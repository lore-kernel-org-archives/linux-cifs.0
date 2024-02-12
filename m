Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3DB1841
	for <linux-cifs@vger.kernel.org>; Mon, 12 Feb 2024 03:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707707234; cv=none; b=Oyn0nGAK4jhqxlbFEs+pvXoQdYfCf1TdS9InDBPGu+OcWsF7pbviyUWUD4P1aBAymDCsokHpWAP9klhKdYHiCdh1QynzSFV8U5HIgkg68g7ly9oXTk9TETYsr6wncAyxUlePqfwXinmB10x/5ZDVaG5GWKfqREiFxTO6UtzIdJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707707234; c=relaxed/simple;
	bh=gqBEZUvye648SOMHJ/DyIotegnMDR9aLr0aDcOt/Rk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E7v+SwTdphtM85DjFdAlX4RyRdnWJzPSLuEtEiYZb0DXffsx9Fny82h1pLH26/tKs3tpC/kUmHOIikRpFwRphM9cgMyi0O7ZusHzUFKQ5h8QPl/b5+FtXxPzZ9tYfvlsO4OSAUrl6qOUFBgXzz0ewTjDUzPvo2oEOw5ueScEWl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/iox0gW; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/iox0gW"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d0e520362cso14461331fa.2
        for <linux-cifs@vger.kernel.org>; Sun, 11 Feb 2024 19:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707707230; x=1708312030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/9+iSYF0GX6IS/JCqwZKPxY8c3onvnKHWNo9EbhBgo=;
        b=O/iox0gWPeRLM2Rw5gdCtVG09SKdcto/Ur5sbSpCgGkQFVM+slXFXlSFBOwLzoVdQh
         r143F6R9Qngu76h4Cg29Pw/7m80jcczuiG8IySdxexFuTQYcU7zH5ePRLDD3lpU6c4yV
         GTzVMmTaISOi5356HU35NUpWGA6zFT6rut3LTsz1BwmpE4UqosGAr2c6UdXWZIjxVqpb
         dKpQSQjiVCYTdw1XJjD1ah6/cujWMYrM6Mpz6/cgRouy4J0Q7FmsllOQVfuAInqufYLy
         S2dwRgAK+qeh3MTt3CbW22dVPZSoWYbOZlH1tVTy8b9BmI8FWOl3vOgqKdE8R/kkFoGg
         Ziig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707707230; x=1708312030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/9+iSYF0GX6IS/JCqwZKPxY8c3onvnKHWNo9EbhBgo=;
        b=v3Loko+2dfWRzTjk3v1iOigx+vYWcREGhfq6t3yOlJayucNmpS/mejvhLaXG/uyRO7
         sUnhDuX/2S+aj6pF6RhIJL9lamxeAdPKPHvZ4nyA6giD96W/Lwzktq2x5BrXcRmGdVo3
         gLr1f27GeBaSPU1SdnWacC0cbF/fhzNI2/qCtNNbtlamgkj8wuYDUIWaQO2IMu6q0Cuv
         rNrmWdICS0g54wkRO9HRTsxcV1DisI8tWUCH75NHO7vi78NVNQBkQM9xMhNtohDdhmyk
         avq2dPObLygsZxwKDuQ2pUUQbOOX2ER6zMn5+A4IvbS75+033FZ3JXeyllnBCEAO3q8j
         KWQA==
X-Gm-Message-State: AOJu0YxJCa5KHuQbPD8Jr9cu2IwHOzpFxoHCu5e5ba0TzE/vP2byVBaJ
	ZQc+F4zaYLmnKfaow+ZE8zIOCglwT1x+1xdIn+3A4cXrdh1zEdn61j1Q9ZqDWaLt2hEc6ByMmef
	pfifU6DG019AzM54wCPKljk60iai5eTD1QpE=
X-Google-Smtp-Source: AGHT+IEWHmDRaToQC1tubmZMK1FERPSnILZjw6OgZokVXpz9f1yDqusELwd2yteOYeexI5TBAiscdRJrQ72i7Q7SIPA=
X-Received: by 2002:a2e:8216:0:b0:2d0:cce1:f0a8 with SMTP id
 w22-20020a2e8216000000b002d0cce1f0a8mr3330020ljg.1.1707707230075; Sun, 11 Feb
 2024 19:07:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240211231931.185193-1-pc@manguebit.com>
In-Reply-To: <20240211231931.185193-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 11 Feb 2024 21:06:57 -0600
Message-ID: <CAH2r5mvUeeNcd_eBQfCvKLdp3x0GycO17s2WSaGrWpa6dmBXHg@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: set correct id, uid and cruid for
 multiuser automounts
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Shane Nehring <snehring@iastate.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged these two into cifs-2.6.git for-next pending review
and testing

On Sun, Feb 11, 2024 at 5:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> When uid, gid and cruid are not specified, we need to set dynamically
> set them into the filesystem context used for automounting otherwise
> they'll end up reusing the values from the parent mount.
>
> Fixes: 9fd29a5bae6e ("cifs: use fs_context for automounts")
> Reported-by: Shane Nehring <snehring@iastate.edu>
> Closes: https://bugzilla.redhat.com/show_bug.cgi?id=3D2259257
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/namespace.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/fs/smb/client/namespace.c b/fs/smb/client/namespace.c
> index a6968573b775..4a517b280f2b 100644
> --- a/fs/smb/client/namespace.c
> +++ b/fs/smb/client/namespace.c
> @@ -168,6 +168,21 @@ static char *automount_fullpath(struct dentry *dentr=
y, void *page)
>         return s;
>  }
>
> +static void fs_context_set_ids(struct smb3_fs_context *ctx)
> +{
> +       kuid_t uid =3D current_fsuid();
> +       kgid_t gid =3D current_fsgid();
> +
> +       if (ctx->multiuser) {
> +               if (!ctx->uid_specified)
> +                       ctx->linux_uid =3D uid;
> +               if (!ctx->gid_specified)
> +                       ctx->linux_gid =3D gid;
> +       }
> +       if (!ctx->cruid_specified)
> +               ctx->cred_uid =3D uid;
> +}
> +
>  /*
>   * Create a vfsmount that we can automount
>   */
> @@ -205,6 +220,7 @@ static struct vfsmount *cifs_do_automount(struct path=
 *path)
>         tmp.leaf_fullpath =3D NULL;
>         tmp.UNC =3D tmp.prepath =3D NULL;
>         tmp.dfs_root_ses =3D NULL;
> +       fs_context_set_ids(&tmp);
>
>         rc =3D smb3_fs_context_dup(ctx, &tmp);
>         if (rc) {
> --
> 2.43.0
>


--=20
Thanks,

Steve
