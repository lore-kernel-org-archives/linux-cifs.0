Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906BB154BEE
	for <linux-cifs@vger.kernel.org>; Sat, 23 Nov 2024 01:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732324536; cv=none; b=gCXeCcYVKFaQ0qmH1t5KazNZ9qij5DdPe53WitP9rEzLiYf9ekqSA7uzGuuUyMlG+NvqqB2B4uGUJjr9NvdLIzBNz20iIGXn9SPqwMedxuD6O0BZ+aZnfxf6DmEBo3212WLeu63/R+3PF4tGY93N12YkZY/bPay5xbC/qfojRW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732324536; c=relaxed/simple;
	bh=HPgrpK/tlEaYLDaYDgs5sN7h9Md3m6ZXUSrLb+doXvg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F7jlgSACnnr6eG/1/v27eROajnyuxu7HRg5H/4W3b5vixDtERXPIMH8qPY8m8q+VRm2MJcDIIkhmzW2Kb4cTS3dofBAI7m0p4BlAoqz3AotwCJnGpt+1QYnnoUWtDdnuZwLnNdJebGQmjSCkW7w8JEZM++y79mD7mY4DwaE4j5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOszUXpy; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOszUXpy"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-382411ea5eeso1567890f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 17:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732324532; x=1732929332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uxebx9p93hw+pnwK9rW+njV3dr2vF90svG/VIvLtRTs=;
        b=aOszUXpyMPAhDgQAEE8ZMGmgQIbw1OGPfd0YerG0M8IzV2aksFkS1Nr2COKrR+SDeU
         e6ePqTHmRKiVx8finw7isgQJP8gLAfwAdfyB15Qa30UpsqslbnZLLTRRZx794sfdxqc2
         fpnxpl5xogYGgRtJ3Dk2H9xkvIorJ+LX6ouGMzPAVfKeRNY054Z2acqyLcKXCJRcA8uS
         dk9kTnSMNiV/YpUBrZ/sOPYuOglqGwJGwv1QKR1RE+/LtLjyfKOAzEmLy2QF/O2Jb2ze
         mghxeJOORCu5f/m3E60XBYz68fuj7Pss86944MJqPFQZRcq3RDR34n9sMfmgFnGt4n3t
         nv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732324532; x=1732929332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uxebx9p93hw+pnwK9rW+njV3dr2vF90svG/VIvLtRTs=;
        b=aEePbDPZJlS2JLsELPLNG+VQuyCWpPdbYqKsyy2D0W8b5Pdi/+V7EFcw+Ii5FfkVEB
         r8NEdWCVmpCk5zLpRbLfMQv/QmLKNlnTadUWDDLdNNrI9uWRu2pRaTivWjv4mjpq7z3j
         J1N/IJYb5SJRLykQAWVPgwS4RyVnzEEvk760sBlE9K70/Xy8lBQ4KTSt5z+EVXSxPURb
         WYNulsY/USXS5zktYF0pbEjSgVGy88/QDbco+fHEhpDylhTpJ/+P+9RC3sb2fE06SHzO
         tsuKqXt+AYZXwtaPB5nbmzHcTHUzHvTpJ+tAe7B3JlS2pryktHB5ADfnT96P0hTf9qSS
         4UhA==
X-Forwarded-Encrypted: i=1; AJvYcCUqIMGxO2X6IL+6hQnkS+b2fBt6FQo2pF25DIHxkmbTC2aQbrnwGhv7QTTJZkDln8r1UO7H4eB4p1CK@vger.kernel.org
X-Gm-Message-State: AOJu0YzNB6p2lhh4OUkKdV8q09xYfJJNkL/DiCIGkyOsEcsZz+0KXyTW
	Te3nOtGidDkis+hCPb85LbGMVICMRocVvvRFW4MBZFQMYEvAKNsOIu30UEMtm9Q=
X-Gm-Gg: ASbGncsCU/2FVBVmBAiRQoK9LsnuVv+NoZykDsY5v+XDhbHQ23XOsaj7A8EeDgErf/3
	wffW8cDYYq4eps6q54/EG9Iswwfhg0e1nk71A7OGkA8tMzgWHxWFI4URBbKHLxSoXKdsNWcD3WV
	oCEub0vt4o4x/CTskV7N7tZKVUKrc3nRnpUweX+CTPqsu+LWBU36avh8tkln62Vv/vAs0hUXAST
	K3HmkhT8wNIsUMKo4GFQOdH4XxR1qqALVMY0QO/1M/to2vCwbpQlZxoFPVDq2J9XL4xyA==
X-Google-Smtp-Source: AGHT+IF3s8Mz/D/2xIAhC/CBpXNM3r1h5Ra3mLbPEansa+Y19QqhFZPSdNmAo5H9LWuFwgNunvNGrw==
X-Received: by 2002:a5d:64af:0:b0:382:47d0:64b9 with SMTP id ffacd0b85a97d-38259cb7f85mr7326863f8f.3.1732324531846;
        Fri, 22 Nov 2024 17:15:31 -0800 (PST)
Received: from localhost.localdomain ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eaca70371dsm4043040a91.1.2024.11.22.17.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 17:15:31 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 1/3] smb: client: disable directory caching when dir_cache_timeout is zero
Date: Fri, 22 Nov 2024 22:14:35 -0300
Message-ID: <20241123011437.375637-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting dir_cache_timeout to zero should disable the caching of
directory contents. Currently, even when dir_cache_timeout is zero,
some caching related functions are still invoked, which is unintended
behavior.

Fix the issue by setting tcon->nohandlecache to true when
dir_cache_timeout is zero, ensuring that directory handle caching
is properly disabled.

Fixes: 238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: Split patch and addressed review comments

 fs/smb/client/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index b227d61a6f205..62a29183c655c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	if (ses->server->dialect >= SMB20_PROT_ID &&
 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
-		nohandlecache = ctx->nohandlecache;
+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
 	else
 		nohandlecache = true;
 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);
-- 
2.46.0

