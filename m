From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix memory leak in cifs_do_mount
Date: Thu, 26 May 2011 00:02:16 +0400
Message-ID: <1306353736-16393-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and simplify error handling code.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d1ed7f9..1d2a93c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -556,9 +556,8 @@ cifs_do_mount(struct file_system_type *fs_type,
 
 	sb = sget(fs_type, NULL, set_anon_super, NULL);
 	if (IS_ERR(sb)) {
-		kfree(cifs_sb);
 		root = ERR_CAST(sb);
-		goto out;
+		goto out_cifs_sb;
 	}
 
 	/*
@@ -569,7 +568,7 @@ cifs_do_mount(struct file_system_type *fs_type,
 	cifs_sb->mountdata = kstrndup(data, PAGE_SIZE, GFP_KERNEL);
 	if (cifs_sb->mountdata == NULL) {
 		root = ERR_PTR(-ENOMEM);
-		goto err_out;
+		goto out_super;
 	}
 
 	sb->s_flags = flags;
@@ -581,21 +580,23 @@ cifs_do_mount(struct file_system_type *fs_type,
 			     flags & MS_SILENT ? 1 : 0);
 	if (rc) {
 		root = ERR_PTR(rc);
-		goto err_out;
+		goto out_super;
 	}
 
 	sb->s_flags |= MS_ACTIVE;
 
 	root = dget(sb->s_root);
-out:
-	cifs_cleanup_volume_info(&volume_info);
-	return root;
+	goto out;
 
-err_out:
+out_super:
 	kfree(cifs_sb->mountdata);
+	deactivate_locked_super(sb);
+
+out_cifs_sb:
 	unload_nls(cifs_sb->local_nls);
 	kfree(cifs_sb);
-	deactivate_locked_super(sb);
+
+out:
 	cifs_cleanup_volume_info(&volume_info);
 	return root;
 }
-- 
1.7.1
