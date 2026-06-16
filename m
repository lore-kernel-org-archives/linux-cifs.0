Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1D13DC4A0
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 07:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781595698; cv=pass; b=AqREkXhXvj2hJ3CxWlYcCtz9THjHn+DMq54jHyGcuL6XCTLNIbYg2iqKo/VumOZNF/Nzs/0yMTtwrWh0BWjTU6l05lbjljT1WBA9IcQKVI2uJvR2joyjWFIj5+dzpBNdvPIzxAGA8D8/QvUG7a4KJt6fzj69RZuhUNM3eGRDtJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781595698; c=relaxed/simple;
	bh=Rv6kcVid9OnSJmu0yuwCyzWmXzFLMgeMTnENA4SCyi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B2WrHxc63DPxxTHaEKzEg1fOVm9RO8ypH1YvdIKyDI2uxgn55YMFY/UgCSG41mlC9vBsHg1rUxLoHJ9jnBTgvW2MRyh+vmeMStzcOF6uM+o+vP9Q+7uBt8mejghnasGMm5cZ2pt7rCgRC/3k8ZZlrCs5auMjZpvhgJ3qqDulcD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jBqRBu0z; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jBqRBu0z"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8cc0ef7c306so38485766d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 00:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781595696; cv=none;
        d=google.com; s=arc-20240605;
        b=JExlbph90SzOWvBWUvmxnIv0jsyIm91BbTBoQuOzSjJ39ngmho7xaur4AU3DOddore
         rVBKFbBTTp3dofr8lP85E1CzA/qBUYcHJQLFAZu8J7Crk88IZyTw4ktYDpCztkqrfv4s
         Esn5msKpdcx9ramm3+rvrek7l2Q1ANNNlOo2RvPgcfiQ1Zhjc50y3+eHmz2xHYxGZg1Y
         M9txUOkipI4ghYktt5Drni8gNdH6b9gln57O585j9Ffbz93NYcXHMljDqrTl1RIvX5vF
         SbSqkBR9JRO1Y3nXwi6+fsnyiHSgk26ZrwzekgC4yV8IXZ8UH1w6chB3lK2N1nODhHcA
         1O0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NheyWu9fmQLnZ+ToHWYn/7vC8SOuuDUTb7g7EsFCmoY=;
        fh=9Mg0SR8rCIcW0Rhh6Yz7C02xz9DdwVzIJOWBN/aI3GI=;
        b=KNbZyOQ/c8QpjYS8u9Rn1O0DlduRtGDnmvkQpnh5qw8BU4Zrmorc+8shnQt/H2HCUP
         aPzznxLwG39Js06wZ44ljLR9j9EubQyn2h/qQyhqmRDA0ODDE7A2KsEYpAEjkBc2tT7U
         3nreyN/zQ7xS4mh9/ezBHPq1A0SzZqzR2amqxEZQ7EC3RpNL836N4dm99wtD15Sttmmh
         ebzAJna8cHdoit7b+UaT9xujfsgF96L6258zYHyIITk5V1Uar+WZZjtWqz/uNwYXGCRZ
         XfPWz/PC//NIYH/de3L5/4WF/uI99rBCDOPYQrHxMXLrJwu78yxH7ZGXTJCwuoqI20Aj
         KxOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781595696; x=1782200496; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NheyWu9fmQLnZ+ToHWYn/7vC8SOuuDUTb7g7EsFCmoY=;
        b=jBqRBu0zqx0RsI3J/IzR2fEvlbWKxvppdACBeKMs2HrHJVdxf8hCu5d4sHFfIJPdcG
         ptAYyY2ExfMIufYIKBBV0mDQO8y7SMZ1T3br1a+tLyH2n6Q+1O0WHYg6i+lje+BTT2Tp
         ak8xC5yqE+MoVEQSOved4harXWyQENSDDD9/YSnUq3lxyUj4OgKDUfWJCTeypQoUOOIA
         87S7sfompibvKSx7M0qblIa1cgzFccIN3N7ZAV56l+Z7m+CLKQsa1ClFsbgPawKF5k2o
         7qUb/VZTbLIpcW+xqA2gLjhvDukFvl5xqiMfzkms4w0kdpZ5OLwrXiPoqXqe1XDZyJN7
         A/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781595696; x=1782200496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NheyWu9fmQLnZ+ToHWYn/7vC8SOuuDUTb7g7EsFCmoY=;
        b=lejL9wl5Njw3x2s3UU16c6SiKhAHKYUB8fsKt07iSQMrRZwHzfY1pyG6yZ78da+9wn
         4flAZ/x6aDrO0xrWWeKvts/4pk1oE173h6Tqv7Co5+nX3LEuHEIY6o3j+5wT4ih6MzzS
         uhySkGL1ocsjQqwtgXyujRQnuNgspeEQ40TqokqL/1T8IvzE2d3Um9ujGPnz26GP3S0r
         7/kzfp1aXwONV7xG+K/H5/koIuaIFgfn3Q/EaJdVVq8/QviMfgWp0ghy1XqLzjvaagqA
         ZgofLjNAEYJkCfanYiAkKohnX8Mvz9aoJbFvi6B0Gr+MJYxOlGPFGvY/HxPo6zBfuXC7
         NHYw==
X-Forwarded-Encrypted: i=1; AFNElJ+SUf8E2IF3XMcsrAQYPX2xrnoK0GNO3om8v2LZB5aH34EOAFxd5fDDOyEDRDLbQh/cqKKikyPl4QDN@vger.kernel.org
X-Gm-Message-State: AOJu0YwPn0XW1exIx+QPYI+gS3rQwe2e2avS7dRzLaIRw9UJV9d72mAC
	+39skIf+TwcKIod7nrLjUOkQtHCW9wK/gHBEmPhMPrL4CY+vUaOhckAGiHqWg3WHBXXAMYNXvnd
	rP+KqdTzGOin2F8MTgPbbi0yLjmflSjGSXWPt
X-Gm-Gg: Acq92OEOtpQ1SiymX5z6lkysb98PDe+xULLLO9EbTDKXlibh6ZfcCzbx4NlNkpVTr6r
	WAoXElASrP83JZmQ/WShDqNKZFhlJCfKCDKwf1sK/JNmdCJ3vhD9e4JCwTDysgc73jIAGN2aa/A
	+GvzjaV7UaJO0oCeY/6ef+Nfhr6uC6dhWOzhjSp/oQ6uSSZ3h5/PxvankSMc+npRxiDzewqKK8Q
	1LAQlDBq8Amv1w29EpCoskQfbhpRX2Es1TuMRLk1k2a+rKycWh+EEAtamuSroDhgTUujl0wbZ2z
	6exJQw==
X-Received: by 2002:a05:6214:2c05:b0:8cc:de92:882f with SMTP id
 6a1803df08f44-8da204578b8mr35491286d6.36.1781595696224; Tue, 16 Jun 2026
 00:41:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616055357.3798387-1-rajasimandalos@gmail.com> <20260616055357.3798387-6-rajasimandalos@gmail.com>
In-Reply-To: <20260616055357.3798387-6-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Tue, 16 Jun 2026 00:41:23 -0700
X-Gm-Features: AVVi8CemOUjbB0j8tp1URfq8v5r5u8ht7qazlebrM7vu7UBJs2p5r4LBR2wsKwI
Message-ID: <CAFTVevUUH5wmhSaXxjyzOLz7BDNY1RfQJG2X80_O=Zme8tCdsA@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] smb: client: apply rasize on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Mon, Jun 15, 2026 at 10:54=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> rasize is accepted during remount parsing but sb->s_bdi->ra_pages is
> only set in cifs_read_super() at mount time. A remount with a new
> rasize value silently has no effect on the readahead window.
>
> Update ra_pages in smb3_reconfigure() after the context has been
> duplicated, using the same logic as cifs_read_super(): if rasize is
> set, use it directly; otherwise fall back to 2 * rsize.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 659fb0adb528..0a72e1089ff7 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1313,7 +1313,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> -       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
> +       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize, rasize =
=3D ctx->rasize;
>         char *new_password =3D NULL, *new_password2 =3D NULL;
>         bool need_recon =3D false;
>         bool need_mchan_update;
> @@ -1379,9 +1379,10 @@ static int smb3_reconfigure(struct fs_context *fc)
>                 STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
>         }
>
> -       /* if rsize or wsize not passed in on remount, use previous value=
s */
> +       /* if rsize, wsize, or rasize not passed in on remount, use previ=
ous values */
>         ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
>         ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
> +       ctx->rasize =3D rasize ? rasize : cifs_sb->ctx->rasize;
>
>         new_ctx =3D kzalloc_obj(*new_ctx);
>         if (!new_ctx) {
> @@ -1470,6 +1471,12 @@ static int smb3_reconfigure(struct fs_context *fc)
>         smb3_cleanup_fs_context(old_ctx);
>         old_ctx =3D NULL;
>         smb3_update_mnt_flags(cifs_sb);
> +
> +       if (cifs_sb->ctx->rasize)
> +               root->d_sb->s_bdi->ra_pages =3D cifs_sb->ctx->rasize / PA=
GE_SIZE;
> +       else
> +               root->d_sb->s_bdi->ra_pages =3D 2 * (cifs_sb->ctx->rsize =
/ PAGE_SIZE);
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         if (!rc)
>                 rc =3D dfs_cache_remount_fs(cifs_sb);
> --
> 2.43.0
>
