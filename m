From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't return error from standard_receive3 after marking response malformed
Date: Mon,  6 Feb 2012 15:02:48 -0500
Message-ID: <1328558568-11655-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

standard_receive3 will check the validity of the response from the
server (via checkSMB). It'll pass the result of that check to handle_mid
which will dequeue it and mark it with a status of
MID_RESPONSE_MALFORMED if checkSMB returned an error. At that point,
standard_receive3 will also return an error, which will make the
demultiplex thread skip doing the callback for the mid.

This is wrong -- if we were able to identify the request and the
response is marked malformed, then we want the demultiplex thread to do
the callback. Fix this by making standard_receive3 return 0 in this
situation.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Reported-by: Mark Moseley <moseleymark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index aa687c8..4759543 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -773,10 +773,11 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
-	if (mid)
-		handle_mid(mid, server, smb_buffer, length);
+	if (!mid)
+		return length;
 
-	return length;
+	handle_mid(mid, server, smb_buffer, length);
+	return 0;
 }
 
 static int
-- 
1.7.7.6
