From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/7] cifs: don't override the uid/gid in getattr when cifsacl is enabled
Date: Wed, 17 Oct 2012 14:09:03 -0400
Message-ID: <1350497343-7155-8-git-send-email-jlayton@redhat.com>
References: <1350497343-7155-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350497343-7155-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we're using cifsacl, then we don't want to override the uid/gid with
the current uid/gid, since that would prevent you from being able to
upcall for this info.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index afdff79..ed6208f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1791,11 +1791,12 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	stat->ino = CIFS_I(inode)->uniqueid;
 
 	/*
-	 * If on a multiuser mount without unix extensions, and the admin hasn't
-	 * overridden them, set the ownership to the fsuid/fsgid of the current
-	 * process.
+	 * If on a multiuser mount without unix extensions or cifsacl being
+	 * enabled, and the admin hasn't overridden them, set the ownership
+	 * to the fsuid/fsgid of the current process.
 	 */
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
+	    !(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) &&
 	    !tcon->unix_ext) {
 		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID))
 			stat->uid = current_fsuid();
-- 
1.7.11.7
