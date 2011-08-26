From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/16] cifs: trivial: remove obsolete comment
Date: Fri, 26 Aug 2011 15:06:16 -0400
Message-ID: <1314385589-27136-4-git-send-email-jlayton@redhat.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314385589-27136-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0ffba09..55efd1d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -694,12 +694,6 @@ incomplete_rcv:
 		 * The right amount was read from socket - 4 bytes,
 		 * so we can now interpret the length field.
 		 */
-
-		/*
-		 * Note that RFC 1001 length is big endian on the wire,
-		 * but we convert it here so it is always manipulated
-		 * as host byte order.
-		 */
 		pdu_length = be32_to_cpu(smb_buffer->smb_buf_length);
 
 		cFYI(1, "rfc1002 length 0x%x", pdu_length+4);
-- 
1.7.6
