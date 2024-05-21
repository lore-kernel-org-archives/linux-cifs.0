Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2287711E
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716299912; cv=none; b=sS0OHaEdLX8IvX+dgv1LYM2OfAnTHkOCAii5e7DmlkS6Ax4KaymObJVvDgPonBozNUq+Hp8TnmOZlwLxamiJqRlG+g22NOS79fVfUgG3fDv5UEIVuoYLdQswXFqVILN//UhBGeOuMXDehoehb5OpShCYoyaazq3k4DQzajneBAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716299912; c=relaxed/simple;
	bh=x9nY/w2ttPiAkhyV80YsEEzi0i+/uiejYLnCmf0x8Hs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jFnzhGD1vYfhkqPJVXeNNhNuzJDIvguUfi62DkWI40eJdne/2VPHD9RjTaiQSCzOvHsaOBvCgImeG/BRfFeInXwjSoP6uYZ+pkynUKnrbJLudEGW/w8ApNl1Ptkp/++JMNkD1tni2kL0N1G6WlumpA4vglCHJng5WdWwZVWgw7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ee5235f5c9so102847705ad.2
        for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 06:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716299910; x=1716904710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uyb2YxEatHWljamxV4WC0Gtr3YQ+dShU8UO3MhO8ErI=;
        b=s2/lY76/X5lWgBZiGPklClDwTCFAsMIoiAiBS3HPileNHEri2BHPeqSq3sxjaMT12z
         hIapzOvpCmJlPeoq51x4FZtWaYu3s7O64fU8obzqSzYH+vcv+yXFESy7xksLL/QnsoCm
         Llc9bW+qrF6uO+LeBL6aIWkAsgRpqSYDN0gfx/b7I/dF9KMyPPO3tJ+s6a3cVDUb9aEK
         kU0UA54fyzNIwuYLcAq4C+x6ymS0J661UYxvQSN7UsB4+wBjLKlS2KRqCOQ9mVpZ/cpv
         ags3f266PtqgwLliqUeMIe3K0Xv62f1Uc6S/gm7TkpXHmjm3UaH3c6T5ZGXkx/KqBrkW
         bKGA==
X-Gm-Message-State: AOJu0YznvjnPhVPwH6iZabMsEut//M9+YZQNOyOKp0fm8iXJWxcch0/8
	liv7eD4u7soHBmNtZunTepYZV7wjT8X33p0KiWTMhg96eiWagVrCJDqy0w==
X-Google-Smtp-Source: AGHT+IHtzrV/HcyUrLHyeHq2C5tG8Xe3dGAMcflmowdUImwoF8n6qAuCRxwSopQQ086wF0iX1B6KSg==
X-Received: by 2002:a17:902:bb8b:b0:1eb:7aeb:54f3 with SMTP id d9443c01a7336-1ef43e24993mr280799745ad.36.1716299909969;
        Tue, 21 May 2024 06:58:29 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f30358e6d2sm34204015ad.93.2024.05.21.06.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 06:58:29 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Nandor Kracser <bonifaido@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/2] ksmbd: ignore trailing slashes in share paths
Date: Tue, 21 May 2024 22:57:53 +0900
Message-Id: <20240521135753.5108-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240521135753.5108-1-linkinjeon@kernel.org>
References: <20240521135753.5108-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nandor Kracser <bonifaido@gmail.com>

Trailing slashes in share paths (like: /home/me/Share/) caused permission
issues with shares for clients on iOS and on Android TV for me,
but otherwise they work fine with plain old Samba.

Signed-off-by: Nandor Kracser <bonifaido@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/share_config.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/share_config.c b/fs/smb/server/mgmt/share_config.c
index a2f0a2edceb8..e0a6b758094f 100644
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -165,8 +165,12 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 
 		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      GFP_KERNEL);
-		if (share->path)
+		if (share->path) {
 			share->path_sz = strlen(share->path);
+			while (share->path_sz > 1 &&
+			       share->path[share->path_sz - 1] == '/')
+				share->path[--share->path_sz] = '\0';
+		}
 		share->create_mask = resp->create_mask;
 		share->directory_mask = resp->directory_mask;
 		share->force_create_mode = resp->force_create_mode;
-- 
2.25.1

