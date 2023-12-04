Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B624D2
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:45:42 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d0a7b72203so7566065ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697541; x=1702302341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=14wWkANpOfxxqiFimxBWYOWkK6PxgivXsj6IENz0a7o=;
        b=B6G9vLz1Sxb9Jh30MZjfe1aJ/WERdHAmNoFc0SQjkIjpJTuH8R7IeuLlXzFbKZaTBM
         vDidvcjKYYm7jEzbBNUYWob9LqkTp7uI8Rxagv7gk6oDE7JgIcSUyBGqgY1BlYeMAP2s
         e9y9Z1+vGPcV1L0A2jJU0XkEgVnQ3kuMLC+/l1f6VhfrgwnJUK5CvvlTr2CH1Icd6TpQ
         DZTM2PXmHBFZjoLpEW9lvS8Fnrwz0phIjgmlnnva1mDlr+YoCq7muFtHJ36KEitZUmh2
         g534uvuF72hRxQwpepyyo3GhMoVFsGSQveEDDl5jf3voQsIEbjWD81h5fNbmMCIMehKa
         unug==
X-Gm-Message-State: AOJu0YxLMXNj2PvfEUh65r52f97Ots/YOApSxTWRwRbPaJXdM1QQW30T
	ar1c8Igf7XhQe6rPZEqpfO/VvX9r7A4=
X-Google-Smtp-Source: AGHT+IFaT1VI9Fwkk2IvoyGRo3CT+MtTo9MEvOv5El5mWkzrGdkr+wsYfwpIl1emzg/XUCmjuSvD2A==
X-Received: by 2002:a17:902:c94e:b0:1d0:93d2:c38a with SMTP id i14-20020a170902c94e00b001d093d2c38amr2759048pla.94.1701697541110;
        Mon, 04 Dec 2023 05:45:41 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:45:40 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/7] ksmbd: set v2 lease capability
Date: Mon,  4 Dec 2023 22:45:04 +0900
Message-Id: <20231204134509.11413-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231204134509.11413-1-linkinjeon@kernel.org>
References: <20231204134509.11413-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set SMB2_GLOBAL_CAP_DIRECTORY_LEASING to ->capabilities to inform server
support directory lease to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 4 ----
 fs/smb/server/smb2ops.c | 9 ++++++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index ff5c83b1fb85..5ef6af68d0de 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1105,10 +1105,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	bool prev_op_has_lease;
 	__le32 prev_op_state = 0;
 
-	/* not support directory lease */
-	if (S_ISDIR(file_inode(fp->filp)->i_mode))
-		return 0;
-
 	opinfo = alloc_opinfo(work, pid, tid);
 	if (!opinfo)
 		return -ENOMEM;
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index aed7704a0672..27a9dce3e03a 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -221,7 +221,8 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
 	    conn->cli_cap & SMB2_GLOBAL_CAP_ENCRYPTION)
@@ -245,7 +246,8 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
 	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
@@ -270,7 +272,8 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
 	conn->signing_algorithm = SIGNING_ALG_AES_CMAC_LE;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_LEASES)
-		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING;
+		conn->vals->capabilities |= SMB2_GLOBAL_CAP_LEASING |
+			SMB2_GLOBAL_CAP_DIRECTORY_LEASING;
 
 	if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION ||
 	    (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF) &&
-- 
2.25.1

