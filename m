Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0764219E7
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784565777; cv=none; b=QVj0dueY+BQ/zL88nVLrrBiine/TZz87PYCX8R1iX2Zf1VYAm/kQZeZSToT9Rn88zKYMvbxyZ91UmWxvN14s+HreRf7hJkTq/llszE2y8rWweimonvrHsFhEa263Iy9K2nD9C3H31+xxC/xzcnW3F9YW8QBvi5bMjvxAdBfP/1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784565777; c=relaxed/simple;
	bh=ciPPbPKE0mRpCYJkEb/WPs5qkh0KLoAPbQmYoWRKuB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA0cFOJZUwiS80M3SoNifatNBSVGgJ1pR3v9cpE607BQwWA8G3bXJFnyVVNL8r1+bGzLXaP1NuftPP9S66yC1fqIU6bhlzmTQhFEee4naERaHCrp7XXjmhnyH3K2f/jemx07Qt8P3GjoWGHDX45XY/Tj7S1lhpivwG4N+L0nr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=uZ4SNdPU; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="uZ4SNdPU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784565772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4GiM34S0/5ce+IThjNM84F0NVFwQtnEMpxztHoz/WQ=;
	b=uZ4SNdPUp7sKzaV2eFoGa9CYqH7FZTbCOZeo1X5cUlxN4D5MpL+rzL4k8OCSDIdeunaAXB
	LgV5kvAyiBlyRAmOIqeAyihaeEQBuhDpAjaya+uRKGY2cRUe7VOtSGcW8+NTKLvFMAkO7l
	0Zg1+nVARvPTDIqoh7tI27UUZ2oaPx6TJhvV4/sw96Mnb7XAw9URfTR6wSxzaF67HC4HVj
	Cyba/YpTELp0/hPeEN5F8tcGzq/m4NMXRzFINZ9pMEEcqgiXMO5cCy+Qm9wjJvIdwl8JM7
	oAjDNnaqKI97H6LmimgPtt1UVh0/hSfvrKGEaRdtlDDHySLLpCn9PmIUkIiuNw==
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
Subject: [PATCH v2 xfstests resend 1/3] src: factor out common stat code
Date: Mon, 20 Jul 2026 16:42:05 +0000
Message-ID: <20260720164207.732522-2-chenxiaosong@chenxiaosong.com>
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

