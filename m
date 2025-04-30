Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635A92F5B
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 05:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745992206; cv=none; b=aH1FUPGDsJ9B1UxAW7VXaSYlyt9VZ9X1ERXXyn2/WA5WB1L8Df07yZihgw110Mc/N7b2XsgMdfMf5xApeu6R8KOfyuI4MDBkE/aJggYjWKNNA5oC9k2XGWWoQsMb8Sx8VP1GJAxnjDgifiyPxla7P7bEcXsz+h/SM5eYo+jwIC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745992206; c=relaxed/simple;
	bh=P850MVPJ0u6YfhCKpaINA2US4ZZ8M0iWiFPiFRl3orY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tqly4VDYJu9tkqwNyUqGVKiggDpLf0LPKLShA6pjCleCRwAONG6Aqd3C9OdG6u/v0VrlTlnIGJGLgrP3X6WmyXWBS7uNvFBAZKw7s3ql3uUI0QqPJ4CNCtrwHggpOLHP4/SxxuXnX649+PEWLJtTCR43/48T81UjCbExWreEDwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdpikcN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdpikcN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF83DC4CEEA
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 05:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745992204;
	bh=P850MVPJ0u6YfhCKpaINA2US4ZZ8M0iWiFPiFRl3orY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XdpikcN2Wtg8u22rYbavazGLe1Na4cuVQIr2q++U0UMA1+d+ksKoLS+ct4b7sZJ8z
	 vObzGRKE0tbC5LKPwpNYEd2vQ6Roj9fxDbcKneuJcofY9AzePnTkEltkhYaXqMfrmB
	 Ptkru/Jx8hglnUXIk7OHfABtgvlx9/S5kWDrovDRzaMIFKHLINEX5uH8wC3RKq6rMw
	 RRv2g9b4pKu2HAdgE6zd9lU7WJ8nb1xFKyEWLw2nMv5oE9Osx2OG7irRK28pyxQAAp
	 iiB5lZc2tOaZJkP1rVeymbPo7lpIjmmy5HErw7M05LheyUOdWbyrgB+OqY5f3H11kl
	 X5Csgw5cYra2g==
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3fea67e64caso5490450b6e.2
        for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 22:50:04 -0700 (PDT)
X-Gm-Message-State: AOJu0YwuVPVKJdcCvBjh/d5z5vwVHrrwg72zX8Mb6CUT4u5Kxbh/wu9j
	5GZpN33pZ4q/7KtexAebJnWZdZhQf7L86svI/MDM59pnMRO1mRTOJuPqNopUVnoHb54eXNevelV
	sonXrWf8RMLAgJXx+XiAkI3NkbV8=
X-Google-Smtp-Source: AGHT+IHo7FIfDXty//mZKTvSDQeofjrpAdtoFTWAcxhtF0bKwMNLcyobNuRWeKVXGNcZDAa/R+bBMQ2ICKI5auctR20=
X-Received: by 2002:a05:6808:6f8c:b0:401:be80:3235 with SMTP id
 5614622812f47-40239e454c4mr1414182b6e.7.1745992204126; Tue, 29 Apr 2025
 22:50:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430005915.5e1f3c82@deetop.local.jro.nz>
In-Reply-To: <20250430005915.5e1f3c82@deetop.local.jro.nz>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 30 Apr 2025 14:49:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8EUXsjdMRE8RoL+7QORp_MLXvsWZT6ciVMXMNmmnsmVA@mail.gmail.com>
X-Gm-Features: ATxdqUFJFz8pmj2rWQsZxtmRFKeKHLoj1iCUEXMGPDTtDSIu_voKp03Otji3WMc
Message-ID: <CAKYAXd8EUXsjdMRE8RoL+7QORp_MLXvsWZT6ciVMXMNmmnsmVA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix zero length for mkdir POSIX create context
To: Jethro Donaldson <devel@jro.nz>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 10:13=E2=80=AFPM Jethro Donaldson <devel@jro.nz> wr=
ote:
>
> smb: client: fix zero length for mkdir POSIX create context
>
> SMB create requests issued via smb311_posix_mkdir() have an incorrect
> length of zero bytes for the POSIX create context data. A ksmbd server
> rejects such requests and logs "cli req too short" causing mkdir to fail
> with "invalid argument" on the client side.
>
> Inspection of packets sent by cifs.ko using wireshark show valid data for
> the SMB2_POSIX_CREATE_CONTEXT is appended with the correct offset, but
> with an incorrect length of zero bytes. Fails with ksmbd+cifs.ko only as
> Windows server/client does not use POSIX extensions.
>
> Fix smb311_posix_mkdir() to set req->CreateContextsLength as part of
> appending the POSIX creation context to the request.
>
> Signed-off-by: Jethro Donaldson <devel@jro.nz>
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!
