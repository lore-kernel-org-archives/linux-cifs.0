Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632536;
	b=3l0Ow63C2/991ZayV8kDVsweDkwH0jizoDXRIz1dezqn8tJmQ9fry15YcWEjU4Vbq6k8
	 JTfiVzWMm/4fT0+28V5nhkuqZDiulg6ZVBw93TxJ3vGy2OPhpjMlx1VEMxf+T/el1BLUE
	 4WKxajGhjnAH9P+KVnbZC0HFLv4bZJTm4pppBaeaGZmfMUEfVSbN3jjZSI2x/veyg+xah
	 7EyCSYpEu1toprKV3btf6pi9s8e3hj2SiJtDYmZrZ/y9z0bHLTfsiYezgGTosNDuScf3T
	 ws+04RsGYVdaOrJSnOUaJTxVtEYUtwqVy1wjgzCJWZLSbOU7AB0RpfMrppZYbAOH2aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632536;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3bFhAMxZUXT3Jup5PEO61RiTxTb56U44fcsPX51KTas=;
	b=LPHGr3nrkUo/UP8cbcYmvcO34HDVTgIK1n/bCvMvJZVWt6+0UYCd3k8549c59cLfi1Vv
	 AC2e3i+x3+JAlBRjQZTeGEDI8PixtiVrSujA5ohple6sBTl7NZtR1GsR88+DeQ7qT3Iuz
	 Mq4lqOW3DYG3817JvSKaKHp3fE9WKfD7LrajVHuHRBRSGSyLsEZ8ajHf6lW3NL6K4KhU9
	 GiRljcyIO1/zoBJfONgkRFxL0cqvtn8wY9gZU7Of/dVtJ1lUAZ/QXQwRgJJVU02wwDpio
	 KOJEwEGgSfMqtokptiETreeRkSnzgku6yPFEjTsQDP/10CpzFmpfhqVtGQHIYrk6D0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bRqnw5pG;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EDB607B405;
	Mon,  2 Nov 2026 15:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02EDB607B405
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=bRqnw5pG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=3bFhAMxZUXT3Jup5PEO61RiTxTb56U44fcsPX51KTas=; b=bRqnw5pG8+uSyTVkekw6gEiDVb
	oPv0VQD3XWdfGJjJ8XRbAAclECoCgvgy0ttiMfhvoudFp9nlJxUsOm6hJipEMT0JVXuBW2vKPnA+z
	fUAqybKfg6Cw08wsoJXzy86/HOPmBQy8Qlbu11XBABKm0vWk1aQrmsqoJ6A0W+Anb7hSwhykBkfTH
	Sg6hBaCcX3tLxt3FNEyuIAsUdWMGgOf1i8imatvJyFwcIwy+WLmJTM/OHSXyg96fnA7LOcbXzgCe4
	VnDoEYhhe5XyZZC23IGUiqidPOoTtrTNPRNJnSh4ZmRKgHxs49RAOLMLPSJ2Y3zvYtlhXzYG3YCTx
	wKoOJDUQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNtks-00000000aQs-1yae;
	Mon, 02 Nov 2026 12:15:27 -0300
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
Subject: [PATCH 05/15] smb: client: let umount -f abort retried reads and writes
Date: Mon,  2 Nov 2026 12:15:15 -0300
Message-ID: <20261102151525.925058-6-pc@manguebit.org>
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

umount -f only wakes up tasks waiting on the server's queues.  Reads and
writes being retried - forever on hard mounts - keep going, so with the
server gone the unmount still hangs in sync_filesystem() waiting for
their writeback.  NFS kills outstanding RPCs on umount -f instead.

Count umount -f attempts per superblock and have each read and write
request remember the count it started with.  Neither retry nor reissue
subrequests of requests that predate a umount -f, nor issue them while
the server or share is disconnected, failing them with -EIO instead.
First attempts on a connected server still go ahead, and requests
started later are unaffected, so I/O on a healthy server keeps working
if the unmount then fails with -EBUSY or only detaches one of several
mounts.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifs_fs_sb.h |  1 +
 fs/smb/client/cifsfs.c     |  1 +
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/cifsproto.h  |  2 ++
 fs/smb/client/file.c       | 42 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2pdu.c    | 16 ++++-----------
 6 files changed, 51 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifs_fs_sb.h b/fs/smb/client/cifs_fs_sb.h
index d6494e1d93cc..743441b2a55b 100644
--- a/fs/smb/client/cifs_fs_sb.h
+++ b/fs/smb/client/cifs_fs_sb.h
@@ -57,6 +57,7 @@ struct cifs_sb_info {
 	atomic_t active;
 	atomic_t mnt_cifs_flags;
 	atomic_t outstanding_rreq;	/* nr of rreqs not yet fully deinitialized */
+	atomic_t umount_aborts;		/* nr of umount -f attempts */
 	struct delayed_work prune_tlinks;
 	struct rcu_head rcu;
 
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index bf199a5ca084..9db6a32d6e05 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -835,6 +835,7 @@ static void cifs_umount_begin(struct super_block *sb)
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
index aa2d09dac44c..3f87711b1021 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -39,6 +39,36 @@
 
 static int cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush);
 
+bool cifs_io_stopped(struct cifs_io_subrequest *subreq)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(subreq->rreq->inode);
+
+	if (cifs_forced_shutdown(cifs_sb))
+		return true;
+	return atomic_read(&cifs_sb->umount_aborts) !=
+	       subreq->req->umount_aborts;
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
+	return subreq->subreq.retry_count ||
+	       READ_ONCE(subreq->server->tcpStatus) == CifsNeedReconnect ||
+	       tcon->need_reconnect;
+}
+
 /*
  * Prepare a subrequest to upload to the server.  We need to allocate credits
  * so that we know the maximum amount of data that we can include in it.
@@ -58,6 +88,9 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	if (!wdata->have_xid) {
 		wdata->xid = get_xid();
 		wdata->have_xid = true;
+	} else if (cifs_io_stopped(wdata)) {
+		subreq->error = -EIO;
+		return netfs_prepare_write_failed(subreq);
 	}
 
 	server = cifs_pick_channel(tlink_tcon(open_file->tlink)->ses);
@@ -120,6 +153,10 @@ static void cifs_issue_write(struct netfs_io_subrequest *subreq)
 		goto fail;
 	}
 
+	rc = -EIO;
+	if (cifs_io_aborted(wdata))
+		goto fail;
+
 	rc = adjust_credits(wdata->server, wdata, cifs_trace_rw_credits_issue_write_adjust);
 	if (rc)
 		goto fail;
@@ -218,6 +255,10 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 		 __func__, rreq->debug_id, subreq->debug_index, rreq->mapping,
 		 subreq->transferred, subreq->len);
 
+	rc = -EIO;
+	if (cifs_io_aborted(rdata))
+		goto failed;
+
 	rc = adjust_credits(server, rdata, cifs_trace_rw_credits_issue_read_adjust);
 	if (rc)
 		goto failed;
@@ -282,6 +323,7 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
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

