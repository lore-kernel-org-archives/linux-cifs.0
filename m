Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90AB8DF
	for <linux-cifs@vger.kernel.org>; Mon,  4 Dec 2023 05:46:17 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d06fffdb65so8642955ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 04 Dec 2023 05:46:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701697576; x=1702302376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wfmb8XynJiqsiHBGukWRvxQFEjGuoaxPT1r9zoy4zUs=;
        b=hQJ6isBAAHJLCBkuR+64UmZtNEEo1tVvWNNQqIxH3/zqRK/twbvrdCGaSW2Nq6oz5D
         X5nL/3Jmb51V7ZCFixF79NzMm+H4Wmxr/N+B36iuXjGI8W2cUMqANA15mKnH0xPj0eCd
         qe29gZC1PlN80tAzvNYXrpkZAIyxREr8Q24RrK1DIUg83uzCaZSq8taSV5EtTityDcFY
         W5PneSyrEJKlRh9OGakzUCg0JD+lGs+LWkxApgbXK1GZkXZ9X+VTMg+chKk+WCzey3lr
         Gc50wYLzEKSDGN8eJzHWYM4+Ds41MNUsAbCdFuHNFLKaCwWC0QFH9APeFILuQv7/35LF
         SzSA==
X-Gm-Message-State: AOJu0YxLn6RDb32FqCELFVHk6HdNAyXkQvvkqznWHuk/hizPwYabd8C5
	oaR0TEXFMs85Ib0k9RyExBXjtO8bnEg=
X-Google-Smtp-Source: AGHT+IHxI790+iUO7ngLKax5QskFyQ2jPpV32FuwLh+EK+cX9huR+R64G7YzAMwDooy5SzQcVVsNBg==
X-Received: by 2002:a17:902:7281:b0:1d0:bba7:4f95 with SMTP id d1-20020a170902728100b001d0bba74f95mr282683pll.51.1701697576619;
        Mon, 04 Dec 2023 05:46:16 -0800 (PST)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id m9-20020a170902db0900b001cfcbf4b0cbsm8428475plx.128.2023.12.04.05.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 05:46:16 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6/7] ksmbd: avoid duplicate opinfo_put() call on error of smb21_lease_break_ack()
Date: Mon,  4 Dec 2023 22:45:08 +0900
Message-Id: <20231204134509.11413-6-linkinjeon@kernel.org>
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

opinfo_put() could be called twice on error of smb21_lease_break_ack().
It will cause UAF issue if opinfo is referenced on other places.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 45fc4bc3ac19..f3af83dc49c4 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8219,6 +8219,11 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 			    le32_to_cpu(req->LeaseState));
 	}
 
+	if (ret < 0) {
+		rsp->hdr.Status = err;
+		goto err_out;
+	}
+
 	lease_state = lease->state;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
@@ -8226,11 +8231,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
 
-	if (ret < 0) {
-		rsp->hdr.Status = err;
-		goto err_out;
-	}
-
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
 	rsp->Flags = 0;
-- 
2.25.1

