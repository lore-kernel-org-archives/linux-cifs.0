From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: initialize rsp_iov and check for NULL in SMB2_read
Date: Thu, 12 Oct 2017 10:38:40 +1100
Message-ID: <20171011233840.10365-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6ff4c275ca9a..e6b62771a48e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2639,10 +2639,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 {
 	int resp_buftype, rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
-	struct smb2_read_rsp *rsp = NULL;
+	struct smb2_read_rsp *rsp;
 	struct smb2_sync_hdr *shdr;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov =  {NULL, 0};
 	unsigned int total_len;
 	__be32 req_len;
 	struct smb_rqst rqst = { .rq_iov = iov,
@@ -2669,11 +2669,9 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_small_buf_release(req);
 
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
-	shdr = get_sync_hdr(rsp);
-
-	if (shdr->Status == STATUS_END_OF_FILE) {
-		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-		return 0;
+	if (rsp == NULL) {
+		cifs_dbg(VFS, "rsp is NULL in read\n");
+		return -EIO;
 	}
 
 	if (rc) {
@@ -2690,6 +2688,13 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 		}
 	}
 
+	shdr = get_sync_hdr(rsp);
+
+	if (shdr->Status == STATUS_END_OF_FILE) {
+		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
+		return 0;
+	}
+
 	if (*buf) {
 		memcpy(*buf, (char *)shdr + rsp->DataOffset, *nbytes);
 		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
-- 
2.13.3
