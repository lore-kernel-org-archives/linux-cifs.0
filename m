Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94533FEF
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 05:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768800957; cv=none; b=rECutvSaV1eCEj4WS5fnJQeMZiESg30oxhGSpn+WErwCBU0zMKT9oMwbSetkWfXMRdW9HBI+NDHlG2YKAB1wfvOdI8FkbRgkbCrMO4NNMCUGctI2H9BQnz9oIDx0ho6WkcAfn9n3aoWfNARdNXPwCRkoxsjhnhnyEnJoZjfIod0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768800957; c=relaxed/simple;
	bh=7BqMaEVGz86vKGb+0SFdOvMcuI+zvbPIRz1iv1NasSA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dbH2D25v98iMmo30bhrry3H1wkjQHth9y/qMZuqCC/GDpt9G/jPnMAw2Ggu3NsiGTyi9vZE9new98tw4UaKhLK/ZFbcbqZglXsXDToEVGr6z1ZJlXy6Tn8P7Y/dWueT9lx/jsixKLoaC9ClMQZOw2Tdqy7cNMkKukB+3s/U5XFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kJOA42b9; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kJOA42b9"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8765b80a52so632260066b.2
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jan 2026 21:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768800954; x=1769405754; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hd7wfKHqWK+kRwmSI+Pf2BPzDIcGFJfolbhnvsHNpOo=;
        b=kJOA42b90wa3Cjpfbtul5LBmwYbBI9zn9PK6MGTwzryosW3PXhKaqywyXQflWqhZju
         kRxKSXOZEzj+c2tK1IlgK9HL0I3UV+U2dCs6qDrIRfgcBbY4RjTrG/+lN6Ofty+tEHzH
         Xrph8mUeToq8hQBVmvDlcjwgjYFXEdaRO5M+WQcFNb8KIGC3FDTx+MSwQk93FRvNXO62
         30geejn5Lc1eGNR6sgPmKg67P6yZGb9FZXgruob8SizFjuCH35QIjosx2/FDr2vvtM7o
         7neBw5bg+eJdiZienpA1eLvNNn6gSqXqjUF6mSw58H3SfP6t5v5H5BcchVge2yTegFQH
         uTZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768800954; x=1769405754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hd7wfKHqWK+kRwmSI+Pf2BPzDIcGFJfolbhnvsHNpOo=;
        b=NvfypHYIvsc9MFGtjV0YSyxHtia7/rzY26GXx5lY1RaxfSHi0AOnJRLeGT4swaead5
         ZaSQh7o6f8OH4XC2k1XKHeqYxdfo/y3y6yd0W8JXFP9nxkCluZv48RDHs7z6dTUozP+A
         amvknuopXsZ69WK/CAdJoSWhQJE/RspFWjzbgmn41v85JTST5y2+4HjauZrDEfkWtRx8
         YHPVjNbGv1N12kxU+sXxHFfkI2nf0e5G6Nzc0FfDE66j3MMhaMZLIdpu8x6cNOfONtU3
         yk5D/+iyQDi322cuddYPmn1ffczBfWxgJ7hyGasN5FSNbRHIfAnwbRxRRObROQRH5+U+
         bElw==
X-Forwarded-Encrypted: i=1; AJvYcCWK8e16w6up1b8E3955boMO19apATcOVi7aBXsiDPVz13JtQH2h/pTTptrjTQA+eR4ZluPK5NtTMljW@vger.kernel.org
X-Gm-Message-State: AOJu0YztawmmVFpRytF7QSM/Lv5FaUhthWU4DtXzhFdegmeFCaydaYm3
	GMg0xuz8gldkJ26V2hTb7LOuR5xZN6D+s7RN2vUfA2rMZx8mHvFaqUewjnGxCZTHGwVbeTTBxUJ
	IQXH2GIALdpQuoMv/1iNPUM5+sY3RkpM=
X-Gm-Gg: AY/fxX6AsJU7o8U6hb2qMZHS0nJqnESN4wRwrFAqp5yoqyHBrve9zkkZiSzPn32D4g9
	gGuH2EHtqw6+uwvzQaLHkz+6RdZuCqs0BhgpUcyNMYAHt6at0eY7U3buJHa4HakbRPlXp9Lxmvx
	QmIqHKXwSdSIpD39jE7M2c/DlbNpVhaoV9Lp9s5Qsl1RKkcKPml29/YPqGZGHNDSr29/kntwGTL
	c1YeiE/HLX7huuTbMgWGugwOz1spHTyTR0nUEiTPSmhvxctHR7XoPm5+i22MFm25izxng==
X-Received: by 2002:a17:907:d92:b0:b87:1d30:7ec with SMTP id
 a640c23a62f3a-b8792f7985dmr857948166b.37.1768800953994; Sun, 18 Jan 2026
 21:35:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com> <20260116220641.322213-2-henrique.carvalho@suse.com>
In-Reply-To: <20260116220641.322213-2-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 19 Jan 2026 11:05:43 +0530
X-Gm-Features: AZwV_Qg-Q8E_Wfq9keyd2uV2er65we5frsiI-TXndbaeRY2-SMkStcJBg3Fu0oY
Message-ID: <CANT5p=oot1H3NufPO-6JJ-iBpjyhiZytSRekZy6vxWL+LCO-mg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] smb: client: add multichannel async work for !CONFIG_CIFS_DFS_UPCALL
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 17, 2026 at 3:37=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Multichannel support is independent of DFS configuration. Extend the
> async multichannel setup to non-DFS cifs.ko.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/connect.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index d6c93980d1b6..c635b503af52 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3997,6 +3997,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb3_fs_context *ctx)
>  {
>         int rc =3D 0;
>         struct cifs_mount_ctx mnt_ctx =3D { .cifs_sb =3D cifs_sb, .fs_ctx=
 =3D ctx, };
> +       struct mchan_mount *mchan_mount =3D NULL;
>
>         rc =3D cifs_mount_get_session(&mnt_ctx);
>         if (rc)
> @@ -4024,14 +4025,27 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, stru=
ct smb3_fs_context *ctx)
>         if (rc)
>                 goto error;
>
> +       if (ctx->multichannel) {
> +               mchan_mount =3D mchan_mount_alloc(mnt_ctx.ses);
> +               if (IS_ERR(mchan_mount)) {
> +                       rc =3D PTR_ERR(mchan_mount);
> +                       goto error;
> +               }
> +       }
> +
>         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>         if (rc)
>                 goto error;
>
> +       if (ctx->multichannel)
> +               queue_work(cifsiod_wq, &mchan_mount->work);
> +
>         free_xid(mnt_ctx.xid);
>         return rc;
>
>  error:
> +       if (ctx->multichannel && !IS_ERR_OR_NULL(mchan_mount))
> +               mchan_mount_free(mchan_mount);
>         cifs_mount_put_conns(&mnt_ctx);
>         return rc;
>  }
> --
> 2.50.1
>
>

Looks good to me.
Thanks for submitting this. We recently noticed that the
non-DFS-enabled cifs_mount was missing multichannel support. This
change should cover it.

--=20
Regards,
Shyam
