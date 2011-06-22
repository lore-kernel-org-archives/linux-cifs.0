From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: demote DFS referral lookup errors to cFYI
Date: Wed, 22 Jun 2011 17:05:56 -0400
Message-ID: <1308776756-16030-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we call into this routine on every mount, anyone who doesn't
have the upcall configured will get multiple printks about failed lookups.

Reported-and-Tested-by: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_dfs_ref.c |    5 +++--
 fs/cifs/dns_resolve.c  |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 8d8f28c..6873bb6 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -141,10 +141,11 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 
 	rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
 	if (rc < 0) {
-		cERROR(1, "%s: Failed to resolve server part of %s to IP: %d",
-			  __func__, *devname, rc);
+		cFYI(1, "%s: Failed to resolve server part of %s to IP: %d",
+			__func__, *devname, rc);
 		goto compose_mount_options_err;
 	}
+
 	/* md_len = strlen(...) + 12 for 'sep+prefixpath='
 	 * assuming that we have 'unc=' and 'ip=' in
 	 * the original sb_mountdata
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 548f062..1d2d91d 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -79,8 +79,8 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* Perform the upcall */
 	rc = dns_query(NULL, hostname, len, NULL, ip_addr, NULL);
 	if (rc < 0)
-		cERROR(1, "%s: unable to resolve: %*.*s",
-		       __func__, len, len, hostname);
+		cFYI(1, "%s: unable to resolve: %*.*s",
+			__func__, len, len, hostname);
 	else
 		cFYI(1, "%s: resolved: %*.*s to %s",
 		     __func__, len, len, hostname, *ip_addr);
-- 
1.7.5.4
