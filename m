Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199D71519B4
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 05:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768800617; cv=none; b=fitfTj2jwP3fF28UTPLLEtBTddYyOaz8J91AFbNPR8iQLXdbLoi9zdTrBoxbtUahKx/Wfgy+MYNV45pAu9f2Zjipz1es20mbOhrccpiQqX2YAQUiBH7Eg7sjgq1aUZX0s/hmPVRUHwb7jtEfujuGvYUdqwQVZBZ8pl3BrnJG6JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768800617; c=relaxed/simple;
	bh=RyPx8KEWd4KJnb1b0QmwcCM+EcVBb5TUkbFAEccvs0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AjeKzsxzMDqenM5iJ8FUiymwVs5l6UKRdxAMUl2HSHa65Z2J9/1duqKhTib4gYjAm8FGiBjQ7lWHWvA5ouHASmNnkNDlu//9iMnmQKFxe1RPkxIA3ZI8cSeBBYiObtGIttQJmpm+VWk2YNKkPz5z8COw/lRx56Gck8UBkZnUJfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKIEFhGq; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKIEFhGq"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso8101443a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jan 2026 21:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768800614; x=1769405414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C9k76Br+Q+WxdY7O1w/viGg0SCaIwXt90RJF+siNjxE=;
        b=LKIEFhGqW5RSSem+O+40CO8DrnZRJzF09cnXZw/nk5GyExWMmAvoeFFV1qHbnSNHjM
         Um03vxA8YD3ComTnNL9c3msIt0mgVab7OXQp3N9QbIpAPK/bEj+lmjmF/l3+nCNV9WQJ
         Pgs8Tss5XhAqL9z/54Bkerj6fP0s2BYy3ZiqiItyjkdwozHVeefAiAA26HsTHn2GyCdY
         JD/rUC5FrxT1GQ6XtPVxBLVa7JJ795GblfSbmCPM5TohJ6fyrK5yHZMspbEnRdW+nR+T
         J9wYRY4xbCD4nzU2xD2BCvxw0LK0hGaOVO4eQXv71+f5p9QmGuUnznKCsDwyrdBa5Mp8
         dwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768800614; x=1769405414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C9k76Br+Q+WxdY7O1w/viGg0SCaIwXt90RJF+siNjxE=;
        b=fqgT9DT0vU/+I/TyoRuqgRdIeuXkeZK0yMe6rFI7qIXTmbOZqIHiXfYD3YUrWQNKLY
         RNOmQZJtUZ2gGEAj6Up/ALQC9vv215kCK7sXmsarGtNR+IPQBPGvs0C3k/un6rIsPF5F
         oTssG/Mc6/VxunsCGCANCOqyhLNhVBusc2gcUnXaFjiV3q+oiFaqvuAiv9Z3p1HvpzWd
         yX485nHJTAcgsWVa0Stseq1UrjLqKUnSCegqpn1n29yoOU0okPad4HRKAY18idJp6QJt
         WaKUcsvz/115CLSf6/6aYovQivHjHIEcj9j7mhntouu6lUts743Af8C5i6OWHLbjn275
         oDZA==
X-Forwarded-Encrypted: i=1; AJvYcCUKLMCUEaI2qxtAvsUkxVk86RVlGJLbpt2IuPn9IUhzg/AqrVTeHLbJ4uKq/ZwY6JsAuLzlqPZGmmOB@vger.kernel.org
X-Gm-Message-State: AOJu0YwJCz6APapV3tU1DTogmeahun/EsGBSLRdII6CshH2p5xaGCmIo
	CM8BlwJJ+XE3Y1ueyHwLKnoNwYsQlczy4EeX7QXAXk5pdSTUk5uWjf9DiLzVw83BC2L5boOpznU
	wmUkGQCcT2z5EWN+8PfETUKsoW9TLcm8=
X-Gm-Gg: AY/fxX7eifhaM4edf++8w63gvvUffjQ2O65rOQl0cHSBsqkDBeJyi+7eWZEST57wd6l
	9tRQXhekCr42+jNKSQ/itSHXhRMxrUj/cupcbsojYpXF6IvRBmzs6OLCs11DHQ/Np0PiJWDlS+E
	l1IYks+l8QtvPvUdnyYqMHwCYsYKu6bGQZHiw1emrW0rLswsQH+vsj79Row6/cjrLPb6vO5xq/1
	R5bdqq3CzhBBABfERCaa9sdO8q08ngfqnI8fpXT4wr5vdApimkCW1JyVhSUJfvKMPZzMA==
X-Received: by 2002:a17:906:f584:b0:b73:278a:a499 with SMTP id
 a640c23a62f3a-b879690c3ccmr765457866b.15.1768800614164; Sun, 18 Jan 2026
 21:30:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116220641.322213-1-henrique.carvalho@suse.com>
In-Reply-To: <20260116220641.322213-1-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 19 Jan 2026 11:00:03 +0530
X-Gm-Features: AZwV_QiL7jOtTY6qN2cLGp9CcH8huF9rKD9WvMyXPoUmYGm0NMgWjyhXjijbm5M
Message-ID: <CANT5p=r5+Fw6g-gyA25pw1pX_FCXtnxw2qUG8bt4iTNQnyrxUw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] smb: client: introduce multichannel async work
 during mount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Henrique,

Thanks for submitting the patch.

On Sat, Jan 17, 2026 at 3:37=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Mounts can experience large delays when servers advertise interfaces
> that are unreachable from the client.
>
> To fix this, decouple channel addition from the synchronous mount path
> by introducing struct mchan_mount and running channel setup as
> background work.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cifsglob.h |  5 ++++
>  fs/smb/client/connect.c  | 58 +++++++++++++++++++++++++++++++++++++---
>  2 files changed, 60 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3eca5bfb7030..ebb106e927c4 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1796,6 +1796,11 @@ struct cifs_mount_ctx {
>         struct cifs_tcon *tcon;
>  };
>
> +struct mchan_mount {
> +       struct work_struct work;
> +       struct cifs_ses *ses;
> +};
> +
>  static inline void __free_dfs_info_param(struct dfs_info3_param *param)
>  {
>         kfree(param->path_name);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index ce620503e9f7..d6c93980d1b6 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -64,6 +64,10 @@ static int generic_ip_connect(struct TCP_Server_Info *=
server);
>  static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_=
tlink);
>  static void cifs_prune_tlinks(struct work_struct *work);
>
> +static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
> +static void mchan_mount_free(struct mchan_mount *mchan_mount);
> +static void mchan_mount_work_fn(struct work_struct *work);
> +
>  /*
>   * Resolve hostname and set ip addr in tcp ses. Useful for hostnames tha=
t may
>   * get their ip addresses changed at some point.
> @@ -3899,15 +3903,61 @@ int cifs_is_path_remote(struct cifs_mount_ctx *mn=
t_ctx)
>         return rc;
>  }
>
> +static struct mchan_mount *
> +mchan_mount_alloc(struct cifs_ses *ses)
> +{
> +       struct mchan_mount *mchan_mount;
> +
> +       mchan_mount =3D kzalloc(sizeof(*mchan_mount), GFP_KERNEL);
> +       if (!mchan_mount)
> +               return ERR_PTR(-ENOMEM);
> +
> +       INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
> +
> +       spin_lock(&cifs_tcp_ses_lock);
> +       cifs_smb_ses_inc_refcount(ses);
> +       spin_unlock(&cifs_tcp_ses_lock);
> +       mchan_mount->ses =3D ses;
> +
> +       return mchan_mount;
> +}
> +
> +static void
> +mchan_mount_free(struct mchan_mount *mchan_mount)
> +{
> +       cifs_put_smb_ses(mchan_mount->ses);
> +       kfree(mchan_mount);
> +}
> +
> +static void
> +mchan_mount_work_fn(struct work_struct *work)
> +{
> +       struct mchan_mount *mchan_mount =3D container_of(work, struct mch=
an_mount, work);
> +
> +       smb3_update_ses_channels(mchan_mount->ses, mchan_mount->ses->serv=
er, false, false);

I would keep the comment descriptions of the last two args.
Makes it easier to read.

> +
> +       mchan_mount_free(mchan_mount);
> +}
> +
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>  int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx=
)
>  {
>         struct cifs_mount_ctx mnt_ctx =3D { .cifs_sb =3D cifs_sb, .fs_ctx=
 =3D ctx, };
> +       struct mchan_mount *mchan_mount =3D NULL;
>         int rc;
>
>         rc =3D dfs_mount_share(&mnt_ctx);
>         if (rc)
>                 goto error;
> +
> +       if (ctx->multichannel) {
> +               mchan_mount =3D mchan_mount_alloc(mnt_ctx.ses);
> +               if (IS_ERR(mchan_mount)) {
> +                       rc =3D PTR_ERR(mchan_mount);
> +                       goto error;
> +               }
> +       }
> +
>         if (!ctx->dfs_conn)
>                 goto out;
>
> @@ -3926,17 +3976,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, stru=
ct smb3_fs_context *ctx)
>         ctx->prepath =3D NULL;
>
>  out:
> -       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> -                                 false /* from_reconnect */,
> -                                 false /* disable_mchan */);
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
But otherwise, this looks good to me.

--=20
Regards,
Shyam
