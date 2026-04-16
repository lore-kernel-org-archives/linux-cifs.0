Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C2C3E3C5E
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 15:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352733; cv=none; b=HcUM3tnwLfgfABzy6xu9LlKhmJRvzYvVeHcJc89oBVAreEmHQZ+YOg/D207UG8EgcudHaBgwWiq4o0P4xzRFJasjVgppCkE0vqz+qSwfYRfMZitM0y97uqfuR1gAd8/9d8ZkLOLfYka1rfRTXkYCMeg5Bk2+UBj3ohuJP6M/meo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352733; c=relaxed/simple;
	bh=UP/CiVunTonaDGV2Qb9WrDEG4j4D1k7GnPOUnbdyL+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYqb8Qdw/s8mU/0jq4QIZcG24xqlI4rMRXu3NTMN1nIRRHIQ6Gvl1GKhkzn9BMmjHpoPXM6u0GJnj5q2TcVmZLBO9EM68nIb3LB5NRwnL1Ye8B76NAli6nA5E0xjtH4aUWvtBNkuIDbHTDt9ku0u6SgisS99WnVVPWkKY+MNkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EM3OZla3; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EM3OZla3"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a8720818aeso9085095ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 08:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776352727; x=1776957527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hWJmbnMs6FnG4pSZO72MK1KEQtYpxvt77pS90kFtv28=;
        b=EM3OZla3nSv8k1WA8UIi9fx2vpAZ7EQMtquTGB/on1WDdXLNPdJ+vBOn+eQvxQU7nG
         QZKYVk93yhxsz98UtHnv9bUnfa/i5Hlgb2kmi4WSY37HGk68w0PeBcs/WJFce8sLnRir
         Q81PERMD9yhzMGYiGJnXU/4tIOMBoPIxswcenz5BjljE+04STYWVeLSbjjg6wJvfCEt5
         KpIKPXCI9vHnnq/L+uD7JHEi+adKK7caiw5++ZObs0k89u9SZY8Qfl17MvM+8Qm8AVo7
         xiM1Ix6z/yYCckhLfkehX97t8k467CB658Gi60JDzJ15kGb6AP4eZIdAiWdkJgmPKQjR
         P9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776352727; x=1776957527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hWJmbnMs6FnG4pSZO72MK1KEQtYpxvt77pS90kFtv28=;
        b=kKrzyS2LQ8MvXaOrOYTn+icN2TS/PqHyAWCM+05PXBaveqEwiP7WUqEXq9N6cWLmv5
         X764GjGHHmwsxq5dAUzh/UW+Jh6aZGN5+8UIE2N/9/EVpi26fsleROuQYHjZjbI2d6dc
         P2FPSHEZmlnpHX09xzJvEP6wgKfnvcFDPVdRWWyNXhfXLVwKy09CblVeAv11upn97Rju
         A9JA7UZVF1ptKsrfRk9G949rBMeb05Q3GZ+0C062fOoi++aLg25P/nMqTOmIBhkrbCG3
         +O3CSCoNlfsjw5rwlhHOhGRn7fA6bAR8PGtHCYNuI7TIBA7RgxEfcU3+eAvdIoVvI6yv
         Rkcw==
X-Forwarded-Encrypted: i=1; AFNElJ/s8X3kJ2ruKmelq6qtGzJOj/nwHPumBjgRXwlRLDTW/SveVlyCeRDcMJ9nkAOxTBguBfy5rH52YeUn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1GOnc0MCluq5dpZJ65ynsdSt4IljWWeZWb+GpMjiLlTuJjdsQ
	WVm2rL8Hk4ke8J/WXg2RJVgT0jzHY47BLLQqHwfP8eVBxspXgQt0gGqn
X-Gm-Gg: AeBDieskjS46lbEUwaK0GOh0wCxpBq1RNB+aLDhMx/nw/cwrGMlAA0+fqV6hQ92hHlF
	19k+LdjjZqy+0qh4IQNWCVbqru6VaG/CDx7ag56csdsIPxBYszC/uSsJPNx9Ve1/np0Kd46PC1a
	LtjpTwkG3X/y0VxlDD0ypO8IrjhDJB5J7il6t5Rqb9gxzatNOiIbNS2myq9+MxfNTaDQL2rc7DE
	0xerPe0ze0MT7iiCN9zEzFDJwplAb/Wgys1RlXShwP/5wUc92rBIfHxqAfIBwZsCbEZSZT6DRH7
	x5J3MYFtUQjMS6gg9bdCsQW9GDKxxZggah0/om+KZMqlx8bdHuf2qC04VSoWBFQoTKf8OkFqPcO
	CQfVrHamrgoXsyLisgU0QVMzFaF7OMat581TJ9pB6rSf2hBz+115a+2Vf1sOZgYVz1P+dAIY0v2
	mJRNdp0nXdSWn++Fj7
X-Received: by 2002:a05:6a00:3d4f:b0:824:9f50:83c7 with SMTP id d2e1a72fcca58-82f7bde2cb1mr1700921b3a.0.1776352726884;
        Thu, 16 Apr 2026 08:18:46 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f738b399bsm3621805b3a.8.2026.04.16.08.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 08:18:46 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	rajasimandalos@gmail.com,
	rajasimandal@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2] smb/client: fix chan_max and UNC state corruption in smb3_reconfigure
Date: Fri, 17 Apr 2026 00:18:39 +0900
Message-ID: <20260416151839.3315696-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416022811.2692096-1-charsyam@gmail.com>
References: <20260416022811.2692096-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_reconfigure() has four related bugs when handling a
multichannel remount that leave ses->chan_max or cifs_sb->ctx
inconsistent with the actual state.

1) smb3_sync_ses_chan_max() is called before acquiring
   CIFS_SES_FLAG_SCALE_CHANNELS. If a concurrent operation (e.g.
   smb2_reconnect) holds the flag, the current thread takes the
   loser path and returns -EINVAL, but ses->chan_max has already
   been updated to the new value. chan_max is then inconsistent
   with the actual channel state.

2) When smb3_update_ses_channels() fails, ses->chan_max is not
   rolled back and the error is not propagated to the caller.
   mount returns success even though the channel configuration
   was not applied, and repeated failures cause chan_max to
   drift further from reality.

3) Earlier in smb3_reconfigure(), STEAL_STRING moves UNC, source
   and username from cifs_sb->ctx into ctx, setting
   cifs_sb->ctx->UNC to NULL until smb3_fs_context_dup() copies
   them back near the end of the function. Both the existing
   CIFS_SES_FLAG_SCALE_CHANNELS loser-path 'return -EINVAL' and a
   naive 'if (rc < 0) return rc;' to propagate the failure above
   exit in this window. A single failed multichannel remount
   therefore permanently nulls cifs_sb->ctx->UNC; /proc/mounts
   shows the device as "none" and every subsequent
   mount.cifs-based remount is rejected by
   smb3_verify_reconfigure_ctx() because mount.cifs passes that
   "none" back as the new UNC.

4) If the multichannel update fails but smb3_fs_context_dup() is
   still allowed to run with the new ctx values, the rejected
   new max_channels is written into cifs_sb->ctx, undoing the
   ses->chan_max rollback from (2) and creating a fresh
   cifs_sb->ctx vs ses->chan_max mismatch.

Fix all four by:
 - Moving smb3_sync_ses_chan_max() after the SCALE_CHANNELS
   acquire so the loser path cannot corrupt chan_max.
 - Capturing old_chan_max before the sync and restoring it on
   failure while still holding SCALE_CHANNELS so a concurrent
   reconfigure cannot race with the rollback.
 - Recording any multichannel-path failure in a local mchan_rc
   and routing it through a common 'out:' label so every exit
   reaches smb3_fs_context_dup() and cifs_sb->ctx is restored.
 - Before the dup, restoring ctx->multichannel and
   ctx->max_channels from cifs_sb->ctx on mchan_rc so the dup
   does not desync cifs_sb->ctx from the already-rolled-back
   ses->chan_max.
 - Returning mchan_rc to userspace so a failed scaling remount
   surfaces as an error.
 - Surfacing smb3_fs_context_dup() failure in preference to
   mchan_rc when both occur. The dup is the final step of the
   ctx restore and runs after smb3_cleanup_fs_context_contents()
   has already freed cifs_sb->ctx's strings, so a dup failure
   (e.g. -ENOMEM) leaves cifs_sb->ctx partially restored with
   some strings still NULL. Reporting the scaling error in that
   case would hide the real recovery status from userspace;
   reporting the dup error exposes it so the caller can react
   accordingly.

Note: smb3_reconfigure() is not fully transactional. Credentials
(ses->password and ses->password2) are committed before the
multichannel block, so a failed multichannel remount can still
leave ses->password updated while reporting an error to
userspace. Making the entire function atomic is a larger
refactor and is left for a separate patch.

Tested with a QEMU VM (ksmbd + cifs) using module-parameter-based
fault injection:
 - Forced smb3_update_ses_channels() failure via module param
   and verified ses->chan_max is preserved at the old value
   after remount failure.
 - Pre-set CIFS_SES_FLAG_SCALE_CHANNELS before entering the
   scaling path and verified the loser path returns -EINVAL
   without corrupting ses->chan_max.
 - Repeated 19 forced-failure remounts with varying max_channels
   (range 2-8) and confirmed no chan_max drift.
 - After each failure path, verified /proc/mounts continues to
   show the original UNC (//127.0.0.1/share) so subsequent
   remounts are accepted.
All scenarios pass with the patch and fail without it.

Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ1AJ7_GAuRE+aevA@mail.gmail.com/
Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/client/fs_context.c | 48 ++++++++++++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..9efd73ce6910 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1085,10 +1085,11 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	unsigned int old_chan_max;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
-	int rc;
+	int rc, mchan_rc = 0;
 
 	if (ses->expired_pwd)
 		need_recon = true;
@@ -1170,25 +1171,37 @@ static int smb3_reconfigure(struct fs_context *fc)
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
@@ -1197,6 +1210,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 		mutex_unlock(&ses->session_mutex);
 	}
 
+out:
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -1205,12 +1219,32 @@ static int smb3_reconfigure(struct fs_context *fc)
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
+
+	/*
+	 * If smb3_fs_context_dup() failed, cifs_sb->ctx is left in a
+	 * partially-restored state after the cleanup above. Surface that
+	 * failure to the caller before any mchan_rc, since it reflects the
+	 * real recovery status of cifs_sb->ctx rather than the scaling error.
+	 */
+	if (rc)
+		return rc;
+	if (mchan_rc)
+		return mchan_rc;
 #ifdef CONFIG_CIFS_DFS_UPCALL
-	if (!rc)
-		rc = dfs_cache_remount_fs(cifs_sb);
+	rc = dfs_cache_remount_fs(cifs_sb);
 #endif
 
 	return rc;
-- 
2.43.0

