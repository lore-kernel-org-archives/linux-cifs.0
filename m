From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Add protocol specific operation for CIFS xattrs
Date: Sun, 2 Feb 2014 00:25:49 -0600
Message-ID: <CAH2r5mvMMW2AvPyEo-a1FMRWLRmwsEggZ45WRCTH+U7NaTRGCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>From f87189f8ff97d1f95040b3f07ee1607c608567ad Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 1 Feb 2014 23:27:18 -0600
Subject: [PATCH] [CIFS] Add protocol specific operation for CIFS xattrs

Changeset 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 added protocol
operations for get/setxattr to avoid calling cifs operations
on smb2/smb3 mounts for xattr operations and this changeset
adds the calls to cifs specific protocol operations for xattrs
(in order to reenable cifs support for xattrs which was
temporarily disabled by the previous changeset.  We do not
have SMB2/SMB3 worker function for setting xattrs yet so
this only enables it for cifs.

CCing stable since without these two small changsets (its
small coreq 666753c3ef8fc88b0ddd5be4865d0aa66428ac35 is
also needed) calling getfattr/setfattr on smb2/smb3 mounts
causes problems.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/cifs/inode.c   | 13 +++++++++----
 fs/cifs/smb1ops.c |  4 ++++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9cb9679..be58b8f 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -527,10 +527,15 @@ static int cifs_sfu_mode(struct cifs_fattr
*fattr, const unsigned char *path,
         return PTR_ERR(tlink);
     tcon = tlink_tcon(tlink);

-    rc = CIFSSMBQAllEAs(xid, tcon, path, "SETFILEBITS",
-                ea_value, 4 /* size of buf */, cifs_sb->local_nls,
-                cifs_sb->mnt_cifs_flags &
-                CIFS_MOUNT_MAP_SPECIAL_CHR);
+    if (tcon->ses->server->ops->query_all_EAs == NULL) {
+        cifs_put_tlink(tlink);
+        return -EOPNOTSUPP;
+    }
+
+    rc = tcon->ses->server->ops->query_all_EAs(xid, tcon, path,
+            "SETFILEBITS", ea_value, 4 /* size of buf */,
+            cifs_sb->local_nls,
+            cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
     cifs_put_tlink(tlink);
     if (rc < 0)
         return (int)rc;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 9ac5bfc..3e4ff79 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1067,6 +1067,10 @@ struct smb_version_operations smb1_operations = {
     .query_mf_symlink = cifs_query_mf_symlink,
     .create_mf_symlink = cifs_create_mf_symlink,
     .is_read_op = cifs_is_read_op,
+#ifdef CONFIG_CIFS_XATTR
+    .query_all_EAs = CIFSSMBQAllEAs,
+    .set_EA = CIFSSMBSetEA,
+#endif /* CIFS_XATTR */
 };

 struct smb_version_values smb1_values = {


-- 
Thanks,

Steve
