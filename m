Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F4ED502
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 01:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712022277; cv=pass; b=J9bQAWWiUUp8IRt4b+R83weDtfvhXAW1rA/40PS4yvH319j7/jPmE3bQ0rj2kaGX32REi1w6Jo+6Aw3hxmKyNzP2FUbVl7FGQ50MsAmEDTvdz0495tb1V8lQ1mRURs85Xq2S8aZZEgBBgRwpK52/BhuYtnhohqQD8SJOAkjMjKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712022277; c=relaxed/simple;
	bh=0rCdt7DZVzWFxfUd953SzddvRC4ep9FEVTrBLfiRk6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtkeT/RQCyyFf2lhZWR+g/VQ45Ni0JKRVpaYVMgRlRHeZiHkVzQ8fjc47lUUTXB5jSaAl1cPKd9aNr0A7OB9+bQjo1sRpXYGcPr1uGFqphaiW9yPAIJ0jvjzW8gUAkeSaHWqiwPSs/6vOBGn4gielpzTiF8p0f57WqTs+ezHvvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=JaymDLu4; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JaymDLu4"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qncciZH1DcEr2YlcT/3aCOEe25s2kKeU3mIyDT0kQ54=;
	b=JaymDLu4YkBr38h9yagocBx5EhZvM/6OIblunclnbM5915f2ffmDgGd4cmOLeXLJ7X+jSL
	Ig1CLL/v2lG/S3/UCnrLCjn++YXa4Iy6vCad08+CaFxupnORTJMVs4fvdFaSaPPDF9zv0Z
	sXm5THPDCBhk3gTMLLmfcvRm9uR+wSYHI1ejDtx2HhaFqX7+huUc7+jGrClHinFC56I7MY
	LOA8JsBXn+RTfn6LLywe8BfOrLgJ1QFi3k1Hq1QHraOnb/DWNdruLHxe+A2zPbIcikGZBH
	A7Ve28qfwNe+TPWi2wPTXIRoPx8TCUeNuA9evx30RROpma7ri1pRZz7keJeMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712022274; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qncciZH1DcEr2YlcT/3aCOEe25s2kKeU3mIyDT0kQ54=;
	b=nXNoKa8nETByoF1525KU2cSmOAN3DPfmXWuNsDVaWqghzYAlE3RDc0EPIfVJVurvOItrF0
	fVBPsfQcAB0xKxBS7U2VRIELRU00gROb0JBdgENYixvOlxzjiZj5d7QnFo8jquTwhl/lXB
	BRM3cTF8whVHBFWlfMs3aEEn5cFMI/5Vkqm5x3nxzsbf4zHo2hAJ3Rh4wshh4tG7yZ8MsI
	5lgPT+hhkUAqsrBQexyWkWilrix+awIvjba9GCMq5VObnmH2Q20WG7bwLGkq7fgJW8/tpv
	RHm1FTK0MHr7VAwGoppPbftPHWfhCdWdXvmW5UQxPuwF/8kJZUmNpKW/ircbQg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712022274; a=rsa-sha256;
	cv=none;
	b=ZOf+OjKPdfMyOBYAqMwgsznX6r3x3PNivHl4/SVJYb1GW+fENsg9rTE9WH0bMV3gsZDrw6
	BH7ahH9H4QnJRLb2p4v3anWVvs30JebUCnJA+DiaJTaaDI8Lo0CLGym1H5HZW/sY/pSi9u
	incHzTLYyGHomoW0u+9pB9eCzJjVY/T64QnuWGVG2WG7ZlCpxx+Duhqj7nHqJZ60zBl+Zo
	7qyRpM59/II2JoYkkUnv6z/u2oTmY0OkiUFetpIPksMOMN5JKai7mmO7iusOcbi3aLMFaY
	MZzTMvjyWy5ixIb/+VW4SYN4JKOJ/IJQZpKMb0eM4PCE+OCvp1yOxIrCPQv9Xw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 3/4] smb: client: handle DFS tcons in cifs_construct_tcon()
Date: Mon,  1 Apr 2024 22:44:08 -0300
Message-ID: <20240402014409.145562-3-pc@manguebit.com>
In-Reply-To: <20240402014409.145562-1-pc@manguebit.com>
References: <20240402014409.145562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tcons created by cifs_construct_tcon() on multiuser mounts must
also be able to failover and refresh DFS referrals, so set the
appropriate fields in order to get a full DFS tcon.  They could be
shared among different superblocks later, too.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 22d152cd24d1..cc0568c3f085 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3995,6 +3995,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon = NULL;
 	struct smb3_fs_context *ctx;
+	char *origin_fullpath = NULL;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (ctx == NULL)
@@ -4018,6 +4019,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	ctx->sign = master_tcon->ses->sign;
 	ctx->seal = master_tcon->seal;
 	ctx->witness = master_tcon->use_witness;
+	ctx->dfs_root_ses = master_tcon->ses->dfs_root_ses;
 
 	rc = cifs_set_vol_auth(ctx, master_tcon->ses);
 	if (rc) {
@@ -4037,12 +4039,35 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 		goto out;
 	}
 
+	spin_lock(&master_tcon->tc_lock);
+	if (master_tcon->origin_fullpath) {
+		spin_unlock(&master_tcon->tc_lock);
+		origin_fullpath = dfs_get_path(cifs_sb, cifs_sb->ctx->source);
+		if (IS_ERR(origin_fullpath)) {
+			tcon = ERR_CAST(origin_fullpath);
+			origin_fullpath = NULL;
+			cifs_put_smb_ses(ses);
+			goto out;
+		}
+	} else {
+		spin_unlock(&master_tcon->tc_lock);
+	}
+
 	tcon = cifs_get_tcon(ses, ctx);
 	if (IS_ERR(tcon)) {
 		cifs_put_smb_ses(ses);
 		goto out;
 	}
 
+	if (origin_fullpath) {
+		spin_lock(&tcon->tc_lock);
+		tcon->origin_fullpath = origin_fullpath;
+		spin_unlock(&tcon->tc_lock);
+		origin_fullpath = NULL;
+		queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
+				   dfs_cache_get_ttl() * HZ);
+	}
+
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, ctx);
@@ -4051,6 +4076,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 out:
 	kfree(ctx->username);
 	kfree_sensitive(ctx->password);
+	kfree(origin_fullpath);
 	kfree(ctx);
 
 	return tcon;
-- 
2.44.0

