From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: try to use default credcache if we didn't find one
Date: Tue, 17 Sep 2013 11:44:58 -0400
Message-ID: <1379432698-9704-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fedora is in the process of moving to KEYRING: credcaches which are not
currently handled by cifs.upcall. We could try to detect when they're in
use, but it's simpler and more robust to just try to use the default
credcache whenever we don't find a FILE: or DIR: cache.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 20b562f..cc65824 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -382,11 +382,20 @@ cifs_krb5_get_req(const char *host, const char *ccname,
 		return ret;
 	}
 
-	ret = krb5_cc_resolve(context, ccname, &ccache);
-	if (ret) {
-		syslog(LOG_DEBUG, "%s: unable to resolve %s to ccache\n",
-		       __func__, ccname);
-		goto out_free_context;
+	if (ccname) {
+		ret = krb5_cc_resolve(context, ccname, &ccache);
+		if (ret) {
+			syslog(LOG_DEBUG, "%s: unable to resolve %s to ccache\n",
+			       __func__, ccname);
+			goto out_free_context;
+		}
+	} else {
+		ret = krb5_cc_default(context, &ccache);
+		if (ret) {
+			syslog(LOG_DEBUG, "%s: krb5_cc_default: %d",
+				__func__, (int)ret);
+			goto out_free_context;
+		}
 	}
 
 	memset(&in_creds, 0, sizeof(in_creds));
-- 
1.8.3.1
