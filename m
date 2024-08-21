Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F2E20C008
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724234504; cv=none; b=U38bY24+GV+PYRDW172UtZeCCinKrvPm1W5gT5MEPQ9RVVIxjrAmWpZ/uSOvhUcjzCzhSW5fbmrGjSlz4TiaeJ7jOgBxhcwaMjtThTXcR4UiANtAfQ5l9rtZCPnhO2U3RfNhysylBjTeMck5hdweVf79tC1CNAHmGqx7Hl+yXz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724234504; c=relaxed/simple;
	bh=iUpl83bfR0Ipvut4oGsYgDirYKG9fQxE+Ew3JiD6dOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CP398H/eP7Flnam+e4jeKpn9eMUPsd1UXUQhdPnmkqThswyFZo/uaLfrckEKvR0X0zhG+MHCOhNVa7DezWvNxzREe9DudynRRN9NxkD5igPWPQN20g51FFiL/0O6Q1tvKHN7LKv0319l7CTc7b6XXUVOfPv+Aqk9keJqAUWUWxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=uTpDLbZp; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="uTpDLbZp"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5334832fb94so147594e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 03:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724234501; x=1724839301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VqKffVzCatspkF3hdT8rjFuwjdyFjJBW3hMnTSV2ivA=;
        b=uTpDLbZpvMQBh6JzpEJcHBjx9vPK3xggT44Q0zGnb7qvPKjBcelBpMDfvUbcOFXR/w
         L4pyvZZsqppyZJjjMhTdMaJYMJcVZquti71xfcr3Q6+aS97oUW5saAMF5tIy9XYVsYj+
         3xdnsfLDAAjFZ8vR3s809gb3IBwoWYDWgkRaseZu7mCP2TRtsfsHwmuBLdd8Cjsm0T+0
         78iIZx9tA1ktdwuDWCbyOE0OK9IrJy0TReqw/uAFnBSzwZ92HAwwDyaMhjkC/l67e8QB
         Q966cJ6sj/MduIiFhGbb9p+PQ/2MQ6Q/Eb2npnujfIiAeeezUChzGpQ7f34SKCTZy2qT
         HaUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724234501; x=1724839301;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VqKffVzCatspkF3hdT8rjFuwjdyFjJBW3hMnTSV2ivA=;
        b=h94Uq2kgSFm0uBFosOfxmZWhG5lQXuhwYP83R09WWbSu2Ko5YCgPe41OwXiRNJaAr4
         PxbKFZVN7wDjIxTzDCFxxqjWaW7Uyi95cclD7PousDMHnsxy6JNVm/UTjn3RtL5VD1mq
         FTI41JWNj/OxOWEaAFwTMPeJ8HRWlrS7sC5PaUoRxLBk2l6FXF8O1vb2jElrHicUiJBY
         TWTpMSt4a1FqTWe5mCKlK7d1S3b2Bhot6mCxJufe88TrJFMjTjJsyGizpPCPhJ+DPkGx
         JbGKVqAJcIpLFnM/7kBCOjdhDDS54ROHNqNLi4OLpsWlEdkhcDDW17Vq/0PafWpWeLb8
         i5FA==
X-Gm-Message-State: AOJu0YzINRAGuvUxZQWB+u9ZgOTvso396IoTWL66+E3GY0JXY6AHLrB6
	XR0MZMKcqnqP6K+TiBL7mAFdM3ajTlsBEcQE5QaLRu7oNcKv/91q6JgwEdlSeVI=
X-Google-Smtp-Source: AGHT+IH/JSLMrbDgLILURQPqtt6q2MZ7Up8a0Pm4iXa0ucrUWS/s439Emi+zmW0wjRAvzlHD6Ri82Q==
X-Received: by 2002:a05:6512:3baa:b0:52c:def2:d8af with SMTP id 2adb3069b0e04-5334858bee5mr653203e87.4.1724234500343;
        Wed, 21 Aug 2024 03:01:40 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-228.dynamic.mnet-online.de. [82.135.80.228])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a867a9c28cfsm54307666b.200.2024.08.21.03.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 03:01:39 -0700 (PDT)
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
Subject: [PATCH] smb3: Use min() to improve _smbd_get_connection()
Date: Wed, 21 Aug 2024 11:59:09 +0200
Message-ID: <20240821095907.34900-3-thorsten.blum@toblux.com>
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

