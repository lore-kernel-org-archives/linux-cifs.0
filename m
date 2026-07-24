Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365683164C5;
	Fri, 24 Jul 2026 03:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784862766; cv=none; b=LZ52Y0pLHVANt7nLX0MzryJlFZMJDaI0VhnkH1SwtxzFu18ZLfQUvf58XlG7pz1b72LzoD5LJarb8mlkgrKqtKP7W8QcoR7+oiQ5jMjJhwA84NUHSTbbD2tJF/jW95Em2DAO08H1VM5BrRzo/gTNkSvRQkhdh1pPX7a/eeAtw7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784862766; c=relaxed/simple;
	bh=RQMubjKZkTsejZnLziSTe88KgkkAQodpxpo6uR7cAFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbMHC7K4NcWKug0WNlhACv+WnQa8pzlcbqyt7uk6HjrcXJWNZECqkzSGWIubYX8a3oMBbwhYIqv9j8guDFEL2sf4eBnAAnjB6ZA4npEQsVfZ3SGI35cOcv7JLqc0XXRAvhFH8b7hUbXQadSOpj1ArKYrAOSHPawFY9Mx+v9DUBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hRNJ5P5v; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hRNJ5P5v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784862761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bqy1X5+ryMJ6fr25+393REkQ+0kmg05MJ7n2S010gZ8=;
	b=hRNJ5P5vTLwHvPpccsgHmoRAydx1vv6q7ahREMu0zeIV9Fj+KlCat/qljls7c9mb3POx7O
	cJat6mQaPIlhb/NUa/Yt9VZkvVNDRLlI3XRT/GLoRKVKJ0mJI1a4l5cPhoA3RPpUwhzjVT
	MI/1XoNLQMBh4Uf/bTT0XQBdn7R0uRbnXHcXscgcGBE2Ok4ziMeYADoUMdnk6OQFohhDlk
	4Ptcp5dQy7FuAP5TFkhaPTuMOzBng+ny5S2KljcvnNX+TWqsQ12Z9cE9B2vQy0TDaXBHBP
	A/JQLK9Us6UeSz8B12f8Vl71Rpe1+Ee1nPr8i2x8/LwiiVOGOTmSF+RsH8OKsQ==
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
	fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 xfstests 2/2] generic: new test to check nlink returned by fstat()
Date: Fri, 24 Jul 2026 03:12:10 +0000
Message-ID: <20260724031210.332153-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
References: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add a test to verify that fstat(2) returns the expected
st_nlink value as hardlinks are created and removed.

Regression test for kernel commit:
9dd1964ac59d ("smb/client: fix incorrect nlink returned by fstat()")

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 tests/generic/798     | 60 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 2 files changed, 62 insertions(+)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

diff --git a/tests/generic/798 b/tests/generic/798
new file mode 100755
index 00000000..e44bb10a
--- /dev/null
+++ b/tests/generic/798
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+#
+# FS QA Test 798
+#
+# Check that fstat(2) returns the correct hard link count for a regular file.
+#
+#  from
+#  tests/generic/002
+#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
+#
+. ./common/preamble
+_begin_fstest metadata auto quick hardlink
+
+_cleanup()
+{
+	cd /
+	rm -rf "$tmp".* "$testdir"
+}
+
+_require_test
+_require_hardlinks
+
+_fixed_by_fs_commit cifs 9dd1964ac59d \
+	"smb/client: fix incorrect nlink returned by fstat()"
+
+_get_nlink()
+{
+	$XFS_IO_PROG -c 'stat -r' "$1" |
+		sed -n 's/^stat\.nlink = //p'
+}
+
+status=0
+testdir=$TEST_DIR/$seq
+rm -rf "$testdir"
+mkdir "$testdir"
+
+touch "$testdir/tmp.1"
+for ((l = 2; l <= 20; l++)); do
+	ln "$testdir/tmp.1" "$testdir/tmp.$l"
+	nlink=$(_get_nlink "$testdir/tmp.1")
+	if [ "$nlink" != "$l" ]; then
+		echo "Expected nlink $l after creating link $l, got ${nlink:-nothing}"
+		status=1
+	fi
+done
+
+for ((l = 20; l >= 1; l--)); do
+	nlink=$(_get_nlink "$testdir/tmp.1")
+	if [ "$nlink" != "$l" ]; then
+		echo "Expected nlink $l before removing link $l, got ${nlink:-nothing}"
+		status=1
+	fi
+	rm -f "$testdir/tmp.$l"
+done
+
+echo "Silence is golden"
+exit $status
diff --git a/tests/generic/798.out b/tests/generic/798.out
new file mode 100644
index 00000000..216d6e93
--- /dev/null
+++ b/tests/generic/798.out
@@ -0,0 +1,2 @@
+QA output created by 798
+Silence is golden
-- 
2.43.0

