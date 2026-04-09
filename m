Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B863BFE40
	for <linux-cifs@vger.kernel.org>; Thu,  9 Apr 2026 10:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775728824; cv=none; b=ffroLwf3sHtqUmqZ2uqQ5ine9At1b/TPz3YnmD0jb9h20EJs+Z5detQegcL6+zrdv+vMM/tpJbkwqrlrgoJR/H0uhHv880o2gdJhY+rHTcPnqD8/aj670MeMnB7ITmHazOoM1Oh+Rl0k4Vj+spjgBWjiZSl3tILKp4RsfTkRgL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775728824; c=relaxed/simple;
	bh=bF5qUQUvVDWxl8XF8/5sb4KcQcJun4x9Cxt/2bnKeEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQVnWAsTwkU02Ht20xODNubzYvsIIuVWbswC6yv8W67d46GN7+aKOj9ImId0v4ZZ0cLyzmNOLTa80o4uj9H5vzpSf2kTy4lqnr07DJ1VZ5ebK/d8dWgHlNDtM56Z0KouMXxluZKIT3AHCj+RewGlPvFWtJS45H2zLRnOAq31aWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ScXkflTG; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ScXkflTG"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-82cd5c07f93so384489b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Apr 2026 03:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775728820; x=1776333620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QObthFmA74FR9S5RNg1UaQnHWYJmGmu2RCoe8nfhtXo=;
        b=ScXkflTGFXmHSAniyVhyje+RkF+y4EVFRi8sJdk+OGM/VrgX8Sq+hbvXkna923Qqjn
         LIoMw7Ngx17JFlynT1SFM6i6F1wL1JHaiBkMBwbDTX1I2WrfDzbzM+bxTYYgXFMdlXeu
         HU13JZiDnP5ZuZVn+6Q+2mX/Gq+Qxy5uEV1LnjDtoYbs3vZMx+C6ysZpcaIV6AP1VL8K
         z3l6Lof5lUzltgbyKbaAqJEHWUarwqQFA/SphSme9RK1DfEHO+1d4D+R2kClEZMJayd+
         LE+dp8ls6VGX9y7fr7KYKesCHhw9ea3y6VK2oAnDZFPj9PQc6fbzzrvtPRZA+C7SWOsy
         QYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775728820; x=1776333620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QObthFmA74FR9S5RNg1UaQnHWYJmGmu2RCoe8nfhtXo=;
        b=SIxBJW4vUhli8X4DpbYtYMdS9IBoSI9hkrgWkJc2VWoFG5cRSvjhpU69b7dBA37ysL
         Yt6t+M0CF/JchSy5uiZw9CfDaOyXRHvsokVD31bdMas0RPWDHI63iLCdrwsYNmJ9pmaf
         m/rhXaWb96Ag99u6+6KtssLJ8A8TiBcziT9DvDzA2LqBSemnMfStnSnooZUgdz+jH1gz
         pyOAjkh/8UBptNJq2nBTtc86JuwzVGEBM2KoA00ZnAq72WVQlZRCBC357Hy+netRY9yI
         ublBstoFX1NDC5GKfk0LddNbVcDzBPshAooy5UJjRmsKwr7SQlOCWzueOw2lYOaWDN3D
         H87A==
X-Forwarded-Encrypted: i=1; AJvYcCUJPhj4AbEDHC+oQK27L5Ed89A87dRw7VDX9wentdvf4oteDwjOqObhDr5r6izXSlw4DOeUBogpdsqj@vger.kernel.org
X-Gm-Message-State: AOJu0YxPGpzULvqD5QgbVhm/3k72prt2yoMRFGmA/pThbnaS48hyeFcA
	Zx1rWGlrB4LV2/4mMmK9Y12sLoEwm1Ntwq97FXfoJje8PhtqHrzUlIdh
X-Gm-Gg: AeBDieuW0Yf78bynRa5Nd3t1kXzMCb8Vfhf2kC/2blgb95G/RbvuJNEs/b7bH+lDTAq
	or8V4idP7d93xxKBxc4M+epWwJxRd9t8HAx9NlrCQAi5DFpkliMSwoFALheUxXvOm/Gsb1I5wF5
	evAuolYHFUXtrRNd2q4hW9Kys5dRJoReVAs5keHcbPNIDmECry+BuSVI66HEbrHR25toBaqMhSQ
	LgOsVrXS16m/BKN9sdUXOVOMLNj4Af4RYz3pivJ58nXFaqwSPa/j3Un8fZ8mjZG3gC9omAzynEW
	IHuyI7/pg5OCnjvbtHnofTlAiPHBiVfbxLmpFGwNxF/honpIpjGeofFG9Oy7vRgCGpf2SUZM2I/
	up9qxQLucxfSy7V1bW+4BF3KoXQ/hwMtTWB6kDuEhfF1dp7BAaIwkwgL8vxTIbkNJMMQiOabw4p
	RJEiDExVpfEyY3ICi0N/3MDz1/R9h9fx7FgjK5UGHbGNb85rdsObFxy6oYJiU9MayLycoMPPd/+
	hMK+eBd5n0GKT3D3bp/f3Y=
X-Received: by 2002:a05:6a00:1da1:b0:82c:db43:969b with SMTP id d2e1a72fcca58-82d0da8c12bmr23623633b3a.22.1775728820504;
        Thu, 09 Apr 2026 03:00:20 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c6b80dsm29113671b3a.42.2026.04.09.03.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:00:19 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	metze@samba.org,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 9/9] smb: client: apply rasize on remount
Date: Thu,  9 Apr 2026 09:59:26 +0000
Message-ID: <20260409095926.905020-9-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-1-rajasimandalos@gmail.com>
References: <20260409095926.905020-1-rajasimandalos@gmail.com>
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
 fs/smb/client/fs_context.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d804e5da578e..bba642442ae3 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1504,6 +1504,12 @@ static int smb3_reconfigure(struct fs_context *fc)
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

