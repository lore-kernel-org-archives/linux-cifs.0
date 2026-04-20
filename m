Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088B537EFF8
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776720256; cv=none; b=dTT+L4AjXsq35A6okq7FjHcrql8MY88K25W6MMBdE+px97eLqn+rTucmf96plZ3nK711hXfdUn0iQ1XOTH0fSsZMXRmjtkS3ZbdY39yHgwvTXVkny2dTnHsoFkdA7UhcBQK+j7W1/VQCypsO5edp/B5a/qshUgLl2k5pXiE6Yq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776720256; c=relaxed/simple;
	bh=cfZGeZ7aBcHxMo4XJe8v9HRyfwvKCXMx/aCJy19G1tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMK7yemX7Qypoc5Iig8Pc7SpK+qfwPFfN3gnYdh5Sbw2Z8IX2D8SqonYJYHE7J0rljNSit6kaS1IBJeFRG9TEjPt3fLA7VPzrL10D5mr++WI/PTMXKJtJ/4MZm7FLfmZTwxIrymbhGCXokrmrrm8LltV5M4ciMxN20XEORR9VU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3FnydJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3FnydJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF6CC19425;
	Mon, 20 Apr 2026 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776720255;
	bh=cfZGeZ7aBcHxMo4XJe8v9HRyfwvKCXMx/aCJy19G1tM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3FnydJqet3QokKCcfBi9/4ZTnMWnT56XzkuAQutyfuM8nkprtQw7YDlrEOUIpV/M
	 9jm0WSUGBNarRM/+mGFLFkoaswH2syDbgdNBW44g3pTnyxhkFCS83YhIvuazk6rMl0
	 Haq0Ii0Hq22pFVTzR35ozJ+lWiJn+I7+C3gG4oTJOr5iPwLi0mqZapNRq74tguL1wt
	 DtqmA3/bCl51LEsBtjUzPToSIb53XAArhkpdf1r905li701kMrQUyOKwFK6c9QWcML
	 vKy8AxJXPzPPC+mo+EQ/GI3M8fDMT8P9ScNGzLMyDZQJHsZxZihFoi6UduwmRKqyzA
	 Msso8EcxsXgCA==
Date: Mon, 20 Apr 2026 14:24:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH 7/8] smb: client: compress: add compress/common.h
Message-ID: <20260420212411.GA2260299@ax162>
References: <20260413190713.283939-1-ematsumiya@suse.de>
 <20260413190713.283939-7-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413190713.283939-7-ematsumiya@suse.de>

Hi Enzo,

On Mon, Apr 13, 2026 at 04:07:12PM -0300, Enzo Matsumiya wrote:
> Add compress/common.h to aggregate helpers and definitions that will be
> shared with other compression algorithms.
> 
> Also add a few build time checks for proper support.
> 
> Changes:
> - update affected call paths in compress/lz77.c
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
...
> diff --git a/fs/smb/client/compress/common.h b/fs/smb/client/compress/common.h
> new file mode 100644
> index 000000000000..b5ccf5debd22
> --- /dev/null
> +++ b/fs/smb/client/compress/common.h
...
> +/*
> + * Build time checks/asserts.
> + * These are assumptions/expectations for all algorithms implemented.
> + */
> +#ifndef __LITTLE_ENDIAN /* TODO */
> +# error "SMB3 compression is only supported on little endian architectures"
> +#endif /* !__LITTLE_ENDIAN */
> +
> +#if BITS_PER_LONG < 64 /* TODO */
> +# error "SMB3 compression is only supported on 64-bit architectures"
> +#endif /* BITS_PER_LONG < 64 */
> +
> +/* Build time double checks (probably unnecessary) */
> +static_assert(sizeof(u16) == 2);
> +static_assert(sizeof(u32) == 4);
> +static_assert(sizeof(u64) == 8);
> +static_assert(sizeof(size_t) == 8);

Steve pushed this change into -next as commit 20a248d5e77a ("smb:
client: compress: add compress/common.h"), where it breaks the build for
many 32-bit architectures for obvious reasons:

  $ make -skj"$(nproc)" ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- mrproper allmodconfig fs/smb/
  In file included from fs/smb/client/compress/lz77.c:14:
  fs/smb/client/compress/common.h:34:3: error: #error "SMB3 compression is only supported on 64-bit architectures"
     34 | # error "SMB3 compression is only supported on 64-bit architectures"
        |   ^~~~~
  In file included from include/linux/init.h:5,
                   from include/linux/printk.h:6,
                   from include/asm-generic/bug.h:31,
                   from arch/arm/include/asm/bug.h:60,
                   from include/linux/bug.h:5,
                   from include/linux/slab.h:15,
                   from fs/smb/client/compress/lz77.c:9:
  include/linux/build_bug.h:80:41: error: static assertion failed: "sizeof(size_t) == 8"
     80 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
        |                                         ^~~~~~~~~~~~~~
  include/linux/build_bug.h:79:34: note: in expansion of macro '__static_assert'
     79 | #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
        |                                  ^~~~~~~~~~~~~~~
  fs/smb/client/compress/common.h:41:1: note: in expansion of macro 'static_assert'
     41 | static_assert(sizeof(size_t) == 8);
        | ^~~~~~~~~~~~~

It is unacceptable for the build to break in this manner in my opinion.
You should really use Kconfig to gate this code in a proper manner and
not emit any errors or warnings when it is unsupported.

Cheers,
Nathan
