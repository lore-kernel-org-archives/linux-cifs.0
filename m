From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] cifs: fix comment in validate_t2
Date: Thu, 31 Mar 2011 17:36:43 -0400
Message-ID: <1301607405-4379-4-git-send-email-jlayton@redhat.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607405-4379-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The comment about checking the bcc is in the wrong place. Also make it
match kernel coding style.

Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 4f5c6d0..655f24c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -339,12 +339,13 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 	    get_unaligned_le16(&pSMB->t2_rsp.DataOffset) > 1024)
 		goto vt2_err;
 
-	/* check that bcc is at least as big as parms + data */
-	/* check that bcc is less than negotiated smb buffer */
 	total_size = get_unaligned_le16(&pSMB->t2_rsp.ParameterCount);
 	if (total_size >= 512)
 		goto vt2_err;
 
+	/* check that bcc is at least as big as parms + data, and that it is
+	 * less than negotiated smb buffer
+	 */
 	total_size += get_unaligned_le16(&pSMB->t2_rsp.DataCount);
 	if (total_size > get_bcc(&pSMB->hdr) ||
 	    total_size >= CIFSMaxBufSize + MAX_CIFS_HDR_SIZE)
-- 
1.7.4
