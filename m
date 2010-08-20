From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/15] cifs: on multiuser mount, set ownership to current_fsuid/current_fsgid
Date: Fri, 20 Aug 2010 15:32:10 -0400
Message-ID: <1282332731-17444-15-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...when unix extensions aren't enabled. This makes everything on
the mount appear to be owned by the current user.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 026d7dd..d52ca4a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1747,11 +1747,19 @@ check_inval:
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
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER &&
+		    !tcon->unix_ext) {
+			stat->uid = current_fsuid();
+			stat->gid = current_fsgid();
+		}
 	}
 	return err;
 }
-- 
1.7.2.1
