Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3202930B509
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 13:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678792; cv=none; b=orU07SoO0eClrDjYFMyheF92hn/nm5V8gWz3FE8/IcEkcrp5ZJszsG1PLBvtSnpqhF+0g+pUDWacB31d3/Irxl9QY2z1DNsch9V0KQH5ylJ88T/1mzvs0yy31Qnv//CDH6TCouf+Suxo59+kbFR/xW1uXMvuN9BHVPiSPTc62go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678792; c=relaxed/simple;
	bh=u6sTqYkY03AXF8Fsq7JIjX4yOqxj4hiNwK8IYEC8lg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWOJeR46ioMEX6bie08nUKbNmnp9vPY2XnrrqAoGA3BnJK1EFxdWR8eXlrECtDlPeYLOrzS2uzWrn/wcxdx0xHQSF08CNquILdo5bYiCdksn2Z8lhZLwcplaMUdK92/YBIHVlXmVvKG4wiQMYflCKeyX2T84Szn+AwNHH7uKquI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvkGe515; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvkGe515"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-83538fcdda8so196056b3a.3
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 06:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778678788; x=1779283588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/bkkMADpz2yXiOC9+FVOiFEb43Zu5O/R6fBoD4YtC/M=;
        b=jvkGe515DwLEm66AIvyJpDqf4nsjRvlEe96WbJxTioVg1wHay4bhQjKFDVq8tpnzvL
         A9YhWQLhEY46vBzMczEHfS2zXzBdVHpShVm6b7F/O2IYIp0yhTj2DESEgLIQb453O9YB
         rrQd4f2NyprXjPhPim15/kito8tc9zBVqUXW417gcntgpFEIxroqTceYk5k1GdmKFjhu
         GcY+Yhv7y6GAjEGK0YiyCdpngd1AB7R3v9YCj2yGGX/gAZSryUUvGJVGwKHLMEQ7gLqT
         FmNfPLIlZmUoMNX3oB4x69iVO5BDYifS5Vscl0JYNB+sCG7XDtdCdpzUj/1YzSA2tHlA
         GqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678788; x=1779283588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/bkkMADpz2yXiOC9+FVOiFEb43Zu5O/R6fBoD4YtC/M=;
        b=IpfFC94OSTsx1ZUkhbUSqHfXquH0n0md8UCttaHXB0MuxPOtg4CH7QfmRgsNVZLJQ0
         VtAN7JDU6iOOlzP+RTEtNJsvUXdoCay/bkmL2Rw/u6Y19+pOzDltcrAmdo0fhMHfpOd4
         PIovJGTTJY0fUd5BYWG4QUuViQ3SIRpd2sbi4Blw9ZJTfS2X2ERwHskLOSys2EveOeUQ
         SXLLBZ+A2lpIJc15X+0wxc57lEZb0YXMXnUlBaDjT5bLSbrPO/3gN01DEoZkyHtQC5gU
         RMLZpBvug0SSjV+Khasjf/ImtqX6kQ8A4fU05re+DnvJ30F6vVj19ebVGJcpp0i37lyM
         vo7g==
X-Forwarded-Encrypted: i=1; AFNElJ/58Z7Od+MgqQfhlMNVOxD7CL6SQ55MkDkevqbSKq8huDaRJAEqYjbEQnAH/iZSPafjcZLD/FwcuxOG@vger.kernel.org
X-Gm-Message-State: AOJu0YxmrQn2wj/FOzsKulMW7U1NRRJXQoAfDIqOA/ToB/wyv0EyH71C
	aEHgrxqM3lRCq5W9HQpo8eFdQd5cN5Xur3+5mIkiXaZSQhJUNQl38efVFnLe6jCM
X-Gm-Gg: Acq92OExc9XeAnt6jMJhgzVT9oa2dYPGJd/OCIfoMDzEwXDEr4oXWsFM50vir+lsjpz
	Hhu3wJjhG7DTYYpeUwEOzfgxZxx6Ii54kreYebvxIy43XTUZu0tLE7Q0zet7krgxY74m16PYF+T
	H3Coytz1hPJLRdxPT8se3Zo11kqWNjG3d+vUnBYyGi6cjDis/kncbrm4E5jcxO54JHXO57qHoZK
	G0djw/O6GvFVaq34z0CjYpjr1riAWtN/OxSJuA3Ih6URV85Tur2YcfcTUNHmwxNE7AaqSGKyIMM
	u+0UoD/SkZESOXDdpMY/4HMTakzEYK2Xt5WgclQEjFHXNqyFS7MbCo2piCskz8kia759mUQbpFU
	+/GWjn8TrHJ1bhKfQun2dZ2WvJj0sFUsB2INa27k5YfkH2BwhCsUe26FbcSe8uFUGozVVPcVC+N
	ZszAYabgah3xE+SQ0xGAIgnBUpzgM=
X-Received: by 2002:a05:6a00:3d44:b0:838:c01a:7a56 with SMTP id d2e1a72fcca58-83f0427a642mr1778347b3a.4.1778678788250;
        Wed, 13 May 2026 06:26:28 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83965645140sm27611899b3a.12.2026.05.13.06.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 06:26:27 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	Rajasi Mandal <rajasimandalos@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v6] cifs: client: stage smb3_reconfigure() updates and restore ctx on failure
Date: Wed, 13 May 2026 22:26:22 +0900
Message-ID: <20260513132622.2640103-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501060907.3859641-1-charsyam@gmail.com>
References: <20260501060907.3859641-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_reconfigure() moves strings out of cifs_sb->ctx before the
multichannel update, so a later failure can leave the live context
with NULL strings or options that do not match the session.

Stage the new ctx separately, commit it only on success, and restore
the snapshot on failure. Also make smb3_sync_session_ctx_passwords()
all-or-nothing.

Commit session passwords before channel updates so newly added channels
authenticate with the staged credentials.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
v6: (feedback from Henrique Carvalho)
 - Drop the update_password / update_password2 booleans in
   smb3_sync_session_ctx_passwords(); commit when the local pointer
   itself is non-NULL.
 - Rename the failure label restore_new_ctx -> cleanup_new_ctx, since
   new_ctx is cleaned up (not restored) on the staged-failure path.
 - Shorten the commit message further per review.

v5: (feedback from Henrique Carvalho)
 - Drop mchan_rc / scale_busy; the early failure paths now restore
   cifs_sb->ctx from a snapshot taken on entry.
 - Build new_ctx separately and replace cifs_sb->ctx only on success.
 - Make smb3_sync_session_ctx_passwords() all-or-nothing: allocate
   both copies first, commit only when both succeed.
 - Switch smb3_sync_ses_chan_max() max_channels parameter to size_t
   to match struct cifs_ses::chan_max.
 - Shorten the commit message and follow nearby CIFS log style.

 fs/smb/client/fs_context.c | 161 +++++++++++++++++++++++++------------
 1 file changed, 108 insertions(+), 53 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..cf6e18876c59 100644
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
@@ -1041,25 +1041,34 @@ do {									\
 
 int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 {
+	char *password = NULL, *password2 = NULL;
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
 	}
+
+	if (password) {
+		kfree_sensitive(cifs_sb->ctx->password);
+		cifs_sb->ctx->password = password;
+	}
+	if (password2) {
+		kfree_sensitive(cifs_sb->ctx->password2);
+		cifs_sb->ctx->password2 = password2;
+	}
+
 	return 0;
 }
 
@@ -1072,7 +1081,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
  * with the session's channel lock. This should be called whenever the maximum
  * allowed channels for a session changes (e.g., after a remount or reconfigure).
  */
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 {
 	spin_lock(&ses->chan_lock);
 	ses->chan_max = max_channels;
@@ -1082,12 +1091,15 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channe
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
@@ -1097,6 +1109,16 @@ static int smb3_reconfigure(struct fs_context *fc)
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
@@ -1106,16 +1128,22 @@ static int smb3_reconfigure(struct fs_context *fc)
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
@@ -1125,11 +1153,29 @@ static int smb3_reconfigure(struct fs_context *fc)
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
@@ -1140,54 +1186,55 @@ static int smb3_reconfigure(struct fs_context *fc)
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
+		goto cleanup_new_ctx;
+	}
+
+	/*
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
+			goto cleanup_new_ctx;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
 	}
 
 	/*
-	 * now that allocations for passwords are done, commit them
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
@@ -1197,22 +1244,30 @@ static int smb3_reconfigure(struct fs_context *fc)
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
+cleanup_new_ctx:
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

