From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/3] CIFS: Use NT_CREATE_ANDX command for forcemand mounts
Date: Fri, 30 Nov 2012 14:20:40 +0400
Message-ID: <1354270840-7272-4-git-send-email-piastry@etersoft.ru>
References: <1354270840-7272-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354270840-7272-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

forcemand mount option now lets us use Windows mandatory style of
byte-range locks even if server supports posix ones - switches on
Windows locking mechanism. Share flags is another locking mehanism
provided by Windows semantic that can be used by NT_CREATE_ANDX
command. This patch combines all Windows locking mechanism in one
mount option by using NT_CREATE_ANDX to open files if forcemand is on.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/dir.c  |    1 +
 fs/cifs/file.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 4784d53..8edd950 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -216,6 +216,7 @@ cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 	}
 
 	if (tcon->unix_ext && cap_unix(tcon->ses) && !tcon->broken_posix_open &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 			le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		rc = cifs_posix_open(full_path, &newinode, inode->i_sb, mode,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e2614b9..8cfda53 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -426,8 +426,9 @@ int cifs_open(struct inode *inode, struct file *file)
 	else
 		oplock = 0;
 
-	if (!tcon->broken_posix_open && tcon->unix_ext &&
-	    cap_unix(tcon->ses) && (CIFS_UNIX_POSIX_PATH_OPS_CAP &
+	if (!tcon->broken_posix_open && tcon->unix_ext && cap_unix(tcon->ses)
+	    && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
+	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		/* can not refresh inode info since size could be stale */
 		rc = cifs_posix_open(full_path, &inode, inode->i_sb,
@@ -595,6 +596,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		oplock = 0;
 
 	if (tcon->unix_ext && cap_unix(tcon->ses) &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0) &&
 	    (CIFS_UNIX_POSIX_PATH_OPS_CAP &
 				le64_to_cpu(tcon->fsUnixInfo.Capability))) {
 		/*
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
