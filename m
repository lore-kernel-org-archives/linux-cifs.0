Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE58D42
	for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:46:03 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1cc0d0a0355so4485665ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Nov 2023 00:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700729162; x=1701333962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcIRe6YcO456Gu0O8QafFcuga+JBTVrvlvuRza4m6Oc=;
        b=mjoVkt3HBQOBNgCnG0KSqq0qvDlRafhFJqTFcHTBFIOS78n8JDWp7rRbKTpw04ejig
         Dp1kTgye7MIUCc+Qbke7B+7TJ0/DUXsjgJJzq+l1JjYq0YuhkmK/NZeiS1D9zNFmjc8d
         CG3I3NfGQQa0/ZrvO5WhUeNIqYGZ2J4/VRVHSYzlfu2rFWMtelxhADMR74lTtbLtSUCr
         1ClYlzJVyDgga0gUC+jrOrdOhkrRfY2YKNmKFiuAv17U1ToIuZd5Cz7Xv0x2O8/Ze1aX
         Jx82dQkcm18e2Jqy34w2QS084i0YcbJYZCYVIzo7xFPKon3e+Tzg1AEyYM2Q3EQ7HQgw
         bo2w==
X-Gm-Message-State: AOJu0YxxWkDWxC1bCKc9l/xMEMoYSrUnp/vKA5A6YOSJGVjlkLO1aqCY
	CVI7XwnSgelVPtWjNMtjdq+A0p73b60=
X-Google-Smtp-Source: AGHT+IG4Kegjle6jbrFSnebvQ9xuxXN0Y3iOgH1Pcdc5f06DeGvZTwfA9/bbnUxMFmXMkLvrlQPEPQ==
X-Received: by 2002:a17:902:e751:b0:1cf:7194:8502 with SMTP id p17-20020a170902e75100b001cf71948502mr5034294plf.46.1700729162121;
        Thu, 23 Nov 2023 00:46:02 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm810208plf.111.2023.11.23.00.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 00:46:01 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6/6] ksmbd: don't update ->op_state as OPLOCK_STATE_NONE on error
Date: Thu, 23 Nov 2023 17:45:07 +0900
Message-Id: <20231123084507.35584-6-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231123084507.35584-1-linkinjeon@kernel.org>
References: <20231123084507.35584-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd set ->op_state as OPLOCK_STATE_NONE on lease break ack error.
op_state of lease should not be updated because client can send lease
break ack again. This patch fix smb2.lease.breaking2 test failure.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 427dd2295f16..d369b98a6e10 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8234,7 +8234,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		return;
 
 err_out:
-	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-- 
2.25.1

