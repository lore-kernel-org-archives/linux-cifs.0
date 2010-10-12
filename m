From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: on multiuser mount, set ownership to current_fsuid/current_fsgid (try #7)
Date: Tue, 12 Oct 2010 11:32:42 -0400
Message-ID: <1286897562-1883-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit 3aa1c8c2900065a51268430ab48a1b42fdfe5b45 made cifs_getattr set
the ownership of files to current_fsuid/current_fsgid when multiuser
mounts were in use and when mnt_uid/mnt_gid were non-zero.

It should have instead based that decision on the
CIFS_MOUNT_OVERR_UID/GID flags.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 73dcbb1..cfe2339 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1761,7 +1761,7 @@ check_inval:
 }
 
 int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-	struct kstat *stat)
+		 struct kstat *stat)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifsTconInfo *tcon = cifs_sb_master_tcon(cifs_sb);
@@ -1771,11 +1771,17 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blksize = CIFS_MAX_MSGSIZE;
 		stat->ino = CIFS_I(dentry->d_inode)->uniqueid;
+
+		/*
+		 * If on a multiuser mount without unix extensions, and the
+		 * admin hasn't overridden them, set the ownership to the
+		 * fsuid/fsgid of the current process.
+		 */
 		if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
 		    !tcon->unix_ext) {
-			if (!cifs_sb->mnt_uid)
+			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
 				stat->uid = current_fsuid();
-			if (!cifs_sb->mnt_uid)
+			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
 				stat->gid = current_fsgid();
 		}
 	}
-- 
1.7.2.3
