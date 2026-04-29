Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4A3F7878
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 12:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777464622; cv=none; b=S1osnB43jpibYO2ZfAyO5j3oJze+pVerAMudeEzOU4+07SrBFaY6HPQEEhaVgde3WUIAiVbp6DhLpVYnjaQe0srMOMnaVLt/BaD5i3McpPuWkdCsiBOSAHWmaIUQQBeJNnEpjSCXevAdkBiuK0x4sAQkIWFMRLaCICVKBt9e7t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777464622; c=relaxed/simple;
	bh=cCTTWEhsf0bQ84BK4BXa9bK1yg6tDcfHODTee0k3Vgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOEF5pupz0FzAzJvCZYr+W5ADXiG27fXL6Tf3pJftQjwEovp4P0rI8XsuGFu7JNjzqcilMrN/eSdzegHewJgUjyA08VagjB0j7tbNPRoC4OlltdZO3wt3BGytKebScpeuP6vaEEgdt3H2RJ7C0GkRybAifwhxTCs/Lgc+BNWej8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sPkLAcM8; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sPkLAcM8"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a8720818aeso11911665ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 05:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777464619; x=1778069419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfWt2gVjlusGfjLLhXnNRBjdizd4kWhg9rEa/1+nqIQ=;
        b=sPkLAcM8Yu3B2vVC00Ab3Q6u8r2An0Rp/4NoWje+SdmIfXIap06sBS2Lt6ff3pwCvx
         CZlvSPvMi+IRI15t0IdBpe+Y790yZ1+Sfr5C7WP8/SYnZfrfgee9Q2fj0+E9YroTepV6
         ACR3/RyVWXIPImp5T+CoVwtncJ2tRNoIBQu1caKkmWmw73kjwbp1Bzk5mGpest5udKKF
         FUZ3b2Z98O+/G8O5XhTKqFq/eGyusoMWLBKGVhkMSS5Nec6+bUbBm26ogzMss1e6ZYRW
         XL8DYjLk9uGODyZfdyipx4nBdCfuAG6/poeVIm7Pn8TCsOl+jv6E4ammKViYm0jDpA8l
         Ip5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777464619; x=1778069419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AfWt2gVjlusGfjLLhXnNRBjdizd4kWhg9rEa/1+nqIQ=;
        b=Vz9X8YuOslCObhIlICWJAU4Adk2BPuEpWrE9d+5WqkE5RDg2YWoecgccs10qiyHn7y
         mGnLE0gJpZqXhZ1qrZbwIQHz9vl0raZRqpkv55vbvjtaTfZKYMo7s8UxyTdSnUrbXiq5
         STg2rOIQ32N6bLy9PCH8VkVEFgSb83JF9g/4BS22MA/Ko/AUVONEV8ZU7y1j8Nq/KfSe
         DJnjk9f84Fu89N38FuTfPb4sHVDrVSCsKiTlxBKX6AUmYh9TOIiTHvODYDpb7I8bm/2/
         weV7ZXazHHTqNLwDM1VKko41/HtpjcbRRVm9lD4SMpbOnAT2pryMd6Qw6h4hyxjlh/xS
         /8yA==
X-Forwarded-Encrypted: i=1; AFNElJ+MYUk1bzzMv8p9osC7qycIqaZXUbHsZbK7HsqNrSEg69BiRnCbN7dmnavqhWj4HhdLUjKI2lv7F6y9@vger.kernel.org
X-Gm-Message-State: AOJu0YzZXyv4WD5XGA+UJwBEMdl6l99nt/sSoTS93mMFKcojV2G9XQVn
	5KPNzoH2HYf5vhXSpPLwBLCUfdL9AVU/krA4yt+K23awAg1tHTow7tUm
X-Gm-Gg: AeBDieu88s7C9BOQWVG8eATeCCSHfcI1/wVlWHd4FENstMGQhXVgLv6XjvuXQbjo6Mt
	Ktu3q+d4pmKUtB/hoiMwhryP/VbhcvHl6rPcvhq45DaJIJMghFtioK+zuGBnGrCDkoON1AnBQvb
	N71bptqzn0tEVlCavq2bG83CLsNxUEpGSa8Rwnb211Ug8dusPTVhP5O+LVqgq1veyrQjkSsOqzi
	O8c+9+yR4Fm24pac0SxHq40C9mNH4kJpiC10MVE/Wsc/LP/wJ5sHW2ngPVLggAdQsbte5wzCpJC
	4ReqZM23/Abn+S92Y/2kBGbrDJtoWnL1+FJlpWgacW+Hv8a14ngt/bIxY8MKvnzmBaCOwv9jGc+
	pP7Kll5K2PZOOzAt9JO5zdAJmKNWomDRcPlCfajTTXRWrZIeoXtrK8rqKceraYmITrnvkR/yrLn
	Rt6L9ud87zZ7f7qLQLuP6tN4Ca5ek=
X-Received: by 2002:a17:903:3e0a:b0:2ae:7edc:9234 with SMTP id d9443c01a7336-2b97a7985c3mr26633445ad.1.1777464618855;
        Wed, 29 Apr 2026 05:10:18 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988772c33sm21595265ad.8.2026.04.29.05.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 05:10:18 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>,
	Rajasi Mandal <rajasimandalos@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v4] smb: client: fix state-consistency bugs in smb3_reconfigure() multichannel path
Date: Wed, 29 Apr 2026 21:10:13 +0900
Message-ID: <20260429121013.1696901-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416151839.3315696-1-charsyam@gmail.com>
References: <20260416151839.3315696-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_reconfigure() has several state-consistency bugs when handling
a multichannel remount that leave ses->chan_max or cifs_sb->ctx
inconsistent with the actual state. This patch repairs internal
state only; the userspace-visible return value of
smb3_reconfigure() is preserved to match the pre-patch behaviour:
the concurrent-scale loser path still returns -EINVAL, and a
failed smb3_update_ses_channels() is not newly propagated to
userspace by this patch.

Bugs addressed:

1) Before this patch, smb3_sync_ses_chan_max() is called before
   acquiring CIFS_SES_FLAG_SCALE_CHANNELS. If a concurrent
   operation (e.g. smb2_reconnect) holds the flag, the current
   thread takes the loser path and returns -EINVAL, but
   ses->chan_max has already been updated to the new value.
   chan_max is then out of sync with the actual channel state.

2) When smb3_update_ses_channels() fails, ses->chan_max is not
   rolled back. Repeated failures cause chan_max to drift further
   from reality, and subsequent reconnect/reconfigure paths use
   the drifted target.

3) Earlier in smb3_reconfigure(), STEAL_STRING moves UNC, source
   and username from cifs_sb->ctx into ctx, setting
   cifs_sb->ctx->UNC to NULL until smb3_fs_context_dup() copies
   them back near the end of the function. The pre-existing
   CIFS_SES_FLAG_SCALE_CHANNELS loser-path 'return -EINVAL' exits
   inside this window. A loser-path failure therefore permanently
   nulls cifs_sb->ctx->UNC; /proc/mounts shows the device as
   "none" and every subsequent mount.cifs-based remount is
   rejected by smb3_verify_reconfigure_ctx() because mount.cifs
   passes that "none" back as the new UNC.

4) Once (2) rolls ses->chan_max back to the old value on update
   failure, smb3_fs_context_dup() would still copy the rejected
   new ctx->max_channels into cifs_sb->ctx, creating a fresh
   cifs_sb->ctx vs ses->chan_max mismatch. This must be handled
   together with (2) to keep the rollback complete.

Fix all four by:

 - Moving smb3_sync_ses_chan_max() after the SCALE_CHANNELS
   acquire so the loser path cannot corrupt chan_max.

 - Capturing old_chan_max atomically with the sync via the new
   smb3_sync_ses_chan_max() return value (under chan_lock), and
   restoring it on failure while still holding SCALE_CHANNELS so
   a concurrent reconfigure cannot race with the rollback.

 - Recording any multichannel-path failure in a local mchan_rc
   and routing the loser path through a common 'out:' label so
   every exit reaches smb3_fs_context_dup() and cifs_sb->ctx is
   restored. mchan_rc is used only as internal control flow.

 - Before the dup, restoring ctx->multichannel,
   ctx->multichannel_specified, ctx->max_channels and
   ctx->max_channels_specified from cifs_sb->ctx on mchan_rc so
   the dup does not desync cifs_sb->ctx from the already-rolled-
   back ses->chan_max (the *_specified bits must travel with the
   values to avoid a "user-specified" flag mismatching the
   restored value).

 - Tracking the concurrent-scale loser path with a separate
   scale_busy flag. After cifs_sb->ctx is fully restored, the
   return value is forced to -EINVAL for that path so userspace
   continues to see the pre-patch rejection. dup /
   dfs_cache_remount_fs() failures still take precedence because
   they reflect real state recovery errors.

Deliberately not changed by this patch: the return value of
smb3_reconfigure() on smb3_update_ses_channels() failure. That
path is not newly propagated to userspace here, matching the
asynchronous model used by the mount path (mchan_mount_work_fn).
Those return-semantics and deferred-handling questions are left
to follow-up discussion/patches.

smb3_reconfigure() is not fully transactional: ses->password and
ses->password2 are committed before the multichannel block, so
unrelated earlier state changes may still be visible after a
failed multichannel remount. That is a structural property of
the function and out of scope here.

Tested with a QEMU VM (ksmbd + cifs) using module-parameter
based fault injection:
 - Forced smb3_update_ses_channels() failure via module param
   and verified ses->chan_max is preserved at the old value
   after the remount path runs.
 - Pre-set CIFS_SES_FLAG_SCALE_CHANNELS before entering the
   scaling path and verified the loser path still returns
   -EINVAL, no longer corrupts ses->chan_max, and no longer nulls
   cifs_sb->ctx->UNC.
 - Repeated dozens of forced-failure remounts with varying
   max_channels (range 2-8) and confirmed no chan_max drift.
 - After each failure path, verified /proc/mounts continues to
   show the original UNC (//127.0.0.1/share) so subsequent
   remounts are accepted.

Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
v4: (feedback from Rajasi Mandal)
 - Fix unlocked read of ses->chan_max when capturing the rollback
   value. smb3_sync_ses_chan_max() now returns the previous
   chan_max so the read+write happens atomically under chan_lock,
   removing the data race against cifs_try_adding_channels() /
   cifs_chan_skip_or_disable() which also access chan_max under
   chan_lock.
 - Switch smb3_sync_ses_chan_max()'s parameter/return type to
   size_t to match struct cifs_ses::chan_max.
 - On the multichannel rollback path, also restore
   ctx->multichannel_specified and ctx->max_channels_specified
   from cifs_sb->ctx so the user-specified flags do not desync
   from the restored values when smb3_fs_context_dup() copies
   ctx back.

v3: (feedback from Henrique Carvalho)
 - Drop propagation of smb3_update_ses_channels() failure to
   userspace; preserve the pre-patch best-effort semantics on that
   path.
 - Keep the pre-existing CIFS_SES_FLAG_SCALE_CHANNELS loser-path
   -EINVAL via a separate scale_busy flag so that return is not
   silently converted into success.
 - Reword commit message to describe accurately what userspace-
   visible semantics are preserved and what changed internally.

v2: (feedback from Rajasi Mandal)
 - Route loser-path and update-failure exits through a common
   'out:' label so smb3_fs_context_dup() always runs and
   cifs_sb->ctx->UNC is restored after STEAL_STRING.
 - Restore ctx->multichannel/ctx->max_channels from cifs_sb->ctx
   before the dup so dup does not re-desync cifs_sb->ctx from the
   rolled-back ses->chan_max.

 fs/smb/client/fs_context.c | 61 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..252420bd7d5d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -767,7 +767,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 					    void *data);
 static int smb3_get_tree(struct fs_context *fc);
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
+static size_t smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels);
 static int smb3_reconfigure(struct fs_context *fc);

 static const struct fs_context_operations smb3_fs_context_ops = {
@@ -1069,14 +1069,20 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
  * @max_channels: new maximum number of channels to allow
  *
  * Updates the session's chan_max field to the new value, protecting the update
- * with the session's channel lock. This should be called whenever the maximum
- * allowed channels for a session changes (e.g., after a remount or reconfigure).
+ * with the session's channel lock, and returns the previous chan_max value.
+ * This should be called whenever the maximum allowed channels for a session
+ * changes (e.g., after a remount or reconfigure).
  */
-static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+static size_t smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 {
+	size_t old_chan_max;
+
 	spin_lock(&ses->chan_lock);
+	old_chan_max = ses->chan_max;
 	ses->chan_max = max_channels;
 	spin_unlock(&ses->chan_lock);
+
+	return old_chan_max;
 }

 static int smb3_reconfigure(struct fs_context *fc)
@@ -1085,10 +1091,12 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	size_t old_chan_max;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
-	int rc;
+	bool scale_busy = false;
+	int rc, mchan_rc = 0;

 	if (ses->expired_pwd)
 		need_recon = true;
@@ -1170,25 +1178,37 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
 	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {

-		/* Synchronize ses->chan_max with the new mount context */
-		smb3_sync_ses_chan_max(ses, ctx->max_channels);
-		/* Now update the session's channels to match the new configuration */
 		/* Prevent concurrent scaling operations */
 		spin_lock(&ses->ses_lock);
 		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
 			spin_unlock(&ses->ses_lock);
 			mutex_unlock(&ses->session_mutex);
-			return -EINVAL;
+			scale_busy = true;
+			mchan_rc = -EINVAL;
+			goto out;
 		}
 		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
 		spin_unlock(&ses->ses_lock);

+		/* Synchronize ses->chan_max with the new mount context */
+		old_chan_max = smb3_sync_ses_chan_max(ses, ctx->max_channels);
+
 		mutex_unlock(&ses->session_mutex);

 		rc = smb3_update_ses_channels(ses, ses->server,
 					       false /* from_reconnect */,
 					       false /* disable_mchan */);

+		/*
+		 * On failure, restore chan_max while still holding
+		 * CIFS_SES_FLAG_SCALE_CHANNELS so a concurrent reconfigure
+		 * cannot observe or race with the rollback.
+		 */
+		if (rc < 0) {
+			smb3_sync_ses_chan_max(ses, old_chan_max);
+			mchan_rc = rc;
+		}
+
 		/* Clear scaling flag after operation */
 		spin_lock(&ses->ses_lock);
 		ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
@@ -1197,6 +1217,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 		mutex_unlock(&ses->session_mutex);
 	}

+out:
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -1205,6 +1226,18 @@ static int smb3_reconfigure(struct fs_context *fc)
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;

+	/*
+	 * If the multichannel update failed, restore the old multichannel
+	 * settings in ctx so smb3_fs_context_dup() does not desync
+	 * cifs_sb->ctx from ses->chan_max (which was already rolled back).
+	 */
+	if (mchan_rc) {
+		ctx->multichannel = cifs_sb->ctx->multichannel;
+		ctx->multichannel_specified = cifs_sb->ctx->multichannel_specified;
+		ctx->max_channels = cifs_sb->ctx->max_channels;
+		ctx->max_channels_specified = cifs_sb->ctx->max_channels_specified;
+	}
+
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
 	smb3_update_mnt_flags(cifs_sb);
@@ -1213,6 +1246,16 @@ static int smb3_reconfigure(struct fs_context *fc)
 		rc = dfs_cache_remount_fs(cifs_sb);
 #endif

+	/*
+	 * Preserve the pre-existing loser-path semantics: a concurrent
+	 * scaling operation causes the remount to be rejected with
+	 * -EINVAL. smb3_fs_context_dup() / dfs_cache_remount_fs()
+	 * failures take precedence because they reflect real state
+	 * recovery errors. Other multichannel failures remain best-effort.
+	 */
+	if (!rc && scale_busy)
+		rc = -EINVAL;
+
 	return rc;
 }

--
2.43.0

