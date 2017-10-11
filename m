From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/12] cifs: initialize rsp_iov in SMB2_close
Date: Wed, 11 Oct 2017 12:59:18 +1100
Message-ID: <20171011015927.7669-4-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Or else we might call free_rsp_buf() on an uninitialized pointer if
SendReceive2() failed.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bf35755501e3..acadbdbfc8cb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2066,7 +2066,7 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_close_rsp *rsp;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
-- 
2.13.3
