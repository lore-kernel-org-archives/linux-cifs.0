Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5942FFDDC
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 11:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985015; cv=none; b=sTXV4hlbyaWe4/x4vojEMgQwo0GSgPnp+7PdHcKCyP8I6TLzEks5cPC2PCyIHItUVCtdz2iOAaXYu8riWQ87tW/kQGDNqyCV98hcTgugZH1to0on4UK5sdDW/mKjcXndBd1JBcy5avqQFVoZ9DQDj16oSF70f7IKCFJ2Bw6v2Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985015; c=relaxed/simple;
	bh=+/GfsQT/rK0uYHXDue4gjQbqjKBDZbTf7ID7QVR6pTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hc4bkxpHNDzZd02wE+2ZmJdPoLCEVSIq2mzWKTnvlz++fpzNqmHq0XVRsOu7Zo6nXLKYruixjj5A3y5MqpXeY38icz7trDZ7gKLqDi0x5NYmr6VYylE5EA1VBjJCbcuRpY7WDbGNPBXwcNfceUbPvRXjBkR0DFfIIDTdY2+lZng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TWwP15nb; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TWwP15nb"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7370698a8eso541967666b.0
        for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 03:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763985012; x=1764589812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTsX74x3miO5NhXwBIi3PNOqqcYDVYQU/9M1KuaEhHU=;
        b=TWwP15nbcA+vDeDrruDrFLxXRs/Dew4bRfdFyBMHp/B9XJmwlhdDxMeinSxhpmI+EU
         w7/VwpDqf9XgMkWg1WCSby9imuuGEjVtM3biJjL/zoX9wYawz7v9Sb7xmgf6BSch1RFP
         xOz6w7gMfbFl4iMSaRHnvHZKXeJBrvLBX1tfoWrvwm+6Oys5iFRyw6J+EJ9pUKKVmLJB
         q9CPw1yFt1o1KRSdauC6sQChLjJaFF+rHfNy3y1FkPxsL1WzsY//57KTzxNkiXcRYhrp
         8X0RaZhHakREkTUyfkrr1rbjz9VFvSRVCJIYDGtB18yDb3Fxzayw4O2NdJVND1n98mOs
         xE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763985012; x=1764589812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTsX74x3miO5NhXwBIi3PNOqqcYDVYQU/9M1KuaEhHU=;
        b=YxJx57UPLwNAg+Vj3UET5TgqcbV5eFNI5BPnBcQsELEtk6+ynZ7HMI9/8P9yAW8gD3
         3Qo7hHDp5swF7NxxtT+NKW07q3EmTM7MWx1RuLW02QbPRNHS5wGWZoMlF29OAI2ziTM0
         gpmI+5aYeoGvpIgqErXq79KxVJHqLUZrw6BnYd+QCWXokWu2ilQzILpOo2tyMoEZNQhb
         qUUilyKiZaolzv26H0kcqX/f98VEu+kSXqZBd6s9ItjieKb/6fRfSjU3mU1QMkVpGiJE
         G2sAJPXofo9sblHBhvTr3pg4u9Jn/3ANd+Hq9TQB+Jm2mAY5zAUS0Yoj+FdnTXEmsgx6
         OVLw==
X-Forwarded-Encrypted: i=1; AJvYcCXIlC+ngNS/KMaRPXCxUyCMWjJw8WNq+1I5DWBfIv4NH502ILcz8FSuegWHwfElpS+0EZ/B4R6nF5AH@vger.kernel.org
X-Gm-Message-State: AOJu0YxCJRJqbwzhRO9ePhur3kLUovslOJwMObwGmLklPX8ytd8BMgPt
	1Wu0oQuOYXT6BRz1rgBGR5T2Z4PQbIDiIfN3cn7q+JVAdBtYytFt2p3/n9o1dbKE1W63W0cmDr5
	9MKIgRKkD2/3x+koiNF7mwaaO8uH8+anHMd6u
X-Gm-Gg: ASbGnctUHGKQOWhowuP7fZMyorVDp0CsexlfqNqBeqlE3bkoxHZMcOFwED2PTHWyhr0
	JM/DWvZIw6E8KtqLLpLYrFuJAW3B7kUUoMlLszrA9ygPUV2wiqiwYTCK3lPUpZf0Writqxa21Cv
	NN2P0O+N25t5iR9ZbImsSA/zFabMqwDMn8I2y6SqDH00FiBv7P/reMr8VzgNdZmrkoP5LhwVEKI
	wPbJAlXxoVZz87VQRLyzX/qvKB37ZzAUuCsKhfRIl9+YHp68+oyckojme4zS39er6M25A==
X-Google-Smtp-Source: AGHT+IFZ4hgOnP+GGzFtxXgwCCUo5PfAR/nWqfGsAUnrg85wi9EqQVdLNnZC+kYcsuEtY2QjopW1tLau3Ug6FTb/Vnw=
X-Received: by 2002:a17:907:7244:b0:b76:63b8:7394 with SMTP id
 a640c23a62f3a-b767184bc2bmr1299210766b.51.1763985011282; Mon, 24 Nov 2025
 03:50:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118022655.126994-1-rajasimandalos@gmail.com> <CAFTVevWRXF8TCDQstp7r1uu8eZ21M4m1EPs3zXANPTDj8bh_ZQ@mail.gmail.com>
In-Reply-To: <CAFTVevWRXF8TCDQstp7r1uu8eZ21M4m1EPs3zXANPTDj8bh_ZQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 24 Nov 2025 17:19:58 +0530
X-Gm-Features: AWmQ_bnIjQgahXtJjHFnWg5u-M5ugvbyueAQzBGUsEwA0mwLa5NlWynD5jzcwWc
Message-ID: <CANT5p=ohMvQ+0+YYCQrkSw7sPW24gs60TQzBoiAyfedO8GXgfQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: client: allow changing multichannel mount options
 on remount
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: Rajasi Mandal <rajasimandalos@gmail.com>, sfrench@samba.org, linux-cifs@vger.kernel.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 20, 2025 at 11:40=E2=80=AFAM Meetakshi Setiya
<meetakshisetiyaoss@gmail.com> wrote:
>
> Hi Rajasi,
>
> On Tue, Nov 18, 2025 at 7:59=E2=80=AFAM Rajasi Mandal <rajasimandalos@gma=
il.com> wrote:
> >
> > From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> > Previously, the client did not update a session's channel state when
> > multichannel or max_channels mount options were changed via remount.
> > This led to inconsistent behavior and prevented enabling or disabling
> > multichannel support without a full unmount/remount cycle.
> >
> > Enable dynamic reconfiguration of multichannel and max_channels during
> > remount by:
> > - Introducing smb3_sync_ses_chan_max(), a centralized function for
> >   channel updates which synchronizes the session's channels with the
> >   updated configuration.
> > - Replacing cifs_disable_secondary_channels() with
> >   cifs_decrease_secondary_channels(), which accepts a from_reconfigure
> >   flag to support targeted cleanup during reconfiguration.
> > - Updating remount logic to detect changes in multichannel or
> >   max_channels and trigger appropriate session/channel updates.
> >
> > Current limitation:
> > - The query_interfaces worker runs even when max_channels=3D1 so that
> >   multichannel can be enabled later via remount without requiring an
> >   unmount. This is a temporary approach and may be refined in the
> >   future.
> >
> > Users can safely modify multichannel and max_channels on an existing
> > mount. The client will correctly adjust the session's channel state to
> > match the new configuration, preserving durability where possible and
> > avoiding unnecessary disconnects.
> >
> > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > ---
> >  fs/smb/client/cifsproto.h  |  4 ++-
> >  fs/smb/client/connect.c    |  4 ++-
> >  fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++++++++-
> >  fs/smb/client/sess.c       | 32 +++++++++++++++-------
> >  fs/smb/client/smb2pdu.c    | 55 ++++++++++++++++++++++++++++----------
> >  5 files changed, 119 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 3528c365a452..a1fc9e1918bc 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct shash_=
desc **sdesc);
> >  void cifs_free_hash(struct shash_desc **sdesc);
> >
> >  int cifs_try_adding_channels(struct cifs_ses *ses);
> > +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_I=
nfo *server,
> > +                                       bool from_reconnect, bool from_=
reconfigure);
> >  bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface=
 *iface);
> >  void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
> >
> > @@ -674,7 +676,7 @@ bool
> >  cifs_chan_is_iface_active(struct cifs_ses *ses,
> >                           struct TCP_Server_Info *server);
> >  void
> > -cifs_disable_secondary_channels(struct cifs_ses *ses);
> > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_recon=
figure);
> >  void
> >  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *s=
erver);
> >  int
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 55cb4b0cbd48..cebe4a5f54f2 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, stru=
ct smb3_fs_context *ctx)
> >         ctx->prepath =3D NULL;
> >
> >  out:
> > -       cifs_try_adding_channels(mnt_ctx.ses);
> > +       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> > +                                 false /* from_reconnect */,
> > +                                 false /* from_reconfigure */);
>
> Shouldn't this be added to the non-dfs cifs_mount() too? I see that
> even cifs_try_adding_channels() is not present in this function,
> @Shyam Prasad is this expected?

That's a good catch.
I think this is a day-0 bug.
I can see that the original change by Aurelien has the change only in
DFS cifs_mount:
commit d70e9fa55884760b6d6c293dbf20d8c52ce11fb7
Author: Aurelien Aptel <aaptel@suse.com>
Date:   Fri Sep 20 06:31:10 2019 +0200

    cifs: try opening channels after mounting

We should have a follow-up patch to fix this.

>
> >         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> >         if (rc)
> >                 goto error;
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 0f894d09157b..751ed6ebd458 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
> >  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
> >                                             void *data);
> >  static int smb3_get_tree(struct fs_context *fc);
> > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int =
max_channels);
> >  static int smb3_reconfigure(struct fs_context *fc);
> >
> >  static const struct fs_context_operations smb3_fs_context_ops =3D {
> > @@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_=
sb_info *cifs_sb, struct cifs_se
> >         return 0;
> >  }
> >
> > +/*
> > + * smb3_sync_ses_chan_max - Synchronize the session's maximum channel =
count
> > + * @ses: pointer to the old CIFS session structure
> > + * @max_channels: new maximum number of channels to allow
> > + *
> > + * Updates the session's chan_max field to the new value, protecting t=
he update
> > + * with the session's channel lock. This should be called whenever the=
 maximum
> > + * allowed channels for a session changes (e.g., after a remount or re=
configure).
> > + */
> > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int =
max_channels)
> > +{
> > +       spin_lock(&ses->chan_lock);
> > +       ses->chan_max =3D max_channels;
> > +       spin_unlock(&ses->chan_lock);
> > +}
> > +
> >  static int smb3_reconfigure(struct fs_context *fc)
> >  {
> >         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> > @@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_context *f=
c)
> >                 ses->password2 =3D new_password2;
> >         }
> >
> > -       mutex_unlock(&ses->session_mutex);
> > +       /*
> > +        * If multichannel or max_channels has changed, update the sess=
ion's channels accordingly.
> > +        * This may add or remove channels to match the new configurati=
on.
> > +        */
> > +       if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> > +           (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> > +
> > +               /* Synchronize ses->chan_max with the new mount context=
 */
> > +               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> > +               /* Now update the session's channels to match the new c=
onfiguration */
> > +               /* Prevent concurrent scaling operations */
> > +               spin_lock(&ses->ses_lock);
> > +               if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> > +                       spin_unlock(&ses->ses_lock);
> > +                       return -EINVAL;
> > +               }
> > +               ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> > +               spin_unlock(&ses->ses_lock);
> > +
> > +               mutex_unlock(&ses->session_mutex);
> > +
> > +               rc =3D smb3_update_ses_channels(ses, ses->server,
> > +                                              false /* from_reconnect =
*/,
> > +                                              true /* from_reconfigure=
 */);
> > +
> > +               /* Clear scaling flag after operation */
> > +               spin_lock(&ses->ses_lock);
> > +               ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
> > +               spin_unlock(&ses->ses_lock);
> > +       } else {
> > +               mutex_unlock(&ses->session_mutex);
> > +       }
> >
> >         STEAL_STRING(cifs_sb, ctx, domainname);
> >         STEAL_STRING(cifs_sb, ctx, nodename);
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index ef3b498b0a02..cfd83986a84a 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses=
)
> >  }
> >
> >  /*
> > - * called when multichannel is disabled by the server.
> > - * this always gets called from smb2_reconnect
> > - * and cannot get called in parallel threads.
> > + * cifs_decrease_secondary_channels - Reduce the number of active seco=
ndary channels
> > + * @ses: pointer to the CIFS session structure
> > + * @from_reconfigure: if true, only reduce to chan_max; if false, redu=
ce to a single channel
> > + *
> > + * This function disables and cleans up extra secondary channels for a=
 CIFS session.
> > + * If called during reconfiguration, it reduces the channel count to t=
he new maximum (chan_max).
> > + * Otherwise, it disables all but the primary channel.
> >   */
> >  void
> > -cifs_disable_secondary_channels(struct cifs_ses *ses)
> > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_recon=
figure)
> >  {
> >         int i, chan_count;
> >         struct TCP_Server_Info *server;
> > @@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs_ses *=
ses)
> >         if (chan_count =3D=3D 1)
> >                 goto done;
> >
> > -       ses->chan_count =3D 1;
> > -
> > -       /* for all secondary channels reset the need reconnect bit */
> > -       ses->chans_need_reconnect &=3D 1;
> > +       /* Update the chan_count to the new maximum */
> > +       if (from_reconfigure)
> > +               ses->chan_count =3D ses->chan_max;
> > +       else
> > +               ses->chan_count =3D 1;
> >
> > -       for (i =3D 1; i < chan_count; i++) {
> > +       for (i =3D ses->chan_max ; i < chan_count; i++) {
> >                 iface =3D ses->chans[i].iface;
> >                 server =3D ses->chans[i].server;
> >
> > @@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_ses *s=
es)
> >                 spin_lock(&ses->chan_lock);
> >         }
> >
> > +       /* For extra secondary channels, reset the need reconnect bit *=
/
> > +       if (ses->chan_count =3D=3D 1) {
> > +               cifs_dbg(VFS, "server does not support multichannel any=
more. Disable all other channels\n");
> > +               ses->chans_need_reconnect &=3D 1;
> > +       } else {
> > +               cifs_dbg(VFS, "Disable extra secondary channels\n");
> > +               ses->chans_need_reconnect &=3D ((1UL << ses->chan_max) =
- 1);
> > +       }
> > +
> >  done:
> >         spin_unlock(&ses->chan_lock);
> >  }
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index 8b4a4573e9c3..d051da46eaab 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb=
2_cmd,
> >  static int
> >  cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >                           struct TCP_Server_Info *server,
> > -                         bool from_reconnect)
> > +                         bool from_reconnect, bool from_reconfigure)
> >  {
> >         struct TCP_Server_Info *pserver;
> >         unsigned int chan_index;
> > @@ -206,14 +206,41 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >                 return -EHOSTDOWN;
> >         }
> >
> > -       cifs_server_dbg(VFS,
> > -               "server does not support multichannel anymore. Disable =
all other channels\n");
> > -       cifs_disable_secondary_channels(ses);
> > -
> > +       cifs_decrease_secondary_channels(ses, from_reconfigure);
> >
> >         return 0;
> >  }
> >
> > +/*
> > + * smb3_update_ses_channels - Synchronize session channels with new co=
nfiguration
> > + * @ses: pointer to the CIFS session structure
> > + * @server: pointer to the TCP server info structure
> > + * @from_reconnect: indicates if called from reconnect context
> > + * @from_reconfigure: indicates if called from reconfigure context
> > + *
> > + * Returns 0 on success or error code on failure.
> > + *
> > + * Note: Outside of reconfigure, this function is only called from rec=
onnect scenarios
> > + * when the server stops advertising multichannel (MC) capability.
> > + */
>
> I see that function is being called during mount too. Did you
> mean cifs_decrease_secondary_channels()?
>
> > +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_I=
nfo *server,
> > +                       bool from_reconnect, bool from_reconfigure)
> > +{
> > +       int rc =3D 0;
> > +       /*
> > +        * If the current channel count is less than the new chan_max,
> > +        * try to add channels to reach the new maximum.
> > +        * Otherwise, disable or skip extra channels to match the new c=
onfiguration.
> > +        */
> > +       if (ses->chan_count < ses->chan_max)
> > +               rc =3D cifs_try_adding_channels(ses);
> > +       else
> > +               rc =3D cifs_chan_skip_or_disable(ses, server, from_reco=
nnect,
> > +                                               from_reconfigure);
> > +
> > +       return rc;
> > +}
> > +
> >  static int
> >  smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
> >                struct TCP_Server_Info *server, bool from_reconnect)
> > @@ -355,8 +382,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >          */
> >         if (ses->chan_count > 1 &&
> >             !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> > -               rc =3D cifs_chan_skip_or_disable(ses, server,
> > -                                              from_reconnect);
> > +               rc =3D smb3_update_ses_channels(ses, server,
> > +                                              from_reconnect, false /*=
 from_reconfigure */);
> >                 if (rc) {
> >                         mutex_unlock(&ses->session_mutex);
> >                         goto out;
> > @@ -438,8 +465,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >                          * treat this as server not supporting multicha=
nnel
> >                          */
> >
> > -                       rc =3D cifs_chan_skip_or_disable(ses, server,
> > -                                                      from_reconnect);
> > +                       rc =3D smb3_update_ses_channels(ses, server,
> > +                                                      from_reconnect,
> > +                                                      false /* from_re=
configure */);
> >                         goto skip_add_channels;
> >                 } else if (rc)
> >                         cifs_tcon_dbg(FYI, "%s: failed to query server =
interfaces: %d\n",
> > @@ -451,7 +479,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >                         if (ses->chan_count =3D=3D 1)
> >                                 cifs_server_dbg(VFS, "supports multicha=
nnel now\n");
> >
> > -                       cifs_try_adding_channels(ses);
> > +                       smb3_update_ses_channels(ses, server, from_reco=
nnect,
> > +                                                 false /* from_reconfi=
gure */);
> >                 }
> >         } else {
> >                 mutex_unlock(&ses->session_mutex);
> > @@ -1105,8 +1134,7 @@ SMB2_negotiate(const unsigned int xid,
> >                 req->SecurityMode =3D 0;
> >
> >         req->Capabilities =3D cpu_to_le32(server->vals->req_capabilitie=
s);
> > -       if (ses->chan_max > 1)
> > -               req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULT=
I_CHANNEL);
> > +       req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNE=
L);
> >
> >         /* ClientGUID must be zero for SMB2.02 dialect */
> >         if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > @@ -1312,8 +1340,7 @@ int smb3_validate_negotiate(const unsigned int xi=
d, struct cifs_tcon *tcon)
> >
> >         pneg_inbuf->Capabilities =3D
> >                         cpu_to_le32(server->vals->req_capabilities);
> > -       if (tcon->ses->chan_max > 1)
> > -               pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_C=
AP_MULTI_CHANNEL);
> > +       pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI=
_CHANNEL);
> >
> >         memcpy(pneg_inbuf->Guid, server->client_guid,
> >                                         SMB2_CLIENT_GUID_SIZE);
> > --
> > 2.43.0
> >
> >
>
> Thanks
> Meetakshi
>


--=20
Regards,
Shyam
