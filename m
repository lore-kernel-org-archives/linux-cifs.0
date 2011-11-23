From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/4] cifs.upcall: move to an on-stack princ buffer
Date: Wed, 23 Nov 2011 07:44:03 -0500
Message-ID: <1322052246-18707-2-git-send-email-jlayton@samba.org>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
Cc: abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322052246-18707-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and check to see if provided hostname will exceed it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 51af37a..615c827 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -769,8 +769,9 @@ int main(const int argc, char *const argv[])
 	unsigned int have;
 	long rc = 1;
 	int c, try_dns = 0, legacy_uid = 0;
-	char *buf, *princ = NULL, *ccname = NULL;
+	char *buf, *ccname = NULL;
 	char hostbuf[NI_MAXHOST], *host;
+	char princ[NI_MAXHOST + 5]; /* 5 == len of "cifs/" */
 	struct decoded_args arg;
 	const char *oid;
 	uid_t uid;
@@ -848,6 +849,13 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	if (strlen(arg.hostname) >= NI_MAXHOST) {
+		syslog(LOG_ERR, "hostname provided by kernel is too long");
+		rc = 1;
+		goto out;
+
+	}
+
 	if (!legacy_uid && (have & DKD_HAVE_CREDUID))
 		uid = arg.creduid;
 	else if (have & DKD_HAVE_UID)
@@ -877,14 +885,6 @@ int main(const int argc, char *const argv[])
 	case MS_KRB5:
 	case KRB5:
 retry_new_hostname:
-		/* for "cifs/" service name + terminating 0 */
-		datalen = strlen(host) + 5 + 1;
-		princ = calloc(sizeof(char), datalen);
-		if (!princ) {
-			rc = -ENOMEM;
-			break;
-		}
-
 		if (arg.sec == MS_KRB5)
 			oid = OID_KERBEROS5_OLD;
 		else
@@ -894,8 +894,8 @@ retry_new_hostname:
 		 * try getting a cifs/ principal first and then fall back to
 		 * getting a host/ principal if that doesn't work.
 		 */
-		strlcpy(princ, "cifs/", datalen);
-		strlcpy(princ + 5, host, datalen - 5);
+		strlcpy(princ, "cifs/", sizeof(princ));
+		strlcpy(princ + 5, host, sizeof(princ) - 5);
 		rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
 		if (!rc)
 			break;
@@ -912,7 +912,6 @@ retry_new_hostname:
 		if (rc)
 			break;
 
-		SAFE_FREE(princ);
 		try_dns = 0;
 		host = hostbuf;
 		goto retry_new_hostname;
@@ -922,8 +921,6 @@ retry_new_hostname:
 		break;
 	}
 
-	SAFE_FREE(princ);
-
 	if (rc)
 		goto out;
 
-- 
1.7.6.4
