Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CA72D7D3A
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 02:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783650621; cv=none; b=TzaZPly3i2P2pyL1st2iwJwy0mFhbt7WA+OwT1joIGutMlUu37uUqgbV7d097lqQV6pPSuvCRSdfiJ/C1cv16MvjVWYFX5R+F6Dt3CX4asIuJoFyEAA3bmkSYbkj/omfisfJY8a++d6YrEOV7YZfZwnYlfCFGRFZtksFrSYYGhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783650621; c=relaxed/simple;
	bh=eU5dQc6RCW+mxzU4p5J587p/HlGSRrlSC73EfENRA9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h96BUlmdg4iWKUDTFO7vQEx9kJd1b7/9EowzYPJq/MLto2NsM6TTDC9ey4XvXdpjQbnMoFgl+aQhWSnmgZ8QOb+AvHqrhzwXvesfNTbTph6ObE/rwd3cBgxJNy4mj3ts9BSrZD4uaJBSDkPDnA8mv+umeGiB/49T6I0WZFr4vBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=VD4tkT98; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="VD4tkT98"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783650614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wmjyTrBCl5yvQEGZhJICODiH2HMhqufUmCcyacGqgXo=;
	b=VD4tkT98ysqjqe6j7PIAgh8Iy9bMcDeobVAOMzBMxdOValuzqBdFLX7WE0WHEscsDTxxtV
	/Pg7crVpHpBUj7bBnmePHrioYnV2RNAuJ8AALSoC1GTXKerXndKBeuiizkFdtczC2elpi7
	GMToHkXfhevjW+iKEHiXwlW9sDNCgHOMEpkt8FkomDlL+U7LJMrD+s+Q0o8xUTyQZueVar
	O5buDhNJccb6/ddRz5jtZkj7F449J69IanjpbdTRS/I7Ue1dvPnhwTBQAu8TNsMii4xTkn
	+aOScisrv5lnHRDKjDkMvqS9ym1g7H8adjrKpac75Qx4ZcYxwJ4TFznA2ZOw8g==
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
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH xfstests] cifs/002: check nlink returned by fstat()
Date: Fri, 10 Jul 2026 02:29:47 +0000
Message-ID: <20260710022947.270115-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add a CIFS test based on generic/002 to verify that fstat(2)
returns the expected st_nlink value as hardlinks are created and
removed.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 src/Makefile       |   2 +-
 src/fstat.c        | 200 +++++++++++++++++++++++++++++++++++++++++++++
 tests/cifs/002     |  61 ++++++++++++++
 tests/cifs/002.out |   2 +
 4 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 src/fstat.c
 create mode 100755 tests/cifs/002
 create mode 100644 tests/cifs/002.out

diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..b0886279 100644
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
diff --git a/src/fstat.c b/src/fstat.c
new file mode 100644
index 00000000..59221186
--- /dev/null
+++ b/src/fstat.c
@@ -0,0 +1,200 @@
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
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+
+long	timebuf;
+
+void
+timesince(long timesec)
+{
+	long	d_since;	/* days */
+	long	h_since;	/* hours */
+	long	m_since;	/* minutes */
+	long	s_since;	/* seconds */
+
+	s_since = timebuf - timesec;
+	d_since = s_since / 86400l ;
+	s_since -= d_since * 86400l ;
+	h_since = s_since / 3600l ;
+	s_since -= h_since * 3600l ;
+	m_since = s_since / 60l ;
+	s_since -= m_since * 60l ;
+
+	printf("(%05ld.%02ld:%02ld:%02ld)\n",
+			d_since, h_since, m_since, s_since);
+}
+
+void
+usage(void)
+{
+	fprintf(stderr, "Usage: fstat [-t] filename ...\n");
+	exit(1);
+}
+
+int
+main(int argc, char **argv)
+{
+	struct stat	sbuf;
+	int		i, c;
+	int		terse_flag = 0;
+
+	while ((c = getopt(argc, argv, "t")) != EOF) {
+		switch (c) {
+			case 't':
+				terse_flag = 1;
+				break;
+
+			case '?':
+				usage();
+		}
+	}
+	if (optind == argc) {
+		usage();
+	}
+
+	time(&timebuf);
+
+	for (i = optind; i < argc; i++) {
+		char mode[] = "----------";
+		int fd;
+
+		fd = open(argv[i], O_RDONLY | O_NONBLOCK);
+		if (fd < 0) {
+			perror(argv[i]);
+			continue;
+		}
+
+		if (fstat(fd, &sbuf) < 0) {
+			perror(argv[i]);
+			close(fd);
+			continue;
+		}
+
+		if (terse_flag) {
+			printf("%s %llu ", argv[i], (unsigned long long)sbuf.st_size);
+		}
+		else {
+			printf("  File: \"%s\"\n", argv[i]);
+			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
+		}
+
+		if (sbuf.st_mode & S_IXOTH)
+			mode[9] = 'x';
+		if (sbuf.st_mode & S_IWOTH)
+			mode[8] = 'w';
+		if (sbuf.st_mode & S_IROTH)
+			mode[7] = 'r';
+		if (sbuf.st_mode & S_IXGRP)
+			mode[6] = 'x';
+		if (sbuf.st_mode & S_IWGRP)
+			mode[5] = 'w';
+		if (sbuf.st_mode & S_IRGRP)
+			mode[4] = 'r';
+		if (sbuf.st_mode & S_IXUSR)
+			mode[3] = 'x';
+		if (sbuf.st_mode & S_IWUSR)
+			mode[2] = 'w';
+		if (sbuf.st_mode & S_IRUSR)
+			mode[1] = 'r';
+		if (sbuf.st_mode & S_ISVTX)
+			mode[9] = 't';
+		if (sbuf.st_mode & S_ISGID)
+			mode[6] = 's';
+		if (sbuf.st_mode & S_ISUID)
+			mode[3] = 's';
+
+		if (!terse_flag)
+			printf("   Filetype: ");
+		switch (sbuf.st_mode & S_IFMT) {
+		case S_IFSOCK:
+			if (!terse_flag)
+				puts("Socket");
+			mode[0] = 's';
+			break;
+		case S_IFDIR:
+			if (!terse_flag)
+				puts("Directory");
+			mode[0] = 'd';
+			break;
+		case S_IFCHR:
+			if (!terse_flag)
+				puts("Character Device");
+			mode[0] = 'c';
+			break;
+		case S_IFBLK:
+			if (!terse_flag)
+				puts("Block Device");
+			mode[0] = 'b';
+			break;
+		case S_IFREG:
+			if (!terse_flag)
+				puts("Regular File");
+			mode[0] = '-';
+			break;
+		case S_IFLNK:
+			if (!terse_flag)
+				puts("Symbolic Link");
+			mode[0] = 'l';
+			break;
+		case S_IFIFO:
+			if (!terse_flag)
+				puts("Fifo File");
+			mode[0] = 'f';
+			break;
+		default:
+			if (!terse_flag)
+				puts("Unknown");
+			mode[0] = '?';
+		}
+
+		if (terse_flag) {
+			printf("%s %d,%d\n", mode, (int)sbuf.st_uid, (int)sbuf.st_gid);
+			close(fd);
+			continue;
+		}
+
+		printf("  Mode: (%04o/%s)", (unsigned int)(sbuf.st_mode & 07777), mode);
+		printf("         Uid: (%d)", (int)sbuf.st_uid);
+		printf("  Gid: (%d)\n", (int)sbuf.st_gid);
+		printf("Device: %2d,%-2d", major(sbuf.st_dev),
+				minor(sbuf.st_dev));
+		printf("  Inode: %-9llu", (unsigned long long)sbuf.st_ino);
+		printf(" Links: %-5ld", (long)sbuf.st_nlink);
+
+		if ( ((sbuf.st_mode & S_IFMT) == S_IFCHR)
+		    || ((sbuf.st_mode & S_IFMT) == S_IFBLK) )
+			printf("     Device type: %2d,%-2d\n",
+				major(sbuf.st_rdev), minor(sbuf.st_rdev));
+		else
+			printf("\n");
+
+		printf("Access: %.24s",ctime(&sbuf.st_atime));
+		timesince(sbuf.st_atime);
+		printf("Modify: %.24s",ctime(&sbuf.st_mtime));
+		timesince(sbuf.st_mtime);
+		printf("Change: %.24s",ctime(&sbuf.st_ctime));
+		timesince(sbuf.st_ctime);
+
+		if (i+1 < argc)
+			printf("\n");
+
+		close(fd);
+	}
+	exit(0);
+}
diff --git a/tests/cifs/002 b/tests/cifs/002
new file mode 100755
index 00000000..905d5e93
--- /dev/null
+++ b/tests/cifs/002
@@ -0,0 +1,61 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
+# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
+#
+# FS QA Test No. cifs/002
+#
+# Check that fstat(2) returns the correct hard link count for a regular file.
+# Regression test for https://lore.kernel.org/linux-cifs/20260709025703.3715326-5-chenxiaosong@chenxiaosong.com/
+#
+#  from
+#  tests/generic/002
+#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
+#
+. ./common/preamble
+_begin_fstest metadata auto quick
+
+# Override the default cleanup function.
+_cleanup()
+{
+	rm -f $tmp.*
+	rm -rf $TEST_DIR/$$
+}
+
+status=0	# success is the default!
+
+_require_test
+_require_hardlinks
+_require_test_program fstat
+
+echo "Silence is goodness ..."
+
+testdir=$TEST_DIR/$$
+mkdir -p $testdir
+
+touch $testdir/tmp.1
+for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
+do
+	ln $testdir/tmp.1 $testdir/tmp.$l
+	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+	if [ "$l" -ne $x ]
+	then
+		echo "Arrgh, created link #$l and fstat looks like ..."
+		$here/src/fstat $testdir/tmp.1
+		status=1
+	fi
+done
+
+for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
+do
+	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+	if [ "$l" -ne $x ]
+	then
+		echo "Arrgh, about to remove link #$l and fstat looks like ..."
+		$here/src/fstat $testdir/tmp.1
+		status=1
+	fi
+	rm -f $testdir/tmp.$l
+done
+
+exit
diff --git a/tests/cifs/002.out b/tests/cifs/002.out
new file mode 100644
index 00000000..11426b54
--- /dev/null
+++ b/tests/cifs/002.out
@@ -0,0 +1,2 @@
+QA output created by 002
+Silence is goodness ...
-- 
2.43.0

