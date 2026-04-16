Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBD424A05D
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 02:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776306501; cv=none; b=sVr7aNzHfg1UhEF9zqpE/KPZZSqpuhALE3MOgG0uVSP0BNTKgz3pXWuZPGrmeKWcZTBBnikXNT7mVULyVIJ4nj0a1TGdTcpM5yFc8G9NfOnikyets0+3eI4hXT8wpWlXcI12g9/WCdOsbOjNTilSeNivS2om5quSEhFJJWupxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776306501; c=relaxed/simple;
	bh=KKIpoYq2uErfaHaKJ+Vur6Kcodxd4Fi9QHqXgTG5Zvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h4Lmx/y/Nm6UNxePXImnoVBK6TPxCqOQHduMQmSw1CK7iBa/IEuw7ZqLeOjd24LvPFiXyQxfaFGjYUOtFgGZTg8PxekIqrDb8aHmPvTkv08gwNPQMz0b6LG0EtlIsHWMtbY5/3s6TdRS0/To2Jd6APG0GlMPSw+fqQr5q42tubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qTRvua96; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qTRvua96"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ab08e6c553so7845085ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 19:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776306499; x=1776911299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mJGzIbGnleMhmFoh5QkhawpHd8PMOA09v6aeOmjNus8=;
        b=qTRvua96RpnB2CUnJUlFltedgHQ0yaX4rcD72uyFFrNJXEvYhjAbBz2LonBqr6CWds
         47r3j/lwH4nkTSOyOrItogftCKsT392eqHsWXCrGqZfX4JCS464TvzGO/MPaw4+558fw
         7dWiH4BLP+evx6UzJWttIl/t8p0lTUJCWz0pbv+coIOn5cag+UHvs0jDv8VelE/STURb
         ZHgqD2WzhTbZc7eHO9P9/2DXvXLFTtLQmpXFc8lOdozujkjMW/nAW/ejWPZYBCnF0ViL
         d+KwxPjIkiIG/RcolSStBCku3ZtW1kgcFdFco3Z/uZpM/AgxLuUv497BLpxEhit2+lGs
         SUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776306499; x=1776911299;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJGzIbGnleMhmFoh5QkhawpHd8PMOA09v6aeOmjNus8=;
        b=HZW1yEFRXFL+zVYO2IClRgfGmbrrrBgZPCEjuraPR91NASvgaSKlIepDOUKJKeoM5L
         4dc0otCH3XrSIfKwG0ooA+U81zd8Ad6JVhsnfJiQu/0aEuRDeB/9Q4YHZhucv9nw/fwE
         4hijBaxGX+KE1eRfqUfHgDTRg8rrFGVTdjzEJs6+Nx1I3HL+G9SN5GJrLNccL17mlVmZ
         +QMt8R6URSHGHqABFhPFM9DXQYNNCXcZRKyZRPbRVOhiRbHuQthC+wfa/yh8aNpeTx3T
         pb75FNjZ8ShOQq1Nu5YynHxxLKqKHaEf3qbmzs5pcKEBRKJr1XbaHpSTsRpPP26dt8Rx
         JOqQ==
X-Forwarded-Encrypted: i=1; AFNElJ+V7tgStcESvfcLmoJm9bo5TvqVPuyAbU+ZJChVa4OxkaWTGyYDkfL6iTqpi5FjtKxkSlXT1ulr2bv7@vger.kernel.org
X-Gm-Message-State: AOJu0YzPrnSAlxyoJuk6LoIzIqtWZ+OwAYDt6BfcaAePkG6HrEtg4Wjj
	rUpYl50WaVKKlpSP8Xd9NBNw3M124Ba4TYaZrEPbHOav51hkgcpMlW4O
X-Gm-Gg: AeBDieuTg1j2AqRYoAR8DB2HtBKMVcvi/fPpbZYcchV4tdmW1EJUtA3VNQlzNg20dbU
	lKZkY5qOt0UFBdFE1ZmxMIxVjkLsgjig2XMiY7rqKjGKW443kGXbsi5WFNeCR1hxkYpW5LJ9vDL
	UpYmbdQJQet7CpPliTMoDGAdSW0q64okgYBYSehRCLF0lAjyeCmI9Ns1xqEhW7KkEllRS/2aWaK
	5H3lNB1tPRsgbHm20Mgi/6Q3vgQDZhzPToOhLiAsunzK0V9HQATOKXC3rkrHXLgjVKPN9+yVLTP
	+lNYzpC85ygTp1VAiAIgiHPTu4zNW/ZlzwPvF6nXeAwFyZHDgDxEmkV3Qo1VM1Gwyt8F24VehgD
	BYuIqB4g1J8K7I5eK5Zy0qYwBFNdF/Ru2F8dyd9Qcpc5paviYji2rgdIQww16RsF+2cDo/ta0Kr
	hXyfDbcxxxgGJq4rIG
X-Received: by 2002:a17:903:2292:b0:2b2:4f56:d571 with SMTP id d9443c01a7336-2b5eda2f0c6mr4588475ad.4.1776306499043;
        Wed, 15 Apr 2026 19:28:19 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4782cb32csm38417295ad.79.2026.04.15.19.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 19:28:18 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	rajasimandal@microsoft.com,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH] smb/client: fix chan_max race and rollback in smb3_reconfigure
Date: Thu, 16 Apr 2026 11:28:11 +0900
Message-ID: <20260416022811.2692096-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

smb3_reconfigure() has two bugs when handling multichannel remount:

1) smb3_sync_ses_chan_max() is called before acquiring
   CIFS_SES_FLAG_SCALE_CHANNELS. If a concurrent operation (e.g.
   smb2_reconnect) holds the flag, the current thread takes the
   loser path and returns -EINVAL, but ses->chan_max has already
   been updated to the new value. This leaves chan_max inconsistent
   with the actual channel state.

2) When smb3_update_ses_channels() fails, chan_max is not rolled
   back to its previous value and the error is not propagated to
   the caller. The mount command returns success even though the
   channel configuration was not applied, and repeated failures
   cause chan_max to drift further from reality.

Fix both by moving smb3_sync_ses_chan_max() after the
CIFS_SES_FLAG_SCALE_CHANNELS acquisition so the loser path cannot
corrupt chan_max, and by restoring chan_max from old_chan_max on
update failure while still holding the scaling flag to prevent a
concurrent reconfigure from observing the intermediate state.
Propagate the error to the caller so userspace is informed.

Note: smb3_reconfigure() is not fully transactional — credentials
are committed before the multichannel block, so any early return
(including the existing CIFS_SES_FLAG_SCALE_CHANNELS loser path)
can leave ses->password updated while cifs_sb->ctx is not yet
synced. Making the entire function atomic is a larger refactor
and is left for a separate patch.

Tested with a QEMU VM (ksmbd + cifs) using module-parameter-based
fault injection:
 - Forced smb3_update_ses_channels() failure via module param and
   verified chan_max is preserved at the old value after remount
   failure (fault-injection test for rollback).
 - Pre-set CIFS_SES_FLAG_SCALE_CHANNELS before entering the
   scaling path and verified the loser path returns -EINVAL
   without corrupting chan_max (loser-path invariant test).
 - Repeated 19 forced-failure remounts with varying max_channels
   (range 2-8) and confirmed no chan_max drift (stress test).
All three scenarios pass with the patch and fail without it.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/client/fs_context.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index b9544eb0381b..99e62c2dbf50 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1085,6 +1085,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
+	unsigned int old_chan_max;
 	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
@@ -1170,9 +1171,6 @@ static int smb3_reconfigure(struct fs_context *fc)
 	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
 	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
 
-		/* Synchronize ses->chan_max with the new mount context */
-		smb3_sync_ses_chan_max(ses, ctx->max_channels);
-		/* Now update the session's channels to match the new configuration */
 		/* Prevent concurrent scaling operations */
 		spin_lock(&ses->ses_lock);
 		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
@@ -1183,16 +1181,31 @@ static int smb3_reconfigure(struct fs_context *fc)
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
+		if (rc < 0)
+			smb3_sync_ses_chan_max(ses, old_chan_max);
+
 		/* Clear scaling flag after operation */
 		spin_lock(&ses->ses_lock);
 		ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
 		spin_unlock(&ses->ses_lock);
+
+		if (rc < 0)
+			return rc;
 	} else {
 		mutex_unlock(&ses->session_mutex);
 	}
-- 
2.43.0

