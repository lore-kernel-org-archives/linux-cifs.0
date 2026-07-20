Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E8544210A;
	Mon, 20 Jul 2026 16:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565794; cv=none; b=auUO0ci7bQz13P2869Nl4h9iqtegDQkADWiSO64cNqxANMNwMRwMtg753NDYKzzGCCJUztRuzxJm6QG15W7t1TKxV3zwkiYCpUC7siFjE4BShP6qFVXbJ49v2bYzZIGSoDQBdIRxsoqtvu0QBxUDgf7qMyVKdRDoNqwSK/McKBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565794; c=relaxed/simple;
	bh=hHtxf/lIqO2ZRvyRlXj0+JLSxQv2bRaz/Vg+c14XjGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfMwodDsgPaqh0rPOh4ancRR9t7IoC4dJNNvVY0bU1bMDtLUjyAvwg5SS4sezcEFqpN10wL+8yztb4g/vZfiM6vbB34cXnbZCxOuabRq1D4LPx6zOYMG8+NM6l9K+p/CRSYDbHm+Ot3NL0YZKR5avlqZHYxCzKQ8ieAuZTQwHns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mDeA1zSf; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mDeA1zSf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784565789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PuGKEYhiVlfOcyIvG191ZqxErZC4tp63ydbY2/P8S5c=;
	b=mDeA1zSfO/jNTJ5emtWxpna1kY6UKwKZNubFDuRpKI8M+py5ioP8TQogOmBmPq8fWSWSlh
	lJY8WuCDOj2ndg6Te+v/WqwzjsB9X13IV3OPObcd8x7KNbS5II/Cu2hQF3YS2lC2xu8Ne1
	35+M+w0GmHie0yW+Q2MYkellaWJecmhJzHS6DR4fIM8cqam0P/IMNiG4oUPE7MFG9oj1af
	Pk14Jh49zG0Al4RD04b2l5Ac4IvGS2zacv8zGZWf5a+W2kJu1V5RMbMAnn44H1uFsrf0Hp
	Xh9BRsDUsDLhO81/FDcHW4fi55BqMCo7jpUzchb9hzVFYKrkHuyci9+o1gRxVw==
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
	zlang@kernel.org,
	lukas@herbolt.com
Cc: linux-cifs@vger.kernel.org,
	fstests@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 xfstests resend 3/3] generic/795: check nlink returned by fstat()
Date: Mon, 20 Jul 2026 16:42:07 +0000
Message-ID: <20260720164207.732522-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260720164207.732522-1-chenxiaosong@chenxiaosong.com>
References: <20260720164207.732522-1-chenxiaosong@chenxiaosong.com>
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

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 src/Makefile          |  4 +--
 src/fstat.c           | 42 ++++++++++++++++++++++++++++++
 tests/generic/795     | 60 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/795.out |  2 ++
 4 files changed, 106 insertions(+), 2 deletions(-)
 create mode 100644 src/fstat.c
 create mode 100755 tests/generic/795
 create mode 100644 tests/generic/795.out

diff --git a/src/Makefile b/src/Makefile
index 7fab5d05..fd2622e8 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -6,7 +6,7 @@
 TOPDIR = ..
 include $(TOPDIR)/include/builddefs
 
-TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
+TARGETS = dirstress fill fill2 getpagesize holes lstat64 fstat \
 	nametest permname randholes runas truncfile usemem \
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
@@ -130,7 +130,7 @@ fssum: fssum.c md5.c
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) fssum.c md5.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
-STAT_TARGETS = lstat64
+STAT_TARGETS = lstat64 fstat
 
 $(STAT_TARGETS): %: %.c stat_common.c stat_common.h $(LIBTEST)
 	@echo "    [CC]    $@"
diff --git a/src/fstat.c b/src/fstat.c
new file mode 100644
index 00000000..fb878f77
--- /dev/null
+++ b/src/fstat.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+ * Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+ *
+ *  from
+ *  src/lstat64.c
+ *  Copyright (c) 2000-2002 Silicon Graphics, Inc.
+ *  All Rights Reserved.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "stat_common.h"
+
+static int
+get_fstat(const char *path, struct stat64 *sbuf)
+{
+	int	fd;
+	int	ret;
+	int	saved_errno;
+
+	fd = open(path, O_RDONLY | O_NONBLOCK);
+	if (fd < 0)
+		return -1;
+
+	ret = fstat64(fd, sbuf);
+	saved_errno = errno;
+	close(fd);
+	errno = saved_errno;
+
+	return ret;
+}
+
+int
+main(int argc, char **argv)
+{
+	return handle_stat(argc, argv, "fstat", get_fstat);
+}
diff --git a/tests/generic/795 b/tests/generic/795
new file mode 100755
index 00000000..0fc9a9bc
--- /dev/null
+++ b/tests/generic/795
@@ -0,0 +1,60 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+#
+# FS QA Test 795
+#
+# Check that fstat(2) returns the correct hard link count for a regular file.
+# Regression test for kernel commit:
+# 9dd1964ac59d ("smb/client: fix incorrect nlink returned by fstat()")
+#
+#  from
+#  tests/generic/002
+#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
+#
+. ./common/preamble
+_begin_fstest metadata auto quick hardlink
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	[ -d "$testdir" ] && rm -rf $testdir
+}
+
+status=0	# success is the default!
+
+_require_test
+_require_hardlinks
+_require_test_program fstat
+
+_fixed_by_fs_commit cifs 9dd1964ac59d \
+	"smb/client: fix incorrect nlink returned by fstat()"
+
+testdir=$TEST_DIR/$$
+mkdir -p $testdir
+
+touch $testdir/tmp.1
+for ((l = 2; l <= 20; l++)); do
+	ln $testdir/tmp.1 $testdir/tmp.$l
+	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+	if [ "$l" -ne $x ]; then
+		echo "Arrgh, created link #$l and fstat looks like ..."
+		$here/src/fstat $testdir/tmp.1
+		status=1
+	fi
+done
+
+for ((l = 20; l >= 1; l--)); do
+	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+	if [ "$l" -ne $x ]; then
+		echo "Arrgh, about to remove link #$l and fstat looks like ..."
+		$here/src/fstat $testdir/tmp.1
+		status=1
+	fi
+	rm -f $testdir/tmp.$l
+done
+
+echo "Silence is golden"
+exit $status
diff --git a/tests/generic/795.out b/tests/generic/795.out
new file mode 100644
index 00000000..cb357003
--- /dev/null
+++ b/tests/generic/795.out
@@ -0,0 +1,2 @@
+QA output created by 795
+Silence is golden
-- 
2.43.0

