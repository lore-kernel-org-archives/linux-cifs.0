From: Dave Chiluk <chiluk@canonical.com>
Subject: [PATCH] CIFS: Decrease reconnection delay when switching nics
Date: Mon, 25 Feb 2013 16:28:30 -0600
Message-ID: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

When messages are currently in queue awaiting a response, decrease amount of
time before attempting cifs_reconnect to SMB_MAX_RTT = 10 seconds. The current
wait time before attempting to reconnect is currently 2*SMB_ECHO_INTERVAL(120
seconds) since the last response was recieved.  This does not take into account
the fact that messages waiting for a response should be serviced within a
reasonable round trip time.

This fixes the issue where user moves from wired to wireless or vice versa
causing the mount to hang for 120 seconds, when it could reconnect considerably
faster.  After this fix it will take SMB_MAX_RTT (10 seconds) from the last
time the user attempted to access the volume or SMB_MAX_RTT after the last
echo.  The worst case of the latter scenario being
2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130 seconds).
Statistically speaking it would normally reconnect sooner.  However in the best
case where the user changes nics, and immediately tries to access the cifs
share it will take SMB_MAX_RTT=10 seconds.

BugLink: http://bugs.launchpad.net/bugs/1017622

Signed-off-by: Dave Chiluk <chiluk@canonical.com>
---
 fs/cifs/cifsglob.h |   15 +++++++------
 fs/cifs/connect.c  |   61 +++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e6899ce..138c8cf 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -80,6 +80,8 @@
 
 /* SMB echo "timeout" -- FIXME: tunable? */
 #define SMB_ECHO_INTERVAL (60 * HZ)
+/* Maximum acceptable round trip time to server */
+#define SMB_MAX_RTT (10 * HZ)
 
 #include "cifspdu.h"
 
@@ -1141,8 +1143,8 @@ struct mid_q_entry {
 	__u32 pid;		/* process id */
 	__u32 sequence_number;  /* for CIFS signing */
 	unsigned long when_alloc;  /* when mid was created */
-#ifdef CONFIG_CIFS_STATS2
 	unsigned long when_sent; /* time when smb send finished */
+#ifdef CONFIG_CIFS_STATS2
 	unsigned long when_received; /* when demux complete (taken off wire) */
 #endif
 	mid_receive_t *receive; /* call receive callback */
@@ -1179,11 +1181,6 @@ static inline void cifs_num_waiters_dec(struct TCP_Server_Info *server)
 {
 	atomic_dec(&server->num_waiters);
 }
-
-static inline void cifs_save_when_sent(struct mid_q_entry *mid)
-{
-	mid->when_sent = jiffies;
-}
 #else
 static inline void cifs_in_send_inc(struct TCP_Server_Info *server)
 {
@@ -1199,11 +1196,15 @@ static inline void cifs_num_waiters_inc(struct TCP_Server_Info *server)
 static inline void cifs_num_waiters_dec(struct TCP_Server_Info *server)
 {
 }
+#endif
 
+/* We always need to know when a mid was sent in order to determine if
+ * the server is not responding.
+ */
 static inline void cifs_save_when_sent(struct mid_q_entry *mid)
 {
+	mid->when_sent = jiffies;
 }
-#endif
 
 /* for pending dnotify requests */
 struct dir_notify_req {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12b3da3..57c78b3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -456,25 +456,66 @@ allocate_buffers(struct TCP_Server_Info *server)
 	return true;
 }
 
+/* Takes struct *TCP_Server_Info and returns the when_sent jiffy of the
+ * oldest unanswered mid in the pending queue or the newest response.
+ * Whichever is newer.
+ */
+static unsigned long
+oldest_req_or_newest_resp(struct TCP_Server_Info *server)
+{
+	struct mid_q_entry *mid;
+	unsigned long oldest_jiffy = jiffies;
+
+	spin_lock(&GlobalMid_Lock);
+	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		if (mid->mid_state == MID_REQUEST_SUBMITTED) {
+			if (time_before(mid->when_sent, oldest_jiffy))
+				oldest_jiffy = mid->when_sent;
+		}
+	}
+	spin_unlock(&GlobalMid_Lock);
+
+	/* Check to see if the last response is newer than the oldest request
+	 * This could mean that the server is just responding very slowly,
+	 * possibly even longer than SMB_MAX_RTT.  In which * case we don't
+	 * want to cause a reconnect.
+	 */
+	if (time_after(server->lstrp , oldest_jiffy))
+		return server->lstrp;
+	else
+		return oldest_jiffy;
+}
+
 static bool
 server_unresponsive(struct TCP_Server_Info *server)
 {
+	unsigned long oldest;
+
 	/*
-	 * We need to wait 2 echo intervals to make sure we handle such
-	 * situations right:
+	 * When no messages are in flight max wait is
+	 * 2*SMB_ECHO_INTERVAL + SMB_MAX_RTT + scheduling delay
+	 *
+	 * 1s   client sends a normal SMB request
+	 * 2s   client gets a response
+	 * 61s  echo workqueue job pops, and decides we got a response < 60
+	 *      seconds ago and don't need to send another
+	 * 121s kernel_recvmsg times out, and we see that we haven't gotten
+	 *      a response in >60s. Send echo causing in_flight() to return
+	 *      true
+	 * 131s echo hasn't returned run cifs_reconnect
+	 *
+	 * Situation 2 where non-echo messages are in_flight
 	 * 1s  client sends a normal SMB request
 	 * 2s  client gets a response
-	 * 30s echo workqueue job pops, and decides we got a response recently
-	 *     and don't need to send another
-	 * ...
-	 * 65s kernel_recvmsg times out, and we see that we haven't gotten
-	 *     a response in >60s.
+	 * 3s  client sends a normal SMB request
+	 * 13s client still has not received SMB response run cifs_reconnect
 	 */
 	if (server->tcpStatus == CifsGood &&
-	    time_after(jiffies, server->lstrp + 2 * SMB_ECHO_INTERVAL)) {
-		cERROR(1, "Server %s has not responded in %d seconds. "
+	    (in_flight(server) > 0 && time_after(jiffies,
+		  oldest = oldest_req_or_newest_resp(server) + SMB_MAX_RTT))) {
+		cERROR(1, "Server %s has not responded in %lu seconds. "
 			  "Reconnecting...", server->hostname,
-			  (2 * SMB_ECHO_INTERVAL) / HZ);
+			  ((jiffies - oldest) / HZ));
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
 		return true;
-- 
1.7.9.5
