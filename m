Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0254361977
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789299348; cv=none; b=O1ULdhte9j9Qy8LWVMAkh9nEZz9DDr4u0Jk0VfTT8tlNTLwzkcWOsg+pU2E3UEaT2AdcubSprXc4cItgtDHznwA/uGsgDzWzkGYVpYBMfqxMzJnwhmh+xMrSgq+5OqXtMql3jE0zIVA0w5XsRsC0CMz9U0GZH3UQpasGAiP93qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789299348; c=relaxed/simple;
	bh=8oCwgf5jSl4tR1tbwrxmj4I5X6YWAdjFdANFtPXwGYI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b2MuGFeO3OOkrts4UeonDcCm53l6Tex1kGBUsgZ+/dmMc1xcwf25zuL21GWiwVRJK+HERA+Oi7uePpivmaAurk3Hit2yxpKKcFuLa+vySAhc4q9AtSrWeRlRbRDlzmkpBVPfHxVVhGsvE8J/yh76tXO2/cg8cVeqdIvCA0aVTAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AW6ZzwIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AW6ZzwIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0901F000FF;
	Sun, 13 Sep 2026 11:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789299346;
	bh=ommv6nYLUGc4TEesMoDVudT8St4k1qNzDIaDmS67q/4=;
	h=From:To:Cc:Subject:Date;
	b=AW6ZzwIEGCPDmwSYcPvEUFgTzHk0Xsxcj29KAaIILMS1VeT0v8Bk4X/3QGclOMwkL
	 +wyIjPNWhZglvyDCCONMThB1UETqo0zh+SdeQLN5BWm72J44q9M6toWnTDCGEYCv6V
	 apEipZd6DqeLZZ+LxyrRBnZ+WMjwOfAUKwPdwitNeMWrL6VMF/L2gyGPaBUyqaMxC7
	 IgdcJ7Mqoi53V+GHIbPHZqvL+y1H4/rQTT+M2RDxBrFHvk7M5U+wnbQrQhKyof952N
	 PxpRWT3/vBgByeO3hQ8kq6dvAtJn5A/wZNg6qY4vL3rb8vycA7k++6fOVFZeT2Wn2c
	 ns+K+1fIlpFxw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Mobin Aydinfar <mobin@mobintestserver.ir>
Subject: [PATCH 1/3] ksmbd: follow SMB2 session expiration semantics
Date: Sun, 13 Sep 2026 20:35:36 +0900
Message-Id: <20260913113536.11429-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_session_register() destroys valid sessions after ten seconds of
inactivity whenever a client starts another SessionSetup exchange. This
confuses Session.IdleTime with Session.ExpirationTime. Windows can create
additional authenticated sessions on an existing connection, so deleting
the older session invalidates its tree connects and makes mapped drives
fail with STATUS_NETWORK_NAME_DELETED.

The session expiration rules require the server to change a valid session
to expired only after its credential expiration time passes. A valid or
expired session otherwise keeps its connection from being scavenged.
Connections that have not negotiated a dialect, have no sessions, or have
only InProgress sessions are disconnected after an implementation-specific
timeout. Use the Windows-compatible 45 second value and run the expiration
check periodically for both TCP and SMB Direct.

Keep zero as an infinite credential expiration time, and count each
Valid-to-Expired transition. Set expired sessions to InProgress when they
reauthenticate. If authentication fails, remove the session from the
global and per-connection tables immediately, including SMB3 multichannel
connections.

Retain protection against abandoned SessionId-zero exchanges by allowing
only one InProgress authentication per connection. Additional exchanges
fail with STATUS_INSUFFICIENT_RESOURCES, and stale InProgress sessions are
reaped after the same 45 second setup timeout. This bounds the original
unauthenticated memory-exhaustion path without evicting established
sessions.

Fixes: ea174a918939 ("ksmbd: destroy expired sessions")
Reported-by: Mobin Aydinfar <mobin@mobintestserver.ir>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c        |  72 ++++++++++++++++++
 fs/smb/server/connection.h        |   3 +
 fs/smb/server/mgmt/user_session.c | 124 ++++++++++++++++++++++++++++++--
 fs/smb/server/mgmt/user_session.h |   8 +-
 fs/smb/server/proc.c              |   2 +
 fs/smb/server/server.c            |   2 +-
 fs/smb/server/smb2pdu.c           |  37 ++++++---
 fs/smb/server/smb2pdu.h           |   2 -
 fs/smb/server/stats.h             |   1 +
 9 files changed, 227 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 97a8ede1dfe5..3f8cc4998da5 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -22,6 +22,8 @@
 static DEFINE_MUTEX(init_lock);
 
 static struct ksmbd_conn_ops default_conn_ops;
+static struct delayed_work session_expiration_work;
+static bool stopping_session_expiration_work;
 
 DEFINE_HASHTABLE(conn_list, CONN_HASH_BITS);
 DECLARE_RWSEM(conn_list_lock);
@@ -158,18 +160,28 @@ static void delete_proc_clients(void) {}
 
 static struct workqueue_struct *ksmbd_conn_wq;
 
+static void ksmbd_session_expiration_worker(struct work_struct *work);
+
 int ksmbd_conn_wq_init(void)
 {
 	ksmbd_conn_wq = alloc_workqueue("ksmbd-conn-release",
 					WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
 	if (!ksmbd_conn_wq)
 		return -ENOMEM;
+
+	WRITE_ONCE(stopping_session_expiration_work, false);
+	INIT_DELAYED_WORK(&session_expiration_work,
+			  ksmbd_session_expiration_worker);
+	queue_delayed_work(ksmbd_conn_wq, &session_expiration_work,
+			   KSMBD_SESSION_EXPIRATION_INTERVAL);
 	return 0;
 }
 
 void ksmbd_conn_wq_destroy(void)
 {
 	if (ksmbd_conn_wq) {
+		WRITE_ONCE(stopping_session_expiration_work, true);
+		cancel_delayed_work_sync(&session_expiration_work);
 		destroy_workqueue(ksmbd_conn_wq);
 		ksmbd_conn_wq = NULL;
 	}
@@ -279,6 +291,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		return NULL;
 
 	conn->need_neg = true;
+	conn->creation_time = jiffies;
 	ksmbd_conn_set_new(conn);
 	conn->local_nls = load_nls("utf8");
 	if (!conn->local_nls)
@@ -588,6 +601,20 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 	if (kthread_should_stop())
 		return false;
 
+	/*
+	 * Stale connections that have not completed NEGOTIATE and SESSION_SETUP
+	 * must be disconnected. Do not race a request that is currently
+	 * completing authentication.
+	 */
+	if (!atomic_read(&conn->req_running) &&
+	    time_after(jiffies, conn->creation_time +
+		       KSMBD_UNAUTHENTICATED_CONN_TIMEOUT) &&
+	    (READ_ONCE(conn->need_neg) ||
+	     !ksmbd_conn_has_valid_or_expired_session(conn))) {
+		ksmbd_debug(CONN, "Connection setup timed out\n");
+		return false;
+	}
+
 	if (atomic_read(&conn->stats.open_files_count) > 0)
 		return true;
 
@@ -605,6 +632,51 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
 	return true;
 }
 
+static void ksmbd_session_expiration_worker(struct work_struct *work)
+{
+	struct ksmbd_conn *conn, *target;
+	int bkt;
+
+	if (!ksmbd_server_running())
+		goto reschedule;
+
+	ksmbd_expire_sessions();
+
+	/*
+	 * An old connection without a Valid or Expired session must be
+	 * disconnected. Process one connection at a time without holding
+	 * conn_list_lock across transport shutdown.
+	 */
+again:
+	target = NULL;
+	down_read(&conn_list_lock);
+	hash_for_each(conn_list, bkt, conn, hlist) {
+		if (ksmbd_conn_exiting(conn) || ksmbd_conn_releasing(conn) ||
+		    atomic_read(&conn->req_running) ||
+		    time_before_eq(jiffies, conn->creation_time +
+				   KSMBD_UNAUTHENTICATED_CONN_TIMEOUT) ||
+		    (!READ_ONCE(conn->need_neg) &&
+		     ksmbd_conn_has_valid_or_expired_session(conn)))
+			continue;
+
+		target = ksmbd_conn_get(conn);
+		break;
+	}
+	up_read(&conn_list_lock);
+
+	if (target) {
+		ksmbd_debug(CONN, "Connection setup timed out\n");
+		ksmbd_conn_abort(target);
+		ksmbd_conn_put(target);
+		goto again;
+	}
+
+reschedule:
+	if (!READ_ONCE(stopping_session_expiration_work))
+		queue_delayed_work(ksmbd_conn_wq, &session_expiration_work,
+				   KSMBD_SESSION_EXPIRATION_INTERVAL);
+}
+
 /* "+2" for BCC field (ByteCount, 2 bytes) */
 #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_hdr) + 2)
 #define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 63484c8efbbd..371f17b4f02a 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -77,6 +77,7 @@ struct ksmbd_conn {
 	struct rw_semaphore		session_lock;
 	/* smb session 1 per user */
 	struct xarray			sessions;
+	unsigned long			creation_time;
 	unsigned long			last_active;
 	/* How many request are running currently */
 	atomic_t			req_running;
@@ -192,6 +193,8 @@ struct ksmbd_transport {
 
 #define KSMBD_TCP_RECV_TIMEOUT	(7 * HZ)
 #define KSMBD_TCP_SEND_TIMEOUT	(5 * HZ)
+#define KSMBD_SESSION_EXPIRATION_INTERVAL	(5 * HZ)
+#define KSMBD_UNAUTHENTICATED_CONN_TIMEOUT	(45 * HZ)
 #define KSMBD_TCP_PEER_SOCKADDR(c)	((struct sockaddr *)&((c)->peer_addr))
 
 #define CONN_HASH_BITS	12
diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 2eb8f730e99e..44dc3f800cd4 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -22,6 +22,7 @@
 static DEFINE_IDA(session_ida);
 
 #define SESSION_HASH_BITS		12
+#define KSMBD_MAX_PENDING_SESSIONS	1
 static DEFINE_HASHTABLE(sessions_table, SESSION_HASH_BITS);
 static DECLARE_RWSEM(sessions_table_lock);
 
@@ -432,26 +433,31 @@ struct ksmbd_session *__session_lookup(unsigned long long id)
 	return NULL;
 }
 
-static void ksmbd_expire_session(struct ksmbd_conn *conn)
+static bool ksmbd_too_many_session_setups(struct ksmbd_conn *conn)
 {
 	unsigned long id;
 	struct ksmbd_session *sess;
+	unsigned int pending = 0;
 
 	down_write(&sessions_table_lock);
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
+		if (READ_ONCE(sess->state) != SMB2_SESSION_IN_PROGRESS)
+			continue;
+
 		if (atomic_read(&sess->refcnt) <= 1 &&
-		    (sess->state != SMB2_SESSION_VALID ||
-		     time_after(jiffies,
-			       sess->last_active + SMB2_SESSION_TIMEOUT))) {
+		    time_after(jiffies, sess->last_active +
+			       KSMBD_UNAUTHENTICATED_CONN_TIMEOUT)) {
 			xa_erase(&conn->sessions, sess->id);
 			ksmbd_session_remove_from_table(sess);
 			ksmbd_session_destroy(sess);
 			continue;
 		}
+		pending++;
 	}
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
+	return pending >= KSMBD_MAX_PENDING_SESSIONS;
 }
 
 int ksmbd_session_register(struct ksmbd_conn *conn,
@@ -461,9 +467,12 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 
 	sess->dialect = conn->dialect;
 	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
-	ksmbd_expire_session(conn);
-	ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
-			      KSMBD_DEFAULT_GFP));
+	/* Bound abandoned SessionId-zero authentication exchanges. */
+	if (ksmbd_too_many_session_setups(conn))
+		ret = -ENOSPC;
+	else
+		ret = xa_err(xa_store(&conn->sessions, sess->id, sess,
+				      KSMBD_DEFAULT_GFP));
 	if (ret) {
 		down_write(&sessions_table_lock);
 		ksmbd_session_remove_from_table(sess);
@@ -474,6 +483,105 @@ int ksmbd_session_register(struct ksmbd_conn *conn,
 	return ret;
 }
 
+void ksmbd_session_unregister(struct ksmbd_conn *conn,
+			      struct ksmbd_session *sess)
+{
+	struct ksmbd_conn *session_conns[KSMBD_MAX_CHANNELS];
+	struct channel *chann;
+	unsigned long index;
+	unsigned int nr_conns = 0, i;
+	bool removed = false;
+
+	down_write(&sessions_table_lock);
+	if (!hlist_unhashed(&sess->hlist)) {
+		/* Keep each channel connection stable under sessions_table_lock. */
+		down_read(&sess->chann_lock);
+		xa_for_each(&sess->ksmbd_chann_list, index, chann) {
+			if (nr_conns == ARRAY_SIZE(session_conns))
+				break;
+			session_conns[nr_conns++] = chann->conn;
+		}
+		up_read(&sess->chann_lock);
+
+		ksmbd_session_remove_from_table(sess);
+		removed = true;
+	}
+
+	down_write(&conn->session_lock);
+	if (xa_load(&conn->sessions, sess->id) == sess)
+		xa_erase(&conn->sessions, sess->id);
+	up_write(&conn->session_lock);
+	for (i = 0; i < nr_conns; i++) {
+		if (session_conns[i] == conn)
+			continue;
+		down_write(&session_conns[i]->session_lock);
+		if (xa_load(&session_conns[i]->sessions, sess->id) == sess)
+			xa_erase(&session_conns[i]->sessions, sess->id);
+		up_write(&session_conns[i]->session_lock);
+	}
+	up_write(&sessions_table_lock);
+
+	if (removed)
+		ksmbd_user_session_put(sess);
+}
+
+bool ksmbd_conn_has_valid_or_expired_session(struct ksmbd_conn *conn)
+{
+	struct ksmbd_session *sess;
+	unsigned long id;
+	int state, bkt;
+	bool found = false;
+
+	down_read(&conn->session_lock);
+	xa_for_each(&conn->sessions, id, sess) {
+		state = READ_ONCE(sess->state);
+		if (state == SMB2_SESSION_VALID ||
+		    state == SMB2_SESSION_EXPIRED) {
+			found = true;
+			break;
+		}
+	}
+	up_read(&conn->session_lock);
+	if (found)
+		return true;
+
+	/* A session bound through SMB3 multichannel is not in conn->sessions. */
+	down_read(&sessions_table_lock);
+	hash_for_each(sessions_table, bkt, sess, hlist) {
+		state = READ_ONCE(sess->state);
+		if (state != SMB2_SESSION_VALID &&
+		    state != SMB2_SESSION_EXPIRED)
+			continue;
+
+		down_read(&sess->chann_lock);
+		found = xa_load(&sess->ksmbd_chann_list, (long)conn);
+		up_read(&sess->chann_lock);
+		if (found)
+			break;
+	}
+	up_read(&sessions_table_lock);
+	return found;
+}
+
+void ksmbd_expire_sessions(void)
+{
+	struct ksmbd_session *sess;
+	u64 now = ktime_get_real_seconds();
+	int bkt;
+
+	down_read(&sessions_table_lock);
+	hash_for_each(sessions_table, bkt, sess, hlist) {
+		if (READ_ONCE(sess->state) != SMB2_SESSION_VALID ||
+		    !sess->kerberos_expiry || now < sess->kerberos_expiry)
+			continue;
+
+		if (cmpxchg(&sess->state, SMB2_SESSION_VALID,
+			    SMB2_SESSION_EXPIRED) == SMB2_SESSION_VALID)
+			ksmbd_counter_inc(KSMBD_COUNTER_SESSION_TIMEOUTS);
+	}
+	up_read(&sessions_table_lock);
+}
+
 static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;
@@ -488,7 +596,7 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 	return 0;
 }
 
-void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
+void ksmbd_conn_sessions_cleanup(struct ksmbd_conn *conn)
 {
 	struct ksmbd_session *sess;
 	unsigned long id;
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 3e52d4cc1324..217258551d6d 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -72,6 +72,8 @@ struct ksmbd_session {
 	struct rw_semaphore		rpc_lock;
 };
 
+#define KSMBD_MAX_CHANNELS	32
+
 static inline int test_session_flag(struct ksmbd_session *sess, int bit)
 {
 	return sess->flags & bit;
@@ -98,7 +100,11 @@ bool is_ksmbd_session_in_connection(struct ksmbd_conn *conn,
 				     unsigned long long id);
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess);
+void ksmbd_session_unregister(struct ksmbd_conn *conn,
+			      struct ksmbd_session *sess);
-void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
+void ksmbd_conn_sessions_cleanup(struct ksmbd_conn *conn);
+bool ksmbd_conn_has_valid_or_expired_session(struct ksmbd_conn *conn);
+void ksmbd_expire_sessions(void);
 struct ksmbd_session *__session_lookup(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
diff --git a/fs/smb/server/proc.c b/fs/smb/server/proc.c
index 826353ed0553..19f0f2cfbf54 100644
--- a/fs/smb/server/proc.c
+++ b/fs/smb/server/proc.c
@@ -178,6 +178,8 @@ static int proc_show_ksmbd_stats(struct seq_file *m, void *v)
 	proc_show_runtime_totals(m);
 	seq_printf(m, "sessions:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_SESSIONS));
+	seq_printf(m, "session_timeouts:\t%lld\n",
+		   ksmbd_counter_sum(KSMBD_COUNTER_SESSION_TIMEOUTS));
 	seq_printf(m, "tree_connects:\t%lld\n",
 		   ksmbd_counter_sum(KSMBD_COUNTER_TREE_CONNS));
 	seq_printf(m, "requests:\t%lld\n",
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0069d4e6a60a..0827c8c51006 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -414,7 +414,7 @@ static int ksmbd_server_process_request(struct ksmbd_conn *conn)
 
 static int ksmbd_server_terminate_conn(struct ksmbd_conn *conn)
 {
-	ksmbd_sessions_deregister(conn);
+	ksmbd_conn_sessions_cleanup(conn);
 	destroy_lease_table(conn);
 	return 0;
 }
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2cf328468d01..f4d96799e1d2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -85,8 +85,6 @@ struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn
 	return chann;
 }
 
-#define KSMBD_MAX_CHANNELS	32
-
 static int register_session_channel(struct ksmbd_session *sess,
 				    struct ksmbd_conn *conn,
 				    const char *sess_key)
@@ -933,8 +931,14 @@ static bool smb2_session_expired_cmd_allowed(struct ksmbd_work *work,
 
 static bool smb2_session_kerberos_expired(struct ksmbd_session *sess)
 {
-	return sess->kerberos_expiry &&
-		ktime_get_real_seconds() >= sess->kerberos_expiry;
+	if (!sess->kerberos_expiry ||
+	    ktime_get_real_seconds() < sess->kerberos_expiry)
+		return false;
+
+	if (cmpxchg(&sess->state, SMB2_SESSION_VALID,
+		    SMB2_SESSION_EXPIRED) == SMB2_SESSION_VALID)
+		ksmbd_counter_inc(KSMBD_COUNTER_SESSION_TIMEOUTS);
+	return true;
 }
 
 /**
@@ -969,9 +973,8 @@ int smb2_check_user_session(struct ksmbd_work *work)
 		if (!work->next_smb2_rcv_hdr_off && sess_id)
 			work->sess = ksmbd_session_lookup_all_states(conn, sess_id);
 		if (work->sess) {
-			if (smb2_session_kerberos_expired(work->sess)) {
-				work->sess->state = SMB2_SESSION_EXPIRED;
-			} else if (work->sess->state != SMB2_SESSION_VALID) {
+			if (!smb2_session_kerberos_expired(work->sess) &&
+			    work->sess->state != SMB2_SESSION_VALID) {
 				ksmbd_user_session_put(work->sess);
 				work->sess = NULL;
 			}
@@ -996,8 +999,7 @@ int smb2_check_user_session(struct ksmbd_work *work)
 					sess_id, work->sess->id);
 			return -EINVAL;
 		}
-		if (smb2_session_kerberos_expired(work->sess))
-			work->sess->state = SMB2_SESSION_EXPIRED;
+		smb2_session_kerberos_expired(work->sess);
 		if (work->sess->state != SMB2_SESSION_VALID) {
 			pr_err("compound request on a non-valid session (state %d)\n",
 					work->sess->state);
@@ -1014,7 +1016,6 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	work->sess = ksmbd_session_lookup_all_states(conn, sess_id);
 	if (work->sess) {
 		if (smb2_session_kerberos_expired(work->sess)) {
-			work->sess->state = SMB2_SESSION_EXPIRED;
 			return smb2_session_expired_cmd_allowed(work, cmd) ?
 				1 : -EKEYEXPIRED;
 		}
@@ -2436,7 +2437,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_sess_setup_req *req;
 	struct smb2_sess_setup_rsp *rsp;
-	struct ksmbd_session *sess;
+	struct ksmbd_session *sess = NULL;
 	struct negotiate_message *negblob;
 	unsigned int negblob_len, negblob_off;
 	int rc = 0;
@@ -2592,6 +2593,9 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
+		if (work->session_setup_reauth)
+			WRITE_ONCE(sess->state, SMB2_SESSION_IN_PROGRESS);
+
 		conn->binding = false;
 	}
 	work->sess = sess;
@@ -2703,6 +2707,14 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	}
 
 	if (rc < 0) {
+		bool setup_in_progress = sess &&
+			READ_ONCE(sess->state) == SMB2_SESSION_IN_PROGRESS &&
+			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING);
+
+		/* Authentication errors must not leave the new session published. */
+		if (setup_in_progress)
+			ksmbd_session_unregister(conn, sess);
+
 		if (sess && conn->dialect == SMB311_PROT_ID &&
 		    (req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
 			struct preauth_session *preauth_sess;
@@ -2736,7 +2748,8 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			 * For binding requests, session belongs to another
 			 * connection. Do not expire it.
 			 */
-			if (!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
+			if (!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING) &&
+			    !setup_in_progress) {
 				sess->last_active = jiffies;
 				sess->kerberos_expiry = 0;
 				sess->state = SMB2_SESSION_EXPIRED;
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 3f08d1ca5a38..a6200d8630e2 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -61,8 +61,6 @@ struct preauth_integrity_info {
 #define SMB2_SESSION_IN_PROGRESS	BIT(0)
 #define SMB2_SESSION_VALID		BIT(1)
 
-#define SMB2_SESSION_TIMEOUT		(10 * HZ)
-
 /* Apple Defined Contexts */
 #define SMB2_CREATE_AAPL		"AAPL"
 
diff --git a/fs/smb/server/stats.h b/fs/smb/server/stats.h
index bc864efa0d46..8b32b8b4e8be 100644
--- a/fs/smb/server/stats.h
+++ b/fs/smb/server/stats.h
@@ -15,6 +15,7 @@
 
 enum {
 	KSMBD_COUNTER_SESSIONS = 0,
+	KSMBD_COUNTER_SESSION_TIMEOUTS,
 	KSMBD_COUNTER_TREE_CONNS,
 	KSMBD_COUNTER_REQUESTS,
 	KSMBD_COUNTER_STATUS_SUCCESS,
-- 
2.25.1
