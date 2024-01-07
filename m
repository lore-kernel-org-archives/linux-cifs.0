Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4319F134A1
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jan 2024 13:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d426ad4433so1481925ad.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jan 2024 05:08:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704632909; x=1705237709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v5HCn1F8lSkJInaLk7JtVN24aTwWfHIdO5dB23XuZA=;
        b=h1+1/u9377O3NHHbwaULIHKErdOzc1k2Kd5FiiUJje4bUUlGcu1LiMI7164qDiRetq
         6TLPHsqCEKLSiBtANxhoQa/Nmg0LyLiTK/xPO8KJPwBF77Be+GiMduAw/e2HtCsN+WzF
         jYZl7EgBOn0sdZfUujKUk/rhzfwZGHHbFjWkmb9DY+y327G9+CfH+PolUN1J+XaxjkT+
         ZxNgarDCTT1dDdWXhsiH08mVcMhKzkkoUHGYQsK9s5nLUO8QI6EqDx+GbQvUcmJKafDO
         nQn2nqAmTKuX1qdVWzXDhVAn9YNXqfhiFT0ImZo2gLXPgMVyHDcTtJvbnq1oj25obGIu
         3cJg==
X-Gm-Message-State: AOJu0YzDDpH3yDGLNwRk4wpRWloiU6M1l5IlDzkIxDVstNFt2g12EVJ0
	O6y74sBYSZC2M4MKgNoJjCrHVJ57NDM=
X-Google-Smtp-Source: AGHT+IFAzjUqIKdaoiZ7J3d3ItJKjSa4eCt6rJuY222ZHWnIzzFJSmF96ZHpRxWSS7X+HBgJhH+y6A==
X-Received: by 2002:a17:902:e845:b0:1d4:39a4:25be with SMTP id t5-20020a170902e84500b001d439a425bemr728639plg.59.1704632909119;
        Sun, 07 Jan 2024 05:08:29 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id w14-20020a170902e88e00b001d04c097d32sm4394086plg.270.2024.01.07.05.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jan 2024 05:08:28 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: send lease break notification on FILE_RENAME_INFORMATION
Date: Sun,  7 Jan 2024 22:08:14 +0900
Message-Id: <20240107130814.7247-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240107130814.7247-1-linkinjeon@kernel.org>
References: <20240107130814.7247-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Send lease break notification on FILE_RENAME_INFORMATION request.
This patch fix smb2.lease.v2_epoch2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 12 +++++++-----
 fs/smb/server/smb2pdu.c |  1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 77f20d34ed9a..001926d3b348 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -541,14 +541,12 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				continue;
 			}
 
-			if (lctx->req_state != lease->state)
-				lease->epoch++;
-
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
 				if (lease->state != SMB2_LEASE_NONE_LE &&
 				    lease->state == (lctx->req_state & lease->state)) {
+					lease->epoch++;
 					lease->state |= lctx->req_state;
 					if (lctx->req_state &
 						SMB2_LEASE_WRITE_CACHING_LE)
@@ -559,13 +557,17 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				    atomic_read(&ci->sop_count)) > 1) {
 				if (lctx->req_state ==
 				    (SMB2_LEASE_READ_CACHING_LE |
-				     SMB2_LEASE_HANDLE_CACHING_LE))
+				     SMB2_LEASE_HANDLE_CACHING_LE)) {
+					lease->epoch++;
 					lease->state = lctx->req_state;
+				}
 			}
 
 			if (lctx->req_state && lease->state ==
-			    SMB2_LEASE_NONE_LE)
+			    SMB2_LEASE_NONE_LE) {
+				lease->epoch++;
 				lease_none_upgrade(opinfo, lctx->req_state);
+			}
 		}
 		read_lock(&ci->m_lock);
 	}
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2a335bfe25a4..3143819935dc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5569,6 +5569,7 @@ static int smb2_rename(struct ksmbd_work *work,
 	if (!file_info->ReplaceIfExists)
 		flags = RENAME_NOREPLACE;
 
+	smb_break_all_levII_oplock(work, fp, 0);
 	rc = ksmbd_vfs_rename(work, &fp->filp->f_path, new_name, flags);
 out:
 	kfree(new_name);
-- 
2.25.1

