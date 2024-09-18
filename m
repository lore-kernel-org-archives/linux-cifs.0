Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715B2132464
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 05:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726636574; cv=pass; b=QnG8m71rBaLRJiHRcv00Kqn2669iJKArv5+ecFgFghrKoJUX88fhNyQi/iAkjGOKhOmk/oSoErbm6vxvVC4aYhV1gglJTMcSXpCnM8YpvUmrYWcJbGL8Zw7rIgCYkQVnYGTELw9RBuLE7kcswo8eWiQ2dHP62QjXW41ho+mhbgk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726636574; c=relaxed/simple;
	bh=9O6T3rhV9pxjKZeBuyYL3USTRTnvgwILhKAxWQwqblI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCJmhoB3Xc19cznkL0BHU654+1mZBfnBW0rEct9S7lLzcHo31ff+xcV21Rw130CGuKgQHofeTLaTTGrk6APqtnQbb04+6PSrTYHYs7HpYw3gaHLzMV1zxbP5PfPe56wmEUyEB0MwD6FumlsbWGbYbFjj6f6pw8k3d4H0q0bcBGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=jnIfRU/p; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jnIfRU/p"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HEyQ1h7FWrN0OwUUEj15caJg5Atz9E35yD/EM7YPLDE=;
	b=jnIfRU/pw64R1SWKnDbj6agQOCsYaJ6TLECo6aYSVadDz4Hs1K/L5HYM6deT7Sr2ufTLrc
	dHfpKsuxMHLOEb/b11VB6HmB2DPPGMh+Q37UJft1zlXleOTlB06BrgZjzBfuh1muodHKZO
	5MPjpB70l4r8qjKm/dwFMqXfApwqRAlblR59rGNVvE2N9Z/UeOvePftQNvabbU8V7J8zft
	78UbG5heA2uiWNn1JCgFJK2MDjSDe8Blc4B99qJfGWPW8Yba/giHkCO1ZE2r64mXEHY/yQ
	Tjyf/lyQzhPkY+YpIbR0+ZwituWNAR9Zau7VqYfGIUSiVW3DbW38SXUmMOgEhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726636570; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HEyQ1h7FWrN0OwUUEj15caJg5Atz9E35yD/EM7YPLDE=;
	b=NIFk9GolumSgX4mx+yC/M0fN0oB8AUJOXQx4+8O/zCIduh5SI7mxoCg2XVEbhl0rEV+qSD
	JDkmOWKVTno2kd6xJMGZYcVQn7nccmo7mSTHQPloqMBVJu5OCNG4ATInLH3vOMt+R18idx
	qx6uFXRw1ZdYAO24DI1yLgAR5FKAfacZmls2fzt/qr1TCMNAeBT+8mrYp404seaBG5nQCh
	aXGGNaRTeBBVYJWzWFsiFveKHwJx9+LAww1zTJGv6GOlG0CNuCEG18WXU6QxQRqoXgMrDC
	ow4/wuDV3+nW/eF+H5tEoMyzVPWLV2FFahp1Hr1VGtj6MhHiGvlK+GZUGZtziw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726636570; a=rsa-sha256;
	cv=none;
	b=RFBkPtP6j4EIIekYEXxxss5SPtmSfF3S16TPF8MluwDLpZF6foP0dVltQKbD0X21avCJ6f
	hiuQuoZtHN0yhAIsA0LiJRusGALzmKJ9B91lKT4nJxwliEFH72XbXGSckNHMVS+cv2sLfd
	umqhfZT3Za9wWwnyK5g8DBJtmNwQCV02ySmcHwlgGG/MCNqXMLUPdoDIVyqeo5gQJyI04W
	n5/pX5xl2pehDvSCtIBMaKkJLIt+LLdqnLvzDDOylpJe5Wcdd93dTs/XfeOtUcVc1y+9jA
	NCPFGBczBozFVJ28kngiHemQRvQPwuFd2lK6/8jbxbv4xfpN5ouH2r3P+xip9A==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/9] smb: client: fix DFS interlink failover
Date: Wed, 18 Sep 2024 02:15:36 -0300
Message-ID: <20240918051542.64349-3-pc@manguebit.com>
In-Reply-To: <20240918051542.64349-1-pc@manguebit.com>
References: <20240918051542.64349-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DFS interlinks point to different DFS namespaces so make sure to
use the correct DFS root server to chase any DFS links under it by
storing the SMB session in dfs_ref_walk structure and then using it on
every referral walk.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/cifsglob.h   |  3 ++
 fs/smb/client/cifsproto.h  | 12 ++-----
 fs/smb/client/connect.c    | 41 +++++++++++----------
 fs/smb/client/dfs.c        | 73 ++++++++++++++++++--------------------
 fs/smb/client/dfs.h        | 42 ++++++++++++++--------
 fs/smb/client/dfs_cache.c  |  3 +-
 fs/smb/client/fs_context.h |  1 +
 fs/smb/client/misc.c       |  3 ++
 fs/smb/client/namespace.c  |  2 +-
 9 files changed, 94 insertions(+), 86 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 939ef5844571..e969d1ae2498 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -821,6 +821,7 @@ struct TCP_Server_Info {
 	 * format: \\HOST\SHARE[\OPTIONAL PATH]
 	 */
 	char *leaf_fullpath;
+	bool dfs_conn:1;
 };
 
 static inline bool is_smb1(struct TCP_Server_Info *server)
@@ -1059,6 +1060,7 @@ struct cifs_ses {
 	struct list_head smb_ses_list;
 	struct list_head rlist; /* reconnect list */
 	struct list_head tcon_list;
+	struct list_head dlist; /* dfs list */
 	struct cifs_tcon *tcon_ipc;
 	spinlock_t ses_lock;  /* protect anything here that is not protected */
 	struct mutex session_mutex;
@@ -1287,6 +1289,7 @@ struct cifs_tcon {
 	/* BB add field for back pointer to sb struct(s)? */
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	struct delayed_work dfs_cache_work;
+	struct list_head dfs_ses_list;
 #endif
 	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
 	char *origin_fullpath; /* canonical copy of smb3_fs_context::source */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c69e3f48a60c..68c716e6261b 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -724,15 +724,9 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
 
-/* Put references of @ses and its children */
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
-	struct cifs_ses *next;
-
-	do {
-		next = ses->dfs_root_ses;
-		__cifs_put_smb_ses(ses);
-	} while ((ses = next));
+	__cifs_put_smb_ses(ses);
 }
 
 /* Get an active reference of @ses and its children.
@@ -746,9 +740,7 @@ static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 static inline void cifs_smb_ses_inc_refcount(struct cifs_ses *ses)
 {
 	lockdep_assert_held(&cifs_tcp_ses_lock);
-
-	for (; ses; ses = ses->dfs_root_ses)
-		ses->ses_count++;
+	ses->ses_count++;
 }
 
 static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 08a41c7aaf72..76f02739dda5 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1530,6 +1530,9 @@ static int match_server(struct TCP_Server_Info *server,
 	if (server->nosharesock)
 		return 0;
 
+	if (!match_super && (ctx->dfs_conn || server->dfs_conn))
+		return 0;
+
 	/* If multidialect negotiation see if existing sessions match one */
 	if (strcmp(ctx->vals->version_string, SMB3ANY_VERSION_STRING) == 0) {
 		if (server->vals->protocol_id < SMB30_PROT_ID)
@@ -1723,6 +1726,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 
 	if (ctx->nosharesock)
 		tcp_ses->nosharesock = true;
+	tcp_ses->dfs_conn = ctx->dfs_conn;
 
 	tcp_ses->ops = ctx->ops;
 	tcp_ses->vals = ctx->vals;
@@ -1873,13 +1877,15 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 }
 
 /* this function must be called with ses_lock and chan_lock held */
-static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
+static int match_session(struct cifs_ses *ses,
+			 struct smb3_fs_context *ctx,
+			 bool match_super)
 {
 	if (ctx->sectype != Unspecified &&
 	    ctx->sectype != ses->sectype)
 		return 0;
 
-	if (ctx->dfs_root_ses != ses->dfs_root_ses)
+	if (!match_super && ctx->dfs_root_ses != ses->dfs_root_ses)
 		return 0;
 
 	/*
@@ -1998,7 +2004,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 			continue;
 		}
 		spin_lock(&ses->chan_lock);
-		if (match_session(ses, ctx)) {
+		if (match_session(ses, ctx, false)) {
 			spin_unlock(&ses->chan_lock);
 			spin_unlock(&ses->ses_lock);
 			ret = ses;
@@ -2382,8 +2388,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	 * need to lock before changing something in the session.
 	 */
 	spin_lock(&cifs_tcp_ses_lock);
-	if (ctx->dfs_root_ses)
-		cifs_smb_ses_inc_refcount(ctx->dfs_root_ses);
 	ses->dfs_root_ses = ctx->dfs_root_ses;
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -2458,6 +2462,7 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 {
 	unsigned int xid;
 	struct cifs_ses *ses;
+	LIST_HEAD(ses_list);
 
 	/*
 	 * IPC tcon share the lifetime of their session and are
@@ -2482,6 +2487,9 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 
 	list_del_init(&tcon->tcon_list);
 	tcon->status = TID_EXITING;
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	list_replace_init(&tcon->dfs_ses_list, &ses_list);
+#endif
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -2509,6 +2517,9 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	cifs_fscache_release_super_cookie(tcon);
 	tconInfoFree(tcon, netfs_trace_tcon_ref_free);
 	cifs_put_smb_ses(ses);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	dfs_put_root_smb_sessions(&ses_list);
+#endif
 }
 
 /**
@@ -2892,7 +2903,7 @@ cifs_match_super(struct super_block *sb, void *data)
 	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
 	if (!match_server(tcp_srv, ctx, true) ||
-	    !match_session(ses, ctx) ||
+	    !match_session(ses, ctx, true) ||
 	    !match_tcon(tcon, ctx) ||
 	    !match_prepath(sb, tcon, mnt_data)) {
 		rc = 0;
@@ -3623,13 +3634,12 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mnt_ctx)
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 {
 	struct cifs_mount_ctx mnt_ctx = { .cifs_sb = cifs_sb, .fs_ctx = ctx, };
-	bool isdfs;
 	int rc;
 
-	rc = dfs_mount_share(&mnt_ctx, &isdfs);
+	rc = dfs_mount_share(&mnt_ctx);
 	if (rc)
 		goto error;
-	if (!isdfs)
+	if (!ctx->dfs_conn)
 		goto out;
 
 	/*
@@ -4034,7 +4044,7 @@ cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 }
 
 static struct cifs_tcon *
-__cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
+cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 {
 	int rc;
 	struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
@@ -4132,17 +4142,6 @@ __cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	return tcon;
 }
 
-static struct cifs_tcon *
-cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
-{
-	struct cifs_tcon *ret;
-
-	cifs_mount_lock();
-	ret = __cifs_construct_tcon(cifs_sb, fsuid);
-	cifs_mount_unlock();
-	return ret;
-}
-
 struct cifs_tcon *
 cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
 {
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 3ec965547e3d..3f6077c68d68 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -69,7 +69,7 @@ static int get_session(struct cifs_mount_ctx *mnt_ctx, const char *full_path)
  * Get an active reference of @ses so that next call to cifs_put_tcon() won't
  * release it as any new DFS referrals must go through its IPC tcon.
  */
-static void add_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
+static void set_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	struct cifs_ses *ses = mnt_ctx->ses;
@@ -95,7 +95,7 @@ static inline int parse_dfs_target(struct smb3_fs_context *ctx,
 	return rc;
 }
 
-static int set_ref_paths(struct cifs_mount_ctx *mnt_ctx,
+static int setup_dfs_ref(struct cifs_mount_ctx *mnt_ctx,
 			 struct dfs_info3_param *tgt,
 			 struct dfs_ref_walk *rw)
 {
@@ -120,6 +120,7 @@ static int set_ref_paths(struct cifs_mount_ctx *mnt_ctx,
 	}
 	ref_walk_path(rw) = ref_path;
 	ref_walk_fpath(rw) = full_path;
+	ref_walk_ses(rw) = ctx->dfs_root_ses;
 	return 0;
 }
 
@@ -128,11 +129,11 @@ static int __dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	struct dfs_info3_param tgt = {};
-	bool is_refsrv;
 	int rc = -ENOENT;
 
 again:
 	do {
+		ctx->dfs_root_ses = ref_walk_ses(rw);
 		if (ref_walk_empty(rw)) {
 			rc = dfs_get_referral(mnt_ctx, ref_walk_path(rw) + 1,
 					      NULL, ref_walk_tl(rw));
@@ -158,10 +159,7 @@ static int __dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
 			if (rc)
 				continue;
 
-			is_refsrv = tgt.server_type == DFS_TYPE_ROOT ||
-				DFS_INTERLINK(tgt.flags);
 			ref_walk_set_tgt_hint(rw);
-
 			if (tgt.flags & DFSREF_STORAGE_SERVER) {
 				rc = cifs_mount_get_tcon(mnt_ctx);
 				if (!rc)
@@ -172,12 +170,10 @@ static int __dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
 					continue;
 			}
 
-			if (is_refsrv)
-				add_root_smb_session(mnt_ctx);
-
+			set_root_smb_session(mnt_ctx);
 			rc = ref_walk_advance(rw);
 			if (!rc) {
-				rc = set_ref_paths(mnt_ctx, &tgt, rw);
+				rc = setup_dfs_ref(mnt_ctx, &tgt, rw);
 				if (!rc) {
 					rc = -EREMOTE;
 					goto again;
@@ -193,20 +189,22 @@ static int __dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
 	return rc;
 }
 
-static int dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx)
+static int dfs_referral_walk(struct cifs_mount_ctx *mnt_ctx,
+			     struct dfs_ref_walk **rw)
 {
-	struct dfs_ref_walk *rw;
 	int rc;
 
-	rw = ref_walk_alloc();
-	if (IS_ERR(rw))
-		return PTR_ERR(rw);
+	*rw = ref_walk_alloc();
+	if (IS_ERR(*rw)) {
+		rc = PTR_ERR(*rw);
+		*rw = NULL;
+		return rc;
+	}
 
-	ref_walk_init(rw);
-	rc = set_ref_paths(mnt_ctx, NULL, rw);
+	ref_walk_init(*rw);
+	rc = setup_dfs_ref(mnt_ctx, NULL, *rw);
 	if (!rc)
-		rc = __dfs_referral_walk(mnt_ctx, rw);
-	ref_walk_free(rw);
+		rc = __dfs_referral_walk(mnt_ctx, *rw);
 	return rc;
 }
 
@@ -214,16 +212,16 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct cifs_sb_info *cifs_sb = mnt_ctx->cifs_sb;
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
+	struct dfs_ref_walk *rw = NULL;
 	struct cifs_tcon *tcon;
 	char *origin_fullpath;
-	bool new_tcon = true;
 	int rc;
 
 	origin_fullpath = dfs_get_path(cifs_sb, ctx->source);
 	if (IS_ERR(origin_fullpath))
 		return PTR_ERR(origin_fullpath);
 
-	rc = dfs_referral_walk(mnt_ctx);
+	rc = dfs_referral_walk(mnt_ctx, &rw);
 	if (!rc) {
 		/*
 		 * Prevent superblock from being created with any missing
@@ -241,21 +239,16 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 
 	tcon = mnt_ctx->tcon;
 	spin_lock(&tcon->tc_lock);
-	if (!tcon->origin_fullpath) {
-		tcon->origin_fullpath = origin_fullpath;
-		origin_fullpath = NULL;
-	} else {
-		new_tcon = false;
-	}
+	tcon->origin_fullpath = origin_fullpath;
+	origin_fullpath = NULL;
+	ref_walk_set_tcon(rw, tcon);
 	spin_unlock(&tcon->tc_lock);
-
-	if (new_tcon) {
-		queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
-				   dfs_cache_get_ttl() * HZ);
-	}
+	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+			   dfs_cache_get_ttl() * HZ);
 
 out:
 	kfree(origin_fullpath);
+	ref_walk_free(rw);
 	return rc;
 }
 
@@ -279,7 +272,7 @@ static int update_fs_context_dstaddr(struct smb3_fs_context *ctx)
 	return rc;
 }
 
-int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
+int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	bool nodfs = ctx->nodfs;
@@ -289,7 +282,6 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	if (rc)
 		return rc;
 
-	*isdfs = false;
 	rc = get_session(mnt_ctx, NULL);
 	if (rc)
 		return rc;
@@ -317,10 +309,15 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 		return rc;
 	}
 
-	*isdfs = true;
-	add_root_smb_session(mnt_ctx);
-	rc = __dfs_mount_share(mnt_ctx);
-	dfs_put_root_smb_sessions(mnt_ctx);
+	if (!ctx->dfs_conn) {
+		ctx->dfs_conn = true;
+		cifs_mount_put_conns(mnt_ctx);
+		rc = get_session(mnt_ctx, NULL);
+	}
+	if (!rc) {
+		set_root_smb_session(mnt_ctx);
+		rc = __dfs_mount_share(mnt_ctx);
+	}
 	return rc;
 }
 
diff --git a/fs/smb/client/dfs.h b/fs/smb/client/dfs.h
index e5c4dcf83750..a23150676d9e 100644
--- a/fs/smb/client/dfs.h
+++ b/fs/smb/client/dfs.h
@@ -19,6 +19,7 @@
 struct dfs_ref {
 	char *path;
 	char *full_path;
+	struct cifs_ses *ses;
 	struct dfs_cache_tgt_list tl;
 	struct dfs_cache_tgt_iterator *tit;
 };
@@ -38,6 +39,7 @@ struct dfs_ref_walk {
 #define ref_walk_path(w)	(ref_walk_cur(w)->path)
 #define ref_walk_fpath(w)	(ref_walk_cur(w)->full_path)
 #define ref_walk_tl(w)		(&ref_walk_cur(w)->tl)
+#define ref_walk_ses(w)	(ref_walk_cur(w)->ses)
 
 static inline struct dfs_ref_walk *ref_walk_alloc(void)
 {
@@ -60,14 +62,19 @@ static inline void __ref_walk_free(struct dfs_ref *ref)
 	kfree(ref->path);
 	kfree(ref->full_path);
 	dfs_cache_free_tgts(&ref->tl);
+	if (ref->ses)
+		cifs_put_smb_ses(ref->ses);
 	memset(ref, 0, sizeof(*ref));
 }
 
 static inline void ref_walk_free(struct dfs_ref_walk *rw)
 {
-	struct dfs_ref *ref = ref_walk_start(rw);
+	struct dfs_ref *ref;
 
-	for (; ref <= ref_walk_end(rw); ref++)
+	if (!rw)
+		return;
+
+	for (ref = ref_walk_start(rw); ref <= ref_walk_end(rw); ref++)
 		__ref_walk_free(ref);
 	kfree(rw);
 }
@@ -116,9 +123,22 @@ static inline void ref_walk_set_tgt_hint(struct dfs_ref_walk *rw)
 				       ref_walk_tit(rw));
 }
 
+static inline void ref_walk_set_tcon(struct dfs_ref_walk *rw,
+				     struct cifs_tcon *tcon)
+{
+	struct dfs_ref *ref = ref_walk_start(rw);
+
+	for (; ref <= ref_walk_cur(rw); ref++) {
+		if (WARN_ON_ONCE(!ref->ses))
+			continue;
+		list_add_tail(&ref->ses->dlist, &tcon->dfs_ses_list);
+		ref->ses = NULL;
+	}
+}
+
 int dfs_parse_target_referral(const char *full_path, const struct dfs_info3_param *ref,
 			      struct smb3_fs_context *ctx);
-int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs);
+int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx);
 
 static inline char *dfs_get_path(struct cifs_sb_info *cifs_sb, const char *path)
 {
@@ -142,20 +162,14 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
  * references of all DFS root sessions that were used across the mount process
  * in dfs_mount_share().
  */
-static inline void dfs_put_root_smb_sessions(struct cifs_mount_ctx *mnt_ctx)
+static inline void dfs_put_root_smb_sessions(struct list_head *head)
 {
-	const struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
-	struct cifs_ses *ses = ctx->dfs_root_ses;
-	struct cifs_ses *cur;
+	struct cifs_ses *ses, *n;
 
-	if (!ses)
-		return;
-
-	for (cur = ses; cur; cur = cur->dfs_root_ses) {
-		if (cur->dfs_root_ses)
-			cifs_put_smb_ses(cur->dfs_root_ses);
+	list_for_each_entry_safe(ses, n, head, dlist) {
+		list_del_init(&ses->dlist);
+		cifs_put_smb_ses(ses);
 	}
-	cifs_put_smb_ses(ses);
 }
 
 #endif /* _CIFS_DFS_H */
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index e496dbf8c622..110f03df012a 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1334,9 +1334,8 @@ void dfs_cache_refresh(struct work_struct *work)
 	struct cifs_ses *ses;
 
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
-	ses = tcon->ses->dfs_root_ses;
 
-	for (; ses; ses = ses->dfs_root_ses)
+	list_for_each_entry(ses, &tcon->dfs_ses_list, dlist)
 		refresh_ses_referral(ses);
 	refresh_tcon_referral(tcon, false);
 
diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
index cf577ec0dd0a..69f9d938b336 100644
--- a/fs/smb/client/fs_context.h
+++ b/fs/smb/client/fs_context.h
@@ -284,6 +284,7 @@ struct smb3_fs_context {
 	struct cifs_ses *dfs_root_ses;
 	bool dfs_automount:1; /* set for dfs automount only */
 	enum cifs_reparse_type reparse_type;
+	bool dfs_conn:1; /* set for dfs mounts */
 };
 
 extern const struct fs_parameter_spec smb3_fs_parameters[];
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index dab526191b07..47b861517bed 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -145,6 +145,9 @@ tcon_info_alloc(bool dir_leases_enabled, enum smb3_tcon_ref_trace trace)
 	mutex_init(&ret_buf->fscache_lock);
 #endif
 	trace_smb3_tcon_ref(ret_buf->debug_id, ret_buf->tc_count, trace);
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	INIT_LIST_HEAD(&ret_buf->dfs_ses_list);
+#endif
 
 	return ret_buf;
 }
diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
index 4a517b280f2b..0f788031b740 100644
--- a/fs/smb/client/namespace.c
+++ b/fs/smb/client/namespace.c
@@ -240,7 +240,7 @@ static struct vfsmount *cifs_do_automount(struct path *path)
 		ctx->source = NULL;
 		goto out;
 	}
-	ctx->dfs_automount = is_dfs_mount(mntpt);
+	ctx->dfs_automount = ctx->dfs_conn = is_dfs_mount(mntpt);
 	cifs_dbg(FYI, "%s: ctx: source=%s UNC=%s prepath=%s dfs_automount=%d\n",
 		 __func__, ctx->source, ctx->UNC, ctx->prepath, ctx->dfs_automount);
 
-- 
2.46.0

