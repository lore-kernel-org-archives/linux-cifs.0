Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445BF1A2645;
	Thu, 10 Oct 2024 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728599944; cv=none; b=OvxWzNwcjjkHfmUb1y0UoxW0FTxb5sCyVQcuAsCLPTfy0+n4K2nE5S9ylhh0UKZ12KN0MJzI3Bd5JRZopH221JGIuRJKyc7zq4FQZp7TacbnxQKwgq9QG8hYDk76k6xmisYPTB8PuidUvSxhhutcZEnhUl4zpqYTNc945da51uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728599944; c=relaxed/simple;
	bh=0lQwxyIA8D2mA4EpLag19jMxk3mdwg6s+WRoI9RXPKo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c3wReDknpZNCyTLAFJ4IxwL4Cs6pfgDcl4f9hKHA5xzvqH1XTU1l1Ho5n/pRsE8hYKQ8Ow1fQqsaBALVz1Q02mWh6gYUJiRUaKveIO9uafu2z5eUCdUQZrTf0D03eaGQ04Pa/CV3UCZwgrjbIBryI8tHZxj28hCinK1Bkwcscws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=isGxSbk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="isGxSbk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D50C4CEC5;
	Thu, 10 Oct 2024 22:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728599943;
	bh=0lQwxyIA8D2mA4EpLag19jMxk3mdwg6s+WRoI9RXPKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=isGxSbk+ds8bH37giquW3qR0ymvkWfeBg/4es8mIiTERNZw4jOARThjbrKnXtf9j0
	 MczYwMeV8K3z+qC8YpoRImBl/fUQ1Q4AJbIW6ZD0JCWb7SmNHoeUdEfcaFrs6HKpBm
	 NYuloUxQgUKYDHnSA9r/IR4KvOHfEZZ+L6rl773Tpq0WXRhWF3EYr/iyttKiAKE34A
	 gAS8Min/zcQ9uTD8UaZRIhHDwiYLIM+h3KXSZry9QJElZihlGWevcTwZz1Aj+Ycy+I
	 +xaTKvIVPChQ1kq86b/KSW8WqReA2beou+5MT0B1RuD7GMd53Q+4GcVgNJj7uKtrOl
	 CfJOXrm8IK0oA==
Received: by pali.im (Postfix)
	id 7391181B; Fri, 11 Oct 2024 00:38:57 +0200 (CEST)
Date: Fri, 11 Oct 2024 00:38:57 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] cifs: Add mount option -o reparse=native
Message-ID: <20241010223857.vasehbu7nilemato@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241006100046.30772-2-pali@kernel.org>
 <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
 <20241007183650.aw3skuztljpgk2bs@pali>
 <CAH2r5mttO-aDq94QrLQm10xJRGLg=PULqX9fcfoykAweVVO+uQ@mail.gmail.com>
 <CAH2r5mvV7WzB62hWt4K6oF_xyrQH1EF75zc0JdfjsjFEV4SQKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mvV7WzB62hWt4K6oF_xyrQH1EF75zc0JdfjsjFEV4SQKQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Thursday 10 October 2024 17:21:59 Steve French wrote:
> On Thu, Oct 10, 2024 at 5:17 PM Steve French <smfrench@gmail.com> wrote:
> >
> >
> >
> > On Mon, Oct 7, 2024 at 1:36 PM Pali Rohár <pali@kernel.org> wrote:
> >>
> >> Currently choosing how new symlinks are created is quite complicated.
> >>
> >> Without these patch series, by default new symlinks are created via
> >> native reparse points, even when reparse=nfs or reparse=wsl is
> >> specified. There is no possibility to create a NFS-style or WSL-style
> >> symlink yet, and this patch series address this missing functionality.
> >> When option -o sfu is specified then all new symlinks are created in
> >> SFU-style, independently of -o reparse option. And when -o mfsymlinks is
> >> specified then all new symlinks are created in mf style, independently
> >> of -o reparse and -o sfu options.
> >>
> >> This patch series does not change -o sfu and -o mfsymlinks overrides, it
> >> just changes the way how -o reparse is handled.
> >>
> 
> I lean toward something similar, and more intuitive - do not have
> "reparse=" control symlink creation - but instead use another mount
> parm (e.g. "symlink=") for that.  It would be rarely used - only if
> you don't want the default (windows default format too) for server
> symlinks or "mfsymlinks" (for client only symlinks):
> 
> 1) "symlink=" if specified can be set to one of five formats (with the
> default being the windows format)
>   a) "mfsymlinks" (Mac style which is safer for many use cases since
> they are "client only" symlinks which the server will never use)
>      Setting "symlink=mfsymlinks" will have the same effect as just
> specifying "mfsymlinks" so won't break anything
>   b) "default" (or "windows") which uses the default symlink format
> when trying to create a new symlink
>   c) "nfs"
>   d) "wsl"
>   e) "sfu"
> 2) "reparse=" will still control how special files are created (char,
> block, fifo, socket) and can be set to:
>    a) "nfs" (default)
>    b) or "wsl"
>    c) If "sfu" set on mount will cause special files to be created
> with "sfu" format instead of using reparse points to create
> 3) reading reparse points will always be supported (unless you want to
> add a new parameter "reparse=none" to treat all reparse points as
> empty directories)
> 4) reading special files via the old "sfu" will only be supported if
> you mount with "sfu"
> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve

Ok, and how to handle creating new sockets? For me it makes sense to
create new sockets in "native" AF_UNIX style - compatible with Windows
WinAPI / WinSocks. Should be there also a new parameter?
