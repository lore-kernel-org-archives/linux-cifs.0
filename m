Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6771937C0F8
	for <linux-cifs@vger.kernel.org>; Wed, 19 Aug 2026 03:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787110246; cv=none; b=YHec6hDLdtCXLselB8lt/PAVqAaUPY1eU0RrFpaHxLZ2oRsqlMusFSh4O38jbDFttXomAjsnLsUz33wa8IGKuo0rzAiYN7jhCL5tmfRjjdSZb/xRxBoZGOux+S8ImQEcbDoHSKiP4XjKr01eKTniBS5Vdmto9/rl16T/qNclXpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787110246; c=relaxed/simple;
	bh=Hf8jb04n+OSG9+FTscCgMqP3jePXwQ1Qo8xtQt2hesA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d4x1bk1ai29/wrGUZ4TdpPeBvPc7uXgHgZCz4tWQmYfCX85mrCEmL+ItTK1IATErwGGMvuZDEXUfsL4FkIiKP9JSCwePHwpCVHZmoDADnhfwUErxoHudxSCfmKhKJSv7s8S89rURIay+/pTunqsOQ+MiaJueX4SwnX4bQqYPONM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGadT8q/; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGadT8q/"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c96c92c0980so267541a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 20:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787110245; x=1787715045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ZoAAx48uqOdbRDUh6X+Manct/g/MGnlfeAG9fyc7HY=;
        b=jGadT8q/0O4AWp3/gLMKM2WL9z8ASaS0yj931iLBIGVsSSU8vbdWA3JRUQfC0o8f0y
         SIhToNaTJLmfAR4J0xWGCM3dHLqpmhRwI9v6Lb/KVyJUeGF7qOsnK8vBCVox/tCJqM5a
         PXmZBWiEuCAzR9cDoc/p2CK9eNInTf+3TlyjJdclMoNFltLZgOHbfLEvH4Qn6GOkpZc8
         t4gOpxDWC1sU5rqtQtwcTMKsHPkLejsZ4E1KmzOxpGm9mJjNnZp0htcrBXbkXxQQX4ip
         9CDFsEN5iKdBBO9B4YpyGRZ8H7DnbmPEbMF9VxknboDz5h8Uo7dDYJDUG1JT7j68TDXe
         2Iyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787110245; x=1787715045;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+ZoAAx48uqOdbRDUh6X+Manct/g/MGnlfeAG9fyc7HY=;
        b=L5SE92sD7/pv07vknhp6Qijo/bYZfxeP+OvVjK+mB0dfNROBuufAhH8h9EPihWX0uj
         Ez8YQYQjVJFPq1DbK57bwb68zvqJ6SpkP/PwVNysISntqvddP7VOkIRzbXm6bjkhW0Pl
         sPVg481GsTpyw1CSuRuya6QXgjxiC7coi8c0nm0rEU0AvTaaJfIC1eR1BMbd1O79GT3B
         TbV8BiCfqUFSCM3VjeCyzLQXISNRq6CjGIKi7GkqHHhmdOnAcbDRYqFqme0NQn3/zg3S
         mm74Wkf7X10cEbfmC1CBlOlPoOeUKrMsvoShjzrTb50BCIYPVYKr5DhI0E5pjC5DB4xI
         qdHQ==
X-Gm-Message-State: AOJu0YxOx5n2WcRSoaNwM+XxjKwH7ImsDiVs0TlJGGMtC1mhpjqBt7Q/
	0cd/JW6WVovomylNrpAAtV9+A5NB1eVy3dKMbQkpsokTtkUMacSm8lIZ
X-Gm-Gg: AR+sD10z0hncmFDvle2tLhxNIKgV0WFgWj9GdqxTMy/sW0mwz2YerkNYUYXe2iDlBUw
	7FPS35LDI8SDi5wX+dv4+wW1DSYCxrmE2sdl770R4027atiXfYdaupduwfbOZLxB4dL9P3tQAHh
	WJjuhnupKmjbb8N8iFQpbQwtaEhbDeMhpK1S8YYRxLsNwrOUavmVJzx3Q83ZZN+YJr7NqUBnL0m
	1SHYqGdPsT9rhJJqbiqtl6NFHwLZkyn9S4JsCXTVM0+yC3te49/ckF9eByG9tnsDs0SFWmOge/y
	PJIvBK4X3InJIcKIgpYu9+Db8wK9kLcPQPtY3kwry+N5uHFkHxls7fPoIfkH71l5yTCkp5zr36G
	aty1kCnSaJqD+n5ro3fDOcMwrhDpLNoWmUYJZniSf27l+n/B6yuIGa+NUCJgOtrzb5eBv0f5ler
	0sd3rAyHG5Aq1P16GhqMmPF8UkPreb9DqfVF9Xw8620Gh5GYwPIwnjKWoG6wzDfrrZB18e+lkB9
	FQ=
X-Received: by 2002:a17:90b:384a:b0:38e:6a44:671b with SMTP id 98e67ed59e1d1-39580493a4cmr3181164a91.0.1787110244552;
        Tue, 18 Aug 2026 20:30:44 -0700 (PDT)
Received: from localhost.localdomain ([180.138.223.172])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3957fb17f48sm1016793a91.2.2026.08.18.20.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 20:30:44 -0700 (PDT)
From: nanx95726@gmail.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Hang Nan <nanx95726@gmail.com>
Subject: [PATCH v4 0/3] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Wed, 19 Aug 2026 11:30:10 +0800
Message-ID: <20260819033013.46824-1-nanx95726@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hang Nan <nanx95726@gmail.com>

Changes in v3:

- Update SMB_SERVER_KUNIT_TESTS help text.
- Moved kunit tests under fs/smb/server/tests/.

The following patch from v2 have already been merged into #ksmbd-for-next-next:
https://lore.kernel.org/linux-cifs/CAKYAXd9XHJSNfrFr+F8thNxFnXqGGcKpS1b1qR4DNuu82+j_VQ@mail.gmail.com/

Hang Nan (3):
  ksmbd: add KUnit test for the DACL walk boundary
  ksmbd: test smb_check_perm_dacl() DACL walk boundary
  ksmbd: test maximal-access DACL walk boundary

 fs/smb/server/Kconfig              |   2 +
 fs/smb/server/Makefile             |   1 +
 fs/smb/server/smbacl.c             |   2 +
 fs/smb/server/tests/Kconfig        |  15 ++
 fs/smb/server/tests/Makefile       |   4 +
 fs/smb/server/tests/smbacl_kunit.c | 301 +++++++++++++++++++++++++++++
 fs/smb/server/vfs.c                |   2 +
 7 files changed, 327 insertions(+)
 create mode 100644 fs/smb/server/tests/Kconfig
 create mode 100644 fs/smb/server/tests/Makefile
 create mode 100644 fs/smb/server/tests/smbacl_kunit.c

-- 
2.55.0

