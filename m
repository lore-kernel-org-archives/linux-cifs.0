From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/12] cifs: initialize rsp_iov in SMB2_read and add check for NULL
Date: Wed, 11 Oct 2017 12:59:21 +1100
Message-ID: <20171011015927.7669-7-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ca861ee4ac0a..96a6ed9c86d4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2641,10 +2641,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 {
 	int resp_buftype, rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
-	struct smb2_read_rsp *rsp = NULL;
+	struct smb2_read_rsp *rsp;
 	struct smb2_sync_hdr *shdr;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	unsigned int total_len;
 	__be32 req_len;
 	struct smb_rqst rqst = { .rq_iov = iov,
@@ -2671,6 +2671,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	cifs_small_buf_release(req);
 
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
+	if (rsp == NULL) {
+		cifs_dbg(VFS, "rsp is NULL in read\n");
+		return -EIO;
+	}
 	shdr = get_sync_hdr(rsp);
 
 	if (shdr->Status == STATUS_END_OF_FILE) {
-- 
2.13.3
