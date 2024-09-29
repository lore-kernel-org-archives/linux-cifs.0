Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14F92B9B7;
	Sun, 29 Sep 2024 21:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727644620; cv=none; b=SWAdLi2CgrgNThccck2WrLyPnslH8rqUXx1pap5qMZkPC7cv+KZ6aYKu7BUJfW/5eISfqSfef/g8PKOuKA+TjC2qC0nhmZSz2lPEwTuJBh6pyC5NgIeWnUkFbRTpdhfJQEH9gz1ztMU2vWc5KbvKFY+cHA3wx4FPnwmf++mBHPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727644620; c=relaxed/simple;
	bh=JuBUTNioYcPLimVNyZOPJ1ABpcfG1Unw0fROrPKHPXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=af7V9JkTIRWV4cn4H75KDVkxR3Klv0/XPIie2SGQJhjW3g82QLL3tn+gR62pzOv+foOfcnLLtYR09haAmzTI+oIrX5XskoUna/vLNAQedeF1y9tr9oSFmcgRV42aLdQy5W/sygxrhkwp10Zu2YZL+fGU0J+LQ9pzvx5fwyXxiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OF7ivdxU; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OF7ivdxU"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2fad0f66d49so1013421fa.3;
        Sun, 29 Sep 2024 14:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727644617; x=1728249417; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUefBKmsZjXQ/mUhjIMzhcAvL7NFQX6GDQCKTISAmJY=;
        b=OF7ivdxUvBIp+emyZ4PcssbMI5UvmPVwMU2oFnp4Gx4qqM0bV+8kOZ+WVEf3ylvP8N
         hoPda7GNqlecgAl0pQE9TWg5P0zf9GZssklMiBUkCDyD4y+De8+JiJnQAAUMos9Sbl6J
         eW1RG05k3rboMJ1nH0+XI9tS/s8KfsEe09+HcDvpmLpr1KU7I381sc2r1NUY9ZkJIHOg
         tQBYsw3umDQMcc0OuyonlojzBSw9MiXT0Svc+Lj8c+2mm7IhSjtjGZLiJHPBoy3i0IMZ
         qYA3JIcE2g8QtGfEXwRFpxio3cyoePeuLgz0Sp7FGjHRdtUpm+8iA39Pie4BZCnK/SNI
         BCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727644617; x=1728249417;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUefBKmsZjXQ/mUhjIMzhcAvL7NFQX6GDQCKTISAmJY=;
        b=tkVIXRAjSYBCzPpdlAkzkpwuEHbgL2LyJliEeY0cnASH8HyoQrBs8DXERbO3C4p0QG
         Nk34flybjrLjpspfvGReMU56jgKIlT2HJrZEmxQewkP92YPOTt2cKR87glB1hs+QoNXe
         1v5bI9o0AI7UkxeC5TAXsLaUTVETd0rUxeKpNOzgatxAt1/NVAWBphNPHoRYuuf3xxIw
         AnYuObIo0se/XXJ+ff3xegmowBS3HpB4G4qawSMFy7CaWXp+LbF/TwNvwFQkX6nnJHVu
         u/itjExlNFn3DncrkhPuwQ1avnaHjEifVC8g1RDiRcs7sqKAVa68ibQ+Rz8YXYvZeZFF
         beYg==
X-Forwarded-Encrypted: i=1; AJvYcCUaQkfPoUnWi3E720sTg4SwmJjb+reGKstrKaR1v60qlobrh7fMjrvI18SDojuwF1T5LxF7jpn4RxeZWby/@vger.kernel.org, AJvYcCW3nubOhCeFAgbvKfsDY6F+n8dCv0LWuZgveXan8HESdH5PqxlnItaMXS9dr2UfhBXA6NNCh3fgR321@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1pYzGOTmOB/X2NH0B+iBTg07dpJeuWpsBU5L4KNNU+VAB5Ofd
	LH3mDAAWz6OpIwarpgtSWaQfk7TuCkDqkHjkGsaNXE0OjGFqRe19BTnGm9ZgE5IGb/MoaXEl6/W
	kphzCmRtxCNDhTTC66kzmC6Iw3ZY=
X-Google-Smtp-Source: AGHT+IFhztiBkAoR0MNZ+YeVnE6y7U6FdB1WzwhGAQjxzhSjm+Rh15uzre99U+T6lbNoGuIDfcuIqvDKvXy7nWp3USI=
X-Received: by 2002:a05:6512:33c5:b0:533:40dc:823e with SMTP id
 2adb3069b0e04-5389fc64568mr5063065e87.48.1727644616669; Sun, 29 Sep 2024
 14:16:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org> <20240929185053.10554-2-pali@kernel.org>
In-Reply-To: <20240929185053.10554-2-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 16:16:44 -0500
Message-ID: <CAH2r5mt71ybdLj-9X=v_tuzaLbjGtQgPJvmNvcdZqLPzYpOJhA@mail.gmail.com>
Subject: Re: [PATCH 1/7] cifs: Rename smb2_get_reparse_inode to smb2_create_reparse_inode
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I lean against minor renames in rc2, better to focus on the bug fixes
in your patch (the renaming also makes it a bit harder to backport
fixes, so often better after all the fixes in, if important rename)

On Sun, Sep 29, 2024 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> This function creates a new reparse point, so put "create" into its name.
>
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
>  fs/smb/client/reparse.c   | 6 +++---
>  fs/smb/client/smb2inode.c | 2 +-
>  fs/smb/client/smb2proto.h | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
> index a23ea2f78c09..507e17244ed3 100644
> --- a/fs/smb/client/reparse.c
> +++ b/fs/smb/client/reparse.c
> @@ -68,7 +68,7 @@ int smb2_create_reparse_symlink(const unsigned int xid,=
 struct inode *inode,
>         convert_delimiter(sym, '/');
>         iov.iov_base =3D buf;
>         iov.iov_len =3D len;
> -       new =3D smb2_get_reparse_inode(&data, inode->i_sb, xid,
> +       new =3D smb2_create_reparse_inode(&data, inode->i_sb, xid,
>                                      tcon, full_path, &iov, NULL);
>         if (!IS_ERR(new))
>                 d_instantiate(dentry, new);
> @@ -136,7 +136,7 @@ static int mknod_nfs(unsigned int xid, struct inode *=
inode,
>                 .reparse =3D { .tag =3D IO_REPARSE_TAG_NFS, .nfs =3D p, }=
,
>         };
>
> -       new =3D smb2_get_reparse_inode(&data, inode->i_sb, xid,
> +       new =3D smb2_create_reparse_inode(&data, inode->i_sb, xid,
>                                      tcon, full_path, &iov, NULL);
>         if (!IS_ERR(new))
>                 d_instantiate(dentry, new);
> @@ -282,7 +282,7 @@ static int mknod_wsl(unsigned int xid, struct inode *=
inode,
>         memcpy(data.wsl.eas, &cc->ea, len);
>         data.wsl.eas_len =3D len;
>
> -       new =3D smb2_get_reparse_inode(&data, inode->i_sb,
> +       new =3D smb2_create_reparse_inode(&data, inode->i_sb,
>                                      xid, tcon, full_path,
>                                      &reparse_iov, &xattr_iov);
>         if (!IS_ERR(new))
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 6e69a3b98be3..0fc73035d6dc 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1193,7 +1193,7 @@ smb2_set_file_info(struct inode *inode, const char =
*full_path,
>         return rc;
>  }
>
> -struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> +struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data=
,
>                                      struct super_block *sb,
>                                      const unsigned int xid,
>                                      struct cifs_tcon *tcon,
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index b208232b12a2..4ac30d29d5a1 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -56,7 +56,7 @@ extern int smb3_handle_read_data(struct TCP_Server_Info=
 *server,
>  extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tc=
on *tcon,
>                                 struct cifs_sb_info *cifs_sb, const char =
*path,
>                                 __u32 *reparse_tag);
> -struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
> +struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data=
,
>                                      struct super_block *sb,
>                                      const unsigned int xid,
>                                      struct cifs_tcon *tcon,
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
