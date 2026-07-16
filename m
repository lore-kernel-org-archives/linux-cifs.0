Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E5B23D283;
	Thu, 16 Jul 2026 15:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784216209; cv=none; b=Ro9pw0hcF66kaGrK8neyUIDbuChe2FI6r2HDfcRzgoM3pk/MT4/aYfP66axCe1CP1WU5YRf5zN3u5iGJuJ/tPF0epH64cAEIm6h7DrTXmnJXO+nTy4GTqEMai2MfA/J0YrjtTk6cOv8F8gwWBJRKrUfz0y1Lmkr+nVCyKMpesfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784216209; c=relaxed/simple;
	bh=OnPiJyqCbhK5uLbNTNSrSIiZCoNYDEh44PhQMAsuQtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+583yIeUn8sT/e2vFGuLYEiyGcXpl6v0r2ASD1VQhCQi83Kcleew6EScZnr3xxOxLt0FbeOai8hhoHILesyrAhfrxqb1b/EpodFEoYupXXoEPfljcdG7paKRK0EtjIFOTGCumRWJFYrs6Jz0iK+La08k43K9QnU1I+GEhS4sks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OQDFXGlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OQDFXGlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693AA1F000E9;
	Thu, 16 Jul 2026 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784216207;
	bh=fDspr43tWOqQquea6F7nactIUppwdg0iUWpbCKTz6nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQDFXGlKpEjL8Y/io3JfaoPF5RLBNteWfT6aPvSBINhHphJiLTu3dq/hCkHemwVGi
	 vpTHIVGo/dd5jiGuF4jkYgPclx3fPRNq946Q+QS36d3Xi01YxwSndmD9nvnZNf2wrr
	 lsyjh6QaMu6ZLOzdHwbXYXRZJFMZVArsyhbWFzP2ZqZ2vWSGy5jgMHJzqXOaYzZCo/
	 tdGYjJ/C4ldv5eM2/Obg9T+JhuHc/QTAig/6wgJvKu2JikfkVeNGBIdA8R2Oifykol
	 Ti4xDYBhxEQ51UqWGoYCOfSZ98AjTSyA+KhB6gTAtWIbflavtlqhlmudLvPAhmAaFS
	 n2snsOgeIF2ug==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 1/2] cifs: Add tracing for the cifs_tcon struct refcounting
Date: Thu, 16 Jul 2026 11:36:43 -0400
Message-ID: <20260716153644.582614-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026071416-veal-lunchroom-f691@gregkh>
References: <2026071416-veal-lunchroom-f691@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit afc23febd51c7e24361e3a9c09f3e892eb0a41ea ]

Add tracing for the refcounting/lifecycle of the cifs_tcon struct, marking
different events with different labels and giving each tcon its own debug
ID so that the tracelines corresponding to individual tcons can be
distinguished.  This can be enabled with:

	echo 1 >/sys/kernel/debug/tracing/events/cifs/smb3_tcon_ref/enable

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: ec457f9afe5a ("smb: client: resolve SWN tcon from live registrations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifs_swn.c      | 13 +++---
 fs/cifs/cifsfs.c        |  2 +
 fs/cifs/cifsglob.h      |  1 +
 fs/cifs/cifsproto.h     |  9 ++--
 fs/cifs/connect.c       | 21 ++++++----
 fs/cifs/dfs_cache.c     |  2 +-
 fs/cifs/misc.c          | 10 +++--
 fs/cifs/smb2misc.c      | 10 +++--
 fs/cifs/smb2ops.c       |  7 +++-
 fs/cifs/smb2pdu.c       |  4 +-
 fs/cifs/smb2transport.c |  2 +
 fs/cifs/trace.h         | 93 ++++++++++++++++++++++++++++++++++++++++-
 12 files changed, 141 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 12bde7bfda86be..b5b7611ab15d20 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -313,17 +313,15 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	reg = cifs_find_swn_reg(tcon);
 	if (!IS_ERR(reg)) {
 		kref_get(&reg->ref_count);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	} else if (PTR_ERR(reg) != -EEXIST) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	}
 
 	reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
 	if (reg == NULL) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto fail_unlock;
 	}
 
 	kref_init(&reg->ref_count);
@@ -354,7 +352,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
 
 	reg->tcon = tcon;
-
+unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
 	return reg;
@@ -365,6 +363,7 @@ static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
 	idr_remove(&cifs_swnreg_idr, reg->id);
 fail:
 	kfree(reg);
+fail_unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	return ERR_PTR(ret);
 }
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c254e714f7ceb9..d31e4a6dad605f 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -706,6 +706,8 @@ static void cifs_umount_begin(struct super_block *sb)
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&cifs_tcp_ses_lock);
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+			    netfs_trace_tcon_ref_see_umount);
 	if ((tcon->tc_count > 1) || (tcon->tidStatus == CifsExiting)) {
 		/* we have other mounts to same share or we have
 		   already tried to force umount this and woken up
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 68b9b382d44bf2..91f5f35fe296ba 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1024,6 +1024,7 @@ struct cached_fid {
  */
 struct cifs_tcon {
 	struct list_head tcon_list;
+	int debug_id;		/* Debugging for tracing */
 	int tc_count;
 	struct list_head rlist; /* reconnect list */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7d00802f972239..21fb1dcbc23c89 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -273,7 +273,7 @@ extern void cifs_close_deferred_file_under_dentry(struct cifs_tcon *cifs_tcon,
 extern struct TCP_Server_Info *cifs_get_tcp_session(struct smb3_fs_context *ctx);
 extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
 				 int from_reconnect);
-extern void cifs_put_tcon(struct cifs_tcon *tcon);
+extern void cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace);
 
 #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
 extern void cifs_dfs_release_automount_timer(void);
@@ -489,8 +489,8 @@ extern int CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses);
 
 extern struct cifs_ses *sesInfoAlloc(void);
 extern void sesInfoFree(struct cifs_ses *);
-extern struct cifs_tcon *tconInfoAlloc(void);
-extern void tconInfoFree(struct cifs_tcon *);
+extern struct cifs_tcon *tconInfoAlloc(enum smb3_tcon_ref_trace trace);
+extern void tconInfoFree(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace);
 
 extern int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 		   __u32 *pexpected_response_sequence_number);
@@ -634,9 +634,6 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
-struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
-void cifs_put_tcon_super(struct super_block *sb);
-
 static inline void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
 {
 	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5fd9098250906a..03db7ae121d8e4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1664,7 +1664,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		}
 	}
 
-	tcon = tconInfoAlloc();
+	tcon = tconInfoAlloc(netfs_trace_tcon_ref_new_ipc);
 	if (tcon == NULL)
 		return -ENOMEM;
 
@@ -1679,7 +1679,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (rc) {
 		cifs_server_dbg(VFS, "failed to connect to IPC (rc=%d)\n", rc);
-		tconInfoFree(tcon);
+		tconInfoFree(tcon, netfs_trace_tcon_ref_free_ipc_fail);
 		goto out;
 	}
 
@@ -1710,7 +1710,7 @@ cifs_free_ipc(struct cifs_ses *ses)
 	if (tcon == NULL)
 		return 0;
 
-	tconInfoFree(tcon);
+	tconInfoFree(tcon, netfs_trace_tcon_ref_free_ipc);
 	ses->tcon_ipc = NULL;
 	return 0;
 }
@@ -2115,6 +2115,8 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		if (!match_tcon(tcon, ctx))
 			continue;
 		++tcon->tc_count;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_find);
 		spin_unlock(&cifs_tcp_ses_lock);
 		return tcon;
 	}
@@ -2123,7 +2125,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 }
 
 void
-cifs_put_tcon(struct cifs_tcon *tcon)
+cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 {
 	unsigned int xid;
 	struct cifs_ses *ses;
@@ -2138,6 +2140,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	ses = tcon->ses;
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count - 1, trace);
 	if (--tcon->tc_count > 0) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
@@ -2165,7 +2168,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	_free_xid(xid);
 
 	cifs_fscache_release_super_cookie(tcon);
-	tconInfoFree(tcon);
+	tconInfoFree(tcon, netfs_trace_tcon_ref_free);
 	cifs_put_smb_ses(ses);
 }
 
@@ -2213,7 +2216,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		goto out_fail;
 	}
 
-	tcon = tconInfoAlloc();
+	tcon = tconInfoAlloc(netfs_trace_tcon_ref_new);
 	if (tcon == NULL) {
 		rc = -ENOMEM;
 		goto out_fail;
@@ -2389,7 +2392,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	return tcon;
 
 out_fail:
-	tconInfoFree(tcon);
+	tconInfoFree(tcon, netfs_trace_tcon_ref_free_fail);
 	return ERR_PTR(rc);
 }
 
@@ -2406,7 +2409,7 @@ cifs_put_tlink(struct tcon_link *tlink)
 	}
 
 	if (!IS_ERR(tlink_tcon(tlink)))
-		cifs_put_tcon(tlink_tcon(tlink));
+		cifs_put_tcon(tlink_tcon(tlink), netfs_trace_tcon_ref_put_tlink);
 	kfree(tlink);
 	return;
 }
@@ -2960,7 +2963,7 @@ static inline void mount_put_conns(struct mount_ctx *mnt_ctx)
 	int rc = 0;
 
 	if (mnt_ctx->tcon)
-		cifs_put_tcon(mnt_ctx->tcon);
+		cifs_put_tcon(mnt_ctx->tcon, netfs_trace_tcon_ref_put_mnt_ctx);
 	else if (mnt_ctx->ses)
 		cifs_put_smb_ses(mnt_ctx->ses);
 	else if (mnt_ctx->server)
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 1864bdadf3ddd0..c78accc623ec9b 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1544,7 +1544,7 @@ static void refresh_mounts(struct cifs_ses **sessions)
 		mutex_unlock(&server->refpath_lock);
 
 		__refresh_tcon(server->origin_fullpath + 1, sessions, tcon, false);
-		cifs_put_tcon(tcon);
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
 	}
 }
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a3d37e7769e61f..5c15b602ba3dc2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -101,9 +101,10 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 }
 
 struct cifs_tcon *
-tconInfoAlloc(void)
+tconInfoAlloc(enum smb3_tcon_ref_trace trace)
 {
 	struct cifs_tcon *ret_buf;
+	static atomic_t tcon_debug_id;
 
 	ret_buf = kzalloc(sizeof(*ret_buf), GFP_KERNEL);
 	if (!ret_buf)
@@ -116,7 +117,8 @@ tconInfoAlloc(void)
 
 	atomic_inc(&tconInfoAllocCount);
 	ret_buf->tidStatus = CifsNew;
-	++ret_buf->tc_count;
+	ret_buf->debug_id = atomic_inc_return(&tcon_debug_id);
+	ret_buf->tc_count = 1;
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
 	spin_lock_init(&ret_buf->open_file_lock);
@@ -124,17 +126,19 @@ tconInfoAlloc(void)
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
 	atomic_set(&ret_buf->num_remote_opens, 0);
+	trace_smb3_tcon_ref(ret_buf->debug_id, ret_buf->tc_count, trace);
 
 	return ret_buf;
 }
 
 void
-tconInfoFree(struct cifs_tcon *buf_to_free)
+tconInfoFree(struct cifs_tcon *buf_to_free, enum smb3_tcon_ref_trace trace)
 {
 	if (buf_to_free == NULL) {
 		cifs_dbg(FYI, "Null buffer passed to tconInfoFree\n");
 		return;
 	}
+	trace_smb3_tcon_ref(buf_to_free->debug_id, buf_to_free->tc_count, trace);
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
 	kfree_sensitive(buf_to_free->password);
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index da32b3f6686bd9..8896e682ab96ac 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -743,7 +743,7 @@ smb2_cancelled_close_fid(struct work_struct *work)
 	if (rc)
 		cifs_tcon_dbg(VFS, "Close cancelled mid failed rc:%d\n", rc);
 
-	cifs_put_tcon(tcon);
+	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_close_fid);
 	kfree(cancelled);
 }
 
@@ -787,6 +787,8 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	if (tcon->tc_count <= 0) {
 		struct TCP_Server_Info *server = NULL;
 
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_see_cancelled_close);
 		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
 		spin_unlock(&cifs_tcp_ses_lock);
 
@@ -800,12 +802,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 		return 0;
 	}
 	tcon->tc_count++;
+	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+			    netfs_trace_tcon_ref_get_cancelled_close);
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
 					 persistent_fid, volatile_fid);
 	if (rc)
-		cifs_put_tcon(tcon);
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_close);
 
 	return rc;
 }
@@ -833,7 +837,7 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 					 rsp->PersistentFileId,
 					 rsp->VolatileFileId);
 	if (rc)
-		cifs_put_tcon(tcon);
+		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_mid);
 
 	return rc;
 }
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c372ab70396513..898f3d12ac440b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2893,8 +2893,11 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 		tcon = list_first_entry_or_null(&ses->tcon_list,
 						struct cifs_tcon,
 						tcon_list);
-		if (tcon)
+		if (tcon) {
 			tcon->tc_count++;
+			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+					    netfs_trace_tcon_ref_get_dfs_refer);
+		}
 		spin_unlock(&cifs_tcp_ses_lock);
 	}
 
@@ -2958,6 +2961,8 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 		/* ipc tcons are not refcounted */
 		spin_lock(&cifs_tcp_ses_lock);
 		tcon->tc_count--;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_dec_dfs_refer);
 		/* tc_count can never go negative */
 		WARN_ON(tcon->tc_count < 0);
 		spin_unlock(&cifs_tcp_ses_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 302c08dfb686dc..04a43cc2ee7ab9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3771,6 +3771,8 @@ void smb2_reconnect_server(struct work_struct *work)
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
 				tcon->tc_count++;
+				trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+						    netfs_trace_tcon_ref_get_reconnect_server);
 				list_add_tail(&tcon->rlist, &tmp_list);
 				tcon_exist = true;
 			}
@@ -3804,7 +3806,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		if (tcon->ipc)
 			cifs_put_smb_ses(tcon->ses);
 		else
-			cifs_put_tcon(tcon);
+			cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_reconnect_server);
 	}
 
 	cifs_dbg(FYI, "Reconnecting tcons finished\n");
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index f1e981328bc874..5b88288f6978b9 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -169,6 +169,8 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *ses, __u32  tid)
 		if (tcon->tid != tid)
 			continue;
 		++tcon->tc_count;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_find_sess_tcon);
 		return tcon;
 	}
 
diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
index dafcb6ab050dd9..4e66ca4c16517f 100644
--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -3,6 +3,9 @@
  *   Copyright (C) 2018, Microsoft Corporation.
  *
  *   Author(s): Steve French <stfrench@microsoft.com>
+ *
+ * Please use this 3-part article as a reference for writing new tracepoints:
+ * https://lwn.net/Articles/379903/
  */
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM cifs
@@ -13,9 +16,71 @@
 #include <linux/tracepoint.h>
 
 /*
- * Please use this 3-part article as a reference for writing new tracepoints:
- * https://lwn.net/Articles/379903/
+ * Specify enums for tracing information.
+ */
+#define smb3_tcon_ref_traces					      \
+	EM(netfs_trace_tcon_ref_dec_dfs_refer,		"DEC DfsRef") \
+	EM(netfs_trace_tcon_ref_free,			"FRE       ") \
+	EM(netfs_trace_tcon_ref_free_fail,		"FRE Fail  ") \
+	EM(netfs_trace_tcon_ref_free_ipc,		"FRE Ipc   ") \
+	EM(netfs_trace_tcon_ref_free_ipc_fail,		"FRE Ipc-F ") \
+	EM(netfs_trace_tcon_ref_free_reconnect_server,	"FRE Reconn") \
+	EM(netfs_trace_tcon_ref_get_cancelled_close,	"GET Cn-Cls") \
+	EM(netfs_trace_tcon_ref_get_dfs_refer,		"GET DfsRef") \
+	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
+	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
+	EM(netfs_trace_tcon_ref_get_reconnect_server,	"GET Reconn") \
+	EM(netfs_trace_tcon_ref_new,			"NEW       ") \
+	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
+	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
+	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
+	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
+	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
+	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
+	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
+	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
+	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
+	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
+	EM(netfs_trace_tcon_ref_see_fscache_collision,	"SEE FV-CO!") \
+	EM(netfs_trace_tcon_ref_see_fscache_okay,	"SEE FV-Ok ") \
+	EM(netfs_trace_tcon_ref_see_fscache_relinq,	"SEE FV-Rlq") \
+	E_(netfs_trace_tcon_ref_see_umount,		"SEE Umount")
+
+#undef EM
+#undef E_
+
+/*
+ * Define those tracing enums.
+ */
+#ifndef __SMB3_DECLARE_TRACE_ENUMS_ONCE_ONLY
+#define __SMB3_DECLARE_TRACE_ENUMS_ONCE_ONLY
+
+#define EM(a, b) a,
+#define E_(a, b) a
+
+enum smb3_tcon_ref_trace { smb3_tcon_ref_traces } __mode(byte);
+
+#undef EM
+#undef E_
+#endif
+
+/*
+ * Export enum symbols via userspace.
+ */
+#define EM(a, b) TRACE_DEFINE_ENUM(a);
+#define E_(a, b) TRACE_DEFINE_ENUM(a);
+
+smb3_tcon_ref_traces;
+
+#undef EM
+#undef E_
+
+/*
+ * Now redefine the EM() and E_() macros to map the enums to the strings that
+ * will be printed in the output.
  */
+#define EM(a, b)	{ a, b },
+#define E_(a, b)	{ a, b }
 
 /* For logging errors in read or write */
 DECLARE_EVENT_CLASS(smb3_rw_err_class,
@@ -937,6 +1002,30 @@ DEFINE_SMB3_CREDIT_EVENT(too_many_credits);
 DEFINE_SMB3_CREDIT_EVENT(add_credits);
 DEFINE_SMB3_CREDIT_EVENT(set_credits);
 
+
+TRACE_EVENT(smb3_tcon_ref,
+	    TP_PROTO(unsigned int tcon_debug_id, int ref,
+		     enum smb3_tcon_ref_trace trace),
+	    TP_ARGS(tcon_debug_id, ref, trace),
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		tcon)
+		    __field(int,			ref)
+		    __field(enum smb3_tcon_ref_trace,	trace)
+			     ),
+	    TP_fast_assign(
+		    __entry->tcon	= tcon_debug_id;
+		    __entry->ref	= ref;
+		    __entry->trace	= trace;
+			   ),
+	    TP_printk("TC=%08x %s r=%u",
+		      __entry->tcon,
+		      __print_symbolic(__entry->trace, smb3_tcon_ref_traces),
+		      __entry->ref)
+	    );
+
+
+#undef EM
+#undef E_
 #endif /* _CIFS_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.53.0

