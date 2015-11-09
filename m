From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] Allow copy offload (CopyChunk) across shares
Date: Mon,  9 Nov 2015 09:30:19 -0600
Message-ID: <1447083019-11620-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FSCTL_SRV_COPYCHUNK_WRITE only requires that the source and target
be on the same server (not the same volume or same share),
so relax the existing check (which required them to be on
the same share). Note that this works to Windows (and presumably
most other NAS) but Samba requires that the source
and target be on the same share.  Moving a file across
shares is a common use case and can be very heplful (100x faster).

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Reviewed-by: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsfs.c | 12 ------------
 fs/cifs/ioctl.c  | 11 ++++++++---
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f578ef9..cbc0f4b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -925,9 +925,7 @@ const struct file_operations cifs_file_ops = {
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -943,9 +941,7 @@ const struct file_operations cifs_file_strict_ops = {
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -961,9 +957,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
@@ -979,9 +973,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -996,9 +988,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl	= cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
 };
@@ -1013,9 +1003,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
-#ifdef CONFIG_CIFS_POSIX
 	.unlocked_ioctl  = cifs_ioctl,
-#endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 	.setlease = cifs_setlease,
 	.fallocate = cifs_fallocate,
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 28a77bf..35cf990 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -85,9 +85,14 @@ static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
 	src_tcon = tlink_tcon(smb_file_src->tlink);
 	target_tcon = tlink_tcon(smb_file_target->tlink);
 
-	/* check if source and target are on same tree connection */
-	if (src_tcon != target_tcon) {
-		cifs_dbg(VFS, "file copy src and target on different volume\n");
+	/* check source and target on same server (or volume if dup_extents) */
+	if (dup_extents && (src_tcon != target_tcon)) {
+		cifs_dbg(VFS, "source and target of copy not on same share\n");
+		goto out_fput;
+	}
+
+	if (!dup_extents && (src_tcon->ses != target_tcon->ses)) {
+		cifs_dbg(VFS, "source and target of copy not on same server\n");
 		goto out_fput;
 	}
 
-- 
1.9.1
