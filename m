Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03179F3
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:46:20 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d048d38881so15456765ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:46:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697580; x=1702302380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/yzdZhn9w9Ag3A2hr189ngA8axr2DQvxkZG3Gsd4d+M=;
        b=TGHsY4gP33bnpiIsfm6+Xqu2gTDLQZRiuOgf4+CUFb1xjYKHnRaHPyprlR8naX9Zqp
         3qDUQnWnbb39vCkLmXMyj/PvumyGykVoMbemtsuYY2zkh79x+unQCTLM+JGWmmQXcRHm
         6Egusi6aANJaRyTa7Ogm/yenvVWX2LiIYQZ9AQL4BFirBM2YrKMbQQF59NxkjYVEqc7z
         S0PwPOI6tcQDo8S2R5VHVlBVuZUm8E4lX1OZTcmF+uNwj1gCSwjbXnmsEOQ6CpAemmNz
         ZnB2ToPj2p1q8tOIZ+/t7RuOM2aY1bx1HPGm1QXoYSYAkan+JD4cEcbNiGQcPny8PGSt
         ICHA==
X-Gm-Message-State: AOJu0YwFsb1XHF6tGAiZVJwW1iNEWZsSIHS2KBZgrolacFhT4YFzChyw
	WwEkXhU5EoUlIDZBZgU7Cfjgmjccy/Q=
X-Google-Smtp-Source: AGHT+IFHq+VkjdCbTqV+qt0dkBbKsQin+tdqGn3PgateB+Az6svNTcCD4YWG/J2ncUtCVPDsVDT34w==
X-Received: by 2002:a17:902:a585:b0:1d0:6ffd:ced1 with SMTP id az5-20020a170902a58500b001d06ffdced1mr1667506plb.138.1701697579919;
        Mon, 04 Dec 2023 05:46:19 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:46:19 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7/7] ksmbd: fix wrong allocation size update in smb2_open()
Date: Mon,  4 Dec 2023 22:45:09 +0900
Message-Id: <20231204134509.11413-7-linkinjeon@kernel.org>
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

When client send SMB2_CREATE_ALLOCATION_SIZE create context, ksmbd update
old size to ->AllocationSize in smb2 create response. ksmbd_vfs_getattr()
should be called after it to get updated stat result.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f3af83dc49c4..f1322b39dc90 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2516,7 +2516,7 @@ static void smb2_new_xattrs(struct ksmbd_tree_connect *tcon, const struct path *
 	da.flags = XATTR_DOSINFO_ATTRIB | XATTR_DOSINFO_CREATE_TIME |
 		XATTR_DOSINFO_ITIME;
 
-	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da, false);
+	rc = ksmbd_vfs_set_dos_attrib_xattr(mnt_idmap(path->mnt), path, &da, true);
 	if (rc)
 		ksmbd_debug(SMB, "failed to store file attribute into xattr\n");
 }
@@ -3185,23 +3185,6 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	rc = ksmbd_vfs_getattr(&path, &stat);
-	if (rc)
-		goto err_out;
-
-	if (stat.result_mask & STATX_BTIME)
-		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
-	else
-		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
-	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
-		fp->f_ci->m_fattr =
-			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
-
-	if (!created)
-		smb2_update_xattrs(tcon, &path, fp);
-	else
-		smb2_new_xattrs(tcon, &path, fp);
-
 	if (file_present || created)
 		ksmbd_vfs_kern_path_unlock(&parent_path, &path);
 
@@ -3302,6 +3285,23 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
+	rc = ksmbd_vfs_getattr(&path, &stat);
+	if (rc)
+		goto err_out;
+
+	if (stat.result_mask & STATX_BTIME)
+		fp->create_time = ksmbd_UnixTimeToNT(stat.btime);
+	else
+		fp->create_time = ksmbd_UnixTimeToNT(stat.ctime);
+	if (req->FileAttributes || fp->f_ci->m_fattr == 0)
+		fp->f_ci->m_fattr =
+			cpu_to_le32(smb2_get_dos_mode(&stat, le32_to_cpu(req->FileAttributes)));
+
+	if (!created)
+		smb2_update_xattrs(tcon, &path, fp);
+	else
+		smb2_new_xattrs(tcon, &path, fp);
+
 	memcpy(fp->client_guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 
 	rsp->StructureSize = cpu_to_le16(89);
-- 
2.25.1

