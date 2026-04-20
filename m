Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EF239D6D5
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707495; cv=none; b=qArQ1pHRR050V4TLSUPGatj5kXhIXH5ZJCUwZfDCBXWbWq470QZI7fYtB5Wf1BNwTEtr0Do0hkJ9SG0/guHGD+vbLE6e64OeLhVvUXLhv4mFuMSBuc5ZVbK+/XT6Eih0EYvuOakyttHEnTEFbTYl0bMnkRlt/NGXl6qNblkgxig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707495; c=relaxed/simple;
	bh=uam3YtKNdr+siwieCKD8+jNVlZSofiVOKYEtdaCJ0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NX+L5bGNs2u3pyZg24gbul8+N22nfQgWoGVbscYpa3QG4TdCaCQJDK335Rzm+L0DR/uiRFUitBlZenC0N7Sgajq1Ttj5/kSvVYJpUkUwnRVHYY+xriokjCuo3kLhtC2Oe/y6fT8lxhYazXBVhmzyQBedBUAQ1n1kiSo+WSqRins=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAq8XLwG; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAq8XLwG"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-823be54d49cso393876b3a.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 10:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776707494; x=1777312294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv8YKf2c4/2CV26eV/yRwUDY1hw9RhAfAYIys2Ru/sM=;
        b=fAq8XLwGzdXaQqDAu4KgdRdU09jTgK8NBLFzeX/WW88wErAnRcaJKqEL7i5+kPuYoH
         IvTGN/45WNBP6kk1Xhbzs1F8byafoTnYqA4FdcJi+kpafl5GT/kLpAVSv/9zx3dPUwOl
         4ksuCprbklA/I74R2/LdhxJzc/rmz478h3LwiU/O0OpU8VVavz0YiR8Gm3pjfmeJPLXa
         AEY3vG7Y3l1B/zP/wZhWiOOvsJ4AAo8Fs2Y/Ss5X77o+ZkvrbcckOJP3SdQpu2gk4Th+
         y0j2eiKMlCK85S116M9579K3bYA/RIGcjLsV2WntasSZc1dXLISogHbymDwI3u6eKgCj
         Wicg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776707494; x=1777312294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xv8YKf2c4/2CV26eV/yRwUDY1hw9RhAfAYIys2Ru/sM=;
        b=UkzplVxB3+zCL2V8Pw0QYyLV6qoKZ6ekbb75GibYNHBxKJuVtY6cnfDG3x0DpRSEzk
         IrmalMvMaq/uEiKpBMDoIjHDb47FPOB2u7KoU9v23PDOtI9ZonwAsCVuAmmDy9oWti6G
         3PHJ1fXIYqa83LzGVvnpGB42rl3rYau9wijKpEnlL8xTkba/dkkcpWbgYr8I265ADxwX
         zMX5qFAx9eY9RZ2ekzGsdjtn5Qstj4QtI38DlfTi4HPVfMyJLMJNdr1KFfPb5vjCeVCN
         kIePuYT1nIITkStyYDUG7umEFxhH4LokY63n50r30pLhizGfyNt0IVN1qI7d1p7W1WH6
         KgxA==
X-Forwarded-Encrypted: i=1; AFNElJ/LZt1FAjKj/7LG99ywmVTLhx5c2ssjGCdQH/hoeNzlrenvVz17sJXLhY01YyB0muZUdHPBhuAJs/+O@vger.kernel.org
X-Gm-Message-State: AOJu0YzHOG2L7rnYX1S0EKARF2K8isbN+86DGbRkd42aCytthtvjgVcw
	p7/tQwzyVidq+r7w5IipP149nDTo7ffMiSQunBJbJfPZBwZCYfsxijf3
X-Gm-Gg: AeBDieuFJk5aK7ZiPHhhAbEmFWrWb68eZY9pVQlEPSXoGpsx5VfoXdIPnTY5SuaD31Y
	PJp7yXzPhvyRrtZjr6v/Eo/XdEwKfXZA6IWjChLt82y7HBCkNrzbR/3/Y6l4bNl6OyunoIzQrru
	ViFb+a1XjFxd0duOOnzoA1CqgMYi2G06ZMeuMOw0WsSQjIQsn8AO93yeRGx0Tb616Ofr7fbPS+r
	dFoj2np0Zd/jKjmwudt9rLwm5gP5l3DYvFF1uopfvcSqm/4weyoLiWvr5k1R6pYd7uvSjaziJ+H
	4AoSUrNITEj7PyDB7XcPEPhm4JgFX474zFJjpxvhw3gbDrkEa2174SCHmqQnePNVVCcaWOilb5u
	QYqx+GJ/OObFcYWrZ5f38ie7Za/OxxqUMF2q/N6Apm/zl2nqGHfNX492tYSe3d5wte2CUcmb0r2
	IWCkyyHV3a319zY4wIgEYRKpMU4UQ=
X-Received: by 2002:a05:6a00:2d03:b0:82f:6a82:4231 with SMTP id d2e1a72fcca58-82f8c85475fmr7428020b3a.1.1776707493907;
        Mon, 20 Apr 2026 10:51:33 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f97eb5ce8sm9299074b3a.61.2026.04.20.10.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 10:51:33 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 2/2] ksmbd: fix CreateOptions sanitization clobbering the whole field
Date: Tue, 21 Apr 2026 02:51:25 +0900
Message-ID: <20260420175125.3341090-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_open() attempts to clear conflicting CreateOptions bits
(FILE_SEQUENTIAL_ONLY_LE together with FILE_RANDOM_ACCESS_LE, and
FILE_NO_COMPRESSION_LE on a directory open), but uses a plain
assignment of the bitwise negation of the target flag:

	req->CreateOptions = ~(FILE_SEQUENTIAL_ONLY_LE);
	req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);

This replaces the entire field with 0xFFFFFFFB / 0xFFFFFFEF rather
than clearing a single bit. With the SEQUENTIAL/RANDOM case, the
next check for FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
FILE_RESERVE_OPFILTER_LE then trivially matches and a legitimate
request is rejected with -EOPNOTSUPP. With the NO_COMPRESSION case,
every downstream test (FILE_DELETE_ON_CLOSE, etc.) operates on a
corrupted CreateOptions value.

Use &= ~FLAG to clear only the intended bit in both places.
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6a60f97baa60..38d3bc66912d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3063,7 +3063,7 @@ int smb2_open(struct ksmbd_work *work)
 	} else {
 		if (req->CreateOptions & FILE_SEQUENTIAL_ONLY_LE &&
 		    req->CreateOptions & FILE_RANDOM_ACCESS_LE)
-			req->CreateOptions = ~(FILE_SEQUENTIAL_ONLY_LE);
+			req->CreateOptions &= ~FILE_SEQUENTIAL_ONLY_LE;
 
 		if (req->CreateOptions &
 		    (FILE_OPEN_BY_FILE_ID_LE | CREATE_TREE_CONNECTION |
@@ -3077,7 +3077,7 @@ int smb2_open(struct ksmbd_work *work)
 				rc = -EINVAL;
 				goto err_out2;
 			} else if (req->CreateOptions & FILE_NO_COMPRESSION_LE) {
-				req->CreateOptions = ~(FILE_NO_COMPRESSION_LE);
+				req->CreateOptions &= ~FILE_NO_COMPRESSION_LE;
 			}
 		}
 	}
-- 
2.43.0

