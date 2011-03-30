From: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: [PATCH] Use kstrdup instead of manual string duplication for cifs_sb->mountdata
Date: Wed, 30 Mar 2011 15:07:11 +0200
Message-ID: <54430755071bdb37fe46abf3fda855bf35aaf891.1301492728.git.seanius@seanius.net>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A relatively minor nit, but also clarified the "consensus" from the
preceding comments that it is in fact better to try for the kstrdup
early and cleanup while cleaning up is still a simple thing to do.

Signed-off-by: Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index fb6a2ad..e938bf0 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -134,24 +134,19 @@ cifs_read_super(struct super_block *sb, void *data,
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
+		cifs_sb->mountdata = kstrdup(data, GFP_KERNEL);
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
1.7.2.3
