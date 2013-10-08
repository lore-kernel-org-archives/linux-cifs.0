From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Allow setting per-file compression via SMB3
Date: Mon, 7 Oct 2013 21:45:45 -0500
Message-ID: <CAH2r5muzG6m8UAc5_OEKT5FGtk-FJgtSH2FaVgQFvmvnR0znZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11333610f348a704e831c3b1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a11333610f348a704e831c3b1
Content-Type: text/plain; charset=ISO-8859-1

Allow cifs/smb2/smb3 to return whether or not a file is compressed
via lsattr, and allow SMB3 to set the per-file compression flag
("chattr +c filename" on an smb3 mount).

Windows users often set the compressed flag (it can be
done from the desktop and file manager).  David Disseldorp
has patches to Samba server to support this (at least on btrfs)
which are complementary to this.

Wish chattr supported the per-file encryption flag (that
presumably would be easy to set too via SMB3)

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  2 ++
 fs/cifs/ioctl.c     | 59 +++++++++++++++++++++++++++++++++++++----------------
 fs/cifs/smb2ops.c   |  9 ++++++++
 fs/cifs/smb2pdu.c   | 33 ++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.h   | 31 ++++++++++++++++++++++++++--
 fs/cifs/smb2proto.h |  2 ++
 6 files changed, 114 insertions(+), 22 deletions(-)

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
index 3e08455..4a74236 100644
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
@@ -22,6 +22,10 @@
  */

 #include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/file.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -34,13 +38,11 @@ long cifs_ioctl(struct file *filep, unsigned int
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

@@ -49,12 +51,12 @@ long cifs_ioctl(struct file *filep, unsigned int
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
@@ -63,29 +65,50 @@ long cifs_ioctl(struct file *filep, unsigned int
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
index 861b332..692fb65 100644
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
@@ -1017,6 +1025,7 @@ struct smb_version_operations smb30_operations = {
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
index b83d011..7ce2e3f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -555,6 +555,26 @@ struct validate_negotiate_info {
  __le16 Dialect[1];
 } __packed;

+#define InterNetwork __constant_cpu_to_le16(0x0002)
+#define InterNetwork6 __constant_cpu_to_le16(0x0017)
+struct SockAddr_Storage {
+ __le16 Family;
+ union {
+ struct {
+ __le16 Port; /* MBZ */
+ char IPv4Address[4];
+ char Reserved[120];
+ } sockaddr_in;
+ struct {
+ __le16 Port; /* MBZ */
+ char FlowInfo[4]; /* Should be zero */
+ char IPv6Address[16];
+ char ScopeId[4]; /* Should be zero */
+ char Reserved[100];
+ } sockaddr_in6;
+ } Buffer; /* 128 bytes */
+} __packed;
+
 #define RSS_CAPABLE 0x00000001
 #define RDMA_CAPABLE 0x00000002

@@ -564,11 +584,18 @@ struct network_interface_info_ioctl_rsp {
  __le32 Capability; /* RSS or RDMA Capable */
  __le32 Reserved;
  __le64 LinkSpeed;
- char SockAddr_Storage[128];
+ struct SockAddr_Storage saddr;
 } __packed;

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
@@ -584,7 +611,7 @@ struct smb2_ioctl_req {
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

--001a11333610f348a704e831c3b1
Content-Type: application/octet-stream;
	name="0001-CIFS-Allow-setting-per-file-compression-via-SMB3.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Allow-setting-per-file-compression-via-SMB3.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmiizkyk0

RnJvbSAwNTM4Y2VlNTNhNzAxYmM3ODhjM2YzZmYyYTg2NmQzODY5ZGZjZDVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCA3IE9jdCAyMDEzIDIxOjM3OjIxIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gW0NJRlNd
IEFsbG93IHNldHRpbmcgcGVyLWZpbGUgY29tcHJlc3Npb24gdmlhIFNNQjMKCkFsbG93IGNpZnMv
c21iMi9zbWIzIHRvIHJldHVybiB3aGV0aGVyIG9yIG5vdCBhIGZpbGUgaXMgY29tcHJlc3NlZAp2
aWEgbHNhdHRyLCBhbmQgYWxsb3cgU01CMyB0byBzZXQgdGhlIHBlci1maWxlIGNvbXByZXNzaW9u
IGZsYWcKKCJjaGF0dHIgK2MgZmlsZW5hbWUiIG9uIGFuIHNtYjMgbW91bnQpLgoKV2luZG93cyB1
c2VycyBvZnRlbiBzZXQgdGhlIGNvbXByZXNzZWQgZmxhZyAoaXQgY2FuIGJlCmRvbmUgZnJvbSB0
aGUgZGVza3RvcCBhbmQgZmlsZSBtYW5hZ2VyKS4gIERhdmlkIERpc3NlbGRvcnAKaGFzIHBhdGNo
ZXMgdG8gU2FtYmEgc2VydmVyIHRvIHN1cHBvcnQgdGhpcyAoYXQgbGVhc3Qgb24gYnRyZnMpCndo
aWNoIGFyZSBjb21wbGVtZW50YXJ5IHRvIHRoaXMuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KLS0tCiBmcy9jaWZzL2NpZnNnbG9iLmggIHwgIDIgKysK
IGZzL2NpZnMvaW9jdGwuYyAgICAgfCA1OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLQogZnMvY2lmcy9zbWIyb3BzLmMgICB8ICA5ICsrKysrKysr
CiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgMzMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
CiBmcy9jaWZzL3NtYjJwZHUuaCAgIHwgMzEgKysrKysrKysrKysrKysrKysrKysrKysrKystLQog
ZnMvY2lmcy9zbWIycHJvdG8uaCB8ICAyICsrCiA2IGZpbGVzIGNoYW5nZWQsIDExNCBpbnNlcnRp
b25zKCspLCAyMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmgg
Yi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggNTJiNmY2Yy4uMDZlODk0NyAxMDA2NDQKLS0tIGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMjc4LDYgKzI3
OCw4IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHsKIAkvKiBzZXQgYXR0cmlidXRl
cyAqLwogCWludCAoKnNldF9maWxlX2luZm8pKHN0cnVjdCBpbm9kZSAqLCBjb25zdCBjaGFyICos
IEZJTEVfQkFTSUNfSU5GTyAqLAogCQkJICAgICBjb25zdCB1bnNpZ25lZCBpbnQpOworCWludCAo
KnNldF9jb21wcmVzc2lvbikoY29uc3QgdW5zaWduZWQgaW50LCBzdHJ1Y3QgY2lmc190Y29uICos
CisJCQkgICAgICAgc3RydWN0IGNpZnNGaWxlSW5mbyAqKTsKIAkvKiBjaGVjayBpZiB3ZSBjYW4g
c2VuZCBhbiBlY2hvIG9yIG5vciAqLwogCWJvb2wgKCpjYW5fZWNobykoc3RydWN0IFRDUF9TZXJ2
ZXJfSW5mbyAqKTsKIAkvKiBzZW5kIGVjaG8gcmVxdWVzdCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lm
cy9pb2N0bC5jIGIvZnMvY2lmcy9pb2N0bC5jCmluZGV4IDNlMDg0NTUuLjRhNzQyMzYgMTAwNjQ0
Ci0tLSBhL2ZzL2NpZnMvaW9jdGwuYworKysgYi9mcy9jaWZzL2lvY3RsLmMKQEAgLTMsNyArMyw3
IEBACiAgKgogICogICB2ZnMgb3BlcmF0aW9ucyB0aGF0IGRlYWwgd2l0aCBpbyBjb250cm9sCiAg
KgotICogICBDb3B5cmlnaHQgKEMpIEludGVybmF0aW9uYWwgQnVzaW5lc3MgTWFjaGluZXMgIENv
cnAuLCAyMDA1LDIwMDcKKyAqICAgQ29weXJpZ2h0IChDKSBJbnRlcm5hdGlvbmFsIEJ1c2luZXNz
IE1hY2hpbmVzICBDb3JwLiwgMjAwNSwyMDEzCiAgKiAgIEF1dGhvcihzKTogU3RldmUgRnJlbmNo
IChzZnJlbmNoQHVzLmlibS5jb20pCiAgKgogICogICBUaGlzIGxpYnJhcnkgaXMgZnJlZSBzb2Z0
d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQpAQCAtMjIsNiArMjIs
MTAgQEAKICAqLwogCiAjaW5jbHVkZSA8bGludXgvZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9tb3Vu
dC5oPgorI2luY2x1ZGUgPGxpbnV4L2ZpbGUuaD4KKyNpbmNsdWRlIDxsaW51eC9tbS5oPgorI2lu
Y2x1ZGUgPGxpbnV4L3BhZ2VtYXAuaD4KICNpbmNsdWRlICJjaWZzcGR1LmgiCiAjaW5jbHVkZSAi
Y2lmc2dsb2IuaCIKICNpbmNsdWRlICJjaWZzcHJvdG8uaCIKQEAgLTM0LDEzICszOCwxMSBAQCBs
b25nIGNpZnNfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLCB1bnNpZ25lZCBpbnQgY29tbWFuZCwg
dW5zaWduZWQgbG9uZyBhcmcpCiAJaW50IHJjID0gLUVOT1RUWTsgLyogc3RyYW5nZSBlcnJvciAt
IGJ1dCB0aGUgcHJlY2VkZW50ICovCiAJdW5zaWduZWQgaW50IHhpZDsKIAlzdHJ1Y3QgY2lmc19z
Yl9pbmZvICpjaWZzX3NiOwotI2lmZGVmIENPTkZJR19DSUZTX1BPU0lYCiAJc3RydWN0IGNpZnNG
aWxlSW5mbyAqcFNNQkZpbGUgPSBmaWxlcC0+cHJpdmF0ZV9kYXRhOwogCXN0cnVjdCBjaWZzX3Rj
b24gKnRjb247CiAJX191NjQJRXh0QXR0ckJpdHMgPSAwOwogCV9fdTY0CUV4dEF0dHJNYXNrID0g
MDsKIAlfX3U2NCAgIGNhcHM7Ci0jZW5kaWYgLyogQ09ORklHX0NJRlNfUE9TSVggKi8KIAogCXhp
ZCA9IGdldF94aWQoKTsKIApAQCAtNDksMTIgKzUxLDEyIEBAIGxvbmcgY2lmc19pb2N0bChzdHJ1
Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGludCBjb21tYW5kLCB1bnNpZ25lZCBsb25nIGFyZykK
IAljaWZzX3NiID0gQ0lGU19TQihpbm9kZS0+aV9zYik7CiAKIAlzd2l0Y2ggKGNvbW1hbmQpIHsK
LSNpZmRlZiBDT05GSUdfQ0lGU19QT1NJWAogCQljYXNlIEZTX0lPQ19HRVRGTEFHUzoKIAkJCWlm
IChwU01CRmlsZSA9PSBOVUxMKQogCQkJCWJyZWFrOwogCQkJdGNvbiA9IHRsaW5rX3Rjb24ocFNN
QkZpbGUtPnRsaW5rKTsKIAkJCWNhcHMgPSBsZTY0X3RvX2NwdSh0Y29uLT5mc1VuaXhJbmZvLkNh
cGFiaWxpdHkpOworI2lmZGVmIENPTkZJR19DSUZTX1BPU0lYCiAJCQlpZiAoQ0lGU19VTklYX0VY
VEFUVFJfQ0FQICYgY2FwcykgewogCQkJCXJjID0gQ0lGU0dldEV4dEF0dHIoeGlkLCB0Y29uLAog
CQkJCQkJICAgIHBTTUJGaWxlLT5maWQubmV0ZmlkLApAQCAtNjMsMjkgKzY1LDUwIEBAIGxvbmcg
Y2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGludCBjb21tYW5kLCB1bnNp
Z25lZCBsb25nIGFyZykKIAkJCQkJcmMgPSBwdXRfdXNlcihFeHRBdHRyQml0cyAmCiAJCQkJCQlG
U19GTF9VU0VSX1ZJU0lCTEUsCiAJCQkJCQkoaW50IF9fdXNlciAqKWFyZyk7CisJCQkJaWYgKHJj
ICE9IEVPUE5PVFNVUFApCisJCQkJCWJyZWFrOworCQkJfQorI2VuZGlmIC8qIENPTkZJR19DSUZT
X1BPU0lYICovCisJCQlyYyA9IDA7CisJCQlpZiAoQ0lGU19JKGlub2RlKS0+Y2lmc0F0dHJzICYg
QVRUUl9DT01QUkVTU0VEKSB7CisJCQkJLyogYWRkIGluIHRoZSBjb21wcmVzc2VkIGJpdCAqLwor
CQkJCUV4dEF0dHJCaXRzID0gRlNfQ09NUFJfRkw7CisJCQkJcmMgPSBwdXRfdXNlcihFeHRBdHRy
Qml0cyAmIEZTX0ZMX1VTRVJfVklTSUJMRSwKKwkJCQkJICAgICAgKGludCBfX3VzZXIgKilhcmcp
OwogCQkJfQogCQkJYnJlYWs7Ci0KIAkJY2FzZSBGU19JT0NfU0VURkxBR1M6CiAJCQlpZiAocFNN
QkZpbGUgPT0gTlVMTCkKIAkJCQlicmVhazsKIAkJCXRjb24gPSB0bGlua190Y29uKHBTTUJGaWxl
LT50bGluayk7CiAJCQljYXBzID0gbGU2NF90b19jcHUodGNvbi0+ZnNVbml4SW5mby5DYXBhYmls
aXR5KTsKLQkJCWlmIChDSUZTX1VOSVhfRVhUQVRUUl9DQVAgJiBjYXBzKSB7Ci0JCQkJaWYgKGdl
dF91c2VyKEV4dEF0dHJCaXRzLCAoaW50IF9fdXNlciAqKWFyZykpIHsKLQkJCQkJcmMgPSAtRUZB
VUxUOwotCQkJCQlicmVhazsKLQkJCQl9Ci0JCQkJLyoKLQkJCQkgKiByYyA9IENJRlNHZXRFeHRB
dHRyKHhpZCwgdGNvbiwKLQkJCQkgKgkJICAgICAgIHBTTUJGaWxlLT5maWQubmV0ZmlkLAotCQkJ
CSAqCQkgICAgICAgZXh0QXR0ckJpdHMsCi0JCQkJICoJCSAgICAgICAmRXh0QXR0ck1hc2spOwot
CQkJCSAqLworCisJCQlpZiAoZ2V0X3VzZXIoRXh0QXR0ckJpdHMsIChpbnQgX191c2VyICopYXJn
KSkgeworCQkJCXJjID0gLUVGQVVMVDsKKwkJCQlicmVhazsKKwkJCX0KKworCQkJLyoKKwkJCSAq
IGlmIChDSUZTX1VOSVhfRVhUQVRUUl9DQVAgJiBjYXBzKQorCQkJICoJcmMgPSBDSUZTU2V0RXh0
QXR0cih4aWQsIHRjb24sCisJCQkgKgkJICAgICAgIHBTTUJGaWxlLT5maWQubmV0ZmlkLAorCQkJ
ICoJCSAgICAgICBleHRBdHRyQml0cywKKwkJCSAqCQkgICAgICAgJkV4dEF0dHJNYXNrKTsKKwkJ
CSAqIGlmIChyYyAhPSBFT1BOT1RTVVBQKQorCQkJICoJYnJlYWs7CisJCQkgKi8KKworCQkJLyog
Q3VycmVudGx5IG9ubHkgZmxhZyB3ZSBjYW4gc2V0IGlzIGNvbXByZXNzZWQgZmxhZyAqLworCQkJ
aWYgKChFeHRBdHRyQml0cyAmIEZTX0NPTVBSX0ZMKSA9PSAwKQorCQkJCWJyZWFrOworCisJCQkv
KiBUcnkgdG8gc2V0IGNvbXByZXNzIGZsYWcgKi8KKwkJCWlmICh0Y29uLT5zZXMtPnNlcnZlci0+
b3BzLT5zZXRfY29tcHJlc3Npb24pIHsKKwkJCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMt
PnNldF9jb21wcmVzc2lvbigKKwkJCQkJCQl4aWQsIHRjb24sIHBTTUJGaWxlKTsKKwkJCQljaWZz
X2RiZyhGWUksICJzZXQgY29tcHJlc3MgZmxhZyByYyAlZFxuIiwgcmMpOwogCQkJfQotCQkJY2lm
c19kYmcoRllJLCAic2V0IGZsYWdzIG5vdCBpbXBsZW1lbnRlZCB5ZXRcbiIpOwogCQkJYnJlYWs7
Ci0jZW5kaWYgLyogQ09ORklHX0NJRlNfUE9TSVggKi8KIAkJZGVmYXVsdDoKIAkJCWNpZnNfZGJn
KEZZSSwgInVuc3VwcG9ydGVkIGlvY3RsXG4iKTsKIAkJCWJyZWFrOwpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCA4NjFiMzMyLi42OTJmYjY1
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpA
QCAtNDQ2LDYgKzQ0NiwxNCBAQCBzbWIyX3NldF9maWxlX3NpemUoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIH0KIAogc3RhdGljIGludAorc21iMl9zZXRf
Y29tcHJlc3Npb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKKwkJICAgc3RydWN0IGNpZnNGaWxlSW5mbyAqY2ZpbGUpCit7CisJcmV0dXJuIFNNQjJfc2V0
X2NvbXByZXNzaW9uKHhpZCwgdGNvbiwgY2ZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJCSAg
ICBjZmlsZS0+ZmlkLnZvbGF0aWxlX2ZpZCk7Cit9CisKK3N0YXRpYyBpbnQKIHNtYjJfcXVlcnlf
ZGlyX2ZpcnN0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CiAJCSAgICAgY29uc3QgY2hhciAqcGF0aCwgc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwK
IAkJICAgICBzdHJ1Y3QgY2lmc19maWQgKmZpZCwgX191MTYgc2VhcmNoX2ZsYWdzLApAQCAtMTAx
Nyw2ICsxMDI1LDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3BlcmF0
aW9ucyA9IHsKIAkuc2V0X3BhdGhfc2l6ZSA9IHNtYjJfc2V0X3BhdGhfc2l6ZSwKIAkuc2V0X2Zp
bGVfc2l6ZSA9IHNtYjJfc2V0X2ZpbGVfc2l6ZSwKIAkuc2V0X2ZpbGVfaW5mbyA9IHNtYjJfc2V0
X2ZpbGVfaW5mbywKKwkuc2V0X2NvbXByZXNzaW9uID0gc21iMl9zZXRfY29tcHJlc3Npb24sCiAJ
Lm1rZGlyID0gc21iMl9ta2RpciwKIAkubWtkaXJfc2V0aW5mbyA9IHNtYjJfbWtkaXJfc2V0aW5m
bywKIAkucm1kaXIgPSBzbWIyX3JtZGlyLApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMg
Yi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBlZGNjYjUyLi5mYjE5YWQ4IDEwMDY0NAotLS0gYS9m
cy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpAQCAtMTEzNyw2ICsxMTM3
LDcgQEAgU01CMl9pb2N0bChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLCB1NjQgcGVyc2lzdGVudF9maWQsCiAKIAljaWZzX2RiZyhGWUksICJTTUIyIElPQ1RM
XG4iKTsKIAorCSpvdXRfZGF0YSA9IE5VTEw7CiAJLyogemVybyBvdXQgcmV0dXJuZWQgZGF0YSBs
ZW4sIGluIGNhc2Ugb2YgZXJyb3IgKi8KIAlpZiAocGxlbikKIAkJKnBsZW4gPSAwOwpAQCAtMTE4
MywxMCArMTE4NCwxMiBAQCBTTUIyX2lvY3RsKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sIHU2NCBwZXJzaXN0ZW50X2ZpZCwKIAogCWlvdlswXS5pb3ZfYmFz
ZSA9IChjaGFyICopcmVxOwogCS8qIDQgZm9yIHJmYzEwMDIgbGVuZ3RoIGZpZWxkICovCi0JaW92
WzBdLmlvdl9sZW4gPSBnZXRfcmZjMTAwMl9sZW5ndGgocmVxKSArIDQ7CisJLyogLTEgc2luY2Ug
bGFzdCBieXRlIGlzIGJ1ZlswXSB3aGljaCBpcyBzZW50IGluIGlvdlsxXSBvciBub3QgYXQgYWxs
ICovCisJaW92WzBdLmlvdl9sZW4gPSBnZXRfcmZjMTAwMl9sZW5ndGgocmVxKSArIDQgLSAxOwog
CisJLyogLTEgc2luY2UgbGFzdCBieXRlIGlzIGJ1ZlswXSB3aGljaCB3YXMgY291bnRlZCBpbiBz
bWIyX2J1Zl9sZW4gKi8KIAlpZiAoaW5kYXRhbGVuKQotCQlpbmNfcmZjMTAwMV9sZW4ocmVxLCBp
bmRhdGFsZW4pOworCQlpbmNfcmZjMTAwMV9sZW4ocmVxLCBpbmRhdGFsZW4gLSAxKTsKIAogCXJj
ID0gU2VuZFJlY2VpdmUyKHhpZCwgc2VzLCBpb3YsIG51bV9pb3ZlY3MsICZyZXNwX2J1ZnR5cGUs
IDApOwogCXJzcCA9IChzdHJ1Y3Qgc21iMl9pb2N0bF9yc3AgKilpb3ZbMF0uaW92X2Jhc2U7CkBA
IC0xMjM0LDYgKzEyMzcsMzIgQEAgaW9jdGxfZXhpdDoKIAlyZXR1cm4gcmM7CiB9CiAKKy8qCisg
KiAgIEluZGl2aWR1YWwgY2FsbGVycyB0byBpb2N0bCB3b3JrZXIgZnVuY3Rpb24gZm9sbG93Cisg
Ki8KKworaW50CitTTUIyX3NldF9jb21wcmVzc2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLAorCQkgICAgIHU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZv
bGF0aWxlX2ZpZCkKK3sKKwlpbnQgcmM7CisJY2hhciAqcmVzX2tleSA9IE5VTEw7CisJc3RydWN0
ICBjb21wcmVzc19pb2N0bCBmc2N0bF9pbnB1dDsKKwljaGFyICpyZXRfZGF0YSA9IE5VTEw7CisK
Kwlmc2N0bF9pbnB1dC5Db21wcmVzc2lvblN0YXRlID0gY3B1X3RvX2xlMTYoQ09NUFJFU1NJT05f
Rk9STUFUX0RFRkFVTFQpOworCisJcmMgPSBTTUIyX2lvY3RsKHhpZCwgdGNvbiwgcGVyc2lzdGVu
dF9maWQsIHZvbGF0aWxlX2ZpZCwKKwkJCUZTQ1RMX1NFVF9DT01QUkVTU0lPTiwgdHJ1ZSAvKiBp
c19mc2N0bCAqLywKKwkJCShjaGFyICopJmZzY3RsX2lucHV0IC8qIGRhdGEgaW5wdXQgKi8sCisJ
CQkyIC8qIGluIGRhdGEgbGVuICovLCAmcmV0X2RhdGEgLyogb3V0IGRhdGEgKi8sIE5VTEwpOwor
CisJY2lmc19kYmcoVkZTLCAic2V0IGNvbXByZXNzaW9uIHJjICVkXG4iLCByYyk7IC8qIEZJWE1F
ICovCisJa2ZyZWUocmVzX2tleSk7CisKKwlyZXR1cm4gcmM7Cit9CisKIGludAogU01CMl9jbG9z
ZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCSAgIHU2
NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxlX2ZpZCkKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
c21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggYjgzZDAxMS4uN2NlMmUzZiAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIycGR1LmgKQEAgLTU1
NSw2ICs1NTUsMjYgQEAgc3RydWN0IHZhbGlkYXRlX25lZ290aWF0ZV9pbmZvIHsKIAlfX2xlMTYg
RGlhbGVjdFsxXTsKIH0gX19wYWNrZWQ7CiAKKyNkZWZpbmUgSW50ZXJOZXR3b3JrCV9fY29uc3Rh
bnRfY3B1X3RvX2xlMTYoMHgwMDAyKQorI2RlZmluZSBJbnRlck5ldHdvcms2CV9fY29uc3RhbnRf
Y3B1X3RvX2xlMTYoMHgwMDE3KQorc3RydWN0IFNvY2tBZGRyX1N0b3JhZ2UgeworCV9fbGUxNiBG
YW1pbHk7CisJdW5pb24geworCQlzdHJ1Y3QgeworCQkJX19sZTE2CVBvcnQ7IC8qIE1CWiAqLwor
CQkJY2hhcglJUHY0QWRkcmVzc1s0XTsKKwkJCWNoYXIJUmVzZXJ2ZWRbMTIwXTsKKwkJfSBzb2Nr
YWRkcl9pbjsKKwkJc3RydWN0IHsKKwkJCV9fbGUxNglQb3J0OyAvKiBNQlogKi8KKwkJCWNoYXIJ
Rmxvd0luZm9bNF07IC8qIFNob3VsZCBiZSB6ZXJvICovCisJCQljaGFyCUlQdjZBZGRyZXNzWzE2
XTsKKwkJCWNoYXIJU2NvcGVJZFs0XTsgLyogU2hvdWxkIGJlIHplcm8gKi8KKwkJCWNoYXIJUmVz
ZXJ2ZWRbMTAwXTsKKwkJfSBzb2NrYWRkcl9pbjY7CisJfSBCdWZmZXI7IC8qIDEyOCBieXRlcyAq
LworfSBfX3BhY2tlZDsKKwogI2RlZmluZSBSU1NfQ0FQQUJMRQkweDAwMDAwMDAxCiAjZGVmaW5l
IFJETUFfQ0FQQUJMRQkweDAwMDAwMDAyCiAKQEAgLTU2NCwxMSArNTg0LDE4IEBAIHN0cnVjdCBu
ZXR3b3JrX2ludGVyZmFjZV9pbmZvX2lvY3RsX3JzcCB7CiAJX19sZTMyIENhcGFiaWxpdHk7IC8q
IFJTUyBvciBSRE1BIENhcGFibGUgKi8KIAlfX2xlMzIgUmVzZXJ2ZWQ7CiAJX19sZTY0IExpbmtT
cGVlZDsKLQljaGFyCVNvY2tBZGRyX1N0b3JhZ2VbMTI4XTsKKwlzdHJ1Y3QgU29ja0FkZHJfU3Rv
cmFnZSBzYWRkcjsKIH0gX19wYWNrZWQ7CiAKICNkZWZpbmUgTk9fRklMRV9JRCAweEZGRkZGRkZG
RkZGRkZGRkZVTEwgLyogZ2VuZXJhbCBpb2N0bHMgdG8gc3J2IG5vdCB0byBmaWxlICovCiAKK3N0
cnVjdCBjb21wcmVzc19pb2N0bCB7CisJX19sZTE2IENvbXByZXNzaW9uU3RhdGU7Cit9IF9fcGFj
a2VkOworCisjZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1BVF9OT05FCQkweDAwMDAKKyNkZWZpbmUg
Q09NUFJFU1NJT05fRk9STUFUX0RFRkFVTFQJMHgwMDAxCisjZGVmaW5lIENPTVBSRVNTSU9OX0ZP
Uk1BVF9MWk5UMQkweDAwMDIKIHN0cnVjdCBzbWIyX2lvY3RsX3JlcSB7CiAJc3RydWN0IHNtYjJf
aGRyIGhkcjsKIAlfX2xlMTYgU3RydWN0dXJlU2l6ZTsJLyogTXVzdCBiZSA1NyAqLwpAQCAtNTg0
LDcgKzYxMSw3IEBAIHN0cnVjdCBzbWIyX2lvY3RsX3JlcSB7CiAJX19sZTMyIE1heE91dHB1dFJl
c3BvbnNlOwogCV9fbGUzMiBGbGFnczsKIAlfX3UzMiAgUmVzZXJ2ZWQyOwotCWNoYXIgICBCdWZm
ZXJbMF07CisJX191OCAgIEJ1ZmZlclswXTsKIH0gX19wYWNrZWQ7CiAKIHN0cnVjdCBzbWIyX2lv
Y3RsX3JzcCB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwcm90by5oIGIvZnMvY2lmcy9zbWIy
cHJvdG8uaAppbmRleCBlM2ZiNDgwLi4zY2YyMmUzIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJw
cm90by5oCisrKyBiL2ZzL2NpZnMvc21iMnByb3RvLmgKQEAgLTE0Miw2ICsxNDIsOCBAQCBleHRl
cm4gaW50IFNNQjJfc2V0X2VvZihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190
Y29uICp0Y29uLAogZXh0ZXJuIGludCBTTUIyX3NldF9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4
aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQg
dm9sYXRpbGVfZmlkLAogCQkJIEZJTEVfQkFTSUNfSU5GTyAqYnVmKTsKK2V4dGVybiBpbnQgU01C
Ml9zZXRfY29tcHJlc3Npb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwKKwkJCQl1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQpOwogZXh0
ZXJuIGludCBTTUIyX29wbG9ja19icmVhayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkJICAgICBjb25zdCB1NjQgcGVyc2lzdGVudF9maWQsIGNvbnN0
IHU2NCB2b2xhdGlsZV9maWQsCiAJCQkgICAgIGNvbnN0IF9fdTggb3Bsb2NrX2xldmVsKTsKLS0g
CjEuNy4xMS43Cgo=
--001a11333610f348a704e831c3b1--
