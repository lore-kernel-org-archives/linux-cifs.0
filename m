From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 10/12] cifs: initialize rsp_iov in SMB2_QFS_info
Date: Wed, 11 Oct 2017 12:59:25 +1100
Message-ID: <20171011015927.7669-11-lsahlber@redhat.com>
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
index 93ecaa050c57..f3cc9dbd6fd4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3382,9 +3382,9 @@ int
 SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
 {
-	struct smb2_query_info_rsp *rsp = NULL;
+	struct smb2_query_info_rsp *rsp;
 	struct kvec iov;
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = { NULL, 0 };
 	int rc = 0;
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
-- 
2.13.3
