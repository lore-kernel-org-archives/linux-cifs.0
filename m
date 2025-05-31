Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59AB413CA97
	for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748717414; cv=none; b=cfrOf5+wK1LSG7TYibfqjw9UWM+TAtxmIgB4inkJaBrUzODi04R+IkmJzO8i6S+ONRYOvPYC4WvSW8U0ma/Kcyp25DoRBhXddJG8qoHvEyN0QnvSXpYvS4f8smU+UCFfJZdELMDMYA4XfGrlyVCb1bWILVdthxEGzNPGUYUQ+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748717414; c=relaxed/simple;
	bh=LNNz6RQq+yJSJyrqGHYeHd4lIwOVcSdsshPAJPmP/2A=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=awWGTU29trYd3I4SDB6LEz5Dc1HwErDJE0Zka2Yx27SK1bO11kU4wDO7J/+1UJqnpBZj78p9+ZxvD8/sknwqLCCMTsvjI3Qpl4sIqs8QEG28KrJpj1LLXeZo34UrBlbhQmv/0vVTnHJo04A5yUFss24DxGUPpRb8UVvaylpKnjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fDDgCRmB; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fDDgCRmB"
Message-ID: <088096eba2d038bce2f73e6519d11ce9@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1748717403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L5XNyCacvsECkV8OPMUggCJaFwEvY2kqdPe+35lKuQU=;
	b=fDDgCRmBbLHoXvm71nJlo4XwDgfEqx24dCvXV3o5NRZrQssKtIGT+jKpbSx6eHwg5Ulvbh
	k5PYQ7mc0jYNnSkNQMOUUs58BYSFj5MXt8QVLSntvEc9UkK7wF2aePYMW6cuHrQoFeD5T1
	RPuunO5JUzhW3GMbuhcnEevDspQ1nWyl3RqeBJC6M1goeWNZcaB4pPZGjG+N7XNmUqGkZ9
	0YXa0ae44MselLcaSIXPhByLea7yotCp+cUVUMIJ/JhZIbpnKAkG6W3uLxnFAd3lHJ+bx0
	npxpT8LNNYxs9v1cjK2UhMsN+J7E1Fg4ofRTvAx4guL48wfz7vuEQuQJWCRGXg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, Linus Walleij <linus.walleij@linaro.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
In-Reply-To: <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
Date: Sat, 31 May 2025 15:49:47 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> It is interesting that almost 700 kernel modules define
> MODULE_VERSION() for their module, but only 4 filesystems (including
> cifs.ko).  I find it useful mainly for seeing which fixes are in
> (since some distros do 'full backports' so easier to look at the
> module version sometimes to see what fixes are likely in the module
> when someone reports a problem).   I am curious why few fs use it
> though since it is apparently very widely used for other module types.

I find cifs.ko version quite useless, especially for distro and stable
kernels which take fixes from newer versions while not backporting the
commit that bumps cifs.ko version.  So relying on that version becomes
pointless, IMO.
