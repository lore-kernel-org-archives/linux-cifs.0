Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C0A136330
	for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727185724; cv=none; b=WpQNrR22RMToNsOxOXMxY0ytjirofKiodVrjdctMK9XZ2oKw/q/Yx8CfLJKVknQyUBZVRJg9x2J+lVOSXyDbekFlyOAT2KnqTsLsypdzW+12LUh3xghvmeD1ayCQpq4CSMO8V9CU/QY5cNZyg4mVvelP01tL4kjN9hsS48ugpxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727185724; c=relaxed/simple;
	bh=vD7fjU+l1bGWYKHGKcpdBildjqsUX+zkofEM0Uw2nL4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Mv+hqaCwnFKiKeKeMz0MMkOijG2rrOMxJQ6S9kC7Fzlc/XgSWtdVdEtFNp72EJ2kHjeXBnnvbVdfQSNLGQBCcqovZzwprO/Nar8EHsnu2Ba6PnMmeyLoDsQftEOQIxdEKbcmZCG0s3mNJeeoCkfW0aEGAu96eYnWySe5ToxXrzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2d873dc644dso4328196a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2024 06:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727185722; x=1727790522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RkZN19jHe2i6vnXx2Vy02wrubZznFB6Lql7mwsIoVkI=;
        b=gZAzj53PfCR1cDAdmZ1Pxzn8h+2lxqKr9DVIriPEnGrtKMnf6/61T6+isVG0YN6KXV
         7fmlNVs1kW93/mgySCLO6NoPk1loEvL3HCgda0+B9Iwh/malWCFxaqhmx8hCqs+pq2CU
         Sk6xLYqsFqkXn3it5pRqU+hX9pjTOSCaAr4WcirjTbGvYx3pt05QRqNAmRrgnDayFq2D
         46bFP/1sWOPMtrHU5KmTi2snk4DS24Nkxav8m/0NZyODggEvSnTAgFKe0NxErQB8PNvo
         P97mM0v5hEleqj8n/30HCkylLUnfOFk1byr1XdHFUMJmgGckA7gmzEbdsfsj9JWkqrlB
         fd/Q==
X-Gm-Message-State: AOJu0Yx7HpgfxXwd8BG3HNJC2mSd91zbr67H4d41Hzm3GW+48Em69WA0
	Czu4Umokmn3pV6Muvv+rTW82gbIjHSMO3Xpqtmqtfr2Xu1e33nGM28zFuw==
X-Google-Smtp-Source: AGHT+IH9sz79DFxQWp4Zh3ukMf+opJj0lNbVqV2OFOA1iRqZTlU7GHSXkHHGHM2oxYYlmEmOE3cXVQ==
X-Received: by 2002:a17:90a:5143:b0:2db:ec3c:8a0e with SMTP id 98e67ed59e1d1-2dd7f758735mr17956114a91.35.1727185721835;
        Tue, 24 Sep 2024 06:48:41 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e058ee3cd8sm1535532a91.2.2024.09.24.06.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:48:41 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix warning: comparison of distinct pointer types lacks a cast
Date: Tue, 24 Sep 2024 22:48:16 +0900
Message-Id: <20240924134818.15552-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

smb2pdu.c: In function ‘smb2_open’:
./include/linux/minmax.h:20:28: warning: comparison of distinct
pointer types lacks a cast
   20 |  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                            ^~
./include/linux/minmax.h:26:4: note: in expansion of macro ‘__typecheck’
   26 |   (__typecheck(x, y) && __no_side_effects(x, y))
      |    ^~~~~~~~~~~
./include/linux/minmax.h:36:24: note: in expansion of macro ‘__safe_cmp’
   36 |  __builtin_choose_expr(__safe_cmp(x, y), \
      |                        ^~~~~~~~~~
./include/linux/minmax.h:45:19: note: in expansion of macro ‘__careful_cmp’
   45 | #define min(x, y) __careful_cmp(x, y, <)
      |                   ^~~~~~~~~~~~~
/home/linkinjeon/git/smbd_work/ksmbd/smb2pdu.c:3713:27: note: in
expansion of macro ‘min’
 3713 |     fp->durable_timeout = min(dh_info.timeout,

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 5 +++--
 fs/smb/server/vfs_cache.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e6bdc1b20727..28cd66fa8e05 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3531,8 +3531,9 @@ int smb2_open(struct ksmbd_work *work)
 			memcpy(fp->create_guid, dh_info.CreateGuid,
 					SMB2_CREATE_GUID_SIZE);
 			if (dh_info.timeout)
-				fp->durable_timeout = min(dh_info.timeout,
-						DURABLE_HANDLE_MAX_TIMEOUT);
+				fp->durable_timeout =
+					min_t(unsigned int, dh_info.timeout,
+					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
 				fp->durable_timeout = 60;
 		}
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index b0f6d0f94cb8..5bbb179736c2 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -100,8 +100,8 @@ struct ksmbd_file {
 	struct list_head		blocked_works;
 	struct list_head		lock_list;
 
-	int				durable_timeout;
-	int				durable_scavenger_timeout;
+	unsigned int			durable_timeout;
+	unsigned int			durable_scavenger_timeout;
 
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
-- 
2.25.1

