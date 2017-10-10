From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] CIFS: Fix NULL pointer deref on TCON failures
Date: Wed, 11 Oct 2017 10:01:38 +1100
Message-ID: <20171010230138.31832-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6f0e6343c15e..6ff4c275ca9a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1255,7 +1255,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	struct smb2_tree_connect_req *req;
 	struct smb2_tree_connect_rsp *rsp = NULL;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int rc = 0;
 	int resp_buftype;
 	int unc_path_len;
@@ -1315,6 +1315,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
+	if (rsp == NULL)
+		goto tcon_exit;
 
 	if (rc != 0) {
 		if (tcon) {
-- 
2.13.3
