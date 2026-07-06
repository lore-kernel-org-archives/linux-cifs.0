Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A92C3D34AB
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378564; cv=pass; b=qC7c3Ymk09DMYiZ7rUoXy49yxs7vYuYT/IUaADFWHWpLW6Zdy6851HbWxUVSbIU5eAYB8NYa9ulCbU/Sh9WA8e7xl3lbZH6U4kU+XgFqqPLG1/fp+J4XPwDg7c6qWHwBTkoLXsfpTVssFR7lHjbUFCl1dxdzBUsuQBKGmU82Yl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378564; c=relaxed/simple;
	bh=WqK+7xmTyDqCneT5QNkJZ12eODb5m4juYLqkNtReMyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qaA0XD0yij76g15mHKw4kcrPPtAV2He6LG/lnKjimOITE3pSi271kFnzMNsZt9A3+svMxJfXh+DMyg7GSEb0F2zx1O0+9WNyj4+k2n2oxTKctYa8f8dbLFq548/rqYx0yGNEUIJtBHK/3iQXGS+yKnEEvSYmmBkd7JPvUzbzcyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=goQ5tDGI; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="goQ5tDGI"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8efcfdb2b43so26477166d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 15:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783378562; cv=none;
        d=google.com; s=arc-20260327;
        b=GVwA7ReJA2Bs+qE/E5xZTpCa/ZJWhZATHIS/IKqFxWVNKoaY2V/NgGMxvNnli8dAnU
         BNnX105Yx2NvCxZijrbV1MdBmmA31klZBFyXGH4d9EHQX/cLl1WnMuvvSTvpx4xUadgh
         AVecGZFHElO5vRuyUJhy74ARyBXXPuMi2dSPhjRgG0KW7zXkCv0VVIp5PD9abvrs9qy4
         TQQWAJymJZJRHrl4xNyt306xhxXqZTn3B9F/uTNvL/kB71I07az7yNT/oq8HnzOx5J+2
         nzs9v0nscgwIifyhovmXRvKLe1GWvuYBMJQ6j/8ospR/+ru6OD9IS+ackGpLz79NXWsm
         EJBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h6xj/oj32lXMNG6RcjTx/lJkLZP07BoJe7G5Ib5EAjo=;
        fh=6vXjSjdXYquoD8SVeTJ80T1DCoVefW6jetwpg+fRccs=;
        b=Hezh0hQdYxHihv5UjVLunTgdD1/Ffrd2Lu+waVC4vL+dIXzQ/AER7uPaVrWQHlWYIx
         PquuRPHLQ1osOqknBSI3o34m5o2HE2T/EIPxMxGPG4U9SSrBpzHECL6TJl+My4OVDC/2
         RzMh8so9x4Hw22OtRlUlgdrlWBYv0b6fOcSghpsno5g4mm0Ul9sHIq1uTJ306doFfHhX
         O42IkRoPsURANs1ZGQFMO9mCtKUlA56jVTw4TKZ7FhPAe3HDIDHbkKjxyyj4UDWqe8XJ
         5VFBVHc7WxrQu9D3V3eFz/lr4CNdsBGwYXQXfDrxxXVhhgoAG0hFVDcl81fxnCSMIV5v
         lPpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783378562; x=1783983362; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6xj/oj32lXMNG6RcjTx/lJkLZP07BoJe7G5Ib5EAjo=;
        b=goQ5tDGIHO25DP4KekzUqzRfGhOLV8FfmbAzr7ElzANTx3rBMfHPHqMJh2S0rcsBjq
         K8Qa2vdacMmA0ufvb8q3Za56TbVFK7DLHBUYpSc8GxT0o9Gh3Lm1hmP1rlhbnDaTq9rY
         yQyDdOOPUJcg0s/h47HlAk8qVHP7Pw3/a5z0wv4t8tmmT/Gb7CrMfRUkBJq7yMq2sCaA
         a5f1fh0fA/TNXdZaAHQnSp1rR5BblRTvda7Tfc3/Uk1FKJ/h2T58xeHwC76PcaMOhbH6
         /5f+Cvp46UeoQdeXqXHdZnxxFPF4xC1CpMVz+VxPwM/N34Oqw7lDkRsuJSMhEYRizigg
         DUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783378562; x=1783983362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h6xj/oj32lXMNG6RcjTx/lJkLZP07BoJe7G5Ib5EAjo=;
        b=rnbcK83CCLuhoKJpSYTkr4mr2mBtz91fOqOQqhbs2jGX7mLGXfL1Bz+eheJ/PnhCWK
         QrRI6oScBOpETdFNIpfwjr8wGe2Niq5LAhDhP2rE1G2kAV5MxikFjb8/xFrjwjVAGCAU
         phCdp/Zz6zzO4KZk6h01pV4t+rJXHXiwPryVUU7jXzSX3jK1Q4JA15weamflqcddXJSr
         kD+Jei4ulEmV6M+lK2udvlhS2JLtczswWNk0jSWpDMywNgs5AUa60EERttOBYl0qL0hZ
         skF0bpUcQZen4D4Kb7zbsZkq6JI/WWyJvmKlPNFC+P216kuLUd2glD1wNA6dDr/ZeCfG
         6Rkg==
X-Gm-Message-State: AOJu0YyVf0ONRTs7Tak77f6YTf23mONH37PG4YsyBEBI67Cs1oKBZPa2
	iC6F5zPkZUCiMhQFPyILvA+Lah650ooORGqTJDpXrsmSX7huLMr3Pf8RRASl9mU1ZEmn/wczcQB
	9mBMukhXzJjmOeHZf1E3r+GXsSXHoZEg=
X-Gm-Gg: AfdE7cnAe875AtIE0u/HVZ+EBa2IVu6QgKWMY28yOs2DyQbtCi9b3fpGAAEoOBoX0Fo
	ce8Qq3J0w+O8W8NlYf0DH8aGzew/y+9G28AdHlWuTU0mESrkxPXi8DOGj1/wXPOtbTJey+k3O1g
	yzH+HdlBZVWOr2MnOf5UL/FDZH0T53Oct5Di3IAoapkN9U4CqRKH2tlV/7nfixwvFtxQ/gEIgXC
	PxAJY6eINCHaAOd0KG7zNoBdHRlMu6VUnFjiu9DcqPPOQGB9xh8cpEgZRZWGMbWdS7CGkffXGr1
	6Bf9TqMMBWFc+Lc4/kW4mkdFsFLV9LpQT0SJOKDEtRn28bphHWdRTJJJCfOL6a0qoQPxZzpfmhY
	Yselq4t3kE+8HEhY5kN9B/zNWNcWVn87eIEL0tcD1oXGP1i3y2SlcTZDhRQYNdMYJUJawMhL7lK
	/1IpudpPMZGUA=
X-Received: by 2002:ad4:5c8d:0:b0:8f1:4bff:24e7 with SMTP id
 6a1803df08f44-8fcb54d2c16mr31007136d6.40.1783378562250; Mon, 06 Jul 2026
 15:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706184819.22124-1-pali@kernel.org> <20260706184819.22124-7-pali@kernel.org>
 <CAH2r5mue0UYq0--B-6uUVg5zryhxuS82RKFfhMZ0_dJR0gVs4Q@mail.gmail.com> <20260706223948.5tmkeq7tu5dk7uuv@pali>
In-Reply-To: <20260706223948.5tmkeq7tu5dk7uuv@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Jul 2026 17:55:50 -0500
X-Gm-Features: AVVi8CdnX6NO_2DHriHP5TxEcn03jtGWZTy3f_M3mOF5Ljj1WxaJBws12m1Ge-c
Message-ID: <CAH2r5mu4LK8cgWHDb_EUpUHkZdD1EtoJcp_c7Zv0KGmibW+=2Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 06/11] cifs: Validate presence of EA $LXMOD for WSL
 reparse points
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Without this change would Linux client recognize it more accurately?

On Mon, Jul 6, 2026 at 5:39=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> With this change applied, such nodes are recognized as "regular files" sa=
me as in WSL.
>
> On Monday 06 July 2026 17:30:35 Steve French wrote:
> > If this EA is missing, does Linux client still recognize it (not
> > talking about WSL just what Linux client would see)?
> >
> > On Mon, Jul 6, 2026 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org=
> wrote:
> > >
> > > S_DT part of xattr $LXMOD is mandatory for all WSL reparse points exc=
ept the
> > > WSL symlink and Win32 socket. Microsoft WSL subsystem does not recogn=
ize
> > > them without xattr $LXMOD too, and treat such inodes as regular files=
.
> > >
> > > Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
> > > Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from =
WSL reparse points")
> > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > ---
> > >  fs/smb/client/reparse.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> > > index 49a6a0cc2b61..99e93b56374f 100644
> > > --- a/fs/smb/client/reparse.c
> > > +++ b/fs/smb/client/reparse.c
> > > @@ -1124,6 +1124,7 @@ static bool wsl_to_fattr(struct cifs_open_info_=
data *data,
> > >  {
> > >         struct smb2_file_full_ea_info *ea;
> > >         bool ignore_missing_eas =3D false;
> > > +       bool have_xattr_mode =3D false;
> > >         bool have_xattr_dev =3D false;
> > >         umode_t reparse_mode_type =3D 0;
> > >         u32 next =3D 0;
> > > @@ -1183,6 +1184,7 @@ static bool wsl_to_fattr(struct cifs_open_info_=
data *data,
> > >                         if (S_DT(reparse_mode_type) !=3D S_DT(le32_to=
_cpu(*(__le32 *)v)))
> > >                                 return false;
> > >                         fattr->cf_mode =3D (umode_t)le32_to_cpu(*(__l=
e32 *)v);
> > > +                       have_xattr_mode =3D true;
> > >                 } else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) =
{
> > >                         fattr->cf_rdev =3D reparse_mkdev(v);
> > >                         have_xattr_dev =3D true;
> > > @@ -1194,6 +1196,16 @@ static bool wsl_to_fattr(struct cifs_open_info=
_data *data,
> > >         if (!have_xattr_dev && (tag =3D=3D IO_REPARSE_TAG_LX_CHR || t=
ag =3D=3D IO_REPARSE_TAG_LX_BLK))
> > >                 return ignore_missing_eas;
> > >
> > > +       /*
> > > +        * S_DT part of xattr MODE is mandatory for all WSL reparse p=
oints except the WSL symlink.
> > > +        * Microsoft WSL does not recognize them without xattr MODE t=
oo (except the WSL symlink).
> > > +        * IO_REPARSE_TAG_AF_UNIX is here an exception because this r=
eparse point is used by both
> > > +        * WSL subsystem and native NT/WinAPI subsystems. And NT/WinA=
PI creates AF UNIX socket
> > > +        * without the xattr MODE and recognize it also without the x=
attr MODE.
> > > +        */
> > > +       if (!have_xattr_mode && (tag !=3D IO_REPARSE_TAG_AF_UNIX && t=
ag !=3D IO_REPARSE_TAG_LX_SYMLINK))
> > > +               return ignore_missing_eas;
> > > +
> > >         fattr->cf_mode |=3D reparse_mode_type;
> > >         return true;
> > >  }
> > > --
> > > 2.20.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
