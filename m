Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B8198A17
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731949754; cv=none; b=Ch5qHfwaCKNX1VUGirGzlWqRkbq9z2B9UUVpOg3Eb7ys0ka8p3aVfhaL9DmSTaKDXaOBeEOxKPPfa2/CikFIs/Xm1hcxH4QQPEHRFkv5q1wDMp5mw3Njl3PziOgThqE17p+9eDKKxj/nWQcpEP2ROxUpcfuhBJSVcrVMbn+ErEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731949754; c=relaxed/simple;
	bh=qMxPflzeuB3aTXw2p3aP7mzJ3ro068SI6FDa/f6YFro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ihrQ67ARd/ELyhaIsfALcUDG3cf8xVf1k7CoVKVFtEpUeAogI8Pa6Ag+6qkwnB/iOE+P2/U4sYAjbyZc7jtDJt1k4EZMJuQOthnLTgcEn7G3FwOyWFxajroyZF/X/VK1GNAWhOLhqphPSUsFIiDFlyqnkryPi1n7e0xOdJMSXos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAhmK7Eg; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAhmK7Eg"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2feeb1e8edfso28272511fa.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 09:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731949751; x=1732554551; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qGczjWQW1pxJRRJULZU/KgiY/JKW88O91iy9n6DMZNk=;
        b=LAhmK7EgvlXxRPHRQkX5phs6l8NFuEMZF/ko2+oJGUReBlyEExTeGyb1fv+nNA7n7p
         hA3qYaPwfnwrKzLyYpOTu6FIqa57bOeST6HdZghJcIeJlo5eSuj9X5qzK/ebJNoUQ2Sz
         pSuLvZJjaQgibXFMllgohovBTz7YOTEchP0C4xoc9u0BkETpLGsYlU7Yu8QMCjNi3hks
         aYhk1TH/lmsAs5D2043GpgBJ8irHYcmhw+rE+/1cX53jS/kqdr//cJ8q869whDev8N30
         hl1JbINWTi2wF+J5lMw7EpFDfxPTxhmDhZKZqNFbKmjD940dpRryS1H9W9zkpZMNrIyi
         AvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731949751; x=1732554551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGczjWQW1pxJRRJULZU/KgiY/JKW88O91iy9n6DMZNk=;
        b=e9xe9/u+uhOsup6efBvUPDAQjH3TXJVW9N6mW09Y+KszxOXo9MsyV6MOnjYr6+Nkye
         lS9PnDSHgJ/ZWgpGPB28TZ9frqZb5lYCn2qbrYp5sP0BSaw9AXiTuxQERn68WVKxUih3
         dyAUvsD7nsLy/Hq/9lfQy9LJU4gJPGfRLmwJM91j8Lx5uq/WzCHP5UW5x5agKqh6ZcGG
         6KYKTU8FoGflYzeg242ZowTDjke3ixSe62Gm69AMdYRF+jlP4PyNdyyEuf9BLPolm5x/
         cvcWxun6nYexgeMP5lk2/9jCxVww3r664ewj6wDkTHasS7CNu7PiHvIbAGcxdpBo7cHa
         BJFw==
X-Gm-Message-State: AOJu0YwsDx5Nr02I2ThOGbrcs0M+UyUEa9m9tdMKp5pGAfdrffZ2uKXr
	bTUNneUyusULlAimj1D46IqxzNxq6kSIvYUOkFHD6Ao0ZteOsyYYd4E+hzC0Qks+mhtoF8aUYMS
	cAIMndCpwpvr5eehzoyqH9EEenSg=
X-Google-Smtp-Source: AGHT+IFy88UMTNIihfbBtvw2O6u9p6rxrslNPJ0ntmSTa0SUBtge+rqmWJcg6bh3kRfamb5kFDqk/TGnZdrY5oErOwA=
X-Received: by 2002:a2e:bd0c:0:b0:2fa:cdac:8732 with SMTP id
 38308e7fff4ca-2ff606db2d4mr92403621fa.30.1731949750796; Mon, 18 Nov 2024
 09:09:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118153516.48676-1-pc@manguebit.com> <20241118153516.48676-3-pc@manguebit.com>
In-Reply-To: <20241118153516.48676-3-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 18 Nov 2024 11:08:42 -0600
Message-ID: <CAH2r5mueythTtWNcgaduN1=CW3gt+xQc2mY=naYEn_mmKY2vMg@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb: client: handle max length for SMB symlinks
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Presumably a symlink could be up to PATH_MAX (4096), is there any
reason not to fix the client side to be able to handle at least 4096?

Any ideas how common long symlink target paths are?

On Mon, Nov 18, 2024 at 9:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> We can't use PATH_MAX for SMB symlinks because
>
>   (1) Windows Server will fail FSCTL_SET_REPARSE_POINT with
>       STATUS_IO_REPARSE_DATA_INVALID when input buffer is larger than
>       16K, as specified in MS-FSA 2.1.5.10.37.
>
>   (2) The client won't be able to parse large SMB responses that
>       includes SMB symlink path within SMB2_CREATE or SMB2_IOCTL
>       responses.
>
> Fix this by defining a maximum length value (4060) for SMB symlinks
> that both client and server can handle.
>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/reparse.c | 5 ++++-
>  fs/smb/client/reparse.h | 2 ++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 74abbdf5026c..90da1e2b6217 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -35,6 +35,9 @@ int smb2_create_reparse_symlink(const unsigned int xid,=
 struct inode *inode,
>         u16 len, plen;
>         int rc =3D 0;
>
> +       if (strlen(symname) > REPARSE_SYM_PATH_MAX)
> +               return -ENAMETOOLONG;
> +
>         sym =3D kstrdup(symname, GFP_KERNEL);
>         if (!sym)
>                 return -ENOMEM;
> @@ -64,7 +67,7 @@ int smb2_create_reparse_symlink(const unsigned int xid,=
 struct inode *inode,
>         if (rc < 0)
>                 goto out;
>
> -       plen =3D 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
> +       plen =3D 2 * UniStrnlen((wchar_t *)path, REPARSE_SYM_PATH_MAX);
>         len =3D sizeof(*buf) + plen * 2;
>         buf =3D kzalloc(len, GFP_KERNEL);
>         if (!buf) {
> diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
> index 158e7b7aae64..2a9f4f9f79de 100644
> --- a/fs/smb/client/reparse.h
> +++ b/fs/smb/client/reparse.h
> @@ -12,6 +12,8 @@
>  #include "fs_context.h"
>  #include "cifsglob.h"
>
> +#define REPARSE_SYM_PATH_MAX 4060
> +
>  /*
>   * Used only by cifs.ko to ignore reparse points from files when client =
or
>   * server doesn't support FSCTL_GET_REPARSE_POINT.
> --
> 2.47.0
>


--=20
Thanks,

Steve
