From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Allow setting per-file compression via CIFS protocol
Date: Sun, 13 Oct 2013 21:19:02 -0500
Message-ID: <CAH2r5muX8qA5qHBEZM97ByNM-zdVRkZ0gqnnA8Fh4fccE8VcEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b5d8d757f854804e8aa175c
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b5d8d757f854804e8aa175c
Content-Type: text/plain; charset=ISO-8859-1

An earlier patch allowed setting the per-file compression flag

"chattr +c filename"

on an smb2 or smb3 mount, and also allowed lsattr to return
whether a file on a cifs, or smb2/smb3 mount was compressed.

As suggested by Metze, this patch extends the ability to set
the per-file compression flag to the cifs protocol, which uses
a somewhat different IOCTL mechanism than SMB2,
although the payload (the flags stored in the compression_state)
are the same.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifspdu.h   | 24 ++++++++++++++++++++++++
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/cifssmb.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb1ops.c   |  8 ++++++++
 4 files changed, 87 insertions(+)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d40bd77..d963429 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1352,6 +1352,30 @@ typedef struct smb_com_transaction_ioctl_req {
     __u8 Data[1];
 } __attribute__((packed)) TRANSACT_IOCTL_REQ;

+typedef struct smb_com_transaction_compr_ioctl_req {
+    struct smb_hdr hdr;    /* wct = 23 */
+    __u8 MaxSetupCount;
+    __u16 Reserved;
+    __le32 TotalParameterCount;
+    __le32 TotalDataCount;
+    __le32 MaxParameterCount;
+    __le32 MaxDataCount;
+    __le32 ParameterCount;
+    __le32 ParameterOffset;
+    __le32 DataCount;
+    __le32 DataOffset;
+    __u8 SetupCount; /* four setup words follow subcommand */
+    /* SNIA spec incorrectly included spurious pad here */
+    __le16 SubCommand; /* 2 = IOCTL/FSCTL */
+    __le32 FunctionCode;
+    __u16 Fid;
+    __u8 IsFsctl;  /* 1 = File System Control 0 = device control (IOCTL) */
+    __u8 IsRootFlag; /* 1 = apply command to root of share (must be DFS) */
+    __le16 ByteCount;
+    __u8 Pad[3];
+    __le16 compression_state;  /* See similar SMB2 IOCTL for valid flags */
+} __attribute__((packed)) TRANSACT_COMPR_IOCTL_REQ;
+
 typedef struct smb_com_transaction_ioctl_rsp {
     struct smb_hdr hdr;    /* wct = 19 */
     __u8 Reserved[3];
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b5ec2a2..aa33976 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -360,6 +360,8 @@ extern int CIFSSMBUnixQuerySymLink(const unsigned int xid,
 extern int CIFSSMBQuerySymLink(const unsigned int xid, struct cifs_tcon *tcon,
                    __u16 fid, char **symlinkinfo,
                    const struct nls_table *nls_codepage);
+extern int CIFSSMB_set_compression(const unsigned int xid,
+                   struct cifs_tcon *tcon, __u16 fid);
 extern int CIFSSMBOpen(const unsigned int xid, struct cifs_tcon *tcon,
             const char *fileName, const int disposition,
             const int access_flags, const int omode,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ccd31ab..ec57dde 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3199,6 +3199,59 @@ qreparse_out:
     return rc;
 }

+int
+CIFSSMB_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
+            __u16 fid)
+{
+    int rc = 0;
+    int bytes_returned;
+    struct smb_com_transaction_compr_ioctl_req *pSMB;
+    struct smb_com_transaction_ioctl_rsp *pSMBr;
+
+    cifs_dbg(FYI, "Set compression for %u\n", fid);
+    rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
+              (void **) &pSMBr);
+    if (rc)
+        return rc;
+
+    pSMB->compression_state = cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
+
+    pSMB->TotalParameterCount = 0;
+    pSMB->TotalDataCount = cpu_to_le32(2);
+    pSMB->MaxParameterCount = 0;
+    pSMB->MaxDataCount = 0;
+    pSMB->MaxSetupCount = 4;
+    pSMB->Reserved = 0;
+    pSMB->ParameterOffset = 0;
+    pSMB->DataCount = cpu_to_le32(2);
+    pSMB->DataOffset =
+        cpu_to_le32(offsetof(struct smb_com_transaction_compr_ioctl_req,
+                compression_state) - 4);  /* 84 */
+    pSMB->SetupCount = 4;
+    pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_IOCTL);
+    pSMB->ParameterCount = 0;
+    pSMB->FunctionCode = cpu_to_le32(FSCTL_SET_COMPRESSION);
+    pSMB->IsFsctl = 1; /* FSCTL */
+    pSMB->IsRootFlag = 0;
+    pSMB->Fid = fid; /* file handle always le */
+    pSMB->ByteCount = cpu_to_le16(5); /* 3 byte pad 2 byte compress state */
+    inc_rfc1001_len(pSMB, 5);
+
+    rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
+             (struct smb_hdr *) pSMBr, &bytes_returned, 0);
+    if (rc)
+        cifs_dbg(FYI, "Send error in SetCompression = %d\n", rc);
+
+    cifs_buf_release(pSMB);
+
+    /*
+     * Note: On -EAGAIN error only caller can retry on handle based calls
+     * since file handle passed in no longer valid.
+     */
+    return rc;
+}
+
+
 #ifdef CONFIG_CIFS_POSIX

 /*Convert an Access Control Entry from wire format to local POSIX
xattr format*/
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8233b17..ea99efe 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -807,6 +807,13 @@ out:
 }

 static int
+cifs_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
+           struct cifsFileInfo *cfile)
+{
+    return CIFSSMB_set_compression(xid, tcon, cfile->fid.netfid);
+}
+
+static int
 cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
              const char *path, struct cifs_sb_info *cifs_sb,
              struct cifs_fid *fid, __u16 search_flags,
@@ -956,6 +963,7 @@ struct smb_version_operations smb1_operations = {
     .set_path_size = CIFSSMBSetEOF,
     .set_file_size = CIFSSMBSetFileSize,
     .set_file_info = smb_set_file_info,
+    .set_compression = cifs_set_compression,
     .echo = CIFSSMBEcho,
     .mkdir = CIFSSMBMkDir,
     .mkdir_setinfo = cifs_mkdir_setinfo,
-- 
1.7.11.7


-- 
Thanks,

Steve

--047d7b5d8d757f854804e8aa175c
Content-Type: application/octet-stream;
	name="0001-CIFS-Allow-setting-per-file-compression-via-CIFS-pro.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Allow-setting-per-file-compression-via-CIFS-pro.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmr2phqa0

RnJvbSA4YTkzYzhlZTNlZGM2NjgzZjgyNmY1MDM0NzFmMjRkNTMxMDQzY2VlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU3VuLCAxMyBPY3QgMjAxMyAyMTowNzoxNSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBBbGxvdyBzZXR0aW5nIHBlci1maWxlIGNvbXByZXNzaW9uIHZpYSBDSUZTIHByb3RvY29sCgpB
biBlYXJsaWVyIHBhdGNoIGFsbG93ZWQgc2V0dGluZyB0aGUgcGVyLWZpbGUgY29tcHJlc3Npb24g
ZmxhZwoKImNoYXR0ciArYyBmaWxlbmFtZSIKCm9uIGFuIHNtYjIgb3Igc21iMyBtb3VudCwgYW5k
IGFsc28gYWxsb3dlZCBsc2F0dHIgdG8gcmV0dXJuCndoZXRoZXIgYSBmaWxlIG9uIGEgY2lmcywg
b3Igc21iMi9zbWIzIG1vdW50IHdhcyBjb21wcmVzc2VkLgoKVGhpcyBwYXRjaCBleHRlbmRzIHRo
ZSBhYmlsaXR5IHRvIHNldCB0aGUgcGVyLWZpbGUKY29tcHJlc3Npb24gZmxhZyB0byB0aGUgY2lm
cyBwcm90b2NvbCwgd2hpY2ggdXNlcyBhIHNvbWV3aGF0CmRpZmZlcmVudCBJT0NUTCBtZWNoYW5p
c20gdGhhbiBTTUIyLCBhbHRob3VnaCB0aGUgcGF5bG9hZAoodGhlIGZsYWdzIHN0b3JlZCBpbiB0
aGUgY29tcHJlc3Npb25fc3RhdGUpIGFyZSB0aGUgc2FtZS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2NpZnMvY2lmc3BkdS5oICAgfCAy
NCArKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgMiArKwog
ZnMvY2lmcy9jaWZzc21iLmMgICB8IDUzICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrCiBmcy9jaWZzL3NtYjFvcHMuYyAgIHwgIDggKysrKysrKysK
IDQgZmlsZXMgY2hhbmdlZCwgODcgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1LmgKaW5kZXggZDQwYmQ3Ny4uZDk2MzQyOSAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzcGR1LmgKKysrIGIvZnMvY2lmcy9jaWZzcGR1LmgKQEAgLTEz
NTIsNiArMTM1MiwzMCBAQCB0eXBlZGVmIHN0cnVjdCBzbWJfY29tX3RyYW5zYWN0aW9uX2lvY3Rs
X3JlcSB7CiAJX191OCBEYXRhWzFdOwogfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKSBUUkFOU0FD
VF9JT0NUTF9SRVE7CiAKK3R5cGVkZWYgc3RydWN0IHNtYl9jb21fdHJhbnNhY3Rpb25fY29tcHJf
aW9jdGxfcmVxIHsKKwlzdHJ1Y3Qgc21iX2hkciBoZHI7CS8qIHdjdCA9IDIzICovCisJX191OCBN
YXhTZXR1cENvdW50OworCV9fdTE2IFJlc2VydmVkOworCV9fbGUzMiBUb3RhbFBhcmFtZXRlckNv
dW50OworCV9fbGUzMiBUb3RhbERhdGFDb3VudDsKKwlfX2xlMzIgTWF4UGFyYW1ldGVyQ291bnQ7
CisJX19sZTMyIE1heERhdGFDb3VudDsKKwlfX2xlMzIgUGFyYW1ldGVyQ291bnQ7CisJX19sZTMy
IFBhcmFtZXRlck9mZnNldDsKKwlfX2xlMzIgRGF0YUNvdW50OworCV9fbGUzMiBEYXRhT2Zmc2V0
OworCV9fdTggU2V0dXBDb3VudDsgLyogZm91ciBzZXR1cCB3b3JkcyBmb2xsb3cgc3ViY29tbWFu
ZCAqLworCS8qIFNOSUEgc3BlYyBpbmNvcnJlY3RseSBpbmNsdWRlZCBzcHVyaW91cyBwYWQgaGVy
ZSAqLworCV9fbGUxNiBTdWJDb21tYW5kOyAvKiAyID0gSU9DVEwvRlNDVEwgKi8KKwlfX2xlMzIg
RnVuY3Rpb25Db2RlOworCV9fdTE2IEZpZDsKKwlfX3U4IElzRnNjdGw7ICAvKiAxID0gRmlsZSBT
eXN0ZW0gQ29udHJvbCAwID0gZGV2aWNlIGNvbnRyb2wgKElPQ1RMKSAqLworCV9fdTggSXNSb290
RmxhZzsgLyogMSA9IGFwcGx5IGNvbW1hbmQgdG8gcm9vdCBvZiBzaGFyZSAobXVzdCBiZSBERlMp
ICovCisJX19sZTE2IEJ5dGVDb3VudDsKKwlfX3U4IFBhZFszXTsKKwlfX2xlMTYgY29tcHJlc3Np
b25fc3RhdGU7ICAvKiBTZWUgc2ltaWxhciBTTUIyIElPQ1RMIGZvciB2YWxpZCBmbGFncyAqLwor
fSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKSBUUkFOU0FDVF9DT01QUl9JT0NUTF9SRVE7CisKIHR5
cGVkZWYgc3RydWN0IHNtYl9jb21fdHJhbnNhY3Rpb25faW9jdGxfcnNwIHsKIAlzdHJ1Y3Qgc21i
X2hkciBoZHI7CS8qIHdjdCA9IDE5ICovCiAJX191OCBSZXNlcnZlZFszXTsKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IGI1ZWMyYTIu
LmFhMzM5NzYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgKKysrIGIvZnMvY2lmcy9j
aWZzcHJvdG8uaApAQCAtMzYwLDYgKzM2MCw4IEBAIGV4dGVybiBpbnQgQ0lGU1NNQlVuaXhRdWVy
eVN5bUxpbmsoY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIGV4dGVybiBpbnQgQ0lGU1NNQlF1ZXJ5
U3ltTGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAog
CQkJICAgICAgIF9fdTE2IGZpZCwgY2hhciAqKnN5bWxpbmtpbmZvLAogCQkJICAgICAgIGNvbnN0
IHN0cnVjdCBubHNfdGFibGUgKm5sc19jb2RlcGFnZSk7CitleHRlcm4gaW50IENJRlNTTUJfc2V0
X2NvbXByZXNzaW9uKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCisJCQkJICAgc3RydWN0IGNpZnNf
dGNvbiAqdGNvbiwgX191MTYgZmlkKTsKIGV4dGVybiBpbnQgQ0lGU1NNQk9wZW4oY29uc3QgdW5z
aWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCWNvbnN0IGNoYXIgKmZp
bGVOYW1lLCBjb25zdCBpbnQgZGlzcG9zaXRpb24sCiAJCQljb25zdCBpbnQgYWNjZXNzX2ZsYWdz
LCBjb25zdCBpbnQgb21vZGUsCmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNzbWIuYyBiL2ZzL2Np
ZnMvY2lmc3NtYi5jCmluZGV4IGNjZDMxYWIuLmVjNTdkZGUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMv
Y2lmc3NtYi5jCisrKyBiL2ZzL2NpZnMvY2lmc3NtYi5jCkBAIC0zMTk5LDYgKzMxOTksNTkgQEAg
cXJlcGFyc2Vfb3V0OgogCXJldHVybiByYzsKIH0KIAoraW50CitDSUZTU01CX3NldF9jb21wcmVz
c2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAorCQkg
ICAgX191MTYgZmlkKQoreworCWludCByYyA9IDA7CisJaW50IGJ5dGVzX3JldHVybmVkOworCXN0
cnVjdCBzbWJfY29tX3RyYW5zYWN0aW9uX2NvbXByX2lvY3RsX3JlcSAqcFNNQjsKKwlzdHJ1Y3Qg
c21iX2NvbV90cmFuc2FjdGlvbl9pb2N0bF9yc3AgKnBTTUJyOworCisJY2lmc19kYmcoRllJLCAi
U2V0IGNvbXByZXNzaW9uIGZvciAldVxuIiwgZmlkKTsKKwlyYyA9IHNtYl9pbml0KFNNQl9DT01f
TlRfVFJBTlNBQ1QsIDIzLCB0Y29uLCAodm9pZCAqKikgJnBTTUIsCisJCSAgICAgICh2b2lkICoq
KSAmcFNNQnIpOworCWlmIChyYykKKwkJcmV0dXJuIHJjOworCisJcFNNQi0+Y29tcHJlc3Npb25f
c3RhdGUgPSBjcHVfdG9fbGUxNihDT01QUkVTU0lPTl9GT1JNQVRfREVGQVVMVCk7CisKKwlwU01C
LT5Ub3RhbFBhcmFtZXRlckNvdW50ID0gMDsKKwlwU01CLT5Ub3RhbERhdGFDb3VudCA9IGNwdV90
b19sZTMyKDIpOworCXBTTUItPk1heFBhcmFtZXRlckNvdW50ID0gMDsKKwlwU01CLT5NYXhEYXRh
Q291bnQgPSAwOworCXBTTUItPk1heFNldHVwQ291bnQgPSA0OworCXBTTUItPlJlc2VydmVkID0g
MDsKKwlwU01CLT5QYXJhbWV0ZXJPZmZzZXQgPSAwOworCXBTTUItPkRhdGFDb3VudCA9IGNwdV90
b19sZTMyKDIpOworCXBTTUItPkRhdGFPZmZzZXQgPQorCQljcHVfdG9fbGUzMihvZmZzZXRvZihz
dHJ1Y3Qgc21iX2NvbV90cmFuc2FjdGlvbl9jb21wcl9pb2N0bF9yZXEsCisJCQkJY29tcHJlc3Np
b25fc3RhdGUpIC0gNCk7ICAvKiA4NCAqLworCXBTTUItPlNldHVwQ291bnQgPSA0OworCXBTTUIt
PlN1YkNvbW1hbmQgPSBjcHVfdG9fbGUxNihOVF9UUkFOU0FDVF9JT0NUTCk7CisJcFNNQi0+UGFy
YW1ldGVyQ291bnQgPSAwOworCXBTTUItPkZ1bmN0aW9uQ29kZSA9IGNwdV90b19sZTMyKEZTQ1RM
X1NFVF9DT01QUkVTU0lPTik7CisJcFNNQi0+SXNGc2N0bCA9IDE7IC8qIEZTQ1RMICovCisJcFNN
Qi0+SXNSb290RmxhZyA9IDA7CisJcFNNQi0+RmlkID0gZmlkOyAvKiBmaWxlIGhhbmRsZSBhbHdh
eXMgbGUgKi8KKwlwU01CLT5CeXRlQ291bnQgPSBjcHVfdG9fbGUxNig1KTsgLyogMyBieXRlIHBh
ZCAyIGJ5dGUgY29tcHJlc3Mgc3RhdGUgKi8KKwlpbmNfcmZjMTAwMV9sZW4ocFNNQiwgNSk7CisK
KwlyYyA9IFNlbmRSZWNlaXZlKHhpZCwgdGNvbi0+c2VzLCAoc3RydWN0IHNtYl9oZHIgKikgcFNN
QiwKKwkJCSAoc3RydWN0IHNtYl9oZHIgKikgcFNNQnIsICZieXRlc19yZXR1cm5lZCwgMCk7CisJ
aWYgKHJjKQorCQljaWZzX2RiZyhGWUksICJTZW5kIGVycm9yIGluIFNldENvbXByZXNzaW9uID0g
JWRcbiIsIHJjKTsKKworCWNpZnNfYnVmX3JlbGVhc2UocFNNQik7CisKKwkvKgorCSAqIE5vdGU6
IE9uIC1FQUdBSU4gZXJyb3Igb25seSBjYWxsZXIgY2FuIHJldHJ5IG9uIGhhbmRsZSBiYXNlZCBj
YWxscworCSAqIHNpbmNlIGZpbGUgaGFuZGxlIHBhc3NlZCBpbiBubyBsb25nZXIgdmFsaWQuCisJ
ICovCisJcmV0dXJuIHJjOworfQorCisKICNpZmRlZiBDT05GSUdfQ0lGU19QT1NJWAogCiAvKkNv
bnZlcnQgYW4gQWNjZXNzIENvbnRyb2wgRW50cnkgZnJvbSB3aXJlIGZvcm1hdCB0byBsb2NhbCBQ
T1NJWCB4YXR0ciBmb3JtYXQqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIxb3BzLmMgYi9mcy9j
aWZzL3NtYjFvcHMuYwppbmRleCA4MjMzYjE3Li5lYTk5ZWZlIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjFvcHMuYworKysgYi9mcy9jaWZzL3NtYjFvcHMuYwpAQCAtODA3LDYgKzgwNywxMyBAQCBv
dXQ6CiB9CiAKIHN0YXRpYyBpbnQKK2NpZnNfc2V0X2NvbXByZXNzaW9uKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCisJCSAgIHN0cnVjdCBjaWZzRmlsZUlu
Zm8gKmNmaWxlKQoreworCXJldHVybiBDSUZTU01CX3NldF9jb21wcmVzc2lvbih4aWQsIHRjb24s
IGNmaWxlLT5maWQubmV0ZmlkKTsKK30KKworc3RhdGljIGludAogY2lmc19xdWVyeV9kaXJfZmly
c3QoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJICAg
ICBjb25zdCBjaGFyICpwYXRoLCBzdHJ1Y3QgY2lmc19zYl9pbmZvICpjaWZzX3NiLAogCQkgICAg
IHN0cnVjdCBjaWZzX2ZpZCAqZmlkLCBfX3UxNiBzZWFyY2hfZmxhZ3MsCkBAIC05NTYsNiArOTYz
LDcgQEAgc3RydWN0IHNtYl92ZXJzaW9uX29wZXJhdGlvbnMgc21iMV9vcGVyYXRpb25zID0gewog
CS5zZXRfcGF0aF9zaXplID0gQ0lGU1NNQlNldEVPRiwKIAkuc2V0X2ZpbGVfc2l6ZSA9IENJRlNT
TUJTZXRGaWxlU2l6ZSwKIAkuc2V0X2ZpbGVfaW5mbyA9IHNtYl9zZXRfZmlsZV9pbmZvLAorCS5z
ZXRfY29tcHJlc3Npb24gPSBjaWZzX3NldF9jb21wcmVzc2lvbiwKIAkuZWNobyA9IENJRlNTTUJF
Y2hvLAogCS5ta2RpciA9IENJRlNTTUJNa0RpciwKIAkubWtkaXJfc2V0aW5mbyA9IGNpZnNfbWtk
aXJfc2V0aW5mbywKLS0gCjEuNy4xMS43Cgo=
--047d7b5d8d757f854804e8aa175c--
