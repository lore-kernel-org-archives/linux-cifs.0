Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B3135F162
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199045; cv=none; b=o4sOvyxMm/3+UIEg8lX8U9Ptqr4l+tICYcY4ONgqn0RLzkFA+K33SnO92xyru3bhaHx4kHmAxwrOsUDVnFwGsKJ3ktSBWd+ttLh7FL0mUFWGAz76bWHNL5S6r0VmMHv46Pw3XfBL3ld1Upgc4WYfGSdklC+0mERYbgQIugJrIzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199045; c=relaxed/simple;
	bh=yuZJcfrm+QB9M8jWwsTJCPsxoZJ4I5ugkrbjEIAY6Hg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o0aXjjE7oDdnOB+DshUVKEHrtmLC16UXqVv2xkSuMoVlyf8s6TYf3UMLCIn3Jb1ZXYeIYqIOnUHIINiAASVcV0dx8EOGqjdBMwmHM1vxhBgUuHsUUUM14hmN9Ipi+xnnpqI78VnqdGEypnliHTFexSBXAJhd2a+4swdVXbkqnDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W4RaKoFF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W4RaKoFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B871F000C4;
	Sat, 17 Oct 2026 01:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199043;
	bh=olTAI28Yb1jvG9kS3MQpSsz7XV6/8EDbuO2QsNnAE6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4RaKoFFqrM8L745y148tLNHNsJc/BgCDF2L+wLcQ28PcNLumcTm4AiFSVc0jODNC
	 HWGCKbJ/5eABpTTnvCH/LSQYRn4IZY/yT7T4JBS1qDSPkaGIIck+vS101Vg1AWDfDv
	 xL0RbQ7jQ9La2YX9HLtV+AYWMfRvZ9CfqLcanSFvb2Gr/t21qkBOkilk/dRHPNFgyU
	 0vwT3qdE5uM72QAK/pAm2vzMRHTCRMQ9ln9WsFcgxxUtCHXMql8pPIi0GdGED8N6nW
	 IkIS06kSRSeWhROSDF2UlSIreXXIOYftxFBb/JF2BRajsGWJNSLV+EV13xpm6yxfEL
	 rv1dAbtUWQzDw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 03/22] ksmbd: track delivery of queued TCP writes
Date: Sat, 17 Oct 2026 10:03:25 +0900
Message-Id: <20261017010344.11478-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A nonblocking break send must distinguish a PDU accepted by TCP from one
still queued in ksmbd. Retrying an accepted PDU can send duplicates, while
abandoning a partial send can corrupt the stream.

Queue owned PDU bytes when TCP cannot accept the full message. Track the
stream position through socket delivery and TCP ACK, and expose it to break
retries. Bound retained data and stop queued writes during teardown.

Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c    |  52 +++++-
 fs/smb/server/connection.h    |  24 ++-
 fs/smb/server/transport_tcp.c | 299 +++++++++++++++++++++++++++++++++-
 3 files changed, 356 insertions(+), 19 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index d1cc725eeb06..19d32681bb92 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -457,17 +457,13 @@ void ksmbd_all_conn_set_status(struct ksmbd_session *sess, u32 status)
 
 void ksmbd_conn_abort(struct ksmbd_conn *conn)
 {
-	bool shutdown = false;
-
 	spin_lock(&conn->request_lock);
-	if (!ksmbd_conn_exiting(conn) && !ksmbd_conn_releasing(conn)) {
+	if (!ksmbd_conn_exiting(conn) && !ksmbd_conn_releasing(conn))
 		ksmbd_conn_set_exiting(conn);
-		shutdown = true;
-	}
 	spin_unlock(&conn->request_lock);
 	wake_up_all(&conn->req_running_q);
 
-	if (shutdown && conn->transport->ops->shutdown)
+	if (conn->transport->ops->shutdown)
 		conn->transport->ops->shutdown(conn->transport);
 }
 
@@ -534,12 +530,19 @@ static int __ksmbd_conn_write(struct ksmbd_work *work,
 	tx->need_invalidate_rkey = work->need_invalidate_rkey;
 	tx->remote_key = work->remote_key;
 
-	ksmbd_conn_lock(conn);
+	if (tx->tracking) {
+		/* A busy writer must not consume the break's retry budget. */
+		if (!mutex_trylock(&conn->srv_mutex))
+			return -EAGAIN;
+	} else {
+		ksmbd_conn_lock(conn);
+	}
 	sent = conn->transport->ops->writev(conn->transport, tx);
 	ksmbd_conn_unlock(conn);
 
 	if (sent < 0) {
-		pr_err("Failed to send message: %d\n", sent);
+		if (!tx->tracking || sent != -EAGAIN)
+			pr_err("Failed to send message: %d\n", sent);
 		return sent;
 	}
 
@@ -553,6 +556,20 @@ int ksmbd_conn_write(struct ksmbd_work *work)
 	return __ksmbd_conn_write(work, &tx);
 }
 
+int ksmbd_conn_write_tracked(struct ksmbd_work *work,
+			     struct ksmbd_tx_tracking *tracking)
+{
+	struct ksmbd_transport_write tx = {};
+
+	tracking->valid = false;
+	/* Transports without delivery tracking keep their synchronous send path. */
+	if (work->conn->transport->ops->is_acked) {
+		tx.msg_flags = MSG_DONTWAIT;
+		tx.tracking = tracking;
+	}
+	return __ksmbd_conn_write(work, &tx);
+}
+
 int ksmbd_conn_write_eor(struct ksmbd_work *work)
 {
 	struct ksmbd_transport_write tx = {
@@ -805,7 +822,12 @@ int ksmbd_conn_handler_loop(void *p)
 		}
 	}
 
+	/* Exclude new break senders before draining their work references. */
+	spin_lock(&conn->request_lock);
 	ksmbd_conn_set_releasing(conn);
+	spin_unlock(&conn->request_lock);
+	/* TCP writers waiting for queue space must release their work references. */
+	wake_up_all(&conn->req_running_q);
 	ksmbd_conn_cancel_async_requests(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
@@ -832,6 +854,20 @@ void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn)
 	atomic_inc(&conn->r_count);
 }
 
+/* The caller already owns a connection reference. */
+bool ksmbd_conn_r_count_inc_if_good(struct ksmbd_conn *conn)
+{
+	bool ret = false;
+
+	spin_lock(&conn->request_lock);
+	if (ksmbd_conn_good(conn)) {
+		atomic_inc(&conn->r_count);
+		ret = true;
+	}
+	spin_unlock(&conn->request_lock);
+	return ret;
+}
+
 void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn)
 {
 	/*
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 2026a2afa5e4..85e2d2073cd2 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -103,6 +103,8 @@ struct ksmbd_conn {
 	wait_queue_head_t		r_count_q;
 	/* Lock to protect requests list*/
 	spinlock_t			request_lock;
+	/* Set under request_lock at teardown start and kept set thereafter. */
+	bool				releasing;
 	struct list_head		requests;
 	struct list_head		async_requests;
 	int				connection_type;
@@ -162,6 +164,13 @@ struct ksmbd_conn_ops {
 	int	(*terminate_fn)(struct ksmbd_conn *conn);
 };
 
+struct ksmbd_tx_tracking {
+	/* Required TCP byte count, including transport and socket queues. */
+	u64		end;
+	unsigned long	retry_after;
+	bool		valid;
+};
+
 struct ksmbd_transport_write {
 	struct kvec	*iov;
 	int		iov_cnt;
@@ -169,6 +178,7 @@ struct ksmbd_transport_write {
 	bool		need_invalidate_rkey;
 	unsigned int	remote_key;
 	int		msg_flags;
+	struct ksmbd_tx_tracking *tracking;
 };
 
 struct ksmbd_transport_ops {
@@ -176,8 +186,12 @@ struct ksmbd_transport_ops {
 	void (*shutdown)(struct ksmbd_transport *t);
 	int (*read)(struct ksmbd_transport *t, char *buf,
 		    unsigned int size, int max_retries);
+	/* Retained bytes must be privately owned before a full result is returned. */
 	int (*writev)(struct ksmbd_transport *t,
 		      const struct ksmbd_transport_write *tx);
+	/* Optional delivery tracking for nonblocking break sends. */
+	bool (*is_acked)(struct ksmbd_transport *t,
+			 const struct ksmbd_tx_tracking *tracking);
 	int (*rdma_read)(struct ksmbd_transport *t,
 			 void *buf, unsigned int len,
 			 struct smbdirect_buffer_descriptor_v1 *desc,
@@ -217,6 +231,8 @@ int ksmbd_conn_wq_init(void);
 void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
+int ksmbd_conn_write_tracked(struct ksmbd_work *work,
+			     struct ksmbd_tx_tracking *tracking);
 int ksmbd_conn_write_eor(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
 			 void *buf, unsigned int buflen,
@@ -235,6 +251,7 @@ void ksmbd_conn_transport_destroy(void);
 void ksmbd_conn_lock(struct ksmbd_conn *conn);
 void ksmbd_conn_unlock(struct ksmbd_conn *conn);
 void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn);
+bool ksmbd_conn_r_count_inc_if_good(struct ksmbd_conn *conn);
 void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn);
 
 /*
@@ -250,7 +267,8 @@ static inline bool ksmbd_conn_new(struct ksmbd_conn *conn)
 
 static inline bool ksmbd_conn_good(struct ksmbd_conn *conn)
 {
-	return READ_ONCE(conn->status) == KSMBD_SESS_GOOD;
+	return !READ_ONCE(conn->releasing) &&
+		READ_ONCE(conn->status) == KSMBD_SESS_GOOD;
 }
 
 static inline unsigned int
@@ -284,7 +302,8 @@ static inline bool ksmbd_conn_exiting(struct ksmbd_conn *conn)
 
 static inline bool ksmbd_conn_releasing(struct ksmbd_conn *conn)
 {
-	return READ_ONCE(conn->status) == KSMBD_SESS_RELEASING;
+	return READ_ONCE(conn->releasing) ||
+		READ_ONCE(conn->status) == KSMBD_SESS_RELEASING;
 }
 
 static inline void ksmbd_conn_set_new(struct ksmbd_conn *conn)
@@ -319,6 +338,7 @@ static inline void ksmbd_conn_set_exiting(struct ksmbd_conn *conn)
 
 static inline void ksmbd_conn_set_releasing(struct ksmbd_conn *conn)
 {
+	WRITE_ONCE(conn->releasing, true);
 	WRITE_ONCE(conn->status, KSMBD_SESS_RELEASING);
 }
 
diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 488ca113b431..9c6ca878d30f 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/freezer.h>
+#include <linux/uio.h>
 
 #include "smb_common.h"
 #include "server.h"
@@ -29,11 +30,30 @@ static LIST_HEAD(iface_list);
 
 static int bind_additional_ifaces;
 
+struct tcp_tx {
+	struct list_head		list;
+	size_t			len;
+	size_t			offset;
+	unsigned long		deadline;
+	int			msg_flags;
+	u8			data[];
+};
+
 struct tcp_transport {
 	struct ksmbd_transport		transport;
 	struct socket			*sock;
 	struct kvec			*iov;
 	unsigned int			nr_iov;
+	/* Serializes queue access and socket writes. Never taken by callbacks. */
+	struct mutex			tx_lock;
+	struct list_head		tx_queue;
+	struct delayed_work		tx_work;
+	size_t				tx_queued;
+	/* TCP byte positions for accepted PDUs and bytes passed to the socket. */
+	u64				tx_end;
+	u64				tx_sent;
+	bool				tx_stopped;
+	void				(*write_space)(struct sock *sk);
 };
 
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops;
@@ -42,6 +62,10 @@ static void tcp_stop_kthread(struct task_struct *kthread);
 static void ksmbd_tcp_stop_listener(struct interface *iface);
 static struct interface *alloc_iface(char *ifname);
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t);
+static void ksmbd_tcp_shutdown(struct ksmbd_transport *t);
+static void ksmbd_tcp_tx_work(struct work_struct *work);
+static void ksmbd_tcp_write_space(struct sock *sk);
+static void ksmbd_tcp_stop_tx(struct tcp_transport *t);
 
 #define KSMBD_TRANS(t)	(&(t)->transport)
 #define TCP_TRANS(t)	((struct tcp_transport *)container_of(t, \
@@ -66,6 +90,9 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	if (!t)
 		return NULL;
 	t->sock = client_sk;
+	mutex_init(&t->tx_lock);
+	INIT_LIST_HEAD(&t->tx_queue);
+	INIT_DELAYED_WORK(&t->tx_work, ksmbd_tcp_tx_work);
 
 	conn = ksmbd_conn_alloc();
 	if (!conn) {
@@ -86,13 +113,26 @@ static struct tcp_transport *alloc_transport(struct socket *client_sk)
 	conn->inet_addr = inet_sk(client_sk->sk)->inet_daddr;
 	conn->inet_hash = ipv4_addr_hash(inet_sk(client_sk->sk)->inet_daddr);
 #endif
-	down_write(&conn_list_lock);
-	hash_add(conn_list, &conn->hlist, conn->inet_hash);
-	up_write(&conn_list_lock);
-
 	conn->transport = KSMBD_TRANS(t);
 	KSMBD_TRANS(t)->conn = conn;
 	KSMBD_TRANS(t)->ops = &ksmbd_tcp_transport_ops;
+
+	lock_sock(client_sk->sk);
+	t->tx_end = tcp_sk(client_sk->sk)->bytes_acked +
+		(u32)(tcp_sk(client_sk->sk)->write_seq -
+		      tcp_sk(client_sk->sk)->snd_una);
+	t->tx_sent = t->tx_end;
+	release_sock(client_sk->sk);
+
+	write_lock_bh(&client_sk->sk->sk_callback_lock);
+	t->write_space = client_sk->sk->sk_write_space;
+	client_sk->sk->sk_user_data = t;
+	client_sk->sk->sk_write_space = ksmbd_tcp_write_space;
+	write_unlock_bh(&client_sk->sk->sk_callback_lock);
+
+	down_write(&conn_list_lock);
+	hash_add(conn_list, &conn->hlist, conn->inet_hash);
+	up_write(&conn_list_lock);
 	return t;
 }
 
@@ -100,6 +140,7 @@ static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 {
 	struct tcp_transport *t = TCP_TRANS(kt);
 
+	ksmbd_tcp_stop_tx(t);
 	sock_release(t->sock);
 	kfree(t->iov);
 	kfree(t);
@@ -107,7 +148,8 @@ static void ksmbd_tcp_free_transport(struct ksmbd_transport *kt)
 
 static void free_transport(struct tcp_transport *t)
 {
-	kernel_sock_shutdown(t->sock, SHUT_RDWR);
+	ksmbd_tcp_shutdown(KSMBD_TRANS(t));
+	ksmbd_tcp_stop_tx(t);
 	ksmbd_conn_free(KSMBD_TRANS(t)->conn);
 }
 
@@ -432,15 +474,251 @@ static int ksmbd_tcp_read(struct ksmbd_transport *t, char *buf,
 	return ksmbd_tcp_readv(TCP_TRANS(t), &iov, 1, to_read, max_retries);
 }
 
+static bool ksmbd_tcp_tx_has_space(struct tcp_transport *t, size_t size)
+{
+	size_t limit = max_t(size_t, READ_ONCE(t->sock->sk->sk_sndbuf), size);
+
+	/* Allow one large response, but bound the retained response buffers. */
+	return READ_ONCE(t->tx_queued) <= limit - size;
+}
+
+static struct tcp_tx *ksmbd_tcp_alloc_tx(const struct ksmbd_transport_write *tx,
+					 size_t offset)
+{
+	struct tcp_tx *msg;
+	struct iov_iter iter;
+	size_t remaining = tx->size - offset;
+
+	msg = kvmalloc(struct_size(msg, data, remaining), KSMBD_DEFAULT_GFP);
+	if (!msg)
+		return NULL;
+
+	iov_iter_kvec(&iter, ITER_SOURCE, tx->iov, tx->iov_cnt, tx->size);
+	iov_iter_advance(&iter, offset);
+	if (!copy_from_iter_full(msg->data, remaining, &iter)) {
+		kvfree(msg);
+		return NULL;
+	}
+	msg->len = remaining;
+	msg->offset = 0;
+	msg->msg_flags = tx->msg_flags;
+	return msg;
+}
+
+static void ksmbd_tcp_purge_tx(struct tcp_transport *t)
+{
+	struct tcp_tx *msg, *next;
+
+	list_for_each_entry_safe(msg, next, &t->tx_queue, list) {
+		list_del(&msg->list);
+		kvfree(msg);
+	}
+	WRITE_ONCE(t->tx_queued, 0);
+}
+
+static bool ksmbd_tcp_send_retry(int ret)
+{
+	return ret == -EAGAIN || ret == -EINTR || ret == -ERESTARTSYS ||
+		ret == -ENOMEM;
+}
+
+static void ksmbd_tcp_tx_work(struct work_struct *work)
+{
+	struct tcp_transport *t = container_of(to_delayed_work(work),
+					     struct tcp_transport, tx_work);
+	unsigned long delay = 0;
+	unsigned int budget = 16;
+	bool failed = false;
+	int ret;
+
+	mutex_lock(&t->tx_lock);
+	while (!READ_ONCE(t->tx_stopped) && !list_empty(&t->tx_queue) && budget--) {
+		struct tcp_tx *msg = list_first_entry(&t->tx_queue, struct tcp_tx, list);
+		struct msghdr hdr = {
+			.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | msg->msg_flags,
+		};
+		struct kvec iov = {
+			.iov_base = msg->data + msg->offset,
+			.iov_len = msg->len - msg->offset,
+		};
+
+		/* MSG_DONTWAIT bypasses sk_sndtimeo, including for retained PDUs. */
+		if (time_after_eq(jiffies, msg->deadline)) {
+			WRITE_ONCE(t->tx_stopped, true);
+			failed = true;
+			break;
+		}
+		ret = kernel_sendmsg(t->sock, &hdr, &iov, 1, iov.iov_len);
+		if (ret > 0) {
+			msg->offset += ret;
+			t->tx_sent += ret;
+			if (msg->offset == msg->len) {
+				WRITE_ONCE(t->tx_queued, t->tx_queued - msg->len);
+				list_del(&msg->list);
+				kvfree(msg);
+				continue;
+			}
+		} else if (!ksmbd_tcp_send_retry(ret)) {
+			WRITE_ONCE(t->tx_stopped, true);
+			failed = true;
+			break;
+		}
+		/*
+		 * Write-space notifications normally resume the head of the queue.
+		 * Also retry after memory pressure, which may produce no notification.
+		 */
+		delay = max_t(unsigned long, 1, HZ / 10);
+		break;
+	}
+	if (READ_ONCE(t->tx_stopped))
+		ksmbd_tcp_purge_tx(t);
+	else if (!list_empty(&t->tx_queue))
+		queue_delayed_work(system_unbound_wq, &t->tx_work, delay);
+	mutex_unlock(&t->tx_lock);
+	wake_up_all(&t->transport.conn->req_running_q);
+
+	if (failed)
+		ksmbd_conn_abort(t->transport.conn);
+}
+
+static void ksmbd_tcp_write_space(struct sock *sk)
+{
+	struct tcp_transport *t;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	t = sk->sk_user_data;
+	if (t) {
+		t->write_space(sk);
+		if (!READ_ONCE(t->tx_stopped) && sk_stream_is_writeable(sk))
+			mod_delayed_work(system_unbound_wq, &t->tx_work, 0);
+	}
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
+static void ksmbd_tcp_stop_tx(struct tcp_transport *t)
+{
+	struct sock *sk = t->sock->sk;
+
+	WRITE_ONCE(t->tx_stopped, true);
+	write_lock_bh(&sk->sk_callback_lock);
+	if (sk->sk_user_data == t) {
+		sk->sk_write_space = t->write_space;
+		sk->sk_user_data = NULL;
+	}
+	write_unlock_bh(&sk->sk_callback_lock);
+	cancel_delayed_work_sync(&t->tx_work);
+	mutex_lock(&t->tx_lock);
+	ksmbd_tcp_purge_tx(t);
+	mutex_unlock(&t->tx_lock);
+	wake_up_all(&t->transport.conn->req_running_q);
+}
+
 static int ksmbd_tcp_writev(struct ksmbd_transport *t,
 			    const struct ksmbd_transport_write *tx)
 {
-	struct msghdr smb_msg = {
-		.msg_flags = MSG_NOSIGNAL | tx->msg_flags,
+	struct tcp_transport *tt = TCP_TRANS(t);
+	struct sock *sk = tt->sock->sk;
+	struct msghdr hdr = {
+		.msg_flags = MSG_NOSIGNAL | MSG_DONTWAIT | tx->msg_flags,
 	};
+	struct tcp_tx *msg;
+	unsigned long deadline = jiffies + KSMBD_TCP_SEND_TIMEOUT;
+	long timeout;
+	int sent = 0;
+
+	for (;;) {
+		if (tx->msg_flags & MSG_DONTWAIT) {
+			if (!mutex_trylock(&tt->tx_lock))
+				return -EAGAIN;
+		} else {
+			mutex_lock(&tt->tx_lock);
+		}
+		if (READ_ONCE(tt->tx_stopped) || ksmbd_conn_exiting(t->conn) ||
+		    ksmbd_conn_releasing(t->conn)) {
+			mutex_unlock(&tt->tx_lock);
+			return -EPIPE;
+		}
+		if (ksmbd_tcp_tx_has_space(tt, tx->size))
+			break;
+		mutex_unlock(&tt->tx_lock);
+		if (tx->msg_flags & MSG_DONTWAIT)
+			return -EAGAIN;
+		timeout = deadline - jiffies;
+		if (time_after_eq(jiffies, deadline) ||
+		    !wait_event_timeout(t->conn->req_running_q,
+					READ_ONCE(tt->tx_stopped) ||
+					ksmbd_conn_exiting(t->conn) ||
+					ksmbd_conn_releasing(t->conn) ||
+					ksmbd_tcp_tx_has_space(tt, tx->size),
+					timeout)) {
+			/* A queued PDU may already have a prefix in the socket. */
+			ksmbd_conn_abort(t->conn);
+			return -EAGAIN;
+		}
+	}
 
-	return kernel_sendmsg(TCP_TRANS(t)->sock, &smb_msg, tx->iov,
-			      tx->iov_cnt, tx->size);
+	/* Avoid an extra copy when the socket accepts the whole PDU at once. */
+	if (list_empty(&tt->tx_queue)) {
+		sent = kernel_sendmsg(tt->sock, &hdr, tx->iov, tx->iov_cnt, tx->size);
+		if (sent > 0) {
+			tt->tx_sent += sent;
+			if (sent == tx->size)
+				goto accepted;
+		} else if (ksmbd_tcp_send_retry(sent)) {
+			sent = 0;
+		} else {
+			WRITE_ONCE(tt->tx_stopped, true);
+			mutex_unlock(&tt->tx_lock);
+			ksmbd_conn_abort(t->conn);
+			return sent ?: -EPIPE;
+		}
+	}
+
+	/* The request buffers can be freed as soon as writev returns. */
+	msg = ksmbd_tcp_alloc_tx(tx, sent);
+	if (!msg) {
+		if (sent)
+			WRITE_ONCE(tt->tx_stopped, true);
+		mutex_unlock(&tt->tx_lock);
+		if (sent)
+			ksmbd_conn_abort(t->conn);
+		return -ENOMEM;
+	}
+	msg->deadline = deadline;
+	list_add_tail(&msg->list, &tt->tx_queue);
+	WRITE_ONCE(tt->tx_queued, tt->tx_queued + msg->len);
+	queue_delayed_work(system_unbound_wq, &tt->tx_work, 0);
+
+accepted:
+	tt->tx_end += tx->size;
+	if (tx->tracking) {
+		/* Include retained data, without retaining the caller's tracking object. */
+		tx->tracking->end = tt->tx_end;
+		lock_sock(sk);
+		tx->tracking->retry_after =
+			clamp_t(unsigned long, 6UL * inet_csk(sk)->icsk_rto,
+				msecs_to_jiffies(1200), 6 * HZ);
+		release_sock(sk);
+		tx->tracking->valid = true;
+	}
+	mutex_unlock(&tt->tx_lock);
+	return tx->size;
+}
+
+static bool ksmbd_tcp_is_acked(struct ksmbd_transport *t,
+			     const struct ksmbd_tx_tracking *tracking)
+{
+	struct tcp_transport *tt = TCP_TRANS(t);
+	struct sock *sk = tt->sock->sk;
+	bool acked;
+
+	mutex_lock(&tt->tx_lock);
+	lock_sock(sk);
+	acked = tt->tx_sent >= tracking->end &&
+		tcp_sk(sk)->bytes_acked >= tracking->end;
+	release_sock(sk);
+	mutex_unlock(&tt->tx_lock);
+	return acked;
 }
 
 static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
@@ -452,7 +730,9 @@ static void ksmbd_tcp_disconnect(struct ksmbd_transport *t)
 
 static void ksmbd_tcp_shutdown(struct ksmbd_transport *t)
 {
+	WRITE_ONCE(TCP_TRANS(t)->tx_stopped, true);
 	kernel_sock_shutdown(TCP_TRANS(t)->sock, SHUT_RDWR);
+	wake_up_all(&t->conn->req_running_q);
 }
 
 static void tcp_destroy_socket(struct socket *ksmbd_socket)
@@ -721,6 +1001,7 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 static const struct ksmbd_transport_ops ksmbd_tcp_transport_ops = {
 	.read		= ksmbd_tcp_read,
 	.writev		= ksmbd_tcp_writev,
+	.is_acked	= ksmbd_tcp_is_acked,
 	.disconnect	= ksmbd_tcp_disconnect,
 	.shutdown	= ksmbd_tcp_shutdown,
 	.free_transport = ksmbd_tcp_free_transport,
-- 
2.25.1

