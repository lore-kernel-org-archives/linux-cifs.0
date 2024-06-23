Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4BF175AD;
	Sun, 23 Jun 2024 23:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719184953; cv=none; b=Mm2WeuEb2AJ3s0bVOaYWp2ktU5TDsU21+fTdDIyWj72NV+VOeoPmn6VgK6jjV4URSOaCMaVv8sr2+9m6BQQHvibIFk3R9MtCvI4kanj/2edWsUlwBLiuM1tI7D9F8MGMULO4xW0oXyo1lsvzjREtP4vO2QRrY8BnzDdm61uYcn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719184953; c=relaxed/simple;
	bh=8G/sFbqTRFJ/E9GYSVMbhFESpaZYFbGrjSCDAA9gLpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFRhlHhnjJg5amGRaMSg3/gEPr4Z7Ud8XjHYFENav+FDx6DwQQUh9NvyxGD0s6/jeS2ay48SFXqepcCHoWzkqPXBY72kKolMKbkGAX6cVQxxtN/uSSV1DABcbvUuQs6bjFnHMic5G4KbZSGIqNHUb0CDPVJhZVGUMB7oLroSx9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UqOBLF9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UqOBLF9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF988C32781;
	Sun, 23 Jun 2024 23:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719184952;
	bh=8G/sFbqTRFJ/E9GYSVMbhFESpaZYFbGrjSCDAA9gLpo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UqOBLF9FtZPxgvHGQE6c75PTkiJwQUXam/2sCYxuF9MwmIvTofHBj2Iri+dnFnrCT
	 iplpc9ST9y4KsQKfUo1spoqRrq9p4d3Fxy6JP5QAOQeCFw4gEmQ9LvaFlimjO4dwId
	 J6HNuJNamKxlq4fSgGBczVLwbFV9XQcwetQCaAW0PFNcS4iuXeMOeQ1lBI5ld+w0TD
	 ELkRqjkdxwbMfKl6wkMFlh+79bbUvBgDmd17DWiNudWWFtPcVOSKLaoOqV2hR32jSY
	 bT3zaaXiOopmMNx18vLrdB7wHUPI2lQdu88UKCTu+5MfxY+Ha63huCYjFKqcSRfjxI
	 5bTkhaSiA6YbQ==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-25c4d8ae511so1801031fac.2;
        Sun, 23 Jun 2024 16:22:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWw79EJBWF47wK03IeWGT+YaSmoJpB76EEpJaDmj91Ue88awFEE7SYreuwkgBsSe7hWDS6DfYlibGJ/frnfBcrc+Rt8qi1U50i45ntXc0yVGBFrxYCB9zfZ1bEt7r6b9RBPXZZ1RhKoI3fmALCnmDpz8BIJDJ6uFq2BuiWllXAKYMnherOdCtvm9g==
X-Gm-Message-State: AOJu0Yz6G1g0kDABM5VxTKuVYcZ1bSOUqZ3vau1lo64GNb5+l6bMapo6
	q2rk1mOpjqdnHJIKa7ZJf07oilP6Yyvl5e3si1WvrRdiJgsTjrLup+1ZKAZNrGW3uWFdAiSoyA4
	PXJdMNkFKOJ/ZfwhOMEYiYDAQJiE=
X-Google-Smtp-Source: AGHT+IGrXiZyfj5eLcPnQoRl/qQQU4poQcHCOK3E7pS9en1m/44j6q0F4ete6LvMgW4VhiIvNLgXBGcdN2UUoUWWUfU=
X-Received: by 2002:a05:6870:55c9:b0:24c:a8e6:34e7 with SMTP id
 586e51a60fabf-25d06cd6cb8mr3663619fac.26.1719184952182; Sun, 23 Jun 2024
 16:22:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c06ecbfde4cc106603285ed96febf3b887425286.1719160522.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <c06ecbfde4cc106603285ed96febf3b887425286.1719160522.git.christophe.jaillet@wanadoo.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 24 Jun 2024 08:22:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9TrTeQh4Ee=NwdS_Nsjm9Wzswwpo5YOWKdbZNY1VRP7w@mail.gmail.com>
Message-ID: <CAKYAXd9TrTeQh4Ee=NwdS_Nsjm9Wzswwpo5YOWKdbZNY1VRP7w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Constify struct ksmbd_transport_ops
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-kernel@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 6=EC=9B=94 24=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 3:09, C=
hristophe JAILLET
<christophe.jaillet@wanadoo.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 'struct ksmbd_transport_ops' is not modified in these drivers.
>
> Constifying this structure moves some data to a read-only section, so
> increase overall security.
>
> On a x86_64, with allmodconfig, as an example:
> Before:
> =3D=3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   52184    2085     256   54525    d4fd fs/smb/server/transport_rdma.o
>
> After:
> =3D=3D=3D=3D=3D
>    text    data     bss     dec     hex filename
>   52260    2021     256   54537    d509 fs/smb/server/transport_rdma.o
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!
