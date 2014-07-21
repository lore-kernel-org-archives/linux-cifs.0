From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][SMB3] fallocate worker function
Date: Mon, 21 Jul 2014 12:35:59 -0500
Message-ID: <CAH2r5msQzVHbCQ0gZzPE9BHO3tNpGFZnUT5uBSgmyvR+d9Z+WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11c305807d048e04feb78bd1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a11c305807d048e04feb78bd1
Content-Type: text/plain; charset=UTF-8

>From 08c80cdc50e0d327234288cb0f628fdf5e80bc8d Mon Sep 17 00:00:00 2001
From: Steve French <sfrench-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Date: Sat, 19 Jul 2014 21:44:58 -0500
Subject: [PATCH] [CIFS] Add worker function to set allocation size

Adds setinfo worker function for SMB2/SMB3 support of SET_ALLOCATION_INFORMATION

Attached is one approach for adding the worker function to extend
a file's allocation size over SMB2/SMB3 mounts.   It is a very
small change to add a parm to SMB2_set_eof and seems the
easiest way.   I have experimented with two ways
of using this patch - via the fallocate VFS interface (in which
we have to be careful and check that we are not going
to shrink the file so that we follow the Linux semantics) and
an cifs/smb3 specific ioctl.  Before adding the second patch
though, I am waiting for more information.  I have asked
for clarification from Microsoft and also from JRA on
the behavior on the two server types (since I may have found
a Samba server bug) when testing this.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2inode.c |  2 +-
 fs/cifs/smb2ops.c   |  3 ++-
 fs/cifs/smb2pdu.c   | 10 +++++++---
 fs/cifs/smb2proto.h |  2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 84c012a..0150182 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -91,7 +91,7 @@ smb2_open_op_close(const unsigned int xid, struct
cifs_tcon *tcon,
  case SMB2_OP_SET_EOF:
  tmprc = SMB2_set_eof(xid, tcon, fid.persistent_fid,
      fid.volatile_fid, current->tgid,
-     (__le64 *)data);
+     (__le64 *)data, false);
  break;
  case SMB2_OP_SET_INFO:
  tmprc = SMB2_set_info(xid, tcon, fid.persistent_fid,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 787844b..ae1bff3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -19,6 +19,7 @@

 #include <linux/pagemap.h>
 #include <linux/vfs.h>
+#include <linux/falloc.h>
 #include "cifsglob.h"
 #include "smb2pdu.h"
 #include "smb2proto.h"
@@ -687,7 +688,7 @@ smb2_set_file_size(const unsigned int xid, struct
cifs_tcon *tcon,
 {
  __le64 eof = cpu_to_le64(size);
  return SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-    cfile->fid.volatile_fid, cfile->pid, &eof);
+    cfile->fid.volatile_fid, cfile->pid, &eof, false);
 }

 static int
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b0b260d..49d14b6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2325,7 +2325,7 @@ SMB2_set_hardlink(const unsigned int xid, struct
cifs_tcon *tcon,

 int
 SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64
persistent_fid,
-     u64 volatile_fid, u32 pid, __le64 *eof)
+     u64 volatile_fid, u32 pid, __le64 *eof, bool is_falloc)
 {
  struct smb2_file_eof_info info;
  void *data;
@@ -2336,8 +2336,12 @@ SMB2_set_eof(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
  data = &info;
  size = sizeof(struct smb2_file_eof_info);

- return send_set_info(xid, tcon, persistent_fid, volatile_fid, pid,
-     FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
+ if (is_falloc)
+ return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+ pid, FILE_ALLOCATION_INFORMATION, 1, &data, &size);
+ else
+ return send_set_info(xid, tcon, persistent_fid, volatile_fid,
+ pid, FILE_END_OF_FILE_INFORMATION, 1, &data, &size);
 }

 int
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 0ce48db..67e8ce8 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -139,7 +139,7 @@ extern int SMB2_set_hardlink(const unsigned int
xid, struct cifs_tcon *tcon,
      __le16 *target_file);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
  u64 persistent_fid, u64 volatile_fid, u32 pid,
- __le64 *eof);
+ __le64 *eof, bool is_fallocate);
 extern int SMB2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
  u64 persistent_fid, u64 volatile_fid,
  FILE_BASIC_INFO *buf);
-- 
1.9.3


-- 
Thanks,

Steve

--001a11c305807d048e04feb78bd1
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Add-worker-function-to-set-allocation-size.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Add-worker-function-to-set-allocation-size.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hxw2q4u50

RnJvbSAwOGM4MGNkYzUwZTBkMzI3MjM0Mjg4Y2IwZjYyOGZkZjVlODBiYzhkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNmcmVuY2hAbG9jYWxob3N0LmxvY2Fs
ZG9tYWluPgpEYXRlOiBTYXQsIDE5IEp1bCAyMDE0IDIxOjQ0OjU4IC0wNTAwClN1YmplY3Q6IFtQ
QVRDSF0gW0NJRlNdIEFkZCB3b3JrZXIgZnVuY3Rpb24gdG8gc2V0IGFsbG9jYXRpb24gc2l6ZQoK
QWRkcyBzZXRpbmZvIHdvcmtlciBmdW5jdGlvbiBmb3IgU01CMi9TTUIzIHN1cHBvcnQgb2YgU0VU
X0FMTE9DQVRJT05fSU5GT1JNQVRJT04KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21m
cmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2NpZnMvc21iMmlub2RlLmMgfCAgMiArLQogZnMvY2lm
cy9zbWIyb3BzLmMgICB8ICAzICsrLQogZnMvY2lmcy9zbWIycGR1LmMgICB8IDEwICsrKysrKyst
LS0KIGZzL2NpZnMvc21iMnByb3RvLmggfCAgMiArLQogNCBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNl
cnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMmlub2Rl
LmMgYi9mcy9jaWZzL3NtYjJpbm9kZS5jCmluZGV4IDg0YzAxMmEuLjAxNTAxODIgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iMmlub2RlLmMKKysrIGIvZnMvY2lmcy9zbWIyaW5vZGUuYwpAQCAtOTEs
NyArOTEsNyBAQCBzbWIyX29wZW5fb3BfY2xvc2UoY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3Ry
dWN0IGNpZnNfdGNvbiAqdGNvbiwKIAljYXNlIFNNQjJfT1BfU0VUX0VPRjoKIAkJdG1wcmMgPSBT
TUIyX3NldF9lb2YoeGlkLCB0Y29uLCBmaWQucGVyc2lzdGVudF9maWQsCiAJCQkJICAgICBmaWQu
dm9sYXRpbGVfZmlkLCBjdXJyZW50LT50Z2lkLAotCQkJCSAgICAgKF9fbGU2NCAqKWRhdGEpOwor
CQkJCSAgICAgKF9fbGU2NCAqKWRhdGEsIGZhbHNlKTsKIAkJYnJlYWs7CiAJY2FzZSBTTUIyX09Q
X1NFVF9JTkZPOgogCQl0bXByYyA9IFNNQjJfc2V0X2luZm8oeGlkLCB0Y29uLCBmaWQucGVyc2lz
dGVudF9maWQsCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJvcHMuYyBiL2ZzL2NpZnMvc21iMm9w
cy5jCmluZGV4IDc4Nzg0NGIuLmFlMWJmZjMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMm9wcy5j
CisrKyBiL2ZzL2NpZnMvc21iMm9wcy5jCkBAIC0xOSw2ICsxOSw3IEBACiAKICNpbmNsdWRlIDxs
aW51eC9wYWdlbWFwLmg+CiAjaW5jbHVkZSA8bGludXgvdmZzLmg+CisjaW5jbHVkZSA8bGludXgv
ZmFsbG9jLmg+CiAjaW5jbHVkZSAiY2lmc2dsb2IuaCIKICNpbmNsdWRlICJzbWIycGR1LmgiCiAj
aW5jbHVkZSAic21iMnByb3RvLmgiCkBAIC02ODcsNyArNjg4LDcgQEAgc21iMl9zZXRfZmlsZV9z
aXplKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiB7CiAJ
X19sZTY0IGVvZiA9IGNwdV90b19sZTY0KHNpemUpOwogCXJldHVybiBTTUIyX3NldF9lb2YoeGlk
LCB0Y29uLCBjZmlsZS0+ZmlkLnBlcnNpc3RlbnRfZmlkLAotCQkJICAgIGNmaWxlLT5maWQudm9s
YXRpbGVfZmlkLCBjZmlsZS0+cGlkLCAmZW9mKTsKKwkJCSAgICBjZmlsZS0+ZmlkLnZvbGF0aWxl
X2ZpZCwgY2ZpbGUtPnBpZCwgJmVvZiwgZmFsc2UpOwogfQogCiBzdGF0aWMgaW50CmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3NtYjJwZHUuYyBiL2ZzL2NpZnMvc21iMnBkdS5jCmluZGV4IGIwYjI2MGQu
LjQ5ZDE0YjYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2NpZnMvc21i
MnBkdS5jCkBAIC0yMzI1LDcgKzIzMjUsNyBAQCBTTUIyX3NldF9oYXJkbGluayhjb25zdCB1bnNp
Z25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiBpbnQKIFNNQjJfc2V0X2Vv
Zihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCB1NjQgcGVy
c2lzdGVudF9maWQsCi0JICAgICB1NjQgdm9sYXRpbGVfZmlkLCB1MzIgcGlkLCBfX2xlNjQgKmVv
ZikKKwkgICAgIHU2NCB2b2xhdGlsZV9maWQsIHUzMiBwaWQsIF9fbGU2NCAqZW9mLCBib29sIGlz
X2ZhbGxvYykKIHsKIAlzdHJ1Y3Qgc21iMl9maWxlX2VvZl9pbmZvIGluZm87CiAJdm9pZCAqZGF0
YTsKQEAgLTIzMzYsOCArMjMzNiwxMiBAQCBTTUIyX3NldF9lb2YoY29uc3QgdW5zaWduZWQgaW50
IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgdTY0IHBlcnNpc3RlbnRfZmlkLAogCWRhdGEg
PSAmaW5mbzsKIAlzaXplID0gc2l6ZW9mKHN0cnVjdCBzbWIyX2ZpbGVfZW9mX2luZm8pOwogCi0J
cmV0dXJuIHNlbmRfc2V0X2luZm8oeGlkLCB0Y29uLCBwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVf
ZmlkLCBwaWQsCi0JCQkgICAgIEZJTEVfRU5EX09GX0ZJTEVfSU5GT1JNQVRJT04sIDEsICZkYXRh
LCAmc2l6ZSk7CisJaWYgKGlzX2ZhbGxvYykKKwkJcmV0dXJuIHNlbmRfc2V0X2luZm8oeGlkLCB0
Y29uLCBwZXJzaXN0ZW50X2ZpZCwgdm9sYXRpbGVfZmlkLAorCQkJcGlkLCBGSUxFX0FMTE9DQVRJ
T05fSU5GT1JNQVRJT04sIDEsICZkYXRhLCAmc2l6ZSk7CisJZWxzZQorCQlyZXR1cm4gc2VuZF9z
ZXRfaW5mbyh4aWQsIHRjb24sIHBlcnNpc3RlbnRfZmlkLCB2b2xhdGlsZV9maWQsCisJCQlwaWQs
IEZJTEVfRU5EX09GX0ZJTEVfSU5GT1JNQVRJT04sIDEsICZkYXRhLCAmc2l6ZSk7CiB9CiAKIGlu
dApkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycHJvdG8uaCBiL2ZzL2NpZnMvc21iMnByb3RvLmgK
aW5kZXggMGNlNDhkYi4uNjdlOGNlOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycHJvdG8uaAor
KysgYi9mcy9jaWZzL3NtYjJwcm90by5oCkBAIC0xMzksNyArMTM5LDcgQEAgZXh0ZXJuIGludCBT
TUIyX3NldF9oYXJkbGluayhjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29u
ICp0Y29uLAogCQkJICAgICBfX2xlMTYgKnRhcmdldF9maWxlKTsKIGV4dGVybiBpbnQgU01CMl9z
ZXRfZW9mKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJ
CQl1NjQgcGVyc2lzdGVudF9maWQsIHU2NCB2b2xhdGlsZV9maWQsIHUzMiBwaWQsCi0JCQlfX2xl
NjQgKmVvZik7CisJCQlfX2xlNjQgKmVvZiwgYm9vbCBpc19mYWxsb2NhdGUpOwogZXh0ZXJuIGlu
dCBTTUIyX3NldF9pbmZvKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCiAJCQkgdTY0IHBlcnNpc3RlbnRfZmlkLCB1NjQgdm9sYXRpbGVfZmlkLAogCQkJIEZJ
TEVfQkFTSUNfSU5GTyAqYnVmKTsKLS0gCjEuOS4zCgo=
--001a11c305807d048e04feb78bd1--
