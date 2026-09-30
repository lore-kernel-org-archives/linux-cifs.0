Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51EB51DE07;
	Wed, 30 Sep 2026 21:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804553; cv=none; b=hAgWt+cjPaq69MG0tP93rKTPDUGh4hquU5znbOErK5fQ9erOryoQFyeT1VIiz7fqwpszpK4GUDRncLM+lN0cCe8dSY9UCVQgXs5SUJ3ZbgdCbTXyreFucqUWjzCFPIDD7sRJQ5FfFznFao9Kw8/VvCjDxBoVkmnee3Id0OeMRn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804553; c=relaxed/simple;
	bh=9CCPN+j8Wlx6MCQOuR9q/1iOf7xKMhRMaDnk382VUWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShcJORanVERZQQOhBJhCMoNkkJUFy6XcUwzyPculBxRMJttwXYgBA0rWGalahIELZURTEq5NEmC1i37m2XUCnrhqxUsteC52fY9LQdeiSOebCxQJCsF+0U/Pk4GbA8oWpI1Ee1Jmyg3JllglL0EjLEEjid4FmfQfqWBfyPjOL10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRGmhhlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRGmhhlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F71F00898;
	Wed, 30 Sep 2026 21:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804551;
	bh=cep3Xt9Xt+O0PBfWm6neKYILbKrQRMuPBhDFa0lHeB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRGmhhlOtWZaGFMUjYTMmpmAvt5Ng6/zZpJojHQdlQ43cKg+VHVb0HRbD1Of6rpQE
	 KCtBHJFyCj+oPs/URtEf5kyt5NasXKRmTVUpinOp4R8OZpYqvwA09wGkUtJpNsMPv+
	 BmDVBX4jVZ3nlCeas7sbn61RaVULCsEpvRD9Tjeh+DWlO+cWhUTTxYPzJcNv8ScObO
	 sYfHelESZS/tH8uj05d3SvzSVyF8Dk8ACGxZ3YAWi/6giAZ3D4TM4ow7XFt+cRers+
	 E8pNtTLNNQKp+YKBx7WvLLMCFs4DQ+KYsBSrtDjyvSdUz0D3MX24EP3QdQvl6Tnvlk
	 Laa7cDmTTyiTA==
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
Subject: [PATCH 5.15.y 2/3] cifs: Remove the server pointer from smb_message
Date: Wed, 30 Sep 2026 17:42:26 -0400
Message-ID: <20260930214227.3484209-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930214227.3484209-1-sashal@kernel.org>
References: <2026092900-threefold-unblessed-1235@gregkh>
 <20260930214227.3484209-1-sashal@kernel.org>
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

[5.15 backport: Keep the implementation in fs/cifs and adapt the existing
MID allocation, release and callback routines instead of importing the
newer cifstransport.c split or netfs I/O changes. Preserve GlobalMid_Lock,
MID flags, and the existing cifs_mid_poolp allocation scheme. dequeue_mid()
does not need a server argument with the global lock in this tree.

Use refcount_t and pass the owning server explicitly through all existing
MID callbacks and release paths. Use refcount_inc() directly rather than
adding smb_get_mid(). Rename the existing cifs_delete_mid() to delete_mid()
and the compound MID array to mid so the dependent fix can be cherry-picked
without changing its delete_mid(server, mid[i]) calls. No functions added.]

[ sashal: Reduced backport -- upstream 87fba18abbb84 touches 12 file(s), this
  backport carries 10. Not backported here:
  fs/smb/client/cifsfs.c
  fs/smb/client/cifsglob.h
  fs/smb/client/cifsproto.h
  fs/smb/client/cifssmb.c
  fs/smb/client/cifstransport.c
  fs/smb/client/connect.c
  fs/smb/client/netmisc.c
  fs/smb/client/smb1ops.c
  ... and 4 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 8f6f8a48399f ("smb: client: delete compound mids on send failure before unlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h      |   7 +--
 fs/cifs/cifsproto.h     |  20 ++++---
 fs/cifs/cifssmb.c       |  19 +++----
 fs/cifs/connect.c       |  18 +++----
 fs/cifs/netmisc.c       |   7 +--
 fs/cifs/smb1ops.c       |   2 +-
 fs/cifs/smb2ops.c       |   8 +--
 fs/cifs/smb2pdu.c       |  23 ++++----
 fs/cifs/smb2transport.c |   7 ++-
 fs/cifs/transport.c     | 116 +++++++++++++++++++---------------------
 10 files changed, 112 insertions(+), 115 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 616305a32e34a..f0214df840f75 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -16,6 +16,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/mempool.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
@@ -1526,7 +1527,8 @@ typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
  */
-typedef void (*mid_callback_t)(struct mid_q_entry *mid);
+typedef void (*mid_callback_t)(struct TCP_Server_Info *server,
+			       struct mid_q_entry *mid);
 
 /*
  * This is the protopyte for mid handle function. This is called once the mid
@@ -1538,8 +1540,7 @@ typedef int (*mid_handle_t)(struct TCP_Server_Info *server,
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
 	struct list_head qhead;	/* mids waiting on reply from this server */
-	struct kref refcount;
-	struct TCP_Server_Info *server;	/* server corresponding to this mid */
+	refcount_t refcount;
 	__u64 mid;		/* multiplex id */
 	__u16 credits;		/* number of credits consumed by this mid */
 	__u16 credits_received;	/* number of credits from the response */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8525d47f09494..e1b83ecf51737 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -81,10 +81,13 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
-extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
-extern void cifs_delete_mid(struct mid_q_entry *mid);
-void _cifs_mid_q_entry_release(struct kref *refcount);
-extern void cifs_wake_up_task(struct mid_q_entry *mid);
+extern void DeleteMidQEntry(struct TCP_Server_Info *server,
+			   struct mid_q_entry *midEntry);
+extern void delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
+void _cifs_mid_q_entry_release(struct TCP_Server_Info *server,
+			       struct mid_q_entry *midEntry);
+extern void cifs_wake_up_task(struct TCP_Server_Info *server,
+			     struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
 extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
@@ -154,7 +157,8 @@ extern int decode_negTokenInit(unsigned char *security_blob, int length,
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
 extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
 extern int map_smb_to_linux_error(char *buf, bool logErr);
-extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
+extern int map_and_check_smb_error(struct TCP_Server_Info *server,
+				   struct mid_q_entry *mid, bool logErr);
 extern void header_assemble(struct smb_hdr *, char /* command */ ,
 			    const struct cifs_tcon *, int /* length of
 			    fixed section (word count) in two byte units */);
@@ -634,9 +638,11 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
-static inline void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+static inline void cifs_mid_q_entry_release(struct TCP_Server_Info *server,
+					    struct mid_q_entry *midEntry)
 {
-	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+	if (refcount_dec_and_test(&midEntry->refcount))
+		_cifs_mid_q_entry_release(server, midEntry);
 }
 
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 11a400663b9f2..bf1db482470a6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -629,12 +629,11 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-cifs_echo_callback(struct mid_q_entry *mid)
+cifs_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct TCP_Server_Info *server = mid->callback_data;
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -1503,11 +1502,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 }
 
 static void
-cifs_readv_callback(struct mid_q_entry *mid)
+cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
-	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 2,
 				 .rq_pages = rdata->pages,
@@ -1552,7 +1550,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	}
 
 	queue_work(cifsiod_wq, &rdata->work);
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -2040,17 +2038,16 @@ cifs_writedata_direct_alloc(struct page **pages, work_func_t complete)
  * workqueue completion task.
  */
 static void
-cifs_writev_callback(struct mid_q_entry *mid)
+cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_writedata *wdata = mid->callback_data;
-	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	unsigned int written;
 	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		wdata->result = cifs_check_receive(mid, tcon->ses->server, 0);
+		wdata->result = cifs_check_receive(mid, server, 0);
 		if (wdata->result != 0)
 			break;
 
@@ -2081,8 +2078,8 @@ cifs_writev_callback(struct mid_q_entry *mid)
 	}
 
 	queue_work(cifsiod_wq, &wdata->work);
-	DeleteMidQEntry(mid);
-	add_credits(tcon->ses->server, &credits, 0);
+	DeleteMidQEntry(server, mid);
+	add_credits(server, &credits, 0);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d35474b836007..4183440766470 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -223,7 +223,7 @@ static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server
 	spin_lock(&GlobalMid_Lock);
 	list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-		kref_get(&mid_entry->refcount);
+		refcount_inc(&mid_entry->refcount);
 		if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
 			mid_entry->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid_entry->qhead, &retry_list);
@@ -236,8 +236,8 @@ static void cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server
 	list_for_each_safe(tmp, tmp2, &retry_list) {
 		mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 		list_del_init(&mid_entry->qhead);
-		mid_entry->callback(mid_entry);
-		cifs_mid_q_entry_release(mid_entry);
+		mid_entry->callback(server, mid_entry);
+		cifs_mid_q_entry_release(server, mid_entry);
 	}
 
 	if (cifs_rdma_enabled(server)) {
@@ -803,7 +803,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
-			kref_get(&mid_entry->refcount);
+			refcount_inc(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
 			mid_entry->mid_flags |= MID_DELETED;
@@ -815,8 +815,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
-			mid_entry->callback(mid_entry);
-			cifs_mid_q_entry_release(mid_entry);
+			mid_entry->callback(server, mid_entry);
+			cifs_mid_q_entry_release(server, mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
@@ -1058,7 +1058,7 @@ cifs_demultiplex_thread(void *p)
 		if (length < 0) {
 			for (i = 0; i < num_mids; i++)
 				if (mids[i])
-					cifs_mid_q_entry_release(mids[i]);
+					cifs_mid_q_entry_release(server, mids[i]);
 			continue;
 		}
 
@@ -1086,9 +1086,9 @@ cifs_demultiplex_thread(void *p)
 									server);
 
 				if (!mids[i]->multiRsp || mids[i]->multiEnd)
-					mids[i]->callback(mids[i]);
+					mids[i]->callback(server, mids[i]);
 
-				cifs_mid_q_entry_release(mids[i]);
+				cifs_mid_q_entry_release(server, mids[i]);
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 6ddab41f58738..dbfcc2a9eaefe 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -881,7 +881,8 @@ map_smb_to_linux_error(char *buf, bool logErr)
 }
 
 int
-map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
+map_and_check_smb_error(struct TCP_Server_Info *server,
+			struct mid_q_entry *mid, bool logErr)
 {
 	int rc;
 	struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
@@ -897,8 +898,8 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
 			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
 				code);
 			spin_lock(&GlobalMid_Lock);
-			if (mid->server->tcpStatus != CifsExiting)
-				mid->server->tcpStatus = CifsNeedReconnect;
+			if (server->tcpStatus != CifsExiting)
+				server->tcpStatus = CifsNeedReconnect;
 			spin_unlock(&GlobalMid_Lock);
 		}
 	}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 41e468d06b5b0..21e4db6f816e8 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -96,7 +96,7 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 		if (compare_mid(mid->mid, buf) &&
 		    mid->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
-			kref_get(&mid->refcount);
+			refcount_inc(&mid->refcount);
 			spin_unlock(&GlobalMid_Lock);
 			return mid;
 		}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3aaa45375d8ba..30cf6becd5983 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -339,7 +339,7 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
-			kref_get(&mid->refcount);
+			refcount_inc(&mid->refcount);
 			if (dequeue) {
 				list_del_init(&mid->qhead);
 				mid->mid_flags |= MID_DELETED;
@@ -5051,13 +5051,13 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				dw->server->ops->is_network_name_deleted(dw->buf,
 									 dw->server);
 
-			mid->callback(mid);
+			mid->callback(dw->server, mid);
 		} else {
 			spin_lock(&GlobalMid_Lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&GlobalMid_Lock);
-				mid->callback(mid);
+				mid->callback(dw->server, mid);
 			} else {
 				mid->mid_state = MID_REQUEST_SUBMITTED;
 				mid->mid_flags &= ~(MID_DELETED);
@@ -5066,7 +5066,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				spin_unlock(&GlobalMid_Lock);
 			}
 		}
-		cifs_mid_q_entry_release(mid);
+		cifs_mid_q_entry_release(dw->server, mid);
 	}
 
 free_pages:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index e93dd51a88557..f8900216b55bc 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3730,9 +3730,8 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-smb2_echo_callback(struct mid_q_entry *mid)
+smb2_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct TCP_Server_Info *server = mid->callback_data;
 	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 
@@ -3742,7 +3741,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 		credits.instance = server->reconnect_instance;
 	}
 
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -4033,11 +4032,10 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 }
 
 static void
-smb2_readv_callback(struct mid_q_entry *mid)
+smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
-	struct TCP_Server_Info *server = rdata->server;
 	struct smb2_hdr *shdr =
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
@@ -4052,9 +4050,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		rqst.rq_tailsz = rdata->tailsz;
 	}
 
-	WARN_ONCE(rdata->server != mid->server,
+	WARN_ONCE(rdata->server != server,
 		  "rdata server %p != mid server %p",
-		  rdata->server, mid->server);
+		  rdata->server, server);
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u\n",
 		 __func__, mid->mid, mid->mid_state, rdata->result,
@@ -4118,7 +4116,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				     rdata->offset, rdata->got_bytes);
 
 	queue_work(cifsiod_wq, &rdata->work);
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	add_credits(server, &credits, 0);
 }
 
@@ -4279,18 +4277,17 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
  * workqueue completion task.
  */
 static void
-smb2_writev_callback(struct mid_q_entry *mid)
+smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	struct cifs_writedata *wdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
-	struct TCP_Server_Info *server = wdata->server;
 	unsigned int written;
 	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 
-	WARN_ONCE(wdata->server != mid->server,
+	WARN_ONCE(wdata->server != server,
 		  "wdata server %p != mid server %p",
-		  wdata->server, mid->server);
+		  wdata->server, server);
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -4356,7 +4353,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 				      wdata->offset, wdata->bytes);
 
 	queue_work(cifsiod_wq, &wdata->work);
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	add_credits(server, &credits, 0);
 }
 
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index c76fe00180403..7f8e99111ce02 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -731,13 +731,12 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 
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
 
 	/*
 	 * The default is for the mid to be synchronous, so the
@@ -841,7 +840,7 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		cifs_delete_mid(mid);
+		delete_mid(server, mid);
 		return ERR_PTR(rc);
 	}
 
@@ -871,7 +870,7 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		DeleteMidQEntry(mid);
+		DeleteMidQEntry(server, mid);
 		return ERR_PTR(rc);
 	}
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d30183fac942e..8b4fbacb91fb9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -32,7 +32,7 @@
 #define CIFS_MAX_IOV_SIZE 8
 
 void
-cifs_wake_up_task(struct mid_q_entry *mid)
+cifs_wake_up_task(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	if (mid->mid_state == MID_RESPONSE_RECEIVED)
 		mid->mid_state = MID_RESPONSE_READY;
@@ -51,7 +51,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 
 	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	memset(temp, 0, sizeof(struct mid_q_entry));
-	kref_init(&temp->refcount);
+	refcount_set(&temp->refcount, 1);
 	temp->mid = get_mid(smb_buffer);
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
@@ -59,7 +59,6 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
 	/* when mid allocated can be before when sent */
 	temp->when_alloc = jiffies;
-	temp->server = server;
 
 	/*
 	 * The default is for the mid to be synchronous, so the
@@ -75,17 +74,15 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-void _cifs_mid_q_entry_release(struct kref *refcount)
+void _cifs_mid_q_entry_release(struct TCP_Server_Info *server,
+			       struct mid_q_entry *midEntry)
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
 
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
 	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
@@ -155,13 +152,13 @@ void _cifs_mid_q_entry_release(struct kref *refcount)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void DeleteMidQEntry(struct mid_q_entry *midEntry)
+void DeleteMidQEntry(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 {
-	cifs_mid_q_entry_release(midEntry);
+	cifs_mid_q_entry_release(server, midEntry);
 }
 
 void
-cifs_delete_mid(struct mid_q_entry *mid)
+delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
 	if (!(mid->mid_flags & MID_DELETED)) {
@@ -170,7 +167,7 @@ cifs_delete_mid(struct mid_q_entry *mid)
 	}
 	spin_unlock(&GlobalMid_Lock);
 
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 }
 
 /*
@@ -787,7 +784,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 
 	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
-		DeleteMidQEntry(mid);
+		DeleteMidQEntry(server, mid);
 		return ERR_PTR(rc);
 	}
 
@@ -862,7 +859,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
 		server->sequence_number -= 2;
-		cifs_delete_mid(mid);
+		delete_mid(server, mid);
 	}
 
 	mutex_unlock(&server->srv_mutex);
@@ -934,7 +931,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	}
 	spin_unlock(&GlobalMid_Lock);
 
-	DeleteMidQEntry(mid);
+	DeleteMidQEntry(server, mid);
 	return rc;
 }
 
@@ -974,11 +971,11 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
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
@@ -992,18 +989,17 @@ cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *ignored,
 	rc = allocate_mid(ses, hdr, &mid);
 	if (rc)
 		return ERR_PTR(rc);
-	rc = cifs_sign_rqst(rqst, ses->server, &mid->sequence_number);
+	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
 	if (rc) {
-		cifs_delete_mid(mid);
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
 	struct cifs_credits credits;
 
 	credits.value = server->ops->get_credits(mid);
@@ -1016,17 +1012,17 @@ cifs_compound_callback(struct mid_q_entry *mid)
 }
 
 static void
-cifs_compound_last_callback(struct mid_q_entry *mid)
+cifs_compound_last_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	cifs_compound_callback(mid);
-	cifs_wake_up_task(mid);
+	cifs_compound_callback(server, mid);
+	cifs_wake_up_task(server, mid);
 }
 
 static void
-cifs_cancelled_callback(struct mid_q_entry *mid)
+cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	cifs_compound_callback(mid);
-	DeleteMidQEntry(mid);
+	cifs_compound_callback(server, mid);
+	DeleteMidQEntry(server, mid);
 }
 
 /*
@@ -1065,7 +1061,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
-	struct mid_q_entry *midQ[MAX_COMPOUND];
+	struct mid_q_entry *mid[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
 		{ .value = 0, .instance = 0 }
@@ -1127,35 +1123,35 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		midQ[i] = server->ops->setup_request(ses, server, &rqst[i]);
-		if (IS_ERR(midQ[i])) {
+		mid[i] = server->ops->setup_request(ses, server, &rqst[i]);
+		if (IS_ERR(mid[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-				cifs_delete_mid(midQ[j]);
+				delete_mid(server, mid[j]);
 			mutex_unlock(&server->srv_mutex);
 
 			/* Update # of requests on wire to server */
 			for (j = 0; j < num_rqst; j++)
 				add_credits(server, &credits[j], optype);
-			return PTR_ERR(midQ[i]);
+			return PTR_ERR(mid[i]);
 		}
 
-		midQ[i]->mid_state = MID_REQUEST_SUBMITTED;
-		midQ[i]->optype = optype;
+		mid[i]->mid_state = MID_REQUEST_SUBMITTED;
+		mid[i]->optype = optype;
 		/*
 		 * Invoke callback for every part of the compound chain
 		 * to calculate credits properly. Wake up this thread only when
 		 * the last element is received.
 		 */
 		if (i < num_rqst - 1)
-			midQ[i]->callback = cifs_compound_callback;
+			mid[i]->callback = cifs_compound_callback;
 		else
-			midQ[i]->callback = cifs_compound_last_callback;
+			mid[i]->callback = cifs_compound_last_callback;
 	}
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
 
 	for (i = 0; i < num_rqst; i++)
-		cifs_save_when_sent(midQ[i]);
+		cifs_save_when_sent(mid[i]);
 
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
@@ -1193,20 +1189,20 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_response(server, midQ[i]);
+		rc = wait_for_response(server, mid[i]);
 		if (rc != 0)
 			break;
 	}
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
-				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
-			send_cancel(server, &rqst[i], midQ[i]);
+				 mid[i]->mid, le16_to_cpu(mid[i]->command));
+			send_cancel(server, &rqst[i], mid[i]);
 			spin_lock(&GlobalMid_Lock);
-			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
-			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
-			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
-				midQ[i]->callback = cifs_cancelled_callback;
+			mid[i]->mid_flags |= MID_WAIT_CANCELLED;
+			if (mid[i]->mid_state == MID_REQUEST_SUBMITTED ||
+			    mid[i]->mid_state == MID_RESPONSE_RECEIVED) {
+				mid[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
@@ -1218,36 +1214,36 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		if (rc < 0)
 			goto out;
 
-		rc = cifs_sync_mid_result(midQ[i], server);
+		rc = cifs_sync_mid_result(mid[i], server);
 		if (rc != 0) {
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
 		}
 
-		if (!midQ[i]->resp_buf ||
-		    midQ[i]->mid_state != MID_RESPONSE_READY) {
+		if (!mid[i]->resp_buf ||
+		    mid[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
 		}
 
-		buf = (char *)midQ[i]->resp_buf;
+		buf = (char *)mid[i]->resp_buf;
 		resp_iov[i].iov_base = buf;
-		resp_iov[i].iov_len = midQ[i]->resp_buf_size +
+		resp_iov[i].iov_len = mid[i]->resp_buf_size +
 			server->vals->header_preamble_size;
 
-		if (midQ[i]->large_buf)
+		if (mid[i]->large_buf)
 			resp_buf_type[i] = CIFS_LARGE_BUFFER;
 		else
 			resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
-		rc = server->ops->check_receive(midQ[i], server,
+		rc = server->ops->check_receive(mid[i], server,
 						     flags & CIFS_LOG_ERROR);
 
-		/* mark it so buf will not be freed by cifs_delete_mid */
+		/* mark it so buf will not be freed by delete_mid */
 		if ((flags & CIFS_NO_RSP_BUF) == 0)
-			midQ[i]->resp_buf = NULL;
+			mid[i]->resp_buf = NULL;
 
 	}
 
@@ -1273,7 +1269,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 */
 	for (i = 0; i < num_rqst; i++) {
 		if (!cancelled_mid[i])
-			cifs_delete_mid(midQ[i]);
+			delete_mid(server, mid[i]);
 	}
 
 	return rc;
@@ -1433,7 +1429,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	cifs_delete_mid(midQ);
+	delete_mid(server, midQ);
 	add_credits(server, &credits, 0);
 
 	return rc;
@@ -1522,7 +1518,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_sign_smb(in_buf, server, &midQ->sequence_number);
 	if (rc) {
-		cifs_delete_mid(midQ);
+		delete_mid(server, midQ);
 		mutex_unlock(&server->srv_mutex);
 		return rc;
 	}
@@ -1537,7 +1533,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	mutex_unlock(&server->srv_mutex);
 
 	if (rc < 0) {
-		cifs_delete_mid(midQ);
+		delete_mid(server, midQ);
 		return rc;
 	}
 
@@ -1560,7 +1556,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   blocking lock to return. */
 			rc = send_cancel(server, &rqst, midQ);
 			if (rc) {
-				cifs_delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		} else {
@@ -1572,7 +1568,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				cifs_delete_mid(midQ);
+				delete_mid(server, midQ);
 				return rc;
 			}
 		}
@@ -1610,7 +1606,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, server, 0);
 out:
-	cifs_delete_mid(midQ);
+	delete_mid(server, midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
2.53.0

