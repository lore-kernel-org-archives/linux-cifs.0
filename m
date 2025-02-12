Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2BC20D51A
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 12:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364307; cv=none; b=LqcqwZX8uRbyuaqc88Othb/NCn3xkVFCoOZ2R3ZdeE3ckJhYNkxx1XlANqenIBs0xFbYK9mMRRn1ytw7D15rhji3mqzY+fNwrHf5o4Ti4nAOi7xTpxDPjgZi+SppWYBw5qs2FCjgnX0Hwy2IA2ci88cvtCF0PX1P0hJvB4Xb+7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364307; c=relaxed/simple;
	bh=TGvHXZz8joM3IGZAP7s0F5y4ZCmtrdhcQxiIL6Yu7qM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KGBAzJl+DaoD1VviYWBJ47ZigmUEbJIoTD7t3N03f+Fl1qzesKaIAhnShWNz4heV6kVbMXI9LIYaSdZgWNxamAGksaxRYadaXcbfzCEatmkH2Dwcm3KSXsQDGTpruanlIjdolbAYkgu+RFzdwOLhqCVeimiGcXsO6j90QRCIbik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21f55fbb72bso88500805ad.2
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 04:45:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739364305; x=1739969105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osOQ3qPxeMscLY+ItsA4f5Olbq/57j78Y+wOABavW5g=;
        b=G2FuqGzCH9MFLkEHOGDq44rzk3GswCCl5gSE1BhwotLd2IirXatf7974N7GpaU3jfL
         xlGonj8X7rS4aGY1T8sWK3Gix0GC3K1Nd1SejuoxFK6QiCFHbBoBIwYxHmx2hVUzOshd
         7YMl185k4urN9H9o/yoRa+UaEgUaDb3mOFaf0mvdUoleNYd9nFP7Cie5y2LWtZ1zCjyf
         fmcepxTQ3DhERTgw26PUmuOzJ0BvfCeXi9EIdvwVs5RQwuNR0B0aeRSTnx9fT5zqFBol
         ohEGWI7FvBeuibflz/2vl97aYS5Pivb+9WzvGd/0okoSyUV6QnKRkCToy3aK8T7dnT1D
         ZdCg==
X-Gm-Message-State: AOJu0Yw+3GIrpMVyzJJvrti1ioQhG2skjdGD36qQ+VW4mu3iopg0Iohn
	UVJMXFOY1moJpqycxqWdRpZvMpWzJ39EYQ1cJP0uy08hgTPoa2t9+eX9bw==
X-Gm-Gg: ASbGncsMaRWqGcLcfsoSEmcKJZZ03dwKUizF4mbQYru7LF6z3QGklsy5VVrKlPzxeA9
	6z38M5cctloX3KVBiYitw2umQl+gDNLB+yLz0307EVc4+vnI73JS4FNRBB3US50+q6DzeFBLs5n
	wjRFwcrJc2TCsFskNCDu9zsAFW12oTd10rbd/s5SQK8M8FohiNxG0nhEM+6nczorfydEcgVpSfF
	AfaTx7fQEy6Dp3hTlSYCKOktAiZ0REoFDqJi0+joym+DgHs48cLGRQNWi7qTwZkdC+HUXFBfHZC
	x/ElacEb6pxvk2pqSHTYnvk9lQ8jhw==
X-Google-Smtp-Source: AGHT+IEZN9seU8if90plTa1W9I1ekJDfbOotYzn2VWNhg218wyjoOD9dmp0jCpe0ntjG6USDycOSfQ==
X-Received: by 2002:a05:6a20:244b:b0:1e8:a374:ced7 with SMTP id adf61e73a8af0-1ee5c7909d5mr5293239637.23.1739364304782;
        Wed, 12 Feb 2025 04:45:04 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51af7b744sm11248738a12.77.2025.02.12.04.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 04:45:04 -0800 (PST)
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
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 4/4] cifs: add validation check for the fields in smb_aces
Date: Wed, 12 Feb 2025 21:43:40 +0900
Message-Id: <20250212124340.8034-4-linkinjeon@kernel.org>
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

cifs.ko is missing validation check when accessing smb_aces.
This patch add validation check for the fields in smb_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsacl.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 6b29a01a6e56..5c511b28dd77 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -811,7 +811,23 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			return;
 
 		for (i = 0; i < num_aces; ++i) {
+			if (end_of_acl - acl_base < acl_size)
+	                        break;
+
 			ppace[i] = (struct smb_ace *) (acl_base + acl_size);
+			acl_base = (char *)ppace[i];
+			acl_size = offsetof(struct smb_ace, sid) +
+				offsetof(struct smb_sid, sub_auth);
+
+			if (end_of_acl - acl_base < acl_size ||
+			    ppace[i]->sid.num_subauth == 0 ||
+			    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    (end_of_acl - acl_base <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
+			    (le16_to_cpu(ppace[i]->size) <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
+				break;
+
 #ifdef CONFIG_CIFS_DEBUG2
 			dump_ace(ppace[i], end_of_acl);
 #endif
@@ -855,7 +871,6 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 				(void *)ppace[i],
 				sizeof(struct smb_ace)); */
 
-			acl_base = (char *)ppace[i];
 			acl_size = le16_to_cpu(ppace[i]->size);
 		}
 
-- 
2.25.1

