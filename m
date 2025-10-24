Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919E327453
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 05:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761282486; cv=none; b=VSyBCgr9Z8QaUja2Fjpw3Jm4VnXgTa8JeZ5YAIBVD+eA03rIGVD6wkl/mvJTECUfJYrqK74TofWkDOutmG7uPu3aC58IBss6uOTUVDd+G3Krsh5Gz+RqRNtuGnBB8dNgzNJyMAHTtgPQKyaC/xKZE5HQh9rTnZ6XacuQptlgQno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761282486; c=relaxed/simple;
	bh=eIJk14yf0ixEQNG5/MPY9A2l/FLeyJqXyUAOMoIZ1u0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBBIhuirBtVk9pNWoS6Vsqxkfeirfgfa0ah+C6vqnfuZUhOJY9TPbieg8dTmj7G9/Tqc1N3zuUK4yBgRJ/Gcxu6C9jsIHCoS5WVyczyaP326oxfhfN3IN6AMDxOcIIxnG35yVl7InBrbE1R9I59ZQrH1nLzJcg35QXRS+y++13c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMCKRlOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMCKRlOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA0FC4CEF1;
	Fri, 24 Oct 2025 05:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761282485;
	bh=eIJk14yf0ixEQNG5/MPY9A2l/FLeyJqXyUAOMoIZ1u0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zMCKRlOdduUb7bSyy/j4YhvcQ4DQtqVKh53lcdld+zaKy5pAQb5bO8atfC/BxJJU6
	 +i2biU6io3Ru/btoZ+laZWfttmHGq+VFmYay3HFc7812xfDwZ5I/b7sjCWx1CbQx8u
	 78o9HGgOkH25ZmfNyCZa5dSTyjzYki/gHtTHfs0k=
Date: Fri, 24 Oct 2025 07:08:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH v2] RFC: ksmbd: Create module_kobject if builtin
Message-ID: <2025102441-calculate-accustom-2023@gregkh>
References: <20251024-ksmbd-sysfs-module-v2-1-acba8159dbe5@linaro.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024-ksmbd-sysfs-module-v2-1-acba8159dbe5@linaro.org>

On Fri, Oct 24, 2025 at 12:49:44AM +0200, Linus Walleij wrote:
> Adding a call to lookup_or_create_module_kobject() to ksmbd
> makes /sys/modules/ksmbd appear even when ksmbd is compiled
> into the kernel.

Ick, no, please do not.  Otherwise you will see this pop up in all
drivers/modules for the same "reason".

> This is nice when you boot a custom kernel on OpenWrt because
> the startup script does things such as:
> 
> [ ! -e /sys/module/ksmbd ] && modprobe ksmbd 2> /dev/null
> if [ ! -e /sys/module/ksmbd ]; then
>     logger -p daemon.error -t 'ksmbd' "modprobe of ksmbd "
>     "module failed, can\'t start ksmbd!"
>      exit 1
> fi
> 
> which makes the script not work with a compiled-in ksmbd.

Please fix the start up script to not do this.  Don't work around broken
userspace by changing the kernel.

> Since I actually turn off modules and compile all my modules
> into the kernel, I can't change the script to just check
> cat /lib/modules/$(uname -r)/modules.builtin | grep ksmbd
> either: no /lib/modules directory.

Then do something else to determine if ksmbd is in the running kernel,
don't rely on a modules sysfs file like that.

> An option would be to change the script to proceed and
> just assume the module is compiled in but it feels wrong.

Agreed, surely there is some other way to "know" if that kernel feature
is present or not, right?  Mount a filesystem?  Something else?

> If this approach is acceptable I am happy to generalize this
> to something that any module that wants a /sys/modules/foo
> file can use to get just that.

No, please do not do that.  Just fix userspace.

thanks,

greg k-h
