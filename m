From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS][PATCH] set copy chunk defaults
Date: Fri, 15 Nov 2013 11:34:18 -0600
Message-ID: <CAH2r5ms-1ZZxKqCDr+0xOxmDcjNPtmv=v+-Q1FkQ4EnJb=DSOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8ffba027a4195904eb3a9b1b
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	Christof Schmitt <christof.schmitt-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--e89a8ffba027a4195904eb3a9b1b
Content-Type: text/plain; charset=ISO-8859-1

>From e53cf824641ad237e1b7ceb09aefbfbfb1787f47 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, 15 Nov 2013 11:26:24 -0600
Subject: [PATCH] [CIFS] Set copychunk defaults

Patch 2 of the copy chunk series (the final patch will
use these to handle copies of files larger than the chunk size.

We set the same defaults that Windows and Samba expect for
CopyChunk.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +++
 fs/cifs/smb2pdu.c  | 10 +++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 50a6ca1..d9ea7ad 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -858,6 +858,9 @@ struct cifs_tcon {
  __le64 vol_create_time;
  __u32 ss_flags; /* sector size flags */
  __u32 perf_sector_size; /* best sector size for perf */
+ __u32 max_chunks;
+ __u32 max_bytes_chunk;
+ __u32 max_bytes_copy;
 #endif /* CONFIG_CIFS_SMB2 */
 #ifdef CONFIG_CIFS_FSCACHE
  u64 resource_id; /* server resource id */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8ab05b0..ca7f307 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -717,6 +717,14 @@ static inline void cifs_stats_fail_inc(struct
cifs_tcon *tcon, uint16_t code)

 #define MAX_SHARENAME_LENGTH (255 /* server */ + 80 /* share */ + 1 /* NULL */)

+/* These are similar values to what Windows uses */
+static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
+{
+ tcon->max_chunks = 256;
+ tcon->max_bytes_chunk = 1048576;
+ tcon->max_bytes_copy = 16777216;
+}
+
 int
 SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
   struct cifs_tcon *tcon, const struct nls_table *cp)
@@ -818,7 +826,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
*ses, const char *tree,
  if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
     ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
  cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
-
+ init_copy_chunk_defaults(tcon);
 tcon_exit:
  free_rsp_buf(resp_buftype, rsp);
  kfree(unc_path);
-- 
1.8.3.1


-- 
Thanks,

Steve

--e89a8ffba027a4195904eb3a9b1b
Content-Type: text/x-patch; charset=US-ASCII; name="0001-CIFS-Set-copychunk-defaults.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Set-copychunk-defaults.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ho1phi8a0

RnJvbSBlNTNjZjgyNDY0MWFkMjM3ZTFiN2NlYjA5YWVmYmZiZmIxNzg3ZjQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KRGF0
ZTogRnJpLCAxNSBOb3YgMjAxMyAxMToyNjoyNCAtMDYwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBTZXQgY29weWNodW5rIGRlZmF1bHRzCgpQYXRjaCAyIG9mIHRoZSBjb3B5IGNodW5rIHNlcmll
cyAodGhlIGZpbmFsIHBhdGNoIHdpbGwKdXNlIHRoZXNlIHRvIGhhbmRsZSBjb3BpZXMgb2YgZmls
ZXMgbGFyZ2VyIHRoYW4gdGhlIGNodW5rIHNpemUuCgpXZSBzZXQgdGhlIHNhbWUgZGVmYXVsdHMg
dGhhdCBXaW5kb3dzIGFuZCBTYW1iYSBleHBlY3QgZm9yCkNvcHlDaHVuay4KClNpZ25lZC1vZmYt
Ynk6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2NpZnMvY2lmc2ds
b2IuaCB8ICAzICsrKwogZnMvY2lmcy9zbWIycGR1LmMgIHwgMTAgKysrKysrKysrLQogMiBmaWxl
cyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9jaWZzZ2xvYi5oIGIvZnMvY2lmcy9jaWZzZ2xvYi5oCmluZGV4IDUwYTZjYTEuLmQ5
ZWE3YWQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc2dsb2IuaAorKysgYi9mcy9jaWZzL2NpZnNn
bG9iLmgKQEAgLTg1OCw2ICs4NTgsOSBAQCBzdHJ1Y3QgY2lmc190Y29uIHsKIAlfX2xlNjQgdm9s
X2NyZWF0ZV90aW1lOwogCV9fdTMyIHNzX2ZsYWdzOwkJLyogc2VjdG9yIHNpemUgZmxhZ3MgKi8K
IAlfX3UzMiBwZXJmX3NlY3Rvcl9zaXplOyAvKiBiZXN0IHNlY3RvciBzaXplIGZvciBwZXJmICov
CisJX191MzIgbWF4X2NodW5rczsKKwlfX3UzMiBtYXhfYnl0ZXNfY2h1bms7CisJX191MzIgbWF4
X2J5dGVzX2NvcHk7CiAjZW5kaWYgLyogQ09ORklHX0NJRlNfU01CMiAqLwogI2lmZGVmIENPTkZJ
R19DSUZTX0ZTQ0FDSEUKIAl1NjQgcmVzb3VyY2VfaWQ7CQkvKiBzZXJ2ZXIgcmVzb3VyY2UgaWQg
Ki8KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5k
ZXggOGFiMDViMC4uY2E3ZjMwNyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIv
ZnMvY2lmcy9zbWIycGR1LmMKQEAgLTcxNyw2ICs3MTcsMTQgQEAgc3RhdGljIGlubGluZSB2b2lk
IGNpZnNfc3RhdHNfZmFpbF9pbmMoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgdWludDE2X3QgY29k
ZSkKIAogI2RlZmluZSBNQVhfU0hBUkVOQU1FX0xFTkdUSCAoMjU1IC8qIHNlcnZlciAqLyArIDgw
IC8qIHNoYXJlICovICsgMSAvKiBOVUxMICovKQogCisvKiBUaGVzZSBhcmUgc2ltaWxhciB2YWx1
ZXMgdG8gd2hhdCBXaW5kb3dzIHVzZXMgKi8KK3N0YXRpYyBpbmxpbmUgdm9pZCBpbml0X2NvcHlf
Y2h1bmtfZGVmYXVsdHMoc3RydWN0IGNpZnNfdGNvbiAqdGNvbikKK3sKKwl0Y29uLT5tYXhfY2h1
bmtzID0gMjU2OworCXRjb24tPm1heF9ieXRlc19jaHVuayA9IDEwNDg1NzY7CisJdGNvbi0+bWF4
X2J5dGVzX2NvcHkgPSAxNjc3NzIxNjsKK30KKwogaW50CiBTTUIyX3Rjb24oY29uc3QgdW5zaWdu
ZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsIGNvbnN0IGNoYXIgKnRyZWUsCiAJICBz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLCBjb25zdCBzdHJ1Y3QgbmxzX3RhYmxlICpjcCkKQEAgLTgx
OCw3ICs4MjYsNyBAQCBTTUIyX3Rjb24oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNp
ZnNfc2VzICpzZXMsIGNvbnN0IGNoYXIgKnRyZWUsCiAJaWYgKChyc3AtPkNhcGFiaWxpdGllcyAm
IFNNQjJfU0hBUkVfQ0FQX0RGUykgJiYKIAkgICAgKCh0Y29uLT5zaGFyZV9mbGFncyAmIFNISTEw
MDVfRkxBR1NfREZTKSA9PSAwKSkKIAkJY2lmc19kYmcoVkZTLCAiREZTIGNhcGFiaWxpdHkgY29u
dHJhZGljdHMgREZTIGZsYWdcbiIpOwotCisJaW5pdF9jb3B5X2NodW5rX2RlZmF1bHRzKHRjb24p
OwogdGNvbl9leGl0OgogCWZyZWVfcnNwX2J1ZihyZXNwX2J1ZnR5cGUsIHJzcCk7CiAJa2ZyZWUo
dW5jX3BhdGgpOwotLSAKMS44LjMuMQoK
--e89a8ffba027a4195904eb3a9b1b--
