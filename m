Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7119B2848A1
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436196; cv=pass; b=rvfJqYi5dwnNbPdYpldmEhEKi3wcOUWkIxIf2tEEijrBU8mq4U0BoqJCSMKouIo0HFkY8N5xqjkMGKVVXdAlGsdq8isfNFEJI/FoSK6CEKISfRcQBwVge4iOE0KzRqbleo6AZPo6TrzCvF9vFwwONEj2n4F2HJE/Pbo+C/pu2rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436196; c=relaxed/simple;
	bh=tlWD3Mls1MGK5VB67e5i4j1KqrsmURRoL6Q7BFRsWv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rIbfYRSnMV5MpS5dyUg/gR5d3pp1nXqeaeijZtuP0mxw4eYphKhJBSvdhpZzEvXcM/gIZK+Rkfiv35kTVFZoLsfTg5rCX48rLei7O5GOAaEOG2Qzp8kFMiNtJTz4QCvf0hy5Ev5tFESXVG0+kuKu0bLUNzmartUV8XrffU2Tf4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YH544/48; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YH544/48"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506bcb23a78so5681261cf.3
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 07:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776436194; cv=none;
        d=google.com; s=arc-20240605;
        b=MaoRvV7lKwhPEYjhpo/2dbcIVO7qt9M1PJIeWD91l4tpZWfpPtZ4d60Eyutuxvsa15
         GzemTR9Qrl/nX967CCABUwDiSKZrsteGEyYjKwXeKdQcZHS+kjgv+AlEboRfLNp0oA49
         PlNfklmU257oYZbF/BD0iLF4rgV9WDJ1Ld/SSkkaYQ5ChC/BUSYK5T6hqB73FYFme031
         81hqu193px7SVOvSmIl6sTHV8beOPeefBz/4v1WOYfnx7Pv71/RhTPyEQwwJli8fFuXv
         8M+o2hZCxc3E5hthynHPn1siZAJEn1O1FhMK37xvJKxp2gUiAAgqavI4B3lGTosKOTxR
         v55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IrQhFlOK7Lyde0jdFiKi6KhR2p58M2iJhwNDgLPHCPc=;
        fh=DVXsfYfyqD7GxDXNEw9nVHEvtjU14KJiLNfrPYJKFdw=;
        b=Zd5tWb+NTg3kJjSonGkt9++Uc3Q4+j+enNg82l0zRKByWT2+wCU6zzGx3Pn/csn9Mn
         GE6a1XtERB3RmGgTeTJMMhnBfMxq0hqYoJEuRNgJXfHzXBfV90wipPFHRbumAfQxoJHJ
         3G37g4k0kqDIbQ5L+uAGBftHKH+Ou4zEl6w8Th0mXjpufD6G0hjMoCIh7lnFCke61s97
         5Yq5CTGL4Kh9tyjicS5k0M0l4Bs9DGKtCH9P+eWbB0Mz3TgUFM3n2k+PuOsE99Vn6/Mz
         FXYW8wfhoIzhGB8PBxVSjRhxfIjp9RyXVp3DLh/XzLhVjNrwK4ymTIIA7AGppyCtqykU
         2eRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776436194; x=1777040994; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrQhFlOK7Lyde0jdFiKi6KhR2p58M2iJhwNDgLPHCPc=;
        b=YH544/484M039V2awxpVcQBVfzxWQ9Skk+V9DcU4zMWq4MewlkkJljzTTltk0yCx5L
         B790Vaf//BPnUHyoCN95iFepnrpU7591djOERT8l3rU7RA/3iKt2M56h4o65oCphJST3
         jgaIrALKvSKvu+mDDWy6FqKrm/FEBaRC19Ip/vZDJPSB0Q+1BXILv5qrnxFaANAIWvTW
         5RjbEpO8Yjk8a8RLB7bIi1YAaS1BTS3DWaLVoBpCfnyXlvRWUgGXTNY+ZV1UkiaT27bu
         w2ZSUcIaU0QB5XPZtyX1ElBjTuiJbOcUnajQLCoi8Hn0fLFnYesXT3tNMSm6kwCMTbCA
         WRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776436194; x=1777040994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IrQhFlOK7Lyde0jdFiKi6KhR2p58M2iJhwNDgLPHCPc=;
        b=J6LC6fErnBOBzJUU3ArJAoP2lxg/teX/Y2RlNboEbmO7CowVptFXHdnW3pllLKxfXq
         5GmJRZxZ6mtIsStgU5t20CiymoOA8fRawFfJfo4KQKdmKHL/8dpU5jXeyLXplFwBFEx2
         vsU7Kj4S5DNHtQEGWGPTHTumr5qYxE7ylGGWXvKejQFZhJrpY0d6/LPDrLT/5Z9uuB8A
         /qYIBNnCFJQL9XeILmLcnAl1EplWz95kWEoSmGX21nHfLzVevaLGtc4uHsX3D4NyzcJb
         JcIkoYUSaHSimVDu/nxSvopFee8ihKYT513yCsdaVJeGX4BvEBKSClpNpYU4Atxs6j0U
         MMBA==
X-Forwarded-Encrypted: i=1; AFNElJ+dY7uK6eynfXvqGBG1nUWxy6AIz40J63/GvVAvrnlQ+qlAn+7xojZu6w6vni261kqfEcMLC4goVjsh@vger.kernel.org
X-Gm-Message-State: AOJu0YwYTCHPCMxk/M8141sycDV1nDFa7zsWTgGvTYnvYqI4fjaZnXQO
	O7EklPqVgFgbM2HHqxbs1rk0lGRWqm5GMnjUxCdzaUSJwTGMrtB7Qlv5RaR9FSJmkGwi8iV1e8T
	WxAJUEt45wUdP8WqICF0yk3BPAwE+heo=
X-Gm-Gg: AeBDiesU3fV+oXlQ64WgYjrmdi2DpJl0565lFbBfcdEk3R0dAw7oqXKMfIwaQCcSrWH
	f6rcZINvmecU+fGgH/b4XAlCBoLT80LuCPodqsFlzS9JRsu0Z6w35y6A4PKY1fiZGFbuW+/KoDA
	hHjoFw34+ccmgzulm0GDBjOsNy4fsUlZ/t3y3kDLRx79B19Kh8HzC4eoeD5dTE6zhfDOr4mGj/G
	9LBgAufjjqPbBJ/W5NfpGJVbPEJxu58FiInczqMRobi7SHZbN9KDhHi4YDaEmwS+bllB+qzarxd
	i6qRYP6BGmh6wvHgLuCbziFBmvk=
X-Received: by 2002:a05:622a:1347:b0:50d:5d96:568a with SMTP id
 d75a77b69052e-50e36c340f0mr43253791cf.27.1776436194302; Fri, 17 Apr 2026
 07:29:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com> <20260409095926.905020-3-rajasimandalos@gmail.com>
In-Reply-To: <20260409095926.905020-3-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 17 Apr 2026 07:29:43 -0700
X-Gm-Features: AQROBzA2N8OlNDQOEmXUygJ-tsBFmyVg8kFHQBp84otiszbx5FY1YD_Q-qBUGxA
Message-ID: <CAFTVevVYu3YkvhYxwiNJbQVpufMN33rpHQD8u_4g9G8zR59JwA@mail.gmail.com>
Subject: Re: [PATCH 3/9] smb: client: sync tcon-level options on remount
To: rajasimandalos@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	metze@samba.org, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

Some nits:

On Thu, Apr 9, 2026 at 3:03=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Several mount options are stored on each cifs_tcon at mount time but
> smb3_reconfigure() only updates cifs_sb->ctx. A remount that changes
> any of these options silently has no effect because the runtime code
> reads from the tcon fields, not from the superblock context.
>
> The affected options and their tcon fields are:
>   retry           -> tcon->retry
>   max_cached_dirs -> tcon->max_cached_dirs
>
> Add smb3_sync_tcon_opts() which walks the tlink_tree under
> tlink_tree_lock and propagates these values from ctx to every tcon
> under tc_lock. Call it from smb3_reconfigure() after the context has
> been updated.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index e1bf7bad5be6..90e83f07c870 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1307,6 +1307,35 @@ static void smb3_sync_ses_chan_max(struct cifs_ses=
 *ses, unsigned int max_channe
>         spin_unlock(&ses->chan_lock);
>  }
>
> +/*
> + * Synchronize tcon options that are derived from ctx across all tcons
> + * associated with this superblock.  These fields are consulted at runti=
me
> + * (reconnect, I/O, unlink/rmdir) so remount needs to update the live
> + * tcons in addition to cifs_sb->ctx.
> + */
> +static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
> +                               struct smb3_fs_context *ctx)
> +{
> +       struct rb_node *node;
> +
> +       spin_lock(&cifs_sb->tlink_tree_lock);
> +       for (node =3D rb_first(&cifs_sb->tlink_tree); node; node =3D rb_n=
ext(node)) {
> +               struct tcon_link *tlink;
> +               struct cifs_tcon *tcon;

Maybe declare these outside the loop?

> +
> +               tlink =3D rb_entry(node, struct tcon_link, tl_rbnode);
> +               tcon =3D tlink_tcon(tlink);
> +               if (IS_ERR_OR_NULL(tcon))
> +                       continue;
> +
> +               spin_lock(&tcon->tc_lock);
> +               tcon->retry =3D ctx->retry;
> +               tcon->max_cached_dirs =3D ctx->max_cached_dirs;

Would be good to add a comment that this will not resize the existing
cached dirents.

> +               spin_unlock(&tcon->tc_lock);
> +       }
> +       spin_unlock(&cifs_sb->tlink_tree_lock);
> +}
> +
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> @@ -1444,6 +1473,8 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if (!rc)
>                 rc =3D dfs_cache_remount_fs(cifs_sb);
>  #endif
> +       if (!rc)
> +               smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
>
>         return rc;
>  }
> --
> 2.43.0
>
>

Other than that, it looks good to me.

Thanks

Meetakshi
