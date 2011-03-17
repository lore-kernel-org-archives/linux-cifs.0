From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS] Cleanup use of CONFIG_CIFS_STATS2 ifdef to make transport
 routines more readable
Date: Thu, 17 Mar 2011 14:12:23 -0500
Message-ID: <AANLkTim2bOYRB9i-RzqTt62=Z_SF9BWk-7d-7qr2g0_p@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Christoph had requested that the stats related code (in
CONFIG_CIFS_STATS2) be moved into helpers to make code flow more
readable.   This patch should help.   For example the following
section from transport.c

			spin_unlock(&GlobalMid_Lock);
#ifdef CONFIG_CIFS_STATS2
			atomic_inc(&ses->server->num_waiters);
#endif
			wait_event(ses->server->request_q,
				   atomic_read(&ses->server->inFlight)
				     < cifs_max_pending);
#ifdef CONFIG_CIFS_STATS2
			atomic_dec(&ses->server->num_waiters);
#endif
			spin_lock(&GlobalMid_Lock);

becomes simpler (with the patch below):
			spin_unlock(&GlobalMid_Lock);
			cifs_num_waiters_inc(server);
			wait_event(server->request_q,
				   atomic_read(&server->inFlight)
				     < cifs_max_pending);
			cifs_num_waiters_dec(server);
			spin_lock(&GlobalMid_Lock);



diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 69e6e50..6dc9da5 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -146,7 +146,7 @@ static void dump_cifs_debug_info(int i, struct seq_file *m,

 #ifdef CONFIG_CIFS_STATS2
 		seq_printf(m, " In Send: %d In MaxReq Wait: %d",
-				atomic_read(&server->inSend),
+				atomic_read(&server->in_send),
 				atomic_read(&server->num_waiters));
 #endif

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 398f596..04ea75b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -219,7 +219,7 @@ struct TCP_Server_Info {
 	struct fscache_cookie   *fscache; /* client index cache cookie */
 #endif
 #ifdef CONFIG_CIFS_STATS2
-	atomic_t inSend; /* requests trying to send */
+	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #endif
 #ifdef CONFIG_CIFS_SMB2
@@ -609,6 +609,55 @@ struct mid_q_entry {
 	bool multiEnd:1;	/* both received */
 };

+/*	Make code in transport.c a little cleaner by moving
+	update of optional stats into function below */
+#ifdef CONFIG_CIFS_STATS2
+
+static inline void cifs_in_send_inc(struct TCP_Server_Info *server)
+{
+	atomic_inc(&server->in_send);
+}
+
+static inline void cifs_in_send_dec(struct TCP_Server_Info *server)
+{
+	atomic_dec(&server->in_send);
+}
+
+static inline void cifs_num_waiters_inc(struct TCP_Server_Info *server)
+{
+	atomic_inc(&server->num_waiters);
+}
+
+static inline void cifs_num_waiters_dec(struct TCP_Server_Info *server)
+{
+	atomic_dec(&server->num_waiters);
+}
+
+static inline void cifs_save_when_sent(struct mid_q_entry *mid)
+{
+	mid->when_sent = jiffies;
+}
+#else
+static inline void cifs_in_send_inc(struct TCP_Server_Info *server)
+{
+}
+static inline void cifs_in_send_dec(struct TCP_Server_Info *server)
+{
+}
+
+static inline void cifs_num_waiters_inc(struct TCP_Server_Info *server)
+{
+}
+
+static inline void cifs_num_waiters_dec(struct TCP_Server_Info *server)
+{
+}
+
+static inline void cifs_save_when_sent(struct mid_q_entry *mid)
+{
+}
+#endif
+
 /* for pending dnotify requests */
 struct dir_notify_req {
 	struct list_head lhead;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fd43ac6..1b3a9e0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -267,28 +267,20 @@ int wait_for_free_request(struct TCP_Server_Info *server,
 		if ((server->is_smb2 == false) &&
 		    atomic_read(&server->inFlight) >= cifs_max_pending) {
 			spin_unlock(&GlobalMid_Lock);
-#ifdef CONFIG_CIFS_STATS2
-			atomic_inc(&server->num_waiters);
-#endif
+			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
 				   atomic_read(&server->inFlight)
 				     < cifs_max_pending);
-#ifdef CONFIG_CIFS_STATS2
-			atomic_dec(&server->num_waiters);
-#endif
+			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
 #ifdef CONFIG_CIFS_SMB2
 		} else if (server->is_smb2 &&
 			  (atomic_read(&server->credits) < 1)) {
 			spin_unlock(&GlobalMid_Lock);
-#ifdef CONFIG_CIFS_STATS2
-			atomic_inc(&server->num_waiters);
-#endif
+			cifs_num_waiters_inc(server);
 			wait_event(server->request_q,
 				   atomic_read(&server->credits) > 0);
-#ifdef CONFIG_CIFS_STATS2
-			atomic_dec(&server->num_waiters);
-#endif
+			cifs_num_waiters_dec(server);
 			spin_lock(&GlobalMid_Lock);
 #endif /* CONFIG_CIFS_SMB2 */
 		} else {
@@ -392,14 +384,10 @@ cifs_call_async(struct TCP_Server_Info *server,
struct smb_hdr *in_buf,
 	mid->callback = callback;
 	mid->callback_data = cbdata;
 	mid->midState = MID_REQUEST_SUBMITTED;
-#ifdef CONFIG_CIFS_STATS2
-	atomic_inc(&server->inSend);
-#endif
+	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
-#ifdef CONFIG_CIFS_STATS2
-	atomic_dec(&server->inSend);
-	mid->when_sent = jiffies;
-#endif
+	cifs_in_send_dec(server);
+	cifs_save_when_sent(mid);
 	mutex_unlock(&server->srv_mutex);
 	if (rc)
 		goto out_err;
@@ -575,14 +563,10 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	}

 	midQ->midState = MID_REQUEST_SUBMITTED;
-#ifdef CONFIG_CIFS_STATS2
-	atomic_inc(&ses->server->inSend);
-#endif
+	cifs_in_send_inc(ses->server);
 	rc = smb_sendv(ses->server, iov, n_vec);
-#ifdef CONFIG_CIFS_STATS2
-	atomic_dec(&ses->server->inSend);
-	midQ->when_sent = jiffies;
-#endif
+	cifs_in_send_dec(ses->server);
+	cifs_save_when_sent(midQ);

 	mutex_unlock(&ses->server->srv_mutex);

@@ -739,14 +723,11 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}

 	midQ->midState = MID_REQUEST_SUBMITTED;
-#ifdef CONFIG_CIFS_STATS2
-	atomic_inc(&ses->server->inSend);
-#endif
+
+	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
-#ifdef CONFIG_CIFS_STATS2
-	atomic_dec(&ses->server->inSend);
-	midQ->when_sent = jiffies;
-#endif
+	cifs_in_send_dec(ses->server);
+	cifs_save_when_sent(midQ);
 	mutex_unlock(&ses->server->srv_mutex);

 	if (rc < 0)
@@ -917,14 +898,10 @@ SendReceiveBlockingLock(const unsigned int xid,
struct cifs_tcon *tcon,
 	}

 	midQ->midState = MID_REQUEST_SUBMITTED;
-#ifdef CONFIG_CIFS_STATS2
-	atomic_inc(&ses->server->inSend);
-#endif
+	cifs_in_send_inc(ses->server);
 	rc = smb_send(ses->server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
-#ifdef CONFIG_CIFS_STATS2
-	atomic_dec(&ses->server->inSend);
-	midQ->when_sent = jiffies;
-#endif
+	cifs_in_send_dec(ses->server);
+	cifs_save_when_sent(midQ);
 	mutex_unlock(&ses->server->srv_mutex);

 	if (rc < 0) {

-- 
Thanks,

Steve
