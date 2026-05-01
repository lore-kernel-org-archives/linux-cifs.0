Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A7E28E00
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777594174; cv=pass; b=BH8sJgT1jMjk7mPo8paqgMQVALE39q1XwE9o7yrnaZYWVCN5VoQfs8++E6GUm0BZmssqkQLGltFpXU7GtB4xw2iP7qScKnQP3G3n7bWmtB8V+4bKJebdBtxPSdMURF/VHer+mEcIOIoz0pqBmrQ2EprMRhNAhf9ZRlo3+70T3A0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777594174; c=relaxed/simple;
	bh=PE1/3S+he+KI20uXj2b7qjJL0Z7zNGU1+fyETMz6Dwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9gx5/6+FO7DdiZ0qF3Ol9XjyhXQr/9jHPf1MDuKDSTDxhL/LHCL1pYHjj/lgTqsK45USFjaCujKsJsY1hVrGRJ9lIPGMo83A3vI6FGkjF4ON4jM37y/WszQtVHu51j09BstUbsVDl83B/6rg7bdXVDy22yrjdr78PMN+A9BD0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ej0Q5oBD; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ej0Q5oBD"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso12852906d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 17:09:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777594172; cv=none;
        d=google.com; s=arc-20240605;
        b=PFMgoPcJ8uR1SBopMnoI4tVSUPdOyiLM4ajtn/zV+Tr1YDdpxffZHaOt0gGklEVy19
         Vp/a14lrxhDqYdx8uwDX+54rkaqpzemLlmxNuwqtZzL8lq6xKqH/aknyDrBq9p43exJi
         4ef+a+VU6OENggIThdM49iZsEFiztV+pGsLozybK12zmBy0cvxhExwsFhHNamOdHDNRd
         xetb+7KE3RxV4zT9oU5NP8nQQzdo3mfJoBxa9ciFblVTvhsyXUPHjsyLClbd6TWbE5i7
         p0jl/iUbsni0mBLlHDiaq8Iay1QlXZG6QOqzSNdIP8ab/8XFojHOd80X0h1nsLwikTiC
         D0Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5IYpuakU8c4Z1hffhq097EhGBs3XtcW4cNQFmZrV9QM=;
        fh=sREvkurtnIGNiqBo1A8Rxha4HJcW3fpJEpmqCd2RCIM=;
        b=a1CJKp1iJGjY1kdCyaJNyawFwWrZPDVyFp0aIBXxsaW/WrqsMEH9ZyG0mldy9JOmCx
         JsJ70Gc4vbetexQg0qY+RFLME/IxISTsbddpG6Hh/ZEWOY1gkQZgqE6LQ38Vy9BbG/t4
         88rk5IYCT8RYyn6MH1jv5RVuOjEwFqDixUmT2VnKinHDIQYVsJLmO1nftfPXPtBmySJH
         GITU6dOJm7E+FJJDXntb+qdIm0Z3+1ggjKQFYJpa8P0gfdSCK3rEJLBVLZWviF+xaHRt
         n54NAHttT08I0YzynRgbXS9T3O6Qvfbx3/QxMeXbLSP79rLnrAes1XEF3uUNDYj5tp4p
         RNtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777594172; x=1778198972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5IYpuakU8c4Z1hffhq097EhGBs3XtcW4cNQFmZrV9QM=;
        b=ej0Q5oBDlZxhcD3x77rdA+uBO/Q7dAuklCO9NhKGeu2c+BIAYUXlkaM/9pKwSWEA2j
         mBOWsxwg/bPYjtLriPrUm+DG/B8q2BEPjkNi97H1lsMB5RsUZf8yY0hri3aMf2fwhsIu
         c7dPY+YpGgT84XcQY/Pdz9CjgND6H7Ft4PyydFAqlpgU+1ymgSpF6hOnM1so3nms0HFn
         CgYx+iyf3Ivz9s9UkKvAC15a/LypLbz59rJWCiOva9jeMJLfocuNfL/5SnqXb+i3y3ox
         qRgGQKxl1AWnedrRvgPLtrjv0F8RZIXSnwx3fR8PUTXiOkIzzf7FxVCVSAEMWL+u2TiQ
         YNTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777594172; x=1778198972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5IYpuakU8c4Z1hffhq097EhGBs3XtcW4cNQFmZrV9QM=;
        b=Q8BMy7RQECr6+coBC2WKKONnFeJasWkoIypmRa1gNpCl3G/275lsXJ+eMP6phLUj8e
         xefHclLYhCyRRK5v52A0usDDvDdrX4p1dQ5j5966AKI8V/qDXq+0MWZqsyFWUDLJrGMM
         Zx6IfTR0ayL10X9xPq2+m2RGeX15t3RblFw3pYKnik5OeW9K6dZGZESdrjIFN9joyDiH
         Tx0qBjIOfI+5Sgb58ET97j8S3v2nInc4+UV5gSvqBNWU4fCyOZ7ngDdVLBR07Q/MluXN
         LEN8TVEy5rycOYx0P3mErskpNU3AMTgRQyC6B0DNDSTviexOjvuJY9xpZuEgQD0NdGF8
         ++bQ==
X-Gm-Message-State: AOJu0YxhEdvnLUxjPLPAHZr4DqrwzblnwNs5DTwJ2+daM3OiihuSRLqs
	EH0wgY28WPf6tmXf0PbQdo32foJQmxCwJL9nWj+WkRLr+/D/p+brb2dc7gi2zAHgNU58vPl/MkF
	b+e7dxyHPhYGg85zXgnEPYjyf4NFW1d79hB/u45M=
X-Gm-Gg: AeBDieubSFI41yfMuwUW28y1Hl9J4Ez/KZ+o24WuxHZE+8U9LSXz1mPxS/9d6U0991Z
	flrFIebYsOJvlxrYBZKDx9If7Yn5dNHssLT0MvatJnBneBmBKI9nV9JjbAzKxzm2HY08mTXJg/1
	JdMWobrGgi3qFVl/bLG9Cb9z2DaOnOqBYBVdOMzIxWEHP7yhkX02dH240uwMH4ZCRarDZODOeV8
	Cei9fbKPn6TUipQeUiuQ4Inp85aPXP77tczJHTMNqJKFUyS/Jf3jRk7ejLL1TSoql2pNmorwam1
	S/zF39SDBQ2eWVKs//qiOIhN3eoR0mlnl/o52y1uR0bRIG+U7z+BcpZvCZ2irbHCcmyClW9YeCz
	0svfF7EhTrGIQQ4XTCRUskh+EQEPKh1RkSahsJyUgB+etPbm/dkIs9GEaLUcmmdCdm8bJn04=
X-Received: by 2002:a05:6214:21c7:b0:8b4:9a1e:bbe7 with SMTP id
 6a1803df08f44-8b49a1ebc7dmr57061966d6.3.1777594172243; Thu, 30 Apr 2026
 17:09:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430220601.76266-1-rosenp@gmail.com>
In-Reply-To: <20260430220601.76266-1-rosenp@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Apr 2026 19:09:19 -0500
X-Gm-Features: AVHnY4IbRSCoEPhCVymhGIHbC7kZSeuXeSoP6DvlIvsKxNqqSzw21Xc8RwadaJY
Message-ID: <CAH2r5mvNHedEymrmCYCbghmdv1OLcbVPstnrSZooLXavKkc4Kw@mail.gmail.com>
Subject: Re: [PATCH] cifssmb: use struct_offset in memcpy calculations
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, 
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Seems clearer to leave in the cast so it is a memcpy from char * to char *

           memcpy((char *) pFindData,

On Thu, Apr 30, 2026 at 5:06=E2=80=AFPM Rosen Penev <rosenp@gmail.com> wrot=
e:
>
> It seems W=3D1/FORTIFY_SOURCE is getting confused about the math here.
>
> Use struct_offset to point FORTIFY_SOURCE to the correct place.
>
> Remove response_data variables and directly apply to memcpy. Simpler
> and avoids excess casting.
>
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  fs/smb/client/cifssmb.c | 40 +++++++++++++---------------------------
>  1 file changed, 13 insertions(+), 27 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index 3990a9012264..8598cec5ebbd 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -4090,9 +4090,9 @@ CIFSSMBQFileInfo(const unsigned int xid, struct cif=
s_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), 40);
>                 else if (pFindData) {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset, sizeof(FILE_ALL_INFO));
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
> +                              sizeof(FILE_ALL_INFO));
>                 } else
>                     rc =3D -ENOMEM;
>         }
> @@ -4264,9 +4264,8 @@ CIFSSMBUnixQFileInfo(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), sizeof(FILE_U=
NIX_BASIC_INFO));
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset,
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_UNIX_BASIC_INFO));
>                 }
>         }
> @@ -4349,9 +4348,8 @@ CIFSSMBUnixQPathInfo(const unsigned int xid, struct=
 cifs_tcon *tcon,
>                                       get_bcc(&pSMBr->hdr), sizeof(FILE_U=
NIX_BASIC_INFO));
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       memcpy((char *) pFindData,
> -                              (char *) &pSMBr->hdr.Protocol +
> -                              data_offset,
> +                       memcpy(pFindData,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_UNIX_BASIC_INFO));
>                 }
>         }
> @@ -5079,7 +5077,6 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, str=
uct cifs_tcon *tcon)
>  /* level 0x105  SMB_QUERY_FILE_SYSTEM_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_ATTRIBUTE_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5130,11 +5127,8 @@ CIFSSMBQFSAttributeInfo(const unsigned int xid, st=
ruct cifs_tcon *tcon)
>                                       get_bcc(&pSMBr->hdr), 13);
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_ATTRIBUTE_INFO
> -                            *) (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsAttrInfo, response_data,
> +                       memcpy(&tcon->fsAttrInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_ATTRIBUTE_INFO));
>                 }
>         }
> @@ -5152,7 +5146,6 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struct=
 cifs_tcon *tcon)
>  /* level 0x104 SMB_QUERY_FILE_SYSTEM_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_DEVICE_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5205,11 +5198,8 @@ CIFSSMBQFSDeviceInfo(const unsigned int xid, struc=
t cifs_tcon *tcon)
>                                       sizeof(FILE_SYSTEM_DEVICE_INFO));
>                 else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_DEVICE_INFO *)
> -                               (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsDevInfo, response_data,
> +                       memcpy(&tcon->fsDevInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_DEVICE_INFO));
>                 }
>         }
> @@ -5227,7 +5217,6 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct c=
ifs_tcon *tcon)
>  /* level 0x200  SMB_QUERY_CIFS_UNIX_INFO */
>         TRANSACTION2_QFSI_REQ *pSMB =3D NULL;
>         TRANSACTION2_QFSI_RSP *pSMBr =3D NULL;
> -       FILE_SYSTEM_UNIX_INFO *response_data;
>         unsigned int in_len;
>         int rc =3D 0;
>         int bytes_returned =3D 0;
> @@ -5277,11 +5266,8 @@ CIFSSMBQFSUnixInfo(const unsigned int xid, struct =
cifs_tcon *tcon)
>                                       get_bcc(&pSMBr->hdr), 13);
>                 } else {
>                         __u16 data_offset =3D le16_to_cpu(pSMBr->t2.DataO=
ffset);
> -                       response_data =3D
> -                           (FILE_SYSTEM_UNIX_INFO
> -                            *) (((char *) &pSMBr->hdr.Protocol) +
> -                                data_offset);
> -                       memcpy(&tcon->fsUnixInfo, response_data,
> +                       memcpy(&tcon->fsUnixInfo,
> +                              (char *)pSMBr + struct_offset(pSMBr, hdr.P=
rotocol) + data_offset,
>                                sizeof(FILE_SYSTEM_UNIX_INFO));
>                 }
>         }
> --
> 2.54.0
>
>


--=20
Thanks,

Steve
