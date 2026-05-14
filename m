Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB2034404F
	for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778782125; cv=none; b=VLLy1xysgLQrPkzc4DG6b2Kv+9SbWYuoD3o8Mpuye6Q8p3suWR4aynOLY+Yy6FQkAQX+8na6f/gIXKf7V4gzyjjj7CY6t28bW8fD352n3BqAb4kbsZpyyNUyBFYYKYRph0q96nGa49qVLdnEVasEG8ArfgopTE/WLtpYLzNnX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778782125; c=relaxed/simple;
	bh=5Ynp0tspbj7fop3SCVuGpgcFSVxC2e/pW316p1fDYmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbwq8FoCEPX2IjzwquO//9NcTuQoaT0UHk4dQEm76sOJ+7t3pvpARFETKBygozwaAIi40dOtiDbUjXA5HQwdu5eTny6I16tZPL5v6EhtEuyoadnq6gtYRGIsciU/15anB+OWNeEYr7cJeQp7Zslf+VHG++FrGx34imF63aT5AjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QPWatS4+; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QPWatS4+"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3660daea6a5so4627774a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 14 May 2026 11:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778782123; x=1779386923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehxmwL/oIJBExyIAhWyjKvWrZy8W+BKAjdFc8FsLwUA=;
        b=QPWatS4+cWbSjWOC6rZtdOa/sKlAHcXpAyjDKWtGiSXG38rWJu6YvvAd2H2v9uub3W
         WgLCfjWo6vXk3rO5XxR7QKlqCWAOkiwCrj/b2d1BD26+UshhZR4gZJxfCz7JuqKYd6O6
         i3jagyeDS5PJlUi+vZZoMGY4Zdap5cLuc7P1dVilO4TElvFFhqZzucGR6jtrNVomUxp1
         RwjXXeY9nfUgm4g2BBoxYXtl8NPzjx/0mAiIunr0UyLYKYzapR/elsTmFQfk3SYzU+65
         mfbPahgXDuK9FZx3igoMZgSfLyHuvP2BI2MNRKD7pjs/uDtKFPz5hNhBvnyUGexfkpZh
         znfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778782123; x=1779386923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ehxmwL/oIJBExyIAhWyjKvWrZy8W+BKAjdFc8FsLwUA=;
        b=EkvRWU6m6pnxEHQ752AVF/58JP/4IMIfCLtn1EZAmKd9aqNaq+u5UiqTQ9IcZQAv/A
         /F0Blgh9A+c0WQG41pMI2Fdw2U6MVrLNo37WeC2+Wysxixl2TF70Jsx+FKb/XDG91Na5
         3oW7IJxC6nOfsRvp1BU3RQs3djeDLe/S4tRqdQ1VWqQ4cUxYedKovGMIT0V/FjW2KH5r
         Fjhky0/XItkPyBnnHI2t8GL5g4NbOUGVwKX2kjkYCsLRoTLMDxS7QdvpSXT5T+c8Euti
         LlsxZZmOtLja9M9a3UgzDocBcliuYcGzL/rAPUcfrgbMP1q0FZPX59MaOUxMqQ9gssNb
         Km5g==
X-Gm-Message-State: AOJu0YyIdF4usongV8qEN0oCMh+e9EHk0o09q4h/+g4Nd6/hSRY9j4Xz
	RFFYgvX9U6P7ebinQ3/47VP2+ioJvTPBHhzgQoQqMc1W95PXiR43Dabpg+b6Nz3dKfk=
X-Gm-Gg: Acq92OGglFBsd4RRex10rQY6a5AGYwXs4ND8Et499C7NDpMP6H3Q5FhCm9L3WU1AOI4
	DPLGNXHJ3vIfehVUTlq3rX8RC8KrNEZqmxbW7j2ctChhJjeThCCiqXgBw7SDjV3H9uAYnbg0yhc
	TTNv+dW1xkB/XLWdV1svPWq6tQE44RvNJ6JJHmQil/Gseb4+wbRnvDKO0Zp01YPCn2L8E8FKeuD
	RWXiOOMXNjsdJMmAmsePD2GukuI2tySKcomAsQG4uAiQRxuFHP7FaMGaX+E13xuEfmrWnD5KY9m
	+vCX37NX/8VQpthp1IjKxr69Fp2X5YoEiViXnO/RD3YIv2YtclR2rX7lxuf2mT6dDwvnnchqYa2
	c3qjJvRVshbSMfINeW5oEZZxLmkJ6nX4hGDZIE4uBFfXeYjsc+/BHcuLEoZ+mHLM/w8L10Urcyl
	M/MVCzbVW+4vYTFgOvx5zTDlIicHhAVhH6iOks8zzQl2DcbfjWraHtGBGqoOMVpVpX
X-Received: by 2002:a17:90b:1b05:b0:366:132:fda3 with SMTP id 98e67ed59e1d1-369519c4b9cmr440132a91.11.1778782123575;
        Thu, 14 May 2026 11:08:43 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.104])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb121cd6sm3134589a12.30.2026.05.14.11.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 11:08:43 -0700 (PDT)
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
Subject: [PATCH v5 11/17] cifs: option to disable time-based eviction of cache
Date: Thu, 14 May 2026 23:38:17 +0530
Message-ID: <20260514180823.497293-11-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260514180823.497293-1-sprasad@microsoft.com>
References: <20260514180823.497293-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today there is no way to disable time-based eviction of dir cache.
dir_cache_timeout = 0 meant immediate free up of dir cache on next
laundromat scan. We already have nohandlecache to disable dir cache.

This changes the meaning of dir_cache_timeout = 0 to mean unlimited
timeout. Shrinker-based eviction is still possible.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsfs.c  | 2 +-
 fs/smb/client/connect.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 14cb3d37a8607..f6dff13d9906d 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -121,7 +121,7 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server for "
 unsigned int dir_cache_timeout = 30;
 module_param(dir_cache_timeout, uint, 0644);
 MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory contents for which we have a lease. Default: 30 "
-				 "Range: 1 to 65000 seconds, 0 to disable caching dir contents");
+				 "Range: 0 to 65000 seconds. 0 disables timeout-based cleanup (cached dirs persist until explicitly invalidated).");
 /* Module-wide total cached dirents (in bytes) across all tcons */
 atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
 static struct shrinker *cifs_dircache_shrinker;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468df..f0aca5b7ac15d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2697,7 +2697,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (ses->server->dialect >= SMB20_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
-		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
+		nohandlecache = ctx->nohandlecache;
 	else
 		nohandlecache = true;
 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
-- 
2.43.0

