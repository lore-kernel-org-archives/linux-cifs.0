From: Jeff Layton <jlayton@samba.org>
Subject: [cifs-utils PATCHv2 6/6] cifs.upcall: stop passing around ccache name
 strings
Date: Thu, 25 Aug 2016 10:17:45 -0400
Message-ID: <1472134665-4014-7-git-send-email-jlayton@samba.org>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
Cc: jfdey@fredhutch.org, samba-technical@lists.samba.org
To: linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1472134665-4014-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

Instead, get a ccache handle and pass that around. That way we can keep
the cache open until the program is complete as well.

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 cifs.upcall.c | 98 +++++++++++++++++++++++++----------------------------------
 1 file changed, 41 insertions(+), 57 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index a20576654a95..8f146c92b4a5 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -117,7 +117,7 @@ static time_t get_tgt_time(krb5_ccache ccache)
 
 	if (krb5_cc_get_principal(context, ccache, &principal)) {
 		syslog(LOG_DEBUG, "%s: unable to get principal", __func__);
-		goto err_princ;
+		goto err_cache;
 	}
 
 	if (krb5_cc_start_seq_get(context, ccache, &cur)) {
@@ -154,32 +154,27 @@ err_cache:
 	return credtime;
 }
 
-static char *
+static krb5_ccache
 get_default_cc(void)
 {
-	const char *ccname;
-	char *rcc = NULL;
-	krb5_ccache ccache;
+	krb5_error_code ret;
+	krb5_ccache cc;
 
-	ccname = krb5_cc_default_name(context);
-	if (!ccname) {
-		syslog(LOG_DEBUG, "%s: krb5_cc_default returned NULL.", __func__);
+	ret = krb5_cc_default(context, &cc);
+	if (ret) {
+		syslog(LOG_DEBUG, "%s: krb5_cc_default returned %d", __func__, ret);
 		return NULL;
 	}
 
-	if (krb5_cc_resolve(context, ccname, &ccache)) {
-		syslog(LOG_DEBUG, "%s: unable to resolve krb5 cache", __func__);
-		return NULL;
+	if (!get_tgt_time(cc)) {
+		krb5_cc_close(context, cc);
+		cc = NULL;
 	}
-
-	if (get_tgt_time(ccache))
-		rcc = strdup(ccname);
-	krb5_cc_close(context, ccache);
-	return rcc;
+	return cc;
 }
 
 
-static char *
+static krb5_ccache
 init_cc_from_keytab(const char *keytab_name, const char *user)
 {
 	krb5_error_code ret;
@@ -187,7 +182,6 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 	krb5_keytab keytab = NULL;
 	krb5_principal me = NULL;
 	krb5_ccache cc = NULL;
-	char *ccname = NULL;
 
 	memset((char *) &my_creds, 0, sizeof(my_creds));
 
@@ -229,61 +223,46 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
 	}
 
 	ret = krb5_cc_store_cred(context, cc, &my_creds);
-	if (ret)
+	if (ret) {
 		syslog(LOG_DEBUG, "krb5_cc_store_cred: %d", (int)ret);
-
-	ccname = strdup(krb5_cc_default_name(context));
-	if (ccname == NULL)
-		syslog(LOG_ERR, "Unable to allocate memory");
-icfk_cleanup:
+		goto icfk_cleanup;
+	}
+out:
 	my_creds.client = (krb5_principal)0;
 	krb5_free_cred_contents(context, &my_creds);
 
 	if (me)
 		krb5_free_principal(context, me);
-	if (cc)
-		krb5_cc_close(context, cc);
 	if (keytab)
 		krb5_kt_close(context, keytab);
-	return ccname;
+	return cc;
+icfk_cleanup:
+	if (cc) {
+		krb5_cc_close(context, cc);
+		cc = NULL;
+	}
+	goto out;
 }
 
 static int
-cifs_krb5_get_req(const char *host, const char *ccname,
+cifs_krb5_get_req(const char *host, krb5_ccache ccache,
 		  DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
 {
 	krb5_error_code ret;
 	krb5_keyblock *tokb;
-	krb5_ccache ccache;
 	krb5_creds in_creds, *out_creds;
 	krb5_data apreq_pkt, in_data;
 	krb5_auth_context auth_context = NULL;
 #if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
 	static const uint8_t gss_cksum[24] = { 0x10, 0x00, /* ... */};
 #endif
-	if (ccname) {
-		ret = krb5_cc_resolve(context, ccname, &ccache);
-		if (ret) {
-			syslog(LOG_DEBUG, "%s: unable to resolve %s to ccache\n",
-			       __func__, ccname);
-			return ret;
-		}
-	} else {
-		ret = krb5_cc_default(context, &ccache);
-		if (ret) {
-			syslog(LOG_DEBUG, "%s: krb5_cc_default: %d",
-				__func__, (int)ret);
-			return ret;
-		}
-	}
-
 	memset(&in_creds, 0, sizeof(in_creds));
 
 	ret = krb5_cc_get_principal(context, ccache, &in_creds.client);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get client principal name",
 		       __func__);
-		goto out_free_ccache;
+		return ret;
 	}
 
 	ret = krb5_sname_to_principal(context, host, "cifs", KRB5_NT_UNKNOWN,
@@ -383,8 +362,6 @@ out_free_creds:
 	krb5_free_creds(context, out_creds);
 out_free_principal:
 	krb5_free_principal(context, in_creds.client);
-out_free_ccache:
-	krb5_cc_close(context, ccache);
 	return ret;
 }
 
@@ -410,7 +387,7 @@ out_free_ccache:
  */
 static int
 handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
-		 DATA_BLOB * sess_key, const char *ccname)
+		 DATA_BLOB * sess_key, krb5_ccache ccache)
 {
 	int retval;
 	DATA_BLOB tkt, tkt_wrapped;
@@ -418,7 +395,7 @@ handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
 	syslog(LOG_DEBUG, "%s: getting service ticket for %s", __func__, host);
 
 	/* get a kerberos ticket for the service and extract the session key */
-	retval = cifs_krb5_get_req(host, ccname, &tkt, sess_key);
+	retval = cifs_krb5_get_req(host, ccache, &tkt, sess_key);
 	if (retval) {
 		syslog(LOG_DEBUG, "%s: failed to obtain service ticket (%d)",
 		       __func__, retval);
@@ -709,12 +686,13 @@ int main(const int argc, char *const argv[])
 	unsigned int have;
 	long rc = 1;
 	int c, try_dns = 0, legacy_uid = 0;
-	char *buf, *ccname = NULL;
+	char *buf;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
 	const char *oid;
 	uid_t uid;
 	char *keytab_name = NULL;
+	krb5_ccache ccache = NULL;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -828,10 +806,15 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	ccname = get_default_cc();
+	ccache = get_default_cc();
 	/* Couldn't find credcache? Try to use keytab */
-	if (ccname == NULL && arg.username != NULL)
-		ccname = init_cc_from_keytab(keytab_name, arg.username);
+	if (ccache == NULL && arg.username != NULL)
+		ccache = init_cc_from_keytab(keytab_name, arg.username);
+
+	if (ccache == NULL) {
+		rc = 1;
+		goto out;
+	}
 
 	host = arg.hostname;
 
@@ -859,7 +842,7 @@ int main(const int argc, char *const argv[])
 
 retry_new_hostname:
 		lowercase_string(host);
-		rc = handle_krb5_mech(oid, host, &secblob, &sess_key, ccname);
+		rc = handle_krb5_mech(oid, host, &secblob, &sess_key, ccache);
 		if (!rc)
 			break;
 
@@ -904,7 +887,7 @@ retry_new_hostname:
 				break;
 			}
 
-			rc = handle_krb5_mech(oid, fqdn, &secblob, &sess_key, ccname);
+			rc = handle_krb5_mech(oid, fqdn, &secblob, &sess_key, ccache);
 			if (!rc)
 				break;
 		}
@@ -968,9 +951,10 @@ out:
 	}
 	data_blob_free(&secblob);
 	data_blob_free(&sess_key);
+	if (ccache)
+		krb5_cc_close(context, ccache);
 	if (context)
 		krb5_free_context(context);
-	SAFE_FREE(ccname);
 	SAFE_FREE(arg.hostname);
 	SAFE_FREE(arg.ip);
 	SAFE_FREE(arg.username);
-- 
2.7.4
