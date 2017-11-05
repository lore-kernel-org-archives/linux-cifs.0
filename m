From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 14/22] CIFS: SMBD: Implement function to receive data via RDMA receive
Date: Sat,  4 Nov 2017 22:43:56 -0700
Message-ID: <20171105054404.23886-15-longli@exchange.microsoft.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105054404.23886-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

On the receive path, the transport maintains receive buffers and a
reassembly queue for transferring payload via RDMA recv. There is data
copy in the transport on recv when it copies the payload to upper layer.

The transport recognizes the RFC1002 header length use in the SMB upper
layer payloads in CIFS. Because this length is mainly used for TCP and
not applicable to RDMA, it is handled as a out-of-band information and is
never sent over the wire, and the trasnport behaves like TCP to upper layer
by processing and exposing the length correctly on data payloads.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smbdirect.c | 228 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smbdirect.h |   3 +
 2 files changed, 231 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 5952276..1e7f5df 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -14,6 +14,7 @@
  *   the GNU General Public License for more details.
  */
 #include <linux/module.h>
+#include <linux/highmem.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
 
@@ -179,6 +180,8 @@ static void smbd_destroy_rdma_work(struct work_struct *work)
 
 	log_rdma_event(INFO, "wait for all recv to finish\n");
 	wake_up_interruptible(&info->wait_reassembly_queue);
+	wait_event(info->wait_smbd_recv_pending,
+		info->smbd_recv_pending == 0);
 
 	log_rdma_event(INFO, "wait for all send posted to IB to finish\n");
 	wait_event(info->wait_send_pending,
@@ -1655,6 +1658,9 @@ struct smbd_connection *_smbd_get_connection(
 	queue_delayed_work(info->workqueue, &info->idle_timer_work,
 		info->keep_alive_interval*HZ);
 
+	init_waitqueue_head(&info->wait_smbd_recv_pending);
+	info->smbd_recv_pending = 0;
+
 	init_waitqueue_head(&info->wait_send_pending);
 	atomic_set(&info->send_pending, 0);
 
@@ -1721,3 +1727,225 @@ struct smbd_connection *smbd_get_connection(
 	}
 	return ret;
 }
+
+/*
+ * Receive data from receive reassembly queue
+ * All the incoming data packets are placed in reassembly queue
+ * buf: the buffer to read data into
+ * size: the length of data to read
+ * return value: actual data read
+ * Note: this implementation copies the data from reassebmly queue to receive
+ * buffers used by upper layer. This is not the optimal code path. A better way
+ * to do it is to not have upper layer allocate its receive buffers but rather
+ * borrow the buffer from reassembly queue, and return it after data is
+ * consumed. But this will require more changes to upper layer code, and also
+ * need to consider packet boundaries while they still being reassembled.
+ */
+int smbd_recv_buf(struct smbd_connection *info, char *buf, unsigned int size)
+{
+	struct smbd_response *response;
+	struct smbd_data_transfer *data_transfer;
+	int to_copy, to_read, data_read, offset;
+	u32 data_length, remaining_data_length, data_offset;
+	int rc;
+	unsigned long flags;
+
+again:
+	if (info->transport_status != SMBD_CONNECTED) {
+		log_read(ERR, "disconnected\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * No need to hold the reassembly queue lock all the time as we are
+	 * the only one reading from the front of the queue. The transport
+	 * may add more entries to the back of the queeu at the same time
+	 */
+	log_read(INFO, "size=%d info->reassembly_data_length=%d\n", size,
+		info->reassembly_data_length);
+	if (info->reassembly_data_length >= size) {
+		int queue_length;
+		int queue_removed = 0;
+
+		/*
+		 * Need to make sure reassembly_data_length is read before
+		 * reading reassembly_queue_length and calling
+		 * _get_first_reassembly. This call is lock free
+		 * as we never read at the end of the queue which are being
+		 * updated in SOFTIRQ as more data is received
+		 */
+		virt_rmb();
+		queue_length = info->reassembly_queue_length;
+		data_read = 0;
+		to_read = size;
+		offset = info->first_entry_offset;
+		while (data_read < size) {
+			response = _get_first_reassembly(info);
+			data_transfer = smbd_response_payload(response);
+			data_length = le32_to_cpu(data_transfer->data_length);
+			remaining_data_length =
+				le32_to_cpu(
+					data_transfer->remaining_data_length);
+			data_offset = le32_to_cpu(data_transfer->data_offset);
+
+			/*
+			 * The upper layer expects RFC1002 length at the
+			 * beginning of the payload. Return it to indicate
+			 * the total length of the packet. This minimize the
+			 * change to upper layer packet processing logic. This
+			 * will be eventually remove when an intermediate
+			 * transport layer is added
+			 */
+			if (response->first_segment && size == 4) {
+				unsigned int rfc1002_len =
+					data_length + remaining_data_length;
+				*((__be32 *)buf) = cpu_to_be32(rfc1002_len);
+				data_read = 4;
+				response->first_segment = false;
+				log_read(INFO, "returning rfc1002 length %d\n",
+					rfc1002_len);
+				goto read_rfc1002_done;
+			}
+
+			to_copy = min_t(int, data_length - offset, to_read);
+			memcpy(
+				buf + data_read,
+				(char *)data_transfer + data_offset + offset,
+				to_copy);
+
+			/* move on to the next buffer? */
+			if (to_copy == data_length - offset) {
+				queue_length--;
+				/*
+				 * No need to lock if we are not at the
+				 * end of the queue
+				 */
+				if (!queue_length)
+					spin_lock_irqsave(
+						&info->reassembly_queue_lock,
+						flags);
+				list_del(&response->list);
+				queue_removed++;
+				if (!queue_length)
+					spin_unlock_irqrestore(
+						&info->reassembly_queue_lock,
+						flags);
+
+				info->count_reassembly_queue--;
+				info->count_dequeue_reassembly_queue++;
+				put_receive_buffer(info, response, true);
+				offset = 0;
+				log_read(INFO, "put_receive_buffer offset=0\n");
+			} else
+				offset += to_copy;
+
+			to_read -= to_copy;
+			data_read += to_copy;
+
+			log_read(INFO, "_get_first_reassembly memcpy %d bytes "
+				"data_transfer_length-offset=%d after that "
+				"to_read=%d data_read=%d offset=%d\n",
+				to_copy, data_length - offset,
+				to_read, data_read, offset);
+		}
+
+		spin_lock_irqsave(&info->reassembly_queue_lock, flags);
+		info->reassembly_data_length -= data_read;
+		info->reassembly_queue_length -= queue_removed;
+		spin_unlock_irqrestore(&info->reassembly_queue_lock, flags);
+
+		info->first_entry_offset = offset;
+		log_read(INFO, "returning to thread data_read=%d "
+			"reassembly_data_length=%d first_entry_offset=%d\n",
+			data_read, info->reassembly_data_length,
+			info->first_entry_offset);
+read_rfc1002_done:
+		return data_read;
+	}
+
+	log_read(INFO, "wait_event on more data\n");
+	rc = wait_event_interruptible(
+		info->wait_reassembly_queue,
+		info->reassembly_data_length >= size ||
+			info->transport_status != SMBD_CONNECTED);
+	/* Don't return any data if interrupted */
+	if (rc)
+		return -ENODEV;
+
+	goto again;
+}
+
+/*
+ * Receive a page from receive reassembly queue
+ * page: the page to read data into
+ * to_read: the length of data to read
+ * return value: actual data read
+ */
+int smbd_recv_page(struct smbd_connection *info,
+		struct page *page, unsigned int to_read)
+{
+	int ret;
+	char *to_address;
+
+	/* make sure we have the page ready for read */
+	ret = wait_event_interruptible(
+		info->wait_reassembly_queue,
+		info->reassembly_data_length >= to_read ||
+			info->transport_status != SMBD_CONNECTED);
+	if (ret)
+		return 0;
+
+	/* now we can read from reassembly queue and not sleep */
+	to_address = kmap_atomic(page);
+
+	log_read(INFO, "reading from page=%p address=%p to_read=%d\n",
+		page, to_address, to_read);
+
+	ret = smbd_recv_buf(info, to_address, to_read);
+	kunmap_atomic(to_address);
+
+	return ret;
+}
+
+/*
+ * Receive data from transport
+ * msg: a msghdr point to the buffer, can be ITER_KVEC or ITER_BVEC
+ * return: total bytes read, or 0. SMB Direct will not do partial read.
+ */
+int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
+{
+	char *buf;
+	struct page *page;
+	unsigned int to_read;
+	int rc;
+
+	info->smbd_recv_pending++;
+
+	switch (msg->msg_iter.type) {
+	case READ | ITER_KVEC:
+		buf = msg->msg_iter.kvec->iov_base;
+		to_read = msg->msg_iter.kvec->iov_len;
+		rc = smbd_recv_buf(info, buf, to_read);
+		break;
+
+	case READ | ITER_BVEC:
+		page = msg->msg_iter.bvec->bv_page;
+		to_read = msg->msg_iter.bvec->bv_len;
+		rc = smbd_recv_page(info, page, to_read);
+		break;
+
+	default:
+		/* It's a bug in upper layer to get there */
+		cifs_dbg(VFS, "CIFS: invalid msg type %d\n",
+			msg->msg_iter.type);
+		rc = -EIO;
+	}
+
+	info->smbd_recv_pending--;
+	wake_up(&info->wait_smbd_recv_pending);
+
+	/* SMBDirect will read it all or nothing */
+	if (rc > 0)
+		msg->msg_iter.count = 0;
+	return rc;
+}
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index 1707bbc..c1e2d3d 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -88,6 +88,9 @@ struct smbd_connection {
 	int fragment_reassembly_remaining;
 
 	/* Activity accoutning */
+	/* Pending reqeusts issued from upper layer */
+	int smbd_recv_pending;
+	wait_queue_head_t wait_smbd_recv_pending;
 
 	atomic_t send_pending;
 	wait_queue_head_t wait_send_pending;
-- 
2.7.4
