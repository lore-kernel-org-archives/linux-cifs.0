From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Allow setting per-file compression via SMB2/3
Date: Thu, 10 Oct 2013 22:00:08 -0500
Message-ID: <CAH2r5mvHo4v4uKQfFc-vPtnYt1E8OvbhspskdfNezMbyYFq5KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Allow cifs/smb2/smb3 to return whether or not a file is compressed
via lsattr, and allow SMB2/SMB3 to set the per-file compression
flag ("chattr +c filename" on an smb3 mount).

A followon patch will do this for cifs

Windows users often set the compressed flag (it can be
done from the desktop and file manager).  David Disseldorp
has patches to Samba server to support this (at least on btrfs)
which are complementary to this.

As Metze suggested I split out the part of the patch
which fixed up the length calculation in the
SMB2_ioctl worker function as it is more general
and not compression specific enablement (I
just noticed the problem when doing this patch).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  2 ++
 fs/cifs/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2ops.c   | 11 +++++++++++
 fs/cifs/smb2pdu.c   | 26 +++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |  9 ++++++++-
 fs/cifs/smb2proto.h |  2 ++
 6 files changed, 86 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 52b6f6c..06e8947 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -278,6 +278,8 @@ struct smb_version_operations {
  /* set attributes */
  int (*set_file_info)(struct inode *, const char *, FILE_BASIC_INFO *,
      const unsigned int);
+ int (*set_compression)(const unsigned int, struct cifs_tcon *,
+       struct cifsFileInfo *);
  /* check if we can send an echo or nor */
  bool (*can_echo)(struct TCP_Server_Info *);
  /* send echo request */
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 3e08455..0298670 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -3,7 +3,7 @@
  *
  *   vfs operations that deal with io control
  *
- *   Copyright (C) International Business Machines  Corp., 2005,2007
+ *   Copyright (C) International Business Machines  Corp., 2005,2013
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -34,13 +34,11 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  int rc = -ENOTTY; /* strange error - but the precedent */
  unsigned int xid;
  struct cifs_sb_info *cifs_sb;
-#ifdef CONFIG_CIFS_POSIX
  struct cifsFileInfo *pSMBFile = filep->private_data;
  struct cifs_tcon *tcon;
  __u64 ExtAttrBits = 0;
  __u64 ExtAttrMask = 0;
  __u64   caps;
-#endif /* CONFIG_CIFS_POSIX */

  xid = get_xid();

@@ -49,12 +47,12 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  cifs_sb = CIFS_SB(inode->i_sb);

  switch (command) {
-#ifdef CONFIG_CIFS_POSIX
  case FS_IOC_GETFLAGS:
  if (pSMBFile == NULL)
  break;
  tcon = tlink_tcon(pSMBFile->tlink);
  caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
+#ifdef CONFIG_CIFS_POSIX
  if (CIFS_UNIX_EXTATTR_CAP & caps) {
  rc = CIFSGetExtAttr(xid, tcon,
     pSMBFile->fid.netfid,
@@ -63,29 +61,50 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  rc = put_user(ExtAttrBits &
  FS_FL_USER_VISIBLE,
  (int __user *)arg);
+ if (rc != EOPNOTSUPP)
+ break;
+ }
+#endif /* CONFIG_CIFS_POSIX */
+ rc = 0;
+ if (CIFS_I(inode)->cifsAttrs & ATTR_COMPRESSED) {
+ /* add in the compressed bit */
+ ExtAttrBits = FS_COMPR_FL;
+ rc = put_user(ExtAttrBits & FS_FL_USER_VISIBLE,
+      (int __user *)arg);
  }
  break;
-
  case FS_IOC_SETFLAGS:
  if (pSMBFile == NULL)
  break;
  tcon = tlink_tcon(pSMBFile->tlink);
  caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
- if (CIFS_UNIX_EXTATTR_CAP & caps) {
- if (get_user(ExtAttrBits, (int __user *)arg)) {
- rc = -EFAULT;
- break;
- }
- /*
- * rc = CIFSGetExtAttr(xid, tcon,
- *       pSMBFile->fid.netfid,
- *       extAttrBits,
- *       &ExtAttrMask);
- */
+
+ if (get_user(ExtAttrBits, (int __user *)arg)) {
+ rc = -EFAULT;
+ break;
+ }
+
+ /*
+ * if (CIFS_UNIX_EXTATTR_CAP & caps)
+ * rc = CIFSSetExtAttr(xid, tcon,
+ *       pSMBFile->fid.netfid,
+ *       extAttrBits,
+ *       &ExtAttrMask);
+ * if (rc != EOPNOTSUPP)
+ * break;
+ */
+
+ /* Currently only flag we can set is compressed flag */
+ if ((ExtAttrBits & FS_COMPR_FL) == 0)
+ break;
+
+ /* Try to set compress flag */
+ if (tcon->ses->server->ops->set_compression) {
+ rc = tcon->ses->server->ops->set_compression(
+ xid, tcon, pSMBFile);
+ cifs_dbg(FYI, "set compress flag rc %d\n", rc);
  }
- cifs_dbg(FYI, "set flags not implemented yet\n");
  break;
-#endif /* CONFIG_CIFS_POSIX */
  default:
  cifs_dbg(FYI, "unsupported ioctl\n");
  break;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 861b332..b96bacc 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -446,6 +446,14 @@ smb2_set_file_size(const unsigned int xid, struct
cifs_tcon *tcon,
 }

 static int
+smb2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
+   struct cifsFileInfo *cfile)
+{
+ return SMB2_set_compression(xid, tcon, cfile->fid.persistent_fid,
+    cfile->fid.volatile_fid);
+}
+
+static int
 smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
      const char *path, struct cifs_sb_info *cifs_sb,
      struct cifs_fid *fid, __u16 search_flags,
@@ -874,6 +882,7 @@ struct smb_version_operations smb20_operations = {
  .set_path_size = smb2_set_path_size,
  .set_file_size = smb2_set_file_size,
  .set_file_info = smb2_set_file_info,
+ .set_compression = smb2_set_compression,
  .mkdir = smb2_mkdir,
  .mkdir_setinfo = smb2_mkdir_setinfo,
  .rmdir = smb2_rmdir,
@@ -945,6 +954,7 @@ struct smb_version_operations smb21_operations = {
  .set_path_size = smb2_set_path_size,
  .set_file_size = smb2_set_file_size,
  .set_file_info = smb2_set_file_info,
+ .set_compression = smb2_set_compression,
  .mkdir = smb2_mkdir,
  .mkdir_setinfo = smb2_mkdir_setinfo,
  .rmdir = smb2_rmdir,
@@ -1017,6 +1027,7 @@ struct smb_version_operations smb30_operations = {
  .set_path_size = smb2_set_path_size,
  .set_file_size = smb2_set_file_size,
  .set_file_info = smb2_set_file_info,
+ .set_compression = smb2_set_compression,
  .mkdir = smb2_mkdir,
  .mkdir_setinfo = smb2_mkdir_setinfo,
  .rmdir = smb2_rmdir,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dabfa90..fb19ad8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1237,6 +1237,32 @@ ioctl_exit:
  return rc;
 }

+/*
+ *   Individual callers to ioctl worker function follow
+ */
+
+int
+SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
+     u64 persistent_fid, u64 volatile_fid)
+{
+ int rc;
+ char *res_key = NULL;
+ struct  compress_ioctl fsctl_input;
+ char *ret_data = NULL;
+
+ fsctl_input.CompressionState = cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
+
+ rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
+ FSCTL_SET_COMPRESSION, true /* is_fsctl */,
+ (char *)&fsctl_input /* data input */,
+ 2 /* in data len */, &ret_data /* out data */, NULL);
+
+ cifs_dbg(VFS, "set compression rc %d\n", rc); /* FIXME */
+ kfree(res_key);
+
+ return rc;
+}
+
 int
 SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
    u64 persistent_fid, u64 volatile_fid)
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index b83d011..c7c3c82 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -569,6 +569,13 @@ struct network_interface_info_ioctl_rsp {

 #define NO_FILE_ID 0xFFFFFFFFFFFFFFFFULL /* general ioctls to srv not
to file */

+struct compress_ioctl {
+ __le16 CompressionState;
+} __packed;
+
+#define COMPRESSION_FORMAT_NONE 0x0000
+#define COMPRESSION_FORMAT_DEFAULT 0x0001
+#define COMPRESSION_FORMAT_LZNT1 0x0002
 struct smb2_ioctl_req {
  struct smb2_hdr hdr;
  __le16 StructureSize; /* Must be 57 */
@@ -584,7 +591,7 @@ struct smb2_ioctl_req {
  __le32 MaxOutputResponse;
  __le32 Flags;
  __u32  Reserved2;
- char   Buffer[0];
+ __u8   Buffer[0];
 } __packed;

 struct smb2_ioctl_rsp {
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index e3fb480..3cf22e3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -142,6 +142,8 @@ extern int SMB2_set_eof(const unsigned int xid,
struct cifs_tcon *tcon,
 extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
  u64 persistent_fid, u64 volatile_fid,
  FILE_BASIC_INFO *buf);
+extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
+ u64 persistent_fid, u64 volatile_fid);
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
      const u64 persistent_fid, const u64 volatile_fid,
      const __u8 oplock_level);
-- 
1.7.11.7


-- 
Thanks,

Steve
