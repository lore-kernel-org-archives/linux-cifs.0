Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4A28BEC
	for <linux-cifs@vger.kernel.org>; Thu,  7 Nov 2024 16:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730997677; cv=none; b=AjKOiZg0Hh+NbkN0XY/AvNs82QUbZRZFhoHNv/NtXbfzOD4980ShGMLOcqTqAUbQQk8V+TreV5SRwxCPDUuRN6f3wLlBNVVZNbJco6ftRfipDwSB8B+J5j5idfbFv3NZrFt55/5PXj1p+LsWgyxe0hibdRE0mmx3gUuon+4B0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730997677; c=relaxed/simple;
	bh=vbDyQFue2yyFOCzOW/IZVUp2LT5iN0pJbov8sjMKBWg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sbl6yduln6EZ7k5+ycSdIsiiCA55TMm+ip5fGuqmSb5DLCy2TDD23KfPL4mqRPszazdrz/469B8KJtFKSeO9YVo3xfjT0AjlZLR3sP8jMA7hgLf69zK/U4MAaab8ukc4PrhV5zDemCtLDH+4/IHZpGBDqKcdbMRMLaGeUTZ5Kzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f+EXykch; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f+EXykch"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-37d3ecad390so1364193f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 Nov 2024 08:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730997672; x=1731602472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X48QXGikYauDYbQBJX1TarjLO3xffqcYgo4rqKOZxuM=;
        b=f+EXykchUBznB1QtWeh2Cu2By2KloP4F2Msr7fj098kmIxpNeugFt6SWufbQ2h8pr3
         ijJ/A2hSiiQ+YWOiKB05Dj821LKMJK5B9RSiX7lJTx8Xp9TsSNUjPfmduWbbQp9zuqVX
         yN2q+mMxE4tTCPQTM7HJCFWnNGo5I4VItW3WWNyOn9GkeZMXucxbNegZLPFKGejgnA6g
         9d8ahWDJlTLmCWKRtSXlxkkzs7AcsOysLl1lGZ/UT0j5whoH6UVnQ3O6d2AJCjsXfTjd
         zWajmREtJLgEm/eT6Fkkt98vheYK0gczlRnfslRa0qz+VbVloDFsrASkfpzTw1Fg/9i5
         OoYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730997672; x=1731602472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X48QXGikYauDYbQBJX1TarjLO3xffqcYgo4rqKOZxuM=;
        b=Es/v35w5FPXHaYCyte0NB0hBdcleuitFKgUo6FD1m4Jd8gIsDdTqvcvjVXdHfxrK47
         vz8c2bnIsIbOROq73JViWVyCKG6PQLWtvbWtl6OTGBsJAf7y8NBkppHeEOUsL843Ru7s
         Pp5sAkn5edAYZEcMB1bBVAqvlepX0ZuX3NWCjGT362CExpxSdfngl6zQk8cuBCdVwZ8p
         4SBFE1WEU7ycjuaRstvItrmQ6qKoQGIzS6LpSnkebztf4YeMSw3DxmlT9co8LlCALBsA
         Mu0zriQX0K3qW59bQMYeFLDXuTkgvUUrMcIpp1ka1PsH9+kfvH0bTAJELav+AG2P8uOX
         AVyQ==
X-Gm-Message-State: AOJu0YziHEitjNExq6UZZ23TAi+G+VRY0YAj83D35qm4TW+mV/7ghyJJ
	oJ/Z+FBB0fdh190TTce3/obczBTz1a7Y1xGVeFaAsh0OnfLXZ41nVNPuK+my/NieL8PBuvPKtc1
	QYC4=
X-Google-Smtp-Source: AGHT+IFIFCoo6SLSGxNzV6kWD94Xsro0/00zWVpA5rhtezcwp3EdqVVLpcefcuFXcQZljoC9Bfqoww==
X-Received: by 2002:a5d:6c66:0:b0:381:d133:d541 with SMTP id ffacd0b85a97d-381f0f58573mr168975f8f.11.1730997671790;
        Thu, 07 Nov 2024 08:41:11 -0800 (PST)
Received: from localhost.prg2.suse.org ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381eda05ce0sm2124729f8f.103.2024.11.07.08.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 08:41:11 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.com,
	Marco Crivellari <marco.crivellari@suse.com>
Subject: [PATCH] Update misleading comment in cifs_chan_update_iface
Date: Thu,  7 Nov 2024 17:40:29 +0100
Message-ID: <20241107164029.322205-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 8da33fd11c05 ("cifs: avoid deadlocks while updating iface")
cifs_chan_update_iface now takes the chan_lock itself, so update the
comment accordingly.

Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 fs/smb/client/sess.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3216f786908f..51614a36a100 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -359,10 +359,7 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 	spin_unlock(&ses->chan_lock);
 }
 
-/*
- * update the iface for the channel if necessary.
- * Must be called with chan_lock held.
- */
+/* update the iface for the channel if necessary. */
 void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 {
-- 
2.47.0

