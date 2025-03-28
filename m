Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C490B13777E
	for <linux-cifs@vger.kernel.org>; Fri, 28 Mar 2025 06:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743142429; cv=none; b=DPfLtyM28ExkvFK8+oMv/fcwPfn0x2GsjOnZaRpjUIKbII1f5tRhnHIEBDLdMF/gNdmDlzoxRrfEaBPC0eJpiBl6UkychpTRUohCiAWUqR08B4knT9jCwc47tWZEfZISqM8y/G6eTbGPAVD+pHQ4j/q2uWp/ii65B2y+yH0b1+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743142429; c=relaxed/simple;
	bh=Wsg8ZatJuqYT3hPbw4Jwvt0jsfav6P1nCC0zVS4iFhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J6sHpjLecClwjX1AODzqol7Rwm48+0/UJO3qiLr08q5zm0nNhEzsdLL/PQ4y7cK+FET9gQauHd0MklGa7qT2b63JK0VKg9o3FUs/6G9bjdPaskNCReQmbHtCfJFs3K7N5Y2eKskDUOfMC1gWGid2Dyz2MdooK7h2G1mCjqsh6Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgXBVTBh; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgXBVTBh"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3d589ed2b63so15476565ab.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Mar 2025 23:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743142427; x=1743747227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xgg1zPfK11lPOGmZ7JCeopWICjETEHukwebolg6NfSg=;
        b=OgXBVTBhYKK1C24e6NXSiiy7Ppu0NuhedKEo+xKrjz+rvaITk9m8Nkf94hlX+yUTB8
         XxVppqu/J7nF6EoXjM0AhGhPNGYNhkjDxlBF9orJaLEWDaakevW+UUgb1epe4tev4Pdf
         a0G3VTvxWEi88rKEvkqgFZd8i9S96mPDTiIEHMmCGSJeX2mp8i/Hx1a4Qc7lNLY+foBt
         IctkBMi0ICFZG5l3DV4qBHV70cW4RzSLz5xGfgDUHbXd+BwnitiBSc3knIdDA9kUqZ73
         hMdWAfcN5xI1pzHBkRUozFeyaQ/SIrOmWNSEiGmxZYLIac6ydKMH88z/jeT/igLUkzm0
         t0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743142427; x=1743747227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xgg1zPfK11lPOGmZ7JCeopWICjETEHukwebolg6NfSg=;
        b=bPeOtNTUGcROI4EY0PVIt3wxo83bwrdodcUSlqo77EzqeCUarmiSX6tN2K02WWt/Fl
         ZY1fCN7LSIRi7mDa7b+3ZO5nrl4rTNdRW7eKqd13+AH4h8KE5p6E2xpIVQYUD56tZrlO
         dyv0TER7UNqjAk/pnR5Hjb9owD3UYP3W8RVgqpJ4YWfx5uzN2ivRumlPNcb95q1SbG3r
         12HXqOn5Zpba605c+GcM1jZHGH2PidacTFasGuJcHq16lc33JDud8SnAuAZpY1Rzq0fM
         4g3PiTtFendNKV0lgsUnuPLvY5dQyZF+3iDWbO8KiVf3LoNr2OlICZo3LzVJ9ReTWp6g
         9Odg==
X-Gm-Message-State: AOJu0YxJwe6kCHlXHMUoxWxyvKsXIl9ekvQWBSISTbmh0GcyDvb1S8Hm
	oUy7OuAteZM9ap0ko45hOQta5bwJ/MBGUU6A0g8IRm48WnHGu/v/+yJGC6De
X-Gm-Gg: ASbGncu5KzXNukHbAGApwBKYvJ/fURhM1MWyYYXxWZQMtwWB7QVj4WPQwPHAcSoPmVm
	9eU0Czs2oHVKAnc0R0YrFjSNthdXSXdQK/C0PHFUePVWSnEQExbZoowL3fvJ/zi9msZ+IG43qmO
	lrjlTEaxQT0FoQcTHNxLeDWGp45E/2WYDWkrXQb/1OB2Fxs+QxbnOgMELOR4DTLPTsy5HxH5trt
	WrpdSDCNC2ej2xIzhEV2ZAkADrDJ3UdFEQN8B1CTkMArt9nfGNhr5qzXxcnmS5XIReBIU1cBYV+
	AtjS41ZX06lgKgUa7a0u2TlyXlkew/+3l1PBE42CHNYY+6y0+TZfndrCW/sfPEN+GE92ba7Kfhx
	aZnwVMfVEu7kVus8TdoxcMweEVsV0beo=
X-Google-Smtp-Source: AGHT+IF3B8JlfKCQSvmwJUoi6//ihkfQOtF4btqvZWHrsU/u9zV3jo8B38RH+W3BexvKZ9wN/YUk7w==
X-Received: by 2002:a05:6e02:3f0d:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3d5cce2884fmr66661855ab.14.1743142426511;
        Thu, 27 Mar 2025 23:13:46 -0700 (PDT)
Received: from linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net ([74.249.180.8])
        by smtp.googlemail.com with ESMTPSA id 8926c6da1cb9f-4f4648718c4sm293769173.88.2025.03.27.23.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 23:13:45 -0700 (PDT)
From: aman1cifs@gmail.com
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	pc@manguebit.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	ronniesahlberg@gmail.com,
	bharathsm@microsoft.com,
	psachdeva@microsoft.com
Cc: Aman <aman1@microsoft.com>
Subject: [PATCH 1/2] CIFS: Propagate min offload along with other parameters from primary to secondary channels.
Date: Fri, 28 Mar 2025 06:13:12 +0000
Message-ID: <20250328061312.3043039-1-aman1cifs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <Z66BwJnHAI8zDOzP@linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net>
References: <Z66BwJnHAI8zDOzP@linuxbox.oloxx3b4wsrernbskgt3tooxxe.gx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aman <aman1@microsoft.com>

In a multichannel setup, it was observed that a few fields were not being
copied over to the secondary channels, which impacted performance in cases
where these options were relevant but not properly synchronized. To address
this, this patch introduces copying the following parameters from the
primary channel to the secondary channels:

- min_offload
- retrans

By copying these parameters, we ensure consistency across channels and
prevent performance degradation due to missing or outdated settings.

Signed-off-by: Aman <aman1@microsoft.com>
---
 fs/smb/client/sess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 91d4d409c..35ae7ad3b 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -522,6 +522,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx->echo_interval = ses->server->echo_interval / HZ;
 	ctx->max_credits = ses->server->max_credits;
+	ctx->min_offload = ses->server->min_offload;
+	ctx->retrans = ses->server->retrans;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw
-- 
2.43.0

