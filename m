Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5521E3C8728
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 09:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786614182; cv=none; b=KUOjoLEsN68g7JFc+3whri8Mj4h5Hf2Z/kIZC3jf9a1JGAa8wxHVBH8wDudTmVGZLnq/hu7Glt76d0ipWw5o/in68DvSoaV8liFGUq+UJ23Yy+QaB1RO5PAw2APRlL8+HUQtas5wUX+BdM5Sc3g2y3Xl3CfQYFKVNrJO8BixshE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786614182; c=relaxed/simple;
	bh=OxtRfiIHh3S1kfQnPTLdeqpvQiUujaYRxQEXReFGzko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1icl28qdvUJWo+D/H/Wkf35Nys0OlTzVwxm8S8uH5p0Ym+LwxQarhwrede91AlCkU7PODBQ5L+xMwx3oTBfDAJ9sB1WsFAbg8KaIMIomqNLebqSn3KFCdAMHPTFrzgLltFQHxMZqcwH1xPybFn9k8nuF1sVJElR10AK7zeJbc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/OntauW; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/OntauW"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cbb7926836eso403058a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 02:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786614180; x=1787218980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OO+deiHIxK+tXMQ1FpAuYruDMnb7+U8IXX7Uan9Hvnc=;
        b=j/OntauWP+T4ZrX47IKeDXx83dml40vPkxPgg0HQGnWz1jJceQpebsJd56QEQyWeKY
         2OSaIXmNoP4vEA0LM9ILJ9VojLmvyztcsbF1aQO3Tn/AMy2H9HTRIZYnZMp37hkWqHbi
         jRrCW5XZMk69pxYa7V7affTZn0EsgqD1L/ma3WrVDZBqrZbt2ezFU2H2cpk9+6u2Sa8H
         Dr8K4aebcPmJ+j8KVCaKgFvGTnEzjGkea2Ju9/XFuToSsyZsm+sti+O2SV7E7PwGxbrr
         m/TdMYx8sQU2hNamcgozpLkXFz3wo6yOsfee6cGyPo4JFkwRH4ZXjmZpti7jaeBln9jz
         CybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786614180; x=1787218980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OO+deiHIxK+tXMQ1FpAuYruDMnb7+U8IXX7Uan9Hvnc=;
        b=mXgcrC1UQoW9bYdMw4wCMArszbbnzaHkb0bhHSuU+KrQ1+sX8UzK1E7WdJvnLCdf20
         cjCIHgkeClplfhX2EX7ciarlw4GQsIy7PW3gM9pIj8eSpaR91pTf5eH/SXS07iscRTDz
         T4kipXr+aKFWzpniBIv8FiS3OHE5jsknVkk07hQtJd/CYBlIOS35cuAvI7D1C8MFySkn
         0qH1Yny8xxmjZ0ZWjzMl1O0R8IvHpFQ2r+Ys4IcsLkpeYOlSEthd6tO6aPWZCU75uOia
         lrNxsZkb6oEUzwsQGshbSJMFX5RDxB5B2MmkzcrUtqYaAiEzv8kK97ufZa3OH1L+Cehp
         CpFQ==
X-Forwarded-Encrypted: i=1; AHgh+RqiSERyXc39hnhCw1urMZhExn1h+TdzBXbwMlC6oXoL0JW9qEWgF7tJUG9j73CkaQ9/eGOqDT5/FVHC@vger.kernel.org
X-Gm-Message-State: AOJu0YxGTV1MLRQMWCnQ6hFTpXZKdGDIocVFlFFLj5mcZooFeEZiM+Vm
	J/zPM/VOD14i8s+J9n+imlWNRkW7FfGCYy6TpYaeJhmeD0MzykKpdmgdD7iJZA==
X-Gm-Gg: AR+sD13PZtSzDIQxMM8KBk7pNTtvJkxP256jTZK8aRTRjoeOLrIZvH0hinUTNHhd/lY
	o1YAOIlbAOXZGtb0BWvjKa+Eslz5Z98vvcNQZLNXPABMeuT3wWzfAQ8paQM0SMNK6Y0wPEnVW0/
	N2puns/vwXjvUtrJx6doncweItC7zpbu7WoBn1kQ3JMjhcsKt2g7R7myBzrCt3nuR9loSQiksYU
	Ww2ngA6aA4c6zbAg9mLr5bnbWWKbGOCmZevrQfCS0ujUVm0Ii0CF7Nv4CF9LQOfFsvGGq4f6aB2
	mw3u0DsWHdVUGN/zNCXf6yoqsy8JP24Qy8Bs3L00uP7CCYtngxuJiUv2Ei0Od86BJ571XnY0KH/
	YDFSbpMa04yw14hAIMrGFw0fbr7RZaB7JV2bgqv02CS6iNqKoa0YvMGzjpxdwSKJf23vsimyfW/
	Ncbb5PZFQMM0XAvQlfgNhWiDYSfBJ813C2hB9NFRQC8kq68IumAI1c3r0/HgCR6Lbel+37b0eXk
	GvF2mgvFvkPp96G7l12PejrilvyZBxxMcpotnUWC5usnQN4noAWWVpOtJOZK1QxGFhpoKbzOsOc
	X5b9y4Tx+wvkPxUx
X-Received: by 2002:a05:6a20:1609:b0:3c0:ac0f:6558 with SMTP id adf61e73a8af0-3cc54fafa7emr6309950637.2.1786614179398;
        Thu, 13 Aug 2026 02:42:59 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31ebc760524sm6409135eec.1.2026.08.13.02.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 02:42:58 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Cc: Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH v2 1/8] smb: client: sync runtime state into ctx on reconfigure
Date: Thu, 13 Aug 2026 09:42:44 +0000
Message-ID: <20260813094251.666373-2-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813094251.666373-1-rajasimandalos@gmail.com>
References: <20260813074517.607275-1-rajasimandalos@gmail.com>
 <20260813094251.666373-1-rajasimandalos@gmail.com>
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
defaults are a poor baseline for deciding what changed on remount.

On reconfigure, duplicate the live cifs_sb->ctx into a private context
and sync it with runtime state via a new smb3_sync_ctx_from_runtime()
so the baseline matches /proc/mounts.  This mirrors libmount
(util-linux), which replays the current /proc/mounts options on
remount: unless the baseline equals the displayed state, a bare
'mount -o remount' looks like a change and is rejected.  Only positive
runtime state is reflected -- no_linux_ext / nopersistent are not
fabricated, as a fabricated value would suppress POSIX / persistent-
handle auto-enable on a later reconnect.

This is preparatory plumbing for the next patch, which compares new_ctx
against old_ctx to reject non-reconfigurable option changes.

Not addressed (pre-existing): cifs_sb->ctx has no lifetime protection.
cifs_show_options() reads string fields (e.g. ctx->iocharset)
locklessly while smb3_reconfigure() frees and replaces them in place,
so a reader racing a remount can take a use-after-free read (KASAN
splat/oops), not merely a stale value.  The reconfigure-time dup added
here is one such lockless reader.  The exposure is bounded --
reconfigure is privileged and serialized by s_umount -- and the proper
fix (an RCU/refcount ctx lifetime) is a larger, standalone change.

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

