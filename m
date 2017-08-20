From: Long Li <longli@exchange.microsoft.com>
Subject: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for SMB write
Date: Sun, 20 Aug 2017 12:04:37 -0700
Message-ID: <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
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

When sending I/O, if size is larger than rdma_readwrite_threshold we prepare to send SMB WRITE packet for a RDMA read via memory registration. The actual I/O is done out-of-the-band, so modify the relevant fields in the packet accordingly.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/smb2pdu.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5cc5f6c..5581afd 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -48,6 +48,7 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
+#include "smbdirect.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -2716,6 +2717,41 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				offsetof(struct smb2_write_req, Buffer) - 4);
 	req->RemainingBytes = 0;
 
+	/*
+	 * If we want to do a server RDMA read, fill in and append
+	 * smbd_buffer_descriptor_v1 to the end of write request
+	 */
+	if (server->rdma && wdata->bytes >
+		server->smbd_conn->rdma_readwrite_threshold) {
+
+		struct smbd_buffer_descriptor_v1 *v1;
+		bool need_invalidate = server->dialect == SMB30_PROT_ID;
+
+		wdata->mr = smbd_register_mr(
+				server->smbd_conn, wdata->pages,
+				wdata->nr_pages, wdata->tailsz,
+				false, need_invalidate);
+		if (!wdata->mr) {
+			rc = -ENOBUFS;
+			goto async_writev_out;
+		}
+		req->Length = 0;
+		req->DataOffset = 0;
+		req->RemainingBytes =
+			(wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz;
+		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
+		if (need_invalidate)
+			req->Channel = SMB2_CHANNEL_RDMA_V1;
+		req->WriteChannelInfoOffset =
+			offsetof(struct smb2_write_req, Buffer) - 4;
+		req->WriteChannelInfoLength =
+			sizeof(struct smbd_buffer_descriptor_v1);
+		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
+		v1->offset = wdata->mr->mr->iova;
+		v1->token = wdata->mr->mr->rkey;
+		v1->length = wdata->mr->mr->length;
+	}
+
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = req;
@@ -2729,10 +2765,17 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
 
+	if (wdata->mr) {
+		iov[1].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
+		rqst.rq_npages = 0;
+	}
+
 	cifs_dbg(FYI, "async write at %llu %u bytes\n",
 		 wdata->offset, wdata->bytes);
 
-	req->Length = cpu_to_le32(wdata->bytes);
+	/* For RDMA read, I/O size is in RemainingBytes not in Length */
+	if (!wdata->mr)
+		req->Length = cpu_to_le32(wdata->bytes);
 
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
-- 
2.7.4
