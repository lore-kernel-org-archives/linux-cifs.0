From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH v4 5/6] cifs: Use kstrndup for cifs_sb->mountdata
Date: Wed, 6 Apr 2011 16:26:44 +0200
Message-ID: <1302100005-1848-5-git-send-email-seanius@seanius.net>
References: <1302100005-1848-1-git-send-email-seanius@seanius.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302100005-1848-1-git-send-email-seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A relatively minor nit, but also clarified the "consensus" from the
preceding comments that it is in fact better to try for the kstrdup
early and cleanup while cleaning up is still a simple thing to do.

Reviewed-By: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb6a2ad..cf8a610 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -134,24 +134,20 @@ cifs_read_super(struct super_block *sb, void *data,
 	cifs_sb->bdi.ra_pages = default_backing_dev_info.ra_pages;
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	/* copy mount params to sb for use in submounts */
-	/* BB: should we move this after the mount so we
-	 * do not have to do the copy on failed mounts?
-	 * BB: May be it is better to do simple copy before
-	 * complex operation (mount), and in case of fail
-	 * just exit instead of doing mount and attempting
-	 * undo it if this copy fails?*/
+	/*
+	 * Copy mount params to sb for use in submounts. Better to do
+	 * the copy here and deal with the error before cleanup gets
+	 * complicated post-mount.
+	 */
 	if (data) {
-		int len = strlen(data);
-		cifs_sb->mountdata = kzalloc(len + 1, GFP_KERNEL);
+		cifs_sb->mountdata = kstrndup(data, PAGE_CACHE_SIZE,
+					      GFP_KERNEL);
 		if (cifs_sb->mountdata == NULL) {
 			bdi_destroy(&cifs_sb->bdi);
 			kfree(sb->s_fs_info);
 			sb->s_fs_info = NULL;
 			return -ENOMEM;
 		}
-		strncpy(cifs_sb->mountdata, data, len + 1);
-		cifs_sb->mountdata[len] = '\0';
 	}
 #endif
 
-- 
1.7.4.1
