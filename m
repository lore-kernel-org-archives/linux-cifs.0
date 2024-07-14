Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256C14006;
	Sun, 14 Jul 2024 21:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720992684; cv=none; b=lZ43qOnpMGLHuwoPMyVqYrr+FTuml338zByO1Nh3ZpCaCZRUVvahlqWiSWDjhq+ijnFk2q7SDKaDOSlgkv6gCcy2p6aDVcmvKv5VREnvJ87qSjIPJzK2+OKdZUSynpR8rWhvg95qIWGkm2C6wiw5alOVnT08CnO/cF1egbuxKQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720992684; c=relaxed/simple;
	bh=UoKrjrHvXPwSGJkX8s798cWDHp3QXsXhOzLtMRZDma0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AcByNoVQAUjlaNXAnXY+T5fgMHE5lueHYrBp/A4TqzCHdWMY50yIQ3Vc4ozf8Hp5vicz4nCAfpwLxcmYEB1OV+zNgAF1vPoFDBGuyBSeRaiuoPPkZlR5/ru2/7pSB6q8IHmrpDtCYxfwgpLpyxBgNBNw6KVAmjBhkUneHEt2iAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUlJxx1W; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUlJxx1W"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ebe40673e8so50474231fa.3;
        Sun, 14 Jul 2024 14:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720992681; x=1721597481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4xkzDWX19N9oFSSTQeCe65G8IASeY++bNpXDyU0BaI=;
        b=aUlJxx1WD618RadeQfU+5AObp7KizASjDR4Jmphe6sk0Zyak7q05taC97ZRi2KUD5e
         ysVDmDj/TqvzK4IhWqAa8AEde6N5jGt+Qgv/gVzuiL/R/rCAJzbFFny8MAyVcl+1AK6e
         KggktccY93sJF72nJgVr5sWnnloFwvVn+fzFOFx8YY6+IGcGGYLNU/Tx/syBpXedsKFr
         mZiBId350jdTRnTUG6w1oeLl8TS9utwlxii3bEJfLFCv2WI1NAurM/1Vc4NPzYSh+ptg
         vpLKjuxYwAU205Ds0H34M69RngsCOlqSaeiJI9ibLtsp7uGF9r3j8ranAvykwc9m/m1+
         u+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720992681; x=1721597481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v4xkzDWX19N9oFSSTQeCe65G8IASeY++bNpXDyU0BaI=;
        b=iW8QQOKYdMLxIZz9WxeN0LIEh2zmbYfAFq7dpFV1naCEQOG5Tj3LXMwegfI+1w98dC
         /1WMPGcM4XudqN1j8H10xOhyNdfAdRThxGW50nb1v2Jg9KyUTghH8s2tm5epiBBvsfWU
         WsEijRAcTZP0ZSKooU4eIpYNWyXdKxmDYvWLk0Fwq6oigbz2+Nuci22izAiFf9By5mcq
         gBBM+iTyZbx15c6BibrqQx4xpb4x7tStiIJ9139Ic/Zvk3fMAywkycKc5nwADM+Webdc
         2wFS8M80LOgU+PjGrwdj5zblQ0aqBDbYo7TGG2QcwJ0KjoEP3ov6Kazm3pQHjHBmJKth
         HzOA==
X-Forwarded-Encrypted: i=1; AJvYcCUqHVN34gd74mw5FDS+rTEw++X5/wTiKtrqygrInzMvWB3DhxuaUjBIqBdGiRScRFc0o8tvYIyMmZRd7KmsRkoXO3CNacRxcz6fOpLB4Ne2lABaTyG/2DT1d379CqoZn5vWi8OhzjMb/71OpIaZAtAurwlvYQw+Qa2LdrgghQNB8kSqwExCZi7lAw==
X-Gm-Message-State: AOJu0YzbbKG1vSPjo4xNxKYINQLM/kCMa7yvROXK7yuqoNbjffLcHmGo
	hXHHiNPnAd7/JHiPf/UoqSwYOwpY4GW/QroHAebK2Thf5IfBluwJkCuY2Eu7LPGjTK9FxmKObZ9
	GpGTpYUpB5m8pDiqkcVKLF6LqjD8=
X-Google-Smtp-Source: AGHT+IHZzsUJb+X/1SRiHsZxjcp8GphpXB7juokaQr1xHTkTa0/CX9uDQm+sFRpdXWKF/6b8s8qSfjvWuuxrH2AC3HY=
X-Received: by 2002:a2e:9d06:0:b0:2ec:5469:9d57 with SMTP id
 38308e7fff4ca-2eeb318275cmr108695541fa.41.1720992680928; Sun, 14 Jul 2024
 14:31:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <18310e20-826f-45ab-b69e-dbfe47a1f83f@web.de>
In-Reply-To: <18310e20-826f-45ab-b69e-dbfe47a1f83f@web.de>
From: Steve French <smfrench@gmail.com>
Date: Sun, 14 Jul 2024 16:31:09 -0500
Message-ID: <CAH2r5mvbk6OrX59dybJvS=ANdzzidsj=rDzRUFrBrjff-upSkg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Use seq_putc() in two functions
To: Markus Elfring <Markus.Elfring@web.de>
Cc: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, Bharath SM <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

are there other examples of modules where similar changes have been made?

On Sun, Jul 14, 2024 at 3:35=E2=80=AFAM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 14 Jul 2024 10:23:49 +0200
>
> Single characters should be put into a sequence.
> Thus use the corresponding function =E2=80=9Cseq_putc=E2=80=9D.
>
> This issue was transformed by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/smb/client/cifs_swn.c | 2 +-
>  fs/smb/client/cifsfs.c   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
> index 7233c6a7e6d7..68998c6ba7a2 100644
> --- a/fs/smb/client/cifs_swn.c
> +++ b/fs/smb/client/cifs_swn.c
> @@ -655,7 +655,7 @@ void cifs_swn_dump(struct seq_file *m)
>                 seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
>         }
>         mutex_unlock(&cifs_swnreg_idr_mutex);
> -       seq_puts(m, "\n");
> +       seq_putc(m, '\n');
>  }
>
>  void cifs_swn_check(void)
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 6397fdefd876..ce5cb72bb81f 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -491,7 +491,7 @@ cifs_show_security(struct seq_file *s, struct cifs_se=
s *ses)
>         }
>
>         if (ses->sign)
> -               seq_puts(s, "i");
> +               seq_putc(s, 'i');
>
>         if (ses->sectype =3D=3D Kerberos)
>                 seq_printf(s, ",cruid=3D%u",
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
