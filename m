Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666AC4A3E
	for <linux-cifs@vger.kernel.org>; Fri, 25 Jul 2025 03:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753415538; cv=none; b=ZZ/TwEcyU1xtKFRwZd2zRzNQ/NYMvq54Ld3Tgys2/rcqkbdCACOkmDySYq2LsSxH1xyGyyDpZw6CUwn+SKz0DCWPCXl6pJ0ljyJ+LQWKm5B0fFQV9yQ5uCG37d41906cHmLMz7jERuKfyVNMNGONBfZe8vE+hc5VIknrSllpmks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753415538; c=relaxed/simple;
	bh=bMZlElQuwesHgmOWFeyG9juKed4c6/e2+2Q8siSKiKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tv5W2x1EhUv+FOKZVckqQny4AW3sA070wtVWdgAl4R10migvuSKfH1H/BUqA2ewpIZJ8BbSDXNGaBub7YEvhtcFydm0JYf5HsrGjUUUMi7Lml0i0iuAhqxMulWtkYKdgKnaFZ1eVqp/rFKAfeh5NduJi6Qp2tSfEPtSV+QWogGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zbdvoy4Q; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zbdvoy4Q"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-707122b5b37so11641066d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 24 Jul 2025 20:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753415536; x=1754020336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dOM99D24Ua62ofkJnwKzIhd8tP7yC9PMkgCzO7YP9Yg=;
        b=Zbdvoy4QMRY1ZhQi5RKK0PlbTBXaxbvyzvdOj8+vI7GXaogsrg4o+oDzHcv0ek2C5U
         q6R7aemUY5fhffmJVeuwqvYc/mkm5l7/zCcfdXCjVpUOFUqAYUtGiC7odGuF2zskdMpM
         PGe5qF7fVsVkYHIOcFo8EgRbPvCFhYqTraBWd/nhCc7rYgLnvudEuIvSgU//c2vBSPsp
         wwZzoYptqRqElYNHRVyAyNWKLhSgnAW6ODrJaCTDe8Oo8gpk73pgTarbjoP4chxU4rpS
         ogjwrBGT6KuFzH2I3+q+AxxmR0G8tehBQtSM+ax6ggsqUi5hyX4eFuk/gHdWuLf7Gipm
         X+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753415536; x=1754020336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dOM99D24Ua62ofkJnwKzIhd8tP7yC9PMkgCzO7YP9Yg=;
        b=Ajo8Uj61FAwtONDocJxIsrLlGArI/yTqcMTeVnIY6KtqKFRQw4tt4+cHb3Ej5t1Fnc
         fl5aAW1Y4XmpJ51b/pcnyHPZoqU5+2ys2wi0EKuV+ocl9AIpTZfe23eSo62XZo5A5pf8
         WzAVO8eFgk9JO/xh1jaEPuwRDzsACgNti/QRQm9Zz6YoH/nd1KXA+wJdCscsXogVmpXz
         49CTkG+1STI3RB+idv3I//i5IblfAWh4hD4dRjfgxUKDWuHK7FrO0CaQ0uwaBFvusVq/
         enR26r4qwQMBg8IwF7Z/GXiQZX+Ru/0INSGq2hNn4zjNqH4zl3EWA/w90xC88mpgNC7H
         4Pqg==
X-Gm-Message-State: AOJu0YxIaiIsZrCPenaVzj91cpUOsG5pVoP6C5g4UhlwlEiV6XX9spxA
	PRFHlm+oVpX7lSpghFg12iprkRamKF9LbYteKRQt5hZzFqTxq4gzD3HU371Yu8mcq0JuLX1vUut
	iWk0vXSuTktr0N6YUq3m/fUy65PrYOlQ=
X-Gm-Gg: ASbGncukALBLIue7P3gPWMxeIGuXG1fIYpPKXym5yRzoYJ7wpzQNmj0lhHWmRrq42LW
	go3aHsJqpTZAVIGmg0O/ZDIWWxzvEjXhBpQIfV3T7rIi/ZgtBN1XC0osg6nO1HshJK9d0Gn99A3
	LiCmm6Dv+o3B2WfE4lRyFphTD+OeEuFvh1W3sDXp08PHtj7ruSaxteioTSM7PV5PNMSxcd4KFC4
	FNSymDWEeXoM3ZPaOzR6ExD812/TdpkQbMIInPtdQ==
X-Google-Smtp-Source: AGHT+IGLrRb5VZzIHL0OkQlHRunG9+IzDbRBVs2VOTlE+IcdfmhkEJ+KqsTb6pfnUvx6DkYGF7jT18mzsVWUe7bWE58=
X-Received: by 2002:ad4:5965:0:b0:702:d7ff:27f9 with SMTP id
 6a1803df08f44-707205a9bdamr4169486d6.24.1753415536189; Thu, 24 Jul 2025
 20:52:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250725030444.1851761-1-pc@manguebit.org>
In-Reply-To: <20250725030444.1851761-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 24 Jul 2025 22:52:03 -0500
X-Gm-Features: Ac12FXwJfJCI5Pyoi_fHZblYS7Zt6M3j_CgqROauST5T40AoSWGUCnV-bn21mDA
Message-ID: <CAH2r5msMHJN+aD1BipPPKfseFjCPV8-hbLHJv2XpYK+ZcD8JWQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: allow parsing zero-length AV pairs
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged both of these into cifs-2.6.git for-next pending more review and tes=
ting

On Thu, Jul 24, 2025 at 10:04=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> Zero-length AV pairs should be considered as valid target infos.
> Don't skip the next AV pairs that follow them.
>
> Cc: linux-cifs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Fixes: 0e8ae9b953bc ("smb: client: parse av pair type 4 in CHALLENGE_MESS=
AGE")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>  fs/smb/client/cifsencrypt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
> index 35892df7335c..6be850d2a346 100644
> --- a/fs/smb/client/cifsencrypt.c
> +++ b/fs/smb/client/cifsencrypt.c
> @@ -343,7 +343,7 @@ static struct ntlmssp2_name *find_next_av(struct cifs=
_ses *ses,
>         len =3D AV_LEN(av);
>         if (AV_TYPE(av) =3D=3D NTLMSSP_AV_EOL)
>                 return NULL;
> -       if (!len || (u8 *)av + sizeof(*av) + len > end)
> +       if ((u8 *)av + sizeof(*av) + len > end)
>                 return NULL;
>         return av;
>  }
> @@ -363,7 +363,7 @@ static int find_av_name(struct cifs_ses *ses, u16 typ=
e, char **name, u16 maxlen)
>
>         av_for_each_entry(ses, av) {
>                 len =3D AV_LEN(av);
> -               if (AV_TYPE(av) !=3D type)
> +               if (AV_TYPE(av) !=3D type || !len)
>                         continue;
>                 if (!IS_ALIGNED(len, sizeof(__le16))) {
>                         cifs_dbg(VFS | ONCE, "%s: bad length(%u) for type=
 %u\n",
> --
> 2.50.1
>


--=20
Thanks,

Steve
