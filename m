From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv2] [CIFS] Allow setting per-file compression via CIFS protocol
Date: Sun, 13 Oct 2013 22:33:07 -0500
Message-ID: <CAH2r5mu+PiSKxB9GhyHApo4Gkj-p7jP+mT9rQB+5_RA2TF4rYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1134417e7319d004e8ab2036
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a1134417e7319d004e8ab2036
Content-Type: text/plain; charset=ISO-8859-1

(PATCHv2 updated to address build problem with SMB2 disabled in .config)

An earlier patch allowed setting the per-file compression flag

"chattr +c filename"

on an smb2 or smb3 mount, and also allowed lsattr to return
whether a file on a cifs, or smb2/smb3 mount was compressed.

This patch extends the ability to set the per-file
compression flag to the cifs protocol, which uses a somewhat
different IOCTL mechanism than SMB2, although the payload
(the flags stored in the compression_state) are the same.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifspdu.h   | 29 +++++++++++++++++++++++++++++
 fs/cifs/cifsproto.h |  2 ++
 fs/cifs/cifssmb.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb1ops.c   |  8 ++++++++
 fs/cifs/smb2pdu.h   |  9 ++++++---
 5 files changed, 98 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d40bd77..f9bb497 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1352,6 +1352,35 @@ typedef struct smb_com_transaction_ioctl_req {
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
+    __le16 compression_state;  /* See below for valid flags */
+} __attribute__((packed)) TRANSACT_COMPR_IOCTL_REQ;
+
+/* compression state flags */
+#define COMPRESSION_FORMAT_NONE        0x0000
+#define COMPRESSION_FORMAT_DEFAULT    0x0001
+#define COMPRESSION_FORMAT_LZNT1    0x0002
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
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 7e44f18..2a72ef2 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -573,9 +573,12 @@ struct compress_ioctl {
     __le16 CompressionState;
 } __packed;

-#define COMPRESSION_FORMAT_NONE        0x0000
-#define COMPRESSION_FORMAT_DEFAULT    0x0001
-#define COMPRESSION_FORMAT_LZNT1    0x0002
+/*
+ * These defines have been moved to cifspdu.h
+ * #define COMPRESSION_FORMAT_NONE    0x0000
+ * #define COMPRESSION_FORMAT_DEFAULT    0x0001
+ * #define COMPRESSION_FORMAT_LZNT1    0x0002
+ */
 struct smb2_ioctl_req {
     struct smb2_hdr hdr;
     __le16 StructureSize;    /* Must be 57 */
-- 
1.7.11.7


-- 
Thanks,

Steve

--001a1134417e7319d004e8ab2036
Content-Type: application/octet-stream;
	name="0001-CIFS-Allow-setting-per-file-compression-via-CIFS-pro.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Allow-setting-per-file-compression-via-CIFS-pro.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmr5bfxg0

RnJvbSAzNDNlOWFjZjQ2ZTcyMjhiMmQyMzg0ZDkwZWI3Mzg4M2UzMTQ0YzQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU3VuLCAxMyBPY3QgMjAxMyAyMjoxMzoyOSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
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
OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogZnMvY2lmcy9jaWZzcHJvdG8uaCB8ICAy
ICsrCiBmcy9jaWZzL2NpZnNzbWIuYyAgIHwgNTMgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysKIGZzL2NpZnMvc21iMW9wcy5jICAgfCAgOCArKysr
KysrKwogZnMvY2lmcy9zbWIycGR1LmggICB8ICA5ICsrKysrKy0tLQogNSBmaWxlcyBjaGFuZ2Vk
LCA5OCBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMv
Y2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1LmgKaW5kZXggZDQwYmQ3Ny4uZjliYjQ5NyAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9jaWZzcGR1LmgKKysrIGIvZnMvY2lmcy9jaWZzcGR1LmgKQEAgLTEz
NTIsNiArMTM1MiwzNSBAQCB0eXBlZGVmIHN0cnVjdCBzbWJfY29tX3RyYW5zYWN0aW9uX2lvY3Rs
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
b25fc3RhdGU7ICAvKiBTZWUgYmVsb3cgZm9yIHZhbGlkIGZsYWdzICovCit9IF9fYXR0cmlidXRl
X18oKHBhY2tlZCkpIFRSQU5TQUNUX0NPTVBSX0lPQ1RMX1JFUTsKKworLyogY29tcHJlc3Npb24g
c3RhdGUgZmxhZ3MgKi8KKyNkZWZpbmUgQ09NUFJFU1NJT05fRk9STUFUX05PTkUJCTB4MDAwMAor
I2RlZmluZSBDT01QUkVTU0lPTl9GT1JNQVRfREVGQVVMVAkweDAwMDEKKyNkZWZpbmUgQ09NUFJF
U1NJT05fRk9STUFUX0xaTlQxCTB4MDAwMgorCiB0eXBlZGVmIHN0cnVjdCBzbWJfY29tX3RyYW5z
YWN0aW9uX2lvY3RsX3JzcCB7CiAJc3RydWN0IHNtYl9oZHIgaGRyOwkvKiB3Y3QgPSAxOSAqLwog
CV9fdTggUmVzZXJ2ZWRbM107CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNwcm90by5oIGIvZnMv
Y2lmcy9jaWZzcHJvdG8uaAppbmRleCBiNWVjMmEyLi5hYTMzOTc2IDEwMDY0NAotLS0gYS9mcy9j
aWZzL2NpZnNwcm90by5oCisrKyBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKQEAgLTM2MCw2ICszNjAs
OCBAQCBleHRlcm4gaW50IENJRlNTTUJVbml4UXVlcnlTeW1MaW5rKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsCiBleHRlcm4gaW50IENJRlNTTUJRdWVyeVN5bUxpbmsoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAkJCSAgICAgICBfX3UxNiBmaWQsIGNoYXIg
KipzeW1saW5raW5mbywKIAkJCSAgICAgICBjb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICpubHNfY29k
ZXBhZ2UpOworZXh0ZXJuIGludCBDSUZTU01CX3NldF9jb21wcmVzc2lvbihjb25zdCB1bnNpZ25l
ZCBpbnQgeGlkLAorCQkJCSAgIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sIF9fdTE2IGZpZCk7CiBl
eHRlcm4gaW50IENJRlNTTUJPcGVuKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZz
X3Rjb24gKnRjb24sCiAJCQljb25zdCBjaGFyICpmaWxlTmFtZSwgY29uc3QgaW50IGRpc3Bvc2l0
aW9uLAogCQkJY29uc3QgaW50IGFjY2Vzc19mbGFncywgY29uc3QgaW50IG9tb2RlLApkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2NpZnNzbWIuYwppbmRleCBjY2QzMWFi
Li5lYzU3ZGRlIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNzbWIuYworKysgYi9mcy9jaWZzL2Np
ZnNzbWIuYwpAQCAtMzE5OSw2ICszMTk5LDU5IEBAIHFyZXBhcnNlX291dDoKIAlyZXR1cm4gcmM7
CiB9CiAKK2ludAorQ0lGU1NNQl9zZXRfY29tcHJlc3Npb24oY29uc3QgdW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKKwkJICAgIF9fdTE2IGZpZCkKK3sKKwlpbnQgcmMg
PSAwOworCWludCBieXRlc19yZXR1cm5lZDsKKwlzdHJ1Y3Qgc21iX2NvbV90cmFuc2FjdGlvbl9j
b21wcl9pb2N0bF9yZXEgKnBTTUI7CisJc3RydWN0IHNtYl9jb21fdHJhbnNhY3Rpb25faW9jdGxf
cnNwICpwU01CcjsKKworCWNpZnNfZGJnKEZZSSwgIlNldCBjb21wcmVzc2lvbiBmb3IgJXVcbiIs
IGZpZCk7CisJcmMgPSBzbWJfaW5pdChTTUJfQ09NX05UX1RSQU5TQUNULCAyMywgdGNvbiwgKHZv
aWQgKiopICZwU01CLAorCQkgICAgICAodm9pZCAqKikgJnBTTUJyKTsKKwlpZiAocmMpCisJCXJl
dHVybiByYzsKKworCXBTTUItPmNvbXByZXNzaW9uX3N0YXRlID0gY3B1X3RvX2xlMTYoQ09NUFJF
U1NJT05fRk9STUFUX0RFRkFVTFQpOworCisJcFNNQi0+VG90YWxQYXJhbWV0ZXJDb3VudCA9IDA7
CisJcFNNQi0+VG90YWxEYXRhQ291bnQgPSBjcHVfdG9fbGUzMigyKTsKKwlwU01CLT5NYXhQYXJh
bWV0ZXJDb3VudCA9IDA7CisJcFNNQi0+TWF4RGF0YUNvdW50ID0gMDsKKwlwU01CLT5NYXhTZXR1
cENvdW50ID0gNDsKKwlwU01CLT5SZXNlcnZlZCA9IDA7CisJcFNNQi0+UGFyYW1ldGVyT2Zmc2V0
ID0gMDsKKwlwU01CLT5EYXRhQ291bnQgPSBjcHVfdG9fbGUzMigyKTsKKwlwU01CLT5EYXRhT2Zm
c2V0ID0KKwkJY3B1X3RvX2xlMzIob2Zmc2V0b2Yoc3RydWN0IHNtYl9jb21fdHJhbnNhY3Rpb25f
Y29tcHJfaW9jdGxfcmVxLAorCQkJCWNvbXByZXNzaW9uX3N0YXRlKSAtIDQpOyAgLyogODQgKi8K
KwlwU01CLT5TZXR1cENvdW50ID0gNDsKKwlwU01CLT5TdWJDb21tYW5kID0gY3B1X3RvX2xlMTYo
TlRfVFJBTlNBQ1RfSU9DVEwpOworCXBTTUItPlBhcmFtZXRlckNvdW50ID0gMDsKKwlwU01CLT5G
dW5jdGlvbkNvZGUgPSBjcHVfdG9fbGUzMihGU0NUTF9TRVRfQ09NUFJFU1NJT04pOworCXBTTUIt
PklzRnNjdGwgPSAxOyAvKiBGU0NUTCAqLworCXBTTUItPklzUm9vdEZsYWcgPSAwOworCXBTTUIt
PkZpZCA9IGZpZDsgLyogZmlsZSBoYW5kbGUgYWx3YXlzIGxlICovCisJcFNNQi0+Qnl0ZUNvdW50
ID0gY3B1X3RvX2xlMTYoNSk7IC8qIDMgYnl0ZSBwYWQgMiBieXRlIGNvbXByZXNzIHN0YXRlICov
CisJaW5jX3JmYzEwMDFfbGVuKHBTTUIsIDUpOworCisJcmMgPSBTZW5kUmVjZWl2ZSh4aWQsIHRj
b24tPnNlcywgKHN0cnVjdCBzbWJfaGRyICopIHBTTUIsCisJCQkgKHN0cnVjdCBzbWJfaGRyICop
IHBTTUJyLCAmYnl0ZXNfcmV0dXJuZWQsIDApOworCWlmIChyYykKKwkJY2lmc19kYmcoRllJLCAi
U2VuZCBlcnJvciBpbiBTZXRDb21wcmVzc2lvbiA9ICVkXG4iLCByYyk7CisKKwljaWZzX2J1Zl9y
ZWxlYXNlKHBTTUIpOworCisJLyoKKwkgKiBOb3RlOiBPbiAtRUFHQUlOIGVycm9yIG9ubHkgY2Fs
bGVyIGNhbiByZXRyeSBvbiBoYW5kbGUgYmFzZWQgY2FsbHMKKwkgKiBzaW5jZSBmaWxlIGhhbmRs
ZSBwYXNzZWQgaW4gbm8gbG9uZ2VyIHZhbGlkLgorCSAqLworCXJldHVybiByYzsKK30KKworCiAj
aWZkZWYgQ09ORklHX0NJRlNfUE9TSVgKIAogLypDb252ZXJ0IGFuIEFjY2VzcyBDb250cm9sIEVu
dHJ5IGZyb20gd2lyZSBmb3JtYXQgdG8gbG9jYWwgUE9TSVggeGF0dHIgZm9ybWF0Ki8KZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvc21iMW9wcy5jIGIvZnMvY2lmcy9zbWIxb3BzLmMKaW5kZXggODIzM2Ix
Ny4uZWE5OWVmZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIxb3BzLmMKKysrIGIvZnMvY2lmcy9z
bWIxb3BzLmMKQEAgLTgwNyw2ICs4MDcsMTMgQEAgb3V0OgogfQogCiBzdGF0aWMgaW50CitjaWZz
X3NldF9jb21wcmVzc2lvbihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAorCQkgICBzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSkKK3sKKwlyZXR1cm4gQ0lG
U1NNQl9zZXRfY29tcHJlc3Npb24oeGlkLCB0Y29uLCBjZmlsZS0+ZmlkLm5ldGZpZCk7Cit9CisK
K3N0YXRpYyBpbnQKIGNpZnNfcXVlcnlfZGlyX2ZpcnN0KGNvbnN0IHVuc2lnbmVkIGludCB4aWQs
IHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJCSAgICAgY29uc3QgY2hhciAqcGF0aCwgc3RydWN0
IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwKIAkJICAgICBzdHJ1Y3QgY2lmc19maWQgKmZpZCwgX191
MTYgc2VhcmNoX2ZsYWdzLApAQCAtOTU2LDYgKzk2Myw3IEBAIHN0cnVjdCBzbWJfdmVyc2lvbl9v
cGVyYXRpb25zIHNtYjFfb3BlcmF0aW9ucyA9IHsKIAkuc2V0X3BhdGhfc2l6ZSA9IENJRlNTTUJT
ZXRFT0YsCiAJLnNldF9maWxlX3NpemUgPSBDSUZTU01CU2V0RmlsZVNpemUsCiAJLnNldF9maWxl
X2luZm8gPSBzbWJfc2V0X2ZpbGVfaW5mbywKKwkuc2V0X2NvbXByZXNzaW9uID0gY2lmc19zZXRf
Y29tcHJlc3Npb24sCiAJLmVjaG8gPSBDSUZTU01CRWNobywKIAkubWtkaXIgPSBDSUZTU01CTWtE
aXIsCiAJLm1rZGlyX3NldGluZm8gPSBjaWZzX21rZGlyX3NldGluZm8sCmRpZmYgLS1naXQgYS9m
cy9jaWZzL3NtYjJwZHUuaCBiL2ZzL2NpZnMvc21iMnBkdS5oCmluZGV4IDdlNDRmMTguLjJhNzJl
ZjIgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5oCisrKyBiL2ZzL2NpZnMvc21iMnBkdS5o
CkBAIC01NzMsOSArNTczLDEyIEBAIHN0cnVjdCBjb21wcmVzc19pb2N0bCB7CiAJX19sZTE2IENv
bXByZXNzaW9uU3RhdGU7CiB9IF9fcGFja2VkOwogCi0jZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1B
VF9OT05FCQkweDAwMDAKLSNkZWZpbmUgQ09NUFJFU1NJT05fRk9STUFUX0RFRkFVTFQJMHgwMDAx
Ci0jZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1BVF9MWk5UMQkweDAwMDIKKy8qCisgKiBUaGVzZSBk
ZWZpbmVzIGhhdmUgYmVlbiBtb3ZlZCB0byBjaWZzcGR1LmgKKyAqICNkZWZpbmUgQ09NUFJFU1NJ
T05fRk9STUFUX05PTkUJMHgwMDAwCisgKiAjZGVmaW5lIENPTVBSRVNTSU9OX0ZPUk1BVF9ERUZB
VUxUCTB4MDAwMQorICogI2RlZmluZSBDT01QUkVTU0lPTl9GT1JNQVRfTFpOVDEJMHgwMDAyCisg
Ki8KIHN0cnVjdCBzbWIyX2lvY3RsX3JlcSB7CiAJc3RydWN0IHNtYjJfaGRyIGhkcjsKIAlfX2xl
MTYgU3RydWN0dXJlU2l6ZTsJLyogTXVzdCBiZSA1NyAqLwotLSAKMS43LjExLjcKCg==
--001a1134417e7319d004e8ab2036--
