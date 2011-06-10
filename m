From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't allow cifs_reconnect to exit with NULL socket pointer
Date: Fri, 10 Jun 2011 16:14:57 -0400
Message-ID: <1307736897-9831-1-git-send-email-jlayton@redhat.com>
Cc: greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's possible for the following set of events to happen:

cifsd calls cifs_reconnect which reconnects the socket. A userspace
process then calls cifs_negotiate_protocol to handle the NEGOTIATE and
gets a reply. But, while processing the reply, cifsd calls
cifs_reconnect again.  Eventually the GlobalMid_Lock is dropped and the
reply from the earlier NEGOTIATE completes and the tcpStatus is set to
CifsGood. cifs_reconnect then goes through and closes the socket and sets the
pointer to zero, but because the status is now CifsGood, the new socket
is not created and cifs_reconnect exits with the socket pointer set to
NULL.

Fix this by only setting the tcpStatus to CifsGood if the tcpStatus is
CifsNeedNegotiate, and by making sure that generic_ip_connect is always
called at least once in cifs_reconnect.

Note that this is not a perfect fix for this issue. It's still possible
that the NEGOTIATE reply is handled after the socket has been closed and
reconnected. In that case, the socket state will look correct but it no
NEGOTIATE was performed on it be for the wrong socket. In that situation
though the server should just shut down the socket on the next attempted
send, rather than causing the oops that occurs today.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # .38.x: fd88ce9: [CIFS] cifs: clarify the meaning of tcpStatus == CifsGood
Reported-and-Tested-by: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bb659eb..61ed0ba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -152,7 +152,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		mid_entry->callback(mid_entry);
 	}
 
-	while (server->tcpStatus == CifsNeedReconnect) {
+	do {
 		try_to_freeze();
 
 		/* we should try only the port we connected to before */
@@ -167,7 +167,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 				server->tcpStatus = CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
 		}
-	}
+	} while (server->tcpStatus == CifsNeedReconnect);
 
 	return rc;
 }
@@ -3371,7 +3371,7 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	}
 	if (rc == 0) {
 		spin_lock(&GlobalMid_Lock);
-		if (server->tcpStatus != CifsExiting)
+		if (server->tcpStatus == CifsNeedNegotiate)
 			server->tcpStatus = CifsGood;
 		else
 			rc = -EHOSTDOWN;
-- 
1.7.5.2
