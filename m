Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3A476078
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 11:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788522512; cv=none; b=ZYm21WIAcNfHY1lNUqD6L0I0ZZLbFnn6I8MTRP5IejI934IYc4UKR+LinOmRRdaO8lIaEOUFwp0+rQZFDyyeveOFGLuN+240RwSAyvrhcOWJcIe6EUyKBEjOXoCCg7YfVZFHi8sAcSyCkcOGdFJSN/UqYtlGaDms2U+e2Q3YZ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788522512; c=relaxed/simple;
	bh=FyM9la6c8DEmZm1o0Sze28ytD0RoNgbIOnGq9U4XXr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WTQa3QPJMdF0AhXS6U8lK/dWHWKPGgXgG9/l7MLnT1Md86mFM7O4r3HCcqiyPo51Jp2WLa/nTScGA42BJ2tTy4TbGU9yvPA+zOgka56+VuCto23DIRWJPg38MYb+1EVHgIceQylD+7aovNYvpVsMSRNWxsoGD1R0G6n+8DxF5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kjOrxgbf; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kjOrxgbf"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ce98cb8165so9964555ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 04:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788522509; x=1789127309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ve+amK0veETMoSZ5+zoCVWoX1YogA6ZC5rvoZ6VzdJQ=;
        b=kjOrxgbf0AjHAUBjTPbM05KcXGXjp712ozHlQjTacuePqZ3kDbVbsg82rejSUzgTyC
         gYf8gUfC6a35QH/sMJyNB8f1RihqOSnX8W/Ia1ZdwA5A7f1Vb3bW69ExVEkvT39oPjiN
         uB7yhboKQNIJcgKwemVzALIkdo/jIKWUSy6fH3LImRcVTcppZbXLymmKSFS+gFi4VkqJ
         EB9048WzM/h3JCJ8Xns9+Mk4kgrWI/u6SiWpbKS5i51+103sDKrP7s0WJzLuilaUnIVz
         WbR+ZW7BjP8rp6Zma0Z/ksz6UVQyHK3YvGQuQyZhA2jlAvVmb0kOGatwhBzXzXl9Ss0u
         B7AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788522509; x=1789127309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ve+amK0veETMoSZ5+zoCVWoX1YogA6ZC5rvoZ6VzdJQ=;
        b=ZyvHcl6Ab+JRElAr48INxtpwFgpl1NAQNfKuRRS4so/cnYA+F8sBRbcpH/M/qwHF9x
         ta8qdkbHgkllPKLHiQmpp82prlkAos2QO/EYr1ZkQHtvN7jjE4/tBCEhPFumQyTi5M08
         +BfDeMfQwC0gBpTUzgMqqbojJuVozgoQoXcmwjc1kq7vrq0o/ITgYLc97CYDaDu5pUGa
         oUOxXQAXTdhD6TUdJIOLZdtiI0hQvHWB81Huv02mk3MGOyzV5+hiM7kyp8qLsVxQq5Dp
         hTkU4h3fj7vJcYxV3DqJHfOp/DJVKYfez58R+Ti4im2i9pShlw3LS9TD4ej3jZ+ODmDI
         2Hww==
X-Forwarded-Encrypted: i=1; AKwUvBxBEP5+aKffWsN6Sd7dh2keDER0Ix9P6PY4BQRqxI2QJ8R8xFRo/FjPd8C+w2448SPEyv8vvzR9T56h@vger.kernel.org
X-Gm-Message-State: AFuF++n41ZB/rcx03ZpC5TCAcVT9ew9hLtuJjcVhAATPy5CXHt60Lryf
	6PtaxMIeN2cZoAUNreCBu0sJfxU3zOREKtYwxBQs70wrTZWCJ82Kltxt
X-Gm-Gg: AYBFou16D+h6wyTMdUTMAUxFNfZjnwCJvQcqSneTSUruufl+kkp2037+YdSKFvbj+rp
	HgCbs8/l1fjoDI1DNekU+jy+lh/aDWfisq40+g9NI6AMkvE1mW4RmwX90HudJmeIxkDAjiALI89
	sTM7yPBCrPXGV+Hk2rXS5p888ET8RxvqYWx1Ft7GTX4ILncAPOxuYzm9w4N5BVoKWe5spqefVGk
	QkuZjifNXtvzxUTp/EUft77EBg44W6rF7wGAhFx0mvk/rPVzYsskjqNSvHIszJuVqOCx7GAn3KX
	bBup+zMxVGWgHqWz2nJAiw3lmoq9PleIu2lm6R46m5dOJOamZvtTvjnXTcPIyink4IrSqXG1ktu
	28hW4ed9DtcaOqHBnFuIxpWKIx/bwE7JiUsD9PDL3/yVxmj7MA8+28K+PrXVyWQqNhY2DStpDKL
	y2SOa44IG3YXV3nThqC+u7Aa58Y1tbQy1BIuIYCfENl1Q9eQs5yW/P41RPSVzAJsYnNWpeyo5aM
	jHz7Vnxmc/27AE=
X-Received: by 2002:a17:90a:d446:b0:395:c3f7:2895 with SMTP id 98e67ed59e1d1-39b07f2f50amr13717422a91.7.1788522508712;
        Fri, 04 Sep 2026 04:48:28 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm6882570eec.30.2026.09.04.04.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 04:48:28 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-doc@vger.kernel.org
Subject: [PATCH] Documentation/admin-guide: fix typo "asser" in comment
Date: Fri,  4 Sep 2026 17:18:20 +0530
Message-ID: <20260904114821.33650-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct "asser" to "Assert", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 Documentation/admin-guide/cifs/authors.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cifs/authors.rst b/Documentation/admin-guide/cifs/authors.rst
index 5c1d2f0fa7d1..ebe223413577 100644
--- a/Documentation/admin-guide/cifs/authors.rst
+++ b/Documentation/admin-guide/cifs/authors.rst
@@ -40,7 +40,7 @@ Patch Contributors
 - Adrian Bunk (kcalloc cleanups)
 - Miklos Szeredi
 - Kazeon team for various fixes especially for 2.4 version.
-- Asser Ferno (Change Notify support)
+- Assert Ferno (Change Notify support)
 - Shaggy (Dave Kleikamp) for innumerable small fs suggestions and some good cleanup
 - Gunter Kukkukk (testing and suggestions for support of old servers)
 - Igor Mammedov (DFS support)
-- 
2.48.1

