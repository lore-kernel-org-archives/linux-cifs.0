Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BBC18EB0
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 06:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761287875; cv=none; b=ub8iEg+gqLqNxI2dySDDeC7IIxT5MXSQWL2tIbBsGQnv8qyYCSSHLLItKHtsE9mw8p/hVDZr6L/0ZaHZ5lkNdw7UTDtaPn6yEKg+GnSMReM5+fx5ddGY/0oRXPAITOH+hSqMYbZIlg8SUhpqUcwO2Ss0FclGqEwjAMluODFLQiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761287875; c=relaxed/simple;
	bh=8qk+32fVN3b3+8aKYtqQDu56XjPW0o49wNdBG5xKkd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p9xKsCROXpuBdIhnkmJwP3T5WAsLblIDr6zEU/VP/uRgEHkNVVFeVn31pyhU3I09XKLRQBUBOrWMxX3fM+DnD31h1oQVlb3XkZ7VYJmf17WCx/N3iDlqA2VCAoitMWwJE82IoYtk12+JQr9cdJNkYCAe5aK1g3Ej39GNSEfxLbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slxDDNWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slxDDNWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2949AC4CEF1;
	Fri, 24 Oct 2025 06:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761287874;
	bh=8qk+32fVN3b3+8aKYtqQDu56XjPW0o49wNdBG5xKkd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=slxDDNWl3jJi27pU5TrgztsHmoq/3rEJT5LKt9Tp+9nR9f6hmQzoOfWQsagMUC09/
	 O/wSlzRhjIN/NA/VBKowbn6BdA2JrE0rZTPGXHGCGK2HcGST9BWYOpw/nbdwA9LWiP
	 0NItFpxXWWxNBhQ+dF+7zd5F0J5NmXg0nq6sCLTY=
Date: Fri, 24 Oct 2025 08:37:49 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH v2] RFC: ksmbd: Create module_kobject if builtin
Message-ID: <2025102434-wasting-hurler-be60@gregkh>
References: <20251024-ksmbd-sysfs-module-v2-1-acba8159dbe5@linaro.org>
 <2025102441-calculate-accustom-2023@gregkh>
 <CACRpkdb7puCMh4VdhcwL1kkwEAsU0e6S=4ZvL-LoXav_Xvu6kg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb7puCMh4VdhcwL1kkwEAsU0e6S=4ZvL-LoXav_Xvu6kg@mail.gmail.com>

On Fri, Oct 24, 2025 at 08:05:29AM +0200, Linus Walleij wrote:
> On Fri, Oct 24, 2025 at 7:08 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > > Since I actually turn off modules and compile all my modules
> > > into the kernel, I can't change the script to just check
> > > cat /lib/modules/$(uname -r)/modules.builtin | grep ksmbd
> > > either: no /lib/modules directory.
> >
> > Then do something else to determine if ksmbd is in the running kernel,
> > don't rely on a modules sysfs file like that.
> 
> There really isn't a good way for a script to detect if a module is
> compiled-in that I know of.

That should be a per-feature type of thing.  Surely ksmbd has some sort
of user/kernel api that can be tested if it is present or not?

> You did suggest simply create this file also for compiled-in
> module, always:
> https://lore.kernel.org/all/2025060254-unscathed-junior-1b43@gregkh/
> 
> It just seemed a bit cluttery, but maybe the $subject approach
> is even more cluttery by creating special cases.

Yes, let's not special-case this, either make it so that every module
name shows up in sysfs (if it has a parameter or not), or keep it as-is.
Don't do module-specific hacks like you are proposing here.

thanks,

greg k-h
