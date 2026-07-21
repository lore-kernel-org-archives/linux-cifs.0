Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0249A3B992F
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 08:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784622364; cv=none; b=DMGFnGqK72J6K8bCEGuAXvZfHZ+8TeSSHHTXYqXwmjC42UPadqJX1EN2kyKUxVS63TCKakmAJKObuZ0nmxuR6eccMmlSW3VkDczMxnlWjAeys/KqXUTPLLkjKySzsqRWcXDm4kNYnQFmekermIWWEMLW3ay7PkgFTNjoU/ZGGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784622364; c=relaxed/simple;
	bh=1fXxaCXAp9pcOO1TbrJrt4m2cSnU1UVe1pqixdu6kYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7lB5qtjMf54ZZjYvpgrHPAvMzIhGd5WeL4Jd7DSOJLJEGHAMKv1ei4hkDhqg/RKSFfRQZDxiMk37Xcw735Pii8jdoNT7HQR/kzKxoMDv4e9qEv21VNb7dTax/Qr7ts9cDsT95wqqDtdkaDSJc8wygFCCdreR132uudb8ldEMCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTnNUTM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTnNUTM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C998D1F000E9;
	Tue, 21 Jul 2026 08:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784622362;
	bh=odY24mpVB9Q87sUCRB0OgVqoReRHGitnV2AOXLpJ6RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GTnNUTM2h1Ccu97zAb32i3GxHr8d3q8ipPBghw1B2IHS88CjpypTKfcX9XXVIcc8D
	 /wXdGbjsw+dDEbnvGaX1rwfof3+MrRjbmle8EDyJiTZ2sVlJ1bvZtyPxsdmYvDevA1
	 iOuNwiQT9Gcdvo9Wdh+x/qn170Ud/A0gtWYIlp/LMKIfYxB+tHSIr2RCLCUB5VfCcP
	 1c+nh4bvwQblqrNVJQ3HN9nE+hfnQzoXfPgIPRF6JIGeWPapI7gl0fzb1+JhQMpzae
	 BLt3dGuzxThbXNP1jiRqQ1+cp6K6kKPC3oNAemIcqzQxH90uCAfhTaDltDYvs25KY6
	 +YAPqkX/JStYw==
Date: Tue, 21 Jul 2026 16:25:51 +0800
From: Zorro Lang <zlang@kernel.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v2 xfstests 0/3] add generic/795
Message-ID: <al8nX7MnPDzmUA5W@zlang-mailbox>
References: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720163502.732454-1-chenxiaosong@chenxiaosong.com>

On Mon, Jul 20, 2026 at 04:34:59PM +0000, ChenXiaoSong wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> v1->v2:
>   - Add patch#01 patch#02.
>   - Patch#03: some cleanups.
> 
> v1: https://lore.kernel.org/linux-cifs/20260713151658.533155-1-chenxiaosong@chenxiaosong.com/
> 
> ChenXiaoSong (3):
>   src: factor out common stat code
>   generic/002: clean up the test
>   generic/795: check nlink returned by fstat()
> 
>  src/Makefile          |  13 ++-
>  src/fstat.c           |  42 ++++++++++
>  src/lstat64.c         | 166 +------------------------------------
>  src/stat_common.c     | 185 ++++++++++++++++++++++++++++++++++++++++++
>  src/stat_common.h     |  16 ++++
>  tests/generic/002     |  16 ++--
>  tests/generic/002.out |   2 +-

Hi,

I might not have explained clearly during the review. I wasn't asking you to
rewrite g/002 and lstat64.c. I was suggesting checking whether src/fstat.c in
your previous patch could be replaced by the stat command in xfs_io [1]. Check
`man xfs_io` for the "stat" command to see if it can fulfill your test
requirement.

Due to I noticed you need information like st_nlink from struct stat, so
`xfs_io -c "stat -r" ...` should meet your requirements. Please
give it a try, if it works, it will make the whole patch much cleaner.

P.S. For a new test case, please don't use a specific case number (like
generic/795) in the subject or commit log, as it might get assigned a
different number when merged. You can just use something like:
"[PATCH] generic: new test to ..."

Thanks,
Zorro

[1]
  https://lore.kernel.org/fstests/a8771f15-7cb6-44a1-a592-8055818f57f1@chenxiaosong.com/T/#mff79f3e74e8cefbdda71e6a22f6a20f2dd985661
  "I'm wondering if a specific src/fstat.c is needed. Can we replace the whole
  src/fstat.c with `xfs_io -c stat ` ? Can you give it a try?"

>  tests/generic/795     |  60 ++++++++++++++
>  tests/generic/795.out |   2 +
>  9 files changed, 324 insertions(+), 178 deletions(-)
>  create mode 100644 src/fstat.c
>  create mode 100644 src/stat_common.c
>  create mode 100644 src/stat_common.h
>  create mode 100755 tests/generic/795
>  create mode 100644 tests/generic/795.out
> 
> -- 
> 2.43.0
> 
