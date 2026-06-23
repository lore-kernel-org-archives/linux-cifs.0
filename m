Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED9314D05
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232177; cv=none; b=ErDWdg2x3OgiJYzI012s2mTyc8tXhhOyBln+aqtew7CVxqy442YgYHoAAFGltkPBWWU67mxirruO3cfsvKQXtpIz9L3tiKT3LQqSbymG9eLkWEdG9oqTJtS/XAjtyDqSRpPzADcrdI0RNYIU5eLwjY3mIE4qomBR6pDP70fOJnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232177; c=relaxed/simple;
	bh=o8T6Qn6pP50ZlbURwxE/h/i6IzS2ZsYzuG1atEi0sCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEmA9pSUmCPckBih9P08wij1TAjF8L7dEmRCkkI8vQplSlYnv3YucA2LhyRBNOBr7hJfY4E06W9Ve3WfCyjcfbbOEfxQZNEE7K2WYB1HjiBlULfDicY/IsNd/ArWRsfN4MGe+7kJDIUG7nqEIaoJrVgEIRtRKvs8vFj275VK070=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wpk+qoqD; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wpk+qoqD"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c0c1e0b0faso371135ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232175; x=1782836975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nq6SBpT/r4YYp/T8WkAAYFXVdiFPhMfy3nopjFPh4Ms=;
        b=Wpk+qoqDtzDTrccu0jpcw+VxtrvkBQWLQcZ8aOeypB4A1TwfzAYW5R3zrCZSPhdQTK
         n1HC8h6dF1pqfwJ9XjI59013t145hOOYWp+g7gwRXI/TzqtaGQYkWauhFCUoyooED8tV
         wUFq7fQzku2hr1kiQhD+47b9F+AbaNsqGv9T+tjluZk7gADJxJp+4H+B9wtXNGqWb16D
         RUv+J7dGti1ybQw1hirCMNzFp+3FH4lC7AFT7kIEMv3AZ1/u85wzsHUJF4+A4oD/gSb9
         HsskqCCw9CsCS17j2vn4tItKeuz8yJGBRbvSg+3reJaiA+ra3akntCNT4kJJc8xnXLy+
         7D2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232175; x=1782836975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nq6SBpT/r4YYp/T8WkAAYFXVdiFPhMfy3nopjFPh4Ms=;
        b=M9wbfMFRXNsH+w3kFF4i06SiTS1E6ITHPp/cdBpI3IUMWTOTrCCr56833/IZlxvBIh
         u+RdJXX8ZEMjRn2QhOmpD0PRU3UO1X1F71wlMeDx//gonxIc1/r4OCY79Kw5IHv6OkzJ
         S9KHraDWahUxBTJgQKBFImCZtZmva7zIBtGjmbcM4kk+WikBtdPL1hqRqv44QFPuw3rH
         AY180Zewl8wAclEVETqjcjrIxRG1aWXT07amZHmHbUgAa5Ljg551h5Zywfm9zc5vSyS0
         w9J9hk/xpwSPoTUefSu/xbt+EF+aoBG0kFUonRLdNEIsifsaKvWomdWlSoEBGbs8Rwec
         fYOw==
X-Gm-Message-State: AOJu0Yx97D19D77vofTw9bHNCeYzZq33CTYCAGP/AuExl50DdezoYopT
	ytj0IlkPQvd0soFYk2qND0jdQahNA8Q9WpwEio64HaMUfM1YY9DDGsKo7HEFusv23EE=
X-Gm-Gg: AfdE7cl9d4qXCmg2XPVmsjhqxtTUsFXZ3mPb84LPITigfBxbIQcnC+y1HocGDkGnwsa
	GJyxh1YWGr2Tj4iBd4+tNXhBj9sCAlf4LjfNsfFJdulZC9oi/btL1PGQBt1x2PmRspLVU/wNY+5
	7lhC8iKMEkLUlo9J6ofv5d8M5zeTfENnez6HtymZeGjGlfBcAHsKCjX1DM69DxdfrUenvCsrD4Q
	oR2y1UwCE5vhUT6EhEFU4u5CNFkEMjG4kQ/a7erC8U8nnuAtGlJvz9XSY1hE2TxxggkHMj2YVbW
	otOfIcsxlv0V8BtAUBVic574TslohwKkfHekmvWH8r12caqpE4JSoYePNcTkC7z9G9bOoyz9BrG
	S1dURs0XVZAy5kxMzcDO2mFModTHzUqpczufSwhItUrphu19E36pBPUFZt5hnqe30frJ+oPQG1S
	0c3CXk2BsiPFUflvTBnzLVZK64QUV5c+8vPvKztlB4UCM=
X-Received: by 2002:a17:902:e545:b0:2c6:beeb:d7db with SMTP id d9443c01a7336-2c7c7600d9cmr41323375ad.16.1782232175189;
        Tue, 23 Jun 2026 09:29:35 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:34 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v6 12/17] cifs: option to set unlimited number of cached dirs
Date: Tue, 23 Jun 2026 21:59:05 +0530
Message-ID: <20260623162910.343930-12-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623162910.343930-1-sprasad@microsoft.com>
References: <20260623162910.343930-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we can control the number of cached dirs on the system using
the mount option max_cached_dirs. The default value is 16.

This change allows setting this option to a special value of 0,
which means unlimited number of cached dirs. Shrinker can still
evict the cached dirs.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  5 +++--
 fs/smb/client/fs_context.c | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 921a6f2c3c51b..ecdc6907cf6d1 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1255,9 +1255,10 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	if (lookup_only) {
 		return NULL;
 	}
-	if (cfids->num_entries >= max_cached_dirs) {
+
+	if (max_cached_dirs && cfids->num_entries >= max_cached_dirs)
 		return NULL;
-	}
+
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
 		return NULL;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 9bb41114237f6..f2cc5530447a7 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1523,12 +1523,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->max_channels = result.uint_32;
 		break;
 	case Opt_max_cached_dirs:
-		if (result.uint_32 < 1) {
-			cifs_errorf(fc, "%s: Invalid max_cached_dirs, needs to be 1 or more\n",
-				    __func__);
-			goto cifs_parse_mount_err;
+		if (result.uint_32 > 0) {
+			ctx->max_cached_dirs = result.uint_32;
+		} else {
+			/* 0 means unlimited */
+			ctx->max_cached_dirs = 0;
 		}
-		ctx->max_cached_dirs = result.uint_32;
 		break;
 	case Opt_handletimeout:
 		ctx->handle_timeout = result.uint_32;
-- 
2.43.0

