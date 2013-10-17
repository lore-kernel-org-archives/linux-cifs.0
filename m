From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (unknown)
Date: Thu, 17 Oct 2013 15:35:20 -0500
Message-ID: <CAH2r5msKBSykRiXRfXOE_wrRHjkf_FBKzvaiv6EdKt0uzDFSKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bacc796ae027404e8f5c131
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7bacc796ae027404e8f5c131
Content-Type: text/plain; charset=ISO-8859-1

>From 6b6503530681165dccf2ce59eb631542ec58288c Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Thu, 17 Oct 2013 14:16:33 -0500
Subject: [PATCH] [CIFS] SMB2/SMB3 Copy offload support (refcopy) phase 1

This first patch adds the ability for us to do a server side copy
(ie fast copy offloaded to the server)

"cp --reflink"

of one file to another located on the same server.  This
is much faster than traditional copy (which requires
reading and writing over the network and extra
memcpys).

This first version is not going to copy
files larger than about 1MB (to Samba) until I add
support for multiple chunks and for autoconfiguring
the chunksize.  To work to Samba it requires Samba 4.1 or later and
David Disseldorp's recently posted small Samba server patch.
It does work to Windows.

It includes:
1) processing of the ioctl (IOC_CLONE, similar to btrfs)
2) marshalling and sending the SMB2/SMB3 fsctl over the network
3) simple parsing of the response

It does not include yet (these will be in followon patches to come soon):
1) support for multiple chunks
2) support for autoconfiguring and remembering the chunksize
3) Support for the older style copychunk which Samba 4.1 server supports
(because this would require read permission on the target file, which
cp does not give you, apparently per-posix).  Use of COPYCHUNK to
Samba 4.1 server (pre-david's patch) may require
a distinct tool (other than cp) and another (trivial) ioctl to implement.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h |   3 ++
 fs/cifs/ioctl.c    | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2ops.c  |  82 ++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h  |  15 +++++++-
 4 files changed, 202 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index de3e3e0..a67cf12 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -381,6 +381,9 @@ struct smb_version_operations {
  char * (*create_lease_buf)(u8 *, u8);
  /* parse lease context buffer and return oplock/epoch info */
  __u8 (*parse_lease_buf)(void *, unsigned int *);
+ int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
+ struct cifsFileInfo *target_file, u64 src_off, u64 len,
+ u64 dest_off);
 };

 struct smb_version_values {
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index ba54bf6..d353f6c 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -22,12 +22,112 @@
  */

 #include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/mount.h>
+#include <linux/mm.h>
+#include <linux/pagemap.h>
+#include <linux/btrfs.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"

+static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
+ unsigned long srcfd, u64 off, u64 len, u64 destoff)
+{
+ int rc;
+ struct cifsFileInfo *smb_file_target = dst_file->private_data;
+ struct inode *target_inode = file_inode(dst_file);
+ struct cifs_tcon *target_tcon;
+ struct fd src_file;
+ struct cifsFileInfo *smb_file_src;
+ struct inode *src_inode;
+ struct cifs_tcon *src_tcon;
+
+ cifs_dbg(FYI, "ioctl clone range\n");
+ /* the destination must be opened for writing */
+ if (!(dst_file->f_mode & FMODE_WRITE)) {
+ cifs_dbg(FYI, "file target not open for write\n");
+ return -EINVAL;
+ }
+
+ /* check if target volume is readonly and take reference */
+ rc = mnt_want_write_file(dst_file);
+ if (rc) {
+ cifs_dbg(FYI, "mnt_want_write failed with rc %d\n", rc);
+ return rc;
+ }
+
+ src_file = fdget(srcfd);
+ if (!src_file.file) {
+ rc = -EBADF;
+ goto out_drop_write;
+ }
+
+ if ((!src_file.file->private_data) || (!dst_file->private_data)) {
+ rc = -EBADF;
+ cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
+ goto out_fput;
+ }
+
+ rc = -EXDEV;
+ smb_file_target = dst_file->private_data;
+ smb_file_src = src_file.file->private_data;
+ src_tcon = tlink_tcon(smb_file_src->tlink);
+ target_tcon = tlink_tcon(smb_file_target->tlink);
+
+ /* check if source and target are on same tree connection */
+ if (src_tcon != target_tcon) {
+ cifs_dbg(VFS, "file copy src and target on different volume\n");
+ goto out_fput;
+ }
+
+ src_inode = src_file.file->f_dentry->d_inode;
+
+ /* Note: cifs case is easier than btrfs since server responsible for */
+ /* checks for proper open modes and file type and if it wants */
+ /* server could even support copy of range where source = target */
+
+ /* so we do not deadlock racing two ioctls on same files */
+ /* btrfs does a similar check */
+ if (target_inode < src_inode) {
+ mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_PARENT);
+ mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_CHILD);
+ } else {
+ mutex_lock_nested(&src_inode->i_mutex, I_MUTEX_PARENT);
+ mutex_lock_nested(&target_inode->i_mutex, I_MUTEX_CHILD);
+ }
+
+ /* determine range to clone */
+ rc = -EINVAL;
+ if (off + len > src_inode->i_size || off + len < off)
+ goto out_unlock;
+ if (len == 0)
+ len = src_inode->i_size - off;
+
+ cifs_dbg(FYI, "about to flush pages\n");
+ /* should we flush first and last page first */
+ truncate_inode_pages_range(&target_inode->i_data, destoff,
+   PAGE_CACHE_ALIGN(destoff + len)-1);
+
+ if (target_tcon->ses->server->ops->clone_range)
+ rc = target_tcon->ses->server->ops->clone_range(xid,
+ smb_file_src, smb_file_target, off, len, destoff);
+
+ /* force revalidate of size and timestamps of target file now
+   that target is updated on the server */
+ CIFS_I(target_inode)->time = 0;
+out_unlock:
+ mutex_unlock(&src_inode->i_mutex);
+ mutex_unlock(&target_inode->i_mutex);
+out_fput:
+ fdput(src_file);
+out_drop_write:
+ mnt_drop_write_file(dst_file);
+ return rc;
+}
+
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
  struct inode *inode = file_inode(filep);
@@ -105,6 +205,9 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
  cifs_dbg(FYI, "set compress flag rc %d\n", rc);
  }
  break;
+ case BTRFS_IOC_CLONE:
+ rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
+ break;
  default:
  cifs_dbg(FYI, "unsupported ioctl\n");
  break;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c571be8..11dde4b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -494,6 +494,85 @@ smb2_close_file(const unsigned int xid, struct
cifs_tcon *tcon,
 }

 static int
+SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
+     u64 persistent_fid, u64 volatile_fid,
+     struct copychunk_ioctl *pcchunk)
+{
+ int rc;
+ unsigned int ret_data_len;
+ struct resume_key_req *res_key;
+
+ rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
+ FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
+ NULL, 0 /* no input */,
+ (char **)&res_key, &ret_data_len);
+
+ if (rc) {
+ cifs_dbg(VFS, "refcpy ioctl error %d getting resume key\n", rc);
+ goto req_res_key_exit;
+ }
+ if (ret_data_len < sizeof(struct resume_key_req)) {
+ cifs_dbg(VFS, "Invalid refcopy resume key length\n");
+ rc = -EINVAL;
+ goto req_res_key_exit;
+ }
+ memcpy(pcchunk->SourceKey, res_key->ResumeKey, COPY_CHUNK_RES_KEY_SIZE);
+
+req_res_key_exit:
+ kfree(res_key);
+ return rc;
+}
+
+static int
+smb2_clone_range(const unsigned int xid,
+ struct cifsFileInfo *srcfile,
+ struct cifsFileInfo *trgtfile, u64 src_off,
+ u64 len, u64 dest_off)
+{
+ int rc;
+ unsigned int ret_data_len;
+ struct copychunk_ioctl *pcchunk;
+ char *retbuf = NULL;
+
+ pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
+
+ if (pcchunk == NULL)
+ return -ENOMEM;
+
+ cifs_dbg(FYI, "in smb2_clone_range - about to call request res key\n");
+ /* Request a key from the server to identify the source of the copy */
+ rc = SMB2_request_res_key(xid, tlink_tcon(srcfile->tlink),
+ srcfile->fid.persistent_fid,
+ srcfile->fid.volatile_fid, pcchunk);
+
+ /* Note: request_res_key sets res_key null only if rc !=0 */
+ if (rc)
+ return rc;
+
+ /* For now array only one chunk long, will make more flexible later */
+ pcchunk->ChunkCount = __constant_cpu_to_le32(1);
+ pcchunk->Reserved = 0;
+ pcchunk->SourceOffset = cpu_to_le64(src_off);
+ pcchunk->TargetOffset = cpu_to_le64(dest_off);
+ pcchunk->Length = cpu_to_le32(len);
+ pcchunk->Reserved2 = 0;
+
+ /* Request that server copy to target from src file identified by key */
+ rc = SMB2_ioctl(xid, tlink_tcon(trgtfile->tlink),
+ trgtfile->fid.persistent_fid,
+ trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
+ true /* is_fsctl */, (char *)pcchunk,
+ sizeof(struct copychunk_ioctl), &retbuf, &ret_data_len);
+
+ /* BB need to special case rc = EINVAL to alter chunk size */
+
+ cifs_dbg(FYI, "rc %d data length out %d\n", rc, ret_data_len);
+
+ kfree(pcchunk);
+ return rc;
+}
+
+static int
 smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
  struct cifs_fid *fid)
 {
@@ -1017,6 +1096,7 @@ struct smb_version_operations smb20_operations = {
  .set_oplock_level = smb2_set_oplock_level,
  .create_lease_buf = smb2_create_lease_buf,
  .parse_lease_buf = smb2_parse_lease_buf,
+ .clone_range = smb2_clone_range,
 };

 struct smb_version_operations smb21_operations = {
@@ -1090,6 +1170,7 @@ struct smb_version_operations smb21_operations = {
  .set_oplock_level = smb21_set_oplock_level,
  .create_lease_buf = smb2_create_lease_buf,
  .parse_lease_buf = smb2_parse_lease_buf,
+ .clone_range = smb2_clone_range,
 };

 struct smb_version_operations smb30_operations = {
@@ -1165,6 +1246,7 @@ struct smb_version_operations smb30_operations = {
  .set_oplock_level = smb3_set_oplock_level,
  .create_lease_buf = smb3_create_lease_buf,
  .parse_lease_buf = smb3_parse_lease_buf,
+ .clone_range = smb2_clone_range,
 };

 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 6183b1b..b50a129 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -534,9 +534,16 @@ struct create_durable {
  } Data;
 } __packed;

+#define COPY_CHUNK_RES_KEY_SIZE 24
+struct resume_key_req {
+ char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
+ __le32 ContextLength; /* MBZ */
+ char Context[0]; /* ignored, Windows sets to 4 bytes of zero */
+} __packed;
+
 /* this goes in the ioctl buffer when doing a copychunk request */
 struct copychunk_ioctl {
- char SourceKey[24];
+ char SourceKey[COPY_CHUNK_RES_KEY_SIZE];
  __le32 ChunkCount; /* we are only sending 1 */
  __le32 Reserved;
  /* array will only be one chunk long for us */
@@ -546,6 +553,12 @@ struct copychunk_ioctl {
  __u32 Reserved2;
 } __packed;

+struct copychunk_ioctl_rsp {
+ __le32 ChunksWritten;
+ __le32 ChunkBytesWritten;
+ __le32 TotalBytesWritten;
+} __packed;
+
 /* Response and Request are the same format */
 struct validate_negotiate_info {
  __le32 Capabilities;
-- 
1.7.11.7



-- 
Thanks,

Steve

--047d7bacc796ae027404e8f5c131
Content-Type: application/octet-stream;
	name="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-phase-1.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-phase-1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmwg6w3k0

RnJvbSA2YjY1MDM1MzA2ODExNjVkY2NmMmNlNTllYjYzMTU0MmVjNTgyODhjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVGh1LCAxNyBPY3QgMjAxMyAxNDoxNjozMyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBTTUIyL1NNQjMgQ29weSBvZmZsb2FkIHN1cHBvcnQgKHJlZmNvcHkpIHBoYXNlIDEKClRoaXMg
Zmlyc3QgcGF0Y2ggYWRkcyB0aGUgYWJpbGl0eSBmb3IgdXMgdG8gZG8gYSBzZXJ2ZXIgc2lkZSBj
b3B5CihpZSBmYXN0IGNvcHkgb2ZmbG9hZGVkIHRvIHRoZSBzZXJ2ZXIgdG8gcGVyZm9ybSwgYWth
IHJlZmNvcHkpCgoiY3AgLS1yZWZsaW5rIgoKb2Ygb25lIGZpbGUgdG8gYW5vdGhlciBsb2NhdGVk
IG9uIHRoZSBzYW1lIHNlcnZlci4gIFRoaXMKaXMgbXVjaCBmYXN0ZXIgdGhhbiB0cmFkaXRpb25h
bCBjb3B5ICh3aGljaCByZXF1aXJlcwpyZWFkaW5nIGFuZCB3cml0aW5nIG92ZXIgdGhlIG5ldHdv
cmsgYW5kIGV4dHJhCm1lbWNweXMpLgoKVGhpcyBmaXJzdCB2ZXJzaW9uIGlzIG5vdCBnb2luZyB0
byBiZSBjb3B5CmZpbGVzIGxhcmdlciB0aGFuIGFib3V0IDFNQiAodG8gU2FtYmEpIHVudGlsIEkg
YWRkCnN1cHBvcnQgZm9yIG11bHRpcGxlIGNodW5rcyBhbmQgZm9yIGF1dG9jb25maWd1cmluZwp0
aGUgY2h1bmtzaXplLgoKSXQgaW5jbHVkZXM6CjEpIHByb2Nlc3Npbmcgb2YgdGhlIGlvY3RsCjIp
IG1hcnNoYWxsaW5nIGFuZCBzZW5kaW5nIHRoZSBTTUIyL1NNQjMgZnNjdGwgb3ZlciB0aGUgbmV0
d29yawozKSBzaW1wbGUgcGFyc2luZyBvZiB0aGUgcmVzcG9uc2UKCkl0IGRvZXMgbm90IGluY2x1
ZGUgeWV0ICh0aGVzZSB3aWxsIGJlIGluIGZvbGxvd29uIHBhdGNoZXMgdG8gY29tZSBzb29uKToK
MSkgc3VwcG9ydCBmb3IgbXVsdGlwbGUgY2h1bmtzCjIpIHN1cHBvcnQgZm9yIGF1dG9jb25maWd1
cmluZyBhbmQgcmVtZW1iZXJpbmcgdGhlIGNodW5rc2l6ZQozKSBTdXBwb3J0IGZvciB0aGUgb2xk
ZXIgc3R5bGUgY29weWNodW5rIHdoaWNoIFNhbWJhIDQuMSBzZXJ2ZXIgc3VwcG9ydHMKKGJlY2F1
c2UgdGhpcyByZXF1aXJlcyB3cml0ZSBwZXJtaXNzaW9uIG9uIHRoZSB0YXJnZXQgZmlsZSwgd2hp
Y2gKY3AgZG9lcyBub3QgZ2l2ZSB5b3UsIGFwcGFyZW50bHkgcGVyLXBvc2l4KS4gIFRoaXMgbWF5
IHJlcXVpcmUKYSBkaXN0aW5jdCB0b29sIChvdGhlciB0aGFuIGNwKSBhbmQgb3RoZXIgaW9jdGwg
dG8gaW1wbGVtZW50LgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFp
bC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oIHwgICAzICsrCiBmcy9jaWZzL2lvY3RsLmMg
ICAgfCAxMDMgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysKIGZzL2NpZnMvc21iMm9wcy5jICB8ICA4MiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysKIGZzL2NpZnMvc21iMnBkdS5oICB8ICAxNSArKysrKysrLQogNCBm
aWxlcyBjaGFuZ2VkLCAyMDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRleCBkZTNlM2Uw
Li5hNjdjZjEyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIvZnMvY2lmcy9j
aWZzZ2xvYi5oCkBAIC0zODEsNiArMzgxLDkgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlv
bnMgewogCWNoYXIgKiAoKmNyZWF0ZV9sZWFzZV9idWYpKHU4ICosIHU4KTsKIAkvKiBwYXJzZSBs
ZWFzZSBjb250ZXh0IGJ1ZmZlciBhbmQgcmV0dXJuIG9wbG9jay9lcG9jaCBpbmZvICovCiAJX191
OCAoKnBhcnNlX2xlYXNlX2J1Zikodm9pZCAqLCB1bnNpZ25lZCBpbnQgKik7CisJaW50ICgqY2xv
bmVfcmFuZ2UpKGNvbnN0IHVuc2lnbmVkIGludCwgc3RydWN0IGNpZnNGaWxlSW5mbyAqc3JjX2Zp
bGUsCisJCQlzdHJ1Y3QgY2lmc0ZpbGVJbmZvICp0YXJnZXRfZmlsZSwgdTY0IHNyY19vZmYsIHU2
NCBsZW4sCisJCQl1NjQgZGVzdF9vZmYpOwogfTsKIAogc3RydWN0IHNtYl92ZXJzaW9uX3ZhbHVl
cyB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2lvY3RsLmMgYi9mcy9jaWZzL2lvY3RsLmMKaW5kZXgg
YmE1NGJmNi4uZDM1M2Y2YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pb2N0bC5jCisrKyBiL2ZzL2Np
ZnMvaW9jdGwuYwpAQCAtMjIsMTIgKzIyLDExMiBAQAogICovCiAKICNpbmNsdWRlIDxsaW51eC9m
cy5oPgorI2luY2x1ZGUgPGxpbnV4L2ZpbGUuaD4KKyNpbmNsdWRlIDxsaW51eC9tb3VudC5oPgor
I2luY2x1ZGUgPGxpbnV4L21tLmg+CisjaW5jbHVkZSA8bGludXgvcGFnZW1hcC5oPgorI2luY2x1
ZGUgPGxpbnV4L2J0cmZzLmg+CiAjaW5jbHVkZSAiY2lmc3BkdS5oIgogI2luY2x1ZGUgImNpZnNn
bG9iLmgiCiAjaW5jbHVkZSAiY2lmc3Byb3RvLmgiCiAjaW5jbHVkZSAiY2lmc19kZWJ1Zy5oIgog
I2luY2x1ZGUgImNpZnNmcy5oIgogCitzdGF0aWMgbG9uZyBjaWZzX2lvY3RsX2Nsb25lKHVuc2ln
bmVkIGludCB4aWQsIHN0cnVjdCBmaWxlICpkc3RfZmlsZSwKKwkJCXVuc2lnbmVkIGxvbmcgc3Jj
ZmQsIHU2NCBvZmYsIHU2NCBsZW4sIHU2NCBkZXN0b2ZmKQoreworCWludCByYzsKKwlzdHJ1Y3Qg
Y2lmc0ZpbGVJbmZvICpzbWJfZmlsZV90YXJnZXQgPSBkc3RfZmlsZS0+cHJpdmF0ZV9kYXRhOwor
CXN0cnVjdCBpbm9kZSAqdGFyZ2V0X2lub2RlID0gZmlsZV9pbm9kZShkc3RfZmlsZSk7CisJc3Ry
dWN0IGNpZnNfdGNvbiAqdGFyZ2V0X3Rjb247CisJc3RydWN0IGZkIHNyY19maWxlOworCXN0cnVj
dCBjaWZzRmlsZUluZm8gKnNtYl9maWxlX3NyYzsKKwlzdHJ1Y3QgaW5vZGUgKnNyY19pbm9kZTsK
KwlzdHJ1Y3QgY2lmc190Y29uICpzcmNfdGNvbjsKKworCWNpZnNfZGJnKEZZSSwgImlvY3RsIGNs
b25lIHJhbmdlXG4iKTsKKwkvKiB0aGUgZGVzdGluYXRpb24gbXVzdCBiZSBvcGVuZWQgZm9yIHdy
aXRpbmcgKi8KKwlpZiAoIShkc3RfZmlsZS0+Zl9tb2RlICYgRk1PREVfV1JJVEUpKSB7CisJCWNp
ZnNfZGJnKEZZSSwgImZpbGUgdGFyZ2V0IG5vdCBvcGVuIGZvciB3cml0ZVxuIik7CisJCXJldHVy
biAtRUlOVkFMOworCX0KKworCS8qIGNoZWNrIGlmIHRhcmdldCB2b2x1bWUgaXMgcmVhZG9ubHkg
YW5kIHRha2UgcmVmZXJlbmNlICovCisJcmMgPSBtbnRfd2FudF93cml0ZV9maWxlKGRzdF9maWxl
KTsKKwlpZiAocmMpIHsKKwkJY2lmc19kYmcoRllJLCAibW50X3dhbnRfd3JpdGUgZmFpbGVkIHdp
dGggcmMgJWRcbiIsIHJjKTsKKwkJcmV0dXJuIHJjOworCX0KKworCXNyY19maWxlID0gZmRnZXQo
c3JjZmQpOworCWlmICghc3JjX2ZpbGUuZmlsZSkgeworCQlyYyA9IC1FQkFERjsKKwkJZ290byBv
dXRfZHJvcF93cml0ZTsKKwl9CisKKwlpZiAoKCFzcmNfZmlsZS5maWxlLT5wcml2YXRlX2RhdGEp
IHx8ICghZHN0X2ZpbGUtPnByaXZhdGVfZGF0YSkpIHsKKwkJcmMgPSAtRUJBREY7CisJCWNpZnNf
ZGJnKFZGUywgIm1pc3NpbmcgY2lmc0ZpbGVJbmZvIG9uIGNvcHkgcmFuZ2Ugc3JjIGZpbGVcbiIp
OworCQlnb3RvIG91dF9mcHV0OworCX0KKworCXJjID0gLUVYREVWOworCXNtYl9maWxlX3Rhcmdl
dCA9IGRzdF9maWxlLT5wcml2YXRlX2RhdGE7CisJc21iX2ZpbGVfc3JjID0gc3JjX2ZpbGUuZmls
ZS0+cHJpdmF0ZV9kYXRhOworCXNyY190Y29uID0gdGxpbmtfdGNvbihzbWJfZmlsZV9zcmMtPnRs
aW5rKTsKKwl0YXJnZXRfdGNvbiA9IHRsaW5rX3Rjb24oc21iX2ZpbGVfdGFyZ2V0LT50bGluayk7
CisKKwkvKiBjaGVjayBpZiBzb3VyY2UgYW5kIHRhcmdldCBhcmUgb24gc2FtZSB0cmVlIGNvbm5l
Y3Rpb24gKi8KKwlpZiAoc3JjX3Rjb24gIT0gdGFyZ2V0X3Rjb24pIHsKKwkJY2lmc19kYmcoVkZT
LCAiZmlsZSBjb3B5IHNyYyBhbmQgdGFyZ2V0IG9uIGRpZmZlcmVudCB2b2x1bWVcbiIpOworCQln
b3RvIG91dF9mcHV0OworCX0KKworCXNyY19pbm9kZSA9IHNyY19maWxlLmZpbGUtPmZfZGVudHJ5
LT5kX2lub2RlOworCisJLyogTm90ZTogY2lmcyBjYXNlIGlzIGVhc2llciB0aGFuIGJ0cmZzIHNp
bmNlIHNlcnZlciByZXNwb25zaWJsZSBmb3IgKi8KKwkvKiBjaGVja3MgZm9yIHByb3BlciBvcGVu
IG1vZGVzIGFuZCBmaWxlIHR5cGUgYW5kIGlmIGl0IHdhbnRzICovCisJLyogc2VydmVyIGNvdWxk
IGV2ZW4gc3VwcG9ydCBjb3B5IG9mIHJhbmdlIHdoZXJlIHNvdXJjZSA9IHRhcmdldCAqLworCisJ
Lyogc28gd2UgZG8gbm90IGRlYWRsb2NrIHJhY2luZyB0d28gaW9jdGxzIG9uIHNhbWUgZmlsZXMg
Ki8KKwkvKiBidHJmcyBkb2VzIGEgc2ltaWxhciBjaGVjayAqLworCWlmICh0YXJnZXRfaW5vZGUg
PCBzcmNfaW5vZGUpIHsKKwkJbXV0ZXhfbG9ja19uZXN0ZWQoJnRhcmdldF9pbm9kZS0+aV9tdXRl
eCwgSV9NVVRFWF9QQVJFTlQpOworCQltdXRleF9sb2NrX25lc3RlZCgmc3JjX2lub2RlLT5pX211
dGV4LCBJX01VVEVYX0NISUxEKTsKKwl9IGVsc2UgeworCQltdXRleF9sb2NrX25lc3RlZCgmc3Jj
X2lub2RlLT5pX211dGV4LCBJX01VVEVYX1BBUkVOVCk7CisJCW11dGV4X2xvY2tfbmVzdGVkKCZ0
YXJnZXRfaW5vZGUtPmlfbXV0ZXgsIElfTVVURVhfQ0hJTEQpOworCX0KKworCS8qIGRldGVybWlu
ZSByYW5nZSB0byBjbG9uZSAqLworCXJjID0gLUVJTlZBTDsKKwlpZiAob2ZmICsgbGVuID4gc3Jj
X2lub2RlLT5pX3NpemUgfHwgb2ZmICsgbGVuIDwgb2ZmKQorCQlnb3RvIG91dF91bmxvY2s7CisJ
aWYgKGxlbiA9PSAwKQorCQlsZW4gPSBzcmNfaW5vZGUtPmlfc2l6ZSAtIG9mZjsKKworCWNpZnNf
ZGJnKEZZSSwgImFib3V0IHRvIGZsdXNoIHBhZ2VzXG4iKTsKKwkvKiBzaG91bGQgd2UgZmx1c2gg
Zmlyc3QgYW5kIGxhc3QgcGFnZSBmaXJzdCAqLworCXRydW5jYXRlX2lub2RlX3BhZ2VzX3Jhbmdl
KCZ0YXJnZXRfaW5vZGUtPmlfZGF0YSwgZGVzdG9mZiwKKwkJCQkgICBQQUdFX0NBQ0hFX0FMSUdO
KGRlc3RvZmYgKyBsZW4pLTEpOworCisJaWYgKHRhcmdldF90Y29uLT5zZXMtPnNlcnZlci0+b3Bz
LT5jbG9uZV9yYW5nZSkKKwkJcmMgPSB0YXJnZXRfdGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+Y2xv
bmVfcmFuZ2UoeGlkLAorCQkJc21iX2ZpbGVfc3JjLCBzbWJfZmlsZV90YXJnZXQsIG9mZiwgbGVu
LCBkZXN0b2ZmKTsKKworCS8qIGZvcmNlIHJldmFsaWRhdGUgb2Ygc2l6ZSBhbmQgdGltZXN0YW1w
cyBvZiB0YXJnZXQgZmlsZSBub3cKKwkgICB0aGF0IHRhcmdldCBpcyB1cGRhdGVkIG9uIHRoZSBz
ZXJ2ZXIgKi8KKwlDSUZTX0kodGFyZ2V0X2lub2RlKS0+dGltZSA9IDA7CitvdXRfdW5sb2NrOgor
CW11dGV4X3VubG9jaygmc3JjX2lub2RlLT5pX211dGV4KTsKKwltdXRleF91bmxvY2soJnRhcmdl
dF9pbm9kZS0+aV9tdXRleCk7CitvdXRfZnB1dDoKKwlmZHB1dChzcmNfZmlsZSk7CitvdXRfZHJv
cF93cml0ZToKKwltbnRfZHJvcF93cml0ZV9maWxlKGRzdF9maWxlKTsKKwlyZXR1cm4gcmM7Cit9
CisKIGxvbmcgY2lmc19pb2N0bChzdHJ1Y3QgZmlsZSAqZmlsZXAsIHVuc2lnbmVkIGludCBjb21t
YW5kLCB1bnNpZ25lZCBsb25nIGFyZykKIHsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlID0gZmlsZV9p
bm9kZShmaWxlcCk7CkBAIC0xMDUsNiArMjA1LDkgQEAgbG9uZyBjaWZzX2lvY3RsKHN0cnVjdCBm
aWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNvbW1hbmQsIHVuc2lnbmVkIGxvbmcgYXJnKQogCQkJ
CWNpZnNfZGJnKEZZSSwgInNldCBjb21wcmVzcyBmbGFnIHJjICVkXG4iLCByYyk7CiAJCQl9CiAJ
CQlicmVhazsKKwkJY2FzZSBCVFJGU19JT0NfQ0xPTkU6CisJCQlyYyA9IGNpZnNfaW9jdGxfY2xv
bmUoeGlkLCBmaWxlcCwgYXJnLCAwLCAwLCAwKTsKKwkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJ
Y2lmc19kYmcoRllJLCAidW5zdXBwb3J0ZWQgaW9jdGxcbiIpOwogCQkJYnJlYWs7CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9wcy5jCmluZGV4IGM1NzFiZTgu
LjExZGRlNGIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5jCisrKyBiL2ZzL2NpZnMvc21i
Mm9wcy5jCkBAIC00OTQsNiArNDk0LDg1IEBAIHNtYjJfY2xvc2VfZmlsZShjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogfQogCiBzdGF0aWMgaW50CitTTUIy
X3JlcXVlc3RfcmVzX2tleShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAorCQkgICAgIHU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxlX2ZpZCwKKwkJ
ICAgICBzdHJ1Y3QgY29weWNodW5rX2lvY3RsICpwY2NodW5rKQoreworCWludCByYzsKKwl1bnNp
Z25lZCBpbnQgcmV0X2RhdGFfbGVuOworCXN0cnVjdCByZXN1bWVfa2V5X3JlcSAqcmVzX2tleTsK
KworCXJjID0gU01CMl9pb2N0bCh4aWQsIHRjb24sIHBlcnNpc3RlbnRfZmlkLCB2b2xhdGlsZV9m
aWQsCisJCQlGU0NUTF9TUlZfUkVRVUVTVF9SRVNVTUVfS0VZLCB0cnVlIC8qIGlzX2ZzY3RsICov
LAorCQkJTlVMTCwgMCAvKiBubyBpbnB1dCAqLywKKwkJCShjaGFyICoqKSZyZXNfa2V5LCAmcmV0
X2RhdGFfbGVuKTsKKworCWlmIChyYykgeworCQljaWZzX2RiZyhWRlMsICJyZWZjcHkgaW9jdGwg
ZXJyb3IgJWQgZ2V0dGluZyByZXN1bWUga2V5XG4iLCByYyk7CisJCWdvdG8gcmVxX3Jlc19rZXlf
ZXhpdDsKKwl9CisJaWYgKHJldF9kYXRhX2xlbiA8IHNpemVvZihzdHJ1Y3QgcmVzdW1lX2tleV9y
ZXEpKSB7CisJCWNpZnNfZGJnKFZGUywgIkludmFsaWQgcmVmY29weSByZXN1bWUga2V5IGxlbmd0
aFxuIik7CisJCXJjID0gLUVJTlZBTDsKKwkJZ290byByZXFfcmVzX2tleV9leGl0OworCX0KKwlt
ZW1jcHkocGNjaHVuay0+U291cmNlS2V5LCByZXNfa2V5LT5SZXN1bWVLZXksIENPUFlfQ0hVTktf
UkVTX0tFWV9TSVpFKTsKKworcmVxX3Jlc19rZXlfZXhpdDoKKwlrZnJlZShyZXNfa2V5KTsKKwly
ZXR1cm4gcmM7Cit9CisKK3N0YXRpYyBpbnQKK3NtYjJfY2xvbmVfcmFuZ2UoY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwKKwkJCXN0cnVjdCBjaWZzRmlsZUluZm8gKnNyY2ZpbGUsCisJCQlzdHJ1Y3Qg
Y2lmc0ZpbGVJbmZvICp0cmd0ZmlsZSwgdTY0IHNyY19vZmYsCisJCQl1NjQgbGVuLCB1NjQgZGVz
dF9vZmYpCit7CisJaW50IHJjOworCXVuc2lnbmVkIGludCByZXRfZGF0YV9sZW47CisJc3RydWN0
IGNvcHljaHVua19pb2N0bCAqcGNjaHVuazsKKwljaGFyICpyZXRidWYgPSBOVUxMOworCisJcGNj
aHVuayA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBjb3B5Y2h1bmtfaW9jdGwpLCBHRlBfS0VSTkVM
KTsKKworCWlmIChwY2NodW5rID09IE5VTEwpCisJCXJldHVybiAtRU5PTUVNOworCisJY2lmc19k
YmcoRllJLCAiaW4gc21iMl9jbG9uZV9yYW5nZSAtIGFib3V0IHRvIGNhbGwgcmVxdWVzdCByZXMg
a2V5XG4iKTsKKwkvKiBSZXF1ZXN0IGEga2V5IGZyb20gdGhlIHNlcnZlciB0byBpZGVudGlmeSB0
aGUgc291cmNlIG9mIHRoZSBjb3B5ICovCisJcmMgPSBTTUIyX3JlcXVlc3RfcmVzX2tleSh4aWQs
IHRsaW5rX3Rjb24oc3JjZmlsZS0+dGxpbmspLAorCQkJCXNyY2ZpbGUtPmZpZC5wZXJzaXN0ZW50
X2ZpZCwKKwkJCQlzcmNmaWxlLT5maWQudm9sYXRpbGVfZmlkLCBwY2NodW5rKTsKKworCS8qIE5v
dGU6IHJlcXVlc3RfcmVzX2tleSBzZXRzIHJlc19rZXkgbnVsbCBvbmx5IGlmIHJjICE9MCAqLwor
CWlmIChyYykKKwkJcmV0dXJuIHJjOworCisJLyogRm9yIG5vdyBhcnJheSBvbmx5IG9uZSBjaHVu
ayBsb25nLCB3aWxsIG1ha2UgbW9yZSBmbGV4aWJsZSBsYXRlciAqLworCXBjY2h1bmstPkNodW5r
Q291bnQgPSBfX2NvbnN0YW50X2NwdV90b19sZTMyKDEpOworCXBjY2h1bmstPlJlc2VydmVkID0g
MDsKKwlwY2NodW5rLT5Tb3VyY2VPZmZzZXQgPSBjcHVfdG9fbGU2NChzcmNfb2ZmKTsKKwlwY2No
dW5rLT5UYXJnZXRPZmZzZXQgPSBjcHVfdG9fbGU2NChkZXN0X29mZik7CisJcGNjaHVuay0+TGVu
Z3RoID0gY3B1X3RvX2xlMzIobGVuKTsKKwlwY2NodW5rLT5SZXNlcnZlZDIgPSAwOworCisJLyog
UmVxdWVzdCB0aGF0IHNlcnZlciBjb3B5IHRvIHRhcmdldCBmcm9tIHNyYyBmaWxlIGlkZW50aWZp
ZWQgYnkga2V5ICovCisJcmMgPSBTTUIyX2lvY3RsKHhpZCwgdGxpbmtfdGNvbih0cmd0ZmlsZS0+
dGxpbmspLAorCQkJdHJndGZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJCXRyZ3RmaWxlLT5m
aWQudm9sYXRpbGVfZmlkLCBGU0NUTF9TUlZfQ09QWUNIVU5LX1dSSVRFLAorCQkJdHJ1ZSAvKiBp
c19mc2N0bCAqLywgKGNoYXIgKilwY2NodW5rLAorCQkJc2l6ZW9mKHN0cnVjdCBjb3B5Y2h1bmtf
aW9jdGwpLAkmcmV0YnVmLCAmcmV0X2RhdGFfbGVuKTsKKworCS8qIEJCIG5lZWQgdG8gc3BlY2lh
bCBjYXNlIHJjID0gRUlOVkFMIHRvIGFsdGVyIGNodW5rIHNpemUgKi8KKworCWNpZnNfZGJnKEZZ
SSwgInJjICVkIGRhdGEgbGVuZ3RoIG91dCAlZFxuIiwgcmMsIHJldF9kYXRhX2xlbik7CisKKwlr
ZnJlZShwY2NodW5rKTsKKwlyZXR1cm4gcmM7Cit9CisKK3N0YXRpYyBpbnQKIHNtYjJfZmx1c2hf
ZmlsZShjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlz
dHJ1Y3QgY2lmc19maWQgKmZpZCkKIHsKQEAgLTEwMTcsNiArMTA5Niw3IEBAIHN0cnVjdCBzbWJf
dmVyc2lvbl9vcGVyYXRpb25zIHNtYjIwX29wZXJhdGlvbnMgPSB7CiAJLnNldF9vcGxvY2tfbGV2
ZWwgPSBzbWIyX3NldF9vcGxvY2tfbGV2ZWwsCiAJLmNyZWF0ZV9sZWFzZV9idWYgPSBzbWIyX2Ny
ZWF0ZV9sZWFzZV9idWYsCiAJLnBhcnNlX2xlYXNlX2J1ZiA9IHNtYjJfcGFyc2VfbGVhc2VfYnVm
LAorCS5jbG9uZV9yYW5nZSA9IHNtYjJfY2xvbmVfcmFuZ2UsCiB9OwogCiBzdHJ1Y3Qgc21iX3Zl
cnNpb25fb3BlcmF0aW9ucyBzbWIyMV9vcGVyYXRpb25zID0gewpAQCAtMTA5MCw2ICsxMTcwLDcg
QEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMjFfb3BlcmF0aW9ucyA9IHsKIAku
c2V0X29wbG9ja19sZXZlbCA9IHNtYjIxX3NldF9vcGxvY2tfbGV2ZWwsCiAJLmNyZWF0ZV9sZWFz
ZV9idWYgPSBzbWIyX2NyZWF0ZV9sZWFzZV9idWYsCiAJLnBhcnNlX2xlYXNlX2J1ZiA9IHNtYjJf
cGFyc2VfbGVhc2VfYnVmLAorCS5jbG9uZV9yYW5nZSA9IHNtYjJfY2xvbmVfcmFuZ2UsCiB9Owog
CiBzdHJ1Y3Qgc21iX3ZlcnNpb25fb3BlcmF0aW9ucyBzbWIzMF9vcGVyYXRpb25zID0gewpAQCAt
MTE2NSw2ICsxMjQ2LDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3Bl
cmF0aW9ucyA9IHsKIAkuc2V0X29wbG9ja19sZXZlbCA9IHNtYjNfc2V0X29wbG9ja19sZXZlbCwK
IAkuY3JlYXRlX2xlYXNlX2J1ZiA9IHNtYjNfY3JlYXRlX2xlYXNlX2J1ZiwKIAkucGFyc2VfbGVh
c2VfYnVmID0gc21iM19wYXJzZV9sZWFzZV9idWYsCisJLmNsb25lX3JhbmdlID0gc21iMl9jbG9u
ZV9yYW5nZSwKIH07CiAKIHN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMgc21iMjBfdmFsdWVzID0g
ewpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRl
eCA2MTgzYjFiLi5iNTBhMTI5IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9m
cy9jaWZzL3NtYjJwZHUuaApAQCAtNTM0LDkgKzUzNCwxNiBAQCBzdHJ1Y3QgY3JlYXRlX2R1cmFi
bGUgewogCX0gRGF0YTsKIH0gX19wYWNrZWQ7CiAKKyNkZWZpbmUgQ09QWV9DSFVOS19SRVNfS0VZ
X1NJWkUJMjQKK3N0cnVjdCByZXN1bWVfa2V5X3JlcSB7CisJY2hhciBSZXN1bWVLZXlbQ09QWV9D
SFVOS19SRVNfS0VZX1NJWkVdOworCV9fbGUzMglDb250ZXh0TGVuZ3RoOwkvKiBNQlogKi8KKwlj
aGFyCUNvbnRleHRbMF07CS8qIGlnbm9yZWQsIFdpbmRvd3Mgc2V0cyB0byA0IGJ5dGVzIG9mIHpl
cm8gKi8KK30gX19wYWNrZWQ7CisKIC8qIHRoaXMgZ29lcyBpbiB0aGUgaW9jdGwgYnVmZmVyIHdo
ZW4gZG9pbmcgYSBjb3B5Y2h1bmsgcmVxdWVzdCAqLwogc3RydWN0IGNvcHljaHVua19pb2N0bCB7
Ci0JY2hhciBTb3VyY2VLZXlbMjRdOworCWNoYXIgU291cmNlS2V5W0NPUFlfQ0hVTktfUkVTX0tF
WV9TSVpFXTsKIAlfX2xlMzIgQ2h1bmtDb3VudDsgLyogd2UgYXJlIG9ubHkgc2VuZGluZyAxICov
CiAJX19sZTMyIFJlc2VydmVkOwogCS8qIGFycmF5IHdpbGwgb25seSBiZSBvbmUgY2h1bmsgbG9u
ZyBmb3IgdXMgKi8KQEAgLTU0Niw2ICs1NTMsMTIgQEAgc3RydWN0IGNvcHljaHVua19pb2N0bCB7
CiAJX191MzIgUmVzZXJ2ZWQyOwogfSBfX3BhY2tlZDsKIAorc3RydWN0IGNvcHljaHVua19pb2N0
bF9yc3AgeworCV9fbGUzMiBDaHVua3NXcml0dGVuOworCV9fbGUzMiBDaHVua0J5dGVzV3JpdHRl
bjsKKwlfX2xlMzIgVG90YWxCeXRlc1dyaXR0ZW47Cit9IF9fcGFja2VkOworCiAvKiBSZXNwb25z
ZSBhbmQgUmVxdWVzdCBhcmUgdGhlIHNhbWUgZm9ybWF0ICovCiBzdHJ1Y3QgdmFsaWRhdGVfbmVn
b3RpYXRlX2luZm8gewogCV9fbGUzMiBDYXBhYmlsaXRpZXM7Ci0tIAoxLjcuMTEuNwoK
--047d7bacc796ae027404e8f5c131--
