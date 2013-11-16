From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: setfacl fix
Date: Fri, 15 Nov 2013 20:53:12 -0600
Message-ID: <CAH2r5msswZg_NvY9qMNknh2FWht1jMgwW1s2umtaBj3mHreDAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b33cac86fa4da04eb426a15
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b33cac86fa4da04eb426a15
Content-Type: text/plain; charset=ISO-8859-1

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 15 Nov 2013 20:41:32 -0600
Subject: [PATCH] [CIFS] setfacl removes part of ACL when setting POSIX ACLs to
 Samba

setfacl over cifs mounts can remove the default ACL when setting the
(non-default part of) the ACL and vice versa (we were leaving at 0
rather than setting to -1 the count field for the unaffected
half of the ACL.  For example notice the setfacl removed
the default ACL in this sequence:

steven@steven-GA-970A-DS3:~/cifs-2.6$ getfacl /mnt/test-dir ; setfacl
-m default:user:test:rwx,user:test:rwx /mnt/test-dir
getfacl: Removing leading '/' from absolute path names
user::rwx
group::r-x
other::r-x
default:user::rwx
default:user:test:rwx
default:group::r-x
default:mask::rwx
default:other::r-x

steven@steven-GA-970A-DS3:~/cifs-2.6$ getfacl /mnt/test-dir
getfacl: Removing leading '/' from absolute path names
user::rwx
user:test:rwx
group::r-x
mask::rwx
other::r-x

CC: Stable <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Acked-by: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifssmb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 93b2947..124aa02 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3369,11 +3369,13 @@ static __u16 ACL_to_cifs_posix(char
*parm_data, const char *pACL,
         return 0;
     }
     cifs_acl->version = cpu_to_le16(1);
-    if (acl_type == ACL_TYPE_ACCESS)
+    if (acl_type == ACL_TYPE_ACCESS) {
         cifs_acl->access_entry_count = cpu_to_le16(count);
-    else if (acl_type == ACL_TYPE_DEFAULT)
+        cifs_acl->default_entry_count = __constant_cpu_to_le16(0xFFFF);
+    } else if (acl_type == ACL_TYPE_DEFAULT) {
         cifs_acl->default_entry_count = cpu_to_le16(count);
-    else {
+        cifs_acl->access_entry_count = __constant_cpu_to_le16(0xFFFF);
+    } else {
         cifs_dbg(FYI, "unknown ACL type %d\n", acl_type);
         return 0;
     }
-- 
1.8.3.1


-- 
Thanks,

Steve

--047d7b33cac86fa4da04eb426a15
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-setfacl-removes-part-of-ACL-when-setting-POSIX-.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-setfacl-removes-part-of-ACL-when-setting-POSIX-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho29fkin0

RnJvbSA1ZThiNGIyOTM0MDkzYjFlOGVjNmU4ZWYzMGYxMTBjZDU3ZTBkYmRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCAxNSBOb3YgMjAxMyAyMDo0MTozMiAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBzZXRmYWNsIHJlbW92ZXMgcGFydCBvZiBBQ0wgd2hlbiBzZXR0aW5nIFBPU0lYIEFDTHMgdG8K
IFNhbWJhCgpzZXRmYWNsIG92ZXIgY2lmcyBtb3VudHMgY2FuIHJlbW92ZSB0aGUgZGVmYXVsdCBB
Q0wgd2hlbiBzZXR0aW5nIHRoZQoobm9uLWRlZmF1bHQgcGFydCBvZikgdGhlIEFDTCBhbmQgdmlj
ZSB2ZXJzYSAod2Ugd2VyZSBsZWF2aW5nIGF0IDAKcmF0aGVyIHRoYW4gc2V0dGluZyB0byAtMSB0
aGUgY291bnQgZmllbGQgZm9yIHRoZSB1bmFmZmVjdGVkCmhhbGYgb2YgdGhlIEFDTC4gIEZvciBl
eGFtcGxlIG5vdGljZSB0aGUgc2V0ZmFjbCByZW1vdmVkCnRoZSBkZWZhdWx0IEFDTCBpbiB0aGlz
IHNlcXVlbmNlOgoKc3RldmVuQHN0ZXZlbi1HQS05NzBBLURTMzp+L2NpZnMtMi42JCBnZXRmYWNs
IC9tbnQvdGVzdC1kaXIgOyBzZXRmYWNsCi1tIGRlZmF1bHQ6dXNlcjp0ZXN0OnJ3eCx1c2VyOnRl
c3Q6cnd4IC9tbnQvdGVzdC1kaXIKZ2V0ZmFjbDogUmVtb3ZpbmcgbGVhZGluZyAnLycgZnJvbSBh
YnNvbHV0ZSBwYXRoIG5hbWVzCnVzZXI6OnJ3eApncm91cDo6ci14Cm90aGVyOjpyLXgKZGVmYXVs
dDp1c2VyOjpyd3gKZGVmYXVsdDp1c2VyOnRlc3Q6cnd4CmRlZmF1bHQ6Z3JvdXA6OnIteApkZWZh
dWx0Om1hc2s6OnJ3eApkZWZhdWx0Om90aGVyOjpyLXgKCnN0ZXZlbkBzdGV2ZW4tR0EtOTcwQS1E
UzM6fi9jaWZzLTIuNiQgZ2V0ZmFjbCAvbW50L3Rlc3QtZGlyCmdldGZhY2w6IFJlbW92aW5nIGxl
YWRpbmcgJy8nIGZyb20gYWJzb2x1dGUgcGF0aCBuYW1lcwp1c2VyOjpyd3gKdXNlcjp0ZXN0OnJ3
eApncm91cDo6ci14Cm1hc2s6OnJ3eApvdGhlcjo6ci14CgpDQzogU3RhYmxlIDxzdGFibGVAa2Vy
bmVsLm9yZz4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+
CkFja2VkLWJ5OiBKZXJlbXkgQWxsaXNvbiA8anJhQHNhbWJhLm9yZz4KLS0tCiBmcy9jaWZzL2Np
ZnNzbWIuYyB8IDggKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDMg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzc21iLmMgYi9mcy9jaWZzL2Np
ZnNzbWIuYwppbmRleCA5M2IyOTQ3Li4xMjRhYTAyIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNz
bWIuYworKysgYi9mcy9jaWZzL2NpZnNzbWIuYwpAQCAtMzM2OSwxMSArMzM2OSwxMyBAQCBzdGF0
aWMgX191MTYgQUNMX3RvX2NpZnNfcG9zaXgoY2hhciAqcGFybV9kYXRhLCBjb25zdCBjaGFyICpw
QUNMLAogCQlyZXR1cm4gMDsKIAl9CiAJY2lmc19hY2wtPnZlcnNpb24gPSBjcHVfdG9fbGUxNigx
KTsKLQlpZiAoYWNsX3R5cGUgPT0gQUNMX1RZUEVfQUNDRVNTKQorCWlmIChhY2xfdHlwZSA9PSBB
Q0xfVFlQRV9BQ0NFU1MpIHsKIAkJY2lmc19hY2wtPmFjY2Vzc19lbnRyeV9jb3VudCA9IGNwdV90
b19sZTE2KGNvdW50KTsKLQllbHNlIGlmIChhY2xfdHlwZSA9PSBBQ0xfVFlQRV9ERUZBVUxUKQor
CQljaWZzX2FjbC0+ZGVmYXVsdF9lbnRyeV9jb3VudCA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMTYo
MHhGRkZGKTsKKwl9IGVsc2UgaWYgKGFjbF90eXBlID09IEFDTF9UWVBFX0RFRkFVTFQpIHsKIAkJ
Y2lmc19hY2wtPmRlZmF1bHRfZW50cnlfY291bnQgPSBjcHVfdG9fbGUxNihjb3VudCk7Ci0JZWxz
ZSB7CisJCWNpZnNfYWNsLT5hY2Nlc3NfZW50cnlfY291bnQgPSBfX2NvbnN0YW50X2NwdV90b19s
ZTE2KDB4RkZGRik7CisJfSBlbHNlIHsKIAkJY2lmc19kYmcoRllJLCAidW5rbm93biBBQ0wgdHlw
ZSAlZFxuIiwgYWNsX3R5cGUpOwogCQlyZXR1cm4gMDsKIAl9Ci0tIAoxLjguMy4xCgo=
--047d7b33cac86fa4da04eb426a15--
