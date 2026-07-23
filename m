Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31B34963DA
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 18:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832450; cv=none; b=FWiu9EPIrCcSZrJHGdiNjOXQsRnYbZQ0uJ52flbW4yURL/S71Gxy4n6Xynpiaq1mrW5LV5IDKxUAoBTDZSCHDsu12x8AYuB35HZP7I6Wqf/jSF0liTlmR8s1WcUlyvTl3CLRyIUnHb5FbGoZaVDxQj6vhlvEVOdGggZou5FPJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832450; c=relaxed/simple;
	bh=0THJsAe0GGadOigqS9gjiJwezmjYYlE4GhLoiWCj6bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fc3LTHL2gnSHprbAabKUYpJpjl3NV69eQTrCZafPXlIqYqEw/PzLqzC3FfWzgJlATTzZbqfO3Q8iaPZ2nEybyTuQPDfB6qbEgyMyWUOW8iF4Of3e7Z63l4usQRIVIkVet8WECkuiW2WJ6aDNCri8COStV0i4+vA5Fbd2g1+9O4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EQEIVisM; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQEIVisM"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso754499a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 11:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832441; x=1785437241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iwiokRL+A5T31Uey5wDHfoo+mp6zGabrAoF65o28YUE=;
        b=EQEIVisMEVzEoxHf1rSoc70u3qlYJGbqv8TJewbswYbYTmccAoY3xOHDZZ32ILBD+r
         Da6RO4tS/8NqOobZZK4Yca4Ux66fFR/z6M6WA5tKHr/+iv7Pi2XN2SHaci3hDCdD2Njj
         m6cJVRLf2SfKZq8xyER6GKP4nKXQXk9UueWLylXDQkIPfLHfzvByGC1WoRNSwV0RiHA9
         ARDlw1wijdnkIH03UiZK+MDgZ4CC1FRaI0qT/Bwu65BPQgsq0WxM8Y5Xx0PO4cvkBbjL
         LFWHluf0Hqr9x2vNKlFZa9RBOnEfvZEiIs5eH1iZtiZrVGDvM2m394FnPDahT+cmGiCf
         s2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832441; x=1785437241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iwiokRL+A5T31Uey5wDHfoo+mp6zGabrAoF65o28YUE=;
        b=gZ9zoyJqBUaMObcB8WCwAqf4V15ZMpsNkKfo3zPIlVpTl7DxgmrxeYcLxZABzTFI0/
         xZaIfChXFuT+KpB4cbqXxWQ4WA/szy2gXgLZjI8yR/Kck1wRqoBWUEhDj9ya7Bs+cNZS
         BDVLfQWGnumQiZLqxT56+L3bRsHBD6uIM7amr3T/Zy09r+vXt9qiWrvXLmoH/nwY/R2t
         RFn9686kN6Eq3psR+GGG3IyYEc/3ZXoNTU4g6RFtX5Bv00bHYg01P19xWr26g9ID1JFO
         hsMbeNW5aZ+t3BWX+1W17OFJ/9uTQZYkmAhj2dEGdvxV2/AoWVyHvqc62iVEzh/YeAZK
         vzrA==
X-Forwarded-Encrypted: i=1; AHgh+RrJvUP6+mY2oQ+1GJ6Vxy1YfFG/VEMom+jlzOPVbSoKqp0gkhdkAwQMWH41At8CHag0gm8f0dHJJsxp@vger.kernel.org
X-Gm-Message-State: AOJu0YydmdHlB5S5I8UCFXa3B73EleS8tN73jWYhiBgHZOCoLWctfV7F
	qPRLIzY7kyu1EWxuYxMReGFLBGL+PyQg8M5gCS1LLIxmeG+dWYaD+7lJ
X-Gm-Gg: AR+sD11ZF3HC7nCD9o3B1E7RTTSy1WqZFlZK6BXCzi+lC+MdxuMiah3dc5TtYexXoRK
	8r07HI8l78Q1YOyxCiEn2Cblcc/t3tRnd02tYj/lX7jJfhKX7s7kDeGwcDkt6ZmHiYlnGjPy5vw
	HdhztvT7tgtEWcBhAqPcO8RsMIiRnKs/RC4sAVNWT4CeEqbYfU9fHKdrp48iPC+Pj0pxS4h4ESN
	To9hXoX2menICsfVfMFodnu53tMf4ugxQaHpTpyHSM0Gxv2ayN0d/MWDJzYWKiBZYE1EPu4A3Hl
	i1a/FVtdEKp+3Lr5Q6bfUbTaBIjpYpUKyGij+A/dS/v3qCseZBtPpCobwn2zw2+k2y1L7FlnI+J
	4GFxi4rUZegn4tktwoOZT+5U7xGf11uP8W7Mof8tKN+vqjGHXUuacru48JCgci8rUsCzAlxjh
X-Received: by 2002:a17:90b:52cd:b0:38e:5ce1:ae30 with SMTP id 98e67ed59e1d1-38ec8468567mr3576355a91.14.1784832441260;
        Thu, 23 Jul 2026 11:47:21 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:47:20 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Steve French <sfrench@samba.org>
Cc: cocci@inria.fr,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	samba-technical@lists.samba.org,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 34/36] smb: client: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:36 +0900
Message-ID: <20260723184538.3888637-35-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 fs/smb/client/smb1maperror.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index ab3d09613c91..395299f9121b 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -234,11 +234,7 @@ int __init smb1_init_maperror(void)
 	if (rc)
 		return rc;
 
-	rc = mapping_table_ERRSRV_is_sorted();
-	if (rc)
-		return rc;
-
-	return rc;
+	return mapping_table_ERRSRV_is_sorted();
 }
 
 #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
-- 
2.43.0

