Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794007120;
	b=U+dCa0rzCJY2cvjwkPe8Ai3qIh8jRw8c6USwmk51cUW+SYnmhmPTKC1DAn6Z3XjaWGq8
	 9zFZh+pZfuk7ipRO0LhoDZaqU9rNz+zdv/gVju41BCAaBXqzfZFHqm4WTwClAijM++uJw
	 GkbqwiHgZWWVqubDlp/BIQCzIB7V+RnpKtzqdOG4qpYywWksaZgPQ5XctQnMKzmqmvsAN
	 H9fXsx5Ws+pwzPjF/3v7k2r7VLbbmOsJMNtfyxh+O9DZhiUeis5rydYtKZlAAnS8b08HW
	 kxWXonr8sRRaaj4LYFiWcqDW30r5K/h0Is3rk3F0CMh9D6K3vWVnXlY9G/ZXqanxtKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794007120;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ONVBZOGRK6Li/BFHinDMKlUeKD/Gp6VvcaHhv+nvDQU=;
	b=tsRBGCEBd3vbCDltszcRMC/wqeLWBkoXmxgIOSLOcJdWfEpzRDIRTnuwKLld8dvgnm0g
	 eFDupXIx553glBZTARWZIf/L1YXPOn+WeRaMC5qfZMqCs+d4WceQ6OxKlcsrhcoj3NS8w
	 Vk2WDbU3uE9qRMUmIrWLSqb5NfUwLzaxH4KrVTRO8wfd7d/mJAtfrYAt7d8SllCR6udUJ
	 yFiB+DdSJ72QvMaWD1GwSz15lDqteJVh7yjsEcfvoOteBmkOwhqsD7fAWLjdMqxnfqdUi
	 Nk+llxQdhnDRqJTvLiE/72DmWz8ibtbQ8RMxMJmFMJvo7qwaPqnA9nhhusPcftmq2dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vEGFMg3O;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9E606A336;
	Fri,  6 Nov 2026 23:18:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64A9E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vEGFMg3O
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=ONVBZOGRK6Li/BFHinDMKlUeKD/Gp6VvcaHhv+nvDQU=; b=vEGFMg3O1lghdx4OZjHnRrcopd
	Vg2Jexwtn8hZxJvNj3QhK6ydFX0JOTmBvpwd/oeKDEGaZq84fLvPuA9+/IHVwX9UUO4qiFPKeuk1/
	/n/ykPy8/u3tp6G3zgJgrmb296FK9TxvlpAgzuX6xmf9eJt926CaMLmHo0KL5+pHx9TBqrmhK4P+J
	rBU6ij8aZwfRbO8yNdLj6r7G6fnMiLlk4T1EcmnqGN7hoQHQpZvhT74fzq5UY04eSFles0y7drN6U
	uxUMc/ffckZQfbLgE0zogjEpHP2ib+Vee+vk7qS9ZDSPS6Wb9baFmATE2zFiCuEfxgpsXTblK71l7
	aOxtJnDw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPTCW-000000014Dy-2TIG;
	Fri, 06 Nov 2026 20:18:29 -0300
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
Subject: [PATCH v7 05/19] smb: client: let umount -f abort retried reads and writes
Date: Fri,  6 Nov 2026 20:18:13 -0300
Message-ID: <20261106231827.2604956-6-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261106231827.2604956-1-pc@manguebit.org>
References: <20261106231827.2604956-1-pc@manguebit.org>
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

umount -f only wakes up tasks waiting on the server's queues.  Reads and
writes being retried - forever on hard mounts - keep going, so with the
server gone the unmount still hangs in sync_filesystem() waiting for
their writeback.  NFS kills outstanding RPCs on umount -f instead.

Count umount -f attempts per superblock and have each read and write
request remember the count it started with.  Fail with -EIO, rather than
retry, reissue, issue or wait for credits, any subrequest of a request
that predates a umount -f once it is a retry or the server or share is
disconnected; a kworker doing writeback can't be signalled out of the
credit wait otherwise.  First attempts on a connected server still go
ahead, and requests started later aren't aborted (but see below), so
I/O on a healthy server keeps working if the unmount then fails with
-EBUSY or only detaches one of several mounts.

retry_count is not bumped yet when netfs_retry_write_stream() calls
prepare_write() for the first retry, so don't rely on it alone to tell a
reissue from a first attempt: treat a subrequest as a retry when it
already carries an xid (it has been prepared before) in
prepare_write()/prepare_read(), or when its replay flag is set in
cifs_io_aborted(), and abort it when the mount is going away even if the
connection still looks healthy.

Requests created after umount -f - writeback kicked off by the background
flusher, an oplock break or sync_filesystem() during the final teardown -
snapshot the already bumped count and would otherwise retry forever on a
hard mount, hanging cifs_kill_sb().  Once a superblock that saw a umount
-f reaches cifs_kill_sb() the mount is going away for good, so flag it and
stop retrying I/O on it too; one that never saw a umount -f still
flushes as before.

A sync(2) or syncfs() waiting under s_umount for writeback started after
umount -f would still keep the unmount from reaching cifs_kill_sb(), so
also stop retrying such I/O while s_umount is contended.  After a failed
umount -f, that also stops reads and writes retrying while a remount,
freeze or new mount of the same superblock waits on s_umount.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifs_fs_sb.h |  2 ++
 fs/smb/client/cifsfs.c     | 10 +++++++
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/cifsproto.h  |  2 ++
 fs/smb/client/file.c       | 55 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2pdu.c    | 16 +++--------
 6 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index d6494e1d93cc..b322718d9199 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -57,6 +57,7 @@ struct cifs_sb_info {
 	atomic_t active;
 	atomic_t mnt_cifs_flags;
 	atomic_t outstanding_rreq;	/* nr of rreqs not yet fully deinitialized */
+	atomic_t umount_aborts;		/* nr of umount -f attempts */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
@@ -68,6 +69,7 @@ struct cifs_sb_info {
 	 * (cifs_autodisable_serverino) in order to match new mounts.
 	 */
 	bool mnt_cifs_serverino_autodisabled;
+	bool exiting;			/* umount -f committed: stop retries */
 	/*
 	 * Available once the mount has completed.
 	 */
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bf199a5ca084..b3735c98bfc3 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -297,6 +297,15 @@ static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 
+	/*
+	 * Reaching here after a umount -f means the mount is going away for
+	 * good, so stop retrying I/O that can no longer complete (e.g.
+	 * writeback to a server that is gone) rather than looping forever on
+	 * a hard mount and hanging the teardown below.
+	 */
+	if (atomic_read(&cifs_sb->umount_aborts))
+		WRITE_ONCE(cifs_sb->exiting, true);
+
 	/*
 	 * We need to release all dentries for the cached directories
 	 * and close all deferred file handles before we kill the sb.
@@ -835,6 +844,7 @@ static void cifs_umount_begin(struct super_block *sb)
 	if (cifs_sb == NULL)
 		return;
 
+	atomic_inc(&cifs_sb->umount_aborts);
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&cifs_tcp_ses_lock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index dbf980fcf05b..fb732c178e76 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1482,6 +1482,7 @@ struct cifs_io_request {
 	struct netfs_io_request		rreq;
 	struct cifsFileInfo		*cfile;
 	pid_t				pid;
+	int				umount_aborts;
 };
 
 /* asynchronous read support */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f9ea35597bc2..a37eee2ca54b 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -137,6 +137,8 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file,
 			    bool from_readdir);
 void cifs_write_subrequest_terminated(struct cifs_io_subrequest *wdata,
 				      ssize_t result);
+bool cifs_io_stopped(struct cifs_io_subrequest *subreq);
+bool cifs_io_should_replay(struct cifs_io_subrequest *subreq);
 struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_inode,
 					int flags);
 int __cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index aa2d09dac44c..270858e526f9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -39,6 +39,40 @@
 
 static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
 
+bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
+{
+	struct super_block *sb = subreq->rreq->inode->i_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	int aborts;
+
+	if (cifs_forced_shutdown(cifs_sb) || READ_ONCE(cifs_sb->exiting))
+		return true;
+	aborts = atomic_read(&cifs_sb->umount_aborts);
+	if (aborts != subreq->req->umount_aborts)
+		return true;
+	return aborts && rwsem_is_contended(&sb->s_umount);
+}
+
+bool cifs_io_should_replay(struct cifs_io_subrequest *subreq)
+{
+	struct cifs_tcon *tcon = tlink_tcon(subreq->req->cfile->tlink);
+
+	if (cifs_io_stopped(subreq))
+		return false;
+	return smb2_should_replay(tcon, &subreq->retries, &subreq->cur_sleep);
+}
+
+static bool cifs_io_aborted(struct cifs_io_subrequest *subreq)
+{
+	struct cifs_tcon *tcon = tlink_tcon(subreq->req->cfile->tlink);
+
+	if (!cifs_io_stopped(subreq))
+		return false;
+	return subreq->subreq.retry_count || subreq->replay ||
+	       READ_ONCE(subreq->server->tcpStatus) == CifsNeedReconnect ||
+	       tcon->need_reconnect;
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -52,6 +86,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	struct TCP_Server_Info *server;
 	struct cifsFileInfo *open_file = req->cfile;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(wdata->rreq->inode->i_sb);
+	bool reprepared = wdata->have_xid;
 	size_t wsize = req->rreq.wsize;
 	int rc;
 
@@ -63,6 +98,12 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
 	wdata->server = server;
 
+	if (cifs_io_aborted(wdata) ||
+	    (reprepared && cifs_io_stopped(wdata))) {
+		subreq->error = -EIO;
+		return netfs_prepare_write_failed(subreq);
+	}
+
 	if (cifs_sb->ctx->wsize == 0)
 		cifs_negotiate_wsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
@@ -120,6 +161,10 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 		goto fail;
 	}
 
+	rc = -EIO;
+	if (cifs_io_aborted(wdata))
+		goto fail;
+
 	rc = adjust_credits(wdata->server, wdata, cifs_trace_rw_credits_issue_write_adjust);
 	if (rc)
 		goto fail;
@@ -157,6 +202,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	struct cifs_io_request *req = container_of(subreq->rreq, struct cifs_io_request, rreq);
 	struct TCP_Server_Info *server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
+	bool reprepared = rdata->have_xid;
 	size_t size;
 	int rc = 0;
 
@@ -168,6 +214,10 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 	rdata->server = server;
 
+	if (cifs_io_aborted(rdata) ||
+	    (reprepared && cifs_io_stopped(rdata)))
+		return -EIO;
+
 	if (cifs_sb->ctx->rsize == 0)
 		cifs_negotiate_rsize(server, cifs_sb->ctx,
 				     tlink_tcon(req->cfile->tlink));
@@ -218,6 +268,10 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 		 __func__, rreq->debug_id, subreq->debug_index, rreq->mapping,
 		 subreq->transferred, subreq->len);
 
+	rc = -EIO;
+	if (cifs_io_aborted(rdata))
+		goto failed;
+
 	rc = adjust_credits(server, rdata, cifs_trace_rw_credits_issue_read_adjust);
 	if (rc)
 		goto failed;
@@ -282,6 +336,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 	rreq->rsize = cifs_sb->ctx->rsize;
 	rreq->wsize = cifs_sb->ctx->wsize;
 	req->pid = current->tgid; // Ummm...  This may be a workqueue
+	req->umount_aborts = atomic_read(&cifs_sb->umount_aborts);
 
 	if (file) {
 		open_file = file->private_data;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f85595136ef8..ecc127d9f0af 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4815,9 +4815,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* see if we need to retry */
 	if (is_replayable_error(rdata->result) &&
-	    smb2_should_replay(tcon,
-			       &rdata->retries,
-			       &rdata->cur_sleep))
+	    cifs_io_should_replay(rdata))
 		rdata->replay = true;
 
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, rdata->credits.value,
@@ -4926,9 +4924,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 out:
 	/* if the send error is retryable, let netfs know about it */
 	if (is_replayable_error(rc) &&
-	    smb2_should_replay(tcon,
-			       &rdata->retries,
-			       &rdata->cur_sleep)) {
+	    cifs_io_should_replay(rdata)) {
 		rdata->replay = true;
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_retry_needed);
 		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
@@ -5165,9 +5161,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* see if we need to retry */
 	if (is_replayable_error(wdata->result) &&
-	    smb2_should_replay(tcon,
-			       &wdata->retries,
-			       &wdata->cur_sleep))
+	    cifs_io_should_replay(wdata))
 		wdata->replay = true;
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
@@ -5339,9 +5333,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 out:
 	/* if the send error is retryable, let netfs know about it */
 	if (is_replayable_error(rc) &&
-	    smb2_should_replay(tcon,
-			       &wdata->retries,
-			       &wdata->cur_sleep)) {
+	    cifs_io_should_replay(wdata)) {
 		wdata->replay = true;
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
 		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-- 
2.56.0

