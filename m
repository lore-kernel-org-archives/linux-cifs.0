Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8423B3CA4A8
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 13:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776086999; cv=pass; b=jdOb/rD4iBDZMRYkUvxilCTKsNNZHacBlRtiRlbVmVp+4bDMKcrHAf3sgdBKhkxwaP1Giau08JpTu0AfKKXAhQbn8dbrMDr5wGypzJKTAFwwHCC2o0Z8kZMathcplKRXVgmHqMv6GyBHuuag2IswyyFQmJ68vnMuPb5U69jAOVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776086999; c=relaxed/simple;
	bh=g0CAVjZHZKt0+X1c8km9qbv7eZV24rgR+3dLCKEEfPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gwQT0hhxqeqa6eqgPT7i/nbY7tJn20+Jf0mIxbrG9E5iKP+FiLKfTEQ9jOO4MLAysGbQkiAa8NrpQWSqggUZD4GWHOv3ayWphrYDgrcGmzut6otBpGioF+M/tpij326QMO4ahaHjj4NJ4J+nUP12rqBeSQkRis8yLfTYCW9P/fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LLNX+CRA; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLNX+CRA"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a58057d7baso48422966d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 06:29:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776086997; cv=none;
        d=google.com; s=arc-20240605;
        b=Rc//TTkODVqW9NVlouj1PGUGehcfNLYmsXqeGJirCF5JUTA4uLHlZSi6I5YosLkwFc
         kMvHGW70jHbyxLWrN7+o7YbRv6jjPaTvloPjbB/Plk33i4R76rKUm1fCZ+cEq3LwTPBP
         Os43misLbYFRVyxSVaVVho91DYWp//EDe/QIpFC8OA9gi2Y1lnhL1a+SJDFEn8BtBuTC
         /a6npnrnkHdrMbceys6RWMIJR4RKj+s2RQa5ly7Zci2OfITR+H93wHh7ICrUJWodh1RY
         c2Onqlt1K6mN6ACGnOiBl0LjJvO+/wFppcLg9PtmCojkeQDUfKCa7VlnrOaqIudFhN4y
         XFTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qt2r1TaV663knZA9RDtX++CGJ4T04oYta/wYOgVpjMM=;
        fh=32o+Z0pZ9yfOrvi7M40VdOzzOOBPR1qbHH1hJuJCErk=;
        b=G5/lHFs8zLZVn8BcGKHRYzkRiaixZ5TlmjMDsLEEUsbtQE3TWbdAs3YbBXeQnIOa+0
         bKm3vYVc9ghhUNoy5a7zvbJwJoh20n/kCIq38bjfdYsN2z2AXH+EWUowWRpq+i8c7NFP
         hpVOPRHW0wUheJWNTZ3yLUL0dgCW0/hzUnDZNi53X4ukt6QQ8RHyCn9ZCj2bs7RvsnBc
         3SPP94P2HJAjAHjtD6FxyGANfDkWUbhiGdmIinBFk5AsTXJ54I0AcEp/H6EtRdE4/MnQ
         otlQa4TYRM5wdBOA9dQSqgClh1i54tVZgUhhOScxWnXzeU/ypVXLcbgtRwiOCAhjaJMz
         b6ew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776086997; x=1776691797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qt2r1TaV663knZA9RDtX++CGJ4T04oYta/wYOgVpjMM=;
        b=LLNX+CRAlCwfclVxoKDPxmIyZzZ4gICRXtj9lqJ9zv9vdvPPGkeQ4pfSIXNQPPs2NP
         5STw6giaJNWio2muWUWyzmqZGQoKVemgxCCYDej5tSaA5TtmLy60VDy5C+9nkZet0nnz
         EI4N23hHfP1Pvicy9yxtciINghqxIYmVYHJJPuVnUUvJcO+6/GfsjDSMuVvg3Km7SScO
         yJ7fzIIcnAYFScDSZ7yZiKuGvzTJ3ayQG4nsVF5EuMZMAxJCXpfhesIOk4pqeT/dXpJT
         SN4MYCJySTmEDpK1hS0FdhplEwlpece8S9rNwU6SYEwPBdGAfTyZU3xP0A3vF26xM12w
         iT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776086997; x=1776691797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qt2r1TaV663knZA9RDtX++CGJ4T04oYta/wYOgVpjMM=;
        b=CBtH7yLDwJmXpUwvrsz/6TQX3lag9FIw4W7ptpkOa5HBIXvNcKX/MzrL0X67ykkHBj
         Dx9TaF01oD3bRTjDLugQa1hLRM7jjr42mMt+xxArFPjNQaYMh7mshomYHAOcCVPovm1Z
         telQuI2Qm477Y3HY2US3pJQVN9YsDU63e+izEpnC2V279UlcHATtgJNRg+P5INah3OQN
         hOflaH8uijQRxRpNTVXyIKBZQm1Rp7TfpMMJ0ucTDivynyrV5QDXSyHOhSVpCFM017X2
         dyBF+rRNPXwgwh8MzULeZg0DuK7cl63j2M2L03lUzfrca95DVDFw9UC+HJbLjy5tPNaD
         76ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ90PLBQGlCAw3nY7PdHj29lN4OGOB/GQ73QQhoiRXAxSQL/0y70D6OVQ8n9hubV5cihv1NJ9xTLfeuq@vger.kernel.org
X-Gm-Message-State: AOJu0YwomYgyaFfhwmf35k0yIgIomx9JxHJsNpVLZna+EiFfF9dHhPGP
	aQ67L9d8S2hph+kO1SUAEqv52DrZGgxfefwVAG9hlXzawMl6UOgDAUfRcJ7rcswAIlaRxntkU9W
	fRPsgxC0AmYmUpd3bDy5ju2WOtskjIz4=
X-Gm-Gg: AeBDiesr9HVid2Z+bA12X2cQicOk9ibJAJXTWxfQrCAr4DoMyCUTixh/RVviu5ksSx4
	YyZ1mHN8QEbiwNEAitoBhGJxxvgXuSeHBbZ1k2mD8jJjh9KPuCAJWVNa4MKJO5Ri0TQnGwqan70
	lAb0o+puXuFeAb57VymlF5UjjGV2A/sUt3PlJnJdW4sJx1wt+10L+kfqJW9/KIMBfXdvC81/9F0
	/RL3zsAxqd9iSsoqqdu4v1AU6AiIWPmmggWtPaBMO76MtMh0h2yDjGidW5r6pqloOg89ufJ42xw
	YO29vg==
X-Received: by 2002:a05:6214:4602:b0:8ac:74d7:dd17 with SMTP id
 6a1803df08f44-8ac862f1d3dmr206027766d6.50.1776086997355; Mon, 13 Apr 2026
 06:29:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com> <20260409095926.905020-9-rajasimandalos@gmail.com>
In-Reply-To: <20260409095926.905020-9-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Mon, 13 Apr 2026 06:29:46 -0700
X-Gm-Features: AQROBzCeE6jrulhnepsXQX_7tRjmDcNV5WQAOG8kWBHLKSDBR3FNxO2-EPpUZa4
Message-ID: <CAFTVevXf-sV8Z15Qyb=LtcjDRy64R6pyMwFVtpytqXpOmbR4Qw@mail.gmail.com>
Subject: Re: [PATCH 9/9] smb: client: apply rasize on remount
To: rajasimandalos@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	metze@samba.org, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

Before syncing the contexts, you should check if rasize has been
passed during remount at all. Else, we run the risk of overwriting
cifs_sb->ctx->rasize to 0 (the default value).
Please check how rsize and wsize handle this (a few lines above):

/* if rsize or wsize not passed in on remount, use previous values */
ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx->rsize;
ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx->wsize;

Thanks
Meetakshi

On Thu, Apr 9, 2026 at 3:08=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
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
> ---
>  fs/smb/client/fs_context.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index d804e5da578e..bba642442ae3 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1504,6 +1504,12 @@ static int smb3_reconfigure(struct fs_context *fc)
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>         rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
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
>
