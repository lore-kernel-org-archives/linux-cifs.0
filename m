Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA3C1304B0;
	Sun, 29 Sep 2024 21:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727646483; cv=none; b=aw8tCfn0GoMofHdlgxpp/tc4QjumqYvygjVIhiw09mBqDvthIFV3M/L//0g82aCbgdJpXIL5YI7OBAqRhY/F/AhSDbungCJ2TBRwvevtgDUSz1KX4qFDtS5+z4E44ABU321CDCrtxgu4uQGz9Tk8M0FTt5qAOUht3d7K/J5iFVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727646483; c=relaxed/simple;
	bh=vJNw4C0ImdXNyd6MebebYyAzxTn0xdRo1UvGrrFCeHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C9p9uD6lTminAVFc7gFS21AZKbZcAln6+a012CC+YEaDaxf8SWDE2xaZjXcCDcdpY1WZYIsA71BGsaCaL4t43xncc/znHkNsxiy6xcGfFiO0cdCZJQhJpr/ShZyhtwUSrqMbmqKIcWlvMUVVgEREECQ4gcm4WDvFK5lj3wvg+MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PVTkwKxu; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PVTkwKxu"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53988c54ec8so2349276e87.0;
        Sun, 29 Sep 2024 14:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727646480; x=1728251280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKcPM+XgnSOCOlXiyAt/x0t4A1hlRxmsWur1NvKdBrw=;
        b=PVTkwKxuzQdrNRST54PVEcrtHffk2gdxl4vU++EQ64CiwG6yzV3Whwzpz8OyGCtpnZ
         ZExdzl4bmziJlPIurUZYHd6jTszneks0PChLrMavUkmW21XH66TYtZgscabqPmHPdchA
         U+PlvGrv1xkS+DTXGMY4LY3iTTYkRNRGYfqbQ5arY/AhIYVBZiSlV/dRQ/QVKDvKvN4Z
         GOgXhkQGfGiiEd2Y7iPwxSlBRtaHn84l8zG2EXA1gygLTng5jDmQiK9+7/L3CzvlMC7Q
         i7qn9ndddEq/PsrPKF1tk+E0lWIYRfxc1i8wxJXcr5vvnY7KMrYgblsbzITGT7i1esof
         bD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727646480; x=1728251280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKcPM+XgnSOCOlXiyAt/x0t4A1hlRxmsWur1NvKdBrw=;
        b=VLhGWzwreC+wOyueRR/rRBreGD/1t1UFmWKwGocOD39T6GHrPWY+3o3CcMn4H/91BL
         cSTFWB7CNRLi7ya5W6BDr/XzX0VKzuY+oiUaVRyeG8bU3P0X0qRTTbREyGSH4LdJRt29
         hStqALD/sRsQmHqb71G+mPUDI32jzOh1VRIj37sCPlwDHvtmGBPlIgo4Jejo8ZevonCv
         3ENVVIvCtsgu/JC2u7SdcVZmgCmu97iVZO8jaL8Bw+4YGVTILoE0AcUD67ODhV8gXvPQ
         vugVHsnoQelVkws3lZJqrl680aXTj7l35+1bLoN4ir9l9kb8yrEuqE5mszRhIZrQI9rg
         l8fg==
X-Forwarded-Encrypted: i=1; AJvYcCUXBzEUPd407QspJXVB5b41KeWwpmKEjgG/spiPKXROYSirWEyciwYkeans9MTwUTIk/mJ/usJzNInGjVWk@vger.kernel.org, AJvYcCWBlS2T81aYuziWBA0LvhRk9L8mrNLwSq+6bmPBKm+UyyTKcd/vxea6HHmqiE20qPpZ6dOjqMvcJs9Z@vger.kernel.org
X-Gm-Message-State: AOJu0YxFNcJXNQNBfxdBiypOHAJ6MTQ4gdSRlmr0ERl073ul2UZIA6TH
	g54fgf81SBvyzjpGaMstzvk4DfjaphnpE131mRSjwfqrHrmmOapXriyDRGPfskb1tSLkTJpZLF8
	U6X6Z/FR6KmpP7WExT1w0p40h7Rc=
X-Google-Smtp-Source: AGHT+IEern+aT43RFEJL1z9TGpzvHYgFqhvQWZoVDhAONw6iVnoeJfrFdotkdGUQOgBbgSrlLyXz2gMca3i3nWDT7KA=
X-Received: by 2002:a05:6512:1293:b0:535:82eb:21d1 with SMTP id
 2adb3069b0e04-5389fc8422bmr4976133e87.57.1727646479442; Sun, 29 Sep 2024
 14:47:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20240929185053.10554-6-pali@kernel.org>
In-Reply-To: <20240929185053.10554-6-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 16:47:48 -0500
Message-ID: <CAH2r5mu6Uikd+72DVjKs9A10xn4yy3Db7ZftC_W_9jWTZ_W0SA@mail.gmail.com>
Subject: Re: [PATCH 5/7] cifs: Fix parsing native symlinks directory/file type
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

obvious question is ... is there any risk that this could break POSIX
behavior when creating server side symlinks (ie not using mfsylmlinks,
but native symlink reparse point) remotely ...?

On Sun, Sep 29, 2024 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> As SMB protocol distinguish between symlink to directory and symlink to
> file, add some mechanism to disallow resolving incompatible types.
>
> When SMB symlink is of the directory type, ensure that its target path en=
ds
> with slash. This forces Linux to not allow resolving such symlink to file=
.
>
> And when SMB symlink is of the file type and its target path ends with
> slash then returns an error as such symlink is unresolvable. Such symlink
> always points to invalid location as file cannot end with slash.
>
> This mimics Windows behavior of native SMB symlinks.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c   |  4 ++++
>  fs/smb/client/smb2file.c  | 46 +++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb2inode.c |  4 ++++
>  fs/smb/client/smb2proto.h |  1 +
>  4 files changed, 55 insertions(+)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index d8edb513556f..5a738f65b190 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -589,6 +589,10 @@ static int parse_reparse_symlink(struct reparse_syml=
ink_data_buffer *sym,
>                                        le32_to_cpu(sym->Flags) & SYMLINK_=
FLAG_RELATIVE,
>                                        full_path,
>                                        cifs_sb);
> +       if (!rc) {
> +               bool directory =3D le32_to_cpu(data->fi.Attributes) & ATT=
R_DIRECTORY;
> +               rc =3D smb2_fix_symlink_target_type(&data->symlink_target=
, directory);
> +       }
>         return rc;
>  }
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index dc52995f5591..8a1a1b2a1c81 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -63,6 +63,48 @@ static struct smb2_symlink_err_rsp *symlink_data(const=
 struct kvec *iov)
>         return sym;
>  }
>
> +int smb2_fix_symlink_target_type(char **target, bool directory)
> +{
> +       char *buf;
> +       int len =3D strlen(*target);
> +
> +       if (!len)
> +               return -EIO;
> +
> +       /*
> +        * If this is directory symlink and it does not have trailing sla=
sh then
> +        * append it. Trailing slash simulates Windows/SMB behavior which=
 do not
> +        * allow resolving directory symlink to file.
> +        */
> +       if (directory && (*target)[len-1] !=3D '/') {
> +               buf =3D kzalloc(len+2, GFP_KERNEL);
> +               if (!buf)
> +                       return -ENOMEM;
> +               memcpy(buf, *target, len);
> +               buf[len] =3D '/';
> +               kfree(*target);
> +               *target =3D buf;
> +       }
> +
> +       /*
> +        * If this is a symlink which points to file name with trailing s=
lash,
> +        * or to file named "." or file named ".." then this symlink cann=
ot be
> +        * resolved on Linux because Linux does not allow files with such=
 names.
> +        * So return an error to prevent resolving this file type symlink=
 to
> +        * directory, as it do not point to directory at all.
> +        */
> +       if (!directory) {
> +               const char *basename =3D kbasename(*target);
> +               int basename_len =3D strlen(basename);
> +               if (basename_len =3D=3D 0 || /* symname ends with slash *=
/
> +                   (basename_len =3D=3D 1 && basename[0] =3D=3D '.') || =
/* last component is "." */
> +                   (basename_len =3D=3D 2 && basename[0] =3D=3D '.' && b=
asename[1] =3D=3D '.')) /* last component is ".." */
> +                       return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
>  int smb2_parse_symlink_response(struct cifs_sb_info *cifs_sb, const stru=
ct kvec *iov,
>                                 const char *full_path, char **path)
>  {
> @@ -132,6 +174,10 @@ int smb2_open_file(const unsigned int xid, struct ci=
fs_open_parms *oparms, __u32
>                                 rc =3D SMB2_open(xid, oparms, smb2_path, =
&smb2_oplock, smb2_data,
>                                                NULL, NULL, NULL);
>                                 oparms->create_options &=3D ~OPEN_REPARSE=
_POINT;
> +                               if (!rc) {
> +                                       bool directory =3D le32_to_cpu(da=
ta->fi.Attributes) & ATTR_DIRECTORY;
> +                                       rc =3D smb2_fix_symlink_target_ty=
pe(&data->symlink_target, directory);
> +                               }
>                         }
>                 }
>         }
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index c9cdac7d2d50..faf0a8344faa 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -960,6 +960,10 @@ int smb2_query_path_info(const unsigned int xid,
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                                       &oparms, in_iov, cmds, num_cmds,
>                                       cfile, NULL, NULL, NULL);
> +               if (data->reparse.tag =3D=3D IO_REPARSE_TAG_SYMLINK && !r=
c) {
> +                       bool directory =3D le32_to_cpu(data->fi.Attribute=
s) & ATTR_DIRECTORY;
> +                       rc =3D smb2_fix_symlink_target_type(&data->symlin=
k_target, directory);
> +               }
>                 break;
>         case -EREMOTE:
>                 break;
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 11cef65fa831..d308f3c2f8df 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -113,6 +113,7 @@ extern int smb3_query_mf_symlink(unsigned int xid, st=
ruct cifs_tcon *tcon,
>                           struct cifs_sb_info *cifs_sb,
>                           const unsigned char *path, char *pbuf,
>                           unsigned int *pbytes_read);
> +int smb2_fix_symlink_target_type(char **target, bool directory);
>  int smb2_parse_native_symlink(char **target, const char *buf, unsigned i=
nt len,
>                               bool unicode, bool relative,
>                               const char *full_path,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
