Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66213D0DD;
	Wed, 13 Mar 2024 10:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710326458; cv=none; b=m5zWf5JG+C5U0fEdEgyuDasajYcG+pwe59YKn74fqH420CrApuOO/EPGzAGUAjL3jGKyaxkdx7+vtutM960owQfRXqSgIKgYzktPmlYaxW/lczo1OYmsYEiCkOb303tO70gTQZLtINysixZhhZL4VNsAGRkYw8CZzUxmpHNPFkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710326458; c=relaxed/simple;
	bh=UNelH5wTjTT8i5mdCLk5Ttahrbgzioby/Lc2B/x0uB8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Zm/BxzLj8QcvWk+UKMngjHCkHFbQTfAAs25d+e2ijEegtdtf4ZlRW6Gg3OExw6xkZ5d+5KIYa9IC+L03A3+v27EW7jnuqpeikghsocyfP03KFm6wh63YNc4vvlnHaltJGzVy+B4hsd2uv2fVBy4vzQ3Sh0gVW4GOIOoLNFq5MMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Io1OYrKT; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Io1OYrKT"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1dd8dd198d0so26675945ad.3;
        Wed, 13 Mar 2024 03:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710326455; x=1710931255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C5s1glts79sNex9bVlpA0c1lBh0VMrNrvQIOC8soHhM=;
        b=Io1OYrKToCHGcZY+JOKAMfXdCa4FdCZkhhAuMpLW2qLSjdn0oXKPOYmoQPVp7bBnBq
         F1nuadO9h/KzW9HGqnwLOIKZHw36zX5Jc/t0aQrxOtAKKPv8c1VH6KT/mINbdoDWvV3E
         M8SyOU0muVPXbx5WDx/bqfctEfzN/a98gRWLR5ic/qaitOb6KM5vob+7U87yx0WrNFaQ
         i8FGBtqEy0hw4/oLz0gev4WTB00rusH9+Y90ZJ8ekmCfNBUH0UZscOLApLE0tN/hnZ+d
         manD/TvLXg6cH9DEbY0qgjP0oG42Z3ic2mJf58ytEq2OxXrxx4BDJv1fVhFk3nN8I2Vq
         F0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710326455; x=1710931255;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C5s1glts79sNex9bVlpA0c1lBh0VMrNrvQIOC8soHhM=;
        b=jyBBiwnSKpJilfn/xNBnhudSWFYoslnwsViNb3fOrCiYKSyxFNV3PhDHtJDcjn2xYD
         kp5HU4Q80W/Y8JQFIAmpVzMthI5ffOrqBelid8RNPwq+nOzyOro3DaQKZnpvoEeIhriw
         dGSdg6ZZskbqbs9Wn/F8IZa/qYucwg6ugxKzPP+RVOmb7bTb1m9Q8+vhWNoJWcEzGCAe
         3MPYayeUKdnIfJXtLoX+u9U2C0QDOgd2Dt1+nrSuKf5Y+PNO3O7qJ+WWGQOIZ2ftkJlw
         tYJqkgjgDg1tnLDZoJ4k9hkijT5fY/C0GGHSktJd4Xhaux7yyKzBpcKgxHI8fOm847fJ
         aqOw==
X-Forwarded-Encrypted: i=1; AJvYcCX9lGrA0ALIwnF+jVFvhoD2K+O6zn7UQ/qVUzm4kEJ+/vFCurjTCd3wx0d9ugVe/CpO1aT2GoqMMAj1GwkdrmD1qFqCqgwA
X-Gm-Message-State: AOJu0YxFX3K/fyYbKT/yzzPBePyMkSVolxrIxsZMiOWIYwW/3mE/GJDH
	w7UJfOY80F+W4GV7ypURBhMDl9/WYCGrbjxizKqa+Bc87k8ID9AdXPow8UmzBXs=
X-Google-Smtp-Source: AGHT+IGDLrLMn9X0u3tp4D6RyjCsWeTOhWxeZ5pHgx6xYzwGOuN/E1yeatexknW60aQPWKk8kkRn8Q==
X-Received: by 2002:a17:902:d54e:b0:1dd:7e30:4b15 with SMTP id z14-20020a170902d54e00b001dd7e304b15mr13831222plf.29.1710326455054;
        Wed, 13 Mar 2024 03:40:55 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e80600b001dd88cf204dsm7175433plg.80.2024.03.13.03.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 03:40:54 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Stable <stable@vger.kernel.org>,
	=?UTF-8?q?Jan=20=C4=8Cerm=C3=A1k?= <sairon@sairon.cz>
Subject: [PATCH 1/2] cifs: reduce warning log level for server not advertising interfaces
Date: Wed, 13 Mar 2024 10:40:40 +0000
Message-Id: <20240313104041.188204-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Several users have reported this log getting dumped too regularly to
kernel log. The likely root cause has been identified, and it suggests
that this situation is expected for some configurations
(for example SMB2.1).

Since the function returns appropriately even for such cases, it is
fairly harmless to make this a debug log. When needed, the verbosity
can be increased to capture this log.

Cc: Stable <stable@vger.kernel.org>
Reported-by: Jan Čermák <sairon@sairon.cz>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 8f37373fd333..37cdf5b55108 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -230,7 +230,7 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 		spin_lock(&ses->iface_lock);
 		if (!ses->iface_count) {
 			spin_unlock(&ses->iface_lock);
-			cifs_dbg(VFS, "server %s does not advertise interfaces\n",
+			cifs_dbg(FYI, "server %s does not advertise interfaces\n",
 				      ses->server->hostname);
 			break;
 		}
@@ -396,7 +396,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_lock(&ses->iface_lock);
 	if (!ses->iface_count) {
 		spin_unlock(&ses->iface_lock);
-		cifs_dbg(VFS, "server %s does not advertise interfaces\n", ses->server->hostname);
+		cifs_dbg(FYI, "server %s does not advertise interfaces\n", ses->server->hostname);
 		return;
 	}
 
-- 
2.34.1

