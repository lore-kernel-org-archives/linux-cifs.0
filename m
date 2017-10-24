From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: initialize rsp_iov and avoid a NULL deref in SMB2_read
Date: Tue, 24 Oct 2017 14:01:53 +1100
Message-ID: <20171024030153.541-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6ff4c275ca9a..efa06068e7e1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2669,27 +2669,27 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_small_buf_release(req);
 
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
-	shdr = get_sync_hdr(rsp);
 
-	if (shdr->Status == STATUS_END_OF_FILE) {
+	if (rc) {
+		if (rc != -ENODATA) {
+			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
+			cifs_dbg(VFS, "Send error in read = %d\n", rc);
+		}
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-		return 0;
+		return rc == -ENODATA ? 0 : rc;
 	}
 
-	if (rc) {
-		cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
-		cifs_dbg(VFS, "Send error in read = %d\n", rc);
-	} else {
-		*nbytes = le32_to_cpu(rsp->DataLength);
-		if ((*nbytes > CIFS_MAX_MSGSIZE) ||
-		    (*nbytes > io_parms->length)) {
-			cifs_dbg(FYI, "bad length %d for count %d\n",
-				 *nbytes, io_parms->length);
-			rc = -EIO;
-			*nbytes = 0;
-		}
+	*nbytes = le32_to_cpu(rsp->DataLength);
+	if ((*nbytes > CIFS_MAX_MSGSIZE) ||
+	    (*nbytes > io_parms->length)) {
+		cifs_dbg(FYI, "bad length %d for count %d\n",
+			 *nbytes, io_parms->length);
+		rc = -EIO;
+		*nbytes = 0;
 	}
 
+	shdr = get_sync_hdr(rsp);
+
 	if (*buf) {
 		memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-- 
2.13.3
