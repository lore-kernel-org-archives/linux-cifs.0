Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6E02343C9
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347375; cv=none; b=EHMfbHbQ9naDmDib0V90CyCa5ri3kGE5lNjqfqri7P0nLnTV4bmRN9SlHwcinuy1ZwiyAHyjbSR/rpkkSLn9ULL9Xm5AHkyreSQEYb++5VUWHBiCRj/nQtaqiqBRsQq0XUDTyXWJhnhQVN0+jfJ3DuP5E9artztHebNXcbc6Yh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347375; c=relaxed/simple;
	bh=UZAJLORmMQ+VPiHPCuSghMrQnYqnP8Wrf6bFkwdkl3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGiJHdrNEhk3a4vPSk4j4A5X5muHRhP8rrul8zIknaVrx7oaw6qZYK4y2DIbjOqjlgBPJuEbvLUliTZmB21SdJBMjqKUV5FA0eR7c/COXLVrT5SvSoWQRyu+vufEaBF6nSLzWoub+iQUq1HhqEclGdS6TVBt2rCKudynvyLoIqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hzubxLSu; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hzubxLSu"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso955529b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347373; x=1750952173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Tw9GjVq0m6igbM1IXs1HSDtvLN0hWKPC2IU3RYNl5M=;
        b=hzubxLSu0IobhZoMHjVd7J2Btj7iibjJPQvuWlrZeRT4WVl6rVHwJsmnga9kp/4R26
         9vF8GzyMvtPe0+civiybwGJZhMdRF8uyts+FbycD42MWcNCEL88VModQAM9MpbmKhmIv
         Bt6M+UiNDPfk0y8JbEoF3tPUzfc+46Ino4gQxnAyTCUZ4+XxQWJWRwsiR0Ut9IsZ41rW
         J40Rkee6Ah2Qih69Qz8Jz3/ijlq5TZenQV3y6bxe7woaA+EOdo7uFeU5jI2bmpHhlSk/
         7gSv1EFaKxlQuGvC/jrnHx1kxjxp3ATfXVZu6uX5WFAS5cokAnXoDzTs8mGo8h//NocR
         qO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347373; x=1750952173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Tw9GjVq0m6igbM1IXs1HSDtvLN0hWKPC2IU3RYNl5M=;
        b=tjUaHFRmVvOzz4Pes05Iu3XLQ833OYbdFYyDTuuqmr5IgYjtGz0Njy5Untor8T4zgn
         aqdehbJChO1oXy1Adlk8B8nAKTIGy3FFzTI+vtJOJ65x3LlfXjFZ4W2WywZbZmscZfZ4
         dneCC0PdoLOiHoH+hKNkdXOwTY0G2SsVI669t8teYDCZQeEF8mLJ9rwcp1CgMA9eA84m
         s8GZrbbBKcJ0BtsnvKMm8tqwAEnccaWi3Coa40ca76HfXwPIn2lH3ZHczsjN6Yp6XIaf
         K5+TaB1K1/kmk4D4KIW0ihdVkcJK+/GtozQkAtkLN1c+81BOxv5X+QLcfMA6npEpxdYv
         M0qw==
X-Gm-Message-State: AOJu0YxHwfyIEydDJrL1oq9wAmTt9/GYFrq8a141C55/8LmgwFE3fT1F
	SFjjPWGutBzGo9j85SrXN21RkMEDsnqXAEwEh7DlDnUC3bUgJnx5SH8ifnuJWMBB
X-Gm-Gg: ASbGncuIduWhsXgkwhkhM6NMhGdZNvx8t69sZIsrm7muXAiwphI7jKdjXf1CkXca9u5
	35sFpIWE+W9uSXem3R3eeRB+Fa+LW1pdFcOj0GeEUSBHm5vVmZEy0jcqV8QvowFk4tzhIbg6/nP
	KP4McLnliPcwv4GvbnufYYg3ASv3t2FwHV+jpJUIr1g2wdh4oqlnsH8Bm2VrnXB+DKSgEN/WUe0
	xCc9VaaRTa1fYttHAir5AGBPjHkNGqU9YQbAuEkV5HxH9ceL6veIwnWM6cdxh7eTQXgEcW7Lkgk
	lB7atLe55X20b+X9TFYX2uuZL0nEtSBWW4zLp0qqrSxV7vTWQDZdk+EIq0MGj9UxGTWnkRxyj+K
	eb9k+Vp7RCkQx
X-Google-Smtp-Source: AGHT+IGt0wnxnEC9aBZQyEWVepXCUdl4Q0gHmvPYCj4dHPblWVPPhHfEvpS1GtpcatxcwYW1TapTHQ==
X-Received: by 2002:a05:6a00:13a9:b0:740:9c57:3907 with SMTP id d2e1a72fcca58-7489d175260mr31160605b3a.19.1750347373397;
        Thu, 19 Jun 2025 08:36:13 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:13 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 4/7] smb: add NULL check after kzalloc in cifsConvertToUTF16
Date: Thu, 19 Jun 2025 21:05:35 +0530
Message-ID: <20250619153538.1600500-4-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Added a check to return -ENOMEM if kzalloc for wchar_to fails

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_unicode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
index 4cc6e0896fad..7bc2268d6881 100644
--- a/fs/smb/client/cifs_unicode.c
+++ b/fs/smb/client/cifs_unicode.c
@@ -466,6 +466,8 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
 
 	wchar_to = kzalloc(6, GFP_KERNEL);
+	if (wchar_to == NULL)
+		return -ENOMEM;
 
 	for (i = 0; i < srclen; j++) {
 		src_char = source[i];
-- 
2.43.0

