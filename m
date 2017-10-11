From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/12] cifs: initialize rsp_iov in SMB2_write
Date: Wed, 11 Oct 2017 12:59:22 +1100
Message-ID: <20171011015927.7669-8-lsahlber@redhat.com>
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
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 96a6ed9c86d4..21ffeb5f5e4b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2862,9 +2862,9 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 {
 	int rc = 0;
 	struct smb2_write_req *req = NULL;
-	struct smb2_write_rsp *rsp = NULL;
+	struct smb2_write_rsp *rsp;
 	int resp_buftype;
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int flags = 0;
 
 	*nbytes = 0;
-- 
2.13.3
