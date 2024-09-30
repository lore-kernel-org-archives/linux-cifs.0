Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D0EDE;
	Mon, 30 Sep 2024 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727732005; cv=none; b=EZgtdXtkyC/n77C7cgQIv9u8Y6xSKX3MINfyRoPIsV2/oUVu9m7ajdA/V48Qgs8h8Z/Bvn/pWVPcM/KxAkUzFws9hQwsDjIM5o01sSBfiuHKKt9ZqgFsrxIG5jSrDmF7jg9ttgCy+bGzsLlSUGSzwaRRFkTQb6ukvhDZuyS91PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727732005; c=relaxed/simple;
	bh=18lpUTB0CF/mhpWU0xQeVTTOD8GAgMqG6a8GmvcEVXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JTb6+6imqi0Ov0NHL84/PisbtaxjzcXvVFOHmc9RUc/q8cQUJGGR3YtItiy0X40mRl2ChMI8fvTrVEiHrtmped3O+rLCdsm9amJVgoe8oU7ebYBCd2RVqtnQAdv4LhiMcitNSzK1r3isa7of8baPI8YSMxXTtpLTkrWuowZak6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TId3sVP5; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TId3sVP5"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-537a399e06dso5616239e87.1;
        Mon, 30 Sep 2024 14:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727732001; x=1728336801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ag5VhbnQShpIryOjSzBOtWYz1Q5qSqu8Fn5OY1wETi0=;
        b=TId3sVP5ZFyIAhfbWZj1qC7M2IG7EI2xqODuphRXSvW7pEdWfFwLHitVjfRh0eX6gB
         ktikg8wQH4RxmEFFnGNtdRNhX0b1ibHWA0W2czKUuWPJbO9QkiUAN+Pn3sNme8MdrQLj
         xHP5OXmaD+zcYAvjKFb2OOVJs3YPNJ3Md/NliZFil8CAjWLpKY3nbdz2WbhhFC0t5pDh
         1DE4RMzwaXE974U5JC80dMdvI+F3PCfMbS6mMc0H+A72stpRcsJsDQFBT7+t/b913nBv
         YeH1dj7JEk5NwElRo0Cv0LI631YwrpXVQVqtas8fa0nCsMG4qZ/uP8QF70LV1JddQYBu
         eUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727732001; x=1728336801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ag5VhbnQShpIryOjSzBOtWYz1Q5qSqu8Fn5OY1wETi0=;
        b=sBWDbyXPM0QhUlRl72skzr79xE+vyzTQqOrKCeuPwNyjbiGXFtQjFcjy6ZenJ71HyO
         /WBa817eq3I2EfSEutlbUhmm5ayBs/zu4GNx9oE/IPmvVXF8x9PCcptrOtawqBwDSmDd
         7u3YJKViVWSHV6A3mQzQIgC6oLRPbpLgPOXbyKjY0yAOFqYTdHMMFEqW7g64j3tUMcQX
         JogtBQi6liLHAqE/cKDDWdkcA+LDWiFCoGSE60DbTxlWe9DMLzDB/k7JJbb+1HUeNwuk
         sDuRaFVwID5kvpxTfKxN0Hcmh964syK6TgbjsHa3dnfNQ+2iml7Q/dJr7D7XXf42wwJF
         o8Mw==
X-Forwarded-Encrypted: i=1; AJvYcCVdpwxpXxKyClrIcfe4xiGwfzNcR/vWERPvl9/Jn+Y2DCnB2YxvbjRSUzHCgB6UmCh07noeSevOQ6ty@vger.kernel.org, AJvYcCXTPRhfN34yR91gxzl+R4F5HdvmJo09PDOOzBC2WjwGvTSe4+seLyd4fhiAjg0egZKnE933Tu9naQ8hx49V@vger.kernel.org
X-Gm-Message-State: AOJu0YzXX1kcMRarlSedj+TiE5OnCeqGqHPoBtUYeO1CymB5SmIq9jD/
	6/srwaqeaMZJuFyTNZmQWOYiKDtBWzfzHCF9FffCUj3j/3POsidRPXlvYvH0dJx89dQd9VpbkVP
	gRHlq/mVpHWuXSNW9YvLCxlDVO0g=
X-Google-Smtp-Source: AGHT+IEFLnKYTXFERxHv+RTe8z+BjoJWs1ezwBtE1WSeXEVM+qPAcIgV8yJsNLAv1mWUxaaLwnmNVTScMOeZHEk923c=
X-Received: by 2002:a05:6512:1054:b0:535:6795:301a with SMTP id
 2adb3069b0e04-5389fc642a8mr6346203e87.47.1727732001020; Mon, 30 Sep 2024
 14:33:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928215948.4494-3-pali@kernel.org> <20240930202510.23187-1-pali@kernel.org>
In-Reply-To: <20240930202510.23187-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 30 Sep 2024 16:33:11 -0500
Message-ID: <CAH2r5mvgWzAA_z_448Y3=GivuLu=M9FsNemjyGrwUMVVF_4H0Q@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: Remove intermediate object of failed create
 reparse call
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git pending review and testing

On Mon, Sep 30, 2024 at 3:28=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
> intermediate object created by CREATE. Otherwise empty object stay on the
> server when reparse call failed.
>
> This ensures that if the creating of special files is unsupported by the
> server then no empty file stay on the server as a result of unsupported
> operation.
>
> Fixes: 102466f303ff ("smb: client: allow creating special files via repar=
se points")
> Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> ---
> Changes in v3:
> * Check if iov_base and out_buftype are valid before derefrencing iov_bas=
e
> Changes in v2:
> * Increase out_buftype[] and out_iov[] members from 2 to 4 as required by=
 smb2_compound_op
> * Call free_rsp_buf() for all members of out_buftype[]/out_iov[]
> ---
>  fs/smb/client/smb2inode.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 11a1c53c64e0..a6dab60e2c01 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1205,9 +1205,12 @@ struct inode *smb2_get_reparse_inode(struct cifs_o=
pen_info_data *data,
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>         struct cifsFileInfo *cfile;
>         struct inode *new =3D NULL;
> +       int out_buftype[4] =3D {};
> +       struct kvec out_iov[4] =3D {};
>         struct kvec in_iov[2];
>         int cmds[2];
>         int rc;
> +       int i;
>
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path,
>                              SYNCHRONIZE | DELETE |
> @@ -1228,7 +1231,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_op=
en_info_data *data,
>                 cmds[1] =3D SMB2_OP_POSIX_QUERY_INFO;
>                 cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfi=
le);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
> -                                     in_iov, cmds, 2, cfile, NULL, NULL,=
 NULL);
> +                                     in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
>                         rc =3D smb311_posix_get_inode_info(&new, full_pat=
h,
>                                                          data, sb, xid);
> @@ -1237,12 +1240,29 @@ struct inode *smb2_get_reparse_inode(struct cifs_=
open_info_data *data,
>                 cmds[1] =3D SMB2_OP_QUERY_INFO;
>                 cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfi=
le);
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms,
> -                                     in_iov, cmds, 2, cfile, NULL, NULL,=
 NULL);
> +                                     in_iov, cmds, 2, cfile, out_iov, ou=
t_buftype, NULL);
>                 if (!rc) {
>                         rc =3D cifs_get_inode_info(&new, full_path,
>                                                  data, sb, xid, NULL);
>                 }
>         }
> +
> +
> +       /*
> +        * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
> +        * remove the intermediate object created by CREATE. Otherwise
> +        * empty object stay on the server when reparse call failed.
> +        */
> +       if (rc &&
> +           out_iov[0].iov_base !=3D NULL && out_buftype[0] !=3D CIFS_NO_=
BUFFER &&
> +           ((struct smb2_hdr *)out_iov[0].iov_base)->Status =3D=3D STATU=
S_SUCCESS &&
> +           (out_iov[1].iov_base =3D=3D NULL || out_buftype[1] =3D=3D CIF=
S_NO_BUFFER ||
> +            ((struct smb2_hdr *)out_iov[1].iov_base)->Status !=3D STATUS=
_SUCCESS))
> +               smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
> +
> +       for (i =3D 0; i < ARRAY_SIZE(out_buftype); i++)
> +               free_rsp_buf(out_buftype[i], out_iov[i].iov_base);
> +
>         return rc ? ERR_PTR(rc) : new;
>  }
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
