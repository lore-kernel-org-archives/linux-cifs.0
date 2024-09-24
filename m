Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AC91A7248
	for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 13:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727185736; cv=none; b=JjIGbPY3E3ib3HBzUrUyBBjdOHoIE0Hm+iyR1mCPTX0QnakSodc43iy9J2IBdUiIjlbSC+GEF7gRjcJIDMxL33ExhCNWH1zoSpDayedAv81CoreAu14oFwUCL5vMv9X3UWJCX3cJleHPNdxZZgETg1WS8WrXBHP5jJTkXuXTNbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727185736; c=relaxed/simple;
	bh=hX069wJveWCFhN8RCSPVx//mT1T1HV7Ce6i7LaFM1k0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZKMfX4tN9+2rpwUKsoXhp/mpHuHrde4FRNfz488FyIcjnIDL2ZxLsSH2rNFzBAuosKdYxJq4MtTCR5gURHsV2/PHRIE+FHM5qsPA4gPRo35pujb1H7OIoG8Y9RI8R+6DdXc6zzSYO4bvBxZTAbJP+rgy65XueufC8COO2Bw9IDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7db637d1e4eso4017227a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 06:48:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727185734; x=1727790534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cB3e/nUibl+JSeDchly64GSSdjir7WJCPs7kmPjUmM=;
        b=V3xxZmEvLWGzwgW8wzAPBN6DIESpodlpmAj8Wknm4JXYZvpr9TV09Ec97OWDSkQQE/
         Asd3qqDlUuT+feF4TBJjax0RLz5+MPXeL9bst1uU4yJkYWBUvqJumiT2bO4rSf4GlDZp
         lJOloGMITMbgRFuNnDCPjRULdRWfHs0nWUcqIn/hDVuTuwe9vtJW5ETW/hTHOUzJN64K
         dkXATITWK8Gm7P4iIPmzerDdHzS7ZQKV8W6O5pQy/1n6xDmNmSi6ka/v3SDD06P3EtNc
         mSEOR58z0ljoIP8t5IHI3WsKrdpEiHaKbWTJ9PGymZTjeVItXu+tI8Pv4tJd7r2sWM6i
         8W3Q==
X-Gm-Message-State: AOJu0Yzpp5vHkZiqA3+cDI3qnkalqEl/s05whi6fOCR//F7DetKaRbVr
	ZRJfxyLV3PoZGFARpSSNT95ai1mnD3xnA9FuWUtBJ2md6C8zcAVaffpBDg==
X-Google-Smtp-Source: AGHT+IHvFIPecp40jOYD1rVW5aRBMD0B8okRYehUpXXfKBlebSMuQaxL7Mv3X5FSTarnd+/eFIgh4Q==
X-Received: by 2002:a17:90a:7806:b0:2d3:d398:3c1e with SMTP id 98e67ed59e1d1-2dd80e54adfmr18022597a91.36.1727185734442;
        Tue, 24 Sep 2024 06:48:54 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e058ee3cd8sm1535532a91.2.2024.09.24.06.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:48:54 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH] ksmbd: remove unsafe_memcpy use in session setup
Date: Tue, 24 Sep 2024 22:48:17 +0900
Message-Id: <20240924134818.15552-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924134818.15552-1-linkinjeon@kernel.org>
References: <20240924134818.15552-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kees pointed out to just use directly ->Buffer instead of pointing
->Buffer using offset not to use unsafe_memcpy().

Suggested-by: Kees Cook <kees@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7121266daa02..72af3ab40b5c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1335,8 +1335,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 		return rc;
 
 	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	chgblob =
-		(struct challenge_message *)((char *)&rsp->hdr.ProtocolId + sz);
+	chgblob = (struct challenge_message *)rsp->Buffer;
 	memset(chgblob, 0, sizeof(struct challenge_message));
 
 	if (!work->conn->use_spnego) {
@@ -1369,9 +1368,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 		goto out;
 	}
 
-	sz = le16_to_cpu(rsp->SecurityBufferOffset);
-	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
-			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
+	memcpy(rsp->Buffer, spnego_blob, spnego_blob_len);
 	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 
 out:
@@ -1453,10 +1450,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 		if (rc)
 			return -ENOMEM;
 
-		sz = le16_to_cpu(rsp->SecurityBufferOffset);
-		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
-				spnego_blob_len,
-				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
+		memcpy(rsp->Buffer, spnego_blob, spnego_blob_len);
 		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
 		kfree(spnego_blob);
 	}
-- 
2.25.1

