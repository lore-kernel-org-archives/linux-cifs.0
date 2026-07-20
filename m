Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37996406270
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565378; cv=none; b=ert+GxT2jaezbGQi9JjMKn0KcdAXiAeUNHnr0qE7eog+Ec2fmrya5aJTN8H+pAVCA62eP37Rk89Oj9GbKMSjHRlznaWrnT27JHMn2la8o5+/WPiv4brcyU7+lzNLwWQNScMf4BVQ2SPE+xZyuWSkeR9RGolWnHvhsRqzvbA51hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565378; c=relaxed/simple;
	bh=ciPPbPKE0mRpCYJkEb/WPs5qkh0KLoAPbQmYoWRKuB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk6sSANmDFIF9G7N00QQPupzsu4lkAHw/f8B8UD7AVN7xY31YhN5Bbf+NOpgPOq90rzzdNqv8Lj2vhM3X1ckwthhJ2vqQgOL4LbXF+HVHEKXKgBrs4JiM59DZ0K2LCX90SXEEfLdb5DUbqIB7Q/Icvmh8wt3d3TKY82FMkhxfYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=TsesCER0; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="TsesCER0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784565372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4GiM34S0/5ce+IThjNM84F0NVFwQtnEMpxztHoz/WQ=;
	b=TsesCER07frAJ955aDOGKtYJSAc9i7Aht4weLL1xOK9Qau9tyNoGVySED3ATHIPaPN0k3q
	rmsOTsgwALqvjY0wrscpRbwTC7xfUw8mSHbxblyYfQeR7H3/yTxnLEBjI6cs36/wRZilnk
	avpFs8bf2YHHnAjnS8IFVEkfNSrO8CyBgL8VlJ5/e2cfb1e0dhzohR9gvqBfd/l3zPNEOG
	/q9/KXbn8zG6ySgfNcfukqEzY+g+kzBp91gIHqKACQhkR7GSqlgWkgoVLuRZC/pYAha8vF
	jqqP1889h1qLRkwbR4aI8F4FPmzG+5a7wZFzlbWj0iZMYsEJGAB+8iH5xxkQ3g==
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
Subject: [PATCH v2 xfstests 1/3] src: factor out common stat code
Date: Mon, 20 Jul 2026 16:35:00 +0000
Message-ID: <20260720163502.732454-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

To see only the differences in the code copied from lstat64.c to
stat_common.c, run:

  git show --find-copies --diff-filter=C <commit-id>

Move command-line parsing and stat output formatting from lstat64 into
stat_common so the implementation can be shared by other stat helpers.

No functional change.

Suggested-by: Zorro Lang <zlang@kernel.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 src/Makefile      |  11 ++-
 src/lstat64.c     | 166 +----------------------------------------
 src/stat_common.c | 185 ++++++++++++++++++++++++++++++++++++++++++++++
 src/stat_common.h |  16 ++++
 4 files changed, 212 insertions(+), 166 deletions(-)
 create mode 100644 src/stat_common.c
 create mode 100644 src/stat_common.h

diff --git a/src/Makefile b/src/Makefile
index 31ac43b2..7fab5d05 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -115,7 +115,8 @@ ifeq ($(NEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE),yes)
 LCFLAGS += -DNEED_INTERNAL_XFS_IOC_EXCHANGE_RANGE
 endif
 
-CFILES = $(TARGETS:=.c)
+CFILES = $(TARGETS:=.c) stat_common.c
+HFILES = stat_common.h
 LDIRT = $(TARGETS) fssum
 
 
@@ -129,7 +130,13 @@ fssum: fssum.c md5.c
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) fssum.c md5.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
-$(TARGETS): $(LIBTEST)
+STAT_TARGETS = lstat64
+
+$(STAT_TARGETS): %: %.c stat_common.c stat_common.h $(LIBTEST)
+	@echo "    [CC]    $@"
+	$(Q)$(LTLINK) $@.c stat_common.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
+
+$(filter-out $(STAT_TARGETS),$(TARGETS)): $(LIBTEST)
 	@echo "    [CC]    $@"
 	$(Q)$(LTLINK) $@.c -o $@ $(CFLAGS) $(LDFLAGS) $(LDLIBS) $(LIBTEST)
 
diff --git a/src/lstat64.c b/src/lstat64.c
index db8726fd..5cca2347 100644
--- a/src/lstat64.c
+++ b/src/lstat64.c
@@ -12,172 +12,10 @@
 #include <sys/stat.h>
 #include <sys/sysmacros.h>
 
-long	timebuf;
-
-void
-timesince(long timesec)
-{
-	long	d_since;	/* days */
-	long	h_since;	/* hours */
-	long	m_since;	/* minutes */
-	long	s_since;	/* seconds */
-
-	s_since = timebuf - timesec;
-	d_since = s_since / 86400l ;
-	s_since -= d_since * 86400l ;
-	h_since = s_since / 3600l ;
-	s_since -= h_since * 3600l ;
-	m_since = s_since / 60l ;
-	s_since -= m_since * 60l ;
-
-	printf("(%05ld.%02ld:%02ld:%02ld)\n",
-			d_since, h_since, m_since, s_since);
-}
-
-void
-usage(void)
-{
-	fprintf(stderr, "Usage: lstat64 [-t] filename ...\n");
-	exit(1);
-}
+#include "stat_common.h"
 
 int
 main(int argc, char **argv)
 {
-	struct stat64	sbuf;
-	int		i, c;
-	int		terse_flag = 0;
-
-	while ((c = getopt(argc, argv, "t")) != EOF) {
-		switch (c) {
-			case 't':
-				terse_flag = 1;
-				break;
-
-			case '?':
-				usage();
-		}
-	}
-	if (optind == argc) {
-		usage();
-	}
-
-	time(&timebuf);
-
-	for (i = optind; i < argc; i++) {
-		char mode[] = "----------";
-
-		if( lstat64(argv[i], &sbuf) < 0) {
-			perror(argv[i]);
-			continue;
-		}
-
-		if (terse_flag) {
-			printf("%s %llu ", argv[i], (unsigned long long)sbuf.st_size);
-		}
-		else {
-			printf("  File: \"%s\"\n", argv[i]);
-			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
-		}
-
-		if (sbuf.st_mode & S_IXOTH)
-			mode[9] = 'x';
-		if (sbuf.st_mode & S_IWOTH)
-			mode[8] = 'w';
-		if (sbuf.st_mode & S_IROTH)
-			mode[7] = 'r';
-		if (sbuf.st_mode & S_IXGRP)
-			mode[6] = 'x';
-		if (sbuf.st_mode & S_IWGRP)
-			mode[5] = 'w';
-		if (sbuf.st_mode & S_IRGRP)
-			mode[4] = 'r';
-		if (sbuf.st_mode & S_IXUSR)
-			mode[3] = 'x';
-		if (sbuf.st_mode & S_IWUSR)
-			mode[2] = 'w';
-		if (sbuf.st_mode & S_IRUSR)
-			mode[1] = 'r';
-		if (sbuf.st_mode & S_ISVTX)
-			mode[9] = 't';
-		if (sbuf.st_mode & S_ISGID)
-			mode[6] = 's';
-		if (sbuf.st_mode & S_ISUID)
-			mode[3] = 's';
-
-		if (!terse_flag)
-			printf("   Filetype: ");
-		switch (sbuf.st_mode & S_IFMT) {
-		case S_IFSOCK:	
-			if (!terse_flag)
-				puts("Socket");
-			mode[0] = 's';
-			break;
-		case S_IFDIR:	
-			if (!terse_flag)
-				puts("Directory");
-			mode[0] = 'd';
-			break;
-		case S_IFCHR:	
-			if (!terse_flag)
-				puts("Character Device");
-			mode[0] = 'c';
-			break;
-		case S_IFBLK:	
-			if (!terse_flag)
-				puts("Block Device");
-			mode[0] = 'b';
-			break;
-		case S_IFREG:	
-			if (!terse_flag)
-				puts("Regular File");
-			mode[0] = '-';
-			break;
-		case S_IFLNK:	
-			if (!terse_flag)
-				puts("Symbolic Link");
-			mode[0] = 'l';
-			break;
-		case S_IFIFO:	
-			if (!terse_flag)
-				puts("Fifo File");
-			mode[0] = 'f';
-			break;
-		default:	
-			if (!terse_flag)
-				puts("Unknown");
-			mode[0] = '?';
-		}
-
-		if (terse_flag) {
-			printf("%s %d,%d\n", mode, (int)sbuf.st_uid, (int)sbuf.st_gid);
-			continue;
-		}
-
-		printf("  Mode: (%04o/%s)", (unsigned int)(sbuf.st_mode & 07777), mode);
-		printf("         Uid: (%d)", (int)sbuf.st_uid);
-		printf("  Gid: (%d)\n", (int)sbuf.st_gid);
-		printf("Device: %2d,%-2d", major(sbuf.st_dev),
-				minor(sbuf.st_dev));
-		printf("  Inode: %-9llu", (unsigned long long)sbuf.st_ino);
-		printf(" Links: %-5ld", (long)sbuf.st_nlink);
-
-		if ( ((sbuf.st_mode & S_IFMT) == S_IFCHR)
-		    || ((sbuf.st_mode & S_IFMT) == S_IFBLK) )
-			printf("     Device type: %2d,%-2d\n",
-				major(sbuf.st_rdev), minor(sbuf.st_rdev));
-		else
-			printf("\n");
-
-		printf("Access: %.24s",ctime(&sbuf.st_atime));
-		timesince(sbuf.st_atime);
-		printf("Modify: %.24s",ctime(&sbuf.st_mtime));
-		timesince(sbuf.st_mtime);
-		printf("Change: %.24s",ctime(&sbuf.st_ctime));
-		timesince(sbuf.st_ctime);
-
-		if (i+1 < argc)
-			printf("\n");
-	}
-	exit(0);
+	return handle_stat(argc, argv, "lstat64", lstat64);
 }
diff --git a/src/stat_common.c b/src/stat_common.c
new file mode 100644
index 00000000..e94114ff
--- /dev/null
+++ b/src/stat_common.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+ 
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+
+#include "stat_common.h"
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
+usage(const char *program)
+{
+	fprintf(stderr, "Usage: %s [-t] filename ...\n", program);
+	exit(1);
+}
+
+int
+handle_stat(int argc, char **argv, const char *program, get_stat_fn get_stat)
+{
+	struct stat64	sbuf;
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
+				usage(program);
+		}
+	}
+	if (optind == argc) {
+		usage(program);
+	}
+
+	time(&timebuf);
+
+	for (i = optind; i < argc; i++) {
+		char mode[] = "----------";
+
+		if(get_stat(argv[i], &sbuf) < 0) {
+			perror(argv[i]);
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
+	}
+	exit(0);
+}
diff --git a/src/stat_common.h b/src/stat_common.h
new file mode 100644
index 00000000..290643d7
--- /dev/null
+++ b/src/stat_common.h
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2002 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef STAT_COMMON_H
+#define STAT_COMMON_H
+
+#include <sys/stat.h>
+
+typedef int (*get_stat_fn)(const char *path, struct stat64 *sbuf);
+
+int handle_stat(int argc, char **argv, const char *program, get_stat_fn get_stat);
+
+#endif /* STAT_COMMON_H */
-- 
2.43.0

