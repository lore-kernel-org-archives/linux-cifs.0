Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E9F3112A5
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 02:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784860574; cv=none; b=kCVyGfBYqMfYuLyhwiEcUJKurP8Qh6X00ftfZMfWHPETpT6VYf5ltnbIi4aNmeS9Y5ELQEkxFT/oKPE3qAqvWOonMcBcIYLNElySkZFHQ1grHQEzHuxynTJnNKj9KgeGTFnx5Q/5u5WPxev5+b0Yx0nWiDxUJX0aDWVDPwO0A20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784860574; c=relaxed/simple;
	bh=olPxujuYkEW8ok539c4p0l5U2j8JwhQTnj/MAOjfLW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RpogmQs4Wp8/IbCJOjqpFZdSxi/hduKo0DBQoiCAPIqREtD0r2q+LKEUQ8Gv+WnHYzejDAjg1BUz6ZaQl5lVMO3vFHjN7A8sIluADYFo9a7gQm1SjztVO2anG67uUJQ7bzJhJ8UVRODRc42jr8/WdZJsuLsl6W+nl+701B5MzR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pyhQA/ZD; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyhQA/ZD"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c2b2c9eccso13233871cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 19:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784860572; x=1785465372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jPRPDODK54d+U5KjdC02Y68fkYSuUcD8QWj3Elue670=;
        b=pyhQA/ZDzdoxCfvrMcYmbptJ53ypOoJ7yuUC0kWaNdWyLZTHlxzZ4JKEC6Sb97F/ho
         ysmqMaPSf3P8NgconY7RyLRdNKSu+XJBkaBuw0vrZDWCJ5GmfYzooUdcNRkzDn/x0DQp
         1j1cwJYkMnFu4buNc0FCXlbF8ox6CsD+aPobxfOebjqnA8SZLTXQHwWdKdS7no/Vfl7Q
         zDTDBFszf3tZg/sAU9rPtgOxAjivb282cZSai9XNkBR0ueZVbGTC49zeB865eoVStTJs
         vnm6WLue8mDYkPwJ3UJL0F4SwXWHT56hpyrQRT0RXXjjhB7tvCgTTypnrMaWvjUwp3SQ
         tNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784860572; x=1785465372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jPRPDODK54d+U5KjdC02Y68fkYSuUcD8QWj3Elue670=;
        b=P8+hM4FfMhDAQK8eKrny5EWEhsGJoLSzYZyk0M35dzL1SnBcH3SNkVYNBtObwHArxh
         WjzFDGwvXczuZ1ihU83XB6n9+LWSOBLp4lJD9ceT1Mb8Z7Ek/hQSKoaXF5kudjpK5eO8
         Vb9kxQOuEnEYYDwqoQqOd39C1SbDPMZqcevzKt2m29KyX5QNw06VTJprNhkDa6lyGBPb
         KHHgA/5bnd+bI7n+XuiCgg2m3gxb2nSsf1+IiXtml2r8Yx4cXaz33xqoZcwjJB8m2xTF
         ZwIcLlRnujG/ogtTetR0R1DarH2H2c9Szd5v7apNmEbRLwLgnSMTcNgJdeLgpFtURLJy
         PCaw==
X-Forwarded-Encrypted: i=1; AHgh+Rr6MJwJaGHcNPCCFkP6LWchgDJ3stcGTQhwbkbw16kaVEp4aBSsKhV/BFR96EaXyiO3RiCof5Ryf0xf@vger.kernel.org
X-Gm-Message-State: AOJu0YweWvh3ATiZS2bvCHvvWn8Isi1vZris3Qbw9QcLeleG84fBc4M/
	I17dOiOMddNJhe8QwTV/74bsBdTyqHrRKKlujQj4DfTr5HuvRjVqbPOl
X-Gm-Gg: AR+sD13b2Byt8C885ssmKJy1r902UUarNhZqdV2mCJe2noKbOH03EXs+GVr66R4T+kX
	+w7LnTcRKXadCbeNR3ha5KVjsUEfc7KI86FSXiltQazLAcgp3+KFOGiZK3CSfkJ+SSDjAUpa4si
	YBbqpIBzaPl/rl/0rJzjgMyBxaXWnGXsQVSnvcknHe8Rtqna9sk6mPDMLBKqIBbkFGWgsoNPc05
	urvxGAYmcEygFexDsAxmCfXc2cFF/mdK8qs28SsNP/YJr3thr/suwj0K2k/Ryiqg3j7hDucIMiR
	5+IWfQrOkdRkwB5D9XEfJkDJHpgT6WqvusJe1L6uDPh3W2mEUhJ4zoIh/zSFvV5kxMTvoAuTvvA
	HSS4gxL7a8fgW4Mcq4q5zAJn7YshOd7PN+v49MkKHJyXlmwN8tUhG17Gg5w7nCIgBGcfOPUWg5I
	Yv2tgjrugHqtu4/gc=
X-Received: by 2002:a05:622a:106:b0:51c:1fa1:80d3 with SMTP id d75a77b69052e-5283df10f33mr58127371cf.49.1784860571755;
        Thu, 23 Jul 2026 19:36:11 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:fed0:9b59:babb:80f6])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0f4dasm58223986d6.41.2026.07.23.19.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 19:36:11 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: clear ce->tgthint in free_tgts()
Date: Thu, 23 Jul 2026 19:35:39 -0700
Message-ID: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When free_tgts() frees all structures in ce->tlist, ce->tgthint
is left pointing to one of the freed cache_dfs_tgt structures.

If ce->tgthint is not reset before it is used later, it results
in a use-after-free.

Set ce->tgthint to NULL in free_tgts() after the elements are
freed to reflect that no elements remain.

Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
Cc: stable@vger.kernel.org
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 8cd93cd2f00f..451550eb4023 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -122,6 +122,8 @@ static inline void free_tgts(struct cache_entry *ce)
 		kfree(t->name);
 		kfree(t);
 	}
+
+	WRITE_ONCE(ce->tgthint, NULL);
 }
 
 static inline void flush_cache_ent(struct cache_entry *ce)
-- 
2.53.0

