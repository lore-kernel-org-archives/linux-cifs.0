Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B31C32
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 04:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732335456; cv=none; b=YVWnjooKJg+6VBkb0FXyE2ToFK9d3c5z0gEvge0s3I92PWAqspCXNo//kv3wdPr6FfVjPegEWoBNTwMMJe3oHg6pUb4LBhBrwP53RjAQUfsB5NLk+LVz6pfKDB+5JqDK1Rae1qaKIDtV+MqQShGt/8U1Ykm5+C7ak0jztW/XeLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732335456; c=relaxed/simple;
	bh=SPz6NHm/+S0XO34uULnf82YC5lc5MABVAlW90wDVHBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CmnZeMGQnegQ3n59/XwWojksO1sM+ttinhtrw9DpHBzKHsOsI+zH55T498XxKtzpJ+MWf9+uvbruV5oa6nS5TPP0PLSPEEpdstQVCx1wCmVfJcv/TSG9i1xqB0lVE542siUTLa510ccoSTESAXT3k5jfwWPIXXt+l9EG0XRS4oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-21200c749bfso28094185ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:17:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732335455; x=1732940255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1w+wilE3t7Ne9uOjHZGpOpEOklh3D5k2uClb8Bcs4cs=;
        b=NbnVKPf7uZG6eF7Xssxd1hvjm2ilienl5nfpXj83v+mlOPJ1BUBBcf0WxqjSMIsHV5
         toocF+10TlaesDsOPP6+WhdQyXDfDSPEm3iaWYUYoXmYDk9dZp+hx71Fvl4pzWefaItE
         DUp6FVjdFvQpFrg6g7mD7aE9iYG4fst/PdNk96GBYI7gT4DJAjCY9qbxels5hPKPU95u
         M8D9JkmAuAYUY8Qq24X2jyfM1CrAhajZ6r/rko+4BFX5b/nt5/zITHBoDX4PznIO3eiS
         Ae/VgYW1mG61QjYsSaOw4tw/pph6hTiLljNrBixbKrHl9+2EX6F9DNEjxY2N7w4ZBS81
         fCeQ==
X-Gm-Message-State: AOJu0YzwsZTs2sq1DsX47Uaz12MADMeSPMtwKDA050uCaAJt478zFfAs
	s+1UyxD5Ypi2tQbHMycAUEaiBKIXqb6NIvB7hn+N96AyY8QXPyvC2sG6yQ==
X-Gm-Gg: ASbGnctbmrokKyUCFYv/ZAV6lggQZ3LYqEZCOcypCNpJ2MCkgLuzf9XhKX6t2T4vcfR
	8TQXW1RGR2HNnmuDzkDy2q+jdCrvUO0hDL4V2m0TMA6vDk5Zh8YdtpSKShluE7OWV1ieEIFjiiq
	61z+Nm98E+DeIL45z6DBNvq8XuI+RiAbyrv8Wn4v/81WWr7y/N/cGbY7FSietuw5OeDi66PttpE
	RETuv3tL1OxrNZHRN7F4Cqe+d0IW/aCo6l8a4Bb+HBu3PCjqIm035Up2P4qHWG1
X-Google-Smtp-Source: AGHT+IF799yIiiJU6C85XQkGKmcN8b1ep7qe4NuVrnZUklRU6uBS78QWJcAMBQwyMB9ryEEkTd6xhg==
X-Received: by 2002:a17:903:1ca:b0:1fa:1dd8:947a with SMTP id d9443c01a7336-2129f27e5d8mr61466035ad.46.1732335454695;
        Fri, 22 Nov 2024 20:17:34 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2129dba20e2sm24437805ad.94.2024.11.22.20.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 20:17:34 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6/6] ksmbd: use msleep instaed of schedule_timeout_interruptible()
Date: Sat, 23 Nov 2024 13:17:06 +0900
Message-Id: <20241123041706.4943-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241123041706.4943-1-linkinjeon@kernel.org>
References: <20241123041706.4943-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

use msleep instaed of schedule_timeout_interruptible()
to guarantee the task delays as expected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/connection.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index a329e6c9076e..c14dd72e1b30 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -463,7 +463,7 @@ static void stop_sessions(void)
 	up_read(&conn_list_lock);
 
 	if (!list_empty(&conn_list)) {
-		schedule_timeout_interruptible(HZ / 10); /* 100ms */
+		msleep(100);
 		goto again;
 	}
 }
-- 
2.25.1

