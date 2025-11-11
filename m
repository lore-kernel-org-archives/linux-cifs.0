Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5ED12E54D7
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 07:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762844781; cv=none; b=jqfhPld0tQiPOKcDr4oW1dE+wAUVYzsVRwrDn69r9zGqYJEa6USN18PuMGsf0c5mOF2AjMtA/q2hE5ivMS0p4RFhuDpRcCzFl4yLWrqaKbZXr/dwHpF3CpMLYfuQGD26Pft3dcP33yxoPVLOelTA8i7HPcQKlGUjLHMxqxXnUDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762844781; c=relaxed/simple;
	bh=yIdvyF3gzCSmMa7JjqM4x9chXbYDzVsQAR8cg9etAeE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i2VwmYOQDJxSTigT/naISfr5jxYRQnoHSCOTEp6clzJI2G59Iv1jQG8HP3yZc0UbczUPcp4ujoNKWHosM10v8ML3wQ4hWWZ2U8Lqf+3XMPGAic64+KPIL/nq7dRP17gigBpgpvNf7NR1mXLD7Yxuf94AYDoJ1iwPsoO6++FK15Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jm2L6LKb; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jm2L6LKb"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297ea936b39so3533685ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 23:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762844779; x=1763449579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hG8GeeNZLRMCptK974y73GVf3lQ3b5vjFabIgGEhvCg=;
        b=Jm2L6LKbgNVAlEBFNAgrBZ53xqAmApcLsTub7B1S3ihbDI7jq7ow3njPAX4FG9fgc7
         hQ9viV/htxfT3Pn2RgbuFZvI34m84t0weZguQzLhStLW3fRsHwszeaVQ+W4hIoYuiecj
         jEUdfxsoJTdRnVTsdWFAfWdDOWBiSI7NxeOIiTnWdTbkCiPyw7uVYG3hS1ZEk3UOHrrf
         eGEtkmmv8RemI7AfWxVYnjZhlpC8BxyFGoIyJjYbSctezxDSPpB87Fogw/VOfTzaWkL6
         qgOJI9plcRdwEdy2H1bsuSvcXqZKz3PzQBnGlh71QiSoI8tiS6jIeAMKerN9KJCnMxwn
         PhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762844779; x=1763449579;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hG8GeeNZLRMCptK974y73GVf3lQ3b5vjFabIgGEhvCg=;
        b=Vnx4l8XLzYuk+v+J9fQ3JPYuSLq6MvjosU9D9aAXU2s1LgIJxaOaTFm9A9y8SBa9Dl
         UUocR0w66TL7ebZIyAhRfiEAJoNxzEjUpM6iXa1CEfiQMnTfI9u2r3lcS9V1ShLnvZh5
         0oSOAsMcwk973Z7AIpEKx30G7fKsYombvz3utfVdQcyv3flKPU4i/vLTNUihcMbTpIF7
         CFA8C4Mh+ALLXJYCk/wXEG+TWN5ulLhqtHQbIORyiyAY+xuEpEt9p3+0Edzs2kmAKsGK
         hXTnKb75vxgfF0iiSZrKnjbpwbBqZhFDLk+dBUYp8aqurewUG56PqrSi+lwnyd8+aqS2
         7sfQ==
X-Gm-Message-State: AOJu0Yzf0xl4sROI2P4K1stTfDh62dErTKmEo0Oi4Uu5aTMnGsJ4b23L
	zf6BopBwXcOjSRWP8nBKaxAw2fAkRzXSZGAmwfy1e6xwt+eeAP8pqbO5
X-Gm-Gg: ASbGncsptoIeAI8+M8JkK8eRk2GkaBbZ/1Scm08YY+Lv/FqaNBHiI2Yvrmy3lIfmynZ
	5RpiRLgwDSl6KFktr7zaHsUpjL/fI4AuYOzcy96iJyYhqJk1GIB6rRuh7F0XM5LQk2ICRtPTzSD
	qIOFhxxOlxXJYHWcutD+18LWV0oBPDEe8QvcjITBbTv2fsLZtW4XZh7SPSpgVflaNYBaG2k8zp6
	FDe5mMTvPzlTnb+Hx6asL3mN3dFo6UAWAabmdEjGWCLiAWTV/MgqL0vOoFA1xbmZuLPp26usTE6
	ZXvL2bGZVN1USPDG9RHyTi45ST42+xadDNYvmUNeZgj3o+vrqC5dzJhprZUfkHW61imYLv5xO/4
	J7rALNvIBh/4GDABZdSdvrx4Wfc16bvyOsWzAqiMJHghMtNRzx1AlK/1FJQ9CssG3nDlB0aKfES
	Bi7rqmQhj3npW0u4rHZgdL
X-Google-Smtp-Source: AGHT+IFDRWJUbjlU49NMp5vrzNBe6mYRB0vkdh/8U7PMF7Hafyra6SQ728XFlvN2IRQiW++gi4XTgg==
X-Received: by 2002:a17:902:e353:b0:297:e604:598 with SMTP id d9443c01a7336-297e60407famr50041575ad.4.1762844778684;
        Mon, 10 Nov 2025 23:06:18 -0800 (PST)
Received: from localhost.localdomain ([101.44.65.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-297ddde1e7esm110430465ad.77.2025.11.10.23.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 23:06:18 -0800 (PST)
From: Yiqi Sun <sunyiqixm@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Yiqi Sun <sunyiqixm@gmail.com>
Subject: [PATCH] smb: fix invalid username check in smb3_fs_context_parse_param()
Date: Tue, 11 Nov 2025 15:05:39 +0800
Message-Id: <20251111070539.1558765-1-sunyiqixm@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the maximum return value of strnlen(..., CIFS_MAX_USERNAME_LEN)
is CIFS_MAX_USERNAME_LEN, length check in smb3_fs_context_parse_param()
is always FALSE and invalid.

Fix the comparison in if statement.

Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 59ccc2229ab3..d2cf1f60416a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1470,7 +1470,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			break;
 		}
 
-		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
+		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) ==
 		    CIFS_MAX_USERNAME_LEN) {
 			pr_warn("username too long\n");
 			goto cifs_parse_mount_err;
-- 
2.34.1

