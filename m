From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/5] cifs.upcall: consolidate find_krb5_cc calls
Date: Fri,  7 Jan 2011 09:11:41 -0500
Message-ID: <1294409505-2999-2-git-send-email-jlayton@samba.org>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   28 +++++++++++++---------------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 34b0638..33b7e4c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -675,6 +675,7 @@ int main(const int argc, char *const argv[])
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
 	const char *oid;
+	uid_t uid;
 
 	hostbuf[0] = '\0';
 	memset(&arg, 0, sizeof(arg));
@@ -748,27 +749,24 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	if (!legacy_uid && (have & DKD_HAVE_CREDUID)) {
-		rc = setuid(arg.creduid);
-		if (rc == -1) {
-			syslog(LOG_ERR, "setuid: %s", strerror(errno));
-			goto out;
-		}
-		ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, arg.creduid);
-	} else if (have & DKD_HAVE_UID) {
-		rc = setuid(arg.uid);
-		if (rc == -1) {
-			syslog(LOG_ERR, "setuid: %s", strerror(errno));
-			goto out;
-		}
-		ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, arg.uid);
-	} else {
+	if (!legacy_uid && (have & DKD_HAVE_CREDUID))
+		uid = arg.creduid;
+	else if (have & DKD_HAVE_UID)
+		uid = arg.uid;
+	else {
 		/* no uid= or creduid= parm -- something is wrong */
 		syslog(LOG_ERR, "No uid= or creduid= parm specified");
 		rc = 1;
 		goto out;
 	}
 
+	rc = setuid(uid);
+	if (rc == -1) {
+		syslog(LOG_ERR, "setuid: %s", strerror(errno));
+		goto out;
+	}
+	ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, uid);
+
 	host = arg.hostname;
 
 	// do mech specific authorization
-- 
1.7.3.4
