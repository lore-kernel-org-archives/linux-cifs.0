From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] SMB2/SMB3 Copy offload support (refcopy) finishup
Date: Sat, 16 Nov 2013 01:14:19 -0600
Message-ID: <CAH2r5muLwHY_e8QJP5N4veyqem4mQ9rOJC87nOeHYVyvFmWLsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1133100e3a2fc904eb461004
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a1133100e3a2fc904eb461004
Content-Type: text/plain; charset=ISO-8859-1

>From 6474d967fc8228fff7579748f7219f6a8e443f30 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 16 Nov 2013 01:06:00 -0600
Subject: [PATCH] CIFS: SMB2/SMB3 Copy offload support (refcopy) finish up

This patch extends the ability of copychunk (refcopy) to
handle servers with smaller than usual maximum chunk sizes
and also to handle files bigger than the maximum chunk sizes

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/cifs/smb2pdu.c |  2 +-
 2 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 11dde4b..7a21447 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -532,7 +532,10 @@ smb2_clone_range(const unsigned int xid,
     int rc;
     unsigned int ret_data_len;
     struct copychunk_ioctl *pcchunk;
-    char *retbuf = NULL;
+    struct copychunk_ioctl_rsp *retbuf = NULL;
+    struct cifs_tcon *tcon;
+    int chunks_copied = 0;
+    bool chunk_sizes_updated = false;

     pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);

@@ -552,22 +555,86 @@ smb2_clone_range(const unsigned int xid,
     /* For now array only one chunk long, will make more flexible later */
     pcchunk->ChunkCount = __constant_cpu_to_le32(1);
     pcchunk->Reserved = 0;
-    pcchunk->SourceOffset = cpu_to_le64(src_off);
-    pcchunk->TargetOffset = cpu_to_le64(dest_off);
-    pcchunk->Length = cpu_to_le32(len);
     pcchunk->Reserved2 = 0;

+    tcon = tlink_tcon(trgtfile->tlink);
+
+    while (len > 0) {
+        pcchunk->SourceOffset = cpu_to_le64(src_off);
+        pcchunk->TargetOffset = cpu_to_le64(dest_off);
+        pcchunk->Length =
+            cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
+
     /* Request that server copy to target from src file identified by key */
-    rc = SMB2_ioctl(xid, tlink_tcon(trgtfile->tlink),
-            trgtfile->fid.persistent_fid,
+        rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
             trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
             true /* is_fsctl */, (char *)pcchunk,
-            sizeof(struct copychunk_ioctl),    &retbuf, &ret_data_len);
-
-    /* BB need to special case rc = EINVAL to alter chunk size */
-
-    cifs_dbg(FYI, "rc %d data length out %d\n", rc, ret_data_len);
+            sizeof(struct copychunk_ioctl),    (char **)&retbuf,
+            &ret_data_len);
+        if (rc == 0) {
+            if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
+                goto cchunk_out;
+            if (retbuf->TotalBytesWritten == 0) {
+                cifs_dbg(FYI, "no bytes copied\n");
+                goto cchunk_out;
+            }
+            /*
+             * Check if server claimed to write more than we asked
+             */
+            if (le32_to_cpu(retbuf->TotalBytesWritten) >
+                le32_to_cpu(pcchunk->Length)) {
+                cifs_dbg(VFS, "invalid copy chunk response\n");
+                rc = -EIO;
+                goto cchunk_out;
+            }
+            if (le32_to_cpu(retbuf->ChunksWritten) != 1) {
+                cifs_dbg(VFS, "invalid num chunks written\n");
+                rc = -EIO;
+                goto cchunk_out;
+            }
+            chunks_copied++;
+
+            src_off += le32_to_cpu(retbuf->TotalBytesWritten);
+            dest_off += le32_to_cpu(retbuf->TotalBytesWritten);
+            len -= le32_to_cpu(retbuf->TotalBytesWritten);
+
+            cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %d\n",
+                le32_to_cpu(retbuf->ChunksWritten),
+                le32_to_cpu(retbuf->ChunkBytesWritten),
+                le32_to_cpu(retbuf->TotalBytesWritten));
+        } else if (rc == -EINVAL) {
+            if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
+                goto cchunk_out;
+
+            cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
+                le32_to_cpu(retbuf->ChunksWritten),
+                le32_to_cpu(retbuf->ChunkBytesWritten),
+                le32_to_cpu(retbuf->TotalBytesWritten));
+
+            /*
+             * Check if this is the first request using these sizes,
+             * (ie check if copy succeed once with original sizes
+             * and check if the server gave us different sizes after
+             * we already updated max sizes on previous request).
+             * if not then why is the server returning an error now
+             */
+            if ((chunks_copied != 0) || chunk_sizes_updated)
+                goto cchunk_out;
+
+            /* Check that server is not asking us to grow size */
+            if (le32_to_cpu(retbuf->ChunkBytesWritten) <
+                    tcon->max_bytes_chunk)
+                tcon->max_bytes_chunk =
+                    le32_to_cpu(retbuf->ChunkBytesWritten);
+            else
+                goto cchunk_out; /* server gave us bogus size */
+
+            /* No need to change MaxChunks since already set to 1 */
+            chunk_sizes_updated = true;
+        }
+    }

+cchunk_out:
     kfree(pcchunk);
     return rc;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d65270c..c5915dc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1214,7 +1214,7 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
     rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
     rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;

-    if (rc != 0) {
+    if ((rc != 0) && (rc != -EINVAL)) {
         if (tcon)
             cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
         goto ioctl_exit;
-- 
1.8.3.1


-- 
Thanks,

Steve

--001a1133100e3a2fc904eb461004
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-finish-u.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-finish-u.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho2isbyg0

RnJvbSA2NDc0ZDk2N2ZjODIyOGZmZjc1Nzk3NDhmNzIxOWY2YThlNDQzZjMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU2F0LCAxNiBOb3YgMjAxMyAwMTowNjowMCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIENJRlM6
IFNNQjIvU01CMyBDb3B5IG9mZmxvYWQgc3VwcG9ydCAocmVmY29weSkgZmluaXNoIHVwCgpUaGlz
IHBhdGNoIGV4dGVuZHMgdGhlIGFiaWxpdHkgb2YgY29weWNodW5rIChyZWZjb3B5KSB0bwpoYW5k
bGUgc2VydmVycyB3aXRoIHNtYWxsZXIgdGhhbiB1c3VhbCBtYXhpbXVtIGNodW5rIHNpemVzCmFu
ZCBhbHNvIHRvIGhhbmRsZSBmaWxlcyBiaWdnZXIgdGhhbiB0aGUgbWF4aW11bSBjaHVuayBzaXpl
cwoKU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+Ci0tLQog
ZnMvY2lmcy9zbWIyb3BzLmMgfCA4OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKystLS0tLS0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8ICAyICstCiAyIGZpbGVz
IGNoYW5nZWQsIDc5IGluc2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMm9wcy5jIGIvZnMvY2lmcy9zbWIyb3BzLmMKaW5kZXggMTFkZGU0Yi4uN2Ey
MTQ0NyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIyb3BzLmMKKysrIGIvZnMvY2lmcy9zbWIyb3Bz
LmMKQEAgLTUzMiw3ICs1MzIsMTAgQEAgc21iMl9jbG9uZV9yYW5nZShjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLAogCWludCByYzsKIAl1bnNpZ25lZCBpbnQgcmV0X2RhdGFfbGVuOwogCXN0cnVjdCBj
b3B5Y2h1bmtfaW9jdGwgKnBjY2h1bms7Ci0JY2hhciAqcmV0YnVmID0gTlVMTDsKKwlzdHJ1Y3Qg
Y29weWNodW5rX2lvY3RsX3JzcCAqcmV0YnVmID0gTlVMTDsKKwlzdHJ1Y3QgY2lmc190Y29uICp0
Y29uOworCWludCBjaHVua3NfY29waWVkID0gMDsKKwlib29sIGNodW5rX3NpemVzX3VwZGF0ZWQg
PSBmYWxzZTsKIAogCXBjY2h1bmsgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgY29weWNodW5rX2lv
Y3RsKSwgR0ZQX0tFUk5FTCk7CiAKQEAgLTU1MiwyMiArNTU1LDg2IEBAIHNtYjJfY2xvbmVfcmFu
Z2UoY29uc3QgdW5zaWduZWQgaW50IHhpZCwKIAkvKiBGb3Igbm93IGFycmF5IG9ubHkgb25lIGNo
dW5rIGxvbmcsIHdpbGwgbWFrZSBtb3JlIGZsZXhpYmxlIGxhdGVyICovCiAJcGNjaHVuay0+Q2h1
bmtDb3VudCA9IF9fY29uc3RhbnRfY3B1X3RvX2xlMzIoMSk7CiAJcGNjaHVuay0+UmVzZXJ2ZWQg
PSAwOwotCXBjY2h1bmstPlNvdXJjZU9mZnNldCA9IGNwdV90b19sZTY0KHNyY19vZmYpOwotCXBj
Y2h1bmstPlRhcmdldE9mZnNldCA9IGNwdV90b19sZTY0KGRlc3Rfb2ZmKTsKLQlwY2NodW5rLT5M
ZW5ndGggPSBjcHVfdG9fbGUzMihsZW4pOwogCXBjY2h1bmstPlJlc2VydmVkMiA9IDA7CiAKKwl0
Y29uID0gdGxpbmtfdGNvbih0cmd0ZmlsZS0+dGxpbmspOworCisJd2hpbGUgKGxlbiA+IDApIHsK
KwkJcGNjaHVuay0+U291cmNlT2Zmc2V0ID0gY3B1X3RvX2xlNjQoc3JjX29mZik7CisJCXBjY2h1
bmstPlRhcmdldE9mZnNldCA9IGNwdV90b19sZTY0KGRlc3Rfb2ZmKTsKKwkJcGNjaHVuay0+TGVu
Z3RoID0KKwkJCWNwdV90b19sZTMyKG1pbl90KHUzMiwgbGVuLCB0Y29uLT5tYXhfYnl0ZXNfY2h1
bmspKTsKKwogCS8qIFJlcXVlc3QgdGhhdCBzZXJ2ZXIgY29weSB0byB0YXJnZXQgZnJvbSBzcmMg
ZmlsZSBpZGVudGlmaWVkIGJ5IGtleSAqLwotCXJjID0gU01CMl9pb2N0bCh4aWQsIHRsaW5rX3Rj
b24odHJndGZpbGUtPnRsaW5rKSwKLQkJCXRyZ3RmaWxlLT5maWQucGVyc2lzdGVudF9maWQsCisJ
CXJjID0gU01CMl9pb2N0bCh4aWQsIHRjb24sIHRyZ3RmaWxlLT5maWQucGVyc2lzdGVudF9maWQs
CiAJCQl0cmd0ZmlsZS0+ZmlkLnZvbGF0aWxlX2ZpZCwgRlNDVExfU1JWX0NPUFlDSFVOS19XUklU
RSwKIAkJCXRydWUgLyogaXNfZnNjdGwgKi8sIChjaGFyICopcGNjaHVuaywKLQkJCXNpemVvZihz
dHJ1Y3QgY29weWNodW5rX2lvY3RsKSwJJnJldGJ1ZiwgJnJldF9kYXRhX2xlbik7Ci0KLQkvKiBC
QiBuZWVkIHRvIHNwZWNpYWwgY2FzZSByYyA9IEVJTlZBTCB0byBhbHRlciBjaHVuayBzaXplICov
Ci0KLQljaWZzX2RiZyhGWUksICJyYyAlZCBkYXRhIGxlbmd0aCBvdXQgJWRcbiIsIHJjLCByZXRf
ZGF0YV9sZW4pOworCQkJc2l6ZW9mKHN0cnVjdCBjb3B5Y2h1bmtfaW9jdGwpLAkoY2hhciAqKikm
cmV0YnVmLAorCQkJJnJldF9kYXRhX2xlbik7CisJCWlmIChyYyA9PSAwKSB7CisJCQlpZiAocmV0
X2RhdGFfbGVuICE9IHNpemVvZihzdHJ1Y3QgY29weWNodW5rX2lvY3RsX3JzcCkpCisJCQkJZ290
byBjY2h1bmtfb3V0OworCQkJaWYgKHJldGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4gPT0gMCkgewor
CQkJCWNpZnNfZGJnKEZZSSwgIm5vIGJ5dGVzIGNvcGllZFxuIik7CisJCQkJZ290byBjY2h1bmtf
b3V0OworCQkJfQorCQkJLyoKKwkJCSAqIENoZWNrIGlmIHNlcnZlciBjbGFpbWVkIHRvIHdyaXRl
IG1vcmUgdGhhbiB3ZSBhc2tlZAorCQkJICovCisJCQlpZiAobGUzMl90b19jcHUocmV0YnVmLT5U
b3RhbEJ5dGVzV3JpdHRlbikgPgorCQkJICAgIGxlMzJfdG9fY3B1KHBjY2h1bmstPkxlbmd0aCkp
IHsKKwkJCQljaWZzX2RiZyhWRlMsICJpbnZhbGlkIGNvcHkgY2h1bmsgcmVzcG9uc2VcbiIpOwor
CQkJCXJjID0gLUVJTzsKKwkJCQlnb3RvIGNjaHVua19vdXQ7CisJCQl9CisJCQlpZiAobGUzMl90
b19jcHUocmV0YnVmLT5DaHVua3NXcml0dGVuKSAhPSAxKSB7CisJCQkJY2lmc19kYmcoVkZTLCAi
aW52YWxpZCBudW0gY2h1bmtzIHdyaXR0ZW5cbiIpOworCQkJCXJjID0gLUVJTzsKKwkJCQlnb3Rv
IGNjaHVua19vdXQ7CisJCQl9CisJCQljaHVua3NfY29waWVkKys7CisKKwkJCXNyY19vZmYgKz0g
bGUzMl90b19jcHUocmV0YnVmLT5Ub3RhbEJ5dGVzV3JpdHRlbik7CisJCQlkZXN0X29mZiArPSBs
ZTMyX3RvX2NwdShyZXRidWYtPlRvdGFsQnl0ZXNXcml0dGVuKTsKKwkJCWxlbiAtPSBsZTMyX3Rv
X2NwdShyZXRidWYtPlRvdGFsQnl0ZXNXcml0dGVuKTsKKworCQkJY2lmc19kYmcoRllJLCAiQ2h1
bmtzICVkIFBhcnRpYWxDaHVuayAlZCBUb3RhbCAlZFxuIiwKKwkJCQlsZTMyX3RvX2NwdShyZXRi
dWYtPkNodW5rc1dyaXR0ZW4pLAorCQkJCWxlMzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtCeXRlc1dy
aXR0ZW4pLAorCQkJCWxlMzJfdG9fY3B1KHJldGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4pKTsKKwkJ
fSBlbHNlIGlmIChyYyA9PSAtRUlOVkFMKSB7CisJCQlpZiAocmV0X2RhdGFfbGVuICE9IHNpemVv
ZihzdHJ1Y3QgY29weWNodW5rX2lvY3RsX3JzcCkpCisJCQkJZ290byBjY2h1bmtfb3V0OworCisJ
CQljaWZzX2RiZyhGWUksICJNYXhDaHVua3MgJWQgQnl0ZXNDaHVuayAlZCBNYXhDb3B5ICVkXG4i
LAorCQkJCWxlMzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtzV3JpdHRlbiksCisJCQkJbGUzMl90b19j
cHUocmV0YnVmLT5DaHVua0J5dGVzV3JpdHRlbiksCisJCQkJbGUzMl90b19jcHUocmV0YnVmLT5U
b3RhbEJ5dGVzV3JpdHRlbikpOworCisJCQkvKgorCQkJICogQ2hlY2sgaWYgdGhpcyBpcyB0aGUg
Zmlyc3QgcmVxdWVzdCB1c2luZyB0aGVzZSBzaXplcywKKwkJCSAqIChpZSBjaGVjayBpZiBjb3B5
IHN1Y2NlZWQgb25jZSB3aXRoIG9yaWdpbmFsIHNpemVzCisJCQkgKiBhbmQgY2hlY2sgaWYgdGhl
IHNlcnZlciBnYXZlIHVzIGRpZmZlcmVudCBzaXplcyBhZnRlcgorCQkJICogd2UgYWxyZWFkeSB1
cGRhdGVkIG1heCBzaXplcyBvbiBwcmV2aW91cyByZXF1ZXN0KS4KKwkJCSAqIGlmIG5vdCB0aGVu
IHdoeSBpcyB0aGUgc2VydmVyIHJldHVybmluZyBhbiBlcnJvciBub3cKKwkJCSAqLworCQkJaWYg
KChjaHVua3NfY29waWVkICE9IDApIHx8IGNodW5rX3NpemVzX3VwZGF0ZWQpCisJCQkJZ290byBj
Y2h1bmtfb3V0OworCisJCQkvKiBDaGVjayB0aGF0IHNlcnZlciBpcyBub3QgYXNraW5nIHVzIHRv
IGdyb3cgc2l6ZSAqLworCQkJaWYgKGxlMzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtCeXRlc1dyaXR0
ZW4pIDwKKwkJCQkJdGNvbi0+bWF4X2J5dGVzX2NodW5rKQorCQkJCXRjb24tPm1heF9ieXRlc19j
aHVuayA9CisJCQkJCWxlMzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtCeXRlc1dyaXR0ZW4pOworCQkJ
ZWxzZQorCQkJCWdvdG8gY2NodW5rX291dDsgLyogc2VydmVyIGdhdmUgdXMgYm9ndXMgc2l6ZSAq
LworCisJCQkvKiBObyBuZWVkIHRvIGNoYW5nZSBNYXhDaHVua3Mgc2luY2UgYWxyZWFkeSBzZXQg
dG8gMSAqLworCQkJY2h1bmtfc2l6ZXNfdXBkYXRlZCA9IHRydWU7CisJCX0KKwl9CiAKK2NjaHVu
a19vdXQ6CiAJa2ZyZWUocGNjaHVuayk7CiAJcmV0dXJuIHJjOwogfQpkaWZmIC0tZ2l0IGEvZnMv
Y2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRleCBkNjUyNzBjLi5jNTkxNWRj
IDEwMDY0NAotLS0gYS9mcy9jaWZzL3NtYjJwZHUuYworKysgYi9mcy9jaWZzL3NtYjJwZHUuYwpA
QCAtMTIxNCw3ICsxMjE0LDcgQEAgU01CMl9pb2N0bChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLCB1NjQgcGVyc2lzdGVudF9maWQsCiAJcmMgPSBTZW5kUmVj
ZWl2ZTIoeGlkLCBzZXMsIGlvdiwgbnVtX2lvdmVjcywgJnJlc3BfYnVmdHlwZSwgMCk7CiAJcnNw
ID0gKHN0cnVjdCBzbWIyX2lvY3RsX3JzcCAqKWlvdlswXS5pb3ZfYmFzZTsKIAotCWlmIChyYyAh
PSAwKSB7CisJaWYgKChyYyAhPSAwKSAmJiAocmMgIT0gLUVJTlZBTCkpIHsKIAkJaWYgKHRjb24p
CiAJCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfSU9DVExfSEUpOwogCQlnb3RvIGlv
Y3RsX2V4aXQ7Ci0tIAoxLjguMy4xCgo=
--001a1133100e3a2fc904eb461004--
