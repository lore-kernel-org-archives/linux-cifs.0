From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: clarify the meaning of tcpStatus == CifsGood
Date: Mon,  7 Feb 2011 08:54:36 -0500
Message-ID: <1297086876-19165-3-git-send-email-jlayton@redhat.com>
References: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297086876-19165-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the TCP_Server_Info is first allocated and connected, tcpStatus ==
CifsGood means that the NEGOTIATE_PROTOCOL request has completed and the
socket is ready for other calls. cifs_reconnect however sets tcpStatus
to CifsGood as soon as the socket is reconnected and the optional
RFC1001 session setup is done. We have no clear way to tell the
difference between these two states, and we need to know this in order
to know whether we can send an echo or not.

Resolve this by adding a new statusEnum value -- CifsNeedNegotiate. When
the socket has been connected but has not yet had a NEGOTIATE_PROTOCOL
request done, set it to this value. Once the NEGOTIATE is done,
cifs_negotiate_protocol will set tcpStatus to CifsGood.

This also fixes and cleans the logic in cifs_reconnect and
cifs_reconnect_tcon. The old code checked for specific states when what
it really wants to know is whether the state has actually changed from
CifsNeedReconnect.

Reported-and-Tested-by: JG <jg-9fI4heB6ewM@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    3 ++-
 fs/cifs/cifssmb.c  |    4 ++--
 fs/cifs/connect.c  |    8 ++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index edd5b29..5f333e0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -92,7 +92,8 @@ enum statusEnum {
 	CifsNew = 0,
 	CifsGood,
 	CifsExiting,
-	CifsNeedReconnect
+	CifsNeedReconnect,
+	CifsNeedNegotiate
 };
 
 enum securityEnum {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 904aa47..f4bd502 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -142,9 +142,9 @@ cifs_reconnect_tcon(struct cifsTconInfo *tcon, int smb_command)
 	 */
 	while (server->tcpStatus == CifsNeedReconnect) {
 		wait_event_interruptible_timeout(server->response_q,
-			(server->tcpStatus == CifsGood), 10 * HZ);
+			(server->tcpStatus != CifsNeedReconnect), 10 * HZ);
 
-		/* is TCP session is reestablished now ?*/
+		/* are we still trying to reconnect? */
 		if (server->tcpStatus != CifsNeedReconnect)
 			break;
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 257b6d8..7deceae 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -199,8 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	}
 	spin_unlock(&GlobalMid_Lock);
 
-	while ((server->tcpStatus != CifsExiting) &&
-	       (server->tcpStatus != CifsGood)) {
+	while (server->tcpStatus == CifsNeedReconnect) {
 		try_to_freeze();
 
 		/* we should try only the port we connected to before */
@@ -212,7 +211,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			atomic_inc(&tcpSesReconnectCount);
 			spin_lock(&GlobalMid_Lock);
 			if (server->tcpStatus != CifsExiting)
-				server->tcpStatus = CifsGood;
+				server->tcpStatus = CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
 		}
 	}
@@ -420,7 +419,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
 		pdu_length = 4; /* enough to get RFC1001 header */
 
 incomplete_rcv:
-		if (echo_retries > 0 &&
+		if (echo_retries > 0 && server->tcpStatus == CifsGood &&
 		    time_after(jiffies, server->lstrp +
 					(echo_retries * SMB_ECHO_INTERVAL))) {
 			cERROR(1, "Server %s has not responded in %d seconds. "
@@ -1732,6 +1731,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 		cERROR(1, "Error connecting to socket. Aborting operation");
 		goto out_err_crypto_release;
 	}
+	tcp_ses->tcpStatus = CifsNeedNegotiate;
 
 	/*
 	 * since we're in a cifs function already, we know that
-- 
1.7.4
