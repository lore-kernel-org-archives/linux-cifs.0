Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE9717BA3
	for <linux-cifs@vger.kernel.org>; Mon,  2 Jun 2025 05:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748842477; cv=none; b=lYuiFTAl6lCr1XtOrj8qQhCrZt+mAPtDOfEij+2dKZdhqD1OSxqq0ScPh0oSuXvKTqfwcJ3N2g7o3+Vscw7sC3sYuEanmt+TWy5fFKrwxSAFEbYohgaUWT1nl8Nzyoko/l1GZSHaY/ofmii8hTqUYu7b+shx0GCwxn9UOVTVHCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748842477; c=relaxed/simple;
	bh=k4vf1nw6PpnbJL+CVpHZQK0l5ZFYGh9YVcV27w6/MW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQ/0Irqa9zUtX31DMaMU5eXyTCT5t+nYp0FJn22ErL1WuDDKIXheYIzSfSQnaOciJpjlhA6OPaISjFcn4Y+nNQJjflyoOCSgREhr4z0dzZhsXKmJmHKCrmA8HdMdp2P6lo/cI03U5zpq2f9Imsg8o1zm3vyDtfuyXIMyTt/DQrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xrok0ZB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xrok0ZB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02154C4CEEB;
	Mon,  2 Jun 2025 05:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748842476;
	bh=k4vf1nw6PpnbJL+CVpHZQK0l5ZFYGh9YVcV27w6/MW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xrok0ZB+j4UZj3LP/uz9L/wqZHWbRAEAODdR03xo1lyEuPionx90T69fcRNEydUNI
	 Vb+6L6hMlgl/JepuSc8MofEmp+pqG0uQZqPEs9e6CM22pAsO5V0nEJSfKJtPmZYCtk
	 kn76zcWe4FVF9s06KWkNBbUDyQ6uoIeutGlhHEeI=
Date: Mon, 2 Jun 2025 07:34:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
Message-ID: <2025060254-unscathed-junior-1b43@gregkh>
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com>
 <2025060107-anatomist-squander-d073@gregkh>
 <CACRpkdZ0w85ecgtjbiypG8K37eBF9hk-7oqSq8E9K6_+SE+nUQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZ0w85ecgtjbiypG8K37eBF9hk-7oqSq8E9K6_+SE+nUQ@mail.gmail.com>

On Sun, Jun 01, 2025 at 08:54:10PM +0200, Linus Walleij wrote:
> On Sun, Jun 1, 2025 at 9:41 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
> > >  So relying on that version becomes
> > > pointless, IMO.
> >
> > Yes, it is pointless, which is why it really should just be removed.
> > I'll do a sweep of the tree after -rc1 is out and start sending out
> > patches...
> 
> In a way I'm happy with that result :D
> 
> But what do you think about the original problem of making
> the dir /sys/modules/foo appear for a compiled-in module?

It does that today, if the module has a parameter, right?  Maybe change
that to always do that even if there is no parameter present and see
what happens?

thanks,

greg k-h
