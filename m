Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DA62836BE
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 05:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776834394; cv=none; b=THlzMi3wGkZrSXqXuZmsforfOCzskswF5Uq/K5xwzbzgsJmUFuMyIEJgUem7xepz2S3qgNGQe8eWh2ussmQY/EDR1CM1sGuBlWhzmlRM2D1iWVnAGX7xKiCYhgVjcyMss3dChyEMYmOneWXNK2naJih91zx/unKFvZ1ZYT+xLZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776834394; c=relaxed/simple;
	bh=8tqUhDwFGwuXjqhe2jM986k6o+3Bby8a7ng6Kt/J5SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADA5MgHNekGoPzvPse+6AnX+Z8+Q4/zDMYJ1resDLdD+cZfNK5d3rSL3dSMIvJqviRNZ0yL8VHa/LFMl0CCiOHdV84bJG9Xz0VudQdv3rla3g/zx+B1NFQ41GcL8eEzyiZTkb7lvO5CL/ShainYCwkC5UieHAqQupZMs6vtBNhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBo6Q+nl; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBo6Q+nl"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82f8892d4d6so2183802b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 22:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776834392; x=1777439192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TF9vfIdTBsK1gXD903+/RyAA96pAo1Q8ROFs39JYctc=;
        b=mBo6Q+nlBv4HqSzb+ASvh4H+Jdfbg7VXU6z3MwR8lNH7Youm4uunBKLOgSieO2M91u
         H49ZX4f8wrjpDXTavID/nkS7Z+QG9gFz2/NZK1oNdULl7hTbp4fB47AqLp5bjjAXrQFW
         iczfB86DIgFLsbazRJMV3tkP5/4DpSBRnC5t9xVDi/TUNNHmsyXJw1dJawaRuMNSN8Uc
         EhwialXBRVHnsGeTWDnQWrzX64xfxC4ZqduCOq4iQVX1ICANoM/xK91ri7jfXbbDkVxH
         R6WgOOcJkr1Rk5Kr+Y9UHYt6iM8Mm5KmtDMEzcPJ8Bnk4o3T5aXgOFEJghGHFvbPNQvr
         dTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776834392; x=1777439192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TF9vfIdTBsK1gXD903+/RyAA96pAo1Q8ROFs39JYctc=;
        b=kjeD07sW8b72nMZsE7mD5WsryIb/zOZlmxcOHI85dcyKM+0n+krCA2vAeFVjv6nSWF
         BbrL4CjJDk68I1J+lRt5hiuQ1jrXlCTnEZpVPgzrPF1ai8PZZp3Sc1B6ewmyhcWsUWWl
         4LPQ9UqU34mYy9Ru4CsKQ5ShliuCOzVE4ZEC+sLoqirq4MrXuklIW/bOlXrCg375fJS6
         ml33TxWjY92eGBmGJDHoMZq1aAhYnF3oDC0JAXf5PyxEFGWojvXWkkdfc0Tmz0V26IJh
         LyH3umKowBL1e7jFNExeVNZoXcYvMpsfctejvKIOwV6fsZ6OVppsWOPeXKQCvIVDF9Uu
         +85Q==
X-Forwarded-Encrypted: i=1; AFNElJ/7cLba2SpDeeam8TTXCnCETFk+r8A4OcL/PpqCJZv60qO5xKXVd10mt33UrPjn6yaQDF/E6p3L0PHY@vger.kernel.org
X-Gm-Message-State: AOJu0YwgKpD+vDRX8jr9/OJ+Wjmlms58WhrrWrXgiU2c+R4Nnn+hVeGy
	0/cYzoEsph3u2RA5nDuxtF+vh1/H0CQ4HH7Q4vQFn6RUa+xVpI0HTnQE
X-Gm-Gg: AeBDiet9JDNn3ZCzhKN4VgBsVk/O0i80NWrFZUcN/xmWMcYSQ6xHMy8VkWTWDX98IO7
	T8Agty0Uqrh10QBf62eT28mG96AvvqI+wOktz/4jXi2psFESKAN2IwAGK5Jf+6I0DNqOVrI72C7
	MwdqNgHX+c/+M5ZLA7swmm5v03z6+B6RtZrQinTgf91Zp8caOHzX9qwaexRJHXD3Z0qQDtu+iGZ
	yP+JL5wBz7UvRSBVGJxPPBB6mL51mZ+CU2yelZ48cZONPntiPiOdUldS/a6AXWfzOq5grUjV3E/
	/m6Lcerpch+50pxfl9vwKi7r1FgjBn5lj7oRmaYBXwSTSGwI+qmwDCRNQuhGFs7HLex5xSl/+rT
	bo1xzspoNiS7LDP0uIP70yCfvaPgxmt7PhrWxp4hz2dCPgu45y6SOk66/mLnbh1ZHTv6Unq509P
	WvG6MWKYyeKkO7Rlm0iir5RqoW04yQKJiIj+74Z5pNIdsFK3UEfPYaWWnhFrcudZXeDIT2EEwju
	rdglnQ/0tmg3DoO2ZRNleDUybFLMeL2RA==
X-Received: by 2002:a05:6a00:bb84:b0:82f:1d38:f693 with SMTP id d2e1a72fcca58-82f8c8e0f98mr21053083b3a.35.1776834392581;
        Tue, 21 Apr 2026 22:06:32 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec0307esm15854271b3a.53.2026.04.21.22.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 22:06:32 -0700 (PDT)
From: rajasimandalos@gmail.com
To: sfrench@samba.org,
	linux-cifs@vger.kernel.org
Cc: rajasimandalos@gmail.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v2] smb: client: allow nolease option to be reconfigured on remount
Date: Wed, 22 Apr 2026 05:06:13 +0000
Message-ID: <20260422050613.1136327-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260409095926.905020-6-rajasimandalos@gmail.com>
References: <20260409095926.905020-6-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

tcon->no_lease controls whether the client requests leases from the
server.  Changing nolease via remount is silently accepted but has
no effect because the value is never propagated to the live tcon.

Add no_lease to smb3_sync_tcon_opts() so the flag is propagated to
every tcon on remount.

When switching to nolease, close all deferred file handles via
cifs_close_all_deferred_files_sb() outside the tlink_tree_lock,
since closing deferred handles can sleep.  Deferred handles retain
active leases from before the switch; without closing them, those
files continue using lease-based caching despite nolease being set.

Both transitions are safe:
 - lease -> nolease: deferred handles are closed, future opens
   get OPLOCK_LEVEL_NONE.
 - nolease -> lease: future opens request leases normally.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 45173f287f00..fb59b45c7f66 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1317,6 +1317,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 		spin_lock(&tcon->tc_lock);
 		tcon->retry = ctx->retry;
+		tcon->no_lease = ctx->no_lease;
 		/*
 		 * Note: this updates the limit for new cached dir opens
 		 * but does not resize or evict existing cached dirents.
@@ -1325,6 +1326,14 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 		spin_unlock(&tcon->tc_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/*
+	 * When switching to nolease, close all deferred file handles.
+	 * cifs_close_all_deferred_files_sb() handles its own locking
+	 * and must be called outside tlink_tree_lock since it can sleep.
+	 */
+	if (ctx->no_lease)
+		cifs_close_all_deferred_files_sb(cifs_sb);
 }
 
 /*
-- 
2.43.0

