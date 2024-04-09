Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2184D4C85
	for <linux-cifs@vger.kernel.org>; Tue,  9 Apr 2024 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712681523; cv=none; b=AkJgY3R79GaqyiwDE/5HSc6P2SayZ+yfB/SaZjLtJSDh4hzOwxoSOCW+lSDmrjM8UmJERQ8E31K1ktJq9mRTDtOmlUyMLlZvbyYRp5OQP6hejKT5iqg/Nrm0/CIPMTJPzr6xHGtsw/GZvQm4sypQmnKMOn4Ayxyq+b+ufBFOxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712681523; c=relaxed/simple;
	bh=grMBNPO9f9WSoNT7wervwGiqn+I26bQLILQ1Nj1gf98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZtmHZ5IfMNvidCC5OC6PIsSASZ13UF1lj2MNJYFzDtPovmPyzZebHGvmoefS/gcVMQzE6E6wKU2hXFeWUyVbmKhPo+NvkWghPR4O1hUaXntDiKW6FIm6icMxaXh/aEYObBPSDAdDVMbq7zvyvgVSxqOYt7CzVgd3LtLxsWM1gpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lBlDgMwh; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lBlDgMwh"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-516d68d7a8bso3900212e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2024 09:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712681520; x=1713286320; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ja07TcEUvN8V5fkQFPx6Jkg9vDtMUCdnASObX4g+5U4=;
        b=lBlDgMwheUNvdd4A89TkPXLgvtLTS2oZK3Ygkb6MVujD7jwwvCrdNHHWcXOxXrBCdk
         WijvtybMap+dSJ4fR4DJfvNI22123plA2g3n1xAhZacR6yPnVZxIQGscDKJN7q2NbO/5
         VzOgxT1QTfqtStVxY1vs3I/yWj367YAvGG5gAT/DI8Y8pG4J7rib2HSX9NNNpfwWI/XK
         pElJCyHDTYflYwQDzCuMZH97E1VRs0x6e2FVzdSVjfhvUZPkSZ5ItH4yV/ALxvMQp6gg
         ft9sExL6adV/R067IRZjAyObiL2YlR7kB127cazXl9lURJlAYRmq2anloT01BLSVVpXZ
         E1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712681520; x=1713286320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ja07TcEUvN8V5fkQFPx6Jkg9vDtMUCdnASObX4g+5U4=;
        b=I000gDfAE91CGNttkRfrJKy3n1Kprc6AnLI0Di6+ztGy3xtVGmt3pPk71sFTdBT7Cq
         eDLt3MLrC2mdZo2zXiUg0FSoLIdGg/zQnBu9xS5p1ELcnfdPBzP7kVnb7tt/I+lUkRkI
         CCNdhbr9SqmvRw24AslH1h3FP4G6owMGGIltjnt1fjtxX332DP2R31CXHehzaF6GYDdF
         JbsqUraWNxvLYtO8fkoSkVmwmRLh2x3R9Uaur1Zyj223fy9+3tNulTyitmxAFMXuqhws
         3zMjJTXINBKNPW46vVBDJ2jyq1FFYMzep86erMYQpBdCjBifUVvRq0cAZA99LgYX3+WI
         likA==
X-Gm-Message-State: AOJu0Yz1Py9ceTcfaTjkzyRJSC/OmXKrVql1+LMzVa9akaBeC4hGd9Lv
	p169ZEBYs/Hhqnkc9UmrRMlesouPpBwOd3Jq4Qx/46A83XELkE77rWf6yoVlONTiloTN/bvdsUV
	Jg2bAIikX/fXcc8rzkQiXTaP6IS99aEPd
X-Google-Smtp-Source: AGHT+IG5sVh+xA/xLVQ8hqqn9gY7gJL2bwHmCVag0+X+jkK04Q1BTe9ihdTan6JNcSe6X1s+NkQzAR9EDbFcSIaBqmg=
X-Received: by 2002:ac2:5b89:0:b0:513:ec32:aa8c with SMTP id
 o9-20020ac25b89000000b00513ec32aa8cmr70177lfn.5.1712681519847; Tue, 09 Apr
 2024 09:51:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240409142859.789709-1-pc@manguebit.com>
In-Reply-To: <20240409142859.789709-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 9 Apr 2024 11:51:48 -0500
Message-ID: <CAH2r5mt28gOK-HkE6DfTq6RwhNksPz9K7n6kfgdCQ3hvQgRWVg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: instantiate when creating SFU files
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, roberto.sassu@huawei.com, 
	viro@zeniv.linux.org.uk, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated commit description with details of the repro scenario and
added to cifs-2.6.git for-next

On Tue, Apr 9, 2024 at 9:29=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> In cifs_sfu_make_node(), on success, instantiate rather than leave it
> with dentry unhashed negative to support callers that expect mknod(2)
> to always instantiate.
>
> Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" m=
ount option")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2ops.c | 94 ++++++++++++++++++++++++-----------------
>  1 file changed, 55 insertions(+), 39 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index b156eefa75d7..78c94d0350fe 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4964,68 +4964,84 @@ static int smb2_next_header(struct TCP_Server_Inf=
o *server, char *buf,
>         return 0;
>  }
>
> -int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> -                      struct dentry *dentry, struct cifs_tcon *tcon,
> -                      const char *full_path, umode_t mode, dev_t dev)
> +static int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> +                               struct dentry *dentry, struct cifs_tcon *=
tcon,
> +                               const char *full_path, umode_t mode, dev_=
t dev)
>  {
> -       struct cifs_open_info_data buf =3D {};
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         struct cifs_open_parms oparms;
>         struct cifs_io_parms io_parms =3D {};
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
>         struct cifs_fid fid;
>         unsigned int bytes_written;
> -       struct win_dev *pdev;
> +       struct win_dev pdev =3D {};
>         struct kvec iov[2];
>         __u32 oplock =3D server->oplocks ? REQ_OPLOCK : 0;
>         int rc;
>
> -       if (!S_ISCHR(mode) && !S_ISBLK(mode) && !S_ISFIFO(mode))
> +       switch (mode & S_IFMT) {
> +       case S_IFCHR:
> +               strscpy(pdev.type, "IntxCHR");
> +               pdev.major =3D cpu_to_le64(MAJOR(dev));
> +               pdev.minor =3D cpu_to_le64(MINOR(dev));
> +               break;
> +       case S_IFBLK:
> +               strscpy(pdev.type, "IntxBLK");
> +               pdev.major =3D cpu_to_le64(MAJOR(dev));
> +               pdev.minor =3D cpu_to_le64(MINOR(dev));
> +               break;
> +       case S_IFIFO:
> +               strscpy(pdev.type, "LnxFIFO");
> +               break;
> +       default:
>                 return -EPERM;
> +       }
>
> -       oparms =3D (struct cifs_open_parms) {
> -               .tcon =3D tcon,
> -               .cifs_sb =3D cifs_sb,
> -               .desired_access =3D GENERIC_WRITE,
> -               .create_options =3D cifs_create_options(cifs_sb, CREATE_N=
OT_DIR |
> -                                                     CREATE_OPTION_SPECI=
AL),
> -               .disposition =3D FILE_CREATE,
> -               .path =3D full_path,
> -               .fid =3D &fid,
> -       };
> +       oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, GENERIC_WRITE,
> +                            FILE_CREATE, CREATE_NOT_DIR |
> +                            CREATE_OPTION_SPECIAL, ACL_NO_MODE);
> +       oparms.fid =3D &fid;
>
> -       rc =3D server->ops->open(xid, &oparms, &oplock, &buf);
> +       rc =3D server->ops->open(xid, &oparms, &oplock, NULL);
>         if (rc)
>                 return rc;
>
> -       /*
> -        * BB Do not bother to decode buf since no local inode yet to put
> -        * timestamps in, but we can reuse it safely.
> -        */
> -       pdev =3D (struct win_dev *)&buf.fi;
>         io_parms.pid =3D current->tgid;
>         io_parms.tcon =3D tcon;
> -       io_parms.length =3D sizeof(*pdev);
> -       iov[1].iov_base =3D pdev;
> -       iov[1].iov_len =3D sizeof(*pdev);
> -       if (S_ISCHR(mode)) {
> -               memcpy(pdev->type, "IntxCHR", 8);
> -               pdev->major =3D cpu_to_le64(MAJOR(dev));
> -               pdev->minor =3D cpu_to_le64(MINOR(dev));
> -       } else if (S_ISBLK(mode)) {
> -               memcpy(pdev->type, "IntxBLK", 8);
> -               pdev->major =3D cpu_to_le64(MAJOR(dev));
> -               pdev->minor =3D cpu_to_le64(MINOR(dev));
> -       } else if (S_ISFIFO(mode)) {
> -               memcpy(pdev->type, "LnxFIFO", 8);
> -       }
> +       io_parms.length =3D sizeof(pdev);
> +       iov[1].iov_base =3D &pdev;
> +       iov[1].iov_len =3D sizeof(pdev);
>
>         rc =3D server->ops->sync_write(xid, &fid, &io_parms,
>                                      &bytes_written, iov, 1);
>         server->ops->close(xid, tcon, &fid);
> -       d_drop(dentry);
> -       /* FIXME: add code here to set EAs */
> -       cifs_free_open_info(&buf);
> +       return rc;
> +}
> +
> +int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> +                      struct dentry *dentry, struct cifs_tcon *tcon,
> +                      const char *full_path, umode_t mode, dev_t dev)
> +{
> +       struct inode *new =3D NULL;
> +       int rc;
> +
> +       rc =3D __cifs_sfu_make_node(xid, inode, dentry, tcon,
> +                                 full_path, mode, dev);
> +       if (rc)
> +               return rc;
> +
> +       if (tcon->posix_extensions) {
> +               rc =3D smb311_posix_get_inode_info(&new, full_path, NULL,
> +                                                inode->i_sb, xid);
> +       } else if (tcon->unix_ext) {
> +               rc =3D cifs_get_inode_info_unix(&new, full_path,
> +                                             inode->i_sb, xid);
> +       } else {
> +               rc =3D cifs_get_inode_info(&new, full_path, NULL,
> +                                        inode->i_sb, xid, NULL);
> +       }
> +       if (!rc)
> +               d_instantiate(dentry, new);
>         return rc;
>  }
>
> --
> 2.44.0
>


--=20
Thanks,

Steve
