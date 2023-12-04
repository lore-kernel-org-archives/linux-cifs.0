Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0326ED5
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:45:40 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1cf7a8ab047so14132295ad.1
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:45:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697537; x=1702302337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UZvlNwT/iX5r5rTm1v9fxuuNT8ZQDlQj/yW+NBcPy2g=;
        b=NnRCbrEM6n/6xJI/vPOjIXXj8aDARUeh0jzxCa9n1Ldh2ZsEaZEcwz8bdf2s9Vg1GE
         17h3kmm/MWJUQGoUgn7FmFN4zcpiIrhjfElFX+9d+q0QcUeKFZB6jGeg+SGR4uWgjCbo
         NuxKsk7QLNUr8TYieYQUOsaBQNwgme5YgVp/ojn2KFuKR2S3MI5c/+LvuIlY6k00juAV
         y+f7zzI//6lBGlBS0YVIePljFBlat1bCmWUd9/1CGs8/QjPFfqmI9Tc/wbqTI87cFai/
         tMTcy+28TdP5nZ5U6Kn6q2EqSebJdS2O+Y2PCp1R/cg7gYOpneAYyx9CWIroxTGanEqc
         Pwvg==
X-Gm-Message-State: AOJu0YwkI4vH9TQUDjEdii1RAzARQOCnP5mN5F7CbGg1tmAXR0f0/i/4
	m+1thW7/XJ6hKS+C7MF88vf9NL+Swpw=
X-Google-Smtp-Source: AGHT+IGdHzL/N8SgkdLKS6RdI79U5G9bAimJsLdQbCWyg/x41kr9z7j0ZaeejYXvwGXknyfJm5Yktg==
X-Received: by 2002:a17:902:c407:b0:1cf:8ebd:4eae with SMTP id k7-20020a170902c40700b001cf8ebd4eaemr1834451plk.69.1701697537446;
        Mon, 04 Dec 2023 05:45:37 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:45:36 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/7] ksmbd: set epoch in create context v2 lease
Date: Mon,  4 Dec 2023 22:45:03 +0900
Message-Id: <20231204134509.11413-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support v2 lease(directory lease), ksmbd set epoch in create context
v2 lease response.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 5 ++++-
 fs/smb/server/oplock.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 50c68beb71d6..ff5c83b1fb85 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -104,7 +104,7 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	lease->duration = lctx->duration;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
-	lease->epoch = 0;
+	lease->epoch = le16_to_cpu(lctx->epoch);
 	INIT_LIST_HEAD(&opinfo->lease_entry);
 	opinfo->o_lease = lease;
 
@@ -1032,6 +1032,7 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
 	       SMB2_LEASE_KEY_SIZE);
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
+	lease2->epoch = lease1->epoch++;
 }
 
 static int add_lease_global_list(struct oplock_info *opinfo)
@@ -1364,6 +1365,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
 		       SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
+		buf->lcontext.Epoch = cpu_to_le16(++lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
 		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
 		       SMB2_LEASE_KEY_SIZE);
@@ -1423,6 +1425,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
 		memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
 				SMB2_LEASE_KEY_SIZE);
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 4b0fe6da7694..ad31439c61fe 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -34,6 +34,7 @@ struct lease_ctx_info {
 	__le32			flags;
 	__le64			duration;
 	__u8			parent_lease_key[SMB2_LEASE_KEY_SIZE];
+	__le16			epoch;
 	int			version;
 };
 
-- 
2.25.1

