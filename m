Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8DF38B12C
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 09:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777109932; cv=none; b=cMTrpoTCQpXX+v7S5Rjl5Avu9cpws+vRNRhUo7ksDZKdZ3X+T6LuXVFnNZpXTMiT6OTxnt10V78TLafyYgGgSnOPtJMLnLywjy23dWZlV6RTRr9mcLL5dLDfdxGYJ8WaLO8IuU/Ig8tDPa4WZr2kGwYbuPvIx3SZ7cdWgDdpF0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777109932; c=relaxed/simple;
	bh=vLXb7ugMCCE+MqTlVuyJxG9Yf4Bgq1xnSh9pyLx2sbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2GR11HuZGGxxRJoNF+tddIS/Mx/drN5YQcJrpFTJ7DOIXgei7/GhW1KE6ptyD299s61UAGkrD+LeH82Oz4ExCrieCcgkFKWY4rrhUgOflZTeCRoUH183G6kd9TSSj8ezgVaonpyFADvGES8p/O/zlBcMxC1l6z4jsJB70QT9/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OxBHlE+N; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OxBHlE+N"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d901060f6so1710769a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 02:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777109929; x=1777714729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xU3Yw2OSZmM/2qmw+RTJFnRRSGp4FPsoUSqHBFDOncs=;
        b=OxBHlE+NPe776LkNam9Mh/v3lrs5EWZOGYQ5prj5H3wDBloVx7/4psp86iem/EQDs/
         kBFUfHvnJ2gQQQDB9Mor3PLvd+VITF50BbgkdVnqp7wDnql+ZfdHNZJM1M6Axf1BKVex
         7rBhA6ZBvReRXzuH942YLdI2mjQuva8pJ9X+cIQhIyU5rC6Hb5Yvbk/YJJGq+lYE1Jg4
         jxf2T6YQIL8WQDPvtf/OQrF+IlrCJSxGlRPfkk/t/hkZUIwGH7zF2hLC8hmNroS2H5sb
         nlgmOIqMaP095TI3HFU+IAbtJrar/3WXPaIzqyUR3WVCfzF9zyGQCRaMGwfpUvlEvcY3
         SGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777109929; x=1777714729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xU3Yw2OSZmM/2qmw+RTJFnRRSGp4FPsoUSqHBFDOncs=;
        b=Fc94Llw8vxszaTQ7POWWAX7+1ZuPdZJKUce3hwRyAn7X1VppjC07g5O3bEHwjWQYn7
         u+A8CWUOua3a9xpTaVn8F0QqTh5nLJ/LIAtddBkes0qRyg4bz+j5pk2ZFryyjoi6hwno
         cmJt5G6S9um1Tj50hNnp2i9whxAUJpCgW+vmV2PrAsZcHyYC4AwfnjLarm9JhHTAzI5y
         7nMtvFgeUF7zt8W0u+4VrVdOalGNRdgzUn/P6BHA4yN0ZZ10BWY5h0xY/bA5N+yH5I8b
         CRAj8j9qIuW8P8MoJUnLMAjNFVxTjoJzUEwMSiPmGDip6d0HU82B76K4RiDQmwHC1bp4
         p99g==
X-Forwarded-Encrypted: i=1; AFNElJ8u/J2cpc5RyIt1yCyFwHGpIi6ZY3+sBko6n5WMm5tEGDxVLzbRyDckx+/AjU6275cOdg2uEO70XxG4@vger.kernel.org
X-Gm-Message-State: AOJu0Ywjou8KZeS/B57Tn2w4en05pKXb8XRZNz5eGuquLTCAHvIrsGq0
	gOMhXGy4n3Os+3Vv/NHvKoNryQIP2pFAUfchH+T+eGDpxSYydYTYs4+JKC+7JnZJ
X-Gm-Gg: AeBDiesIQxDz1Xt532aDOkZ6la/mWcoZXiXU+FbQzM6ujL9nfYFA76iIgdE2lHzbnLX
	jm37zarTcfJHLWQHlHfH3nX0a0adaFrkSJdxTTd4SSteEERqDDu3jY+uhKijuhEcQWg9CxfaS4w
	fV6mrEffqwXAtlmfGiSz3NmAYqrYQxGApyGjg1oDjy0ZBlwFpwsLwCEi3DAfGcX4MKVgueTCrCX
	dg82RWpVgf6H/nEcUczn5pzDFNq24rMqWgXTVti4ZQORDI9JZ+3Vgt3nhV3LAQ8oSAR8VucgKdZ
	zOVKXwzGpF17N2/YKZYMFv60nnUIlrJFz9B8dcnW4+Qt/znDADyhE/cY9Y7ZKl72YEAIKOExTC+
	dumignINfDW9rKz1bJ5c9vk2tVW8DacCHH3/mTyMygdYyE2CvzqmM50qsPHN4XxtWuDr8+eL7Wl
	JvV7P4xFz8+kAEJ4cCLGZTtwcNsBA=
X-Received: by 2002:a17:903:1a6b:b0:2b9:42a3:6013 with SMTP id d9443c01a7336-2b942a361famr13236185ad.1.1777109928798;
        Sat, 25 Apr 2026 02:38:48 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b606ce9891sm206791725ad.83.2026.04.25.02.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Apr 2026 02:38:48 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 2/2] ksmbd: centralize ksmbd_conn final release to plug transport leak
Date: Sat, 25 Apr 2026 18:38:29 +0900
Message-ID: <20260425093829.4004785-3-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260425093829.4004785-1-charsyam@gmail.com>
References: <20260425093829.4004785-1-charsyam@gmail.com>
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

Reproducer (QEMU/virtme guest, ksmbd server and CIFS client in the
same guest, mounting //127.0.0.1/testshare): each iteration holds 8
files open via sleep processes, force-closes TCP with
`ss -K sport = :445`, kills the holders, lazy-umounts; repeated 10
times, then ksmbd shutdown and kmemleak scan.

Kprobes: ksmbd_conn_alloc, ksmbd_conn_free, ksmbd_tcp_free_transport,
free_opinfo_rcu.  (ksmbd_tcp_new_connection did not register stably
so ksmbd_conn_alloc is the lifecycle anchor.)

A/B validation, same image, varying only ksmbd.ko.  Pre-patch is HEAD
with only patch 1 of this series applied:

    state         conn_alloc  conn_free  tcp_free  opi_rcu  kmemleak
    ----------    ----------  ---------  --------  -------  --------
    pre-patch         20          20        10       160        7
    with patch        20          20        20       160        0

Pre-patch conn_free=20 with tcp_free=10 directly demonstrates the
bare-kfree paths skipping transport cleanup, and kmemleak reports 7
unreferenced allocations whose backtraces point into the ksmbd text
(struct tcp_transport, t->iov kvec).  With this patch tcp_free matches
conn_free at 20/20 and kmemleak is clean across two independent
post-patch runs.  opi_rcu=160 confirms the RCU opinfo release path
that motivates the fix is exercised.  The transport leak fix is
established by this A/B comparison.

Move the per-struct final release into __ksmbd_conn_release_work() and
route the three bare-kfree final-put sites through a new
ksmbd_conn_put().  Those sites now pair ida_destroy() and
free_transport() with kfree(conn) regardless of which holder happens
to release the last reference.  The stop_sessions() path keeps patch
1's local pin-drop cleanup open-coded instead of routing that
temporary reference through ksmbd_conn_put(), so this patch does not
layer the conn-put conversion on top of the stop_sessions() iteration
rewrite and the two fixes remain independently reviewable and
revertible.  Applying this patch alone still leaves stop_sessions()
on its own local cleanup; patch 1 fixes that site separately.

The centralized release reaches sock_release() -> tcp_close() ->
lock_sock_nested() from every final putter.  lock_sock_nested() has
might_sleep(), and __free_opinfo() can be released from an RCU
callback (free_opinfo_rcu(), softirq on default kernels).  Calling
the final release directly from that path trips
CONFIG_DEBUG_ATOMIC_SLEEP:

    BUG: sleeping function called from invalid context at net/core/sock.c:3785
    in_atomic(): 1, irqs_disabled(): 0, non_block: 0
    Call Trace:
     <IRQ>
     lock_sock_nested+0x43/0xa0
     tcp_close+0x19/0xa0
     inet_release+0x44/0x90
     sock_release+0x25/0x90
     ksmbd_tcp_free_transport+0x16/0x40 [ksmbd]
     __ksmbd_conn_release_work+0x... [ksmbd]
     ksmbd_conn_put+0x... [ksmbd]
     free_opinfo_rcu+0x... [ksmbd]
     rcu_do_batch+0x1e5/0x5c0
     rcu_core+0x395/0x4d0

Handle this once inside ksmbd_conn_put() by making the final release
unconditional through a dedicated ksmbd_conn_wq workqueue.  When the
refcount reaches zero, ksmbd_conn_put() queues the pre-initialized
release_work onto the workqueue and returns; the work handler runs
the sleep-allowed teardown (ida_destroy,
free_transport -> sock_release, kfree) in process context.  That makes
ksmbd_conn_put() safe to call from RCU callbacks and other
non-sleeping putter contexts without each call site needing its own
bounce.

Moving the final release onto a workqueue is not by itself enough on
the session_fd_check() path: __close_file_table_ids() holds
write_lock(&ft->lock) across the skip callback, and
session_fd_check() already sleeps in
ksmbd_vfs_copy_durable_owner() -> kstrdup(GFP_KERNEL) and
down_write(&fp->f_ci->m_lock) (a rw_semaphore) before it ever reaches
ksmbd_conn_put().  These sleeps pre-date this patch but would
equally trip CONFIG_DEBUG_ATOMIC_SLEEP on a durable-fd workload.
Refactor __close_file_table_ids() to take a transient reference on
fp and unpublish fp from the session idr *under ft->lock* before
calling skip() outside the lock.  A transient ref protects lifetime
but not concurrent field mutation, so the idr_remove() is what keeps
__ksmbd_lookup_fd() through this session's idr from granting a new
ksmbd_fp_get() reference to an fp whose fp->conn / fp->tcon /
fp->volatile_id / op->conn / lock_list links are about to be rewritten
by session_fd_check().  The same unpublished transition also clears
fp->volatile_id under ft->lock, preventing any later final close of
the same fp from removing a reused idr slot.  Durable reconnect is
unaffected because it reaches fp through the global durable table
(ksmbd_lookup_durable_fd -> global_ft).

After skip() returns, the preserve path drops the transient with
atomic_dec(): fp keeps the original +1 refcount that used to represent
the session idr entry so the durable scavenger can later expire it
once the timeout elapses.  The close path transitions f_state to
FP_CLOSED under ft->lock (matching ksmbd_close_fd()) so ksmbd_fp_get()
lookups via any remaining path fail, then removes fp from m_fp_list
before dropping both the transient and the original session-idr ref
via atomic_sub_and_test(2).  The list removal cannot be left for a
deferred final putter because fp->volatile_id has already been cleared
and __ksmbd_remove_fd() will intentionally skip both idr_remove() and
list_del_init().  The subtraction cannot underflow because no
concurrent close path can consume the session-idr ref after the
idr_remove() above.  If the subtraction hits zero we finalize fp
ourselves, otherwise the remaining user's ksmbd_fd_put() finalizes via
__put_fd_final() -> __ksmbd_close_fd().

The __close_file_table_ids() refactor is exercised separately on a
debug kernel additionally built with CONFIG_DEBUG_LIST and
CONFIG_DEBUG_OBJECTS_WORK using a same-session two-tcon workload:
one tcon drives an open/write storm while the other tcon repeats 50
tree disconnects on the same session.  Trace counts: 52
__close_file_table_ids invocations, 4793 __ksmbd_close_fd calls,
30337 __put_fd_final, 9578 ksmbd_conn_put decrements, 1
__ksmbd_conn_release_work execution.  The workload exercises the
idr_remove() / fp->volatile_id clear / m_fp_list unlink coupling
under concurrent fp allocation in the same session table.  This run
validates the file-table/id/list rewrite under
DEBUG_LIST/DEBUG_OBJECTS_WORK; it does not re-prove the transport
leak fix, which the abrupt-disconnect A/B above already covered.  No
list-corruption, work_struct ODEBUG, sleep-in-atomic, lockdep or
kmemleak reports were observed.

The deferred-final-putter branch in __close_file_table_ids()
(atomic_sub_and_test(2) returning false) is covered by analysis, not
by a dedicated counter in this run: the trace points used above
cannot distinguish a deferred-putter __ksmbd_close_fd from a normal
SMB2_CLOSE __ksmbd_close_fd.  __close_file_table_ids() unconditionally
clears fp->volatile_id and unlinks fp from m_fp_list before
atomic_sub_and_test(2), so __ksmbd_remove_fd() invoked from a later
__put_fd_final() correctly skips both idr_remove() and list_del_init().

At module exit, the workqueue is flushed and destroyed after
rcu_barrier(), so any release queued by a trailing RCU callback is
drained before the inode hash and the module text go away.  Verified
by kprobe tracing that all 20 __ksmbd_conn_release_work() executions
complete before ksmbd_conn_wq_destroy() enters, with
ksmbd_tcp_free_transport() matching ksmbd_conn_alloc() at 20/20.

The ida_destroy() previously added to ksmbd_conn_free()'s refcount
branch is folded into __ksmbd_conn_release_work() so it runs from
whichever site turns out to be the last putter.

The conversion also closes a pre-existing ksmbd_conn lifetime gap: fp
used to store a borrowed pointer to its connection
(fp->conn = work->conn) without taking a reference, so nothing stopped
the conn from being freed while an fp still held a stale fp->conn.
Teach fp to own a strong reference on fp->conn for as long as
fp->conn is non-NULL:

  * ksmbd_open_fd() and ksmbd_reopen_durable_fd() bump conn->refcnt
    when assigning fp->conn (matching put on the ksmbd_open_fd() error
    path and on the ksmbd_reopen_durable_fd() __open_id() failure
    path).  Both now set fp->conn and fp->tcon before __open_id()
    publishes fp into the session's file table, so a concurrent
    teardown that iterates the table via idr cannot observe a valid
    volatile_id with fp->conn still NULL and preserve a
    partially-initialized fp.

  * session_fd_check() (durable preserve) and __ksmbd_close_fd() (fp
    destroy) release the owned reference via ksmbd_conn_put() and
    clear fp->conn.

With that invariant in place, session_fd_check() needs no local pin
across the op->conn puts -- fp's own reference keeps conn alive for
the entire body of the function, including the subsequent
conn->llist_lock access.  The NULL-guard at the top of
session_fd_check() stays: a durable reconnect that has already been
through cleanup once leaves fp->conn cleared, and the lock_list loop
would otherwise dereference NULL.

The kernel under test was built with CONFIG_DEBUG_KMEMLEAK,
CONFIG_PROVE_LOCKING, CONFIG_DEBUG_ATOMIC_SLEEP, CONFIG_DEBUG_OBJECTS
and CONFIG_FAILSLAB, plus CONFIG_DEBUG_LIST and
CONFIG_DEBUG_OBJECTS_WORK for the two-tcon stress run.

The __close_file_table_ids() refactor was also exercised under the
same debug kernel with a local test harness that forces
is_reconnectable() to return true so session_fd_check() reaches the
ksmbd_vfs_copy_durable_owner()/down_write(&ci->m_lock) path for
every fp (Linux cifs.ko does not request durable handles in the
generic mount path so the slow path is otherwise not covered).  With
the refactor applied the harness traverses the full sleep path and
CONFIG_DEBUG_ATOMIC_SLEEP / CONFIG_PROVE_LOCKING stay silent.
Reverting only the __close_file_table_ids() hunk while keeping the
harness produces:

    BUG: sleeping function called from invalid context at vfs_cache.c:1095
    __might_sleep+0x49/0x60
    [ BUG: Invalid wait context ]

which confirms that the refactor is what keeps ft->lock out of the
sleepable skip() body.

Fixes: ee426bfb9d09 ("ksmbd: add refcnt to ksmbd_conn struct")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/connection.c |  74 ++++++++++++---
 fs/smb/server/connection.h |   5 +
 fs/smb/server/oplock.c     |   4 +-
 fs/smb/server/server.c     |  12 +++
 fs/smb/server/vfs_cache.c  | 189 ++++++++++++++++++++++++++++++++-----
 5 files changed, 246 insertions(+), 38 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index c5aac4946cbe..7438adb86fe2 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -79,6 +79,62 @@ static int create_proc_clients(void) { return 0; }
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
+ * ksmbd_conn_put() - drop a reference and, if it was the last, queue the
+ * release onto ksmbd_conn_wq so it runs from process context.
+ *
+ * Callable from any context including RCU softirq callbacks and non-sleeping
+ * locks; the actual release is deferred to the workqueue.
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
@@ -97,19 +153,7 @@ void ksmbd_conn_free(struct ksmbd_conn *conn)
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
@@ -136,6 +180,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void)
 		conn->um = ERR_PTR(-EOPNOTSUPP);
 	if (IS_ERR(conn->um))
 		conn->um = NULL;
+	INIT_WORK(&conn->release_work, __ksmbd_conn_release_work);
 	atomic_set(&conn->req_running, 0);
 	atomic_set(&conn->r_count, 0);
 	atomic_set(&conn->refcnt, 1);
@@ -512,8 +557,7 @@ void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn)
 	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
 		wake_up(&conn->r_count_q);
 
-	if (atomic_dec_and_test(&conn->refcnt))
-		kfree(conn);
+	ksmbd_conn_put(conn);
 }
 
 int ksmbd_conn_transport_init(void)
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index de2d46941c93..f6d38c35ea92 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -16,6 +16,7 @@
 #include <linux/kthread.h>
 #include <linux/nls.h>
 #include <linux/unicode.h>
+#include <linux/workqueue.h>
 
 #include "smb_common.h"
 #include "ksmbd_work.h"
@@ -120,6 +121,7 @@ struct ksmbd_conn {
 	bool				binding;
 	atomic_t			refcnt;
 	bool				is_aapl;
+	struct work_struct		release_work;
 };
 
 struct ksmbd_conn_ops {
@@ -164,6 +166,9 @@ void ksmbd_conn_wait_idle(struct ksmbd_conn *conn);
 int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id);
 struct ksmbd_conn *ksmbd_conn_alloc(void);
 void ksmbd_conn_free(struct ksmbd_conn *conn);
+void ksmbd_conn_put(struct ksmbd_conn *conn);
+int ksmbd_conn_wq_init(void);
+void ksmbd_conn_wq_destroy(void);
 bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c);
 int ksmbd_conn_write(struct ksmbd_work *work);
 int ksmbd_conn_rdma_read(struct ksmbd_conn *conn,
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index cd3f28b0e7cb..f1e0bb650cea 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -132,8 +132,8 @@ static void __free_opinfo(struct oplock_info *opinfo)
 {
 	if (opinfo->is_lease)
 		free_lease(opinfo);
-	if (opinfo->conn && atomic_dec_and_test(&opinfo->conn->refcnt))
-		kfree(opinfo->conn);
+	if (opinfo->conn)
+		ksmbd_conn_put(opinfo->conn);
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
index 3551f01a3fa0..b7cc4f1bc021 100644
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
@@ -752,6 +763,14 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
+	/*
+	 * fp owns a strong reference on fp->conn for as long as fp->conn is
+	 * non-NULL, so session_fd_check() and __ksmbd_close_fd() never
+	 * dereference a dangling pointer.  Paired with ksmbd_conn_put() in
+	 * session_fd_check() (durable preserve), in __ksmbd_close_fd()
+	 * (final close), and on the error paths below.
+	 */
+	atomic_inc(&work->conn->refcnt);
 	fp->conn		= work->conn;
 	fp->tcon		= work->tcon;
 	fp->volatile_id		= KSMBD_NO_FID;
@@ -774,6 +793,9 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	return fp;
 
 err_out:
+	/* fp->conn was set and refcounted before every branch here. */
+	ksmbd_conn_put(fp->conn);
+	fp->conn = NULL;
 	kmem_cache_free(filp_cache, fp);
 	return ERR_PTR(ret);
 }
@@ -794,7 +816,8 @@ __close_file_table_ids(struct ksmbd_session *sess,
 		       struct ksmbd_tree_connect *tcon,
 		       bool (*skip)(struct ksmbd_tree_connect *tcon,
 				    struct ksmbd_file *fp,
-				    struct ksmbd_user *user))
+				    struct ksmbd_user *user),
+		       bool skip_preserves_fp)
 {
 	struct ksmbd_file_table *ft = &sess->file_table;
 	struct ksmbd_file *fp;
@@ -802,32 +825,132 @@ __close_file_table_ids(struct ksmbd_session *sess,
 	int num = 0;
 
 	while (1) {
+		unsigned int saved_id;
+
 		write_lock(&ft->lock);
 		fp = idr_get_next(ft->idr, &id);
 		if (!fp) {
 			write_unlock(&ft->lock);
 			break;
 		}
-
-		if (skip(tcon, fp, sess->user) ||
-		    !atomic_dec_and_test(&fp->refcount)) {
+		saved_id = id;
+		if (!atomic_inc_not_zero(&fp->refcount)) {
 			id++;
 			write_unlock(&ft->lock);
 			continue;
 		}
 
-		set_close_state_blocked_works(fp);
-		idr_remove(ft->idr, fp->volatile_id);
-		fp->volatile_id = KSMBD_NO_FID;
-		write_unlock(&ft->lock);
+		if (skip_preserves_fp) {
+			/*
+			 * Session teardown: skip() is session_fd_check(),
+			 * which may sleep and mutates fp->conn / fp->tcon /
+			 * fp->volatile_id when it chooses to preserve fp
+			 * for durable reconnect.  Unpublish fp from the
+			 * session idr here, under ft->lock, so that neither
+			 * __ksmbd_lookup_fd() nor a concurrent
+			 * ksmbd_close_fd() through this session can reach
+			 * fp -- the former would otherwise grant a new
+			 * ksmbd_fp_get() reference to an fp whose fields
+			 * are about to be rewritten outside the lock, and
+			 * the latter would otherwise consume the original
+			 * idr-owned ref out from under the
+			 * atomic_sub_and_test(2) below.  Durable reconnect
+			 * still reaches fp via global_ft.
+			 */
+			idr_remove(ft->idr, saved_id);
+			fp->volatile_id = KSMBD_NO_FID;
+			write_unlock(&ft->lock);
 
+			if (skip(tcon, fp, sess->user)) {
+				/*
+				 * session_fd_check() has converted fp to
+				 * durable-preserve state and cleared its
+				 * per-conn fields.  fp is already unpublished
+				 * above; the original idr-owned ref keeps it
+				 * alive for the durable scavenger.  Drop only
+				 * the transient ref.  atomic_dec() is safe --
+				 * atomic_inc_not_zero() succeeded on a
+				 * positive value and we added one more, so
+				 * refcount cannot be zero here.
+				 */
+				atomic_dec(&fp->refcount);
+				id++;
+				continue;
+			}
+
+			/*
+			 * Close path.  fp is already out of the session
+			 * idr, so no concurrent close path can consume the
+			 * idr-owned ref before our atomic_sub_and_test(2)
+			 * below.  Block any remaining lookup (global_ft,
+			 * m_fp_list) by transitioning f_state to FP_CLOSED;
+			 * ksmbd_fp_get() refuses non-FP_INITED files.
+			 */
+			write_lock(&ft->lock);
+			if (fp->f_state == FP_INITED) {
+				set_close_state_blocked_works(fp);
+				fp->f_state = FP_CLOSED;
+			}
+			write_unlock(&ft->lock);
+		} else {
+			/*
+			 * Tree teardown: skip() is tree_conn_fd_check(), a
+			 * cheap pointer compare that doesn't sleep and has
+			 * no side effects, so keep the skip decision plus
+			 * the unpublish-and-mark-closed sequence atomic
+			 * under ft->lock.  fps belonging to other tree
+			 * connects (skip() == true) stay fully published in
+			 * the session idr with no lock window; fps we
+			 * intend to close are unpublished and transitioned
+			 * to FP_CLOSED before we release the lock, so no
+			 * concurrent ksmbd_close_fd() can consume the
+			 * idr-owned ref before our atomic_sub_and_test(2)
+			 * below.
+			 */
+			if (skip(tcon, fp, sess->user)) {
+				atomic_dec(&fp->refcount);
+				write_unlock(&ft->lock);
+				id++;
+				continue;
+			}
+			idr_remove(ft->idr, saved_id);
+			fp->volatile_id = KSMBD_NO_FID;
+			if (fp->f_state == FP_INITED) {
+				set_close_state_blocked_works(fp);
+				fp->f_state = FP_CLOSED;
+			}
+			write_unlock(&ft->lock);
+		}
+
+		/*
+		 * fp->volatile_id is already cleared to prevent stale idr
+		 * removal from a deferred final close.  Remove fp from
+		 * m_fp_list here because __ksmbd_remove_fd() will skip the
+		 * list unlink when volatile_id is KSMBD_NO_FID.
+		 */
 		down_write(&fp->f_ci->m_lock);
 		list_del_init(&fp->node);
 		up_write(&fp->f_ci->m_lock);
 
-		__ksmbd_close_fd(ft, fp);
-
-		num++;
+		/*
+		 * Drop both our transient (+1) and the original
+		 * session-idr-owned ref via atomic_sub_and_test(2).  By
+		 * the reasoning in each branch above, no concurrent close
+		 * path can consume the idr-owned ref, so the subtraction
+		 * cannot underflow.
+		 *
+		 * If we end up as the final putter, finalize fp and
+		 * account the open_files_count decrement via the caller's
+		 * atomic_sub(num, ...).  Otherwise the remaining user's
+		 * ksmbd_fd_put() reaches __put_fd_final(), which does its
+		 * own atomic_dec(&open_files_count), so we must not count
+		 * this fp here -- doing so would double-decrement the
+		 * connection-wide counter.
+		 */
+		if (atomic_sub_and_test(2, &fp->refcount)) {
+			__ksmbd_close_fd(NULL, fp);
+			num++;
+		}
 		id++;
 	}
 
@@ -1062,25 +1185,32 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	if (!is_reconnectable(fp))
 		return false;
 
+	if (!fp->conn)
+		return true;
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
@@ -1091,6 +1221,8 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 		fp->durable_scavenger_timeout =
 			jiffies_to_msecs(jiffies) + fp->durable_timeout;
 
+	/* Drop fp's own reference on conn. */
+	ksmbd_conn_put(conn);
 	return true;
 }
 
@@ -1098,7 +1230,8 @@ void ksmbd_close_tree_conn_fds(struct ksmbd_work *work)
 {
 	int num = __close_file_table_ids(work->sess,
 					 work->tcon,
-					 tree_conn_fd_check);
+					 tree_conn_fd_check,
+					 false);
 
 	atomic_sub(num, &work->conn->stats.open_files_count);
 }
@@ -1107,7 +1240,8 @@ void ksmbd_close_session_fds(struct ksmbd_work *work)
 {
 	int num = __close_file_table_ids(work->sess,
 					 work->tcon,
-					 session_fd_check);
+					 session_fd_check,
+					 true);
 
 	atomic_sub(num, &work->conn->stats.open_files_count);
 }
@@ -1178,15 +1312,28 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 
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
+	atomic_inc(&conn->refcnt);
+	fp->conn = conn;
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
@@ -1228,7 +1375,7 @@ void ksmbd_destroy_file_table(struct ksmbd_session *sess)
 	if (!ft->idr)
 		return;
 
-	__close_file_table_ids(sess, NULL, session_fd_check);
+	__close_file_table_ids(sess, NULL, session_fd_check, true);
 	idr_destroy(ft->idr);
 	kfree(ft->idr);
 	ft->idr = NULL;
-- 
2.43.0

