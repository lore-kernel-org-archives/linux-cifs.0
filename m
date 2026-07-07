Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A1012B94
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 20:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783455367; cv=none; b=B8PPFhC6VmbEaob3UpI1fhaDF/h0VKLf8GP4Ao7BqH+xfNx65IXVHxWpb8LJaTKNK3BjPpMhRjHc6Ql9OYGkGtLXHEAIHTDCm03SpOZqutBBfZfxcv/tDiXwTzjfIS63s1cJy+xgpo7C9ZhvhhxGri8wrU6G+nUaDsGpmxafPTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783455367; c=relaxed/simple;
	bh=GUu1CcwnyZXwBDxzXDD4wgD2y2O3kU3By9aHPIwlNjE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RFGNGQ+53io03SA1QY7vZu7SOmJl8lPdhKlMf60njdsc3jV202JKE86m4NFAeQPfvALSiut/qcYHCpZpLknTSlByjac068eee4rbluigl83Sx285RILCDPFPAXM6KEdB4msvd6dZ88icc3SJZDPSFbbLf1VPF7XeHLHYvsNBemg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBpcS0z5; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBpcS0z5"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30c965eab27so28136eec.0
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 13:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783455365; x=1784060165; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1xC/vjWp5VOBev2gGqHZAevHveHtDjkFqaNJAttQCvo=;
        b=aBpcS0z56f/F3OxgeqATYydOXUYvi/MhTBGPQBqVL298xRkkwrwo75HEOlCeg7zjyw
         kN2KdBPnirWMAbkWtKJkik8Hzgzae2ehuSjjF8uWpmAD5JqJiV65GezgysBw3OfnBt5Z
         G0kUrGcvU7TTDXF0/zXDEz0bgE1xKl/jOWoK8GfVX7QQ9TWwBrfxPrNCGpnyjqtry6OB
         21QnK5lE4ZRUkk3wTuNt5AKkjhQPyUBL3bpRecHX4Tdv5Hl9ueLk0NKbIrQhDmn6miTK
         mpi1f/U23tN1fcFnUS/DitpTnjopw7ipsR7GwOIPcrWkE6IwtNpMmwBgdSoaDr8UiEmp
         GobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783455365; x=1784060165;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1xC/vjWp5VOBev2gGqHZAevHveHtDjkFqaNJAttQCvo=;
        b=NR/VNPt/+810K+WnseV5qIF+djIrtypXgb1pByp6KIxfWk3CDdDx/IXlrgS6x0FKOJ
         b7lvUK7cqvTOFCl3TujOXYlJ3gsrgxA7Wfnj7FptIa336dI0dRT7MIWQGIstXau7qAhc
         +QlTdRzo1SXL2m7fLI7PoZ1FTTXrReePPvjmREBwNojJ3QmtgKt2wHRNeiO3Nth3Ex+1
         77r39NK8V29rcUaX7+3rvHya7o3YNpQtqenSEFudMcunfLDFI9ay9O4F91GipVqojwEd
         TwBWTZlUFONM3YtIBbxlzmtqIzMyRbfLY1qUPma1nNYA28H5TAiSK0TioUQSq0jkPB3Q
         Yfmg==
X-Forwarded-Encrypted: i=1; AHgh+Rou7ZmRSnT3hcbEIs3L5GRH6BMHoDdpefCsxCCB8EYLb7CYZAFmZiKRy31Ah7IpP00njC+i5hP+wCPG@vger.kernel.org
X-Gm-Message-State: AOJu0YwufyqF5BADS4iVR6XcxfPs88A3IOlasYXvw8rP43dVgxlM3Q1x
	lFQxFc5n8XmkfLBktuZ0ix7JH33Omy2iwg1Hc+QF4GHRicH4vUZFUcrOJrkovA==
X-Gm-Gg: AfdE7ckMMEoi4kOdaPiLqpakJD+mKvZ6TMN/SPbGPVEdN/P4jDrWHdeyAccVeg7d/s3
	ck+GkHix2fG/8xMtsjFx25TdP7i3X+0MzMTCi9iaR30Pl9K+9jKhDqV4XZUiT/4rS+8g+l0ZKDx
	Eqqlp85w/hx4Vvy7MFUv49JPD/DEpxHdG/ca4ThRJW0UTGYpuxVvtfZfRQCNWxQ+wiZvX9l8pQo
	rcGhNjS0AVbeheY1FwTAfYk28ykhDjDM9sj8K4TE6OLIu7Ia+u/3OZzSTv+W0/fVECs4FTWjjxP
	m7tUl7VOtVBQ7OSUOHABPEhFU+71g3/hYC9z3zXSHL4HklmtHZrTeL28bP/EI/yAZtUwNqFb9eO
	3Op3ZvxlkeTVTwEc49sz7kT+yXB7j0GdE8Lav8m7Yim79mtnJUvacns6mjN64RHFUKXgVeKcQzE
	Q7h/OEIHmzgMo=
X-Received: by 2002:a05:7300:a507:b0:30e:be3f:e7f4 with SMTP id 5a478bee46e88-3116b968ad5mr56470eec.9.1783455364889;
        Tue, 07 Jul 2026 13:16:04 -0700 (PDT)
Received: from FredPC ([2600:380:8034:4833:1820:b099:c590:4c7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311748394acsm11742196eec.8.2026.07.07.13.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 13:16:04 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: use GFP_KERNEL for DFS cache allocations
Date: Tue,  7 Jul 2026 13:15:26 -0700
Message-ID: <20260707201526.33733-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

In dfs_cache.c, the helper functions alloc_target(), setup_referral(),
and update_cache_entry_locked() currently utilize GFP_ATOMIC to
allocate memory.

However, all of these functions are executed in sleepable conditions.
Use GFP_KERNEL instead, to reduce the risk of allocation failure and
stop putting unnecessary pressure on emergency memory pools in
low-memory scenarios.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
Compile-tested only. I don't have any way to test DFS code.
---
 fs/smb/client/dfs_cache.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 83f8cf2f8d2b..44409ba44e1d 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -363,10 +363,10 @@ static struct cache_dfs_tgt *alloc_target(const char *name, int path_consumed)
 {
 	struct cache_dfs_tgt *t;
 
-	t = kmalloc_obj(*t, GFP_ATOMIC);
+	t = kmalloc_obj(*t, GFP_KERNEL);
 	if (!t)
 		return ERR_PTR(-ENOMEM);
-	t->name = kstrdup(name, GFP_ATOMIC);
+	t->name = kstrdup(name, GFP_KERNEL);
 	if (!t->name) {
 		kfree(t);
 		return ERR_PTR(-ENOMEM);
@@ -626,7 +626,7 @@ static int update_cache_entry_locked(struct cache_entry *ce, const struct dfs_in
 
 	target = READ_ONCE(ce->tgthint);
 	if (target) {
-		th = kstrdup(target->name, GFP_ATOMIC);
+		th = kstrdup(target->name, GFP_KERNEL);
 		if (!th)
 			return -ENOMEM;
 	}
@@ -760,11 +760,11 @@ static int setup_referral(const char *path, struct cache_entry *ce,
 
 	memset(ref, 0, sizeof(*ref));
 
-	ref->path_name = kstrdup(path, GFP_ATOMIC);
+	ref->path_name = kstrdup(path, GFP_KERNEL);
 	if (!ref->path_name)
 		return -ENOMEM;
 
-	ref->node_name = kstrdup(target, GFP_ATOMIC);
+	ref->node_name = kstrdup(target, GFP_KERNEL);
 	if (!ref->node_name) {
 		rc = -ENOMEM;
 		goto err_free_path;
-- 
2.53.0

