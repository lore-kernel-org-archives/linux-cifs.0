From: Jim McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3] readdir cf_nlink initialization
Date: Wed, 18 Sep 2013 16:00:17 -0700
Message-ID: <CAFneQccAzKRE1O31528S4T4rsHZ7Wn+acV6Cmr1+QAwd+JmNPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One more try .  Trying to not trust non-unix servers when they are
reporting zero without delete pending, or in the directory case, on
querypathinfo, and never on readdir.  But only faking it on inode
instantiation.

Also, this is finally for a recent kernel...


--
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/inode.c    | 41 +++++++++++++++++++++++++++++++++++------
 fs/cifs/readdir.c  |  3 +++
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 52ca861..750dbfa 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1253,6 +1253,7 @@ struct dfs_info3_param {
 #define CIFS_FATTR_DELETE_PENDING    0x2
 #define CIFS_FATTR_NEED_REVAL        0x4
 #define CIFS_FATTR_INO_COLLISION    0x8
+#define CIFS_FATTR_UNKNOWN_NLINK    0x10

 struct cifs_fattr {
     u32        cf_flags;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 449b6cf..1d7bbb9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -120,6 +120,30 @@ cifs_revalidate_cache(struct inode *inode, struct
cifs_fattr *fattr)
     cifs_i->invalid_mapping = true;
 }

+/* copy nlink to the inode, unless it wasn't provided.  Provide
+   sane values if we don't have an existing one and none was provided */
+static void
+cifs_nlink_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
+{
+    /* if we're in a situation where we can't trust what we
+       got from the server (readdir, some non-unix cases)
+       fake reasonable values
+    */
+    if (fattr->cf_flags & CIFS_FATTR_UNKNOWN_NLINK) {
+        /* only provide fake values on a new inode */
+        if (inode->i_state & I_NEW) {
+            if (fattr->cf_cifsattrs & ATTR_DIRECTORY)
+                set_nlink(inode, 2);
+            else
+                set_nlink(inode, 1);
+        }
+        return;
+    }
+
+    /* we trust the server, so update it */
+    set_nlink(inode, fattr->cf_nlink);
+}
+
 /* populate an inode with info from a cifs_fattr struct */
 void
 cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
@@ -134,7 +158,7 @@ cifs_fattr_to_inode(struct inode *inode, struct
cifs_fattr *fattr)
     inode->i_mtime = fattr->cf_mtime;
     inode->i_ctime = fattr->cf_ctime;
     inode->i_rdev = fattr->cf_rdev;
-    set_nlink(inode, fattr->cf_nlink);
+    cifs_nlink_fattr_to_inode(inode, fattr);
     inode->i_uid = fattr->cf_uid;
     inode->i_gid = fattr->cf_gid;

@@ -541,6 +565,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
     fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
     fattr->cf_createtime = le64_to_cpu(info->CreationTime);

+    fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
     if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
         fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
         fattr->cf_dtype = DT_DIR;
@@ -548,7 +573,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
          * Server can return wrong NumberOfLinks value for directories
          * when Unix extensions are disabled - fake it.
          */
-        fattr->cf_nlink = 2;
+        if (!tcon->unix_ext)
+            fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
     } else {
         fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
         fattr->cf_dtype = DT_REG;
@@ -557,11 +583,14 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr,
FILE_ALL_INFO *info,
         if (fattr->cf_cifsattrs & ATTR_READONLY)
             fattr->cf_mode &= ~(S_IWUGO);

-        fattr->cf_nlink = le32_to_cpu(info->NumberOfLinks);
-        if (fattr->cf_nlink < 1) {
-            cifs_dbg(1, "replacing bogus file nlink value %u\n",
+        /* Don't accept zero nlink from non-unix servers unless
+           delete is pending.  Instead mark it as unknown.
+        */
+        if ((fattr->cf_nlink < 1) && (!tcon->unix_ext) &&
+            (!info->DeletePending)) {
+            cifs_dbg(1, "bogus file nlink value %u\n",
                 fattr->cf_nlink);
-            fattr->cf_nlink = 1;
+            fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
         }
     }

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 69d2c82..b1f67dc 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -177,6 +177,9 @@ cifs_fill_common_info(struct cifs_fattr *fattr,
struct cifs_sb_info *cifs_sb)
         fattr->cf_dtype = DT_REG;
     }

+    /* non-unix readdir doesn't provide nlink */
+    fattr->cf_flags |= CIFS_FATTR_UNKNOWN_NLINK;
+
     if (fattr->cf_cifsattrs & ATTR_READONLY)
         fattr->cf_mode &= ~S_IWUGO;

-- 
1.8.1.4




-- 
Jim McDonough
Samba Team
SUSE labs
jmcd at samba dot org
jmcd at themcdonoughs dot org
