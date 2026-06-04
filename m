Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612FE3E2AAD
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780582284; cv=pass; b=lwgur5XFQQ06sYJsn28yHElNLSkBtwXtswuTerP1z8N0teDg969Xz2PQztNCq/ufuEUzIYYYq/DttCRP+6s38Ea2xHZrkozMRqslxIsqhSAizXdcHUwC2CuPSz4jMu4NrFi7E+NB3OCV/y67eUAgN4sunBOZI/POPVfDbaIdJic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780582284; c=relaxed/simple;
	bh=bJIHe0dawq5ObjvbPtRsVIavvD63UEXBUry2epmQjTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VHoT4zttnwJUKuKQk7tpaL0GiFF7a30WAOh1b1ousAiSosgKFk7G8cDLsjr6CMfB8CbOcWn819SNhWRx89SX7nYzen9UZxHZ2GpGhwQdrGUgbMU6V+AoMMvQHYJXUNMWkI56etRKOKq7ISvRe5EwiI0E6ys4MsK9uOjVOQhZDR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dFz3t2ur; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFz3t2ur"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ce9de10985so7695786d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jun 2026 07:11:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780582282; cv=none;
        d=google.com; s=arc-20240605;
        b=AQn+VkqT4gwbvgEqvo/b6+PECuNQjC8788MOpIG4H8rhfvwYw1qStnIACZw8A7+GFh
         7sNvuz+ktHIc4zuq75axkgz0pGHzU2+H27UmpKBOxjTSts9NbFBs9KigvanahjvmH9Lg
         8nqI6tFOHg2nCn/z4gEO9f0D7gMFOyeQtYSJ2+ju/HmgoD6doFfsG8TqUaLH1O5eYY7s
         0FwKHnTWetjEC2LXh7+xzMlHeiyWq8rRYV/MABFKd1KJiRD4PfIgyoqa5uTxPJDtsmU6
         Zlb3rvkLflSr1yEIe0RPuIDqVqB/S2UoHjLWrwZby07R3xafBDjBu8Jb8nWZzxQOSsjR
         ARyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HAqZYNG+rmtqKS23VkI2qWHKfK5z5tcIUr8PbghsjX0=;
        fh=IhXx4O3+dvSy2xM/hQD9vuFn6McYCc1qrQrOnFFJZQo=;
        b=ah5kntPAxSOcgK0AOlpMplXjgJ7Tjim7jwJW5n8R6tVZXAzSdEiFJhaQc+Td3Unvoy
         zj+iBc29+yCTaWXLxK7oekm6Wr/Y0iFR0vrBngM4AhZeJgRP/b3BTU7xeoeJZ272XGBJ
         9QjwRSCOmzoDI9O7qQGr9aEChnZSPgvN3AQX4R0Ld/h//876hKb5GTFcdTLMrTSPcGbA
         y+D1m8of754Zd11TLc2l6+TAAAMmVqWZp5FGB6lCT05xlkWrUFkJQwg7QrNbE1D0EEN9
         8SbMmFYV/7ocjF3EzqsxfK0UDUyD/5VVgeUOzYgdeIpRgqZgg7jlEy0GpDbMevQyZGWS
         h2Bg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780582282; x=1781187082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAqZYNG+rmtqKS23VkI2qWHKfK5z5tcIUr8PbghsjX0=;
        b=dFz3t2ur4fFT/QUg259cvsJs+M6amjxkas1oRJJdR0gyiqZuEICo9uWC6mr/B7NCAx
         artArE97/JFkrhLh6bH3k2nfX39rWvow+pD0n8AGl3lkfIcAEHtLOD6iU2LKZfl7fA85
         4wnO/GPjZ8moHVDSAHe/HQARX5mcMImXi3ZQpczqUOixUIkuH+pxrLYFJFcWza/olqNz
         6zpBwtNkRkxBn2wGv/VqKnIEh39DyEZZpp81R/TAkq50QDwOf8QyJnUQaVfHQpqDRO1t
         aG9vXzKRD/wH+TvLjo/icS72HxY8odJQq5XbzqVDj6ar0ofNFVuoFVbrQbrNjhCUhjW9
         IPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780582282; x=1781187082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HAqZYNG+rmtqKS23VkI2qWHKfK5z5tcIUr8PbghsjX0=;
        b=PNu4zq0VL+N1hZ/A1JLNymIB1+It8PC+g+0baCMsxboXoDHjOAuwMR1QPbd2LidDo7
         9sfpGDR5T/2XDdCkQf84Ml8Uu+kmV6psfFzX3CQXa92r+E8DdbVTVjkyWYOgyd6yWxUU
         O5EiyXR3FadHzM4yuo3BRyfJ7tTB6P5FntxrR7iEItbSGHeBtrQw6Xv/TfzcSvuCHp2F
         YeLgUVDT27Ke0Ia5b7WTjHeybGiKFKr4VHslE4mGh8h6nTbYeo7mH6xick44ntmpHncg
         27V+QbMrr4LgNaQmq5ndAi+olqD8VCWNMJzW1MccB7NB+VuEItxRMI9eaOJb02XI1M3F
         KHsw==
X-Forwarded-Encrypted: i=1; AFNElJ++9SiI5q+w2S0fSj1+dX6nVECKYL9wFk+4CcbiWCSqxxbtkpcWoLV4WQFnx/dgza9voGvhImUULgB1@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwp/dDFb5mxPGFaWDe7W3Q9Vl1TIMnLY9wihOvpFmij09HzanJ
	pBWx19cTj55wiqznTibEaC1W6BZt7lAPzMuPZEq18yFLwK433BxdZEvlXLABMBpGAOO4YKBvTlA
	b1lcbrxSMMZ6kfpp4tOZDYJYWlK3klXwsdQ==
X-Gm-Gg: Acq92OElvS52N2ELeDk83/i/EHGf/Z2019N625bFhUeVDtouIhVmNNNKHB2ZIn19QD0
	msVD1HKosj2XXP/PQiQ3Hd8HIVrXe7Wwg5prAVKyczPnU9i6aFz5vho2vgKzpGkXIBHwZgm2qch
	oQbAjffDkBmEtciUwy2HQaFUSb2OmnSLyJywW5Q+Utmjfdr7LphwzkjOxsR88/aPF/x6K0mOzqI
	8eCpp8VTdhQooQeSv1aTN4T7hsYxZYgL+CabJnhwt3yx4D/RDA+QwN4AOI3i9DACCbvTxHrkw3f
	XgWMH6kdxCBHTYp3YA==
X-Received: by 2002:a05:6214:e6c:b0:8cc:e17:7d16 with SMTP id
 6a1803df08f44-8ced7c7eb51mr53203956d6.7.1780582281890; Thu, 04 Jun 2026
 07:11:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1779371115.git.rajasimandal@microsoft.com> <5eeeecdba9a2ab93074b5fbac505b83f35aac18f.1779371115.git.rajasimandal@microsoft.com>
In-Reply-To: <5eeeecdba9a2ab93074b5fbac505b83f35aac18f.1779371115.git.rajasimandal@microsoft.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Thu, 4 Jun 2026 19:41:09 +0530
X-Gm-Features: AVVi8CcywLjjPVswhsivadEETv7LgcwpaSQMHtDt4ETiT4mxT3trA-uofoqHp_4
Message-ID: <CAFTVevVna3EHBU+pzYTrE9ZmYU8_+hF51OB5ewPvQSytjOc2Og@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] smb: client: sync runtime state into ctx on reconfigure
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

My comments inline.

On Thu, May 21, 2026 at 7:24=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
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
> ---
>  fs/smb/client/cifs_swn.h   |  14 ++++-
>  fs/smb/client/fs_context.c | 117 ++++++++++++++++++++++++++++++++++++-
>  fs/smb/client/smb1ops.c    |   7 ++-
>  fs/smb/client/smb2pdu.c    |  11 +++-
>  4 files changed, 143 insertions(+), 6 deletions(-)
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
> index 2f86158f85d7..b93d6ef13463 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -717,13 +717,13 @@ static int smb3_handle_conflicting_options(struct f=
s_context *fc)
>                                 ctx->multichannel =3D true;
>                         else
>                                 ctx->multichannel =3D false;
> -               } else {
> +               } else if (fc->purpose !=3D FS_CONTEXT_FOR_RECONFIGURE) {
>                         ctx->multichannel =3D false;
>                         ctx->max_channels =3D 1;
>                 }
> +               /* For reconfigure with neither specified, keep inherited=
 values */
>         }
>
> -       //resetting default values as remount doesn't initialize fs_conte=
xt again
>         ctx->multichannel_specified =3D false;
>         ctx->max_channels_specified =3D false;
>
> @@ -921,6 +921,85 @@ static void smb3_fs_context_free(struct fs_context *=
fc)
>         smb3_cleanup_fs_context(ctx);
>  }
>
> +/*
> + * Sync cifs_sb->ctx with the runtime state visible through /proc/mounts=
.
> + * cifs_show_options() reads many fields from tcon/server/ses rather tha=
n
> + * from ctx.  On remount, libmount reads /proc/mounts and feeds those
> + * values back as mount options.  To avoid false mismatches between the
> + * old ctx and the newly parsed options, we must ensure ctx reflects
> + * the current runtime state before it is duplicated into the new
> + * remount context.
> + *
> + * Note: sb->s_umount is not yet held when VFS calls init_fs_context()
> + * for reconfigure, so in theory concurrent I/O paths could read
> + * cifs_sb->ctx fields (e.g. cifs_symlink_type()) while we write them.
> + * This is safe because all fields written here are word-sized
> + * (bool/int/pointer), so stores are architecturally atomic.  The same
> + * unsynchronized-read pattern already exists in cifs_show_options().
> + */

Nitpick about the comment - dstaddr for example is not word-sized and
not atomic. You should rework this comment.

> +static void smb3_sync_ctx_from_runtime(struct cifs_sb_info *cifs_sb)
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
> +       if (domain && !ctx->domainname)
> +               ctx->domainname =3D kstrdup(domain, GFP_KERNEL);

Can you handle the ENOMEM error here?

> +       if (unicode >=3D 0)
> +               ctx->unicode =3D unicode;
> +}
> +
>  /*
>   * Compare the old and new proposed context during reconfigure
>   * and check if the changes are compatible.
> @@ -1958,6 +2037,40 @@ int smb3_init_fs_context(struct fs_context *fc)
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
> +               smb3_sync_ctx_from_runtime(cifs_sb);
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
> index e198e3dda917..a91539d7f0ba 100644
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
> index 995fcdd30681..9e07c1a99981 100644
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
> @@ -2228,8 +2234,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses =
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

Other than these issues, the patch looks good to me.

Thanks
Meetakshi
