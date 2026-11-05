Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793918745;
	b=EwAbsv3hILOU90w2PO85VXnPhEz9KJu5nhwyg0QeymBpCHbJELb7WRJYAY7lDdfKZVj6
	 BS3f7brCgJGF78DXpo+2Y0jYJqMGepuB5O0hWKCSdvEPc1XFmLB2TlaSSiWOYaMZ0GQiH
	 MOWKslyhjf0W5tj05XFm7RJYAvtJLLmDL7IUo6/DXddUuAdKVraab//8AXRW/fjQ7OX/T
	 kYBw7306VQyllqDZI0hn2Q5sUTUoui/dwRytJ2lpKPLg7PcT8hxKL/0121JxdEj2FAKe9
	 mbKnqVVG/De5owUJmp8XRVZUN9+fvdvQrCBAOl3mmOymRBeqLLY4Nbl/8FeKMYTxTUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793918745;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ImNXfCQmwXS9wJk0EFQdI0ui/ZNN1dZT9BSoVQQXZro=;
	b=bqve08ssLyBozEHBKiqmq6VPuTpP2uw7tioNLC2poBLGZbWX8E0oxWtZeePu3jlPyv5S
	 jzUmtQRP6237k0+HfWcwfX3pzevIIsQnGWNAmwRt06LbZ7xe2TCE5cLkJXj0H176mr1bi
	 iwIzpVu2O+orypXcwr3YMeyIDGRUC+9cwuaQnVZR3JxAdkyrA3tStzI1P3XKEG1FK+WlS
	 t9iIo6QnPNptOdl0qgp7FfeHmvS8Pq7lH452aQJ+3Gk73UyFElZqf8K42suy9JWNyQkqG
	 st+BK5SgLJeOB1xtaFj+J+SY+s8mSZx5MBydwk2DIA+VW6wEHE1yRxwtBeYR/AbEFsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tndSO6AO;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1CE606D829;
	Thu,  5 Nov 2026 22:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F1CE606D829
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=tndSO6AO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=ImNXfCQmwXS9wJk0EFQdI0ui/ZNN1dZT9BSoVQQXZro=; b=tndSO6AO9dgEJOy6NcbZIJyMXv
	fP4abZBXoJRzASMIRnLy9I1wjnK4uX+VFVbgHFXEpU8jWVm23S2PvFrt5MGcn5i9dW5SCJHfBmZZ2
	RooN3z1e99SDFj9Ay4ENOQbXivGT7KSdtRopPMWSTOlrQ15W5Pc592xByTG5a5Q/p4VVikk8kmdtj
	vIa+WELquVzGuaecJDU6RRjVZnebxQ2fo6gc2yjm/1WlkIUpx9bJI47+QUyrP0AsV6jPqphmyOC7R
	n3Mx/rYSaOYect9f6bML8eM0xG3ht6eXl/I0PXWXs/L4SsetHhO50qJnTASKzZxR2BS2lH7KCBbx/
	n8Jn23Nw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xP6DA-00000000ypY-1v8F;
	Thu, 05 Nov 2026 19:45:37 -0300
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
Subject: [PATCH v5 16/17] smb: client: fail writeback sends and reopens fast when the server is gone
Date: Thu,  5 Nov 2026 19:45:30 -0300
Message-ID: <20261105224531.2316211-17-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105224531.2316211-1-pc@manguebit.org>
References: <20261105224531.2316211-1-pc@manguebit.org>
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
collector.  Have the worker try the reopen only once, and back off
before queueing, so that a dead mount can't tie up the shared worker
for the other mounts.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h  | 13 ++++++-
 fs/smb/client/cifsproto.h |  6 ++--
 fs/smb/client/cifssmb.c   |  2 +-
 fs/smb/client/connect.c   |  1 +
 fs/smb/client/file.c      | 71 ++++++++++++++++++++++++---------------
 fs/smb/client/misc.c      |  7 +++-
 fs/smb/client/smb2ops.c   |  9 +++--
 fs/smb/client/smb2pdu.c   | 53 ++++++++++++++++++++++++-----
 fs/smb/client/transport.c | 15 ++++++---
 9 files changed, 130 insertions(+), 47 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index edc5a6ad03c6..7bcb39a6b0da 100644
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
@@ -1410,6 +1418,7 @@ struct cifs_open_parms {
 	bool reconnect:1;
 	bool replay:1; /* indicates that this open is for a replay */
 	bool no_replay:1; /* don't replay this open internally */
+	bool no_reconnect_wait:1; /* fail fast, don't wait for reconnect */
 	struct kvec *ea_cctx;
 	__le32 lease_flags;
 };
@@ -1504,6 +1513,7 @@ struct cifs_io_subrequest {
 	int				result;
 	bool				have_xid;
 	bool				replay;
+	bool				deferred;	/* issue in a worker */
 	unsigned int			reopens;
 	unsigned int			retries;	/* number of retries so far */
 	unsigned int			cur_sleep;	/* time to sleep before replay */
@@ -1945,6 +1955,7 @@ enum cifs_find_flags {
 #define   CIFS_COMPRESS_REQ       0x4000 /* compress request before sending */
 #define   CIFS_INTERRUPTIBLE_WAIT 0x8000 /* Interruptible wait (e.g. lock request) */
 #define   CIFS_WINDOWS_LOCK       0x10000 /* We're trying to get a Windows lock */
+#define   CIFS_NO_RECONNECT_WAIT  0x20000 /* don't wait if conn is down */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 8b7914dd13af..eec8593130a9 100644
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
@@ -443,7 +444,8 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 }
 
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
index fc2a9baeae64..d517d9a1746d 100644
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
index d318f8202e2c..5e3b1a189b7f 100644
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
@@ -178,13 +178,7 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
 		retrying = true;
 		reconnects = cifs_ses_reconnects(ses);
 		rc = cifs_reopen_file(cfile, can_flush, CIFS_REOPEN_BOUND);
-		if (!rc || is_interrupt_error(rc) ||
-		    cifs_writeback_dying(&subreq->subreq))
-			return rc;
-		if (!is_replayable_error(rc) &&
-		    !(writeback && cifs_writeback_transient(rc)))
-			return rc;
-		if (writeback && READ_ONCE(subreq->req->reopen_gave_up))
+		if (!rc || !is_replayable_error(rc))
 			return rc;
 		if (free_retry && !cifs_io_stopped(subreq) &&
 		    (cifs_ses_reconnects(ses) != reconnects ||
@@ -192,15 +186,33 @@ static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
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
 
+static int cifs_reopen_writeback(struct cifs_io_subrequest *wdata)
+{
+	struct cifs_io_request *req = wdata->req;
+	int rc;
+
+	if (cifs_io_aborted(wdata))
+		return -EIO;
+	rc = cifs_reopen_file(req->cfile, false,
+			      CIFS_REOPEN_BOUND | CIFS_REOPEN_NOWAIT);
+	if (!rc || !cifs_writeback_transient(rc))
+		return rc;
+	if (READ_ONCE(req->reopen_gave_up) || !cifs_io_should_replay(wdata)) {
+		WRITE_ONCE(req->reopen_gave_up, true);
+		return -EIO;
+	}
+	wdata->replay = true;
+	trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
+	__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	return rc;
+}
+
 /*
  * Record, as generation + 1 (0 means none), the newest reopen generation of a
  * handle that a writeback subrequest found bad (-EBADF).  Subrequests of the
@@ -239,6 +251,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *open_file = req->cfile;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(wdata->rreq->inode->i_sb);
+	bool writeback = subreq->rreq->origin == NETFS_WRITEBACK;
 	bool reprepared = wdata->have_xid;
 	size_t wsize = req->rreq.wsize;
 	int rc;
@@ -250,6 +263,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 	wdata->server = server;
+	wdata->deferred = false;
 
 	if (cifs_io_aborted(wdata) ||
 	    (reprepared && cifs_io_stopped(wdata))) {
@@ -267,21 +281,20 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	cifs_invalidate_bad_handle(req);
 
 	if (open_file->invalidHandle) {
+		if (writeback)
+			goto defer;
 		rc = cifs_reopen_file_retry(open_file, false, wdata);
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
@@ -289,6 +302,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	goto out;
 
 defer:
+	wdata->deferred = true;
 	wdata->credits = (struct cifs_credits){};
 	stream->sreq_max_len = min_t(size_t, wsize, SMB2_MAX_BUFFER_SIZE);
 out:
@@ -335,9 +349,6 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	if (rc)
 		goto fail;
 
-	if (wdata->replay && wdata->cur_sleep)
-		msleep(wdata->cur_sleep);
-
 	rc = -EAGAIN;
 	if (wdata->req->cfile->invalidHandle)
 		goto fail;
@@ -370,11 +381,10 @@ static void cifs_issue_write_worker(struct work_struct *work)
 	cfile = wdata->req->cfile;
 	cifs_invalidate_bad_handle(wdata->req);
 	if (cfile->invalidHandle)
-		rc = cifs_reopen_file_retry(cfile, false, wdata);
+		rc = cifs_reopen_writeback(wdata);
 	if (rc) {
 		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
-		cifs_write_subrequest_terminated(wdata,
-				cifs_writeback_error(&wdata->subreq, rc));
+		cifs_write_subrequest_terminated(wdata, rc);
 		return;
 	}
 	__cifs_issue_write(&wdata->subreq);
@@ -382,7 +392,13 @@ static void cifs_issue_write_worker(struct work_struct *work)
 
 static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 {
-	if (unlikely(cifs_writeback_dying(subreq))) {
+	struct cifs_io_subrequest *wdata =
+		container_of(subreq, struct cifs_io_subrequest, subreq);
+
+	if (wdata->replay && wdata->cur_sleep)
+		msleep(wdata->cur_sleep);
+
+	if (unlikely(wdata->deferred || cifs_writeback_dying(subreq))) {
 		subreq->work.func = cifs_issue_write_worker;
 		WARN_ON_ONCE(!queue_work(cifs_writeback_wq, &subreq->work));
 		return;
@@ -432,7 +448,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	}
 
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
-					   &size, &rdata->credits);
+					   &size, &rdata->credits, false);
 	if (rc)
 		return rc;
 
@@ -1658,6 +1674,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush, unsigned int flags)
 		.reconnect = !fresh,
 		.replay = fresh,
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
index 6eefe91a0c9a..bceaec2d3ef0 100644
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
 
@@ -4365,7 +4393,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
@@ -4397,7 +4426,8 @@ void smb2_reconnect_server(struct work_struct *work)
 	/* now reconnect sessions for necessary channels */
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
-		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true);
+		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
+				    false);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
@@ -5213,8 +5243,13 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
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
index d0d0159c1061..a9431dd448da 100644
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
@@ -634,7 +641,7 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 
 int
 cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
-		      size_t *num, struct cifs_credits *credits)
+		      size_t *num, struct cifs_credits *credits, bool nowait)
 {
 	*num = size;
 	credits->value = 0;
-- 
2.56.0

