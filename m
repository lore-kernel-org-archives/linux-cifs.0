Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0AFEB64DC
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 18:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjF1S5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Jun 2023 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjF1Szu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Jun 2023 14:55:50 -0400
X-Greylist: delayed 66514 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jun 2023 11:53:47 PDT
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979E02118
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jun 2023 11:53:47 -0700 (PDT)
Message-ID: <efe033740c7ec923fbc3a2453287b36f.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687978425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djijAyMu8lWSYkskJDGvc28nap+vc7zA6W+Sp3B5rYc=;
        b=o78uTmQvefu9T3uWZ5Rk9jh/mx8QudKo26VGDZXkNfWe/1VoD5bcO/dC/qd6BTJaO9FEja
        c6Qow/mWEeGUfnnmUZRG72LcpPfbf81pOXpOhQCXaPV0hqD8eIrP8Ot8OdueIC65i21s9E
        KeRMlbV6JjEh2W6yHdDp53RlLtOIgjrVF25rX4euzynffQ7vVOu5gk3Z1TepyLtxpGoR/y
        RUTm662e//87wv70kuzR9RlWR9cfQQCw8QoBTwL28q3Gjj2tKbcJTqlar6kEzv6gUbbLPl
        DZjlPRk8irrqJI/A9VuH14pUBeKsbk+sYbI+zJI1m6neMeOyhWO7FaU75OaFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1687978425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=djijAyMu8lWSYkskJDGvc28nap+vc7zA6W+Sp3B5rYc=;
        b=fZaBGZGpLyoPdsNzp2F3U/2T67bQUvEyWD1hRYcWCqumBrh5AqiexbduPBuFmniQIfDl99
        MvqT0liMxdriKF8PmT4Xayhc3IOtdSwwSiW9vmXJlWrdfLXxlPgye+0/zQfgBIYIwiQgzy
        3eBa5pKufV5cKTjDxxeZ88uJGLTaCdYK9YxCCuq3Vrqf90GmoXNEHvwnEqlXydZZF/FtN8
        6AYAZRt7X8C7AvE3fx+H/FLmnvvvUuysT4lhiXQky/miZ4hLsKj0H1sDrdk4KmLwfKWfEJ
        2kKPpwQp5MjEei4GKklMh6N4RyN2HdK11JtxK1pBTseENo27KRo95btRkWWhNQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1687978425; a=rsa-sha256;
        cv=none;
        b=kLQKNSNLs6gs0YFV3aPGP1xV8ZH6QGvdQzKBLAK+dTOR0DOneGA1RsU6x5QocfPG+x2ZDa
        9Mitp6+C9TgYVJA0v41+kAWfhjmz1FUCSEz5DGcgvchszY11Ea9oOQbw/xd2L0h24x/tYA
        mRdWfqkijZN3oBaiZzfYPKWtiPaCLwA6c72g7Gl0Tr9QkdIupgBPtw25tk/oMd2yfe9BMl
        TiD2hyXSIj5t0c5zUnZOzNULyql+ii0B+YAiNYy1OkuSAAeEIbAcaHEXrjuWx49xe76SR8
        C5VFdZGMcPuL/2n7lrRY0bVVMk6KiNfomVHGgBCnubjFTSLi4l/wUB5pX938Bg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/4] smb: client: fix shared DFS root mounts with
 different prefixes
In-Reply-To: <20230628002450.18781-2-pc@manguebit.com>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-2-pc@manguebit.com>
Date:   Wed, 28 Jun 2023 15:53:36 -0300
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Steve,

Sorry, but I've missed an important change in cifs_tree_connect().  If
we couldn't find DFS superlock from @tcon, it means that we must still
go on and tree connect to last share set in @tcon->tree_name.
Otherwise, we'd leave the non-DFS tcon disconnected as long as the mount
is active.

I also took the opportunity for renaming cifs_get_tcon_super() to
cifs_get_dfs_tcon_super() to make it more clearer.

Find the updated patch as attachment.

--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-smb-client-fix-shared-DFS-root-mounts-with-different.patch

From e1f3dfc6769189f03117130b4fe01990a51aa5da Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@manguebit.com>
Date: Mon, 26 Jun 2023 16:04:17 -0300
Subject: [PATCH] smb: client: fix shared DFS root mounts with different
 prefixes

When having two DFS root mounts that are connected to same namespace,
same mount options but different prefix paths, we can't really use the
shared @server->origin_fullpath when chasing DFS links in them.

Move the origin_fullpath field to cifs_tcon structure so when having
shared DFS root mounts with different prefix paths, and we need to
chase any DFS links, dfs_get_automount_devname() will pick up the
correct full path out of the @tcon that will be used for the new
mount.

Before patch

  mount.cifs //dom/dfs/dir /mnt/1 -o ...
  mount.cifs //dom/dfs /mnt/2 -o ...
  # shared server, ses, tcon
  # server: origin_fullpath=//dom/dfs/dir

  # @server->origin_fullpath + '/dir/link1'
  $ ls /mnt/2/dir/link1
  ls: cannot open directory '/mnt/2/dir/link1': No such file or directory

After patch

  mount.cifs //dom/dfs/dir /mnt/1 -o ...
  mount.cifs //dom/dfs /mnt/2 -o ...
  # shared server & ses
  # tcon_1: origin_fullpath=//dom/dfs/dir
  # tcon_2: origin_fullpath=//dom/dfs

  # @tcon_2->origin_fullpath + '/dir/link1'
  $ ls /mnt/2/dir/link1
  dir0  dir1  dir10  dir3  dir5  dir6  dir7  dir9  target2_file.txt  tsub

Fixes: 8e3554150d6c ("cifs: fix sharing of DFS connections")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifs_debug.c | 16 +++++----
 fs/smb/client/cifsglob.h   | 10 +++---
 fs/smb/client/cifsproto.h  |  2 +-
 fs/smb/client/connect.c    | 70 ++++++++++++++++++++++----------------
 fs/smb/client/dfs.c        | 55 ++++++++++++------------------
 fs/smb/client/dfs.h        | 19 +++++------
 fs/smb/client/dfs_cache.c  |  8 +++--
 fs/smb/client/misc.c       | 38 ++++++++++++++++-----
 8 files changed, 118 insertions(+), 100 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 2c771c84b970..f82dd7e0ec77 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -123,6 +123,12 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 		seq_puts(m, " nosparse");
 	if (tcon->need_reconnect)
 		seq_puts(m, "\tDISCONNECTED ");
+	spin_lock(&tcon->tc_lock);
+	if (tcon->origin_fullpath) {
+		seq_printf(m, "\n\tDFS origin fullpath: %s",
+			   tcon->origin_fullpath);
+	}
+	spin_unlock(&tcon->tc_lock);
 	seq_putc(m, '\n');
 }
 
@@ -465,13 +471,9 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "\nIn Send: %d In MaxReq Wait: %d",
 				atomic_read(&server->in_send),
 				atomic_read(&server->num_waiters));
-		if (IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)) {
-			if (server->origin_fullpath)
-				seq_printf(m, "\nDFS origin full path: %s",
-					   server->origin_fullpath);
-			if (server->leaf_fullpath)
-				seq_printf(m, "\nDFS leaf full path:   %s",
-					   server->leaf_fullpath);
+		if (server->leaf_fullpath) {
+			seq_printf(m, "\nDFS leaf full path: %s",
+				   server->leaf_fullpath);
 		}
 
 		seq_printf(m, "\n\n\tSessions: ");
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 30e7f350f95a..cb38c29b9a73 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -736,23 +736,20 @@ struct TCP_Server_Info {
 #endif
 	struct mutex refpath_lock; /* protects leaf_fullpath */
 	/*
-	 * origin_fullpath: Canonical copy of smb3_fs_context::source.
-	 *                  It is used for matching existing DFS tcons.
-	 *
 	 * leaf_fullpath: Canonical DFS referral path related to this
 	 *                connection.
 	 *                It is used in DFS cache refresher, reconnect and may
 	 *                change due to nested DFS links.
 	 *
-	 * Both protected by @refpath_lock and @srv_lock.  The @refpath_lock is
-	 * mosly used for not requiring a copy of @leaf_fullpath when getting
+	 * Protected by @refpath_lock and @srv_lock.  The @refpath_lock is
+	 * mostly used for not requiring a copy of @leaf_fullpath when getting
 	 * cached or new DFS referrals (which might also sleep during I/O).
 	 * While @srv_lock is held for making string and NULL comparions against
 	 * both fields as in mount(2) and cache refresh.
 	 *
 	 * format: \\HOST\SHARE[\OPTIONAL PATH]
 	 */
-	char *origin_fullpath, *leaf_fullpath;
+	char *leaf_fullpath;
 };
 
 static inline bool is_smb1(struct TCP_Server_Info *server)
@@ -1206,6 +1203,7 @@ struct cifs_tcon {
 	struct delayed_work dfs_cache_work;
 #endif
 	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
+	char *origin_fullpath; /* canonical copy of smb3_fs_context::source */
 };
 
 /*
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 293c54867d94..1d71d658e167 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -652,7 +652,7 @@ int smb2_parse_query_directory(struct cifs_tcon *tcon, struct kvec *rsp_iov,
 			       int resp_buftype,
 			       struct cifs_search_info *srch_inf);
 
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server);
+struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon);
 void cifs_put_tcp_super(struct super_block *sb);
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix);
 char *extract_hostname(const char *unc);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ca77aaa1d91c..60f5c8652cd7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -996,7 +996,6 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-	kfree(server->origin_fullpath);
 	kfree(server->leaf_fullpath);
 	kfree(server);
 
@@ -1436,7 +1435,9 @@ match_security(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 }
 
 /* this function must be called with srv_lock held */
-static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
+static int match_server(struct TCP_Server_Info *server,
+			struct smb3_fs_context *ctx,
+			bool match_super)
 {
 	struct sockaddr *addr = (struct sockaddr *)&ctx->dstaddr;
 
@@ -1467,36 +1468,38 @@ static int match_server(struct TCP_Server_Info *server, struct smb3_fs_context *
 			       (struct sockaddr *)&server->srcaddr))
 		return 0;
 	/*
-	 * - Match for an DFS tcon (@server->origin_fullpath).
-	 * - Match for an DFS root server connection (@server->leaf_fullpath).
-	 * - If none of the above and @ctx->leaf_fullpath is set, then
-	 *   it is a new DFS connection.
-	 * - If 'nodfs' mount option was passed, then match only connections
-	 *   that have no DFS referrals set
-	 *   (e.g. can't failover to other targets).
+	 * When matching cifs.ko superblocks (@match_super == true), we can't
+	 * really match either @server->leaf_fullpath or @server->dstaddr
+	 * directly since this @server might belong to a completely different
+	 * server -- in case of domain-based DFS referrals or DFS links -- as
+	 * provided earlier by mount(2) through 'source' and 'ip' options.
+	 *
+	 * Otherwise, match the DFS referral in @server->leaf_fullpath or the
+	 * destination address in @server->dstaddr.
+	 *
+	 * When using 'nodfs' mount option, we avoid sharing it with DFS
+	 * connections as they might failover.
 	 */
-	if (!ctx->nodfs) {
-		if (ctx->source && server->origin_fullpath) {
-			if (!dfs_src_pathname_equal(ctx->source,
-						    server->origin_fullpath))
+	if (!match_super) {
+		if (!ctx->nodfs) {
+			if (server->leaf_fullpath) {
+				if (!ctx->leaf_fullpath ||
+				    strcasecmp(server->leaf_fullpath,
+					       ctx->leaf_fullpath))
+					return 0;
+			} else if (ctx->leaf_fullpath) {
 				return 0;
+			}
 		} else if (server->leaf_fullpath) {
-			if (!ctx->leaf_fullpath ||
-			    strcasecmp(server->leaf_fullpath,
-				       ctx->leaf_fullpath))
-				return 0;
-		} else if (ctx->leaf_fullpath) {
 			return 0;
 		}
-	} else if (server->origin_fullpath || server->leaf_fullpath) {
-		return 0;
 	}
 
 	/*
 	 * Match for a regular connection (address/hostname/port) which has no
 	 * DFS referrals set.
 	 */
-	if (!server->origin_fullpath && !server->leaf_fullpath &&
+	if (!server->leaf_fullpath &&
 	    (strcasecmp(server->hostname, ctx->server_hostname) ||
 	     !match_server_address(server, addr) ||
 	     !match_port(server, addr)))
@@ -1532,7 +1535,8 @@ cifs_find_tcp_session(struct smb3_fs_context *ctx)
 		 * Skip ses channels since they're only handled in lower layers
 		 * (e.g. cifs_send_recv).
 		 */
-		if (CIFS_SERVER_IS_CHAN(server) || !match_server(server, ctx)) {
+		if (CIFS_SERVER_IS_CHAN(server) ||
+		    !match_server(server, ctx, false)) {
 			spin_unlock(&server->srv_lock);
 			continue;
 		}
@@ -2321,10 +2325,16 @@ static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 
 	if (tcon->status == TID_EXITING)
 		return 0;
-	/* Skip UNC validation when matching DFS connections or superblocks */
-	if (!server->origin_fullpath && !server->leaf_fullpath &&
-	    strncmp(tcon->tree_name, ctx->UNC, MAX_TREE_SIZE))
+
+	if (tcon->origin_fullpath) {
+		if (!ctx->source ||
+		    !dfs_src_pathname_equal(ctx->source,
+					    tcon->origin_fullpath))
+			return 0;
+	} else if (!server->leaf_fullpath &&
+		   strncmp(tcon->tree_name, ctx->UNC, MAX_TREE_SIZE)) {
 		return 0;
+	}
 	if (tcon->seal != ctx->seal)
 		return 0;
 	if (tcon->snapshot_time != ctx->snapshot_time)
@@ -2726,7 +2736,7 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 }
 
 static int match_prepath(struct super_block *sb,
-			 struct TCP_Server_Info *server,
+			 struct cifs_tcon *tcon,
 			 struct cifs_mnt_data *mnt_data)
 {
 	struct smb3_fs_context *ctx = mnt_data->ctx;
@@ -2737,8 +2747,8 @@ static int match_prepath(struct super_block *sb,
 	bool new_set = (new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) &&
 		new->prepath;
 
-	if (server->origin_fullpath &&
-	    dfs_src_pathname_equal(server->origin_fullpath, ctx->source))
+	if (tcon->origin_fullpath &&
+	    dfs_src_pathname_equal(tcon->origin_fullpath, ctx->source))
 		return 1;
 
 	if (old_set && new_set && !strcmp(new->prepath, old->prepath))
@@ -2787,10 +2797,10 @@ cifs_match_super(struct super_block *sb, void *data)
 	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
 	spin_lock(&tcon->tc_lock);
-	if (!match_server(tcp_srv, ctx) ||
+	if (!match_server(tcp_srv, ctx, true) ||
 	    !match_session(ses, ctx) ||
 	    !match_tcon(tcon, ctx) ||
-	    !match_prepath(sb, tcp_srv, mnt_data)) {
+	    !match_prepath(sb, tcon, mnt_data)) {
 		rc = 0;
 		goto out;
 	}
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index d741f396c527..dd06b8a0ff7a 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -217,14 +217,12 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 		server = mnt_ctx->server;
 		tcon = mnt_ctx->tcon;
 
-		mutex_lock(&server->refpath_lock);
-		spin_lock(&server->srv_lock);
-		if (!server->origin_fullpath) {
-			server->origin_fullpath = origin_fullpath;
+		spin_lock(&tcon->tc_lock);
+		if (!tcon->origin_fullpath) {
+			tcon->origin_fullpath = origin_fullpath;
 			origin_fullpath = NULL;
 		}
-		spin_unlock(&server->srv_lock);
-		mutex_unlock(&server->refpath_lock);
+		spin_unlock(&tcon->tc_lock);
 
 		if (list_empty(&tcon->dfs_ses_list)) {
 			list_replace_init(&mnt_ctx->dfs_ses_list,
@@ -247,18 +245,13 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 {
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	struct cifs_ses *ses;
-	char *source = ctx->source;
 	bool nodfs = ctx->nodfs;
 	int rc;
 
 	*isdfs = false;
-	/* Temporarily set @ctx->source to NULL as we're not matching DFS
-	 * superblocks yet.  See cifs_match_super() and match_server().
-	 */
-	ctx->source = NULL;
 	rc = get_session(mnt_ctx, NULL);
 	if (rc)
-		goto out;
+		return rc;
 
 	ctx->dfs_root_ses = mnt_ctx->ses;
 	/*
@@ -272,7 +265,7 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 		rc = dfs_get_referral(mnt_ctx, ctx->UNC + 1, NULL, NULL);
 		if (rc) {
 			if (rc != -ENOENT && rc != -EOPNOTSUPP && rc != -EIO)
-				goto out;
+				return rc;
 			nodfs = true;
 		}
 	}
@@ -280,7 +273,7 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 		rc = cifs_mount_get_tcon(mnt_ctx);
 		if (!rc)
 			rc = cifs_is_path_remote(mnt_ctx);
-		goto out;
+		return rc;
 	}
 
 	*isdfs = true;
@@ -296,12 +289,7 @@ int dfs_mount_share(struct cifs_mount_ctx *mnt_ctx, bool *isdfs)
 	rc = __dfs_mount_share(mnt_ctx);
 	if (ses == ctx->dfs_root_ses)
 		cifs_put_smb_ses(ses);
-out:
-	/*
-	 * Restore previous value of @ctx->source so DFS superblock can be
-	 * matched in cifs_match_super().
-	 */
-	ctx->source = source;
+
 	return rc;
 }
 
@@ -535,11 +523,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	int rc;
 	struct TCP_Server_Info *server = tcon->ses->server;
 	const struct smb_version_operations *ops = server->ops;
-	struct super_block *sb = NULL;
-	struct cifs_sb_info *cifs_sb;
 	struct dfs_cache_tgt_list tl = DFS_CACHE_TGT_LIST_INIT(tl);
-	char *tree;
+	struct cifs_sb_info *cifs_sb = NULL;
+	struct super_block *sb = NULL;
 	struct dfs_info3_param ref = {0};
+	char *tree;
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
@@ -571,19 +559,18 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		goto out;
 	}
 
-	sb = cifs_get_tcp_super(server);
-	if (IS_ERR(sb)) {
-		rc = PTR_ERR(sb);
-		cifs_dbg(VFS, "%s: could not find superblock: %d\n", __func__, rc);
-		goto out;
-	}
+	sb = cifs_get_dfs_tcon_super(tcon);
+	if (!IS_ERR(sb))
+		cifs_sb = CIFS_SB(sb);
 
-	cifs_sb = CIFS_SB(sb);
-
-	/* If it is not dfs or there was no cached dfs referral, then reconnect to same share */
-	if (!server->leaf_fullpath ||
+	/*
+	 * Tree connect to last share in @tcon->tree_name whether dfs super or
+	 * cached dfs referral was not found.
+	 */
+	if (!cifs_sb || !server->leaf_fullpath ||
 	    dfs_cache_noreq_find(server->leaf_fullpath + 1, &ref, &tl)) {
-		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name, tcon, cifs_sb->local_nls);
+		rc = ops->tree_connect(xid, tcon->ses, tcon->tree_name, tcon,
+				       cifs_sb ? cifs_sb->local_nls : nlsc);
 		goto out;
 	}
 
diff --git a/fs/smb/client/dfs.h b/fs/smb/client/dfs.h
index 1c90df5ecfbd..98e9d2aca6a7 100644
--- a/fs/smb/client/dfs.h
+++ b/fs/smb/client/dfs.h
@@ -39,16 +39,15 @@ static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
-	struct TCP_Server_Info *server = tcon->ses->server;
 	size_t len;
 	char *s;
 
-	spin_lock(&server->srv_lock);
-	if (unlikely(!server->origin_fullpath)) {
-		spin_unlock(&server->srv_lock);
+	spin_lock(&tcon->tc_lock);
+	if (unlikely(!tcon->origin_fullpath)) {
+		spin_unlock(&tcon->tc_lock);
 		return ERR_PTR(-EREMOTE);
 	}
-	spin_unlock(&server->srv_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	s = dentry_path_raw(dentry, page, PATH_MAX);
 	if (IS_ERR(s))
@@ -57,16 +56,16 @@ static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
 	if (!s[1])
 		s++;
 
-	spin_lock(&server->srv_lock);
-	len = strlen(server->origin_fullpath);
+	spin_lock(&tcon->tc_lock);
+	len = strlen(tcon->origin_fullpath);
 	if (s < (char *)page + len) {
-		spin_unlock(&server->srv_lock);
+		spin_unlock(&tcon->tc_lock);
 		return ERR_PTR(-ENAMETOOLONG);
 	}
 
 	s -= len;
-	memcpy(s, server->origin_fullpath, len);
-	spin_unlock(&server->srv_lock);
+	memcpy(s, tcon->origin_fullpath, len);
+	spin_unlock(&tcon->tc_lock);
 	convert_delimiter(s, '/');
 
 	return s;
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 1513b2709889..33adf43a01f1 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1248,18 +1248,20 @@ static int refresh_tcon(struct cifs_tcon *tcon, bool force_refresh)
 int dfs_cache_remount_fs(struct cifs_sb_info *cifs_sb)
 {
 	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
 
 	if (!cifs_sb || !cifs_sb->master_tlink)
 		return -EINVAL;
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	server = tcon->ses->server;
 
-	if (!server->origin_fullpath) {
+	spin_lock(&tcon->tc_lock);
+	if (!tcon->origin_fullpath) {
+		spin_unlock(&tcon->tc_lock);
 		cifs_dbg(FYI, "%s: not a dfs mount\n", __func__);
 		return 0;
 	}
+	spin_unlock(&tcon->tc_lock);
+
 	/*
 	 * After reconnecting to a different server, unique ids won't match anymore, so we disable
 	 * serverino. This prevents dentry revalidation to think the dentry are stale (ESTALE).
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 609d0c0d9eca..70dbfe6584f9 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -156,6 +156,7 @@ tconInfoFree(struct cifs_tcon *tcon)
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	dfs_put_root_smb_sessions(&tcon->dfs_ses_list);
 #endif
+	kfree(tcon->origin_fullpath);
 	kfree(tcon);
 }
 
@@ -1106,20 +1107,25 @@ struct super_cb_data {
 	struct super_block *sb;
 };
 
-static void tcp_super_cb(struct super_block *sb, void *arg)
+static void tcon_super_cb(struct super_block *sb, void *arg)
 {
 	struct super_cb_data *sd = arg;
-	struct TCP_Server_Info *server = sd->data;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *tcon;
+	struct cifs_tcon *t1 = sd->data, *t2;
 
 	if (sd->sb)
 		return;
 
 	cifs_sb = CIFS_SB(sb);
-	tcon = cifs_sb_master_tcon(cifs_sb);
-	if (tcon->ses->server == server)
+	t2 = cifs_sb_master_tcon(cifs_sb);
+
+	spin_lock(&t2->tc_lock);
+	if (t1->ses == t2->ses &&
+	    t1->ses->server == t2->ses->server &&
+	    t2->origin_fullpath &&
+	    dfs_src_pathname_equal(t2->origin_fullpath, t1->origin_fullpath))
 		sd->sb = sb;
+	spin_unlock(&t2->tc_lock);
 }
 
 static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void *),
@@ -1145,6 +1151,7 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 			return sd.sb;
 		}
 	}
+	pr_warn_once("%s: could not find dfs superblock\n", __func__);
 	return ERR_PTR(-EINVAL);
 }
 
@@ -1154,9 +1161,15 @@ static void __cifs_put_super(struct super_block *sb)
 		cifs_sb_deactive(sb);
 }
 
-struct super_block *cifs_get_tcp_super(struct TCP_Server_Info *server)
+struct super_block *cifs_get_dfs_tcon_super(struct cifs_tcon *tcon)
 {
-	return __cifs_get_super(tcp_super_cb, server);
+	spin_lock(&tcon->tc_lock);
+	if (!tcon->origin_fullpath) {
+		spin_unlock(&tcon->tc_lock);
+		return ERR_PTR(-ENOENT);
+	}
+	spin_unlock(&tcon->tc_lock);
+	return __cifs_get_super(tcon_super_cb, tcon);
 }
 
 void cifs_put_tcp_super(struct super_block *sb)
@@ -1243,9 +1256,16 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 	 */
 	if (strlen(full_path) < 2 || !cifs_sb ||
 	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
-	    !is_tcon_dfs(tcon) || !ses->server->origin_fullpath)
+	    !is_tcon_dfs(tcon))
 		return 0;
 
+	spin_lock(&tcon->tc_lock);
+	if (!tcon->origin_fullpath) {
+		spin_unlock(&tcon->tc_lock);
+		return 0;
+	}
+	spin_unlock(&tcon->tc_lock);
+
 	/*
 	 * Slow path - tcon is DFS and @full_path has prefix path, so attempt
 	 * to get a referral to figure out whether it is an DFS link.
@@ -1269,7 +1289,7 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 
 		/*
 		 * XXX: we are not using dfs_cache_find() here because we might
-		 * end filling all the DFS cache and thus potentially
+		 * end up filling all the DFS cache and thus potentially
 		 * removing cached DFS targets that the client would eventually
 		 * need during failover.
 		 */
-- 
2.41.0


--=-=-=
Content-Type: text/plain


Thanks.

--=-=-=--
