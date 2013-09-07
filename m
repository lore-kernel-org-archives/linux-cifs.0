From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] readdir cf_nlink initialization
Date: Sat, 7 Sep 2013 14:49:24 -0400
Message-ID: <CAFneQcePFASf4u_Q-xyCy0_cYrpOb7p3+yQV1N1FKxtNYMi2vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Here's my second try.  I hope there aren't missed ops which update the
inode without having nlink updated.  At worst, they should stop
clobbering valid values, which was definitely happening before.

Signed-off-by: Jim McDonough <jmcdonough-l3A5Bk7waGM@public.gmane.org>

---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/inode.c    |   21 ++++++++++++++++++++-
 fs/cifs/readdir.c  |    3 +++
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -712,6 +712,7 @@ struct dfs_info3_param {
 #define CIFS_FATTR_DELETE_PENDING    0x2
 #define CIFS_FATTR_NEED_REVAL        0x4
 #define CIFS_FATTR_INO_COLLISION    0x8
+#define CIFS_FATTR_MISSING_NLINK    0x10

 struct cifs_fattr {
     u32        cf_flags;
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -118,6 +118,25 @@ cifs_revalidate_cache(struct inode *inod
     cifs_i->invalid_mapping = true;
 }

+/* copy nlink to the inode, unless it wasn't provided.  Provide
+   sane values if we don't have an existing one and none was provided */
+static void
+cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
+{
+    if (fattr->cf_nlink) {
+        inode->i_nlink = fattr->cf_nlink;
+        return;
+    }
+
+    if ((fattr->cf_flags & CIFS_FATTR_MISSING_NLINK) &&
+        (inode->i_state & I_NEW)) {
+        if (fattr->cf_cifsattrs & ATTR_DIRECTORY)
+            inode->i_nlink = 2;
+        else
+            inode->i_nlink = 1;
+    }
+}
+
 /* populate an inode with info from a cifs_fattr struct */
 void
 cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
@@ -132,7 +151,7 @@ cifs_fattr_to_inode(struct inode *inode,
     inode->i_mtime = fattr->cf_mtime;
     inode->i_ctime = fattr->cf_ctime;
     inode->i_rdev = fattr->cf_rdev;
-    inode->i_nlink = fattr->cf_nlink;
+    cifs_nlink_fattr_to_inode(inode, fattr);
     inode->i_uid = fattr->cf_uid;
     inode->i_gid = fattr->cf_gid;

--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -130,6 +130,9 @@ cifs_fill_common_info(struct cifs_fattr
         fattr->cf_dtype = DT_REG;
     }

+    /* non-unix readdir doesn't provide nlink */
+    fattr->cf_flags &= CIFS_FATTR_MISSING_NLINK;
+
     if (fattr->cf_cifsattrs & ATTR_READONLY)
         fattr->cf_mode &= ~S_IWUGO;




-- 
Jim McDonough
Samba Team
SUSE labs
jmcd at samba dot org
jmcd at themcdonoughs dot org
