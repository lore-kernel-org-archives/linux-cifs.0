Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BF679C0
	for <linux-cifs@vger.kernel.org>; Thu,  1 May 2025 03:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746069066; cv=none; b=ZFlK/AwyLvdqzp7yWpHDMZADVHZ67KrTViW//nqdjQRJuoyUOEwEmRc1Ez4vED9veaY4mzfLyGZC6lgYdTpIE0IXt6NM3P1IPot4xnFOwfsIxYsVi6uvdFEjZnx1MPOA4LLdF1B7GzoINHSXXaX5luxPvpqw3YPYyHjeRtAklVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746069066; c=relaxed/simple;
	bh=530pz8wGgpG97YbJ7QlBa60WUe7lfgyRGoNQvsoy7Co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXKaCTdxErft6iGiky7xnkdqlKkMi1o0Pn6KfWbHvUfaHH7LVP6b6MrUjo+HnbSkZweOZcH8RcJCG0BjSTLRN1EurMLq8AMUbzxryEw6KNybqgFPPq4LMzvE62BXYRPocDfGmV7abvSJmnzoyPQDHoykB0wKJbOb4szU8h6F0eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chLm9fiW; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chLm9fiW"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54298ec925bso625436e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 20:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746069062; x=1746673862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mkh7i0MOcgYIFUa1FZteJhUIl6/o4vXMShnpQl6fH4U=;
        b=chLm9fiW7FoLvd3PWc803FTee8Tj3bd0QgPxkvTOeIoG2inGxb0Q2dTEfmbvi/kwl9
         vJ7Y7zU0/QqEdD29TR47DwceIRixmdL9CzY+bRzAWtSUYlaMYPLZVjOVjMzGosK2tw26
         O2uAzhP4oPyZ8mnNsAiKDIcwVcQEc5q/TxXzTFwY7QJUo5zoR3ahpde4Qnho89/7VAwx
         Ft2awv+yfwIzRjkFO5C/svYutRTQVBGioxTqJpfQ6ZN9QF8dhyU/3ZDBUIEuMDIE9UaP
         7xwKjQkacOoM1j7awdPRHp6wbp8MpFCzvIxFrXtmONpoV7+MkRoaT1ooJ3YJ+w8nqasS
         STVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746069062; x=1746673862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mkh7i0MOcgYIFUa1FZteJhUIl6/o4vXMShnpQl6fH4U=;
        b=oi2nywre8VfhtHUXi7zJGj7RlKYh1p5TSDW7hNKRQsDB0IpFXXMvQoiZi4OM5SlUrk
         0vqcX6NFWfegH2uewySFjwPDssXOIBUZ+DnZ3y4DDQn+p7xBKzdBLKR5X0ppMDhcxqvX
         J6tirIH+QNY8QITzcyWIYgE6LZgobXANkJkXQ5HGVOChuCjhIRRINZppiECNXaHzC528
         fCKZHF6wUulAGm7cpjGRDT8dDkRLqRlZnVp1qvh6Przdzab/kAHdB6UoWyBsR3Tz8Vps
         kmh5D+MF3z1/s6B4vP8ogMcntndWXvvIDkCFdqKTbYBIC8UgAbrG/rPECqV8m/GKVMr1
         grNQ==
X-Gm-Message-State: AOJu0Yz6574F+THdSqO605vae6bLbbyfd92iaoHSvwGEsSeocZKAadui
	HUIow1IntoYGZADK8Cd9yGxSzGQeTCEIAu/OdQrmHXxqjd04rnBuguiyxNkBlSpb6moe8PexN61
	gJrRoPwPSOJOS2zaVaJfXSgoRY+s=
X-Gm-Gg: ASbGnculqCMm3zOr3BDFtPysWH3N2YUqKg/Qvqn69AYetZBgDV47AyGRnTrZlqeAcFC
	p+FQwTv7/ZNEJdSQhwQUuivzfW04puIt/QNKXEATXssrMOo/vWY0IpkjcF+SpDmyf1omIb4kPjK
	ImUL8hqRr9omEvR5nO/HbI1NXZ3rbrtyfBWXbQ9L/UiCo8YnO80/30o3SfffiMNAK8riA=
X-Google-Smtp-Source: AGHT+IFLRNQgD+p2uyYKbV6Q8mcNWR7DoZe6dBokEk1T7v8sfxScOquBuSUmTo4FNGsFDk2s+3F8vcrSQiYuPFLaDIg=
X-Received: by 2002:a05:6512:3a8c:b0:545:f0a:bf50 with SMTP id
 2adb3069b0e04-54ea76623b6mr230732e87.35.1746069061773; Wed, 30 Apr 2025
 20:11:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430231548.1836976-1-pc@manguebit.com>
In-Reply-To: <20250430231548.1836976-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 30 Apr 2025 22:10:50 -0500
X-Gm-Features: ATxdqUEClNBPV7fEUBclL0ijB2idJqmE30mrrniElzshwek9gkyyaQh9C4nYPbc
Message-ID: <CAH2r5mu6p-ex-A7g99KadEY4FgsQQiyg9o6gB_FHYuExv+7daQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: ensure aligned IO sizes
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

thoughts about taking Cc: stable?

On Wed, Apr 30, 2025 at 6:15=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
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
>  fs/smb/client/connect.c    | 23 +------------------
>  fs/smb/client/file.c       |  6 ++---
>  fs/smb/client/fs_context.c | 25 +++++---------------
>  fs/smb/client/fs_context.h | 47 ++++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb1ops.c    |  8 +++----
>  fs/smb/client/smb2pdu.c    |  8 ++-----
>  6 files changed, 62 insertions(+), 55 deletions(-)
>
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
> index 2980941b9667..a634a34d4086 100644
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
> +       ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
> +       ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
>
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>         rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> @@ -1312,7 +1310,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
>                                 __func__);
>                         goto cifs_parse_mount_err;
>                 }
> -               ctx->bsize =3D result.uint_32;
> +               ctx->bsize =3D CIFS_ALIGN_BSIZE(fc, result.uint_32);
>                 ctx->got_bsize =3D true;
>                 break;
>         case Opt_rasize:
> @@ -1336,24 +1334,13 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
>                 ctx->rasize =3D result.uint_32;
>                 break;
>         case Opt_rsize:
> -               ctx->rsize =3D result.uint_32;
> +               ctx->rsize =3D CIFS_ALIGN_RSIZE(fc, result.uint_32);
>                 ctx->got_rsize =3D true;
>                 ctx->vol_rsize =3D ctx->rsize;
>                 break;
>         case Opt_wsize:
> -               ctx->wsize =3D result.uint_32;
> +               ctx->wsize =3D CIFS_ALIGN_WSIZE(fc, result.uint_32);
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
> index d1d29249bcdb..9e83302ce4b8 100644
> --- a/fs/smb/client/fs_context.h
> +++ b/fs/smb/client/fs_context.h
> @@ -20,6 +20,21 @@
>                 cifs_dbg(VFS, fmt, ## __VA_ARGS__);     \
>         } while (0)
>
> +static inline size_t cifs_io_align(struct fs_context *fc,
> +                                  const char *name, size_t size)
> +{
> +       if (!size || !IS_ALIGNED(size, PAGE_SIZE)) {
> +               cifs_errorf(fc, "unaligned %s, making it a multiple of %l=
u bytes\n",
> +                           name, PAGE_SIZE);
> +               size =3D umax(round_down(size, PAGE_SIZE), PAGE_SIZE);
> +       }
> +       return size;
> +}
> +
> +#define CIFS_ALIGN_WSIZE(_fc, _size) cifs_io_align(_fc, "wsize", _size)
> +#define CIFS_ALIGN_RSIZE(_fc, _size) cifs_io_align(_fc, "rsize", _size)
> +#define CIFS_ALIGN_BSIZE(_fc, _size) cifs_io_align(_fc, "bsize", _size)
> +
>  enum smb_version {
>         Smb_1 =3D 1,
>         Smb_20,
> @@ -361,4 +376,36 @@ static inline void cifs_mount_unlock(void)
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
