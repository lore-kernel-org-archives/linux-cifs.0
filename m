From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Validate Negotiate Updated Patch
Date: Mon, 18 Nov 2013 22:56:01 -0600
Message-ID: <CAH2r5mtkDZJ9ccAvp3sTw7hc8U4KWs0r3JqTNp-HXdVqqnxJaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec52162932d0d4f04eb807bd4
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--bcaec52162932d0d4f04eb807bd4
Content-Type: text/plain; charset=ISO-8859-1

This patch oopses in the calc signature code (will fix that tomorrow)
since the signing structs aren't initialized when we think we don't
have to do signing (but with SMB3 you always have to be able to do
signing) but is progress in validating negotiate info via the SMB3
fsctl.  Feedback/comments welcome.

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
index 1e136ee..8b9cc99 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -454,6 +454,70 @@ neg_exit:
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
+ /* BB need to force signing on this request */
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
@@ -829,6 +893,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
*ses, const char *tree,
     ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
  cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
  init_copy_chunk_defaults(tcon);
+ if (tcon->ses->server->ops->validate_negotiate)
+ rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
 tcon_exit:
  free_rsp_buf(resp_buftype, rsp);
  kfree(unc_path);
@@ -1161,6 +1227,10 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
  if (rc)
  return rc;

+ /* validate negotiate is always signed */
+ if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
+ req->hdr.Flags |= SMB2_FLAGS_SIGNED;
+
  req->CtlCode = cpu_to_le32(opcode);
  req->PersistentFileId = persistent_fid;
  req->VolatileFileId = volatile_fid;
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
Thanks,

Steve

--bcaec52162932d0d4f04eb807bd4
Content-Type: text/x-patch; charset=US-ASCII; name="validate-negotiate.patch"
Content-Disposition: attachment; filename="validate-negotiate.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho6o4sje0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY2lmc2dsb2IuaCBiL2ZzL2NpZnMvY2lmc2dsb2IuaAppbmRl
eCBkOWVhN2FkLi5mOTE4YTk5IDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNnbG9iLmgKKysrIGIv
ZnMvY2lmcy9jaWZzZ2xvYi5oCkBAIC0zODQsNiArMzg0LDcgQEAgc3RydWN0IHNtYl92ZXJzaW9u
X29wZXJhdGlvbnMgewogCWludCAoKmNsb25lX3JhbmdlKShjb25zdCB1bnNpZ25lZCBpbnQsIHN0
cnVjdCBjaWZzRmlsZUluZm8gKnNyY19maWxlLAogCQkJc3RydWN0IGNpZnNGaWxlSW5mbyAqdGFy
Z2V0X2ZpbGUsIHU2NCBzcmNfb2ZmLCB1NjQgbGVuLAogCQkJdTY0IGRlc3Rfb2ZmKTsKKwlpbnQg
KCp2YWxpZGF0ZV9uZWdvdGlhdGUpKGNvbnN0IHVuc2lnbmVkIGludCwgc3RydWN0IGNpZnNfdGNv
biAqKTsKIH07CiAKIHN0cnVjdCBzbWJfdmVyc2lvbl92YWx1ZXMgewpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9zbWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCBhMzk2OGVlLi43NTdkYTNl
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpA
QCAtMTMxOSw2ICsxMzE5LDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBf
b3BlcmF0aW9ucyA9IHsKIAkuY3JlYXRlX2xlYXNlX2J1ZiA9IHNtYjNfY3JlYXRlX2xlYXNlX2J1
ZiwKIAkucGFyc2VfbGVhc2VfYnVmID0gc21iM19wYXJzZV9sZWFzZV9idWYsCiAJLmNsb25lX3Jh
bmdlID0gc21iMl9jbG9uZV9yYW5nZSwKKwkudmFsaWRhdGVfbmVnb3RpYXRlID0gc21iM192YWxp
ZGF0ZV9uZWdvdGlhdGUsCiB9OwogCiBzdHJ1Y3Qgc21iX3ZlcnNpb25fdmFsdWVzIHNtYjIwX3Zh
bHVlcyA9IHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1
LmMKaW5kZXggMWUxMzZlZS4uOGI5Y2M5OSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMK
KysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTQ1NCw2ICs0NTQsNzAgQEAgbmVnX2V4aXQ6CiAJ
cmV0dXJuIHJjOwogfQogCitpbnQgc21iM192YWxpZGF0ZV9uZWdvdGlhdGUoY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKK3sKKwlpbnQgcmMgPSAwOworCXN0
cnVjdCB2YWxpZGF0ZV9uZWdvdGlhdGVfaW5mb19yZXEgdm5lZ19pbmJ1ZjsKKwlzdHJ1Y3QgdmFs
aWRhdGVfbmVnb3RpYXRlX2luZm9fcnNwICpwbmVnX3JzcDsKKwl1MzIgcnNwbGVuOworCisJY2lm
c19kYmcoVkZTLCAidmFsaWRhdGUgbmVnb3RpYXRlICIpOworCXZuZWdfaW5idWYuQ2FwYWJpbGl0
aWVzID0KKwkJCWNwdV90b19sZTMyKHRjb24tPnNlcy0+c2VydmVyLT52YWxzLT5yZXFfY2FwYWJp
bGl0aWVzKTsKKwltZW1jcHkodm5lZ19pbmJ1Zi5HdWlkLCBjaWZzX2NsaWVudF9ndWlkLCBTTUIy
X0NMSUVOVF9HVUlEX1NJWkUpOworCisJaWYgKHRjb24tPnNlcy0+c2lnbikKKwkJdm5lZ19pbmJ1
Zi5TZWN1cml0eU1vZGUgPQorCQkJY3B1X3RvX2xlMTYoU01CMl9ORUdPVElBVEVfU0lHTklOR19S
RVFVSVJFRCk7CisJZWxzZSBpZiAoZ2xvYmFsX3NlY2ZsYWdzICYgQ0lGU1NFQ19NQVlfU0lHTikK
KwkJdm5lZ19pbmJ1Zi5TZWN1cml0eU1vZGUgPQorCQkJY3B1X3RvX2xlMTYoU01CMl9ORUdPVElB
VEVfU0lHTklOR19FTkFCTEVEKTsKKwllbHNlCisJCXZuZWdfaW5idWYuU2VjdXJpdHlNb2RlID0g
MDsKKworCXZuZWdfaW5idWYuRGlhbGVjdENvdW50ID0gY3B1X3RvX2xlMTYoMSk7CisJdm5lZ19p
bmJ1Zi5EaWFsZWN0c1swXSA9CisJCWNwdV90b19sZTE2KHRjb24tPnNlcy0+c2VydmVyLT52YWxz
LT5wcm90b2NvbF9pZCk7CisKKwkvKiBCQiBuZWVkIHRvIGZvcmNlIHNpZ25pbmcgb24gdGhpcyBy
ZXF1ZXN0ICovCisJcmMgPSBTTUIyX2lvY3RsKHhpZCwgdGNvbiwgTk9fRklMRV9JRCwgTk9fRklM
RV9JRCwKKwkJRlNDVExfVkFMSURBVEVfTkVHT1RJQVRFX0lORk8sIHRydWUgLyogaXNfZnNjdGwg
Ki8sCisJCShjaGFyICopJnZuZWdfaW5idWYsIHNpemVvZihzdHJ1Y3QgdmFsaWRhdGVfbmVnb3Rp
YXRlX2luZm9fcmVxKSwKKwkJKGNoYXIgKiopJnBuZWdfcnNwLCAmcnNwbGVuKTsKKworCWlmIChy
YyAhPSAwKSB7CisJCWNpZnNfZGJnKFZGUywgInZhbGlkYXRlIHByb3RvY29sIG5lZ290aWF0ZSBm
YWlsZWQ6ICVkXG4iLCByYyk7CisJCXJldHVybiAtRUlPOworCX0KKworCWlmIChyc3BsZW4gIT0g
c2l6ZW9mKHN0cnVjdCB2YWxpZGF0ZV9uZWdvdGlhdGVfaW5mb19yc3ApKSB7CisJCWNpZnNfZGJn
KFZGUywgImludmFsaWQgc2l6ZSBvZiBwcm90b2NvbCBuZWdvdGlhdGUgcmVzcG9uc2VcbiIpOwor
CQlyZXR1cm4gLUVJTzsKKwl9CisKKwkvKiBjaGVjayB2YWxpZGF0ZSBuZWdvdGlhdGUgaW5mbyBy
ZXNwb25zZSBtYXRjaGVzIHdoYXQgd2UgZ290IGVhcmxpZXIgKi8KKwlpZiAocG5lZ19yc3AtPkRp
YWxlY3QgIT0KKwkJCWNwdV90b19sZTE2KHRjb24tPnNlcy0+c2VydmVyLT52YWxzLT5wcm90b2Nv
bF9pZCkpCisJCWdvdG8gdm5lZ19vdXQ7CisKKwlpZiAocG5lZ19yc3AtPlNlY3VyaXR5TW9kZSAh
PSBjcHVfdG9fbGUxNih0Y29uLT5zZXMtPnNlcnZlci0+c2VjX21vZGUpKQorCQlnb3RvIHZuZWdf
b3V0OworCisJLyogZG8gbm90IHZhbGlkYXRlIHNlcnZlciBndWlkIGJlY2F1c2Ugbm90IHNhdmVk
IGF0IG5lZ3Byb3QgdGltZSB5ZXQgKi8KKworCWlmICgobGUzMl90b19jcHUocG5lZ19yc3AtPkNh
cGFiaWxpdGllcykgfCBTTUIyX05UX0ZJTkQgfAorCSAgICAgIFNNQjJfTEFSR0VfRklMRVMpICE9
IHRjb24tPnNlcy0+c2VydmVyLT5jYXBhYmlsaXRpZXMpCisJCWdvdG8gdm5lZ19vdXQ7CisKKwkv
KiB2YWxpZGF0ZSBuZWdvdGlhdGUgc3VjY2Vzc2Z1bCAqLworCWNpZnNfZGJnKEZZSSwgInZhbGlk
YXRlIG5lZ290aWF0ZSBpbmZvIHN1Y2Nlc3NmdWxcbiIpOworCXJldHVybiAwOworCit2bmVnX291
dDoKKwljaWZzX2RiZyhWRlMsICJwcm90b2NvbCByZXZhbGlkYXRpb24gLSBzZWN1cml0eSBzZXR0
aW5ncyBtaXNtYXRjaFxuIik7CisJcmV0dXJuIC1FSU87Cit9CisKIGludAogU01CMl9zZXNzX3Nl
dHVwKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLAogCQljb25z
dCBzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY3ApCkBAIC04MjksNiArODkzLDggQEAgU01CMl90Y29u
KGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3NlcyAqc2VzLCBjb25zdCBjaGFy
ICp0cmVlLAogCSAgICAoKHRjb24tPnNoYXJlX2ZsYWdzICYgU0hJMTAwNV9GTEFHU19ERlMpID09
IDApKQogCQljaWZzX2RiZyhWRlMsICJERlMgY2FwYWJpbGl0eSBjb250cmFkaWN0cyBERlMgZmxh
Z1xuIik7CiAJaW5pdF9jb3B5X2NodW5rX2RlZmF1bHRzKHRjb24pOworCWlmICh0Y29uLT5zZXMt
PnNlcnZlci0+b3BzLT52YWxpZGF0ZV9uZWdvdGlhdGUpCisJCXJjID0gdGNvbi0+c2VzLT5zZXJ2
ZXItPm9wcy0+dmFsaWRhdGVfbmVnb3RpYXRlKHhpZCwgdGNvbik7CiB0Y29uX2V4aXQ6CiAJZnJl
ZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgcnNwKTsKIAlrZnJlZSh1bmNfcGF0aCk7CkBAIC0xMTYx
LDYgKzEyMjcsMTAgQEAgU01CMl9pb2N0bChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLCB1NjQgcGVyc2lzdGVudF9maWQsCiAJaWYgKHJjKQogCQlyZXR1cm4g
cmM7CiAKKwkvKiB2YWxpZGF0ZSBuZWdvdGlhdGUgaXMgYWx3YXlzIHNpZ25lZCAqLworCWlmIChv
cGNvZGUgPT0gRlNDVExfVkFMSURBVEVfTkVHT1RJQVRFX0lORk8pCisJCXJlcS0+aGRyLkZsYWdz
IHw9IFNNQjJfRkxBR1NfU0lHTkVEOworCiAJcmVxLT5DdGxDb2RlID0gY3B1X3RvX2xlMzIob3Bj
b2RlKTsKIAlyZXEtPlBlcnNpc3RlbnRGaWxlSWQgPSBwZXJzaXN0ZW50X2ZpZDsKIAlyZXEtPlZv
bGF0aWxlRmlsZUlkID0gdm9sYXRpbGVfZmlkOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1
LmggYi9mcy9jaWZzL3NtYjJwZHUuaAppbmRleCBmODgzMjBiLi4yMDIyYzU0IDEwMDY0NAotLS0g
YS9mcy9jaWZzL3NtYjJwZHUuaAorKysgYi9mcy9jaWZzL3NtYjJwZHUuaApAQCAtNTc3LDEzICs1
NzcsMTkgQEAgc3RydWN0IGNvcHljaHVua19pb2N0bF9yc3AgewogCV9fbGUzMiBUb3RhbEJ5dGVz
V3JpdHRlbjsKIH0gX19wYWNrZWQ7CiAKLS8qIFJlc3BvbnNlIGFuZCBSZXF1ZXN0IGFyZSB0aGUg
c2FtZSBmb3JtYXQgKi8KLXN0cnVjdCB2YWxpZGF0ZV9uZWdvdGlhdGVfaW5mbyB7CitzdHJ1Y3Qg
dmFsaWRhdGVfbmVnb3RpYXRlX2luZm9fcmVxIHsKIAlfX2xlMzIgQ2FwYWJpbGl0aWVzOwogCV9f
dTggICBHdWlkW1NNQjJfQ0xJRU5UX0dVSURfU0laRV07CiAJX19sZTE2IFNlY3VyaXR5TW9kZTsK
IAlfX2xlMTYgRGlhbGVjdENvdW50OwotCV9fbGUxNiBEaWFsZWN0WzFdOworCV9fbGUxNiBEaWFs
ZWN0c1sxXTsgLyogZGlhbGVjdCAoc29tZWRheSBtYXliZSBsaXN0KSBjbGllbnQgYXNrZWQgZm9y
ICovCit9IF9fcGFja2VkOworCitzdHJ1Y3QgdmFsaWRhdGVfbmVnb3RpYXRlX2luZm9fcnNwIHsK
KwlfX2xlMzIgQ2FwYWJpbGl0aWVzOworCV9fdTggICBHdWlkW1NNQjJfQ0xJRU5UX0dVSURfU0la
RV07CisJX19sZTE2IFNlY3VyaXR5TW9kZTsKKwlfX2xlMTYgRGlhbGVjdDsgLyogRGlhbGVjdCBp
biB1c2UgZm9yIHRoZSBjb25uZWN0aW9uICovCiB9IF9fcGFja2VkOwogCiAjZGVmaW5lIFJTU19D
QVBBQkxFCTB4MDAwMDAwMDEKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnByb3RvLmggYi9mcy9j
aWZzL3NtYjJwcm90by5oCmluZGV4IGI0ZWVhMTAuLjkzYWRjNjQgMTAwNjQ0Ci0tLSBhL2ZzL2Np
ZnMvc21iMnByb3RvLmgKKysrIGIvZnMvY2lmcy9zbWIycHJvdG8uaApAQCAtMTYyLDUgKzE2Miw2
IEBAIGV4dGVybiBpbnQgc21iMl9sb2Nrdihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc190Y29uICp0Y29uLAogCQkgICAgICBzdHJ1Y3Qgc21iMl9sb2NrX2VsZW1lbnQgKmJ1Zik7
CiBleHRlcm4gaW50IFNNQjJfbGVhc2VfYnJlYWsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSAgICBfX3U4ICpsZWFzZV9rZXksIGNvbnN0IF9fbGUz
MiBsZWFzZV9zdGF0ZSk7CitleHRlcm4gaW50IHNtYjNfdmFsaWRhdGVfbmVnb3RpYXRlKGNvbnN0
IHVuc2lnbmVkIGludCwgc3RydWN0IGNpZnNfdGNvbiAqKTsKIAogI2VuZGlmCQkJLyogX1NNQjJQ
Uk9UT19IICovCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYmZzY3RsLmggYi9mcy9jaWZzL3NtYmZz
Y3RsLmgKaW5kZXggYTRiMjM5MWYuLjBlNTM4YjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iZnNj
dGwuaAorKysgYi9mcy9jaWZzL3NtYmZzY3RsLmgKQEAgLTkwLDcgKzkwLDcgQEAKICNkZWZpbmUg
RlNDVExfTE1SX1JFUVVFU1RfUkVTSUxJRU5DWSAweDAwMTQwMUQ0IC8qIEJCIGFkZCBzdHJ1Y3Qg
Ki8KICNkZWZpbmUgRlNDVExfTE1SX0dFVF9MSU5LX1RSQUNLX0lORiAweDAwMTQwMEU4IC8qIEJC
IGFkZCBzdHJ1Y3QgKi8KICNkZWZpbmUgRlNDVExfTE1SX1NFVF9MSU5LX1RSQUNLX0lORiAweDAw
MTQwMEVDIC8qIEJCIGFkZCBzdHJ1Y3QgKi8KLSNkZWZpbmUgRlNDVExfVkFMSURBVEVfTkVHT1RJ
QVRFX0lORk8gMHgwMDE0MDIwNCAvKiBCQiBhZGQgc3RydWN0ICovCisjZGVmaW5lIEZTQ1RMX1ZB
TElEQVRFX05FR09USUFURV9JTkZPIDB4MDAxNDAyMDQKIC8qIFBlcmZvcm0gc2VydmVyLXNpZGUg
ZGF0YSBtb3ZlbWVudCAqLwogI2RlZmluZSBGU0NUTF9TUlZfQ09QWUNIVU5LIDB4MDAxNDQwRjIK
ICNkZWZpbmUgRlNDVExfU1JWX0NPUFlDSFVOS19XUklURSAweDAwMTQ4MEYyCg==
--bcaec52162932d0d4f04eb807bd4--
