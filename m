Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A41FBF
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 05:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705986490; cv=none; b=hhXnyca2qFXxRRzZvbcIWtY5XiV9Zw9HVE3+W+fvf8KLHU/hinxjj9clkp8B49KpGZKB2sdtyRrrNr7gmd0mG9MTdsZPkaTxo2DFSMomycFIVAUlN/P4JPTnLFeO9ka4qQD2vaG31uh6QjJWlSrmL1BbbBa0i42/pVQQFBLElHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705986490; c=relaxed/simple;
	bh=EnnrWTfbj+2fkuOaD28qI3mhUPe3LLcApfm0abeu//M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pQN2f1srkPZzTfiX33jsWje5kOCMq4B6xDXFM9hN2kCQnfKhBXqBgWUjc7sZzETFIftYZ2be3oPXvVYFzAfoJaLk0Q1O0hbx3p1hJeWK08v45XhYp2ih10Mrn5yWf8hL+CtrC7ofa5nmghZ7HCOzmsontTnfnWQO5isEel4Rqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZhhBNoDT; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhhBNoDT"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1d751bc0c15so14592735ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 21:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705986487; x=1706591287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n5DfSOUkmA6h6gKJhmAgpSxR5fjL03XjEylxy0TklPM=;
        b=ZhhBNoDTdYN9hSmYiA/68wPcOr/ItiGL0zbZ3wVCeZv1og4CKX+fTuGNfvZT6M371U
         rSHjuhFtrvQvLoVvNbhlp4uaknrHFe/cmgRgaflOolbtMpOHVK0Q2QLR970GY7WhN5Q3
         jUAN9yFggGLQtE3hRzAoGbbzw9Hwhal5PnE3+MXLiNGKdn1q4ZuunkuhOAVNI0o04H9J
         4c5j/DbJRRlw2bG8Ioe60MCvCPych8VET66ssoTlW2prwmWteUHu/6Pjq77AhMADC9fu
         l/At+g4G5WZJ/+pbpNfW/sZKX3CIvocJKRhWAbwtK0ZwAa/Bna+DFWamw7i8TY4WjTht
         Z4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705986487; x=1706591287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n5DfSOUkmA6h6gKJhmAgpSxR5fjL03XjEylxy0TklPM=;
        b=LtXaoxIGDH71OsUhNZwjsSMOKOCoZi0bJB600NfhI2mI84pLE2KlEqkdt4rGXuLLJd
         MvArBnV6bNuHv1BnJmhIPqgBXMmeLfj7PGuaa39Nm4cKQ1D/ed4vihd/85mkc7Da7uMD
         IrHQ69JnuaPZrrnTyN9Q+iV2Fcst01n4Bp0vuDAPEsodZciUE1cRJY7GHFFtKPv02V6F
         G+EbYczT/bDYztYqZBv3dnuD10LcBi6+sXqOESDApudKoPcYylnMXb92BReZfypYLTNt
         DvkqVy2dTnHWKok6o10A+TRtDJjZZA5+ZaU1T0nD6qTD1LHmERWddtn5/rPzqV8CYjLW
         Xc6g==
X-Gm-Message-State: AOJu0YyL5DqaTA9PvnUV38//HiHhMPYvmh2QlVCJ+g+QuIeFIwv0zUTT
	42mPATBHzXXySU1jBdf4wa6qfyNCLL6YJoUFfZcreysK2O0sDe+3hHRcQWdI
X-Google-Smtp-Source: AGHT+IGHL4aWMviLK04NnR94MrWxYB/k+r2pmbSA01aKhRhu5hqHvkKHP/yC8E20qZB3GxZxLjQBSA==
X-Received: by 2002:a17:903:2281:b0:1d7:579d:89a3 with SMTP id b1-20020a170903228100b001d7579d89a3mr2947732plh.133.1705986487544;
        Mon, 22 Jan 2024 21:08:07 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902b60e00b001d4e765f5efsm7980116pls.110.2024.01.22.21.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 21:08:07 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: fix stray unlock in cifs_chan_skip_or_disable
Date: Tue, 23 Jan 2024 05:07:57 +0000
Message-Id: <20240123050757.5373-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

A recent change moved the code that decides to skip
a channel or disable multichannel entirely, into a
helper function.

During this, a mutex_unlock of the session_mutex
should have been removed. Doing that here.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4f2cc8373b67..86f6f35b7f32 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -195,7 +195,6 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		pserver = server->primary_server;
 		cifs_signal_cifsd_for_reconnect(pserver, false);
 skip_terminate:
-		mutex_unlock(&ses->session_mutex);
 		return -EHOSTDOWN;
 	}
 
-- 
2.34.1

