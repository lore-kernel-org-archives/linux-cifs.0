Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6890941A51D;
	Tue, 28 Jul 2026 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233631; cv=none; b=rJtmLI3f9ImXIOuu3ndz4OMIeOJ20/q66rpM6eceiEVO5FVQeepG/o/xza+AkSntrPYzaoz6/OQvSrWYExvS8gwErluU1+UfSDxs5vpv7duNggSrgXlbOK8DSD/hSlnqGxzMeD+JS8a5mgX5CW45DYEqTlfRhs0t1iWNZDTtQq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233631; c=relaxed/simple;
	bh=Gmz1sCybwuGLBz9x6XC7L/VXU2xHwNjBH4V5oWI3vD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aR4DGo/hfSEwddt70TRgzZ8x6QG2tNQcVkrDAv5NTdnxp3D1kqup69lf18vxKF1cJiLKW+yndYOLvYdcKpEvcNFkOU9ppasz1bDtprwKEF6HXp/FV1//ymPpWZ/V2DW3eehgm266fZikeB2TXcdCUH1C4kneMI2EKGRmePzzXl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlQKp2Qc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlQKp2Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA01F000E9;
	Tue, 28 Jul 2026 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785233630;
	bh=OIfv8wwaDgjxxjUc7vMj13LMyJ42jbVGbOuEFBkTun4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OlQKp2QcvPfSFdIxnspcGEpizoyMq8X2eanSLGi2r45L3pZgAULlXBqkjs1JL4DMd
	 ugFLqRLko3HSiNx5EIcYpaRgHQpaNojJYU7oBxKh+BKqIdNKtvKWGQr+ii661PVvOl
	 tyt/hanPoyZiy2K0/vyxFHMgz+XnB2L/hZJKRYoKHBvNTNfylc1vDV00WoRcMFlLTB
	 gOKjUrqPCIff9+WixrHTaVAJXlrd1PV+iSSsnNQRfVss+JUZa2R9jn2FAVus9J4Q2T
	 v10Iv1iReWKqeDNwv4C0G8e6jvd9248AFvwVPMusnVBzDmcGUPtifF4L9A2q8RI1ko
	 UbP6Zb73ycUsQ==
Date: Tue, 28 Jul 2026 18:13:40 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v3 xfstests 1/2] generic/002: simplify the hardlink count
 test
Message-ID: <amh85c25M9jOE_BW@zlang-mailbox>
Mail-Followup-To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	fstests@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260724031210.332153-1-chenxiaosong@chenxiaosong.com>
 <20260724031210.332153-2-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724031210.332153-2-chenxiaosong@chenxiaosong.com>

On Fri, Jul 24, 2026 at 03:12:09AM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Add the test to the hardlink group and replace the enumerated link
> counts with arithmetic loops.
> 
> Clean up the test header, use "Silence is golden" success message,
> and return the test status explicitly.
> 
> Suggested-by: Zorro Lang <zlang@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---

generic/002 is quite an old test case, and some of its code differs
from the current standard conventions in fstests. If you just want
to add it to the "hardlink" group, updating the group is sufficient.

However, if you'd like to take this opportunity to refactor some of
the code, besides your changes, you can refer to the review points
on [PATCH 2/2] as well as using _require_test_program "lstat64"

Thanks,
Zorro

>  tests/generic/002     | 16 ++++++----------
>  tests/generic/002.out |  2 +-
>  2 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/tests/generic/002 b/tests/generic/002
> index 6df57a7a..9b210705 100755
> --- a/tests/generic/002
> +++ b/tests/generic/002
> @@ -2,12 +2,12 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
>  #
> -# FS QA Test No. 002
> +# FS QA Test 002
>  #
>  # simple inode link count test for a regular file
>  #
>  . ./common/preamble
> -_begin_fstest metadata udf auto quick
> +_begin_fstest metadata udf auto quick hardlink
>  
>  # Import common functions.
>  . ./common/filter
> @@ -17,14 +17,11 @@ status=0	# success is the default!
>  _require_test
>  _require_hardlinks
>  
> -echo "Silence is goodness ..."
> -
>  # ensure target directory exists
>  mkdir `dirname $TEST_DIR/tmp` 2>/dev/null
>  
>  touch $TEST_DIR/tmp.1
> -for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
> -do
> +for ((l = 2; l <= 20; l++)); do
>      ln $TEST_DIR/tmp.1 $TEST_DIR/tmp.$l
>      x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
>      if [ "$l" -ne $x ]
> @@ -35,8 +32,7 @@ do
>      fi
>  done
>  
> -for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
> -do
> +for ((l = 20; l >= 1; l--)); do
>      x=`$here/src/lstat64 $TEST_DIR/tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
>      if [ "$l" -ne $x ]
>      then
> @@ -47,5 +43,5 @@ do
>      rm -f $TEST_DIR/tmp.$l
>  done
>  
> -# success, all done
> -exit
> +echo "Silence is golden"
> +exit $status
> diff --git a/tests/generic/002.out b/tests/generic/002.out
> index 11426b54..61705c7c 100644
> --- a/tests/generic/002.out
> +++ b/tests/generic/002.out
> @@ -1,2 +1,2 @@
>  QA output created by 002
> -Silence is goodness ...
> +Silence is golden
> -- 
> 2.43.0
> 
