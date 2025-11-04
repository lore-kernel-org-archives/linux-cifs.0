Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A09032C33E
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762265547; cv=none; b=U36F4hfM8F7VGhbjhShI8UbCQBvn61tgDVM7LZexSvgnGaEfwN0yJoRBIVM0ahNf2OPRjVuZNcxtgkngWl8lm0Oxb5HQPdsSnOSf42uNSrBD3jdYDhNviukd8pq97rBKDKyPbZOEbkCFE+4HwtZNyQ3ZEykG9PJig9UaYkd7VCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762265547; c=relaxed/simple;
	bh=0nrrlREagafRXQeDgB+zbKiCfD15/eLfwA/KcOk41RA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jv9ecTehjMqLYlx8SmFsjFgCTsKZB893JZVvS4+b9ZBod0lK6ecer3+jC4d9/JypxylAr+rGj5wrwP1bEOSuikpsJ5ngxkqk5QDHH6ioGjScpgFq6t3+1MJV3cI5/QwrK4PhQWMMY/UNAO3H2GI8W8dDMotw8mCyLRJ0Z418Io4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=imm7HD1R; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="imm7HD1R"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2960771ec71so975505ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 06:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762265546; x=1762870346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0HPvUdMK3sKhI8XnoOYJRY8A3cM+jePDjpaUPHvJoM=;
        b=imm7HD1RNd6jMNZCzpRX7BzlrZbNqUjvsp1l3W8QzrPX4q3dh8vszmrDZW389KPT5g
         Ng7BCF7jeA8gul+hQRDjs5UBYwwXf1LcBAdhsNRDKLe69zeVswZ+xvufRnhCLavXbVWg
         P6EC6qepEglAMefMYKwaiJEcqcUC4HFxAXqBTYC/l3HIGICMWmY/siWuq0Cs/dZ90x6e
         FlywCoOaB4Md6nEMpEENe/dNGrGQ/Z0vpYfpktRsyEmbdcNgEZE2YePcEW4o3rdKYD7N
         lZMlbVruGTUXfdXdw8oks3+TYHsO+8ukWDTB1lO+HZhvqTf4UObTndUdfJNT/nM8fogM
         Apaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762265546; x=1762870346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B0HPvUdMK3sKhI8XnoOYJRY8A3cM+jePDjpaUPHvJoM=;
        b=DzFelHIFq7QI1w4womdrIs3Dvm904CkbFNLbjdlwzzm8IhyFHpN1wKiZAFsEie0X/O
         ko7dPHOiLw+lIvRO2ZImzbcAyGmtE74UdVBvpJgYHd4XFqFfHlj7MTYVJ2CxRI6PVKyE
         DpBxBKKp8YuenNFjluuEkM5AOxTnbOEF3Jkj633znMNaPDa0CFfUa/OVmGnltghorleo
         ZQOe/Gq/xAFWG9zvs6GVoPLKbgdzKvVeyhAdk5YwZfRtCVBZ5I1VQfAcN7492YEpyf2q
         lXz/cWl4caozn+O2+jYmVHT0gJdwfQP6xjq6Bae59MZcGd2CEMXnZ2TpJ8XMaIAP3UMm
         MJag==
X-Forwarded-Encrypted: i=1; AJvYcCWIeCTXbrZzZylSpzxIoLY9VZOyh43x1JtqaWGDQsGlYuszxIothtI7cQN3CisY9qJU4rHlfbNvNDIx@vger.kernel.org
X-Gm-Message-State: AOJu0YxwklJ4SPGPeGGisnHl35fPeMELbB5XmDl7tvbIjzv4UghcWlaa
	ihnjB0vqZf+3CA291dxg+KbF7yjD8kSvY6NTZTcafDQ8BT+BPQK0/UuR
X-Gm-Gg: ASbGncvmUaHtHyB46H20HXnVyJwjCDylAIcc7aarZ0aZTAHrBbA8Dw+2WtdVvgSwOuU
	4Czu8O8nRicpyTSJDXaAmDucUzQY3VLXUNV2+ifQ+oFzzUhHzVBJdtsFB5qyVf3dLX+wWXg6dTc
	D9ylOsj3ayd66AEQqU/YSWZn08SUZlbUq8cafoaQeBSOjMZ/Al8inchqgP4PkhaBNLn+lnw3wpC
	oJg2XJifReeeN77zKL2HRJZf3G430XXp2y0qhCz1p6k5hbCIW9FlQWROY4OIrpEhg5tQ18Y8pTp
	0i4a95btDBSJdBxI+fGlv9Wrr5OI5d01ZSrAJ8jeogvHTYeBCx4fP1bB04x4SDjcFwWGLztxYiq
	JlrAPLohrZoYHfKW3NQ2Jf8qty10nSKgVOHb3UOdZ6pjphMrieNUOxxqEHhDixj4EPRjjjZVRCI
	jZl5nwFzgw+aX3uSWRx7PSeKNAAU6Cux7fNVisJZJTQNwLtrfDuyY1XIr38JGu9g==
X-Google-Smtp-Source: AGHT+IHAugMJ2nxjbD5sdy8UKfYjv2iz1PHt/Er2Dg2Libs5zWlSaypUfNKo7evt+LepO6KkcCxWDA==
X-Received: by 2002:a17:902:c651:b0:266:914a:2e7a with SMTP id d9443c01a7336-2951a491ecamr80222935ad.6.1762265545624;
        Tue, 04 Nov 2025 06:12:25 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601a60ef0sm28866755ad.83.2025.11.04.06.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 06:12:25 -0800 (PST)
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
Date: Tue,  4 Nov 2025 23:12:14 +0900
Message-Id: <20251104141214.345175-1-pioooooooooip@gmail.com>
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
 fs/smb/server/server.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 40420544c..15dd13e76 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -244,8 +244,14 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 	if (work->sess && work->sess->enc && work->encrypted &&
 	    conn->ops->encrypt_resp) {
 		rc = conn->ops->encrypt_resp(work);
-		if (rc < 0)
+		if (rc < 0) {
 			conn->ops->set_rsp_status(work, STATUS_DATA_ERROR);
+			work->encrypted = false;
+			if (work->tr_buf) {
+				kvfree(work->tr_buf);
+				work->tr_buf = NULL;
+			}
+		}
 	}
 	if (work->sess)
 		ksmbd_user_session_put(work->sess);
-- 
2.34.1

