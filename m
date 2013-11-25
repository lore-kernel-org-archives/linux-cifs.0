From: Steve French <smfrench@gmail.com>
Subject: (unknown)
Date: Mon, 25 Nov 2013 09:59:43 -0600
Message-ID: <CAH2r5mt59CQ3oh-T4V3Uoek+TPsBV060=2CgzFSsPxvTB35s7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b15afd3cdd0ad04ec0273ff
Cc: David Disseldorp <ddiss@suse.de>
To: samba-technical <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Subject: 
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

--047d7b15afd3cdd0ad04ec0273ff
Content-Type: text/plain; charset=ISO-8859-1

>From f19e84df37bda502a2248d507a9cf2b9e693279e Mon Sep 17 00:00:00 2001
From: Steve French <smfrench@gmail.com>
Date: Sun, 24 Nov 2013 21:53:17 -0600
Subject: [PATCH] [CIFS] Do not use btrfs refcopy ioctl for SMB2 copy offload

Change cifs.ko to using CIFS_IOCTL_COPYCHUNK instead
of BTRFS_IOC_CLONE to avoid confusion about whether
copy-on-write is required or optional for this operation.

SMB2/SMB3 copyoffload had used the BTRFS_IOC_CLONE ioctl since
they both speed up copy by offloading the copy rather than
passing many read and write requests back and forth and both have
identical syntax (passing file handles), but for SMB2/SMB3
CopyChunk the server is not required to use copy-on-write
to make a copy of the file (although some do), and Christoph
has commented that since CopyChunk does not require
copy-on-write we should not reuse BTRFS_IOC_CLONE.

This patch renames the ioctl to use a cifs specific IOCTL
CIFS_IOCTL_COPYCHUNK.  This ioctl is particularly important
for SMB2/SMB3 since large file copy over the network otherwise
can be very slow, and with this is often more than 100 times
faster putting less load on server and client.

Note that if a copy syscall is ever introduced, depending on
its requirements/format it could end up using one of the other
three methods that CIFS/SMB2/SMB3 protocol allows for copy offload,
but this method is particularly useful for file copy
and broadly supported (not just by Samba server).

Signed-off-by: Steve French <smfrench@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: David Disseldorp <ddiss@samba.org>
---
 fs/cifs/ioctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 409b45e..7749230 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -26,13 +26,15 @@
 #include <linux/mount.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
-#include <linux/btrfs.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "cifsfs.h"

+#define CIFS_IOCTL_MAGIC    0xCF
+#define CIFS_IOC_COPYCHUNK_FILE    _IOW(CIFS_IOCTL_MAGIC, 3, int)
+
 static long cifs_ioctl_clone(unsigned int xid, struct file *dst_file,
             unsigned long srcfd, u64 off, u64 len, u64 destoff)
 {
@@ -213,7 +215,7 @@ long cifs_ioctl(struct file *filep, unsigned int
command, unsigned long arg)
                 cifs_dbg(FYI, "set compress flag rc %d\n", rc);
             }
             break;
-        case BTRFS_IOC_CLONE:
+        case CIFS_IOC_COPYCHUNK_FILE:
             rc = cifs_ioctl_clone(xid, filep, arg, 0, 0, 0);
             break;
         default:
-- 
1.8.3.1


-- 
Thanks,

Steve

--047d7b15afd3cdd0ad04ec0273ff
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-Do-not-use-btrfs-refcopy-ioctl-for-SMB2-copy-of.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Do-not-use-btrfs-refcopy-ioctl-for-SMB2-copy-of.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hofwio410

RnJvbSBmMTllODRkZjM3YmRhNTAyYTIyNDhkNTA3YTljZjJiOWU2OTMyNzllIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU3VuLCAyNCBOb3YgMjAxMyAyMTo1MzoxNyAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBEbyBub3QgdXNlIGJ0cmZzIHJlZmNvcHkgaW9jdGwgZm9yIFNNQjIgY29weSBvZmZsb2FkCgpD
aGFuZ2UgY2lmcy5rbyB0byB1c2luZyBDSUZTX0lPQ1RMX0NPUFlDSFVOSyBpbnN0ZWFkCm9mIEJU
UkZTX0lPQ19DTE9ORSB0byBhdm9pZCBjb25mdXNpb24gYWJvdXQgd2hldGhlcgpjb3B5LW9uLXdy
aXRlIGlzIHJlcXVpcmVkIG9yIG9wdGlvbmFsIGZvciB0aGlzIG9wZXJhdGlvbi4KClNNQjIvU01C
MyBjb3B5b2ZmbG9hZCBoYWQgdXNlZCB0aGUgQlRSRlNfSU9DX0NMT05FIGlvY3RsIHNpbmNlCnRo
ZXkgYm90aCBzcGVlZCB1cCBjb3B5IGJ5IG9mZmxvYWRpbmcgdGhlIGNvcHkgcmF0aGVyIHRoYW4K
cGFzc2luZyBtYW55IHJlYWQgYW5kIHdyaXRlIHJlcXVlc3RzIGJhY2sgYW5kIGZvcnRoIGFuZCBi
b3RoIGhhdmUKaWRlbnRpY2FsIHN5bnRheCAocGFzc2luZyBmaWxlIGhhbmRsZXMpLCBidXQgZm9y
IFNNQjIvU01CMwpDb3B5Q2h1bmsgdGhlIHNlcnZlciBpcyBub3QgcmVxdWlyZWQgdG8gdXNlIGNv
cHktb24td3JpdGUKdG8gbWFrZSBhIGNvcHkgb2YgdGhlIGZpbGUgKGFsdGhvdWdoIHNvbWUgZG8p
LCBhbmQgQ2hyaXN0b3BoCmhhcyBjb21tZW50ZWQgdGhhdCBzaW5jZSBDb3B5Q2h1bmsgZG9lcyBu
b3QgcmVxdWlyZQpjb3B5LW9uLXdyaXRlIHdlIHNob3VsZCBub3QgcmV1c2UgQlRSRlNfSU9DX0NM
T05FLgoKVGhpcyBwYXRjaCByZW5hbWVzIHRoZSBpb2N0bCB0byB1c2UgYSBjaWZzIHNwZWNpZmlj
IElPQ1RMCkNJRlNfSU9DVExfQ09QWUNIVU5LLiAgVGhpcyBpb2N0bCBpcyBwYXJ0aWN1bGFybHkg
aW1wb3J0YW50CmZvciBTTUIyL1NNQjMgc2luY2UgbGFyZ2UgZmlsZSBjb3B5IG92ZXIgdGhlIG5l
dHdvcmsgb3RoZXJ3aXNlCmNhbiBiZSB2ZXJ5IHNsb3csIGFuZCB3aXRoIHRoaXMgaXMgb2Z0ZW4g
bW9yZSB0aGFuIDEwMCB0aW1lcwpmYXN0ZXIgcHV0dGluZyBsZXNzIGxvYWQgb24gc2VydmVyIGFu
ZCBjbGllbnQuCgpOb3RlIHRoYXQgaWYgYSBjb3B5IHN5c2NhbGwgaXMgZXZlciBpbnRyb2R1Y2Vk
LCBkZXBlbmRpbmcgb24KaXRzIHJlcXVpcmVtZW50cy9mb3JtYXQgaXQgY291bGQgZW5kIHVwIHVz
aW5nIG9uZSBvZiB0aGUgb3RoZXIKdGhyZWUgbWV0aG9kcyB0aGF0IENJRlMvU01CMi9TTUIzIGNh
biBkbyBmb3IgY29weSBvZmZsb2FkLApidXQgdGhpcyBtZXRob2QgaXMgcGFydGljdWxhcmx5IHVz
ZWZ1bCBmb3IgZmlsZSBjb3B5CmFuZCBicm9hZGx5IHN1cHBvcnRlZCAobm90IGp1c3QgYnkgU2Ft
YmEgc2VydmVyKS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwu
Y29tPgpSZXZpZXdlZC1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT4KUmV2aWV3
ZWQtYnk6IERhdmlkIERpc3NlbGRvcnAgPGRkaXNzQHNhbWJhLm9yZz4KLS0tCiBmcy9jaWZzL2lv
Y3RsLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMiBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZzL2lvY3RsLmMgYi9mcy9jaWZzL2lvY3RsLmMK
aW5kZXggNDA5YjQ1ZS4uNzc0OTIzMCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pb2N0bC5jCisrKyBi
L2ZzL2NpZnMvaW9jdGwuYwpAQCAtMjYsMTMgKzI2LDE1IEBACiAjaW5jbHVkZSA8bGludXgvbW91
bnQuaD4KICNpbmNsdWRlIDxsaW51eC9tbS5oPgogI2luY2x1ZGUgPGxpbnV4L3BhZ2VtYXAuaD4K
LSNpbmNsdWRlIDxsaW51eC9idHJmcy5oPgogI2luY2x1ZGUgImNpZnNwZHUuaCIKICNpbmNsdWRl
ICJjaWZzZ2xvYi5oIgogI2luY2x1ZGUgImNpZnNwcm90by5oIgogI2luY2x1ZGUgImNpZnNfZGVi
dWcuaCIKICNpbmNsdWRlICJjaWZzZnMuaCIKIAorI2RlZmluZSBDSUZTX0lPQ1RMX01BR0lDCTB4
Q0YKKyNkZWZpbmUgQ0lGU19JT0NfQ09QWUNIVU5LX0ZJTEUJX0lPVyhDSUZTX0lPQ1RMX01BR0lD
LCAzLCBpbnQpCisKIHN0YXRpYyBsb25nIGNpZnNfaW9jdGxfY2xvbmUodW5zaWduZWQgaW50IHhp
ZCwgc3RydWN0IGZpbGUgKmRzdF9maWxlLAogCQkJdW5zaWduZWQgbG9uZyBzcmNmZCwgdTY0IG9m
ZiwgdTY0IGxlbiwgdTY0IGRlc3RvZmYpCiB7CkBAIC0yMTMsNyArMjE1LDcgQEAgbG9uZyBjaWZz
X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxlcCwgdW5zaWduZWQgaW50IGNvbW1hbmQsIHVuc2lnbmVk
IGxvbmcgYXJnKQogCQkJCWNpZnNfZGJnKEZZSSwgInNldCBjb21wcmVzcyBmbGFnIHJjICVkXG4i
LCByYyk7CiAJCQl9CiAJCQlicmVhazsKLQkJY2FzZSBCVFJGU19JT0NfQ0xPTkU6CisJCWNhc2Ug
Q0lGU19JT0NfQ09QWUNIVU5LX0ZJTEU6CiAJCQlyYyA9IGNpZnNfaW9jdGxfY2xvbmUoeGlkLCBm
aWxlcCwgYXJnLCAwLCAwLCAwKTsKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgotLSAKMS44LjMuMQoK
--047d7b15afd3cdd0ad04ec0273ff--
