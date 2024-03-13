Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F175B2F3A
	for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710342081; cv=none; b=LMErDVWcByOFzFfV1R3bBLfFYYJZlAbs6AqPDj7JoWH/kmJJCrXTMYYoTsch1h1khogz55hJIMtusxKOS1VaAXHW+Yd/PO5mnPWwO5vUTOd5FJujeHAE5qqEEnaB9llFqstY3vydaZ871LPMgvQOUYiTguvF8tR6gTaBRROi2G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710342081; c=relaxed/simple;
	bh=6qAjXF75KSt24eVVm0oXYvRM5VNNoGNI2XqyufgbwqI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=Y3n4P57qaIR4HF/kY0Z97SlRBef2R2hWaAwzsNli13teZtAO5eWh/Gsbd4buQKkUDOBx8yZ6JBPc7WyE+pfr6575aBN3DTyhHlbefErzB2kQU23gK1DrZjcDh8J7rifJl0W8tECejX0aLoCUuaDJ5o1xHXdJtczWpZbbK9yW6IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9p46EMF; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9p46EMF"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6b6e000a4so668780b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 08:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710342079; x=1710946879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=8kjePairGB3DQHsAr5RMJ1cJhFr/8ryhQJTXaIi4Apc=;
        b=Z9p46EMFwMItuk5j5BFmesp6BYvhfeqBIgQIN/nb2dUXG0PvBCKP3+hw7v2J4MTFJc
         O34hupAzrNpHyODlTHK3wyB521fdfd7F8hCXGFA2ZDk+t0jws6aYbBV2UGn/6hkGNT+J
         v1isLO5ZxsseZe0xPzZfDNCdrgTcJ4Hs2n2o37U1eOak2manU9CuxG0vK0oOzcnsA1Kr
         SKrCynq1OgEtewWbbLM3dd5ZpjT98pa8elb1k6XKPPN+Qy2zeXfIS9tk+rzgbDCNGQGb
         vSGIB93Y/gxKZFcqLy2Vf6BvPcyL+uhPAJ4GY09CZ5J4YKEEfT8vG3Fe949xvtiXfrsW
         9PFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710342079; x=1710946879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8kjePairGB3DQHsAr5RMJ1cJhFr/8ryhQJTXaIi4Apc=;
        b=Xraa3S/dSZEYxhn4oQU37he649Wiw4qfCa8YlfAhWFPazBiq31pnM8cfSCqfHwCuq8
         bWz3EsJhM4pzXT0JBx9kCAFCawx6M9KiA5jHLUxgUQiS1NlvFgkQCDpkc7LeL0x5hdfO
         cOtvk/CBtnRDeWuz1wh0cHelIVLy1+rmupBGEniyVsxw5qSbVXn5OoK/vU6r+O/hwS5N
         HW9bBCMqa8gGOqXjxLKaY8xbpreOSBwtbeC5hbaRSMNnjVfb2xGqP0Wb+mGxnIGvuhFv
         wEQsvgWxM2eg3v5t5cLgfJwO2K5nL+uyXn1XTEge0RGUw/KxGSTFlVGS+ZZxuM8xR19H
         3Law==
X-Forwarded-Encrypted: i=1; AJvYcCWNjiGQ8AENwpVgbJf1pN62mipBU/xauqx6EZTD5z8BLMeGVZhspz1knsfnYwVzRH1eWWfd25zZsA8NIDyuUuhxolqn8vF/VoyXrg==
X-Gm-Message-State: AOJu0YxU21cc3jOtVk19i4oBWg5rxhkDkfgzQ5deT7MW1U+jfdAd7PrE
	5b/V3o4xBbdbCZWxgtpTXQLyf0mcCjkMiLkR15y7xV5bRYbidpB52LVZJSKDZ7g=
X-Google-Smtp-Source: AGHT+IE+Vti3do+NX1J0w54yAXYnF4q6rymyk6Zf5YYQkrHM44nn1axSAhsZjJUpO8axitLZ9LDowQ==
X-Received: by 2002:a05:6a00:39a0:b0:6e6:57a9:f8b1 with SMTP id fi32-20020a056a0039a000b006e657a9f8b1mr3566771pfb.9.1710342079306;
        Wed, 13 Mar 2024 08:01:19 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([131.107.147.61])
        by smtp.googlemail.com with ESMTPSA id d7-20020a056a0010c700b006e5f754646csm7960834pfu.139.2024.03.13.08.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 08:01:18 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	bharathsm@microsoft.com
Subject: [PATCH] cifs: remove redundant variable assignment
Date: Wed, 13 Mar 2024 20:30:34 +0530
Message-Id: <20240313150034.165152-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This removes an unnecessary variable assignment. The assigned
value will be overwritten by cifs_fattr_to_inode before it
is accessed, making the line redundant.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 00aae4515a09..50e939234a8e 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -400,7 +400,6 @@ cifs_get_file_info_unix(struct file *filp)
 		cifs_unix_basic_to_fattr(&fattr, &find_data, cifs_sb);
 	} else if (rc == -EREMOTE) {
 		cifs_create_junction_fattr(&fattr, inode->i_sb);
-		rc = 0;
 	} else
 		goto cifs_gfiunix_out;
 
@@ -852,7 +851,6 @@ cifs_get_file_info(struct file *filp)
 		 * for now, just skip revalidating and mark inode for
 		 * immediate reval.
 		 */
-		rc = 0;
 		CIFS_I(inode)->time = 0;
 		goto cgfi_exit;
 	default:
-- 
2.34.1

