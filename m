From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 21/22] CIFS: SMBD: Upper layer performs SMB read via RDMA write through memory registration
Date: Sat,  4 Nov 2017 22:44:03 -0700
Message-ID: <20171105054404.23886-22-longli@exchange.microsoft.com>
References: <20171105054404.23886-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171105054404.23886-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

If I/O size is larger than rdma_readwrite_threshold, use RDMA write for
SMB read by specifying channel SMB2_CHANNEL_RDMA_V1 or
SMB2_CHANNEL_RDMA_V1_INVALIDATE in the SMB packet, depending on SMB dialect
used. Append a smbd_buffer_descriptor_v1 to the end of the SMB packet and
fill in other values to indicate this SMB read uses RDMA write.

There is no need to read from the transport for incoming payload. At the
time SMB read response comes back, the data is already transfered and
placed in the pages by RDMA hardware.

When SMB read is finished, deregister the memory regions if RDMA write is
used for this SMB read. smbd_deregister_mr may need to do local
invalidation and sleep, if server remote invalidation is not used.

There are situations where the MID may not be created on I/O failure, under
which memory region is deregistered when read data context is released.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c    | 19 +++++++++++++++++--
 fs/cifs/smb2pdu.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0786f19..94479ef 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -42,7 +42,9 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "fscache.h"
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 static inline int cifs_convert_flags(unsigned int flags)
 {
@@ -2908,7 +2910,12 @@ cifs_readdata_release(struct kref *refcount)
 {
 	struct cifs_readdata *rdata = container_of(refcount,
 					struct cifs_readdata, refcount);
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (rdata->mr) {
+		smbd_deregister_mr(rdata->mr);
+		rdata->mr = NULL;
+	}
+#endif
 	if (rdata->cfile)
 		cifsFileInfo_put(rdata->cfile);
 
@@ -3037,6 +3044,10 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 		}
 		if (iter)
 			result = copy_page_from_iter(page, 0, n, iter);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+		else if (rdata->mr)
+			result = n;
+#endif
 		else
 			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
@@ -3606,6 +3617,10 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 
 		if (iter)
 			result = copy_page_from_iter(page, 0, n, iter);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+		else if (rdata->mr)
+			result = n;
+#endif
 		else
 			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8ef4a2f..f07eb37 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2381,7 +2381,40 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	req->MinimumCount = 0;
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/*
+	 * If we want to do a RDMA write, fill in and append
+	 * smbd_buffer_descriptor_v1 to the end of read request
+	 */
+	if (server->rdma && rdata &&
+		rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
+
+		struct smbd_buffer_descriptor_v1 *v1;
+		bool need_invalidate =
+			io_parms->tcon->ses->server->dialect == SMB30_PROT_ID;
+
+		rdata->mr = smbd_register_mr(
+				server->smbd_conn, rdata->pages,
+				rdata->nr_pages, rdata->tailsz,
+				true, need_invalidate);
+		if (!rdata->mr)
+			return -ENOBUFS;
+
+		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
+		if (need_invalidate)
+			req->Channel = SMB2_CHANNEL_RDMA_V1;
+		req->ReadChannelInfoOffset =
+			offsetof(struct smb2_read_plain_req, Buffer);
+		req->ReadChannelInfoLength =
+			sizeof(struct smbd_buffer_descriptor_v1);
+		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+		v1->offset = rdata->mr->mr->iova;
+		v1->token = rdata->mr->mr->rkey;
+		v1->length = rdata->mr->mr->length;
 
+		*total_len += sizeof(*v1) - 1;
+	}
+#endif
 	if (request_type & CHAINED_REQUEST) {
 		if (!(request_type & END_OF_CHAIN)) {
 			/* next 8-byte aligned request */
@@ -2460,7 +2493,17 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		if (rdata->result != -ENODATA)
 			rdata->result = -EIO;
 	}
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/*
+	 * If this rdata has a memmory registered, the MR can be freed
+	 * MR needs to be freed as soon as I/O finishes to prevent deadlock
+	 * because they have limited number and are used for future I/Os
+	 */
+	if (rdata->mr) {
+		smbd_deregister_mr(rdata->mr);
+		rdata->mr = NULL;
+	}
+#endif
 	if (rdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
