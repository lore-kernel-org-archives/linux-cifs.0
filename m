Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3E395AD3
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 20:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782246043; cv=none; b=tV9rRccRBNb/5jeZ92WXzGzHQpz7y8zD92lTGFTK+6vpj2I1qvqDGZtM3eA7n5K+MfSORLX24CJmsUgZmdrVoqfJM4l9ofnRYnLsy0b/BcX4YZYPViUYet1qRITwBVruy6NxbtZi+QAmk6VD6zmwbWm/nOLNRaln3zFgKhx3K0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782246043; c=relaxed/simple;
	bh=KbFvPOZSz7wxdUzN9l0SbeltmoeNf23o1giwySeHYIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2yy5Gp4bfecDPmIIttgniAcYkk5eCCHcO3CyEOWa73Iw3WsCM/ma/gLX/bzhU/yqZrNfzv0NuWjbpRIPk/v1afSn1bhry6QK5WXIUbquPM8sAM3bvssyTF3iJ5DflRoSpkI4X7r2SqI02bnPomud3GM8B/PtaLhMCsmWdPk9e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=flqguiUg; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flqguiUg"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6a0edfe29ecso188329eaf.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 13:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246041; x=1782850841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjVr/kDrfw8aioptvG8qcadlMGtnVSqSDWGO090lcJQ=;
        b=flqguiUgkR37ZIdGR7SDg/7XDOFtFLMUc2EACsVCv/cDMDtPi33ghsGtPvmNSrI5Y3
         D58YW7YaZuY68xEJjoz8nH6FtnQ5aF8M5D/IrAz9+1m/MtI8qjGq2HefHp9V2Hzde+gf
         6eZxrUTEQipHsqpm0rihZwLYya0xY4k29mt/RRg3iP+mxo0mgmO1GNQajPKrFsaeOOJ1
         jUBl3RxVJqHbNCjUn17XlxUqehulolHoIikovo0Q2axW6MFu+zTPiQb2EizQ2fgA5IQ6
         OPM8vUn3IdrmDx0quGzc4zg6RvQDKbT6GKeLsNJJi1x29XxpACzFmxoQZ7+quEfYz65O
         uOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246041; x=1782850841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OjVr/kDrfw8aioptvG8qcadlMGtnVSqSDWGO090lcJQ=;
        b=Ukgx9Pe9Jaoz0ftUJQDmd1wlcjix0UTLKXCgRiRETJbN6S/EMOWh4KoUdi278DDVhz
         mdSUuYzgYQJhh3lQtYdZ2oqzs+vK55iiiTNBoDLk4VX90mWQIuO5LlP3ajR1PFvUGr/3
         2EEHxIjPZQxewbijl+iqKan0w6zAZc8Bi8uxoZxDoXhAb4/wWYJa+GFLFSIKZiL/lhHS
         j3MMvYzOhkT3NWDyQxF+2WJnIazef1c7ByJBMVb4G4QMGucqvCQrRWhj8fRUX4wIZnO3
         F9bGGTzUL8MjjhOPLECZtb/10+GU8R6jlaj4DtWliGNfABCbE5FaoWperAEJtSQD6LaO
         pApw==
X-Gm-Message-State: AOJu0YwljY50rldcroh1onOLKI4CR0IrDv5GSkWGE2JJKwpe6nQ9z9qX
	EBamzoO0eWqDJjji7RRM/iIvNRe6huVtEoilM6SHCLOf9FqM9Frw6eY9WacNkGal
X-Gm-Gg: AfdE7clVYhjdOkL9amJfao9WOXJazU/H8ZBy5+2vSKJUMSTpgVsat0KQBVtCWBC3326
	AYT2/g09yGaJToyaZRSz29kNyPEJeTBiBNUfS5FQDwF+O8rG9rNmGOS8orkURdgjJ5pJX2kOAHO
	F3WNFi9FJDFG20JCbrwMVjqcH2GsvOkZYYmCvH86FwgEpCUk2+oMLvhYDCVYGFOXmCRQqcOswbK
	4Tw1PgfDRhsixKKwwW+wuD7LJ/3SdpBLF962VsoUDpIPFyAP9N38VG376eg3uL/eH7lHHi34wYx
	WUQMRxAjEF4KMG4/7SWs17bno0PyKEBsAVwLiwqI9byxYEED6jcePLjLLf/icI15UfXNk6qfcWD
	naMqHYkdSLbz6qt2Ju/kuwTry/Y9vSDerckO+AEivU2Hu4mqAPJ+HXUIS6/Z33NzNtDPYMbbpZN
	0V8ZPZKPAd6O1xJfKx6p0tOjR6/koSfGsx4VtX2e/kq6t1MvaIE5PVWjWO8x1MgZdAJzrGmSjwt
	qGTjJBfpYcEW/2EkFcBKm1Pyi7CAYO9PZjVmhOmnQDu0tane/TM4dT9TTES0awPo3h5Si4OqWti
	7ulIlqIseOL7ro+QjEPR8589kcU=
X-Received: by 2002:a05:6820:98c:b0:69e:6a90:ba4c with SMTP id 006d021491bc7-6a123035692mr204495eaf.53.1782246041374;
        Tue, 23 Jun 2026 13:20:41 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:7d5b:9c51:3ae4:81e2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a11e6ef161sm1000243eaf.5.2026.06.23.13.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:40 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 10/16] cifs: option to disable time-based eviction of cache
Date: Tue, 23 Jun 2026 15:13:37 -0500
Message-ID: <20260623201344.2043841-10-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623201344.2043841-1-stfrench@microsoft.com>
References: <20260623201344.2043841-1-stfrench@microsoft.com>
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
index fd725ee4293b..deebe5d440de 100644
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
index 79762e6bbe50..ebe0232ae96f 100644
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
2.53.0

