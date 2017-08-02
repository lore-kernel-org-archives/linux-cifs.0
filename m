From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [[PATCH v1] 21/37] [CIFS] SMBD: Implement API for upper layer to receive data
Date: Wed,  2 Aug 2017 13:10:32 -0700
Message-ID: <1501704648-20159-22-git-send-email-longli@exchange.microsoft.com>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

With reassembly queue in place, implement the API for upper layer to recevie data. This call may sleep if there is not enough data in the reassembly queue.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsrdma.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsrdma.h |   5 +++
 2 files changed, 115 insertions(+)

diff --git a/fs/cifs/cifsrdma.c b/fs/cifs/cifsrdma.c
index 1d3fd26..e5f6300 100644
--- a/fs/cifs/cifsrdma.c
+++ b/fs/cifs/cifsrdma.c
@@ -1316,6 +1316,116 @@ struct cifs_rdma_info* cifs_create_rdma_session(
 }
 
 /*
+ * Read data from receive reassembly queue
+ * All the incoming data packets are placed in reassembly queue
+ * buf: the buffer to read data into
+ * size: the length of data to read
+ * return value: actual data read
+ */
+int cifs_rdma_read(struct cifs_rdma_info *info, char *buf, unsigned int size)
+{
+	struct cifs_rdma_response *response;
+	struct smbd_data_transfer *data_transfer;
+	unsigned long flags;
+	int to_copy, to_read, data_read, offset;
+	u32 data_length, remaining_data_length, data_offset;
+
+again:
+	// the transport is disconnected?
+	if (info->transport_status != CIFS_RDMA_CONNECTED) {
+		log_cifs_read("disconnected\n");
+
+		/*
+		 * If upper layer code is reading SMB packet length
+		 * return 0 to indicate transport is disconnected and
+		 * trigger a reconnect.
+		 */
+		spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+		response = _get_first_reassembly(info);
+		if (response && response->first_segment && size==4) {
+			memset(buf, 0, size);
+			spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+			return size;
+		}
+		spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+		return 0;
+	}
+
+	spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+	log_cifs_read("size=%d info->reassembly_data_length=%d\n", size,
+		atomic_read(&info->reassembly_data_length));
+	if (atomic_read(&info->reassembly_data_length) >= size) {
+		data_read = 0;
+		to_read = size;
+		offset = info->first_entry_offset;
+		while(data_read < size) {
+			response = _get_first_reassembly(info);
+			data_transfer = (struct smbd_data_transfer *) response->packet;
+
+			data_length = le32_to_cpu(data_transfer->data_length);
+			remaining_data_length =
+				le32_to_cpu(data_transfer->remaining_data_length);
+			data_offset = le32_to_cpu(data_transfer->data_offset);
+
+			// this is for reading rfc1002 length
+			if (response->first_segment && size==4) {
+				unsigned int rfc1002_len =
+					data_length + remaining_data_length;
+				*((__be32*)buf) = cpu_to_be32(rfc1002_len);
+				data_read = 4;
+				response->first_segment = false;
+				log_cifs_read("returning rfc1002 length %d\n",
+					rfc1002_len);
+				goto read_rfc1002_done;
+			}
+
+			to_copy = min_t(int, data_length - offset, to_read);
+			memcpy(
+				buf + data_read,
+				(char*)data_transfer + data_offset + offset,
+				to_copy);
+
+			// move on to the next buffer?
+			if (to_copy == data_length - offset) {
+				list_del(&response->list);
+				info->count_reassembly_queue--;
+				info->count_dequeue_reassembly_queue++;
+				put_receive_buffer(info, response);
+				offset = 0;
+				log_cifs_read("put_receive_buffer offset=0\n");
+			} else
+				offset += to_copy;
+
+			to_read -= to_copy;
+			data_read += to_copy;
+
+			log_cifs_read("_get_first_reassembly memcpy %d bytes "
+				"data_transfer_length-offset=%d after that "
+				"to_read=%d data_read=%d offset=%d\n",
+				to_copy, data_length - offset,
+				to_read, data_read, offset);
+		}
+		atomic_sub(data_read, &info->reassembly_data_length);
+		info->first_entry_offset = offset;
+		log_cifs_read("returning to thread data_read=%d "
+			"reassembly_data_length=%d first_entry_offset=%d\n",
+			data_read, atomic_read(&info->reassembly_data_length),
+			info->first_entry_offset);
+read_rfc1002_done:
+		spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+		return data_read;
+	}
+
+	spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+	log_cifs_read("wait_event on more data\n");
+	wait_event(
+		info->wait_reassembly_queue,
+		atomic_read(&info->reassembly_data_length) >= size ||
+			info->transport_status != CIFS_RDMA_CONNECTED);
+	goto again;
+}
+
+/*
  * Write data to transport
  * Each rqst is transported as a SMBDirect payload
  * rqst: the data to write
diff --git a/fs/cifs/cifsrdma.h b/fs/cifs/cifsrdma.h
index b26e3b7..8891e21 100644
--- a/fs/cifs/cifsrdma.h
+++ b/fs/cifs/cifsrdma.h
@@ -89,6 +89,8 @@ struct cifs_rdma_info {
 
 	// total data length of reassembly queue
 	atomic_t reassembly_data_length;
+	// the offset to first buffer in reassembly queue
+	int first_entry_offset;
 
 	wait_queue_head_t wait_send_queue;
 
@@ -210,5 +212,8 @@ struct cifs_rdma_response {
 struct cifs_rdma_info* cifs_create_rdma_session(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
 
+// SMBDirect interface for carrying upper layer CIFS I/O
+int cifs_rdma_read(
+	struct cifs_rdma_info *rdma, char *buf, unsigned int to_read);
 int cifs_rdma_write(struct cifs_rdma_info *rdma, struct smb_rqst *rqst);
 #endif
-- 
2.7.4
