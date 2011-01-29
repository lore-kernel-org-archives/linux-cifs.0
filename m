From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cifs: force a reconnect if there are too many MIDs in flight
Date: Sat, 29 Jan 2011 07:02:28 -0500
Message-ID: <1296302548-18913-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we allow the pending_mid_q to grow without bound with
SIGKILL'ed processes. This could eventually be a DoS'able problem. An
unprivileged user could a process that does a long-running call and then
SIGKILL it.

If he can also intercept the NT_CANCEL calls or the replies from the
server, then the pending_mid_q could grow very large, possibly even to
2^16 entries which might leave GetNextMid in an infinite loop. Fix this
by imposing a hard limit of 32k calls per server. If we cross that
limit, set the tcpStatus to CifsNeedReconnect to force cifsd to
eventually reconnect the socket and clean out the pending_mid_q.

While we're at it, clean up the function a bit and eliminate an
unnecessary NULL pointer check.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |   37 ++++++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 77dc732..2a930a7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -236,10 +236,7 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
 {
 	__u16 mid = 0;
 	__u16 last_mid;
-	int   collision;
-
-	if (server == NULL)
-		return mid;
+	bool collision;
 
 	spin_lock(&GlobalMid_Lock);
 	last_mid = server->CurrentMid; /* we do not want to loop forever */
@@ -252,24 +249,38 @@ __u16 GetNextMid(struct TCP_Server_Info *server)
 	(and it would also have to have been a request that
 	 did not time out) */
 	while (server->CurrentMid != last_mid) {
-		struct list_head *tmp;
 		struct mid_q_entry *mid_entry;
+		unsigned int num_mids;
 
-		collision = 0;
+		collision = false;
 		if (server->CurrentMid == 0)
 			server->CurrentMid++;
 
-		list_for_each(tmp, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-
-			if ((mid_entry->mid == server->CurrentMid) &&
-			    (mid_entry->midState == MID_REQUEST_SUBMITTED)) {
+		num_mids = 0;
+		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+			++num_mids;
+			if (mid_entry->mid == server->CurrentMid &&
+			    mid_entry->midState == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
-				collision = 1;
+				collision = true;
 				break;
 			}
 		}
-		if (collision == 0) {
+
+		/*
+		 * if we have more than 32k mids in the list, then something
+		 * is very wrong. Possibly a local user is trying to DoS the
+		 * box by issuing long-running calls and SIGKILL'ing them. If
+		 * we get to 2^16 mids then we're in big trouble as this
+		 * function could loop forever.
+		 *
+		 * Go ahead and assign out the mid in this situation, but force
+		 * an eventual reconnect to clean out the pending_mid_q.
+		 */
+		if (num_mids > 32768)
+			server->tcpStatus = CifsNeedReconnect;
+
+		if (!collision) {
 			mid = server->CurrentMid;
 			break;
 		}
-- 
1.7.3.4
