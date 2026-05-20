Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B462DF134
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779240234; cv=pass; b=o7cArdYVys0UMLDm/XU4c1V5BY6KcmcvYh3G5frZTpQA6guy1S/Rv3XurjrkYUVyGG9Rtn4Z/x25dr/QOsfHKqE+JIh+ogxFHaT+cGAVODMNAJvj0JQ9nOJ3dmfs2M0q+f6W0F/w3vzUI2gd3CWY/MZkzZbxxOs0o3nXdKQX8ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779240234; c=relaxed/simple;
	bh=Bmz9pB0STLjQ0bbinEUxCdyhHQ91R2NK9xI7G1i13hI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qq05zaN3ap+Corb7+aqhuEV3ywwpsMRKSRcyCm5MYtvb3qAWE/hV1x0cT6f1bVyMjhiwrPckWKURZiMhHUjNHpx7DnCF8UG6NcEnYbTXOWmlnTj8bGwBzTgmmT4pk+kPxQ0zxugSwdVgpIfhp2IZ4ELFJz5FAfkAYgupy7uSbQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1jCa1+j; arc=pass smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1jCa1+j"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-636970cf66cso3208899137.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 18:23:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779240231; cv=none;
        d=google.com; s=arc-20240605;
        b=lxCB3wftwI/1Ioq9qTs8YkIndcFCD8ABUIVU/eGigiQDBuPIsoPDtwUuSRzvP6reG8
         3736kEC9L3jED7Xgmiu52kjokxEy93zxXLfA3MGcf0rYWcTxr6ufz5PY9Px8Cm0HYtHx
         9fDBGKTt/fcPvEfwtLBLPWqNv3DGb2yfyIQ/1fRgNED0nJUtEiIoJjoq0qjWr3hCkErU
         iY538Bh+NxW/Vmu4QCP9uEEAl8cHp07PgUmFJN9npVZoEVArIUTM9r1PNSuSEjZNyakJ
         hcj0XJHPcPYNzH4i4mBTJoWieijhk+dpsMBzxO+XraGbrx1AAd4rWdOfPaD4pJxxANkx
         P6zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a4SgDoIhHpEcjnMITXQX4jAgqUnogobUmuC9FvWDQNE=;
        fh=XVRIClcNV2gYt2raLKtr1WiemEyVqM5BbNs2+Yh1Snk=;
        b=lBvOnP+nTkQUeQioI4JODNrJqVzds6+jHDFhp3Xmw+jn37de3VsWwU1WaxP2J5MjQ1
         badKKotOB/Hz8tEgyflD4DIFlKt1wilWSjUKMC8Pg31K2cQOJijmYCxceh+xL9DR8t/v
         xKZs+gppFrmVkOptt8vdKMIz3RELZwVvYNwZJEHbhcq7SV+dG/ypghcnbRzYWrO6RfTu
         +JGjym33hCfi7I7++waNzRsUa1JxAOFEXviOdX3p9izkISKaljqMz0yHEe+96WRA73qD
         jPvRWEc0en4AkZvm2Ca4UHE3ieinGDjusS/ovWaGrsviz7Jq0ippGf97FJN1IcAmZlT+
         iI5Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779240231; x=1779845031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a4SgDoIhHpEcjnMITXQX4jAgqUnogobUmuC9FvWDQNE=;
        b=V1jCa1+j90U6pHkPYSSdBD68rdekjNkgP+Up+/5pOUbazPWwMdVhS1Ullm+1oyCbA8
         DxE7xyQpEDDDSxoB0F+qfsPQu6QDJi0GXf1v3YehFSCow6b6cSB6FS44esZ/p5RDEzNM
         ra4vmK2f1xsCpGBKBhOfS79xxDzWyFh0wYkLcduXNFsOgBEpk9nC3Hk2hBX9uhh37Ia9
         7MHAuPfjHq9eXHFC7wZBhUif7qPyLvauCE0v8iDYoVoQsGkg7VsBkwr9kzjiUAfTEVnl
         z0/kO1oRrlKyd+l1uEbJCEA14Vm1Y/lGq+ukUB/H424KutkJEu+DN3XaZpBeKnmDS7/c
         qaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779240231; x=1779845031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a4SgDoIhHpEcjnMITXQX4jAgqUnogobUmuC9FvWDQNE=;
        b=HtaFbboFEEyj/GrmM/bhIDWAgnTUa1b93ME6C8CeYnGheUy8vnSuw3ayp8Xf2loux9
         wKC3Az6wjuBQGZtg+R0Kocwjee41b/nWJCKMq+R6aKwoJBV7c8kh23Xh3cueyjDOxpvs
         zysvtmki40aFNeU/VimmaVGHtaY4oWyDrJIRDTR4qL04z8eefdQI0WH43vpHiTWTO+Qi
         lqvYw2g242gzkrHLA4hJR4aJhdM3eGW3y/SfIjhkC/Mq0Ap3QK5jvdw4/5qzff0JuLS3
         4QZrQ06L4vmGwZ76JTxn8qiW9PjYlD5mV0gWLpnmM2rXV3Hglt3JsajJAGXlokYsYecu
         qQ3w==
X-Forwarded-Encrypted: i=1; AFNElJ802II1PGGT3feU+bh07XYM9CefPjqMXOj9/X5H8ayGfqxIcfScjr72BIUXMsf9dnrw8qK9Ym0KML+D@vger.kernel.org
X-Gm-Message-State: AOJu0YzLPtOpCYx82DzA49HiBD+mSVrGZkod8WKmi9KS/J3Lecs5h5I1
	5Ylw47lS8WYQbwV1HgjW0tkhS/exBchu9KXHcoymx7j4Uu5rBNcAeXbNplpzDNINQmmCyU8Cmh1
	vRJnNu4PzEsAfK1R1nHDaWW/xAdFqhTPCk7xD
X-Gm-Gg: Acq92OG1d2hOHHfG9HC5yUR1SUlm8DuHnBA6rqJEMq/lKPkNjXYVNVHB965DWhbKnhs
	D90ymRkSqK3QrQrPXaFseCJnrFlu+29utmSrFA4XuAyKlK4/PFtZISGDt7sgqZ8xSRNCf34wdq2
	AXTLcVGw5GIuthGSEtfkhPGNUoaPWmBNxM8tO6E//HV9Ri86993FhQB7Hrcs6UHknqBrAIov6tJ
	D7vk3tLkWZUfl5NS/MkM5GOAaakrTEvRRFjklQP1X6mheu3a6kaEBKeEtiGMO/ZaP4U6yCB45Ft
	c+AymCc1
X-Received: by 2002:a05:6102:3911:b0:632:b111:965a with SMTP id
 ada2fe7eead31-638b70ad67fmr11174267137.11.1779240230807; Tue, 19 May 2026
 18:23:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260519001241.553855-1-FredTheDude@proton.me>
In-Reply-To: <20260519001241.553855-1-FredTheDude@proton.me>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Tue, 19 May 2026 18:23:40 -0700
X-Gm-Features: AVHnY4LJuct7t7Xd-CFexz_e6hHnnjNLSR2hobaygPQMMr7tPcC9TBN2zTe9S08
Message-ID: <CAAk_H6GdHJKWUE6sU5j1XvOxda__nph+MgR1HVtHKWwktsjivA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix memory corruption in smb3_reconfigure()
To: sfrench@samba.org
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Steve and list,

Please disregard this patch. I see that DaeMyung's patch series
("cifs: client: stage smb3_reconfigure() updates and restore ctx on failure=
")
was merged into 7.1-rc4, which addresses this exact state-corruption path.

Apologies for the noise.

Best regards,
Fredric Cover

On Mon, May 18, 2026 at 5:14=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> smb3_reconfigure() modifies the active volume context directly.
> If smb3_fs_context_dup() fails to allocate space when copying strings
> of a new context into the volume context, it clears the volume context.
>
> Add staging logic (tmp_ctx) to ensure that either the volume context
> stays the same on errors or is updated with the new state, and is
> never cleared.
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/fs_context.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b9544eb03..3a6f207a5 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1082,6 +1082,7 @@ static void smb3_sync_ses_chan_max(struct cifs_ses =
*ses, unsigned int max_channe
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> +       struct smb3_fs_context *tmp_ctx; /* used for copy of ctx to cifs_=
sb->ctx */
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> @@ -1205,13 +1206,19 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>         ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
>         ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
>
> -       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> -       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> -       smb3_update_mnt_flags(cifs_sb);
> +       tmp_ctx =3D kzalloc_obj(*tmp_ctx, GFP_KERNEL);
> +       if (!tmp_ctx)
> +               return -ENOMEM;
> +       rc =3D smb3_fs_context_dup(tmp_ctx, ctx);
> +       if (!rc) {
> +               smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> +               memcpy(cifs_sb->ctx, tmp_ctx, sizeof(*tmp_ctx));
> +               smb3_update_mnt_flags(cifs_sb);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> -       if (!rc)
>                 rc =3D dfs_cache_remount_fs(cifs_sb);
>  #endif
> +       }
> +       kfree(tmp_ctx);
>
>         return rc;
>  }
> --
> 2.53.0
>
