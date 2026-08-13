Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52703C5526
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786607127; cv=none; b=bBylxhO7DhPZsd0aimv77voRTxLLxqGpKiFhZkGROtT1PY4/S8tS6fZoxTkRHBzohsvAGFW2H5eVIntEspYqlASttEOL0p9NGGJVVWiCAx5wTKqtMRNopyB/N31iYvkweOdiz71J50vvx3ETpvONWEnRGbLyqnXvSI8nF0aJp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786607127; c=relaxed/simple;
	bh=aXKxShEmecHdt/6AUwaIgXyeXHNZzvfHrmpv9PB1i30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tax6NzckDCDSagertxfWOVjH8YbosOOBY+LzjeQkirteuLwRFZ2Q51+P92/1BzJv2Rw46sLBUVnB7rltoN1cwX5u7lOP+s+Ea7vznQr9RjH7Qt9ssFeLazF6e9tQiQ1AeAsm508RhtDeUZ3FMi0GwvpX/iFIyAZGt0kB6UKYnqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FrOh1unT; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrOh1unT"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84830c774a0so2204277b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 00:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607125; x=1787211925; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9R5yNNbe1E5fEL8LXl4YkHZwAkns899WTQx38COqCZM=;
        b=FrOh1unTbqL7Tbn7POyJbUu80/V1Odffk9J8N4MCahi82dOpsflLzbi2Z+nYqRPIWZ
         CzOJ/58K1Rwr5iuVJuY5YU6FobX18Z7qyK/d3U2uE5RMDlREeN/YP3g9do5Ojdr6B2iV
         dDedaq2rIMwulfQ+0M7VfVT1jFPX4B41YdbhDU+wDaUDz7jFavrGaC3AyvO7JY41it/A
         CFaKuPQ9eQTfjTiHRzoiyetvBHH+X0/P50ah0IfXHRZ2zA+2/vdIRKbqIJ/T/KpAtWsX
         WGql93LmPRXWTVHaOh0rUpzovN09Iv1IJmmPy7XvfIXOWlohwIefx5kb1YkjpuBeTX0a
         NljA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607125; x=1787211925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9R5yNNbe1E5fEL8LXl4YkHZwAkns899WTQx38COqCZM=;
        b=cVzHUaDfoqju2kytCglgZts0rXa1hzO4aH94zo4JIjcZ8TqZIYVcJG68mxVQdxax0G
         Q7RcIiceUToy8ilrEI3VBaq3l8m7fn5X9AwTr2e7zLzj9+TiE0RJGm52uxAbFA9DVBM6
         6zNgQCEOVBWWN+De7MNYv8S+pn8VneRk5SZq205J/duz2VnlKJ3KLQtQe+tC4Y2vY230
         yyG1MrhP8LLeUjYQtdmSE4sF/FxXr8sndfuhwmWAAr/iD/tv+FIn1lYrplhtd57amHVF
         y+8N+XUZpApRKD00UQsw2Gn84VhQaBqNF47z56FVTM6pFrfEhLLnHlvT0u02W8O4negB
         MLYg==
X-Forwarded-Encrypted: i=1; AHgh+RqOod3oTHBV3fVObfZYmBcisZvh3KC9+5MEO5EQQsMrCcNBCByNUnEL+UyFn/TFOVnR8KJAbfKNCfLb@vger.kernel.org
X-Gm-Message-State: AOJu0YyMEYGXaE94byeV+eBq0leDpGAIsgiqthUpij0MR7B1RvoSQGyC
	8ZCIaytw2aBJhHsid6Am7gfjgZLV+5J1o3uxw0g3sgZbICf6NCfO86n8IH/Dlw==
X-Gm-Gg: AR+sD10ed30/sB05Vp81ivyiww8oeGpfc6u6bsLGeTQ7pJLKWBMjJywcNhnm5CzbeIX
	mAxlTKBp9BTM2zHz/1CwqrqandS3tycaTHE4gUNSxdKhWxYsAOxrwwUwpXY6HXKY0vHMOb9LbXV
	D9iOmR+hwXxkquvUzjiIOkOp9ChjoO6P1KtYJvEm473gqjZU0Cv0xuPYi/LOBcf5Tq9A+j1IB2d
	sYN2Yevi2tHR+m35m3prL+ua/kc+UlqBBH1C/M0xYmfE3SjB3G+DqPTLKMJeLUAdFGY7hhOLNEy
	5Cqu4q6sQO4URQD5zthPHzMFC5OzlKRRHWXFV8Q4V5g9U7wQi97xca0RsN//HFtHUb82Iw8rVbd
	ME1MulD38Sat0Z8ePGOpTmpmi8MqgWmqAGF3ECQZ3Rvks/S+EWj93mtVMcrxNdIow2ruKZxzEvx
	h0uixcjs7GakF3PsXAQL0i22LK9FvmXqXQB84Nmwgh7qKek1688GgR3G6gEWJUkzzCduZnKlkRh
	gNKr5+ImELHYKYSbDafsP66054jaKbdr8W+mYEOjMdrPY3BWOujnyiY4LlEXdtzQ5Np2TcJeAZK
	/NsfYqNP0JtD7DHuyzwDveD+YQI=
X-Received: by 2002:a05:6a20:c70b:b0:3c3:a168:edc3 with SMTP id adf61e73a8af0-3cc554929e6mr5567457637.38.1786607124820;
        Thu, 13 Aug 2026 00:45:24 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ec022acabsm4587594eec.27.2026.08.13.00.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:45:24 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH 1/7] smb: client: sync runtime state into ctx on reconfigure
Date: Thu, 13 Aug 2026 07:45:11 +0000
Message-ID: <20260813074517.607275-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813074517.607275-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

smb3_init_fs_context() builds a fresh context from init defaults on
every call, including remount.  Many options shown by
cifs_show_options() come from tcon/server/ses rather than ctx, so those
defaults don't reflect the live mount and make a poor baseline for
deciding what changed on remount.

On reconfigure, duplicate the live cifs_sb->ctx into a private context
and sync it with runtime state via a new smb3_sync_ctx_from_runtime()
so the baseline matches what /proc/mounts displays.  This mirrors
libmount (util-linux), which on remount replays the current
/proc/mounts options back to the kernel: the baseline must equal the
displayed state, or a bare 'mount -o remount' looks like a change and
is rejected.  libmount isn't present everywhere, but the kernel must
accept such a replay regardless.  Syncing into the private copy (and
comparing against a freshly synced base_ctx in smb3_reconfigure())
avoids racing /proc/mounts readers; wide fields (dstaddr, ops/vals) are
read under srv_lock and tcon->unix_ext under tc_lock.

Only positive runtime state is reflected: no_linux_ext / nopersistent
are not fabricated from inactive runtime state, as a fabricated value
committed to cifs_sb->ctx would suppress POSIX / persistent-handle
auto-enable on a later reconnect or failover.

This is preparatory plumbing for the next patch, which compares new_ctx
against old_ctx to reject non-reconfigurable option changes.

Not addressed (pre-existing): this race is not introduced here.
smb3_reconfigure() already replaces cifs_sb->ctx in place with

	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
	memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));

while cifs_show_options() has always read the same cifs_sb->ctx
locklessly for /proc/mounts, so a reader racing a remount of that mount
can already observe a torn field or a briefly stale string pointer.
The risk is low: remount is an infrequent, admin-triggered operation
serialized by s_umount, the only concurrent reader is the diagnostic
/proc/mounts path, and the worst outcome is a transiently inconsistent
options line for that one mount rather than memory corruption or a
crash.  This patch neither widens that window nor adds a new lockless
reader -- init dup()s cifs_sb->ctx the same way the mount path already
does -- so a proper fix (RCU-style ctx replacement) is left as a
separate change.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifs_swn.h   |  14 ++-
 fs/smb/client/fs_context.c | 197 ++++++++++++++++++++++++++++++++++++-
 fs/smb/client/smb1ops.c    |   7 +-
 fs/smb/client/smb2pdu.c    |  11 ++-
 4 files changed, 223 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
index 955d07b69450..caf0779d4d07 100644
--- a/fs/smb/client/cifs_swn.h
+++ b/fs/smb/client/cifs_swn.h
@@ -26,11 +26,21 @@ void cifs_swn_check(void);
 
 static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *server)
 {
+	bool ret = false;
+
+	/*
+	 * srv_lock serializes the 128-byte sockaddr_storage write against
+	 * concurrent readers (e.g. cifs_show_address(), reconn_set_ipaddr_
+	 * from_hostname() snapshot, smb3_sync_ctx_from_runtime()) and other
+	 * writers like cifs_chan_update_iface() which already use srv_lock.
+	 */
+	spin_lock(&server->srv_lock);
 	if (server->use_swn_dstaddr) {
 		server->dstaddr = server->swn_dstaddr;
-		return true;
+		ret = true;
 	}
-	return false;
+	spin_unlock(&server->srv_lock);
+	return ret;
 }
 
 static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info *server)
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index abc29500a664..1a68ae058166 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -926,6 +926,121 @@ static void smb3_fs_context_free(struct fs_context *fc)
 	smb3_cleanup_fs_context(ctx);
 }
 
+/*
+ * Sync a private reconfigure context with runtime state from
+ * tcon/server/ses so the baseline matches what cifs_show_options()
+ * displays.  @ctx must be the caller's freshly-duplicated context, not
+ * the live cifs_sb->ctx: this function writes into @ctx, and mutating
+ * the shared cifs_sb->ctx here would race with concurrent fspick/remount
+ * and /proc/mounts readers.  Wide fields (dstaddr, ops/vals) are read
+ * under the matching server/tcon lock; the remaining word-sized scalars
+ * rely on the same unsynchronized-read pattern already used by
+ * cifs_show_options().
+ */
+static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb,
+				      struct smb3_fs_context *ctx)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses = tcon->ses;
+	const char *domain;
+	int unicode;
+
+	/*
+	 * Server fields that can drift from ctx after mount:
+	 *  - ops/vals: dialect renegotiation during reconnect (paired,
+	 *    so read under srv_lock to match the writer in SMB2_negotiate)
+	 *  - dstaddr: SWN witness failover updates server->dstaddr; the
+	 *    128-byte sockaddr_storage is not atomic, so srv_lock is
+	 *    required against torn reads
+	 *  - nosharesock: can be flipped to true post-mount by SMB2_tcon
+	 *    on STATUS_BAD_NETWORK_NAME with ISOLATED_TRANSPORT, so read
+	 *    under srv_lock to pair with that writer
+	 */
+	spin_lock(&server->srv_lock);
+	ctx->ops = server->ops;
+	ctx->vals = server->vals;
+	ctx->dstaddr = server->dstaddr;
+	ctx->nosharesock = server->nosharesock;
+	spin_unlock(&server->srv_lock);
+
+	/*
+	 * These connection-tied options live on the shared TCP_Server_Info and
+	 * are reported by cifs_show_options() from server->*, not from the
+	 * per-mount ctx.  On a connection shared by several mounts, a mount that
+	 * never set them still displays them in /proc/mounts, so a
+	 * `mount -a -o remount` replays them into the new ctx.  Sync them from
+	 * the live server into the baseline so such an otherwise bare remount is
+	 * not rejected by smb3_verify_reconfigure_ctx().  They are established at
+	 * mount time and not mutated at runtime, so plain reads match how both
+	 * cifs_show_options() and cifs_construct_tcon() read them.
+	 */
+	ctx->noblocksnd = server->noblocksnd;
+	ctx->noautotune = server->noautotune;
+	ctx->sockopt_tcp_nodelay = server->tcp_nodelay;
+	ctx->echo_interval = server->echo_interval / HZ;
+	ctx->max_credits = server->max_credits;
+	ctx->min_offload = server->min_offload;
+
+	/*
+	 * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_caps()
+	 * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to pair
+	 * with that writer. tcon->posix_extensions is only ever set at
+	 * mount-time pre-publish, but read it under the same lock so the
+	 * derived linux_ext value is consistent.
+	 *
+	 * Only reflect the positive runtime state (extensions active) here.  Do
+	 * NOT fabricate no_linux_ext when they are inactive: no_linux_ext is the
+	 * user's explicit "nounix" request, whereas an inactive runtime state may
+	 * merely mean the current server does not offer them.  This ctx is copied
+	 * into cifs_sb->ctx by smb3_reconfigure(), so a fabricated no_linux_ext
+	 * would wrongly suppress POSIX auto-enable on a later reconnect/failover
+	 * to a capable server -- the same reason nopersistent is not derived from
+	 * use_persistent below.
+	 */
+	spin_lock(&tcon->tc_lock);
+	if (tcon->posix_extensions || tcon->unix_ext) {
+		ctx->linux_ext = 1;
+		ctx->no_linux_ext = 0;
+	}
+	spin_unlock(&tcon->tc_lock);
+	ctx->seal	  = tcon->seal;
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
+	ctx->persistent	  = tcon->use_persistent;
+	ctx->resilient	  = tcon->use_resilient;
+	ctx->witness	  = tcon->use_witness;
+
+	/*
+	 * Session fields: domainName and unicode are effectively
+	 * write-once (set during session setup, never freed/replaced
+	 * while the session exists), so plain reads are safe.  @ctx is
+	 * the caller's private copy, so filling in a missing domainname
+	 * here cannot leak or race.
+	 */
+	domain = ses->domainName;
+	unicode = ses->unicode;
+
+	if (domain && !ctx->domainname) {
+		ctx->domainname = kstrdup(domain, GFP_KERNEL);
+		if (!ctx->domainname)
+			return -ENOMEM;
+	}
+	if (unicode >= 0)
+		ctx->unicode = unicode;
+
+	return 0;
+}
+
 /*
  * Compare the old and new proposed context during reconfigure
  * and check if the changes are compatible.
@@ -1067,6 +1182,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
 	struct smb3_fs_context *new_ctx = NULL;
 	struct smb3_fs_context *old_ctx = NULL;
+	struct smb3_fs_context *base_ctx = NULL;
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
@@ -1079,9 +1195,37 @@ static int smb3_reconfigure(struct fs_context *fc)
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
@@ -1245,6 +1389,13 @@ static int smb3_reconfigure(struct fs_context *fc)
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
 
@@ -1961,6 +2112,48 @@ int smb3_init_fs_context(struct fs_context *fc)
 	char *nodename = utsname()->nodename;
 	int i;
 
+	/*
+	 * For reconfigure (remount), duplicate the existing mount context
+	 * instead of building one from scratch with init defaults.
+	 *
+	 * VFS sets fc->root before calling init_fs_context for reconfigure,
+	 * so we can access the existing superblock's context.  We dup the
+	 * live cifs_sb->ctx into a private new_ctx, then sync new_ctx with
+	 * runtime state (tcon/server/ses) so it matches what
+	 * cifs_show_options() displays.  Syncing into the private copy (not
+	 * the shared cifs_sb->ctx) avoids racing with concurrent
+	 * fspick/remount and /proc/mounts readers.  The parser will overwrite
+	 * only the options explicitly passed on remount, so any difference
+	 * between new_ctx and old_ctx in smb3_verify_reconfigure_ctx()
+	 * represents a real, intentional change by the user.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct cifs_sb_info *cifs_sb = CIFS_SB(fc->root->d_sb);
+		int rc;
+
+		ctx = kzalloc_obj(struct smb3_fs_context);
+		if (!ctx)
+			return -ENOMEM;
+
+		rc = smb3_fs_context_dup(ctx, cifs_sb->ctx);
+		if (rc) {
+			smb3_cleanup_fs_context_contents(ctx);
+			kfree(ctx);
+			return rc;
+		}
+
+		rc = smb3_sync_ctx_from_runtime(cifs_sb, ctx);
+		if (rc) {
+			smb3_cleanup_fs_context_contents(ctx);
+			kfree(ctx);
+			return rc;
+		}
+
+		fc->fs_private = ctx;
+		fc->ops = &smb3_fs_context_ops;
+		return 0;
+	}
+
 	ctx = kzalloc_obj(struct smb3_fs_context);
 	if (unlikely(!ctx))
 		return -ENOMEM;
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index dc5a8c1da623..16df7c423a9b 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -36,11 +36,16 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 
 	if (ctx && ctx->no_linux_ext) {
 		tcon->fsUnixInfo.Capability = 0;
+		spin_lock(&tcon->tc_lock);
 		tcon->unix_ext = 0; /* Unix Extensions disabled */
+		spin_unlock(&tcon->tc_lock);
 		cifs_dbg(FYI, "Linux protocol extensions disabled\n");
 		return;
-	} else if (ctx)
+	} else if (ctx) {
+		spin_lock(&tcon->tc_lock);
 		tcon->unix_ext = 1; /* Unix Extensions supported */
+		spin_unlock(&tcon->tc_lock);
+	}
 
 	if (!tcon->unix_ext) {
 		cifs_dbg(FYI, "Unix extensions disabled so not set on reconnect\n");
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4ce165e40657..ee63b8547728 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1215,8 +1215,10 @@ SMB2_negotiate(const unsigned int xid,
 			goto neg_exit;
 		case SMB311_PROT_ID:
 			/* ops set to 3.0 by default for default so update */
+			spin_lock(&server->srv_lock);
 			server->ops = &smb311_operations;
 			server->vals = &smb311_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		default:
 			break;
@@ -1231,12 +1233,16 @@ SMB2_negotiate(const unsigned int xid,
 			goto neg_exit;
 		case SMB21_PROT_ID:
 			/* ops set to 3.0 by default for default so update */
+			spin_lock(&server->srv_lock);
 			server->ops = &smb21_operations;
 			server->vals = &smb21_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		case SMB311_PROT_ID:
+			spin_lock(&server->srv_lock);
 			server->ops = &smb311_operations;
 			server->vals = &smb311_values;
+			spin_unlock(&server->srv_lock);
 			break;
 		default:
 			break;
@@ -2252,8 +2258,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (server->ops->validate_negotiate)
 		rc = server->ops->validate_negotiate(xid, tcon);
 	if (rc == 0) /* See MS-SMB2 2.2.10 and 3.2.5.5 */
-		if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT)
+		if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT) {
+			spin_lock(&server->srv_lock);
 			server->nosharesock = true;
+			spin_unlock(&server->srv_lock);
+		}
 tcon_exit:
 
 	free_rsp_buf(resp_buftype, rsp);

base-commit: c0a27675eaf08255017b3cabc28c99c0cd71f468
-- 
2.43.0

