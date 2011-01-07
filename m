From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 5/5] cifs.upcall: add keytab support for unattended mounts
Date: Fri,  7 Jan 2011 09:11:45 -0500
Message-ID: <1294409505-2999-6-git-send-email-jlayton@samba.org>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Based on a patch from a few years ago by Igor Mammedov. This patch
adds the ability for cifs.upcall to establish a TGT using the
system-default keytab.

Cc: Igor Mammedov <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 3dbcd6e..479517c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -54,6 +54,7 @@
 
 #define	CIFS_DEFAULT_KRB5_DIR		"/tmp"
 #define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc_"
+#define CIFS_DEFAULT_KRB5_KEYTAB	"/etc/krb5.keytab"
 
 #define	MAX_CCNAME_LEN			PATH_MAX + 5
 
@@ -185,6 +186,78 @@ static int krb5cc_filter(const struct dirent *dirent)
 		return 0;
 }
 
+static char *
+init_cc_from_keytab(const char *keytab_name, const char *user)
+{
+	krb5_context context = NULL;
+	krb5_error_code ret;
+	krb5_creds my_creds;
+	krb5_keytab keytab = NULL;
+	krb5_principal me = NULL;
+	krb5_ccache cc = NULL;
+	char *ccname = NULL;
+
+	memset((char *) &my_creds, 0, sizeof(my_creds));
+
+	ret = krb5_init_context(&context);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_init_context: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_kt_resolve(context, keytab_name, &keytab);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_kt_resolve: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_parse_name(context, user, &me);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_parse_name: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_get_init_creds_keytab(context, &my_creds, me,
+			keytab, 0, NULL, NULL);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_get_init_creds_keytab: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_cc_default(context, &cc);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_cc_default: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_cc_initialize(context, cc, me);
+	if (ret) {
+		syslog(LOG_DEBUG, "krb5_cc_initialize: %d", (int)ret);
+		goto icfk_cleanup;
+	}
+
+	ret = krb5_cc_store_cred(context, cc, &my_creds);
+	if (ret)
+		syslog(LOG_DEBUG, "krb5_cc_store_cred: %d", (int)ret);
+
+	ccname = strdup(krb5_cc_default_name(context));
+	if (ccname == NULL)
+		syslog(LOG_ERR, "Unable to allocate memory");
+icfk_cleanup:
+	my_creds.client = 0;
+	krb5_free_cred_contents(context, &my_creds);
+
+	if (me)
+		krb5_free_principal(context, me);
+	if (cc)
+		krb5_cc_close(context, cc);
+	if (keytab)
+		krb5_kt_close(context, keytab);
+	if (context)
+		krb5_free_context(context);
+	return ccname;
+}
+
 /* search for a credcache that looks like a likely candidate */
 static char *find_krb5_cc(const char *dirname, uid_t uid)
 {
@@ -702,6 +775,7 @@ int main(const int argc, char *const argv[])
 	struct decoded_args arg;
 	const char *oid;
 	uid_t uid;
+	char *keytab_name = CIFS_DEFAULT_KRB5_KEYTAB;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -793,6 +867,10 @@ int main(const int argc, char *const argv[])
 	}
 	ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid);
 
+	/* Couldn't find credcache? Try to use keytab */
+	if (ccname == NULL && arg.username != NULL)
+		ccname = init_cc_from_keytab(keytab_name, arg.username);
+
 	host = arg.hostname;
 
 	// do mech specific authorization
-- 
1.7.3.4
