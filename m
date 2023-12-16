Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD0C15EA6
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 12:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5c21e185df5so1320832a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 04:30:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702729815; x=1703334615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKxsGNdycCsapBkqubfGw/Dn5fK6LpSzNNn2n4GD9mA=;
        b=WQK+WogbSMjm3yLr6kmzRYDtFrqq8Uss7pruHJIbom/oKT5pN+e+pwbI+W+bbvSoHs
         ncXEzWL2Cw9TAgmNCQuWGod8QNGOUWhq3mJPttSOTz+CCKOHijLRvUINYAmC8J/z5KPo
         uoWaRQmCUS63bpN3ImGfQ/2ETgZYLsVfoRrV8gR5OUWnIpQMD3rEERaUxb0UX27qrENT
         bPGmd1lUgQCIpjDx6aGJPQJJlhdG1vTrI66JGktHFwTNWgBxF9b5Ec6a52s3CMYHKaBV
         RBQQ0a+hPBv+e21k4FbPoY7GI9hGx8c20NR78GeoQo5gQxst+YTl1SDml3C30tqVkGrf
         Hwtg==
X-Gm-Message-State: AOJu0YxqZcXTHvgocjAcEAsQ7XX15BqoQM5EjWPVWIYMCjTr4yMmcxj5
	JuI504tA/9YCBc99LG+/57fRoKTuqgA=
X-Google-Smtp-Source: AGHT+IEoq40OA7Ggc/aMBxVAHrFvTQ3lm8rz/4xdxqUFcPWwtAWrkxzqvDeKPuOVS+/QkuAdSmE1cw==
X-Received: by 2002:a17:903:41c9:b0:1d3:7a3b:d391 with SMTP id u9-20020a17090341c900b001d37a3bd391mr4081363ple.9.1702729814996;
        Sat, 16 Dec 2023 04:30:14 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d6-20020a170903230600b001d347a98e7asm6887843plh.260.2023.12.16.04.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 04:30:14 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: don't increment epoch if current state and request state are same
Date: Sat, 16 Dec 2023 21:29:38 +0900
Message-Id: <20231216122938.4511-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231216122938.4511-1-linkinjeon@kernel.org>
References: <20231216122938.4511-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If existing lease state and request state are same, don't increment
epoch in create context.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 9a19d8b06c8c..77f20d34ed9a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -105,7 +105,7 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
-	lease->epoch = le16_to_cpu(lctx->epoch);
+	lease->epoch = le16_to_cpu(lctx->epoch) + 1;
 	INIT_LIST_HEAD(&opinfo->lease_entry);
 	opinfo->o_lease = lease;
 
@@ -541,6 +541,9 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				continue;
 			}
 
+			if (lctx->req_state != lease->state)
+				lease->epoch++;
+
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
@@ -1035,7 +1038,7 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	       SMB2_LEASE_KEY_SIZE);
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
-	lease2->epoch = lease1->epoch++;
+	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
 }
 
@@ -1448,7 +1451,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
 		       SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
-		buf->lcontext.Epoch = cpu_to_le16(++lease->epoch);
+		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
 		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
 		       SMB2_LEASE_KEY_SIZE);
-- 
2.25.1

