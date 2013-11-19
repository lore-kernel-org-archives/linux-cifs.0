From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv2][CIFS] Validate Negotiate Info
Date: Tue, 19 Nov 2013 13:20:01 -0600
Message-ID: <CAH2r5mufCuB6b1aLbezcdPW8uAsFs7ojoW-L3E5MhrouEb9kVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8ff1c81810430004eb8c8da5
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--e89a8ff1c81810430004eb8c8da5
Content-Type: text/plain; charset=ISO-8859-1

>From e4608aa57f9948a5e160ecb8590c885f76796e34 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 19 Nov 2013 12:58:08 -0600
Subject: [PATCH] [CIFS] Check SMB3 dialects against downgrade attacks

When we are running SMB3 or SMB3.02 connections which are signed
we need to validate the protocol negotiation information,
to ensure that thenegotiate protocol response was not tampered with.

Add the missing FSCTL which is sent at mount time (immediately after
the SMB3 Tree Connect) to validate that the capabilities match
what we think the server sent.

"Secure dialect negotiation is introduced in SMB3 to protect against
man-in-the-middle attempt to downgrade dialect negotiation.
The idea is to prevent an eavesdropper from downgrading the initially
negotiated dialect and capabilities between the client and the server."

For more explanation see 2.2.31.4 of MS-SMB2 or
http://blogs.msdn.com/b/openspecification/archive/2012/06/28/smb3-secure-dialect-negotiation.aspx

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/smb2ops.c   |  1 +
 fs/cifs/smb2pdu.c   | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   | 12 ++++++---
 fs/cifs/smb2proto.h |  1 +
 fs/cifs/smbfsctl.h  |  2 +-
 6 files changed, 89 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d9ea7ad..f918a99 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -384,6 +384,7 @@ struct smb_version_operations {
  int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
  struct cifsFileInfo *target_file, u64 src_off, u64 len,
  u64 dest_off);
+ int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
 };

 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a3968ee..757da3e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1319,6 +1319,7 @@ struct smb_version_operations smb30_operations = {
  .create_lease_buf = smb3_create_lease_buf,
  .parse_lease_buf = smb3_parse_lease_buf,
  .clone_range = smb2_clone_range,
+ .validate_negotiate = smb3_validate_negotiate,
 };

 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1e136ee..7756f9b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -454,6 +454,80 @@ neg_exit:
  return rc;
 }

+int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
+{
+ int rc = 0;
+ struct validate_negotiate_info_req vneg_inbuf;
+ struct validate_negotiate_info_rsp *pneg_rsp;
+ u32 rsplen;
+
+ cifs_dbg(VFS, "validate negotiate ");
+ vneg_inbuf.Capabilities =
+ cpu_to_le32(tcon->ses->server->vals->req_capabilities);
+ memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+
+ /*
+ * validation ioctl must be signed, so no point sending this if we
+ * can not sign it.  We could eventually change this to selectively
+ * sign just this, the first and only signed request on a connection.
+ * This is good enough for now since a user who wants better security
+ * would also enable signing on the mount. Having validation of
+ * negotiate info for signed connections helps reduce attack vectors
+ */
+ if (tcon->ses->server->sign == false)
+ return 0; /* validation requires signing */
+
+ if (tcon->ses->sign)
+ vneg_inbuf.SecurityMode =
+ cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
+ else if (global_secflags & CIFSSEC_MAY_SIGN)
+ vneg_inbuf.SecurityMode =
+ cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
+ else
+ vneg_inbuf.SecurityMode = 0;
+
+ vneg_inbuf.DialectCount = cpu_to_le16(1);
+ vneg_inbuf.Dialects[0] =
+ cpu_to_le16(tcon->ses->server->vals->protocol_id);
+
+ rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
+ FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+ (char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
+ (char **)&pneg_rsp, &rsplen);
+
+ if (rc != 0) {
+ cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
+ return -EIO;
+ }
+
+ if (rsplen != sizeof(struct validate_negotiate_info_rsp)) {
+ cifs_dbg(VFS, "invalid size of protocol negotiate response\n");
+ return -EIO;
+ }
+
+ /* check validate negotiate info response matches what we got earlier */
+ if (pneg_rsp->Dialect !=
+ cpu_to_le16(tcon->ses->server->vals->protocol_id))
+ goto vneg_out;
+
+ if (pneg_rsp->SecurityMode != cpu_to_le16(tcon->ses->server->sec_mode))
+ goto vneg_out;
+
+ /* do not validate server guid because not saved at negprot time yet */
+
+ if ((le32_to_cpu(pneg_rsp->Capabilities) | SMB2_NT_FIND |
+      SMB2_LARGE_FILES) != tcon->ses->server->capabilities)
+ goto vneg_out;
+
+ /* validate negotiate successful */
+ cifs_dbg(FYI, "validate negotiate info successful\n");
+ return 0;
+
+vneg_out:
+ cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
+ return -EIO;
+}
+
 int
 SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
  const struct nls_table *nls_cp)
@@ -829,6 +903,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
*ses, const char *tree,
     ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
  cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
  init_copy_chunk_defaults(tcon);
+ if (tcon->ses->server->ops->validate_negotiate)
+ rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
 tcon_exit:
  free_rsp_buf(resp_buftype, rsp);
  kfree(unc_path);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f88320b..2022c54 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -577,13 +577,19 @@ struct copychunk_ioctl_rsp {
  __le32 TotalBytesWritten;
 } __packed;

-/* Response and Request are the same format */
-struct validate_negotiate_info {
+struct validate_negotiate_info_req {
  __le32 Capabilities;
  __u8   Guid[SMB2_CLIENT_GUID_SIZE];
  __le16 SecurityMode;
  __le16 DialectCount;
- __le16 Dialect[1];
+ __le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
+} __packed;
+
+struct validate_negotiate_info_rsp {
+ __le32 Capabilities;
+ __u8   Guid[SMB2_CLIENT_GUID_SIZE];
+ __le16 SecurityMode;
+ __le16 Dialect; /* Dialect in use for the connection */
 } __packed;

 #define RSS_CAPABLE 0x00000001
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b4eea10..93adc64 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -162,5 +162,6 @@ extern int smb2_lockv(const unsigned int xid,
struct cifs_tcon *tcon,
       struct smb2_lock_element *buf);
 extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
     __u8 *lease_key, const __le32 lease_state);
+extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);

 #endif /* _SMB2PROTO_H */
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index a4b2391f..0e538b5 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -90,7 +90,7 @@
 #define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4 /* BB add struct */
 #define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
 #define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
-#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204 /* BB add struct */
+#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
 /* Perform server-side data movement */
 #define FSCTL_SRV_COPYCHUNK 0x001440F2
 #define FSCTL_SRV_COPYCHUNK_WRITE 0x001480F2
-- 
1.8.3.1


-- 
Thanks,

Steve

--e89a8ff1c81810430004eb8c8da5
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Check-SMB3-dialects-against-downgrade-attacks.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Check-SMB3-dialects-against-downgrade-attacks.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho7j0rv60

RnJvbSBlNDYwOGFhNTdmOTk0OGE1ZTE2MGVjYjg1OTBjODg1Zjc2Nzk2ZTM0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogVHVlLCAxOSBOb3YgMjAxMyAxMjo1ODowOCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBDaGVjayBTTUIzIGRpYWxlY3RzIGFnYWluc3QgZG93bmdyYWRlIGF0dGFja3MKCldoZW4gd2Ug
YXJlIHJ1bm5pbmcgU01CMyBvciBTTUIzLjAyIGNvbm5lY3Rpb25zIHdoaWNoIGFyZSBzaWduZWQK
d2UgbmVlZCB0byB2YWxpZGF0ZSB0aGUgcHJvdG9jb2wgbmVnb3RpYXRpb24gaW5mb3JtYXRpb24s
CnRvIGVuc3VyZSB0aGF0IHRoZW5lZ290aWF0ZSBwcm90b2NvbCByZXNwb25zZSB3YXMgbm90IHRh
bXBlcmVkIHdpdGguCgpBZGQgdGhlIG1pc3NpbmcgRlNDVEwgd2hpY2ggaXMgc2VudCBhdCBtb3Vu
dCB0aW1lIChpbW1lZGlhdGVseSBhZnRlcgp0aGUgU01CMyBUcmVlIENvbm5lY3QpIHRvIHZhbGlk
YXRlIHRoYXQgdGhlIGNhcGFiaWxpdGllcyBtYXRjaAp3aGF0IHdlIHRoaW5rIHRoZSBzZXJ2ZXIg
c2VudC4KCiJTZWN1cmUgZGlhbGVjdCBuZWdvdGlhdGlvbiBpcyBpbnRyb2R1Y2VkIGluIFNNQjMg
dG8gcHJvdGVjdCBhZ2FpbnN0Cm1hbi1pbi10aGUtbWlkZGxlIGF0dGVtcHQgdG8gZG93bmdyYWRl
IGRpYWxlY3QgbmVnb3RpYXRpb24uClRoZSBpZGVhIGlzIHRvIHByZXZlbnQgYW4gZWF2ZXNkcm9w
cGVyIGZyb20gZG93bmdyYWRpbmcgdGhlIGluaXRpYWxseQpuZWdvdGlhdGVkIGRpYWxlY3QgYW5k
IGNhcGFiaWxpdGllcyBiZXR3ZWVuIHRoZSBjbGllbnQgYW5kIHRoZSBzZXJ2ZXIuIgoKRm9yIG1v
cmUgZXhwbGFuYXRpb24gc2VlIDIuMi4zMS40IG9mIE1TLVNNQjIgb3IKaHR0cDovL2Jsb2dzLm1z
ZG4uY29tL2Ivb3BlbnNwZWNpZmljYXRpb24vYXJjaGl2ZS8yMDEyLzA2LzI4L3NtYjMtc2VjdXJl
LWRpYWxlY3QtbmVnb3RpYXRpb24uYXNweAoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxz
bWZyZW5jaEBnbWFpbC5jb20+Ci0tLQogZnMvY2lmcy9jaWZzZ2xvYi5oICB8ICAxICsKIGZzL2Np
ZnMvc21iMm9wcy5jICAgfCAgMSArCiBmcy9jaWZzL3NtYjJwZHUuYyAgIHwgNzYgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvc21i
MnBkdS5oICAgfCAxMiArKysrKystLS0KIGZzL2NpZnMvc21iMnByb3RvLmggfCAgMSArCiBmcy9j
aWZzL3NtYmZzY3RsLmggIHwgIDIgKy0KIDYgZmlsZXMgY2hhbmdlZCwgODkgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9j
aWZzL2NpZnNnbG9iLmgKaW5kZXggZDllYTdhZC4uZjkxOGE5OSAxMDA2NDQKLS0tIGEvZnMvY2lm
cy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApAQCAtMzg0LDYgKzM4NCw3IEBA
IHN0cnVjdCBzbWJfdmVyc2lvbl9vcGVyYXRpb25zIHsKIAlpbnQgKCpjbG9uZV9yYW5nZSkoY29u
c3QgdW5zaWduZWQgaW50LCBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpzcmNfZmlsZSwKIAkJCXN0cnVj
dCBjaWZzRmlsZUluZm8gKnRhcmdldF9maWxlLCB1NjQgc3JjX29mZiwgdTY0IGxlbiwKIAkJCXU2
NCBkZXN0X29mZik7CisJaW50ICgqdmFsaWRhdGVfbmVnb3RpYXRlKShjb25zdCB1bnNpZ25lZCBp
bnQsIHN0cnVjdCBjaWZzX3Rjb24gKik7CiB9OwogCiBzdHJ1Y3Qgc21iX3ZlcnNpb25fdmFsdWVz
IHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5k
ZXggYTM5NjhlZS4uNzU3ZGEzZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIv
ZnMvY2lmcy9zbWIyb3BzLmMKQEAgLTEzMTksNiArMTMxOSw3IEBAIHN0cnVjdCBzbWJfdmVyc2lv
bl9vcGVyYXRpb25zIHNtYjMwX29wZXJhdGlvbnMgPSB7CiAJLmNyZWF0ZV9sZWFzZV9idWYgPSBz
bWIzX2NyZWF0ZV9sZWFzZV9idWYsCiAJLnBhcnNlX2xlYXNlX2J1ZiA9IHNtYjNfcGFyc2VfbGVh
c2VfYnVmLAogCS5jbG9uZV9yYW5nZSA9IHNtYjJfY2xvbmVfcmFuZ2UsCisJLnZhbGlkYXRlX25l
Z290aWF0ZSA9IHNtYjNfdmFsaWRhdGVfbmVnb3RpYXRlLAogfTsKIAogc3RydWN0IHNtYl92ZXJz
aW9uX3ZhbHVlcyBzbWIyMF92YWx1ZXMgPSB7CmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJwZHUu
YyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IDFlMTM2ZWUuLjc3NTZmOWIgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5jCkBAIC00NTQsNiArNDU0
LDgwIEBAIG5lZ19leGl0OgogCXJldHVybiByYzsKIH0KIAoraW50IHNtYjNfdmFsaWRhdGVfbmVn
b3RpYXRlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCit7
CisJaW50IHJjID0gMDsKKwlzdHJ1Y3QgdmFsaWRhdGVfbmVnb3RpYXRlX2luZm9fcmVxIHZuZWdf
aW5idWY7CisJc3RydWN0IHZhbGlkYXRlX25lZ290aWF0ZV9pbmZvX3JzcCAqcG5lZ19yc3A7CisJ
dTMyIHJzcGxlbjsKKworCWNpZnNfZGJnKFZGUywgInZhbGlkYXRlIG5lZ290aWF0ZSAiKTsKKwl2
bmVnX2luYnVmLkNhcGFiaWxpdGllcyA9CisJCQljcHVfdG9fbGUzMih0Y29uLT5zZXMtPnNlcnZl
ci0+dmFscy0+cmVxX2NhcGFiaWxpdGllcyk7CisJbWVtY3B5KHZuZWdfaW5idWYuR3VpZCwgY2lm
c19jbGllbnRfZ3VpZCwgU01CMl9DTElFTlRfR1VJRF9TSVpFKTsKKworCS8qCisJICogdmFsaWRh
dGlvbiBpb2N0bCBtdXN0IGJlIHNpZ25lZCwgc28gbm8gcG9pbnQgc2VuZGluZyB0aGlzIGlmIHdl
CisJICogY2FuIG5vdCBzaWduIGl0LiAgV2UgY291bGQgZXZlbnR1YWxseSBjaGFuZ2UgdGhpcyB0
byBzZWxlY3RpdmVseQorCSAqIHNpZ24ganVzdCB0aGlzLCB0aGUgZmlyc3QgYW5kIG9ubHkgc2ln
bmVkIHJlcXVlc3Qgb24gYSBjb25uZWN0aW9uLgorCSAqIFRoaXMgaXMgZ29vZCBlbm91Z2ggZm9y
IG5vdyBzaW5jZSBhIHVzZXIgd2hvIHdhbnRzIGJldHRlciBzZWN1cml0eQorCSAqIHdvdWxkIGFs
c28gZW5hYmxlIHNpZ25pbmcgb24gdGhlIG1vdW50LiBIYXZpbmcgdmFsaWRhdGlvbiBvZgorCSAq
IG5lZ290aWF0ZSBpbmZvIGZvciBzaWduZWQgY29ubmVjdGlvbnMgaGVscHMgcmVkdWNlIGF0dGFj
ayB2ZWN0b3JzCisJICovCisJaWYgKHRjb24tPnNlcy0+c2VydmVyLT5zaWduID09IGZhbHNlKQor
CQlyZXR1cm4gMDsgLyogdmFsaWRhdGlvbiByZXF1aXJlcyBzaWduaW5nICovCisKKwlpZiAodGNv
bi0+c2VzLT5zaWduKQorCQl2bmVnX2luYnVmLlNlY3VyaXR5TW9kZSA9CisJCQljcHVfdG9fbGUx
NihTTUIyX05FR09USUFURV9TSUdOSU5HX1JFUVVJUkVEKTsKKwllbHNlIGlmIChnbG9iYWxfc2Vj
ZmxhZ3MgJiBDSUZTU0VDX01BWV9TSUdOKQorCQl2bmVnX2luYnVmLlNlY3VyaXR5TW9kZSA9CisJ
CQljcHVfdG9fbGUxNihTTUIyX05FR09USUFURV9TSUdOSU5HX0VOQUJMRUQpOworCWVsc2UKKwkJ
dm5lZ19pbmJ1Zi5TZWN1cml0eU1vZGUgPSAwOworCisJdm5lZ19pbmJ1Zi5EaWFsZWN0Q291bnQg
PSBjcHVfdG9fbGUxNigxKTsKKwl2bmVnX2luYnVmLkRpYWxlY3RzWzBdID0KKwkJY3B1X3RvX2xl
MTYodGNvbi0+c2VzLT5zZXJ2ZXItPnZhbHMtPnByb3RvY29sX2lkKTsKKworCXJjID0gU01CMl9p
b2N0bCh4aWQsIHRjb24sIE5PX0ZJTEVfSUQsIE5PX0ZJTEVfSUQsCisJCUZTQ1RMX1ZBTElEQVRF
X05FR09USUFURV9JTkZPLCB0cnVlIC8qIGlzX2ZzY3RsICovLAorCQkoY2hhciAqKSZ2bmVnX2lu
YnVmLCBzaXplb2Yoc3RydWN0IHZhbGlkYXRlX25lZ290aWF0ZV9pbmZvX3JlcSksCisJCShjaGFy
ICoqKSZwbmVnX3JzcCwgJnJzcGxlbik7CisKKwlpZiAocmMgIT0gMCkgeworCQljaWZzX2RiZyhW
RlMsICJ2YWxpZGF0ZSBwcm90b2NvbCBuZWdvdGlhdGUgZmFpbGVkOiAlZFxuIiwgcmMpOworCQly
ZXR1cm4gLUVJTzsKKwl9CisKKwlpZiAocnNwbGVuICE9IHNpemVvZihzdHJ1Y3QgdmFsaWRhdGVf
bmVnb3RpYXRlX2luZm9fcnNwKSkgeworCQljaWZzX2RiZyhWRlMsICJpbnZhbGlkIHNpemUgb2Yg
cHJvdG9jb2wgbmVnb3RpYXRlIHJlc3BvbnNlXG4iKTsKKwkJcmV0dXJuIC1FSU87CisJfQorCisJ
LyogY2hlY2sgdmFsaWRhdGUgbmVnb3RpYXRlIGluZm8gcmVzcG9uc2UgbWF0Y2hlcyB3aGF0IHdl
IGdvdCBlYXJsaWVyICovCisJaWYgKHBuZWdfcnNwLT5EaWFsZWN0ICE9CisJCQljcHVfdG9fbGUx
Nih0Y29uLT5zZXMtPnNlcnZlci0+dmFscy0+cHJvdG9jb2xfaWQpKQorCQlnb3RvIHZuZWdfb3V0
OworCisJaWYgKHBuZWdfcnNwLT5TZWN1cml0eU1vZGUgIT0gY3B1X3RvX2xlMTYodGNvbi0+c2Vz
LT5zZXJ2ZXItPnNlY19tb2RlKSkKKwkJZ290byB2bmVnX291dDsKKworCS8qIGRvIG5vdCB2YWxp
ZGF0ZSBzZXJ2ZXIgZ3VpZCBiZWNhdXNlIG5vdCBzYXZlZCBhdCBuZWdwcm90IHRpbWUgeWV0ICov
CisKKwlpZiAoKGxlMzJfdG9fY3B1KHBuZWdfcnNwLT5DYXBhYmlsaXRpZXMpIHwgU01CMl9OVF9G
SU5EIHwKKwkgICAgICBTTUIyX0xBUkdFX0ZJTEVTKSAhPSB0Y29uLT5zZXMtPnNlcnZlci0+Y2Fw
YWJpbGl0aWVzKQorCQlnb3RvIHZuZWdfb3V0OworCisJLyogdmFsaWRhdGUgbmVnb3RpYXRlIHN1
Y2Nlc3NmdWwgKi8KKwljaWZzX2RiZyhGWUksICJ2YWxpZGF0ZSBuZWdvdGlhdGUgaW5mbyBzdWNj
ZXNzZnVsXG4iKTsKKwlyZXR1cm4gMDsKKwordm5lZ19vdXQ6CisJY2lmc19kYmcoVkZTLCAicHJv
dG9jb2wgcmV2YWxpZGF0aW9uIC0gc2VjdXJpdHkgc2V0dGluZ3MgbWlzbWF0Y2hcbiIpOworCXJl
dHVybiAtRUlPOworfQorCiBpbnQKIFNNQjJfc2Vzc19zZXR1cChjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywKIAkJY29uc3Qgc3RydWN0IG5sc190YWJsZSAqbmxz
X2NwKQpAQCAtODI5LDYgKzkwMyw4IEBAIFNNQjJfdGNvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LCBzdHJ1Y3QgY2lmc19zZXMgKnNlcywgY29uc3QgY2hhciAqdHJlZSwKIAkgICAgKCh0Y29uLT5z
aGFyZV9mbGFncyAmIFNISTEwMDVfRkxBR1NfREZTKSA9PSAwKSkKIAkJY2lmc19kYmcoVkZTLCAi
REZTIGNhcGFiaWxpdHkgY29udHJhZGljdHMgREZTIGZsYWdcbiIpOwogCWluaXRfY29weV9jaHVu
a19kZWZhdWx0cyh0Y29uKTsKKwlpZiAodGNvbi0+c2VzLT5zZXJ2ZXItPm9wcy0+dmFsaWRhdGVf
bmVnb3RpYXRlKQorCQlyYyA9IHRjb24tPnNlcy0+c2VydmVyLT5vcHMtPnZhbGlkYXRlX25lZ290
aWF0ZSh4aWQsIHRjb24pOwogdGNvbl9leGl0OgogCWZyZWVfcnNwX2J1ZihyZXNwX2J1ZnR5cGUs
IHJzcCk7CiAJa2ZyZWUodW5jX3BhdGgpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1Lmgg
Yi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBmODgzMjBiLi4yMDIyYzU0IDEwMDY0NAotLS0gYS9m
cy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtNTc3LDEzICs1Nzcs
MTkgQEAgc3RydWN0IGNvcHljaHVua19pb2N0bF9yc3AgewogCV9fbGUzMiBUb3RhbEJ5dGVzV3Jp
dHRlbjsKIH0gX19wYWNrZWQ7CiAKLS8qIFJlc3BvbnNlIGFuZCBSZXF1ZXN0IGFyZSB0aGUgc2Ft
ZSBmb3JtYXQgKi8KLXN0cnVjdCB2YWxpZGF0ZV9uZWdvdGlhdGVfaW5mbyB7CitzdHJ1Y3QgdmFs
aWRhdGVfbmVnb3RpYXRlX2luZm9fcmVxIHsKIAlfX2xlMzIgQ2FwYWJpbGl0aWVzOwogCV9fdTgg
ICBHdWlkW1NNQjJfQ0xJRU5UX0dVSURfU0laRV07CiAJX19sZTE2IFNlY3VyaXR5TW9kZTsKIAlf
X2xlMTYgRGlhbGVjdENvdW50OwotCV9fbGUxNiBEaWFsZWN0WzFdOworCV9fbGUxNiBEaWFsZWN0
c1sxXTsgLyogZGlhbGVjdCAoc29tZWRheSBtYXliZSBsaXN0KSBjbGllbnQgYXNrZWQgZm9yICov
Cit9IF9fcGFja2VkOworCitzdHJ1Y3QgdmFsaWRhdGVfbmVnb3RpYXRlX2luZm9fcnNwIHsKKwlf
X2xlMzIgQ2FwYWJpbGl0aWVzOworCV9fdTggICBHdWlkW1NNQjJfQ0xJRU5UX0dVSURfU0laRV07
CisJX19sZTE2IFNlY3VyaXR5TW9kZTsKKwlfX2xlMTYgRGlhbGVjdDsgLyogRGlhbGVjdCBpbiB1
c2UgZm9yIHRoZSBjb25uZWN0aW9uICovCiB9IF9fcGFja2VkOwogCiAjZGVmaW5lIFJTU19DQVBB
QkxFCTB4MDAwMDAwMDEKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnByb3RvLmggYi9mcy9jaWZz
L3NtYjJwcm90by5oCmluZGV4IGI0ZWVhMTAuLjkzYWRjNjQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
c21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtMTYyLDUgKzE2Miw2IEBA
IGV4dGVybiBpbnQgc21iMl9sb2Nrdihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCQkgICAgICBzdHJ1Y3Qgc21iMl9sb2NrX2VsZW1lbnQgKmJ1Zik7CiBl
eHRlcm4gaW50IFNNQjJfbGVhc2VfYnJlYWsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0
IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSAgICBfX3U4ICpsZWFzZV9rZXksIGNvbnN0IF9fbGUzMiBs
ZWFzZV9zdGF0ZSk7CitleHRlcm4gaW50IHNtYjNfdmFsaWRhdGVfbmVnb3RpYXRlKGNvbnN0IHVu
c2lnbmVkIGludCwgc3RydWN0IGNpZnNfdGNvbiAqKTsKIAogI2VuZGlmCQkJLyogX1NNQjJQUk9U
T19IICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYmZzY3RsLmggYi9mcy9jaWZzL3NtYmZzY3Rs
LmgKaW5kZXggYTRiMjM5MWYuLjBlNTM4YjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iZnNjdGwu
aAorKysgYi9mcy9jaWZzL3NtYmZzY3RsLmgKQEAgLTkwLDcgKzkwLDcgQEAKICNkZWZpbmUgRlND
VExfTE1SX1JFUVVFU1RfUkVTSUxJRU5DWSAweDAwMTQwMUQ0IC8qIEJCIGFkZCBzdHJ1Y3QgKi8K
ICNkZWZpbmUgRlNDVExfTE1SX0dFVF9MSU5LX1RSQUNLX0lORiAweDAwMTQwMEU4IC8qIEJCIGFk
ZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfTE1SX1NFVF9MSU5LX1RSQUNLX0lORiAweDAwMTQw
MEVDIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KLSNkZWZpbmUgRlNDVExfVkFMSURBVEVfTkVHT1RJQVRF
X0lORk8gMHgwMDE0MDIwNCAvKiBCQiBhZGQgc3RydWN0ICovCisjZGVmaW5lIEZTQ1RMX1ZBTElE
QVRFX05FR09USUFURV9JTkZPIDB4MDAxNDAyMDQKIC8qIFBlcmZvcm0gc2VydmVyLXNpZGUgZGF0
YSBtb3ZlbWVudCAqLwogI2RlZmluZSBGU0NUTF9TUlZfQ09QWUNIVU5LIDB4MDAxNDQwRjIKICNk
ZWZpbmUgRlNDVExfU1JWX0NPUFlDSFVOS19XUklURSAweDAwMTQ4MEYyCi0tIAoxLjguMy4xCgo=
--e89a8ff1c81810430004eb8c8da5--
