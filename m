Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEFD44D01E
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392513; cv=none; b=KHFtGgdBwWz1CmBnb9rwcyGiY0w96GigaBJ5c9RNe8j3OpT0QBe+WMTDNnvEtLaOSoyyhpVxNwSuA70r2AM3Rul2e2M22pivVNTCCxgmdWiu30pe0abxqZ2CGsQC1xEkPqRTYNNDYfsvluBsZLwpDipXlIOrTOozJJNb1m3kD2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392513; c=relaxed/simple;
	bh=9v6XO9ylEL8LwjPW3xmhI3J94s+qIyMUgsSxkjgdOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH3E1O6syMGeWhW5QtDp5HbklWaxSui23RbeluRqfR3RMci9jLC0aKEUZItdvEnbcMrC3RTRP2x3NtfqxTAaN+Ib4l+QOb5eHrQDLNVwdZxZ5+jWTI4AzBiCtMxwJjDuPo7ftxFoENdEYwVSoBTk627iWNSrgR6Vg+cxpWh+u8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FJVNGH3I; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FJVNGH3I"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ab077e3f32so50630235ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392511; x=1777997311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=go18YIiEwWbQ57FroEFcnRyZ9WBWa63cQdoyTHIy0po=;
        b=FJVNGH3IVcXfoO3S+EyBzA9XfUsDGetQ2NvmcMEcJqxHV1HS3orJ8ecA/XMgnxRzHt
         1/RHkZBVU/cnOj95AuICKz1krgcE2IBQ9eSPPSRx2PBuIlBgLuymeGjrWXVUTdOKJIwK
         ChALv3PCczcnRmSb/54csTVKM7W+VQ3V9LStTiOp/wwjSSJNXtRw+AVvU8tpSA3Ex+uQ
         NQxNC6AdxhN8z950ai2pYiIzscNh2csyQivbeSmHJ0LnCx7qsuChs0ORakVHgWc71h2K
         a7a+P1oUknHLZu3QYilLy7gBGzIhMW6YdqqQ5IxB7BAO8hTaSW4qPvMAbnC754Iaguxo
         Ctnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392511; x=1777997311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=go18YIiEwWbQ57FroEFcnRyZ9WBWa63cQdoyTHIy0po=;
        b=UgKSYbj31jnDKowYANds6y2Yb+W0HPU2iCSESK4Kbceeg2/GOrWeNsdI9O/zHm1KDK
         NdnlwOepfS54ogzt1vhlEHcYmhOE/jsRiK3rcEGpoouhhPQyvjMovhD316FCL8OVI0o2
         ZwXfcpv80+eRdPUcBKj6uX3xbksVi6TqfL+6JKd1WJwdLXvwqZ+TclWo1iTVS3lUP2x+
         d9HQzdgZRQEynu8i8Lc8uwfzq+CYQwznQjdSlLy7hMjjnV4/MB0tbQ1IsvS5CjpxH1PX
         A5KwpKk5OQy40/Jm1WWLog69xSv8v6s9Q9taw5hwCJP9aTQf3CY1pMTFkSxQVbqt9j7b
         yFZA==
X-Gm-Message-State: AOJu0YzikvEgLYyIcv2YCezsXuzgDKowZPaMBIU+o4IarHl6S9SPB/In
	JBUDkmCl7oFGbL6veA2EH2PVFZHH4vN/BVKNQ5QuTVCNkjjkLzlNlEWjB/ZG1tEEuTQ=
X-Gm-Gg: AeBDieuAZMBdZ2SNgrSYprCuCzDenmRsTeGU0en1b2cKjcw/tc/CorypJVtfIAPSkDJ
	kl7LRrA/opco77xZW9vvSgwgL5hihusIGY96ob0sN4RpiuNjMFQRWkjRaEtSuDrAUzjVk76GxLD
	g7YNNQnhz8XLJPz58IIoTydq9/82XVJf/3DtIRR0pUaVPI+Fsa41H4lni6Si2h2U0XuR2bGxNt5
	Wt9BeWEjWPTnKmJXMpu5VOgEIRS8OrQy6ULFO8/fMd6HH5+La3S48FzNdFkMg66P6B56pOOPwJQ
	j7ps7ZRgTWKbKQmsewX6JFQz1CL46twWoq4HibKlMHYzKohWSv6JcPSX35IIgf4St8o0b34LE+A
	clsGCPjucUDtl2EYEK8sS0w5KSS3cHvPPkXFu6640JWm2pxu1hCPwkc/dwo0lyn/cdNFxoDK8OU
	WA2CcpRTDaFn9yLb/b7y1t6biQNg6n6f4f6ZV5i5irDIEgbh8Jw3o4l+bkEjcT6ehsh7MEDpbS1
	mM=
X-Received: by 2002:a17:902:f54a:b0:2b0:6885:f1d4 with SMTP id d9443c01a7336-2b97c4f3b2fmr34294335ad.39.1777392511250;
        Tue, 28 Apr 2026 09:08:31 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:30 -0700 (PDT)
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
Subject: [PATCH v3 13/19] cifs: option to disable time-based eviction of cache
Date: Tue, 28 Apr 2026 21:37:58 +0530
Message-ID: <20260428160804.281745-13-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428160804.281745-1-sprasad@microsoft.com>
References: <20260428160804.281745-1-sprasad@microsoft.com>
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
index ee5de358e27f8..79a6a4c297ee3 100644
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
index 69b38f0ccf2b2..849c16c538353 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2698,7 +2698,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (ses->server->dialect >= SMB20_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
-		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
+		nohandlecache = ctx->nohandlecache;
 	else
 		nohandlecache = true;
 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
-- 
2.43.0

