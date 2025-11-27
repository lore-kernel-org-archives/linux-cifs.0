Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DCF26281
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764260000; cv=none; b=ChGmpDFjMfkZBr/0j4itujhKoVYscElop9xkao4zbDmAxrODpwNT+X7CnFU9o7geQzSQqbLZ+uCSDIi5DhEGE4T5DMtAC/lXx/Lnaj+bDXPGU3kFMNYIxb9/hHpLWzhP6OPiKDNxPCubcLRp/JSbSf/yFQ+rJm41HcZ003mMNH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764260000; c=relaxed/simple;
	bh=0Po3kuMxw9NSurS8GIK4ciWsHDkIjRfT1l+sH9pfasI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aDqGANU+5FusRWzuwpjHKcAzrS8K1OQTST5Ekf11XVCWDEm/XWTu8BOInPZuGx/npa0N5oUQFbitJmObs/FRBx1BCKyfJbMKj2TUQTEH9IwjIfgYm2fCSv/AAEnoE2p+tp7Frl5wTIoTkgpWQUhojM1ACFofi1Es7Jbue429aHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgPoocH7; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgPoocH7"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37a5bc6b491so8802221fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 08:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764259997; x=1764864797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3/Z+H09K8YYLfwSDwuJjkjBRQpHLPc95WVX/pq1mF2o=;
        b=hgPoocH765OAsSRmFqaw+mZH831cFxH4EP/vpQD6V5BJli43Rk8nsvR3UzONz7+Gw6
         NsORo/eD8bAqrihaKV8PVcCwfTbAr/itE0IUjFoxFlzF6oeBWgd6CfAHOwsBm/ohuyhb
         e7ZopfRic0ghSTKr7BVr9m+JeawUrpR5YyUFk7tLg+YMlWFs4hqWA67ISrYXrBq/RaiH
         ehBS7osPHU3MJXs7Rzo4c+64MWDCM26JC5mYJK4Pf0m1Avzn2M4LCSVQwBulTHjZBw6h
         LjCD21ELh5+I8G98Tdv3nm9mIEMlZyVfZcMB2WPKtfXBON5kiUE8wk6zuQvNiEytWJgC
         pGlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764259997; x=1764864797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/Z+H09K8YYLfwSDwuJjkjBRQpHLPc95WVX/pq1mF2o=;
        b=eFOUhm7H5klaBQC28Hrh4WspEBKqpOsIBSWCwLzg3TGsGf2JpiSLxapS4Ph2KjeCNI
         LOwv3BlHIQLt7RIqDqWsnGC33NSBLOziruhcyMsgVDiGW/eWM3iGKWHm6xr57jRPNffD
         lEMLiYfhBt78Pv9fFQflMwpA0aqR7vRKq+Eg7/eetd111QejxeCo3bLbtD8VnDskFXvp
         WB+PdroGaMy1LOK8UfvnVXFN9O+pydTvxwIvQmu1OjtC6lDANEIPMmJZFTeTF2V+1epq
         /vcFaNCU7fzRXIY1R231hAjorTAD6ql+Em+gfVBQ1Dtxg8gmwD8GOUYvByCIKmFAW73Y
         159A==
X-Forwarded-Encrypted: i=1; AJvYcCVr1Ig72lZaBERSSNbbv5RWlh+QOFRHGdtWZ+2p4FXklWOAyotUO/LiKJkD5xuhLfiUrCXpDPjNEOUV@vger.kernel.org
X-Gm-Message-State: AOJu0Yyilk6imXMVstzryR0kdbYylPsZ7xYYB343FnZNiFF+oIlPOZin
	zK0gKoSarm99U7dXxwNlPO5AJCp4/J/9EAtdKeKClatX35g3OBYRrnd2
X-Gm-Gg: ASbGncvV7HDMx6UZlsZaScED9V1Ye2cJ0BAlTIHXucLyWrxuhUDvAsIdd879DGEJ/gI
	TXbJUaZjU16Itoi/eH7z8zCBQppvcg186JCxdPd3HUHs/ydP/uPALhQNDNIn+ml5XQ4ERjNCS07
	2XkDpDAZLtsW83zyZCEqvz5tOcjCU38ueRfE+jmEaLqMRTOwaQ2FOArLykosD0xS6JWtQXk3YCA
	YR0y+S6PktXns7I4cndIZ28csfhG+2VKZfGLjFo6ICP+b1IMSooO1VutBHqTd7ZIoaQqShR6Ooy
	bC8Mqt0074rCQfT/WrKspHo7SG78CMWBR38gO2UROcJ9iX5ESTzkcHS5WVnL0DBwy+XO3d/glu0
	W2auApbCVyguqJvtXNJlMVJJ52achRhTTWBDomuaMQ6rQ3QncTc5vMl1y9kLPlYUiZ+UDd+j+x6
	d2OhzjOUfV2puJ0C4QFw==
X-Google-Smtp-Source: AGHT+IHlqZKW3RGfD9KM7kg5E7xEkc/mxYEEWgQnVCRsAYnmr0KWZSxRe6UKez63lOWwqeEbjWWSwQ==
X-Received: by 2002:a05:651c:4399:10b0:37b:a395:fd8b with SMTP id 38308e7fff4ca-37cd91641f1mr65655311fa.1.1764259996764;
        Thu, 27 Nov 2025 08:13:16 -0800 (PST)
Received: from cherrypc.astralinux.ru ([81.9.21.4])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37d236e6e5fsm4648561fa.18.2025.11.27.08.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 08:13:16 -0800 (PST)
From: Nazar Kalashnikov <sivartiwe@gmail.com>
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
Subject: [PATCH v2 6.1] ksmbd: fix use-after-free in session logoff
Date: Thu, 27 Nov 2025 19:13:33 +0300
Message-ID: <20251127161335.6272-1-sivartiwe@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
v2: Fix duplicate From: header
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

