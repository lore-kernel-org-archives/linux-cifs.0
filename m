Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BEA39A7E1
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615912; cv=none; b=gVpRl0l6z5nAtG5F9FukbAmkHnZvt8MOccXVbDSue/0hn8xIlNetjW/533jiE5t+OSDiAUreGL9Tied9ARQs35Bz24beIU4rSVrEi63e35juaw79MiL8nUgtufO0iHc1TuA/D4k0A3OhSIYRqgjfQNeSJnkunMyW2QZeHWTM5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615912; c=relaxed/simple;
	bh=idin51Xyigxop9nQZrEDg2HcKIVVNosWMqY4lOu78xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duZUA+dveKpx7JcZomTV/5l/kHKrTTKaPj7vcTWTsOz/SK+ioGXpbHgknx5pfd/HWnTUwUQ9ixBu2UKYoUKJSJtBs4ucmdIQDs0lRViBpHDSVHYkTusKqAVUN61Hxtct5JwclMSR7ZmsHhCZzs/FO3ZaAAOhmiLHSA5FEU5IukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HBsnM2Y3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HBsnM2Y3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493d1e8aa46so218935e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783615910; x=1784220710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3xOOnELaDGIaO7Cr3bZptDC3H56uyl2WG9eVkbLIVDc=;
        b=HBsnM2Y3rD4XQzTm56wn8jo9Dr3xpN4BV/ZjjfGzzbLcVilEDToVCrm5L99TFP7261
         bKelhVyO/BfTKu5XN4TolEj9R//w9hJtgQiZ0MZ4CEciouemgQeqls0IJczoH2BhnF/Q
         I6gZaH7TtGlr4HNUiq/KtdSWSulWTcBj1rhIZq16z4UUxh3FeEaJNm+rdq+jYCAnz9VM
         GDerDJZwOKrJESwHBJj/lxb4P804A+zBofWYcUHxcHiUgMidrqE0+O7jHVcoUDEM++vC
         l10Pj2YigigDESAkNgV8hA8nZ/Y2eoGDf27ZikadSc0IqLmUucm0J0Pv/N26gABCX++W
         jaIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783615910; x=1784220710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3xOOnELaDGIaO7Cr3bZptDC3H56uyl2WG9eVkbLIVDc=;
        b=rL9oZSylW0ZrijBIRrOczcKy2W3FNSqesBHX74xz/Z0/nT25vIgExvQvkJu78Izxpm
         BN9fO/zMvyA3INvABx96ftOxCR1HL9vytxDBDlmw9uM3esj0HrE1ILSmx95f/ITuG0h0
         iW7drRfBrg/TXg7VsKYuwObDVEfcyM7uTRHUup7i4FsKxr09xzBA/Qn79BS3GcgP4e+4
         /ukguNJZtZZkSVF1TjjVdrvLygYJeyDOb0BlrVEr9o73hyT3SSo8lC1BusE0nVpDl+wv
         TPAwh5OlZ1DWCP0/KJ9TaHarfM8aUr9ucONSiT8YbqkCzofEBpBgL8Sx/c9uaJ6+rEuA
         YSUQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPx1zBROnRCFzMMV0NKQEuigmUKNHeQXsAZYZHmhrqV9PadQ6E96EiqJv1c1FCbqLkgz0R0CnipR75@vger.kernel.org
X-Gm-Message-State: AOJu0YyCIPco2vmgacAAxnJRm//99ELa7nzjy3J/H8fVzdWf8JznD4By
	QCf0nnS8bLjrxiz3Ed6BWS4Lp/NjprBAzNIfEsq2aaHGpW+4eo1Oxld7
X-Gm-Gg: AfdE7cnP+kB+2LF4YM4xYQunp5EJ9wu95VqsVsEUclPzRF4UEHI72tTY3y0XvzygfJ3
	1CXzrKqcghQHsfixe/e0sg4n46QsOUnRGc840EqIlVavcnIpYXjheMlDCgeDoj5SLS4K4wUx0RY
	aIzLXj/wpGUjeICQOZkQi4frvX8ADYT0KadegoOmx+p775B01PSjir62riVS+C5HYP1DCSql+Z3
	hmtTt+qJh7Icnd6CsCUF9Pp+LMJdwz6HrAPtrEaEqBhlmUclvtn7Wwf++C+e33B5BdZVjBi+wHX
	Kj4tvKxfuyraZc52nlVUguiofHT6sEZfSJI5Mhmr+z4A1vQH0nrl3/XqkmeubCp1Nd0Z8z9LNdX
	h91UWmWp/ubmEz804K5p88Uaf0rJW7JP39r5iJe6j2TrYWd2aWEMdioCrKKcg01cWGQWvAmnzoc
	nO3Uuo9Di7A8+acnKf506OX+dD/IbCVXfp/QA=
X-Received: by 2002:a05:600c:e557:20b0:493:c0ec:9a5f with SMTP id 5b1f17b1804b1-493e68ddd9bmr59417945e9.19.1783615909957;
        Thu, 09 Jul 2026 09:51:49 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm53974738f8f.15.2026.07.09.09.51.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 09 Jul 2026 09:51:49 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
Date: Thu,  9 Jul 2026 18:50:45 +0200
Message-ID: <20260709165141.2111-2-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709165141.2111-1-g.blivet@me.com>
References: <20260709165141.2111-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Follow-up to
commit bb682f1496f7 ("ksmbd: quiet mdssvc RPC log spam"),
which silenced __rpc_method()'s own "Unsupported RPC: mdssvc" log line
but missed that ksmbd_session_rpc_open() failing for that same,
now-still-rejected pipe also trips a second, separate pr_err() here in
its caller. macOS's routine mdssvc (Spotlight) probes still spam the
kernel log via this second site on every single probe, defeating the
original commit's stated purpose.

Suppress this specific case the same way the other site does; behavior
is unchanged for every other RPC failure.

__rpc_method() (mgmt/user_session.c) returns -ENOENT for mdssvc, not
-EINVAL.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Check -ENOENT instead of -EINVAL, matching what
__rpc_method() actually returns for mdssvc.

 fs/smb/server/smb2pdu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 69b244664..285d31d0e 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2655,7 +2655,16 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
 
 	id = ksmbd_session_rpc_open(work->sess, name);
 	if (id < 0) {
-		pr_err("Unable to open RPC pipe: %d\n", id);
+		/*
+		 * mdssvc (Spotlight) is a routine, expected probe from macOS
+		 * that we deliberately don't support -- it's disabled at the
+		 * __rpc_method() level (mgmt/user_session.c), but this
+		 * generic failure log would otherwise still fire on every
+		 * single probe regardless.
+		 */
+		if (!(id == -ENOENT && (!strcmp(name, "\\mdssvc") ||
+					!strcmp(name, "mdssvc"))))
+			pr_err("Unable to open RPC pipe: %d\n", id);
 		err = id;
 		goto out;
 	}

base-commit: 5e6eeafe46a4a19559808c5ef36ea36ea4f2a204
-- 
2.43.0

