From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v3 13/19] CIFS: SMBD: Implement SMB write via RDMA read through memory registration
Date: Tue, 29 Aug 2017 12:29:09 -0700
Message-ID: <20170829192915.26251-14-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When sending I/O, if size is larger than rdma_readwrite_threshold we prepare
to send SMB write packet for a RDMA read via memory registration. The actual
I/O is done by remote peer through local RDMA hardware. Modify the relevant
fields in the packet accordingly, and append a smbd_buffer_descriptor_v1 to
the end of the SMB write packet.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
