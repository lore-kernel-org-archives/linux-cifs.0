From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix possible freed pointer dereference in SMB2_sess_setup
Date: Tue, 25 Sep 2012 11:00:09 +0400
Message-ID: <1348556409-10339-3-git-send-email-piastry@etersoft.ru>
References: <1348556409-10339-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348556409-10339-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and remove redundant (rsp == NULL) checks after SendReceive2.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2pdu.c |   35 +++--------------------------------
 1 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a7db95f..5ad88b4b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -409,11 +409,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc != 0)
 		goto neg_exit;
 
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto neg_exit;
-	}
-
 	cFYI(1, "mode 0x%x", rsp->SecurityMode);
 
 	if (rsp->DialectRevision == smb2protocols[SMB21_PROT].name)
@@ -637,13 +632,14 @@ ssetup_ntlmssp_authenticate:
 
 	kfree(security_blob);
 	rsp = (struct smb2_sess_setup_rsp *)iov[0].iov_base;
-	if (rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
+	if (resp_buftype != CIFS_NO_BUFFER &&
+	    rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
 		if (phase != NtLmNegotiate) {
 			cERROR(1, "Unexpected more processing error");
 			goto ssetup_exit;
 		}
 		if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
-			le16_to_cpu(rsp->SecurityBufferOffset)) {
+				le16_to_cpu(rsp->SecurityBufferOffset)) {
 			cERROR(1, "Invalid security buffer offset %d",
 				  le16_to_cpu(rsp->SecurityBufferOffset));
 			rc = -EIO;
@@ -669,11 +665,6 @@ ssetup_ntlmssp_authenticate:
 	if (rc != 0)
 		goto ssetup_exit;
 
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto ssetup_exit;
-	}
-
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 ssetup_exit:
 	free_rsp_buf(resp_buftype, rsp);
@@ -793,11 +784,6 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		goto tcon_error_exit;
 	}
 
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto tcon_exit;
-	}
-
 	if (tcon == NULL) {
 		ses->ipc_tid = rsp->hdr.TreeId;
 		goto tcon_exit;
@@ -1046,10 +1032,6 @@ SMB2_open(const unsigned int xid, struct cifs_tcon *tcon, __le16 *path,
 		goto creat_exit;
 	}
 
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto creat_exit;
-	}
 	*persistent_fid = rsp->PersistentFileId;
 	*volatile_fid = rsp->VolatileFileId;
 
@@ -1111,11 +1093,6 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 		goto close_exit;
 	}
 
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto close_exit;
-	}
-
 	/* BB FIXME - decode close response, update inode for caching */
 
 close_exit:
@@ -1950,12 +1927,6 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_stats_fail_inc(tcon, SMB2_SET_INFO_HE);
 		goto out;
 	}
-
-	if (rsp == NULL) {
-		rc = -EIO;
-		goto out;
-	}
-
 out:
 	free_rsp_buf(resp_buftype, rsp);
 	kfree(iov);
-- 
1.7.5.4
