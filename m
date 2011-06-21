From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: advertise the right receive buffer size to the server (try #2)
Date: Tue, 21 Jun 2011 12:42:53 -0400
Message-ID: <1308674573-19784-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we mirror the same size back to the server that it sends us.
That makes little sense. Instead we should be sending the server the
maximum buffer size that we can handle -- CIFSMaxBufSize minus the
4 byte RFC1001 header.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3892ab8..7ee3d75 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -124,7 +124,8 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
 	/*	that we use in next few lines                               */
 	/* Note that header is initialized to zero in header_assemble */
 	pSMB->req.AndXCommand = 0xFF;
-	pSMB->req.MaxBufferSize = cpu_to_le16(ses->server->maxBuf);
+	pSMB->req.MaxBufferSize = cpu_to_le16(min_t(u32, CIFSMaxBufSize - 4,
+						USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(ses->server->maxReq);
 	pSMB->req.VcNumber = get_next_vcnum(ses);
 
-- 
1.7.5.4
