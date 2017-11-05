From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v6 19/22] CIFS: SMBD: Upper layer performs SMB write via RDMA read through memory registration
Date: Sat,  4 Nov 2017 22:44:01 -0700
Message-ID: <20171105054404.23886-20-longli@exchange.microsoft.com>
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

When sending I/O, if size is larger than rdma_readwrite_threshold we
prepare to send SMB write packet for a RDMA read via memory registration.
The actual I/O is done by remote peer through local RDMA hardware. Modify
the relevant fields in the packet accordingly, and append a
smbd_buffer_descriptor_v1 to the end of the SMB write packet.

On write I/O finish, deregister the memory region if this was for a RDMA
read. If remote invalidation is not used, the call to smbd_deregister_mr
will do local invalidation and possibly wait. Memory region is normally
deregistered in MID callback as soon as it's used. There are situations
where the MID may not be created on I/O failure, under which memory region
is deregistered when write data context is released.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +++
 fs/cifs/cifssmb.c  |  9 ++++++++
 fs/cifs/smb2pdu.c  | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 09f9a71..2ae7d02 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1170,6 +1170,9 @@ struct cifs_writedata {
 	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbd_mr			*mr;
+#endif
 	unsigned int			pagesz;
 	unsigned int			tailsz;
 	unsigned int			credits;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5857009..08ff56a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -43,6 +43,9 @@
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 #ifdef CONFIG_CIFS_POSIX
 static struct {
@@ -1911,6 +1914,12 @@ cifs_writedata_release(struct kref *refcount)
 {
 	struct cifs_writedata *wdata = container_of(refcount,
 					struct cifs_writedata, refcount);
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (wdata->mr) {
+		smbd_deregister_mr(wdata->mr);
+		wdata->mr = NULL;
+	}
+#endif
 
 	if (wdata->cfile)
 		cifsFileInfo_put(wdata->cfile);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 32ad590..8ef4a2f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -48,6 +48,9 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
+#ifdef CONFIG_CIFS_SMB_DIRECT
+#include "smbdirect.h"
+#endif
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -2656,7 +2659,19 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		wdata->result = -EIO;
 		break;
 	}
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/*
+	 * If this wdata has a memory registered, the MR can be freed
+	 * The number of MRs available is limited, it's important to recover
+	 * used MR as soon as I/O is finished. Hold MR longer in the later
+	 * I/O process can possibly result in I/O deadlock due to lack of MR
+	 * to send request on I/O retry
+	 */
+	if (wdata->mr) {
+		smbd_deregister_mr(wdata->mr);
+		wdata->mr = NULL;
+	}
+#endif
 	if (wdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 
@@ -2707,7 +2722,42 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	req->DataOffset = cpu_to_le16(
 				offsetof(struct smb2_write_req, Buffer) - 4);
 	req->RemainingBytes = 0;
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/*
+	 * If we want to do a server RDMA read, fill in and append
+	 * smbd_buffer_descriptor_v1 to the end of write request
+	 */
+	if (server->rdma && wdata->bytes >=
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
+#endif
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = req;
@@ -2720,12 +2770,22 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_npages = wdata->nr_pages;
 	rqst.rq_pagesz = wdata->pagesz;
 	rqst.rq_tailsz = wdata->tailsz;
-
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	if (wdata->mr) {
+		iov[1].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
+		rqst.rq_npages = 0;
+	}
+#endif
 	cifs_dbg(FYI, "async write at %llu %u bytes\n",
 		 wdata->offset, wdata->bytes);
 
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	/* For RDMA read, I/O size is in RemainingBytes not in Length */
+	if (!wdata->mr)
+		req->Length = cpu_to_le32(wdata->bytes);
+#else
 	req->Length = cpu_to_le32(wdata->bytes);
-
+#endif
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
 	if (wdata->credits) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
