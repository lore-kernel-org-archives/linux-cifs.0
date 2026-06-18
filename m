Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688B2FA0DF
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814923; cv=none; b=jiLdq2OYnMW9uzGOzv5M7f0zvIuUHRIAqPIB//ndCG9pF/VBu68OmE+lRfk5Bt2dM8M+p78ZHgLZlQo6/O/cHc5RXayWQnQjf0KiaQ9lskasToJkHswvdppVfesWtPX3RE1mziHP09hxcqMVA6bn80cROaL6Ki16YZ2dIX7Anpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814923; c=relaxed/simple;
	bh=uY7iuDW2cKbgN2Qgeq/4H/Jy5sfRAkMU9qPuKO3jeq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KudIgm0CGL0jOkbX0CzUEWG2YVQTJgBG4JL3qnHxh7AbJlsCctiMghqYYTYgOwipq1fSp5m9GcFM3g6DRuujGI0Gyx6ZiCx1LRb8PocMvPQzYtBIxtUU0+cqpU7oUm2kWRx1OPzOlwVgsOPlJ7xnUy0FxoqeE11p+Mte3tntHBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KJQpHvC/; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KJQpHvC/"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-46255b269c2so1034784f8f.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814921; x=1782419721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ErDVMMnCJh8AXl29GXVD3LL5ghXN42O3QGPzibnYxw=;
        b=KJQpHvC/gO/25pMFVIIKd7HtvYJUe89CYBtO/i0afUDPu4O7qS+6Lf+/hZZG4uF2qh
         FIbc3HGB0vuzWDLw3BsIiCmopgM2YC/HNqzb9tgYcGnjpv/3ND6xSi9/PrrI/4IY26dX
         eMiMmPPadlTjgM4fg6iUWWG1DN9bDV2Kp9q2vVIQQR/yezaGn+suDlFMd0sN6Y0cl3Sl
         7gR/qcLw/V7rMUw2P3G6YV+zLkrOA1cOSCzNiG2v/NzkKm1khrwv8k1dbyg0xR8mTegB
         UbKOJtm+7qR7TNsPIwApjV0b9CF3jbKPyYn2GFQNcBa5ybM12j+diFOyvLrhpcDUtxpT
         WUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814921; x=1782419721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ErDVMMnCJh8AXl29GXVD3LL5ghXN42O3QGPzibnYxw=;
        b=fKJGiCYKKcP7re6TIAr7cADkdD3R/oG00YEB+Kaz4dtXEukWqkTa0kuGgvRHntKrB8
         7rpDjaaX73mlq5YULjsUqxqYZzXfvWOv+YpwmSZmzFz+5QmW+5qKq4rts7A3r6Q1ysAH
         Yvskrma9GW9TWVo3kiCIaUlede+o09bUeq0/0QMClPp0iljbnaCET92o2jLOXkxM/9EJ
         tgyzuad8vJhSKiNkztk34DoZ99VPkYCFfyBTOCBJFrX1npKyZslZNVhMQNr/U3JGKjOB
         WEeWbJG0OKUldNsiB8t72+FUHqNf+oF5pp5coAWP0mzX8UM5kMePCnt7d6FX6+6x8OrW
         miEg==
X-Forwarded-Encrypted: i=1; AFNElJ/x6wkZ7f1w/7tZSCqo32rEyuLMBgq4DVznK62Q9wGE/+qrxQaZSqHLSV/Dm8uu1jBqD1D5heKbb35+@vger.kernel.org
X-Gm-Message-State: AOJu0YxhEo0EJ30ten4l8v02poHxFsbS1pRj6oo6tqQHuY9fP6TSREN/
	S4p/KuC3tdd7A/kf8BM04WTmV2I+QLjzVl7mYlVv2HhhF7SLjPfDqsf1iMNgTU0clVU=
X-Gm-Gg: AfdE7cmRzZAg+X6VeyVzP/unOxQwcsiEpX/y308mG1w+MiAz+N1M3elLU6MnqewTqyU
	UPoKXwnM3X3wUDR1veAGCO+W+cZopRyRgUzLOIwZmHqURWAmqRLf5bcGfeAG+GZmM3o7S2HvW/m
	+DuizWbd7BWsVAfOO3yHTLrzCwBw22EhmgKHipGwb5uokBTYC101Wuym49wT20NAyLpqtY5q1qY
	eUkN4YeMaXe+2OpT2qLYdl80tB/7qk0wGGDQEgapaCn+mEtcKUSIoGd1mIgGja1tQeQsGXgbW8Q
	p8CSbs7+bW5JnU6kMl/nibTJCVxtmeq5zhlTXdlqj+0PDF4fhF0aXK/+HsfIX9L2Tl1o16ULmS8
	5oJztHssC6g6SXn5gXX0qT7P76cRQNX2pmBOqoOKGQ/nnotdO35mTFgha5wUSDiOSk93PQv8E7P
	MtT0ntYbw3AOJs5gLNrIyI
X-Received: by 2002:a05:600c:c48e:b0:490:b0e0:3de2 with SMTP id 5b1f17b1804b1-4923f5a8fd6mr17674955e9.33.1781814921011;
        Thu, 18 Jun 2026 13:35:21 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:35:20 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 4/6] smb: client: fix query_info() replay double-free
Date: Thu, 18 Jun 2026 17:34:36 -0300
Message-ID: <20260618203438.667881-4-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618203438.667881-1-henrique.carvalho@suse.com>
References: <20260618203438.667881-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A response-bearing attempt can return a replayable error and free its
response buffer. If SMB2_query_info_init() fails before the next send,
cleanup retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a7b1fbe28a2d..6e6aed87ab0a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3942,6 +3942,8 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	allocated = false;
 	server = cifs_pick_channel(ses);
-- 
2.54.0

