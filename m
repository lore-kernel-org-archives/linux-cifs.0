Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA713559F8
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 23:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782691174; cv=none; b=SxRd7w78uolZZvDIe15SbxtvJXKkvrm/GPdjjDshrQZdLf3dn//NM3iZwcQIKs/7G1dUo68Hn8bt2XNCt1uT/yWpTRoiozyKbXMH/rzturv7hecYUeO93fBHivAcu777KmxaVHBibIgvjbKB8CH0H/gK2/Y+iEypAyrUgS2ufF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782691174; c=relaxed/simple;
	bh=+X29beL8jceJXITvoztr4tTvLSQMtz4F6zPcLg8gI+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SLZtEkRJxG3BL+N4ojXwdI6wtoWSLucdaJpe3BFkPNZcNjiJ0gi6eM9XIBuQn4aNCZuJWTqlEdRZAZbJD28diQbRbeGHp48OQ9Ne4ueL+lhUGPzqjtdUkZx9nKbXN3A7HjtcJu8exGhCImJPNxKDgmrZtDVjZaVw+MiXfFvqiF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1dPa3GZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1dPa3GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A7F1F000E9
	for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 23:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782691173;
	bh=5BxjU6YMbsIbEPP8Up34hQGdUMRDmz7p9Kpyn6VnhUY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a1dPa3GZ2WyRAeRcixXVvwlnA8mLijahgmv4sjOyjkoHlPxiP4QqyR2XM3oXTgsJ/
	 lk/hjgDu5DHRXBgUNbeqz4cslxjeshrXSPHQxB7g1oULofFi9Uq7u6yoM9znWfc9EC
	 gU7KUZNTl3/PpQ5PLMaVUre8cRqe0CyWle0nVVMpYPO2J8Q3x+7Z+i5emccpCI/gFy
	 1MFNuAzSLia4cCE41qe8SlApCiI2flpOF0d6oAhCU2itKoBgvc1tm/2iKPHIpaWcgs
	 j12ojhxKEzESgR5GGUUQrM+ptZyKFWGq6Re9AYT6fVo6mIM83XcTxpJVvOr3TGfbfn
	 wYkO8a+hCSoWg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-697df404e32so5592828a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2026 16:59:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoMVdo7eQhdcKn8yBET20kIxdul+1ALqB08s5EsEwUoMuflBqEiJ9xxqw9P1ctYWbYBn2C6JvKqxGa9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/ckX7F/T8dOwFgg9Jrfjuh37ZxWfMRDvYq0h8dNgrL8ddysE/
	kMikF7odC8F3bYzZzXrRA6MO8RAs2Rh+7M4TP90VoJoY6c6OBCe280V81AW6VWhDnidJLQpgajL
	pPrhUhEQ64UkW89StrYw4GThEVCRozFY=
X-Received: by 2002:a17:907:cd0b:b0:c11:6550:d659 with SMTP id
 a640c23a62f3a-c1205f3be37mr836495766b.41.1782691166031; Sun, 28 Jun 2026
 16:59:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260628074243.629589-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260628074243.629589-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 29 Jun 2026 08:59:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9ijOdQJ+3oJsrLoup5Rg2Eq5WeCNb507dTETQRG8i5SA@mail.gmail.com>
X-Gm-Features: AVVi8Cf0sPCWy-XaLNfCMBa3oe_JB9NUEEeoK5uG11M5NseRdWKChykYk1P4A4E
Message-ID: <CAKYAXd9ijOdQJ+3oJsrLoup5Rg2Eq5WeCNb507dTETQRG8i5SA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: do not require delete access for
 non-replacing links
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2026 at 4:43=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Reproducer:
>
>   1. server: systemctl start ksmbd
>   2. client: mount -t cifs //${server_ip}/export /mnt
>   3. client: touch /mnt/file; ln /mnt/file /mnt/hardlink
>   4. client err log: ln: failed to create hard link 'hardlink' =3D> 'file=
': Permission denied
>   5. server err log: ksmbd: no right to delete : 0x80
>
> Fixes: 13f3942f2bf4 ("ksmbd: add per-handle permission check to FILE_LINK=
_INFORMATION")
> Cc: stable@vger.kernel.org
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
