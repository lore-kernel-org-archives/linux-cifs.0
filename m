Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973FA3ACEE0
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776855026; cv=none; b=sKevx0xIpM1FA33UKlVqJTn/6CaGVj7xcdzGqb5YnKcRfzfQj6n+L+U908kKV5gHAGs4cEaTbbvXvxovRkWRTZX6bEfN20CI0kAZZww7jS0fgX18AyjXK7Zcte/G43AwfQPoGsZNrmM9pwjWE7UnR7dPj7JROR5tzUv2cD202Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776855026; c=relaxed/simple;
	bh=NTs5bzZQ8z2/2klgBwWnJgNaEfHxSdH+3/p0mnoDh5E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rEXqcjmsq4c8D3NfKWcuMiEMdwWsfYh3S6zvs4UQ1T0ow0BU5TgykQFHHQ5zymSeK/4qYAArQlTVFPfEDil4kiHpPEdnXGTztaVfEe3XxpU/t/KT1U2CXeh5jS3GcTqWq/jhwFo20NHpcNLIMkHGS1ecwgVKMRlw+l1w/w+/zKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b=JQFFJh8+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b="JQFFJh8+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so66360585e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 03:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20251104.gappssmtp.com; s=20251104; t=1776855024; x=1777459824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UiqY+tQG9rAjKfengkzSw/6cHF5nEm3xrdSBpeQLnBU=;
        b=JQFFJh8+Eup6jJaQZcxo9WZHwPusUd3HTk/CG8/FC7hk/yft6EQs7mIQwenCJyY/h2
         T55ug0IrQlR6zdG5HeO/8hPdXK3dOwOLGgRw85jysphfJRNfox34ITnBW+OZ9pYIMnht
         S7AeGkCpNGILYQ74ox8G8VN2ptJDkwDiqMS4yv2W1pvgC1wbPgt9EMNMTsQaAmjGKBwO
         gBG3/MN2UceKrETQyhBetDQTNIf9mAkL14wkPpgDYz4XG4d4pAwcaSdrSbnej3ZLICL9
         UGuQkAKF/2vw2FOSDjeUHdOj9bv7SMHPYAXJDY8MZaGoyplaA9DNL3I8TsoSjVEfBIOU
         V7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776855024; x=1777459824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiqY+tQG9rAjKfengkzSw/6cHF5nEm3xrdSBpeQLnBU=;
        b=KCmfYfPisp7yoaXa9rDVYI646tTj9w6S4xtgGffE0Sg3DXUKrUxYWsYFZzHLOYpBbF
         btfpzHNkK7VOvoA7APliOvrZvDMnxgZKbiYJzeZW/h4gqBVv/0fBYsDIkQXRvyLpTaPJ
         NZQ2TwU3HTyw6jVt8OgNb9K0VRffsJoBUwHVgMHZkck1iTWiflAFdlLDTq2nA+cCjwYq
         pmxxLuk60UUNt8WFVcvH1FFXb1AVbUHYwLrWXRuvLyn7/QxwWYAuD0UEaUBoQWxfIaEW
         OClv70qE9meUn7GAa7ee/mAFbc7eVXTrLyR7quJulSgEv4/DqxHwK2yjyDqy2z8AJ/9N
         vpyQ==
X-Gm-Message-State: AOJu0YzhPjPE2dsBKjBZjM2bguegOuGt7LbyvJVfBy8RpxdzhkkAWMyl
	8fj3l0TysTOvXE7YfvC72QNHdERUEx2jiJOn/hwBnNjbh9f5XFccRHIHDY2cNxsVEIEs3i90J85
	r+VpJ/+8=
X-Gm-Gg: AeBDieuxHFuDaJW4GQ1k2kcBroU9nktgAcxaxFDbXDqDzkk0ulDhlqzAzXgQtqyPLXo
	HYh5XWZPIF7vIHpPdq1cdUDDcXLy9j9CEFd+o38WkRCI3uzhAx4TelrTqWbQt0lpVEJT0RVsNc/
	b8/gYJPgTkf9zLumATH16iPsexFazh0iyeyRv5PK98EfiAf1rgTOZVaRinD6d52kysPfrrexmH3
	qL5FdrBw9E/exPRKxF4duO5WSYNNd5MBm0vw1S+EIbxxSqiFiEIrwspkKStDOhAzAZRW/NBb54o
	8Lgxn5a0cDsVJKq7RP2W3xFsYsEtNUHz75pewG7F4RolkBZp4o4D8cKnaiYPX2JzEAALhyEjLj4
	ZRabM0sno8ks/g0bhSSuYS2smyggme2hTuaASj4einSJEJ+lErKiInQbWHBjdLKAN269s5rvVhj
	XsNS0/eenFScHufo1R66+7O+JF9OUcWk0A9AdXtqvfa40LgB3Zy0reTR/vLq5XSvKz6f4okPvPT
	KmunIviFUbdCisbK0QXPc2T0q7zGTzvwsMm1Ke5gbpYODqthVJATwE=
X-Received: by 2002:a05:600c:1554:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-488fb77810bmr323706895e9.14.1776855023711;
        Wed, 22 Apr 2026 03:50:23 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a52583fe7sm156095555e9.13.2026.04.22.03.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 03:50:23 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org,
	linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	tom@talpey.com,
	senozhatsky@chromium.org,
	Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] fs: smb: server: zero buffer before filling file entry
Date: Wed, 22 Apr 2026 12:50:11 +0200
Message-ID: <20260422105010.2600337-2-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

this ensures there is no stale data in padding area between entries
when processing SMB2_QUERY_DIRECTORY request.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 07782f7205dc..b55bef96d94b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3962,6 +3962,7 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		rc = -ENOSPC;
 		goto free_conv_name;
 	}
+	memset(d_info->wptr, 0, next_entry_offset);
 
 	kstat = d_info->wptr;
 	if (info_level != FILE_NAMES_INFORMATION)
-- 
2.51.1

