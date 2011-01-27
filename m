From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: fix length vs. total_read confusion in cifs_demultiplex_thread
Date: Thu, 27 Jan 2011 07:47:55 -0500
Message-ID: <1296132476-21948-1-git-send-email-jlayton@redhat.com>
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
---
 fs/cifs/connect.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 47034af..12a3e04 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -581,11 +581,10 @@ incomplete_rcv:
 		else if (reconnect == 1)
 			continue;
 
-		length += 4; /* account for rfc1002 hdr */
+		total_read += 4; /* account for rfc1002 hdr */
 
-
-		dump_smb(smb_buffer, length);
-		if (checkSMB(smb_buffer, smb_buffer->Mid, total_read+4)) {
+		dump_smb(smb_buffer, total_read);
+		if (checkSMB(smb_buffer, smb_buffer->Mid, total_read)) {
 			cifs_dump_mem("Bad SMB: ", smb_buffer, 48);
 			continue;
 		}
-- 
1.7.3.4
