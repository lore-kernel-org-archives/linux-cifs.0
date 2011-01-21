From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix up CIFSSMBEcho for unaligned access
Date: Thu, 20 Jan 2011 21:19:25 -0500
Message-ID: <1295576365-11810-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make sure that CIFSSMBEcho can handle unaligned fields. Also fix a minor
bug that causes this warning:

fs/cifs/cifssmb.c: In function 'CIFSSMBEcho':
fs/cifs/cifssmb.c:740: warning: large integer implicitly truncated to unsigned type

...WordCount is u8, not __le16, so no need to convert it.

This patch should apply cleanly on top of the rest of the patchset to
clean up unaligned access.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1e43e61..32378f2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -733,9 +733,9 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 
 	/* set up echo request */
 	smb->hdr.Tid = cpu_to_le16(0xffff);
-	smb->hdr.WordCount = cpu_to_le16(1);
-	smb->EchoCount = cpu_to_le16(1);
-	smb->ByteCount = cpu_to_le16(1);
+	smb->hdr.WordCount = 1;
+	put_unaligned_le16(1, &smb->EchoCount);
+	put_bcc_le(1, &smb->hdr);
 	smb->Data[0] = 'a';
 	smb->hdr.smb_buf_length += 3;
 
-- 
1.7.3.4
