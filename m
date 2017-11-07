From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v7 16/22] CIFS: SMBD: Implement function to send data via RDMA send
Date: Tue,  7 Nov 2017 01:55:08 -0700
Message-ID: <20171107085514.12693-17-longli@exchange.microsoft.com>
References: <20171107085514.12693-1-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171107085514.12693-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

The transport doesn't maintain send buffers or send queue for transferring
payload via RDMA send. There is no data copy in the transport on send.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smbdirect.c | 246 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h |   3 +
 2 files changed, 249 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5a08015..0705f49 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -42,6 +42,12 @@ static int smbd_post_recv(
 		struct smbd_response *response);
 
 static int smbd_post_send_empty(struct smbd_connection *info);
+static int smbd_post_send_data(
+		struct smbd_connection *info,
+		struct kvec *iov, int n_vec, int remaining_data_length);
+static int smbd_post_send_page(struct smbd_connection *info,
+		struct page *page, unsigned long offset,
+		size_t size, int remaining_data_length);
 
 /* SMBD version number */
 #define SMBD_V1	0x0100
@@ -178,6 +184,10 @@ static void smbd_destroy_rdma_work(struct work_struct *work)
 	log_rdma_event(INFO, "cancelling send immediate work\n");
 	cancel_delayed_work_sync(&info->send_immediate_work);
 
+	log_rdma_event(INFO, "wait for all send to finish\n");
+	wait_event(info->wait_smbd_send_pending,
+		info->smbd_send_pending == 0);
+
 	log_rdma_event(INFO, "wait for all recv to finish\n");
 	wake_up_interruptible(&info->wait_reassembly_queue);
 	wait_event(info->wait_smbd_recv_pending,
@@ -1080,6 +1090,24 @@ static int smbd_post_send_sgl(struct smbd_connection *info,
 }
 
 /*
+ * Send a page
+ * page: the page to send
+ * offset: offset in the page to send
+ * size: length in the page to send
+ * remaining_data_length: remaining data to send in this payload
+ */
+static int smbd_post_send_page(struct smbd_connection *info, struct page *page,
+		unsigned long offset, size_t size, int remaining_data_length)
+{
+	struct scatterlist sgl;
+
+	sg_init_table(&sgl, 1);
+	sg_set_page(&sgl, page, size, offset);
+
+	return smbd_post_send_sgl(info, &sgl, size, remaining_data_length);
+}
+
+/*
  * Send an empty message
  * Empty message is used to extend credits to peer to for keep live
  * while there is no upper layer payload to send at the time
@@ -1091,6 +1119,35 @@ static int smbd_post_send_empty(struct smbd_connection *info)
 }
 
 /*
+ * Send a data buffer
+ * iov: the iov array describing the data buffers
+ * n_vec: number of iov array
+ * remaining_data_length: remaining data to send following this packet
+ * in segmented SMBD packet
+ */
+static int smbd_post_send_data(
+	struct smbd_connection *info, struct kvec *iov, int n_vec,
+	int remaining_data_length)
+{
+	int i;
+	u32 data_length = 0;
+	struct scatterlist sgl[SMBDIRECT_MAX_SGE];
+
+	if (n_vec > SMBDIRECT_MAX_SGE) {
+		cifs_dbg(VFS, "Can't fit data to SGL, n_vec=%d\n", n_vec);
+		return -ENOMEM;
+	}
+
+	sg_init_table(sgl, n_vec);
+	for (i = 0; i < n_vec; i++) {
+		data_length += iov[i].iov_len;
+		sg_set_buf(&sgl[i], iov[i].iov_base, iov[i].iov_len);
+	}
+
+	return smbd_post_send_sgl(info, sgl, data_length, remaining_data_length);
+}
+
+/*
  * Post a receive request to the transport
  * The remote peer can only send data when a receive request is posted
  * The interaction is controlled by send/receive credit system
@@ -1657,6 +1714,9 @@ struct smbd_connection *_smbd_get_connection(
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
 		info->keep_alive_interval*HZ);
 
+	init_waitqueue_head(&info->wait_smbd_send_pending);
+	info->smbd_send_pending = 0;
+
 	init_waitqueue_head(&info->wait_smbd_recv_pending);
 	info->smbd_recv_pending = 0;
 
@@ -1948,3 +2008,189 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 		msg->msg_iter.count = 0;
 	return rc;
 }
+
+/*
+ * Send data to transport
+ * Each rqst is transported as a SMBDirect payload
+ * rqst: the data to write
+ * return value: 0 if successfully write, otherwise error code
+ */
+int smbd_send(struct smbd_connection *info, struct smb_rqst *rqst)
+{
+	struct kvec vec;
+	int nvecs;
+	int size;
+	int buflen = 0, remaining_data_length;
+	int start, i, j;
+	int max_iov_size =
+		info->max_send_size - sizeof(struct smbd_data_transfer);
+	struct kvec iov[SMBDIRECT_MAX_SGE];
+	int rc;
+
+	info->smbd_send_pending++;
+	if (info->transport_status != SMBD_CONNECTED) {
+		rc = -ENODEV;
+		goto done;
+	}
+
+	/*
+	 * This usually means a configuration error
+	 * We use RDMA read/write for packet size > rdma_readwrite_threshold
+	 * as long as it's properly configured we should never get into this
+	 * situation
+	 */
+	if (rqst->rq_nvec + rqst->rq_npages > SMBDIRECT_MAX_SGE) {
+		log_write(ERR, "maximum send segment %x exceeding %x\n",
+			 rqst->rq_nvec + rqst->rq_npages, SMBDIRECT_MAX_SGE);
+		rc = -EINVAL;
+		goto done;
+	}
+
+	/*
+	 * Remove the RFC1002 length defined in MS-SMB2 section 2.1
+	 * It is used only for TCP transport
+	 * In future we may want to add a transport layer under protocol
+	 * layer so this will only be issued to TCP transport
+	 */
+	iov[0].iov_base = (char *)rqst->rq_iov[0].iov_base + 4;
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
+		log_write(ERR, "payload size %d > max size %d\n",
+			buflen, info->max_fragmented_send_size);
+		rc = -EINVAL;
+		goto done;
+	}
+
+	remaining_data_length = buflen;
+
+	log_write(INFO, "rqst->rq_nvec=%d rqst->rq_npages=%d rq_pagesz=%d "
+		"rq_tailsz=%d buflen=%d\n",
+		rqst->rq_nvec, rqst->rq_npages, rqst->rq_pagesz,
+		rqst->rq_tailsz, buflen);
+
+	start = i = iov[0].iov_len ? 0 : 1;
+	buflen = 0;
+	while (true) {
+		buflen += iov[i].iov_len;
+		if (buflen > max_iov_size) {
+			if (i > start) {
+				remaining_data_length -=
+					(buflen-iov[i].iov_len);
+				log_write(INFO, "sending iov[] from start=%d "
+					"i=%d nvecs=%d "
+					"remaining_data_length=%d\n",
+					start, i, i-start,
+					remaining_data_length);
+				rc = smbd_post_send_data(
+					info, &iov[start], i-start,
+					remaining_data_length);
+				if (rc)
+					goto done;
+			} else {
+				/* iov[start] is too big, break it */
+				nvecs = (buflen+max_iov_size-1)/max_iov_size;
+				log_write(INFO, "iov[%d] iov_base=%p buflen=%d"
+					" break to %d vectors\n",
+					start, iov[start].iov_base,
+					buflen, nvecs);
+				for (j = 0; j < nvecs; j++) {
+					vec.iov_base =
+						(char *)iov[start].iov_base +
+						j*max_iov_size;
+					vec.iov_len = max_iov_size;
+					if (j == nvecs-1)
+						vec.iov_len =
+							buflen -
+							max_iov_size*(nvecs-1);
+					remaining_data_length -= vec.iov_len;
+					log_write(INFO,
+						"sending vec j=%d iov_base=%p"
+						" iov_len=%zu "
+						"remaining_data_length=%d\n",
+						j, vec.iov_base, vec.iov_len,
+						remaining_data_length);
+					rc = smbd_post_send_data(
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
+				/* send out all remaining vecs */
+				remaining_data_length -= buflen;
+				log_write(INFO,
+					"sending iov[] from start=%d i=%d "
+					"nvecs=%d remaining_data_length=%d\n",
+					start, i, i-start,
+					remaining_data_length);
+				rc = smbd_post_send_data(info, &iov[start],
+					i-start, remaining_data_length);
+				if (rc)
+					goto done;
+				break;
+			}
+		}
+		log_write(INFO, "looping i=%d buflen=%d\n", i, buflen);
+	}
+
+	/* now sending pages if there are any */
+	for (i = 0; i < rqst->rq_npages; i++) {
+		buflen = (i == rqst->rq_npages-1) ?
+			rqst->rq_tailsz : rqst->rq_pagesz;
+		nvecs = (buflen + max_iov_size - 1) / max_iov_size;
+		log_write(INFO, "sending pages buflen=%d nvecs=%d\n",
+			buflen, nvecs);
+		for (j = 0; j < nvecs; j++) {
+			size = max_iov_size;
+			if (j == nvecs-1)
+				size = buflen - j*max_iov_size;
+			remaining_data_length -= size;
+			log_write(INFO, "sending pages i=%d offset=%d size=%d"
+				" remaining_data_length=%d\n",
+				i, j*max_iov_size, size, remaining_data_length);
+			rc = smbd_post_send_page(
+				info, rqst->rq_pages[i], j*max_iov_size,
+				size, remaining_data_length);
+			if (rc)
+				goto done;
+		}
+	}
+
+done:
+	/*
+	 * As an optimization, we don't wait for individual I/O to finish
+	 * before sending the next one.
+	 * Send them all and wait for pending send count to get to 0
+	 * that means all the I/Os have been out and we are good to return
+	 */
+
+	wait_event(info->wait_send_payload_pending,
+		atomic_read(&info->send_payload_pending) == 0);
+
+	info->smbd_send_pending--;
+	wake_up(&info->wait_smbd_send_pending);
+
+	return rc;
+}
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 65a431f..e777d77 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -92,6 +92,9 @@ struct smbd_connection {
 
 	/* Activity accoutning */
 	/* Pending reqeusts issued from upper layer */
+	int smbd_send_pending;
+	wait_queue_head_t wait_smbd_send_pending;
+
 	int smbd_recv_pending;
 	wait_queue_head_t wait_smbd_recv_pending;
 
-- 
2.7.4
