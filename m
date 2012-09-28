From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: convert to use be32_add_cpu()
Date: Fri, 28 Sep 2012 12:49:51 +0800
Message-ID: <CAPgLHd9ixgpjFc7c4dq2aJyaZxr0E4YE+y7n_0ox59JSx0LVAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Convert cpu_to_be32(be32_to_cpu(E1) + E2) to use be32_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 fs/cifs/sess.c    | 3 +--
 fs/cifs/connect.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 382c06d..148ac5c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -864,8 +864,7 @@ ssetup_ntlmssp_authenticate:
 	iov[2].iov_len = (long) bcc_ptr - (long) str_area;
 
 	count = iov[1].iov_len + iov[2].iov_len;
-	smb_buf->smb_buf_length =
-		cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);
+	be32_add_cpu(&smb_buf->smb_buf_length, count);
 
 	put_bcc(count, smb_buf);
 

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6df6fa1..e8e7011 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3863,8 +3863,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	bcc_ptr += strlen("?????");
 	bcc_ptr += 1;
 	count = bcc_ptr - &pSMB->Password[0];
-	pSMB->hdr.smb_buf_length = cpu_to_be32(be32_to_cpu(
-					pSMB->hdr.smb_buf_length) + count);
+	be32_add_cpu(&pSMB->hdr.smb_buf_length, count);
 	pSMB->ByteCount = cpu_to_le16(count);
 
 	rc = SendReceive(xid, ses, smb_buffer, smb_buffer_response, &length,
