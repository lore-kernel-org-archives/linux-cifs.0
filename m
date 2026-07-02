Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FD64252AC
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992171; cv=none; b=jhKaWt1pFeFbUL8n3McnWKnNBK6ixi/wWW3dzi8M27EU7F2X5SkMvxW1EK281cHMkZbZsMgz2KYQ0n7sMtn4+WeUkIHV1BKOabLx/n4UcyBX8T9+5ZAUwdZtbxCbF5Aor0G8JSJXxu73G52r4j6jHbR1Vb7rvyyUHyhWuodrEOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992171; c=relaxed/simple;
	bh=upbPLLUfFGnuH1ErOUQTeMwpvOnVKBTyuMf/H1Ud55o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFsFtXmDyhUdTaicEMACl9HQyoyH0o6Ipcn4oUQ5md7HdwV+9+FpNBRucaTktmXxm47fyrzOBQNBP3NaPEi9Ba/wFYmzo7njk0R5mKfHh4J0lplkTV+U0pg3/p5Zy2VHn+6g7OqRRgbQnBnkqf2N7Wa3Xl8VkTy0hy8sgEw9L5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oGTXm2i7; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oGTXm2i7"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-37e4098e920so1264318a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992166; x=1783596966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yN8UAzlM+QAI/w8pUDaBiyUBIP6fCdKXAC7QxX/6piU=;
        b=oGTXm2i7HzV7DBkm589L4EP5/sZxG4kC29mW7hRumtU873DJzdV+YlsN6E534Ppq1P
         +6E1PdNMi/AWBsCihwWqRNKlNCrgqZ2CV9tJLj6IuqUQLqFOEXsBSzU2KYfMRZPVmU1G
         Vt4dEF+JYZO3DA9BrSR6hb23M8Vwq6sdsxJxEo7py6ewkGBfii8bERYuDgAcuAr4uOUI
         jfe1lyEy8py5sH/kO7i5ernnhuHyB7h/I+iiBL+EcEG/svf9ENRYvGmuw4+4sZTSNjEE
         sju+imI7uoWVMbT2DkuBczhmmiWvgGdqbL0ZreO3JB6LkB1k4UtpfwCf8/DAMH7nG9Ex
         t3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992166; x=1783596966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yN8UAzlM+QAI/w8pUDaBiyUBIP6fCdKXAC7QxX/6piU=;
        b=VHl5BAVLE7bt27i+32YK/+ZjuESB9eOLsn6LajFbkcwqvnLsHsFUEMX1/lzOnNSGt3
         D8laDzeHt3PdxsHfTxt8KPK7GBQdNqrSCwSaDARaKk6czuHAhYGg1GCoQwMasLpmsHnD
         S0a3Eo27Ip1eo3/E1tcti39lbArCVC9fjx52TtibdFIXNXyVb0U17JczEBcuvGjKSRfA
         APjn5jFeNVNqLFRFWdIihPw9V976M6HWayfv6xUU6XOl5CSPvYcSK8EepNkTJ3JeGHxC
         hgSfSUxnNXybSneBhMc3zgtR2guvzW4bfU1GE30qBkTNIesSqSSDKl7JwkrpSy4kq22p
         cczg==
X-Gm-Message-State: AOJu0YxBP8NBuaqjxm4ZKgL0ZPvdmVvFC/Ig3iTEgzd9n8kWwJNzlSEX
	YscHfjL3WT0XN0LSs/yvXQlouCmflo/DfZsh0c3krGqE33euILKkLfZXZw7rFQ==
X-Gm-Gg: AfdE7clWU5S/arYIrPZ8w0QA3LdDE6nAgJXJECN6eeJP+oio8jpZxlkk6qF68/0Ongj
	KLUvLdCFax3i/EhjyElzm2WQ++8HJEHU/waD4MihVvPCTnn6AQHYtsL+JSRz3psADftezyVSiUn
	Ved/6w68/+m9O/tb3yexlVgKuQsyXDVRFkvUnb1bHlPM1f5tPPffPDysl3Qrl3GzXZgt59J4q0F
	2l0UQeRVyH/HlMh+prEgewBzfMG/60/rLMG5+VK6qq2FMu1zg4ykFrSxib5d3alSOIwcyHmD8PK
	lt0n7cDCb0KCWKR25l5m36+agZvXzwvGNpn8xyztrSM51QOIqwbCTvc3nTEkps82tlYxsTFGn9P
	h0xhWYObzDUgZjcJF1aLeTi2ykzlwrB3/iigWTSivSri03MqxyspMaCrSzxdXlkOTobIEnL3MP0
	nmOXcS7LrENWyS8OODqaAcNXuf8X5vNISDHeDawdIMkecOMbBZOoanFKDT5LdQx79zZvz9SmPle
	VgXPmNJNvBL6Dh8BKdrl4U=
X-Received: by 2002:a17:90b:2ecc:b0:380:ced0:ecf9 with SMTP id 98e67ed59e1d1-380ced0f4aemr3967790a91.4.1782992165893;
        Thu, 02 Jul 2026 04:36:05 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:36:05 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 8/9] smb: client: review fixes for remount ctx/retrans sync (patches 1-4)
Date: Thu,  2 Jul 2026 11:35:34 +0000
Message-ID: <20260702113535.4044308-9-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
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

