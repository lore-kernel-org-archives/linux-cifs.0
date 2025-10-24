Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83753090CD
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 09:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761298023; cv=none; b=jgpUBqUhWoSyZjoCNSUCoxnxWnghLieEopP4cBBU/J8Mop8P5vflgskcw4+VjxYaUIJKOWouC1DcpPvGfSuaYqznaYPHMPco9X+jyIJRor09dUFoBzWFsDgA9/dxwIU3xZC2EcurPhj5cGZ9a+QHoyMG1aAfxr3pmRU905cxvNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761298023; c=relaxed/simple;
	bh=0UM13nhtH7kbqzISQ9hbZarJuvA7D7pFzANkPQzqWro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uf7tQ+MushWHI0uJufjWJ4pzsVj8ovlCaTBnYgQyk4wCWNt+1y7xQ4WHW+w5JMuJgo+sxuc5Ipu4jMyZoyWZXEDa/x576pZKoevp3tV9/xPBdiuwIy7uxes+htPYPu2kksqmxPe/YOvcMxdJUyrQgckzIYRRGJ3vIvbkgOI32ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D25MtTv3; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D25MtTv3"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-63e1e1bf882so1777308d50.1
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761298018; x=1761902818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNNoqoRzDIwftY7XY1gASFIIJZdqCK/aeWRWrrUplAQ=;
        b=D25MtTv3NXYoEdoG0WmHcqZhtT7meK9mKchThGpCHogfCLNcW4yoCEn6FR0IbIY9ma
         6Gbwm2TIH0ogfREiYUB3ws9B8zfr55Wuh52q08CMMCg3ZwSWujaB6ADWd9IX7ol735xi
         lYgaycexog3YQ+Ks8gD3QxG2htnT2ylP+rS8W3JzwhYbBsvXn1C5gxpTOr/1CtRw3J9Z
         JNXrBxYMEiaKsviDwO8fbYtYKgGnU1PpKroY1rB5cye2N3Ye3hoP8w+lFDj/0O1zj6RD
         INXet/RnYSVMo77+nBaJAKvL4S2/Nukn4zEgImdGkJWtgvpmXiigB7ZzuTkdbzRqM6mV
         GAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761298018; x=1761902818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNNoqoRzDIwftY7XY1gASFIIJZdqCK/aeWRWrrUplAQ=;
        b=CLje0jxuFFhrLQwyV5E1TVrTZ7ztyKcsGHeft7gS6ymU5V6ZxwG9Tc87oYggAOia7O
         LBgDUuJX7+a23iXLW2r1x0WcQDDhoIpVVg0Vyep/wsQoKbJRPm3IR+mlGIADsciSYAdH
         Pp6kuYGQ1Hcoo0CVq7b7K7Gvfs0Qs6yXfjijby5tJg9wcb1/yuZSB7ojvmj+lfAGw6mb
         c1kQoHH7VFrrjLDK/oEqkrSxK124P/t/Fv8rfncPJtXG2TkTcLwVsda4NmmDCRB0lWlz
         WtzjP1hTRb1LUf7X4qrteMqI0q9mL92Z5G1T8tXSgPPHReqb1YYKZbCUCCQ+3TA8Vhmm
         O7UA==
X-Gm-Message-State: AOJu0Yz5bpOndLzRvl+Y2QtEtTVXA9BOefWqluOohRYZ6LpbDh7PjkfH
	siDW1uGpO1O8zcy+cI96jiYpNSpyFe7drGwpqwAklYeubDUU3JJ4/c0Wudoli2TYyuyyPLIqqw0
	sfqbOwJCGKKKx2LfDFxrKsk34A7JWDHk=
X-Gm-Gg: ASbGncuMiBzuHN89ePL7jxGpB0QzZkQJPiK90yWr9Jn9JF4347FxyqCxpj5+wMBYrh+
	FRuaMovU5W9OjYQEiWTpASVrdCLx70w20m4PnKbwwjSZLyoZhIYzsRVyTwEIZeUZAXF2IVgFM9F
	URK68ItRT1Ho6ngfxoG0BIrjVyD+x4mJQ5ok+WfJCNYiOnJIOKrz/Tz6gHsCv6DbjI7YEULl7J1
	4HpPDyWqovd1/zEwQ8UE4iRoRp9633Vjm+DU1mB7C2Lt3bV5+GaD0nfVQr8
X-Google-Smtp-Source: AGHT+IGbFusj6kw0ZBN7Rj8t8QD5HuDIGo5YUqCv7EU4QHtGcRHA8lvHb9XTL4hNsNHfZ5vdy8WpeeVQRpShygumYnA=
X-Received: by 2002:a05:690c:6501:b0:781:f32:4acb with SMTP id
 00721157ae682-7836d392524mr424858737b3.68.1761298018575; Fri, 24 Oct 2025
 02:26:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007174304.1755251-1-ematsumiya@suse.de> <20251007174304.1755251-16-ematsumiya@suse.de>
In-Reply-To: <20251007174304.1755251-16-ematsumiya@suse.de>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 24 Oct 2025 02:26:47 -0700
X-Gm-Features: AS18NWCZ1X1azBFMmOf8Yj3NvZt07h_RLa0PXTiIKE9qzeTtSXYcIx9Jfcave6U
Message-ID: <CAGypqWyGNiB5zFf2Lo_qhfBp1vdvf_FQnmOJLpaCwNu88sWJ-g@mail.gmail.com>
Subject: Re: [PATCH v2 15/20] smb: client: remove cached_dirent->fattr
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 7, 2025 at 10:44=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Replace with ->unique_id and ->dtype -- the only fields used from
> cifs_fattr.
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cached_dir.h | 6 ++++--
>  fs/smb/client/readdir.c    | 9 ++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index de1231bdb0d9..86a1a927a521 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -8,13 +8,15 @@
>  #ifndef _CACHED_DIR_H
>  #define _CACHED_DIR_H
>
> -
>  struct cached_dirent {
>         struct list_head entry;
>         char *name;
>         int namelen;
>         loff_t pos;
> -       struct cifs_fattr fattr;
> +
> +       /* filled from cifs_fattr */
> +       u64 unique_id;
> +       unsigned int dtype;
>  };
>
>  struct cached_dirents {
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index 32dcbb702b14..96b5074d72a5 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -850,9 +850,7 @@ static bool emit_cached_dirents(struct cached_dirents=
 *cde,
>                  * initial scan.
>                  */
>                 ctx->pos =3D dirent->pos;
> -               rc =3D dir_emit(ctx, dirent->name, dirent->namelen,
> -                             dirent->fattr.cf_uniqueid,
> -                             dirent->fattr.cf_dtype);
> +               rc =3D dir_emit(ctx, dirent->name, dirent->namelen, diren=
t->unique_id, dirent->dtype);
>                 if (!rc)
>                         return rc;
>                 ctx->pos++;
> @@ -905,9 +903,10 @@ static bool add_cached_dirent(struct cached_dirents =
*cde,
>                 cde->is_failed =3D 1;
>                 return false;
>         }
> -       de->pos =3D ctx->pos;
>
> -       memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
> +       de->pos =3D ctx->pos;
> +       de->unique_id =3D fattr->cf_uniqueid;
> +       de->dtype =3D fattr->cf_dtype;
>
>         list_add_tail(&de->entry, &cde->entries);
>         /* update accounting */
> --
> 2.51.0
>
>

Looks good to me.

-Bharath
