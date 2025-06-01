Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC5E2E628
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 19:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748807792; cv=none; b=Se4YZ4/BF2lpJ5Qqlf6GliMrv1TqiNob0sL7ycbeJKJBWPpw1HUKuLh8UO8XJL6ZfeNIC6+ADNDu3YgodSzeGoJgdril1W+0XmngqKUjOXZ8zPlF9Ok2f9OQMQfP0IsuumX4/FX6rkXZVabnmXPslx+EIUu6s/kqlpSsA5EDV74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748807792; c=relaxed/simple;
	bh=E+6VehpwvSlonuRm4aMIWtJxM0TjKr7cY307Hu5+Ros=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=l+GhcTxFPMkXdxuP5YpvhbXO/YNGtQDuSINU8Ip5EWYT0EL0WCzanwI6OwBbaDzlmXvWU+4xzDgsA/J9omajVtWltTOvo8LGJ2C57MeO/Zbkv1CFtnSc0d95VflItor7rVVXgYFkg+TwpLQtPIF7uyynkrvolqhkKr8MLjR9orU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=n4DV00Bx; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="n4DV00Bx"
Message-ID: <be8026cec8f645de3409433fe15e690a@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1748807782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r/PTBIDd36vlORJ1ZpAHSOO6klD7Kdq/UuuOsvWgmTE=;
	b=n4DV00BxJF4RfNgwxk+qPM+jcj/+tL7Lr15APb2bHizMPUAl7ib4sGRpJOW+7+4Ig+vtiB
	8JbCgg+4qSeJCf+4ymiMCnWV2y2mDnpTylsPrT4h4p3E7AqkK4yvBJLB3gubIrU5X0h9w5
	xgpOuFluOXkXfWPkCwZNtbo/yvedObxOuNQVNjLjlXJAsYLFnTPHHMCt/oY/xuwP3a1m+v
	yhEpHLFx+TPh2lnKem5Uu+DMv6lNDSff8XUzy9u+GJSEm+QNGKmHwJThmhkYTEjy2ctzQ7
	ou1pgiXQlpPlaZQFk39V9TfxinxI69eHRxT75rxhKRhlNGLHvMsnu8f5WMZMSg==
From: Paulo Alcantara <pc@manguebit.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steve French <smfrench@gmail.com>, Linus Walleij
 <linus.walleij@linaro.org>, Namjae Jeon <linkinjeon@kernel.org>, Sergey
 Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
In-Reply-To: <2025060107-anatomist-squander-d073@gregkh>
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com>
 <2025060107-anatomist-squander-d073@gregkh>
Date: Sun, 01 Jun 2025 16:56:07 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
>> Steve French <smfrench@gmail.com> writes:
>> 
>> > It is interesting that almost 700 kernel modules define
>> > MODULE_VERSION() for their module, but only 4 filesystems (including
>> > cifs.ko).  I find it useful mainly for seeing which fixes are in
>> > (since some distros do 'full backports' so easier to look at the
>> > module version sometimes to see what fixes are likely in the module
>> > when someone reports a problem).   I am curious why few fs use it
>> > though since it is apparently very widely used for other module types.
>> 
>> I find cifs.ko version quite useless, especially for distro and stable
>> kernels which take fixes from newer versions while not backporting the
>> commit that bumps cifs.ko version.  So relying on that version becomes
>> pointless, IMO.
>
> Yes, it is pointless, which is why it really should just be removed.
> I'll do a sweep of the tree after -rc1 is out and start sending out
> patches...

Sounds good.  Kernel version and git tree are just enough to figure out
what a filesystem or driver has in terms of features or fixes.
