Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31567283FEF
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776194141; cv=none; b=dxA2W7ULJ/P2znVhTUTeKGGCjNca80HR83oa7PasX5mbNxVCLsrFplElbMSm0/Dd+wpUHia/IUcPr5tyQK7PSiI4FeFtitqW8mkc6rNIHNW0xHNCYPjC656gkTyMd720fS7gg0rtiEfnpXCRHQ6MoNmxVkwyynXX2LWBBiC3jgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776194141; c=relaxed/simple;
	bh=I7ZPd6BYpji+HeA0FutzbeEHhoDVteznmPpu9gEGUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pT8TEw6RrZrmdabxWLHpII70Q6kzwDxS1xJIR0sXR5uuR29KshLW7Bo0x3vQQRUAWOgXxOq1I3VFTGZhqy3ONepLbNoHBXTeYWLX5gNSiUxVFI/p5ios+ktrolO3Z6SiCZmuZdHsd/xcbPbN8PojmrsfdLCK8L8LOlH8+fW++1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FX7CsWco; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FX7CsWco"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-89f1e767f92so47882476d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 12:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776194139; x=1776798939; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=koYFiagrEfQMs7bgNuUQ21Zxibgpf6kYEiIIemViCQ8=;
        b=FX7CsWcoYyxjgsun6VL7si4tj/S0zOFXJyksWA662F2hblqvLBemKSOlOyCrOVpDs2
         b79AWQ9PKXnHoXSH0wrvoJBFfH+ZMUa3KSYDSQ+6yI0YmTHyHhBwT3tVyaTUy8DYp4qC
         cv1Unpn+sVaDXZHgeddXHKv4RClt12GVRJAZRoELhMZogWrWTItY3gUGYH1gEV1SzPUV
         W+UL+O2950oHh6wn+KaUMQH4a0TsDmFavoVSq8nY0vQvqUMFQ4L/WzFqPTlazNx1FKMD
         ruCAukqxIfAfbL+a3aL92+qLBKpKuUC0nSenPC/nGYKmQjhqqZ9so0Ds6jGJuQUIM9aE
         EvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194139; x=1776798939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=koYFiagrEfQMs7bgNuUQ21Zxibgpf6kYEiIIemViCQ8=;
        b=NuBq/C3fwoiFRrVP9LMSgAaBf1ppJXtXzE/h7+JCKwTE27LjQZxiRTlyHmop0gLBet
         WnXbq+g5EY3zZR/xuNrlgBjp75kjBWCuAUsR8hbsfX4vVRv97nzbIcIzmjBpuJiuxNxY
         grPNHxnRh8Jy6+BDnd+6000OMlkpAMe2FippgPEASWYgOUa8etR7vL7TiY0kSBWvZZyC
         uTwGfYQuzh5XrZ1/URyz9IBg1RZ+e36iXucAdi/1UsrHbDNfbUzz+XPf24wpJMq6uCal
         foGx/66/0MX1au7sr3ojpy1oyAXQ61nvATOBX11KLwin8wHgJ3SAwpwC7H8zWPdarRHS
         KAHw==
X-Gm-Message-State: AOJu0Yw6Itii/2Z289xS7Ln+2gmF2AJKk3HXbI6k0wZBMCnVS7kj1ezt
	TxWFIk2EEI5RYSgwmxWE8FD2pEquITO9SKJ23VxM3Tu/Cp4+nw/VulvwaUUjT9pm
X-Gm-Gg: AeBDieuzwq6zKt426tD3Dnz1EdKxDERbRGgJnL8iEGZiOnKoEm43JOQBNf6kCej2dmm
	41af456a6mkqPlnCVGTjoJ2OZik10rFwk98N49dbVpzAp9FMy9mCqTke33vcKdAQWk/0kPNqjUc
	yGP07U+S6BA4aNmJS/maHQlWwNu8a7rjldEZhkzxp90q1y0xh7xTRrr0K9H3GL1ipSFI1LAKVgP
	Gw2SdGEiBp3Syz8ERK6tORMlF8Qq2FUaG3P+Zkk1Sq2j9BjlUOrHuwpNoa26GnTB8MLWpkGAgDP
	Yqd/E5q/49Iu8F79kpF7BaQ4jqiLCYGVsWmCWcrtRfSVvHVqnN74jZbzeou8EhsfsA9qizz2t4x
	t3USGBZGGe2qnQLT79HoTiOzt3YGw807EeiDbxYjQPJjqI5whHGs0Sgzcbl+MJftAH36JVaTLoJ
	8o0bJGUOAQwDrPy2UsXxayC2AvE9/WanEYJ2y7C4cBuMgzY8dvnawzGaq/Q1L8J4/0/W5vYplPA
	38HeUTq0VghVpIBWKXWmzeT5Yr4bGg=
X-Received: by 2002:ad4:5d47:0:b0:8ae:64c0:c922 with SMTP id 6a1803df08f44-8ae64c0ccd2mr36692696d6.46.1776194138726;
        Tue, 14 Apr 2026 12:15:38 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca478a70csm77229126d6.27.2026.04.14.12.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 12:15:38 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/3] ksmbd: reject negative ngroups in ksmbd_alloc_user()
Date: Tue, 14 Apr 2026 15:15:32 -0400
Message-ID: <20260414191533.1467353-3-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414191533.1467353-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

resp_ext->ngroups is __s32.  ksmbd_alloc_user() guards against
oversized group counts with

	if (resp_ext->ngroups > NGROUPS_MAX)
		goto err_free;

but the signed comparison does not catch negative values.  A
negative ngroups passes through into the subsequent multiplication

	resp_ext->ngroups * sizeof(gid_t)

where signed-to-size_t conversion turns e.g. -1 into SIZE_MAX, and
kmemdup() is handed an absurd size.  In practice kmemdup() fails
gracefully on the huge allocation, but the intent of the guard is
to reject out-of-range values up front, not rely on the allocator
to notice.

Reject negative ngroups explicitly so the check reflects the actual
valid range, and switch the log format for ngroups from %u to %d so
the bad signed value is printed correctly.

Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---

fs/smb/server/mgmt/user_config.c | 4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index a3183fe5c536..c62e2bf0ebef 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -56,8 +56,8 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		goto err_free;
 
 	if (resp_ext) {
-		if (resp_ext->ngroups > NGROUPS_MAX) {
-			pr_err("ngroups(%u) from login response exceeds max groups(%d)\n",
+		if (resp_ext->ngroups < 0 || resp_ext->ngroups > NGROUPS_MAX) {
+			pr_err("ngroups(%d) from login response exceeds max groups(%d)\n",
 					resp_ext->ngroups, NGROUPS_MAX);
 			goto err_free;
 		}
--
2.53.0
