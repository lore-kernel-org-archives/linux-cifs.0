From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: CIFS: O_DIRECT opens should work on directio mounts
Date: Mon, 11 Nov 2013 17:00:24 -0600
Message-ID: <CAH2r5mvH=qZGbLGLLvdASSTTZ=RPgOLX-gAZxexkQ4PS1bjn+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8ffbab6b82746e04eaeeb209
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--e89a8ffbab6b82746e04eaeeb209
Content-Type: text/plain; charset=ISO-8859-1

>From dca692880e887739a669f6c41a80ca68ce2b09fc Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Mon, 11 Nov 2013 16:42:37 -0600
Subject: [CIFS] O_DIRECT opens should work on directio mounts

Opens on current cifs/smb2/smb3 mounts with O_DIRECT flag fail
even when caching is disabled on the mount.  This was
reported by those running SMB2 benchmarks who need to
be able to pass O_DIRECT on many of their open calls to
reduce caching effects, but would also be needed by other
applications.

When mounting with forcedirectio ("cache=none") cifs and smb2/smb3
do not go through the page cache and thus opens with O_DIRECT flag
should work (when posix extensions are negotiated we even are
able to send the flag to the server). This patch fixes that
in a simple way.

The 9P client has a similar situation (caching is often disabled)
and takes the same approach to O_DIRECT support ie works if caching
disabled, but if client caching enabled it fails with EINVAL.

A followon idea for a future patch as Pavel noted, could
be that files opened with O_DIRECT could cause us to change
inode->i_fop on the fly from

cifs_file_strict_ops

to

cifs_file_direct_ops

which would allow us to support this on non-forcedirectio mounts
(cache=strict and cache=loose) as well.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7ddddf2..5a5a872 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3663,6 +3663,27 @@ void cifs_oplock_break(struct work_struct *work)
  }
 }

+/*
+ * The presence of cifs_direct_io() in the address space ops vector
+ * allowes open() O_DIRECT flags which would have failed otherwise.
+ *
+ * In the non-cached mode (mount with cache=none), we shunt off
direct read and write requests
+ * so this method should never be called.
+ *
+ * Direct IO is not yet supported in the cached mode.
+ */
+static ssize_t
+cifs_direct_io(int rw, struct kiocb *iocb, const struct iovec *iov,
+               loff_t pos, unsigned long nr_segs)
+{
+        /*
+         * FIXME
+         * Eventually need to support direct IO for non forcedirectio mounts
+         */
+        return -EINVAL;
+}
+
+
 const struct address_space_operations cifs_addr_ops = {
  .readpage = cifs_readpage,
  .readpages = cifs_readpages,
@@ -3672,6 +3693,7 @@ const struct address_space_operations cifs_addr_ops = {
  .write_end = cifs_write_end,
  .set_page_dirty = __set_page_dirty_nobuffers,
  .releasepage = cifs_release_page,
+ .direct_IO = cifs_direct_io,
  .invalidatepage = cifs_invalidate_page,
  .launder_page = cifs_launder_page,
 };
-- 
1.8.3.1


-- 
Thanks,

Steve

--e89a8ffbab6b82746e04eaeeb209
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-O_DIRECT-opens-should-work-on-directio-mounts.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-O_DIRECT-opens-should-work-on-directio-mounts.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hnwbcaqk0

RnJvbSBkY2E2OTI4ODBlODg3NzM5YTY2OWY2YzQxYTgwY2E2OGNlMmIwOWZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogTW9uLCAxMSBOb3YgMjAxMyAxNjo0MjozNyAtMDYwMApTdWJqZWN0OiBbUEFUQ0ggMS8yXSBb
Q0lGU10gT19ESVJFQ1Qgb3BlbnMgc2hvdWxkIHdvcmsgb24gZGlyZWN0aW8gbW91bnRzCgpPcGVu
cyBvbiBjdXJyZW50IGNpZnMvc21iMi9zbWIzIG1vdW50cyB3aXRoIE9fRElSRUNUIGZsYWcgZmFp
bApldmVuIHdoZW4gY2FjaGluZyBpcyBkaXNhYmxlZCBvbiB0aGUgbW91bnQuICBUaGlzIHdhcwpy
ZXBvcnRlZCBieSB0aG9zZSBydW5uaW5nIFNNQjIgYmVuY2htYXJrcyB3aG8gbmVlZCB0bwpiZSBh
YmxlIHRvIHBhc3MgT19ESVJFQ1Qgb24gbWFueSBvZiB0aGVpciBvcGVuIGNhbGxzIHRvCnJlZHVj
ZSBjYWNoaW5nIGVmZmVjdHMsIGJ1dCB3b3VsZCBhbHNvIGJlIG5lZWRlZCBieSBvdGhlcgphcHBs
aWNhdGlvbnMuCgpXaGVuIG1vdW50aW5nIHdpdGggZm9yY2VkaXJlY3RpbyAoImNhY2hlPW5vbmUi
KSBjaWZzIGFuZCBzbWIyL3NtYjMKZG8gbm90IGdvIHRocm91Z2ggdGhlIHBhZ2UgY2FjaGUgYW5k
IHRodXMgb3BlbnMgd2l0aCBPX0RJUkVDVCBmbGFnCnNob3VsZCB3b3JrICh3aGVuIHBvc2l4IGV4
dGVuc2lvbnMgYXJlIG5lZ290aWF0ZWQgd2UgZXZlbiBhcmUKYWJsZSB0byBzZW5kIHRoZSBmbGFn
IHRvIHRoZSBzZXJ2ZXIpLiBUaGlzIHBhdGNoIGZpeGVzIHRoYXQKaW4gYSBzaW1wbGUgd2F5LgoK
VGhlIDlQIGNsaWVudCBoYXMgYSBzaW1pbGFyIHNpdHVhdGlvbiAoY2FjaGluZyBpcyBvZnRlbiBk
aXNhYmxlZCkKYW5kIHRha2VzIHRoZSBzYW1lIGFwcHJvYWNoIHRvIE9fRElSRUNUIHN1cHBvcnQg
aWUgd29ya3MgaWYgY2FjaGluZwpkaXNhYmxlZCwgYnV0IGlmIGNsaWVudCBjYWNoaW5nIGVuYWJs
ZWQgaXQgZmFpbHMgd2l0aCBFSU5WQUwuCgpBIGZvbGxvd29uIGlkZWEgZm9yIGEgZnV0dXJlIHBh
dGNoIGFzIFBhdmVsIG5vdGVkLCBjb3VsZApiZSB0aGF0IGZpbGVzIG9wZW5lZCB3aXRoIE9fRElS
RUNUIGNvdWxkIGNhdXNlIHVzIHRvIGNoYW5nZQppbm9kZS0+aV9mb3Agb24gdGhlIGZseSBmcm9t
CgpjaWZzX2ZpbGVfc3RyaWN0X29wcwoKdG8KCmNpZnNfZmlsZV9kaXJlY3Rfb3BzCgp3aGljaCB3
b3VsZCBhbGxvdyB1cyB0byBzdXBwb3J0IHRoaXMgb24gbm9uLWZvcmNlZGlyZWN0aW8gbW91bnRz
CihjYWNoZT1zdHJpY3QgYW5kIGNhY2hlPWxvb3NlKSBhcyB3ZWxsLgoKUmV2aWV3ZWQtYnk6IFBh
dmVsIFNoaWxvdnNreSA8cGlhc3RyeUBldGVyc29mdC5ydT4KU2lnbmVkLW9mZi1ieTogU3RldmUg
RnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+Ci0tLQogZnMvY2lmcy9maWxlLmMgfCAyMiArKysr
KysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvZmlsZS5jIGIvZnMvY2lmcy9maWxlLmMKaW5kZXggN2RkZGRmMi4u
NWE1YTg3MiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMK
QEAgLTM2NjMsNiArMzY2MywyNyBAQCB2b2lkIGNpZnNfb3Bsb2NrX2JyZWFrKHN0cnVjdCB3b3Jr
X3N0cnVjdCAqd29yaykKIAl9CiB9CiAKKy8qCisgKiBUaGUgcHJlc2VuY2Ugb2YgY2lmc19kaXJl
Y3RfaW8oKSBpbiB0aGUgYWRkcmVzcyBzcGFjZSBvcHMgdmVjdG9yCisgKiBhbGxvd2VzIG9wZW4o
KSBPX0RJUkVDVCBmbGFncyB3aGljaCB3b3VsZCBoYXZlIGZhaWxlZCBvdGhlcndpc2UuCisgKgor
ICogSW4gdGhlIG5vbi1jYWNoZWQgbW9kZSAobW91bnQgd2l0aCBjYWNoZT1ub25lKSwgd2Ugc2h1
bnQgb2ZmIGRpcmVjdCByZWFkIGFuZCB3cml0ZSByZXF1ZXN0cworICogc28gdGhpcyBtZXRob2Qg
c2hvdWxkIG5ldmVyIGJlIGNhbGxlZC4KKyAqCisgKiBEaXJlY3QgSU8gaXMgbm90IHlldCBzdXBw
b3J0ZWQgaW4gdGhlIGNhY2hlZCBtb2RlLiAKKyAqLworc3RhdGljIHNzaXplX3QKK2NpZnNfZGly
ZWN0X2lvKGludCBydywgc3RydWN0IGtpb2NiICppb2NiLCBjb25zdCBzdHJ1Y3QgaW92ZWMgKmlv
diwKKyAgICAgICAgICAgICAgIGxvZmZfdCBwb3MsIHVuc2lnbmVkIGxvbmcgbnJfc2VncykKK3sK
KyAgICAgICAgLyoKKyAgICAgICAgICogRklYTUUKKyAgICAgICAgICogRXZlbnR1YWxseSBuZWVk
IHRvIHN1cHBvcnQgZGlyZWN0IElPIGZvciBub24gZm9yY2VkaXJlY3RpbyBtb3VudHMKKyAgICAg
ICAgICovCisgICAgICAgIHJldHVybiAtRUlOVkFMOworfQorCisKIGNvbnN0IHN0cnVjdCBhZGRy
ZXNzX3NwYWNlX29wZXJhdGlvbnMgY2lmc19hZGRyX29wcyA9IHsKIAkucmVhZHBhZ2UgPSBjaWZz
X3JlYWRwYWdlLAogCS5yZWFkcGFnZXMgPSBjaWZzX3JlYWRwYWdlcywKQEAgLTM2NzIsNiArMzY5
Myw3IEBAIGNvbnN0IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgY2lmc19hZGRyX29w
cyA9IHsKIAkud3JpdGVfZW5kID0gY2lmc193cml0ZV9lbmQsCiAJLnNldF9wYWdlX2RpcnR5ID0g
X19zZXRfcGFnZV9kaXJ0eV9ub2J1ZmZlcnMsCiAJLnJlbGVhc2VwYWdlID0gY2lmc19yZWxlYXNl
X3BhZ2UsCisJLmRpcmVjdF9JTyA9IGNpZnNfZGlyZWN0X2lvLAogCS5pbnZhbGlkYXRlcGFnZSA9
IGNpZnNfaW52YWxpZGF0ZV9wYWdlLAogCS5sYXVuZGVyX3BhZ2UgPSBjaWZzX2xhdW5kZXJfcGFn
ZSwKIH07Ci0tIAoxLjguMy4xCgo=
--e89a8ffbab6b82746e04eaeeb209--
