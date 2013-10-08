From: Steve French <smfrench@gmail.com>
Subject: [[PATCH v2] [CIFS] Allow setting per-file compression via SMB2 and SMB3
Date: Tue, 8 Oct 2013 15:41:17 -0500
Message-ID: <CAH2r5mubgNp_gY=0b_dWuQx2X2S1hESz5iKXwNhGZfXwCM7TsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8ffbac1d64758f04e840ca55
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--e89a8ffbac1d64758f04e840ca55
Content-Type: text/plain; charset=ISO-8859-1

Allow cifs/smb2/smb3 to return whether or not a file is compressed
via lsattr, and allow SMB2/SMB3 to set the per-file compression
flag ("chattr +c filename" on an smb2 or smb3 mount).

Windows users often set the compressed flag (it can be
done from the desktop and file manager).  David Disseldorp
has patches to Samba server to support this (at least on btrfs)
which are complementary to this

Signed-off-by: Steve French <smfrench@gmail.com>
---
 fs/cifs/cifsglob.h  |  2 ++
 fs/cifs/ioctl.c     | 55 +++++++++++++++++++++++++++++++++++------------------
 fs/cifs/smb2ops.c   | 11 +++++++++++
 fs/cifs/smb2pdu.c   | 33 ++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.h   |  9 ++++++++-
 fs/cifs/smb2proto.h |  2 ++
 6 files changed, 91 insertions(+), 21 deletions(-)

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
  *   Author(s): Steve French (sfrench@us.ibm.com)
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
index edccb52..fb19ad8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1137,6 +1137,7 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

  cifs_dbg(FYI, "SMB2 IOCTL\n");

+ *out_data = NULL;
  /* zero out returned data len, in case of error */
  if (plen)
  *plen = 0;
@@ -1183,10 +1184,12 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

  iov[0].iov_base = (char *)req;
  /* 4 for rfc1002 length field */
- iov[0].iov_len = get_rfc1002_length(req) + 4;
+ /* -1 since last byte is buf[0] which is sent in iov[1] or not at all */
+ iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;

+ /* -1 since last byte is buf[0] which was counted in smb2_buf_len */
  if (indatalen)
- inc_rfc1001_len(req, indatalen);
+ inc_rfc1001_len(req, indatalen - 1);

  rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
  rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
@@ -1234,6 +1237,32 @@ ioctl_exit:
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

--e89a8ffbac1d64758f04e840ca55
Content-Type: application/octet-stream;
	name="0001-CIFS-Allow-setting-per-file-compression-via-SMB2-and.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Allow-setting-per-file-compression-via-SMB2-and.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmjlfrfn0

RnJvbSA1ZjkzNzRjODRjZmU5ODg1ZGM4ZjM2ZTJiOTdhZmJjOTJkNTQ5ZTIwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCA4IE9jdCAyMDEzIDExOjMyOjIxIC0wNTAwClN1YmplY3Q6IFtQQVRDSCB2Ml0gW0NJ
RlNdIEFsbG93IHNldHRpbmcgcGVyLWZpbGUgY29tcHJlc3Npb24gdmlhIFNNQjIgYW5kIFNNQjMK
CkFsbG93IGNpZnMvc21iMi9zbWIzIHRvIHJldHVybiB3aGV0aGVyIG9yIG5vdCBhIGZpbGUgaXMg
Y29tcHJlc3NlZAp2aWEgbHNhdHRyLCBhbmQgYWxsb3cgU01CMi9TTUIzIHRvIHNldCB0aGUgcGVy
LWZpbGUgY29tcHJlc3Npb24KZmxhZyAoImNoYXR0ciArYyBmaWxlbmFtZSIgb24gYW4gc21iMiBv
ciBzbWIzIG1vdW50KS4KCldpbmRvd3MgdXNlcnMgb2Z0ZW4gc2V0IHRoZSBjb21wcmVzc2VkIGZs
YWcgKGl0IGNhbiBiZQpkb25lIGZyb20gdGhlIGRlc2t0b3AgYW5kIGZpbGUgbWFuYWdlcikuICBE
YXZpZCBEaXNzZWxkb3JwCmhhcyBwYXRjaGVzIHRvIFNhbWJhIHNlcnZlciB0byBzdXBwb3J0IHRo
aXMgKGF0IGxlYXN0IG9uIGJ0cmZzKQp3aGljaCBhcmUgY29tcGxlbWVudGFyeSB0byB0aGlzCgpT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KLS0tCiBmcy9j
aWZzL2NpZnNnbG9iLmggIHwgIDIgKysKIGZzL2NpZnMvaW9jdGwuYyAgICAgfCA1NSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQogZnMvY2lmcy9z
bWIyb3BzLmMgICB8IDExICsrKysrKysrKysrCiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgMzMgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIGZzL2NpZnMvc21iMnBkdS5oICAgfCAgOSAr
KysrKysrKy0KIGZzL2NpZnMvc21iMnByb3RvLmggfCAgMiArKwogNiBmaWxlcyBjaGFuZ2VkLCA5
MSBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2Np
ZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggNTJiNmY2Yy4uMDZlODk0NyAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAt
Mjc4LDYgKzI3OCw4IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHsKIAkvKiBzZXQg
YXR0cmlidXRlcyAqLwogCWludCAoKnNldF9maWxlX2luZm8pKHN0cnVjdCBpbm9kZSAqLCBjb25z
dCBjaGFyICosIEZJTEVfQkFTSUNfSU5GTyAqLAogCQkJICAgICBjb25zdCB1bnNpZ25lZCBpbnQp
OworCWludCAoKnNldF9jb21wcmVzc2lvbikoY29uc3QgdW5zaWduZWQgaW50LCBzdHJ1Y3QgY2lm
c190Y29uICosCisJCQkgICAgICAgc3RydWN0IGNpZnNGaWxlSW5mbyAqKTsKIAkvKiBjaGVjayBp
ZiB3ZSBjYW4gc2VuZCBhbiBlY2hvIG9yIG5vciAqLwogCWJvb2wgKCpjYW5fZWNobykoc3RydWN0
IFRDUF9TZXJ2ZXJfSW5mbyAqKTsKIAkvKiBzZW5kIGVjaG8gcmVxdWVzdCAqLwpkaWZmIC0tZ2l0
IGEvZnMvY2lmcy9pb2N0bC5jIGIvZnMvY2lmcy9pb2N0bC5jCmluZGV4IDNlMDg0NTUuLjAyOTg2
NzAgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW9jdGwuYworKysgYi9mcy9jaWZzL2lvY3RsLmMKQEAg
LTMsNyArMyw3IEBACiAgKgogICogICB2ZnMgb3BlcmF0aW9ucyB0aGF0IGRlYWwgd2l0aCBpbyBj
b250cm9sCiAgKgotICogICBDb3B5cmlnaHQgKEMpIEludGVybmF0aW9uYWwgQnVzaW5lc3MgTWFj
aGluZXMgIENvcnAuLCAyMDA1LDIwMDcKKyAqICAgQ29weXJpZ2h0IChDKSBJbnRlcm5hdGlvbmFs
IEJ1c2luZXNzIE1hY2hpbmVzICBDb3JwLiwgMjAwNSwyMDEzCiAgKiAgIEF1dGhvcihzKTogU3Rl
dmUgRnJlbmNoIChzZnJlbmNoQHVzLmlibS5jb20pCiAgKgogICogICBUaGlzIGxpYnJhcnkgaXMg
ZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQpAQCAt
MzQsMTMgKzM0LDExIEBAIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2ln
bmVkIGludCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIAlpbnQgcmMgPSAtRU5PVFRZOyAv
KiBzdHJhbmdlIGVycm9yIC0gYnV0IHRoZSBwcmVjZWRlbnQgKi8KIAl1bnNpZ25lZCBpbnQgeGlk
OwogCXN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2I7Ci0jaWZkZWYgQ09ORklHX0NJRlNfUE9T
SVgKIAlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpwU01CRmlsZSA9IGZpbGVwLT5wcml2YXRlX2RhdGE7
CiAJc3RydWN0IGNpZnNfdGNvbiAqdGNvbjsKIAlfX3U2NAlFeHRBdHRyQml0cyA9IDA7CiAJX191
NjQJRXh0QXR0ck1hc2sgPSAwOwogCV9fdTY0ICAgY2FwczsKLSNlbmRpZiAvKiBDT05GSUdfQ0lG
U19QT1NJWCAqLwogCiAJeGlkID0gZ2V0X3hpZCgpOwogCkBAIC00OSwxMiArNDcsMTIgQEAgbG9u
ZyBjaWZzX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNvbW1hbmQsIHVu
c2lnbmVkIGxvbmcgYXJnKQogCWNpZnNfc2IgPSBDSUZTX1NCKGlub2RlLT5pX3NiKTsKIAogCXN3
aXRjaCAoY29tbWFuZCkgewotI2lmZGVmIENPTkZJR19DSUZTX1BPU0lYCiAJCWNhc2UgRlNfSU9D
X0dFVEZMQUdTOgogCQkJaWYgKHBTTUJGaWxlID09IE5VTEwpCiAJCQkJYnJlYWs7CiAJCQl0Y29u
ID0gdGxpbmtfdGNvbihwU01CRmlsZS0+dGxpbmspOwogCQkJY2FwcyA9IGxlNjRfdG9fY3B1KHRj
b24tPmZzVW5peEluZm8uQ2FwYWJpbGl0eSk7CisjaWZkZWYgQ09ORklHX0NJRlNfUE9TSVgKIAkJ
CWlmIChDSUZTX1VOSVhfRVhUQVRUUl9DQVAgJiBjYXBzKSB7CiAJCQkJcmMgPSBDSUZTR2V0RXh0
QXR0cih4aWQsIHRjb24sCiAJCQkJCQkgICAgcFNNQkZpbGUtPmZpZC5uZXRmaWQsCkBAIC02Mywy
OSArNjEsNTAgQEAgbG9uZyBjaWZzX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlcCwgdW5zaWduZWQg
aW50IGNvbW1hbmQsIHVuc2lnbmVkIGxvbmcgYXJnKQogCQkJCQlyYyA9IHB1dF91c2VyKEV4dEF0
dHJCaXRzICYKIAkJCQkJCUZTX0ZMX1VTRVJfVklTSUJMRSwKIAkJCQkJCShpbnQgX191c2VyICop
YXJnKTsKKwkJCQlpZiAocmMgIT0gRU9QTk9UU1VQUCkKKwkJCQkJYnJlYWs7CisJCQl9CisjZW5k
aWYgLyogQ09ORklHX0NJRlNfUE9TSVggKi8KKwkJCXJjID0gMDsKKwkJCWlmIChDSUZTX0koaW5v
ZGUpLT5jaWZzQXR0cnMgJiBBVFRSX0NPTVBSRVNTRUQpIHsKKwkJCQkvKiBhZGQgaW4gdGhlIGNv
bXByZXNzZWQgYml0ICovCisJCQkJRXh0QXR0ckJpdHMgPSBGU19DT01QUl9GTDsKKwkJCQlyYyA9
IHB1dF91c2VyKEV4dEF0dHJCaXRzICYgRlNfRkxfVVNFUl9WSVNJQkxFLAorCQkJCQkgICAgICAo
aW50IF9fdXNlciAqKWFyZyk7CiAJCQl9CiAJCQlicmVhazsKLQogCQljYXNlIEZTX0lPQ19TRVRG
TEFHUzoKIAkJCWlmIChwU01CRmlsZSA9PSBOVUxMKQogCQkJCWJyZWFrOwogCQkJdGNvbiA9IHRs
aW5rX3Rjb24ocFNNQkZpbGUtPnRsaW5rKTsKIAkJCWNhcHMgPSBsZTY0X3RvX2NwdSh0Y29uLT5m
c1VuaXhJbmZvLkNhcGFiaWxpdHkpOwotCQkJaWYgKENJRlNfVU5JWF9FWFRBVFRSX0NBUCAmIGNh
cHMpIHsKLQkJCQlpZiAoZ2V0X3VzZXIoRXh0QXR0ckJpdHMsIChpbnQgX191c2VyICopYXJnKSkg
ewotCQkJCQlyYyA9IC1FRkFVTFQ7Ci0JCQkJCWJyZWFrOwotCQkJCX0KLQkJCQkvKgotCQkJCSAq
IHJjID0gQ0lGU0dldEV4dEF0dHIoeGlkLCB0Y29uLAotCQkJCSAqCQkgICAgICAgcFNNQkZpbGUt
PmZpZC5uZXRmaWQsCi0JCQkJICoJCSAgICAgICBleHRBdHRyQml0cywKLQkJCQkgKgkJICAgICAg
ICZFeHRBdHRyTWFzayk7Ci0JCQkJICovCisKKwkJCWlmIChnZXRfdXNlcihFeHRBdHRyQml0cywg
KGludCBfX3VzZXIgKilhcmcpKSB7CisJCQkJcmMgPSAtRUZBVUxUOworCQkJCWJyZWFrOworCQkJ
fQorCisJCQkvKgorCQkJICogaWYgKENJRlNfVU5JWF9FWFRBVFRSX0NBUCAmIGNhcHMpCisJCQkg
KglyYyA9IENJRlNTZXRFeHRBdHRyKHhpZCwgdGNvbiwKKwkJCSAqCQkgICAgICAgcFNNQkZpbGUt
PmZpZC5uZXRmaWQsCisJCQkgKgkJICAgICAgIGV4dEF0dHJCaXRzLAorCQkJICoJCSAgICAgICAm
RXh0QXR0ck1hc2spOworCQkJICogaWYgKHJjICE9IEVPUE5PVFNVUFApCisJCQkgKglicmVhazsK
KwkJCSAqLworCisJCQkvKiBDdXJyZW50bHkgb25seSBmbGFnIHdlIGNhbiBzZXQgaXMgY29tcHJl
c3NlZCBmbGFnICovCisJCQlpZiAoKEV4dEF0dHJCaXRzICYgRlNfQ09NUFJfRkwpID09IDApCisJ
CQkJYnJlYWs7CisKKwkJCS8qIFRyeSB0byBzZXQgY29tcHJlc3MgZmxhZyAqLworCQkJaWYgKHRj
b24tPnNlcy0+c2VydmVyLT5vcHMtPnNldF9jb21wcmVzc2lvbikgeworCQkJCXJjID0gdGNvbi0+
c2VzLT5zZXJ2ZXItPm9wcy0+c2V0X2NvbXByZXNzaW9uKAorCQkJCQkJCXhpZCwgdGNvbiwgcFNN
QkZpbGUpOworCQkJCWNpZnNfZGJnKEZZSSwgInNldCBjb21wcmVzcyBmbGFnIHJjICVkXG4iLCBy
Yyk7CiAJCQl9Ci0JCQljaWZzX2RiZyhGWUksICJzZXQgZmxhZ3Mgbm90IGltcGxlbWVudGVkIHll
dFxuIik7CiAJCQlicmVhazsKLSNlbmRpZiAvKiBDT05GSUdfQ0lGU19QT1NJWCAqLwogCQlkZWZh
dWx0OgogCQkJY2lmc19kYmcoRllJLCAidW5zdXBwb3J0ZWQgaW9jdGxcbiIpOwogCQkJYnJlYWs7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4
IDg2MWIzMzIuLmI5NmJhY2MgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2Zz
L2NpZnMvc21iMm9wcy5jCkBAIC00NDYsNiArNDQ2LDE0IEBAIHNtYjJfc2V0X2ZpbGVfc2l6ZShj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogfQogCiBzdGF0
aWMgaW50CitzbWIyX3NldF9jb21wcmVzc2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAorCQkgICBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSkKK3sK
KwlyZXR1cm4gU01CMl9zZXRfY29tcHJlc3Npb24oeGlkLCB0Y29uLCBjZmlsZS0+ZmlkLnBlcnNp
c3RlbnRfZmlkLAorCQkJICAgIGNmaWxlLT5maWQudm9sYXRpbGVfZmlkKTsKK30KKworc3RhdGlj
IGludAogc21iMl9xdWVyeV9kaXJfZmlyc3QoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAkJICAgICBjb25zdCBjaGFyICpwYXRoLCBzdHJ1Y3QgY2lmc19z
Yl9pbmZvICpjaWZzX3NiLAogCQkgICAgIHN0cnVjdCBjaWZzX2ZpZCAqZmlkLCBfX3UxNiBzZWFy
Y2hfZmxhZ3MsCkBAIC04NzQsNiArODgyLDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlv
bnMgc21iMjBfb3BlcmF0aW9ucyA9IHsKIAkuc2V0X3BhdGhfc2l6ZSA9IHNtYjJfc2V0X3BhdGhf
c2l6ZSwKIAkuc2V0X2ZpbGVfc2l6ZSA9IHNtYjJfc2V0X2ZpbGVfc2l6ZSwKIAkuc2V0X2ZpbGVf
aW5mbyA9IHNtYjJfc2V0X2ZpbGVfaW5mbywKKwkuc2V0X2NvbXByZXNzaW9uID0gc21iMl9zZXRf
Y29tcHJlc3Npb24sCiAJLm1rZGlyID0gc21iMl9ta2RpciwKIAkubWtkaXJfc2V0aW5mbyA9IHNt
YjJfbWtkaXJfc2V0aW5mbywKIAkucm1kaXIgPSBzbWIyX3JtZGlyLApAQCAtOTQ1LDYgKzk1NCw3
IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIxX29wZXJhdGlvbnMgPSB7CiAJ
LnNldF9wYXRoX3NpemUgPSBzbWIyX3NldF9wYXRoX3NpemUsCiAJLnNldF9maWxlX3NpemUgPSBz
bWIyX3NldF9maWxlX3NpemUsCiAJLnNldF9maWxlX2luZm8gPSBzbWIyX3NldF9maWxlX2luZm8s
CisJLnNldF9jb21wcmVzc2lvbiA9IHNtYjJfc2V0X2NvbXByZXNzaW9uLAogCS5ta2RpciA9IHNt
YjJfbWtkaXIsCiAJLm1rZGlyX3NldGluZm8gPSBzbWIyX21rZGlyX3NldGluZm8sCiAJLnJtZGly
ID0gc21iMl9ybWRpciwKQEAgLTEwMTcsNiArMTAyNyw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9v
cGVyYXRpb25zIHNtYjMwX29wZXJhdGlvbnMgPSB7CiAJLnNldF9wYXRoX3NpemUgPSBzbWIyX3Nl
dF9wYXRoX3NpemUsCiAJLnNldF9maWxlX3NpemUgPSBzbWIyX3NldF9maWxlX3NpemUsCiAJLnNl
dF9maWxlX2luZm8gPSBzbWIyX3NldF9maWxlX2luZm8sCisJLnNldF9jb21wcmVzc2lvbiA9IHNt
YjJfc2V0X2NvbXByZXNzaW9uLAogCS5ta2RpciA9IHNtYjJfbWtkaXIsCiAJLm1rZGlyX3NldGlu
Zm8gPSBzbWIyX21rZGlyX3NldGluZm8sCiAJLnJtZGlyID0gc21iMl9ybWRpciwKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggZWRjY2I1Mi4u
ZmIxOWFkOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmMKQEAgLTExMzcsNiArMTEzNyw3IEBAIFNNQjJfaW9jdGwoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgdTY0IHBlcnNpc3RlbnRfZmlkLAogCiAJY2lm
c19kYmcoRllJLCAiU01CMiBJT0NUTFxuIik7CiAKKwkqb3V0X2RhdGEgPSBOVUxMOwogCS8qIHpl
cm8gb3V0IHJldHVybmVkIGRhdGEgbGVuLCBpbiBjYXNlIG9mIGVycm9yICovCiAJaWYgKHBsZW4p
CiAJCSpwbGVuID0gMDsKQEAgLTExODMsMTAgKzExODQsMTIgQEAgU01CMl9pb2N0bChjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCB1NjQgcGVyc2lzdGVudF9m
aWQsCiAKIAlpb3ZbMF0uaW92X2Jhc2UgPSAoY2hhciAqKXJlcTsKIAkvKiA0IGZvciByZmMxMDAy
IGxlbmd0aCBmaWVsZCAqLwotCWlvdlswXS5pb3ZfbGVuID0gZ2V0X3JmYzEwMDJfbGVuZ3RoKHJl
cSkgKyA0OworCS8qIC0xIHNpbmNlIGxhc3QgYnl0ZSBpcyBidWZbMF0gd2hpY2ggaXMgc2VudCBp
biBpb3ZbMV0gb3Igbm90IGF0IGFsbCAqLworCWlvdlswXS5pb3ZfbGVuID0gZ2V0X3JmYzEwMDJf
bGVuZ3RoKHJlcSkgKyA0IC0gMTsKIAorCS8qIC0xIHNpbmNlIGxhc3QgYnl0ZSBpcyBidWZbMF0g
d2hpY2ggd2FzIGNvdW50ZWQgaW4gc21iMl9idWZfbGVuICovCiAJaWYgKGluZGF0YWxlbikKLQkJ
aW5jX3JmYzEwMDFfbGVuKHJlcSwgaW5kYXRhbGVuKTsKKwkJaW5jX3JmYzEwMDFfbGVuKHJlcSwg
aW5kYXRhbGVuIC0gMSk7CiAKIAlyYyA9IFNlbmRSZWNlaXZlMih4aWQsIHNlcywgaW92LCBudW1f
aW92ZWNzLCAmcmVzcF9idWZ0eXBlLCAwKTsKIAlyc3AgPSAoc3RydWN0IHNtYjJfaW9jdGxfcnNw
ICopaW92WzBdLmlvdl9iYXNlOwpAQCAtMTIzNCw2ICsxMjM3LDMyIEBAIGlvY3RsX2V4aXQ6CiAJ
cmV0dXJuIHJjOwogfQogCisvKgorICogICBJbmRpdmlkdWFsIGNhbGxlcnMgdG8gaW9jdGwgd29y
a2VyIGZ1bmN0aW9uIGZvbGxvdworICovCisKK2ludAorU01CMl9zZXRfY29tcHJlc3Npb24oY29u
c3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJICAgICB1NjQg
cGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQpCit7CisJaW50IHJjOworCWNoYXIgKnJl
c19rZXkgPSBOVUxMOworCXN0cnVjdCAgY29tcHJlc3NfaW9jdGwgZnNjdGxfaW5wdXQ7CisJY2hh
ciAqcmV0X2RhdGEgPSBOVUxMOworCisJZnNjdGxfaW5wdXQuQ29tcHJlc3Npb25TdGF0ZSA9IGNw
dV90b19sZTE2KENPTVBSRVNTSU9OX0ZPUk1BVF9ERUZBVUxUKTsKKworCXJjID0gU01CMl9pb2N0
bCh4aWQsIHRjb24sIHBlcnNpc3RlbnRfZmlkLCB2b2xhdGlsZV9maWQsCisJCQlGU0NUTF9TRVRf
Q09NUFJFU1NJT04sIHRydWUgLyogaXNfZnNjdGwgKi8sCisJCQkoY2hhciAqKSZmc2N0bF9pbnB1
dCAvKiBkYXRhIGlucHV0ICovLAorCQkJMiAvKiBpbiBkYXRhIGxlbiAqLywgJnJldF9kYXRhIC8q
IG91dCBkYXRhICovLCBOVUxMKTsKKworCWNpZnNfZGJnKFZGUywgInNldCBjb21wcmVzc2lvbiBy
YyAlZFxuIiwgcmMpOyAvKiBGSVhNRSAqLworCWtmcmVlKHJlc19rZXkpOworCisJcmV0dXJuIHJj
OworfQorCiBpbnQKIFNNQjJfY2xvc2UoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkgICB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQp
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4
IGI4M2QwMTEuLmM3YzNjODIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2Zz
L2NpZnMvc21iMnBkdS5oCkBAIC01NjksNiArNTY5LDEzIEBAIHN0cnVjdCBuZXR3b3JrX2ludGVy
ZmFjZV9pbmZvX2lvY3RsX3JzcCB7CiAKICNkZWZpbmUgTk9fRklMRV9JRCAweEZGRkZGRkZGRkZG
RkZGRkZVTEwgLyogZ2VuZXJhbCBpb2N0bHMgdG8gc3J2IG5vdCB0byBmaWxlICovCiAKK3N0cnVj
dCBjb21wcmVzc19pb2N0bCB7CisJX19sZTE2IENvbXByZXNzaW9uU3RhdGU7Cit9IF9fcGFja2Vk
OworCisjZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1BVF9OT05FCQkweDAwMDAKKyNkZWZpbmUgQ09N
UFJFU1NJT05fRk9STUFUX0RFRkFVTFQJMHgwMDAxCisjZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1B
VF9MWk5UMQkweDAwMDIKIHN0cnVjdCBzbWIyX2lvY3RsX3JlcSB7CiAJc3RydWN0IHNtYjJfaGRy
IGhkcjsKIAlfX2xlMTYgU3RydWN0dXJlU2l6ZTsJLyogTXVzdCBiZSA1NyAqLwpAQCAtNTg0LDcg
KzU5MSw3IEBAIHN0cnVjdCBzbWIyX2lvY3RsX3JlcSB7CiAJX19sZTMyIE1heE91dHB1dFJlc3Bv
bnNlOwogCV9fbGUzMiBGbGFnczsKIAlfX3UzMiAgUmVzZXJ2ZWQyOwotCWNoYXIgICBCdWZmZXJb
MF07CisJX191OCAgIEJ1ZmZlclswXTsKIH0gX19wYWNrZWQ7CiAKIHN0cnVjdCBzbWIyX2lvY3Rs
X3JzcCB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIycHJv
dG8uaAppbmRleCBlM2ZiNDgwLi4zY2YyMmUzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwcm90
by5oCisrKyBiL2ZzL2NpZnMvc21iMnByb3RvLmgKQEAgLTE0Miw2ICsxNDIsOCBAQCBleHRlcm4g
aW50IFNNQjJfc2V0X2VvZihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogZXh0ZXJuIGludCBTTUIyX3NldF9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9s
YXRpbGVfZmlkLAogCQkJIEZJTEVfQkFTSUNfSU5GTyAqYnVmKTsKK2V4dGVybiBpbnQgU01CMl9z
ZXRfY29tcHJlc3Npb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAq
dGNvbiwKKwkJCQl1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQpOwogZXh0ZXJu
IGludCBTTUIyX29wbG9ja19icmVhayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkJICAgICBjb25zdCB1NjQgcGVyc2lzdGVudF9maWQsIGNvbnN0IHU2
NCB2b2xhdGlsZV9maWQsCiAJCQkgICAgIGNvbnN0IF9fdTggb3Bsb2NrX2xldmVsKTsKLS0gCjEu
Ny4xMS43Cgo=
--e89a8ffbac1d64758f04e840ca55--
