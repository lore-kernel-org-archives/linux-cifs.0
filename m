From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 18/37] [CIFS] SMBD: Implement API for upper layer to send data
Date: Wed,  2 Aug 2017 13:10:29 -0700
Message-ID: <1501704648-20159-19-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

Implement cifs_rdma_write for send an upper layer data. Upper layer uses this function to do a RDMA send. This function is also used to pass SMB packets for doing a RDMA read/write via memory registration.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |   5 ++
 2 files changed, 182 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index ef21f1c..eb48651 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -229,6 +229,10 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 			request->sge[i].length,
 			DMA_TO_DEVICE);
 
+	if (atomic_dec_and_test(&request->info->send_pending)) {
+		wake_up(&request->info->wait_send_pending);
+	}
+
 	kfree(request->sge);
 	mempool_free(request, request->info->request_mempool);
 }
@@ -551,12 +555,14 @@ static int cifs_rdma_post_send_negotiate_req(struct cifs_rdma_info *info)
 		request->sge[0].addr,
 		request->sge[0].length, request->sge[0].lkey);
 
+	atomic_inc(&info->send_pending);
 	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
 	if (!rc)
 		return 0;
 
 	// if we reach here, post send failed
 	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	atomic_dec(&info->send_pending);
 	ib_dma_unmap_single(info->id->device, request->sge[0].addr,
 		request->sge[0].length, DMA_TO_DEVICE);
 
@@ -662,12 +668,14 @@ static int cifs_rdma_post_send_page(struct cifs_rdma_info *info, struct page *pa
 	send_wr.opcode = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
+	atomic_inc(&info->send_pending);
 	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
 	if (!rc)
 		return 0;
 
 	// post send failed
 	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	atomic_dec(&info->send_pending);
 
 dma_mapping_failed:
 	for (i=0; i<2; i++)
@@ -768,11 +776,13 @@ static int cifs_rdma_post_send_empty(struct cifs_rdma_info *info)
 	send_wr.opcode = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
+	atomic_inc(&info->send_pending);
 	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
 	if (!rc)
 		return 0;
 
 	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	atomic_dec(&info->send_pending);
 	ib_dma_unmap_single(info->id->device, request->sge[0].addr,
 			    request->sge[0].length, DMA_TO_DEVICE);
 
@@ -885,12 +895,14 @@ static int cifs_rdma_post_send_data(
 	send_wr.opcode = IB_WR_SEND;
 	send_wr.send_flags = IB_SEND_SIGNALED;
 
+	atomic_inc(&info->send_pending);
 	rc = ib_post_send(info->id->qp, &send_wr, &send_wr_fail);
 	if (!rc)
 		return 0;
 
 	// post send failed
 	log_rdma_send("ib_post_send failed rc=%d\n", rc);
+	atomic_dec(&info->send_pending);
 
 dma_mapping_failure:
 	for (i=0; i<n_vec+1; i++)
@@ -1185,6 +1197,9 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	allocate_receive_buffers(info, info->receive_credit_max);
 	init_waitqueue_head(&info->wait_send_queue);
 
+	init_waitqueue_head(&info->wait_send_pending);
+	atomic_set(&info->send_pending, 0);
+
 	init_waitqueue_head(&info->wait_recv_pending);
 	atomic_set(&info->recv_pending, 0);
 
@@ -1202,3 +1217,165 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 	kfree(info);
 	return NULL;
 }
+
+/*
+ * Write data to transport
+ * Each rqst is transported as a SMBDirect payload
+ * rqst: the data to write
+ * return value: 0 if successfully write, otherwise error code
+ */
+int cifs_rdma_write(struct cifs_rdma_info *info, struct smb_rqst *rqst)
+{
+	struct kvec vec;
+	int nvecs;
+	int size;
+	int buflen=0, remaining_data_length;
+	int start, i, j;
+	int max_iov_size = info->max_send_size - sizeof(struct smbd_data_transfer);
+	struct kvec *iov;
+	int rc;
+
+	if (info->transport_status != CIFS_RDMA_CONNECTED) {
+		log_cifs_write("disconnected returning -EIO\n");
+		return -EIO;
+	}
+
+	iov = kzalloc(sizeof(struct kvec)*rqst->rq_nvec, GFP_KERNEL);
+	if (!iov) {
+		log_cifs_write("failed to allocate iov returing -ENOMEM\n");
+		return -ENOMEM;
+	}
+
+	/* Strip the first 4 bytes MS-SMB2 section 2.1
+	 * they are used only for TCP transport */
+	iov[0].iov_base = (char*)rqst->rq_iov[0].iov_base + 4;
+	iov[0].iov_len = rqst->rq_iov[0].iov_len - 4;
+	buflen += iov[0].iov_len;
+
+	/* total up iov array first */
+	for (i = 1; i < rqst->rq_nvec; i++) {
+		iov[i].iov_base = rqst->rq_iov[i].iov_base;
+		iov[i].iov_len = rqst->rq_iov[i].iov_len;
+		buflen += iov[i].iov_len;
+	}
+
+	/* add in the page array if there is one */
+	if (rqst->rq_npages) {
+		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
+		buflen += rqst->rq_tailsz;
+	}
+
+	if (buflen + sizeof(struct smbd_data_transfer) >
+		info->max_fragmented_send_size) {
+		log_cifs_write("payload size %d > max size %d\n",
+			buflen, info->max_fragmented_send_size);
+		rc = -EINVAL;
+		goto done;
+	}
+
+	remaining_data_length = buflen;
+
+	log_cifs_write("rqst->rq_nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
+		"rq_tailsz=%d buflen=%d\n",
+		rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
+		rqst->rq_tailsz, buflen);
+
+	start = i = iov[0].iov_len ? 0 : 1;
+	buflen = 0;
+	while (true){
+		buflen += iov[i].iov_len;
+		if (buflen > max_iov_size) {
+			if (i > start) {
+				remaining_data_length -=
+					(buflen-iov[i].iov_len);
+				log_cifs_write("sending iov[] from start=%d "
+					"i=%d nvecs=%d "
+					"remaining_data_length=%d\n",
+					start, i, i-start,
+					remaining_data_length);
+				rc = cifs_rdma_post_send_data(
+					info, &iov[start], i-start,
+					remaining_data_length);
+				if (rc)
+					goto done;
+			} else {
+				// iov[start] is too big, break it to nvecs pieces
+				nvecs = (buflen+max_iov_size-1)/max_iov_size;
+				log_cifs_write("iov[%d] iov_base=%p buflen=%d"
+					" break to %d vectors\n",
+					start, iov[start].iov_base,
+					buflen, nvecs);
+				for (j=0; j<nvecs; j++) {
+					vec.iov_base =
+						(char *)iov[start].iov_base +
+						j*max_iov_size;
+					vec.iov_len = max_iov_size;
+					if (j == nvecs-1)
+						vec.iov_len =
+							buflen -
+							max_iov_size*(nvecs-1);
+					remaining_data_length -= vec.iov_len;
+					log_cifs_write(
+						"sending vec j=%d iov_base=%p"
+						" iov_len=%lu "
+						"remaining_data_length=%d\n",
+						j, vec.iov_base, vec.iov_len,
+						remaining_data_length);
+					rc = cifs_rdma_post_send_data(
+						info, &vec, 1,
+						remaining_data_length);
+					if (rc)
+						goto done;
+				}
+				i++;
+			}
+			start = i;
+			buflen = 0;
+		} else {
+			i++;
+			if (i == rqst->rq_nvec) {
+				// send out all remaining vecs and we are done
+				remaining_data_length -= buflen;
+				log_cifs_write(
+					"sending iov[] from start=%d i=%d "
+					"nvecs=%d remaining_data_length=%d\n",
+					start, i, i-start,
+					remaining_data_length);
+				rc = cifs_rdma_post_send_data(info, &iov[start],
+					i-start, remaining_data_length);
+				if (rc)
+					goto done;
+				break;
+			}
+		}
+		log_cifs_write("looping i=%d buflen=%d\n", i, buflen);
+	}
+
+	// now sending pages
+	for (i = 0; i < rqst->rq_npages; i++) {
+		buflen = (i == rqst->rq_npages-1) ?
+			rqst->rq_tailsz : rqst->rq_pagesz;
+		nvecs = (buflen+max_iov_size-1)/max_iov_size;
+		log_cifs_write("sending pages buflen=%d nvecs=%d\n",
+			buflen, nvecs);
+		for (j=0; j<nvecs; j++) {
+			size = max_iov_size;
+			if (j == nvecs-1)
+				size = buflen - j*max_iov_size;
+			remaining_data_length -= size;
+			log_cifs_write("sending pages i=%d offset=%d size=%d"
+				" remaining_data_length=%d\n",
+				i, j*max_iov_size, size, remaining_data_length);
+			rc = cifs_rdma_post_send_page(
+				info, rqst->rq_pages[i], j*max_iov_size,
+				size, remaining_data_length);
+			if (rc)
+				goto done;
+		}
+	}
+
+done:
+	kfree(iov);
+	wait_event(info->wait_send_pending, atomic_read(&info->send_pending) == 0);
+	return rc;
+}
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index 9618e0b..90746a4 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -73,6 +73,9 @@ struct cifs_rdma_info {
 	atomic_t receive_credits;
 	atomic_t receive_credit_target;
 
+	atomic_t send_pending;
+	wait_queue_head_t wait_send_pending;
+
 	atomic_t recv_pending;
 	wait_queue_head_t wait_recv_pending;
 
@@ -195,4 +198,6 @@ struct cifs_rdma_response {
 // Create a SMBDirect session
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
+
+int cifs_rdma_write(struct cifs_rdma_info *rdma, struct smb_rqst *rqst);
 #endif
-- 
2.7.4
