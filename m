Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C727BF7D
	for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 10:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771065011; cv=none; b=QGNwMlerC2n0ZE4Cj6vlwbLvOUIKHSaitkmD0Zw9ndBpT62kmR08UWTgKtgbuZkPk4KfvlCl2sGwOI0SPsLxwx23lTwMnmIOHVvMB8S7OUpgMhXailypKajbHliHIBDGQpCL4hidqnflPXmboYSvm6I0k9fK43uMXpn8zARSYvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771065011; c=relaxed/simple;
	bh=66bFQJioCqB5CFI2x5MfSZGkiisxs5PAxra1l1UjAak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S1RrxTPezM6A8UoPV76bmre1xr7Oo1XFhA+z066h08KLs0xR0YaSaCHuwJMXEIrHzoFg9ETsePa4CEpC7VdVClgSM0uQPEWHLzB/6/e8tjporMFLsXD8IQGcj1uRMoZbgH42iCNYMQtyHQRb1yZqaLaBJUSTX6vbaDShchxeVLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVF6s2FI; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVF6s2FI"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2aaf5d53eaaso10819495ad.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 02:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771065009; x=1771669809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4wUQJiyKQ4BFUx5XsHhu4xM8nw7tnHD69jYjWhXt4VA=;
        b=nVF6s2FI78C1zL8ffEitHH/hHDILHLFjo9ZoPTae+3kp23VUtDT2K11hy+3M7W2yCq
         KKqQmU+wLLm5vnYErcmh1hU0pj33DydDkC4p3Jd6V8w8kCBRmYDTA2onRvqsali9iCmB
         xfSVriXcGZNenssPMySeYNhDdIcG0SeGYif2QM9Qdx0pt9ohTCcmp911wo20a1U1HBRe
         JeOkDEuL0/ExGQOSkOJ9v/tTS0R+/yT8vdoWlglTfvX5y2/arFAFzl6EJFJ2STiT3eLH
         S9pLU8SUpDVKgOFET5bQH+A9Lo1ENz/59ERBU8l9567VCyHsUDIwpgUAgjGdyHTk64zn
         GLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771065009; x=1771669809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wUQJiyKQ4BFUx5XsHhu4xM8nw7tnHD69jYjWhXt4VA=;
        b=H/kQrmsB6FiVWWnj2MSvT8adUHLL5/YtmmkNTBL9IyY39Sn2br38lzy0ZBnNwfGrEu
         6mPnQW2/ik5diatLeNEBf+QNgEFaJUaHQbZkNf25ytgYY9t+qE/g9jf5iCs1NGCkSU0K
         pjcYchFOKKKrr1D4pR5Al81Goikgy/j1IM2UWiUNuEmzPLfk+cqv5SETkkn72Dp9ULr6
         8l1g4iJBfk/kBlHFVuso+XljLWM9iFyO4nEbaVl3ElkmOThatj8wm6QHD9rTZX0r9MAo
         aBAsYvk9QahpSTE2RRMk8wkr9MYmmauGiqUI02XMOlIL4SwhivqXw4KDvauRXJ35fuFD
         Nk5w==
X-Gm-Message-State: AOJu0Yzxws3eamAtVBiOtMRQ5mW/OfxJXuC6P1NT0pxe5XBwrE/FDrHt
	Bsm4/gbaV6GjcoKgy3OqFTtUYNSY5PrO7xOs+S2d5UQGPA9V0W36i9xmyjQJS52D
X-Gm-Gg: AZuq6aLVmlCXFwvgmHzvjJlDaA+D+Kavak0wuZk3r8yAgic17nBtjoHcEI/e+KYxuFW
	plqQiCt5KTUqh5EM7aiE2HvJ1scUvVQ7Gek6ELM06tx6dmec/Vw9kpm4vcef+9v/FzTWbMhXxZs
	AaTGFoajiMhxaUqbsa8lswpKWzNWrTP3+gcEb5o97qK7Yl4LL2bWjbOhuLIANT2aJcPMHLovyEI
	Y9Yh6F4jH+KsEbLW65NenHdFJXLh55LlRypkWNOfUoPyDybVOpf8E1pSns0lZFJpuJi0y1V/uOl
	tauQt8mVlgzFVCrBOhDKPXN//3qDMdXvl5nPZM5qwIZCMv2QkmAzuoXJdTRQwIIwFWho84opy2K
	ydHqaHcKuJcP5bjQOeg8rJBNAmhxDx4kaeEFnxEAFYlxcOUbn5nrnbjVFuqXWqBCxkUa1RwBeD0
	L03vF2uIyaKCfkqLI1w9lXmW3yvpNO7P0Zbt87LExcBIrZncW9RWAU/7oOo9RAuQ==
X-Received: by 2002:a17:902:ce87:b0:2a9:5f11:3a26 with SMTP id d9443c01a7336-2ad1740bcaamr22696455ad.7.1771065008695;
        Sat, 14 Feb 2026 02:30:08 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6f9d4dsm15741395ad.8.2026.02.14.02.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 02:30:07 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: some missing initializations on replay
Date: Sat, 14 Feb 2026 15:59:13 +0530
Message-ID: <20260214102943.190621-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

In several places in the code, we have a label to signify
the start of the code where a request can be replayed if
necessary. However, some of these places were missing the
necessary reinitializations of certain local variables
before replay.

This change makes sure that these variables get initialized
after the label.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 2 ++
 fs/smb/client/smb2pdu.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 262df6d2c2c82..ae39b3c027d2d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1185,6 +1185,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 
 replay_again:
 	/* reinitialize for possible replay */
+	used_len = 0;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
@@ -1586,6 +1587,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 
 replay_again:
 	/* reinitialize for possible replay */
+	buffer = NULL;
 	flags = CIFS_CP_CREATE_CLOSE_OP;
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	server = cifs_pick_channel(ses);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 4602b4dfe8322..7f3edf42b9c3f 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2908,6 +2908,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 replay_again:
 	/* reinitialize for possible replay */
+	pc_buf = NULL;
 	flags = 0;
 	n_iov = 2;
 	server = cifs_pick_channel(ses);
-- 
2.43.0

