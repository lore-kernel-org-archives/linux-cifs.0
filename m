Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69F2DEA9D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 20:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776372348; cv=none; b=ZSs9tSmOuFuVxbxxAgZU7M3Obsj7tb3Hau8vYyxug2qIuY2ggSFt0hTpH2g+5oj6PGBJLgmFanFMrM8S8BkjyH7cC+XOxXOuOHxmxkd/I0U7ebWeCmJiU0qBvQX8AdTPtnY0U2gjl4wm/1roMdgOvgVsYrESNgD3TdrSv5dcuik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776372348; c=relaxed/simple;
	bh=2/YKQepib8qgPE6x6OTTQCVAq0n90vlOEci55qr1yKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq7zlihueAjsFqiLAdhWR9cK1UO5MDAou3xjhyYJOSN8+vAb//RG9ueGj4JBiOa7Xd8J66Ru3d1hRNQy+Hftrt3nwWJjFkVwuzOKb/tnV7xJjJffeDuM9yUnG5jXx1eGvMmp3KZ+Rqk0VkCy73wt8tHd2LkkFh26g3/oucswYOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lReweN1q; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lReweN1q"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3597822d6d8so2858a91.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 13:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776372346; x=1776977146; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwPWif+GAoWQlSDJUgW/WlYq4WqK6TIhb5jcpCKTfEM=;
        b=lReweN1qiQByeBls0049oYjNwCgCuZxbviR3dugqdZx9PqiHlJKx534S8mR5VxLnD6
         Y5n/E9LGSOztFx0Es/IcR8IPk1xDcVlz/lhlrIIX6OEF0Q+34aESnSvPzgRVmRrExu7c
         niMrwUie9yQVCdvhlIUPzV5s27o4aIBE78PuvBaPCjZ9BL6FuFSN3oIFsacC7uIsROiE
         7APzCxTpfqw6SIx9deYzMmC/ywd1PqOdkJWNWDNGVoAPMFub48piupXjjQxkl0OAThDx
         NxVlzQGI6wsSCmSP1UpFdI2binxXmvuV0rQ+u1R1NpI9Q/DByWnX+swxkylsAPKLDcsa
         EVdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776372346; x=1776977146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GwPWif+GAoWQlSDJUgW/WlYq4WqK6TIhb5jcpCKTfEM=;
        b=TBP2fRD/TR6QEsR2MaeqYTlla/w0zzajkxp7bjZFKCVHj07o3dKKNnn0IkDGhPKqvp
         Dp92l2tOph+G+xLKtzdn5WeiDbAwivUw2q0BAr3pYj1Qm734g7Vci4ep7YVOdjqBzU4Q
         9j6i9aZyuINUBVzo6DLJsT5rF05QGre1TPJ/VUt7WNSi7sLbTXQRFvr8mdqgDDbZwbff
         DSkRSgpznmJhvqXs+4Pfzk5+Ow5KVapRGfcAD8n6qGeIvBjNrzUbDLpKfQqHBqVUcgec
         ggzmfCjWmItQzMBUHEleccXP1lTK/5p7CcOcQ2Uin06qYqbZxyfLGoWNqQrAonhv1Al8
         RTXg==
X-Forwarded-Encrypted: i=1; AFNElJ9fXyRzB145tcydovsJSqjOZK6eJO0WXtCDEVUzry0KYcyO44XYAA0YZ/Kc35/2kWZMgBi+S6+q1XNB@vger.kernel.org
X-Gm-Message-State: AOJu0YwnNggXvnoI/e12OjzcbybcXnrMe7/9flhKdXRp50/ONQy8jL1Z
	OJK6UZaJx6nMrDZfw3ww2Xtb4rQBdO2caIz3yF87xkbXQrS1/s0OJxvk
X-Gm-Gg: AeBDiesvJLi4pEEwEoiIg2cxivona3FZT7wM1TA34Hyl0Zwq7SLPH25iuHQBphDRlh8
	KAi0zSnB5HJ3orzhf+jkrenBA4ce2CGtmSceJfnQI5ALI+j7QJLW0suTC7aXiTEi0KNshhE84o8
	zw/IrcOBFx5pAVf6y+iWKAvz9Qi2ahd3KN9kz5OZFE68kJ30xohVqRJXSPC8jhmkqlwdpzjXbHh
	Foke2mcLjz9erHyHGbjDBiSPwkNKpC8L4SiOuIFD51Yo5/1FKB7s4LFExgcQzmU+fECkMOvR/1R
	Otoy3YQOJj7KGehzxAsFFrZgHowhRvJ1tajakP5armC9r+zxJfpdnAY61rPhmHZVasQgmadt99h
	bIDrfMjQNWzoiOdUCd3qwKVLkbRcEmG9eg0SxSVG36qIhunrmE7Bvv2sHgDXtq7g+Nlp0hvxbKv
	B9XGd6lbc3JgOwbirjdwbR5xE0ByE=
X-Received: by 2002:a17:90a:ec85:b0:35f:bd42:c127 with SMTP id 98e67ed59e1d1-36140209044mr1959a91.0.1776372346244;
        Thu, 16 Apr 2026 13:45:46 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36132dbce55sm3066326a91.13.2026.04.16.13.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:45:45 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	rajasimandalos@gmail.com,
	rajasimandal@microsoft.com,
	henrique.carvalho@suse.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v3] smb/client: fix state corruption in smb3_reconfigure multichannel path
Date: Fri, 17 Apr 2026 05:45:39 +0900
Message-ID: <20260416204539.3536168-1-charsyam@gmail.com>
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

1) smb3_sync_ses_chan_max() is called before acquiring
   CIFS_SES_FLAG_SCALE_CHANNELS. If a concurrent operation (e.g.
   smb2_reconnect) holds the flag, the current thread takes the
   loser path and returns -EINVAL, but ses->chan_max has already
   been updated to the new value. chan_max is then out of sync
   with the actual channel state.

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

 - Capturing old_chan_max before the sync and restoring it on
   failure while still holding SCALE_CHANNELS so a concurrent
   reconfigure cannot race with the rollback.

 - Recording any multichannel-path failure in a local mchan_rc
   and routing the loser path through a common 'out:' label so
   every exit reaches smb3_fs_context_dup() and cifs_sb->ctx is
   restored. mchan_rc is used only as internal control flow.

 - Before the dup, restoring ctx->multichannel and
   ctx->max_channels from cifs_sb->ctx on mchan_rc so the dup
   does not desync cifs_sb->ctx from the already-rolled-back
   ses->chan_max.

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
 - Repeated 19 forced-failure remounts with varying max_channels
   (range 2-8) and confirmed no chan_max drift.
 - After each failure path, verified /proc/mounts continues to
   show the original UNC (//127.0.0.1/share) so subsequent
   remounts are accepted.

Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug2pxm7wy7nbms@iq6cf5taa65v/
Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
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

 fs/smb/client/fs_context.c | 46 +++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..aaa364a3f60d 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1085,10 +1085,12 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	unsigned int old_chan_max;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
-	int rc;
+	bool scale_busy = false;
+	int rc, mchan_rc = 0;
 
 	if (ses->expired_pwd)
 		need_recon = true;
@@ -1170,25 +1172,38 @@ static int smb3_reconfigure(struct fs_context *fc)
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
 
+		old_chan_max = ses->chan_max;
+		/* Synchronize ses->chan_max with the new mount context */
+		smb3_sync_ses_chan_max(ses, ctx->max_channels);
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
@@ -1197,6 +1212,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 		mutex_unlock(&ses->session_mutex);
 	}
 
+out:
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -1205,6 +1221,16 @@ static int smb3_reconfigure(struct fs_context *fc)
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
 
+	/*
+	 * If the multichannel update failed, restore the old multichannel
+	 * settings in ctx so smb3_fs_context_dup() does not desync
+	 * cifs_sb->ctx from ses->chan_max (which was already rolled back).
+	 */
+	if (mchan_rc) {
+		ctx->multichannel = cifs_sb->ctx->multichannel;
+		ctx->max_channels = cifs_sb->ctx->max_channels;
+	}
+
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
 	smb3_update_mnt_flags(cifs_sb);
@@ -1213,6 +1239,16 @@ static int smb3_reconfigure(struct fs_context *fc)
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

