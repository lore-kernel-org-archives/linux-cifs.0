Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97F120CCD0
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 12:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364297; cv=none; b=jSXEmfWa5Dd7Ndc5ZS1RKrQV2bdjAitmJtamGUmXUZP2EXf37UkP+TkgONNq5xf1IS37U69u8Gd0O6dk6o/ZD5VCuCbwlq/OkvOfG840/OljPiWSLbmfMsnsprripsZGEomgjEdTjntFjiAmM/DqFovwUU6u49JTrkJk5UktLy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364297; c=relaxed/simple;
	bh=WKFp6PHwXN5lK8ik0lamRW1lZF4+3X2dcEbpxKLKtSU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cFEj3p4mIG0/ajc1/B6YRJ12rvn2pLnnvyCdNwmgR58HMDXdePUtaKv1TJAbIh0dN/v/VHV+VyTGWk/b5NLWjJDbz2SnXAy9b0YSttpQzYaq7o1Q3eDJ9B+pA+95pbl9NSAvd2fThHXGnRzkKlIFjIZQ96TUEX1ZgFd/NNPb/GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-220c4159f87so5804695ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 04:44:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739364295; x=1739969095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eCiXAibI5ZdLpXE92mh0AhStNa2PNZ4fNwcxW7+eEFg=;
        b=Xv6YWTBZn0aapDF+ONAO7OR/MdPX5QB3pCdF94Fe3ti8i+kwpi+5gsv4y1CsjM7ITs
         iF3THxBQ6LQFfOSYHTaed60o47kJfk8DfbhtaubKmRQ2Zp+GRjTHbYt+pDZpQMWfghve
         GOcelH9G73aChl57ShnZFTyNY9SIc2qnGbbokKryCnanYQAZcd4Qqozyi9PKyw1cQWND
         0xzhTQxEkyuj/WX4NCGmBDtT5jvfMfCT2uMjpUzhbqAPh8GUMp98lR6KunMnvs/65GIT
         vbsE7UhNlAnyuYOIRt7ZYSM1ekbIRUrfsTrS6ADFVvioYgBbhu2onPcofmVhtTgvz5BP
         tZ4A==
X-Gm-Message-State: AOJu0Yx7gaUIu0vkOK7N1zPnEnJQSx+gLlhVeZvzNzEZssvICjmflbJd
	fhpIP3oCFzbcksywYZKyfvHzmmWJ2VwmVrnOKkqAUmrcS43W4vL9L70MlQ==
X-Gm-Gg: ASbGnctUhqj0rr3wm6hWKb8li13mByqXhiFXq6Bxzd0lRj0nmIgy9YRUnL5rmNjBvxn
	Xlu5wCMLGUl+h2/InWTTRUHyPnId+aG03ZZhrtemSs4b91FGf8//YdUVSZwsb0xNE/rBwbhVJVr
	JDCDzLTCx3OsGhhtQJm6JUB9iA/17R2qYRDR2iIsjGPNDWRd3lik/2GwbsPn5/AFCykbNe4bqDW
	mvODZGrWfOM8/auvjUr9UCnaudx4w/BP92AXMiI1JGcPk7hpxmgwl9AvjDXFCBpuTUOjmqQ3/Qw
	mrr/bHRBfWPoqDWhPxAThk2M89pFmQ==
X-Google-Smtp-Source: AGHT+IGPrZywvriVlqVtOrL0ihID1dKUqFDsDBpt3zcdljqojHJtp1K6AbUx0jJFTfcQwFtRXmgimQ==
X-Received: by 2002:a17:902:e946:b0:21d:ccec:b321 with SMTP id d9443c01a7336-220bbcae546mr55715115ad.34.1739364294713;
        Wed, 12 Feb 2025 04:44:54 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51af7b744sm11248738a12.77.2025.02.12.04.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 04:44:54 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Igor Leite Ladessa <igor-ladessa@hotmail.com>
Subject: [PATCH 2/4] ksmbd: fix incorrect validation for num_aces field of smb_acl
Date: Wed, 12 Feb 2025 21:43:38 +0900
Message-Id: <20250212124340.8034-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250212124340.8034-1-linkinjeon@kernel.org>
References: <20250212124340.8034-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

parse_dcal() validate num_aces to allocate posix_ace_state_array.

if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in request buffer
size. Use this to check invalid num_aces.

Reported-by: Igor Leite Ladessa <igor-ladessa@hotmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smbacl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index f820d0759c3c..410a4b10c91d 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -398,7 +398,9 @@ static void parse_dacl(struct mnt_idmap *idmap,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+	if (num_aces > (pdacl->size - sizeof(struct smb_acl)) /
+			(offsetof(struct smb_ace, sid) +
+			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
 
 	ret = init_acl_state(&acl_state, num_aces);
@@ -432,6 +434,7 @@ static void parse_dacl(struct mnt_idmap *idmap,
 			offsetof(struct smb_sid, sub_auth);
 
 		if (end_of_acl - acl_base < acl_size ||
+		    ppace[i]->sid.num_subauth == 0 ||
 		    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
 		    (end_of_acl - acl_base <
 		     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
-- 
2.25.1

