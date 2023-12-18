Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699CB3A1D4;
	Mon, 18 Dec 2023 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNae4B2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E99C433D9;
	Mon, 18 Dec 2023 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702914867;
	bh=GKFIpWALPPsypWUO/IOs6Dgt78iECnZDwfzIImnelqU=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=RNae4B2dUmZfMwRbgL0DJqjqU6qmEqnN8QRmkA9dP9DCsQ35vVFQeGN83szy/u+iW
	 bYvAkY9Ng+B6tOkltNMN/SDhkg4qSV15rFZXnbIMScuhrlDd8rnkBM7CnTVfvIQZrd
	 hK9eiMskFU/eUfeY+/IegwYVjCTJoOjVjnprTimUdW7OTsKN+vbQm5qPHYykLELNw4
	 VvYGHk1XA8XhTM/meGi6b618sFzFFefX+r/MKDyh+uBWZOzaBxtHAgl5hbPt/6cT4b
	 K66AiCn2TmnaODvAlrChZ83Yhu8Hsh175Rq6uc6AE9Nw6OliR9BMm4xOmS2QToTX91
	 O6OJI6jNMSuoA==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-59082c4aadaso2314790eaf.0;
        Mon, 18 Dec 2023 07:54:26 -0800 (PST)
X-Gm-Message-State: AOJu0YwGUU9baGChxQuJKcsUJ9ZpLTl/PmKOZIFeD5bD/eFO6Ep5NeVH
	6+RBZu4AaIcjA2zs1tHhw0ualUPUM9wjvTn0sUo=
X-Google-Smtp-Source: AGHT+IFdDKcJTP/alQPrvWNpW82WSR2W0KFM4YnjIeUQiPe5kgABXtCKcSkhCfejCwq/Pym+qF6wi73L/4jfAkBw3hs=
X-Received: by 2002:a05:6820:1ca3:b0:590:83e9:290b with SMTP id
 ct35-20020a0568201ca300b0059083e9290bmr14069473oob.9.1702914866225; Mon, 18
 Dec 2023 07:54:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:7f88:0:b0:507:5de0:116e with HTTP; Mon, 18 Dec 2023
 07:54:25 -0800 (PST)
In-Reply-To: <20231218135053.258325456@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org> <20231218135053.258325456@linuxfoundation.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 Dec 2023 00:54:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd952=Y54gwM4KBDca52ZFcg+yjJeuiy+6o3jG+zYYUF1w@mail.gmail.com>
Message-ID: <CAKYAXd952=Y54gwM4KBDca52ZFcg+yjJeuiy+6o3jG+zYYUF1w@mail.gmail.com>
Subject: Re: [PATCH 5.15 80/83] ksmbd: Mark as BROKEN in the 5.15.y kernel
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Steve French <sfrench@samba.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

2023-12-18 22:52 GMT+09:00, Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> 5.15-stable review patch.  If anyone has any objections, please let me
> know.
Hi Greg,

It took some time as there were a lot of backport patches and testing,
but I just sent the patchset to you and stable list. Could you please
remove this patch in your queue ?

Thanks!
>
> ------------------
>
>
> Due to many known bugfixes not being backported properly to the 5.15.y
> kernel tree, the ksmbd code in this branch is just not safe to be used
> at this point in time at all.  So mark it as BROKEN so it will not be
> used.
>
> This can be changed in the future if all needed backports are made by
> anyone who cares about this code in this stable kernel branch.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Steve French <sfrench@samba.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  fs/ksmbd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- a/fs/ksmbd/Kconfig
> +++ b/fs/ksmbd/Kconfig
> @@ -3,6 +3,7 @@ config SMB_SERVER
>  	depends on INET
>  	depends on MULTIUSER
>  	depends on FILE_LOCKING
> +	depends on BROKEN
>  	select NLS
>  	select NLS_UTF8
>  	select CRYPTO
>
>
>
