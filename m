From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [SMB3] enable fallocate punch hole ("fallocate -p") for SMB3
Date: Tue, 19 Aug 2014 00:21:37 -0500
Message-ID: <CAH2r5mup7nT6OErhg+7O9fkYYr0Le-hW8mGH=F3qP4u9uUVpRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Implement FALLOC_FL_PUNCH_HOLE (which does not change the file size
fortunately so this matches the behavior of the equivalent SMB3
fsctl call) for SMB3 mounts.  This allows "fallocate -p" to work.
It requires that the server support setting files as sparse
(which Windows allows) which we do before punching the hole.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c   | 19 +++++++++++++++++++
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/smb2ops.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h  |  6 ++++++
 fs/cifs/smbfsctl.h |  2 +-
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 0a4a4d7..155347e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -207,6 +207,19 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
     return 0;
 }

+static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
+{
+    struct super_block *sb = file->f_path.dentry->d_sb;
+    struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+    struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+    struct TCP_Server_Info *server = tcon->ses->server;
+
+    if (server->ops->fallocate)
+        return server->ops->fallocate(file, tcon, mode, off, len);
+
+    return -EOPNOTSUPP;
+}
+
 static int cifs_permission(struct inode *inode, int mask)
 {
     struct cifs_sb_info *cifs_sb;
@@ -909,6 +922,7 @@ const struct file_operations cifs_file_ops = {
     .unlocked_ioctl    = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_file_strict_ops = {
@@ -928,6 +942,7 @@ const struct file_operations cifs_file_strict_ops = {
     .unlocked_ioctl    = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_file_direct_ops = {
@@ -948,6 +963,7 @@ const struct file_operations cifs_file_direct_ops = {
 #endif /* CONFIG_CIFS_POSIX */
     .llseek = cifs_llseek,
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_file_nobrl_ops = {
@@ -966,6 +982,7 @@ const struct file_operations cifs_file_nobrl_ops = {
     .unlocked_ioctl    = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_file_strict_nobrl_ops = {
@@ -984,6 +1001,7 @@ const struct file_operations cifs_file_strict_nobrl_ops = {
     .unlocked_ioctl    = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_file_direct_nobrl_ops = {
@@ -1003,6 +1021,7 @@ const struct file_operations
cifs_file_direct_nobrl_ops = {
 #endif /* CONFIG_CIFS_POSIX */
     .llseek = cifs_llseek,
     .setlease = cifs_setlease,
+    .fallocate = cifs_fallocate,
 };

 const struct file_operations cifs_dir_ops = {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ce24c1f..dfc731b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -411,6 +411,8 @@ struct smb_version_operations {
                 unsigned int *, unsigned int *);
     /* check if we need to issue closedir */
     bool (*dir_needs_close)(struct cifsFileInfo *);
+    long (*fallocate)(struct file *, struct cifs_tcon *, int, loff_t,
+              loff_t);
 };

 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3fcd410..101670c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1015,6 +1015,50 @@ smb2_query_symlink(const unsigned int xid,
struct cifs_tcon *tcon,
     return rc;
 }

+static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
+                loff_t offset, loff_t len)
+{
+    struct inode *inode;
+    struct cifsInodeInfo *cifsi;
+    struct cifsFileInfo *cfile = file->private_data;
+    struct file_zero_data_information fsctl_buf;
+    long rc;
+    unsigned int xid;
+    __u8 set_sparse = 1;
+
+    xid = get_xid();
+
+    inode = cfile->dentry->d_inode;
+    cifsi = CIFS_I(inode);
+
+    /* Need to make file sparse, if not already, before freeing range. */
+    /* Consider adding equivalent for compressed since it could also work */
+    if (!smb2_set_sparse(xid, tcon, cfile, inode, set_sparse))
+        return -EOPNOTSUPP;
+
+    cifs_dbg(FYI, "offset %lld len %lld", offset, len);
+
+    fsctl_buf.FileOffset = cpu_to_le64(offset);
+    fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
+
+    rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
+            cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
+            true /* is_fctl */, (char *)&fsctl_buf,
+            sizeof(struct file_zero_data_information), NULL, NULL);
+    free_xid(xid);
+    return rc;
+}
+
+static long smb3_fallocate(struct file *file, struct cifs_tcon *tcon, int mode,
+               loff_t off, loff_t len)
+{
+    /* KEEP_SIZE already checked for by do_fallocate */
+    if (mode & FALLOC_FL_PUNCH_HOLE)
+        return smb3_punch_hole(file, tcon, off, len);
+
+    return -EOPNOTSUPP;
+}
+
 static void
 smb2_downgrade_oplock(struct TCP_Server_Info *server,
             struct cifsInodeInfo *cinode, bool set_level2)
@@ -1463,6 +1507,7 @@ struct smb_version_operations smb30_operations = {
     .validate_negotiate = smb3_validate_negotiate,
     .wp_retry_size = smb2_wp_retry_size,
     .dir_needs_close = smb2_dir_needs_close,
+    .fallocate = smb3_fallocate,
 };

 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 69f3595..fbe486c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -573,6 +573,12 @@ struct copychunk_ioctl {
     __u32 Reserved2;
 } __packed;

+/* this goes in the ioctl buffer when doing FSCTL_SET_ZERO_DATA */
+struct file_zero_data_information {
+    __le64    FileOffset;
+    __le64    BeyondFinalZero;
+} __packed;
+
 struct copychunk_ioctl_rsp {
     __le32 ChunksWritten;
     __le32 ChunkBytesWritten;
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index 0e538b5..83efa59 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -63,7 +63,7 @@
 #define FSCTL_SET_OBJECT_ID_EXTENDED 0x000900BC /* BB add struct */
 #define FSCTL_CREATE_OR_GET_OBJECT_ID 0x000900C0 /* BB add struct */
 #define FSCTL_SET_SPARSE             0x000900C4 /* BB add struct */
-#define FSCTL_SET_ZERO_DATA          0x000900C8 /* BB add struct */
+#define FSCTL_SET_ZERO_DATA          0x000980C8
 #define FSCTL_SET_ENCRYPTION         0x000900D7 /* BB add struct */
 #define FSCTL_ENCRYPTION_FSCTL_IO    0x000900DB /* BB add struct */
 #define FSCTL_WRITE_RAW_ENCRYPTED    0x000900DF /* BB add struct */


-- 
Thanks,

Steve
