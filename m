Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630F32DCC0D
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 07:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748763698; cv=none; b=FR/XaCcHh/XH15tCBGHFLwlP1po0/7CmLelgJZ6wGMrzS5yDAVhmj+ouZDnaTrP/ad27DLcEx52W8zKNBpJk3kLuXtq8+C92QJzSEbZjD73/on7k8GrOfQjrp0lEqFQsG1IYx8TKkMIcU3HF3TogYdwAwUTi/RuhA14wxNblAP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748763698; c=relaxed/simple;
	bh=7ZVYcv7HRB2JP+iDfZrYOsxhY/4ROy3O6J/9mzautgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4CBQCSXvrUiet3wbuGBG9QLBdSIEkOx55P7qqz6OVk9Ea3GBFKTrT0DYh5YDjut2XfZDuDMdRO2i+LjgUz5cErn2x2bwt1qjMzRFOeyFWFsABujNZu/e8cycfhT8jNZBBnXBfCMx+chyZeWZ932ghFrOLGeee2E0H14pz/hP7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRd9Fxkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRd9Fxkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84301C4CEE7;
	Sun,  1 Jun 2025 07:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748763697;
	bh=7ZVYcv7HRB2JP+iDfZrYOsxhY/4ROy3O6J/9mzautgY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRd9FxkbbG5zPovyF2TJIRwAtIlc0pybqhz9wjorOMQ+dABg7zuICzLV/8u5bYtTm
	 G3+yoISWvG5WoXc4Ib3gp7YF45+8Bs1rXvcJCLCe8IwhT0zySll3X97qte6qjpwXQG
	 /4hgTA5kG31q4mvMVARC5KHj54j6i9cU3oBv3Dr0=
Date: Sun, 1 Jun 2025 09:41:35 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
Message-ID: <2025060107-anatomist-squander-d073@gregkh>
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <088096eba2d038bce2f73e6519d11ce9@manguebit.com>

On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
> Steve French <smfrench@gmail.com> writes:
> 
> > It is interesting that almost 700 kernel modules define
> > MODULE_VERSION() for their module, but only 4 filesystems (including
> > cifs.ko).  I find it useful mainly for seeing which fixes are in
> > (since some distros do 'full backports' so easier to look at the
> > module version sometimes to see what fixes are likely in the module
> > when someone reports a problem).   I am curious why few fs use it
> > though since it is apparently very widely used for other module types.
> 
> I find cifs.ko version quite useless, especially for distro and stable
> kernels which take fixes from newer versions while not backporting the
> commit that bumps cifs.ko version.  So relying on that version becomes
> pointless, IMO.

Yes, it is pointless, which is why it really should just be removed.
I'll do a sweep of the tree after -rc1 is out and start sending out
patches...

thanks,

greg k-h
