Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9565A4252AC
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992153; cv=none; b=Ye1mmfryu+UeYuW3oTvrGBTgGqEhRgDXyRYlzMvl8z6HWU7Kh1YpsZQNJXPIVvYrM5My0lBBaqciEV472r+oBA9k/p8lw1yJyTbVse7dWIXqpEf+r/rN7v3fYxYWoUn8RiIHUCmf/IKPYXZnFajod1J2vKqidYq6hZ9hFr3e3H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992153; c=relaxed/simple;
	bh=l7QZIOTNwrq3vH/zCBV2W7ozWeP6Z5nR0d4LN+vuDxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shvr9oMU99oKHWQhd+OKvnCdO+nDbqs8BXUjtLBJeeX9Cfxp7ojbf7fkcV35lQdkKTmV5yzoWodiqRDN7CdIUrh4mK3lNp99g/XwWGP5OpEE/mK2N5Ypc0OWSRgM+SL+V9qxRDCSiEbKqIds2+583PNSn7t3CPB7E/WPaoLeqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fg+ijW21; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fg+ijW21"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36b9d265355so1181913a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992144; x=1783596944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJ9iCHB9sbvcmZy5nVVVV8AFM81EYbRzctkVxH4Ahuk=;
        b=fg+ijW21yBSzsTXaaQX+je3Lb6Y9GyLF8978NcASq+vS79E3EoqbfC0f8QMn9fUxz7
         zjR+h9eb0zFdEmqVOW0B21LRQZinnPwj1daSs0UMJiQRCoI7gYk7oV6KmMzq5LrN/a4q
         Nepg9g9w7xWhFr0ftcdU5AWfVBMDfCBZYxThlbvWjrT1tUkHDXri1RXzF0zFAfkjVQyG
         8/ALvB6syi/8qFL+1XXyaeipCrd3HxPyy4QDbY7FyOJGDA7Et9ZCZTl1xM3Xu1Ql/I4A
         olP2CL6gIF7o0y7XpqSgUzbr1+gtPA26q5nejyY74vk6ME+rKQGXV5yRy3xIdiuSq9b8
         bimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992144; x=1783596944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KJ9iCHB9sbvcmZy5nVVVV8AFM81EYbRzctkVxH4Ahuk=;
        b=lkqPXZzkNE4PNZadzQX7DZ6UQbUDgbl9qiP4TAkjT5uNBdcQBrNRCMtIRKwK4RTVos
         bXYu48jg9cW6lwEAhr+uyv4nQkBD7ZTnAuS1SyeL3X42fdc8CpU5Ad432YOyxFdpHxuN
         fPFBm6kQgyP7KOPuhtS8xu1aVMWVsrTs3tPb5EdUaWX6kptTWYbjxGvbIDxVdJYyyRAe
         yAoJJfwjy2uiOWXpXwchj7Uszyy9TJMQRf40F1jJ+1f+6BJDdJHXN3DznEphehFJF3t9
         GLrpL4z34ZuGdMwQepMHcH6OSWot5hA82RfomHTNTV6jhm6IR7xuMxH1Ud73g8LBRkhu
         rThA==
X-Gm-Message-State: AOJu0YzBSc1atBk7lh89tIf4+OL0yZS1orzVrMf4EEscz5humpiAAKmn
	U6RSsUni9CGXm0eNNSvm8f7RSQq49kT1mJT1rG5XtppmSYB35UVJX1bhB/hBbg==
X-Gm-Gg: AfdE7clHZCrX3IoKMjzUgjPEJXr4ejGoKNqhri9fxDi7Bn4xWIrIUD8WqNEaQQDFu4V
	8ZUIfoXiI9w4dPBJt6MNqI9Wa4Z2CK9REDUqxPwXffkxFoHY5Qm12n/nBEZl4wVG7IT12M4MTk0
	a4oXBT2fbyl3HDIBvlD1plbaPZXoxyMNFqVjuwZUFvZaPNCqQ+hMBLOLa4C/9Pw+HZi1ZozQcK7
	4yjbS5ifRauK2VkNJ44G3oGNaeDxrTnS9pfKXpNURKeb8WKrrEVv9GpThZVwo4xtBr0YLnRmyDf
	cQFQDE4i2NIhDOuv2pnG+1PrDUcY4KPO/tlp/KrXkJ3q5BsGhJKKmsvj5QSsz58bvwhUMt9i9Sg
	tAtCVBuC7imqGnQ7wFfiz9uBA+a5D3ZRGPto7k54qDptGPlix46ybk9NZwrDNfB5b81LTLdAnaV
	KcrR4TBwgGt1tAZbfk0oyUnOfm8lZVdDl3tBDK8i+0DWK4DRndsPEReb21mr5MT7gnt1g7rcTX/
	pddrIR4bka/
X-Received: by 2002:a17:90b:48c8:b0:37f:9ce1:735b with SMTP id 98e67ed59e1d1-380ba920706mr5207202a91.28.1782992143815;
        Thu, 02 Jul 2026 04:35:43 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:35:43 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 1/9] smb: client: sync runtime state into ctx on reconfigure
Date: Thu,  2 Jul 2026 11:35:27 +0000
Message-ID: <20260702113535.4044308-2-rajasimandalos@gmail.com>
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

smb3_init_fs_context() builds a fresh context with init defaults on
every call, including reconfigure (remount).  Many fields displayed
by cifs_show_options() are sourced from tcon/server/ses rather than
from ctx, so the init defaults do not reflect the live mount and
cannot be used as a baseline for comparing new vs old options on
remount.

Detect FS_CONTEXT_FOR_RECONFIGURE in smb3_init_fs_context() and
duplicate the existing cifs_sb->ctx instead.  Before duplicating,
sync ctx with runtime state via a new helper
smb3_sync_ctx_from_runtime() so the baseline matches what
cifs_show_options() displays.  Add srv_lock / tc_lock around the
relevant runtime writers (SMB2_negotiate, SMB2_tcon,
reset_cifs_unix_caps, cifs_swn_set_server_dstaddr) so the helper
can read them without torn-read races.

Also preserve inherited multichannel/max_channels values in
smb3_handle_conflicting_options() during reconfigure when neither
option is explicitly specified, since the dup'd context already
carries them.

This is preparatory plumbing for a subsequent commit that compares
new_ctx against old_ctx in smb3_verify_reconfigure_ctx() to reject
non-reconfigurable option changes.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/cifs_swn.h   |  14 ++++-
 fs/smb/client/fs_context.c | 111 +++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb1ops.c    |   7 ++-
 fs/smb/client/smb2pdu.c    |  11 +++-
 4 files changed, 139 insertions(+), 4 deletions(-)

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
index 9addc74ce57e..576a78b6d0cb 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -926,6 +926,81 @@ static void smb3_fs_context_free(struct fs_context *fc)
 	smb3_cleanup_fs_context(ctx);
 }
 
+/*
+ * Sync cifs_sb->ctx with runtime state from tcon/server/ses so the
+ * baseline matches what cifs_show_options() displays.  Wide fields
+ * (dstaddr, ops/vals) are protected by the matching server/tcon lock;
+ * the remaining word-sized scalars rely on the same unsynchronized-read
+ * pattern already used by cifs_show_options().
+ */
+static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
+{
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_ses *ses = tcon->ses;
+	struct smb3_fs_context *ctx = cifs_sb->ctx;
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
+	 * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_caps()
+	 * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to pair
+	 * with that writer. tcon->posix_extensions is only ever set at
+	 * mount-time pre-publish, but read it under the same lock so the
+	 * derived linux_ext/no_linux_ext pair is consistent.
+	 */
+	spin_lock(&tcon->tc_lock);
+	if (tcon->posix_extensions || tcon->unix_ext) {
+		ctx->linux_ext = 1;
+		ctx->no_linux_ext = 0;
+	} else {
+		ctx->linux_ext = 0;
+		ctx->no_linux_ext = 1;
+	}
+	spin_unlock(&tcon->tc_lock);
+	ctx->seal	  = tcon->seal;
+	ctx->persistent	  = tcon->use_persistent;
+	ctx->nopersistent = !tcon->use_persistent;
+	ctx->resilient	  = tcon->use_resilient;
+	ctx->witness	  = tcon->use_witness;
+
+	/*
+	 * Session fields: domainName and unicode are effectively
+	 * write-once (set during session setup, never freed/replaced
+	 * while the session exists), so plain reads are safe.
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
@@ -1961,6 +2036,42 @@ int smb3_init_fs_context(struct fs_context *fc)
 	char *nodename = utsname()->nodename;
 	int i;
 
+	/*
+	 * For reconfigure (remount), duplicate the existing mount context
+	 * instead of building one from scratch with init defaults.
+	 *
+	 * VFS sets fc->root before calling init_fs_context for reconfigure,
+	 * so we can access the existing superblock's context.  We first sync
+	 * cifs_sb->ctx with runtime state (tcon/server/ses) so that ctx
+	 * matches what cifs_show_options() displays.  Then we dup old_ctx
+	 * into new_ctx.  The parser will overwrite only the options
+	 * explicitly passed on remount, so any difference between new_ctx
+	 * and old_ctx in smb3_verify_reconfigure_ctx() represents a real,
+	 * intentional change by the user.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct cifs_sb_info *cifs_sb = CIFS_SB(fc->root->d_sb);
+		int rc;
+
+		rc = smb3_sync_ctx_from_runtime(cifs_sb);
+		if (rc)
+			return rc;
+
+		ctx = kzalloc_obj(struct smb3_fs_context);
+		if (!ctx)
+			return -ENOMEM;
+
+		rc = smb3_fs_context_dup(ctx, cifs_sb->ctx);
+		if (rc) {
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
index d34b3d99f6ed..33c890e14988 100644
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
index 4972cfe249f6..958ca0753774 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1189,8 +1189,10 @@ SMB2_negotiate(const unsigned int xid,
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
@@ -1205,12 +1207,16 @@ SMB2_negotiate(const unsigned int xid,
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
@@ -2226,8 +2232,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
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
-- 
2.43.0

