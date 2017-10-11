From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/12] cifs: initialize rsp_iov in SMB2_ioctl and check for NULL before deref
Date: Wed, 11 Oct 2017 12:59:17 +1100
Message-ID: <20171011015927.7669-3-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 08701b6125b9..bf35755501e3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1884,7 +1884,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	struct smb2_sync_hdr *shdr;
 	struct cifs_ses *ses;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int resp_buftype;
 	int n_iov;
 	int rc = 0;
@@ -1981,6 +1981,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
+	if (rsp == NULL)
+		goto ioctl_exit;
 
 	if ((rc != 0) && (rc != -EINVAL)) {
 		cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
-- 
2.13.3
