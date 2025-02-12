Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6764620C487
	for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364301; cv=none; b=q5ktTvUCiBaNcTkPIsuCqairv3xv8M5EiVp7PeZcpQIbclktM2A5ARVGmijTCI6K6MLKex6T3ep6TCpGqviGAR1Lr5Dab95hcXle+mpdfsVq1MRTa4P2bZwSzSy62e9ycOb1kV50F5FMYs4kBTbynBgDtqLRzruzo6G3z91QYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364301; c=relaxed/simple;
	bh=BJ0ZERBX/bjNROk/YBMzYh9pkHe5L7DVl89gGAtHXy4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZbsOhSizs4hheaIkuNNw/BTA6eyj16+Us+/z6yWzoacuNfERWIOu6rk3rCQjEAyzEAkLbCV9kZk65QMwgTKFA8AD80R0vcUlQz3H6rQ/Z1kri4X6JzY9auu9BWd8Qpr+cLxVuOFz+W2Ux4+Gam/MCoSgI4y5erJ7h7Ye5QVZcmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21f49bd087cso92043625ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Feb 2025 04:45:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739364299; x=1739969099;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8cCHTH4uYzSKc+HskhqO8fql8hHbjyp7xXtxTB1g+FA=;
        b=DPoELxxiALexQmY2TSUw57VItJ77QlHIo5P9YOWrQrq821m1quGbGdt7WAwvT+2t6p
         09fcS9rpazmeso+vplAGUsQei2tvgxIXCKktbQCOZfTStGgIuGBYHLdok/26j5aOiKEr
         cRVtACEZDmxd43/cYr9PakujYKqg4D2LKyoFMPmkbkatr9agbs0VvQz099l3IXJ1rmww
         aKowY+KN1qiBoIrqvtNdVqeXHwKctVgHv30oqxoqBBQuHbESiBAvylt5mZMvIDH/s8lV
         AkMytqgLrmRiSu4rPlhJFtAJ45WFEyf/woI22aIuLs7ASE8kEDsdC/rzhtqRsnDwVouv
         eKuQ==
X-Gm-Message-State: AOJu0Yx7sN6RozDQzU5f+6NmnpNeWSz4oNOMm8m9qIzK4q4DDoPpb5YE
	p0LnyKaL3Pa9Zda9HfBhieIgFcJJ9GnAO0+WR/e8mGaq6tg6mqltnh3khQ==
X-Gm-Gg: ASbGncsAQlHlTG7eDyrpVzqfclyUNE6zQSllkgdh7pIyiNeQid7kEhFjAvWN9ngQMvM
	jUK+Z8M1UrX6cObDs/Xy1gH6ydLYii2N6g03YC0MsfqgjFXSn2yoNUxtrxBkJ7k56Alr3z1QJLj
	DqIRi7Z7udlovp0yTx/dz1rcwRUTnQvh1SD/S/wlz7nsvQVTFeZbpOagXg9sXOSA+3zfT74UlIQ
	XplDauXQRLV3oKXhZF0d2lRollAcv4Lkb4E1DJltO4P63tWs09+HDxYBv7WxiSFZW1w4NlTUs77
	Z48sOKjd2OrFJxhqi9UAH6JbiOov7A==
X-Google-Smtp-Source: AGHT+IHbyEXyLswpR5Ejd5qGU4FhITE4+ogKyVzssHPODJIIqweMGg60DZJMeLhic0NVn772AC1+uA==
X-Received: by 2002:a05:6300:8a06:b0:1ee:615c:6c8e with SMTP id adf61e73a8af0-1ee615c7caamr2566471637.9.1739364299535;
        Wed, 12 Feb 2025 04:44:59 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ad51af7b744sm11248738a12.77.2025.02.12.04.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 04:44:59 -0800 (PST)
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
Subject: [PATCH 3/4] cifs: fix incorrect validation for num_aces field of smb_acl
Date: Wed, 12 Feb 2025 21:43:39 +0900
Message-Id: <20250212124340.8034-3-linkinjeon@kernel.org>
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

parse_dcal() validate num_aces to allocate ace array.

f (num_aces > ULONG_MAX / sizeof(struct smb_ace *))

It is an incorrect validation that we can create an array of size ULONG_MAX.
smb_acl has ->size field to calculate actual number of aces in response buffer
size. Use this to check invalid num_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/cifsacl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7d953208046a..6b29a01a6e56 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -778,7 +778,8 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	}
 
 	/* validate that we do not go past end of acl */
-	if (end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
+	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
+	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
 		cifs_dbg(VFS, "ACL too small to parse DACL\n");
 		return;
 	}
@@ -799,8 +800,11 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 	if (num_aces > 0) {
 		umode_t denied_mode = 0;
 
-		if (num_aces > ULONG_MAX / sizeof(struct smb_ace *))
+		if (num_aces > (pdacl->size - sizeof(struct smb_acl)) /
+				(offsetof(struct smb_ace, sid) +
+				 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 			return;
+
 		ppace = kmalloc_array(num_aces, sizeof(struct smb_ace *),
 				      GFP_KERNEL);
 		if (!ppace)
-- 
2.25.1

