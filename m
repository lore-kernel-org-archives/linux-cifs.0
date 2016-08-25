From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCHv2 3/6] cifs.upcall: make the krb5_context a static global variable
Date: Thu, 25 Aug 2016 10:17:42 -0400
Message-ID: <1472134665-4014-4-git-send-email-jlayton@samba.org>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472134665-4014-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There's no need to keep initing a new context for every function. Just
do it once and reuse as needed.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 61 ++++++++++++++++-------------------------------------------
 1 file changed, 16 insertions(+), 45 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index d0f6d089d8e1..8448d00f6061 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -52,7 +52,9 @@
 #include "spnego.h"
 #include "cifs_spnego.h"
 
-static const char *prog = "cifs.upcall";
+static krb5_context	context;
+static const char	*prog = "cifs.upcall";
+
 typedef enum _sectype {
 	NONE = 0,
 	KRB5,
@@ -69,9 +71,7 @@ typedef enum _sectype {
  * @return pointer to the realm
  *
  */
-
-static char *cifs_krb5_principal_get_realm(krb5_context context __attribute__ ((unused)),
-					   krb5_principal principal)
+static char *cifs_krb5_principal_get_realm(krb5_principal principal)
 {
 #ifdef HAVE_KRB5_PRINCIPAL_GET_REALM	/* Heimdal */
 	return krb5_principal_get_realm(context, principal);
@@ -104,7 +104,6 @@ krb5_auth_con_getsendsubkey(krb5_context context,
 /* does the ccache have a valid TGT? */
 static time_t get_tgt_time(const char *ccname)
 {
-	krb5_context context;
 	krb5_ccache ccache;
 	krb5_cc_cursor cur;
 	krb5_creds creds;
@@ -112,11 +111,6 @@ static time_t get_tgt_time(const char *ccname)
 	time_t credtime = 0;
 	char *realm = NULL;
 
-	if (krb5_init_context(&context)) {
-		syslog(LOG_DEBUG, "%s: unable to init krb5 context", __func__);
-		return 0;
-	}
-
 	if (krb5_cc_resolve(context, ccname, &ccache)) {
 		syslog(LOG_DEBUG, "%s: unable to resolve krb5 cache", __func__);
 		goto err_cache;
@@ -137,7 +131,7 @@ static time_t get_tgt_time(const char *ccname)
 		goto err_ccstart;
 	}
 
-	if ((realm = cifs_krb5_principal_get_realm(context, principal)) == NULL) {
+	if ((realm = cifs_krb5_principal_get_realm(principal)) == NULL) {
 		syslog(LOG_DEBUG, "%s: unable to get realm", __func__);
 		goto err_ccstart;
 	}
@@ -168,34 +162,23 @@ err_princ:
 #endif
 	krb5_cc_close(context, ccache);
 err_cache:
-	krb5_free_context(context);
 	return credtime;
 }
 
 static char *
 get_default_cc(void)
 {
-	krb5_error_code ret;
 	const char *ccname;
 	char *rcc = NULL;
-	krb5_context context = NULL;
-
-	ret = krb5_init_context(&context);
-	if (ret) {
-		syslog(LOG_DEBUG, "krb5_init_context: %d", (int)ret);
-		return NULL;
-	}
 
 	ccname = krb5_cc_default_name(context);
 	if (!ccname) {
 		syslog(LOG_DEBUG, "krb5_cc_default returned NULL.");
-		goto out_free_context;
+		return NULL;
 	}
 
 	if (get_tgt_time(ccname))
 		rcc = strdup(ccname);
-out_free_context:
-	krb5_free_context(context);
 	return rcc;
 }
 
@@ -203,7 +186,6 @@ out_free_context:
 static char *
 init_cc_from_keytab(const char *keytab_name, const char *user)
 {
-	krb5_context context = NULL;
 	krb5_error_code ret;
 	krb5_creds my_creds;
 	krb5_keytab keytab = NULL;
@@ -213,12 +195,6 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 
 	memset((char *) &my_creds, 0, sizeof(my_creds));
 
-	ret = krb5_init_context(&context);
-	if (ret) {
-		syslog(LOG_DEBUG, "krb5_init_context: %d", (int)ret);
-		goto icfk_cleanup;
-	}
-
 	if (keytab_name)
 		ret = krb5_kt_resolve(context, keytab_name, &keytab);
 	else
@@ -273,8 +249,6 @@ icfk_cleanup:
 		krb5_cc_close(context, cc);
 	if (keytab)
 		krb5_kt_close(context, keytab);
-	if (context)
-		krb5_free_context(context);
 	return ccname;
 }
 
@@ -284,7 +258,6 @@ cifs_krb5_get_req(const char *host, const char *ccname,
 {
 	krb5_error_code ret;
 	krb5_keyblock *tokb;
-	krb5_context context;
 	krb5_ccache ccache;
 	krb5_creds in_creds, *out_creds;
 	krb5_data apreq_pkt, in_data;
@@ -292,26 +265,19 @@ cifs_krb5_get_req(const char *host, const char *ccname,
 #if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
 	static const uint8_t gss_cksum[24] = { 0x10, 0x00, /* ... */};
 #endif
-
-	ret = krb5_init_context(&context);
-	if (ret) {
-		syslog(LOG_DEBUG, "%s: unable to init krb5 context", __func__);
-		return ret;
-	}
-
 	if (ccname) {
 		ret = krb5_cc_resolve(context, ccname, &ccache);
 		if (ret) {
 			syslog(LOG_DEBUG, "%s: unable to resolve %s to ccache\n",
 			       __func__, ccname);
-			goto out_free_context;
+			return ret;
 		}
 	} else {
 		ret = krb5_cc_default(context, &ccache);
 		if (ret) {
 			syslog(LOG_DEBUG, "%s: krb5_cc_default: %d",
 				__func__, (int)ret);
-			goto out_free_context;
+			return ret;
 		}
 	}
 
@@ -383,7 +349,6 @@ cifs_krb5_get_req(const char *host, const char *ccname,
 	/* MIT krb5 < 1.7 is missing the prototype, but still has the symbol */
 #if !HAVE_DECL_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE
 	krb5_error_code krb5_auth_con_set_req_cksumtype(
-		krb5_context      context,
 		krb5_auth_context auth_context,
 		krb5_cksumtype    cksumtype);
 #endif
@@ -427,8 +392,6 @@ out_free_ccache:
 	krb5_cc_set_flags(context, ccache, KRB5_TC_OPENCLOSE);
 #endif
 	krb5_cc_close(context, ccache);
-out_free_context:
-	krb5_free_context(context);
 	return ret;
 }
 
@@ -866,6 +829,12 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	rc = krb5_init_context(&context);
+	if (rc) {
+		syslog(LOG_ERR, "unable to init krb5 context: %ld", rc);
+		goto out;
+	}
+
 	ccname = get_default_cc();
 	/* Couldn't find credcache? Try to use keytab */
 	if (ccname == NULL && arg.username != NULL)
@@ -1006,6 +975,8 @@ out:
 	}
 	data_blob_free(&secblob);
 	data_blob_free(&sess_key);
+	if (context)
+		krb5_free_context(context);
 	SAFE_FREE(ccname);
 	SAFE_FREE(arg.hostname);
 	SAFE_FREE(arg.ip);
-- 
2.7.4
