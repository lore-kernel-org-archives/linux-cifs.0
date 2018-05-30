From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 07/15] CIFS: When sending data on socket, pass the correct page offset
Date: Wed, 30 May 2018 12:47:59 -0700
Message-ID: <20180530194807.31657-8-longli@linuxonhyperv.com>
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

It's possible that the offset is non-zero in the page to send, change the
function to pass this offset to socket.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d6b5523..5c96ee8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -288,15 +288,13 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 
 	/* now walk the page array and send each page in it */
 	for (i = 0; i < rqst->rq_npages; i++) {
-		size_t len = i == rqst->rq_npages - 1
-				? rqst->rq_tailsz
-				: rqst->rq_pagesz;
-		struct bio_vec bvec = {
-			.bv_page = rqst->rq_pages[i],
-			.bv_len = len
-		};
+		struct bio_vec bvec;
+
+		bvec.bv_page = rqst->rq_pages[i];
+		rqst_page_get_length(rqst, i, &bvec.bv_len, &bvec.bv_offset);
+
 		iov_iter_bvec(&smb_msg.msg_iter, WRITE | ITER_BVEC,
-			      &bvec, 1, len);
+			      &bvec, 1, bvec.bv_len);
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
 			break;
-- 
2.7.4
