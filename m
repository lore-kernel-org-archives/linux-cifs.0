Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6733A6B9D
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695454; cv=pass; b=T93hDJ5fWktZ6UbA7sffbZB5ycg3vfylA8utFS/8/VLvHJqUm4Zoiu/VfcqITzMymRZp0aHIJdBdYHJAtjwahb8GI3kqDRJqS+AQxbV9cmAn3gI3Hd6vulcVXlHb+XREoACCgh/38bnx/etQj0QrtuFkR+wzfaoIEw90UInBPlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695454; c=relaxed/simple;
	bh=8M+ZmXLzKDfIqLs6pqMHK7VyRtnHtJhnVAgpqGUCxZ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m+/jlJsus3ZfEm/0cz44W09ol18ZQJZHuN9rYRVJrLfSJpiXCUFl97uEBvqhw6cVMH8A7MKKrL/ZTOXk+JckkaLVXmXJ0OgQGGhLowv0hhMBmrlXwt8pKWRmDOs3VIUw6m+qfsv609+kdKpMOuOFgVh0cx83cqUFVMyulmZ/80c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9tHFEQL; arc=pass smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9tHFEQL"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-95cc3522c40so4521465241.2
        for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 11:04:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778695450; cv=none;
        d=google.com; s=arc-20240605;
        b=cgpE8L4xQNMgqOKqMnbks9GfjnelE42mE071YAKJic98PDnHcffN65qecbNDFNDUuh
         l0r716nSEZziiegntYdMLXoI/+sh8yYOzOJFbAOSk3n0ury7V/MjT3ojhPdL4iTy8d08
         9rtFcyfGE3qOLfaP9B7WlZvbwkiYesXOyJubGkgJFVgj2xUkdaV1nBVG7tPgb+3rwZjP
         BYrD9EdKUfHZlaOyhBtGx5UAXbmub4MmPgyPg4vUToQFKYWCMfr4V78jEG+V6Z4Kh7EK
         F3zo+HXa5hKIbKyJTzF5X3Iev/yEjcGK86K5JmkguDX/CJtxmcp39OuiEn99Dewg4RfV
         DcYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+tnbCx2fkqtShb8y9otgTppwhjsPSTrmGaAYf/0+YpA=;
        fh=8kt/qWf9j3NQMNgXGmezDj7Xe4Dw/a8f6LRH3hScA4c=;
        b=WsGheYfyc6T5gJjpsGeC1HjrYPtfLZ4QhjZayQjt+ClI5eO5h/VSCwxfVIFtbMOzpe
         yyu95yh3CUTE9x93dIK4OKdt8fzygHrIsiEUK67MpidoRh1oZrG+b3pC2WlOZBswfnxB
         88pE/zf0hGbGkh/f7hRglSdLyayxON4sSsTZmAqETOI4vT0jbyldClIJWkEpgLScNFPU
         doSYDeGk1EDFJeRRGGRlcoJ096Cp+pOYv7fv3rgWV+d03Nzb3GgawlFfpi0gdYDL/Q88
         +NggRkjfWHRAm5CHIkLtdgycwoouu4KAJEfeKtNmO4sHvE+wWjdqwZlOcphPG3rIWdl1
         Insg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778695450; x=1779300250; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tnbCx2fkqtShb8y9otgTppwhjsPSTrmGaAYf/0+YpA=;
        b=l9tHFEQLd2aLXP77296oLR/P2o7EMO6xXRtj4uSXc3um9zhyoUqedJ3vT7xefZ9b6f
         ejnDe9eMNyQLHAHLf0voUxNupZ5lGYvKt5NFpTuscD2avvMOfwmAKcJGCGZTLbEQDOnw
         zDYVcISna7lDfSMaybxUIkNgzdmH9lKUDiWoKjuUYpnmKkwpHb0T3XC+wIdjeWZpNv3B
         6fc6VGK2hLhbBBi6AO/lZPEwCLQkPzzFUrzgUKaeiwBh6jNj4HMKjLE/TgVacOyE7LDX
         vRGWLfmYSWS2tYzwpB07Q2un94KUUqSXDCV/I6rBzx2umrJyIVE4G3XKzIdeQTDVqqUW
         yRiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778695450; x=1779300250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+tnbCx2fkqtShb8y9otgTppwhjsPSTrmGaAYf/0+YpA=;
        b=YNfj7ud/TezebK2EeQZvChVn8jtjqeSuEqi+BB2an0iBAheiCiVdrwRNlhlRKIpyvX
         P03Q62Mo4G/6e/v3nsu/3wNEISd8U5Y762plJUVab5hj2BZT4Of1LqkT1cz6g5VF0gft
         PFbjv0IhNeLhD+ZfNA/Fw0fRbE4BoxTxfz4dLr3UbKJfd9VudYajDZ5LCunMNmlC6nH1
         9jVjHBG8qcy5EHyY7wzwr8rCt6K/KCCrWYP16y581M7h0eBWcwpLPj27ZCIV6Of1jYoS
         zOJ+ZzZynP0PgWbVYmi/EgY1axN/n4mtu3CCO8pT6R+k9Ktwk+CRGMsqkN+HuTd0Q7GD
         /IDQ==
X-Forwarded-Encrypted: i=1; AFNElJ9eDjKtAbMzi43ODOBFBF4jU5fJ5xirTTq6xoBQVjGu0+roaILn6kkVMRoXpNdT23EZGgyLguDbZcGm@vger.kernel.org
X-Gm-Message-State: AOJu0YwSWOyVg6tWfS+lESca+F2Su9P5XbHJSHX77fXE6lmNeEGm85nF
	UbT8p+6dqzn217CWDB7ojrmpgHKs6mzJL9Y8VuvQHuF4SuPMIiq69r2vygpGKkMRm2symBIlDiZ
	Fo216Cdji65C1Z3rvsLY4ZWwY8LNLrdU=
X-Gm-Gg: Acq92OEWc0nFy5nieuXokmnzR2MHeyYQ+/SJkE+hz4GgBPW5zjzqRzdBg7NSdt82PYF
	wevcyMUoi2kq+gHzc9/DJGqmeCwZXFlVxkzrBNiT2V3uI4QatNy+hROWYGHHyV9GFwjKaIkPYpd
	1U6elx4MYRNxZIxbvRHXuaTQqBkjkWr6sN+kYZZP1TdW8ETjoITenVwF1Xz7hMZ2FPUnOK0L1BG
	e1U9h+ulWxmDZMn5RCyJjwBVMaFu7EEXGTTnWu59RDqq5AZPelJTx3hCu7OgW+zmr8cGe0m+J/9
	C9DRjSvaTYxQ5gqB46thQn22id47fNQkP33g0hgYeQA4yKlbirFt6cj5aWBf+oaMkdQDe2/5gr9
	RbbNdrOhZq8a2bs8zQOyIOy1wZzTozugMM4ts9v1qLPx0yDjNP8DTXLVhE5TtDCOksDPxXcck7A
	2SsEB2/3a+R/yORKvrWrgnBg==
X-Received: by 2002:a05:6102:3a0b:b0:631:23b4:8dce with SMTP id
 ada2fe7eead31-637a8ec68a9mr2254497137.13.1778695450149; Wed, 13 May 2026
 11:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501060907.3859641-1-charsyam@gmail.com> <20260513132622.2640103-1-charsyam@gmail.com>
In-Reply-To: <20260513132622.2640103-1-charsyam@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 May 2026 13:03:58 -0500
X-Gm-Features: AVHnY4JnXdeTA5RPedytX3P5wpjpjQtcGI3sVXwadqCsl4sbjbUIgCW0xTIjuwk
Message-ID: <CAH2r5msEsn9HgawQRjJhLi1-++VKznyZCCfHvXz+AAYremELSg@mail.gmail.com>
Subject: Re: [PATCH v6] cifs: client: stage smb3_reconfigure() updates and
 restore ctx on failure
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	Rajasi Mandal <rajasimandalos@gmail.com>, Rajasi Mandal <rajasimandal@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next pending additional testing, but
Rajasi will need to update some of her remount series due to this
patch (e.g. "smb: client: sync tcon-level options on remount")

On Wed, May 13, 2026 at 8:54=E2=80=AFAM DaeMyung Kang <charsyam@gmail.com> =
wrote:
>
> smb3_reconfigure() moves strings out of cifs_sb->ctx before the
> multichannel update, so a later failure can leave the live context
> with NULL strings or options that do not match the session.
>
> Stage the new ctx separately, commit it only on success, and restore
> the snapshot on failure. Also make smb3_sync_session_ctx_passwords()
> all-or-nothing.
>
> Commit session passwords before channel updates so newly added channels
> authenticate with the staged credentials.
>
> Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount opt=
ions on remount")
> Reported-by: RAJASI MANDAL <rajasimandalos@gmail.com>
> Closes: https://lore.kernel.org/lkml/CAEY6_V1+dzW3OD5zqXhsWyXwrDTrg5tAMGZ=
1AJ7_GAuRE+aevA@mail.gmail.com/
> Link: https://lore.kernel.org/lkml/xkr2dlvgibq5j6gkcxd3yhhnj4atgxw2uy4eug=
2pxm7wy7nbms@iq6cf5taa65v/
> Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
> Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
> ---
> v6: (feedback from Henrique Carvalho)
>  - Drop the update_password / update_password2 booleans in
>    smb3_sync_session_ctx_passwords(); commit when the local pointer
>    itself is non-NULL.
>  - Rename the failure label restore_new_ctx -> cleanup_new_ctx, since
>    new_ctx is cleaned up (not restored) on the staged-failure path.
>  - Shorten the commit message further per review.
>
> v5: (feedback from Henrique Carvalho)
>  - Drop mchan_rc / scale_busy; the early failure paths now restore
>    cifs_sb->ctx from a snapshot taken on entry.
>  - Build new_ctx separately and replace cifs_sb->ctx only on success.
>  - Make smb3_sync_session_ctx_passwords() all-or-nothing: allocate
>    both copies first, commit only when both succeed.
>  - Switch smb3_sync_ses_chan_max() max_channels parameter to size_t
>    to match struct cifs_ses::chan_max.
>  - Shorten the commit message and follow nearby CIFS log style.
>
>  fs/smb/client/fs_context.c | 161 +++++++++++++++++++++++++------------
>  1 file changed, 108 insertions(+), 53 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b9544eb0381b..cf6e18876c59 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -767,7 +767,7 @@ static int smb3_fs_context_parse_param(struct fs_cont=
ext *fc,
>  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
>                                             void *data);
>  static int smb3_get_tree(struct fs_context *fc);
> -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int ma=
x_channels);
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_chan=
nels);
>  static int smb3_reconfigure(struct fs_context *fc);
>
>  static const struct fs_context_operations smb3_fs_context_ops =3D {
> @@ -1041,25 +1041,34 @@ do {                                             =
                       \
>
>  int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct=
 cifs_ses *ses)
>  {
> +       char *password =3D NULL, *password2 =3D NULL;
> +
>         if (ses->password &&
>             cifs_sb->ctx->password &&
>             strcmp(ses->password, cifs_sb->ctx->password)) {
> -               kfree_sensitive(cifs_sb->ctx->password);
> -               cifs_sb->ctx->password =3D kstrdup(ses->password, GFP_KER=
NEL);
> -               if (!cifs_sb->ctx->password)
> +               password =3D kstrdup(ses->password, GFP_KERNEL);
> +               if (!password)
>                         return -ENOMEM;
>         }
>         if (ses->password2 &&
>             cifs_sb->ctx->password2 &&
>             strcmp(ses->password2, cifs_sb->ctx->password2)) {
> -               kfree_sensitive(cifs_sb->ctx->password2);
> -               cifs_sb->ctx->password2 =3D kstrdup(ses->password2, GFP_K=
ERNEL);
> -               if (!cifs_sb->ctx->password2) {
> -                       kfree_sensitive(cifs_sb->ctx->password);
> -                       cifs_sb->ctx->password =3D NULL;
> +               password2 =3D kstrdup(ses->password2, GFP_KERNEL);
> +               if (!password2) {
> +                       kfree_sensitive(password);
>                         return -ENOMEM;
>                 }
>         }
> +
> +       if (password) {
> +               kfree_sensitive(cifs_sb->ctx->password);
> +               cifs_sb->ctx->password =3D password;
> +       }
> +       if (password2) {
> +               kfree_sensitive(cifs_sb->ctx->password2);
> +               cifs_sb->ctx->password2 =3D password2;
> +       }
> +
>         return 0;
>  }
>
> @@ -1072,7 +1081,7 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_=
info *cifs_sb, struct cifs_se
>   * with the session's channel lock. This should be called whenever the m=
aximum
>   * allowed channels for a session changes (e.g., after a remount or reco=
nfigure).
>   */
> -static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int ma=
x_channels)
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_chan=
nels)
>  {
>         spin_lock(&ses->chan_lock);
>         ses->chan_max =3D max_channels;
> @@ -1082,12 +1091,15 @@ static void smb3_sync_ses_chan_max(struct cifs_se=
s *ses, unsigned int max_channe
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> +       struct smb3_fs_context *new_ctx =3D NULL;
> +       struct smb3_fs_context *old_ctx =3D NULL;
>         struct dentry *root =3D fc->root;
>         struct cifs_sb_info *cifs_sb =3D CIFS_SB(root->d_sb);
>         struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
>         unsigned int rsize =3D ctx->rsize, wsize =3D ctx->wsize;
>         char *new_password =3D NULL, *new_password2 =3D NULL;
>         bool need_recon =3D false;
> +       bool need_mchan_update;
>         int rc;
>
>         if (ses->expired_pwd)
> @@ -1097,6 +1109,16 @@ static int smb3_reconfigure(struct fs_context *fc)
>         if (rc)
>                 return rc;
>
> +       old_ctx =3D kzalloc_obj(*old_ctx);
> +       if (!old_ctx)
> +               return -ENOMEM;
> +
> +       rc =3D smb3_fs_context_dup(old_ctx, cifs_sb->ctx);
> +       if (rc) {
> +               kfree(old_ctx);
> +               return rc;
> +       }
> +
>         /*
>          * We can not change UNC/username/password/domainname/
>          * workstation_name/nodename/iocharset
> @@ -1106,16 +1128,22 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>         STEAL_STRING(cifs_sb, ctx, UNC);
>         STEAL_STRING(cifs_sb, ctx, source);
>         STEAL_STRING(cifs_sb, ctx, username);
> +       STEAL_STRING(cifs_sb, ctx, domainname);
> +       STEAL_STRING(cifs_sb, ctx, nodename);
> +       STEAL_STRING(cifs_sb, ctx, iocharset);
>
> -       if (need_recon =3D=3D false)
> +       if (!need_recon) {
>                 STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> -       else  {
> +       } else {
>                 if (ctx->password) {
>                         new_password =3D kstrdup(ctx->password, GFP_KERNE=
L);
> -                       if (!new_password)
> -                               return -ENOMEM;
> -               } else
> +                       if (!new_password) {
> +                               rc =3D -ENOMEM;
> +                               goto restore_ctx;
> +                       }
> +               } else {
>                         STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
> +               }
>         }
>
>         /*
> @@ -1125,11 +1153,29 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>         if (ctx->password2) {
>                 new_password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
>                 if (!new_password2) {
> -                       kfree_sensitive(new_password);
> -                       return -ENOMEM;
> +                       rc =3D -ENOMEM;
> +                       goto restore_ctx;
>                 }
> -       } else
> +       } else {
>                 STEAL_STRING_SENSITIVE(cifs_sb, ctx, password2);
> +       }
> +
> +       /* if rsize or wsize not passed in on remount, use previous value=
s */
> +       ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
> +       ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
> +
> +       new_ctx =3D kzalloc_obj(*new_ctx);
> +       if (!new_ctx) {
> +               rc =3D -ENOMEM;
> +               goto restore_ctx;
> +       }
> +
> +       rc =3D smb3_fs_context_dup(new_ctx, ctx);
> +       if (rc)
> +               goto restore_ctx;
> +
> +       need_mchan_update =3D ctx->multichannel !=3D cifs_sb->ctx->multic=
hannel ||
> +                           ctx->max_channels !=3D cifs_sb->ctx->max_chan=
nels;
>
>         /*
>          * we may update the passwords in the ses struct below. Make sure=
 we do
> @@ -1140,54 +1186,55 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>         /*
>          * smb2_reconnect may swap password and password2 in case session=
 setup
>          * failed. First get ctx passwords in sync with ses passwords. It=
 should
> -        * be okay to do this even if this function were to return an err=
or at a
> -        * later stage
> +        * be done before committing new passwords.
>          */
>         rc =3D smb3_sync_session_ctx_passwords(cifs_sb, ses);
>         if (rc) {
>                 mutex_unlock(&ses->session_mutex);
> -               kfree_sensitive(new_password);
> -               kfree_sensitive(new_password2);
> -               return rc;
> +               goto cleanup_new_ctx;
> +       }
> +
> +       /*
> +        * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> +        * This may add or remove channels to match the new configuration=
.
> +        */
> +       if (need_mchan_update) {
> +               /* Prevent concurrent scaling operations */
> +               spin_lock(&ses->ses_lock);
> +               if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> +                       spin_unlock(&ses->ses_lock);
> +                       mutex_unlock(&ses->session_mutex);
> +                       rc =3D -EINVAL;
> +                       goto cleanup_new_ctx;
> +               }
> +               ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> +               spin_unlock(&ses->ses_lock);
>         }
>
>         /*
> -        * now that allocations for passwords are done, commit them
> +        * Commit session passwords before any channel work so newly adde=
d
> +        * channels authenticate with the new credentials.
>          */
>         if (new_password) {
>                 kfree_sensitive(ses->password);
>                 ses->password =3D new_password;
> +               new_password =3D NULL;
>         }
>         if (new_password2) {
>                 kfree_sensitive(ses->password2);
>                 ses->password2 =3D new_password2;
> +               new_password2 =3D NULL;
>         }
>
> -       /*
> -        * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> -        * This may add or remove channels to match the new configuration=
.
> -        */
> -       if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> -           (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> -
> +       if (need_mchan_update) {
>                 /* Synchronize ses->chan_max with the new mount context *=
/
>                 smb3_sync_ses_chan_max(ses, ctx->max_channels);
> -               /* Now update the session's channels to match the new con=
figuration */
> -               /* Prevent concurrent scaling operations */
> -               spin_lock(&ses->ses_lock);
> -               if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> -                       spin_unlock(&ses->ses_lock);
> -                       mutex_unlock(&ses->session_mutex);
> -                       return -EINVAL;
> -               }
> -               ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> -               spin_unlock(&ses->ses_lock);
>
>                 mutex_unlock(&ses->session_mutex);
>
> -               rc =3D smb3_update_ses_channels(ses, ses->server,
> -                                              false /* from_reconnect */=
,
> -                                              false /* disable_mchan */)=
;
> +               smb3_update_ses_channels(ses, ses->server,
> +                                        false /* from_reconnect */,
> +                                        false /* disable_mchan */);
>
>                 /* Clear scaling flag after operation */
>                 spin_lock(&ses->ses_lock);
> @@ -1197,22 +1244,30 @@ static int smb3_reconfigure(struct fs_context *fc=
)
>                 mutex_unlock(&ses->session_mutex);
>         }
>
> -       STEAL_STRING(cifs_sb, ctx, domainname);
> -       STEAL_STRING(cifs_sb, ctx, nodename);
> -       STEAL_STRING(cifs_sb, ctx, iocharset);
> -
> -       /* if rsize or wsize not passed in on remount, use previous value=
s */
> -       ctx->rsize =3D rsize ? CIFS_ALIGN_RSIZE(fc, rsize) : cifs_sb->ctx=
->rsize;
> -       ctx->wsize =3D wsize ? CIFS_ALIGN_WSIZE(fc, wsize) : cifs_sb->ctx=
->wsize;
> -
>         smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> -       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> +       memcpy(cifs_sb->ctx, new_ctx, sizeof(*new_ctx));
> +       kfree(new_ctx);
> +       new_ctx =3D NULL;
> +       smb3_cleanup_fs_context(old_ctx);
> +       old_ctx =3D NULL;
>         smb3_update_mnt_flags(cifs_sb);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
>         if (!rc)
>                 rc =3D dfs_cache_remount_fs(cifs_sb);
>  #endif
>
> +       return rc;
> +
> +cleanup_new_ctx:
> +       smb3_cleanup_fs_context_contents(new_ctx);
> +restore_ctx:
> +       kfree(new_ctx);
> +       kfree_sensitive(new_password);
> +       kfree_sensitive(new_password2);
> +       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> +       memcpy(cifs_sb->ctx, old_ctx, sizeof(*old_ctx));
> +       kfree(old_ctx);
> +
>         return rc;
>  }
>
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
