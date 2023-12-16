Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B662D797
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 12:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-35d718382b7so6980865ab.1
        for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 04:30:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702729809; x=1703334609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tt85lrQC7Yj4igYLC/WbHrjIg/MuHhtJDM2PYE4oEFI=;
        b=mTrIY90izW++u6bWpPruYCafvO660NHDDq3rnbvwj2ezCnbkzPFMOi+pKjpFl9Z2a/
         P/SxErKVXx3XSe4uQpK891sVCIFHLDRkiLvwooZBa6Am8kpK4aeYm54foZc0RZipkunZ
         6MChJbHEYfwH40+Wmns1sDc8BUE8npNxE5zgRn5iSa0Er95iv6OmJvpoQAwNpfcx0mpz
         WQDYdaqTlp4q8KEA17pyU0PMv5WYwi5TZSr3+vfGUN4cWCu5FceLbrB37zjNQwxpx+gC
         qBMg4YC4OOBBJItVQnSJlDZ3/OhlAaNr+bfo4oKrw8k3ZrtYMGj8ddsL0P4v5yHVq4Qc
         W8CQ==
X-Gm-Message-State: AOJu0YytHILSO4fJtRnda7MnKNnu7n3erMHE3Cw85XYtcH7CbaUoG4Zs
	/0jsK+N6ga/wlYv6uMmV2nANCrrdPNY=
X-Google-Smtp-Source: AGHT+IFbVdZAauKSUsOgRSpZXLNELweVd1ek/W4+jFivp8Us99cljgzsNoWRBmL2cNV1SKxFBiCx0g==
X-Received: by 2002:a05:6e02:1cae:b0:35d:2f2e:f17 with SMTP id x14-20020a056e021cae00b0035d2f2e0f17mr20393498ill.1.1702729808960;
        Sat, 16 Dec 2023 04:30:08 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d6-20020a170903230600b001d347a98e7asm6887843plh.260.2023.12.16.04.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 04:30:08 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: set v2 lease version on lease upgrade
Date: Sat, 16 Dec 2023 21:29:36 +0900
Message-Id: <20231216122938.4511-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If file opened with v2 lease is upgraded with v1 lease, smb server
should response v2 lease create context to client.
This patch fix smb2.lease.v2_epoch2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 562b180459a1..9a19d8b06c8c 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
 	lease2->epoch = lease1->epoch++;
+	lease2->version = lease1->version;
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)
-- 
2.25.1

