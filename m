Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140BC257830
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256383; cv=none; b=bj4O7hqBTFC6UYqCRTO0nyDw0Po8sNHU+so7oMueWwpyJl8usmPaKLaEYEEgNAM0Ct1TTXb7LQomCQh85Awncd9NchsDzLHzjJccqtFdVMebk4mAXR1UaSSQ7o4GEc0MTeEBPhBRwzKbQDgHdkA7egW5aJCoJ8K0Frh+kSdK2VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256383; c=relaxed/simple;
	bh=L3wH1dZ2OsI4qXhVsrxGUjiBqTWXd18/FbeuIC0+2r4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mZlNXTl7BCSEu0pCNQUiPHP0+sOjICJ/bKDFj8xnHzniux1kp8ib40fmwmF+k9sj5fTDGESz1WBOt7OM+EiqukwCOmarG/RHR7VJYwmyJ06M3xGW0GpTdGip0jktopjVyQX3TrPOp3IwCOCHBMU7Okzt2TF8aMwI4MbWhsBI7YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NqFDVA6r; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NqFDVA6r"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37b935df7bfso9325231fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 07:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764256379; x=1764861179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ED1C3ibqhXI9fuhgTYBvzdlG1H90hVJ8Fjdd0YUiAJI=;
        b=NqFDVA6rjvxVAd4FJpPzDS71sCRC4x0DBKsQqPg2gjNvZDXsbEyyUS20PnshKHmfDa
         GWIxstfSWCqZXV5Ym1tlr+ZJmuR83TLY35gpUVpOZLfBy3RRst63Qsy7cdHbQ8SYAwVJ
         4xxfso4nTCmxZNr6zU/mBksgRS0z74se4oFbMZYVIOoduxtqZIX1kvy97/udNa5afMTM
         xdFJrNmm0XPZOn0HrK1Sihqj9C/WsSH6u9d/eOGICaAYx26Cyq5P6I1dKMSHh019iAvi
         8loAtSdYJRLqHeygqXRwgUViEsOszO3IxkzuQkEVnMsoScOu2nKcwZuQrdYrgl9FAQsA
         ovew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764256379; x=1764861179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ED1C3ibqhXI9fuhgTYBvzdlG1H90hVJ8Fjdd0YUiAJI=;
        b=TzaDHzaCiRVk84LjDbP3FPYCTGiWMwCryPpo0wRkaMuYvVNCFY3KLu5zMXmKs+8w/X
         3O91psqu1yqj2lCjYqDA6JQNBF892jOme6Zz5w8hzjHu86tJvwBXwi//e12k/ZbITqwg
         dNzbm8vi8tEACO9LbbC808zXes9NumSpU6pSeH3WhUhF3QWyBwFaggeUrSKvWJ81GOPK
         gq8fLZuQK/2L8VwiKoh10N3SFQ8ZBLV4ReP/ZrhDgPwmay9OSRhSpJ700N1ojOEefyZk
         k2Otm9C2PAhrCv6cliX8Plu7q1YcVCrqs/TiFzVmqd2dn6M27C+SFTHkcP6BppyT0cml
         XtDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU173MjeIwoNdQQotvvbVSQmJSnqpF4Srh2NGxcNnATOHZmPk6OhxHq8HRPHifPYpUDhiwtmlEOzDk2@vger.kernel.org
X-Gm-Message-State: AOJu0YwRXvI41Myc1DZ9U3K+ks05ReSFFHbOcspOGv7mGaRXjF1kK0Fm
	V7KXa+0bmWdg4HGk2IpajH49j3GcdriKJaVysbQlp92ldQXRavoJ+60S
X-Gm-Gg: ASbGncvsD4lvDdKiKrvWa2fNWCZDxbqgsT2Qr3BO4aClxcpDoP1yBqq1MoBK66P8rOg
	Qb+rvcl6ZdeSSYSmvLX3mHeCFVeg4J/DVw4rghZNNjwe7rkb3L5WzEVLMful41lXzNeN+ARyDr+
	VWDWVGxEmOJGuTqqe5Rw3cYrjBpsfP8QE1/bm4YU68wSN5xofbxdkqFMq5R3gU1tgp3yOqHzJfv
	DYLt4yd9KtDU2xscaJI6UppqNrQEH6suQKvdC6hnRMW4dHBk2nFS8YcuJW+NHpVA4BsPcN7CEMD
	CdtaoCpZHy1x+8s4T11iZ4bEinWixmCMHPUXukcT242Xf+8jD+5KFqVj55KyFe17k73gkBhqC3t
	crCSpUnn9chiRx1KDpQkGLGLc9plzTrsdX5Xkb1g+08B0LSqvAICQU7xEQ21yMzuYGss+5qhdvW
	JEcHSGanFD7mxfIHmdr7AMa0c5uhY=
X-Google-Smtp-Source: AGHT+IF3H290YEVRrB7mbBY9eiIKdjw3YXsiJTPdz10I9RjESS09gqJtTisxKUm+Mdw2RcCSA11Xng==
X-Received: by 2002:a2e:9e58:0:b0:37a:2c11:2c61 with SMTP id 38308e7fff4ca-37cd91874e2mr59529531fa.4.1764256378814;
        Thu, 27 Nov 2025 07:12:58 -0800 (PST)
Received: from cherrypc.astracloud.ru ([81.9.21.4])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37d236b7e97sm4329601fa.13.2025.11.27.07.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 07:12:58 -0800 (PST)
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
Subject: [PATCH 6.6] ksmbd: fix use-after-free in session logoff
Date: Thu, 27 Nov 2025 18:11:58 +0300
Message-ID: <20251127151158.107004-1-nkalashnikov@astralinux.ru>
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
index 9f64808c7917..a819f198c333 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2255,10 +2255,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	if (sess->user) {
-		ksmbd_free_user(sess->user);
-		sess->user = NULL;
-	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_SETUP);
 
 	rsp->StructureSize = cpu_to_le16(4);
-- 
2.43.0

