From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH 7/7] cifs: support RENAME_NOREPLACE
Date: Mon, 28 Jul 2014 17:04:59 -0400
Message-ID: <CAH2r5mv8au28v21kQS6G61fH=3GnTdF_q=cFVLCfgLR2TFM_Xw@mail.gmail.com>
References: <1406121336-1379-1-git-send-email-miklos@szeredi.hu> <1406121336-1379-8-git-send-email-miklos@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406121336-1379-8-git-send-email-miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Adding linux cifs to cc


---------- Forwarded message ----------
From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Date: Wed, Jul 23, 2014 at 9:15 AM
Subject: [PATCH 7/7] cifs: support RENAME_NOREPLACE
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


From: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>

This flag gives CIFS the ability to support its native rename semantics.

Implementation is simple: just bail out before trying to hack around the
noreplace semantics.

Signed-off-by: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c |  2 +-
 fs/cifs/cifsfs.h |  4 ++--
 fs/cifs/inode.c  | 14 ++++++++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 888398067420..ac4f260155c8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -848,7 +848,7 @@ const struct inode_operations cifs_dir_inode_ops = {
        .link = cifs_hardlink,
        .mkdir = cifs_mkdir,
        .rmdir = cifs_rmdir,
-       .rename = cifs_rename,
+       .rename2 = cifs_rename2,
        .permission = cifs_permission,
 /*     revalidate:cifs_revalidate,   */
        .setattr = cifs_setattr,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 70f178a7c759..ed58c88f5f5d 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -68,8 +68,8 @@ extern int cifs_hardlink(struct dentry *, struct
inode *, struct dentry *);
 extern int cifs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 extern int cifs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int cifs_rmdir(struct inode *, struct dentry *);
-extern int cifs_rename(struct inode *, struct dentry *, struct inode *,
-                      struct dentry *);
+extern int cifs_rename2(struct inode *, struct dentry *, struct inode *,
+                       struct dentry *, unsigned int);
 extern int cifs_revalidate_file_attr(struct file *filp);
 extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a174605f6afa..bec0a0831be6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1627,8 +1627,9 @@ do_rename_exit:
 }

 int
-cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
-           struct inode *target_dir, struct dentry *target_dentry)
+cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
+            struct inode *target_dir, struct dentry *target_dentry,
+            unsigned int flags)
 {
        char *from_name = NULL;
        char *to_name = NULL;
@@ -1640,6 +1641,9 @@ cifs_rename(struct inode *source_dir, struct
dentry *source_dentry,
        unsigned int xid;
        int rc, tmprc;

+       if (flags & ~RENAME_NOREPLACE)
+               return -EINVAL;
+
        cifs_sb = CIFS_SB(source_dir->i_sb);
        tlink = cifs_sb_tlink(cifs_sb);
        if (IS_ERR(tlink))
@@ -1667,6 +1671,12 @@ cifs_rename(struct inode *source_dir, struct
dentry *source_dentry,
        rc = cifs_do_rename(xid, source_dentry, from_name, target_dentry,
                            to_name);

+       /*
+        * No-replace is the natural behavior for CIFS, so skip unlink hacks.
+        */
+       if (flags & RENAME_NOREPLACE)
+               goto cifs_rename_exit;
+
        if (rc == -EEXIST && tcon->unix_ext) {
                /*
                 * Are src and dst hardlinks of same inode? We can only tell
--
1.8.1.4



-- 
Thanks,

Steve
