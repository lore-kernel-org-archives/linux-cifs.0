Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B298314B6D;
	Tue, 28 Jul 2026 09:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232610; cv=none; b=UHvpeuewtC8t7Zowkc5tXX95ttQFc0qgExY/5+F1J7RFVy+MAUMW6SHXToHnnZdwdpoO56qAByuKINGz5SbATMRlW1WbDJN6jB4yPoWNc46SZi7sqEQRw5Xw5VFEA1vN1tDoMbgqsh/XeFiiFY9TSDYZuquEbYRHS9N1lJDAISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232610; c=relaxed/simple;
	bh=AHUtrpUIJOmQgr4jI2TmASrY7d1Vw0qw2F/d6RQglEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KHYXTexFrqNtLsU+RU7E8iNTHgcnn4BzXBrRechO/63/supo8bKTdtWk12k7FmSBi3HHLkk4bgmsYkNVYiQj4riKTvHFoESpaX1x3VIT9+XhfbIBXY0EQjdxVUcMmjP7mGmSb5ql/7O/BIrf9CDAyN8JUtvCcsck07ls8H3WT0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZfXonuDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZfXonuDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E466A1F000E9;
	Tue, 28 Jul 2026 09:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785232609;
	bh=G/U6PEVLKLInbJ+hfDHFac/AG6Vj9ZON00UB4jcXl68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZfXonuDPZDH2Fo92f1bPvtyLPvaGmqfd06lkeyRj7YUHDMxEqMB3uRvExpnmnE5KG
	 i9ZWlx+uuzr8xlnceLV00wAQ2jeMOhqi4muINNDDwT5Fc31Lv0MsqQw1ODDq92e+cI
	 hpEEcHEzRrlJqrKE9REHpz/WfO3mUmcO4QOGESp9PGyjkmNsYQx6Y9f7y0uBSsFrdV
	 hj0vdHxEPlQb8hnMunr/Dn7G9Ho7I/l/TO268IuIuQnB9dwm8j9qgAZmyahi9AEogl
	 PB5+bpscoLYhu6bMQXmXvzYUd2KjhIFnw7ZTqzSTl7G3WX2Ar1Z6JHIVeN8EocBrIQ
	 T4K07hIY3w9cw==
Date: Tue, 28 Jul 2026 17:56:39 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v3 xfstests 2/2] generic: new test to check nlink
 returned by fstat()
Message-ID: <amhXZgFrXgYkuOTb@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
 <20260724031210.332153-3-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724031210.332153-3-chenxiaosong@chenxiaosong.com>

On Fri, Jul 24, 2026 at 03:12:10AM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Add a test to verify that fstat(2) returns the expected
> st_nlink value as hardlinks are created and removed.
> 
> Regression test for kernel commit:
> 9dd1964ac59d ("smb/client: fix incorrect nlink returned by fstat()")
> 
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  tests/generic/798     | 60 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 62 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
> 
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..e44bb10a
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,60 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2026 KylinSoft Co., Ltd. All rights reserved.
> +# Author(s): ChenXiaoSong <chenxiaosong@kylinos.cn>
> +#
> +# FS QA Test 798
> +#
> +# Check that fstat(2) returns the correct hard link count for a regular file.
> +#
> +#  from
> +#  tests/generic/002
> +#  Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
> +#
> +. ./common/preamble
> +_begin_fstest metadata auto quick hardlink
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf "$tmp".* "$testdir"
> +}
> +
> +_require_test
> +_require_hardlinks
> +
> +_fixed_by_fs_commit cifs 9dd1964ac59d \
> +	"smb/client: fix incorrect nlink returned by fstat()"
> +
> +_get_nlink()
> +{
> +	$XFS_IO_PROG -c 'stat -r' "$1" |
> +		sed -n 's/^stat\.nlink = //p'
> +}
> +
> +status=0

We set "status=1" in _begin_fstest. You can remove this line, and then ...

> +testdir=$TEST_DIR/$seq
> +rm -rf "$testdir"
> +mkdir "$testdir"
> +
> +touch "$testdir/tmp.1"
> +for ((l = 2; l <= 20; l++)); do
> +	ln "$testdir/tmp.1" "$testdir/tmp.$l"
> +	nlink=$(_get_nlink "$testdir/tmp.1")
> +	if [ "$nlink" != "$l" ]; then
> +		echo "Expected nlink $l after creating link $l, got ${nlink:-nothing}"
> +		status=1

... The current "echo" output is already sufficient to break the golden image
and cause the test to fail, so set "status=1" isn't necessary. Alternatively,
if you feel there's no need to continue the rest of the loop once a failure is
detected, you can use "_fail" to replace "echo" instead.

> +	fi
> +done
> +
> +for ((l = 20; l >= 1; l--)); do
> +	nlink=$(_get_nlink "$testdir/tmp.1")
> +	if [ "$nlink" != "$l" ]; then
> +		echo "Expected nlink $l before removing link $l, got ${nlink:-nothing}"
> +		status=1

Same here

> +	fi
> +	rm -f "$testdir/tmp.$l"
> +done
> +
> +echo "Silence is golden"
> +exit $status

then you can write "_exit 0" at here.

Thanks,
Zorro

> diff --git a/tests/generic/798.out b/tests/generic/798.out
> new file mode 100644
> index 00000000..216d6e93
> --- /dev/null
> +++ b/tests/generic/798.out
> @@ -0,0 +1,2 @@
> +QA output created by 798
> +Silence is golden
> -- 
> 2.43.0
> 
