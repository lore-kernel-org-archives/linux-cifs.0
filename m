From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] cifs: tune bdi.ra_pages in accordance with the rsize
Date: Tue, 30 Aug 2011 10:46:14 -0400
Message-ID: <1314715574-23431-6-git-send-email-jlayton@redhat.com>
References: <1314715574-23431-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314715574-23431-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tune bdi.ra_pages to be a multiple of the rsize. This prevents the VFS
from asking for pages that require small reads to satisfy.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6ec06af..36fe8a7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3155,6 +3155,21 @@ cifs_get_volume_info(char *mount_data, const char *devname)
 	return volume_info;
 }
 
+/* make sure ra_pages is a multiple of rsize */
+static inline unsigned int
+cifs_ra_pages(struct cifs_sb_info *cifs_sb)
+{
+	unsigned int reads;
+	unsigned int rsize_pages = cifs_sb->rsize / PAGE_CACHE_SIZE;
+
+	if (rsize_pages >= default_backing_dev_info.ra_pages)
+		return default_backing_dev_info.ra_pages;
+
+	reads = default_backing_dev_info.ra_pages / rsize_pages;
+
+	return reads * rsize_pages;
+}
+
 int
 cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 {
@@ -3173,8 +3188,6 @@ cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *volume_info)
 	if (rc)
 		return rc;
 
-	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
-
 #ifdef CONFIG_CIFS_DFS_UPCALL
 try_mount_again:
 	/* cleanup activities if we're chasing a referral */
@@ -3242,6 +3255,9 @@ try_mount_again:
 	cifs_sb->wsize = cifs_negotiate_wsize(tcon, volume_info);
 	cifs_sb->rsize = cifs_negotiate_rsize(tcon, volume_info);
 
+	/* tune readahead according to rsize */
+	cifs_sb->bdi.ra_pages = cifs_ra_pages(cifs_sb);
+
 remote_path_check:
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	/*
-- 
1.7.6
