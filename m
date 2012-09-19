From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix possible memory leaks in SMB2 code
Date: Wed, 19 Sep 2012 16:03:26 +0400
Message-ID: <1348056206-14288-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and add missed increments of failed async read and write requests.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2pdu.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1572abe..a7db95f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1218,13 +1218,13 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_len = get_rfc1002_length(req) + 4;
 
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);
+	rsp = (struct smb2_query_info_rsp *)iov[0].iov_base;
+
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
 		goto qinf_exit;
 	}
 
-	rsp = (struct smb2_query_info_rsp *)iov[0].iov_base;
-
 	rc = validate_and_copy_buf(le16_to_cpu(rsp->OutputBufferOffset),
 				   le32_to_cpu(rsp->OutputBufferLength),
 				   &rsp->hdr, min_len, data);
@@ -1485,8 +1485,10 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
 			     rdata, 0);
-	if (rc)
+	if (rc) {
 		kref_put(&rdata->refcount, cifs_readdata_release);
+		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
+	}
 
 	cifs_small_buf_release(buf);
 	return rc;
@@ -1643,8 +1645,10 @@ smb2_async_writev(struct cifs_writedata *wdata)
 	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
 				smb2_writev_callback, wdata, 0);
 
-	if (rc)
+	if (rc) {
 		kref_put(&wdata->refcount, cifs_writedata_release);
+		cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
+	}
 
 async_writev_out:
 	cifs_small_buf_release(req);
@@ -1700,15 +1704,15 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	rc = SendReceive2(xid, io_parms->tcon->ses, iov, n_vec + 1,
 			  &resp_buftype, 0);
+	rsp = (struct smb2_write_rsp *)iov[0].iov_base;
 
 	if (rc) {
 		cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
 		cERROR(1, "Send error in write = %d", rc);
-	} else {
-		rsp = (struct smb2_write_rsp *)iov[0].iov_base;
+	} else
 		*nbytes = le32_to_cpu(rsp->DataLength);
-		free_rsp_buf(resp_buftype, rsp);
-	}
+
+	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
 
@@ -1828,11 +1832,12 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	inc_rfc1001_len(req, len - 1 /* Buffer */);
 
 	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, 0);
+	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
+
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
 		goto qdir_exit;
 	}
-	rsp = (struct smb2_query_directory_rsp *)iov[0].iov_base;
 
 	rc = validate_buf(le16_to_cpu(rsp->OutputBufferOffset),
 			  le32_to_cpu(rsp->OutputBufferLength), &rsp->hdr,
-- 
1.7.5.4
