Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024592;
	b=kFoALg1zadwd6K6AGe9na4cmw74AYd6353/5bv/lCH3jLafHI1MJyiabCzTL7y8JhNxr
	 wm0pbbqa5/R1ql8tvFQQOC8lvrot1FVnwSuYaNq83zlj0qCyKS9mFS4XdL+3Wm5Yd3O7s
	 vgrK/PnjhD/Almxxwq26nFLC9v3eJzfZ2K0RLSn5bpo+WghqFYyRlo6RXuCnQVbel0bC6
	 len9Zh0PJwL5jWvuzAI1k5i4Ka+Xu70TUI3uzMMOALC4AFZEb9BfgNzW9+F5NJIgl0lVt
	 FmKtVYiW5vLpDI+55T4b/JuPJZ8qzURQxqDbk75ymGlFfWYGH6Xjb6M5CegSGH673oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024592;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HSq33gnzuH28FxcO3Xj/s5LHEWVhjTVqVkE0mAa9vbE=;
	b=T+X+LIAS6yr4T9O6BLrSO7pme6qvIFNlD7uhF7Kwx3qu2bMbg2VtLr3n4Zq/DnKHun7j
	 oATJpWnw/jmQHfhjUAwxnNAaFGhnefzdiJU7dt8KYH5Uwftlc0TYuSJWgmGYnZOw/bDRD
	 er4q+ZRfprOXwfcTo8/XTRDbGt69pKTos0zVRQzQrNIOAXUqm3dgwfPCzJfU8WdqJJEh/
	 Fun2UqzdKiobLvxyXOS8jDVFIOzF/LQUAuWxVVQBd1/QLPQB5U674fg2GqgsPPdhfII11
	 4VW3nQ/8AHwtRyz/X34NHUBz6+2rfbeRUUAkiPOAG+AxKrfJncSZoa6d19g9XTw5sOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=PnEwl8IA;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03DD606A33D;
	Sat,  7 Nov 2026 04:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C03DD606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=PnEwl8IA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=HSq33gnzuH28FxcO3Xj/s5LHEWVhjTVqVkE0mAa9vbE=; b=PnEwl8IAbs6nah9OFLhdqMH5rU
	CwsXIb5md4bDHmk/8obIHPTydjx6Zv8B7dHuMJjvYL5S6sXmwg2ePhUoxBn/rxfToGcSfslqzw7nS
	ldT2uRljkfqw/hjonpyp0GfpAmXpAL/BqDjrq9YVUeEt+fjErYWlTn8hzSHeK/jzZWpN4+BYFC4fK
	xIfpiTTRNBx+IgXhFkxxYDtbXQl1D9W2k4QWR9c7JS2E1RXDnGAdtX/f50j3LTEsche8LLFjFSr45
	OS3XlkOWFWxqDENUOMZVSZsnZtcIG+3SjBoy8AG24eadmYMOIH+6QUi8HM+RsUEfFFRJjw4JgQZi7
	AJzrPLiQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkQ-000000015Oj-0rEQ;
	Sat, 07 Nov 2026 01:09:47 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v8 18/19] smb: client: fail writeback sends and reopens fast when the server is gone
Date: Sat,  7 Nov 2026 01:09:39 -0300
Message-ID: <20261107040940.2692656-19-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107040940.2692656-1-pc@manguebit.org>
References: <20261107040940.2692656-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A writeback whose send or handle reopen finds the server needing
reconnect waits in smb2_reconnect() -> cifs_wait_for_server_reconnect()
for the reconnect to finish - on a hard mount until the server returns or
umount -f.  But umount -f only breaks that wait for a request that entered
it before the abort count was bumped; a send or reopen that enters
afterwards, including the writeback that generic_shutdown_super() ->
sync_filesystem() starts during the unmount itself, snapshots the
already-bumped count and waits forever, hanging the unmount.

Issue writeback sends and reopens without waiting for the reconnect: pass
a nowait flag down to smb2_reconnect() and have it return -EAGAIN from
every point it would otherwise wait in or loop back to
cifs_wait_for_server_reconnect() - the initial need-reconnect check, the
wait itself, a need-reconnect seen after taking the session mutex, and a
failed renegotiation - not just the first.  The subrequest is then
retried from the netfs collector, which backs off and re-checks umount -f
and the retry window before trying again.  Reads, direct writes and every
other command keep waiting as before.

Writeback started between umount_begin() and cifs_kill_sb() can also
block the unmount from the flusher, which holds s_umount: in the reopen
retry loop, or in a credit wait, as credits only come back with a
reconnect.  Defer writeback reopens to the worker, and fail writeback
credit waits with -EAGAIN while the connection needs reconnecting,
waking the waiters when it drops, so both get retried from the netfs
collector.  Have only one subrequest of a request reopen at a time, the
others retrying after it rather than failing on its behalf, back off
before queueing once per pass rather than per subrequest, and never block
the flusher or the worker on fh_mutex, which a reader stuck reconnecting
may hold, so that a dead mount can't tie up the shared worker for the
other mounts, nor the collector or the flusher.  Let the pieces a
retry re-slices keep the retry state of the span they come from, and
make the reopen's own credit wait fail fast as well.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |  19 +++-
 fs/smb/client/cifsproto.h |   6 +-
 fs/smb/client/cifssmb.c   |   2 +-
 fs/smb/client/connect.c   |   1 +
 fs/smb/client/file.c      | 219 +++++++++++++++++++++++++++++++-------
 fs/smb/client/misc.c      |   7 +-
 fs/smb/client/smb2ops.c   |   9 +-
 fs/smb/client/smb2pdu.c   |  55 ++++++++--
 fs/smb/client/transport.c |  22 +++-
 9 files changed, 283 insertions(+), 57 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8e5495c172c6..9167e5324c90 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -585,7 +585,7 @@ struct smb_version_operations {
 	unsigned int (*wp_retry_size)(struct inode *);
 	/* get mtu credits */
 	int (*wait_mtu_credits)(struct TCP_Server_Info *, size_t,
-				size_t *, struct cifs_credits *);
+				size_t *, struct cifs_credits *, bool nowait);
 	/* adjust previously taken mtu credits to request size */
 	int (*adjust_credits)(struct TCP_Server_Info *server,
 			      struct cifs_io_subrequest *subreq,
@@ -887,6 +887,14 @@ has_credits(struct TCP_Server_Info *server, int *credits, int num_credits)
 	return num >= num_credits;
 }
 
+static inline bool
+credits_or_conn_down(struct TCP_Server_Info *server, int *credits,
+		     int num_credits, bool nowait)
+{
+	return has_credits(server, credits, num_credits) ||
+	       (nowait && READ_ONCE(server->tcpStatus) == CifsNeedReconnect);
+}
+
 static inline void
 add_credits(struct TCP_Server_Info *server, struct cifs_credits *credits,
 	    const int optype)
@@ -1411,6 +1419,7 @@ struct cifs_open_parms {
 	bool replay:1; /* indicates that this open is for a replay */
 	bool no_replay:1; /* don't replay this open internally */
 	bool pending:1; /* in/out: last built create had no answer */
+	bool no_reconnect_wait:1; /* fail fast, don't wait for reconnect */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
@@ -1492,7 +1501,13 @@ struct cifs_io_request {
 	pid_t				pid;
 	int				umount_aborts;
 	bool				reopen_gave_up;
+	bool				replay;
 	atomic_t			bad_reopens;	/* 0 or bad gen + 1 */
+	int				reopen_err;
+	struct mutex			reopen_lock;	/* serializes reopens */
+	unsigned long			retry_deadline;
+	unsigned int			cur_sleep;
+	unsigned int			slept;
 };
 
 /* asynchronous read support */
@@ -1507,6 +1522,7 @@ struct cifs_io_subrequest {
 	int				result;
 	bool				have_xid;
 	bool				replay;
+	bool				deferred;	/* issue in a worker */
 	unsigned int			reopens;
 	unsigned int			retries;	/* number of retries so far */
 	unsigned int			cur_sleep;	/* time to sleep before replay */
@@ -1948,6 +1964,7 @@ enum cifs_find_flags {
 #define   CIFS_COMPRESS_REQ       0x4000 /* compress request before sending */
 #define   CIFS_INTERRUPTIBLE_WAIT 0x8000 /* Interruptible wait (e.g. lock request) */
 #define   CIFS_WINDOWS_LOCK       0x10000 /* We're trying to get a Windows lock */
+#define   CIFS_NO_RECONNECT_WAIT  0x20000 /* don't wait if conn is down */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 1b735a1c5b3d..b7a7fe372d47 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -112,7 +112,8 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 int wait_for_free_request(struct TCP_Server_Info *server, const int flags,
 			  unsigned int *instance);
 int cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
-			  size_t *num, struct cifs_credits *credits);
+			  size_t *num, struct cifs_credits *credits,
+			  bool nowait);
 
 static inline int
 send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
@@ -444,7 +445,8 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 
 void cifs_wake_ses_waiters(struct cifs_ses *ses);
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
-				   struct cifs_tcon *tcon, int aborts);
+				   struct cifs_tcon *tcon, int aborts,
+				   bool nowait);
 
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 712086eb3d1f..68f05a52605f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -105,7 +105,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&tcon->tc_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts, false);
 	if (rc)
 		return rc;
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 8e55a036fe92..0b62b4802cfa 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -352,6 +352,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 		mid_execute_callback(server, mid);
 		release_mid(server, mid);
 	}
+	wake_up_all(&server->request_q);
 }
 
 static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num_targets)
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ff950f11de22..568a16997461 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -39,6 +39,7 @@
 
 /* flags for cifs_reopen_file() */
 #define CIFS_REOPEN_BOUND	BIT(0)	/* caller bounds the retries */
+#define CIFS_REOPEN_NOWAIT	BIT(1)	/* fail fast, skip reconnect wait */
 
 static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush,
 			    unsigned int flags);
@@ -163,7 +164,6 @@ static bool cifs_tcon_reconnecting(struct cifs_tcon *tcon)
 static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 				  struct cifs_io_subrequest *subreq)
 {
-	bool writeback = subreq->rreq->origin == NETFS_WRITEBACK;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct cifs_ses *ses = tcon->ses;
 	unsigned int reconnects;
@@ -171,9 +171,6 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 	bool retrying = false;
 	int rc;
 
-	if (writeback && READ_ONCE(subreq->req->reopen_gave_up))
-		return -EIO;
-
 	for (;;) {
 		if ((retrying && cifs_io_stopped(subreq)) ||
 		    cifs_io_aborted(subreq))
@@ -181,11 +178,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
 		rc = cifs_reopen_file(cfile, can_flush, CIFS_REOPEN_BOUND);
-		if (!rc || is_interrupt_error(rc) ||
-		    cifs_writeback_dying(&subreq->subreq))
-			return rc;
-		if (!is_replayable_error(rc) &&
-		    !(writeback && cifs_writeback_transient(rc)))
+		if (!rc || !is_replayable_error(rc))
 			return rc;
 		if (free_retry && !cifs_io_stopped(subreq) &&
 		    (cifs_ses_reconnects(ses) != reconnects ||
@@ -193,11 +186,8 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 			free_retry = false;
 			continue;
 		}
-		if (!cifs_io_should_replay(subreq)) {
-			if (writeback)
-				WRITE_ONCE(subreq->req->reopen_gave_up, true);
+		if (!cifs_io_should_replay(subreq))
 			return rc;
-		}
 		msleep(subreq->cur_sleep);
 	}
 }
@@ -216,17 +206,78 @@ static void cifs_mark_bad_handle(struct cifs_io_request *req, unsigned int gen)
 		;
 }
 
-static void cifs_invalidate_bad_handle(struct cifs_io_request *req)
+static bool cifs_bad_handle_pending(struct cifs_io_request *req)
 {
+	unsigned int bad = atomic_read(&req->bad_reopens);
+
+	return bad && bad - 1 == READ_ONCE(req->cfile->reopens);
+}
+
+static void __cifs_invalidate_bad_handle(struct cifs_io_request *req)
+{
+	unsigned int bad = atomic_read(&req->bad_reopens);
 	struct cifsFileInfo *cfile = req->cfile;
-	unsigned int bad;
 
-	guard(mutex)(&cfile->fh_mutex);
-	bad = atomic_read(&req->bad_reopens);
+	lockdep_assert_held(&cfile->fh_mutex);
 	if (bad && bad - 1 == cfile->reopens)
 		cfile->invalidHandle = true;
 }
 
+static void cifs_invalidate_bad_handle(struct cifs_io_request *req)
+{
+	if (!cifs_bad_handle_pending(req))
+		return;
+	guard(mutex)(&req->cfile->fh_mutex);
+	__cifs_invalidate_bad_handle(req);
+}
+
+static bool cifs_try_invalidate_bad_handle(struct cifs_io_request *req)
+{
+	if (!cifs_bad_handle_pending(req))
+		return true;
+	if (!mutex_trylock(&req->cfile->fh_mutex))
+		return false;
+	__cifs_invalidate_bad_handle(req);
+	mutex_unlock(&req->cfile->fh_mutex);
+	return true;
+}
+
+static int cifs_reopen_writeback(struct cifs_io_subrequest *wdata)
+{
+	struct cifs_io_request *req = wdata->req;
+	int rc;
+
+	if (cifs_io_aborted(wdata) || READ_ONCE(req->reopen_gave_up))
+		return -EIO;
+	rc = READ_ONCE(req->reopen_err);
+	if (rc)
+		return rc;
+	if (mutex_trylock(&req->reopen_lock)) {
+		if (!cifs_try_invalidate_bad_handle(req))
+			rc = -EAGAIN;
+		else if (req->cfile->invalidHandle)
+			rc = cifs_reopen_file(req->cfile, false,
+					      CIFS_REOPEN_BOUND |
+					      CIFS_REOPEN_NOWAIT);
+		mutex_unlock(&req->reopen_lock);
+		if (!rc)
+			return 0;
+		if (!cifs_writeback_transient(rc)) {
+			WRITE_ONCE(req->reopen_err, rc);
+			return rc;
+		}
+		if (!cifs_io_should_replay(wdata)) {
+			WRITE_ONCE(req->reopen_gave_up, true);
+			return -EIO;
+		}
+	} else {
+		rc = -EAGAIN;
+	}
+	trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
+	__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	return rc;
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -240,6 +291,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *open_file = req->cfile;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(wdata->rreq->inode->i_sb);
+	bool writeback = subreq->rreq->origin == NETFS_WRITEBACK;
 	bool reprepared = wdata->have_xid;
 	size_t wsize = req->rreq.wsize;
 	int rc;
@@ -251,6 +303,17 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 	wdata->server = server;
+	wdata->deferred = false;
+
+	if (reprepared) {
+		req->retry_deadline = wdata->retry_deadline;
+		req->cur_sleep = wdata->cur_sleep;
+		req->replay = wdata->replay;
+	} else if (subreq->retry_count) {
+		wdata->retry_deadline = req->retry_deadline;
+		wdata->cur_sleep = req->cur_sleep;
+		wdata->replay = req->replay;
+	}
 
 	if (cifs_io_aborted(wdata) ||
 	    (reprepared && cifs_io_stopped(wdata))) {
@@ -265,24 +328,29 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	if (cifs_writeback_dying(subreq))
 		goto defer;
 
-	cifs_invalidate_bad_handle(req);
+	if (!writeback)
+		cifs_invalidate_bad_handle(req);
+	else if (cifs_bad_handle_pending(req))
+		goto defer;
 
 	if (open_file->invalidHandle) {
-		rc = cifs_reopen_file_retry(open_file, false, wdata);
+		if (!writeback)
+			rc = cifs_reopen_file_retry(open_file, false, wdata);
+		else if (!READ_ONCE(req->reopen_gave_up))
+			goto defer;
+		else
+			rc = -EIO;
 		if (rc < 0) {
-			if (subreq->rreq->origin == NETFS_WRITEBACK &&
-			    (is_interrupt_error(rc) ||
-			     fatal_signal_pending(current)))
-				goto defer;
-			subreq->error = cifs_writeback_error(subreq, rc);
+			subreq->error = rc;
 			return netfs_prepare_write_failed(subreq);
 		}
 	}
 
 	rc = server->ops->wait_mtu_credits(server, wsize, &stream->sreq_max_len,
-					   &wdata->credits);
+					   &wdata->credits, writeback);
 	if (rc < 0) {
-		if (cifs_writeback_dying(subreq))
+		if (cifs_writeback_dying(subreq) ||
+		    (writeback && rc == -EAGAIN))
 			goto defer;
 		subreq->error = cifs_writeback_error(subreq, rc);
 		return netfs_prepare_write_failed(subreq);
@@ -290,6 +358,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	goto out;
 
 defer:
+	wdata->deferred = true;
 	wdata->credits = (struct cifs_credits){};
 	stream->sreq_max_len = min_t(size_t, wsize, SMB2_MAX_BUFFER_SIZE);
 out:
@@ -336,9 +405,6 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	if (rc)
 		goto fail;
 
-	if (wdata->replay && wdata->cur_sleep)
-		msleep(wdata->cur_sleep);
-
 	rc = -EAGAIN;
 	if (wdata->req->cfile->invalidHandle ||
 	    (wdata->credits.value &&
@@ -372,13 +438,11 @@ static void cifs_issue_write_worker(struct work_struct *work)
 
 	wdata = container_of(work, struct cifs_io_subrequest, subreq.work);
 	cfile = wdata->req->cfile;
-	cifs_invalidate_bad_handle(wdata->req);
-	if (cfile->invalidHandle)
-		rc = cifs_reopen_file_retry(cfile, false, wdata);
+	if (cifs_bad_handle_pending(wdata->req) || cfile->invalidHandle)
+		rc = cifs_reopen_writeback(wdata);
 	if (rc) {
 		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
-		cifs_write_subrequest_terminated(wdata,
-				cifs_writeback_error(&wdata->subreq, rc));
+		cifs_write_subrequest_terminated(wdata, rc);
 		return;
 	}
 	__cifs_issue_write(&wdata->subreq);
@@ -386,7 +450,16 @@ static void cifs_issue_write_worker(struct work_struct *work)
 
 static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
-	if (unlikely(cifs_writeback_dying(subreq))) {
+	struct cifs_io_subrequest *wdata =
+		container_of(subreq, struct cifs_io_subrequest, subreq);
+	struct cifs_io_request *req = wdata->req;
+
+	if (wdata->cur_sleep > req->slept) {
+		msleep(wdata->cur_sleep - req->slept);
+		req->slept = wdata->cur_sleep;
+	}
+
+	if (unlikely(wdata->deferred || cifs_writeback_dying(subreq))) {
 		subreq->work.func = cifs_issue_write_worker;
 		WARN_ON_ONCE(!queue_work(cifs_writeback_wq, &subreq->work));
 		return;
@@ -394,6 +467,70 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 	__cifs_issue_write(subreq);
 }
 
+static void cifs_share_retry_state(struct netfs_io_subrequest *from,
+				   struct netfs_io_subrequest *stop,
+				   struct list_head *head)
+{
+	struct netfs_io_subrequest *subreq = from;
+	struct cifs_io_subrequest *wdata;
+	unsigned long deadline = 0;
+	unsigned int sleep = 0;
+	bool replay = false;
+
+	list_for_each_entry_from(subreq, head, rreq_link) {
+		if (subreq == stop)
+			break;
+		wdata = container_of(subreq, struct cifs_io_subrequest, subreq);
+		if (wdata->retry_deadline &&
+		    (!deadline || time_before(wdata->retry_deadline, deadline)))
+			deadline = wdata->retry_deadline;
+		sleep = max(sleep, wdata->cur_sleep);
+		replay |= wdata->replay;
+	}
+	subreq = from;
+	list_for_each_entry_from(subreq, head, rreq_link) {
+		if (subreq == stop)
+			break;
+		wdata = container_of(subreq, struct cifs_io_subrequest, subreq);
+		wdata->retry_deadline = deadline;
+		wdata->cur_sleep = sleep;
+		wdata->replay = replay;
+	}
+}
+
+static void cifs_retry_request(struct netfs_io_request *wreq,
+			       struct netfs_io_stream *stream)
+{
+	struct netfs_io_subrequest *subreq, *from = NULL;
+	struct cifs_io_request *req =
+		container_of(wreq, struct cifs_io_request, rreq);
+	uoff_t end = 0;
+
+	req->slept = 0;
+	if (!stream)
+		return;
+
+	guard(spinlock)(&wreq->lock);
+	list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+		if (from && test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags) &&
+		    !test_bit(NETFS_SREQ_BOUNDARY, &subreq->flags) &&
+		    subreq->start + subreq->transferred == end) {
+			end += subreq->len;
+			continue;
+		}
+		if (from)
+			cifs_share_retry_state(from, subreq,
+					       &stream->subrequests);
+		from = NULL;
+		if (test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
+			from = subreq;
+			end = subreq->start + subreq->len;
+		}
+	}
+	if (from)
+		cifs_share_retry_state(from, NULL, &stream->subrequests);
+}
+
 static void cifs_netfs_invalidate_cache(struct netfs_io_request *wreq)
 {
 	cifs_invalidate_cache(wreq->inode, 0);
@@ -436,7 +573,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	}
 
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
-					   &size, &rdata->credits);
+					   &size, &rdata->credits, false);
 	if (rc)
 		return rc;
 
@@ -558,6 +695,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 	rreq->wsize = cifs_sb->ctx->wsize;
 	req->pid = current->tgid; // Ummm...  This may be a workqueue
 	req->umount_aborts = atomic_read(&cifs_sb->umount_aborts);
+	mutex_init(&req->reopen_lock);
 
 	if (file) {
 		open_file = file->private_data;
@@ -646,6 +784,7 @@ const struct netfs_request_ops cifs_req_ops = {
 	.begin_writeback	= cifs_begin_writeback,
 	.prepare_write		= cifs_prepare_write,
 	.issue_write		= cifs_issue_write,
+	.retry_request		= cifs_retry_request,
 	.invalidate_cache	= cifs_netfs_invalidate_cache,
 };
 
@@ -1577,7 +1716,12 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 	bool fresh;
 
 	xid = get_xid();
-	mutex_lock(&cfile->fh_mutex);
+	if (!(flags & CIFS_REOPEN_NOWAIT)) {
+		mutex_lock(&cfile->fh_mutex);
+	} else if (!mutex_trylock(&cfile->fh_mutex)) {
+		free_xid(xid);
+		return -EAGAIN;
+	}
 	if (!cfile->invalidHandle) {
 		mutex_unlock(&cfile->fh_mutex);
 		free_xid(xid);
@@ -1668,6 +1812,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 		.replay = cfile->reopen_replay,
 		.pending = cfile->reopen_replay,
 		.no_replay = !!(flags & CIFS_REOPEN_BOUND),
+		.no_reconnect_wait = !!(flags & CIFS_REOPEN_NOWAIT),
 	};
 
 	/*
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 13eb067ad88a..4a3ecf5c80f7 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1081,7 +1081,8 @@ static bool reco_wait_done(struct TCP_Server_Info *server,
 }
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
-				   struct cifs_tcon *tcon, int aborts)
+				   struct cifs_tcon *tcon, int aborts,
+				   bool nowait)
 {
 	int timeout = 10;
 	int rc;
@@ -1091,6 +1092,10 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
 		spin_unlock(&server->srv_lock);
 		return 0;
 	}
+	if (nowait) {
+		spin_unlock(&server->srv_lock);
+		return -EAGAIN;
+	}
 	timeout *= server->nr_targets;
 	spin_unlock(&server->srv_lock);
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 457f18ce3245..0a487b24f4e7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -244,7 +244,7 @@ smb2_get_credits(struct mid_q_entry *mid)
 
 static int
 smb2_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
-		      size_t *num, struct cifs_credits *credits)
+		      size_t *num, struct cifs_credits *credits, bool nowait)
 {
 	int rc = 0;
 	unsigned int scredits, in_flight;
@@ -258,6 +258,10 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 			spin_unlock(&server->srv_lock);
 			return -ENOENT;
 		}
+		if (nowait && server->tcpStatus == CifsNeedReconnect) {
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
 		spin_unlock(&server->srv_lock);
 
 		spin_lock(&server->req_lock);
@@ -265,7 +269,8 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-				has_credits(server, &server->credits, 1));
+				credits_or_conn_down(server, &server->credits,
+						     1, nowait));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c18912693895..9d855ff3baba 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -248,7 +248,8 @@ int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *serve
 
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
-	       struct TCP_Server_Info *server, bool from_reconnect)
+	       struct TCP_Server_Info *server, bool from_reconnect,
+	       bool nowait)
 {
 	struct cifs_ses *ses;
 	int aborts;
@@ -311,6 +312,10 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			spin_unlock(&server->srv_lock);
 			return -EAGAIN;
 		}
+		if (nowait) {
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
 	}
 
 	/* if server is marked for termination, cifsd will cleanup */
@@ -321,7 +326,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&server->srv_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts, nowait);
 	if (rc)
 		return rc;
 
@@ -349,6 +354,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
+		if (nowait)
+			return -EAGAIN;
 		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
@@ -380,6 +387,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
+		if (nowait)
+			return -EAGAIN;
 		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
@@ -592,7 +601,22 @@ static int smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 {
 	int rc;
 
-	rc = smb2_reconnect(smb2_command, tcon, server, false);
+	rc = smb2_reconnect(smb2_command, tcon, server, false, false);
+	if (rc)
+		return rc;
+
+	return __smb2_plain_req_init(smb2_command, tcon, server, request_buf,
+				     total_len);
+}
+
+/* As smb2_plain_req_init(), but fail fast instead of waiting for reconnect. */
+static int smb2_io_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
+			    struct TCP_Server_Info *server,
+			    void **request_buf, unsigned int *total_len)
+{
+	int rc;
+
+	rc = smb2_reconnect(smb2_command, tcon, server, false, true);
 	if (rc)
 		return rc;
 
@@ -3147,8 +3171,12 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	__le16 *copy_path;
 	int rc;
 
-	rc = smb2_plain_req_init(SMB2_CREATE, tcon, server,
-				 (void **) &req, &total_len);
+	if (oparms->no_reconnect_wait)
+		rc = smb2_io_req_init(SMB2_CREATE, tcon, server,
+				      (void **) &req, &total_len);
+	else
+		rc = smb2_plain_req_init(SMB2_CREATE, tcon, server,
+					 (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -3358,6 +3386,8 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
+	if (oparms->no_reconnect_wait)
+		flags |= CIFS_NO_RECONNECT_WAIT;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
@@ -4380,7 +4410,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
@@ -4412,7 +4443,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -5230,8 +5262,13 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	};
 	io_parms = &_io_parms;
 
-	rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
-				 (void **) &req, &total_len);
+	if (wdata->subreq.rreq->origin == NETFS_WRITEBACK) {
+		flags |= CIFS_NO_RECONNECT_WAIT;
+		rc = smb2_io_req_init(SMB2_WRITE, tcon, server,
+				      (void **) &req, &total_len);
+	} else
+		rc = smb2_plain_req_init(SMB2_WRITE, tcon, server,
+					 (void **) &req, &total_len);
 	if (rc)
 		goto out;
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index d0d0159c1061..c51f99d7be4b 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -430,6 +430,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		      const int timeout, const int flags,
 		      unsigned int *instance)
 {
+	bool nowait = flags & CIFS_NO_RECONNECT_WAIT;
 	long rc;
 	int *credits;
 	int optype;
@@ -478,6 +479,10 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 			spin_unlock(&server->srv_lock);
 			return -ENOENT;
 		}
+		if (nowait && server->tcpStatus == CifsNeedReconnect) {
+			spin_unlock(&server->srv_lock);
+			return -EAGAIN;
+		}
 		spin_unlock(&server->srv_lock);
 
 		spin_lock(&server->req_lock);
@@ -487,7 +492,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable_timeout(server->request_q,
-				has_credits(server, credits, num_credits), t);
+				credits_or_conn_down(server, credits,
+						     num_credits, nowait), t);
 			cifs_num_waiters_dec(server);
 			if (!rc) {
 				spin_lock(&server->req_lock);
@@ -527,8 +533,9 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 				cifs_num_waiters_inc(server);
 				rc = wait_event_killable_timeout(
 					server->request_q,
-					has_credits(server, credits,
-						    MAX_COMPOUND + 1),
+					credits_or_conn_down(server, credits,
+							     MAX_COMPOUND + 1,
+							     nowait),
 					t);
 				cifs_num_waiters_dec(server);
 				if (!rc) {
@@ -595,6 +602,10 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 
 	credits = server->ops->get_credits_field(server, flags & CIFS_OP_MASK);
 
+	if ((flags & CIFS_NO_RECONNECT_WAIT) &&
+	    READ_ONCE(server->tcpStatus) == CifsNeedReconnect)
+		return -EAGAIN;
+
 	spin_lock(&server->req_lock);
 	scredits = *credits;
 	in_flight = server->in_flight;
@@ -618,6 +629,9 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 		 */
 		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
+			if ((flags & CIFS_NO_RECONNECT_WAIT) &&
+			    READ_ONCE(server->tcpStatus) == CifsNeedReconnect)
+				return -EAGAIN;
 			trace_smb3_insufficient_credits(server->current_mid,
 					server->conn_id, server->hostname, scredits,
 					num, in_flight);
@@ -634,7 +648,7 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 
 int
 cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
-		      size_t *num, struct cifs_credits *credits)
+		      size_t *num, struct cifs_credits *credits, bool nowait)
 {
 	*num = size;
 	credits->value = 0;
-- 
2.56.0

