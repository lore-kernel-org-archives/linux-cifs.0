Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1845A30DEA6
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 16:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782232176; cv=none; b=NvHsMsPEVdWK6XrHgRTVROhVj0cwsfPQWPK3seCM9LOzF0kNFeOnIJIn08RhiZTJz2qM4HNaIOyrkmsFBiCWdvWlZMz6etZAIJCQTgavziM+d5paDzfssy5czJtzboxS5Hv4bcHSbFIU4KiwLCZ7iTZkTxlmH32aeld4uKVmipY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782232176; c=relaxed/simple;
	bh=l0RfHkDELgJ6NBfBjhhwtVKu4uqnV6Fa1VePewMLJq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCNONVoFoNsZzqABFB0kG1eMhOyYiHf8B//9cgNY6Ei8dTZtBnVPtjrPCotJxlxjqk9o3ujlL5MA8N4qAP6LXcFnGYMEWF9tVroBBZL6rzHc7pRnJ7FDru52R1NTeGaqpnc9yWFzqql4qCzd49/CBqyS5cwAgCtFa/lauJmyQ2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s75MIulP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s75MIulP"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c7cfa17fedso226995ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 09:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782232174; x=1782836974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1V5qNNR3gxQe9AQDeMRRh0mprBB1A3lfF8Sk76rC2Ik=;
        b=s75MIulPKNUrGnPDoGc79sZsuRXfBbHcXOjrfV2zB2q4+JCPnKE2n8aiHz/JUMRfad
         D6cCpgw+0nGf1uUDD6arUZBGikM8Y3MBwxlOqlAt41S53BG7ddj5ORlDIOm7nAGvOcNi
         gGldWlTnCj6s1dgonpz3APhkKh5tKENDs6AHSgT0VYzjcbtB/PDNz8DfAKpUNhShXux2
         /i4YtLeRPIVDwKJ5DsIslZ9qPFj53e0rAe2UlPTzZkKPWcixl2csgjWlrW4R4FwdVwiy
         f0gM7KKYYlJMWDiTFlU9B2zSM8lSqbJfHYPcq7FUeeD3ICObvDOPpQ8flpCST7SbWbKx
         DwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782232174; x=1782836974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1V5qNNR3gxQe9AQDeMRRh0mprBB1A3lfF8Sk76rC2Ik=;
        b=jVpNL6OkFnmrgO3zoXxelGH8I9sYtuQUiFU6+8VbnUULvSEuCTqzxK9mtObWFUw6Rn
         rDoIpgGPo5gHF6YmFFAkREqVcyoKwqIS0iuFaNR1UIlddE5AO/B3lRFvPwmDjZPrF/Vc
         kAbN/5wD/mBzADBd7oNm7jEtWtCCWR+oMUqx13jV2cdzARHpDZEcS1LzIhmksv/L3M6E
         fK+VF4RFCWItPGY5UIrhYNyYTStiMQY0VcacOznr7PCfwks59F4xlcRNz8UWdlOBOxZr
         /0djdiIODjpfz5AUMQTRO/Umx3MdasEkmbLNNr4vOMFjEntZjC5zMSfn7xVeK4GNL1WL
         swSw==
X-Gm-Message-State: AOJu0YxI4mBLZc9LaK6sPBerYw0e4/57wKAM4D7TYk33DwNghmMPHvnk
	RYaUmwzMgrmURISvzWAbwQvPkHhJAVgdqAfA4fgazcJOmSZkyMdbDxMjI1eyog8jrP0=
X-Gm-Gg: AfdE7cn1L8+5JsFsaNj1G8uzswSCinLzMIPOTfeo5S42qsoA87J7y57P0/hKZIrwVfw
	c+SGO4BcJc48vncjW+Kcei2j2P11G2KXZ10Pg93NErc8aQApAUxJ+ds+B2abSiHFS6I/1ypknyM
	YK2YzmI06vKnvJRcvC1AGEKOJ9zIJ/euf+w8r9AYm/vVuOYCRGv4s5hdrwKrehux9AdJ1FR4DVG
	mji77pxYddQJbrNZB1vC+mLPaGPhVaeO+Z0xQ5a2226UhUplO3BLLUpNagv6zhpTBLdBiqNZ3Zx
	fyuvkiPd3FQcOO9uXbog1IJg4RuQkcUVkm1Wz3nznN/fdGpLuvhyesIB/tOqJMCE9BkEFkOB0MF
	t+9Qjq3toixVsbAcQ/ibGFroTsv0Sg1J6DXd92Mpv4G7bWrcwHs+hDbYgTSiF7aj99I75/cHxtN
	4VBGQ1/d/vayJ958YN92cjTaW+YglWTIaHiT9Qm/Wz8kc=
X-Received: by 2002:a17:903:444c:b0:2c1:13b5:6c24 with SMTP id d9443c01a7336-2c7c9a37476mr24250685ad.20.1782232174392;
        Tue, 23 Jun 2026 09:29:34 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c743bfdc97sm135185485ad.65.2026.06.23.09.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 09:29:33 -0700 (PDT)
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
Subject: [PATCH v6 11/17] cifs: option to disable time-based eviction of cache
Date: Tue, 23 Jun 2026 21:59:04 +0530
Message-ID: <20260623162910.343930-11-sprasad@microsoft.com>
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
index fd725ee4293b6..deebe5d440de5 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -123,7 +123,7 @@ MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server for "
 unsigned int dir_cache_timeout = 30;
 module_param(dir_cache_timeout, uint, 0644);
 MODULE_PARM_DESC(dir_cache_timeout, "Number of seconds to cache directory contents for which we have a lease. Default: 30 "
-				 "Range: 1 to 65000 seconds, 0 to disable caching dir contents");
+				 "Range: 0 to 65000 seconds. 0 disables timeout-based cleanup (cached dirs persist until explicitly invalidated).");
 /* Module-wide total cached dirents (in bytes) across all tcons */
 atomic64_t cifs_dircache_bytes_used = ATOMIC64_INIT(0);
 static struct shrinker *cifs_dircache_shrinker;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 79762e6bbe50c..ebe0232ae96f9 100644
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

