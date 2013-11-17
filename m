From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: (unknown)
Date: Sat, 16 Nov 2013 18:12:14 -0600
Message-ID: <CAH2r5msND9eqACgS85WpXU_mv0r4H=uMs4LM8ynpoMNAa69n8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b15b265989e8c04eb544871
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Subject: 
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--047d7b15b265989e8c04eb544871
Content-Type: text/plain; charset=ISO-8859-1

David,
I have updated the patch as you suggested - let me know if you see
further changes needed.  I will probably wait a day or two before
sending this up since I would like to test this updated patch -
especially to do some additional perf testing and also to see if any
additional review feedback, but will send a request for the other
pending patches soon.

>From a289b96bfae816a8861ea51a97e74f54ff06f4b2 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Sat, 16 Nov 2013 18:05:28 -0600
Subject: [PATCH] CIFS: SMB2/SMB3 Copy offload support (refcopy) finish up

This third version of the patch, incorparating feedback from David Disseldorp
extends the ability of copychunk (refcopy) over smb2/smb3 mounts to
handle servers with smaller than usual maximum chunk sizes
and also to handle files bigger than the maximum chunk sizes

In the future this can be extended further to handle sending
multiple chunk requests in on SMB2 ioctl request which will
further improve performance, but even with one 1MB chunk per
request the speedup on cp is quite large.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2ops.c | 98 +++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/cifs/smb2pdu.c |  9 ++++-
 2 files changed, 93 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 11dde4b..a3968ee 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -532,7 +532,10 @@ smb2_clone_range(const unsigned int xid,
  int rc;
  unsigned int ret_data_len;
  struct copychunk_ioctl *pcchunk;
- char *retbuf = NULL;
+ struct copychunk_ioctl_rsp *retbuf = NULL;
+ struct cifs_tcon *tcon;
+ int chunks_copied = 0;
+ bool chunk_sizes_updated = false;

  pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);

@@ -547,27 +550,96 @@ smb2_clone_range(const unsigned int xid,

  /* Note: request_res_key sets res_key null only if rc !=0 */
  if (rc)
- return rc;
+ goto cchunk_out;

  /* For now array only one chunk long, will make more flexible later */
  pcchunk->ChunkCount = __constant_cpu_to_le32(1);
  pcchunk->Reserved = 0;
- pcchunk->SourceOffset = cpu_to_le64(src_off);
- pcchunk->TargetOffset = cpu_to_le64(dest_off);
- pcchunk->Length = cpu_to_le32(len);
  pcchunk->Reserved2 = 0;

- /* Request that server copy to target from src file identified by key */
- rc = SMB2_ioctl(xid, tlink_tcon(trgtfile->tlink),
- trgtfile->fid.persistent_fid,
- trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
- true /* is_fsctl */, (char *)pcchunk,
- sizeof(struct copychunk_ioctl), &retbuf, &ret_data_len);
+ tcon = tlink_tcon(trgtfile->tlink);

- /* BB need to special case rc = EINVAL to alter chunk size */
+ while (len > 0) {
+ pcchunk->SourceOffset = cpu_to_le64(src_off);
+ pcchunk->TargetOffset = cpu_to_le64(dest_off);
+ pcchunk->Length =
+ cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));

- cifs_dbg(FYI, "rc %d data length out %d\n", rc, ret_data_len);
+ /* Request server copy to target from src identified by key */
+ rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
+ trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
+ true /* is_fsctl */, (char *)pcchunk,
+ sizeof(struct copychunk_ioctl), (char **)&retbuf,
+ &ret_data_len);
+ if (rc == 0) {
+ if (ret_data_len !=
+ sizeof(struct copychunk_ioctl_rsp)) {
+ cifs_dbg(VFS, "invalid cchunk response size\n");
+ rc = -EIO;
+ goto cchunk_out;
+ }
+ if (retbuf->TotalBytesWritten == 0) {
+ cifs_dbg(FYI, "no bytes copied\n");
+ rc = -EIO;
+ goto cchunk_out;
+ }
+ /*
+ * Check if server claimed to write more than we asked
+ */
+ if (le32_to_cpu(retbuf->TotalBytesWritten) >
+    le32_to_cpu(pcchunk->Length)) {
+ cifs_dbg(VFS, "invalid copy chunk response\n");
+ rc = -EIO;
+ goto cchunk_out;
+ }
+ if (le32_to_cpu(retbuf->ChunksWritten) != 1) {
+ cifs_dbg(VFS, "invalid num chunks written\n");
+ rc = -EIO;
+ goto cchunk_out;
+ }
+ chunks_copied++;
+
+ src_off += le32_to_cpu(retbuf->TotalBytesWritten);
+ dest_off += le32_to_cpu(retbuf->TotalBytesWritten);
+ len -= le32_to_cpu(retbuf->TotalBytesWritten);
+
+ cifs_dbg(FYI, "Chunks %d PartialChunk %d Total %d\n",
+ le32_to_cpu(retbuf->ChunksWritten),
+ le32_to_cpu(retbuf->ChunkBytesWritten),
+ le32_to_cpu(retbuf->TotalBytesWritten));
+ } else if (rc == -EINVAL) {
+ if (ret_data_len != sizeof(struct copychunk_ioctl_rsp))
+ goto cchunk_out;
+
+ cifs_dbg(FYI, "MaxChunks %d BytesChunk %d MaxCopy %d\n",
+ le32_to_cpu(retbuf->ChunksWritten),
+ le32_to_cpu(retbuf->ChunkBytesWritten),
+ le32_to_cpu(retbuf->TotalBytesWritten));
+
+ /*
+ * Check if this is the first request using these sizes,
+ * (ie check if copy succeed once with original sizes
+ * and check if the server gave us different sizes after
+ * we already updated max sizes on previous request).
+ * if not then why is the server returning an error now
+ */
+ if ((chunks_copied != 0) || chunk_sizes_updated)
+ goto cchunk_out;
+
+ /* Check that server is not asking us to grow size */
+ if (le32_to_cpu(retbuf->ChunkBytesWritten) <
+ tcon->max_bytes_chunk)
+ tcon->max_bytes_chunk =
+ le32_to_cpu(retbuf->ChunkBytesWritten);
+ else
+ goto cchunk_out; /* server gave us bogus size */
+
+ /* No need to change MaxChunks since already set to 1 */
+ chunk_sizes_updated = true;
+ }
+ }

+cchunk_out:
  kfree(pcchunk);
  return rc;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d65270c..87f430e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1214,10 +1214,17 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
  rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
  rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;

- if (rc != 0) {
+ if ((rc != 0) && (rc != -EINVAL)) {
  if (tcon)
  cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
  goto ioctl_exit;
+ } else if (rc == -EINVAL) {
+ if ((opcode != FSCTL_SRV_COPYCHUNK_WRITE) &&
+    (opcode != FSCTL_SRV_COPYCHUNK)) {
+ if (tcon)
+ cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
+ goto ioctl_exit;
+ }
  }

  /* check if caller wants to look at return data or just return rc */
-- 
1.8.3.1


-- 
Thanks,

Steve

--047d7b15b265989e8c04eb544871
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-finish-u.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-SMB2-SMB3-Copy-offload-support-refcopy-finish-u.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho3j2kry0

RnJvbSBhMjg5Yjk2YmZhZTgxNmE4ODYxZWE1MWE5N2U3NGY1NGZmMDZmNGIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogU2F0LCAxNiBOb3YgMjAxMyAxODowNToyOCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIENJRlM6
IFNNQjIvU01CMyBDb3B5IG9mZmxvYWQgc3VwcG9ydCAocmVmY29weSkgZmluaXNoIHVwCgpUaGlz
IHRoaXJkIHZlcnNpb24gb2YgdGhlIHBhdGNoLCBpbmNvcnBhcmF0aW5nIGZlZWRiYWNrIGZyb20g
RGF2aWQgRGlzc2VsZG9ycApleHRlbmRzIHRoZSBhYmlsaXR5IG9mIGNvcHljaHVuayAocmVmY29w
eSkgb3ZlciBzbWIyL3NtYjMgbW91bnRzIHRvCmhhbmRsZSBzZXJ2ZXJzIHdpdGggc21hbGxlciB0
aGFuIHVzdWFsIG1heGltdW0gY2h1bmsgc2l6ZXMKYW5kIGFsc28gdG8gaGFuZGxlIGZpbGVzIGJp
Z2dlciB0aGFuIHRoZSBtYXhpbXVtIGNodW5rIHNpemVzCgpJbiB0aGUgZnV0dXJlIHRoaXMgY2Fu
IGJlIGV4dGVuZGVkIGZ1cnRoZXIgdG8gaGFuZGxlIHNlbmRpbmcKbXVsdGlwbGUgY2h1bmsgcmVx
dWVzdHMgaW4gb24gU01CMiBpb2N0bCByZXF1ZXN0IHdoaWNoIHdpbGwKZnVydGhlciBpbXByb3Zl
IHBlcmZvcm1hbmNlLCBidXQgZXZlbiB3aXRoIG9uZSAxTUIgY2h1bmsgcGVyCnJlcXVlc3QgdGhl
IHNwZWVkdXAgb24gY3AgaXMgcXVpdGUgbGFyZ2UuCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KLS0tCiBmcy9jaWZzL3NtYjJvcHMuYyB8IDk4ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0KIGZzL2Np
ZnMvc21iMnBkdS5jIHwgIDkgKysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgOTMgaW5zZXJ0aW9ucygr
KSwgMTQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIyb3BzLmMgYi9mcy9j
aWZzL3NtYjJvcHMuYwppbmRleCAxMWRkZTRiLi5hMzk2OGVlIDEwMDY0NAotLS0gYS9mcy9jaWZz
L3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtNTMyLDcgKzUzMiwxMCBAQCBz
bWIyX2Nsb25lX3JhbmdlKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsCiAJaW50IHJjOwogCXVuc2ln
bmVkIGludCByZXRfZGF0YV9sZW47CiAJc3RydWN0IGNvcHljaHVua19pb2N0bCAqcGNjaHVuazsK
LQljaGFyICpyZXRidWYgPSBOVUxMOworCXN0cnVjdCBjb3B5Y2h1bmtfaW9jdGxfcnNwICpyZXRi
dWYgPSBOVUxMOworCXN0cnVjdCBjaWZzX3Rjb24gKnRjb247CisJaW50IGNodW5rc19jb3BpZWQg
PSAwOworCWJvb2wgY2h1bmtfc2l6ZXNfdXBkYXRlZCA9IGZhbHNlOwogCiAJcGNjaHVuayA9IGtt
YWxsb2Moc2l6ZW9mKHN0cnVjdCBjb3B5Y2h1bmtfaW9jdGwpLCBHRlBfS0VSTkVMKTsKIApAQCAt
NTQ3LDI3ICs1NTAsOTYgQEAgc21iMl9jbG9uZV9yYW5nZShjb25zdCB1bnNpZ25lZCBpbnQgeGlk
LAogCiAJLyogTm90ZTogcmVxdWVzdF9yZXNfa2V5IHNldHMgcmVzX2tleSBudWxsIG9ubHkgaWYg
cmMgIT0wICovCiAJaWYgKHJjKQotCQlyZXR1cm4gcmM7CisJCWdvdG8gY2NodW5rX291dDsKIAog
CS8qIEZvciBub3cgYXJyYXkgb25seSBvbmUgY2h1bmsgbG9uZywgd2lsbCBtYWtlIG1vcmUgZmxl
eGlibGUgbGF0ZXIgKi8KIAlwY2NodW5rLT5DaHVua0NvdW50ID0gX19jb25zdGFudF9jcHVfdG9f
bGUzMigxKTsKIAlwY2NodW5rLT5SZXNlcnZlZCA9IDA7Ci0JcGNjaHVuay0+U291cmNlT2Zmc2V0
ID0gY3B1X3RvX2xlNjQoc3JjX29mZik7Ci0JcGNjaHVuay0+VGFyZ2V0T2Zmc2V0ID0gY3B1X3Rv
X2xlNjQoZGVzdF9vZmYpOwotCXBjY2h1bmstPkxlbmd0aCA9IGNwdV90b19sZTMyKGxlbik7CiAJ
cGNjaHVuay0+UmVzZXJ2ZWQyID0gMDsKIAotCS8qIFJlcXVlc3QgdGhhdCBzZXJ2ZXIgY29weSB0
byB0YXJnZXQgZnJvbSBzcmMgZmlsZSBpZGVudGlmaWVkIGJ5IGtleSAqLwotCXJjID0gU01CMl9p
b2N0bCh4aWQsIHRsaW5rX3Rjb24odHJndGZpbGUtPnRsaW5rKSwKLQkJCXRyZ3RmaWxlLT5maWQu
cGVyc2lzdGVudF9maWQsCi0JCQl0cmd0ZmlsZS0+ZmlkLnZvbGF0aWxlX2ZpZCwgRlNDVExfU1JW
X0NPUFlDSFVOS19XUklURSwKLQkJCXRydWUgLyogaXNfZnNjdGwgKi8sIChjaGFyICopcGNjaHVu
aywKLQkJCXNpemVvZihzdHJ1Y3QgY29weWNodW5rX2lvY3RsKSwJJnJldGJ1ZiwgJnJldF9kYXRh
X2xlbik7CisJdGNvbiA9IHRsaW5rX3Rjb24odHJndGZpbGUtPnRsaW5rKTsKIAotCS8qIEJCIG5l
ZWQgdG8gc3BlY2lhbCBjYXNlIHJjID0gRUlOVkFMIHRvIGFsdGVyIGNodW5rIHNpemUgKi8KKwl3
aGlsZSAobGVuID4gMCkgeworCQlwY2NodW5rLT5Tb3VyY2VPZmZzZXQgPSBjcHVfdG9fbGU2NChz
cmNfb2ZmKTsKKwkJcGNjaHVuay0+VGFyZ2V0T2Zmc2V0ID0gY3B1X3RvX2xlNjQoZGVzdF9vZmYp
OworCQlwY2NodW5rLT5MZW5ndGggPQorCQkJY3B1X3RvX2xlMzIobWluX3QodTMyLCBsZW4sIHRj
b24tPm1heF9ieXRlc19jaHVuaykpOwogCi0JY2lmc19kYmcoRllJLCAicmMgJWQgZGF0YSBsZW5n
dGggb3V0ICVkXG4iLCByYywgcmV0X2RhdGFfbGVuKTsKKwkJLyogUmVxdWVzdCBzZXJ2ZXIgY29w
eSB0byB0YXJnZXQgZnJvbSBzcmMgaWRlbnRpZmllZCBieSBrZXkgKi8KKwkJcmMgPSBTTUIyX2lv
Y3RsKHhpZCwgdGNvbiwgdHJndGZpbGUtPmZpZC5wZXJzaXN0ZW50X2ZpZCwKKwkJCXRyZ3RmaWxl
LT5maWQudm9sYXRpbGVfZmlkLCBGU0NUTF9TUlZfQ09QWUNIVU5LX1dSSVRFLAorCQkJdHJ1ZSAv
KiBpc19mc2N0bCAqLywgKGNoYXIgKilwY2NodW5rLAorCQkJc2l6ZW9mKHN0cnVjdCBjb3B5Y2h1
bmtfaW9jdGwpLAkoY2hhciAqKikmcmV0YnVmLAorCQkJJnJldF9kYXRhX2xlbik7CisJCWlmIChy
YyA9PSAwKSB7CisJCQlpZiAocmV0X2RhdGFfbGVuICE9CisJCQkJCXNpemVvZihzdHJ1Y3QgY29w
eWNodW5rX2lvY3RsX3JzcCkpIHsKKwkJCQljaWZzX2RiZyhWRlMsICJpbnZhbGlkIGNjaHVuayBy
ZXNwb25zZSBzaXplXG4iKTsKKwkJCQlyYyA9IC1FSU87CisJCQkJZ290byBjY2h1bmtfb3V0Owor
CQkJfQorCQkJaWYgKHJldGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4gPT0gMCkgeworCQkJCWNpZnNf
ZGJnKEZZSSwgIm5vIGJ5dGVzIGNvcGllZFxuIik7CisJCQkJcmMgPSAtRUlPOworCQkJCWdvdG8g
Y2NodW5rX291dDsKKwkJCX0KKwkJCS8qCisJCQkgKiBDaGVjayBpZiBzZXJ2ZXIgY2xhaW1lZCB0
byB3cml0ZSBtb3JlIHRoYW4gd2UgYXNrZWQKKwkJCSAqLworCQkJaWYgKGxlMzJfdG9fY3B1KHJl
dGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4pID4KKwkJCSAgICBsZTMyX3RvX2NwdShwY2NodW5rLT5M
ZW5ndGgpKSB7CisJCQkJY2lmc19kYmcoVkZTLCAiaW52YWxpZCBjb3B5IGNodW5rIHJlc3BvbnNl
XG4iKTsKKwkJCQlyYyA9IC1FSU87CisJCQkJZ290byBjY2h1bmtfb3V0OworCQkJfQorCQkJaWYg
KGxlMzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtzV3JpdHRlbikgIT0gMSkgeworCQkJCWNpZnNfZGJn
KFZGUywgImludmFsaWQgbnVtIGNodW5rcyB3cml0dGVuXG4iKTsKKwkJCQlyYyA9IC1FSU87CisJ
CQkJZ290byBjY2h1bmtfb3V0OworCQkJfQorCQkJY2h1bmtzX2NvcGllZCsrOworCisJCQlzcmNf
b2ZmICs9IGxlMzJfdG9fY3B1KHJldGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4pOworCQkJZGVzdF9v
ZmYgKz0gbGUzMl90b19jcHUocmV0YnVmLT5Ub3RhbEJ5dGVzV3JpdHRlbik7CisJCQlsZW4gLT0g
bGUzMl90b19jcHUocmV0YnVmLT5Ub3RhbEJ5dGVzV3JpdHRlbik7CisKKwkJCWNpZnNfZGJnKEZZ
SSwgIkNodW5rcyAlZCBQYXJ0aWFsQ2h1bmsgJWQgVG90YWwgJWRcbiIsCisJCQkJbGUzMl90b19j
cHUocmV0YnVmLT5DaHVua3NXcml0dGVuKSwKKwkJCQlsZTMyX3RvX2NwdShyZXRidWYtPkNodW5r
Qnl0ZXNXcml0dGVuKSwKKwkJCQlsZTMyX3RvX2NwdShyZXRidWYtPlRvdGFsQnl0ZXNXcml0dGVu
KSk7CisJCX0gZWxzZSBpZiAocmMgPT0gLUVJTlZBTCkgeworCQkJaWYgKHJldF9kYXRhX2xlbiAh
PSBzaXplb2Yoc3RydWN0IGNvcHljaHVua19pb2N0bF9yc3ApKQorCQkJCWdvdG8gY2NodW5rX291
dDsKKworCQkJY2lmc19kYmcoRllJLCAiTWF4Q2h1bmtzICVkIEJ5dGVzQ2h1bmsgJWQgTWF4Q29w
eSAlZFxuIiwKKwkJCQlsZTMyX3RvX2NwdShyZXRidWYtPkNodW5rc1dyaXR0ZW4pLAorCQkJCWxl
MzJfdG9fY3B1KHJldGJ1Zi0+Q2h1bmtCeXRlc1dyaXR0ZW4pLAorCQkJCWxlMzJfdG9fY3B1KHJl
dGJ1Zi0+VG90YWxCeXRlc1dyaXR0ZW4pKTsKKworCQkJLyoKKwkJCSAqIENoZWNrIGlmIHRoaXMg
aXMgdGhlIGZpcnN0IHJlcXVlc3QgdXNpbmcgdGhlc2Ugc2l6ZXMsCisJCQkgKiAoaWUgY2hlY2sg
aWYgY29weSBzdWNjZWVkIG9uY2Ugd2l0aCBvcmlnaW5hbCBzaXplcworCQkJICogYW5kIGNoZWNr
IGlmIHRoZSBzZXJ2ZXIgZ2F2ZSB1cyBkaWZmZXJlbnQgc2l6ZXMgYWZ0ZXIKKwkJCSAqIHdlIGFs
cmVhZHkgdXBkYXRlZCBtYXggc2l6ZXMgb24gcHJldmlvdXMgcmVxdWVzdCkuCisJCQkgKiBpZiBu
b3QgdGhlbiB3aHkgaXMgdGhlIHNlcnZlciByZXR1cm5pbmcgYW4gZXJyb3Igbm93CisJCQkgKi8K
KwkJCWlmICgoY2h1bmtzX2NvcGllZCAhPSAwKSB8fCBjaHVua19zaXplc191cGRhdGVkKQorCQkJ
CWdvdG8gY2NodW5rX291dDsKKworCQkJLyogQ2hlY2sgdGhhdCBzZXJ2ZXIgaXMgbm90IGFza2lu
ZyB1cyB0byBncm93IHNpemUgKi8KKwkJCWlmIChsZTMyX3RvX2NwdShyZXRidWYtPkNodW5rQnl0
ZXNXcml0dGVuKSA8CisJCQkJCXRjb24tPm1heF9ieXRlc19jaHVuaykKKwkJCQl0Y29uLT5tYXhf
Ynl0ZXNfY2h1bmsgPQorCQkJCQlsZTMyX3RvX2NwdShyZXRidWYtPkNodW5rQnl0ZXNXcml0dGVu
KTsKKwkJCWVsc2UKKwkJCQlnb3RvIGNjaHVua19vdXQ7IC8qIHNlcnZlciBnYXZlIHVzIGJvZ3Vz
IHNpemUgKi8KKworCQkJLyogTm8gbmVlZCB0byBjaGFuZ2UgTWF4Q2h1bmtzIHNpbmNlIGFscmVh
ZHkgc2V0IHRvIDEgKi8KKwkJCWNodW5rX3NpemVzX3VwZGF0ZWQgPSB0cnVlOworCQl9CisJfQog
CitjY2h1bmtfb3V0OgogCWtmcmVlKHBjY2h1bmspOwogCXJldHVybiByYzsKIH0KZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggZDY1MjcwYy4u
ODdmNDMwZSAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmMKQEAgLTEyMTQsMTAgKzEyMTQsMTcgQEAgU01CMl9pb2N0bChjb25zdCB1bnNpZ25lZCBp
bnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLCB1NjQgcGVyc2lzdGVudF9maWQsCiAJcmMg
PSBTZW5kUmVjZWl2ZTIoeGlkLCBzZXMsIGlvdiwgbnVtX2lvdmVjcywgJnJlc3BfYnVmdHlwZSwg
MCk7CiAJcnNwID0gKHN0cnVjdCBzbWIyX2lvY3RsX3JzcCAqKWlvdlswXS5pb3ZfYmFzZTsKIAot
CWlmIChyYyAhPSAwKSB7CisJaWYgKChyYyAhPSAwKSAmJiAocmMgIT0gLUVJTlZBTCkpIHsKIAkJ
aWYgKHRjb24pCiAJCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfSU9DVExfSEUpOwog
CQlnb3RvIGlvY3RsX2V4aXQ7CisJfSBlbHNlIGlmIChyYyA9PSAtRUlOVkFMKSB7CisJCWlmICgo
b3Bjb2RlICE9IEZTQ1RMX1NSVl9DT1BZQ0hVTktfV1JJVEUpICYmCisJCSAgICAob3Bjb2RlICE9
IEZTQ1RMX1NSVl9DT1BZQ0hVTkspKSB7CisJCQlpZiAodGNvbikKKwkJCQljaWZzX3N0YXRzX2Zh
aWxfaW5jKHRjb24sIFNNQjJfSU9DVExfSEUpOworCQkJZ290byBpb2N0bF9leGl0OworCQl9CiAJ
fQogCiAJLyogY2hlY2sgaWYgY2FsbGVyIHdhbnRzIHRvIGxvb2sgYXQgcmV0dXJuIGRhdGEgb3Ig
anVzdCByZXR1cm4gcmMgKi8KLS0gCjEuOC4zLjEKCg==
--047d7b15b265989e8c04eb544871--
