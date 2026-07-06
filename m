Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEFB434E5E
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2026 22:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783377051; cv=pass; b=SRpByWSqKQhD1PzuNsoje0Cy/aD5on2L7eDjx1HhgRycHgjFNwRb1K2QMDo/63TZJdPh+F+4O4z1qP/pOUpF8ZFNxPjKSG3RuKeUr2p+EY+U5y6anm21q+X/o2RK1Qre82LkSvmIp3tgjiusI5dCoEy9it1taAOecHwbOfrSGjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783377051; c=relaxed/simple;
	bh=Sepzh8WjJWQ1/y8eYQBbNFJA9r04LBRMKabbOSBQVq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WoxslZFAMpV/sLjVek6e+3GumwSQRb44YBWTZjS5q5YPgGm43auz5O6SIlNJTrzhgwq34bh27lmMq9nU6+/olNbAPOzlCWwd4Vza2vGaWiPAbi0DeCr5twFAGHexXxj9ZYHuxvv6bRVn8+u1CRx8NqhmG+VewTs5qpChKTNm1G4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vw/MPJTS; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vw/MPJTS"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8f256eaedf8so37563316d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jul 2026 15:30:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783377049; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBasZbT+HPLMikbcyl9wxA6aL4B4+lHh3/HHl57O7GrfsuVPXuGV94V0yU/C2itV+F
         ih+5OAPbAQ9iUeykKwIYGxa/CvqPiqyten+xRS45fYM8rpC7RJj5n3rJuOkolpfBXElo
         d6lyAN0J0tbqpL9Sl8EaKt4ivb88xiMZG31WdO6zQhUTays1KqEHy5qZyATketoQx0vh
         2ffzA0U6Q7/+2pVncxc2kxhdByi8xIBefqKiIE4Z+k+RrzHzH+mzygIJN7G5eei9Ab5a
         X4C6DJPDbdgRBXqmb0CExAGMabGR2btnPWpRKvloaxsfHVVxkvEmT3B/eOVw09vGrYzf
         yhhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KkiuIhL4vokV+7MAch5FPM7pJ2o9BbDurqrYWXc8PWM=;
        fh=6vXjSjdXYquoD8SVeTJ80T1DCoVefW6jetwpg+fRccs=;
        b=lJxfNIs65Q6xvnHxfMczbhEW+AL5tiUy58hLK+MaAyKA/+GRySxx1u8kp8jxFWDPDb
         50kWvj4KGJxfrdF+aPgDOzPfL+5dxa5BvsIAFFSAlqQlkyAnRpU3jN0PRuEw5/ny87ao
         kAhYRTI7WlE02BiiVEKcL2f/RyFg6VXR8OIaLY1ik1q9n7mFsFa6pIJVgGR9hVUfHi+1
         NUNZQmbDI5TW16N9wJaOPy/5uRg5gzF3spY5zeDa1xO9XGiSsgTt/qDJsYezYvWC6vFJ
         KZydJVj06nlMR/etkDGJWBM1SIZbgtBMUuY93zKz9s3rd7XSxJMEwI77AOplLl51xlm4
         seJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783377049; x=1783981849; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KkiuIhL4vokV+7MAch5FPM7pJ2o9BbDurqrYWXc8PWM=;
        b=Vw/MPJTSGH58exXzZJecQnoe+5Mal9W5ZyayOqE1jjaC45Y5pY/PdEcEkQau/XwrCH
         7aKeGozP3qDoJUzu7KIO3kTZsuttzTRlHdf5ZCtUJScBgIXjauWwsP10TAPUw2tlPZUG
         ABduHn5KPlRj6hC88LLsmvt1GtnLYgVETzvuMcSTrRunDfhkd7xj+C6jB/aOLtF+2N2h
         NTNR1d4E5OaR3tbhwyr1fULSElSFLn5P4UiJ/HeFALTGCQRK5Oiyy8xla3QG+vlvZw2I
         O4lF3CksBwMkARZnsNaHttGnMtnUZjW073GcWh+oV9debZMA8ZDtHEUH4xy85HjzHUHc
         UzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783377049; x=1783981849;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KkiuIhL4vokV+7MAch5FPM7pJ2o9BbDurqrYWXc8PWM=;
        b=Oi6nZ8MQSX/dIN1bk2vYK8ASAFhEnN4zNGkMzUNeUbzp1qxiNQUQzh7bSqgqjrVPO5
         ElcDJS7+F4gPNUiy72XmGu0Pbghbk1Viv4R0Irwoa48x101Ai4pLicgn7nfWfjsDy5CJ
         93dEfUUD9HAD8dOti14fosKnlXr/2OEw9gN0nm1csgjq98uyLvJMNI715cbzLOmIg6+I
         MNe0pksYKeTrT2C7WujqSBKo0ccn42KdA9rgLe1ZK+MWP9Mv73VBA5P3iwhC+1rasEHC
         iXk+IUz/3PzJGH9gtVjwvP0PM5L63NbB1PAJ9dkAS3euoD5Sunu4ngdpleMSHI8qcdrM
         TCiQ==
X-Gm-Message-State: AOJu0YyC4mRtOifu3wzQ5ThOn1XKXoRV08hQGZs1P6L7kEEIsqcYsNbi
	XfQJy8gHvtCiqqBqmEVJcasN289QcN1HJHcFkZ5dSwDHSr6HCYJ/DinnooI28wcq/8x5XZfIqq+
	8olyiZ+UjGYcdxr5pLRWYLOx8dkY/XzU=
X-Gm-Gg: AfdE7cm8YcpdSKmXfMczRRYQITIXUe+2uD1vMkG/w6TxB5r8D5yqxBjdkjhbPq2NWTL
	2J95KNpvLXQfFwzfYKWlxEBYVsgI8/JwUr4IFw+95Id4RsvgqY820ez26XgeBNYstQzNHpki16o
	Ctv7jmjwG8NVUj3TFxKk1km/6nu1XYmSC4xEEFgzuEd98mNvXdIU0jrmoXD/8Du36pMpWc97ZGh
	xWK4ieVFWjlNhUQmhDPWAm856Nw092PY6qL8ZsfbwUIRbJ1tmMsNP8tRr/2EAG+/PVzFvOE2DZp
	t1xEUaRDH8Y0X/dbii9sLTmtyPKj2E29cbqR0rPx7zwVUdeo7T7AlT9BW6dPL65h5vu19bHtVWM
	a4BjIxqfy+jciUPzsQjE0hE76cFOKwJGMAtTzut88Xh7oQd91mTyWSjmeJzzwu9kSJeTyS9Sdos
	OObTzKk7xX
X-Received: by 2002:a05:6214:5014:b0:8e9:f5de:d613 with SMTP id
 6a1803df08f44-8fcb4ef482emr33083336d6.50.1783377047676; Mon, 06 Jul 2026
 15:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706184819.22124-1-pali@kernel.org> <20260706184819.22124-7-pali@kernel.org>
In-Reply-To: <20260706184819.22124-7-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 6 Jul 2026 17:30:35 -0500
X-Gm-Features: AVVi8CeyZacLyNKMWYoyoJNJ9nYfwvZcxkPi3tvkMMNcgnhipaQKEo3-5RIk9X4
Message-ID: <CAH2r5mue0UYq0--B-6uUVg5zryhxuS82RKFfhMZ0_dJR0gVs4Q@mail.gmail.com>
Subject: Re: [PATCH RESEND 06/11] cifs: Validate presence of EA $LXMOD for WSL
 reparse points
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If this EA is missing, does Linux client still recognize it (not
talking about WSL just what Linux client would see)?

On Mon, Jul 6, 2026 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> S_DT part of xattr $LXMOD is mandatory for all WSL reparse points except =
the
> WSL symlink and Win32 socket. Microsoft WSL subsystem does not recognize
> them without xattr $LXMOD too, and treat such inodes as regular files.
>
> Fixes: ef201e8759d2 ("cifs: Validate EAs for WSL reparse points")
> Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL =
reparse points")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 49a6a0cc2b61..99e93b56374f 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -1124,6 +1124,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data=
 *data,
>  {
>         struct smb2_file_full_ea_info *ea;
>         bool ignore_missing_eas =3D false;
> +       bool have_xattr_mode =3D false;
>         bool have_xattr_dev =3D false;
>         umode_t reparse_mode_type =3D 0;
>         u32 next =3D 0;
> @@ -1183,6 +1184,7 @@ static bool wsl_to_fattr(struct cifs_open_info_data=
 *data,
>                         if (S_DT(reparse_mode_type) !=3D S_DT(le32_to_cpu=
(*(__le32 *)v)))
>                                 return false;
>                         fattr->cf_mode =3D (umode_t)le32_to_cpu(*(__le32 =
*)v);
> +                       have_xattr_mode =3D true;
>                 } else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
>                         fattr->cf_rdev =3D reparse_mkdev(v);
>                         have_xattr_dev =3D true;
> @@ -1194,6 +1196,16 @@ static bool wsl_to_fattr(struct cifs_open_info_dat=
a *data,
>         if (!have_xattr_dev && (tag =3D=3D IO_REPARSE_TAG_LX_CHR || tag =
=3D=3D IO_REPARSE_TAG_LX_BLK))
>                 return ignore_missing_eas;
>
> +       /*
> +        * S_DT part of xattr MODE is mandatory for all WSL reparse point=
s except the WSL symlink.
> +        * Microsoft WSL does not recognize them without xattr MODE too (=
except the WSL symlink).
> +        * IO_REPARSE_TAG_AF_UNIX is here an exception because this repar=
se point is used by both
> +        * WSL subsystem and native NT/WinAPI subsystems. And NT/WinAPI c=
reates AF UNIX socket
> +        * without the xattr MODE and recognize it also without the xattr=
 MODE.
> +        */
> +       if (!have_xattr_mode && (tag !=3D IO_REPARSE_TAG_AF_UNIX && tag !=
=3D IO_REPARSE_TAG_LX_SYMLINK))
> +               return ignore_missing_eas;
> +
>         fattr->cf_mode |=3D reparse_mode_type;
>         return true;
>  }
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
