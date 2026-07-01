Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FBC413D9C
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 10:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902016; cv=none; b=LP+1lI+lXBH9UFU7/KkFsNXQOmGtvi+orEGIodatfAOjh4NYBpEeccnAXKnn9hLYW0YVHARnUnYBf8+YOvSq5IQ/TthfumdJzKhenkJ7+3j/xSScbmciWUyiEQ7EWCqY9lYsXOFT7Y0WTS4V/iIKDGl0R9cxfACR/dxyv0ow974=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902016; c=relaxed/simple;
	bh=upbPLLUfFGnuH1ErOUQTeMwpvOnVKBTyuMf/H1Ud55o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXiITLc/ufKtH0bQbltTR70TO1Np0iFO2LbUar1i/CaCEdciwW+zhTl+8e3a7/p8CV8S7IFjffotQS0fWNCB9qq+mloJtIsDFSsPC7/uf0uH8shWzCt2DPaOHK8cZVWLou1FU1Zjm4uT4jhwXX79pz7/9hy38zixBUpCPAz0lr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m3+KSFa1; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m3+KSFa1"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-13b2b92b0bfso921421c88.1
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 03:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782902013; x=1783506813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yN8UAzlM+QAI/w8pUDaBiyUBIP6fCdKXAC7QxX/6piU=;
        b=m3+KSFa17IhaiUxwQXxFB8xKspSu89wG4trcSc/t7QSxIhD6+YmyWXDcYGMwQYKCMq
         PkUgWv5cIIGGi/aA1NWoLBdCJHLAYYo19ZaZ0revtzpdlAt2jpF1YuGLGIDC9NRkIVJ+
         k5xN9uXU5zgLkTcMGcL7KB35bSWgXKigVyixFVbaGJeDBosc9+il8Fa32cUVkPvglgt/
         jr0T4Rf7BhtSZhKJlNLMdJiVLP8SLqkRsM4gYz/h2SMPeMswR2hH8UwrTUDkojjZt8JI
         J5RyoGILSjsJEFiY19iHR84Vc3ypxTDipF6BOzCCShXGvTlzAGLrn5ds776iZnwNc3BA
         ioLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782902013; x=1783506813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yN8UAzlM+QAI/w8pUDaBiyUBIP6fCdKXAC7QxX/6piU=;
        b=FqzREiSvlH7Orfpq7ApFTZnck7UrbhUM/94aGtmnG13oQ8mzM9Yn+N/nh6iK08uReB
         MeJyv3vmeMNldghRmAare8rlppT5hL1dP1EtIgd90Jz91p4Zvps2eqaOs5qYhhno989P
         uV7n1GIX8X10VWyUHzZHLkBKabYkveeOFHTv7Pwre1PiDNbG/QckWqDtzJW6keemU3aW
         d4CqU1jCEVcRAV8oRnmk4PwYHIa/m3NVTM4HIcFN/eYlXJLkIAolY0qPI3SxKNYdgX8i
         Uw31I9V364eVDD+QXCgDMLMQmbxRZt8NvF/l9bNdhcWpdDMTMBw3fHX8Rko9QoJL2w2x
         91UA==
X-Gm-Message-State: AOJu0YzyJEwBtHIiKkDfuOOe05xaltIMO3WVRGEoZPxq6QDfYGjzCvIx
	QGmuU9GNcgSVw88hOI6YRNPy5/7Vs7szmF5ZlHP1Ga5Ct9DS3qoym+0Ju2I/KA==
X-Gm-Gg: AfdE7cnQBhenbrkX7bYtoLmGpoizfTQYHZ2cpVofAtM2GG1Dvpa9WCIp/5qzUUXIWRc
	4hCanQwcbMMrF+TfnNBEgJIewDLBvvuzUkFJwV60xqQTvri1Q7gir+5fjqZyEqT77K+Y1aLRGkw
	s0KcnMI8orM7oVfq7alanShxhBctuSNMxbppjqfT9wCOyp0dFzJQNfAXGS/it+AhaVFyNyV+VaB
	EslEy2TDT2nTYEmtnmxmkbQ4Lh8qyB9HWQW1GCaWTpa2JTAy5O162azin6llUWJmkPTWBhZfZ87
	eQnBONuV5imU8ZUFPY4Dq5fhQZlmVCpWgvweYMjDXuLLBIXOs6m8GoxMkG27cMqPJ4ojllhkkrE
	ZIZH0t9fRh+lOMBl0fvAxXDus3xl3NbQQ9pLgDh4YU9mQOuLS7F6XW9aujCIudiM97drHIBQ6nk
	mipnwNnDx+rDWegxDG9a6SgDu70KmtnplXCaWoZkGZre+KSpsaGVPkgtGPNNtNE5sWdORJUIAge
	O93ypQRqBz9
X-Received: by 2002:a05:7022:3d0d:b0:139:8172:837b with SMTP id a92af1059eb24-13b3912e50cmr234388c88.29.1782902012496;
        Wed, 01 Jul 2026 03:33:32 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2abcd5edsm25135838c88.15.2026.07.01.03.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 03:33:31 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 1/2] smb: client: review fixes for remount ctx/retrans sync (patches 1-4)
Date: Wed,  1 Jul 2026 10:33:12 +0000
Message-ID: <20260701103313.3499731-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Fold the review feedback for the first four remount patches into one
change.  Each fix, in two lines:

- ctx sync (patch 1): sync runtime state into a private reconfigure
  context, never the shared cifs_sb->ctx, to avoid racing concurrent
  fspick/remount and /proc/mounts readers.
- ctx sync (patch 1): compare the new context against a runtime-synced
  private base_ctx (dup + sync), freed before commit, instead of the raw
  cifs_sb->ctx.
- ctx sync (patch 1): drop the fabricated "nopersistent = !use_persistent"
  derivation; nopersistent is an independent user option and must keep the
  dup'd value.
- block options (patch 2): mention "(signloosely)" in the ignore_signature
  remount rejection so the message names the user-facing option.
- retrans (patch 3): read/write server->retrans with READ_ONCE/WRITE_ONCE
  to pair the new remount writer with the lockless retry-path reader.
- retrans (patch 3): seed the baseline from READ_ONCE(server->retrans) so a
  bare remount carries the live value forward instead of clobbering it.
- block cache (patch 4): reword the cache-mode comment to state that
  cache=ro sets cache_ro and cache=singleclient sets cache_rw.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifsfs.c     |   6 +-
 fs/smb/client/connect.c    |   4 +-
 fs/smb/client/fs_context.c | 122 +++++++++++++++++++++++++++++--------
 fs/smb/client/smb2ops.c    |   2 +-
 4 files changed, 104 insertions(+), 30 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6b97f7a91235..e99d427fb2c5 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -612,6 +612,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct sockaddr *srcaddr;
 	unsigned int sbflags;
+	unsigned int retrans;
 
 	srcaddr = (struct sockaddr *)&tcon->ses->server->srcaddr;
 
@@ -765,8 +766,9 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",rasize=%u", cifs_sb->ctx->rasize);
 	if (tcon->ses->server->min_offload)
 		seq_printf(s, ",esize=%u", tcon->ses->server->min_offload);
-	if (tcon->ses->server->retrans)
-		seq_printf(s, ",retrans=%u", tcon->ses->server->retrans);
+	retrans = READ_ONCE(tcon->ses->server->retrans);
+	if (retrans)
+		seq_printf(s, ",retrans=%u", retrans);
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 104658e318b6..14dd472c2b0f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1657,7 +1657,7 @@ static int match_server(struct TCP_Server_Info *server,
 	if (server->min_offload != ctx->min_offload)
 		return 0;
 
-	if (server->retrans != ctx->retrans)
+	if (READ_ONCE(server->retrans) != ctx->retrans)
 		return 0;
 
 	return 1;
@@ -1872,7 +1872,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	 */
 	__module_get(THIS_MODULE);
 	tcp_ses->min_offload = ctx->min_offload;
-	tcp_ses->retrans = ctx->retrans;
+	WRITE_ONCE(tcp_ses->retrans, ctx->retrans);
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 53f986d8e9e0..89bf6f4604b3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -928,18 +928,22 @@ static void smb3_fs_context_free(struct fs_context *fc)
 }
 
 /*
- * Sync cifs_sb->ctx with runtime state from tcon/server/ses so the
- * baseline matches what cifs_show_options() displays.  Wide fields
- * (dstaddr, ops/vals) are protected by the matching server/tcon lock;
- * the remaining word-sized scalars rely on the same unsynchronized-read
- * pattern already used by cifs_show_options().
+ * Sync a private reconfigure context with runtime state from
+ * tcon/server/ses so the baseline matches what cifs_show_options()
+ * displays.  @ctx must be the caller's freshly-duplicated context, not
+ * the live cifs_sb->ctx: this function writes into @ctx, and mutating
+ * the shared cifs_sb->ctx here would race with concurrent fspick/remount
+ * and /proc/mounts readers.  Wide fields (dstaddr, ops/vals) are read
+ * under the matching server/tcon lock; the remaining word-sized scalars
+ * rely on the same unsynchronized-read pattern already used by
+ * cifs_show_options().
  */
-static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
+static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb,
+				      struct smb3_fs_context *ctx)
 {
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_ses *ses = tcon->ses;
-	struct smb3_fs_context *ctx = cifs_sb->ctx;
 	const char *domain;
 	int unicode;
 
@@ -961,6 +965,16 @@ static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
 	ctx->nosharesock = server->nosharesock;
 	spin_unlock(&server->srv_lock);
 
+	/*
+	 * retrans lives on the shared TCP_Server_Info and can be updated by
+	 * a remount of any mount sharing the connection.  Sync it from the
+	 * live server so a bare remount carries the current value forward
+	 * instead of writing a stale per-mount copy back in
+	 * smb3_sync_server_opts().  Read with READ_ONCE to pair with the
+	 * lockless WRITE_ONCE writers and the runtime retry-path reader.
+	 */
+	ctx->retrans = READ_ONCE(server->retrans);
+
 	/*
 	 * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_caps()
 	 * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to pair
@@ -978,15 +992,27 @@ static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
 	}
 	spin_unlock(&tcon->tc_lock);
 	ctx->seal	  = tcon->seal;
+	/*
+	 * persistent reflects the live tcon->use_persistent so the baseline
+	 * matches what cifs_show_options() reports (persistenthandles).  Do
+	 * NOT derive nopersistent from use_persistent: persistent and
+	 * nopersistent are independent user options and use_persistent is a
+	 * derived runtime result.  nopersistent is not reported by
+	 * cifs_show_options(), so it must keep the user's original value
+	 * (carried by the dup); fabricating it here would, after the
+	 * reconfigure commits the ctx, wrongly suppress persistent-handle
+	 * auto-enable on continuous-availability shares at reconnect.
+	 */
 	ctx->persistent	  = tcon->use_persistent;
-	ctx->nopersistent = !tcon->use_persistent;
 	ctx->resilient	  = tcon->use_resilient;
 	ctx->witness	  = tcon->use_witness;
 
 	/*
 	 * Session fields: domainName and unicode are effectively
 	 * write-once (set during session setup, never freed/replaced
-	 * while the session exists), so plain reads are safe.
+	 * while the session exists), so plain reads are safe.  @ctx is
+	 * the caller's private copy, so filling in a missing domainname
+	 * here cannot leak or race.
 	 */
 	domain = ses->domainName;
 	unicode = ses->unicode;
@@ -1180,7 +1206,7 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		return -EINVAL;
 	}
 	if (new_ctx->ignore_signature != old_ctx->ignore_signature) {
-		cifs_errorf(fc, "can not change ignore_signature during remount\n");
+		cifs_errorf(fc, "can not change ignore_signature (signloosely) during remount\n");
 		return -EINVAL;
 	}
 	if (new_ctx->seal != old_ctx->seal) {
@@ -1212,7 +1238,11 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
-	/* init default: cache_ro = false, cache_rw = false (i.e. cache=strict) */
+	/*
+	 * cache=ro sets cache_ro and cache=singleclient sets cache_rw; the
+	 * other cache modes (strict/loose/none) leave both clear and are
+	 * handled separately in smb3_update_mnt_flags().
+	 */
 	if (new_ctx->cache_ro != old_ctx->cache_ro) {
 		cifs_errorf(fc, "can not change cache=ro during remount\n");
 		return -EINVAL;
@@ -1340,7 +1370,7 @@ static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 	struct TCP_Server_Info *server = cifs_sb_master_tcon(cifs_sb)->ses->server;
 	struct smb3_fs_context *ctx = cifs_sb->ctx;
 
-	server->retrans = ctx->retrans;
+	WRITE_ONCE(server->retrans, ctx->retrans);
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
@@ -1348,6 +1378,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 	struct smb3_fs_context *new_ctx = NULL;
 	struct smb3_fs_context *old_ctx = NULL;
+	struct smb3_fs_context *base_ctx = NULL;
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
@@ -1360,9 +1391,37 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (ses->expired_pwd)
 		need_recon = true;
 
-	rc = smb3_verify_reconfigure_ctx(fc, ctx, cifs_sb->ctx, need_recon);
+	/*
+	 * Compare the new context against a runtime-synced baseline, not the
+	 * raw cifs_sb->ctx.  smb3_init_fs_context() syncs the new context
+	 * (fc->fs_private) from runtime state, so the comparison baseline must
+	 * be synced the same way; otherwise a field that drifted at runtime
+	 * (e.g. dstaddr after witness failover, or use_persistent auto-enabled
+	 * on a continuous-availability share) would look like a user-requested
+	 * change and be rejected on an otherwise bare remount.  Sync a private
+	 * copy rather than cifs_sb->ctx: s_umount serializes reconfigures, but
+	 * not the fspick/fsconfig init path, which dup()s cifs_sb->ctx in
+	 * smb3_init_fs_context() before reconfigure_super() takes s_umount.  An
+	 * in-place sync would therefore race that lockless dup (e.g. a torn
+	 * read of the 128-byte dstaddr).
+	 */
+	base_ctx = kzalloc_obj(*base_ctx);
+	if (!base_ctx)
+		return -ENOMEM;
+	rc = smb3_fs_context_dup(base_ctx, cifs_sb->ctx);
 	if (rc)
-		return rc;
+		goto free_base_ctx;
+	rc = smb3_sync_ctx_from_runtime(cifs_sb, base_ctx);
+	if (rc)
+		goto cleanup_base_ctx;
+
+	rc = smb3_verify_reconfigure_ctx(fc, ctx, base_ctx, need_recon);
+	if (rc)
+		goto cleanup_base_ctx;
+
+	smb3_cleanup_fs_context_contents(base_ctx);
+	kfree(base_ctx);
+	base_ctx = NULL;
 
 	rc = smb3_handle_conflicting_options(fc);
 	if (rc)
@@ -1537,6 +1596,13 @@ static int smb3_reconfigure(struct fs_context *fc)
 free_old_ctx:
 	kfree(old_ctx);
 
+	return rc;
+
+cleanup_base_ctx:
+	smb3_cleanup_fs_context_contents(base_ctx);
+free_base_ctx:
+	kfree(base_ctx);
+
 	return rc;
 }
 
@@ -2258,28 +2324,34 @@ int smb3_init_fs_context(struct fs_context *fc)
 	 * instead of building one from scratch with init defaults.
 	 *
 	 * VFS sets fc->root before calling init_fs_context for reconfigure,
-	 * so we can access the existing superblock's context.  We first sync
-	 * cifs_sb->ctx with runtime state (tcon/server/ses) so that ctx
-	 * matches what cifs_show_options() displays.  Then we dup old_ctx
-	 * into new_ctx.  The parser will overwrite only the options
-	 * explicitly passed on remount, so any difference between new_ctx
-	 * and old_ctx in smb3_verify_reconfigure_ctx() represents a real,
-	 * intentional change by the user.
+	 * so we can access the existing superblock's context.  We dup the
+	 * live cifs_sb->ctx into a private new_ctx, then sync new_ctx with
+	 * runtime state (tcon/server/ses) so it matches what
+	 * cifs_show_options() displays.  Syncing into the private copy (not
+	 * the shared cifs_sb->ctx) avoids racing with concurrent
+	 * fspick/remount and /proc/mounts readers.  The parser will overwrite
+	 * only the options explicitly passed on remount, so any difference
+	 * between new_ctx and old_ctx in smb3_verify_reconfigure_ctx()
+	 * represents a real, intentional change by the user.
 	 */
 	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		struct cifs_sb_info *cifs_sb = CIFS_SB(fc->root->d_sb);
 		int rc;
 
-		rc = smb3_sync_ctx_from_runtime(cifs_sb);
-		if (rc)
-			return rc;
-
 		ctx = kzalloc_obj(struct smb3_fs_context);
 		if (!ctx)
 			return -ENOMEM;
 
 		rc = smb3_fs_context_dup(ctx, cifs_sb->ctx);
 		if (rc) {
+			smb3_cleanup_fs_context_contents(ctx);
+			kfree(ctx);
+			return rc;
+		}
+
+		rc = smb3_sync_ctx_from_runtime(cifs_sb, ctx);
+		if (rc) {
+			smb3_cleanup_fs_context_contents(ctx);
 			kfree(ctx);
 			return rc;
 		}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a8f8feeeccb5..b30c16b0d157 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2806,7 +2806,7 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 	if (!pretries || !pcur_sleep)
 		return false;
 
-	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
+	if (tcon->retry || (*pretries)++ < READ_ONCE(tcon->ses->server->retrans)) {
 		/* Update sleep time for exponential backoff */
 		if (!(*pcur_sleep))
 			(*pcur_sleep) = 1;
-- 
2.43.0

