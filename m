From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/12] cifs: initialize rsp_iov in SMB2_negotiate
Date: Wed, 11 Oct 2017 12:59:16 +1100
Message-ID: <20171011015927.7669-2-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Initialize rsp_iov so that when rsp is assigned we know it is either NULL
or a valid pointer.

Otherwise, if SendReceive2() returns an error without setting rsp_iov
we could end up calling free_rsp_buf() on an uninitialized pointer.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6ff4c275ca9a..08701b6125b9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -470,7 +470,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	struct smb2_negotiate_req *req;
 	struct smb2_negotiate_rsp *rsp;
 	struct kvec iov[1];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int rc = 0;
 	int resp_buftype;
 	struct TCP_Server_Info *server = ses->server;
-- 
2.13.3
