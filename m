Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5815644CF25
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392514; cv=none; b=U4/jQn1Rw5EalAPKnIag4u92qNAmABn05O2G1xqgcLnSPQjaudStQs5KhrdUrAQVvVcI4OoPCYy6JTQNMnpJ0NMvXYaSWAGwlzaX/btsJi7gUkBUB8gszJc4Sl1EAb/ucQHGXkUZT6h5WdFw00TfaIPgT24eYYr4+atRtoB7jHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392514; c=relaxed/simple;
	bh=2VOV5tqwf3NFwCRY4AHpMHJQv246kLMl9Cpe8yfdGyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwGww7xKQDbgDVlKhBVvWMRQL6DVl/kbqHBJjHIooyyBqnHde34b/f1MnLumRV+fAk1ZGUdkcc3a9/IGO2fSE7x22MTUhTgfyBzGvblwOKnVttIbeWnXp5fuAkY7eGuF2Ie+VSW0Xs3dIuz3yjYynYx0YKjRNaVF2fLibLcyPaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yor6jWkc; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yor6jWkc"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35da1af3e10so10762846a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392512; x=1777997312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9o5H0O8dBnbcBaUn3Ic/j16+H1InseCGstPTG4iokWY=;
        b=Yor6jWkcQUZ5D/VYMILdXxfsU3LmTvrPP5zL9lWkh0IOYh23cwf4137kqYvn3T8WL3
         nsyRW+iM+wV9u+7w7rs/IluyhARPEUb8FhND8Uq+/dfFeGRVk7H04XYe5rsSJno/NZ/f
         mlgAHttD876S4FjqWvcNN9+UuqxGLOYGQRVRbABGl748Q5q5gvWPEByUtQdHb6EvQZN0
         kQkIYjiBwQs5Qfbx22RJaqeJApst6+HK49BDWaYu+MviW8b0mNuIvqSIGZ01/ObUM6nm
         obhD8BUppnRyTxOW83LCCRe6K6EPZVD3f+d/sCI90MvFAJfV2QpU8X3aTu1UILu2fhFj
         e1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392512; x=1777997312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9o5H0O8dBnbcBaUn3Ic/j16+H1InseCGstPTG4iokWY=;
        b=sMSieCDxCdCJDVnKL5NV6qhk5Xd5rNFmMEgmQf+rFCY379DkwE6q+oa4rW/1asgax5
         KKQT4Fdn4hAtFFJxQNDIOkUHKivq655Mlklg9ahCteqECYc23uw52NC0arhPjJr2HHl4
         ar9QZ6KUMyxZnF+H3qO6o041nzp8E34jOx73iqBpYhKUWFnRuxH8T1OHAMQYWU63TqDF
         HXwzu8QPk/QaMy6p6drGBRlMoG5HkVAucWWbD45xngoRnKu/nbCs8/cVT35weiajq9PT
         Fl2uL0DwLSNIsNTngPHU7EpglB0aOgFQmEtcW3/WnqMC0LRzW/8LHGMMtbZfvUvqUllV
         lDSQ==
X-Gm-Message-State: AOJu0YwhFZuZaZweEV3+ybYe50NhUVSD6YNYgXHMZEyVjz626ecL/Sef
	7/UO6Cb3/elpLMnd9NqwGMwmkxJKxwhQpl7FBOZRde0f32lFRv4vwuGX2X3RHgG8Nrk=
X-Gm-Gg: AeBDieuWeTeMl2RmVSQKBH+LjdXZe2ab+0n1QDPg52hWV2W1KXtarWYqJ+7xy9bPea8
	hCD+cNxUusDnHC7H6/Hdz5QcVFmpjecu6pQ+HKFjcpoXW0CHpe5/ITjLrTnvUu0EIdgYQMd8cqf
	ojeerOOkSUa1zw+z9bAW36KYfdqIK+BzcMWjqZPEAZFuIZz9l1ojeUI1CVdpwavEFVyEnbfLIq/
	VngJyukBKeIEGJpbzp3wErV88+Drdf1NG6VoVG9uogzDAJ7LBZKCU/qYkgrP98uyWqwQkYmBCq7
	C3mWW5+SD+9owy5HseyWQAocsQFYr69XhykxULJgncaE+oucWUYFVcurrptT0Ra4Laxl6dNBsq7
	iDv5rKG3tNoczZs0P7d5ShkFLzVcmFY1F9M6Dfm3ErJ12kYYMwhtlQ3w9U6LStbvBsxmKKsNqIO
	KLInDjSWunZ+gq2YyF8bdI6CjXrTmzHiXBWsLABhBjpLB5tIaZ8T9Xosg0+A3FUktT5lhvMPgz3
	Ao=
X-Received: by 2002:a17:90b:3b4a:b0:35d:93ff:284f with SMTP id 98e67ed59e1d1-364920415a4mr3871540a91.15.1777392512012;
        Tue, 28 Apr 2026 09:08:32 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b97ac7894csm30864465ad.50.2026.04.28.09.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:08:31 -0700 (PDT)
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
Subject: [PATCH v3 14/19] cifs: option to set unlimited number of cached dirs
Date: Tue, 28 Apr 2026 21:37:59 +0530
Message-ID: <20260428160804.281745-14-sprasad@microsoft.com>
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

