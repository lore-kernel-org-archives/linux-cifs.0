Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE91EEA31
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 06:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777615755; cv=none; b=Okmb2sQVqqlOpOgcIZzra0fcl8JXeMCpIVyD9FMsnWhuaH+QzhEx3uZeU84hG2DzKwTlT/OIw1QUzxZ9ww6bCXYLAjxSyQiJtrLlQg3+os8SvFU/dCks13W0Pym/g85pXjvpwtSPHnxriocWBop98VdOsESL81UUzskbbVVGKD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777615755; c=relaxed/simple;
	bh=nP4pQbVF7HV231uf0jmDk9LxaD/5c4P8phigOlYZ/7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r33yS6OvbgYDroiaCaZA8LTd8QlgVGLHXL8Crmy7ERPFAF8mBmLTDvaVjr4AcmP9lw7foNv72bn1pI/3Jk8uus5by99ud+6ojMAopbK3VHiOjuiGWJoz8+UUiiF1XTsZewryB95TIrZ5ifSV+wwExd/grVHJ7qhl0e+dl9zSCwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gtLyLYRW; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gtLyLYRW"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-364efc41420so68934a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 23:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777615753; x=1778220553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ljh2MVoIl78+pzMqYmjc4MFbJ/Ye1uVBhLvcnHvPQb0=;
        b=gtLyLYRWo84NN1/RjJJ7JDCNNH7qYb0UHwkOpsgQGVxKVqVYpWmTUqS4niSV+rW6FG
         jU2ZuVZLiWEJnJHdmbhassqFI/XI4r/jD4s9YwrhxF7OSPrWOyYYSnOFqtZumrvp74PM
         /I19xR4WT5BSXP+9EGHrrG2cUDKm5mkJl+pgrIzwc7174pAlpqqZtyl3+fLIF5eEd0zj
         c9XIVv0J9QU4cy0TM1RR5ko5bWy2YiLXbYKzwbdy816+JhQNCzT96OSYuSF4Sq68Gz+Z
         hRtv3wAk/wSLsTmD7v7+1Uc3YuPCRmDC1NGy/HAvVH9uvYhtXC0LNBFtCoixSiPs5ej8
         C1hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777615753; x=1778220553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ljh2MVoIl78+pzMqYmjc4MFbJ/Ye1uVBhLvcnHvPQb0=;
        b=JLCLL7CDlbk+lF+Jbf23jkKcdIvptVb+B3ZnakN6oNzz05nSGF8LQdhjoT6y7nU+nz
         k+5WRpmynwhGrtenLneyyP3NIyWF6mf+XxSlbNr95c/DL5VIe8qUuAhSJqPUB5f/E96W
         kGquL0zvplA1WDmKdicTlqhpZU4hn6I9SdUJKzItyLxHJSFlNqnqidOtGVGER+pFoNTD
         w2l4HGOpK4D3Qmye/uaOxhURaeAlmz29C0ysmbsNbaWqV4b76kreHPxPjDLeh2i8hl21
         u8Zkq2hffWeVRK2Xqa4vkkcbXvNlssBxM6f0lBD213xhuaZM7tFRHMAie++sH8jZ0mIG
         guAA==
X-Forwarded-Encrypted: i=1; AFNElJ/BLqa0KmZ6ihc5ok5eG3vKVoUzHEJe6nHS0s8cXkNG+nKr8YQ/wAsamQUXRjERLvZjZ8Ej0zC1b2c9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6rcmchui1t+7Smjas9rMC8BACSR5/G5ksFgwNbZYrhiYHGDS9
	h159JUNYe5ChsmwLQCpf+f6h57Y7ykLfB/psCR6gonj2xXfx9YMqMOaB
X-Gm-Gg: AeBDiet5i+LS0R2xYaWCcAQPwM3/EP4dM1MeXBZ3QCTjezi/BbXyj03lOC7MRUGp3ah
	c6X/0Q+P3BtPLIr9+L/+XgFLhI8BiGNEcC+/0gzc8wee8vc121v7tRX9wp74qI4e0AyXgJCqxsK
	0YcN/SwKH1tPtG4AEgMkcW8Fl4b1vJb/FI/k0fiaaM/vyueu2yq0wntXrxWVt2YDYcNabieHIs5
	Osqn1H0Qi9z02E5+x2+CrowWgbUEsZZGaTIx1QE88JKh62mYGsx6EX94bany6ZRz7MBc5fo93w0
	UIkVFNByts47TikaHb0R26XXtmhnfjz67RUNJU8/ty8n+Yh7yRWQU7sgeEZWeM6SNn/+dBtprAP
	oLsFSUkyOF5GFi/E9zhIdRbthKhN2Xvs9WdQGKh05yYZmk5t0cDsRaWvAQJ0YvGKRBmuqPQD29D
	lt3VCN+CJrYq2zmTiS6b0G5lT1qPT0gNy6tJ5WRA==
X-Received: by 2002:a17:90b:3a4b:b0:359:8e93:4fd6 with SMTP id 98e67ed59e1d1-364c3157c9amr3639546a91.4.1777615752788;
        Thu, 30 Apr 2026 23:09:12 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364ec00b094sm1252022a91.9.2026.04.30.23.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 23:09:12 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Rajasi Mandal <rajasimandalos@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v5] smb: client: avoid ctx corruption on failed multichannel remounts
Date: Fri,  1 May 2026 15:09:07 +0900
Message-ID: <20260501060907.3859641-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_reconfigure() moves string fields out of the live mount context
(cifs_sb->ctx) before updating multichannel state. If the remount fails
after that point, the live context can be left with NULL strings or with
options that do not match the session state.

Snapshot cifs_sb->ctx on entry, build the new context separately, and
replace cifs_sb->ctx only after the staged reconfigure work succeeds.
Restore the snapshot on failure paths before committing session-side
state.

Also make smb3_sync_session_ctx_passwords() all-or-nothing, and keep the
ses->password commit before smb3_update_ses_channels() so newly added
channels authenticate with the new credentials.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
v5: (feedback from Henrique Carvalho)
 - Drop mchan_rc / scale_busy; the early failure paths now restore
   cifs_sb->ctx from a snapshot taken on entry.
 - Build new_ctx separately and replace cifs_sb->ctx only on success.
 - Make smb3_sync_session_ctx_passwords() all-or-nothing: allocate
   both copies first, commit only when both succeed.
 - Switch smb3_sync_ses_chan_max() max_channels parameter to size_t
   to match struct cifs_ses::chan_max.
 - Shorten the commit message and follow nearby CIFS log style.

 fs/smb/client/fs_context.c | 163 +++++++++++++++++++++++++------------
 1 file changed, 110 insertions(+), 53 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..1f0cbcf78e17 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -767,7 +767,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 					    void *data);
 static int smb3_get_tree(struct fs_context *fc);
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels);
 static int smb3_reconfigure(struct fs_context *fc);
 
 static const struct fs_context_operations smb3_fs_context_ops = {
@@ -1041,24 +1041,35 @@ do {									\
 
 int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
+	char *password = NULL, *password2 = NULL;
+	bool update_password = false, update_password2 = false;
+
 	if (ses->password &&
 	    cifs_sb->ctx->password &&
 	    strcmp(ses->password, cifs_sb->ctx->password)) {
-		kfree_sensitive(cifs_sb->ctx->password);
-		cifs_sb->ctx->password = kstrdup(ses->password, GFP_KERNEL);
-		if (!cifs_sb->ctx->password)
+		password = kstrdup(ses->password, GFP_KERNEL);
+		if (!password)
 			return -ENOMEM;
+		update_password = true;
 	}
 	if (ses->password2 &&
 	    cifs_sb->ctx->password2 &&
 	    strcmp(ses->password2, cifs_sb->ctx->password2)) {
-		kfree_sensitive(cifs_sb->ctx->password2);
-		cifs_sb->ctx->password2 = kstrdup(ses->password2, GFP_KERNEL);
-		if (!cifs_sb->ctx->password2) {
-			kfree_sensitive(cifs_sb->ctx->password);
-			cifs_sb->ctx->password = NULL;
+		password2 = kstrdup(ses->password2, GFP_KERNEL);
+		if (!password2) {
+			kfree_sensitive(password);
 			return -ENOMEM;
 		}
+		update_password2 = true;
+	}
+
+	if (update_password) {
+		kfree_sensitive(cifs_sb->ctx->password);
+		cifs_sb->ctx->password = password;
+	}
+	if (update_password2) {
+		kfree_sensitive(cifs_sb->ctx->password2);
+		cifs_sb->ctx->password2 = password2;
 	}
 	return 0;
 }
@@ -1072,7 +1083,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
  * with the session's channel lock. This should be called whenever the maximum
  * allowed channels for a session changes (e.g., after a remount or reconfigure).
  */
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 {
 	spin_lock(&ses->chan_lock);
 	ses->chan_max = max_channels;
@@ -1082,12 +1093,15 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
+	struct smb3_fs_context *new_ctx = NULL;
+	struct smb3_fs_context *old_ctx = NULL;
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
+	bool need_mchan_update;
 	int rc;
 
 	if (ses->expired_pwd)
@@ -1097,6 +1111,16 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (rc)
 		return rc;
 
+	old_ctx = kzalloc_obj(*old_ctx);
+	if (!old_ctx)
+		return -ENOMEM;
+
+	rc = smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
+	if (rc) {
+		kfree(old_ctx);
+		return rc;
+	}
+
 	/*
 	 * We can not change UNC/username/password/domainname/
 	 * workstation_name/nodename/iocharset
@@ -1106,16 +1130,22 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
+	STEAL_STRING(cifs_sb, ctx, domainname);
+	STEAL_STRING(cifs_sb, ctx, nodename);
+	STEAL_STRING(cifs_sb, ctx, iocharset);
 
-	if (need_recon == false)
+	if (!need_recon) {
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
-	else  {
+	} else {
 		if (ctx->password) {
 			new_password = kstrdup(ctx->password, GFP_KERNEL);
-			if (!new_password)
-				return -ENOMEM;
-		} else
+			if (!new_password) {
+				rc = -ENOMEM;
+				goto restore_ctx;
+			}
+		} else {
 			STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
+		}
 	}
 
 	/*
@@ -1125,11 +1155,29 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if (ctx->password2) {
 		new_password2 = kstrdup(ctx->password2, GFP_KERNEL);
 		if (!new_password2) {
-			kfree_sensitive(new_password);
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto restore_ctx;
 		}
-	} else
+	} else {
 		STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
+	}
+
+	/* if rsize or wsize not passed in on remount, use previous values */
+	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
+	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+
+	new_ctx = kzalloc_obj(*new_ctx);
+	if (!new_ctx) {
+		rc = -ENOMEM;
+		goto restore_ctx;
+	}
+
+	rc = smb3_fs_context_dup(new_ctx, ctx);
+	if (rc)
+		goto restore_ctx;
+
+	need_mchan_update = ctx->multichannel != cifs_sb->ctx->multichannel ||
+			    ctx->max_channels != cifs_sb->ctx->max_channels;
 
 	/*
 	 * we may update the passwords in the ses struct below. Make sure we do
@@ -1140,54 +1188,55 @@ static int smb3_reconfigure(struct fs_context *fc)
 	/*
 	 * smb2_reconnect may swap password and password2 in case session setup
 	 * failed. First get ctx passwords in sync with ses passwords. It should
-	 * be okay to do this even if this function were to return an error at a
-	 * later stage
+	 * be done before committing new passwords.
 	 */
 	rc = smb3_sync_session_ctx_passwords(cifs_sb, ses);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		kfree_sensitive(new_password);
-		kfree_sensitive(new_password2);
-		return rc;
+		goto restore_new_ctx;
 	}
 
 	/*
-	 * now that allocations for passwords are done, commit them
+	 * If multichannel or max_channels has changed, update the session's channels accordingly.
+	 * This may add or remove channels to match the new configuration.
+	 */
+	if (need_mchan_update) {
+		/* Prevent concurrent scaling operations */
+		spin_lock(&ses->ses_lock);
+		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+			spin_unlock(&ses->ses_lock);
+			mutex_unlock(&ses->session_mutex);
+			rc = -EINVAL;
+			goto restore_new_ctx;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+	}
+
+	/*
+	 * Commit session passwords before any channel work so newly added
+	 * channels authenticate with the new credentials.
 	 */
 	if (new_password) {
 		kfree_sensitive(ses->password);
 		ses->password = new_password;
+		new_password = NULL;
 	}
 	if (new_password2) {
 		kfree_sensitive(ses->password2);
 		ses->password2 = new_password2;
+		new_password2 = NULL;
 	}
 
-	/*
-	 * If multichannel or max_channels has changed, update the session's channels accordingly.
-	 * This may add or remove channels to match the new configuration.
-	 */
-	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
-	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
-
+	if (need_mchan_update) {
 		/* Synchronize ses->chan_max with the new mount context */
 		smb3_sync_ses_chan_max(ses, ctx->max_channels);
-		/* Now update the session's channels to match the new configuration */
-		/* Prevent concurrent scaling operations */
-		spin_lock(&ses->ses_lock);
-		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
-			spin_unlock(&ses->ses_lock);
-			mutex_unlock(&ses->session_mutex);
-			return -EINVAL;
-		}
-		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
-		spin_unlock(&ses->ses_lock);
 
 		mutex_unlock(&ses->session_mutex);
 
-		rc = smb3_update_ses_channels(ses, ses->server,
-					       false /* from_reconnect */,
-					       false /* disable_mchan */);
+		smb3_update_ses_channels(ses, ses->server,
+					 false /* from_reconnect */,
+					 false /* disable_mchan */);
 
 		/* Clear scaling flag after operation */
 		spin_lock(&ses->ses_lock);
@@ -1197,22 +1246,30 @@ static int smb3_reconfigure(struct fs_context *fc)
 		mutex_unlock(&ses->session_mutex);
 	}
 
-	STEAL_STRING(cifs_sb, ctx, domainname);
-	STEAL_STRING(cifs_sb, ctx, nodename);
-	STEAL_STRING(cifs_sb, ctx, iocharset);
-
-	/* if rsize or wsize not passed in on remount, use previous values */
-	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
-	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
-
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
-	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
+	memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));
+	kfree(new_ctx);
+	new_ctx = NULL;
+	smb3_cleanup_fs_context(old_ctx);
+	old_ctx = NULL;
 	smb3_update_mnt_flags(cifs_sb);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif
 
+	return rc;
+
+restore_new_ctx:
+	smb3_cleanup_fs_context_contents(new_ctx);
+restore_ctx:
+	kfree(new_ctx);
+	kfree_sensitive(new_password);
+	kfree_sensitive(new_password2);
+	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
+	memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
+	kfree(old_ctx);
+
 	return rc;
 }
 
-- 
2.43.0

