Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB436B928
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 23:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790983787; cv=none; b=WgFhclX+NP0ajpA10h4CvXEqgiTBcGzWo52gkXiMwte33MyKKk7S3kxxTikIQDNGb8vJnAMVF8iMGUtjYb25Z4KYy6SsQmnK1W179SHSRCnnGcu4wwYv6Wk0z5iCnKHlPK2wb5/QEEF0LDHszS6R28Gh/hxKCkQJCB4HbnHsU+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790983787; c=relaxed/simple;
	bh=q9hoYC77TAOBI7UPGkqjKa//giTHqLClViyb2A4XOpQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eop8CSZ/c11qaYoGzCbqrGPJ+W1x+rLVKj2XKoDR05tqfaT9UIG0dLvNgoQ0LwJTqdL+rPAzJVxCdVdCM7qpPWghYCQwV4sT4//sC1D1sEzGW1JFKaHYywv3/KlFb688i0kTZf0AfZQ43Xtm47saajkUJBTwK0heUu5Lm/QtFbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y5jPrgb6; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y5jPrgb6"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a16629a040so3314785e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 02 Oct 2026 16:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790983784; x=1791588584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nxHrVIR24GDD4S7L2ZgpY+muMq5UDZWEAxE61ARdg78=;
        b=Y5jPrgb6rsl5pKRpoyjjCb05KEg9Dy1wOneoOrfX+R9D670m1/zwQYBzEJU8vqNovn
         Gy8pX4HnsE4ez55G2+b/gZPt27CQZlcNlf8gJoupavwqQ36VlB+wv4AtItFM2cwL6+dZ
         fNT6Cpt/eK/SpdURX+DdUPuAf/sAt2C+mW1sydQyIcL/uQi5EjS1Of6oLe/6jd8h/krY
         beYVDBP0hqLfw1WU0L3xk6B91LB1sbjRHuNqqzDaibC1Y9Cja9ajdQ8qrt3oRccz4EvG
         C5Ij/peMiuzn6+ClJhvxZiZ3m6Of3E79qVj0T9PSNPbQ6xcsuYW/NODhykzfBmcRteD+
         MhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790983784; x=1791588584;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nxHrVIR24GDD4S7L2ZgpY+muMq5UDZWEAxE61ARdg78=;
        b=ttx5rPCFURavExh7twJ2a5Gz9hl9kkfOl3tNeqgHQpXYkAOpJfJtIYb2G5Kyu9Efqf
         CHX7hzw8fiOE8mjoYIr6LNtSklg9/Te4SeMKlY/GmFGWEIvQu2hNBeo72uvkQe6HjLsg
         MRcxHhJ+Aayte39u9iYCxsSSzmQaT+Q9nFkEL8qL0cZIGyahoz6FQDvQEubuVtbNSIXx
         UCwlQ14/zevxQ2YCxXRjLHLLiNaahR4s+Fug+tR9mE0f6gsbC2oe/GkNFtRE/ec0JYPR
         ZwVWB2zLEnECEzd6d0GMck26pL9gpnZAGvCgGQRbqm7mF0Jf0ibwhwKRPdOMfIaiRfRZ
         9orw==
X-Forwarded-Encrypted: i=1; AKwUvBygkaOCfk6NSF9RX/dYuYe02+jktFbRgieUX3NF907vI0jJkDIXI4S7PPRLO83346w5EeITy51fYESz@vger.kernel.org
X-Gm-Message-State: AFuF++k0fTVX7nZxXvkHeCGAPJQ+unn7Xj7XsnO6CKAmgVcbLKKuToPj
	wU0ddsRFa2bHONxIedOid2B6PyPxz2Git/PsYjUYCoqHmuyP05+cforh
X-Gm-Gg: AYBFou0oDOWVlhWDoCx2L4MOWS6CMaeauV9pnRYCPsxwy7N37rvZnWjC3dI72eNqZ7V
	LGloHu9HX0PD8ibkpTcIyYr2aUuOs+Z6Wab+Lnyi+1MFDuQ8eD8oeSItZoLuw+34kKnJkPh+uns
	3jgT41Ao/M/ANW6D1a0KvQg3+eel2yUTFl7opRjWzR0L0r0FaKkaxUtPR3EuYLNrr8BgIU5Dyox
	jkw7fDh8KZUWSYgjL+Z9EMJH5L08hvs/FrNEco0ecovC2vBQpq+9qRGE7gECm/K04M+TCkmyisV
	xklFl1FvqibOQWIu/FG7pfUJC/eZkshgVQIhtzGLpGU/fAqWud4Q3zHbpi9UFqJQd+EFX+78bWa
	iWAlfXgocM+Z8YMAiecnlJu2jNzbODtD0j/uGW/XSq8wr4Xo/38/YsO2eFNlm/bQbrHDwra/3XF
	oPoF5RWb/4U/xAG2VN51XJenFmNvHvQRyarHZnetD/dT8CFHz8FiVIB6IEFJk+q4l985nbzX0kK
	R1zqhBliJF0loDydgPNIzG1tRgabLtzB51LbyVvDnl09RexGVuR2inVENJ5mUD4yAwm89jV4JOo
	ZAT3JxI28mO8S3V+umNJ/nLy7OJRmZ+amNX5kArzmfwFR6KbQZqpSwc25TGqvL8Wo65p5mBQOZR
	9sn1ehOk89A8T
X-Received: by 2002:a05:600c:3110:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a168069b91mr14580305e9.0.1790983783964;
        Fri, 02 Oct 2026 16:29:43 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-af35-1901-81da-eee8-c2d0-ee3b.310.pool.telefonica.de. [2a02:3100:af35:1901:81da:eee8:c2d0:ee3b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fac3csm8688932f8f.21.2026.10.02.16.29.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 02 Oct 2026 16:29:43 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: use u8 for SMB2 oplock level values
Date: Sat,  3 Oct 2026 01:29:38 +0200
Message-Id: <20261002232938.40011-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB2 oplock level is an unsigned 8-bit wire value, but
smb20_oplock_break_ack() stores it in a plain char. On architectures where
plain char is signed, the value 0xff becomes -1 and cannot compare equal to
SMB2_OPLOCK_LEVEL_LEASE (0xff). The acknowledgment is consequently rejected
with STATUS_INVALID_OPLOCK_PROTOCOL instead of the intended
STATUS_INVALID_PARAMETER.

Use u8 for the request and response oplock-level variables. This preserves
all wire values in their original representation.

Fixes: 80a56d4a826c ("ksmbd: align SMB2 oplock break ack handling")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6b8809f..6074bdd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11444,7 +11444,7 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	__le32 status = STATUS_SUCCESS;
 	int ret;
 	u64 volatile_id, persistent_id;
-	char req_oplevel = 0, rsp_oplevel = 0;
+	u8 req_oplevel = 0, rsp_oplevel = 0;
 
 	WORK_BUFFERS(work, req, rsp);
 
-- 
2.53.0

