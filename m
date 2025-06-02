Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0AA1DF25C
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 17:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884148; cv=none; b=SVT2R88ZaRO2AM+comuFr6DV6x8tGbOHsuuuhEtFt6mzkFVIipIVHGvq6qA5zcJdRIp7IeCpCB1Jo9ceWSM7d1kY/1mBzHdopKUrSDehpeNTx3mRE+/sSN4ZaEoAd/YPomotobTXlV6V/1gPKU6SjF1zI8T110t4X2nMjutX+9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884148; c=relaxed/simple;
	bh=iAPi68D8iukZS9quqnL3fO0fKwueioQ2RodZzIB21Sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuyYpdozdw0X+T+h7QbKdc2AY9Te1vwab/Iwwr8rvshh0IJI8JKJfle5OgmjjXX67f9KChlL2S2Z4WasVCVJlSakJmlBBQuFRC3tfA5sr/bCTYz6DJ5TOrP+Mtb6MjWc3Gwu0+RM/wOmcEbEn5qMwnxhi/yYpXADxC9pXLASkNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kOcPBpfN; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOcPBpfN"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22c336fcdaaso37913305ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Jun 2025 10:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884146; x=1749488946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upTZoLbxqvA91SITxeWTmTzDYrShPQ4RneJfiCESnQ8=;
        b=kOcPBpfN3B7ktLwKLTmnRwcT9UDQ1qCsD/RuqgWnBrYcsvVJvF8PWmT8BYI4wQ5PcW
         GPw+fGkBJC2xVjNrHQYMGHeQ+/rHPqYzwYfGOdJr6fmofwUj+fLC+GR6YaXeMom1DpRo
         IeF0f6r9mGExN5NUxCDvibclUSwgA1zuonkYkiFY4/AErDxZxBXYJIqX2gHzbGk3i566
         3eFXA4xOV2WfFmWgucUDWe13qs+wvMibH4EmiesYhqMlJLWXEylGoz3wlL9FBO0H5Uza
         D2/EPf4qUfUy+OtDlco5WrbHh51NVr/GAj16mGm1B1+OzCfjKjHl5xVbTri2Ij0FwEMf
         d7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884146; x=1749488946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=upTZoLbxqvA91SITxeWTmTzDYrShPQ4RneJfiCESnQ8=;
        b=faRibh2W/8njSnp9u0kPW88iwMtVau3SNfMRsGdSr3RKWYuJQp+dQ6ioTyz2I0FN5N
         FJ5vcug2Ey6Qctd5f33XDKyvFbXu7Z0Ooh5Y+P1gErLPLAk4moWln4hlGszZ0KZtJvLb
         mnoYjpLX38DVtR3HPo8IGcPcj1nimcfJIxm5aKYcf9Wq96Utv9rQorBDFEDiaXks8fK0
         h6wJyVEHiNeYSk1mijz7+vNbpcX4a3hud7W9uhAoITZEIBJa2n76MnW0jHVWCeQpt4px
         87uydhXVy9l1qD2wcjZHHFTL+Af/1yPNYMOlw2Yf4HwFDGzMrJgaS4EyuIUqvdNRy2+x
         HIeA==
X-Gm-Message-State: AOJu0YzMTmck75ycQzOiTDxuLkLpINdGTAIg8QM7u5biWSTFcPDEfwd/
	27xBO+CakKxsKUQeDqzZONYoftBAuq3cyixhp7RCrox3SsQd7vRcynIOuxbvKQ==
X-Gm-Gg: ASbGncsOtGAxdv33SMw4d3n6RinoIoVs33V9xh2D1Ol2frjeRemEBYlqgQZ4vghUCvJ
	3yVftHlkLMiHAmIzwJjO33TZbDdLpIZiYEWJDcD+sMhg0uKWDkjRDxoLJLUtaH5StL7PY+3+ZCh
	NIllVkHTm2FJx7SrwYkX+AZB2pMBlica/IGO0gVXlFxFmYfT76SgImpVHmKzuCpilOPG3cfxZYF
	IA7q6DEMtyt6nk71UPdWHrECmLyfriUQT56WLegZnL9BrtKn7pfaQh0aYPOLtyPf9PnIdERtiP4
	s86HtJ2Q2OLiFmvBmbtJJlaKSNwVzMhpj5f43esg7yUBoVOeAwn83OnlTz0cndfIgipcWtoEX9w
	LKIn9Ww==
X-Google-Smtp-Source: AGHT+IE9f6hBJo11afMZLyYG0PbnzcXK+YZJ0kvLnQ7YAaO2ONDxLAKT4a9SBwoCDJZyAwVCQn0U8A==
X-Received: by 2002:a17:902:e5d2:b0:235:779:edfa with SMTP id d9443c01a7336-2355f74fdafmr140990905ad.32.1748884145923;
        Mon, 02 Jun 2025 10:09:05 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:05 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5/6] cifs: dns resolution is needed only for primary channel
Date: Mon,  2 Jun 2025 22:37:16 +0530
Message-ID: <20250602170842.809099-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250602170842.809099-1-sprasad@microsoft.com>
References: <20250602170842.809099-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When calling cifs_reconnect, before the connection to the
server is reestablished, the code today does a DNS resolution and
updates server->dstaddr.

However, this is not necessary for secondary channels. Secondary
channels use the interface list returned by the server to decide
which address to connect to. And that happens after tcon is reconnected
and server interfaces are requested.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ca1cb01c6ef8..024817d40c5f 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -392,7 +392,8 @@ static int __cifs_reconnect(struct TCP_Server_Info *server,
 		try_to_freeze();
 		cifs_server_lock(server);
 
-		if (!cifs_swn_set_server_dstaddr(server)) {
+		if (!cifs_swn_set_server_dstaddr(server) &&
+		    !SERVER_IS_CHAN(server)) {
 			/* resolve the hostname again to make sure that IP address is up-to-date */
 			rc = reconn_set_ipaddr_from_hostname(server);
 			cifs_dbg(FYI, "%s: reconn_set_ipaddr_from_hostname: rc=%d\n", __func__, rc);
-- 
2.43.0

