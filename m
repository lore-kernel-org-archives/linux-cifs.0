Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35131E5724
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 08:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781254300; cv=pass; b=n/AjFAVrrelU0zF4V6ieaz/fLKV9WcvhozH5SrzwGEQpwR3amMI9CAUtA+s15BMFFF1VoKgd/p6EdZMnXfYKnkpKwpiN8AHpdCkGLm78P5RRfOx7DcxQIPi+Z4nJB1ashgo4XLs5D0H7K4lTStU6E4ULfhA21IPgCf80uTUDJpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781254300; c=relaxed/simple;
	bh=JmCDfOYh+7S0anaYh38N4BioTJWMoWmpFxTQJGHMBLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ObcOnJDPWi9UWNJ6kCHLcMdlQzsnK60n4zGmcLBWNJXkfj3gd7iePerVUAKzh6rkCcyVUmca0HFzr3XA5oyVvKcCQvAJn2+V3309Ug0uMwiCA7C5UF+UfxYGWauJ1fo4gxV3sl6UyZR2OzUhFtv0jkbRf6Bqvn1SekcqyNMn2L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LzUrHPRi; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzUrHPRi"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8cd45d4b7e2so8605576d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 01:51:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781254298; cv=none;
        d=google.com; s=arc-20240605;
        b=Qz/cDZblKa9ej7Otx6wbrj3o13HPHk5EmZcxrkUSoBT/LUlYGnRonywhFAF04h5CXE
         eiAld7ykrFeNDfcKo22rr6gfU0hLQ1HZbMvK+TQpYWZgwUq2Kpkekp8rqrxmJ7SMELSD
         g7yaIptBygkjFPAbNK0nK8FEr4lXi2/bSA/CSaje7zrP1iBtHWaoOY+UKOk3pFyCxlD8
         b3O3p8NfTI8rN6a5n/EEtk1tXregdZz2HftN/R/Fm9L9Li5KIC6Q9TVQpDsI7VbfArJL
         glnsUUCJ0zLaSPHKOhJarp5bBl7WpHObyzADzUN9wqfwQsY2rF5CRHQWS6YijpANutwC
         foIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K6lWSGsBJpwHMQzHL9yX3C6VB6y0o6yuEP7XHnWFdgE=;
        fh=2q/Ryb3iCCRR8n5aD09MXr+I17pSztr7R9UofffNzBw=;
        b=jSmPRH7PVQEu01oO959Ult2HG8JUn+G7J0f2N1iURBb50Lcdv7Twh1RF4vJdgMSVOB
         O9IyGh3v9h4d24GNdoYXLnoZ0WiTX0n9u0Mm96ykRXYMNvm4DRVQxovpOuk/ESO9TzoO
         eM7DINE9TNYSm2fdnurxwGlae1DNg9/HILZuC9A2jTPLXHQ2brDTPSgnr+2LJVYzAww/
         OlB291AtAOdVzhvHBdIrsRFPIvWeDZgjf774SqIA/qr7+sM2J+8cscF0Di2/sTMJJsYm
         9rdfW6B5Kw897qiisTBZoXzRAuAjb0OveGhzA+HALe2Omasd7+fGZsGT9W06vzc1mM0c
         jniA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781254298; x=1781859098; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6lWSGsBJpwHMQzHL9yX3C6VB6y0o6yuEP7XHnWFdgE=;
        b=LzUrHPRi+8DZ5ceFZ5XRh94VitEcrZacZHVND0t88EDOM8WUyAM4tZtv4RxbIG9JpT
         i9scm7oZYzFAxCrKM3Uky6J4a6yL4m9oIIauP3eTTt+jCEC7migJQB9Lfp7s9/nKUCOl
         D9VbsWLYNBtz829lC6oIWDACLPXGC6LWZGxYZsQk74wAv27okIFAdgk1VOhnGUlUE6ga
         s1HA+ERhEPbJ3gmksIV/0fwPuxBRpckXXLOI52Fq7yp4nTg6NTTN1EYWjAx1a8fTAiLa
         T4PNGq3fs8pXnToLhQnoDKM92GrYrn4jp2/jzfz3RcI43zbDoBx/M64gRmpM5ED2EI+4
         ADtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781254298; x=1781859098;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K6lWSGsBJpwHMQzHL9yX3C6VB6y0o6yuEP7XHnWFdgE=;
        b=blkb8C9yEDm4R6HtYRT+5d6PtR+1MRArEeNOBrSQDPQk/AyA7hJ/GXeNZpy/yo9kRm
         7pBZk9pKpUQik2XVhm9rDd5PdcC4ZoXVU6Cs5kighcr7S9z1pRuYNWAHr0yre+F31n4B
         cdt9pSCT0MrPIe3VjD3EjDrtdnEM6nMG6irhthn4VcpryvjdPlN8eJYpHPcrnvfdTwid
         hgXH8hNC06ytwiX7t+GzA1YWOeti4zoE7EWSLV7SP3vFrPUelMxPxuSSA+7NXKYnLH9D
         nYsO8u/Mq1T+xjCjMz0qr0i8SbGv6XAMFm7guXVjZsq20Ff9be6IldK/HmVLS97n2Bn9
         QYIg==
X-Forwarded-Encrypted: i=1; AFNElJ9W6hlfgxTeTxZqsKfjFp99ROGCI1eABvncjgpFjqodwzHXSTAXVQGU5BhYh0Wm+U+/QWgFsmYr9mqU@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0khkiu1bSTJyN3CSOJMRKGYPtnNiKGEqt7MgdaCr2yCa0Vx4p
	+kuY6k5Vc3oAy7ImAQckYq39LBLAO8435TzEolmEgGbolFT9O32RIjQJO5bksQzJBrbeEO0yFYM
	Q0N3sbGZQmdC2iv4qq74s0kc0K7gpPw4=
X-Gm-Gg: Acq92OG/Bjo6V6j+UYkjLmO1AbDkAzPNiClALkPCD+idajEtF/mBjhKjhJSJbrIiDLG
	nFBHl+hVR1CmaZXAouEIYWyg6+xFrM3sLXqZpOrM/idllf9p6beLQ8b5VqVyrdenByv4hdm/E23
	RlotIULi/Tp9TbU038nKgJZuTnaoEGLDOnOE+7YmqB+TXApizK31ifVT15+vv60lOM0dGUn5Jzp
	bqTYOCGHW1t2fWdEmhSb5X23b6gMnh6zZQkwO7rgrhAua3FP3MboC4IMjSH8SjErzxo3orNg4z2
	iqjayA==
X-Received: by 2002:a05:6214:4888:b0:8cc:3546:2608 with SMTP id
 6a1803df08f44-8d32bd2d6bdmr33524546d6.8.1781254297748; Fri, 12 Jun 2026
 01:51:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779371115.git.rajasimandal@microsoft.com> <c9d3b7dfc9aab1db3376eae3cdd32f4da1457a91.1779372325.git.rajasimandal@microsoft.com>
In-Reply-To: <c9d3b7dfc9aab1db3376eae3cdd32f4da1457a91.1779372325.git.rajasimandal@microsoft.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 12 Jun 2026 01:51:26 -0700
X-Gm-Features: AVVi8CeBGvQmMKlhhH_RQjHwPMGaROUr13YVfkAk2hDOAuWSWHwoahEl4HTywZU
Message-ID: <CAFTVevU4uf3g=crEkWGPYv942=nbj_LTMVqkHjJSb1P4Vq5+9A@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] smb: client: apply rasize on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Thu, May 21, 2026 at 7:07=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
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
>  fs/smb/client/fs_context.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0ef8ccd53882..1b42af418f77 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1367,7 +1367,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> -       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
> +       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize, rasize =
=3D ctx->rasize;
>         char *new_password =3D NULL, *new_password2 =3D NULL;
>         bool need_recon =3D false;
>         bool need_mchan_update;
> @@ -1431,9 +1431,10 @@ static int smb3_reconfigure(struct fs_context *fc)
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
> @@ -1522,6 +1523,12 @@ static int smb3_reconfigure(struct fs_context *fc)
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
