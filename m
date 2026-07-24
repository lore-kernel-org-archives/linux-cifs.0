Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B42B403E96
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 22:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784930536; cv=none; b=da0vO4KGiDmqF1pEhgENlE7G8vzk7bEX9bcgWtqlb0DDlTHW1zyuv08Uz/laqiE2OCVrfU/WfqwEukZ6n0Hz159q6vyfn9URaV+rCoh9GQ6rHdNnINKsmE8CrGwyQwa/Mh0COkIlMGHEOZTMeiR6GzWgN4enW0QxNwh5gpw1StM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784930536; c=relaxed/simple;
	bh=JOTMTHvNXNnDMv8cbytpWkBwOfL6IylIUcituYRfXKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rp57JCloAA8oBK5E/Gzk7GL9vGT4ywL7ShzKU0JlWbE5FBw//2L6CGd260+W/pTqjyam5rowh5nawVdDzcNJxUzctC7ZePLHBBxWlKrABJyQ/Keqz+GRJTvgeiaDe06O0d1OH0GHSaP64TB1FtyLlv8Gz46ckUgE0TU7WjRepks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gd7CVZgy; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gd7CVZgy"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51bfa429aa6so17993571cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 15:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930534; x=1785535334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P1VNwYcQpb9WDj6KVSyLpNd/oPBMCMFNw+HEtq66+P0=;
        b=Gd7CVZgyCqObZMuSxTfhDA93XhEUZi+I0GAWp7DQCT++bxrPkJsSFhSzU2UYmFoAYP
         o8uM33LxEemyXTm2fjLDUvvBtg8mFB966x7y3+FW/xxhuU8fqUHh1krozohDx97u96RW
         kTlE35fx33BM6bbTSAZlU92ae/UmH9nB/9G5BAiwk/knXPSu5TATrAwP6pT6NoPggK4l
         D3zTq1t5Jd8n6UbRqNKlDH1qzeqL7eAOCJthE5pxIK4vLnt0sZD9um4dFgPiQtiBpPaM
         ms3+1F8u3gD/UH6nXVXUAfAcfWsMpMkthVMLMP4pD9awk2pQe/waB7l6H62ftkSBSbXW
         nKlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930534; x=1785535334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P1VNwYcQpb9WDj6KVSyLpNd/oPBMCMFNw+HEtq66+P0=;
        b=GjUcyGSgbMglozg20dEq9XPiSNf7GL0Cdm6tLV0fgR9LKKBOJOkWWypvMSRafQ/MbX
         Nkz0IU+Lv9tJg17QeZFz7m9jkdmDr1sQHMP7OPJ/uwQ9YMy5nWHOVQyaKTAscM1Vo0Rc
         6Ika3z9ajnbHVCOSIuSi7/mzXrYizpHc0sELZSBtOrGkY3IEbmfphTcrElHWF9707BvI
         2dH8rIWe9xY5SSMWyrwP6s44PPj3k5R5dnjnJhtJnIwB23VFU9/szm3CuV7bnby4haEn
         eIGaYqfDhe122nqHA3qP/Lw0Eja8FrDPIXwk2KEBZsWBjUJXGM+OWA1/wplPWK+RLB31
         P9KQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr49nkp6UqphI+4uUqyg5EdH40rb6ijDYzKZo7uBuRMG73Wd4t4hDF1bIi5CXofb0t5+scxfEf7+nBM@vger.kernel.org
X-Gm-Message-State: AOJu0YxImhrtNN82F1Be8Gd3RSiwAwIl7zxJA67lpX5NNgzqwusgFsSc
	KAkDRmJJFGpVB8q80PLCVKwLuxFEQgRpvc3ZSufMoFFyxG1LAZDGTc1V
X-Gm-Gg: AR+sD11GbS8hKkHuhCxHr2Rztdm0gtGBDo8PfiA39ENzZXx7iqMmg3gVnNpBylmNMhD
	Ofgp57srMaqqvKbnQJC7jQ2AHxC1vfMAtLaTOaSLbCnPo6/M52CelNX68EyzidwtHAFNOa3AWSR
	91XCLOrXA7o0M7RGC7Cxvu1q9+A2QxFF5NHG3biXX1N8FtjRQKppda/2dI4t32B6TPtrgWcBzxf
	Svc79Mk1z+h1XZX2KHq69OTnTocLAy4pjmW5n1/Pp+70zYH+tW26KtcOeOznTt6ZHY1XLBxdLdu
	ujGKpuQAN8KFPkoQc1TW1Jb9MX76zQ+XnTI0XmDbq+Kge0+rzxwhlqi/xT1NuTtqYqOvHQLfRXl
	EtBgKLD/BivLhdtIrSdTFySZKNbfGBFO+WmG91xv4dKGeCRcTWMp3Jxi839IZmrDFah1migCkn7
	FSv/07ihZ/J70FvVQ=
X-Received: by 2002:a05:622a:2614:b0:51b:feb2:3827 with SMTP id d75a77b69052e-5295f32b6a5mr29099041cf.32.1784930534076;
        Fri, 24 Jul 2026 15:02:14 -0700 (PDT)
Received: from FredPC.lan ([2600:382:311b:26:c204:8bd0:9563:8b5f])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529a27f68f3sm8668631cf.9.2026.07.24.15.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:13 -0700 (PDT)
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
Subject: [PATCH v3 2/2] smb: client: clear ce->tgthint in free_tgts()
Date: Fri, 24 Jul 2026 15:01:46 -0700
Message-ID: <20260724220146.1859170-3-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
References: <20260724023539.1596955-1-fredric.cover.lkernel@gmail.com>
 <20260724220146.1859170-1-fredric.cover.lkernel@gmail.com>
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

