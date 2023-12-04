Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2B7D2
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:45:45 -0800 (PST)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d05199f34dso16672615ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697544; x=1702302344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dC0LkXvWbrj6UEeIU9WnMk3Az0+eFbJL00Li/qMnmDs=;
        b=G8Mz17Ciw1AtjtIOIuwYIgQ5hRjpNPOGz9+TzduzwMGUyhzmy55O3RiBeTWkfVPoxB
         mVyjDk57zeW1d6mvfsl9FxHjGvlJrW/OXXV2E69r5SJL0UCLc8tKbbzABUE6aNB0vQAz
         aOs1GCiSbe3HTBwCh6g1W6Qvs8DV98o8zAy52NpzVmLBlx7U5wAKJeGMaT4kZqOUIIyH
         8KeY5f17tfObkbdGdpyyLcQaCwCp57jNct9DEj5mbF5lkYYmUXRiCB/uZlt1TPkziWsM
         ZfSkIDNst3nvc3gL9Mxlu4Wf3psSBbn9ZNGauhRgb91xgtPq9LsPZvGw6SfoY3GxP24l
         gucQ==
X-Gm-Message-State: AOJu0YxaabrNycW07vVsH3ladmV+jJEr1TYGFU76JapgG5JM+vLiikAV
	DmIL2hqTDtovtugX2ddWDca21K2tMUs=
X-Google-Smtp-Source: AGHT+IGgNlLLvNdZxWVYFpprA7Gk5GJuLe5rKpgIS1xdsF1iGEZXevL5IUNwVWlipYCc4WAV59qLzg==
X-Received: by 2002:a17:902:8491:b0:1d0:6ffd:6e86 with SMTP id c17-20020a170902849100b001d06ffd6e86mr1654971plo.126.1701697544446;
        Mon, 04 Dec 2023 05:45:44 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:45:43 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/7] ksmbd: downgrade RWH lease caching state to RH for directory
Date: Mon,  4 Dec 2023 22:45:05 +0900
Message-Id: <20231204134509.11413-3-linkinjeon@kernel.org>
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

RWH(Read + Write + Handle) caching state is not supported for directory.
ksmbd downgrade it to RH for directory if client send RWH caching lease
state.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 8 ++++++--
 fs/smb/server/oplock.h  | 2 +-
 fs/smb/server/smb2pdu.c | 8 ++++----
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 5ef6af68d0de..ac327258506a 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1401,7 +1401,7 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
  *
  * Return:  oplock state, -ENOENT if create lease context not found
  */
-struct lease_ctx_info *parse_lease_state(void *open_req)
+struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir)
 {
 	struct create_context *cc;
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
@@ -1419,7 +1419,11 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-		lreq->req_state = lc->lcontext.LeaseState;
+		if (is_dir)
+			lreq->req_state = lc->lcontext.LeaseState &
+				~SMB2_LEASE_WRITE_CACHING_LE;
+		else
+			lreq->req_state = lc->lcontext.LeaseState;
 		lreq->flags = lc->lcontext.LeaseFlags;
 		lreq->epoch = lc->lcontext.Epoch;
 		lreq->duration = lc->lcontext.LeaseDuration;
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index ad31439c61fe..672127318c75 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -109,7 +109,7 @@ void opinfo_put(struct oplock_info *opinfo);
 
 /* Lease related functions */
 void create_lease_buf(u8 *rbuf, struct lease *lease);
-struct lease_ctx_info *parse_lease_state(void *open_req);
+struct lease_ctx_info *parse_lease_state(void *open_req, bool is_dir);
 __u8 smb2_map_lease_to_oplock(__le32 lease_state);
 int lease_read_to_write(struct oplock_info *opinfo);
 
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bf1dea10c9e7..2d3b8acb21e7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2732,10 +2732,6 @@ int smb2_open(struct ksmbd_work *work)
 		}
 	}
 
-	req_op_level = req->RequestedOplockLevel;
-	if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
-		lc = parse_lease_state(req);
-
 	if (le32_to_cpu(req->ImpersonationLevel) > le32_to_cpu(IL_DELEGATE)) {
 		pr_err("Invalid impersonationlevel : 0x%x\n",
 		       le32_to_cpu(req->ImpersonationLevel));
@@ -3215,6 +3211,10 @@ int smb2_open(struct ksmbd_work *work)
 		need_truncate = 1;
 	}
 
+	req_op_level = req->RequestedOplockLevel;
+	if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
+		lc = parse_lease_state(req, S_ISDIR(file_inode(filp)->i_mode));
+
 	share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
 	if (!test_share_config_flag(work->tcon->share_conf, KSMBD_SHARE_FLAG_OPLOCKS) ||
 	    (req_op_level == SMB2_OPLOCK_LEVEL_LEASE &&
-- 
2.25.1

