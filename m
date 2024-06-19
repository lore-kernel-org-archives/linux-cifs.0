Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB511C68F;
	Wed, 19 Jun 2024 23:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718839934; cv=none; b=GlQVQZ0VRi10+YitiDihGYQNLpGfqzYXsVEofmNqLRdSBWmDtf6YVqVop7+tl+Co66QOyy9rbg4vbUWXcrdLYliK29u7P2wp+Lbh27woQlrFRnYUvMQqiSGaFsqz2HWeQ4zb2u/8z+ypYxGoSUiQbGV43u9IFkzbM6Eg8QWa9Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718839934; c=relaxed/simple;
	bh=F4CpIzNzbBUMPI+mEbkLZg02CLmFQNk66TZ/t91MMao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MIVg+vlE0UhEP7Gzokwy7xDU39NPrw7biDQ7KHeKVwl+7oSoCOjRsvVgFBcCozLnPZJ5RCmSPjFD3tcuqcm3fRDV9gY5OdcKtbGL5Ux8AwiR4/HiOAEEMzu5Unprjck3bf1M13S4dc+rmCfPLV60m8l/MN+9QAlvl2BZpIquzmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fLUXXsvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fLUXXsvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC45C4AF0C;
	Wed, 19 Jun 2024 23:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718839933;
	bh=F4CpIzNzbBUMPI+mEbkLZg02CLmFQNk66TZ/t91MMao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fLUXXsvZAPE9OKsb3U0T1Wij/dHh7+TZHI6YSxmnJ31CHIL0NM1VEn2t+F9OooW7e
	 YH1LEvqE5BltEbIzJoZEb+PJLxNBkS3j8KZeWhZmi6CubdXtB33kBy+LLmSK+Ngryr
	 XaMRIWBR23l66F2sIo2AcL/tPysTE9P7XN8vL1rxrd0zU/hw9O7qA1qhyJI+N7hgkW
	 v27trALBU5biyPJka64GjGcpegFsOC6t/nbhJo6FdjwuqGrX2t+wiAyQkzB8+dCacf
	 e9ZJm2tH906glOF2cdzu6oPozbv+qiQMUmulYQh3ZiEJv4NRHanmglzAy5dIJ+C25G
	 xnu5KsammyuBA==
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5baeab9fd60so120371eaf.2;
        Wed, 19 Jun 2024 16:32:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUj1g9tNHPxoYG0pQMAFjqa7eRQeqmgUZSgijZGUQZ/c4W6mK4HlHbkdnWE5GPjpGaXF0n76ZetPCxRKOjOVUl1qoIhtNkcz+IbDmCA/Rb+d8U9tovRqUdwc69hgnfpuqgW7K/7G/AaWw==
X-Gm-Message-State: AOJu0YwB01wt4B2+GW1ArZzb3o5Yi6pgrcePKx3s12N1tcDUvBDuWCM0
	bZ/TDDqePPugP4ENWfn5NvKOXDu9r6MkUVp2aLr766r0tY3ufIWVuJiKKyqnfoWhag3EPSh7dbb
	P1CH9zHuPjVMa/QKGWfkfEl9vv90=
X-Google-Smtp-Source: AGHT+IHztATvBmnqgF15p6/sdSBgWtaA7Pf8BZ+Y2cUp/dd+2nIxbJC+EgJkCNcFTcQIFIugOT8rEaxmZOCNLtYCLKw=
X-Received: by 2002:a4a:91c2:0:b0:5bb:672:4067 with SMTP id
 006d021491bc7-5c1adc0d1fcmr4011799eaf.7.1718839932856; Wed, 19 Jun 2024
 16:32:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240619161753.385508-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240619161753.385508-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Jun 2024 08:32:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-V80sdH2uXoDe+xqf9N-gFYTjqWtERrB+-vH0s0NUMvw@mail.gmail.com>
Message-ID: <CAKYAXd-V80sdH2uXoDe+xqf9N-gFYTjqWtERrB+-vH0s0NUMvw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove duplicate SMB2 Oplock levels definitions
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	samba-technical@lists.samba.org, chenxiaosong@kylinos.cn, 
	liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 6=EC=9B=94 20=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 1:18, <=
chenxiaosong@chenxiaosong.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> smb/common already have SMB2 Oplock levels definitions, remove duplicate
> definitions in server.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
