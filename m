Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54BB182B7
	for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748713875; cv=none; b=YGX0u6iqNn6P0eQ9wmjjxdP+ZdwCkSzhVUz+d0V/tt4LW0ST4dbghJ0jORtEPakprUyoSz1P5sIRSLelIoTf0JyBObI004Vo6GG1MN2iAWy8CD4PzqdiEGtBpYCLYI4U4fLKPwKmCgo53iGYe9QilI+F6yYFsUKR5qEJAEep2zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748713875; c=relaxed/simple;
	bh=2Ce6fTmIcPdNUbsHvblROgz1NBz+8MGQLg3VxotrMtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J+HDdfKhld49oIugGZOju06jHHDSBg0iHl2ERbYsoJOqC+1AF8vn0RCgl3huCcXZEoyIDuFqkWesVfDriwG4PxDxZzP0avhlPt6lPDtn/sk0BXHsydRmpmZDip7NWFICtHtePniYK+GQT6wjEZafNtwtikWP7WYXmFCsBq6pJLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dRhSzKFx; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dRhSzKFx"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-32a5eb73ad4so26031501fa.2
        for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 10:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748713872; x=1749318672; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lE8rVDKmUGrfwCV/r7sylR9QZS7hRQBZi3o21ySCnNY=;
        b=dRhSzKFxBTQ4Q9I9ydNcOuhkK7SNZ6GK+fv59TfgibwyAKkxhJ5T/P7SRjJb11rojx
         wT5v5ZqeIpZN0nDkdeVBALrygbpXRhYx86LwepS3E86U8frtl/Xt1uKIT5UbgR6nNtse
         5UW66AmoqB/0IFaAm8W5ee/p6uIasZ00iy0W8gn0f/ejiIY07qguzEP1Eeozc3V8ypl2
         T4/woRFMPXwMHZTp4Ymgl8RuZIpTKFvZZ9WFgM/1Y2dVhZXTsnAm4mwgugGsh6fNaMpI
         JCdz4JQ92UM4jvjwYMT6HkquV5fG122rw7ruUDOAHQgEbnt3ieaA/dz00WPYWfcwbcwZ
         e1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748713872; x=1749318672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lE8rVDKmUGrfwCV/r7sylR9QZS7hRQBZi3o21ySCnNY=;
        b=fp6qtLv6DiIr7vMVBR16gCFvCVWispYFFRP5mjBoKnrlp1ICGQE1FH6E3rRB/TpAL/
         A+FO7mJJag0RGn0OugD4PQ8S9cmIUdyHHWihG62CSWBv0eEfU6fRMm92FrH+lfSOKJEp
         tvXfWxVVYKuVmURIyLKO969Fem4Y+N95G+lfVm7aI7FW1c8GoI1RDycnxccpQZIXUbON
         dRQxqU7b8ERn7Spb+L51g224eoWQFeLvFVschtp6EhMyK/Xhm6RT+iM4bWILk1FVgHq7
         KwDEJeCRIqhAL0GRJquPcEn/my9WEt7pVMwD4ugpZdjMRTmEadAeldKUyiSPG24egLBC
         Ywrw==
X-Forwarded-Encrypted: i=1; AJvYcCVvXzKeg//qqQtfQqOmJio5b2vSDElst6Hw4PheTGeXypRiemJbKmnMj1VBl/SIhwY5WzYeeLRIjyxk@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx14Mqx3vJwaXg548ImSqTFf5P5dw27EOGI3Tvio/nfmeodcBc
	87fjvuxeiCdH4JTX9AYjTtrdOG5+rlWZsx0HXWNB34Niseuubuv7who2I0ApoxaVDrKCnBQmHaq
	3RjeT5td7iHgfyNdGUEvVJTvv/1CF1rg=
X-Gm-Gg: ASbGncugkYlWAKwBwk783oS0UVkdcC6GJqbh9po2eg5glSWzCVMrAsqNuDUttJu4Fwu
	0iGohjqNnMC0mUxgFzI4GYzQKEfT3g+JZmcClbTVTJ0i0N3vdsA5Ntn/p0LsYuVo+Bv14LodKqM
	ZpjqLixDzpb61qiMt06VfaXQHjHNK5E8JQvuuVlr5ATfaUlZZmtMSAjy3GCAk+gUgBMmw=
X-Google-Smtp-Source: AGHT+IFCjlimnU7xdQDPkxwZpabOLkT0WZkUhKQ92oQtQBmSGDpg/Aac8DuHUMbtZ6dqpH94hOZDFf6g7l4ohpgeqOo=
X-Received: by 2002:a2e:a986:0:b0:32a:5e74:5727 with SMTP id
 38308e7fff4ca-32a8ce417e8mr29990061fa.36.1748713871524; Sat, 31 May 2025
 10:51:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
In-Reply-To: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 May 2025 12:50:59 -0500
X-Gm-Features: AX0GCFslh7zRAyvybQPUCnM9WLT4NNue5gugJ4gBtwMhC1m-RePCMNIMQaeiEW8
Message-ID: <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It is interesting that almost 700 kernel modules define
MODULE_VERSION() for their module, but only 4 filesystems (including
cifs.ko).  I find it useful mainly for seeing which fixes are in
(since some distros do 'full backports' so easier to look at the
module version sometimes to see what fixes are likely in the module
when someone reports a problem).   I am curious why few fs use it
though since it is apparently very widely used for other module types.

On Sat, May 31, 2025 at 1:42=E2=80=AFAM Linus Walleij <linus.walleij@linaro=
.org> wrote:
>
> Adding MODULE_VERSION("1.0") to ksmbd makes /sys/modules/ksmbd
> appear even when ksmbd is compiled into the kernel.
>
> Adding a version as a way to get a module name is documented in
> Documentation/ABI/stable/sysfs-module.
>
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
>
> Since I actually turn off modules and compile all my modules
> into the kernel, I can't change the script to just check
> cat /lib/modules/$(uname -r)/modules.builtin | grep ksmbd
> either: no /lib/modules directory.
>
> We define the string together with the version number for
> the netlink, as they probably should be in tandem. Perhaps
> this is a general nice thing to do.
>
> An option would be to change the script to proceed and
> just assume the module is compiled in but it feels wrong.
>
> Cc: Rosen Penev <rosenp@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  fs/smb/server/ksmbd_netlink.h | 1 +
>  fs/smb/server/server.c        | 2 ++
>  2 files changed, 3 insertions(+)
>
> diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.=
h
> index 3f07a612c05b40a000151cef1117b918dc5da9ea..9ae6be7c7b116ab2927707408=
9f2305e2b243594 100644
> --- a/fs/smb/server/ksmbd_netlink.h
> +++ b/fs/smb/server/ksmbd_netlink.h
> @@ -58,6 +58,7 @@
>
>  #define KSMBD_GENL_NAME                "SMBD_GENL"
>  #define KSMBD_GENL_VERSION             0x01
> +#define KSMBD_GENL_VERSION_STRING      "1.0"
>
>  #define KSMBD_REQ_MAX_ACCOUNT_NAME_SZ  48
>  #define KSMBD_REQ_MAX_HASH_SZ          18
> diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
> index ab533c6029879fe8a972ebc85efc829ef0e0dcd3..332e3e39dc613d8a9077da074=
5eb1fb7a30b6bb5 100644
> --- a/fs/smb/server/server.c
> +++ b/fs/smb/server/server.c
> @@ -632,5 +632,7 @@ MODULE_SOFTDEP("pre: aead2");
>  MODULE_SOFTDEP("pre: ccm");
>  MODULE_SOFTDEP("pre: gcm");
>  MODULE_SOFTDEP("pre: crc32");
> +/* MODULE_VERSION() Makes /sys/module/ksmbd appear when compiled-in */
> +MODULE_VERSION(KSMBD_GENL_VERSION_STRING);
>  module_init(ksmbd_server_init)
>  module_exit(ksmbd_server_exit)
>
> ---
> base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
> change-id: 20250531-ksmbd-sysfs-module-efaf2d1a86ca
>
> Best regards,
> --
> Linus Walleij <linus.walleij@linaro.org>
>


--=20
Thanks,

Steve
