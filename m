Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794024593;
	b=4+g0SOSv5egbf5hl1uboHWSNaLBHAbEKSvE3W6O5A4Gzqzfh2dHzTQxq8qmrOhgiS+xW
	 N1XGYwOAF5KginMRaLkN6IheFFqNnqwC/rrGSWeXBskPaUaUSx2L/hSZ562+NyCjAiKYh
	 aZfzVjKcF4SjUP9XM40YnRUsPe9+/7GN2qGkc8E5LifLHIPNvLN+CESqSaJuN2qd3fc+K
	 HYCisaGcjeYvwGDV4R0HlVkiVXRmB0ikO17PQXM5jFBekaZ3cLLKP1cEB7oVvUbeH+Bey
	 XVeUtIEHXm/NleBC/eOmC38EfObJoVox11D6k2Tcv8XTGBpUHEC2UVn3KmYbJhyxxzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794024593;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=V/z1nwLmbv7C4xNGgEDcD3iF46X9YiA/Z4QljZu4RnE=;
	b=e3XYilLhIk0AjCmlxHhJNpBmaYTBNOffp6H8DFfj/192tXxZd++bDyhDXPO1R2eUtjh5
	 6iWX5UPhKnpAe445eFoH5DrTh9+wN1vG4FkXqauzo68tK6jfF9oeLKTxarOhLcpD4DrZ/
	 yLuV5Hmek7GioxlpOHQo+IM2IVtrgBoKGX0By33DGR6B803a9d0Nt48g05j1ku/s/37R7
	 NRH8sbDWq+FAp+/Tns//Ul5WKjn3f22Pu6nUo+nTE/MXBaXTpLsiZBCvrGz2qoSLfbp6y
	 oC7ZiZrVmYMU6p9I6v6TVdLFbr/odmLo1wbNSZ2C0IaiXs36vTQjMpu/ASf1Nh2TFmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zjSj3dOz;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D0606A338;
	Sat,  7 Nov 2026 04:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 349D0606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zjSj3dOz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=V/z1nwLmbv7C4xNGgEDcD3iF46X9YiA/Z4QljZu4RnE=; b=zjSj3dOzk64tRI6XqeVslrwyF0
	iBcYR5fjxZiVoapTxvjHry9zNuv3oR35zVqiDJAxUCpPVbdoG3HPV3KX5+YfhbxffR4pUHiWSYTg+
	D5bFsdiYWMcEo8penn1I5TgSrgAMvciR80a6QTc5pKOml1PO0VWdxy0WfmxET9J0+iK2xIGa7y+Vo
	3Le7Uea1hplMaRP1xRzOKdJN7UWnfypB+WDjkz2Fg+UFESIVB2qB70BuOgNH+6ZnSsS7npGIje82H
	aPyo8/q5B7l4iWCgqLCLzK8Dg3bqPsWkCo+g7xFNZO2EpklZjNgtUCt/LsoZX3kk59knyzWV4E7G9
	rjzbgLnA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPXkP-000000015OL-2GoT;
	Sat, 07 Nov 2026 01:09:46 -0300
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
Subject: [PATCH v8 16/19] smb: client: let umount -f stop waiting for reconnects on hard mounts
Date: Sat,  7 Nov 2026 01:09:37 -0300
Message-ID: <20261107040940.2692656-17-pc@manguebit.org>
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

Requests waiting in smb2_reconnect() or cifs_reconnect_tcon() for a
reconnect wait for as long as it takes on hard mounts.  With the server
gone, writeback stuck there keeps umount -f hanging in sync_filesystem()
while it waits for that writeback, even though retries of reads and
writes started before it now give up.

Count umount -f attempts per tcon and stop waiting for reconnects, as on
soft mounts, once one is made after the request started waiting, waking
up such requests on all channels right away.  Do this for the master
tcon and for the per-user tcons of a multiuser mount, skipping tcons
another mount still uses.  Count the references mounts hold on a tcon
for that, rather than relying on tc_count, which internal references
such as a reconnect worker also raise: one per tlink in a superblock's
tree, dropped when the tlink leaves it, and decide under the tree lock so
that pruning or building a tlink can't skew it.  Requests started after
umount -f are unaffected.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c    | 122 ++++++++++++++++++++++++++++----------
 fs/smb/client/cifsglob.h  |   7 +++
 fs/smb/client/cifsproto.h |   4 +-
 fs/smb/client/cifssmb.c   |   9 ++-
 fs/smb/client/connect.c   |  52 ++++++++++++++--
 fs/smb/client/misc.c      |  16 ++++-
 fs/smb/client/smb2pdu.c   |   9 ++-
 7 files changed, 171 insertions(+), 48 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 7146bb22a69e..1feebc08f598 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -294,6 +294,65 @@ cifs_read_super(struct super_block *sb)
 	return rc;
 }
 
+struct cifs_tcon_ref {
+	struct list_head list;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	bool shared;
+};
+
+static bool used_by_other_mounts(struct cifs_tcon *tcon,
+				 struct list_head *tcons, unsigned int pending)
+{
+	struct cifs_tcon_ref *ref;
+	unsigned int n = pending;
+
+	list_for_each_entry(ref, tcons, list)
+		n += ref->tcon == tcon;
+	guard(spinlock)(&tcon->tc_lock);
+	return tcon->mnt_refs > n;
+}
+
+static void get_sb_tcons(struct cifs_sb_info *cifs_sb, struct list_head *tcons)
+{
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct cifs_tcon_ref *ref;
+	unsigned int pending = 0;
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct rb_node *node;
+
+	guard(spinlock)(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR_OR_NULL(tcon)) {
+			if (test_bit(TCON_LINK_PENDING, &tlink->tl_flags))
+				pending++;
+			continue;
+		}
+		ref = kmalloc_obj(struct cifs_tcon_ref, GFP_ATOMIC);
+		if (!ref)
+			break;
+		ref->tlink = cifs_get_tlink(tlink);
+		ref->tcon = tcon;
+		list_add_tail(&ref->list, tcons);
+	}
+	list_for_each_entry(ref, tcons, list)
+		ref->shared = used_by_other_mounts(ref->tcon, tcons, pending);
+}
+
+static void put_sb_tcons(struct list_head *tcons)
+{
+	struct cifs_tcon_ref *ref, *tmp;
+
+	list_for_each_entry_safe(ref, tmp, tcons, list) {
+		cifs_put_tlink(ref->tlink);
+		list_del(&ref->list);
+		kfree(ref);
+	}
+}
+
 static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -837,47 +896,46 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
-static void cifs_umount_begin(struct super_block *sb)
+static void abort_reconnect(struct cifs_tcon *tcon)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
-	struct cifs_tcon *tcon;
-
-	if (cifs_sb == NULL)
-		return;
-
-	atomic_inc(&cifs_sb->umount_aborts);
-	tcon = cifs_sb_master_tcon(cifs_sb);
-
-	spin_lock(&cifs_tcp_ses_lock);
-	spin_lock(&tcon->tc_lock);
-	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
-			    netfs_trace_tcon_ref_see_umount);
-	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
-		/* we have other mounts to same share or we have
-		   already tried to umount this and woken up
-		   all waiting network requests, nothing to do */
-		spin_unlock(&tcon->tc_lock);
-		spin_unlock(&cifs_tcp_ses_lock);
-		return;
-	}
-	/*
-	 * can not set tcon->status to TID_EXITING yet since we don't know if umount -f will
-	 * fail later (e.g. due to open files).  TID_EXITING will be set just before tdis req sent
-	 */
-	spin_unlock(&tcon->tc_lock);
-	spin_unlock(&cifs_tcp_ses_lock);
+	scoped_guard(spinlock, &tcon->tc_lock)
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_see_umount);
 
+	atomic_inc(&tcon->umount_aborts);
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
-		wake_up_all(&tcon->ses->server->request_q);
-		wake_up_all(&tcon->ses->server->response_q);
+		cifs_wake_ses_waiters(tcon->ses);
 		msleep(1); /* yield */
 		/* we have to kick the requests once more */
-		wake_up_all(&tcon->ses->server->response_q);
+		cifs_wake_ses_waiters(tcon->ses);
 		msleep(1);
 	}
+}
 
-	return;
+static void cifs_umount_begin(struct super_block *sb)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon_ref *ref;
+	LIST_HEAD(tcons);
+
+	if (cifs_sb == NULL)
+		return;
+
+	atomic_inc(&cifs_sb->umount_aborts);
+
+	/*
+	 * Abort the reconnect waits of the master tcon and of any per-user
+	 * tcons of a multiuser mount that no other mount uses, pinning their
+	 * tlinks so that they stay alive, and aren't pruned, while we abort and
+	 * sleep outside the tree lock.
+	 */
+	get_sb_tcons(cifs_sb, &tcons);
+	list_for_each_entry(ref, &tcons, list) {
+		if (!ref->shared)
+			abort_reconnect(ref->tcon);
+	}
+	put_sb_tcons(&tcons);
 }
 
 static int cifs_freeze(struct super_block *sb)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 09bde6a08dd7..fe64abdfd740 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1196,6 +1196,8 @@ struct cifs_tcon {
 	struct list_head tcon_list;
 	int debug_id;		/* Debugging for tracing */
 	int tc_count;
+	int mnt_refs;		/* refs held by mounts, under tc_lock */
+	atomic_t umount_aborts;	/* nr of umount -f attempts */
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
@@ -2382,6 +2384,11 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool cifs_tcon_retry(struct cifs_tcon *tcon, int aborts)
+{
+	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts;
+}
+
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
 {
 	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index a37eee2ca54b..1b735a1c5b3d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -442,7 +442,9 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
+void cifs_wake_ses_waiters(struct cifs_ses *ses);
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts);
 
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index fcf97b3d6bea..712086eb3d1f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -73,6 +73,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
+	int aborts;
 	int rc;
 
 	/*
@@ -83,6 +84,8 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	if (!tcon)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	ses = tcon->ses;
 	server = ses->server;
 
@@ -102,7 +105,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&tcon->tc_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -127,7 +130,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -159,7 +162,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e68fffb2ab2e..8e55a036fe92 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2622,6 +2622,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			continue;
 		}
 		++tcon->tc_count;
+		++tcon->mnt_refs;
 		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 				    netfs_trace_tcon_ref_get_find);
 		spin_unlock(&tcon->tc_lock);
@@ -2695,6 +2696,39 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 #endif
 }
 
+void cifs_wake_ses_waiters(struct cifs_ses *ses)
+{
+	guard(spinlock)(&ses->chan_lock);
+	for (size_t i = 0; i < ses->chan_count; i++) {
+		struct TCP_Server_Info *server = ses->chans[i].server;
+
+		if (!server)
+			continue;
+		wake_up_all(&server->request_q);
+		wake_up_all(&server->response_q);
+	}
+}
+
+static void drop_mnt_ref(struct cifs_tcon *tcon)
+{
+	guard(spinlock)(&tcon->tc_lock);
+	tcon->mnt_refs--;
+}
+
+static void put_mnt_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
+{
+	drop_mnt_ref(tcon);
+	cifs_put_tcon(tcon, trace);
+}
+
+static void erase_tlink(struct cifs_sb_info *cifs_sb, struct tcon_link *tlink)
+{
+	clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
+	rb_erase(&tlink->tl_rbnode, &cifs_sb->tlink_tree);
+	if (!IS_ERR(tlink_tcon(tlink)))
+		drop_mnt_ref(tlink_tcon(tlink));
+}
+
 /**
  * cifs_get_tcon - get a tcon matching @ctx data from @ses
  * @ses: smb session to issue the request on
@@ -2750,6 +2784,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		rc = -ENOMEM;
 		goto out_fail;
 	}
+	tcon->mnt_refs = 1;
 	tcon->nohandlecache = nohandlecache;
 
 	if (ctx->snapshot_time) {
@@ -3576,7 +3611,7 @@ void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx)
 	int rc = 0;
 
 	if (mnt_ctx->tcon)
-		cifs_put_tcon(mnt_ctx->tcon, netfs_trace_tcon_ref_put_mnt_ctx);
+		put_mnt_tcon(mnt_ctx->tcon, netfs_trace_tcon_ref_put_mnt_ctx);
 	else if (mnt_ctx->ses)
 		cifs_put_smb_ses(mnt_ctx->ses);
 	else if (mnt_ctx->server)
@@ -4032,8 +4067,7 @@ cifs_umount(struct cifs_sb_info *cifs_sb)
 	while ((node = rb_first(root))) {
 		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
 		cifs_get_tlink(tlink);
-		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
-		rb_erase(node, root);
+		erase_tlink(cifs_sb, tlink);
 
 		spin_unlock(&cifs_sb->tlink_tree_lock);
 		cifs_put_tlink(tlink);
@@ -4424,6 +4458,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 {
 	struct tcon_link *tlink, *newtlink;
 	kuid_t fsuid = current_fsuid();
+	struct cifs_tcon *tcon;
 	int err;
 
 	if (!(cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MULTIUSER))
@@ -4481,7 +4516,13 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 			goto wait_for_construction;
 	}
 
-	tlink->tl_tcon = cifs_construct_tcon(cifs_sb, fsuid);
+	tcon = cifs_construct_tcon(cifs_sb, fsuid);
+	scoped_guard(spinlock, &cifs_sb->tlink_tree_lock) {
+		tlink->tl_tcon = tcon;
+		if (!IS_ERR(tcon) &&
+		    !test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags))
+			drop_mnt_ref(tcon);
+	}
 	clear_bit(TCON_LINK_PENDING, &tlink->tl_flags);
 	wake_up_bit(&tlink->tl_flags, TCON_LINK_PENDING);
 
@@ -4530,8 +4571,7 @@ cifs_prune_tlinks(struct work_struct *work)
 			continue;
 
 		cifs_get_tlink(tlink);
-		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
-		rb_erase(tmp, root);
+		erase_tlink(cifs_sb, tlink);
 
 		spin_unlock(&cifs_sb->tlink_tree_lock);
 		cifs_put_tlink(tlink);
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ec28f102ea08..13eb067ad88a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1073,7 +1073,15 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 }
 #endif
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
+static bool reco_wait_done(struct TCP_Server_Info *server,
+			   struct cifs_tcon *tcon, int aborts)
+{
+	return server->tcpStatus != CifsNeedReconnect ||
+		atomic_read(&tcon->umount_aborts) != aborts;
+}
+
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts)
 {
 	int timeout = 10;
 	int rc;
@@ -1096,7 +1104,9 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 	 */
 	do {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
+						      reco_wait_done(server,
+								     tcon,
+								     aborts),
 						      timeout * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
@@ -1111,7 +1121,7 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 			return 0;
 		}
 		spin_unlock(&server->srv_lock);
-	} while (retry);
+	} while (cifs_tcon_retry(tcon, aborts));
 
 	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
 	return -EHOSTDOWN;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index bf22e7f6445d..b603e937d1a8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -251,6 +251,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
 {
 	struct cifs_ses *ses;
+	int aborts;
 	int xid;
 	int rc = 0;
 
@@ -262,6 +263,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (tcon == NULL)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	if (smb2_command == SMB2_TREE_CONNECT)
 		return 0;
 
@@ -318,7 +321,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&server->srv_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -346,7 +349,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -377,7 +380,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
-- 
2.56.0

