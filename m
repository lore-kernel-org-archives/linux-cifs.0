Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBE9441022
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385346; cv=none; b=X20SBVRWL11VyMwE8JUJejMJtgtiS+NCJ4lBEftNhOo95qzem/C42HgmiYci7n9E+5dP81Wm8a4VBfAbdq0Py5y10c+rucaGv1mC9pmyP0IoGhTOX6pJuQ7+xa5FVDLdkjeIBS2inXufPKCq2L6kG35hNf0KEnP0E//nRQi04QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385346; c=relaxed/simple;
	bh=KGBe/gwXXssI0g1Bu4ClISnGFi2PC+zHggOckt79b48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2W91fWQy5eGqaqhK+w0tFqayJIz15oW7IjhnxDUiozQ7DiaQhHRdyNddhVLBf0cVwuRUcAWkumkDHNf8I8HwbhCdtt8fbutBwfX2yHiihEGnD0qN5S33oF1Qu9TuVjtEp+bbxNPKk66XTTwU9Tv+oBhlLzgmt7FKb7VacpQky8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nz0374Sj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nz0374Sj"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ae3a007bd1so12993995ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 07:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777385344; x=1777990144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEgePd5kGimwA7FpQCQXmU75w1iF7H1t3sq7wQi6GBA=;
        b=Nz0374SjEAiL7moB3moFwnI6h8XRFjSgEzQE3MdlB33qVntujG+Z3Rkxr5jN3io4wh
         qK39zCSBRcuHD9jxmZ4Pu/7NL+uf5r+F2hKxu/fRkJMciJCh/XbMSu+WjRwNHBaVX1tO
         ouzuhIcv4mqftuf5MqACYSda3WJ5EsfH9J+jK8nn5YeGgtqsK7/966j/Y/PcMyNuri7Q
         ivTP8egx6APQk2k2uwjaO5cDaCU/7p5OMYpbftCQMmiOxrqilIwRQ2lilYNZbljBSoLl
         KKohNRtKc/2OWejfcTpwqtR3ebVRzRiD0AgCfNE5mIUxvtJyIDjuuKVKC9rwW5CWR/+y
         5KGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777385344; x=1777990144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uEgePd5kGimwA7FpQCQXmU75w1iF7H1t3sq7wQi6GBA=;
        b=d0Gs3VMHTtwg1u1ntqb3BSwBODrjxJ3ehF2AKjftj+U1Cp6qqT2LgKHVZXM03Ym/Ay
         4EmV9uQUzUlee3NtAUSpsfZuVJlqjn6zV/HilLtfBWmxDFicRTBeLFTKtAQXgzagmgZK
         Sa5JJtC266mFS3OA+IUc9zGITkbWTncH84BYVfAb+omi4phcID8PlqXVKATAWticxWzC
         jw3hcchpCu5PkWjXKI6fhzuxTF8uq7xUgJs93mWkKzf8HUuygGyG/YZxcZ6vKhjN6KWI
         Hb6ScMdS3Y57dTy0eNYvVMRL/D3jN+Zic24mhi2XZ9o4zLfqdtrzU9jADfYEchZrue4Q
         N3Hg==
X-Forwarded-Encrypted: i=1; AFNElJ+afwijMZMhesK6w3pbYCLQf2a/peWd/B7bPhPmGsILAqjqF0eStNCkzy9tREq96ZLDzgUrSA+KMpNI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/iGXZ+ph893irOkeaHnGuQGNMFDBwDXHDzBnsq8qZeKr0vH6s
	jyIbWHsvRcWiHlQyTNbiUnBn1pKD4YRI0MlXOgQjJilnk77YOna+GbT8
X-Gm-Gg: AeBDiesdldWfoQ+oKnuFMqqIfNMz77Bitn/H3VWLmU13wimozhSe6h3/WeSfCR2Q9Uq
	vyuR6ccIjeRSeZuVACxd54WF9cCmrLlgOjKZf3cT/kXZfh7sJeTd4KDC69V7L796UziSJA3s8uT
	BMIy5PwkFdNyRyrpxbDtXYRJBXEdDzBXDh5sP5mv/m54FIM+d5s+C6kqidtCnxUCAaKpfb6lb61
	y/mK2kQyvQfUAmWhmdiqMY0NTyrgDh5ZDs3zd+dZnOslXJoRCkdyMlf/lkq9cJJz2P7xA70URIR
	SrY2+fu2SeiLtB5JBJt8xg/CHniB/eVX9HAtkY5KA/Ms39kp1K79k1rw0nY6CZFU/7y4FEY4SvP
	Y/hVVfogbZoDEH0bbGRB+swzpRKj4ygt3webRq/G55MDOS++pwlZlCkXMpMTgWsATmDE8U1WD2/
	REz6MOpitvRXs7c7SO/HJ4ZYjnruc=
X-Received: by 2002:a05:6300:4047:b0:3a1:6a7c:dba5 with SMTP id adf61e73a8af0-3a398e6360emr2347405637.6.1777385343908;
        Tue, 28 Apr 2026 07:09:03 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fcade0f56sm2190526a12.21.2026.04.28.07.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 07:09:03 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2 1/3] ksmbd: centralize ksmbd_conn final release to plug transport leak
Date: Tue, 28 Apr 2026 23:08:54 +0900
Message-ID: <20260428140856.941847-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428140856.941847-1-charsyam@gmail.com>
References: <20260428140856.941847-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_conn_free() is one of four sites that can observe the last
refcount drop of a struct ksmbd_conn.  The other three

    fs/smb/server/connection.c    ksmbd_conn_r_count_dec()
    fs/smb/server/oplock.c        __free_opinfo()
    fs/smb/server/vfs_cache.c     session_fd_check()

end the conn with a bare kfree(), skipping
ida_destroy(&conn->async_ida) and
conn->transport->ops->free_transport(conn->transport).  Whenever one
of them is the last putter, the embedded async_ida and the entire
transport struct leak -- for TCP, that is also the struct socket and
the kvec iov.

__free_opinfo() being a final putter is not theoretical.  opinfo_put()
queues the callback via call_rcu(&opinfo->rcu, free_opinfo_rcu), so
ksmbd_server_terminate_conn() can deposit N opinfo releases in RCU and
have ksmbd_conn_free() run in the handler thread before any of them
fire.  ksmbd_conn_free() then observes refcnt > 0 and short-circuits;
the last RCU-delivered __free_opinfo() falls onto its bare kfree(conn)
branch and the transport is lost.

A/B validation in a QEMU/virtme guest, mounting //127.0.0.1/testshare:
each iteration holds 8 files open via sleep processes, force-closes
TCP with "ss -K sport = :445", kills the holders, lazy-umounts;
repeated 10 times, then ksmbd shutdown and kmemleak scan.

    state         conn_alloc  conn_free  tcp_free  opi_rcu  kmemleak
    ----------    ----------  ---------  --------  -------  --------
    pre-patch         20          20        10       160        7
    with patch        20          20        20       160        0

Pre-patch conn_free=20 with tcp_free=10 directly demonstrates the
bare-kfree paths skipping transport cleanup; kmemleak backtraces point
into struct tcp_transport / iov.  With this patch tcp_free matches
conn_free at 20/20 and kmemleak is clean.

Move the per-struct final release into __ksmbd_conn_release_work() and
route the three bare-kfree final-put sites through a new
ksmbd_conn_put().  Those sites now pair ida_destroy() and
free_transport() with kfree(conn) regardless of which holder happens
to release the last reference.  stop_sessions() only triggers the
transport shutdown and does not itself drop the last conn reference,
so it is unaffected.

The centralized release reaches sock_release() -> tcp_close() ->
lock_sock_nested() (might_sleep) from every final putter, including
__free_opinfo() invoked from an RCU softirq callback, which trips
CONFIG_DEBUG_ATOMIC_SLEEP.  Defer the release to a dedicated
ksmbd_conn_wq workqueue so ksmbd_conn_put() is safe from any
non-sleeping context.

Make ksmbd_file own a strong connection reference while fp->conn is
non-NULL so durable-preserve and final-close paths cannot dereference
a stale connection.  ksmbd_open_fd() and ksmbd_reopen_durable_fd()
take the reference via ksmbd_conn_get() (the latter also reorders the
fp->conn / fp->tcon assignments before __open_id() so the published fp
is never observed with fp->conn == NULL); session_fd_check() and
__ksmbd_close_fd() drop it via ksmbd_conn_put().  With that invariant,
session_fd_check() can take a local conn pointer once and use it
across the m_op_list and lock_list iterations even though op->conn
puts may otherwise drop the last reference.

At module exit the workqueue is flushed and destroyed after
rcu_barrier(), so any release queued by a trailing RCU callback is
drained before the inode hash and module text go away.

Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/connection.c | 101 +++++++++++++++++++++++++++++++------
 fs/smb/server/connection.h |   6 +++
 fs/smb/server/oplock.c     |   7 +--
 fs/smb/server/server.c     |  12 +++++
 fs/smb/server/vfs_cache.c  |  60 ++++++++++++++++++----
 5 files changed, 156 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index fbbc0529743f..fc9b35d41185 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -79,6 +79,81 @@ static int create_proc_clients(void) { return 0; }
 static void delete_proc_clients(void) {}
 #endif
 
+static struct workqueue_struct *ksmbd_conn_wq;
+
+int ksmbd_conn_wq_init(void)
+{
+	ksmbd_conn_wq = alloc_workqueue("ksmbd-conn-release",
+					WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!ksmbd_conn_wq)
+		return -ENOMEM;
+	return 0;
+}
+
+void ksmbd_conn_wq_destroy(void)
+{
+	if (ksmbd_conn_wq) {
+		destroy_workqueue(ksmbd_conn_wq);
+		ksmbd_conn_wq = NULL;
+	}
+}
+
+/*
+ * __ksmbd_conn_release_work() - perform the final, once-per-struct cleanup
+ * of a ksmbd_conn whose refcount has just dropped to zero.
+ *
+ * This is the common release path used by ksmbd_conn_put() for the embedded
+ * state that outlives the connection thread: async_ida and the attached
+ * transport (which owns the socket and iov for TCP).  Called from a workqueue
+ * so that sleep-allowed teardown (sock_release -> tcp_close ->
+ * lock_sock_nested) never runs from an RCU softirq callback (free_opinfo_rcu)
+ * or any other non-sleeping putter context.
+ */
+static void __ksmbd_conn_release_work(struct work_struct *work)
+{
+	struct ksmbd_conn *conn =
+		container_of(work, struct ksmbd_conn, release_work);
+
+	ida_destroy(&conn->async_ida);
+	conn->transport->ops->free_transport(conn->transport);
+	kfree(conn);
+}
+
+/**
+ * ksmbd_conn_get() - take a reference on @conn and return it.
+ *
+ * Returns @conn unchanged so callers can write
+ * "fp->conn = ksmbd_conn_get(work->conn);" in one expression.  Returns NULL
+ * if @conn is NULL.
+ */
+struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn)
+{
+	if (!conn)
+		return NULL;
+
+	atomic_inc(&conn->refcnt);
+	return conn;
+}
+
+/**
+ * ksmbd_conn_put() - drop a reference and, if it was the last, queue the
+ * release onto ksmbd_conn_wq so it runs from process context.
+ *
+ * Callable from any context including RCU softirq callbacks and non-sleeping
+ * locks; the actual release is deferred to the workqueue.  ksmbd_conn_wq is
+ * created in ksmbd_server_init() before any conn can be allocated and is
+ * destroyed in ksmbd_server_exit() after rcu_barrier(), so it is always
+ * non-NULL while a conn reference is held.
+ */
+void ksmbd_conn_put(struct ksmbd_conn *conn)
+{
+	if (!conn)
+		return;
+
+	if (atomic_dec_and_test(&conn->refcnt))
+		queue_work(ksmbd_conn_wq, &conn->release_work);
+}
+
 /**
  * ksmbd_conn_free() - free resources of the connection instance
  *
@@ -93,23 +168,19 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
 	hash_del(&conn->hlist);
 	up_write(&conn_list_lock);
 
+	/*
+	 * request_buf / preauth_info / mechToken are only ever accessed by the
+	 * connection handler thread that owns @conn.  ksmbd_conn_free() is
+	 * called from the transport free_transport() path when that thread is
+	 * exiting, so it is safe to release them unconditionally even when
+	 * ksmbd_conn_put() below is not the final putter (oplock / ksmbd_file
+	 * holders only retain the conn pointer, not these per-thread buffers).
+	 */
 	xa_destroy(&conn->sessions);
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
-	if (atomic_dec_and_test(&conn->refcnt)) {
-		/*
-		 * async_ida is embedded in struct ksmbd_conn, so pair
-		 * ida_destroy() with the final kfree() rather than with
-		 * the unconditional field teardown above.  This keeps
-		 * the IDA valid for the entire lifetime of the struct,
-		 * even while other refcount holders (oplock / vfs
-		 * durable handles) still reference the connection.
-		 */
-		ida_destroy(&conn->async_ida);
-		conn->transport->ops->free_transport(conn->transport);
-		kfree(conn);
-	}
+	ksmbd_conn_put(conn);
 }
 
 /**
@@ -136,6 +207,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		conn->um = ERR_PTR(-EOPNOTSUPP);
 	if (IS_ERR(conn->um))
 		conn->um = NULL;
+	INIT_WORK(&conn->release_work, __ksmbd_conn_release_work);
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	atomic_set(&conn->refcnt, 1);
@@ -512,8 +584,7 @@ void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn)
 	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
 		wake_up(&conn->r_count_q);
 
-	if (atomic_dec_and_test(&conn->refcnt))
-		kfree(conn);
+	ksmbd_conn_put(conn);
 }
 
 int ksmbd_conn_transport_init(void)
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index ae21a1bd4c70..e95cb4ed0b3f 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/nls.h>
 #include <linux/unicode.h>
+#include <linux/workqueue.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
@@ -119,6 +120,7 @@ struct ksmbd_conn {
 	bool				binding;
 	atomic_t			refcnt;
 	bool				is_aapl;
+	struct work_struct		release_work;
 };
 
 struct ksmbd_conn_ops {
@@ -163,6 +165,10 @@ void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
 int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
+struct ksmbd_conn *ksmbd_conn_get(struct ksmbd_conn *conn);
+void ksmbd_conn_put(struct ksmbd_conn *conn);
+int ksmbd_conn_wq_init(void);
+void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index cd3f28b0e7cb..8feca02ddbf2 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -30,7 +30,6 @@ static DEFINE_RWLOCK(lease_list_lock);
 static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 					u64 id, __u16 Tid)
 {
-	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct oplock_info *opinfo;
 
@@ -39,7 +38,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 		return NULL;
 
 	opinfo->sess = sess;
-	opinfo->conn = conn;
+	opinfo->conn = ksmbd_conn_get(work->conn);
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	opinfo->pending_break = 0;
@@ -50,7 +49,6 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
 	atomic_set(&opinfo->breaking_cnt, 0);
-	atomic_inc(&opinfo->conn->refcnt);
 
 	return opinfo;
 }
@@ -132,8 +130,7 @@ static void __free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
-	if (opinfo->conn && atomic_dec_and_test(&opinfo->conn->refcnt))
-		kfree(opinfo->conn);
+	ksmbd_conn_put(opinfo->conn);
 	kfree(opinfo);
 }
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 58ef02c423fc..5d799b2d4c62 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -596,8 +596,14 @@ static int __init ksmbd_server_init(void)
 	if (ret)
 		goto err_crypto_destroy;
 
+	ret = ksmbd_conn_wq_init();
+	if (ret)
+		goto err_workqueue_destroy;
+
 	return 0;
 
+err_workqueue_destroy:
+	ksmbd_workqueue_destroy();
 err_crypto_destroy:
 	ksmbd_crypto_destroy();
 err_release_inode_hash:
@@ -623,6 +629,12 @@ static void __exit ksmbd_server_exit(void)
 {
 	ksmbd_server_shutdown();
 	rcu_barrier();
+	/*
+	 * ksmbd_conn_put() defers the final release onto ksmbd_conn_wq,
+	 * so drain it after rcu_barrier() has fired any pending RCU
+	 * callbacks that may have queued a release.
+	 */
+	ksmbd_conn_wq_destroy();
 	ksmbd_release_inode_hash();
 }
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 3551f01a3fa0..4a18107937cc 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -475,6 +475,17 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 		kfree(smb_lock);
 	}
 
+	/*
+	 * Drop fp's strong reference on conn (taken in ksmbd_open_fd() /
+	 * ksmbd_reopen_durable_fd()).  Durable fps that reached the
+	 * scavenger have already had fp->conn cleared by session_fd_check(),
+	 * in which case there is nothing to drop here.
+	 */
+	if (fp->conn) {
+		ksmbd_conn_put(fp->conn);
+		fp->conn = NULL;
+	}
+
 	if (ksmbd_stream_fd(fp))
 		kfree(fp->stream.name);
 	kfree(fp->owner.name);
@@ -752,7 +763,14 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
-	fp->conn		= work->conn;
+	/*
+	 * fp owns a strong reference on fp->conn for as long as fp->conn is
+	 * non-NULL, so session_fd_check() and __ksmbd_close_fd() never
+	 * dereference a dangling pointer.  Paired with ksmbd_conn_put() in
+	 * session_fd_check() (durable preserve), in __ksmbd_close_fd()
+	 * (final close), and on the error paths below.
+	 */
+	fp->conn		= ksmbd_conn_get(work->conn);
 	fp->tcon		= work->tcon;
 	fp->volatile_id		= KSMBD_NO_FID;
 	fp->persistent_id	= KSMBD_NO_FID;
@@ -774,6 +792,8 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	return fp;
 
 err_out:
+	/* fp->conn was set and refcounted before every branch here. */
+	ksmbd_conn_put(fp->conn);
 	kmem_cache_free(filp_cache, fp);
 	return ERR_PTR(ret);
 }
@@ -1062,25 +1082,32 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	if (!is_reconnectable(fp))
 		return false;
 
+	if (WARN_ON_ONCE(!fp->conn))
+		return false;
+
 	if (ksmbd_vfs_copy_durable_owner(fp, user))
 		return false;
 
+	/*
+	 * fp owns a strong reference on fp->conn (taken in ksmbd_open_fd()
+	 * / ksmbd_reopen_durable_fd()), so conn stays valid for the whole
+	 * body of this function regardless of any op->conn puts below.
+	 */
 	conn = fp->conn;
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn != conn)
 			continue;
-		if (op->conn && atomic_dec_and_test(&op->conn->refcnt))
-			kfree(op->conn);
+		ksmbd_conn_put(op->conn);
 		op->conn = NULL;
 	}
 	up_write(&ci->m_lock);
 
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		spin_lock(&fp->conn->llist_lock);
+		spin_lock(&conn->llist_lock);
 		list_del_init(&smb_lock->clist);
-		spin_unlock(&fp->conn->llist_lock);
+		spin_unlock(&conn->llist_lock);
 	}
 
 	fp->conn = NULL;
@@ -1091,6 +1118,8 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 		fp->durable_scavenger_timeout =
 			jiffies_to_msecs(jiffies) + fp->durable_timeout;
 
+	/* Drop fp's own reference on conn. */
+	ksmbd_conn_put(conn);
 	return true;
 }
 
@@ -1178,15 +1207,27 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 
 	old_f_state = fp->f_state;
 	fp->f_state = FP_NEW;
+
+	/*
+	 * Initialize fp's connection binding before publishing fp into the
+	 * session's file table.  If __open_id() is ordered first, a
+	 * concurrent teardown that iterates the table can observe a valid
+	 * volatile_id with fp->conn == NULL and preserve a
+	 * partially-initialized fp.  fp owns a strong reference on the new
+	 * conn (see ksmbd_open_fd()); undo it on __open_id() failure.
+	 */
+	fp->conn = ksmbd_conn_get(conn);
+	fp->tcon = work->tcon;
+
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (!has_file_id(fp->volatile_id)) {
+		fp->conn = NULL;
+		fp->tcon = NULL;
+		ksmbd_conn_put(conn);
 		fp->f_state = old_f_state;
 		return -EBADF;
 	}
 
-	fp->conn = conn;
-	fp->tcon = work->tcon;
-
 	list_for_each_entry(smb_lock, &fp->lock_list, flist) {
 		spin_lock(&conn->llist_lock);
 		list_add_tail(&smb_lock->clist, &conn->lock_list);
@@ -1198,8 +1239,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
 		if (op->conn)
 			continue;
-		op->conn = fp->conn;
-		atomic_inc(&op->conn->refcnt);
+		op->conn = ksmbd_conn_get(fp->conn);
 	}
 	up_write(&ci->m_lock);
 
-- 
2.43.0

