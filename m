Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E30E37EFEC
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784929629; cv=none; b=ZwHGm+/O+6gAfTlWlaCf3hbP0RQgkv7vVCA4/8R17t5FDtaTWex/bYftvDqmm+SbTo4GA4hybbp8GXXusljdQz5w2wwUrQxmjVqr0QV3pSzGMkfmhjRrkHfZ7igeeUPiDz503WOgXxZAQjPThFKS21qQ44Wn1umaahOl2h0pPcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784929629; c=relaxed/simple;
	bh=JOTMTHvNXNnDMv8cbytpWkBwOfL6IylIUcituYRfXKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/IDg5uuIHsv3ypYwH6diotQZDbq9KIHqmuqYN1L61p9gbonq4h+ZPfVPEa0OHzCktjVB4CPispt4daXO8gmXYgt0RT2aOnn9tBUG3UAR33mgb/9m7105iYHbaeMsR2gvLQN+InYrU80gSqjo0BMk+bKgvUFMB+SkBTHtWqW3wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FhG50KbA; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FhG50KbA"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c5382806fso9281001cf.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 14:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784929624; x=1785534424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P1VNwYcQpb9WDj6KVSyLpNd/oPBMCMFNw+HEtq66+P0=;
        b=FhG50KbAES9Xcz+clA+Gb9RhVhvutwyqW+sG20+rANtAZHRZ21l37d4BPqx4BYMd9p
         77RGJ112PgEFIhUV9jqB3JtfTBgNH4QAXGkTIAcY0312ualNEcPsI1KxYD6QNX9i+0D+
         moLDoCB8Gu4r6qHDGX7d/7HAkuubeHSjD+VwnZI6ihr3ebjcZu2+05LVZ9e4kSGxDKRH
         MwK1JkcYU0hTDx0pWWR0B6JVTKzFmM3g/uLrr1+O0WNaN0na0zju/p1c1gaaVppgCBii
         zt7+/lBBKxkzyljSFeHFlFiathPwxVdFtAE/MIsMa8XP5bKYj9ufHHM8LkdwcW28NBBy
         O9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784929624; x=1785534424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P1VNwYcQpb9WDj6KVSyLpNd/oPBMCMFNw+HEtq66+P0=;
        b=D+HFdwDCSzsE/XYYXgmxm9ICZlBsHgCILXw9/EudHlh+Ks9AO7BoDKkHI1+oaGBzOl
         Ez9SQfKTr/gB/8zg68TVXEpDPlh8dN2bqXkqR1Tfo6I1ZfHDbfYXXE/RPz8O1L5Aa7KW
         ykBJwWO1zr59D+L4i+j7gUR1Zt9igQtCHSvjn97K8sIsRXM95uJ/Hzpt2WmFabLZL90x
         CmyGwVmWi9+3IDw5pdUhnDgV8PD8f4p2yq+zmhWsfnB8IeCe9qq/J7jINgsyI+mc+/Yu
         sVg3JJ6a4MUYwuMv/dCX10Kuy5PQDLLz5Cl8y8nRPdsqpQpoU+8XpwA8ALUp2p++b0GP
         P0sQ==
X-Forwarded-Encrypted: i=1; AHgh+RreaV1YB2VyJ5yx/2WdTSYDO9iSjeuGhkc90bblh7bYG/FGIm1Uz6cwsfRc/YF6YfKzNbGS7hjB77VD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx87THgeajF4CVKyhnw1NMLVzDXxPojYyBRPwKv1NNSRMgtp4/t
	DFS4KAj4Uxh5xKbeCSAfttlqq90LYGgPC3MyBJBYmYEP/DXwsExjIRYf
X-Gm-Gg: AR+sD11qQcLn2YaRUsjWyll/PhNaoHYoJoacTfb0OKGsC59ON1dNHIQ6LTUOAbdOswf
	8v4Fe8ZXHxfPAhU1cp2DV4uShybdLoU9F6TzI0mqRXAuVaGnMnGTncdliw2uOUGSaGyu8FGrKwi
	f8V8XGWobJY4oXEImaLqoxA7m+S+s4E1n6Oh6PcsdOanRM8Gnc14pRRlu3vMklX/JaY8cJ8Rbnj
	D9tWyiAtH9KHneDwMZBihmerXzL+29HFwybA3jl8VO6/5xKAkkrVXwIz07mWcOonbfdxB/dcwnv
	pWqIASin21ii9/dVgwSAC5c+rFqMeOPm3FIuW9myBCTTtayamDtP1RhsW1u9tipnF7+PK4UuBom
	xZoE0/A/NYjVvPoPQm9k5hoePTVP24crIDCBHKNKPIhz0bl3gw/3UMmRlUdXEOy0S8Q+iDTVbh/
	6B6FpEcs6w2cIjgArtqz3R+irS2A==
X-Received: by 2002:ac8:5e51:0:b0:51c:1568:3a53 with SMTP id d75a77b69052e-529a8337825mr1442741cf.16.1784929624076;
        Fri, 24 Jul 2026 14:47:04 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:c204:8bd0:9563:8b5f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a29cf785sm7916771cf.21.2026.07.24.14.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 14:47:03 -0700 (PDT)
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
Subject: [PATCH v2 2/2] smb: client: clear ce->tgthint in free_tgts()
Date: Fri, 24 Jul 2026 14:44:35 -0700
Message-ID: <20260724214435.1850384-3-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com>
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
 <20260724214435.1850384-1-fredric.cover.lkernel@gmail.com>
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
Cc: stable@vger.kernel.org # depends on: smb: client: harden DFS cache against invalid target hints
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
 fs/smb/client/dfs_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index c9ace4326a35..86dba25b7a5a 100644
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

