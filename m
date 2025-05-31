Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5988C208A7
	for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 06:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748674581; cv=none; b=YTPNA6qnv3uY2JXdnJUfpsqvd0vlPVA/Biei8veOw+nLangAVPoggYuxj5JstICpI4bwA14lHF4/UR3+5u3zd5qtshtdn+sV2G95dWbyBxRWxPATa02OAUmF1zPzyjl95NlEkbfV9T04NovOaheBzv8i94CCwmdUrs7ia4ln5m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748674581; c=relaxed/simple;
	bh=nnacPUYkiu3s4+DFUqDLPf5LFmSpl709UhsOSs69exM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OiHEKDonsPty/+5HZFlonZ+WKLxh4C5ma2p8u3bKOFCfpOYx5tw04Ts+9yvj/1zXZb4S8YwXHtLQL5My7xsVgbP0go1A/MU9mUk3+wA2IMivo1rE2u5WlUcit/44sLl2/OF7xNyARUWq1Ea0PvSijtLU0lDkivZ8tIWP+MNg0EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtOaRrqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtOaRrqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE6EC4CEE3;
	Sat, 31 May 2025 06:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748674580;
	bh=nnacPUYkiu3s4+DFUqDLPf5LFmSpl709UhsOSs69exM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZtOaRrqHKgEiBRmwVtHoBcGouEZI8wzbf+S+VnXd6FBucnaPOsN7VZ4kXQ8R4sLOh
	 RwNubxMJjPDXCbqCHafPrUleMXbepnMyj5MytmELiBuGUN1WoSAPqosjtBgmI1DxfA
	 xgaj9PXsgHoQiPyrbYcFIvd6NiN0wpHWOlSZSF0w=
Date: Sat, 31 May 2025 08:56:17 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
	Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
Message-ID: <2025053156-gilled-mangy-e8b9@gregkh>
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>

On Sat, May 31, 2025 at 08:42:44AM +0200, Linus Walleij wrote:
> Adding MODULE_VERSION("1.0") to ksmbd makes /sys/modules/ksmbd
> appear even when ksmbd is compiled into the kernel.
> 
> Adding a version as a way to get a module name is documented in
> Documentation/ABI/stable/sysfs-module.

MODULE_VERSIONS() mean nothing and should be removed entirely from the
kernel tree.  The only "version" that is an issue is the kernel version.

>  #define KSMBD_GENL_NAME		"SMBD_GENL"
>  #define KSMBD_GENL_VERSION		0x01
> +#define KSMBD_GENL_VERSION_STRING	"1.0"

So you are overloading the module version attribute to somehow reflect
a user/kernel api version number instead?  That feels wrong and not a
good idea.  Export that "version" somewhere else please if userspace
really needs it (and I would strongly argue that it should NOT need it
as you aren't allowed to make breaking user/kernel api changes anyway,
so why would a version number matter?)

> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -632,5 +632,7 @@ MODULE_SOFTDEP("pre: aead2");
>  MODULE_SOFTDEP("pre: ccm");
>  MODULE_SOFTDEP("pre: gcm");
>  MODULE_SOFTDEP("pre: crc32");
> +/* MODULE_VERSION() Makes /sys/module/ksmbd appear when compiled-in */
> +MODULE_VERSION(KSMBD_GENL_VERSION_STRING);

Again, no, please don't do this.

greg k-h
