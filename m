From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/12] cifs: initialize rsp_iov in SMB2_query_directory
Date: Wed, 11 Oct 2017 12:59:23 +1100
Message-ID: <20171011015927.7669-9-lsahlber@redhat.com>
References: <20171011015927.7669-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011015927.7669-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Or else we might call free_rsp_buf() on an uninitialized pointer if
SendReceive2() failed

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 21ffeb5f5e4b..b7f59f536fd7 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2969,7 +2969,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_req *req;
 	struct smb2_query_directory_rsp *rsp = NULL;
 	struct kvec iov[2];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int rc = 0;
 	int len;
 	int resp_buftype = CIFS_NO_BUFFER;
-- 
2.13.3
