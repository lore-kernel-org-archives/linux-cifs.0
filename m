From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 17/19] CIFS: SMBD: Implement SMB READ via RDMA write through memory registration
Date: Sun, 20 Aug 2017 12:04:41 -0700
Message-ID: <1503255883-3041-18-git-send-email-longli@exchange.microsoft.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

If I/O size is larger than rdma_readwrite_threshold, use RDMA write for SMB READ by specifying channel SMB2_CHANNEL_RDMA_V1 or SMB2_CHANNEL_RDMA_V1_INVALIDATE, depending on SMB dialect used. When RDMA write is used, there is no need to read from the transport for incoming payload. At the time SMB READ response comes back, the data is already transfered and placed in the pages by RDMA.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/file.c    |  5 +++++
 fs/cifs/smb2pdu.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dec70b3..41460a5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -42,6 +42,7 @@
 #include "cifs_debug.h"
 #include "cifs_fs_sb.h"
 #include "fscache.h"
+#include "smbdirect.h"
 
 
 static inline int cifs_convert_flags(unsigned int flags)
@@ -3037,6 +3038,8 @@ uncached_fill_pages(struct TCP_Server_Info *server,
 		}
 		if (iter)
 			result = copy_page_from_iter(page, 0, n, iter);
+		else if (rdata->mr)
+			result = n;
 		else
 			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
@@ -3606,6 +3609,8 @@ readpages_fill_pages(struct TCP_Server_Info *server,
 
 		if (iter)
 			result = copy_page_from_iter(page, 0, n, iter);
+		else if (rdata->mr)
+			result = n;
 		else
 			result = cifs_read_page_from_socket(server, page, n);
 		if (result < 0)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fbad987..1f08c75 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2392,6 +2392,39 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
 
+	/*
+	 * If we want to do a RDMA write, fill in and append
+	 * smbd_buffer_descriptor_v1 to the end of read request
+	 */
+	if (server->rdma && rdata &&
+		rdata->bytes > server->smbd_conn->rdma_readwrite_threshold) {
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
+
+		*total_len += sizeof(*v1) - 1;
+	}
+
 	if (request_type & CHAINED_REQUEST) {
 		if (!(request_type & END_OF_CHAIN)) {
 			/* next 8-byte aligned request */
-- 
2.7.4
