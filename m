Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690B61F17B
	for <linux-cifs@vger.kernel.org>; Thu,  1 Feb 2024 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706786139; cv=none; b=lxnaJpFhkXcyv85yI8oPt3vv/61lX0hVNMqYvrZ7vEFfXDZ1V5EYh81i1WTMnfi/duc7LsQHiWWzoB9SOAit2eQZO5ZPkD94/WR0H9B4EaRrrPZZ7+PWQl3HxAuJKJyWXKhrIwDG801RhSauUFDX0b+ixoC7+cMSOUEP3fqEWwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706786139; c=relaxed/simple;
	bh=tc0U37Xi3ByFlkDdJoERrW0Ssh+9zfjEV3kY9r0T8II=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ga49W21xMjJls/TgGwfSWBG+N15tWqykQ7rB8Mp6m+1dfjA8oIZwH9nxR1KHEkko2Bsi/lU7Yhve4JQnS4zaFCaqafsNuWLRRQdF+xA0bgD6X8XTSXw2dwqGHqSdGklPxp+NPuWq4KVccWNY6FIH0TgeVsE2JSZaU9dvmBzD0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LdJuK4Da; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdJuK4Da"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d95d67ff45so719245ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 Feb 2024 03:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706786137; x=1707390937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B2IS41f2qx2GaxxF8Ll3CrnxdEdvgw4trapXDmhY4kc=;
        b=LdJuK4DawryGVdUH19bX6jnE9IVVsHv8mnXsCRp6F7K8Gmc2seonEP2K8ijZ36WHTA
         HAJiEChiX2uMyw/tSORN2XrIi4XUse0N0fFmuwuzWzdEj8b4qnyCXHiZ+lNb2P/giTci
         AD2XuDYVHb6bsAksqLM1MGFUwwIsGlG+BWXsenSKEpMEXevorJtMRFIcZaCrMGRljOBe
         xECqkw20kNHRGz+e4ly184jqQrXBhWqnzHo7xa9Hpa5ez7LDXWUy1IMDIvGHKhNi1ATT
         8+wlqYxl3F3oCeV1cu2Ao9+MsU9lrRiG7hFkUXj2J8LqRApt9XdB4cH23SeoGXgdyw06
         qXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706786137; x=1707390937;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2IS41f2qx2GaxxF8Ll3CrnxdEdvgw4trapXDmhY4kc=;
        b=TlyXtcUPHdENBLeyNC5LYU0+t7Tzc4m+QcsqmMgI50ltAcALGkD77eDPvk4/VqwTxM
         vQW1Z/PBdPKUrzxwZuYgCz0+QFLmBjNGeQr6NGjcCj981uNKUtxiSlq4eQ2VzytZW0NY
         5hAp+tkqL9HvcpTP/qHmgGeMP2SzTxuEdZSqhsBTWUVSQFXOLA6Q/rW6zaPDRPTwP01c
         VjtE3rx8ZWwXU6TOyOi3lANnxbU+UIEqCV8HvBRi2kegablPXeeKdxJ1Pz+LIUKIFFDz
         QPoWb1LU/BdrnU9bUo4d2D+gdHmohCXfiJw3hey/eS0CaYPOmnGUASVze0PJoJ6zAxfg
         SMVw==
X-Gm-Message-State: AOJu0Yz8K3OXBFHLT3/7DiiN4wctuz73Kg66dKbqeSIqYVj9C7kdDU3l
	BZanMFOpNVZpir9Xfp8/H6ynIADBspnt3hGTHjJNJqmPM6KQHkRMujo0frye
X-Google-Smtp-Source: AGHT+IElj+eoqsVm8wXQwKh74+JbGRvfWuZ9uroY2gyfibUn5dckYHO5SkJMAIJaDTXvcfrEQSZZEQ==
X-Received: by 2002:a17:902:c1d4:b0:1d7:92d7:5d1e with SMTP id c20-20020a170902c1d400b001d792d75d1emr4467243plc.15.1706786137043;
        Thu, 01 Feb 2024 03:15:37 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUAXMssok8xOu2rSSUpNHMWVQVnuIHETdw/+Xtz/rwI61PX3oMGlqM7OmbO2HEhb/1dFYw8BjbGCItn8AaHt5t3TE3bBoXnG/6wXSqKT6CdGJ5Yw9KZL9ujYSpO5deHPKy7wNWcpTRotH3PfZFT
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b001d94c4938b3sm1129926plg.262.2024.02.01.03.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 03:15:36 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/5] cifs: avoid redundant calls to disable multichannel
Date: Thu,  1 Feb 2024 11:15:26 +0000
Message-Id: <20240201111530.17194-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

When the server reports query network interface info call
as unsupported following a tree connect, it means that
multichannel is unsupported, even if the server capabilities
report otherwise.

When this happens, cifs_chan_skip_or_disable is called to
disable multichannel on the client. However, we only need
to call this when multichannel is currently setup.

Fixes: f591062bdbf4 ("cifs: handle servers that still advertise multichannel after disabling")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 3110aabc32c5..75713559e69f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -419,7 +419,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		rc = SMB3_request_interfaces(xid, tcon, false);
 		free_xid(xid);
 
-		if (rc == -EOPNOTSUPP) {
+		if (rc == -EOPNOTSUPP && ses->chan_count > 1) {
 			/*
 			 * some servers like Azure SMB server do not advertise
 			 * that multichannel has been disabled with server
-- 
2.34.1

