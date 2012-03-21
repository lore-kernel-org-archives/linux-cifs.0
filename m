From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix issue mounting of DFS ROOT when redirecting from one domain controller to the next
Date: Wed, 21 Mar 2012 06:30:40 -0400
Message-ID: <1332325840-14906-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch fixes an issue when cifs_mount receives a
STATUS_BAD_NETWORK_NAME error during cifs_get_tcon but is able to
continue after an DFS ROOT referral. In this case, the return code
variable is not reset prior to trying to mount from the system referred
to. Thus, is_path_accessible is not executed and the final DFS referral
is not performed causing a mount error.

Use case: In DNS, example.com  resolves to the secondary AD server
ad2.example.com Our primary domain controller is ad1.example.com and has
a DFS redirection set up from \\ad1\share\Users to \\files\share\Users.
Mounting \\example.com\share\Users fails.

Regression introduced by commit 724d9f1.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Thomas Hadig <thomas-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fff5e5d..6b3d919 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3371,7 +3371,7 @@ cifs_ra_pages(struct cifs_sb_info *cifs_sb)
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
-	int rc = 0;
+	int rc;
 	int xid;
 	struct cifs_ses *pSesInfo;
 	struct cifs_tcon *tcon;
@@ -3398,6 +3398,7 @@ try_mount_again:
 		FreeXid(xid);
 	}
 #endif
+	rc = 0;
 	tcon = NULL;
 	pSesInfo = NULL;
 	srvTcp = NULL;
-- 
1.7.7.6
