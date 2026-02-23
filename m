Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39172C11F3
	for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771869779; cv=pass; b=rqXlyLAk/ftd0rXiQbUeUGabjk5I0Fw/67fj9kHXWhe/pYQV9JpHcmhJ6jnOycrEWgtT4JpwRLKAxIP/iCqqNPBGFRg+MsuWSarJv4/9fEpuCaxmFW9zHDvo5s0mqSC0gmFhLYxE+7BCO1W6mzlx8LwLZV1mIk95cj2eCVkKFlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771869779; c=relaxed/simple;
	bh=qBRDI6BEZ0nE8IdMYsEgUfj/X5w/rmTg/mdbug4JXig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K2uTb9gP1wImq+Q4DapsO8mWkX25Zy/4lBi48UZvNQp/uCN0UHWzLSIIA0fsPy6+GM/AN3DSLugNZxn41DDLEfV0q1ZRX1yJibHbcdfsdpVcGLwHZQb8eBRP/noOSZ7z7QEzxcYhLeYZgLFQmwt2h9zAjZvnFWwVasgoMtQCDAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fgFjT26Q; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fgFjT26Q"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64ad019bbd4so4158661d50.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 10:02:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771869777; cv=none;
        d=google.com; s=arc-20240605;
        b=bnaqsW4OXuOQwJUrG7noL+zQkgHIMLt4SsEryvPc2/djLALS0X6Y1rDA4GPCgyfYMy
         Fs23tjHduVGAAD8CUpbKG1LJE+j3KOAkz8gUjevHotX4v6qF78iSXMptviA5cDu2I2rx
         IEVc+4K/qsMq0Hv3sjq6kTfxKIw+dKqx7BdmcDlDVeXk+5y+OVS157bJ8xljVUBBxd6a
         RaZx5FWSlRnZOiOd2dc+VChb49QlrR9VFXy8Gb1lJFhENCYkzVzpF3clGwZt/2gmhRR4
         5dTqCP67bllH8K9SDXUs4cksTNyt/WmnwOzdNjjGGhO90rYtFqIdgtUontPom22mCfi+
         MhDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vFO9fzROge3r/1l97V1HzFX+mVimhnfNTCAPFErmLfw=;
        fh=MP9kIvotmFu9NitkKUvF2HRzbzs8h7PdWJR5ehaam2o=;
        b=PwZbMOfC8e9pyVm8YgBlyVgafa0FC/B+qhUpl+hcSK4TE86PQQ6BryQ6LMvl5cUriq
         dTe9AxYD9+V7smFBewy465h+hqpQE63SN1ci9hhytb8xmGtYNh4VQ0Bbc5xkIiwgnvH7
         /nuD6Ux3fZqxl0+fEmyd8SLCiNPWur2EFkPzrMZSxSeit+udTyFBTne3HEzqyKQ7WBFH
         gc6hA61DBUm8oiFGJ7SsHcfszMZJwbZ7sTRbe9mb9+al92a0CN4M/b4FvQAGY2e9/PsC
         WaWPNx5aTDJYvCXu7gP0Q54iJs0iWqi7t3E0Q8oZ0HRD+fhK9idaBjJkAk5fG2ARIlor
         4idA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771869777; x=1772474577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFO9fzROge3r/1l97V1HzFX+mVimhnfNTCAPFErmLfw=;
        b=fgFjT26Q6H1rZE0tfyBOLf6/vUGuNyTrHwc4H+8ScA3A5GGN7FWy0Svi6LROYjyutb
         qUkJxY9JiF90U7tFbKTeqeL4B6ME4pEIWpDRdISOPXnWa7UmsAy5NvByZxVDRX5XAxq3
         XxC8mzo0k1u8DSRb8pIexUkp/63XWrZp2k0BagxSZprv5nGgN0HaPQvziecQ5kwmBsXD
         Po8RTMgPNGpxlc//OCpwO15h8SCf2LFFSgb7VQOYbqE4muYmkck926cZmQ9t/fhhayO0
         BdDL4rq7fTM0u6sGFsLoIe1suNHPLXC7IbShuSaP1aydnEhdOOCodc7Hq6S5Qddr9dAe
         s73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771869777; x=1772474577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vFO9fzROge3r/1l97V1HzFX+mVimhnfNTCAPFErmLfw=;
        b=T1qEtOL3P5CLDzDR9LKpxORrl4vIITSisAloJ3e6UhP6EckdiFKwf1UedIl+7x/RPO
         inxp4BMk5XwtmU7BHFFGbm/9FQZXYLGYtD4infJpGy+my08naYuzXPbequtyaQ2eg/0/
         mMJW4REncVApI20plWyzKpHEh7BnJKhNwoFw4E6XGpDOxD3SP8R0xj2S1Lj9XMFCYPLp
         WXFsgTiVdfO1/XYNAGGrJSj0YTbYqK+uEiq3nFaNY5I6wtgpbe+hYO89OAWvYcQDp4T+
         8Ex4hjnyRUZYvwwYqGTuqgNoKc2ZvHCaFEnkBYRJ4itTFte8ehq7M78S0otP5JudApdk
         hHHg==
X-Forwarded-Encrypted: i=1; AJvYcCXbKcPIWv9brHcp6vxSJpmg02xXoQlOXvTBAhWT3uH/JXlzDyICSsXjzgW1D7CX3R29zMVHQ/KdO3Ua@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5FQdJGFxz/ZwIUpfqlT9uUOMqkWn/YVkCdd+zPithSFKA4rjj
	Bjgi7wBdu2D9ErZJVoc9j2J2NCPg4r/5IZ8laO86oRNBCxWX66PyZnzWF+77U5nOqUf8NnbnwJC
	Ij73kU7FkXcgTpeLC2kx6qarVFfb2Kp4=
X-Gm-Gg: ATEYQzx/rbkwL8B1ciHuoE03s1q1IxF3A7725+BSaTrSwwSdGtefNgXBmXB1Y0GbjiT
	xT4fhlcZdQzb8QP7KqSKkW8yfWpCz71A82gC8UFco9ALtPP5DILkFktvhK+tCR0vcj7LEA7NADt
	5TaQNdYrBNrmrba550FYIIyjmN5KIvpX2l71yvjrqkP78u2/0WOqQTLJkYFDafYv6WA/jMECzTo
	6SwOnTf4aaBO8F7wNVcj9YQH/Lo5f6CVGIj8ZHzfshycfHTMi3sbbWfF7A7usufsipIWh5smfvK
	lWjyBDjrDDMrsq9GOBcgusGsD+wKe/m9bFrB/LXZS7Cl+8xSRgxBztSNweHd2LY4gAWcgJEr9Mb
	f5P9FV9o6+5SF8NLeOVzg1HlT6+0EmD/HDL+JElSAxjgccr82BLYrbMqxpG09sXgUtE7nPybbyS
	Z9eYHJ1P9mECaxkaUofri0Aw==
X-Received: by 2002:a53:ad51:0:b0:64c:2581:eed9 with SMTP id
 956f58d0204a3-64c78f6478dmr6520954d50.70.1771869776452; Mon, 23 Feb 2026
 10:02:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mvDa8E8NKNHevoWYARY_52DJ+WQX3oetYw-pwysMyAKYQ@mail.gmail.com>
 <20251230164759.259346-1-alxvmr@altlinux.org> <20251230164759.259346-2-alxvmr@altlinux.org>
In-Reply-To: <20251230164759.259346-2-alxvmr@altlinux.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 23 Feb 2026 12:02:45 -0600
X-Gm-Features: AaiRm51yE8Tha1sY5qc4fjXh84W3GdRrcCmn6f3FtkMt9GFEglWSeoB_w_0BqKQ
Message-ID: <CAH2r5msi7CMC8gyHON2C9VzaeFHUJX3Ut_bJYbJ11OaxXocnpA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] fs/smb/client/fs_context: Add hostname option for
 CIFS module to work with domain-based dfs resources with Kerberos authentication
To: Maria Alexeeva <alxvmr@altlinux.org>
Cc: pc@manguebit.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, tom@talpey.com, vt@altlinux.org, 
	Ivan Volchenko <ivolchenko86@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng.

Maria,
Have you verified that behavior hasn't changed when hostname not
specified on mount - the fallback to default hostname code was a
little confusing to read?

On Tue, Dec 30, 2025 at 10:48=E2=80=AFAM Maria Alexeeva <alxvmr@altlinux.or=
g> wrote:
>
> Paths to domain-based dfs resources are defined using the domain name
> of the server in the format:
> \\<DOMAIN.NAME>\<dfsroot>\<path>
>
> The CIFS module, when requesting a TGS, uses the server name
> (<DOMAIN.NAME>) it obtained from the UNC for the initial connection.
> It then composes an SPN that does not match any entities
> in the domain because it is the domain name itself.
>
> To eliminate this behavior, a hostname option is added, which is
> the name of the server to connect to and is used in composing the SPN.
> In the future this option will be used in the cifs-utils development.
>
> Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
> Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
> ---
>  fs/smb/client/fs_context.c | 35 +++++++++++++++++++++++++++++------
>  fs/smb/client/fs_context.h |  3 +++
>  2 files changed, 32 insertions(+), 6 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index d4291d3a9a48..f0d1895fe4bb 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -177,6 +177,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] =
=3D {
>         fsparam_string("password2", Opt_pass2),
>         fsparam_string("ip", Opt_ip),
>         fsparam_string("addr", Opt_ip),
> +       fsparam_string("hostname", Opt_hostname),
>         fsparam_string("domain", Opt_domain),
>         fsparam_string("dom", Opt_domain),
>         fsparam_string("srcaddr", Opt_srcaddr),
> @@ -866,16 +867,23 @@ static int smb3_fs_context_validate(struct fs_conte=
xt *fc)
>                 return -ENOENT;
>         }
>
> +       if (ctx->got_opt_hostname) {
> +               kfree(ctx->server_hostname);
> +               ctx->server_hostname =3D ctx->opt_hostname;
> +               pr_notice("changing server hostname to name provided in h=
ostname=3D option\n");
> +       }
> +
>         if (!ctx->got_ip) {
>                 int len;
> -               const char *slash;
>
> -               /* No ip=3D option specified? Try to get it from UNC */
> -               /* Use the address part of the UNC. */
> -               slash =3D strchr(&ctx->UNC[2], '\\');
> -               len =3D slash - &ctx->UNC[2];
> +               /*
> +                * No ip=3D option specified? Try to get it from server_h=
ostname
> +                * Use the address part of the UNC parsed into server_hos=
tname
> +                * or hostname=3D option if specified.
> +                */
> +               len =3D strlen(ctx->server_hostname);
>                 if (!cifs_convert_address((struct sockaddr *)&ctx->dstadd=
r,
> -                                         &ctx->UNC[2], len)) {
> +                                         ctx->server_hostname, len)) {
>                         pr_err("Unable to determine destination address\n=
");
>                         return -EHOSTUNREACH;
>                 }
> @@ -1591,6 +1599,21 @@ static int smb3_fs_context_parse_param(struct fs_c=
ontext *fc,
>                 }
>                 ctx->got_ip =3D true;
>                 break;
> +       case Opt_hostname:
> +               if (strnlen(param->string, CIFS_NI_MAXHOST) =3D=3D CIFS_N=
I_MAXHOST) {
> +                       pr_warn("host name too long\n");
> +                       goto cifs_parse_mount_err;
> +               }
> +
> +               kfree(ctx->opt_hostname);
> +               ctx->opt_hostname =3D kstrdup(param->string, GFP_KERNEL);
> +               if (ctx->opt_hostname =3D=3D NULL) {
> +                       cifs_errorf(fc, "OOM when copying hostname string=
\n");
> +                       goto cifs_parse_mount_err;
> +               }
> +               cifs_dbg(FYI, "Host name set\n");
> +               ctx->got_opt_hostname =3D true;
> +               break;
>         case Opt_domain:
>                 if (strnlen(param->string, CIFS_MAX_DOMAINNAME_LEN)
>                                 =3D=3D CIFS_MAX_DOMAINNAME_LEN) {
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index 7af7cbbe4208..ff1a04661ef5 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -184,6 +184,7 @@ enum cifs_param {
>         Opt_pass,
>         Opt_pass2,
>         Opt_ip,
> +       Opt_hostname,
>         Opt_domain,
>         Opt_srcaddr,
>         Opt_iocharset,
> @@ -214,6 +215,7 @@ struct smb3_fs_context {
>         bool gid_specified;
>         bool sloppy;
>         bool got_ip;
> +       bool got_opt_hostname;
>         bool got_version;
>         bool got_rsize;
>         bool got_wsize;
> @@ -226,6 +228,7 @@ struct smb3_fs_context {
>         char *domainname;
>         char *source;
>         char *server_hostname;
> +       char *opt_hostname;
>         char *UNC;
>         char *nodename;
>         char workstation_name[CIFS_MAX_WORKSTATION_LEN];
> --
> 2.50.1
>


--=20
Thanks,

Steve
