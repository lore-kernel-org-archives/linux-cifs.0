From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: move bdi_setup_and_register outside of CONFIG_CIFS_DFS_UPCALL
Date: Sat,  9 Jul 2011 12:21:07 -0400
Message-ID: <1310228467-27466-1-git-send-email-jlayton@redhat.com>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This needs to be done regardless of whether that KConfig option is set
or not.

Reported-by: Sven-Haegar Koch <haegar-DcL44mDNY06zQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fea9ecf..dd695c5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3011,6 +3011,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	struct tcon_link *tlink;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	int referral_walks_count = 0;
+#endif
 
 	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
 	if (rc)
@@ -3018,6 +3019,7 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
+#ifdef CONFIG_CIFS_DFS_UPCALL
 try_mount_again:
 	/* cleanup activities if we're chasing a referral */
 	if (referral_walks_count) {
-- 
1.7.6
