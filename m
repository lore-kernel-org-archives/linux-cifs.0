Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3832557A;
	Tue, 18 Mar 2025 12:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742299965; cv=none; b=cgvP8oHT0P2xkqQWP7GaHs6MfD/u+9UOK1xsSLUbmGdvB1oW5Y9d7NhR2oERzXaFJELn223a9fAgiEEeclskG+MA3jxTYPlJChy8UHdlqdfEUsxR4kOfHqB+7vXza+nCYMG3Vp778upgicXq31R0Q0NrXWoL7qOGJbLZNKEvcIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742299965; c=relaxed/simple;
	bh=P96dYxrdOi6sLWI/M0pPc1fvCQWlrcWsqKcgyWQxGRg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iIIXgtTxLJSfNwnL6aDdWgfPSTcwlzfgO7PgVzbnPJbRMCQImkyCkUwinKLZ7OEP9a3FuujS6ZPy9ZL+AMkFN8OKofA/DXLw7yfqEHHucaCp2g9rzAU2I4BaRchH73dWi1GsFUvPcBFO6AjWwrrkVSQnJ5ac6+vzTP30RYSMr8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OlFRe3Wv; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OlFRe3Wv"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2232aead377so122698815ad.0;
        Tue, 18 Mar 2025 05:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742299963; x=1742904763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PFyutyMdC6sV2hhLQ6sHtqvXjBCr0iPXqZL/990k/z0=;
        b=OlFRe3WvliWkccYAsg/J+n2mAyQ+t0irzIRqHGXx0pB5PaPxllHBukEitlaXtYsU0z
         LpMDP8k5kCqT4CoTfg4jo4m+bkluDgTWEzJd/Shr726SyNEzL/7uWLJ8cTtKP+4c7lNl
         Qvg9TIBNOn8R20LzHrmMxJVHiE7NsuEpGTOTWcbxj3AGKJuDyO9BDd6+NbLnUEuDE1Du
         u9qmR+2pFfnAHMjQTRYo7uqFXfqCj3zNPyn5UX/6snld3CjR3GRl+MF+R3roFA/Du5PU
         jSJ1QB6s1w3cSR00ziPAFNDKwnPPy9gonTfLh7KEwJmGk1uyJUKWBH+7Bmbt+myUiS6M
         S6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742299963; x=1742904763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFyutyMdC6sV2hhLQ6sHtqvXjBCr0iPXqZL/990k/z0=;
        b=j9041aARXxlmjl1nq5CU/gXhjH7wIymxAnnrKm8U3pcs62uHnGmCUmHEXhq7slUwGc
         2whAT7KS9XJV0e/lBLlA5mYeltTs/bwq4bQd4Sn09lr8EkoWxhz78TbwsFQy7hMm8m/3
         EuI92XgPtXM4WVEMtNcpFZZm04ZxIavI+wlF7YZDPrHj7No1wMBvk1HmXp5JJidGXwhd
         zSZRxDAOGZqBTumvns6pnuazF/YfpYk8Chrpqp25/94K5kQNzEo1GwZoEjZRfrkqnyop
         Rod8PfBLFBC+WTlTceGpbmTr4nFh1LzuKIKO+Ah64YtvY/zfjyHxn2ythS6UJSmWMXSu
         uzfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6aGRiVCky5nYu/dm9m2kUIXeLNEyjbsMmOyGjQoRQi8rpEm7SDsk/ydSYaiBVKBuc0otzEd6QEz/l0q1q@vger.kernel.org, AJvYcCWL+IQ6W2YgYTuQ978PpuV+cCTQ+a2a6xk5/7QDLCn7DbVibxGONlfS8rfBxYqkUEp6uY3/QDNh7A/I@vger.kernel.org
X-Gm-Message-State: AOJu0YzechC7S/jXUP2DkaHYIc4l2hw+oWDLYtJJYO7KrHbrkSPZk6dh
	+Ya0bJBXm8daijpcLtya9VKtsDCsFdij6fD66kF+kHXGrSwIccstygVDfrfBZvQdeQ==
X-Gm-Gg: ASbGncvAn0M/DXrAVrqDNtJPtBJ+A8WffIVaKX3nNoput9yvC7/FBlDgb9rd1nF1vq9
	bW6sLbSKUcVtpHS8eGL06Subuo6g3A6leX28UMGZp34IOyL10/5vAz3Nb54k554XpJ3BLGV5r7f
	aTiD7TXRW2aj9ZGQxPuONdNh7wA60M/AXVZUYn88bTzh1kPMmtr0ziAmGxmyJRQYoMFZpGog4U7
	W2XHQqt1jU4y3xp7RVVwVn3imGuqXjDLcoqzVQuWwtjurL2fjpwbwlizqfnMUg+8g6NbBoKpOpw
	QicIZXe2c39ic250djSHzHJCNtxjwCBbC+c7510p9HnOQyVakH9dXRYecFzgYKFsCfwug99G9LK
	eUic=
X-Google-Smtp-Source: AGHT+IGgqhbBR9wCLur+GWhSdtnwdp3KjOTmLXU1/0McQmanHfCXy1ef1xowuS/wNO0EodYogrhWdQ==
X-Received: by 2002:a17:903:22c8:b0:223:6436:72bf with SMTP id d9443c01a7336-225e0b0dad5mr199529705ad.44.1742299963288;
        Tue, 18 Mar 2025 05:12:43 -0700 (PDT)
Received: from localhost.localdomain ([183.242.254.176])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-225c68aa616sm92804235ad.93.2025.03.18.05.12.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Mar 2025 05:12:42 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com
Subject: [PATCH] ksmbd: use aead_request_free to match aead_request_alloc
Date: Tue, 18 Mar 2025 20:12:34 +0800
Message-Id: <20250318121234.7756-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use aead_request_free() instead of kfree() to properly free memory
allocated by aead_request_alloc(). This ensures sensitive crypto data
is zeroed before being freed.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 fs/smb/server/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 2a5b4a96bf99..00b31cf86462 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1218,7 +1218,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 free_sg:
 	kfree(sg);
 free_req:
-	kfree(req);
+	aead_request_free(req);
 free_ctx:
 	ksmbd_release_crypto_ctx(ctx);
 	return rc;
-- 
2.39.5 (Apple Git-154)

