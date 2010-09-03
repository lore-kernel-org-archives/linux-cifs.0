From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cifs: prevent cifsd from exiting prematurely
Date: Fri,  3 Sep 2010 08:25:09 -0400
Message-ID: <1283516711-15073-2-git-send-email-jlayton@redhat.com>
References: <1283516711-15073-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283516711-15073-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When cifs_demultiplex_thread exits, it does a number of cleanup tasks
including freeing the TCP_Server_Info struct. Much of the existing code
in cifs assumes that when there is a cisfSesInfo struct, that it holds a
reference to a valid TCP_Server_Info struct.

We can never allow cifsd to exit when a cifsSesInfo struct is still
holding a reference to the server. The server pointers will then point
to freed memory.

This patch eliminates a couple of questionable conditions where it does
this.  The idea here is to make an -EINTR return from kernel_recvmsg
behave the same way as -ERESTARTSYS or -EAGAIN. If the task was
signalled from cifs_put_tcp_session, then tcpStatus will be CifsExiting,
and the kernel_recvmsg call will return quickly.

There's also another condition where this can occur too -- if the
tcpStatus is still in CifsNew, then it will also exit if the server
closes the socket prematurely.  I think we'll probably also need to fix
that situation, but that requires a bit more consideration.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ec0ea4a..f06d8f9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -400,7 +400,9 @@ incomplete_rcv:
 			cFYI(1, "call to reconnect done");
 			csocket = server->ssocket;
 			continue;
-		} else if ((length == -ERESTARTSYS) || (length == -EAGAIN)) {
+		} else if (length == -ERESTARTSYS ||
+			   length == -EAGAIN ||
+			   length == -EINTR) {
 			msleep(1); /* minimum sleep to prevent looping
 				allowing socket to clear and app threads to set
 				tcpStatus CifsNeedReconnect if server hung */
@@ -422,10 +424,6 @@ incomplete_rcv:
 				   and so simply return error to mount */
 				break;
 			}
-			if (!try_to_freeze() && (length == -EINTR)) {
-				cFYI(1, "cifsd thread killed");
-				break;
-			}
 			cFYI(1, "Reconnect after unexpected peek error %d",
 				length);
 			cifs_reconnect(server);
@@ -522,8 +520,7 @@ incomplete_rcv:
 		     total_read += length) {
 			length = kernel_recvmsg(csocket, &smb_msg, &iov, 1,
 						pdu_length - total_read, 0);
-			if ((server->tcpStatus == CifsExiting) ||
-			    (length == -EINTR)) {
+			if (server->tcpStatus == CifsExiting) {
 				/* then will exit */
 				reconnect = 2;
 				break;
@@ -534,8 +531,9 @@ incomplete_rcv:
 				/* Now we will reread sock */
 				reconnect = 1;
 				break;
-			} else if ((length == -ERESTARTSYS) ||
-				   (length == -EAGAIN)) {
+			} else if (length == -ERESTARTSYS ||
+				   length == -EAGAIN ||
+				   length == -EINTR) {
 				msleep(1); /* minimum sleep to prevent looping,
 					      allowing socket to clear and app
 					      threads to set tcpStatus
-- 
1.7.1
