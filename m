Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182FD1B6546;
	Tue,  1 Oct 2024 04:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727757108; cv=none; b=mUemXabUc5wWM0H7VyNR4lu5Syq69HT2LtjDu8DWkTg0JvhlMgrOVyS7ibBs9aixfo1s7qjQgaF4dycpq/wdH5jueDl7r4Jh3G7Pwkx9WJ5XkfcAlzct4o4ZKybk/wrIjM1YdJzRpGuGsu7yv0H+GtJRcW8StCqerore7G/5YCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727757108; c=relaxed/simple;
	bh=QqFw8b03haZc0W4PpgQ2ijn5gbtj1SnUz6wHYH4q15c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KgNrkKKmzyq5gaG6+XskoCcRDO2ZobK2xN4YRIh3TUuxFUjS47IwQBDtk1pqbmb+FJF10HVzO6s0lEl+EPvLG52Xqxi8yZHDtvWENYbYP2YcVjJWsWxks805RowqMDM6wgnOSSennOyj18AqqGGuoqsY4KAsdpcThGiWNcsAmCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=naMc2y5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="naMc2y5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC8BC4CECF;
	Tue,  1 Oct 2024 04:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727757108;
	bh=QqFw8b03haZc0W4PpgQ2ijn5gbtj1SnUz6wHYH4q15c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=naMc2y5cNT/GVpXvYiY5rlqE5IufInLtprYQnHgA+iX3d/u4os2rBH7/Yet5bAMAb
	 SonntitUCWfXesDMO9SVNc28jORi9yAwc1hDJ5GThjfDAWBA5s/3g0xPBx86AnFcnC
	 pnCQZRtpnG1lhnjOVmQXZEVNoirWA2FUc2bSeLUNPICs/Knqq8eneB9mKBoB4248x0
	 W0C49ZMOVVgoOOLlRyGH9sslr8bHkneJB2AJeLV0Csmy81LWPhGfRSxfuQwf/gZm5t
	 ExTbabYoD3O31Cjyxx6mdC1+Uk0Rj7VxfGCO+RvGsQVldXzThWJDy4YgitwFFf8hdg
	 pnR+WGjCZZ5Rg==
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5e5a0519d00so2155200eaf.3;
        Mon, 30 Sep 2024 21:31:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU6nfTmrkLGNFAHCwA5sglUaYEYxv4ozFhN4w4bYDYnJzN1dpJNJ08C/w7LDi8/ekZ2wPL1yonXtE7VIuL4@vger.kernel.org, AJvYcCW+MoU0RDx2SjPKOSC0tDYMOur8x4pV3XU6PCbSHhGVZhePXXquuky/T4TLRkkFFqyp4mKx78AIF5uD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/yrJenhlf9iBJxlJChV9mGh3mGSiH/iLhJTataYg06u+3abbU
	cKqqqsu5I04DanQZHrzWh38RO1L0xzmaAbJ6A7sSq0yv6gpH5ZKlkSXMPK5k2J3PsM5IcFTug3u
	3p1mLqsuxb3nxhL6kIKTkHgUbR2s=
X-Google-Smtp-Source: AGHT+IHub5pqnJ860/avO2mM5rEXNDCxZHZ1ftTbfIJrU5/GAn5eICQDK/3Fi3unU37Ln5roIyadiSP/FJL9PUaKMwI=
X-Received: by 2002:a05:6820:221b:b0:5e1:de92:6b4c with SMTP id
 006d021491bc7-5e77274fd17mr6980232eaf.1.1727757107089; Mon, 30 Sep 2024
 21:31:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928150030.1217-2-thorsten.blum@linux.dev>
In-Reply-To: <20240928150030.1217-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 1 Oct 2024 13:31:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8EMSFYWs11Qd6FDUqtEM06HTnQ7G2C3sr8t5JLASoaYA@mail.gmail.com>
Message-ID: <CAKYAXd8EMSFYWs11Qd6FDUqtEM06HTnQ7G2C3sr8t5JLASoaYA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use struct_size() to improve smb_direct_rdma_xmit()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 29, 2024 at 12:01=E2=80=AFAM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> Use struct_size() to calculate the number of bytes to allocate for a
> new message.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
