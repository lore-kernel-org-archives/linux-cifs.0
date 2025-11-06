Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3819E26E143
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 06:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412300; cv=none; b=q7P2fF6zADUrN7GYanTpceKP0JjJya2C5a10G7SY8GTWXzB1HtcjCZEGNa0Q4lcO/qk+Y771MrjQSBpIHhGlzHE71TprnK+Xd4LOlvb4I1ZtznF8QOL97cLGtOucAChfUNY3jnJ7vbyD+Px8w3q5LlyYAw+5PWAOrvccaPLDm7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412300; c=relaxed/simple;
	bh=3USn+kAKMYwPb5j0sZCxRjClOwX15xPhtud3sUz3LSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pxmK+hNevsZwk43neFTMOwvI03noslhCBZTfMjWasonvUCoC8itt0Vlp9Kc6Q+md0uQNt8/ITFVJ8UhnES9ghV0wiSEEcAjLkyV6U1excZQRb5ck93LvNAXVaoO506svvYSklb0NVM3toHzAMQ9+xYyNoQbPQP+GL+JkfDltwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hymehJ8d; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hymehJ8d"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-340299fd35aso82798a91.1
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 22:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762412298; x=1763017098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkT3tsOZsMZ2+dYyU7EN69OYqrA2oFR+3YWlk36uRQo=;
        b=hymehJ8dpblQda1a2LtR7j75brDh4th8OHJceoKb3SDzOW2NmIXcrOXxDyyDXe6b3O
         6Q0HjEAY4jIcXt1RkyaQLRA/Msvt/KghIBKx8nl+/noxkTdY7TMeL9qxUy6V8AHOXJpO
         LUJxD5zHq7WIVjF9TkoHi2CF1gJBT6gkLzQJikh8jHofEhDSyfVkhvlo53JmbA47rynt
         /pkPLBVZC4BGe7DXo+DQzuKIFkCloZ5W8QIDMnZpdePR/CO1x3Ap5yjlnPBTjxZHeHkx
         AUSwKZGt3L85kK/B7OQL4dkHzOStjuf45LCxxGNIOafXaUzX4rvvYXdfdNdMubCMwPT0
         /Flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762412298; x=1763017098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkT3tsOZsMZ2+dYyU7EN69OYqrA2oFR+3YWlk36uRQo=;
        b=mxq7Ebjk79V8abdXNJsa0WY2zt/wjYTUmJ3A83Ktq1OtQbumH0QF2D+QyfRmomii/M
         HU1w1ZMODODcEhduxf2SZ+OT8pt6BAvk1F9T64GWuSQATKjoStx++J+o9jvbn2wNYFbp
         Zc6PuAvPgDxr1XfqKPR3R+8lpeBY8KMlH1BVk5Un8CObaXDFntNvh8anYeTel860Q89Y
         cwz/ND676tfqtiOveFOuejibGKW9zZmrP+awXHnkW6q0Y3PosfBjkeR0Xqg5/UbcAwPZ
         CdIMEtBSJxML+tgv0FpnEKIMjA3e64BdSTNBq9sgGNlcQj2GPXXamiGZM62bdtWu8LRD
         C0Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWvDytYl9/zu3kOrtM+1AJ235KAw3Z6ukZ/OguLpjTu72Eaz8QJm8sTx9aov4ZchoctsPKDngX4/j7w@vger.kernel.org
X-Gm-Message-State: AOJu0YxIvXiW10qHs89j5DnYt40FcRtlrqSCeG4/z18pTVtU9OvB7/CF
	rbbiqjwvUzzJjKjz+VTT87rU7BrzBGH2T0mtxzI3OKSOKaGQXdxuGoEl
X-Gm-Gg: ASbGnctLyrdJwNNjhpFA3TwP0raPn2Z0orGH/xvSbNmOJ8Cxbu9nxKeUlLeoCfQnOm2
	Kah1bxuwNs5016WEsIpPHuIwb27wNGYAGgdofbLNUwYfw3yXOaXQQppfWujCPpgsrvG1V8FCO88
	f4Cr2V+ZE9RJFmN7XojjKBv+i2SBgtsBXP2xM3Bb8nvgUrepkzGRahXBgtrJ/lEDrN4tsRpBxGD
	/ViqQu5W9o3n5lZTf6N2AXRczY/wXry3uCoUQOwDDZhOa9kBwPHBHJ01uJFKnT3iHA9mAti1bez
	LqOoa94ebHsqf2DOoDFmnQUpZA6voo648JsqF9ZF9ZjPIzvCAiKF6cBNiGs/YXDfKqTHFYNAun3
	LV6xgSm+YA060zTULtew4qquRUnAo004uv1tW5vErwf5A51KHZz0rsIxaRGE6QCUHSBvT7ozuXZ
	mqUnHBk9SGRHRV+oLW4WQWrDFiqqkCwSklbAJhyoHOW1vtu5YtEqx7xTz9Wxc5vDhxm7l2eqBy
X-Google-Smtp-Source: AGHT+IErOrBaCNdpSi7aBofzbjzItcvk/RGTQTtnd70szwBznVi23Y1OUlurbOHADjEnQEG0jggTrw==
X-Received: by 2002:a17:90b:1e0f:b0:341:abd4:b9f5 with SMTP id 98e67ed59e1d1-341abd4c08emr4244793a91.6.1762412298444;
        Wed, 05 Nov 2025 22:58:18 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341d3e0b0b2sm702504a91.21.2025.11.05.22.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 22:58:17 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	gregkh@linuxfoundation.org,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	Zhitong Liu <liuzhitong1993@gmail.com>
Subject: [PATCH v2] ksmbd: clear 'encrypted' on encrypt_resp() failure to send plaintext error
Date: Thu,  6 Nov 2025 15:58:04 +0900
Message-Id: <20251106065804.363242-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251104141214.345175-1-pioooooooooip@gmail.com>
References: <20251104141214.345175-1-pioooooooooip@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When encrypt_resp() fails in the send path, we set STATUS_DATA_ERROR but
leave work->encrypted true. The send path then still assumes a valid
transform buffer and tries to build/send an encrypted reply.

Clear work->encrypted on failure to force a plaintext error reply.
The transform buffer (if allocated) is released by ksmbd_free_work_struct(),
so no explicit kvfree(tr_buf) is needed.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>

---
v2:
  - Drop explicit kvfree(tr_buf); it is freed in ksmbd_free_work_struct().
  - Keep only 'work->encrypted = false' and update the commit message.

 fs/smb/server/server.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 40420544c..a7444a78f 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -244,8 +244,10 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
-		if (rc < 0)
+		if (rc < 0) {
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
+			work->encrypted = false;
+		}
 	}
 	if (work->sess)
 		ksmbd_user_session_put(work->sess);
-- 
2.34.1

