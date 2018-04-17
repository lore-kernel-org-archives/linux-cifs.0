From: Long Li <longli@linuxonhyperv.com>
Subject: [Patch v2 3/6] cifs: smbd: Avoid allocating iov on the stack
Date: Tue, 17 Apr 2018 12:17:07 -0700
Message-ID: <20180417191710.14855-3-longli@linuxonhyperv.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>, stable@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417191710.14855-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

It's not necessary to allocate another iov when going through the buffers
in smbd_send() through RDMA send.

Remove it to reduce stack size.

Signed-off-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/cifs/smbdirect.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index b5c6c0d..f575e9a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -2088,7 +2088,7 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 	int start, i, j;
 	int max_iov_size =
 		info->max_send_size - sizeof(struct smbd_data_transfer);
-	struct kvec iov[SMBDIRECT_MAX_SGE];
+	struct kvec *iov;
 	int rc;
 
 	info->smbd_send_pending++;
@@ -2099,32 +2099,20 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 	}
 
 	/*
-	 * This usually means a configuration error
-	 * We use RDMA read/write for packet size > rdma_readwrite_threshold
-	 * as long as it's properly configured we should never get into this
-	 * situation
-	 */
-	if (rqst->rq_nvec + rqst->rq_npages > SMBDIRECT_MAX_SGE) {
-		log_write(ERR, "maximum send segment %x exceeding %x\n",
-			 rqst->rq_nvec + rqst->rq_npages, SMBDIRECT_MAX_SGE);
-		rc = -EINVAL;
-		goto done;
-	}
-
-	/*
-	 * Remove the RFC1002 length defined in MS-SMB2 section 2.1
-	 * It is used only for TCP transport
+	 * Skip the RFC1002 length defined in MS-SMB2 section 2.1
+	 * It is used only for TCP transport in the iov[0]
 	 * In future we may want to add a transport layer under protocol
 	 * layer so this will only be issued to TCP transport
 	 */
-	iov[0].iov_base = (char *)rqst->rq_iov[0].iov_base + 4;
-	iov[0].iov_len = rqst->rq_iov[0].iov_len - 4;
-	buflen += iov[0].iov_len;
+
+	if (rqst->rq_iov[0].iov_len != 4) {
+		log_write(ERR, "expected the pdu length in 1st iov, but got 0x%lu\n", rqst->rq_iov[0].iov_len);
+		return -EINVAL;
+	}
+	iov = &rqst->rq_iov[1];
 
 	/* total up iov array first */
-	for (i = 1; i < rqst->rq_nvec; i++) {
-		iov[i].iov_base = rqst->rq_iov[i].iov_base;
-		iov[i].iov_len = rqst->rq_iov[i].iov_len;
+	for (i = 0; i < rqst->rq_nvec-1; i++) {
 		buflen += iov[i].iov_len;
 	}
 
@@ -2197,14 +2185,14 @@ int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
 						goto done;
 				}
 				i++;
-				if (i == rqst->rq_nvec)
+				if (i == rqst->rq_nvec-1)
 					break;
 			}
 			start = i;
 			buflen = 0;
 		} else {
 			i++;
-			if (i == rqst->rq_nvec) {
+			if (i == rqst->rq_nvec-1) {
 				/* send out all remaining vecs */
 				remaining_data_length -= buflen;
 				log_write(INFO,
-- 
2.7.4
