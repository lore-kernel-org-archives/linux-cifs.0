Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AADE2DEA68
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 02:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377593; cv=none; b=J82x3uuTgHScM5WSTKLysheIT5cSaLqgZiCb8LfBjmiVzPXxQHurRAXWtFuXzL/023XJd0LW8HcYgKOAffN5KvcmMWDjjoy0xF4GoMW60l1bFilsCS03WRc5S39eeFnr7FwI23EuWWOcsuuskHvYaON9nWZBHoMyt+dZ9Xww6F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377593; c=relaxed/simple;
	bh=oGJVB68kxlzimfqih+fMXUD3zWJccaefGdfuh/YJgms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RF217S7YmqJaAZMghileVFFJP2DnBHRvLZKlN1gc5n5U68JlZia2j1IE9DhrVKe8ca8l/gg144XYfAKv3Xgze/7xzSVLy4U43pZFVVKrjUplttdJr2NfKzCbGFCvRwnNjzB+SKwAs233s/8eGWdoXSonJg6lQG49agPpPJA3ncI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=R2U3D3Ak; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="R2U3D3Ak"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785377588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZpbUmFON9cLHJ0s1jhxH1WhkT8e0jtFVKlC1EO9XGko=;
	b=R2U3D3AkY0uYRmwOfC+sVtHi+YjbemzWn2QP+HH2tlTqmZFoj6COq618y+x6NMMqtfGXuT
	fVLfg04L/lGfVi8eywV2dmmRzSqh9Rj6HOo40ZKo7iJgvbXZ5WMjICksR0AjA43BOTQiUr
	y9de5y/DSEOKCaocHjSgzyi6+cVcJlfAXAX0kNavw0lLgKbX3vHFS8nVH6p0dvTMhsBgBt
	bYICtrJwPlUxBz5EOyLVg+CA8Aq64LQX9oDLMyqtAoCT5pMqHPssfaki0IbOtClr1S6hMI
	7pUSTTXHqAxOek6douVmskIdj4RkCyjN+4WfrjQNIlX/gZmUZG2FImAqKwVLTg==
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
	hch@infradead.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 2/2] generic: new test to check nlink returned by fstat()
Date: Thu, 30 Jul 2026 02:12:38 +0000
Message-ID: <20260730021238.51634-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
References: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
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

