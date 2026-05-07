Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792873B6BF0
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161520; cv=none; b=gqCxaPBHrzbWVoV18L87VTRKOhQ0jnYpk9j9nZYBoYJmBQGgUgEEPYd1XPozbMGX4N4lIl+s2jly/1/E8YokIUUNFQ2dfWyXD65OxH6Q66f/REntLdspalufffjl3wkFt5kck34zRWlBjV8CBmSB7Xs0Dq5vL4VMMN6yHTK2phE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161520; c=relaxed/simple;
	bh=deYO0Iddvizn7AaGURnPiZyhZEfzMxgJvaGXHXzE8HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZUKnHqZHF01UnvHGz0S1eYfHZoywv7aQHQksNKmMGR7k5B5IP0yY41raI56bGiq1lmIbBeZVedPCgMwkpwk1uvHpwfbLOO4p2FNauzgmTrXzWntMhAAtcHpARxGv6TBzfKfRtzHXGaPEtTmZM7RMTpbhI8peN/amLdwUZa5/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r0jZrXf8; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r0jZrXf8"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-366330b6751so162161a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161518; x=1778766318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEmLgVqxwV0oh6SbcOjqZFmdb4K0oH7xBigomKlHENE=;
        b=r0jZrXf8549BrKNfjIAYzfj56pQ5FlgKB1HGSBVdoW8cMk9TM4kQU2C5L893s4UnRn
         CX7nuff7kAu/m49OB2MhbT/4J4Ypxq6Dgj9MqKREPKmuFd2/iDOcAI1azbqCj71zfZdL
         4a70Ztor0Ac/juH5sjvgjZPxnsVnE8IzxqiGCesII3QRA1zzbliVfUzx4U3oOicZEOnq
         w+Eyg7LnoV4EUkQoChIyJNp/SW1ygVNcuTEud6jtk9qnRKsoVPuWg1aYXvDsrEJVqhhT
         p0LV9ANgua62nprjLXWcGo2+4UKNrGQOvlnKOEhbmeRCoB56Qu/ah81zzYZMAdFPtb6N
         7rTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161518; x=1778766318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mEmLgVqxwV0oh6SbcOjqZFmdb4K0oH7xBigomKlHENE=;
        b=Ta65xjQTJhwg07tt8BZ91tMTC+3DODExW4glKFulk4KwS4Q8kiw2XF2rxPX/8tbgXo
         TMISZrIHQmABD1atoH2zOEV2U5GrW6RxZ8VhErHvQbmLRaCE1i75bI13dF73IPI5TcYL
         Xds8wcAeC6UuH1hc2fqZLUgTQ7zt8vu78I5fVgbnNY4Ik49Ekj0Axwrcj/xc/YUCua4N
         a05p7+x8KuRHKY/MNAh7wM7wq1XImpKlmjrQctpw5cxKryIlVfF7EV/fxg6YHrZMxMML
         9RYZtxWj2DCE4iWp71AvJpVO7BWSzxI1HU7IJL/km2SzrzRewV1eFWl5PI2xm3yOyQEj
         elmQ==
X-Gm-Message-State: AOJu0YzRDUGpzp/LWMLrOAPXwO68kJSY1ksf/VY9MjpQHEdSzbCWHqTc
	f1mJ4IR7/Hp7pVFSenOqs/hmbIUHGYuOzLD3auh12qSw8Pd9cP8eIxqfna7N9A==
X-Gm-Gg: AeBDievTcQ09uGfJcxFqZYG+8mP7IErLTOCrLd8kCiOdq9m355SMmUVSoQkMjSl2wF4
	mw+SFVR4mn+wP0yGZpulOpEuDIpvwgOIdUqGxVLbXsq+7PUK/IhwA9E4y1ZW6eNlUZ5V2Y47+3N
	vG7AB6ge4WatunGtZrpumTeYYWQjNEsskz7N0YzmEoWwxV9Vx2BHcoGbkxSwAI5m4KFqEq4fcE4
	6ZUFCUTHFM8bljeRzAXhdMdNUxdCIUeBP/e1bQQux7iE14jVv3cYsXhx0l//O9bpmuTdwHtnssP
	dbP5H/vaSr7q4w+mpjJt60dtHA1+vIIeZUDOeSyrqX1U9PfjMA3ZFQCX0i9uTeA4c8hdziUTdXr
	/fu7XB3c9DZOZampNfd4oZt6/V0cJp+j7n5KdZ4fbjoCQL1tZVh6eYxG34HFyJrSDzANvpcAomL
	PpYYnkQSWQC2DuCTu0TIshE1YFZLkXX7tV854kHrdOUZ5WqB/1+UMnD2Ho4YQRoiQBZNpm4fpcK
	4eFMALX3SBNvud0y2D/Umabjv8mggCEddHytkWdaxrDHRS9eqaIp70=
X-Received: by 2002:a17:90b:278c:b0:35e:5929:d78d with SMTP id 98e67ed59e1d1-365ab9af874mr7982606a91.3.1778161518263;
        Thu, 07 May 2026 06:45:18 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:17 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 8/8] smb: client: apply rasize on remount
Date: Thu,  7 May 2026 13:44:48 +0000
Message-ID: <20260507134448.168602-9-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

rasize is accepted during remount parsing but sb->s_bdi->ra_pages is
only set in cifs_read_super() at mount time. A remount with a new
rasize value silently has no effect on the readahead window.

Update ra_pages in smb3_reconfigure() after the context has been
duplicated, using the same logic as cifs_read_super(): if rasize is
set, use it directly; otherwise fall back to 2 * rsize.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 009b9480b5cc..b10fd05c0af0 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1356,7 +1356,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	struct dentry *root = fc->root;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(root->d_sb);
 	struct cifs_ses *ses = cifs_sb_master_tcon(cifs_sb)->ses;
-	unsigned int rsize = ctx->rsize, wsize = ctx->wsize;
+	unsigned int rsize = ctx->rsize, wsize = ctx->wsize, rasize = ctx->rasize;
 	char *new_password = NULL, *new_password2 = NULL;
 	bool need_recon = false;
 	int rc;
@@ -1472,13 +1472,20 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
 
-	/* if rsize or wsize not passed in on remount, use previous values */
+	/* if rsize, wsize, or rasize not passed in on remount, use previous values */
 	ctx->rsize = rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
 	ctx->wsize = wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;
+	ctx->rasize = rasize ? rasize : cifs_sb->ctx->rasize;
 
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
 	smb3_update_mnt_flags(cifs_sb);
+
+	if (cifs_sb->ctx->rasize)
+		root->d_sb->s_bdi->ra_pages = cifs_sb->ctx->rasize / PAGE_SIZE;
+	else
+		root->d_sb->s_bdi->ra_pages = 2 * (cifs_sb->ctx->rsize / PAGE_SIZE);
+
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	if (!rc)
 		rc = dfs_cache_remount_fs(cifs_sb);
-- 
2.43.0

