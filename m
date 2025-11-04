Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A70B2D481C
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 10:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762250623; cv=none; b=unWiFXXfEuJHRo1n3bbqL4EkPnsU3HiStP4p0liBCsCqVQG6JYrg5Uwb9f5tEeSRpVui3eSY203mVRAtOzjrVd4bAAQp2bmhAGuNVgsHRXO0krZpZ+AglFrJdwJBlxJpsHSH3uF3KKtr5PzcSdSMVxNHr49bVZyM6/LjQVeRTaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762250623; c=relaxed/simple;
	bh=yCNhQ4a0Nk0Atx6Dr4wxtJ0ZtyqyLGT9ZWpCeh0ba7s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DSeZSrRp/hpVcnEmepShxrGJi5rsmVhpFouKU0IPTTjW/T5kkiSNbh3gnofiKbakY01pdNABETqPZ4iLc1O4ym/VCPirwtAfz3X1EN9/FhYWE9X+W7udMdoyO76Q95ifP1w46fzQ+4wpmrs6gL8W9x6lioSrJNc4LdJnpoHFM2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQ53Ntyq; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQ53Ntyq"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-26808b24a00so8083645ad.1
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 02:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762250621; x=1762855421; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKUczaa/kE48HAcaJ5lE+YSGWpwTs3a+tEo/Ya98+Oc=;
        b=mQ53Ntyq00EMTSh035RR+uDtW7hqjDsU/ZP5ohgCtXU8iDxkKWRO+rWmFTmRd3dtve
         /9oHlAvsGwGsM7p2C1MXvAi61D0Uk3dIy6G2YyjJfgSsmY8gX3MXp3jMK7pwNmuNcqBd
         uHBqxjox4bQW/TlBTz4WEPe6EVfSCehly9TXbbO2OuQquuXC92Ulw1VY/Ubm7A+gTN0S
         LvH6K+3Z9chVBQ7YtbJ4ir7Yf1if9X0rhTIXdW/PEyCyRlKuRLOCEQpRXQEW0BWzRMAQ
         uvCO6YkLHlqWaMmAlYMUrhOdL11AIOQ6AHx7XxZhTMVc/xlY5vav4vcw3g9oeQk2eZ0/
         853A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762250621; x=1762855421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VKUczaa/kE48HAcaJ5lE+YSGWpwTs3a+tEo/Ya98+Oc=;
        b=LUaIdUPW9BvnZkIztx6zLAzIrpLQdaq6GMy26knx477xoJd+SktGU6gPo+Op1jxsNP
         mWN9hzmyNHveexAvtkdKmUVPTAgjgnRAhTN7zBcWHavFibP7g2PDdxyma0pKbNIpye3O
         nwNNRGFuPNEr7RJbktIgb6PdC1skbpg40+Sw6WpreDI/mQnT1gqKHt0uYvV78q0fqjuz
         Fl/lYKKyaXhatxL2v8SatJ+xh5cponqHOQOL36XO4p3R9luFT5MwKLDV0/Kb/Ki/H2nT
         /m0YaSSdcnj1+SjzeqdBe2qMKvjcqfQ7MSHpXpyXbwIVodHVjuUAfH3h0EpxT1sNdKcD
         pC1w==
X-Forwarded-Encrypted: i=1; AJvYcCVBHovNvlMzG4DqiJ2XEFjmh+Avv71lLFfATAutwu+0ZPQYEuVXCpmlOD1zQh2qa+u1c5s1cIVSO+Pu@vger.kernel.org
X-Gm-Message-State: AOJu0YwLmCXVaVZQuXCg3MLhbaEdyKns7VuRIN88a1SdN/5VRzVFMLb4
	6wQ1zxuiQ83wdGMcl/5E0MNvEDJ0UDsQm8tknOGo1ys3gw/CfYM6ZpA5
X-Gm-Gg: ASbGncvOs1wBlb15bYMy6NLZmxu705O1vbnvbTpZgbO9NU+S1g8OHzUQMGsOBFvSlH6
	7lmwWFpfxwAvDx6xfUyzM265pO6t6jhEVhxKDcVgYtOUZBp8vnmG49x7D6x1A5j6MDiBgw5N1vG
	pPRYzHaBEjjsrR481iDzl5vNTRPBs9E8uD6u7WLlqkXrsX3bESpHp2vj9omW/ANbDt7c4eu66i+
	pstplER5+6QjQCiN0Qxn/SPAMZYx0kdL8SbdcFSuOh9hVT9UmDqH12s28/kRU+ZnF7k+fZir7es
	uZNTuka9yT+NWdJYHwDh0dvn612gAzcKz7FrWKy4LafBZZ1SdfU5XyRvAQhZiqW/Z0yslJrNy90
	pRxSgX4kb/usW5/cs3aIO1fJFdW42Lo680Ppp8hcmbO5MqBFp94RCHVmJIeMgQrk+GWeStmdW7G
	ZdiBPv1/qqI1z5NhoOu6FqhKNYe7X9S5azdXCG9Meip3zvNkaBuShBJ8eiQlLjwg==
X-Google-Smtp-Source: AGHT+IERjCdObduOqXZ7oaX8UqF7sHs4pQ6NQtq4FOaNwiNZd5TJwbQT+UFYEFtX/Kv19Ewgasg8YA==
X-Received: by 2002:a17:902:f393:b0:295:54cd:d2e2 with SMTP id d9443c01a7336-29554cdd55fmr54991885ad.0.1762250620759;
        Tue, 04 Nov 2025 02:03:40 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601998ef7sm20672565ad.33.2025.11.04.02.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 02:03:40 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix leak of transform buffer on encrypt_resp() failure
Date: Tue,  4 Nov 2025 19:03:25 +0900
Message-Id: <20251104100325.343863-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2025110432-maimed-polio-c7b4@gregkh>
References: <2025110432-maimed-polio-c7b4@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When encrypt_resp() fails at the send path, we only set
STATUS_DATA_ERROR but leave the transform buffer allocated (work->tr_buf
in this tree). Repeating this path leaks kernel memory and can lead to
OOM (DoS) when encryption is required.

Reproduced on: Linux v6.18-rc2 (self-built test kernel)

Fix by freeing the transform buffer and forcing plaintext error reply.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/server.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 7b01c7589..15dd13e76 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -246,11 +246,11 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 		rc = conn->ops->encrypt_resp(work);
 		if (rc < 0) {
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
-			 work->encrypted = false;
-    			 	if (work->tr_buf) {
-            				kvfree(work->tr_buf);
-            				work->tr_buf = NULL;
-       			   	}
+			work->encrypted = false;
+			if (work->tr_buf) {
+				kvfree(work->tr_buf);
+				work->tr_buf = NULL;
+			}
 		}
 	}
 	if (work->sess)
-- 
2.34.1

