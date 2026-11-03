Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728988;
	b=XpW/NEaf2otRA81zyYPtcQU2jrW9zg88/TxX0r0tMYJ1tZ6510p+KBbhoWyEItu0lgwV
	 QIS67qzvAyR+5c2MWpex4SXufqBK1Kd0jeiZHhAcDI8BXnThJwL2/XzR5kJystU/GfY6B
	 k+DO2Z0iAGuaeoFKtHIVSFsc8SMbimpZHBxYotrH09FldcLK/PYiw+UGORsmyg1hBFiKj
	 /nN9IzuW9NPiuW9QhpJ+xTmpOZN8pur1ke6FC4fNBzz+yp0rYIVGjLzqf5pnKriaAmVaL
	 ijDCmCkcW4tLCpr7h3PuRojPpa9vXNcRnh6LKubfekCWinHkxjx1rQ6oTCneA7G0kcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728988;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Af5nXtu4Vm6tZy6zekdNf5b3susK8a/FQOZw8vkz5sc=;
	b=VWhaiH4Bxlu+40dJVa+re0nWNTKuX8vskL1tSo9IGLRT0FhLdyje07R569YxEimyT7bo
	 BrqiHOIww8wZtQior30j3p/BtUtSs+8F37tmI1qbrUZqVXMtKX0Yw+7LdUlOgWh2CKsKe
	 HuHfer2BfU5ihJQYZ/mpkVrZ5mgLYBpRaYxXtXuHexBNLAxNyUfqMNye8jKVQDMfjv6DC
	 4Bn1WZ+DcZIWwDzdyUO2mL3IIcfCsFFHiXpiAspXqnn5ys32dkriHQVsRE4ruYTothIuZ
	 4lZnx6Gb8Wm/0022vNtf4cklxydhcEZ3Wbt588i08CIP20zBzsgbtY99OPKM8NUXSoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="VUmJH/Tk";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588DE606A33E;
	Tue,  3 Nov 2026 18:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 588DE606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=VUmJH/Tk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=Af5nXtu4Vm6tZy6zekdNf5b3susK8a/FQOZw8vkz5sc=; b=VUmJH/TkInmPJTa/higPpdRQGi
	blONNqJiNHmUfV2neezLodvsnHpWREA6ZBlEQor7bp5mm3hDgwQrP3D6UuWrreXLhtALhAYju9ABR
	1QtVAU5o3l7pSuacXSj5x5zI8+x/peyDMwouEDpXluCeaY7V8MYM+j6mFmOUE1ACSd+ZRK7pVpMOr
	gd0vUBUrP4Wrp9wYIQzjT4i14Ar/aNoXcdLC/FekN0cM13mLAaZb6l8eE/a0PYsUL66Cr5YeqDTjD
	YrZsuHn1KKONiySATqYKNs/+xQZATsd9NbXVa47pn7pzneXy/sDTOq0Sw8WtME/VlXKPvDHY5OPZw
	yol/z4lw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqZ-00000000ivx-1A8U;
	Tue, 03 Nov 2026 15:03:00 -0300
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
Subject: [PATCH v2 13/16] smb: client: retry writeback after losing the connection, share or handle
Date: Tue,  3 Nov 2026 15:02:52 -0300
Message-ID: <20261103180255.1482516-14-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
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
 fs/smb/client/cifsglob.h |   5 ++
 fs/smb/client/cifssmb.c  |   6 +-
 fs/smb/client/file.c     | 159 +++++++++++++++++++++++++++++++++++----
 3 files changed, 153 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 064a2cdab4d9..96d2d858214e 100644
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
@@ -1483,6 +1484,9 @@ struct cifs_io_request {
 	struct cifsFileInfo		*cfile;
 	pid_t				pid;
 	int				umount_aborts;
+	bool				reopen_gave_up;
+	bool				bad_handle;
+	unsigned int			bad_reopens;
 };
 
 /* asynchronous read support */
@@ -1497,6 +1501,7 @@ struct cifs_io_subrequest {
 	int				result;
 	bool				have_xid;
 	bool				replay;
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
index f1d6827205f6..d65cae045d74 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -90,12 +90,117 @@ static bool cifs_io_aborted(struct cifs_io_subrequest *subreq)
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
+static bool cifs_tcon_reconnecting(struct cifs_tcon *tcon)
+{
+	struct cifs_ses *ses = tcon->ses;
+
+	if (tcon->need_reconnect)
+		return true;
+
+	guard(spinlock)(&ses->chan_lock);
+	for (size_t i = 0; i < ses->chan_count; i++) {
+		struct TCP_Server_Info *server = ses->chans[i].server;
+
+		if (server && READ_ONCE(server->tcpStatus) == CifsNeedReconnect)
+			return true;
+	}
+	return false;
+}
+
+static int cifs_reopen_file_retry(struct cifsFileInfo *cfile, bool can_flush,
+				  struct cifs_io_subrequest *subreq)
+{
+	bool writeback = subreq->rreq->origin == NETFS_WRITEBACK;
+	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct cifs_ses *ses = tcon->ses;
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
+		if (free_retry && !cifs_io_stopped(subreq) &&
+		    (cifs_ses_reconnects(ses) != reconnects ||
+		     cifs_tcon_reconnecting(tcon))) {
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
+static void cifs_invalidate_bad_handle(struct cifs_io_request *req)
+{
+	struct cifsFileInfo *cfile = req->cfile;
+
+	WRITE_ONCE(req->bad_handle, false);
+	guard(mutex)(&cfile->fh_mutex);
+	if (cfile->reopens == req->bad_reopens)
+		cfile->invalidHandle = true;
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -129,18 +234,20 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 		cifs_negotiate_wsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
 
+	if (READ_ONCE(req->bad_handle))
+		cifs_invalidate_bad_handle(req);
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
@@ -150,7 +257,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	if (rc < 0) {
 		if (cifs_writeback_dying(subreq))
 			goto defer;
-		subreq->error = rc;
+		subreq->error = cifs_writeback_error(subreq, rc);
 		return netfs_prepare_write_failed(subreq);
 	}
 	goto out;
@@ -209,6 +316,7 @@ static void __cifs_issue_write(struct netfs_io_subrequest *subreq)
 	if (wdata->replay && wdata->cur_sleep)
 		msleep(wdata->cur_sleep);
 
+	wdata->reopens = READ_ONCE(wdata->req->cfile->reopens);
 	wdata->server->ops->async_writev(wdata);
 out:
 	return;
@@ -229,12 +337,18 @@ static void cifs_issue_write_worker(struct work_struct *work)
 {
 	struct cifs_io_subrequest *wdata;
 	struct cifsFileInfo *cfile;
+	int rc = 0;
 
 	wdata = container_of(work, struct cifs_io_subrequest, subreq.work);
 	cfile = wdata->req->cfile;
-	while (cfile->invalidHandle &&
-	       cifs_reopen_file(cfile, false) == -EAGAIN)
-		;
+	if (cfile->invalidHandle)
+		rc = cifs_reopen_file_retry(cfile, false, wdata);
+	if (rc) {
+		add_credits_and_wake_if(wdata->server, &wdata->credits, 0);
+		cifs_write_subrequest_terminated(wdata,
+				cifs_writeback_error(&wdata->subreq, rc));
+		return;
+	}
 	__cifs_issue_write(&wdata->subreq);
 }
 
@@ -281,6 +395,12 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
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
@@ -336,9 +456,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 		goto failed;
 
 	if (req->cfile->invalidHandle) {
-		do {
-			rc = cifs_reopen_file(req->cfile, true);
-		} while (rc == -EAGAIN);
+		rc = cifs_reopen_file_retry(req->cfile, true, rdata);
 		if (rc)
 			goto failed;
 	}
@@ -357,6 +475,8 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	return;
 
 failed:
+	if (rc == -EAGAIN)
+		__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	subreq->error = rc;
 	netfs_read_subreq_terminated(subreq);
@@ -1536,6 +1656,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 reopen_success:
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
+	WRITE_ONCE(cfile->reopens, cfile->reopens + 1);
 	cfile->invalidHandle = false;
 	mutex_unlock(&cfile->fh_mutex);
 	cinode = CIFS_I(inode);
@@ -2754,14 +2875,22 @@ void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata, ssize_t
 		spin_unlock(&inode->i_lock);
 	}
 
-	if ((is_interrupt_error(result) || result == -ENOMEM) &&
-	    wreq->origin == NETFS_WRITEBACK && cifs_io_should_replay(wdata)) {
+	if (wreq->origin == NETFS_WRITEBACK &&
+	    !test_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags) &&
+	    cifs_writeback_transient(result) && cifs_io_should_replay(wdata)) {
+		if (result == -EBADF) {
+			wdata->req->bad_reopens = wdata->reopens;
+			WRITE_ONCE(wdata->req->bad_handle, true);
+		}
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

