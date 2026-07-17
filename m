Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AEA2F7EE4;
	Fri, 17 Jul 2026 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308047; cv=none; b=Mhpymj5uNNQNmlk2YgkmGqPvMplB3WNLmnTGX/JfGJgHMufOcZ2VxR9oPiE3EmqgFi1GrPhPT+CsiDPCSDAQWBobj7ENBEahNhGMb9OMs2NtVF8TOU2Zw7vetOf67Kxv1tkjHHDw4S64dyzj+DSHZQRmisRpwdOHWayQYEJu/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308047; c=relaxed/simple;
	bh=Wu+JpUGRFw7HP9AxNPYhFV2sOyHaEaizqjbgmO8sgNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ji4hjGDoSzsATq+q2IP3P91yKNai5jwUmFzvK/f5Sq7+Ljf2qKG4zRdCoozICcoTKtaCJytm1X7jpky5s9Pg70vcpJO2qXtBzDjF6oZrSCqH4LRW2PBcmCHU9iHYKXc6kwakc4/j1z89kUiCynDJslroRWDC+30W6Kb0xWxzz+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfsPQHoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfsPQHoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E450A1F000E9;
	Fri, 17 Jul 2026 17:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308045;
	bh=u0jF6T41xpxyX4x8blcJk0Gzn4FE+fcbJtNVG1i+4xE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UfsPQHoAdUavdR1fqELDMtcel60jEX2KMlb2iLNbAniODsOvSgjBN5NE90tkTE1PX
	 RrJgK7OKaBc8z76cdOSOpA7HUmnr6Gthc7BHeoM3A19+g1Sb5HYts+Eu8vLkEHYZVq
	 MMPpD4v/2srejnOt9GsPTwXQxoV1fRmea5jmaBuL8kKLaRv9lQANew06cZwbMeznnr
	 qIr4IJeisw46mUpTZCskA1wcj3jzzvaimtppj9+t2raeeKcGWfVd7uo5e4kbfaOfOL
	 ys8PGzbXgacZXKowFIQygkJzr992gBXp6ZLqSRiP0Tp4V8mYyeAl9DRY9qVuAAKj/m
	 +m0ge/Q9OjXcQ==
Date: Sat, 18 Jul 2026 01:07:13 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: lukas@herbolt.com, smfrench@gmail.com, linkinjeon@kernel.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH] cifs/002: check nlink returned by fstat()
Message-ID: <alpZg9nrDzS3T9cL@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	lukas@herbolt.com, smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260713151658.533155-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713151658.533155-1-chenxiaosong@chenxiaosong.com>

On Mon, Jul 13, 2026 at 03:16:58PM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Add a CIFS test to verify that fstat(2) returns the expected
> st_nlink value as hardlinks are created and removed.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---

Wow, a new CIFS test case :)

>  src/Makefile       |   2 +-
>  src/fstat.c        | 200 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/cifs/002     |  62 ++++++++++++++
>  tests/cifs/002.out |   2 +
>  4 files changed, 265 insertions(+), 1 deletion(-)
>  create mode 100644 src/fstat.c
>  create mode 100755 tests/cifs/002
>  create mode 100644 tests/cifs/002.out
> 
> diff --git a/src/Makefile b/src/Makefile
> index 31ac43b2..b0886279 100644
> --- a/src/Makefile
> +++ b/src/Makefile
> @@ -6,7 +6,7 @@
>  TOPDIR = ..
>  include $(TOPDIR)/include/builddefs
>  
> -TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
> +TARGETS = dirstress fill fill2 getpagesize holes lstat64 fstat \
>  	nametest permname randholes runas truncfile usemem \
>  	mmapcat append_reader append_writer dirperf metaperf \
>  	devzero feature alloc fault fstest t_access_root \
> diff --git a/src/fstat.c b/src/fstat.c
> new file mode 100644
> index 00000000..59221186
> --- /dev/null
> +++ b/src/fstat.c
> @@ -0,0 +1,200 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
> + * Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
> + *
> + *  from
> + *  src/lstat64.c
> + *  Copyright (c) 2000-2002 Silicon Graphics, Inc.
> + *  All Rights Reserved.
> + */
> +
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <time.h>
> +#include <sys/stat.h>
> +#include <sys/sysmacros.h>
> +
> +long	timebuf;
> +
> +void
> +timesince(long timesec)
> +{
> +	long	d_since;	/* days */
> +	long	h_since;	/* hours */
> +	long	m_since;	/* minutes */
> +	long	s_since;	/* seconds */
> +
> +	s_since = timebuf - timesec;
> +	d_since = s_since / 86400l ;
> +	s_since -= d_since * 86400l ;
> +	h_since = s_since / 3600l ;
> +	s_since -= h_since * 3600l ;
> +	m_since = s_since / 60l ;
> +	s_since -= m_since * 60l ;
> +
> +	printf("(%05ld.%02ld:%02ld:%02ld)\n",
> +			d_since, h_since, m_since, s_since);
> +}
> +
> +void
> +usage(void)
> +{
> +	fprintf(stderr, "Usage: fstat [-t] filename ...\n");
> +	exit(1);
> +}
> +
> +int
> +main(int argc, char **argv)
> +{
> +	struct stat	sbuf;
> +	int		i, c;
> +	int		terse_flag = 0;
> +
> +	while ((c = getopt(argc, argv, "t")) != EOF) {
> +		switch (c) {
> +			case 't':
> +				terse_flag = 1;
> +				break;
> +
> +			case '?':
> +				usage();
> +		}
> +	}
> +	if (optind == argc) {
> +		usage();
> +	}
> +
> +	time(&timebuf);
> +
> +	for (i = optind; i < argc; i++) {
> +		char mode[] = "----------";
> +		int fd;
> +
> +		fd = open(argv[i], O_RDONLY | O_NONBLOCK);
> +		if (fd < 0) {
> +			perror(argv[i]);
> +			continue;
> +		}
> +
> +		if (fstat(fd, &sbuf) < 0) {
> +			perror(argv[i]);
> +			close(fd);
> +			continue;
> +		}
> +
> +		if (terse_flag) {
> +			printf("%s %llu ", argv[i], (unsigned long long)sbuf.st_size);
> +		}
> +		else {
> +			printf("  File: \"%s\"\n", argv[i]);
> +			printf("  Size: %-10llu", (unsigned long long)sbuf.st_size);
> +		}
> +
> +		if (sbuf.st_mode & S_IXOTH)
> +			mode[9] = 'x';
> +		if (sbuf.st_mode & S_IWOTH)
> +			mode[8] = 'w';
> +		if (sbuf.st_mode & S_IROTH)
> +			mode[7] = 'r';
> +		if (sbuf.st_mode & S_IXGRP)
> +			mode[6] = 'x';
> +		if (sbuf.st_mode & S_IWGRP)
> +			mode[5] = 'w';
> +		if (sbuf.st_mode & S_IRGRP)
> +			mode[4] = 'r';
> +		if (sbuf.st_mode & S_IXUSR)
> +			mode[3] = 'x';
> +		if (sbuf.st_mode & S_IWUSR)
> +			mode[2] = 'w';
> +		if (sbuf.st_mode & S_IRUSR)
> +			mode[1] = 'r';
> +		if (sbuf.st_mode & S_ISVTX)
> +			mode[9] = 't';
> +		if (sbuf.st_mode & S_ISGID)
> +			mode[6] = 's';
> +		if (sbuf.st_mode & S_ISUID)
> +			mode[3] = 's';
> +
> +		if (!terse_flag)
> +			printf("   Filetype: ");
> +		switch (sbuf.st_mode & S_IFMT) {
> +		case S_IFSOCK:
> +			if (!terse_flag)
> +				puts("Socket");
> +			mode[0] = 's';
> +			break;
> +		case S_IFDIR:
> +			if (!terse_flag)
> +				puts("Directory");
> +			mode[0] = 'd';
> +			break;
> +		case S_IFCHR:
> +			if (!terse_flag)
> +				puts("Character Device");
> +			mode[0] = 'c';
> +			break;
> +		case S_IFBLK:
> +			if (!terse_flag)
> +				puts("Block Device");
> +			mode[0] = 'b';
> +			break;
> +		case S_IFREG:
> +			if (!terse_flag)
> +				puts("Regular File");
> +			mode[0] = '-';
> +			break;
> +		case S_IFLNK:
> +			if (!terse_flag)
> +				puts("Symbolic Link");
> +			mode[0] = 'l';
> +			break;
> +		case S_IFIFO:
> +			if (!terse_flag)
> +				puts("Fifo File");
> +			mode[0] = 'f';
> +			break;
> +		default:
> +			if (!terse_flag)
> +				puts("Unknown");
> +			mode[0] = '?';
> +		}
> +
> +		if (terse_flag) {
> +			printf("%s %d,%d\n", mode, (int)sbuf.st_uid, (int)sbuf.st_gid);
> +			close(fd);
> +			continue;
> +		}
> +
> +		printf("  Mode: (%04o/%s)", (unsigned int)(sbuf.st_mode & 07777), mode);
> +		printf("         Uid: (%d)", (int)sbuf.st_uid);
> +		printf("  Gid: (%d)\n", (int)sbuf.st_gid);
> +		printf("Device: %2d,%-2d", major(sbuf.st_dev),
> +				minor(sbuf.st_dev));
> +		printf("  Inode: %-9llu", (unsigned long long)sbuf.st_ino);
> +		printf(" Links: %-5ld", (long)sbuf.st_nlink);
> +
> +		if ( ((sbuf.st_mode & S_IFMT) == S_IFCHR)
> +		    || ((sbuf.st_mode & S_IFMT) == S_IFBLK) )
> +			printf("     Device type: %2d,%-2d\n",
> +				major(sbuf.st_rdev), minor(sbuf.st_rdev));
> +		else
> +			printf("\n");
> +
> +		printf("Access: %.24s",ctime(&sbuf.st_atime));
> +		timesince(sbuf.st_atime);
> +		printf("Modify: %.24s",ctime(&sbuf.st_mtime));
> +		timesince(sbuf.st_mtime);
> +		printf("Change: %.24s",ctime(&sbuf.st_ctime));
> +		timesince(sbuf.st_ctime);
> +
> +		if (i+1 < argc)
> +			printf("\n");
> +
> +		close(fd);
> +	}
> +	exit(0);
> +}
> diff --git a/tests/cifs/002 b/tests/cifs/002
> new file mode 100755
> index 00000000..5f1eaffc
> --- /dev/null
> +++ b/tests/cifs/002
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
> +# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
> +#
> +# FS QA Test No. cifs/002

Although we are considering removing this specific line in the future, it is
currently still required to follow the standard format. Therefore, it should
be formatted as: FS QA Test 002

> +#
> +# Check that fstat(2) returns the correct hard link count for a regular file.
> +# Regression test for kernel commit:
> +# 9dd1964ac59d ("smb/client: fix incorrect nlink returned by fstat()")
> +#
> +#  from
> +#  tests/generic/002

The original test case is a generic test case, this one looks similar, doesn't
has any cifs specific test steps. So I think this can be a generic test case too

> +#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +. ./common/preamble
> +_begin_fstest metadata auto quick

I think it also belong to "hardlink" group.

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	rm -f $tmp.*
> +	rm -rf $TEST_DIR/$$

        cd /
        rm -r -f $tmp.*
        [ -d "$testdir" ] && rm -rf $testdir

> +}
> +
> +status=0	# success is the default!
> +
> +_require_test
> +_require_hardlinks
> +_require_test_program fstat

_fixed_by_fs_commit cifs 9dd1964ac59d \
	"smb/client: fix incorrect nlink returned by fstat()"

> +
> +echo "Silence is goodness ..."

If no specical reason, please keep the "Silence is golden".

> +
> +testdir=$TEST_DIR/$$
> +mkdir -p $testdir
> +
> +touch $testdir/tmp.1
> +for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
> +do

for l in $(seq 2 20);do

or

for ((l=2; l<=20; l++))

> +	ln $testdir/tmp.1 $testdir/tmp.$l
> +	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`

I'm wondering if a specific src/fstat.c is needed. Can we replace the whole
src/fstat.c with `xfs_io -c stat ` ? Can you give it a try?

> +	if [ "$l" -ne $x ]
> +	then

if [ "$l" -ne $x ];then

> +		echo "Arrgh, created link #$l and fstat looks like ..."
> +		$here/src/fstat $testdir/tmp.1
> +		status=1
> +	fi
> +done
> +
> +for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
> +do

for l in $(seq 20 -1 1);do

or

for ((l=20; l>=1; l--))

> +	x=`$here/src/fstat $testdir/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
> +	if [ "$l" -ne $x ]
> +	then
> +		echo "Arrgh, about to remove link #$l and fstat looks like ..."
> +		$here/src/fstat $testdir/tmp.1
> +		status=1
> +	fi
> +	rm -f $testdir/tmp.$l
> +done
> +
> +exit

_exit 0

Thanks,
Zorro

> diff --git a/tests/cifs/002.out b/tests/cifs/002.out
> new file mode 100644
> index 00000000..11426b54
> --- /dev/null
> +++ b/tests/cifs/002.out
> @@ -0,0 +1,2 @@
> +QA output created by 002
> +Silence is goodness ...
> -- 
> 2.43.0
> 
> 
