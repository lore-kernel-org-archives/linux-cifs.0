Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47E1EB5CE
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 15:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745941059; cv=none; b=J/MFkbdQdmPPOcrI31ebuCQGD/8uJLv+0vgTqv+bHJjm1rar6qsyFbpRuw3Ec0DY9z4JKQp2bb3QMTEK19FR35AEqHJqGWgvxrkOgMjFiUat919zc0Ht9yj454B6EGAtx5VMaj87MZ6VVl8i5HV7BA7pnCO+MK6k402yPplMSOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745941059; c=relaxed/simple;
	bh=6+xRLjF5VXF/KaNVVkp3ej3YioWLr1gPTI5nM9lUy7A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pAJx960FENihkCFCmCIZRyhtWsfbk02FF0Bjrpmzj8VawtjV5ebdN33E6raDZZnZizN8dabqRdYjIF+eAQJeNB8OlMIxDyQ4ON+vHJguZ6tbgva19StaofnDvVxeFlSl/y3XT7x5tD4aK9agEtrhiahTukORGcuBUA9Qeezrljo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPlIY7Tp; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPlIY7Tp"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-317f68d0dffso66277401fa.2
        for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 08:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745941056; x=1746545856; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FL3wZlS8B1ZLTzV0nKmmfl2l7OguUKLVmyJdeeoK/VA=;
        b=RPlIY7Tp8yWtvOYfEYciOaa3W/Rot1KGiw111LYSXHBwbfoplkGSeVbTeDXalK86VK
         1wMw4RDf9b+EQ9LI54KplX1lJKP3+Aytc1NWjoiNX6WOJfSQmDR2NrvgHgp3iFZNYPA1
         +vcW+lKcW5UPwanbjUWmDo884aDhBWRumYRWcvhIEK1zmhxl0eRzwTCEEyj8csKbXpSn
         IzSEd5w1YxKUreeEdC6Qg/xhb3EXRWlMmyJ5puiHKSe99tbfFVeJctgq8av3m8D59UTj
         Q7ExzEy0hi3w5sHcNEO3xlerj7Znje3iQz3qU6My1icYGgGvIojsOZ2vu2Co+jg1TGkp
         kweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745941056; x=1746545856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FL3wZlS8B1ZLTzV0nKmmfl2l7OguUKLVmyJdeeoK/VA=;
        b=Mviv70MpcMgrlEcwQpMqq8oozYQ7ANCr0bTbnDdK1Iq1QC5z1Ob3sBxtnRlaVYnnt9
         Dlp58vLINHLJr42fomvov+H4TYyfrNp5qLlwF1s8ebEOpZi63096MReirVxdeD1F/tIe
         /2uY3QlEfee4my0oKzurHG+jcUC/LmXXIXqYjl2D5OBD616970rN+MSGg9VOpzsvBWcw
         aG8VkCRH5nXrvcdQFe0QmlIgEP/LOue1GSZvae/yZiXVLAnPbbNi6/EouAX3EqjU9ykF
         dsOdErhBib6PpE942ih7w/1KQGAf0Q5cAQW+y8lpQhQk5YtJ0yCBriliwNwkeN1KK/4f
         Tzow==
X-Gm-Message-State: AOJu0Yx/b15DF9M8x1agYVXZ1XI/SzoADft/HiBzk+phH1WuMioSOyLK
	IC/tO9CVimrQIJMPuGAeX7XKewJg1B+ljMvjVoBW4L5PdRnsLO/EyU0JBu2EIOsZUieQEIBJApj
	STX6gPJFa4//UaAC0Pg6TbvA8o5KflQ==
X-Gm-Gg: ASbGncufnKmXQkTv18wtUCutqGdgySGLv8I5zup6xaNj+BrjbURTM2kUzdR7Xr1SkU5
	BgDUVQ479GA8zi+oVr8PVJ42aaasxcH2gTtKKpPoua7/4i7K1iTVpAAFgCXVsuUWjINZkZx/0VK
	PyA7+keppA/I8IxSNrsquqZGWWdsRuP9acgWUFYel1GlR8WckHpH3WCjZ6
X-Google-Smtp-Source: AGHT+IG1rKl06uJQ9sc92CR1YPL/JdlZm5EDIx5x7pbVf2adwjKCOt0RUtblDEvOQQLZ0olqQQhK2jEFtlXJSB9UKKc=
X-Received: by 2002:a2e:a5c2:0:b0:30d:b309:21b6 with SMTP id
 38308e7fff4ca-31d5a732658mr11564461fa.6.1745941055275; Tue, 29 Apr 2025
 08:37:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250429151827.1677612-1-pc@manguebit.com>
In-Reply-To: <20250429151827.1677612-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 29 Apr 2025 10:37:22 -0500
X-Gm-Features: ATxdqUEp9TPRQhvds6sZ2kE0UIvt1q95QevHfkTtVvxOCUU-RpyZ9A53fFIA-Qc
Message-ID: <CAH2r5mt_jzayXwXG6R5P1cPv5McSKATW6va6Ei=xghD-swB=Rw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: ensure aligned IO sizes
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Do you have a repro example?

Could this have negative performance impact to some servers?

On Tue, Apr 29, 2025 at 10:18=E2=80=AFAM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Make all IO sizes multiple of PAGE_SIZE, either negotiated by the
> server or passed through rsize, wsize and bsize mount options, to
> prevent from breaking DIO reads and writes against servers that
> enforce alignment as specified in MS-FSA 2.1.5.3 and 2.1.5.4.
>
> Cc: linux-cifs@vger.kernel.org
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/cifsglob.h   |  2 ++
>  fs/smb/client/connect.c    | 23 +----------------------
>  fs/smb/client/file.c       |  6 ++----
>  fs/smb/client/fs_context.c | 25 ++++++-------------------
>  fs/smb/client/fs_context.h | 32 ++++++++++++++++++++++++++++++++
>  fs/smb/client/smb1ops.c    |  8 ++++----
>  fs/smb/client/smb2pdu.c    |  8 ++------
>  7 files changed, 49 insertions(+), 55 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 3b32116b0b49..24c2cd9532a9 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1024,6 +1024,8 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
>  #define CIFS_DEFAULT_NON_POSIX_RSIZE (60 * 1024)
>  #define CIFS_DEFAULT_NON_POSIX_WSIZE (65536)
>
> +#define CIFS_IO_ALIGN(v) umax(round_down((v), PAGE_SIZE), PAGE_SIZE)
> +
>  /*
>   * Macros to allow the TCP_Server_Info->net field and related code to dr=
op out
>   * when CONFIG_NET_NS isn't set.
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index df976ce6aed9..6bf04d9a5491 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3753,28 +3753,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt=
_ctx)
>                 }
>         }
>
> -       /*
> -        * Clamp the rsize/wsize mount arguments if they are too big for =
the server
> -        * and set the rsize/wsize to the negotiated values if not passed=
 in by
> -        * the user on mount
> -        */
> -       if ((cifs_sb->ctx->wsize =3D=3D 0) ||
> -           (cifs_sb->ctx->wsize > server->ops->negotiate_wsize(tcon, ctx=
))) {
> -               cifs_sb->ctx->wsize =3D
> -                       round_down(server->ops->negotiate_wsize(tcon, ctx=
), PAGE_SIZE);
> -               /*
> -                * in the very unlikely event that the server sent a max =
write size under PAGE_SIZE,
> -                * (which would get rounded down to 0) then reset wsize t=
o absolute minimum eg 4096
> -                */
> -               if (cifs_sb->ctx->wsize =3D=3D 0) {
> -                       cifs_sb->ctx->wsize =3D PAGE_SIZE;
> -                       cifs_dbg(VFS, "wsize too small, reset to minimum =
ie PAGE_SIZE, usually 4096\n");
> -               }
> -       }
> -       if ((cifs_sb->ctx->rsize =3D=3D 0) ||
> -           (cifs_sb->ctx->rsize > server->ops->negotiate_rsize(tcon, ctx=
)))
> -               cifs_sb->ctx->rsize =3D server->ops->negotiate_rsize(tcon=
, ctx);
> -
> +       cifs_negotiate_iosize(server, cifs_sb->ctx, tcon);
>         /*
>          * The cookie is initialized from volume info returned above.
>          * Inside cifs_fscache_get_super_cookie it checks
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 9e8f404b9e56..851b74f557c1 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -160,10 +160,8 @@ static int cifs_prepare_read(struct netfs_io_subrequ=
est *subreq)
>         server =3D cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
>         rdata->server =3D server;
>
> -       if (cifs_sb->ctx->rsize =3D=3D 0)
> -               cifs_sb->ctx->rsize =3D
> -                       server->ops->negotiate_rsize(tlink_tcon(req->cfil=
e->tlink),
> -                                                    cifs_sb->ctx);
> +       cifs_negotiate_rsize(server, cifs_sb->ctx,
> +                            tlink_tcon(req->cfile->tlink));
>
>         rc =3D server->ops->wait_mtu_credits(server, cifs_sb->ctx->rsize,
>                                            &size, &rdata->credits);
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 2980941b9667..f8fef852a9fb 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1021,6 +1021,7 @@ static int smb3_reconfigure(struct fs_context *fc)
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> +       unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
>         char *new_password =3D NULL, *new_password2 =3D NULL;
>         bool need_recon =3D false;
>         int rc;
> @@ -1103,11 +1104,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>         STEAL_STRING(cifs_sb, ctx, iocharset);
>
>         /* if rsize or wsize not passed in on remount, use previous value=
s */
> -       if (ctx->rsize =3D=3D 0)
> -               ctx->rsize =3D cifs_sb->ctx->rsize;
> -       if (ctx->wsize =3D=3D 0)
> -               ctx->wsize =3D cifs_sb->ctx->wsize;
> -
> +       ctx->rsize =3D !rsize ? cifs_sb->ctx->rsize : CIFS_IO_ALIGN(rsize=
);
> +       ctx->wsize =3D !wsize ? cifs_sb->ctx->wsize : CIFS_IO_ALIGN(wsize=
);
>
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>         rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> @@ -1312,7 +1310,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                                 __func__);
>                         goto cifs_parse_mount_err;
>                 }
> -               ctx->bsize =3D result.uint_32;
> +               ctx->bsize =3D CIFS_IO_ALIGN(result.uint_32);
>                 ctx->got_bsize =3D true;
>                 break;
>         case Opt_rasize:
> @@ -1336,24 +1334,13 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
>                 ctx->rasize =3D result.uint_32;
>                 break;
>         case Opt_rsize:
> -               ctx->rsize =3D result.uint_32;
> +               ctx->rsize =3D CIFS_IO_ALIGN(result.uint_32);
>                 ctx->got_rsize =3D true;
>                 ctx->vol_rsize =3D ctx->rsize;
>                 break;
>         case Opt_wsize:
> -               ctx->wsize =3D result.uint_32;
> +               ctx->wsize =3D CIFS_IO_ALIGN(result.uint_32);
>                 ctx->got_wsize =3D true;
> -               if (ctx->wsize % PAGE_SIZE !=3D 0) {
> -                       ctx->wsize =3D round_down(ctx->wsize, PAGE_SIZE);
> -                       if (ctx->wsize =3D=3D 0) {
> -                               ctx->wsize =3D PAGE_SIZE;
> -                               cifs_dbg(VFS, "wsize too small, reset to =
minimum %ld\n", PAGE_SIZE);
> -                       } else {
> -                               cifs_dbg(VFS,
> -                                        "wsize rounded down to %d to mul=
tiple of PAGE_SIZE %ld\n",
> -                                        ctx->wsize, PAGE_SIZE);
> -                       }
> -               }
>                 ctx->vol_wsize =3D ctx->wsize;
>                 break;
>         case Opt_acregmax:
> diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> index d1d29249bcdb..6ae51e27b4ce 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -361,4 +361,36 @@ static inline void cifs_mount_unlock(void)
>         mutex_unlock(&cifs_mount_mutex);
>  }
>
> +static inline void cifs_negotiate_rsize(struct TCP_Server_Info *server,
> +                                       struct smb3_fs_context *ctx,
> +                                       struct cifs_tcon *tcon)
> +{
> +       unsigned int size;
> +
> +       size =3D umax(server->ops->negotiate_rsize(tcon, ctx), PAGE_SIZE)=
;
> +       if (ctx->rsize)
> +               size =3D umax(umin(ctx->rsize, size), PAGE_SIZE);
> +       ctx->rsize =3D round_down(size, PAGE_SIZE);
> +}
> +
> +static inline void cifs_negotiate_wsize(struct TCP_Server_Info *server,
> +                                       struct smb3_fs_context *ctx,
> +                                       struct cifs_tcon *tcon)
> +{
> +       unsigned int size;
> +
> +       size =3D umax(server->ops->negotiate_wsize(tcon, ctx), PAGE_SIZE)=
;
> +       if (ctx->wsize)
> +               size =3D umax(umin(ctx->wsize, size), PAGE_SIZE);
> +       ctx->wsize =3D round_down(size, PAGE_SIZE);
> +}
> +
> +static inline void cifs_negotiate_iosize(struct TCP_Server_Info *server,
> +                                        struct smb3_fs_context *ctx,
> +                                        struct cifs_tcon *tcon)
> +{
> +       cifs_negotiate_rsize(server, ctx, tcon);
> +       cifs_negotiate_wsize(server, ctx, tcon);
> +}
> +
>  #endif
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index 0adeec652dc1..b5c9915a97c8 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -432,7 +432,7 @@ cifs_negotiate(const unsigned int xid,
>  }
>
>  static unsigned int
> -cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx=
)
> +smb1_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx=
)
>  {
>         __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
>         struct TCP_Server_Info *server =3D tcon->ses->server;
> @@ -467,7 +467,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct s=
mb3_fs_context *ctx)
>  }
>
>  static unsigned int
> -cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx=
)
> +smb1_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx=
)
>  {
>         __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capability);
>         struct TCP_Server_Info *server =3D tcon->ses->server;
> @@ -1161,8 +1161,8 @@ struct smb_version_operations smb1_operations =3D {
>         .check_trans2 =3D cifs_check_trans2,
>         .need_neg =3D cifs_need_neg,
>         .negotiate =3D cifs_negotiate,
> -       .negotiate_wsize =3D cifs_negotiate_wsize,
> -       .negotiate_rsize =3D cifs_negotiate_rsize,
> +       .negotiate_wsize =3D smb1_negotiate_wsize,
> +       .negotiate_rsize =3D smb1_negotiate_rsize,
>         .sess_setup =3D CIFS_SessSetup,
>         .logoff =3D CIFSSMBLogoff,
>         .tree_connect =3D CIFSTCon,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c4d52bebd37d..4590beb549e9 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -4092,12 +4092,8 @@ static void cifs_renegotiate_iosize(struct TCP_Ser=
ver_Info *server,
>                 return;
>
>         spin_lock(&tcon->sb_list_lock);
> -       list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link) {
> -               cifs_sb->ctx->rsize =3D
> -                       server->ops->negotiate_rsize(tcon, cifs_sb->ctx);
> -               cifs_sb->ctx->wsize =3D
> -                       server->ops->negotiate_wsize(tcon, cifs_sb->ctx);
> -       }
> +       list_for_each_entry(cifs_sb, &tcon->cifs_sb_list, tcon_sb_link)
> +               cifs_negotiate_iosize(server, cifs_sb->ctx, tcon);
>         spin_unlock(&tcon->sb_list_lock);
>  }
>
> --
> 2.49.0
>


--=20
Thanks,

Steve
