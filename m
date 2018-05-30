From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 12/15] CIFS: Pass page offset for encrypting
Date: Wed, 30 May 2018 12:48:04 -0700
Message-ID: <20180530194807.31657-13-longli@linuxonhyperv.com>
References: <20180530194807.31657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530194807.31657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

Encryption function needs to read data starting page offset from input
buffer.

This doesn't affect decryption path since it allocates its own page
buffers.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2ops.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 1fa1c29..38d19b6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2189,9 +2189,10 @@ init_sg(struct smb_rqst *rqst, u8 *sign)
 		smb2_sg_set_buf(&sg[i], rqst->rq_iov[i].iov_base,
 						rqst->rq_iov[i].iov_len);
 	for (j = 0; i < sg_len - 1; i++, j++) {
-		unsigned int len = (j < rqst->rq_npages - 1) ? rqst->rq_pagesz
-							: rqst->rq_tailsz;
-		sg_set_page(&sg[i], rqst->rq_pages[j], len, 0);
+		unsigned int len, offset;
+
+		rqst_page_get_length(rqst, j, &len, &offset);
+		sg_set_page(&sg[i], rqst->rq_pages[j], len, offset);
 	}
 	smb2_sg_set_buf(&sg[sg_len - 1], sign, SMB2_SIGNATURE_SIZE);
 	return sg;
@@ -2332,6 +2333,7 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 		return rc;
 
 	new_rq->rq_pages = pages;
+	new_rq->rq_offset = old_rq->rq_offset;
 	new_rq->rq_npages = old_rq->rq_npages;
 	new_rq->rq_pagesz = old_rq->rq_pagesz;
 	new_rq->rq_tailsz = old_rq->rq_tailsz;
@@ -2363,10 +2365,14 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, struct smb_rqst *new_rq,
 
 	/* copy pages form the old */
 	for (i = 0; i < npages; i++) {
-		char *dst = kmap(new_rq->rq_pages[i]);
-		char *src = kmap(old_rq->rq_pages[i]);
-		unsigned int len = (i < npages - 1) ? new_rq->rq_pagesz :
-							new_rq->rq_tailsz;
+		char *dst, *src;
+		unsigned int offset, len;
+
+		rqst_page_get_length(new_rq, i, &len, &offset);
+
+		dst = (char *) kmap(new_rq->rq_pages[i]) + offset;
+		src = (char *) kmap(old_rq->rq_pages[i]) + offset;
+
 		memcpy(dst, src, len);
 		kunmap(new_rq->rq_pages[i]);
 		kunmap(old_rq->rq_pages[i]);
-- 
2.7.4
