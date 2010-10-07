From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: on multiuser mount, set ownership to current_fsuid/current_fsgid (try #5)
Date: Thu,  7 Oct 2010 14:46:28 -0400
Message-ID: <1286477188-26681-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...when unix extensions aren't enabled. This makes everything on the
mount appear to be owned by the current user.

This version of the patch differs from previous versions however in that
the admin can still force the ownership of all files to appear as a
single user via the uid=/gid= options.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index dcd0886..7cf3d93 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1761,11 +1761,21 @@ check_inval:
 int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct kstat *stat)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
+	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
 	int err = cifs_revalidate_dentry(dentry);
+
 	if (!err) {
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blksize = CIFS_MAX_MSGSIZE;
 		stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
+		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
+		    !tcon->unix_ext) {
+			if (!cifs_sb->mnt_uid)
+				stat->uid = current_fsuid();
+			if (!cifs_sb->mnt_uid)
+				stat->gid = current_fsgid();
+		}
 	}
 	return err;
 }
-- 
1.7.2.3
