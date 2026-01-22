Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B825A349B00
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 02:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047852; cv=none; b=mwhPzkBSk9WmneFSdQtIiwxy7p5rNOq16iRm41ZIUCugqzSWnjtjE8kViXVWSbPpmGDAXnGAT767zQTx32VcQ2gqc7/bXGrH/0y8Kh/2x6HrjV+6FXpTHw0Yihm5I3QZY47ovMZgUXwosSHGOQKhnRXctcwANxxd0kFYlrEtTyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047852; c=relaxed/simple;
	bh=G66EWuJIRf3dPEbAum1+c7XXWoBPspYm0WKrtwIzvEE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hpcGLUMclrQdYycY2Q3u2kkbqY6k5eWuz1Syzq+rwkUM0shqLpcFHK/kdQdzpPvOqaVm54PO6xGT6TYueH2XiymqhlxL8azFWABCEKMS2Pp1b+UjGuyLCItiVpQXLnJraidkhZw+L0vkQa2vnOAZZ0EWpxvR/Yo7vkS8Di6KvTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ec0og6xl; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ec0og6xl"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a76f90872cso2594285ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 18:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769047849; x=1769652649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U+v2634kVJ+SsDKjB7tM4SD9Z9ptuM0rR4tFrzs+qLY=;
        b=Ec0og6xlVoYPyp3Hncmj458qx0jX3EM6gu8BfSbo9/DLHbih8kUu0/uD2PgKV5qrGZ
         VAAcJnnqlEatqAiMSIDqnNKsME0cbZShTgySUxCgHoVddkW/T4J5dTN7xMvg8hvFkVr5
         GJB387Z88mRM3oMl50iAZVWcE+6ypBX4C+2ain1Yy7k1V4UcZuPYZt+v0JMFJur5W6vM
         fqecJ2y/lqlCKq6oZ6QxIwtYnJMnkBAHj3tTtAYjAIlKtC3CcBZtba/6udFc41Fcod6J
         rZ/tTnhGNVRXz7eaT2WNZ+CQ2p7M7bbvIPoDHXi3xeDd6TTDH7gebiYC5yNF3nurEVqo
         xwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769047849; x=1769652649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+v2634kVJ+SsDKjB7tM4SD9Z9ptuM0rR4tFrzs+qLY=;
        b=koadblaU/Ir++RSXq052bX59MHw7ujGKi4vOmCO6fe0XrB0hWz+9FOn2Q4xSROPL/+
         AXAP1DnptTBHUVDUmuoMGalD8Vs8ke/z5qqwSNpT5dEm19xPv1jsH8r/kTPBCQrCeeo9
         rGi5BfduSHq+znx4fjiQEFMk+udHwBZ/IGt6cKtpEgRwgNKP2uY4+J7ZHwrorN8IIgSD
         gPTtATtsyIIqXSL4I7Vtq6/xgobhehP1b/5cVZMICcKNyRwD3kO6AT09prel+sRIWBBB
         rF0Q7TIEJm+SBe082fXCkN3nAa/1N0c0l+CW7rTGdq+Lg+0QhVCghhyPxYYGewPyvUCw
         Ch7A==
X-Forwarded-Encrypted: i=1; AJvYcCUyXbN/nRV8XXbNy+M0wBeTQYhDuDhOR59n5E4DswWjnEDv3Vr7cHBUfruo9HqkKMV9BT8D9l9Ddkvk@vger.kernel.org
X-Gm-Message-State: AOJu0YymbssDq/HrgzdC5ErnlZMyxSkOC4Gec+JVaupKAEg+vdcLY5tQ
	SG4L1j6kssdpM82lDF9pufUuLoTR4mUegGF1Mp+UmSStkjnESa6rLK0=
X-Gm-Gg: AZuq6aLUM10vRbKQD4t0qA1X1k67QGl3wO8xfI0spRzKyuE30WRkVKKNoFIMd7oAAAI
	bMCf5363JceW4PCr1EZsUhuAp87wX9B5BZD4f7sfqmESUxDMJr/X5LY/qoxiiZ5KJYr7WxGS0uq
	bwNx7c/B6XLFNwkz1C7zcXR06DCuxATflm4wRTO8CwSihph5ed5cWG7exWECMMUQYNgl2KUZQCO
	MuSqiOundzVhLdtf6Iyh9kBWjsc0+t1yg1vgBK9HaqzfwfUKkA35BVcg2BIhsjMWw+DbNzzpOZR
	v+ueXOio7gKwBQ/O7bmBnEec27Qz1DJUNpn8cglC8SRcH+vEX0y63l7l8q2hu8ibFvqzU9VkaOp
	uH1fK4KY0wGYmGUPfipO6bVuSx5qnRollfc1w8DvMz2cLU5i9TVNk+WpYiWePEc/e17X0ceGdgb
	ejkYv5ESg3JwlIFqA=
X-Received: by 2002:a17:903:1ca:b0:295:ceaf:8d76 with SMTP id d9443c01a7336-2a71893cf55mr199951955ad.47.1769047848994;
        Wed, 21 Jan 2026 18:10:48 -0800 (PST)
Received: from DESKTOP-BKIPFGN ([38.76.140.13])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7c975c386sm12590035ad.73.2026.01.21.18.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 18:10:48 -0800 (PST)
From: Kery Qi <qikeyu2017@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	mmakassikis@freebox.fr,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kery Qi <qikeyu2017@gmail.com>
Subject: [PATCH] ksmbd: validate DataOffset in smb2_write_pipe()
Date: Thu, 22 Jan 2026 10:10:16 +0800
Message-ID: <20260122021015.1954-2-qikeyu2017@gmail.com>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The check of DataOffset in smb2_write_pipe() is insufficient. If
DataOffset is 0 or smaller than offsetof(struct smb2_write_req, Buffer),
data_buf will point to the SMB2 header instead of the actual data
buffer, leading to out-of-bounds read.

This is the same issue that was fixed in smb2_write() by commit
ac60778b87e4 ("ksmbd: prevent out of bound read for SMB2_WRITE"),
but the fix was not applied to smb2_write_pipe().

Add a check to ensure DataOffset is at least offsetof(struct
smb2_write_req, Buffer) to prevent this issue.

Fixes: 158a66b245739 ("ksmbd: validate length in smb2_write()")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
---
 fs/smb/server/smb2pdu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fcd0d4d1fb0..1f1086023e74 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6932,6 +6932,12 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
 		goto out;
 	}
 
+	if (le16_to_cpu(req->DataOffset) <
+	    offsetof(struct smb2_write_req, Buffer)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	data_buf = (char *)(((char *)&req->hdr.ProtocolId) +
 			   le16_to_cpu(req->DataOffset));
 
-- 
2.34.1

