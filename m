Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00372581
	for <linux-cifs@vger.kernel.org>; Fri,  1 Aug 2025 00:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754007591; cv=none; b=pAjRxXZKRSyPVdA3Ce60iY+7/zcsm73vB1IviASBKqkSP6/lrtdOsXYqmE2A+LsQFJTBs1IDutp+kNc2mALXnXH7f5XYuIXimTOpmD9NougbwAupOb6EthII8dtTos7RwoL/3EfGWdz8YbDGo1nZzgU4pw2FGHDT8KRoT8ylJ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754007591; c=relaxed/simple;
	bh=3FZSmSevX7nrQMc2B2+4cJAGVRWonAG0ljoo11YVLwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q9VegaXS5zi9ujJt6vWpysW3Kj0l2JY5d86GdqqN/MsuGKUtHBVzucdK7Puwq7PeC34DlRk3SgEuplvCIpE6LogcCYVtmO3PZRMMeoctNUTtZgst09XxP2L5Hu1fp0qxAKrgi502EuYBC6cKOxd/9g3mlP7I/yEEnpRvzhDG634=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMCymt9z; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMCymt9z"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-7077a1563b5so13071656d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754007589; x=1754612389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LD3HV3BC2Z/zDU7F7sQPUlnlSGzN/UJgazWopvqKWVc=;
        b=dMCymt9zE7twZGGElVj2FET2fUsE2ZP7XepnwmCWH6Eqtqy/iyNwNMJBkDAqy2IdWS
         v5kDT1/subs9OZabfY/V0/koeLoG3W2guNj04GF6d1GzK6zLOCSw3YnicjU0ACcsb2Bb
         kFyANShLJyjwL+vEWnApzMcw+w3NaOAQLw/sFsgeLB0aZlmTk5H3/BwJrYCMorEa8y4O
         duqTC5fFEsEWnEkjCdkeanFJ0eOU5i7d/JUDip2K1nsiZ0NNIJz51gcesMKDOCZAUIdu
         K1tgZ5zTbA9cp/EFRV/SPWAS70II7/sPHWinutG/oTpD6pMnzupraYLtpdYysJFC1TB/
         kiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754007589; x=1754612389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LD3HV3BC2Z/zDU7F7sQPUlnlSGzN/UJgazWopvqKWVc=;
        b=ujdqlCIlV8dDjq64dCMDbvN7ABZd1nPq5ZEImgkHCAIp5jEfydk96N52SwodjQrRoz
         3HlvVMNjuMtzQdlB61/DS9zT/CNDWyVrck4R4j1kGtcGGgl/DAYJQiz0B4P+arHvaYO1
         tHTYuT4TWJWZuLb7mevnb9IIthEP35Jx72ShYllToKq7O2yMuVQLRORGVjrwrhd66uuY
         MpfUYdFqG0qJGKmX+eF98GYppB1ECNJ0ghJ3Y8hKIwo5tTgix/moEckPPBybZZ6ooNzW
         qKwvhv1vtiJsWySrzgH9sQM6dxPUpNLLmZ7mLeHjF2MThi0MlBDMA1mXb0Keiarf+dsI
         mpww==
X-Gm-Message-State: AOJu0YxhBx8QT4cpFkvlIdpbuPdGARMzPVXefUDRePLoj63IlHjAm2HD
	kRpawfoljEcxPiBdQkGAefrqQYH37UgDM7dmdcy3w3r9FzX7zpa2nygjXMk+CQBz1/4QxpZ3I0k
	0wYVbaVSvG776DZy2yUd3BlPGlrv13HE=
X-Gm-Gg: ASbGncsHebNmMms8ABfycM0xDASflW382moybqn5noCtd6kULBqkHEv8NyG1NeZChNY
	gU5ieF3SEgPcgQpsXghbHwcGzQUxlbZc/7IMU7Lm0RAs+mSIT0oeBF5V4C69/D15EyWBFlt3hGt
	nWpM4XiUuLHEhNhWtgAoHAv+Tf3weoHYpgDSmGiNSpmyHMAr7q+YcbbXy9FrQR2ioeyQ7ca+y8L
	exb1IS9q1xth2FIurMtirnASqOxalRjaWiATvDH6A==
X-Google-Smtp-Source: AGHT+IEUd9yketLfd0uYYjL5hs1QdkPLxB3zENEIySp04UypfnX3bbeDKhyT/Ajuy5hd4vhFYduIVtw8MAnEhu0N2bk=
X-Received: by 2002:a05:6214:f2e:b0:704:b09a:9525 with SMTP id
 6a1803df08f44-7076718c0edmr115367746d6.29.1754007588572; Thu, 31 Jul 2025
 17:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250731234643.787785-1-pc@manguebit.org>
In-Reply-To: <20250731234643.787785-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 31 Jul 2025 19:19:37 -0500
X-Gm-Features: Ac12FXxu0yOzj5nbC72OA9gF72-uKDPOtANkVSiggkdUJJvbw72Gb2IB8Z51VZY
Message-ID: <CAH2r5ms9FPCQdxApKObaP1wJmJAY37jmso16h6jBOWQ2bZRndg@mail.gmail.com>
Subject: Re: [PATCH 1/3] smb: client: set symlink type as native for POSIX mounts
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ralph Boehme <slow@samba.org>, 
	David Howells <dhowells@redhat.com>, Matthew Richardson <m.richardson@ed.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

These three look promising, will run some tests on these now.   Any
objections to adding cc:stable for these three?

On Thu, Jul 31, 2025 at 6:46=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> SMB3.1.1 POSIX mounts require symlinks to be created natively with
> IO_REPARSE_TAG_SYMLINK reparse point.
>
> Cc: linux-cifs@vger.kernel.org
> Cc: Ralph Boehme <slow@samba.org>
> Cc: David Howells <dhowells@redhat.com>
> Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
> Closes: https://marc.info/?i=3D1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac=
.uk
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> ---
>  fs/smb/client/cifsfs.c     |  2 +-
>  fs/smb/client/fs_context.c | 18 ------------------
>  fs/smb/client/fs_context.h | 18 +++++++++++++++++-
>  fs/smb/client/link.c       | 11 +++--------
>  fs/smb/client/reparse.c    |  2 +-
>  5 files changed, 22 insertions(+), 29 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index 0a5266ecfd15..697badd0445a 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -723,7 +723,7 @@ cifs_show_options(struct seq_file *s, struct dentry *=
root)
>         else
>                 seq_puts(s, ",nativesocket");
>         seq_show_option(s, "symlink",
> -                       cifs_symlink_type_str(get_cifs_symlink_type(cifs_=
sb)));
> +                       cifs_symlink_type_str(cifs_symlink_type(cifs_sb))=
);
>
>         seq_printf(s, ",rsize=3D%u", cifs_sb->ctx->rsize);
>         seq_printf(s, ",wsize=3D%u", cifs_sb->ctx->wsize);
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 3f34bb07997b..cc8bd79ebca9 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1829,24 +1829,6 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>         return -EINVAL;
>  }
>
> -enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info *cifs_s=
b)
> -{
> -       if (cifs_sb->ctx->symlink_type =3D=3D CIFS_SYMLINK_TYPE_DEFAULT) =
{
> -               if (cifs_sb->ctx->mfsymlinks)
> -                       return CIFS_SYMLINK_TYPE_MFSYMLINKS;
> -               else if (cifs_sb->ctx->sfu_emul)
> -                       return CIFS_SYMLINK_TYPE_SFU;
> -               else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_lin=
ux_ext)
> -                       return CIFS_SYMLINK_TYPE_UNIX;
> -               else if (cifs_sb->ctx->reparse_type !=3D CIFS_REPARSE_TYP=
E_NONE)
> -                       return CIFS_SYMLINK_TYPE_NATIVE;
> -               else
> -                       return CIFS_SYMLINK_TYPE_NONE;
> -       } else {
> -               return cifs_sb->ctx->symlink_type;
> -       }
> -}
> -
>  int smb3_init_fs_context(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx;
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 9e83302ce4b8..b0fec6b9a23b 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -341,7 +341,23 @@ struct smb3_fs_context {
>
>  extern const struct fs_parameter_spec smb3_fs_parameters[];
>
> -extern enum cifs_symlink_type get_cifs_symlink_type(struct cifs_sb_info =
*cifs_sb);
> +static inline enum cifs_symlink_type cifs_symlink_type(struct cifs_sb_in=
fo *cifs_sb)
> +{
> +       bool posix =3D cifs_sb_master_tcon(cifs_sb)->posix_extensions;
> +
> +       if (cifs_sb->ctx->symlink_type !=3D CIFS_SYMLINK_TYPE_DEFAULT)
> +               return cifs_sb->ctx->symlink_type;
> +
> +       if (cifs_sb->ctx->mfsymlinks)
> +               return CIFS_SYMLINK_TYPE_MFSYMLINKS;
> +       else if (cifs_sb->ctx->sfu_emul)
> +               return CIFS_SYMLINK_TYPE_SFU;
> +       else if (cifs_sb->ctx->linux_ext && !cifs_sb->ctx->no_linux_ext)
> +               return posix ? CIFS_SYMLINK_TYPE_NATIVE : CIFS_SYMLINK_TY=
PE_UNIX;
> +       else if (cifs_sb->ctx->reparse_type !=3D CIFS_REPARSE_TYPE_NONE)
> +               return CIFS_SYMLINK_TYPE_NATIVE;
> +       return CIFS_SYMLINK_TYPE_NONE;
> +}
>
>  extern int smb3_init_fs_context(struct fs_context *fc);
>  extern void smb3_cleanup_fs_context_contents(struct smb3_fs_context *ctx=
);
> diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> index 2ecd705e9e8c..afe76367d2c8 100644
> --- a/fs/smb/client/link.c
> +++ b/fs/smb/client/link.c
> @@ -605,14 +605,7 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *=
inode,
>
>         /* BB what if DFS and this volume is on different share? BB */
>         rc =3D -EOPNOTSUPP;
> -       switch (get_cifs_symlink_type(cifs_sb)) {
> -       case CIFS_SYMLINK_TYPE_DEFAULT:
> -               /* should not happen, get_cifs_symlink_type() resolves th=
e default */
> -               break;
> -
> -       case CIFS_SYMLINK_TYPE_NONE:
> -               break;
> -
> +       switch (cifs_symlink_type(cifs_sb)) {
>         case CIFS_SYMLINK_TYPE_UNIX:
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>                 if (pTcon->unix_ext) {
> @@ -648,6 +641,8 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *i=
node,
>                         goto symlink_exit;
>                 }
>                 break;
> +       default:
> +               break;
>         }
>
>         if (rc =3D=3D 0) {
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index 33c1d970747c..7869cec58f52 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -38,7 +38,7 @@ int create_reparse_symlink(const unsigned int xid, stru=
ct inode *inode,
>                                 struct dentry *dentry, struct cifs_tcon *=
tcon,
>                                 const char *full_path, const char *symnam=
e)
>  {
> -       switch (get_cifs_symlink_type(CIFS_SB(inode->i_sb))) {
> +       switch (cifs_symlink_type(CIFS_SB(inode->i_sb))) {
>         case CIFS_SYMLINK_TYPE_NATIVE:
>                 return create_native_symlink(xid, inode, dentry, tcon, fu=
ll_path, symname);
>         case CIFS_SYMLINK_TYPE_NFS:
> --
> 2.50.1
>


--=20
Thanks,

Steve
