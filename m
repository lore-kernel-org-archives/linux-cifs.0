From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Query device characteristics at mount time from server
 on SMB2/3 not just on cifs mounts
Date: Wed, 9 Oct 2013 13:44:04 -0500
Message-ID: <CAH2r5mt+1SDYeV_G2duC63BQg274tSaBn9oxrmy+6RNQuHAL=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b2e0a1101ca9404e85345e1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b2e0a1101ca9404e85345e1
Content-Type: text/plain; charset=ISO-8859-1

Currently SMB2 and SMB3 mounts do not query the device information at mount time
from the server at mount time as is done for cifs.  These can be
useful for debugging.
This is a minor patch, that extends the previous one (which added ability to
query file system attributes at mount time - this returns the device
characteristics - also via in /proc/fs/cifs/DebugData).  I wonder if there is
a way to make additional device characteristics and fs attributes
available in consistent
way for nfs/cifs/smb3 and local file systems (as we do for certain
file attributes).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c   |    5 ++++-
 fs/cifs/smb2pdu.c   |   31 +++++++++++++++++++++++--------
 fs/cifs/smb2proto.h |    2 +-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a53e205..71a3460 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -229,7 +229,10 @@ smb2_qfs_tcon(const unsigned int xid, struct
cifs_tcon *tcon)
     if (rc)
         return;

-    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+            SMB_QUERY_FS_ATTRIBUTE_INFO);
+    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+            SMB_QUERY_FS_DEVICE_INFO);
     SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
     return;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2ade58b..c822d9a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2347,17 +2347,27 @@ qfsinf_exit:

 int
 SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
-          u64 persistent_fid, u64 volatile_fid)
+          u64 persistent_fid, u64 volatile_fid, int level)
 {
     struct smb2_query_info_rsp *rsp = NULL;
     struct kvec iov;
     int rc = 0;
-    int resp_buftype;
+    int resp_buftype, max_len, min_len;
     struct cifs_ses *ses = tcon->ses;
     unsigned int rsp_len, offset;

-    rc = build_qfs_info_req(&iov, tcon, SMB_QUERY_FS_ATTRIBUTE_INFO,
-                sizeof(FILE_SYSTEM_ATTRIBUTE_INFO),
+    if (level == SMB_QUERY_FS_DEVICE_INFO) {
+        max_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
+        min_len = sizeof(FILE_SYSTEM_DEVICE_INFO);
+    } else if (level == SMB_QUERY_FS_ATTRIBUTE_INFO) {
+        max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
+        min_len = MIN_FS_ATTR_INFO_SIZE;
+    } else {
+        cifs_dbg(FYI, "Invalid qfsinfo level %d", level);
+        return -EINVAL;
+    }
+
+    rc = build_qfs_info_req(&iov, tcon, level, max_len,
                 persistent_fid, volatile_fid);
     if (rc)
         return rc;
@@ -2371,12 +2381,17 @@ SMB2_QFS_attr(const unsigned int xid, struct
cifs_tcon *tcon,

     rsp_len = le32_to_cpu(rsp->OutputBufferLength);
     offset = le16_to_cpu(rsp->OutputBufferOffset);
-    rc = validate_buf(offset, rsp_len, &rsp->hdr, MIN_FS_ATTR_INFO_SIZE);
-    if (!rc) {
+    rc = validate_buf(offset, rsp_len, &rsp->hdr, min_len);
+    if (rc)
+        goto qfsattr_exit;
+
+    if (level == SMB_QUERY_FS_ATTRIBUTE_INFO)
         memcpy(&tcon->fsAttrInfo, 4 /* RFC1001 len */ + offset
             + (char *)&rsp->hdr, min_t(unsigned int,
-            rsp_len, sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)));
-    }
+            rsp_len, max_len));
+    else if (level == SMB_QUERY_FS_DEVICE_INFO)
+        memcpy(&tcon->fsDevInfo, 4 /* RFC1001 len */ + offset
+            + (char *)&rsp->hdr, sizeof(FILE_SYSTEM_DEVICE_INFO));

 qfsattr_exit:
     free_rsp_buf(resp_buftype, iov.iov_base);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 68dc00d..313813e 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -151,7 +151,7 @@ extern int SMB2_QFS_info(const unsigned int xid,
struct cifs_tcon *tcon,
              u64 persistent_file_id, u64 volatile_file_id,
              struct kstatfs *FSData);
 extern int SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
-             u64 persistent_file_id, u64 volatile_file_id);
+             u64 persistent_file_id, u64 volatile_file_id, int lvl);
 extern int SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
              const __u64 persist_fid, const __u64 volatile_fid,
              const __u32 pid, const __u64 length, const __u64 offset,
-- 
1.7.10.4


-- 
Thanks,

Steve

--047d7b2e0a1101ca9404e85345e1
Content-Type: application/octet-stream;
	name="0001-CIFS-Query-device-characteristics-at-mount-time-from.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Query-device-characteristics-at-mount-time-from.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmkwoy4o0

RnJvbSA1YTdjODBhNzdjNmQ0NWE4OTEyOTFmYzBkYWRhMzM5Y2JmYjY4MjNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZW4gRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+CkRh
dGU6IFdlZCwgOSBPY3QgMjAxMyAxMzozNjozNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBRdWVyeSBkZXZpY2UgY2hhcmFjdGVyaXN0aWNzIGF0IG1vdW50IHRpbWUgZnJvbQogc2VydmVy
IG9uIFNNQjIvMyBub3QgIGp1c3Qgb24gY2lmcyBtb3VudHMKCkN1cnJlbnRseSBTTUIyIGFuZCBT
TUIzIG1vdW50cyBkbyBub3QgcXVlcnkgdGhlIGRldmljZSBpbmZvcm1hdGlvbiBhdCBtb3VudCB0
aW1lCmZyb20gdGhlIHNlcnZlciBhdCBtb3VudCB0aW1lIGFzIGlzIGRvbmUgZm9yIGNpZnMuICBU
aGVzZSBjYW4gYmUgdXNlZnVsIGZvciBkZWJ1Z2dpbmcuClRoaXMgaXMgYSBtaW5vciBwYXRjaCwg
dGhhdCBleHRlbmRzIHRoZSBwcmV2aW91cyBvbmUgKHdoaWNoIGFkZGVkIGFiaWxpdHkgdG8KcXVl
cnkgZmlsZSBzeXN0ZW0gYXR0cmlidXRlcyBhdCBtb3VudCB0aW1lIC0gdGhpcyByZXR1cm5zIHRo
ZSBkZXZpY2UKY2hhcmFjdGVyaXN0aWNzIC0gYWxzbyB2aWEgaW4gL3Byb2MvZnMvY2lmcy9EZWJ1
Z0RhdGEpCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4K
LS0tCiBmcy9jaWZzL3NtYjJvcHMuYyAgIHwgICAgNSArKysrLQogZnMvY2lmcy9zbWIycGR1LmMg
ICB8ICAgMzEgKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQogZnMvY2lmcy9zbWIycHJv
dG8uaCB8ICAgIDIgKy0KIDMgZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJv
cHMuYwppbmRleCBhNTNlMjA1Li43MWEzNDYwIDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMu
YworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjI5LDcgKzIyOSwxMCBAQCBzbWIyX3Fmc190
Y29uKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCiAJaWYg
KHJjKQogCQlyZXR1cm47CiAKLQlTTUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3Rl
bnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkKTsKKwlTTUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlk
LnBlcnNpc3RlbnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkLAorCQkJU01CX1FVRVJZX0ZTX0FUVFJJ
QlVURV9JTkZPKTsKKwlTTUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlk
LCBmaWQudm9sYXRpbGVfZmlkLAorCQkJU01CX1FVRVJZX0ZTX0RFVklDRV9JTkZPKTsKIAlTTUIy
X2Nsb3NlKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkKTsK
IAlyZXR1cm47CiB9CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21i
MnBkdS5jCmluZGV4IDJhZGU1OGIuLmM4MjJkOWEgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBk
dS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC0yMzQ3LDE3ICsyMzQ3LDI3IEBAIHFmc2lu
Zl9leGl0OgogCiBpbnQKIFNNQjJfUUZTX2F0dHIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKLQkgICAgICB1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xh
dGlsZV9maWQpCisJICAgICAgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRpbGVfZmlkLCBp
bnQgbGV2ZWwpCiB7CiAJc3RydWN0IHNtYjJfcXVlcnlfaW5mb19yc3AgKnJzcCA9IE5VTEw7CiAJ
c3RydWN0IGt2ZWMgaW92OwogCWludCByYyA9IDA7Ci0JaW50IHJlc3BfYnVmdHlwZTsKKwlpbnQg
cmVzcF9idWZ0eXBlLCBtYXhfbGVuLCBtaW5fbGVuOwogCXN0cnVjdCBjaWZzX3NlcyAqc2VzID0g
dGNvbi0+c2VzOwogCXVuc2lnbmVkIGludCByc3BfbGVuLCBvZmZzZXQ7CiAKLQlyYyA9IGJ1aWxk
X3Fmc19pbmZvX3JlcSgmaW92LCB0Y29uLCBTTUJfUVVFUllfRlNfQVRUUklCVVRFX0lORk8sCi0J
CQkJc2l6ZW9mKEZJTEVfU1lTVEVNX0FUVFJJQlVURV9JTkZPKSwKKwlpZiAobGV2ZWwgPT0gU01C
X1FVRVJZX0ZTX0RFVklDRV9JTkZPKSB7CisJCW1heF9sZW4gPSBzaXplb2YoRklMRV9TWVNURU1f
REVWSUNFX0lORk8pOworCQltaW5fbGVuID0gc2l6ZW9mKEZJTEVfU1lTVEVNX0RFVklDRV9JTkZP
KTsKKwl9IGVsc2UgaWYgKGxldmVsID09IFNNQl9RVUVSWV9GU19BVFRSSUJVVEVfSU5GTykgewor
CQltYXhfbGVuID0gc2l6ZW9mKEZJTEVfU1lTVEVNX0FUVFJJQlVURV9JTkZPKTsKKwkJbWluX2xl
biA9IE1JTl9GU19BVFRSX0lORk9fU0laRTsKKwl9IGVsc2UgeworCQljaWZzX2RiZyhGWUksICJJ
bnZhbGlkIHFmc2luZm8gbGV2ZWwgJWQiLCBsZXZlbCk7CisJCXJldHVybiAtRUlOVkFMOworCX0K
KworCXJjID0gYnVpbGRfcWZzX2luZm9fcmVxKCZpb3YsIHRjb24sIGxldmVsLCBtYXhfbGVuLAog
CQkJCXBlcnNpc3RlbnRfZmlkLCB2b2xhdGlsZV9maWQpOwogCWlmIChyYykKIAkJcmV0dXJuIHJj
OwpAQCAtMjM3MSwxMiArMjM4MSwxNyBAQCBTTUIyX1FGU19hdHRyKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAKIAlyc3BfbGVuID0gbGUzMl90b19jcHUo
cnNwLT5PdXRwdXRCdWZmZXJMZW5ndGgpOwogCW9mZnNldCA9IGxlMTZfdG9fY3B1KHJzcC0+T3V0
cHV0QnVmZmVyT2Zmc2V0KTsKLQlyYyA9IHZhbGlkYXRlX2J1ZihvZmZzZXQsIHJzcF9sZW4sICZy
c3AtPmhkciwgTUlOX0ZTX0FUVFJfSU5GT19TSVpFKTsKLQlpZiAoIXJjKSB7CisJcmMgPSB2YWxp
ZGF0ZV9idWYob2Zmc2V0LCByc3BfbGVuLCAmcnNwLT5oZHIsIG1pbl9sZW4pOworCWlmIChyYykK
KwkJZ290byBxZnNhdHRyX2V4aXQ7CisKKwlpZiAobGV2ZWwgPT0gU01CX1FVRVJZX0ZTX0FUVFJJ
QlVURV9JTkZPKQogCQltZW1jcHkoJnRjb24tPmZzQXR0ckluZm8sIDQgLyogUkZDMTAwMSBsZW4g
Ki8gKyBvZmZzZXQKIAkJCSsgKGNoYXIgKikmcnNwLT5oZHIsIG1pbl90KHVuc2lnbmVkIGludCwK
LQkJCXJzcF9sZW4sIHNpemVvZihGSUxFX1NZU1RFTV9BVFRSSUJVVEVfSU5GTykpKTsKLQl9CisJ
CQlyc3BfbGVuLCBtYXhfbGVuKSk7CisJZWxzZSBpZiAobGV2ZWwgPT0gU01CX1FVRVJZX0ZTX0RF
VklDRV9JTkZPKQorCQltZW1jcHkoJnRjb24tPmZzRGV2SW5mbywgNCAvKiBSRkMxMDAxIGxlbiAq
LyArIG9mZnNldAorCQkJKyAoY2hhciAqKSZyc3AtPmhkciwgc2l6ZW9mKEZJTEVfU1lTVEVNX0RF
VklDRV9JTkZPKSk7CiAKIHFmc2F0dHJfZXhpdDoKIAlmcmVlX3JzcF9idWYocmVzcF9idWZ0eXBl
LCBpb3YuaW92X2Jhc2UpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2Np
ZnMvc21iMnByb3RvLmgKaW5kZXggNjhkYzAwZC4uMzEzODEzZSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9zbWIycHJvdG8uaAorKysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC0xNTEsNyArMTUxLDcg
QEAgZXh0ZXJuIGludCBTTUIyX1FGU19pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAJCQkgdTY0IHBlcnNpc3RlbnRfZmlsZV9pZCwgdTY0IHZvbGF0
aWxlX2ZpbGVfaWQsCiAJCQkgc3RydWN0IGtzdGF0ZnMgKkZTRGF0YSk7CiBleHRlcm4gaW50IFNN
QjJfUUZTX2F0dHIoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNv
biwKLQkJCSB1NjQgcGVyc2lzdGVudF9maWxlX2lkLCB1NjQgdm9sYXRpbGVfZmlsZV9pZCk7CisJ
CQkgdTY0IHBlcnNpc3RlbnRfZmlsZV9pZCwgdTY0IHZvbGF0aWxlX2ZpbGVfaWQsIGludCBsdmwp
OwogZXh0ZXJuIGludCBTTUIyX2xvY2soY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfdGNvbiAqdGNvbiwKIAkJICAgICBjb25zdCBfX3U2NCBwZXJzaXN0X2ZpZCwgY29uc3QgX191
NjQgdm9sYXRpbGVfZmlkLAogCQkgICAgIGNvbnN0IF9fdTMyIHBpZCwgY29uc3QgX191NjQgbGVu
Z3RoLCBjb25zdCBfX3U2NCBvZmZzZXQsCi0tIAoxLjcuMTAuNAoK
--047d7b2e0a1101ca9404e85345e1--
