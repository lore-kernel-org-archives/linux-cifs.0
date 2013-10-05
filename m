From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fix cifs symlink handling of "NFS" reparse point symlinks
Date: Fri, 4 Oct 2013 21:59:39 -0500
Message-ID: <CAH2r5mtHFLex2Cck7YMny3HQz2mh4-qTw1JhGiAAW_3JojrDhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b86e5402c523c04e7f59c5d
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b86e5402c523c04e7f59c5d
Content-Type: text/plain; charset=ISO-8859-1

>From 8d615dc23963a48f8177c143f05e859aa6b549a0 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Date: Sat, 28 Sep 2013 18:24:12 -0500
Subject: [PATCH] [CIFS] do not treat non-symlink reparse points as valid
 symlinks

Windows 8 and later can create NFS symlinks (within reparse points)
which we were assuming were normal NTFS symlinks and thus reporting
corrupt paths for.  Add check for reparse points to make sure that
they really are normal symlinks before we try to parse the pathname.

We also should not be parsing other types of reparse points (DFS
junctions etc) as if they were a  symlink so return EOPNOTSUPP
on those.  Also fix endian errors (we were not parsing symlink
lengths as little endian).  With this patch we also return EOPNOTSUPP on
the other non-symlink types of "NFS" reparse points ie those
for fifos, char and block special devices.   We can add support
for these in a followon patch.

In debugging the "NFS symlink" problem, I noticed that
although we support NTFS style file symlinks and now properly
handle "NFS" style symlinks - we don't support NTFS "directory"
symlinks (ie those created by "mklink /D" in Windows).

This patch fixes commit d244bf2dfbebfded05f494ffd53659fa7b1e32c1
which implemented follow link for non-Unix CIFS mounts

CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifspdu.h  | 31 +++++++++++++++++++++++--------
 fs/cifs/cifssmb.c  | 40 ++++++++++++++++++++++++++++++++++------
 fs/cifs/smbfsctl.h | 14 ++++++++++++++
 3 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index a630475..08f9dfb 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1491,15 +1491,30 @@ struct file_notify_information {
     __u8  FileName[0];
 } __attribute__((packed));

-struct reparse_data {
-    __u32    ReparseTag;
-    __u16    ReparseDataLength;
+/* For IO_REPARSE_TAG_SYMLINK */
+struct reparse_symlink_data {
+    __le32    ReparseTag;
+    __le16    ReparseDataLength;
     __u16    Reserved;
-    __u16    SubstituteNameOffset;
-    __u16    SubstituteNameLength;
-    __u16    PrintNameOffset;
-    __u16    PrintNameLength;
-    __u32    Flags;
+    __le16    SubstituteNameOffset;
+    __le16    SubstituteNameLength;
+    __le16    PrintNameOffset;
+    __le16    PrintNameLength;
+    __le32    Flags;
+    char    PathBuffer[0];
+} __attribute__((packed));
+
+/* For IO_REPARSE_TAG_NFS */
+#define NFS_SPECFILE_LNK    0x00000000014B4E4C
+#define NFS_SPECFILE_CHR    0x0000000000524843
+#define NFS_SPECFILE_BLK    0x00000000004B4C42
+#define NFS_SPECFILE_FIFO    0x000000004F464946
+#define NFS_SPECFILE_SOCK    0x000000004B434F53
+struct reparse_posix_data {
+    __le32    ReparseTag;
+    __le16    ReparseDataLength;
+    __u16    Reserved;
+    __le64    InodeType; /* LNK, FIFO, CHR etc. */
     char    PathBuffer[0];
 } __attribute__((packed));

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4baf359..ccd31ab 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3088,7 +3088,8 @@ CIFSSMBQuerySymLink(const unsigned int xid,
struct cifs_tcon *tcon,
     bool is_unicode;
     unsigned int sub_len;
     char *sub_start;
-    struct reparse_data *reparse_buf;
+    struct reparse_symlink_data *reparse_buf;
+    struct reparse_posix_data *posix_buf;
     __u32 data_offset, data_count;
     char *end_of_smb;

@@ -3137,20 +3138,47 @@ CIFSSMBQuerySymLink(const unsigned int xid,
struct cifs_tcon *tcon,
         goto qreparse_out;
     }
     end_of_smb = 2 + get_bcc(&pSMBr->hdr) + (char *)&pSMBr->ByteCount;
-    reparse_buf = (struct reparse_data *)
+    reparse_buf = (struct reparse_symlink_data *)
                 ((char *)&pSMBr->hdr.Protocol + data_offset);
     if ((char *)reparse_buf >= end_of_smb) {
         rc = -EIO;
         goto qreparse_out;
     }
-    if ((reparse_buf->PathBuffer + reparse_buf->PrintNameOffset +
-                reparse_buf->PrintNameLength) > end_of_smb) {
+    if (reparse_buf->ReparseTag == cpu_to_le32(IO_REPARSE_TAG_NFS)) {
+        cifs_dbg(FYI, "NFS style reparse tag\n");
+        posix_buf =  (struct reparse_posix_data *)reparse_buf;
+
+        if (posix_buf->InodeType != cpu_to_le64(NFS_SPECFILE_LNK)) {
+            cifs_dbg(FYI, "unsupported file type 0x%llx\n",
+                 le64_to_cpu(posix_buf->InodeType));
+            rc = -EOPNOTSUPP;
+            goto qreparse_out;
+        }
+        is_unicode = true;
+        sub_len = le16_to_cpu(reparse_buf->ReparseDataLength);
+        if (posix_buf->PathBuffer + sub_len > end_of_smb) {
+            cifs_dbg(FYI, "reparse buf beyond SMB\n");
+            rc = -EIO;
+            goto qreparse_out;
+        }
+        *symlinkinfo = cifs_strndup_from_utf16(posix_buf->PathBuffer,
+                sub_len, is_unicode, nls_codepage);
+        goto qreparse_out;
+    } else if (reparse_buf->ReparseTag !=
+            cpu_to_le32(IO_REPARSE_TAG_SYMLINK)) {
+        rc = -EOPNOTSUPP;
+        goto qreparse_out;
+    }
+
+    /* Reparse tag is NTFS symlink */
+    sub_start = le16_to_cpu(reparse_buf->SubstituteNameOffset) +
+                reparse_buf->PathBuffer;
+    sub_len = le16_to_cpu(reparse_buf->SubstituteNameLength);
+    if (sub_start + sub_len > end_of_smb) {
         cifs_dbg(FYI, "reparse buf beyond SMB\n");
         rc = -EIO;
         goto qreparse_out;
     }
-    sub_start = reparse_buf->SubstituteNameOffset + reparse_buf->PathBuffer;
-    sub_len = reparse_buf->SubstituteNameLength;
     if (pSMBr->hdr.Flags2 & SMBFLG2_UNICODE)
         is_unicode = true;
     else
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index d952ee4..a4b2391f 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -97,9 +97,23 @@
 #define FSCTL_QUERY_NETWORK_INTERFACE_INFO 0x001401FC /* BB add struct */
 #define FSCTL_SRV_READ_HASH          0x001441BB /* BB add struct */

+/* See FSCC 2.1.2.5 */
 #define IO_REPARSE_TAG_MOUNT_POINT   0xA0000003
 #define IO_REPARSE_TAG_HSM           0xC0000004
 #define IO_REPARSE_TAG_SIS           0x80000007
+#define IO_REPARSE_TAG_HSM2          0x80000006
+#define IO_REPARSE_TAG_DRIVER_EXTENDER 0x80000005
+/* Used by the DFS filter. See MS-DFSC */
+#define IO_REPARSE_TAG_DFS           0x8000000A
+/* Used by the DFS filter See MS-DFSC */
+#define IO_REPARSE_TAG_DFSR          0x80000012
+#define IO_REPARSE_TAG_FILTER_MANAGER 0x8000000B
+/* See section MS-FSCC 2.1.2.4 */
+#define IO_REPARSE_TAG_SYMLINK       0xA000000C
+#define IO_REPARSE_TAG_DEDUP         0x80000013
+#define IO_REPARSE_APPXSTREAM         0xC0000014
+/* NFS symlinks, Win 8/SMB3 and later */
+#define IO_REPARSE_TAG_NFS           0x80000014

 /* fsctl flags */
 /* If Flags is set to this value, the request is an FSCTL not ioctl request */
-- 
1.8.1.2


-- 
Thanks,

Steve

--047d7b86e5402c523c04e7f59c5d
Content-Type: application/octet-stream;
	name="0001-CIFS-do-not-treat-non-symlink-reparse-points-as-vali.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-do-not-treat-non-symlink-reparse-points-as-vali.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hme8x34r0

RnJvbSA4ZDYxNWRjMjM5NjNhNDhmODE3N2MxNDNmMDVlODU5YWE2YjU0OWEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQHVzLmlibS5jb20+CkRh
dGU6IFNhdCwgMjggU2VwIDIwMTMgMTg6MjQ6MTIgLTA1MDAKU3ViamVjdDogW1BBVENIXSBbQ0lG
U10gZG8gbm90IHRyZWF0IG5vbi1zeW1saW5rIHJlcGFyc2UgcG9pbnRzIGFzIHZhbGlkCiBzeW1s
aW5rcwoKV2luZG93cyA4IGFuZCBsYXRlciBjYW4gY3JlYXRlIE5GUyBzeW1saW5rcyAod2l0aGlu
IHJlcGFyc2UgcG9pbnRzKQp3aGljaCB3ZSB3ZXJlIGFzc3VtaW5nIHdlcmUgbm9ybWFsIE5URlMg
c3ltbGlua3MgYW5kIHRodXMgcmVwb3J0aW5nCmNvcnJ1cHQgcGF0aHMgZm9yLiAgQWRkIGNoZWNr
IGZvciByZXBhcnNlIHBvaW50cyB0byBtYWtlIHN1cmUgdGhhdAp0aGV5IHJlYWxseSBhcmUgbm9y
bWFsIHN5bWxpbmtzIGJlZm9yZSB3ZSB0cnkgdG8gcGFyc2UgdGhlIHBhdGhuYW1lLgoKV2UgYWxz
byBzaG91bGQgbm90IGJlIHBhcnNpbmcgb3RoZXIgdHlwZXMgb2YgcmVwYXJzZSBwb2ludHMgKERG
UwpqdW5jdGlvbnMgZXRjKSBhcyBpZiB0aGV5IHdlcmUgYSAgc3ltbGluayBzbyByZXR1cm4gRU9Q
Tk9UU1VQUApvbiB0aG9zZS4gIEFsc28gZml4IGVuZGlhbiBlcnJvcnMgKHdlIHdlcmUgbm90IHBh
cnNpbmcgc3ltbGluawpsZW5ndGhzIGFzIGxpdHRsZSBlbmRpYW4pLgoKVGhpcyBmaXhlcyBjb21t
aXQgZDI0NGJmMmRmYmViZmRlZDA1ZjQ5NGZmZDUzNjU5ZmE3YjFlMzJjMQp3aGljaCBpbXBsZW1l
bnRlZCBmb2xsb3cgbGluayBmb3Igbm9uLVVuaXggQ0lGUyBtb3VudHMKCkNDOiBTdGFibGUgPHN0
YWJsZUBrZXJuZWwub3JnPgpSZXZpZXdlZC1ieTogQW5kcmV3IEJhcnRsZXR0IDxhYmFydGxldEBz
YW1iYS5vcmc+ClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29t
PgotLS0KIGZzL2NpZnMvY2lmc3BkdS5oICB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0KIGZzL2NpZnMvY2lmc3NtYi5jICB8IDQwICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKystLS0tLS0KIGZzL2NpZnMvc21iZnNjdGwuaCB8IDE0ICsrKysrKysrKysrKysrCiAz
IGZpbGVzIGNoYW5nZWQsIDcxIGluc2VydGlvbnMoKyksIDE0IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc3BkdS5oIGIvZnMvY2lmcy9jaWZzcGR1LmgKaW5kZXggYTYzMDQ3
NS4uMDhmOWRmYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzcGR1LmgKKysrIGIvZnMvY2lmcy9j
aWZzcGR1LmgKQEAgLTE0OTEsMTUgKzE0OTEsMzAgQEAgc3RydWN0IGZpbGVfbm90aWZ5X2luZm9y
bWF0aW9uIHsKIAlfX3U4ICBGaWxlTmFtZVswXTsKIH0gX19hdHRyaWJ1dGVfXygocGFja2VkKSk7
CiAKLXN0cnVjdCByZXBhcnNlX2RhdGEgewotCV9fdTMyCVJlcGFyc2VUYWc7Ci0JX191MTYJUmVw
YXJzZURhdGFMZW5ndGg7CisvKiBGb3IgSU9fUkVQQVJTRV9UQUdfU1lNTElOSyAqLworc3RydWN0
IHJlcGFyc2Vfc3ltbGlua19kYXRhIHsKKwlfX2xlMzIJUmVwYXJzZVRhZzsKKwlfX2xlMTYJUmVw
YXJzZURhdGFMZW5ndGg7CiAJX191MTYJUmVzZXJ2ZWQ7Ci0JX191MTYJU3Vic3RpdHV0ZU5hbWVP
ZmZzZXQ7Ci0JX191MTYJU3Vic3RpdHV0ZU5hbWVMZW5ndGg7Ci0JX191MTYJUHJpbnROYW1lT2Zm
c2V0OwotCV9fdTE2CVByaW50TmFtZUxlbmd0aDsKLQlfX3UzMglGbGFnczsKKwlfX2xlMTYJU3Vi
c3RpdHV0ZU5hbWVPZmZzZXQ7CisJX19sZTE2CVN1YnN0aXR1dGVOYW1lTGVuZ3RoOworCV9fbGUx
NglQcmludE5hbWVPZmZzZXQ7CisJX19sZTE2CVByaW50TmFtZUxlbmd0aDsKKwlfX2xlMzIJRmxh
Z3M7CisJY2hhcglQYXRoQnVmZmVyWzBdOworfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsKKwor
LyogRm9yIElPX1JFUEFSU0VfVEFHX05GUyAqLworI2RlZmluZSBORlNfU1BFQ0ZJTEVfTE5LCTB4
MDAwMDAwMDAwMTRCNEU0QworI2RlZmluZSBORlNfU1BFQ0ZJTEVfQ0hSCTB4MDAwMDAwMDAwMDUy
NDg0MworI2RlZmluZSBORlNfU1BFQ0ZJTEVfQkxLCTB4MDAwMDAwMDAwMDRCNEM0MgorI2RlZmlu
ZSBORlNfU1BFQ0ZJTEVfRklGTwkweDAwMDAwMDAwNEY0NjQ5NDYKKyNkZWZpbmUgTkZTX1NQRUNG
SUxFX1NPQ0sJMHgwMDAwMDAwMDRCNDM0RjUzCitzdHJ1Y3QgcmVwYXJzZV9wb3NpeF9kYXRhIHsK
KwlfX2xlMzIJUmVwYXJzZVRhZzsKKwlfX2xlMTYJUmVwYXJzZURhdGFMZW5ndGg7CisJX191MTYJ
UmVzZXJ2ZWQ7CisJX19sZTY0CUlub2RlVHlwZTsgLyogTE5LLCBGSUZPLCBDSFIgZXRjLiAqLwog
CWNoYXIJUGF0aEJ1ZmZlclswXTsKIH0gX19hdHRyaWJ1dGVfXygocGFja2VkKSk7CiAKZGlmZiAt
LWdpdCBhL2ZzL2NpZnMvY2lmc3NtYi5jIGIvZnMvY2lmcy9jaWZzc21iLmMKaW5kZXggNGJhZjM1
OS4uY2NkMzFhYiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzc21iLmMKKysrIGIvZnMvY2lmcy9j
aWZzc21iLmMKQEAgLTMwODgsNyArMzA4OCw4IEBAIENJRlNTTUJRdWVyeVN5bUxpbmsoY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAlib29sIGlzX3VuaWNv
ZGU7CiAJdW5zaWduZWQgaW50IHN1Yl9sZW47CiAJY2hhciAqc3ViX3N0YXJ0OwotCXN0cnVjdCBy
ZXBhcnNlX2RhdGEgKnJlcGFyc2VfYnVmOworCXN0cnVjdCByZXBhcnNlX3N5bWxpbmtfZGF0YSAq
cmVwYXJzZV9idWY7CisJc3RydWN0IHJlcGFyc2VfcG9zaXhfZGF0YSAqcG9zaXhfYnVmOwogCV9f
dTMyIGRhdGFfb2Zmc2V0LCBkYXRhX2NvdW50OwogCWNoYXIgKmVuZF9vZl9zbWI7CiAKQEAgLTMx
MzcsMjAgKzMxMzgsNDcgQEAgQ0lGU1NNQlF1ZXJ5U3ltTGluayhjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCQlnb3RvIHFyZXBhcnNlX291dDsKIAl9CiAJ
ZW5kX29mX3NtYiA9IDIgKyBnZXRfYmNjKCZwU01Cci0+aGRyKSArIChjaGFyICopJnBTTUJyLT5C
eXRlQ291bnQ7Ci0JcmVwYXJzZV9idWYgPSAoc3RydWN0IHJlcGFyc2VfZGF0YSAqKQorCXJlcGFy
c2VfYnVmID0gKHN0cnVjdCByZXBhcnNlX3N5bWxpbmtfZGF0YSAqKQogCQkJCSgoY2hhciAqKSZw
U01Cci0+aGRyLlByb3RvY29sICsgZGF0YV9vZmZzZXQpOwogCWlmICgoY2hhciAqKXJlcGFyc2Vf
YnVmID49IGVuZF9vZl9zbWIpIHsKIAkJcmMgPSAtRUlPOwogCQlnb3RvIHFyZXBhcnNlX291dDsK
IAl9Ci0JaWYgKChyZXBhcnNlX2J1Zi0+UGF0aEJ1ZmZlciArIHJlcGFyc2VfYnVmLT5QcmludE5h
bWVPZmZzZXQgKwotCQkJCXJlcGFyc2VfYnVmLT5QcmludE5hbWVMZW5ndGgpID4gZW5kX29mX3Nt
YikgeworCWlmIChyZXBhcnNlX2J1Zi0+UmVwYXJzZVRhZyA9PSBjcHVfdG9fbGUzMihJT19SRVBB
UlNFX1RBR19ORlMpKSB7CisJCWNpZnNfZGJnKEZZSSwgIk5GUyBzdHlsZSByZXBhcnNlIHRhZ1xu
Iik7CisJCXBvc2l4X2J1ZiA9ICAoc3RydWN0IHJlcGFyc2VfcG9zaXhfZGF0YSAqKXJlcGFyc2Vf
YnVmOworCisJCWlmIChwb3NpeF9idWYtPklub2RlVHlwZSAhPSBjcHVfdG9fbGU2NChORlNfU1BF
Q0ZJTEVfTE5LKSkgeworCQkJY2lmc19kYmcoRllJLCAidW5zdXBwb3J0ZWQgZmlsZSB0eXBlIDB4
JWxseFxuIiwKKwkJCQkgbGU2NF90b19jcHUocG9zaXhfYnVmLT5Jbm9kZVR5cGUpKTsKKwkJCXJj
ID0gLUVPUE5PVFNVUFA7CisJCQlnb3RvIHFyZXBhcnNlX291dDsKKwkJfQorCQlpc191bmljb2Rl
ID0gdHJ1ZTsKKwkJc3ViX2xlbiA9IGxlMTZfdG9fY3B1KHJlcGFyc2VfYnVmLT5SZXBhcnNlRGF0
YUxlbmd0aCk7CisJCWlmIChwb3NpeF9idWYtPlBhdGhCdWZmZXIgKyBzdWJfbGVuID4gZW5kX29m
X3NtYikgeworCQkJY2lmc19kYmcoRllJLCAicmVwYXJzZSBidWYgYmV5b25kIFNNQlxuIik7CisJ
CQlyYyA9IC1FSU87CisJCQlnb3RvIHFyZXBhcnNlX291dDsKKwkJfQorCQkqc3ltbGlua2luZm8g
PSBjaWZzX3N0cm5kdXBfZnJvbV91dGYxNihwb3NpeF9idWYtPlBhdGhCdWZmZXIsCisJCQkJc3Vi
X2xlbiwgaXNfdW5pY29kZSwgbmxzX2NvZGVwYWdlKTsKKwkJZ290byBxcmVwYXJzZV9vdXQ7CisJ
fSBlbHNlIGlmIChyZXBhcnNlX2J1Zi0+UmVwYXJzZVRhZyAhPQorCQkJY3B1X3RvX2xlMzIoSU9f
UkVQQVJTRV9UQUdfU1lNTElOSykpIHsKKwkJcmMgPSAtRU9QTk9UU1VQUDsKKwkJZ290byBxcmVw
YXJzZV9vdXQ7CisJfQorCisJLyogUmVwYXJzZSB0YWcgaXMgTlRGUyBzeW1saW5rICovCisJc3Vi
X3N0YXJ0ID0gbGUxNl90b19jcHUocmVwYXJzZV9idWYtPlN1YnN0aXR1dGVOYW1lT2Zmc2V0KSAr
CisJCQkJcmVwYXJzZV9idWYtPlBhdGhCdWZmZXI7CisJc3ViX2xlbiA9IGxlMTZfdG9fY3B1KHJl
cGFyc2VfYnVmLT5TdWJzdGl0dXRlTmFtZUxlbmd0aCk7CisJaWYgKHN1Yl9zdGFydCArIHN1Yl9s
ZW4gPiBlbmRfb2Zfc21iKSB7CiAJCWNpZnNfZGJnKEZZSSwgInJlcGFyc2UgYnVmIGJleW9uZCBT
TUJcbiIpOwogCQlyYyA9IC1FSU87CiAJCWdvdG8gcXJlcGFyc2Vfb3V0OwogCX0KLQlzdWJfc3Rh
cnQgPSByZXBhcnNlX2J1Zi0+U3Vic3RpdHV0ZU5hbWVPZmZzZXQgKyByZXBhcnNlX2J1Zi0+UGF0
aEJ1ZmZlcjsKLQlzdWJfbGVuID0gcmVwYXJzZV9idWYtPlN1YnN0aXR1dGVOYW1lTGVuZ3RoOwog
CWlmIChwU01Cci0+aGRyLkZsYWdzMiAmIFNNQkZMRzJfVU5JQ09ERSkKIAkJaXNfdW5pY29kZSA9
IHRydWU7CiAJZWxzZQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWJmc2N0bC5oIGIvZnMvY2lmcy9z
bWJmc2N0bC5oCmluZGV4IGQ5NTJlZTQuLmE0YjIzOTFmIDEwMDY0NAotLS0gYS9mcy9jaWZzL3Nt
YmZzY3RsLmgKKysrIGIvZnMvY2lmcy9zbWJmc2N0bC5oCkBAIC05Nyw5ICs5NywyMyBAQAogI2Rl
ZmluZSBGU0NUTF9RVUVSWV9ORVRXT1JLX0lOVEVSRkFDRV9JTkZPIDB4MDAxNDAxRkMgLyogQkIg
YWRkIHN0cnVjdCAqLwogI2RlZmluZSBGU0NUTF9TUlZfUkVBRF9IQVNIICAgICAgICAgIDB4MDAx
NDQxQkIgLyogQkIgYWRkIHN0cnVjdCAqLwogCisvKiBTZWUgRlNDQyAyLjEuMi41ICovCiAjZGVm
aW5lIElPX1JFUEFSU0VfVEFHX01PVU5UX1BPSU5UICAgMHhBMDAwMDAwMwogI2RlZmluZSBJT19S
RVBBUlNFX1RBR19IU00gICAgICAgICAgIDB4QzAwMDAwMDQKICNkZWZpbmUgSU9fUkVQQVJTRV9U
QUdfU0lTICAgICAgICAgICAweDgwMDAwMDA3CisjZGVmaW5lIElPX1JFUEFSU0VfVEFHX0hTTTIg
ICAgICAgICAgMHg4MDAwMDAwNgorI2RlZmluZSBJT19SRVBBUlNFX1RBR19EUklWRVJfRVhURU5E
RVIgMHg4MDAwMDAwNQorLyogVXNlZCBieSB0aGUgREZTIGZpbHRlci4gU2VlIE1TLURGU0MgKi8K
KyNkZWZpbmUgSU9fUkVQQVJTRV9UQUdfREZTICAgICAgICAgICAweDgwMDAwMDBBCisvKiBVc2Vk
IGJ5IHRoZSBERlMgZmlsdGVyIFNlZSBNUy1ERlNDICovCisjZGVmaW5lIElPX1JFUEFSU0VfVEFH
X0RGU1IgICAgICAgICAgMHg4MDAwMDAxMgorI2RlZmluZSBJT19SRVBBUlNFX1RBR19GSUxURVJf
TUFOQUdFUiAweDgwMDAwMDBCCisvKiBTZWUgc2VjdGlvbiBNUy1GU0NDIDIuMS4yLjQgKi8KKyNk
ZWZpbmUgSU9fUkVQQVJTRV9UQUdfU1lNTElOSyAgICAgICAweEEwMDAwMDBDCisjZGVmaW5lIElP
X1JFUEFSU0VfVEFHX0RFRFVQICAgICAgICAgMHg4MDAwMDAxMworI2RlZmluZSBJT19SRVBBUlNF
X0FQUFhTVFJFQU0JICAgICAweEMwMDAwMDE0CisvKiBORlMgc3ltbGlua3MsIFdpbiA4L1NNQjMg
YW5kIGxhdGVyICovCisjZGVmaW5lIElPX1JFUEFSU0VfVEFHX05GUyAgICAgICAgICAgMHg4MDAw
MDAxNAogCiAvKiBmc2N0bCBmbGFncyAqLwogLyogSWYgRmxhZ3MgaXMgc2V0IHRvIHRoaXMgdmFs
dWUsIHRoZSByZXF1ZXN0IGlzIGFuIEZTQ1RMIG5vdCBpb2N0bCByZXF1ZXN0ICovCi0tIAoxLjgu
MS4yCgo=
--047d7b86e5402c523c04e7f59c5d--
