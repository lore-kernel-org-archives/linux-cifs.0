Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D5D4779F
	for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710768700; cv=none; b=F4KhqFu/WFMiqMsKPzGZ22xjiWJZqObWUwz/za3XHJxXksemXg1B0VR29Vp+ZEC3QCiS2mAdvUmuptNwFgJDI81K/3hEALVauy9vzqlSStLb3GcQTn4NdLRV9d9T2qDmnHlZoTwTgl6+JeRCNZgJ3sUeUIJ7HTPgnxr8AleowOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710768700; c=relaxed/simple;
	bh=Wc9R67gaJomSWYWjHi1IJEcC2rG/J/t/SeDLtgvZ9LI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HsGCp0uklQ72hfNR2JLcNeBr1FDsHVt+51c1BsoAUvUA8qBsUR8xRSX15IOo5xsaBC8o9hW7bhEILIWU2BaKPii9YzMMu08OFihHfrTOLhcEmG7R2omOYzltC2HIFaGl9waMhvdY8cmUa/971pcFPgVj1rwnHWIsLGCIrVtnIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1def142ae7bso26246615ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2024 06:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710768698; x=1711373498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JrAm4Rh2VC3M1KTEYQT9Xv5+ysRgTlj/SFiZIeDPdDo=;
        b=o90DdGqIDya2Ls4jXcaq8WenB1lJok4QKceC3Cm8/yt3Bg/UVZ4LlZoTd9Gd3jB5Dz
         qW44WPC725YopyQ/Q76udAoY4y5N+MM3awj3HGmMNQI7WAExFT5a4LLnxH6Y4s4i8XDL
         U3GX1baKQG8sOP8TIuy5NNYQCi9P4ze+9bFmj9uU5jwDjZR+aC8ktkywM1kGBgdK8aWU
         UlNqzyeOGWa385mgz8d6ox87i0KCvA/YzfBix/fBlKJQGj5fEI2sZcZ0ZpOKXBbhfCkR
         Izvn0n15bsiD6rBQOG6em5P4kxdzh0CJ2y3kAdxu6uBRPMaoOvA2WTh6eXjoD0dKSenv
         R0qw==
X-Gm-Message-State: AOJu0YzV/7Wqlu2tZN5IBhJechpXOUREQdcgHmqYUsrWsekcEdnfIutS
	qrseZLUPyI68p1WuXgV/wZiHrTlrOGU5RVJFiKm6My84QLVGWadXxk7twABV
X-Google-Smtp-Source: AGHT+IE06q/qJV/Bz2j7LfNgfmgg194kmAc4A7cx/CtFEbcbf/Gz81qYNHbzcMWEpkbRlM+sAA952Q==
X-Received: by 2002:a17:902:d489:b0:1e0:342b:af6f with SMTP id c9-20020a170902d48900b001e0342baf6fmr1138368plg.16.1710768697658;
        Mon, 18 Mar 2024 06:31:37 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id z17-20020a170903409100b001dd88a5dc47sm9228498plc.290.2024.03.18.06.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 06:31:37 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: remove module version
Date: Mon, 18 Mar 2024 22:31:08 +0900
Message-Id: <20240318133108.3768-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd module version marking is not needed. Since there is a
Linux kernel version, there is no point in increasing it anymore.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/glob.h   | 2 --
 fs/smb/server/server.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/fs/smb/server/glob.h b/fs/smb/server/glob.h
index 5b8f3e0ebdb3..d528b20b37a8 100644
--- a/fs/smb/server/glob.h
+++ b/fs/smb/server/glob.h
@@ -12,8 +12,6 @@
 #include "unicode.h"
 #include "vfs_cache.h"
 
-#define KSMBD_VERSION	"3.4.2"
-
 extern int ksmbd_debug_types;
 
 #define KSMBD_DEBUG_SMB		BIT(0)
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 3079e607c5fe..c0788188aa82 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -625,7 +625,6 @@ static void __exit ksmbd_server_exit(void)
 }
 
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
-MODULE_VERSION(KSMBD_VERSION);
 MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
 MODULE_LICENSE("GPL");
 MODULE_SOFTDEP("pre: ecb");
-- 
2.25.1

