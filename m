From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v3 05/16] CIFS: Calculate the correct request length based on page offset and tail size
Date: Sat,  8 Sep 2018 02:13:37 +0000
Message-ID: <20180908021348.19956-6-longli@linuxonhyperv.com>
References: <20180908021348.19956-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180908021348.19956-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

It's possible that the page offset is non-zero in the pages in a request,
change the function to calculate the correct data buffer length.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/transport.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 927226a..d6b5523 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -212,10 +212,24 @@ rqst_len(struct smb_rqst *rqst)
 	for (i = 0; i < rqst->rq_nvec; i++)
 		buflen += iov[i].iov_len;
 
-	/* add in the page array if there is one */
+	/*
+	 * Add in the page array if there is one. The caller needs to make
+	 * sure rq_offset and rq_tailsz are set correctly. If a buffer of
+	 * multiple pages ends at page boundary, rq_tailsz needs to be set to
+	 * PAGE_SIZE.
+	 */
 	if (rqst->rq_npages) {
-		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
-		buflen += rqst->rq_tailsz;
+		if (rqst->rq_npages == 1)
+			buflen += rqst->rq_tailsz;
+		else {
+			/*
+			 * If there is more than one page, calculate the
+			 * buffer length based on rq_offset and rq_tailsz
+			 */
+			buflen += rqst->rq_pagesz * (rqst->rq_npages - 1) -
+					rqst->rq_offset;
+			buflen += rqst->rq_tailsz;
+		}
 	}
 
 	return buflen;
-- 
2.7.4
