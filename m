From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Thu,  9 Jun 2011 16:29:30 +0400
Message-ID: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Recently merged shared-sb capability causes kernel to crash when
we try to do mounts and umounts simultaneously on the same machine.
The patch fixes umount codepath by doing kill_anon_super at first
(it calls generic_shutdown_super that tries to take sb_lock and
removes a superblock from fs_supers list) and then processing
cifs_umount (that frees cifs related fields).

In this case when we call sget and it calls cifs_match_super under
sb_lock for every entry from fs_supers list, we can be sure that
all cifs related fields are not freed by simultaneous umount.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 989442d..3537e7d 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -180,16 +180,30 @@ out_mount_failed:
 static void
 cifs_put_super(struct super_block *sb)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	if (cifs_sb == NULL) {
+		cFYI(1, "Empty cifs superblock info passed to put_super");
+		return;
+	}
+
+	bdi_destroy(&cifs_sb->bdi);
+}
+
+static void
+cifs_kill_super(struct super_block *sb)
+{
 	int rc = 0;
 	struct cifs_sb_info *cifs_sb;
 
 	cFYI(1, "In cifs_put_super");
 	cifs_sb = CIFS_SB(sb);
 	if (cifs_sb == NULL) {
-		cFYI(1, "Empty cifs superblock info passed to unmount");
+		cFYI(1, "Empty cifs superblock info passed to kill_super");
 		return;
 	}
 
+	kill_anon_super(sb);
+
 	rc = cifs_umount(sb, cifs_sb);
 	if (rc)
 		cERROR(1, "cifs_umount failed with return code %d", rc);
@@ -199,7 +213,6 @@ cifs_put_super(struct super_block *sb)
 	}
 
 	unload_nls(cifs_sb->local_nls);
-	bdi_destroy(&cifs_sb->bdi);
 	kfree(cifs_sb);
 }
 
@@ -807,7 +820,7 @@ struct file_system_type cifs_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "cifs",
 	.mount = cifs_do_mount,
-	.kill_sb = kill_anon_super,
+	.kill_sb = cifs_kill_super,
 	/*  .fs_flags */
 };
 const struct inode_operations cifs_dir_inode_ops = {
-- 
1.7.1
