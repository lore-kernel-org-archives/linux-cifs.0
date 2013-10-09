From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Query file system attributes from server on SMB2, not
 just cifs, mounts
Date: Wed, 9 Oct 2013 02:11:43 -0500
Message-ID: <CAH2r5muWeLvm8tqKCmUftnXL3F-5KX0J0+QRH_cuS57LGTKKXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2edb25f8788504e8499831
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b2edb25f8788504e8499831
Content-Type: text/plain; charset=ISO-8859-1

Currently SMB2 and SMB3 mounts do not query the file system attributes
from the server at mount time as is done for cifs.  These can be
useful for debugging.  These could be used in the future to determine
when
we are able to request certain optional features (compressed files e.g.)
of the protocol.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifspdu.h   |  3 +++
 fs/cifs/smb2ops.c   | 28 ++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c   | 42 ++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2proto.h |  2 ++
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 08f9dfb..d40bd77 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2215,6 +2215,9 @@ typedef struct {
  __le32 DeviceCharacteristics;
 } __attribute__((packed)) FILE_SYSTEM_DEVICE_INFO; /* device info
level 0x104 */

+/* minimum includes first three fields, and empty FS Name */
+#define MIN_FS_ATTR_INFO_SIZE 12
+
 typedef struct {
  __le32 Attributes;
  __le32 MaxPathNameComponentLength;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b96bacc..a53e205 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -209,6 +209,31 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon,
struct smb_vol *volume_info)
  return rsize;
 }

+static void
+smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+{
+ int rc;
+ __le16 srch_path = 0; /* Null - open root of share */
+ u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+ struct cifs_open_parms oparms;
+ struct cifs_fid fid;
+
+ oparms.tcon = tcon;
+ oparms.desired_access = FILE_READ_ATTRIBUTES;
+ oparms.disposition = FILE_OPEN;
+ oparms.create_options = 0;
+ oparms.fid = &fid;
+ oparms.reconnect = false;
+
+ rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL);
+ if (rc)
+ return;
+
+ SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+ SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+ return;
+}
+
 static int
 smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
  struct cifs_sb_info *cifs_sb, const char *full_path)
@@ -873,6 +898,7 @@ struct smb_version_operations smb20_operations = {
  .logoff = SMB2_logoff,
  .tree_connect = SMB2_tcon,
  .tree_disconnect = SMB2_tdis,
+ .qfs_tcon = smb2_qfs_tcon,
  .is_path_accessible = smb2_is_path_accessible,
  .can_echo = smb2_can_echo,
  .echo = SMB2_echo,
@@ -945,6 +971,7 @@ struct smb_version_operations smb21_operations = {
  .logoff = SMB2_logoff,
  .tree_connect = SMB2_tcon,
  .tree_disconnect = SMB2_tdis,
+ .qfs_tcon = smb2_qfs_tcon,
  .is_path_accessible = smb2_is_path_accessible,
  .can_echo = smb2_can_echo,
  .echo = SMB2_echo,
@@ -1018,6 +1045,7 @@ struct smb_version_operations smb30_operations = {
  .logoff = SMB2_logoff,
  .tree_connect = SMB2_tcon,
  .tree_disconnect = SMB2_tdis,
+ .qfs_tcon = smb2_qfs_tcon,
  .is_path_accessible = smb2_is_path_accessible,
  .can_echo = smb2_can_echo,
  .echo = SMB2_echo,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fb19ad8..2ade58b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2328,7 +2328,7 @@ SMB2_QFS_info(const unsigned int xid, struct
cifs_tcon *tcon,
  rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0);
  if (rc) {
  cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
- goto qinf_exit;
+ goto qfsinf_exit;
  }
  rsp = (struct smb2_query_info_rsp *)iov.iov_base;

@@ -2340,7 +2340,45 @@ SMB2_QFS_info(const unsigned int xid, struct
cifs_tcon *tcon,
  if (!rc)
  copy_fs_info_to_kstatfs(info, fsdata);

-qinf_exit:
+qfsinf_exit:
+ free_rsp_buf(resp_buftype, iov.iov_base);
+ return rc;
+}
+
+int
+SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
+      u64 persistent_fid, u64 volatile_fid)
+{
+ struct smb2_query_info_rsp *rsp = NULL;
+ struct kvec iov;
+ int rc = 0;
+ int resp_buftype;
+ struct cifs_ses *ses = tcon->ses;
+ unsigned int rsp_len, offset;
+
+ rc = build_qfs_info_req(&iov, tcon, SMB_QUERY_FS_ATTRIBUTE_INFO,
+ sizeof(FILE_SYSTEM_ATTRIBUTE_INFO),
+ persistent_fid, volatile_fid);
+ if (rc)
+ return rc;
+
+ rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, 0);
+ if (rc) {
+ cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
+ goto qfsattr_exit;
+ }
+ rsp = (struct smb2_query_info_rsp *)iov.iov_base;
+
+ rsp_len = le32_to_cpu(rsp->OutputBufferLength);
+ offset = le16_to_cpu(rsp->OutputBufferOffset);
+ rc = validate_buf(offset, rsp_len, &rsp->hdr, MIN_FS_ATTR_INFO_SIZE);
+ if (!rc) {
+ memcpy(&tcon->fsAttrInfo, 4 /* RFC1001 len */ + offset
+ + (char *)&rsp->hdr, min_t(unsigned int,
+ rsp_len, sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)));
+ }
+
+qfsattr_exit:
  free_rsp_buf(resp_buftype, iov.iov_base);
  return rc;
 }
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 3cf22e3..68dc00d 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -150,6 +150,8 @@ extern int SMB2_oplock_break(const unsigned int
xid, struct cifs_tcon *tcon,
 extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
  u64 persistent_file_id, u64 volatile_file_id,
  struct kstatfs *FSData);
+extern int SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
+ u64 persistent_file_id, u64 volatile_file_id);
 extern int SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
      const __u64 persist_fid, const __u64 volatile_fid,
      const __u32 pid, const __u64 length, const __u64 offset,
-- 
1.7.11.7


-- 
Thanks,

Steve

--047d7b2edb25f8788504e8499831
Content-Type: application/octet-stream;
	name="0001-CIFS-Query-file-system-attributes-from-server-on-SMB.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Query-file-system-attributes-from-server-on-SMB.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmk7wo9l0

RnJvbSA3MWE5ZWQ0Y2M1ZmI1N2U3YmE4NDM5MDU2NWI5ZTNmZWE5YjIyY2U5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogV2VkLCA5IE9jdCAyMDEzIDAyOjA3OjAwIC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gW0NJRlNd
IFF1ZXJ5IGZpbGUgc3lzdGVtIGF0dHJpYnV0ZXMgZnJvbSBzZXJ2ZXIgb24gU01CMiwgbm90CiBq
dXN0IGNpZnMsIG1vdW50cwoKQ3VycmVudGx5IFNNQjIgYW5kIFNNQjMgbW91bnRzIGRvIG5vdCBx
dWVyeSB0aGUgZmlsZSBzeXN0ZW0gYXR0cmlidXRlcwpmcm9tIHRoZSBzZXJ2ZXIgYXQgbW91bnQg
dGltZSBhcyBpcyBkb25lIGZvciBjaWZzLiAgVGhlc2UgY2FuIGJlIHVzZWZ1bCBmb3IgZGVidWdn
aW5nLgoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+Ci0t
LQogZnMvY2lmcy9jaWZzcGR1LmggICB8ICAzICsrKwogZnMvY2lmcy9zbWIyb3BzLmMgICB8IDI4
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvc21iMnBkdS5jICAgfCA0MiAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIGZzL2NpZnMvc21iMnBy
b3RvLmggfCAgMiArKwogNCBmaWxlcyBjaGFuZ2VkLCA3MyBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1
LmgKaW5kZXggMDhmOWRmYi4uZDQwYmQ3NyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcGR1LmgK
KysrIGIvZnMvY2lmcy9jaWZzcGR1LmgKQEAgLTIyMTUsNiArMjIxNSw5IEBAIHR5cGVkZWYgc3Ry
dWN0IHsKIAlfX2xlMzIgRGV2aWNlQ2hhcmFjdGVyaXN0aWNzOwogfSBfX2F0dHJpYnV0ZV9fKChw
YWNrZWQpKSBGSUxFX1NZU1RFTV9ERVZJQ0VfSU5GTzsgLyogZGV2aWNlIGluZm8gbGV2ZWwgMHgx
MDQgKi8KIAorLyogbWluaW11bSBpbmNsdWRlcyBmaXJzdCB0aHJlZSBmaWVsZHMsIGFuZCBlbXB0
eSBGUyBOYW1lICovCisjZGVmaW5lIE1JTl9GU19BVFRSX0lORk9fU0laRSAxMgorCiB0eXBlZGVm
IHN0cnVjdCB7CiAJX19sZTMyIEF0dHJpYnV0ZXM7CiAJX19sZTMyIE1heFBhdGhOYW1lQ29tcG9u
ZW50TGVuZ3RoOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJv
cHMuYwppbmRleCBiOTZiYWNjLi5hNTNlMjA1IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMu
YworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjA5LDYgKzIwOSwzMSBAQCBzbWIyX25lZ290
aWF0ZV9yc2l6ZShzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3Qgc21iX3ZvbCAqdm9sdW1l
X2luZm8pCiAJcmV0dXJuIHJzaXplOwogfQogCitzdGF0aWMgdm9pZAorc21iMl9xZnNfdGNvbihj
b25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQoreworCWludCBy
YzsKKwlfX2xlMTYgc3JjaF9wYXRoID0gMDsgLyogTnVsbCAtIG9wZW4gcm9vdCBvZiBzaGFyZSAq
LworCXU4IG9wbG9jayA9IFNNQjJfT1BMT0NLX0xFVkVMX05PTkU7CisJc3RydWN0IGNpZnNfb3Bl
bl9wYXJtcyBvcGFybXM7CisJc3RydWN0IGNpZnNfZmlkIGZpZDsKKworCW9wYXJtcy50Y29uID0g
dGNvbjsKKwlvcGFybXMuZGVzaXJlZF9hY2Nlc3MgPSBGSUxFX1JFQURfQVRUUklCVVRFUzsKKwlv
cGFybXMuZGlzcG9zaXRpb24gPSBGSUxFX09QRU47CisJb3Bhcm1zLmNyZWF0ZV9vcHRpb25zID0g
MDsKKwlvcGFybXMuZmlkID0gJmZpZDsKKwlvcGFybXMucmVjb25uZWN0ID0gZmFsc2U7CisKKwly
YyA9IFNNQjJfb3Blbih4aWQsICZvcGFybXMsICZzcmNoX3BhdGgsICZvcGxvY2ssIE5VTEwsIE5V
TEwpOworCWlmIChyYykKKwkJcmV0dXJuOworCisJU01CMl9RRlNfYXR0cih4aWQsIHRjb24sIGZp
ZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCk7CisJU01CMl9jbG9zZSh4aWQsIHRj
b24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxlX2ZpZCk7CisJcmV0dXJuOworfQor
CiBzdGF0aWMgaW50CiBzbWIyX2lzX3BhdGhfYWNjZXNzaWJsZShjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQkJc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lm
c19zYiwgY29uc3QgY2hhciAqZnVsbF9wYXRoKQpAQCAtODczLDYgKzg5OCw3IEBAIHN0cnVjdCBz
bWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIwX29wZXJhdGlvbnMgPSB7CiAJLmxvZ29mZiA9IFNN
QjJfbG9nb2ZmLAogCS50cmVlX2Nvbm5lY3QgPSBTTUIyX3Rjb24sCiAJLnRyZWVfZGlzY29ubmVj
dCA9IFNNQjJfdGRpcywKKwkucWZzX3Rjb24gPSBzbWIyX3Fmc190Y29uLAogCS5pc19wYXRoX2Fj
Y2Vzc2libGUgPSBzbWIyX2lzX3BhdGhfYWNjZXNzaWJsZSwKIAkuY2FuX2VjaG8gPSBzbWIyX2Nh
bl9lY2hvLAogCS5lY2hvID0gU01CMl9lY2hvLApAQCAtOTQ1LDYgKzk3MSw3IEBAIHN0cnVjdCBz
bWJfdmVyc2lvbl9vcGVyYXRpb25zIHNtYjIxX29wZXJhdGlvbnMgPSB7CiAJLmxvZ29mZiA9IFNN
QjJfbG9nb2ZmLAogCS50cmVlX2Nvbm5lY3QgPSBTTUIyX3Rjb24sCiAJLnRyZWVfZGlzY29ubmVj
dCA9IFNNQjJfdGRpcywKKwkucWZzX3Rjb24gPSBzbWIyX3Fmc190Y29uLAogCS5pc19wYXRoX2Fj
Y2Vzc2libGUgPSBzbWIyX2lzX3BhdGhfYWNjZXNzaWJsZSwKIAkuY2FuX2VjaG8gPSBzbWIyX2Nh
bl9lY2hvLAogCS5lY2hvID0gU01CMl9lY2hvLApAQCAtMTAxOCw2ICsxMDQ1LDcgQEAgc3RydWN0
IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3BlcmF0aW9ucyA9IHsKIAkubG9nb2ZmID0g
U01CMl9sb2dvZmYsCiAJLnRyZWVfY29ubmVjdCA9IFNNQjJfdGNvbiwKIAkudHJlZV9kaXNjb25u
ZWN0ID0gU01CMl90ZGlzLAorCS5xZnNfdGNvbiA9IHNtYjJfcWZzX3Rjb24sCiAJLmlzX3BhdGhf
YWNjZXNzaWJsZSA9IHNtYjJfaXNfcGF0aF9hY2Nlc3NpYmxlLAogCS5jYW5fZWNobyA9IHNtYjJf
Y2FuX2VjaG8sCiAJLmVjaG8gPSBTTUIyX2VjaG8sCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJw
ZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGZiMTlhZDguLjJhZGU1OGIgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yMzI4LDcg
KzIzMjgsNyBAQCBTTUIyX1FGU19pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBj
aWZzX3Rjb24gKnRjb24sCiAJcmMgPSBTZW5kUmVjZWl2ZTIoeGlkLCBzZXMsICZpb3YsIDEsICZy
ZXNwX2J1ZnR5cGUsIDApOwogCWlmIChyYykgewogCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24s
IFNNQjJfUVVFUllfSU5GT19IRSk7Ci0JCWdvdG8gcWluZl9leGl0OworCQlnb3RvIHFmc2luZl9l
eGl0OwogCX0KIAlyc3AgPSAoc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKilpb3YuaW92X2Jh
c2U7CiAKQEAgLTIzNDAsNyArMjM0MCw0NSBAQCBTTUIyX1FGU19pbmZvKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJaWYgKCFyYykKIAkJY29weV9mc19p
bmZvX3RvX2tzdGF0ZnMoaW5mbywgZnNkYXRhKTsKIAotcWluZl9leGl0OgorcWZzaW5mX2V4aXQ6
CisJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgaW92Lmlvdl9iYXNlKTsKKwlyZXR1cm4gcmM7
Cit9CisKK2ludAorU01CMl9RRlNfYXR0cihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAorCSAgICAgIHU2NCBwZXJzaXN0ZW50X2ZpZCwgdTY0IHZvbGF0aWxl
X2ZpZCkKK3sKKwlzdHJ1Y3Qgc21iMl9xdWVyeV9pbmZvX3JzcCAqcnNwID0gTlVMTDsKKwlzdHJ1
Y3Qga3ZlYyBpb3Y7CisJaW50IHJjID0gMDsKKwlpbnQgcmVzcF9idWZ0eXBlOworCXN0cnVjdCBj
aWZzX3NlcyAqc2VzID0gdGNvbi0+c2VzOworCXVuc2lnbmVkIGludCByc3BfbGVuLCBvZmZzZXQ7
CisKKwlyYyA9IGJ1aWxkX3Fmc19pbmZvX3JlcSgmaW92LCB0Y29uLCBTTUJfUVVFUllfRlNfQVRU
UklCVVRFX0lORk8sCisJCQkJc2l6ZW9mKEZJTEVfU1lTVEVNX0FUVFJJQlVURV9JTkZPKSwKKwkJ
CQlwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVfZmlkKTsKKwlpZiAocmMpCisJCXJldHVybiByYzsK
KworCXJjID0gU2VuZFJlY2VpdmUyKHhpZCwgc2VzLCAmaW92LCAxLCAmcmVzcF9idWZ0eXBlLCAw
KTsKKwlpZiAocmMpIHsKKwkJY2lmc19zdGF0c19mYWlsX2luYyh0Y29uLCBTTUIyX1FVRVJZX0lO
Rk9fSEUpOworCQlnb3RvIHFmc2F0dHJfZXhpdDsKKwl9CisJcnNwID0gKHN0cnVjdCBzbWIyX3F1
ZXJ5X2luZm9fcnNwICopaW92Lmlvdl9iYXNlOworCisJcnNwX2xlbiA9IGxlMzJfdG9fY3B1KHJz
cC0+T3V0cHV0QnVmZmVyTGVuZ3RoKTsKKwlvZmZzZXQgPSBsZTE2X3RvX2NwdShyc3AtPk91dHB1
dEJ1ZmZlck9mZnNldCk7CisJcmMgPSB2YWxpZGF0ZV9idWYob2Zmc2V0LCByc3BfbGVuLCAmcnNw
LT5oZHIsIE1JTl9GU19BVFRSX0lORk9fU0laRSk7CisJaWYgKCFyYykgeworCQltZW1jcHkoJnRj
b24tPmZzQXR0ckluZm8sIDQgLyogUkZDMTAwMSBsZW4gKi8gKyBvZmZzZXQKKwkJCSsgKGNoYXIg
KikmcnNwLT5oZHIsIG1pbl90KHVuc2lnbmVkIGludCwKKwkJCXJzcF9sZW4sIHNpemVvZihGSUxF
X1NZU1RFTV9BVFRSSUJVVEVfSU5GTykpKTsKKwl9CisKK3Fmc2F0dHJfZXhpdDoKIAlmcmVlX3Jz
cF9idWYocmVzcF9idWZ0eXBlLCBpb3YuaW92X2Jhc2UpOwogCXJldHVybiByYzsKIH0KZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvc21iMnByb3RvLmggYi9mcy9jaWZzL3NtYjJwcm90by5oCmluZGV4IDNj
ZjIyZTMuLjY4ZGMwMGQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnByb3RvLmgKKysrIGIvZnMv
Y2lmcy9zbWIycHJvdG8uaApAQCAtMTUwLDYgKzE1MCw4IEBAIGV4dGVybiBpbnQgU01CMl9vcGxv
Y2tfYnJlYWsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IGV4dGVybiBpbnQgU01CMl9RRlNfaW5mbyhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkJIHU2NCBwZXJzaXN0ZW50X2ZpbGVfaWQsIHU2NCB2b2xhdGls
ZV9maWxlX2lkLAogCQkJIHN0cnVjdCBrc3RhdGZzICpGU0RhdGEpOworZXh0ZXJuIGludCBTTUIy
X1FGU19hdHRyKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24s
CisJCQkgdTY0IHBlcnNpc3RlbnRfZmlsZV9pZCwgdTY0IHZvbGF0aWxlX2ZpbGVfaWQpOwogZXh0
ZXJuIGludCBTTUIyX2xvY2soY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNv
biAqdGNvbiwKIAkJICAgICBjb25zdCBfX3U2NCBwZXJzaXN0X2ZpZCwgY29uc3QgX191NjQgdm9s
YXRpbGVfZmlkLAogCQkgICAgIGNvbnN0IF9fdTMyIHBpZCwgY29uc3QgX191NjQgbGVuZ3RoLCBj
b25zdCBfX3U2NCBvZmZzZXQsCi0tIAoxLjcuMTEuNwoK
--047d7b2edb25f8788504e8499831--
