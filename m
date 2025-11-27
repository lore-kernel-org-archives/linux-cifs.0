Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D42333456
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255921; cv=none; b=FtyIOrWMBdBDW8AThWQxLnMkbmxBAW3kFDlQSqKmLbx+/uzqvw1eMJnZd57EvOMtf7Gr+lqxMKfYUpb8cEWIZ2uarkaeNdt1ZrTvZ3VbqI+9V60L3+4VdRRME7uWyqdTJj/YkEZJvSLwNfeGL1GHl8tKHzZOIscj3cRQ8ecfkvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255921; c=relaxed/simple;
	bh=ip5685HuVacOSDFUg9j81oJuSt4lg+bea6HTh1DKJAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pzVo/0Aq2kwJS2bgTauRkEWecvsBC71vlI+dLLNk9yOdQO2CnoXcyGBr1EiBUmkhGmGAKPkiuVjro8UIY2f4srA3JGX3EoCsWmWf3LUbes49HmgRiSu0tXh/YL2/XjhIKkxV4ykHYGT5jAiPeTXmr3DQvuJQ90vNoDX50Edxh2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEj2DlJt; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEj2DlJt"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-595819064cdso1316326e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 07:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764255918; x=1764860718; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cqIIQBY8ET4F2qvPv/LLUG9+o1F+aM/rmaNxvOMhsvM=;
        b=GEj2DlJtOiFYRuxksMAexpbrfAcsj3Cc8ATb5mPB6/qhHAMX/wn0RT5EI9vRQYYuVE
         mSe/Dk5bg8P38LjAJ3JB5q3PHu2TJKeKLW5ooyWktKSheKI7ZCsqm1/4+QxUSBi97lnY
         uBCauAi5XPDKxO9fx23iPXLEfHQ6drzBdgoy3GWpLpsN/ehB5KUJjaohUHdhNA3hmQA4
         o1hUJvGFBTXRwB5WbRSJQ8N/oezFlGpvGc+plnGzJANI0AUeIeSlTUJNJ+lyORPx2KbF
         uRiEuZ/L7OEDJoLTbGmjXBYLmhe2qb23wFyDxlp3KtLPo1LEUr7CPhYFIxOLFUwVoEul
         2nNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764255918; x=1764860718;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cqIIQBY8ET4F2qvPv/LLUG9+o1F+aM/rmaNxvOMhsvM=;
        b=ZK2y8rMxKQIEMrVLQr/BZWRQ889QYoa1gDn79GUpPs5s7Vp/dwU9tEJFH8S8trPxjk
         G6pkWG9kJKNF8QcEAOx1myQhwFErKd88g6VmX7pv6QSybZmuSV1NSKyunVgokJENVb2q
         PrZVNoSkdZGXYrQcavrKT+b5wZVPP/rDhoX+Bqaqu47iCHve0QT019vYg4gOxoStU0bE
         d8mudypzikfwD14QbuqsUu4LiKqvl321crLQDFjcPV8EP44dIrsA45yhG2pM2/0fog0+
         xUNwjEqGViiaamOBy0OVgFf2YhubZYmSRjQgyNYoiRpuln8YOSjmgHJ7s3ZarFB0wg9X
         oG8g==
X-Forwarded-Encrypted: i=1; AJvYcCVXoOYChani6dCjVLrYzzh0gHSliz+pqDIfbEjj5G1hyJdpuiGvAo0LDRpAX1O9W1S8OP4otZ/SQkgM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm/jW/ZXXTvhs8KfQAw0kTzakHtQH4ofOhtDXkO6ZCKYWMQmFq
	nsebTRmDQ9odmFhjGIv2oQIwtbvRpc4l0D4XS9GpCyZ9JcS1C38kwkCm
X-Gm-Gg: ASbGnctIXPFj7aRFUSqe0YtelJzjOSUFVIYdrUb3bqAiy0wBSwyHYNcqFbyaNC3jJGL
	zzfgNEPZ9Ky5aPXCvQUyKKney0xXX4tb/HWGj7NU+COnjnykgRA/iC8Ae92ZecnFSUrCNEfJ2Ne
	qQ3zJd+sfx73akZlizOSSN1lCqz1yfMg+faOiE0TXU4g3jLcItxyvQ9Be5tWeOy1Bqh7BBN6Xk6
	63Q9AngRR4xTJbjs7gBtXswAUzmhSonEYqT3psIvE5EtOmuXYMpJQihDqeXNE73H+v3ggqPP3N8
	8mc1jHQcFsdpmuSeL0JX468KOBXd+rS0vRpuiSIpR9xrhIht4eOvEqN9Bt+WrOyu3jRna5Pej1h
	RBdBHvxDgd+7QY3VT6NIwQUp8ID7f4nt3EtBrStPj/z4wmLocp4+CKasTsy38yR2p5il44hoZjK
	dKfgR2eo+0Za5Hcihp4iECBH6Gv34=
X-Google-Smtp-Source: AGHT+IEdfHstPGMT6ATeY0hKxefvApt5zTTLtNMGQ/uAsE433oloJwXugl3AYp0K+M5u6nZD6O0mTQ==
X-Received: by 2002:a05:6512:3c89:b0:594:34c7:cb6c with SMTP id 2adb3069b0e04-5969ea1b9e4mr9365995e87.15.1764255917737;
        Thu, 27 Nov 2025 07:05:17 -0800 (PST)
Received: from cherrypc.astracloud.ru ([81.9.21.4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-596bf8b0ea7sm463504e87.42.2025.11.27.07.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 07:05:17 -0800 (PST)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
X-Google-Original-From: Nazar Kalashnikov <nkalashnikov@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nazar Kalashnikov <sivartiwe@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Sean Heelan <seanheelan@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1] ksmbd: fix use-after-free in session logoff
Date: Thu, 27 Nov 2025 18:05:10 +0300
Message-ID: <20251127150512.106552-1-nkalashnikov@astralinux.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nazar Kalashnikov <sivartiwe@gmail.com>

From: Sean Heelan <seanheelan@gmail.com>

commit 2fc9feff45d92a92cd5f96487655d5be23fb7e2b upstream.

The sess->user object can currently be in use by another thread, for
example if another connection has sent a session setup request to
bind to the session being free'd. The handler for that connection could
be in the smb2_sess_setup function which makes use of sess->user.

Signed-off-by: Sean Heelan <seanheelan@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
---
Backport fix for CVE-2025-37899
 fs/smb/server/smb2pdu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d2dca5d2f17c..f72ef3fe4968 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2252,10 +2252,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
 
 	rsp->StructureSize = cpu_to_le16(4);
-- 
2.39.2

