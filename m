Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398423A0E84
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634448; cv=none; b=fe0baJUBdPgdBEK7uS6iH3/07yVE7tSMJ4SAuyXXafD3+INEGmsGV/W6mBU2Pgtr83qzhRL09DAfOYtH6FTonaofkLN49agchhtVPVhToJQaum0BCnaMacWO/dXy9ulu6hCvcxvR7JFTe3w6gIqXfzO/XyTujem2njS0g1Fh/qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634448; c=relaxed/simple;
	bh=9v6XO9ylEL8LwjPW3xmhI3J94s+qIyMUgsSxkjgdOXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYkPqL+HifKfk3lTWjtBmb1EOS+8znJs33YdwQSuvKyDBP0aEcHi8hZ0ZIVt6WAUbl+7uIPRClWyHhFV86c925tItLiwvb6sB0FngzPKTHwKSfN6ECKbXnx3qkxd0nD4TfnBSe6fvUbXtrme/TixO7M9dJDyrly8y5KRovWSVkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e1jxpDE4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e1jxpDE4"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82f33d28c1dso1055690b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634446; x=1778239246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=go18YIiEwWbQ57FroEFcnRyZ9WBWa63cQdoyTHIy0po=;
        b=e1jxpDE4ykO2BPchcB7mYRiNmBcbJoLXw5IVg5tLBczFhxtQsBOXLwXFu69FmjY6Tk
         Uqe5HTwJB4cUczDaVApn0iYc2j73zO3JnimateJJBmSxZBcsbvciKOK/8SF4ha0k0qi0
         qVYTsvk0ranbW8TjgivZhpd2cVjhnQDv0RdxBwyFiErYr027wt9/QXrihmzuylC/P/s0
         g3lRITgTzw2hvpNJJ6JKgGsX5S/EG8vOMd5iH8PC0ZJvQ0mMulx/qdyBunK03HH/dl9l
         JEh0TXfdcejNXXRF4VjpxeL6OqdagpT7q7Ci2eGkrsyThBFukOTWkEzx2hXnXJC7bAIy
         LsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634446; x=1778239246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=go18YIiEwWbQ57FroEFcnRyZ9WBWa63cQdoyTHIy0po=;
        b=o9Jl/su9a+doYxDwU5Ia1/Ixo1+BXDD6E2JRSaWPDXSUse3sAWqRbgwWCBehtNqeev
         7LBB9IfxpwOtpMfKnUrDvkxm2fE53qmDSpfYV2rXJcA3hB6xT/BS8FWxtrq6eF3mXiYz
         FIw8QwUBgGrpRUhI3yXxPZPr6zkSyv7gWbJIUfWs4fTEWBCYWn8v2lhDM8NcZ1vBBH+v
         SMz49HnZ1zg2JS2Smqo4G7JxMAucxpp9TyGjdscM0MrsCQ3UihlCtV2XcxiZXwlGoQ1D
         BJrtduLHc8J6iQPfnG15dacG7xpSAAuzepPzopoUyVTRg6w1/JDd12zCxL13uh+T1OKp
         edNA==
X-Gm-Message-State: AOJu0YxGTWEpk52tDhVUlHcbzsL9aKceNC0SbwimdRMeafUKv5PFLhRZ
	68I8rQy7Xt+51Xy2p/a8uMIGSgFMlnx0B15l60XtUjs8cbVi5yoT+Lzze4c+9mdh4MY=
X-Gm-Gg: AeBDieuApRLr5yZhPeDqqcxHD12mT18MuhwiJqRq0JAGdeVH38Yq4RIvl55vBEpkUvf
	JTq3IFAXZ10aYsjQY44Xw+atKmouF7nNWifHr5GzWNNUmeJ1/4farckwGbZRtpQGRU8k9cmpk+0
	8nb9o7Whi7eTPNXvBsiiiAFr//cDgnqAzqy8AKwF0xNRIo6AobUOiiA1tIp0sotPrRgcXOwdRig
	lRCJs2HQXs0omekflTd9Mlx6ZTd5bq/FxMHZryfcDq21DkFI44BcWddMzhKwq47nNZ2zqNZ9ozX
	FlBiqKO0XQV/reIi3WyXuonA7DK/BopDcfe0O2S+/dKwUssgINb76zScgi71G0FvVK4WX8wKJoI
	bqAiJrdPlzX6FU38sNb8FSchDZyfYHfFdokucPbrDHvOY5ApJF411pFGhfCipUb/LOsf4nPo1Xu
	gQ670l1GiK1Gakyg9rPRsnxx2lEDjTcC/RI+m5KbuX1CHg+4xc6mIHOzT95Ohr5qQqnJdxtT1D2
	w0=
X-Received: by 2002:a05:6a00:21d4:b0:82c:e816:4135 with SMTP id d2e1a72fcca58-8351a659d4fmr2697730b3a.47.1777634445805;
        Fri, 01 May 2026 04:20:45 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:45 -0700 (PDT)
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
Subject: [PATCH v4 13/19] cifs: option to disable time-based eviction of cache
Date: Fri,  1 May 2026 16:50:16 +0530
Message-ID: <20260501112023.338005-13-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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

