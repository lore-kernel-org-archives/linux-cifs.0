Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA20377AA9;
	Mon,  3 Aug 2026 10:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785753622; cv=none; b=VZ9RuGlqleuThy3TnG2zk4zNtA/Xxid/WEHgLLJ7OLQwXkcZBLMitnIKXU6Z+cqi/fvNTGp6Nnv+Mto+bK6bBUg1UfhsBYG22uYqjg7OSNU4yPfqjnWA+Xw0U+kBfDB2yER9EVVBsuhpuyeHDqzfwEUiKmzmqCmtIyiV+zuCRKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785753622; c=relaxed/simple;
	bh=zCbKPtg397Gcku6x+EY0geamZd7ALjaIPsLhF3e8ODg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rmgf4OqpEGNDtruy6XTXFVmL2+U//hTN+ooRnD7/vB5jc/PDGCuZLZYZfkOnV7ZQIzOZx9WA/jodGBesQLtMtW3H6B6kdlsGwqnjag6g8CrEMHHqZPk2M8nkfpzIPni8RyattFag/KuYQjNvof9KgpAO7JN8GYuLzxzi5u+r3Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6ex2b2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6ex2b2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8034B1F000E9;
	Mon,  3 Aug 2026 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785753621;
	bh=t+9sJG0t1C8CJuS7iZCybuwSBXbJ5ylyezWqLaj/9I4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a6ex2b2SFVHsdgYqYyLi9PNoQewa/t99+jfiKAL53/IyOot8IM+2gKSQv79om3sTl
	 CYW1lTJcRdCuh01YxQ9rfee6FTL9KrqXp0BZRmpf6AZEZCeBVrgf9k/sMxNyz9prYa
	 buGLDYmdolB+RzrjMDVhqpkzqIrli2idei5hUi3qjk75geuQ6gj1m5SfomuZ8B5769
	 ja490t8HJyHjDMzYhOAeQ7WcM4Br7E1MTRDrFC81SAaLzn0uBeRBRVcbrK+Ux8mVjw
	 rROHqxs1IbBQCPKXcKEA3fDGfSNeI2asJLLAk9ow/9VHL8o5I74hycOLnbGIfsGBit
	 pW3k4XlEKHJwA==
Date: Mon, 3 Aug 2026 18:40:09 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, hch@infradead.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] generic: new test to check nlink returned by
 fstat()
Message-ID: <anBvmrwo6SvhVFuu@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, hch@infradead.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	Christoph Hellwig <hch@lst.de>, fstests <fstests@vger.kernel.org>
References: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
 <20260730021238.51634-3-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730021238.51634-3-chenxiaosong@chenxiaosong.com>

On Thu, Jul 30, 2026 at 02:12:38AM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Add a test to verify that fstat(2) returns the expected
> st_nlink value as hardlinks are created and removed.
> 
> Regression test for kernel commit:
> 9dd1964ac59d ("smb/client: fix incorrect nlink returned by fstat()")
> 
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---

This version is good to me now,

Reviewed-by: Zorro Lang <zlang@kernel.org>

(Please To/CC fstests@vger.kernel.org)

>  tests/generic/798     | 59 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/798.out |  2 ++
>  2 files changed, 61 insertions(+)
>  create mode 100755 tests/generic/798
>  create mode 100644 tests/generic/798.out
> 
> diff --git a/tests/generic/798 b/tests/generic/798
> new file mode 100755
> index 00000000..e48a69a1
> --- /dev/null
> +++ b/tests/generic/798
> @@ -0,0 +1,59 @@
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
> +	# This calls `fstat()`, see `stat_f()` in xfsprogs-dev.git io/stat.c:
> +	# https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/stat.c
> +	$XFS_IO_PROG -c 'stat -r' "$1" |
> +		sed -n 's/^stat\.nlink = //p'
> +}
> +
> +testdir=$TEST_DIR/$seq
> +rm -rf "$testdir"
> +mkdir "$testdir"
> +
> +touch "$testdir/tmp.1"
> +for ((l = 2; l <= 20; l++)); do
> +	ln "$testdir/tmp.1" "$testdir/tmp.$l"
> +	nlink=$(_get_nlink "$testdir/tmp.1")
> +	if [ "$nlink" != "$l" ]; then
> +		_fail "Expected nlink $l after creating link $testdir/tmp.$l, got ${nlink:-nothing}"
> +	fi
> +done
> +
> +for ((l = 20; l >= 1; l--)); do
> +	nlink=$(_get_nlink "$testdir/tmp.1")
> +	if [ "$nlink" != "$l" ]; then
> +		_fail "Expected nlink $l before removing link $testdir/tmp.$l, got ${nlink:-nothing}"
> +	fi
> +	rm -f "$testdir/tmp.$l"
> +done
> +
> +echo "Silence is golden"
> +_exit 0
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
