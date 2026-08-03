Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DC440F8D5
	for <linux-cifs@vger.kernel.org>; Mon,  3 Aug 2026 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785761177; cv=none; b=Yddy/N25VafelQyzFA8REXBxjkseVFDc4Nkb38PMuy04qmu6Tf8IkshFdrdXlgqEMyVDXcty1Is+Wqp/BKCwCaAaiXMNL07ZvHduxmP209pSle74JKNSGVel7nim0coVKk/7nDJxfC6QZ9+/tTdjbptahAo7BCTe9j8fl9dlTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785761177; c=relaxed/simple;
	bh=Iq2/cxbhRLud1gV1FwJFagzjHo9q2lSuy2wRxglDkK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P97gJKc5H3L3LVobuwI9WNpxgKswWPXIdg0ReS2gVm7EJlh05KUOaas1egw/t4ZyaZci+iqHoiw9rqy7612la3F9aaSpf978BjvKNFYdxgQHqSKcY8RiQMpJXlr/aBqPBOXZN4X3mpT+RnPyuJnaou+ExFqL5WHPPTEdI1uBOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Lqua5JuP; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Lqua5JuP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785761171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b840jz3fr4gjkI9av+guvfAlG9dfBVIMqQqg6o0lq0A=;
	b=Lqua5JuPvenqrfy5yNh8zLX8egADzudqA7Xmr2c+empxUhAwVxCsPeqiE20/Mj+Y/xEtMj
	MDHE4vQVjbp2rv+9Nd/QBdGbPs8/m/9bCnXSkYxzpFYN6ckgsRZH7vCtPZ6SZUlO940yOq
	1XUq9Fq6MdQTwGo7yfAXNp7TGr7kaejou2tkvmcRkkPid1A7s0+U5qDPzwTPH8BPf+joYh
	qO5nKramlN6Enl7PoPm+LatO/oRe/P9LkVkOMsHiJaQy4TcyHGYc84VF6vXPSHBJ5eLlRZ
	eCtk59Gbn0HT8ekA4DoYfFiSgGFM98N5rSWG82LrZGaoSTdomziVeR3wCkaXLQ==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	hch@lst.de,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH xfstests v4 resend 2/2] generic: new test to check nlink returned by fstat()
Date: Mon,  3 Aug 2026 12:45:23 +0000
Message-ID: <20260803124523.238457-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260803124523.238457-1-chenxiaosong@chenxiaosong.com>
References: <20260803124523.238457-1-chenxiaosong@chenxiaosong.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 tests/generic/798     | 59 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/798.out |  2 ++
 2 files changed, 61 insertions(+)
 create mode 100755 tests/generic/798
 create mode 100644 tests/generic/798.out

diff --git a/tests/generic/798 b/tests/generic/798
new file mode 100755
index 00000000..e48a69a1
--- /dev/null
+++ b/tests/generic/798
@@ -0,0 +1,59 @@
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
+	# This calls `fstat()`, see `stat_f()` in xfsprogs-dev.git io/stat.c:
+	# https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/stat.c
+	$XFS_IO_PROG -c 'stat -r' "$1" |
+		sed -n 's/^stat\.nlink = //p'
+}
+
+testdir=$TEST_DIR/$seq
+rm -rf "$testdir"
+mkdir "$testdir"
+
+touch "$testdir/tmp.1"
+for ((l = 2; l <= 20; l++)); do
+	ln "$testdir/tmp.1" "$testdir/tmp.$l"
+	nlink=$(_get_nlink "$testdir/tmp.1")
+	if [ "$nlink" != "$l" ]; then
+		_fail "Expected nlink $l after creating link $testdir/tmp.$l, got ${nlink:-nothing}"
+	fi
+done
+
+for ((l = 20; l >= 1; l--)); do
+	nlink=$(_get_nlink "$testdir/tmp.1")
+	if [ "$nlink" != "$l" ]; then
+		_fail "Expected nlink $l before removing link $testdir/tmp.$l, got ${nlink:-nothing}"
+	fi
+	rm -f "$testdir/tmp.$l"
+done
+
+echo "Silence is golden"
+_exit 0
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

