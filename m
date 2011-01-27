From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: fix length vs. total_read confusion in cifs_demultiplex_thread (try #2)
Date: Thu, 27 Jan 2011 11:41:50 -0500
Message-ID: <1296146511-25942-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

length at this point is the length returned by the last kernel_recvmsg
call. total_read is the length of all of the data read so far. length
is more or less meaningless at this point, so use total_read for
everything.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 47034af..41a0ba0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -581,12 +581,12 @@ incomplete_rcv:
 		else if (reconnect == 1)
 			continue;
 
-		length += 4; /* account for rfc1002 hdr */
+		total_read += 4; /* account for rfc1002 hdr */
 
-
-		dump_smb(smb_buffer, length);
-		if (checkSMB(smb_buffer, smb_buffer->Mid, total_read+4)) {
-			cifs_dump_mem("Bad SMB: ", smb_buffer, 48);
+		dump_smb(smb_buffer, total_read);
+		if (checkSMB(smb_buffer, smb_buffer->Mid, total_read)) {
+			cifs_dump_mem("Bad SMB: ", smb_buffer,
+					total_read < 48 ? total_read : 48);
 			continue;
 		}
 
-- 
1.7.3.4
