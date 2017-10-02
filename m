From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v4 18/22] CIFS: SMBD: Upper layer performs SMB write via RDMA read through memory registration
Date: Sun,  1 Oct 2017 19:30:26 -0700
Message-ID: <20171002023030.3582-19-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002023030.3582-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When sending I/O, if size is larger than rdma_readwrite_threshold we prepare
to send SMB write packet for a RDMA read via memory registration. The actual
I/O is done by remote peer through local RDMA hardware. Modify the relevant
fields in the packet accordingly, and append a smbd_buffer_descriptor_v1 to
the end of the SMB write packet.

On write I/O finish, deregister the memory region if this was for a RDMA read.
If remote invalidation is not used, the call to smbd_deregister_mr will do
local invalidation and possibly wait. Memory region is normally deregistered
in MID callback as soon as it's used. There are situations where the MID may
not be created on I/O failure, under which memory region is deregistered when
write data context is released.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/cifssmb.c  |  6 ++++++
 fs/cifs/smb2pdu.c  | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5585516..bcb6df1 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1168,6 +1168,7 @@ struct cifs_writedata {
 	pid_t				pid;
 	unsigned int			bytes;
 	int				result;
+	struct smbd_mr			*mr;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
 	unsigned int			credits;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5857009..0e29ecf 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -43,6 +43,7 @@
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
+#include "smbdirect.h"
 
 #ifdef CONFIG_CIFS_POSIX
 static struct {
@@ -1912,6 +1913,11 @@ cifs_writedata_release(struct kref *refcount)
 	struct cifs_writedata *wdata = container_of(refcount,
 					struct cifs_writedata, refcount);
 
+	if (wdata->mr) {
+		smbd_deregister_mr(wdata->mr);
+		wdata->mr = NULL;
+	}
+
 	if (wdata->cfile)
 		cifsFileInfo_put(wdata->cfile);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bab3da6..6089957 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -48,6 +48,7 @@
 #include "smb2glob.h"
 #include "cifspdu.h"
 #include "cifs_spnego.h"
+#include "smbdirect.h"
 
 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -2653,6 +2654,18 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		break;
 	}
 
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
+
 	if (wdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
 
@@ -2704,6 +2717,41 @@ smb2_async_writev(struct cifs_writedata *wdata,
 				offsetof(struct smb2_write_req, Buffer) - 4);
 	req->RemainingBytes = 0;
 
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
+
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	iov[0].iov_len = 4;
 	iov[0].iov_base = req;
@@ -2717,10 +2765,17 @@ smb2_async_writev(struct cifs_writedata *wdata,
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
