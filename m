From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: use krb5_sname_to_principal to construct principal name
Date: Wed, 28 Mar 2012 07:42:47 -0400
Message-ID: <1332934967-1768-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we build the string by hand then then construct the
principal name with krb5_parse_name. That bypasses the domain_realm
section in krb5.conf however.

Switch the code to use krb5_sname_to_principal instead which is more
suited to this task. In order for that to work, we change a couple of
calling functions to pass down a hostname instead of a principal
name, and then pass in "cifs" as the service name.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   47 ++++++++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 27 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 0d222cb..9e7f7e2 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -324,7 +324,7 @@ static char *find_krb5_cc(const char *dirname, uid_t uid)
 }
 
 static int
-cifs_krb5_get_req(const char *principal, const char *ccname,
+cifs_krb5_get_req(const char *host, const char *ccname,
 		  DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
 {
 	krb5_error_code ret;
@@ -360,10 +360,11 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 		goto out_free_ccache;
 	}
 
-	ret = krb5_parse_name(context, principal, &in_creds.server);
+	ret = krb5_sname_to_principal(context, host, "cifs", KRB5_NT_UNKNOWN,
+					&in_creds.server);
 	if (ret) {
-		syslog(LOG_DEBUG, "%s: unable to parse principal (%s).",
-		       __func__, principal);
+		syslog(LOG_DEBUG, "%s: unable to convert sname to princ (%s).",
+		       __func__, host);
 		goto out_free_principal;
 	}
 
@@ -371,7 +372,7 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 	krb5_free_principal(context, in_creds.server);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get credentials for %s",
-		       __func__, principal);
+		       __func__, host);
 		goto out_free_principal;
 	}
 
@@ -428,14 +429,14 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 				   &in_data, out_creds, &apreq_pkt);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to make AP-REQ for %s",
-		       __func__, principal);
+		       __func__, host);
 		goto out_free_auth;
 	}
 
 	ret = krb5_auth_con_getsendsubkey(context, auth_context, &tokb);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get session key for %s",
-		       __func__, principal);
+		       __func__, host);
 		goto out_free_auth;
 	}
 
@@ -480,17 +481,16 @@ out_free_context:
  * ret: 0 - success, others - failure
  */
 static int
-handle_krb5_mech(const char *oid, const char *principal, DATA_BLOB * secblob,
+handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
 		 DATA_BLOB * sess_key, const char *ccname)
 {
 	int retval;
 	DATA_BLOB tkt, tkt_wrapped;
 
-	syslog(LOG_DEBUG, "%s: getting service ticket for %s", __func__,
-	       principal);
+	syslog(LOG_DEBUG, "%s: getting service ticket for %s", __func__, host);
 
 	/* get a kerberos ticket for the service and extract the session key */
-	retval = cifs_krb5_get_req(principal, ccname, &tkt, sess_key);
+	retval = cifs_krb5_get_req(host, ccname, &tkt, sess_key);
 	if (retval) {
 		syslog(LOG_DEBUG, "%s: failed to obtain service ticket (%d)",
 		       __func__, retval);
@@ -782,7 +782,6 @@ int main(const int argc, char *const argv[])
 	int c, try_dns = 0, legacy_uid = 0;
 	char *buf, *ccname = NULL;
 	char hostbuf[NI_MAXHOST], *host;
-	char princ[NI_MAXHOST + 5]; /* 5 == len of "cifs/" */
 	struct decoded_args arg;
 	const char *oid;
 	uid_t uid;
@@ -921,29 +920,23 @@ int main(const int argc, char *const argv[])
 
 retry_new_hostname:
 		lowercase_string(host);
-		/* try "cifs/hostname" first */
-		rc = snprintf(princ, sizeof(princ), "cifs/%s", host);
-		if (rc < 0 || (size_t)rc >= sizeof(princ)) {
-			syslog(LOG_ERR,"Unable to set hostname %s in buffer.", host);
-			goto out;
-		}
-
-		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+		rc = handle_krb5_mech(oid, host, &secblob, &sess_key, ccname);
 		if (!rc)
 			break;
 
 		/*
-		 * If hostname has a '.', assume it's a FQDN, otherwise we want to
-		 * guess the domainname.
+		 * If hostname has a '.', assume it's a FQDN, otherwise we
+		 * want to guess the domainname.
 		 */
 		if (!strchr(host, '.')) {
 			struct addrinfo hints;
 			struct addrinfo *ai;
 			char *domainname;
+			char fqdn[NI_MAXHOST];
 
 			/*
-			 * use getaddrinfo() to resolve the hostname of the server
-			 * and set ai_canonname.
+			 * use getaddrinfo() to resolve the hostname of the
+			 * server and set ai_canonname.
 			 */
 			memset(&hints, 0, sizeof(hints));
 			hints.ai_family = AF_UNSPEC;
@@ -963,16 +956,16 @@ retry_new_hostname:
 				break;
 			}
 			lowercase_string(domainname);
-			rc = snprintf(princ, sizeof(princ), "cifs/%s%s",
+			rc = snprintf(fqdn, sizeof(fqdn), "%s%s",
 					host, domainname);
 			freeaddrinfo(ai);
-			if (rc < 0 || (size_t)rc >= sizeof(princ)) {
+			if (rc < 0 || (size_t)rc >= sizeof(fqdn)) {
 				syslog(LOG_ERR, "Problem setting hostname in string: %ld", rc);
 				rc = -EINVAL;
 				break;
 			}
 
-			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			rc = handle_krb5_mech(oid, fqdn, &secblob, &sess_key, ccname);
 			if (!rc)
 				break;
 		}
-- 
1.7.7.6
