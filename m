Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F3A18024
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750347373; cv=none; b=FX2LQsisJX/WxSmfFTubopqJpJAnt9gvj88kPSiDn7A2YI9A0iDZN29W63GjPzPq3l7xsMamFVtqpqRl29jslGEMkkP60pNcoDbczAmGiAr2ZZZ2FFOtXf6wyyTX9UbNJOds3B9KDm7Skq+//WP+mKySTWhwr/tAjPZwybeZz8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750347373; c=relaxed/simple;
	bh=UrGPVM+t8nLQQrvWXbocuoEIRqp/w7c+EkOLHnLwrtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5y8RnSlTcIw4iZko4lvGdammQJtvMZ3VbnTRo/omuyxnw/cxNG8V42GGiRyd7SGi9TxYpruzyCEAIXa2BM4s5U1iPUP3kCwLC2tGQHmaJ8j0+LG1muwUeQDfnS23MPZXzDQnbss91t5R+Kh1OhN4iiUNuB2RAhO0T9o90iL7oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PR1h507s; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PR1h507s"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-747fc7506d4so660455b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 08:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750347371; x=1750952171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1OHaW5w9SedKqw2AWXSNKSBXgzvsmnqQo+FRbmC4P/8=;
        b=PR1h507s/+TgUV0Nt9tqaFg8nH48wwYCJkLrDHPhRSK0+9pvxIw0RjXsZGVw2WS2PM
         yiCr8t1C8wtPFpvMphJryNiDjqk6Jdj9RMaaZ9LXMhbOaB6oFlCD4jGAPiJvcP2kON5Y
         ybz7TcDQ3tYpxxdS/Y4r9QfSf5dCFmzpTva3j5SLh7Xw3IY8HQR9Hxtn8GwgE6JwzbKr
         k42acby1fZ2OL+pRQAcqSVMOpeXXFs4x27CRj4Ml8zvMawJFrhQ2yKbYh7hrcq7oeFIK
         fijNnJNu4cQORZDZXBBuKC5/D3enir784xxhl23gHOaKC9H70uZ4dOblMcko9vEGirbi
         aPTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750347371; x=1750952171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1OHaW5w9SedKqw2AWXSNKSBXgzvsmnqQo+FRbmC4P/8=;
        b=r0SDHI8dwS1dvL/9IjjoY7CPIN9FFbwMgwNCNvxuNb6g73P61fjPTYt95jyIrok8PP
         ZPawQ5WEp0xWTZ5Lljb5g3hzwTiRq7j8c80dWR2dcRmV68q0o+FuM9vBlwEl1VkmCXl3
         zN+GGMg0bvGs/53skWGWV9c0+DugC0UwLIpHbNFbOrdxDIDH7IDMyQYP9CsNfAvy8wKX
         1w4L7OI+UiFayhpfSla5v3Hk0W+L+yymeHfaGhzoFZJSOxig55fDPrpG2HryKfIMCv1J
         Efxrsb5e9OCsaPJQGdDOxmoBneKPn6G5rzAd20da7BILuV8HTh1gfDHyJVP3YS+piADC
         mEFw==
X-Gm-Message-State: AOJu0Ywjw9Ek5I02ugeJJbzTXceNZNw2MH+2UCMeRIj8N1XDN4Ti+Rl3
	xQw9KhQoF3+4UjiZ9dHV0tON1LlfvLLPGYE3UuBCcnmLH0eWQbcrsEzxWigL7ikZ
X-Gm-Gg: ASbGncsKEUIFahgEoM0e4Hh3X1GOLX9vBRexPn3NiT63x78Y+5WOPRMgBJBttqe+UDj
	B1VjK9CatDeuZ/EzB2B3M9fNISi1KDmibg1VVttXDy/8H+/cnVxD0uGwydrDxQJNuTVv6eN6S59
	5/QoYzpERIRBUFPOZzO1lyQXEdpqzuZZZoAvj9ndlDGPQ51IAA1ax6Utpl1801NmeoLyNlo/s8L
	AsvT4TzDIPrVVNzQgxSKwBvwMFICT5EJ1EDMOPAtqRak84lH799VJBCwVPEOs9X82PkpUhUrJS0
	bmDHo2sjS5hg2rkH2Qm86BasQp6ARAwtsw/YXp0ixEFXlCO0kjbtYvAST2EQLuL0UIrwd8A9NUp
	p3jlQXo5eTBK4
X-Google-Smtp-Source: AGHT+IGvNyiYwV+WovH2X3OweI+ykpgZB7UAWzFAftCglL56ATqpxxVIkuvCvhWiyABoIzuLfWx5fg==
X-Received: by 2002:a05:6a00:2286:b0:73e:23be:11fc with SMTP id d2e1a72fcca58-7489d0556fbmr25501409b3a.22.1750347371035;
        Thu, 19 Jun 2025 08:36:11 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.1.253])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7490a46b574sm162838b3a.15.2025.06.19.08.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 08:36:10 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 3/7] smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for auth_key size
Date: Thu, 19 Jun 2025 21:05:34 +0530
Message-ID: <20250619153538.1600500-3-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replaced hardcoded value 16 with SMB2_NTLMV2_SESSKEY_SIZE
in the auth_key definition and memcpy call.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cifs_ioctl.h | 2 +-
 fs/smb/client/ioctl.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
index 26327442e383..b51ce64fcccf 100644
--- a/fs/smb/client/cifs_ioctl.h
+++ b/fs/smb/client/cifs_ioctl.h
@@ -61,7 +61,7 @@ struct smb_query_info {
 struct smb3_key_debug_info {
 	__u64	Suid;
 	__u16	cipher_type;
-	__u8	auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
+	__u8	auth_key[SMB2_NTLMV2_SESSKEY_SIZE];
 	__u8	smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
 	__u8	smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
 } __packed;
diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index 56439da4f119..0a9935ce05a5 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -506,7 +506,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				le16_to_cpu(tcon->ses->server->cipher_type);
 			pkey_inf.Suid = tcon->ses->Suid;
 			memcpy(pkey_inf.auth_key, tcon->ses->auth_key.response,
-					16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
+				  SMB2_NTLMV2_SESSKEY_SIZE);
 			memcpy(pkey_inf.smb3decryptionkey,
 			      tcon->ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
 			memcpy(pkey_inf.smb3encryptionkey,
-- 
2.43.0

