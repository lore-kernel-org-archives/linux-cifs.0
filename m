Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F423E1205
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 06:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781592282; cv=pass; b=tHnlS/iJ6HsfM1MqCLtpE2Vy+gbd1htoawksDOiuEDs9NM1mKJB59r9VsthBMrN3DVquYSj5XAw6x6jeFZvguQ5GyFm6mOoUX5ISJpkxh/ikroq8dAqL31eJm4JOCtB01A1h/I7YGwpeShaUrpBlqqgVUPMsK+rpROIhI6O6QxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781592282; c=relaxed/simple;
	bh=uqtL0zb29tuYBoVqJQfSzsxons9J9+WTM78Y2mBO6to=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUKurOFkw4d4M155PunMR7akGw5PP7Kz55b4llQUPXv0Sc0ZLIFhtlw9IwDrBZJVbUFnW27lVrHZOXQwBIX/E6oYyuBW1wwwhM9PtDrogY5wT0R5H9c94GKD46uC0zJgBBGzo/zZwerFniV6ljpLbZYCKcyii2CpqWSXel7i5So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E0xHVK/P; arc=pass smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E0xHVK/P"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9185503e6a5so369200085a.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 23:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781592280; cv=none;
        d=google.com; s=arc-20240605;
        b=f3HwowDZJnds7+yo0Nndv5pJJqQiGKicMzx/MCWjgs/IhESedRZi80a/bMNO3wi3Q4
         OalM38RYndwdF49F4sm8bIWRDf7asmMaSEhmqHVizJWw4fA17GcKfbVvq4XKCbvbTyt2
         zzcCFjdkEf54+eCq4IqqQkNReF5lShHEQGWk6uncGsxoLFOvT0XgDUAZhpLsyKSwxQkV
         L7yszFTTI9oYA0y9suQ+BRU0lijfAamy+029p+0rXt8tHZKdxCIfN7Q/OkTWWcf8WjWm
         Z+kpIogpvzjoQX9s7rp02NORWl/SHq96Iu8AO51/KeAhHxDQMc7xFnSzt6xQa/YWlFrq
         587Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4OvpJbzwXbuLCpD3TC91Y21uZis5wof2Mx2NoVBqwYk=;
        fh=WOUzk5TkYcJD55x22Ss5I2A2itNj2AMth27q24rwQKY=;
        b=O1tyaw51/RjbGxKr+QQkRNCTdH2P3slCwbn8eWZzsHL8HGZXuTVo096c9o8Q9qyO/p
         0t/jFxTDqWzbRlR3AG22N7RVqs27YfxszJyzOa6CBKagYcfudWHmIm9FUEinFTuJG9LP
         NKqVW4IU41Y0GYdG+Ug6O9LR0NMYs0U2uwwcebCQa8+eQfPtJKnP7q0lnFSTKhmaaQz/
         XgLjY//CsH9kP3AvIy3qqFk38MivtR3VVw/opmq33Bb/ad1phpRk06WORaGTeI6/QyaF
         NkBEhiiU2hIU101ZSFsMbyeEiGjTILPb8KOkrQOgbCFcEvectzFLgbAjM3tc3tIXky2Z
         kLWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781592280; x=1782197080; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4OvpJbzwXbuLCpD3TC91Y21uZis5wof2Mx2NoVBqwYk=;
        b=E0xHVK/PgrDmRmy0Cb7YQDKiLYpJ23Rvt3e+TB7qZvA+Q7Z9R4yYt6ASAUij1FnT1p
         R0ZOltj0S/autO5QwPu/IiXg3NOqzZeHdxnTesPR6lnr4pFa+/3Yf/MC7WywdVUvnZls
         PW2o1IvhjEHxGbF4vRJuTq9YCWT9l3MfHsEGLPP4PvyenerAoZRR5mAiOW+tQoLA37a5
         34ytv2QG66kkuiOyafVcPjymuTxIMQSlQCpfpqi/1vmboVYWwI7OdCdhQcFfoWhwk4mr
         GIfu9O5X7ZBvG0gq6TfFYqtrEUwgyCH8g+nIBT+ZWo9/6lorc3JSGt2Uh9huINp50Rbs
         ANnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781592280; x=1782197080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4OvpJbzwXbuLCpD3TC91Y21uZis5wof2Mx2NoVBqwYk=;
        b=gE9mXbN57cM8cDZmbSxgy4SbInImZsBWNg2/OpisKX+GYVzD0N3k4wnikbZ+MyOtH2
         Iof1WU3tyzIz7PF1PtMyFM2zLFQvZRBQi/38YjU9WA86k6yWDtLZrY2WBnhZARRNwz8S
         UXTrkV+XPycAkZLH3tZVUfaxAbFuu+4FN/eQqlCUvMts7ud/7t3eeDLDDFBZoNG5RILA
         BiriWcSUTx9mxh105ZJILPcdhswd5yRhIvIMjvWE4BUtnvb53QSTwA8bycA22P5MY1Yg
         OCm3C6q1DV/g2QJirx/Uq5KE1+Tn8+nD04r5brE7YIY6vDFKsORnxM3l5j5Nk0Mgval9
         vnkA==
X-Forwarded-Encrypted: i=1; AFNElJ/SIqgTprWsJM/gn/66dADQCR1DtkEmbtE1jhoRwPocqXLO6Ooi2GkaDIeo9/mlbIWP/99Bu2Hldjcd@vger.kernel.org
X-Gm-Message-State: AOJu0YzT2CG0zsHzraFgxC5W1ORe1AIaBAqFgrAgGqDz/InwHRnxSoqr
	xCIiMhNFAhlyCPmV/FbSMo9Lt3SSNWjvumtbtAU2y1Nnr2TkjXi6PUERaRa5jDQ8L7GXSwkhouY
	zziIK2VKERFU4Flal9DdG2kcXjkGTYCAnbHj0
X-Gm-Gg: Acq92OEmGpobAe4mV8eAUsmuoIkhtcG5vgCfDD7jnfHymTg+5GmfakWhu1nFxv+yPzu
	IL3jQ9MGoHJHKxN4JIchBj+TbfGFhoK5E4vbfXL0q1js1X8Dwv3IdkrXkYc/hJ/9Jbot7uYpnXW
	UjrXwpO+F9T2qkNG2Xe4e0BEfVbHL5N41+ZUwlt5zcX6t9msWIvibmRZSMKl9M1BPC6TH1fOhLh
	7DKfq7z4gBHVKLqerH511xC0NojQo21Jy9nFIj0dDR03gulB7tr/H9YptIyZ3D3GHJkO7Td/HjO
	EDk6lg==
X-Received: by 2002:a05:620a:25d0:b0:90f:786c:4a82 with SMTP id
 af79cd13be357-91c2fb91ee4mr357238785a.39.1781592279581; Mon, 15 Jun 2026
 23:44:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616055357.3798387-1-rajasimandalos@gmail.com> <20260616055357.3798387-2-rajasimandalos@gmail.com>
In-Reply-To: <20260616055357.3798387-2-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Mon, 15 Jun 2026 23:44:28 -0700
X-Gm-Features: AVVi8CeuGOyrpUtyWI-7CtQRJDIqmc8N-IqGkSepwcqyeKTNK6BIC8oPWH1W06k
Message-ID: <CAFTVevWAwVkP4EPUmBQieG2YKmtJrEV2v9baH0coRhvkLs+QPg@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] smb: client: sync runtime state into ctx on reconfigure
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Mon, Jun 15, 2026 at 10:54=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> smb3_init_fs_context() builds a fresh context with init defaults on
> every call, including reconfigure (remount).  Many fields displayed
> by cifs_show_options() are sourced from tcon/server/ses rather than
> from ctx, so the init defaults do not reflect the live mount and
> cannot be used as a baseline for comparing new vs old options on
> remount.
>
> Detect FS_CONTEXT_FOR_RECONFIGURE in smb3_init_fs_context() and
> duplicate the existing cifs_sb->ctx instead.  Before duplicating,
> sync ctx with runtime state via a new helper
> smb3_sync_ctx_from_runtime() so the baseline matches what
> cifs_show_options() displays.  Add srv_lock / tc_lock around the
> relevant runtime writers (SMB2_negotiate, SMB2_tcon,
> reset_cifs_unix_caps, cifs_swn_set_server_dstaddr) so the helper
> can read them without torn-read races.
>
> Also preserve inherited multichannel/max_channels values in
> smb3_handle_conflicting_options() during reconfigure when neither
> option is explicitly specified, since the dup'd context already
> carries them.
>
> This is preparatory plumbing for a subsequent commit that compares
> new_ctx against old_ctx in smb3_verify_reconfigure_ctx() to reject
> non-reconfigurable option changes.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/cifs_swn.h   |  14 ++++-
>  fs/smb/client/fs_context.c | 111 +++++++++++++++++++++++++++++++++++++
>  fs/smb/client/smb1ops.c    |   7 ++-
>  fs/smb/client/smb2pdu.c    |  11 +++-
>  4 files changed, 139 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifs_swn.h b/fs/smb/client/cifs_swn.h
> index 955d07b69450..caf0779d4d07 100644
> --- a/fs/smb/client/cifs_swn.h
> +++ b/fs/smb/client/cifs_swn.h
> @@ -26,11 +26,21 @@ void cifs_swn_check(void);
>
>  static inline bool cifs_swn_set_server_dstaddr(struct TCP_Server_Info *s=
erver)
>  {
> +       bool ret =3D false;
> +
> +       /*
> +        * srv_lock serializes the 128-byte sockaddr_storage write agains=
t
> +        * concurrent readers (e.g. cifs_show_address(), reconn_set_ipadd=
r_
> +        * from_hostname() snapshot, smb3_sync_ctx_from_runtime()) and ot=
her
> +        * writers like cifs_chan_update_iface() which already use srv_lo=
ck.
> +        */
> +       spin_lock(&server->srv_lock);
>         if (server->use_swn_dstaddr) {
>                 server->dstaddr =3D server->swn_dstaddr;
> -               return true;
> +               ret =3D true;
>         }
> -       return false;
> +       spin_unlock(&server->srv_lock);
> +       return ret;
>  }
>
>  static inline void cifs_swn_reset_server_dstaddr(struct TCP_Server_Info =
*server)
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 9addc74ce57e..576a78b6d0cb 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -926,6 +926,81 @@ static void smb3_fs_context_free(struct fs_context *=
fc)
>         smb3_cleanup_fs_context(ctx);
>  }
>
> +/*
> + * Sync cifs_sb->ctx with runtime state from tcon/server/ses so the
> + * baseline matches what cifs_show_options() displays.  Wide fields
> + * (dstaddr, ops/vals) are protected by the matching server/tcon lock;
> + * the remaining word-sized scalars rely on the same unsynchronized-read
> + * pattern already used by cifs_show_options().
> + */
> +static int smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
> +{
> +       struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +       struct TCP_Server_Info *server =3D tcon->ses->server;
> +       struct cifs_ses *ses =3D tcon->ses;
> +       struct smb3_fs_context *ctx =3D cifs_sb->ctx;
> +       const char *domain;
> +       int unicode;
> +
> +       /*
> +        * Server fields that can drift from ctx after mount:
> +        *  - ops/vals: dialect renegotiation during reconnect (paired,
> +        *    so read under srv_lock to match the writer in SMB2_negotiat=
e)
> +        *  - dstaddr: SWN witness failover updates server->dstaddr; the
> +        *    128-byte sockaddr_storage is not atomic, so srv_lock is
> +        *    required against torn reads
> +        *  - nosharesock: can be flipped to true post-mount by SMB2_tcon
> +        *    on STATUS_BAD_NETWORK_NAME with ISOLATED_TRANSPORT, so read
> +        *    under srv_lock to pair with that writer
> +        */
> +       spin_lock(&server->srv_lock);
> +       ctx->ops =3D server->ops;
> +       ctx->vals =3D server->vals;
> +       ctx->dstaddr =3D server->dstaddr;
> +       ctx->nosharesock =3D server->nosharesock;
> +       spin_unlock(&server->srv_lock);
> +
> +       /*
> +        * tcon->unix_ext can be flipped post-mount by reset_cifs_unix_ca=
ps()
> +        * on SMB1 reconnect (smb1_reconnect path). Read under tc_lock to=
 pair
> +        * with that writer. tcon->posix_extensions is only ever set at
> +        * mount-time pre-publish, but read it under the same lock so the
> +        * derived linux_ext/no_linux_ext pair is consistent.
> +        */
> +       spin_lock(&tcon->tc_lock);
> +       if (tcon->posix_extensions || tcon->unix_ext) {
> +               ctx->linux_ext =3D 1;
> +               ctx->no_linux_ext =3D 0;
> +       } else {
> +               ctx->linux_ext =3D 0;
> +               ctx->no_linux_ext =3D 1;
> +       }
> +       spin_unlock(&tcon->tc_lock);
> +       ctx->seal         =3D tcon->seal;
> +       ctx->persistent   =3D tcon->use_persistent;
> +       ctx->nopersistent =3D !tcon->use_persistent;
> +       ctx->resilient    =3D tcon->use_resilient;
> +       ctx->witness      =3D tcon->use_witness;
> +
> +       /*
> +        * Session fields: domainName and unicode are effectively
> +        * write-once (set during session setup, never freed/replaced
> +        * while the session exists), so plain reads are safe.
> +        */
> +       domain =3D ses->domainName;
> +       unicode =3D ses->unicode;
> +
> +       if (domain && !ctx->domainname) {
> +               ctx->domainname =3D kstrdup(domain, GFP_KERNEL);
> +               if (!ctx->domainname)
> +                       return -ENOMEM;
> +       }
> +       if (unicode >=3D 0)
> +               ctx->unicode =3D unicode;
> +
> +       return 0;
> +}
> +
>  /*
>   * Compare the old and new proposed context during reconfigure
>   * and check if the changes are compatible.
> @@ -1961,6 +2036,42 @@ int smb3_init_fs_context(struct fs_context *fc)
>         char *nodename =3D utsname()->nodename;
>         int i;
>
> +       /*
> +        * For reconfigure (remount), duplicate the existing mount contex=
t
> +        * instead of building one from scratch with init defaults.
> +        *
> +        * VFS sets fc->root before calling init_fs_context for reconfigu=
re,
> +        * so we can access the existing superblock's context.  We first =
sync
> +        * cifs_sb->ctx with runtime state (tcon/server/ses) so that ctx
> +        * matches what cifs_show_options() displays.  Then we dup old_ct=
x
> +        * into new_ctx.  The parser will overwrite only the options
> +        * explicitly passed on remount, so any difference between new_ct=
x
> +        * and old_ctx in smb3_verify_reconfigure_ctx() represents a real=
,
> +        * intentional change by the user.
> +        */
> +       if (fc->purpose =3D=3D FS_CONTEXT_FOR_RECONFIGURE) {
> +               struct cifs_sb_info *cifs_sb =3D CIFS_SB(fc->root->d_sb);
> +               int rc;
> +
> +               rc =3D smb3_sync_ctx_from_runtime(cifs_sb);
> +               if (rc)
> +                       return rc;
> +
> +               ctx =3D kzalloc_obj(struct smb3_fs_context);
> +               if (!ctx)
> +                       return -ENOMEM;
> +
> +               rc =3D smb3_fs_context_dup(ctx, cifs_sb->ctx);
> +               if (rc) {
> +                       kfree(ctx);
> +                       return rc;
> +               }
> +
> +               fc->fs_private =3D ctx;
> +               fc->ops =3D &smb3_fs_context_ops;
> +               return 0;
> +       }
> +
>         ctx =3D kzalloc_obj(struct smb3_fs_context);
>         if (unlikely(!ctx))
>                 return -ENOMEM;
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index d34b3d99f6ed..33c890e14988 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -36,11 +36,16 @@ void reset_cifs_unix_caps(unsigned int xid, struct ci=
fs_tcon *tcon,
>
>         if (ctx && ctx->no_linux_ext) {
>                 tcon->fsUnixInfo.Capability =3D 0;
> +               spin_lock(&tcon->tc_lock);
>                 tcon->unix_ext =3D 0; /* Unix Extensions disabled */
> +               spin_unlock(&tcon->tc_lock);
>                 cifs_dbg(FYI, "Linux protocol extensions disabled\n");
>                 return;
> -       } else if (ctx)
> +       } else if (ctx) {
> +               spin_lock(&tcon->tc_lock);
>                 tcon->unix_ext =3D 1; /* Unix Extensions supported */
> +               spin_unlock(&tcon->tc_lock);
> +       }
>
>         if (!tcon->unix_ext) {
>                 cifs_dbg(FYI, "Unix extensions disabled so not set on rec=
onnect\n");
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 4972cfe249f6..958ca0753774 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -1189,8 +1189,10 @@ SMB2_negotiate(const unsigned int xid,
>                         goto neg_exit;
>                 case SMB311_PROT_ID:
>                         /* ops set to 3.0 by default for default so updat=
e */
> +                       spin_lock(&server->srv_lock);
>                         server->ops =3D &smb311_operations;
>                         server->vals =3D &smb311_values;
> +                       spin_unlock(&server->srv_lock);
>                         break;
>                 default:
>                         break;
> @@ -1205,12 +1207,16 @@ SMB2_negotiate(const unsigned int xid,
>                         goto neg_exit;
>                 case SMB21_PROT_ID:
>                         /* ops set to 3.0 by default for default so updat=
e */
> +                       spin_lock(&server->srv_lock);
>                         server->ops =3D &smb21_operations;
>                         server->vals =3D &smb21_values;
> +                       spin_unlock(&server->srv_lock);
>                         break;
>                 case SMB311_PROT_ID:
> +                       spin_lock(&server->srv_lock);
>                         server->ops =3D &smb311_operations;
>                         server->vals =3D &smb311_values;
> +                       spin_unlock(&server->srv_lock);
>                         break;
>                 default:
>                         break;
> @@ -2226,8 +2232,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses =
*ses, const char *tree,
>         if (server->ops->validate_negotiate)
>                 rc =3D server->ops->validate_negotiate(xid, tcon);
>         if (rc =3D=3D 0) /* See MS-SMB2 2.2.10 and 3.2.5.5 */
> -               if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT=
)
> +               if (tcon->share_flags & SMB2_SHAREFLAG_ISOLATED_TRANSPORT=
) {
> +                       spin_lock(&server->srv_lock);
>                         server->nosharesock =3D true;
> +                       spin_unlock(&server->srv_lock);
> +               }
>  tcon_exit:
>
>         free_rsp_buf(resp_buftype, rsp);
> --
> 2.43.0
>
