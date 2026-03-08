Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2FF1AA7A6
	for <linux-cifs@vger.kernel.org>; Sun,  8 Mar 2026 03:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772938928; cv=pass; b=ZYls+v747gOjOhfuUU8xjtu4pJ8B7pqLGBJb7OOsGMfepLSczKoDPuYoyhSiimqL6j62OGodgCj4yMPTGFrJJw5ivtUBxtKDSZsz0DT3bf8dNNiB/LhU8eRC1o0cLiHCnAtjJjsm+vRxJTc3ioyS08E76s+HhA7J8g+8y+Hpbgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772938928; c=relaxed/simple;
	bh=na3CEXYe5VYNa04bxP+z3EvvHcJbLcb5PIkCbRIr368=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o7nKuldePkC3x5hvaiIIpwS/S2ZwmW37FxPaoORmmcNekn/4kDio0wh1tHDQQCiRmHNBEZWGP6RaFAyXH7zKpz7rK4QE4lzovJc4cCdkVRopgJrkGL4WstNstdJNabhTZ5dBIP/2KyUORvvGFUmlP5nKWGv06+Eumz3RHvboGmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tn6/9Zo9; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tn6/9Zo9"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cd73c4a827so158615785a.3
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 19:02:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772938925; cv=none;
        d=google.com; s=arc-20240605;
        b=iXjfoTqa0aA/2FjJ6cBwZAiYshbwLm1yUGcCVap4bnaAvFPDByHqCjor0AwyUJBTDj
         r3bMDP+AtYzGWtSLI3LRjijzy1nlH2xNInHiv/U8t/TApNbIDsHwmkrw4E6LFpEYl6wN
         SnLck22AEi2bkGgm8yFl/kktMdplnJ3IJp7DFevdRTLpS1NyHT16MOGI+1/Tjbr/kgGc
         nI010UCg8E7G9CpDJhdkTmdV3xOnRqisD/AvJ+r7ZlbBl6ilaHde/vOlQS4FHQjezltU
         J8dYvIFWgaYUgZ4KRh2alqL4VpWSmDBZgwRBqDGvnEWqJm82TfY9+o27SaOBSEHYIxV1
         0U2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0b9UiayA3it40t9bJgAqpEj1p345wqtLgZz4wISOPp0=;
        fh=6DHGntIA/OeC7xgEIYYPZ+0EoWsROSj7h6+Drt1ufXg=;
        b=KCcVOAes3dX95h5PqVKqyDOQNAnAyVhKEEW2JE72iGn3j6wwQcCyuYo8d1Tduira5j
         RPe8Oy+4VZDOENKYeytxMJdcaIdlWGlmTK+0aKw3FeERnbvXEr/LJcN1Dnw79YShMxSO
         bGdyvfFwd43ZFWwCJ/RVuRL+GyKxDR6ViETF1nuc6kzNfftgvHYSbHUDOZ085BCGfbRP
         DNBXMGv8q7aLI5BOuB4uackxBI1PJPX438lFhAj1V1t4uCzzU1EhwBKeqc7wWODKmFD/
         7g40GAVKZsuPGcKPSWyxIugVym9HZXAzCiZKZXeX9TsCZM3d/IW5DsTg5i7Q10YaOUFd
         Nx4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772938925; x=1773543725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0b9UiayA3it40t9bJgAqpEj1p345wqtLgZz4wISOPp0=;
        b=Tn6/9Zo9kXHFDWfxLSJdiSPSnXFsvSiYvrFLn+88CAQUn2xSkD+U5NqoB2K8juSlpo
         cv4r9fJsJszwY4ed46YwKGYkkrjf6RpQSb371vL8goD7a6PPvzeQT0sNTD47TDbmjWkp
         prbIjUS/1dIpUXq9cg5Pi3L0O+/2qBo1QdkPqJewtByIZ0HlWirhKwK+gYmjjEfPYnH8
         Cty8YI+vgdI9atbiKXh6fRXreBlxmpgi5V+KmLMEC7amBDZf78I5QOpROCQ3MSngAwB1
         qTdUCl2AjT2X+gLrpxFdSA2z/gqsztbgtDzT+fwYhKUYHkNIS71S85+HsLA4uD/xwLdv
         ojMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772938925; x=1773543725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0b9UiayA3it40t9bJgAqpEj1p345wqtLgZz4wISOPp0=;
        b=PashjSrRmXh7Nr/yK42f+Dh6DSscedG4K+du76Ak8CVkVAC61ZYiiErcXgYpsixlPo
         8B6MilgdCACuBKyCNWrCS7Me4DXX/Y1neFtIdf0PKYYEbmuEnslG+ckSME9hxW0tfGm4
         F/fVlVfhug56Nx8K6GPyb+nfesfTQcMFL35yF30MMVZt+25TSMGM3yBeU34NT8BJFT8D
         UGCcttY0gkc5DsglvwAixxsF5UZoRTOzaWZUjJ/15XIDvDMtg24Qs9sedFZXHPXzp1Q9
         WVoO8tbTgj4yKjNDIxqY1r+DdOp1pLiLoNotAFyiOWqo81O15o7WxkpGT+NQvvqDAc77
         Rvyg==
X-Forwarded-Encrypted: i=1; AJvYcCV5C4dTg/AodUh4qFwLZ25nvG/nBNyYw6u+0/qJUK5pt8N4CGhuBjhN3YGN5UZdvGB+PwT+fRiQF2dK@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ6SimZOkgbAqXDcfJ9W7tKjby4EqjJgTgO+7Dc7lLlWkV+Wsp
	vCzWhyfjE91Lcr0DiL/Te2w2EO1qqX0h6fNmBJoU/juHAw2e2yUk0FXt3Ds1IEpY865Z/aRd5mP
	WfiDD7v1tsSHvgvPcY6CFm66m6kaIo3mKzQ==
X-Gm-Gg: ATEYQzwKf7gKbOviaJc8wMrKedteXCtNIuaDs2GuQhKK/e4xUNys5RPvFmalqZHz9AE
	s+w5cMh6d2ybKiPIRWlJBbfDyNmBCReBkTuyodNMlrsXlzuqRQXXNL26zAjYPWGbD6aZirkz1WO
	1UMi2NahG476kmEH5abWDI3vvUmXrciSaAM6IP+T9S5yICEzl53Oix0TtIgNvC/uFxyZUNr9VP0
	UVqUyPcEtmP0k5wwNUa6ABGj8S9GEZ+sGjgQtMK69ratzOlo/Y6qjDTVmuc5Jsgs4rJ7s/IMnPA
	mp7BdsuZinX4OOVKfzPeqK/PcSoNqD9SxtAsmCuQSQYd3crm/210ISEQCzunBFxwtQrR9q5FOWW
	2qbw0lFPLapjsHXoWWTPTbRlehYY0//zFbtZAuqWBA2SxqOTDFt1NPxJ528Sfbqgpv9Z/LNpy9n
	+rI240wcCfRWnDbLh5CzCxhg==
X-Received: by 2002:ad4:5e88:0:b0:89a:78c:7cf2 with SMTP id
 6a1803df08f44-89a30a5ef7fmr107101396d6.20.1772938924803; Sat, 07 Mar 2026
 19:02:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260307212016.1328931-1-pc@manguebit.org>
In-Reply-To: <20260307212016.1328931-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 7 Mar 2026 21:01:53 -0600
X-Gm-Features: AaiRm50qYatmPyY4sLko0GYgd20OsgwVPIdVaiTS5dCt54-YGh5USYTNNkkjLMs
Message-ID: <CAH2r5mtnfxaZdsu=9byknrk68LLnpzEM0x89k62_h9AkieqX=A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix atomic open with O_DIRECT & O_SYNC
To: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Sat, Mar 7, 2026 at 3:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> When user application requests O_DIRECT|O_SYNC along with O_CREAT on
> open(2), CREATE_NO_BUFFER and CREATE_WRITE_THROUGH bits were missed in
> CREATE request when performing an atomic open, thus leading to
> potentially data integrity issues.
>
> Fix this by setting those missing bits in CREATE request when
> O_DIRECT|O_SYNC has been specified in cifs_do_create().
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h | 10 ++++++++++
>  fs/smb/client/dir.c      |  1 +
>  fs/smb/client/file.c     | 18 +++---------------
>  3 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 6f9b6c72962b..2f4470f9df58 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -2375,4 +2375,14 @@ static inline bool cifs_forced_shutdown(const stru=
ct cifs_sb_info *sbi)
>         return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
>  }
>
> +static inline int cifs_open_create_options(unsigned int oflags, int opts=
)
> +{
> +       /* O_SYNC also has bit for O_DSYNC so following check picks up ei=
ther */
> +       if (oflags & O_SYNC)
> +               opts |=3D CREATE_WRITE_THROUGH;
> +       if (oflags & O_DIRECT)
> +               opts |=3D CREATE_NO_BUFFER;
> +       return opts;
> +}
> +
>  #endif /* _CIFS_GLOB_H */
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 953f1fee8cb8..4bc217e9a727 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -308,6 +308,7 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>                 goto out;
>         }
>
> +       create_options |=3D cifs_open_create_options(oflags, create_optio=
ns);
>         /*
>          * if we're not using unix extensions, see if we need to set
>          * ATTR_READONLY on the create call
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index cffcf82c1b69..13dda87f7711 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -584,15 +584,8 @@ static int cifs_nt_open(const char *full_path, struc=
t inode *inode, struct cifs_
>   *********************************************************************/
>
>         disposition =3D cifs_get_disposition(f_flags);
> -
>         /* BB pass O_SYNC flag through on file attributes .. BB */
> -
> -       /* O_SYNC also has bit for O_DSYNC so following check picks up ei=
ther */
> -       if (f_flags & O_SYNC)
> -               create_options |=3D CREATE_WRITE_THROUGH;
> -
> -       if (f_flags & O_DIRECT)
> -               create_options |=3D CREATE_NO_BUFFER;
> +       create_options |=3D cifs_open_create_options(f_flags, create_opti=
ons);
>
>  retry_open:
>         oparms =3D (struct cifs_open_parms) {
> @@ -1314,13 +1307,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool =
can_flush)
>                 rdwr_for_fscache =3D 1;
>
>         desired_access =3D cifs_convert_flags(cfile->f_flags, rdwr_for_fs=
cache);
> -
> -       /* O_SYNC also has bit for O_DSYNC so following check picks up ei=
ther */
> -       if (cfile->f_flags & O_SYNC)
> -               create_options |=3D CREATE_WRITE_THROUGH;
> -
> -       if (cfile->f_flags & O_DIRECT)
> -               create_options |=3D CREATE_NO_BUFFER;
> +       create_options |=3D cifs_open_create_options(cfile->f_flags,
> +                                                  create_options);
>
>         if (server->ops->get_lease_key)
>                 server->ops->get_lease_key(inode, &cfile->fid);
> --
> 2.53.0
>


--=20
Thanks,

Steve
