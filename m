Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88524409134
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565374; cv=none; b=fdFGCKD7sTdJ2Op307ZIeXZfMSwy87u76YL/DPpMQ+NrTNbsSlbdZ6h8nqOmKJcphIP8krm0gbn1EWhFH9INNpYEY3f1On7xIJQqqUI7zU0XUzv+FP4tHTfIlSh21RKQyqa/GKdrDxxX30D4dcJsvG6mvyVoRCNT789exHKTaSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565374; c=relaxed/simple;
	bh=dg9EM+EbSu2g6+939ZA6ti4jEwPEjQJjVDnjxB0sAHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BBXBnuJ/IREXv8IwpOejxIdvcWpNgdIWDsWwv8jeRvymjY/LIonJPvFk7Ti1qyHvxS5nAMxBOiCkHg5xgm7m643Pp7yVPre/EusvuN26un55wK359TpK3AaoFYnG9pMoF30PfZPK7IW1+dnwDyjb0KhCq/y3ShQcxnQna/hggZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=PPxhJCZq; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="PPxhJCZq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784565364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RULXTOMmkZHfgaFBkHjp2QpNGtxGhALwp9yHrpl7HLU=;
	b=PPxhJCZqUSZ7edj3iUP6TEqu/Cm7K/TijTcZQRUR4g0Flw2YAq/GBK5sP54vsfQGNNNNu4
	XKC9Zwy7Ptl66izi4I+pO07Gnk3GbFPbidcBI2uH757AIRI7GLAaTZbidPoyCT/TAv+nlk
	iLMlZ3uvHwDRhVAlBwk82qh7DOKw7hUzUz5w1gPo7Jgfc03H6HDGPhNgWV2siTD/8NtQBr
	UNkpm51+oJu7PlnZtrKf8D7E3+SOtPcKG2Cih+Lv8zAbVvsinxaKzluC9WOMeB8pptj3XJ
	XFIJqeKbH+asYqBldDXGUC9/9n8A71yxvvNVpCt05DZUATWaN8yHswyr00sdBA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 xfstests 0/3] add generic/795
Date: Mon, 20 Jul 2026 16:34:59 +0000
Message-ID: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v1->v2:
  - Add patch#01 patch#02.
  - Patch#03: some cleanups.

v1: https://lore.kernel.org/linux-cifs/20260713151658.533155-1-chenxiaosong@chenxiaosong.com/

ChenXiaoSong (3):
  src: factor out common stat code
  generic/002: clean up the test
  generic/795: check nlink returned by fstat()

 src/Makefile          |  13 ++-
 src/fstat.c           |  42 ++++++++++
 src/lstat64.c         | 166 +------------------------------------
 src/stat_common.c     | 185 ++++++++++++++++++++++++++++++++++++++++++
 src/stat_common.h     |  16 ++++
 tests/generic/002     |  16 ++--
 tests/generic/002.out |   2 +-
 tests/generic/795     |  60 ++++++++++++++
 tests/generic/795.out |   2 +
 9 files changed, 324 insertions(+), 178 deletions(-)
 create mode 100644 src/fstat.c
 create mode 100644 src/stat_common.c
 create mode 100644 src/stat_common.h
 create mode 100755 tests/generic/795
 create mode 100644 tests/generic/795.out

-- 
2.43.0

