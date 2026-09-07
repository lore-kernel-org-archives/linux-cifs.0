Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F069A4AD4AB;
	Mon,  7 Sep 2026 15:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788793265; cv=none; b=MRGWRQag7ewyVFfVyCAAM1vpCw4+sY6afn4Bh7fHWCxznqOV2P7sTJvZSzWbQWpj0PLhMbVpuYG7d+3siDwT1SXeZ2o/L6KQqNhXwh6TGFOXrMt1TbGZi8aEVWcHXbthQk70y9S65m3HJtbYNQ7cJBzCwpl3+pXNtGoWbMey+jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788793265; c=relaxed/simple;
	bh=hnei0qBM+776PuJsJMa1hdV9xqwff1IHrKDZJhKk9lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHGFH6H0Mjb/vZSBWX06u91hN+IHb72v3fUSYsrFLneAcp7xk1gluDPe5DqSsDeHCJWfanlRWWAEAjiJ1wUQVSt02Vh3tpDg3eyd5Ca/UEiLIRkFWOXo1ji4NzoQ1sWG53Ll7s7rOPwzOyhvOCCZr/EYtgXf1oOFzcYEc1bXR1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjxYylOE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjxYylOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D771F00A3A;
	Mon,  7 Sep 2026 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788793262;
	bh=dQWXfNvp388dh0//08XQpkSyt93YJ5YIv+4COOyiCnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjxYylOEQPWfw1qX+qCSk5Z+NI51MGDTVhmFEn+gX/KxMSIUgbY6Aram+oeNPTcRN
	 KaZKaZk17jIsAOVi1m7/4Hzh2Ddjb35fMIEfhqX5zVN2UEeC5s30Nh+4hdQHY1lCYr
	 FWRGuG2XZXWCehb7mzEeKqtCAhqrHRTZyzNP7TdJgdrtBKkJ/WV+NsqEkgwRKS8jMM
	 45Von9Mxisk4XVOtfxMbiTvQOD02nH8vndq0gB0p0OquKaINHXhk8y2S/ED05ibw74
	 1S1FO6UZy8sz7FsKmXGt9rRCD35d/VP+C68CG8r2Bv25ExzI9VgrnIvf7Jwbfr+m66
	 c9nI8sVI26iwA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12.y 1/6] cifs: Remove the server pointer from smb_message
Date: Mon,  7 Sep 2026 11:00:54 -0400
Message-ID: <20260907150059.3712249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026090303-ashamed-silver-ed5c@gregkh>
References: <2026090303-ashamed-silver-ed5c@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 87fba18abbb8433a47045c785f2edc027e4d2bc5 ]

Remove the server pointer from smb_message and instead pass it down to all
the things that access it.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com> (RDMA, smbdirect)
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[ sashal: Reduced backport -- upstream 87fba18abbb84 touches 12 file(s), this
  backport carries 10. Not backported here:
  fs/smb/client/cifsfs.c
  fs/smb/client/cifstransport.c
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 730d0bb19507 ("smb: client: fix UAF and buffer leak in cifs_check_trans2() for malformed secondary T2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h      |  6 +--
 fs/smb/client/cifsproto.h     | 19 +++++----
 fs/smb/client/cifssmb.c       | 20 ++++------
 fs/smb/client/connect.c       | 29 +++++++-------
 fs/smb/client/netmisc.c       |  5 ++-
 fs/smb/client/smb1ops.c       |  4 +-
 fs/smb/client/smb2ops.c       | 22 +++++------
 fs/smb/client/smb2pdu.c       | 23 +++++------
 fs/smb/client/smb2transport.c |  8 ++--
 fs/smb/client/transport.c     | 74 +++++++++++++++++------------------
 10 files changed, 102 insertions(+), 108 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 3f9c03828cd4f..d61a6424f20ca 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1630,7 +1630,8 @@ typedef int (mid_receive_t)(struct TCP_Server_Info *server,
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
  */
-typedef void (mid_callback_t)(struct mid_q_entry *mid);
+typedef void (mid_callback_t)(struct TCP_Server_Info *server,
+			      struct mid_q_entry *mid);
 
 /*
  * This is the protopyte for mid handle function. This is called once the mid
@@ -1642,8 +1643,7 @@ typedef int (mid_handle_t)(struct TCP_Server_Info *server,
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	struct kref refcount;
-	struct TCP_Server_Info *server;	/* server corresponding to this mid */
+	refcount_t refcount;
 	__u64 mid;		/* multiplex id */
 	__u16 credits;		/* number of credits consumed by this mid */
 	__u16 credits_received;	/* number of credits from the response */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index d2d004764a708..5f28eee91eb9d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -83,9 +83,10 @@ extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 				     int add_treename);
 extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
 char *cifs_build_devname(char *nodename, const char *prepath);
-extern void delete_mid(struct mid_q_entry *mid);
-void __release_mid(struct kref *refcount);
-extern void cifs_wake_up_task(struct mid_q_entry *mid);
+extern void delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
+void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
+extern void cifs_wake_up_task(struct TCP_Server_Info *server,
+			      struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
 extern char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx,
@@ -172,7 +173,8 @@ extern int decode_negTokenInit(unsigned char *security_blob, int length,
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int map_smb_to_linux_error(char *buf, bool logErr);
-extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
+extern int map_and_check_smb_error(struct TCP_Server_Info *server,
+				   struct mid_q_entry *mid, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
@@ -255,7 +257,8 @@ extern unsigned int setup_special_mode_ACE(struct smb_ace *pace,
 					   __u64 nmode);
 extern unsigned int setup_special_user_owner_ACE(struct smb_ace *pace);
 
-extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
+extern void dequeue_mid(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool malformed);
 extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
@@ -763,9 +766,11 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
-static inline void release_mid(struct mid_q_entry *mid)
+static inline void release_mid(struct TCP_Server_Info *server,
+			       struct mid_q_entry *mid)
 {
-	kref_put(&mid->refcount, __release_mid);
+	if (refcount_dec_and_test(&mid->refcount))
+		__release_mid(server, mid);
 }
 
 static inline void cifs_free_open_info(struct cifs_open_info_data *data)
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 01c78d9e7ec0e..89f9c8d70109e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -560,12 +560,11 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-cifs_echo_callback(struct mid_q_entry *mid)
+cifs_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct TCP_Server_Info *server = mid->callback_data;
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
-	release_mid(mid);
+	release_mid(server, mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -1263,12 +1262,11 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 }
 
 static void
-cifs_readv_callback(struct mid_q_entry *mid)
+cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
-	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 2,
 				 .rq_iter = rdata->subreq.io_iter };
@@ -1331,7 +1329,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	rdata->subreq.error = rdata->result;
 	rdata->subreq.transferred += rdata->got_bytes;
 	queue_work(cifsiod_wq, &rdata->subreq.work);
-	release_mid(mid);
+	release_mid(server, mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -1638,11 +1636,9 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
  * workqueue completion task.
  */
 static void
-cifs_writev_callback(struct mid_q_entry *mid)
+cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_io_subrequest *wdata = mid->callback_data;
-	struct TCP_Server_Info *server = wdata->server;
-	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
 	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
 	struct cifs_credits credits = {
 		.value = 1,
@@ -1655,7 +1651,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		result = cifs_check_receive(mid, tcon->ses->server, 0);
+		result = cifs_check_receive(mid, server, 0);
 		if (result != 0)
 			break;
 
@@ -1692,11 +1688,11 @@ cifs_writev_callback(struct mid_q_entry *mid)
 			      0, cifs_trace_rw_credits_write_response_clear);
 	wdata->credits.value = 0;
 	cifs_write_subrequest_terminated(wdata, result, true);
-	release_mid(mid);
+	release_mid(server, mid);
 	trace_smb3_rw_credits(credits.rreq_debug_id, credits.rreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
-	add_credits(tcon->ses->server, &credits, 0);
+	add_credits(server, &credits, 0);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 52ac9b096a402..a550e51472c2f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -339,7 +339,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_lock);
 	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
-		kref_get(&mid->refcount);
+		refcount_inc(&mid->refcount);
 		if (mid->mid_state == MID_REQUEST_SUBMITTED)
 			mid->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid->qhead, &retry_list);
@@ -351,8 +351,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
 		list_del_init(&mid->qhead);
-		mid->callback(mid);
-		release_mid(mid);
+		mid->callback(server, mid);
+		release_mid(server, mid);
 	}
 
 	if (cifs_rdma_enabled(server)) {
@@ -866,12 +866,13 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 void
-dequeue_mid(struct mid_q_entry *mid, bool malformed)
+dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+	    bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
 #endif
-	spin_lock(&mid->server->mid_lock);
+	spin_lock(&server->mid_lock);
 	if (!malformed)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
@@ -881,12 +882,12 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 	 * function has finished processing it is a bug.
 	 */
 	if (mid->mid_flags & MID_DELETED) {
-		spin_unlock(&mid->server->mid_lock);
+		spin_unlock(&server->mid_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
-		spin_unlock(&mid->server->mid_lock);
+		spin_unlock(&server->mid_lock);
 	}
 }
 
@@ -922,7 +923,7 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		else
 			server->smallbuf = NULL;
 	}
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 }
 
 int
@@ -1019,7 +1020,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
-			kref_get(&mid_entry->refcount);
+			refcount_inc(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
 			mid_entry->mid_flags |= MID_DELETED;
@@ -1031,8 +1032,8 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
-			mid_entry->callback(mid_entry);
-			release_mid(mid_entry);
+			mid_entry->callback(server, mid_entry);
+			release_mid(server, mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
@@ -1275,7 +1276,7 @@ cifs_demultiplex_thread(void *p)
 		if (length < 0) {
 			for (i = 0; i < num_mids; i++)
 				if (mids[i])
-					release_mid(mids[i]);
+					release_mid(server, mids[i]);
 			continue;
 		}
 
@@ -1308,9 +1309,9 @@ cifs_demultiplex_thread(void *p)
 				}
 
 				if (!mids[i]->multiRsp || mids[i]->multiEnd)
-					mids[i]->callback(mids[i]);
+					mids[i]->callback(server, mids[i]);
 
-				release_mid(mids[i]);
+				release_mid(server, mids[i]);
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 2a8d71221e5e7..8db57bd1a39de 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -881,7 +881,8 @@ map_smb_to_linux_error(char *buf, bool logErr)
 }
 
 int
-map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
+map_and_check_smb_error(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool logErr)
 {
 	int rc;
 	struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
@@ -896,7 +897,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
 		if (class == ERRSRV && code == ERRbaduid) {
 			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
 				code);
-			cifs_signal_cifsd_for_reconnect(mid->server, false);
+			cifs_signal_cifsd_for_reconnect(server, false);
 		}
 	}
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 4670c3e451a75..ee8c3c54a4634 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -97,7 +97,7 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 		if (compare_mid(mid->mid, buf) &&
 		    mid->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
-			kref_get(&mid->refcount);
+			refcount_inc(&mid->refcount);
 			spin_unlock(&server->mid_lock);
 			return mid;
 		}
@@ -398,7 +398,7 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 			return true;
 		/* All parts received or packet is malformed. */
 		mid->multiEnd = true;
-		dequeue_mid(mid, malformed);
+		dequeue_mid(server, mid, malformed);
 		return true;
 	}
 	if (!server->large_buf) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e99b8e1f66d4f..e6e8c64a5d3d6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -417,7 +417,7 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
-			kref_get(&mid->refcount);
+			refcount_inc(&mid->refcount);
 			if (dequeue) {
 				list_del_init(&mid->qhead);
 				mid->mid_flags |= MID_DELETED;
@@ -4727,7 +4727,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_RECEIVED;
 		else
-			dequeue_mid(mid, false);
+			dequeue_mid(server, mid, false);
 		return 0;
 	}
 
@@ -4754,7 +4754,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
@@ -4773,7 +4773,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4783,7 +4783,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 
@@ -4794,7 +4794,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			if (is_offloaded)
 				mid->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(mid, rdata->result);
+				dequeue_mid(server, mid, rdata->result);
 			return 0;
 		}
 		rdata->got_bytes = data_len;
@@ -4813,14 +4813,14 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		if (is_offloaded)
 			mid->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(mid, rdata->result);
+			dequeue_mid(server, mid, rdata->result);
 		return 0;
 	}
 
 	if (is_offloaded)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		dequeue_mid(mid, false);
+		dequeue_mid(server, mid, false);
 	return 0;
 }
 
@@ -4867,7 +4867,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				dw->server->ops->is_network_name_deleted(dw->buf,
 									 dw->server);
 
-			mid->callback(mid);
+			mid->callback(dw->server, mid);
 		} else {
 			spin_lock(&dw->server->srv_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
@@ -4875,7 +4875,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&dw->server->mid_lock);
 				spin_unlock(&dw->server->srv_lock);
-				mid->callback(mid);
+				mid->callback(dw->server, mid);
 			} else {
 				spin_lock(&dw->server->mid_lock);
 				mid->mid_state = MID_REQUEST_SUBMITTED;
@@ -4886,7 +4886,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				spin_unlock(&dw->server->srv_lock);
 			}
 		}
-		release_mid(mid);
+		release_mid(dw->server, mid);
 	}
 
 free_pages:
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5a8a9e4ba36db..bd271d614ed6c 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4121,9 +4121,8 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-smb2_echo_callback(struct mid_q_entry *mid)
+smb2_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct TCP_Server_Info *server = mid->callback_data;
 	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 
@@ -4133,7 +4132,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 		credits.instance = server->reconnect_instance;
 	}
 
-	release_mid(mid);
+	release_mid(server, mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -4537,12 +4536,11 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 }
 
 static void
-smb2_readv_callback(struct mid_q_entry *mid)
+smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_io_subrequest *rdata = mid->callback_data;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
-	struct TCP_Server_Info *server = rdata->server;
 	struct smb2_hdr *shdr =
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = {
@@ -4559,9 +4557,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		rqst.rq_iter	  = rdata->subreq.io_iter;
 	}
 
-	WARN_ONCE(rdata->server != mid->server,
+	WARN_ONCE(rdata->server != server,
 		  "rdata server %p != mid server %p",
-		  rdata->server, mid->server);
+		  rdata->server, server);
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu/%zu\n",
 		 __func__, mid->mid, mid->mid_state, rdata->result,
@@ -4652,7 +4650,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	rdata->subreq.transferred += rdata->got_bytes;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	queue_work(cifsiod_wq, &rdata->subreq.work);
-	release_mid(mid);
+	release_mid(server, mid);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_read_response_add);
@@ -4829,11 +4827,10 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
  * workqueue completion task.
  */
 static void
-smb2_writev_callback(struct mid_q_entry *mid)
+smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_io_subrequest *wdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
-	struct TCP_Server_Info *server = wdata->server;
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
 	struct cifs_credits credits = {
 		.value = 0,
@@ -4846,9 +4843,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	ssize_t result = 0;
 	size_t written;
 
-	WARN_ONCE(wdata->server != mid->server,
+	WARN_ONCE(wdata->server != server,
 		  "wdata server %p != mid server %p",
-		  wdata->server, mid->server);
+		  wdata->server, server);
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -4926,7 +4923,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	wdata->credits.value = 0;
 	trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_progress);
 	cifs_write_subrequest_terminated(wdata, result ?: written, true);
-	release_mid(mid);
+	release_mid(server, mid);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 31d22af0c626c..5c0ceb3cc0dd7 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -792,14 +792,12 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 
 	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	memset(temp, 0, sizeof(struct mid_q_entry));
-	kref_init(&temp->refcount);
+	refcount_set(&temp->refcount, 1);
 	temp->mid = le64_to_cpu(shdr->MessageId);
 	temp->credits = credits > 0 ? credits : 1;
 	temp->pid = current->pid;
 	temp->command = shdr->Command; /* Always LE */
 	temp->when_alloc = jiffies;
-	temp->server = server;
-
 	/*
 	 * The default is for the mid to be synchronous, so the
 	 * default callback just wakes up the current task.
@@ -915,7 +913,7 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(mid);
+		delete_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 
@@ -949,7 +947,7 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		release_mid(mid);
+		release_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index d7dbbd908cd90..68523c94a70f9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -35,7 +35,7 @@
 #define CIFS_MAX_IOV_SIZE 8
 
 void
-cifs_wake_up_task(struct mid_q_entry *mid)
+cifs_wake_up_task(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	if (mid->mid_state == MID_RESPONSE_RECEIVED)
 		mid->mid_state = MID_RESPONSE_READY;
@@ -54,7 +54,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
 	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	memset(temp, 0, sizeof(struct mid_q_entry));
-	kref_init(&temp->refcount);
+	refcount_set(&temp->refcount, 1);
 	temp->mid = get_mid(smb_buffer);
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
@@ -62,8 +62,6 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	/* easier to use jiffies */
 	/* when mid allocated can be before when sent */
 	temp->when_alloc = jiffies;
-	temp->server = server;
-
 	/*
 	 * The default is for the mid to be synchronous, so the
 	 * default callback just wakes up the current task.
@@ -78,18 +76,15 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-void __release_mid(struct kref *refcount)
+void __release_mid(struct TCP_Server_Info *server,
+		   struct mid_q_entry *midEntry)
 {
-	struct mid_q_entry *midEntry =
-			container_of(refcount, struct mid_q_entry, refcount);
 #ifdef CONFIG_CIFS_STATS2
-	__le16 command = midEntry->server->vals->lock_cmd;
+	__le16 command = server->vals->lock_cmd;
 	__u16 smb_cmd = le16_to_cpu(midEntry->command);
 	unsigned long now;
 	unsigned long roundtrip_time;
 #endif
-	struct TCP_Server_Info *server = midEntry->server;
-
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
 	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
 	     midEntry->mid_state == MID_RESPONSE_READY) &&
@@ -159,16 +154,16 @@ void __release_mid(struct kref *refcount)
 }
 
 void
-delete_mid(struct mid_q_entry *mid)
+delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	spin_lock(&mid->server->mid_lock);
+	spin_lock(&server->mid_lock);
 	if (!(mid->mid_flags & MID_DELETED)) {
 		list_del_init(&mid->qhead);
 		mid->mid_flags |= MID_DELETED;
 	}
-	spin_unlock(&mid->server->mid_lock);
+	spin_unlock(&server->mid_lock);
 
-	release_mid(mid);
+	release_mid(server, mid);
 }
 
 /*
@@ -780,7 +775,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 
 	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
-		release_mid(mid);
+		release_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 
@@ -855,7 +850,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
 		server->sequence_number -= 2;
-		delete_mid(mid);
+		delete_mid(server, mid);
 	}
 
 	cifs_server_unlock(server);
@@ -930,7 +925,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	spin_unlock(&server->mid_lock);
 
 sync_mid_done:
-	release_mid(mid);
+	release_mid(server, mid);
 	return rc;
 }
 
@@ -970,11 +965,11 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	}
 
 	/* BB special case reconnect tid and uid here? */
-	return map_and_check_smb_error(mid, log_error);
+	return map_and_check_smb_error(server, mid, log_error);
 }
 
 struct mid_q_entry *
-cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored,
+cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb_rqst *rqst)
 {
 	int rc;
@@ -988,18 +983,17 @@ cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored,
 	rc = allocate_mid(ses, hdr, &mid);
 	if (rc)
 		return ERR_PTR(rc);
-	rc = cifs_sign_rqst(rqst, ses->server, &mid->sequence_number);
+	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
-		delete_mid(mid);
+		delete_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 	return mid;
 }
 
 static void
-cifs_compound_callback(struct mid_q_entry *mid)
+cifs_compound_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct TCP_Server_Info *server = mid->server;
 	struct cifs_credits credits = {
 		.value = server->ops->get_credits(mid),
 		.instance = server->reconnect_instance,
@@ -1012,17 +1006,19 @@ cifs_compound_callback(struct mid_q_entry *mid)
 }
 
 static void
-cifs_compound_last_callback(struct mid_q_entry *mid)
+cifs_compound_last_callback(struct TCP_Server_Info *server,
+			    struct mid_q_entry *mid)
 {
-	cifs_compound_callback(mid);
-	cifs_wake_up_task(mid);
+	cifs_compound_callback(server, mid);
+	cifs_wake_up_task(server, mid);
 }
 
 static void
-cifs_cancelled_callback(struct mid_q_entry *mid)
+cifs_cancelled_callback(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid)
 {
-	cifs_compound_callback(mid);
-	release_mid(mid);
+	cifs_compound_callback(server, mid);
+	release_mid(server, mid);
 }
 
 /*
@@ -1155,7 +1151,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		if (IS_ERR(midQ[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-				delete_mid(midQ[j]);
+				delete_mid(server, midQ[j]);
 			cifs_server_unlock(server);
 
 			/* Update # of requests on wire to server */
@@ -1306,7 +1302,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	for (i = 0; i < num_rqst; i++) {
 		if (!cancelled_mid[i])
-			delete_mid(midQ[i]);
+			delete_mid(server, midQ[i]);
 	}
 
 	return rc;
@@ -1470,7 +1466,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	delete_mid(midQ);
+	delete_mid(server, midQ);
 	add_credits(server, &credits, 0);
 
 	return rc;
@@ -1563,7 +1559,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_sign_smb(in_buf, server, &midQ->sequence_number);
 	if (rc) {
-		delete_mid(midQ);
+		delete_mid(server, midQ);
 		cifs_server_unlock(server);
 		return rc;
 	}
@@ -1578,7 +1574,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	cifs_server_unlock(server);
 
 	if (rc < 0) {
-		delete_mid(midQ);
+		delete_mid(server, midQ);
 		return rc;
 	}
 
@@ -1603,7 +1599,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   blocking lock to return. */
 			rc = send_cancel(server, &rqst, midQ);
 			if (rc) {
-				delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		} else {
@@ -1615,7 +1611,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		}
@@ -1655,7 +1651,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	delete_mid(midQ);
+	delete_mid(server, midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
@@ -1694,7 +1690,7 @@ __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	int length;
 
 	length = cifs_discard_remaining_data(server);
-	dequeue_mid(mid, malformed);
+	dequeue_mid(server, mid, malformed);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
@@ -1837,7 +1833,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->total_read < buflen)
 		return cifs_readv_discard(server, mid);
 
-	dequeue_mid(mid, false);
+	dequeue_mid(server, mid, false);
 	mid->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
-- 
2.53.0

