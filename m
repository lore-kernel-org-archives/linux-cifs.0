Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C211D2727ED
	for <linux-cifs@vger.kernel.org>; Thu, 20 Nov 2025 06:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619051; cv=none; b=rRenPBmwHW/3dxvWDVYmmPmkdE07AYIkJ3czJErHgQKVMz2NCjDUFFW7WLpcYVkyilecZ/N1lzWC4LwGWl0edncmruJn1+HSUGMAIXPUHy4nL9pe6YNrwUuBbHW3hg2vZfN8zwCC4EgMBk4oYfwV67R62u2rng7IwVtHO2hQjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619051; c=relaxed/simple;
	bh=aX60ZO2fAsLWjpoJBmIraoeeQRzDmR9DUREvlnlHIK8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQOt9xKjUyxEpqA/6faAegF2jIObWpNoG7sPdyyc/lS16gU3OOOBwyBeCFfNMAukvAcJqgKbu8l8vuMxhofARGzwSTZPy8W7Um8L7vU/vxnvVdpc8+DKouQSVnrNCq5LbUhrYxgSpZvoNGU4zIsu9F8FvZd2sIGMsVKtxMQbL/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCj9X+om; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCj9X+om"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b735487129fso90029766b.0
        for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 22:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763619047; x=1764223847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5K3ZcagWd01GkKCXS4H1u5xpaVjjSG5mYKOaQBRYkQ=;
        b=mCj9X+omila9DVrMH9wLLfAUsYCijkpew6X0xdMmr4xuyWma8jx4QkJyFqYl02w4o/
         ErPSxKoewlKaKKJnuxhdJYbkr04GXm8sD6JNX/hn+ftuUku8cnZogsZuavJA7011cAxj
         gTZb3wOuT3x8h2bf9ziN0Z1I7qq0CWqGQajg2Q05gnxMx7DJgryE8k+HDcQ6D3ZgMfo1
         NrOWXZRtu0DHqccue3COJ7rZni2HdZdfL8P2281gQVWUZuve6qfc1SjogOvkyVU6Dlwu
         YQX+3eW/HytaCzKgXGmkGz/7iupg7FlBfwFLzB9KfHW1lNdyc6EnZpaeViA9vq2pNddf
         y7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763619047; x=1764223847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V5K3ZcagWd01GkKCXS4H1u5xpaVjjSG5mYKOaQBRYkQ=;
        b=n05XoJ5aRnPHCGJ5UQYG6MiSD9jFszh0F2LJpwe+zQ8UfoET0rwQAjhWhJn+1HBu82
         sylCSnXezb/FsCM9kyd4a1lKfcaXRMnwqZTp0Zp8+Uy83r2tnK8qBvjTU2YwJBB2sEt7
         mHx4PdRcgmtq/ZTAcT0nVRhkLjCXnsCbL4mG6JgjcJzxH2As4f7sXYldKllxa0hEsiPx
         kONXhju1OvxtdNlZWWm8VIfaNir9FpjFOulXc/i+CRXPhZUhPIS96zpH1xeJMJyVoCMj
         ktdINVJaxbHoJ8hY4hduuODXAZ2RjjvlIuBXLzl5USFEUQlRXAjKuKkqtzszQwxVM7XO
         ZsyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEmYUMphgx8iPWyiaWtgBzDMGXljYX9pNX+zdIzXH6gYuQviPXxYZHO+TsV13bnzvh+TkYKRWl9iq1@vger.kernel.org
X-Gm-Message-State: AOJu0YzBMER3Lsm2A6dLUydtjgP1akOG3tsow4eYy8ZdV8bNo6i8OKSs
	weNXolNYpprjYztb5r/lvqpoh0vbPNTCfY2u4PHw1Zteif3rSlIf2UYpMYh5w8m4iLEsIXozVcF
	GFDu60gpJ0GZ0okCnaFl+S3ZPAoOYWjg=
X-Gm-Gg: ASbGncsl0QPOtNYnLtwq/QsChTzRklDOYfn8iViTOqFcmRv66T1MJuCLZOOFZ41bKZO
	ZVSrmapw7H8e4Z02hFk5e1Ykvl0oc0hzRr4s5WZlzy0hwi6+/gzHDLUdLoeCS1OU/nAi4dsxS7g
	M/RZ3NWZdLrNK32rAbn/LePtMKL9Yxppg3KLI9GUPirJA8WifcDGMvB/493fa3I8g0iFBmVw42G
	H+rFHpP821fvFHRDzzyGiJtXGQu79mi/2SkFl3qYp9jSns5iwgMkIPeAj93OCDC9Toy30Wr
X-Google-Smtp-Source: AGHT+IFKR213kRs/yfdV3WbsYSEkZgAqi3KePxpc8x8fq+Fokd/CdrvNuLrYr2H07iamWpVc4rtkesbag7/UceAuYsQ=
X-Received: by 2002:a17:907:3f95:b0:b72:7cd3:d55b with SMTP id
 a640c23a62f3a-b7654cfaea7mr192993366b.12.1763619046799; Wed, 19 Nov 2025
 22:10:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118022655.126994-1-rajasimandalos@gmail.com>
In-Reply-To: <20251118022655.126994-1-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Thu, 20 Nov 2025 11:40:29 +0530
X-Gm-Features: AWmQ_bnxtle6D52KPppeYHKNYI-1wlJru1s3DAx-orqvs0ajus3MG8eYTRK2r-U
Message-ID: <CAFTVevWRXF8TCDQstp7r1uu8eZ21M4m1EPs3zXANPTDj8bh_ZQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: client: allow changing multichannel mount options
 on remount
To: Rajasi Mandal <rajasimandalos@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Rajasi,

On Tue, Nov 18, 2025 at 7:59=E2=80=AFAM Rajasi Mandal <rajasimandalos@gmail=
.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> Previously, the client did not update a session's channel state when
> multichannel or max_channels mount options were changed via remount.
> This led to inconsistent behavior and prevented enabling or disabling
> multichannel support without a full unmount/remount cycle.
>
> Enable dynamic reconfiguration of multichannel and max_channels during
> remount by:
> - Introducing smb3_sync_ses_chan_max(), a centralized function for
>   channel updates which synchronizes the session's channels with the
>   updated configuration.
> - Replacing cifs_disable_secondary_channels() with
>   cifs_decrease_secondary_channels(), which accepts a from_reconfigure
>   flag to support targeted cleanup during reconfiguration.
> - Updating remount logic to detect changes in multichannel or
>   max_channels and trigger appropriate session/channel updates.
>
> Current limitation:
> - The query_interfaces worker runs even when max_channels=3D1 so that
>   multichannel can be enabled later via remount without requiring an
>   unmount. This is a temporary approach and may be refined in the
>   future.
>
> Users can safely modify multichannel and max_channels on an existing
> mount. The client will correctly adjust the session's channel state to
> match the new configuration, preserving durability where possible and
> avoiding unnecessary disconnects.
>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h  |  4 ++-
>  fs/smb/client/connect.c    |  4 ++-
>  fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++++++++-
>  fs/smb/client/sess.c       | 32 +++++++++++++++-------
>  fs/smb/client/smb2pdu.c    | 55 ++++++++++++++++++++++++++++----------
>  5 files changed, 119 insertions(+), 26 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 3528c365a452..a1fc9e1918bc 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct shash_de=
sc **sdesc);
>  void cifs_free_hash(struct shash_desc **sdesc);
>
>  int cifs_try_adding_channels(struct cifs_ses *ses);
> +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Inf=
o *server,
> +                                       bool from_reconnect, bool from_re=
configure);
>  bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *=
iface);
>  void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
>
> @@ -674,7 +676,7 @@ bool
>  cifs_chan_is_iface_active(struct cifs_ses *ses,
>                           struct TCP_Server_Info *server);
>  void
> -cifs_disable_secondary_channels(struct cifs_ses *ses);
> +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfi=
gure);
>  void
>  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *ser=
ver);
>  int
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 55cb4b0cbd48..cebe4a5f54f2 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct=
 smb3_fs_context *ctx)
>         ctx->prepath =3D NULL;
>
>  out:
> -       cifs_try_adding_channels(mnt_ctx.ses);
> +       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> +                                 false /* from_reconnect */,
> +                                 false /* from_reconfigure */);

Shouldn't this be added to the non-dfs cifs_mount() too? I see that
even cifs_try_adding_channels() is not present in this function,
@Shyam Prasad is this expected?

>         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>         if (rc)
>                 goto error;
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0f894d09157b..751ed6ebd458 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct fs_cont=
ext *fc,
>  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
>                                             void *data);
>  static int smb3_get_tree(struct fs_context *fc);
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int ma=
x_channels);
>  static int smb3_reconfigure(struct fs_context *fc);
>
>  static const struct fs_context_operations smb3_fs_context_ops =3D {
> @@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb=
_info *cifs_sb, struct cifs_se
>         return 0;
>  }
>
> +/*
> + * smb3_sync_ses_chan_max - Synchronize the session's maximum channel co=
unt
> + * @ses: pointer to the old CIFS session structure
> + * @max_channels: new maximum number of channels to allow
> + *
> + * Updates the session's chan_max field to the new value, protecting the=
 update
> + * with the session's channel lock. This should be called whenever the m=
aximum
> + * allowed channels for a session changes (e.g., after a remount or reco=
nfigure).
> + */
> +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int ma=
x_channels)
> +{
> +       spin_lock(&ses->chan_lock);
> +       ses->chan_max =3D max_channels;
> +       spin_unlock(&ses->chan_lock);
> +}
> +
>  static int smb3_reconfigure(struct fs_context *fc)
>  {
>         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> @@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_context *fc)
>                 ses->password2 =3D new_password2;
>         }
>
> -       mutex_unlock(&ses->session_mutex);
> +       /*
> +        * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> +        * This may add or remove channels to match the new configuration=
.
> +        */
> +       if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> +           (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> +
> +               /* Synchronize ses->chan_max with the new mount context *=
/
> +               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> +               /* Now update the session's channels to match the new con=
figuration */
> +               /* Prevent concurrent scaling operations */
> +               spin_lock(&ses->ses_lock);
> +               if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> +                       spin_unlock(&ses->ses_lock);
> +                       return -EINVAL;
> +               }
> +               ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> +               spin_unlock(&ses->ses_lock);
> +
> +               mutex_unlock(&ses->session_mutex);
> +
> +               rc =3D smb3_update_ses_channels(ses, ses->server,
> +                                              false /* from_reconnect */=
,
> +                                              true /* from_reconfigure *=
/);
> +
> +               /* Clear scaling flag after operation */
> +               spin_lock(&ses->ses_lock);
> +               ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
> +               spin_unlock(&ses->ses_lock);
> +       } else {
> +               mutex_unlock(&ses->session_mutex);
> +       }
>
>         STEAL_STRING(cifs_sb, ctx, domainname);
>         STEAL_STRING(cifs_sb, ctx, nodename);
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index ef3b498b0a02..cfd83986a84a 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>  }
>
>  /*
> - * called when multichannel is disabled by the server.
> - * this always gets called from smb2_reconnect
> - * and cannot get called in parallel threads.
> + * cifs_decrease_secondary_channels - Reduce the number of active second=
ary channels
> + * @ses: pointer to the CIFS session structure
> + * @from_reconfigure: if true, only reduce to chan_max; if false, reduce=
 to a single channel
> + *
> + * This function disables and cleans up extra secondary channels for a C=
IFS session.
> + * If called during reconfiguration, it reduces the channel count to the=
 new maximum (chan_max).
> + * Otherwise, it disables all but the primary channel.
>   */
>  void
> -cifs_disable_secondary_channels(struct cifs_ses *ses)
> +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfi=
gure)
>  {
>         int i, chan_count;
>         struct TCP_Server_Info *server;
> @@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs_ses *se=
s)
>         if (chan_count =3D=3D 1)
>                 goto done;
>
> -       ses->chan_count =3D 1;
> -
> -       /* for all secondary channels reset the need reconnect bit */
> -       ses->chans_need_reconnect &=3D 1;
> +       /* Update the chan_count to the new maximum */
> +       if (from_reconfigure)
> +               ses->chan_count =3D ses->chan_max;
> +       else
> +               ses->chan_count =3D 1;
>
> -       for (i =3D 1; i < chan_count; i++) {
> +       for (i =3D ses->chan_max ; i < chan_count; i++) {
>                 iface =3D ses->chans[i].iface;
>                 server =3D ses->chans[i].server;
>
> @@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_ses *ses=
)
>                 spin_lock(&ses->chan_lock);
>         }
>
> +       /* For extra secondary channels, reset the need reconnect bit */
> +       if (ses->chan_count =3D=3D 1) {
> +               cifs_dbg(VFS, "server does not support multichannel anymo=
re. Disable all other channels\n");
> +               ses->chans_need_reconnect &=3D 1;
> +       } else {
> +               cifs_dbg(VFS, "Disable extra secondary channels\n");
> +               ses->chans_need_reconnect &=3D ((1UL << ses->chan_max) - =
1);
> +       }
> +
>  done:
>         spin_unlock(&ses->chan_lock);
>  }
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 8b4a4573e9c3..d051da46eaab 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_=
cmd,
>  static int
>  cifs_chan_skip_or_disable(struct cifs_ses *ses,
>                           struct TCP_Server_Info *server,
> -                         bool from_reconnect)
> +                         bool from_reconnect, bool from_reconfigure)
>  {
>         struct TCP_Server_Info *pserver;
>         unsigned int chan_index;
> @@ -206,14 +206,41 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>                 return -EHOSTDOWN;
>         }
>
> -       cifs_server_dbg(VFS,
> -               "server does not support multichannel anymore. Disable al=
l other channels\n");
> -       cifs_disable_secondary_channels(ses);
> -
> +       cifs_decrease_secondary_channels(ses, from_reconfigure);
>
>         return 0;
>  }
>
> +/*
> + * smb3_update_ses_channels - Synchronize session channels with new conf=
iguration
> + * @ses: pointer to the CIFS session structure
> + * @server: pointer to the TCP server info structure
> + * @from_reconnect: indicates if called from reconnect context
> + * @from_reconfigure: indicates if called from reconfigure context
> + *
> + * Returns 0 on success or error code on failure.
> + *
> + * Note: Outside of reconfigure, this function is only called from recon=
nect scenarios
> + * when the server stops advertising multichannel (MC) capability.
> + */

I see that function is being called during mount too. Did you
mean cifs_decrease_secondary_channels()?

> +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Inf=
o *server,
> +                       bool from_reconnect, bool from_reconfigure)
> +{
> +       int rc =3D 0;
> +       /*
> +        * If the current channel count is less than the new chan_max,
> +        * try to add channels to reach the new maximum.
> +        * Otherwise, disable or skip extra channels to match the new con=
figuration.
> +        */
> +       if (ses->chan_count < ses->chan_max)
> +               rc =3D cifs_try_adding_channels(ses);
> +       else
> +               rc =3D cifs_chan_skip_or_disable(ses, server, from_reconn=
ect,
> +                                               from_reconfigure);
> +
> +       return rc;
> +}
> +
>  static int
>  smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>                struct TCP_Server_Info *server, bool from_reconnect)
> @@ -355,8 +382,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>          */
>         if (ses->chan_count > 1 &&
>             !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> -               rc =3D cifs_chan_skip_or_disable(ses, server,
> -                                              from_reconnect);
> +               rc =3D smb3_update_ses_channels(ses, server,
> +                                              from_reconnect, false /* f=
rom_reconfigure */);
>                 if (rc) {
>                         mutex_unlock(&ses->session_mutex);
>                         goto out;
> @@ -438,8 +465,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                          * treat this as server not supporting multichann=
el
>                          */
>
> -                       rc =3D cifs_chan_skip_or_disable(ses, server,
> -                                                      from_reconnect);
> +                       rc =3D smb3_update_ses_channels(ses, server,
> +                                                      from_reconnect,
> +                                                      false /* from_reco=
nfigure */);
>                         goto skip_add_channels;
>                 } else if (rc)
>                         cifs_tcon_dbg(FYI, "%s: failed to query server in=
terfaces: %d\n",
> @@ -451,7 +479,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>                         if (ses->chan_count =3D=3D 1)
>                                 cifs_server_dbg(VFS, "supports multichann=
el now\n");
>
> -                       cifs_try_adding_channels(ses);
> +                       smb3_update_ses_channels(ses, server, from_reconn=
ect,
> +                                                 false /* from_reconfigu=
re */);
>                 }
>         } else {
>                 mutex_unlock(&ses->session_mutex);
> @@ -1105,8 +1134,7 @@ SMB2_negotiate(const unsigned int xid,
>                 req->SecurityMode =3D 0;
>
>         req->Capabilities =3D cpu_to_le32(server->vals->req_capabilities)=
;
> -       if (ses->chan_max > 1)
> -               req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_=
CHANNEL);
> +       req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL)=
;
>
>         /* ClientGUID must be zero for SMB2.02 dialect */
>         if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> @@ -1312,8 +1340,7 @@ int smb3_validate_negotiate(const unsigned int xid,=
 struct cifs_tcon *tcon)
>
>         pneg_inbuf->Capabilities =3D
>                         cpu_to_le32(server->vals->req_capabilities);
> -       if (tcon->ses->chan_max > 1)
> -               pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP=
_MULTI_CHANNEL);
> +       pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_C=
HANNEL);
>
>         memcpy(pneg_inbuf->Guid, server->client_guid,
>                                         SMB2_CLIENT_GUID_SIZE);
> --
> 2.43.0
>
>

Thanks
Meetakshi
