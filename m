Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487D23A169A
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634449; cv=none; b=LBh7NqXel14EoJzOUysTnCAOHRrClJLlPQSuQISFf9/g1ORAXarnnrfyXT5tN5JnGPRix4ortXxCOwVs9iAOCCT12hAqittrLdxPBRkVlo4/Eb/7FOhWOiVka/9N636R2fDxchsU8nJS/xNluq2Iyf3K205cYH/g0nAuJZGIkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634449; c=relaxed/simple;
	bh=2VOV5tqwf3NFwCRY4AHpMHJQv246kLMl9Cpe8yfdGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKVptmqtc5jIHl0lo1OMv27HTLmIcA9hSbZSFDdjjm6MyxXuuJqALYahdUqk7vZu2KKtiLu+kokYmd3BulcjAaBzxC9H58cE722MibLfSbBbmxorU2vRSUFuk1Ww/Il1Wnhpek48Z+62Z0/ueVv5trhfSK3hs8Ire1rtblfeMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EiDqf00o; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EiDqf00o"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82fbdd60b64so1357514b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634447; x=1778239247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9o5H0O8dBnbcBaUn3Ic/j16+H1InseCGstPTG4iokWY=;
        b=EiDqf00o9Av/SClE3IQo6u9InF4ZHFp5DQb67rtBCbjTomE8+uPFZq90XvgpbgNGD/
         YawCJl/wt7rIdV+aU+PbYWV1z3FQxJRn9VwwXaICqrIrOuTxI5ZqqUwran5VJ38NEGrD
         InuDdjO6FhazYwgkHUmLDDKzsjUOo6unZKMrU4+Twxe5JMHJq1YEKoPbr8jfFO9wKgeh
         MS2/HFCHX+9WnZi1qjILZ0vk1TaRWfAOjnSQhP6ERmZNfKeW8iUafy1KNKB44J3+NrEy
         UWwpe73VnpJ9OtIrFhpn6CD4ZPG3TST/qQhYwy8Srr3RUbfCFe6lXeCDSwKsjj0T5/9P
         20Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634447; x=1778239247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9o5H0O8dBnbcBaUn3Ic/j16+H1InseCGstPTG4iokWY=;
        b=GiltptvJCJrwwGlE6Q6uriXYf3RAg98RMCFxh9MSKcMyC2HfM4AEWn1qk4owi4bVEy
         mpd9alJBG8xhyxMzM2gs7lRPXg/6kS0fJ3sUb16zl8+C900vP2VvkP/ZAVMBZMM82NbQ
         xHy6NruVeOZjMkL1AEsW8fDpI1BC02EqJbtUbXPakT0Ah6ldLlr2Fd1dzRzm+4+WR8KE
         AyJULtg7JvnzEUZA3vGssHAOCJ/fd04wJPM+9fo0nHNtjkCR0LLyaO0djThcjpt8LfI3
         KY4fj9vItDHCuOLZ3JzcrjTsb5bMEQPwwWnr1t7ksLDSQCTnn3vRL6deAsG11As8l0DR
         2qPw==
X-Gm-Message-State: AOJu0YyQTeAP/1Lwq3jK8h3VPuHSiVxQSTugiy9sF/KS15Ce/3MkM7S/
	mutKZE6+rQduUNzft5jGqWtvgY8MK6LVXk+24AQDT6RgT/URcW4UkTwmbQEp7BOIdbI=
X-Gm-Gg: AeBDievuhULsrm2yzIx+DAKgdbbC+XQw135nCf2kDp8+yg8MOgUCoboZCheHLriDc23
	1QOSpIL4ttz5kxFtCP9iNd4ckSjo4YDCUHSq2A+lT+DoSbjTQe6DZfwonghqpIuBcwH+JSEX4OW
	qcwte02E9gIx6IGIqbkVtvfcKp8kxRmJelp/4EeAnKjOFVZG825KyqLEjP/uMTEyCPgAtSy3Iuy
	RjKwjIoILSadSryzCqmjA9HaaJDYXkQ27ZHfFYbO4mngU1dyPJ9BN5EgzUMJHcaqvi1RutMn72b
	qw5yGWojAwO286yMmhp1fNjO7VAagWv0ECSZ/6xxNAl1zPVwcHO/kutnFH82js5i4Exh4N7D2iR
	M7sj9hvva49A2cX3kbEFAUIM/2Iq1uaulm1xDDBA6hin58xQQLlMAN8TK8DhyDqf4F+hYq7LFIP
	3ylKteZpVPbl3/zJH0TNPww4p5XkGX/OSuHtCipn7MUxyhbLhSeISCnaT9W90YV1of
X-Received: by 2002:a05:6a00:950c:b0:82f:721f:10ea with SMTP id d2e1a72fcca58-8351a308c24mr2877687b3a.18.1777634446899;
        Fri, 01 May 2026 04:20:46 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:46 -0700 (PDT)
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
Subject: [PATCH v4 14/19] cifs: option to set unlimited number of cached dirs
Date: Fri,  1 May 2026 16:50:17 +0530
Message-ID: <20260501112023.338005-14-sprasad@microsoft.com>
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

Today we can control the number of cached dirs on the system using
the mount option max_cached_dirs. The default value is 16.

This change allows setting this option to a special value of 0,
which means unlimited number of cached dirs. Shrinker can still
evict the cached dirs.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  2 +-
 fs/smb/client/fs_context.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 7cfbe50db66f5..863b8d666ea95 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -1256,7 +1256,7 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	if (lookup_only) {
 		return NULL;
 	}
-	if (cfids->num_entries >= max_cached_dirs) {
+	if (max_cached_dirs && cfids->num_entries >= max_cached_dirs) {
 		return NULL;
 	}
 	cfid = init_cached_dir(path);
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index a46764c247107..3eff94df70d45 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1493,12 +1493,12 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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

