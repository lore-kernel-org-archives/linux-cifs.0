Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C212FA0DF
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 20:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814905; cv=none; b=UjTgsfyOPImnf5BthHmhM4xlCuV/lyMPXpOsytEu9xINvNpHRot9bNphxokmvZ15RzJwgT0gWHuqzazhnZyTT4BHr174cJa0M369MdJLQvBq1Araf+pVS2QjiSZRxjiLjEvBnx7aMYB4OZjMWIHACAnrjws2DEHyN/81iEl6hgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814905; c=relaxed/simple;
	bh=7slqrmU0JKmIN4TG3bK1//riMPfA2K0Wm+4SvzoW2Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3qmxNerVzvM+MoioT8dY7pdgnstjXyI+anN+yaAexB8zRjiTE4cphJ5z109Q5JP5DZ1eMh4neNak7n/sUaHgNy2Dml5ocpuHVAkrEMiud6A475McFt9C20x1Aw30qUeXq8VnwOmOMIwVdWBy+Mlg5pkUKps/uYE7+cXwuxh39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CWOH9UPI; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CWOH9UPI"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b613a17bso10766475e9.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 13:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781814902; x=1782419702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fd4DJFVLYj9995eIiNZox5y5QI2fYgZzhjzLtOnh2KM=;
        b=CWOH9UPIouVmh1L3dgQpJN9jKLeOOxaRhJ0kO1nzCBHVcYF3PS5fLYooP2umfiDK/l
         ShO7FdGxhLLUX+5T14i10T4lJtEMWe6DM1qicr3FvTo1LFN4LWS4mQblz1qyqXN2679f
         sMfIrdnSTERI80ng3Z9aKZJNN39T3NH8mZRAcaF9T1p19R8ZFTsw4KXohQytqICYxtBF
         wm1KbOrSm3fiAMaypipISejgzVK1r6Hx0Ix07935hp1sh72oShKpyY0XTraooE677Kvn
         61r5C6Ke4rnfCWlea6QU+m+AKwiiRxZ1zRpyO0TfzeywtoZNLOyAEDBnV2WNJHsbhbdc
         eGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814902; x=1782419702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fd4DJFVLYj9995eIiNZox5y5QI2fYgZzhjzLtOnh2KM=;
        b=nQYJ90fqbrmJ+jatLWvty3j7qF/ggqNEqUDfDiIlriO2joFiVAbuPIicsuWtQApBGo
         FSs5zjP4RAf4344Qa42M38ceC01wO6ghaA6y58HIoBkYK5QMYZ2De+F7Lx9pAsp31HCR
         ojkIKFKwrQQ6WilZ1QuKzTl5P6roGcKEB462wTkZj8+yVTeTi/V1kF3VidWYy2a0WBtn
         7T9sywhp/YH9ViaEjO9PxJtJwey0YbtVALH8v3qO0oH4StfUaTFCaK6T/dIRIJhexrMy
         iyVB6R0p1XOWsldBY0iA/E3094kI5m3RveaFtzEHgW5ZbYLW8XCBdaY5SPhmo2t5VumV
         qXCg==
X-Forwarded-Encrypted: i=1; AFNElJ8BvO40nlb5fSl9XktPaBV6zXawW8wO0SW5o+bacJUrc97rd/y2zPMd7WB3IWpDWLLDwLF1AinxSKcJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5zjzx5PJjfucMVT0f5tY2V9g7BWUYdp+NbuFPFffUKC3jqKqN
	T2UYc612Dnj79jDPWkZShTJzxep+++YNFoOgrPSNm9BT3vwZg+wrMCYYujhSe1mMqrw=
X-Gm-Gg: AfdE7cntLjT3Yyf7zBoCYcRF0+4WDAihkwKkZw75z/6r3uNqOzA3hIYaVR+NaqMKTRT
	hJnn2OqGWWMOsBArW8fpo14Dt/FOq0RqYvp3T1UYxi6QLt/mq/uvoGy4ILfIoN7YTlOZGwzHMaX
	9VxJzcLjsRnrCkuG8knpxaZFEV+I6xEnefKimeTP3GdfW0/5A65LO+KxXlaAIEvMSdtXUcx2yHW
	OgN1L0Lq7ca3P8CDKl/qHaAFMQV9jVBkXrTG5IH60IF8nmUbEDN4zMPYK67pIbPkf9Wn7PDv4kE
	JTcfmEHdT6NgFiVIauZOQdFKZ7+kBBGYl1tfvmxnehBCdlr/0GngH9kGHfLBKuQEZobPEX99KIH
	WzWi9TR5NfE/4bcpQqe/tZtMoqma5TAYWCRfJuGXAU7S4L/xdVW6xE8voRTcibKUSlioT0mMqae
	JYTAN+xAqkieIYY3TRYIQr
X-Received: by 2002:a05:600c:524e:b0:492:3e44:214b with SMTP id 5b1f17b1804b1-4923f1530bamr18792335e9.13.1781814902171;
        Thu, 18 Jun 2026 13:35:02 -0700 (PDT)
Received: from precision ([2804:7f0:6401:b508:d1d9:f1f3:d91c:79af])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-966fc32849fsm439109241.5.2026.06.18.13.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:35:01 -0700 (PDT)
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
Subject: [PATCH 2/6] smb: client: fix double-free in SMB2_ioctl() replay
Date: Thu, 18 Jun 2026 17:34:34 -0300
Message-ID: <20260618203438.667881-2-henrique.carvalho@suse.com>
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
response buffer. If SMB2_ioctl_init() fails before the next send, cleanup
retains the previous buffer type and frees that response again.

Reset response bookkeeping before each attempt to prevent the stale free.

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4d6a989748f9..121ae914c3cf 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3532,6 +3532,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	resp_buftype = CIFS_NO_BUFFER;
+	memset(&rsp_iov, 0, sizeof(rsp_iov));
 	flags = 0;
 	server = cifs_pick_channel(ses);
 
-- 
2.54.0

