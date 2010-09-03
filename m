From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: eliminate some more premature cifsd exits
Date: Fri,  3 Sep 2010 08:25:10 -0400
Message-ID: <1283516711-15073-3-git-send-email-jlayton@redhat.com>
References: <1283516711-15073-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrew.hendry-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283516711-15073-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If the tcpStatus is still CifsNew, the main cifs_demultiplex_loop can
break out prematurely in some cases. This is wrong as we will almost
always have other structures with pointers to the TCP_Server_Info. If
the main loop breaks under any other condition other than tcpStatus ==
CifsExiting, then it'll face a use-after-free situation.

I don't see any reason to treat a CifsNew tcpStatus differently than
CifsGood. I believe we'll still want to attempt to reconnect in either
case. What should happen in those situations is that the MIDs get marked
as MID_RETRY_NEEDED. This will make CIFSSMBNegotiate return -EAGAIN, and
then the caller can retry the whole thing on a newly reconnected socket.
If that fails again in the same way, the caller of cifs_get_smb_ses
should tear down the TCP_Server_Info struct.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   41 ++++++++++++-----------------------------
 1 files changed, 12 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f06d8f9..a071358 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -416,14 +416,6 @@ incomplete_rcv:
 			} else
 				continue;
 		} else if (length <= 0) {
-			if (server->tcpStatus == CifsNew) {
-				cFYI(1, "tcp session abend after SMBnegprot");
-				/* some servers kill the TCP session rather than
-				   returning an SMB negprot error, in which
-				   case reconnecting here is not going to help,
-				   and so simply return error to mount */
-				break;
-			}
 			cFYI(1, "Reconnect after unexpected peek error %d",
 				length);
 			cifs_reconnect(server);
@@ -464,27 +456,18 @@ incomplete_rcv:
 			   an error on SMB negprot response */
 			cFYI(1, "Negative RFC1002 Session Response Error 0x%x)",
 				pdu_length);
-			if (server->tcpStatus == CifsNew) {
-				/* if nack on negprot (rather than
-				ret of smb negprot error) reconnecting
-				not going to help, ret error to mount */
-				break;
-			} else {
-				/* give server a second to
-				clean up before reconnect attempt */
-				msleep(1000);
-				/* always try 445 first on reconnect
-				since we get NACK on some if we ever
-				connected to port 139 (the NACK is
-				since we do not begin with RFC1001
-				session initialize frame) */
-				server->addr.sockAddr.sin_port =
-					htons(CIFS_PORT);
-				cifs_reconnect(server);
-				csocket = server->ssocket;
-				wake_up(&server->response_q);
-				continue;
-			}
+			/* give server a second to clean up  */
+			msleep(1000);
+			/* always try 445 first on reconnect since we get NACK
+			 * on some if we ever connected to port 139 (the NACK
+			 * is since we do not begin with RFC1001 session
+			 * initialize frame)
+			 */
+			server->addr.sockAddr.sin_port = htons(CIFS_PORT);
+			cifs_reconnect(server);
+			csocket = server->ssocket;
+			wake_up(&server->response_q);
+			continue;
 		} else if (temp != (char) 0) {
 			cERROR(1, "Unknown RFC 1002 frame");
 			cifs_dump_mem(" Received Data: ", (char *)smb_buffer,
-- 
1.7.1
