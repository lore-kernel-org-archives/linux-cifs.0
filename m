Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F414E30DEDA
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 06:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607972; cv=none; b=KW6+CaLx3N8oixNPR8Xn6c7QHQkbea9MhdFvxKb4MMrb0qjP1/q0eSLIiNbdVL9j6SIgQ4k/Hxuz7RIZHWR2vzdJMC5IomLd59hy35vT9GWiAFLZ4XFy3QSqty0rKhBxiEM4GeMybQDRy7PVvVVdkrbNBdO/LCI2FNH9c1EjUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607972; c=relaxed/simple;
	bh=zCQM/5InL3xzYdezTp/8cg5PGBQqpHWZvo4aVBSn460=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5up/1TXNnP+zAvdNDCQ2hFLV2cei8qYPIoSDJg9AtAHKwWqvBM/QeIsVH9sz+soFdU5l2U9ixe7xK93NLzK50cbVD/YF7LY7EBtfLr0eCfY/2KlfoR4PXTMGgrSqCg9LRtRu3P7uP5nYgKX/xSEcwow0040WO0M/37GzG97250=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LIBr1zEe; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LIBr1zEe"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62fc89cd630so5621623a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 22 Sep 2025 23:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758607968; x=1759212768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1w9gNikfwvygbV6it/YPwZidTE5EG1bRuk6yafVjRA=;
        b=LIBr1zEekZ2lnZH4T1LJO9B2/VYepdEcGAYA0b0dAHnmQ5DimPzyn01w6ipPBy0+U1
         neiWYGGMfX4fTQLyejbTBGZRjphdaCWY/IxHiDVBNibCYDryKSTgNDoCYK1LH1EI7AsC
         X8No6lcdJhoYYe4Wvu6wv+uJ1OJEOkcghZ7CNFkr/UO1u3SwLT/7wImU2O+9Z9fHhieZ
         dQQxn5+xID1leUJKsXnMbiZy66EJecIvWB6vnGDfGkN22W+cJDjfUfLoaQEf8SjfNyj6
         otMwfMnaMYEtWe/CPCW5m5i8ZqDLoxTcEYhCsVy5YMSdTJ1ioUHot7LrEpj3JG+ds+x2
         FdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758607968; x=1759212768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m1w9gNikfwvygbV6it/YPwZidTE5EG1bRuk6yafVjRA=;
        b=fhRc5ddXYkZYSKDiBGiKR8h0mzwMVO7XbFHiVvwSUZS0UEDbe0GkvEGiPKAAXk91VC
         9iCXgGbvCLzPA+abetLk2o1mhGeqaCSlA+kvtAtSj5rm3BBQphZSQBUv0i2ezA2kiQhQ
         4w5vDfW1RJBdZXICpdnSUI3CeoIawbObHOgvExuW9hVrtFvm7grIktbAjsz1buVd4duo
         EB2cGtVYO0mod6wE1Mo4UyALXM4uEvJ1y0toDYvboXosgyKGgYOdmoWLa6sE8yOBtMLC
         Dxt17BiVqEw88C5I30KTPy8dRhKzsyooFIk2I2ASFjqwTtU0A4initWLW2D9FWJ7kn3O
         +PRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9YTirMxDQ1cEHbHH8rBz84sakGCMuzIxb1FdUD07eBAWGw2bfBIIvlgcgmbsRuEwhUC8xDptkZmBk@vger.kernel.org
X-Gm-Message-State: AOJu0YwkbF7Txhe+RSFuqIMGEY3G9SIoHUVnm6vylEZ8k+sUsW8pODfX
	3S0SnDK5QQlYBJVWqAged1E/5ZfNbzXjhYXpcy+Id4FTXDX3HpY+43MHQtdGaiIsDKIr/raUDJZ
	p5DvuLcVnslkIvL2MNXgCHQMaCze/c0pLisA8
X-Gm-Gg: ASbGnctGDNtk2SW3V3TCHcbXRtJ/W8dQXiONdbiZ7OdV0CHB96mHgtm5dd4BDZVMqeQ
	biVHkp2BllA3v789Bih27p89GU9bT4l2OBz7tK6wXCBveKnFlr1KMxCZ9rcr/Is/sfB36OLYUOw
	SfPLw3D1YLdVQBwvdDfHxwu05s8VkwAc6SqVXBuP3eTI/VTI5khgcW01kqR0fNYm/B9//c7XelQ
	PA+Ig==
X-Google-Smtp-Source: AGHT+IEfgroAmNYQRwZEfIYrF8wJtV6S7XNygoK2N2Igw/bDMliejcEbfDXQlBRQFk4sov4X4b6qS9/azhAzLbPhcUQ=
X-Received: by 2002:a17:907:bc97:b0:b30:852e:bea with SMTP id
 a640c23a62f3a-b30852e0e98mr79735466b.63.1758607967971; Mon, 22 Sep 2025
 23:12:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <20250922082417.816331-2-rajasimandalos@gmail.com> <d09c8506-6326-45e6-8687-8e0b002eff62@suse.com>
In-Reply-To: <d09c8506-6326-45e6-8687-8e0b002eff62@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 23 Sep 2025 11:42:36 +0530
X-Gm-Features: AS18NWACbxkiOakGZs7h9HRaSJJwdU0CskzkFIT_giAyrAUroOPsyTrRTYUKzI8
Message-ID: <CANT5p=qsh+jJ2PD2vy1x7ZjE646Hh28n1epS7Fy=RSqmuht_=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: client: allow changing multichannel mount
 options on remount
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: rajasimandalos@gmail.com, Rajasi Mandal <rajasimandal@microsoft.com>, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, linux-kernel@vger.kernel.org, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 2:52=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Hi Rajasi,
>
> On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
> > From: Rajasi Mandal <rajasimandal@microsoft.com>
> >
> > Previously, the client did not properly update the session's channel
> > state when multichannel or max_channels mount options were changed
> > during remount. This led to inconsistent behavior and prevented
> > enabling or disabling multichannel support without a full
> > unmount/remount.
> >
> > Enable dynamic reconfiguration of multichannel and max_channels
> > options during remount by introducing smb3_sync_ses_chan_max() to
> > safely update the session's chan_max field, and smb3_sync_ses_channels(=
)
> > to synchronize the session's channels with the new configuration.
> > Replace cifs_disable_secondary_channels() with
> > cifs_decrease_secondary_channels(), which now takes a from_reconfigure
> > argument for more flexible channel cleanup. Update the remount logic
> > to detect changes in multichannel or max_channels and trigger the
> > appropriate session/channel updates.
> >
> > With this change, users can safely change multichannel and
> > max_channels options on remount, and the client will correctly adjust
> > the session's channel state to match the new configuration.
> >
> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > ---
> >  fs/smb/client/cifsproto.h  |  2 +-
> >  fs/smb/client/fs_context.c | 29 ++++++++++++++++++
> >  fs/smb/client/fs_context.h |  2 +-
> >  fs/smb/client/sess.c       | 35 +++++++++++++++-------
> >  fs/smb/client/smb2pdu.c    | 60 ++++++++++++++++++++++++++++++--------
> >  fs/smb/client/smb2pdu.h    |  2 ++
> >  6 files changed, 105 insertions(+), 25 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index e8fba98690ce..ec3118457b26 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -667,7 +667,7 @@ bool
> >  cifs_chan_is_iface_active(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server);
> >  void
> > -cifs_disable_secondary_channels(struct cifs_ses *ses);
> > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_recon=
figure);
> >  void
> >  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *s=
erver);
> >  int
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index 43552b44f613..96e80c70f25d 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -1015,6 +1015,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_=
sb_info *cifs_sb, struct cifs_se
> >       return 0;
> >  }
> >
> > +/**
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
> > +void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_cha=
nnels)
> > +{
> > +     spin_lock(&ses->chan_lock);
> > +     ses->chan_max =3D max_channels;
> > +     spin_unlock(&ses->chan_lock);
> > +}
> > +
>
> The other writer of chan_max is when creating a session. Is this lock
> really avoiding a race here?

It's not just the writers, but also readers that we protect with this
lock. I don't have major objections to the locking here.

>
> >  static int smb3_reconfigure(struct fs_context *fc)
> >  {
> >       struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> > @@ -1097,6 +1113,18 @@ static int smb3_reconfigure(struct fs_context *f=
c)
> >               ses->password2 =3D new_password2;
> >       }
> >
> > +     /*
> > +      * If multichannel or max_channels has changed, update the sessio=
n's channels accordingly.
> > +      * This may add or remove channels to match the new configuration=
.
> > +      */
> > +     if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> > +             (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> > +             //Synchronize ses->chan_max with the new mount context
> > +             smb3_sync_ses_chan_max(ses, ctx->max_channels);
> > +             //Now update the session's channels to match the new conf=
iguration
> > +             rc =3D smb3_sync_ses_channels(cifs_sb);
> > +     }
> > +
> >       mutex_unlock(&ses->session_mutex);
> >
> >       STEAL_STRING(cifs_sb, ctx, domainname);
> > @@ -1110,6 +1138,7 @@ static int smb3_reconfigure(struct fs_context *fc=
)
> >       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
> >       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
> >       smb3_update_mnt_flags(cifs_sb);
> > +
> >  #ifdef CONFIG_CIFS_DFS_UPCALL
> >       if (!rc)
> >               rc =3D dfs_cache_remount_fs(cifs_sb);
> > diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
> > index b0fec6b9a23b..a75185858285 100644
> > --- a/fs/smb/client/fs_context.h
> > +++ b/fs/smb/client/fs_context.h
> > @@ -371,7 +371,7 @@ static inline struct smb3_fs_context *smb3_fc2conte=
xt(const struct fs_context *f
> >  extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struct=
 smb3_fs_context *ctx);
> >  extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_s=
b, struct cifs_ses *ses);
> >  extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
> > -
> > +extern void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int =
max_channels);
> >  /*
> >   * max deferred close timeout (jiffies) - 2^30
> >   */
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index 0a8c2fcc9ded..42b5481c884a 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -264,13 +264,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses=
)
> >       return new_chan_count - old_chan_count;
> >  }
> >
> > -/*
> > - * called when multichannel is disabled by the server.
> > - * this always gets called from smb2_reconnect
> > - * and cannot get called in parallel threads.
> > +/**
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
> > -void
> > -cifs_disable_secondary_channels(struct cifs_ses *ses)
> > +void cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_=
reconfigure)
> >  {
>
> Maybe you could get rid of from_reconfigure parameter if you just set
> chan_max to 1 before calling cifs_decrease_secondary_channels when this
> function is not called from smb3_reconfigure. What do you think?

chan_max today is set based on "max_channels" mount option that the user se=
ts.
I don't think we should be modifying that value. Unless we change it's
meaning today. :)

>
> >       int i, chan_count;
> >       struct TCP_Server_Info *server;
> > @@ -281,12 +284,13 @@ cifs_disable_secondary_channels(struct cifs_ses *=
ses)
> >       if (chan_count =3D=3D 1)
> >               goto done;
> >
> > -     ses->chan_count =3D 1;
> > -
> > -     /* for all secondary channels reset the need reconnect bit */
> > -     ses->chans_need_reconnect &=3D 1;
> > +     // Update the chan_count to the new maximum
> > +     if (from_reconfigure)
> > +             ses->chan_count =3D ses->chan_max;
> > +     else
> > +             ses->chan_count =3D 1;
> >
> > -     for (i =3D 1; i < chan_count; i++) {
> > +     for (i =3D ses->chan_max ; i < chan_count; i++) {
> >               iface =3D ses->chans[i].iface;
> >               server =3D ses->chans[i].server;
> >
> > @@ -318,6 +322,15 @@ cifs_disable_secondary_channels(struct cifs_ses *s=
es)
> >               spin_lock(&ses->chan_lock);
> >       }
> >
> > +     /* For extra secondary channels, reset the need reconnect bit */
> > +     if (ses->chan_count =3D=3D 1) {
> > +             cifs_server_dbg(VFS, "server does not support multichanne=
l anymore. Disable all other channels\n");
> > +             ses->chans_need_reconnect &=3D 1;
> > +     } else {
> > +             cifs_server_dbg(VFS, "Disable extra secondary channels\n"=
);
> > +             ses->chans_need_reconnect &=3D ((1UL << ses->chan_max) - =
1);
> > +     }
> > +
> >  done:
> >       spin_unlock(&ses->chan_lock);
> >  }
> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > index c3b9d3f6210f..bf9a8dc0e8fc 100644
> > --- a/fs/smb/client/smb2pdu.c
> > +++ b/fs/smb/client/smb2pdu.c
> > @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb=
2_cmd,
> >  static int
> >  cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server,
> > -                       bool from_reconnect)
> > +                       bool from_reconnect, bool from_reconfigure)
> >  {
> >       struct TCP_Server_Info *pserver;
> >       unsigned int chan_index;
> > @@ -206,10 +206,49 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> >               return -EHOSTDOWN;
> >       }
> >
> > -     cifs_server_dbg(VFS,
> > -             "server does not support multichannel anymore. Disable al=
l other channels\n");
> > -     cifs_disable_secondary_channels(ses);
> > +     cifs_decrease_secondary_channels(ses, from_reconfigure);
> >
> > +     return 0;
> > +}
> > +
> > +/**
> > + * smb3_sync_ses_channels - Synchronize session channels
> > + * with new configuration (cifs_sb_info version)
> > + * @cifs_sb: pointer to the CIFS superblock info structure
> > + * Returns 0 on success or -EINVAL if scaling is already in progress.
> > + */
> > +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb)
> > +{
> > +     struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
> > +     struct smb3_fs_context *ctx =3D cifs_sb->ctx;
> > +     bool from_reconnect =3D false;
> > +
> > +     /* Prevent concurrent scaling operations */
> > +     spin_lock(&ses->ses_lock);
> > +     if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> > +             spin_unlock(&ses->ses_lock);
> > +             return -EINVAL;
> > +     }
> > +     ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> > +     spin_unlock(&ses->ses_lock);
> > +
> > +     /*
> > +      * If the old max_channels is less than the new chan_max,
> > +      * try to add channels to reach the new maximum.
> > +      * Otherwise, disable or skip extra channels to match the new con=
figuration.
> > +      */
> > +     if (ctx->max_channels < ses->chan_max) {
> > +             mutex_unlock(&ses->session_mutex);
> > +             cifs_try_adding_channels(ses);
> > +             mutex_lock(&ses->session_mutex);
> > +     } else {
>
> Maybe you can avoid entering any cifs_chan_skip_or_disable if
> ctx->max_channels =3D=3D ses->chan_max. There is a cost of holding locks
> inside of it.
>
> > +             cifs_chan_skip_or_disable(ses, ses->server, from_reconnec=
t, true);
> > +     }
> > +
> > +     /* Clear scaling flag after operation */
> > +     spin_lock(&ses->ses_lock);
> > +     ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
> > +     spin_unlock(&ses->ses_lock);
> >
> >       return 0;
> >  }
> > @@ -356,7 +395,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >       if (ses->chan_count > 1 &&
> >           !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> >               rc =3D cifs_chan_skip_or_disable(ses, server,
> > -                                            from_reconnect);
> > +                                            from_reconnect, false);
> >               if (rc) {
> >                       mutex_unlock(&ses->session_mutex);
> >                       goto out;
> > @@ -439,7 +478,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
> >                        */
> >
> >                       rc =3D cifs_chan_skip_or_disable(ses, server,
> > -                                                    from_reconnect);
> > +                                                    from_reconnect, fa=
lse);
> >                       goto skip_add_channels;
> >               } else if (rc)
> >                       cifs_dbg(FYI, "%s: failed to query server interfa=
ces: %d\n",
> > @@ -1105,8 +1144,7 @@ SMB2_negotiate(const unsigned int xid,
> >               req->SecurityMode =3D 0;
> >
> >       req->Capabilities =3D cpu_to_le32(server->vals->req_capabilities)=
;
> > -     if (ses->chan_max > 1)
> > -             req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_=
CHANNEL);
> > +     req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL)=
;
> >
> >       /* ClientGUID must be zero for SMB2.02 dialect */
> >       if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > @@ -1310,10 +1348,8 @@ int smb3_validate_negotiate(const unsigned int x=
id, struct cifs_tcon *tcon)
> >       if (!pneg_inbuf)
> >               return -ENOMEM;
> >
> > -     pneg_inbuf->Capabilities =3D
> > -                     cpu_to_le32(server->vals->req_capabilities);
> > -     if (tcon->ses->chan_max > 1)
> > -             pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP=
_MULTI_CHANNEL);
> > +     pneg_inbuf->Capabilities =3D cpu_to_le32(server->vals->req_capabi=
lities);
> > +     pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_C=
HANNEL);
> >
> >       memcpy(pneg_inbuf->Guid, server->client_guid,
> >                                       SMB2_CLIENT_GUID_SIZE);
> > diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> > index 3c09a58dfd07..d3f63a4ef426 100644
> > --- a/fs/smb/client/smb2pdu.h
> > +++ b/fs/smb/client/smb2pdu.h
> > @@ -420,6 +420,8 @@ struct smb2_create_ea_ctx {
> >       struct smb2_file_full_ea_info ea;
> >  } __packed;
> >
> > +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb);
> > +
> >  #define SMB2_WSL_XATTR_UID           "$LXUID"
> >  #define SMB2_WSL_XATTR_GID           "$LXGID"
> >  #define SMB2_WSL_XATTR_MODE          "$LXMOD"
>
> I also agree with Enzo that we could have an update_channels that
> centralizes the logic of rescaling channels, but that could also come in
> another patch as Steve suggested.
Ack. We'll review that.

>
> --
> Henrique
> SUSE Labs
>

Thank you for reviewing.

--=20
Regards,
Shyam
