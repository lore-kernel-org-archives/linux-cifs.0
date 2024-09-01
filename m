Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0AA17E900
	for <linux-cifs@vger.kernel.org>; Sun,  1 Sep 2024 16:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208855; cv=none; b=AM61lf+6XV1OaHE2P2UvST4EwQj3R5qEQkSrfXeOux8e0bFo7bg7KOLGrEOi7laZCSV1+Ck3oo8dVLu56awscxa2jaHt4uQINATAhMUXd9nIf8KcEViKtauhkStCOEZqbWANLQoAbD8jGykekzHXRDBHEd0o31GG7ImCu45S4Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208855; c=relaxed/simple;
	bh=iUpl83bfR0Ipvut4oGsYgDirYKG9fQxE+Ew3JiD6dOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LmzRYrERGsNr5Tyklv9QkJo1MYYYE32TOMnpThGbDaYVdTF77zt9YlYiMv139AhgnPcF/RyugMpnZKNRaoz2hLJbq6t+VSTTR8TiR4YrfjWG9kwDR1f1GXWjVhtLvK6WPR85R/B18A6ribe/48lKROl+lCQWhSYb4KGJ8JneErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=AmT+thGX; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="AmT+thGX"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42bb9c04fa5so3853035e9.3
        for <linux-cifs@vger.kernel.org>; Sun, 01 Sep 2024 09:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1725208853; x=1725813653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VqKffVzCatspkF3hdT8rjFuwjdyFjJBW3hMnTSV2ivA=;
        b=AmT+thGX8X8BWeqT7QNlNmoj+KykJY+2J01Uilxcx74PpYl5kYmOu/tGhb5aJvzFwY
         IiQ9eKNnaWWBaVXCsMmlyVmAnnkrq/GgeEN4BZj8Xjpa/CyFVe+lUfR6+sxBtNc/qz3e
         LDGVI5/DeOEcBwMrJpvQ3l4Pzp5OZIDOVt34k4uF+vEOXmo2pUbB07+05QKDS/olJuJ4
         f8YmRGJIGjrduVNRDJjSFfkNzNDD16J1QrCYNvPmDxF8F1rBxTV4r6RUoMzyacbOcuDQ
         cb9cI9+e+XnCxdvkxLRwZK02NpMS6F7IzwvzxlLN4mvA2vFF8Obnk2OL2V9K94abi2z6
         TFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725208853; x=1725813653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VqKffVzCatspkF3hdT8rjFuwjdyFjJBW3hMnTSV2ivA=;
        b=qdl0oRjKXr4HHqvnS0EkNf4NDW644CYzSjbk0HukEwUtoIdCuSrmG8nsPBT+4eE0fj
         8Uxt4JGm1posm2dMiM69+Yb/LsCqGw9MxqX+nX9MHZx5d6vzxa9wPGJxhycThyGucfLm
         QYKTxtn30PtH8+9rduT+Juv7ZWid4rTmWqToeorwVR4Hhxtp2/mvvcBcP9wTroJoS4ld
         qQg7ChRGIsa+7PhMCwjjsftGtdhIWwivq2V4m86e4mJrlvvD1fS5cOSlcZL0dSg//j4z
         VkHK9QL4dEz7CrEGEhnQJwKYOS+aO2NFuFudDx5XlUrQ3pPumB2iiVC+36THcnikPZQC
         xDzg==
X-Gm-Message-State: AOJu0YymWXkcNUCNUijfv5EIh4BnJTk/iIN0wYvV0dFebCzdY3beLQl/
	wQTQcVtTqTHARm7uRuwh6E0Gq7PwJdvg6IuiKrxN/xpnhwzlt7TtALbjQWk0HwI=
X-Google-Smtp-Source: AGHT+IHDHDxYouHkMBLT+9d48IRoCtSbwadnJjfsZAP9i1xo5gy1S3ARpQgQQ985elwg7rOLNUNUnA==
X-Received: by 2002:a5d:47af:0:b0:362:4aac:8697 with SMTP id ffacd0b85a97d-374a941a7fbmr3372288f8f.0.1725208852763;
        Sun, 01 Sep 2024 09:40:52 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a898919670asm460323566b.140.2024.09.01.09.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 09:40:52 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [RESEND PATCH] smb3: Use min() to improve _smbd_get_connection()
Date: Sun,  1 Sep 2024 18:40:03 +0200
Message-ID: <20240901164002.117305-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the min() macro to simplify the _smbd_get_connection() function and
improve its readability.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 fs/smb/client/smbdirect.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7bcc379014ca..8f782edc3fd7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1585,10 +1585,8 @@ static struct smbd_connection *_smbd_get_connection(
 	conn_param.initiator_depth = 0;
 
 	conn_param.responder_resources =
-		info->id->device->attrs.max_qp_rd_atom
-			< SMBD_CM_RESPONDER_RESOURCES ?
-		info->id->device->attrs.max_qp_rd_atom :
-		SMBD_CM_RESPONDER_RESOURCES;
+		min(info->id->device->attrs.max_qp_rd_atom,
+		    SMBD_CM_RESPONDER_RESOURCES);
 	info->responder_resources = conn_param.responder_resources;
 	log_rdma_mr(INFO, "responder_resources=%d\n",
 		info->responder_resources);
-- 
2.46.0

