Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632538;
	b=soXhvDK0B6xlfLvwJGe05/xjGOe5NbZHBWKY4GYF2z32gtirnIkbSobZMXmEbXs0zEKp
	 Gra+VPr9KYKjYEI6fiuX7nY9tebFng3l3937Z/MH0ziY3DNKLmj2+gFx1n81do+55raks
	 3LkVWtT16TARQjtLyvdvdQe5Qfn6gpYzSa6DoVpREfFtN29CPRBs8XqdMN00zS7ctQ9J/
	 gM050qGlZarQ0XyRhW/1ezEbWMYAgtv9XunBGZYmfJ7VqJoT57jRdUi3eHJ4QTBSKUZBa
	 M9+93LcYEIWt+kC6rDUXzWbRjR3aW4cZWVpzK98XYhCmAOYl4xiBd2ymeF5YQ14o2CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632538;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oHrRbfPdc5vmSpv0Jl6aiMpgO8yh2vSvaFTH5zcOad0=;
	b=XIYAn8tcJoU60pJdxhaxMq1il055LJbTd9dfCgzIeO2OGa26tiPxsADAqL6i4XxZPhr/
	 JA1KQdqrz+NrWow+vgkPT7U7Y0k+OiuyW5Eiwedq7SPYq6HtI9vJzamNfAqJmGSHSg+DB
	 kUDOBiLj2EczAo96ifaojmMyIgyx7Sokxz2ETCdpeuqztHGw5PbWcWr+hSknJIyJIZJX0
	 QUMqNz0O7KK1NdFu51pmhPSWObZuRd1GWuO+dFBoE4lJJMcz9nO3w4XW3GCIr6JbDci1Z
	 Y14N9bv8N1Mf8a3XF/EXwiCJvjk4vR/Oh7Fl46kFMwhtBSC4hZch9lf9dI8bb8+pa+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=jJNAru9b;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132B4607B799;
	Mon,  2 Nov 2026 15:15:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 132B4607B799
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=jJNAru9b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=oHrRbfPdc5vmSpv0Jl6aiMpgO8yh2vSvaFTH5zcOad0=; b=jJNAru9bfYa80vQmjEG/TJj6Fo
	kyE4Rn566vNE6C6LZcj2EUQPCFUrGQv53c/qCWbf9upVgsbt40cDiD5I5RQmaoowHO1up99Y8oyF3
	fgPGCMR3ot1kpRwJFoL7t5KG7sk7sgbNNYnxV99khFpJOqmsson+NpBSfw8FfwUxHzUrNRXWCFwt0
	JKMubfMGE9RYPA9ILbrwCCP2Uxamebw07+JaB+ntEofFI/o0JJ0bygAMKrCa8LNgVINIzIGz+fGZi
	nR7O/93kdBH35mGM3WCyVqnJ0HVCcVt5xzCh+Uuy2g2rdKJS+jZARq8c2GcBncmIQDcAg73DjFpnE
	G/1dIH6Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtkv-00000000aTB-2JY4;
	Mon, 02 Nov 2026 12:15:30 -0300
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
Subject: [PATCH 14/15] smb: client: retry writeback after losing the connection, share or handle
Date: Mon,  2 Nov 2026 12:15:24 -0300
Message-ID: <20261102151525.925058-15-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
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

Writeback still fails, dropping its data, when a write gets back an
error that only means the client lost track of the server for a while:

 - -EHOSTDOWN from smb2_reconnect() when a soft mount's server stays
   unreachable for longer than the reconnect wait, or from
   STATUS_HOST_UNREACHABLE,
 - -EREMCHG from STATUS_NETWORK_NAME_DELETED, for which the receive path
   already marks the tcon for reconnect,
 - -EBADF from STATUS_FILE_CLOSED or STATUS_INVALID_HANDLE, e.g. after
   the server lost a durable handle,
 - -ENETRESET and -ESHUTDOWN from STATUS_CONNECTION_RESET and
   STATUS_REMOTE_DISCONNECT,
 - any replayable error on SMB1, whose async write never retries them,
   while it retries writes cut short by a reconnect forever, regardless
   of soft mounts.

Reopening the handle needed by a read or write is worse:
cifs_prepare_write() and cifs_issue_read() retry cifs_reopen_file() only
on -EAGAIN, with no limit and no delay, and fail on anything else.  A
server failing the reopen with a status mapped to -EAGAIN, such as
STATUS_INSUFFICIENT_RESOURCES, makes them spin forever, past umount -f
and, when netfs retries from a worker, with no signal to stop them,
while any of the errors above fails writeback right away.

Retry writeback failing with any of these, as already done for
interrupts and allocation failures, with backoff and giving up on umount
-f.  On -EBADF, have the retry mark the handle invalid, so that it gets
reopened, unless it got reopened since the write was issued: a late
-EBADF would otherwise get the new handle replaced too, leaving it open
on the server along with any byte-range locks pushed to it.

When writeback finally gives up on any of these errors, record -EIO for
it instead, so that fsync(2) and close(2) don't return transient or
internal errors such as -EAGAIN or -ERESTARTSYS.

Retry reopens as the read or write needing them gets retried: as above
for writeback, otherwise per the hard and retrans mount options on
replayable errors, with backoff and giving up on umount -f.  If any
channel of the session got reconnected meanwhile, retry once regardless,
as the reconnect may be what failed the reopen; the next attempt waits
for the reconnect to finish.  Never retry reopens on
interrupts, so that dying tasks don't spin there; for writeback, issue
the subrequest without credits instead, as done for dying tasks, so
that it gets retried from the netfs collector, where no signals are
pending.

Don't reopen for requests that predate a umount -f either, unless it is
a first attempt on a connected server, as with issuing them.  Once a
reopen for writeback gives up, have the other subrequests of the
request try only once, rather than each waiting out a retry window of
its own.

Reopen handles for reads before waiting for credits, as already done
for writes, so that reads don't hold credits while their reopens get
retried.  Keep reopening at issue time for handles invalidated in
between.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsglob.h |   4 ++
 fs/smb/client/cifssmb.c  |   6 +-
 fs/smb/client/file.c     | 129 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 122 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 064a2cdab4d9..0c27773e0838 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1458,6 +1458,7 @@ struct cifsFileInfo {
 	int count;
 	spinlock_t file_info_lock; /* protects four flag/count fields above */
 	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
+	unsigned int reopens;
 	struct cifs_search_info srch_inf;
 	struct work_struct oplock_break; /* work for oplock breaks */
 	struct work_struct put; /* work for the final part of _put */
@@ -1483,6 +1484,7 @@ struct cifs_io_request {
 	struct cifsFileInfo		*cfile;
 	pid_t				pid;
 	int				umount_aborts;
+	bool				reopen_gave_up;
 };
 
 /* asynchronous read support */
@@ -1497,6 +1499,8 @@ struct cifs_io_subrequest {
 	int				result;
 	bool				have_xid;
 	bool				replay;
+	bool				bad_handle;
+	unsigned int			reopens;
 	unsigned int			retries;	/* number of retries so far */
 	unsigned int			cur_sleep;	/* time to sleep before replay */
 	unsigned long			retry_deadline;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2936b38de98f..fcf97b3d6bea 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1939,12 +1939,14 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		if (wdata->rreq->origin != NETFS_WRITEBACK)
+			__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RETRY_NEEDED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		if (wdata->rreq->origin != NETFS_WRITEBACK)
+			__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0340933dec82..ab795139aa43 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -90,12 +90,98 @@ static bool cifs_io_aborted(struct cifs_io_subrequest *subreq)
 	       tcon->need_reconnect;
 }
 
+static bool cifs_writeback_transient(int rc)
+{
+	if (is_replayable_error(rc) || is_interrupt_error(rc))
+		return true;
+
+	switch (rc) {
+	case -ENOMEM:
+	case -EHOSTDOWN:
+	case -ENETRESET:
+	case -ESHUTDOWN:
+	case -EREMCHG:
+	case -EBADF:
+		return true;
+	}
+	return false;
+}
+
+static int cifs_writeback_error(struct netfs_io_subrequest *subreq, int rc)
+{
+	if (subreq->rreq->origin == NETFS_WRITEBACK &&
+	    cifs_writeback_transient(rc))
+		return -EIO;
+	return rc;
+}
+
 static bool cifs_writeback_dying(struct netfs_io_subrequest *subreq)
 {
 	return subreq->rreq->origin == NETFS_WRITEBACK &&
 		fatal_signal_pending(current);
 }
 
+static unsigned int cifs_ses_reconnects(struct cifs_ses *ses)
+{
+	unsigned int n = 0;
+
+	guard(spinlock)(&ses->chan_lock);
+	for (size_t i = 0; i < ses->chan_count; i++) {
+		struct TCP_Server_Info *server = ses->chans[i].server;
+
+		if (server)
+			n += READ_ONCE(server->reconnect_instance);
+	}
+	return n;
+}
+
+static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
+				  struct cifs_io_subrequest *subreq)
+{
+	bool writeback = subreq->rreq->origin == NETFS_WRITEBACK;
+	struct cifs_ses *ses = tlink_tcon(cfile->tlink)->ses;
+	unsigned int reconnects;
+	bool free_retry = true;
+	bool retrying = false;
+	int rc;
+
+	for (;;) {
+		if ((retrying && cifs_io_stopped(subreq)) ||
+		    cifs_io_aborted(subreq))
+			return -EIO;
+		retrying = true;
+		reconnects = cifs_ses_reconnects(ses);
+		rc = cifs_reopen_file(cfile, can_flush);
+		if (!rc || is_interrupt_error(rc))
+			return rc;
+		if (!is_replayable_error(rc) &&
+		    !(writeback && cifs_writeback_transient(rc)))
+			return rc;
+		if (free_retry && cifs_ses_reconnects(ses) != reconnects &&
+		    !cifs_io_stopped(subreq)) {
+			free_retry = false;
+			continue;
+		}
+		if ((writeback && READ_ONCE(subreq->req->reopen_gave_up)) ||
+		    !cifs_io_should_replay(subreq)) {
+			if (writeback)
+				WRITE_ONCE(subreq->req->reopen_gave_up, true);
+			return rc;
+		}
+		msleep(subreq->cur_sleep);
+	}
+}
+
+static void cifs_invalidate_bad_handle(struct cifs_io_subrequest *wdata)
+{
+	struct cifsFileInfo *cfile = wdata->req->cfile;
+
+	wdata->bad_handle = false;
+	guard(mutex)(&cfile->fh_mutex);
+	if (cfile->reopens == wdata->reopens)
+		cfile->invalidHandle = true;
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -127,18 +213,20 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 		cifs_negotiate_wsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
 
+	if (wdata->bad_handle)
+		cifs_invalidate_bad_handle(wdata);
+
 	if (cifs_writeback_dying(subreq))
 		goto defer;
 
-retry:
 	if (open_file->invalidHandle) {
-		rc = cifs_reopen_file(open_file, false);
+		rc = cifs_reopen_file_retry(open_file, false, wdata);
 		if (rc < 0) {
-			if (rc == -EAGAIN)
-				goto retry;
-			if (cifs_writeback_dying(subreq))
+			if (subreq->rreq->origin == NETFS_WRITEBACK &&
+			    (is_interrupt_error(rc) ||
+			     fatal_signal_pending(current)))
 				goto defer;
-			subreq->error = rc;
+			subreq->error = cifs_writeback_error(subreq, rc);
 			return netfs_prepare_write_failed(subreq);
 		}
 	}
@@ -148,7 +236,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	if (rc < 0) {
 		if (cifs_writeback_dying(subreq))
 			goto defer;
-		subreq->error = rc;
+		subreq->error = cifs_writeback_error(subreq, rc);
 		return netfs_prepare_write_failed(subreq);
 	}
 	goto out;
@@ -207,6 +295,7 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	if (wdata->req->cfile->invalidHandle)
 		goto fail;
 
+	wdata->reopens = READ_ONCE(wdata->req->cfile->reopens);
 	wdata->server->ops->async_writev(wdata);
 out:
 	return;
@@ -230,9 +319,8 @@ static void cifs_issue_write_worker(struct work_struct *work)
 
 	wdata = container_of(work, struct cifs_io_subrequest, subreq.work);
 	cfile = wdata->req->cfile;
-	while (cfile->invalidHandle &&
-	       cifs_reopen_file(cfile, false) == -EAGAIN)
-		;
+	if (cfile->invalidHandle)
+		cifs_reopen_file_retry(cfile, false, wdata);
 	__cifs_issue_write(&wdata->subreq);
 }
 
@@ -276,6 +364,12 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 		cifs_negotiate_rsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
 
+	if (req->cfile->invalidHandle) {
+		rc = cifs_reopen_file_retry(req->cfile, true, rdata);
+		if (rc)
+			return rc;
+	}
+
 	rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
 					   &size, &rdata->credits);
 	if (rc)
@@ -334,9 +428,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 		goto failed;
 
 	if (req->cfile->invalidHandle) {
-		do {
-			rc = cifs_reopen_file(req->cfile, true);
-		} while (rc == -EAGAIN);
+		rc = cifs_reopen_file_retry(req->cfile, true, rdata);
 		if (rc)
 			goto failed;
 	}
@@ -1531,6 +1623,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 reopen_success:
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	WRITE_ONCE(cfile->reopens, cfile->reopens + 1);
 	cfile->invalidHandle = false;
 	mutex_unlock(&cfile->fh_mutex);
 	cinode = CIFS_I(inode);
@@ -2749,14 +2842,20 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 		spin_unlock(&inode->i_lock);
 	}
 
-	if ((is_interrupt_error(result) || result == -ENOMEM) &&
-	    wreq->origin == NETFS_WRITEBACK && cifs_io_should_replay(wdata)) {
+	if (wreq->origin == NETFS_WRITEBACK &&
+	    !test_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags) &&
+	    cifs_writeback_transient(result) && cifs_io_should_replay(wdata)) {
+		if (result == -EBADF)
+			wdata->bad_handle = true;
 		wdata->replay = true;
 		trace_netfs_sreq(&wdata->subreq,
 				 netfs_sreq_trace_io_retry_needed);
 		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 	}
 
+	if (result < 0 &&
+	    !test_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags))
+		result = cifs_writeback_error(&wdata->subreq, result);
 	netfs_write_subrequest_terminated(&wdata->subreq, result);
 }
 
-- 
2.56.0

