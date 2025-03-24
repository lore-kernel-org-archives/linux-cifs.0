Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16A1EE7C4;
	Mon, 24 Mar 2025 21:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850472; cv=none; b=HxXgSuFjXXSXAu/1D5FENNK5+FeSwuZ3/GWqDdPfewz0Evm+PDyDVj/vDqnCODH7CXcJ+F41t2tEO2x0Zf+WqpV9v1BvHWmNYPfwcTf7/e8/0FIZfZt7rDRg1j9jvV45fnvJOU2cX252bG/DJUaN30xmR7RjsV8kMYJ3BNYxyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850472; c=relaxed/simple;
	bh=37sGBhOsw4bP+v4LQYWRdTvRompqepkc1tQkVxa12XE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvS4+pOtEtoT0OMKXLb8jLlFFidokgIzAMEt8xMocTO2+RU047ejeDXP1zGnmVEeIO3zNFbwHfoK9q9xviEw2pgFl0a8L3x+ba85rFz5GWrsZtNtoMdNpCVY1g3UAFEfzkgDvzyrpIe6jH1W8GjixCRP70NGc/9EaOo/cYixyCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXz47oRP; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXz47oRP"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-399676b7c41so2593395f8f.3;
        Mon, 24 Mar 2025 14:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742850469; x=1743455269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNLMtPGszyEgjRV8zOXLE9UQ5Tf8yvUAMYZZzFa01jo=;
        b=EXz47oRPBCYRHcNAz/tD1mclTFqFQJiSPidkK4FHbo1P7zPey7LsPf0HGCQq5mxVav
         S2xiiF+yMuE8rijjjzmD3TR+E0+tHgXDtTf5geOLT3PdBd4HCy6W6ulO3kqklfuLjMTo
         hElWbeqB81rJGKmsyKZRCEe/JkzXU85ao99fGj+RRazleTJeNWyEeEMOnA2T0+rov+9x
         LEOEtuDnjPYXXbrbjs1Jahlgv8GW4mPF1qPfxn06U9mLtSug4P4EE00gGFcKhosScvrQ
         hDlHnp46elFxJiG1YQW0UZg11B5/Up2bZSl/cRD/1WsCn+sd9Iy/3mI50G81UelZmb40
         5Jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742850469; x=1743455269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNLMtPGszyEgjRV8zOXLE9UQ5Tf8yvUAMYZZzFa01jo=;
        b=XNcUaMPdZH0B9PJnuJ6fmgRiIecYn67hwwNckPag1Y7W6tN1TQmVRL0K7Ai9lXfIBC
         kAaWSu5pLSz11v5iTPHy3qQKEd+23dcKt177fZ9OymGd6YKB8qLEHzla066Q3D2GfBgB
         WYRGAKm5i5CDGFNdIZmmb/LB9QIHoAklK1AZKMp/KTvbSDRW1apDIT8dFXvV/epVU2LZ
         soqtfXhK/xNiM3Eh0c2bMXgPsQSt2DNmBHwrMWsN6P3Gb0L7KI5mkd8EtymvPLwQarTa
         w+FkTt/ic0syyrVsDskN2vLBrAGYxcsqWVcibYgf4fhglEKmaAsqsEZOba+ZB9p4tsVH
         bjAA==
X-Forwarded-Encrypted: i=1; AJvYcCUiU30xH9yPIHV3mMrJnraVr6AKWSyHGtEYkcN/i/PyEPt846siCOSqU7AK04x2x3dnGN966Jqu28TEpJGd@vger.kernel.org, AJvYcCWcvR40YwrmPQ4pxXzLZHzEhsoZJCREF1Le/oEiypx6CZHsDZojecXH1wHl4Vlv7QiCZsuYEDbHytuZ@vger.kernel.org, AJvYcCXvPckH/c1zw7RPo/CBKfwth4DC6uOSUZ1M78griasaN5qoXHfYXt1Yj9cB7OSm0Pbzo/J3LONp@vger.kernel.org
X-Gm-Message-State: AOJu0YwGpWH6Hh8BvHjRpD9DIZbuSvlJOU0HBha7CnK5JEq4JXsR3871
	wVYLsNEscFHAF5mekS90eXF1vp9sReBzJ6Fe5yuAFnBjk6SAIB/0
X-Gm-Gg: ASbGnctlOPp3qkhPCZFiu4IrNI60c0EnJOvjYXbglskCiWhItcyReGKO5akIPyonG3G
	fnDy6/0f7oI/L2cS1VyJ0TtOGoz4mW+duH4ci339m0xMhNtnELHnMCoGgWlTRAj5I+ssyutA4/H
	QCmGONOuJLQSWvzO9PNjNu0//8xx1iDDmoskghSTnUcNmINeqnoKLu2rpXvQ6QixxNeM75n6tOz
	qR1GkFUjy0zpISP9GFCayO3Kk7J/o3Y7L8kj65lXlLl0dgIkySi/XB1bXEbC70IKgC/ehiOeBXM
	2sBfdwI8xv1Eg2k7pf5IOG1C4aitXudoZS2dybEi0KEvqviqPgLfobD8yWkwfOW2FySSNo8Xiyi
	kSv1fSLSspJab6YHl0Q==
X-Google-Smtp-Source: AGHT+IGT4BKuV7YDOj2O5u8BDxdWnIdabnTB3Mg4ZWsHzsCa72YOZvcYauJbOI4f+AlFZJRYw41viw==
X-Received: by 2002:a05:6000:156f:b0:391:ffc:2413 with SMTP id ffacd0b85a97d-3997f92d5ccmr16502719f8f.40.1742850468674;
        Mon, 24 Mar 2025 14:07:48 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f9eff9asm12152488f8f.92.2025.03.24.14.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 14:07:48 -0700 (PDT)
Date: Mon, 24 Mar 2025 21:07:47 +0000
From: David Laight <david.laight.linux@gmail.com>
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>, netdev@vger.kernel.org
Subject: Re: [PATCH] smb/server: use sock_create_kern() in create_socket()
Message-ID: <20250324210747.3dc899b9@pumpkin>
In-Reply-To: <20250324065155.665290-1-chenxiaosong@chenxiaosong.com>
References: <20250324065155.665290-1-chenxiaosong@chenxiaosong.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Mar 2025 06:51:55 +0000
chenxiaosong@chenxiaosong.com wrote:

> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> The socket resides in kernel space, so use sock_create_kern()
> instead of sock_create().

As in the other patches you need to worry about whether the socket
holds a reference to the network namespace.

	David

> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/transport_tcp.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
> index 7f38a3c3f5bd..e5f46a91c3fc 100644
> --- a/fs/smb/server/transport_tcp.c
> +++ b/fs/smb/server/transport_tcp.c
> @@ -429,12 +429,13 @@ static int create_socket(struct interface *iface)
>  	struct socket *ksmbd_socket;
>  	bool ipv4 = false;
>  
> -	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
> +	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
> +			       IPPROTO_TCP, &ksmbd_socket);
>  	if (ret) {
>  		if (ret != -EAFNOSUPPORT)
>  			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
> -		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
> -				  &ksmbd_socket);
> +		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
> +				       SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
>  		if (ret) {
>  			pr_err("Can't create socket for ipv4: %d\n", ret);
>  			goto out_clear;

