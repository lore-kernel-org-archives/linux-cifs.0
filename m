From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/12] cifs: initialize rsp_iov in smb2_lockv and fix a memory leak
Date: Wed, 11 Oct 2017 12:59:27 +1100
Message-ID: <20171011015927.7669-13-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9dc350fc283d..fd2b2b8e86b0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3498,7 +3498,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	int rc = 0;
 	struct smb2_lock_req *req = NULL;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int resp_buf_type;
 	unsigned int count;
 	int flags = CIFS_NO_RESP;
@@ -3531,6 +3531,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, flags,
 			  &rsp_iov);
 	cifs_small_buf_release(req);
+	free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
 	if (rc) {
 		cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
 		cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
-- 
2.13.3
