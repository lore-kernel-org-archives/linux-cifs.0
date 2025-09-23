Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4AEB1A9F90
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 14:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637289; cv=none; b=jClRs1TQR27z51WvYzYahqbkrGweY788ivJXomDxSFsATn4wl4nw9CyKA+0xqmxymC3v+QNffHtJT+Dyx2yC+PGieiTjvGxZMTXr2Urikx9NamN85dFmq8bDywiH/A0jOwkcTXIWbMlc/7NME491svTSLlb0IWUggsHDnpDz4zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637289; c=relaxed/simple;
	bh=PvdKvf1S3JbHarINYQ+ipxP/u2nXOsLQS5dNFCnpIxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mnx2MTcVwW+h2VLcZp+y5GQGYiaitpoiQP7ZxUUvHcXSGlB7k6yfmXoIut10nWrM5dXuYQYNctZ6jFOqsS9tPtHi4QyTAdV+ZE+wxErze90YSMyHQie2GlL11KiGGiauqYt+XyJQmmtIW+bVIm89O0+dTnFgXEJNHRXqohMXT38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dzvWxCcJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wB21DUoU; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=dzvWxCcJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wB21DUoU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dzvWxCcJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wB21DUoU";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="dzvWxCcJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wB21DUoU"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 17A781F7EE;
	Tue, 23 Sep 2025 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758637285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7LGle4LkK6SZCj0hDxitRI/0FIhGAyL4PgBCyHIp4Q=;
	b=dzvWxCcJuyZJJ2L7MMwKOW1MWzWa7c/ZN9S75Q6sC4cVqTBzU3c0OLzTYA80jojBcu183U
	xbJQ1KSosmD23YZJtMz+p0aSDxGgcXtWkzY05PvNUaJ2PuJ0MuR3Tks+OFESmspVnKSfqF
	5/np6lb4ZxLTxQ1yuQgmYjx7Ic8MpQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758637285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7LGle4LkK6SZCj0hDxitRI/0FIhGAyL4PgBCyHIp4Q=;
	b=wB21DUoU5Y46uraR45rk5tWCfoHiQbE6YRmtZKc9qEEFrYnEcISXQi+kNjmjyxVfKSSlic
	4wGW5evhbsy60MAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758637285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7LGle4LkK6SZCj0hDxitRI/0FIhGAyL4PgBCyHIp4Q=;
	b=dzvWxCcJuyZJJ2L7MMwKOW1MWzWa7c/ZN9S75Q6sC4cVqTBzU3c0OLzTYA80jojBcu183U
	xbJQ1KSosmD23YZJtMz+p0aSDxGgcXtWkzY05PvNUaJ2PuJ0MuR3Tks+OFESmspVnKSfqF
	5/np6lb4ZxLTxQ1yuQgmYjx7Ic8MpQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758637285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u7LGle4LkK6SZCj0hDxitRI/0FIhGAyL4PgBCyHIp4Q=;
	b=wB21DUoU5Y46uraR45rk5tWCfoHiQbE6YRmtZKc9qEEFrYnEcISXQi+kNjmjyxVfKSSlic
	4wGW5evhbsy60MAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97948132C9;
	Tue, 23 Sep 2025 14:21:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id co6lF+Ss0miwQQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 23 Sep 2025 14:21:24 +0000
Date: Tue, 23 Sep 2025 11:21:18 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, 
	rajasimandalos@gmail.com, Rajasi Mandal <rajasimandal@microsoft.com>, sfrench@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH 2/2] cifs: client: allow changing multichannel mount
 options on remount
Message-ID: <mrcj7b6wyh5hyqwgufasxpwxytllzuboro4fjunrqro6eq3siz@6ncku7sdjpkn>
References: <20250922082417.816331-1-rajasimandalos@gmail.com>
 <20250922082417.816331-2-rajasimandalos@gmail.com>
 <d09c8506-6326-45e6-8687-8e0b002eff62@suse.com>
 <CANT5p=qsh+jJ2PD2vy1x7ZjE646Hh28n1epS7Fy=RSqmuht_=g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANT5p=qsh+jJ2PD2vy1x7ZjE646Hh28n1epS7Fy=RSqmuht_=g@mail.gmail.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.com,gmail.com,microsoft.com,samba.org,manguebit.org,talpey.com,vger.kernel.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

On 09/23, Shyam Prasad N wrote:
>On Tue, Sep 23, 2025 at 2:52=E2=80=AFAM Henrique Carvalho
><henrique.carvalho@suse.com> wrote:
>>
>> Hi Rajasi,
>>
>> On 9/22/25 5:24 AM, rajasimandalos@gmail.com wrote:
>> > From: Rajasi Mandal <rajasimandal@microsoft.com>
>> >
>> > Previously, the client did not properly update the session's channel
>> > state when multichannel or max_channels mount options were changed
>> > during remount. This led to inconsistent behavior and prevented
>> > enabling or disabling multichannel support without a full
>> > unmount/remount.
>> >
>> > Enable dynamic reconfiguration of multichannel and max_channels
>> > options during remount by introducing smb3_sync_ses_chan_max() to
>> > safely update the session's chan_max field, and smb3_sync_ses_channels=
()
>> > to synchronize the session's channels with the new configuration.
>> > Replace cifs_disable_secondary_channels() with
>> > cifs_decrease_secondary_channels(), which now takes a from_reconfigure
>> > argument for more flexible channel cleanup. Update the remount logic
>> > to detect changes in multichannel or max_channels and trigger the
>> > appropriate session/channel updates.
>> >
>> > With this change, users can safely change multichannel and
>> > max_channels options on remount, and the client will correctly adjust
>> > the session's channel state to match the new configuration.
>> >
>> > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
>> > ---
>> >  fs/smb/client/cifsproto.h  |  2 +-
>> >  fs/smb/client/fs_context.c | 29 ++++++++++++++++++
>> >  fs/smb/client/fs_context.h |  2 +-
>> >  fs/smb/client/sess.c       | 35 +++++++++++++++-------
>> >  fs/smb/client/smb2pdu.c    | 60 ++++++++++++++++++++++++++++++--------
>> >  fs/smb/client/smb2pdu.h    |  2 ++
>> >  6 files changed, 105 insertions(+), 25 deletions(-)
>> >
>> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>> > index e8fba98690ce..ec3118457b26 100644
>> > --- a/fs/smb/client/cifsproto.h
>> > +++ b/fs/smb/client/cifsproto.h
>> > @@ -667,7 +667,7 @@ bool
>> >  cifs_chan_is_iface_active(struct cifs_ses *ses,
>> >                         struct TCP_Server_Info *server);
>> >  void
>> > -cifs_disable_secondary_channels(struct cifs_ses *ses);
>> > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reco=
nfigure);
>> >  void
>> >  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *=
server);
>> >  int
>> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
>> > index 43552b44f613..96e80c70f25d 100644
>> > --- a/fs/smb/client/fs_context.c
>> > +++ b/fs/smb/client/fs_context.c
>> > @@ -1015,6 +1015,22 @@ int smb3_sync_session_ctx_passwords(struct cifs=
_sb_info *cifs_sb, struct cifs_se
>> >       return 0;
>> >  }
>> >
>> > +/**
>> > + * smb3_sync_ses_chan_max - Synchronize the session's maximum channel=
 count
>> > + * @ses: pointer to the old CIFS session structure
>> > + * @max_channels: new maximum number of channels to allow
>> > + *
>> > + * Updates the session's chan_max field to the new value, protecting =
the update
>> > + * with the session's channel lock. This should be called whenever th=
e maximum
>> > + * allowed channels for a session changes (e.g., after a remount or r=
econfigure).
>> > + */
>> > +void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_ch=
annels)
>> > +{
>> > +     spin_lock(&ses->chan_lock);
>> > +     ses->chan_max =3D max_channels;
>> > +     spin_unlock(&ses->chan_lock);
>> > +}
>> > +
>>
>> The other writer of chan_max is when creating a session. Is this lock
>> really avoiding a race here?

That locked write on ses creation is also useless as it's done before ses
is even on list i.e. no other thread can even see this ses yet.

>It's not just the writers, but also readers that we protect with this
>lock. I don't have major objections to the locking here.

I couldn't find any _locked_ readers of ses->chan_max, did I miss
anything?

>> >  static int smb3_reconfigure(struct fs_context *fc)
>> >  {
>> >       struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
>> > @@ -1097,6 +1113,18 @@ static int smb3_reconfigure(struct fs_context *=
fc)
>> >               ses->password2 =3D new_password2;
>> >       }
>> >
>> > +     /*
>> > +      * If multichannel or max_channels has changed, update the sessi=
on's channels accordingly.
>> > +      * This may add or remove channels to match the new configuratio=
n.
>> > +      */
>> > +     if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
>> > +             (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
>> > +             //Synchronize ses->chan_max with the new mount context
>> > +             smb3_sync_ses_chan_max(ses, ctx->max_channels);
>> > +             //Now update the session's channels to match the new con=
figuration
>> > +             rc =3D smb3_sync_ses_channels(cifs_sb);
>> > +     }
>> > +
>> >       mutex_unlock(&ses->session_mutex);
>> >
>> >       STEAL_STRING(cifs_sb, ctx, domainname);
>> > @@ -1110,6 +1138,7 @@ static int smb3_reconfigure(struct fs_context *f=
c)
>> >       smb3_cleanup_fs_context_contents(cifs_sb->ctx);
>> >       rc =3D smb3_fs_context_dup(cifs_sb->ctx, ctx);
>> >       smb3_update_mnt_flags(cifs_sb);
>> > +
>> >  #ifdef CONFIG_CIFS_DFS_UPCALL
>> >       if (!rc)
>> >               rc =3D dfs_cache_remount_fs(cifs_sb);
>> > diff --git a/fs/smb/client/fs_context.h b/fs/smb/client/fs_context.h
>> > index b0fec6b9a23b..a75185858285 100644
>> > --- a/fs/smb/client/fs_context.h
>> > +++ b/fs/smb/client/fs_context.h
>> > @@ -371,7 +371,7 @@ static inline struct smb3_fs_context *smb3_fc2cont=
ext(const struct fs_context *f
>> >  extern int smb3_fs_context_dup(struct smb3_fs_context *new_ctx, struc=
t smb3_fs_context *ctx);
>> >  extern int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_=
sb, struct cifs_ses *ses);
>> >  extern void smb3_update_mnt_flags(struct cifs_sb_info *cifs_sb);
>> > -
>> > +extern void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int=
 max_channels);
>> >  /*
>> >   * max deferred close timeout (jiffies) - 2^30
>> >   */
>> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
>> > index 0a8c2fcc9ded..42b5481c884a 100644
>> > --- a/fs/smb/client/sess.c
>> > +++ b/fs/smb/client/sess.c
>> > @@ -264,13 +264,16 @@ int cifs_try_adding_channels(struct cifs_ses *se=
s)
>> >       return new_chan_count - old_chan_count;
>> >  }
>> >
>> > -/*
>> > - * called when multichannel is disabled by the server.
>> > - * this always gets called from smb2_reconnect
>> > - * and cannot get called in parallel threads.
>> > +/**
>> > + * cifs_decrease_secondary_channels - Reduce the number of active sec=
ondary channels
>> > + * @ses: pointer to the CIFS session structure
>> > + * @from_reconfigure: if true, only reduce to chan_max; if false, red=
uce to a single channel
>> > + *
>> > + * This function disables and cleans up extra secondary channels for =
a CIFS session.
>> > + * If called during reconfiguration, it reduces the channel count to =
the new maximum (chan_max).
>> > + * Otherwise, it disables all but the primary channel.
>> >   */
>> > -void
>> > -cifs_disable_secondary_channels(struct cifs_ses *ses)
>> > +void cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from=
_reconfigure)
>> >  {
>>
>> Maybe you could get rid of from_reconfigure parameter if you just set
>> chan_max to 1 before calling cifs_decrease_secondary_channels when this
>> function is not called from smb3_reconfigure. What do you think?
>
>chan_max today is set based on "max_channels" mount option that the user s=
ets.
>I don't think we should be modifying that value. Unless we change it's
>meaning today. :)
>
>>
>> >       int i, chan_count;
>> >       struct TCP_Server_Info *server;
>> > @@ -281,12 +284,13 @@ cifs_disable_secondary_channels(struct cifs_ses =
*ses)
>> >       if (chan_count =3D=3D 1)
>> >               goto done;
>> >
>> > -     ses->chan_count =3D 1;
>> > -
>> > -     /* for all secondary channels reset the need reconnect bit */
>> > -     ses->chans_need_reconnect &=3D 1;
>> > +     // Update the chan_count to the new maximum
>> > +     if (from_reconfigure)
>> > +             ses->chan_count =3D ses->chan_max;
>> > +     else
>> > +             ses->chan_count =3D 1;
>> >
>> > -     for (i =3D 1; i < chan_count; i++) {
>> > +     for (i =3D ses->chan_max ; i < chan_count; i++) {
>> >               iface =3D ses->chans[i].iface;
>> >               server =3D ses->chans[i].server;
>> >
>> > @@ -318,6 +322,15 @@ cifs_disable_secondary_channels(struct cifs_ses *=
ses)
>> >               spin_lock(&ses->chan_lock);
>> >       }
>> >
>> > +     /* For extra secondary channels, reset the need reconnect bit */
>> > +     if (ses->chan_count =3D=3D 1) {
>> > +             cifs_server_dbg(VFS, "server does not support multichann=
el anymore. Disable all other channels\n");
>> > +             ses->chans_need_reconnect &=3D 1;
>> > +     } else {
>> > +             cifs_server_dbg(VFS, "Disable extra secondary channels\n=
");
>> > +             ses->chans_need_reconnect &=3D ((1UL << ses->chan_max) -=
 1);
>> > +     }
>> > +
>> >  done:
>> >       spin_unlock(&ses->chan_lock);
>> >  }
>> > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
>> > index c3b9d3f6210f..bf9a8dc0e8fc 100644
>> > --- a/fs/smb/client/smb2pdu.c
>> > +++ b/fs/smb/client/smb2pdu.c
>> > @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 sm=
b2_cmd,
>> >  static int
>> >  cifs_chan_skip_or_disable(struct cifs_ses *ses,
>> >                         struct TCP_Server_Info *server,
>> > -                       bool from_reconnect)
>> > +                       bool from_reconnect, bool from_reconfigure)
>> >  {
>> >       struct TCP_Server_Info *pserver;
>> >       unsigned int chan_index;
>> > @@ -206,10 +206,49 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>> >               return -EHOSTDOWN;
>> >       }
>> >
>> > -     cifs_server_dbg(VFS,
>> > -             "server does not support multichannel anymore. Disable a=
ll other channels\n");
>> > -     cifs_disable_secondary_channels(ses);
>> > +     cifs_decrease_secondary_channels(ses, from_reconfigure);
>> >
>> > +     return 0;
>> > +}
>> > +
>> > +/**
>> > + * smb3_sync_ses_channels - Synchronize session channels
>> > + * with new configuration (cifs_sb_info version)
>> > + * @cifs_sb: pointer to the CIFS superblock info structure
>> > + * Returns 0 on success or -EINVAL if scaling is already in progress.
>> > + */
>> > +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb)
>> > +{
>> > +     struct cifs_ses *ses =3D cifs_sb_master_tcon(cifs_sb)->ses;
>> > +     struct smb3_fs_context *ctx =3D cifs_sb->ctx;
>> > +     bool from_reconnect =3D false;
>> > +
>> > +     /* Prevent concurrent scaling operations */
>> > +     spin_lock(&ses->ses_lock);
>> > +     if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
>> > +             spin_unlock(&ses->ses_lock);
>> > +             return -EINVAL;
>> > +     }
>> > +     ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
>> > +     spin_unlock(&ses->ses_lock);
>> > +
>> > +     /*
>> > +      * If the old max_channels is less than the new chan_max,
>> > +      * try to add channels to reach the new maximum.
>> > +      * Otherwise, disable or skip extra channels to match the new co=
nfiguration.
>> > +      */
>> > +     if (ctx->max_channels < ses->chan_max) {
>> > +             mutex_unlock(&ses->session_mutex);
>> > +             cifs_try_adding_channels(ses);
>> > +             mutex_lock(&ses->session_mutex);
>> > +     } else {
>>
>> Maybe you can avoid entering any cifs_chan_skip_or_disable if
>> ctx->max_channels =3D=3D ses->chan_max. There is a cost of holding locks
>> inside of it.
>>
>> > +             cifs_chan_skip_or_disable(ses, ses->server, from_reconne=
ct, true);
>> > +     }
>> > +
>> > +     /* Clear scaling flag after operation */
>> > +     spin_lock(&ses->ses_lock);
>> > +     ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
>> > +     spin_unlock(&ses->ses_lock);
>> >
>> >       return 0;
>> >  }
>> > @@ -356,7 +395,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tc=
on *tcon,
>> >       if (ses->chan_count > 1 &&
>> >           !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
>> >               rc =3D cifs_chan_skip_or_disable(ses, server,
>> > -                                            from_reconnect);
>> > +                                            from_reconnect, false);
>> >               if (rc) {
>> >                       mutex_unlock(&ses->session_mutex);
>> >                       goto out;
>> > @@ -439,7 +478,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tc=
on *tcon,
>> >                        */
>> >
>> >                       rc =3D cifs_chan_skip_or_disable(ses, server,
>> > -                                                    from_reconnect);
>> > +                                                    from_reconnect, f=
alse);
>> >                       goto skip_add_channels;
>> >               } else if (rc)
>> >                       cifs_dbg(FYI, "%s: failed to query server interf=
aces: %d\n",
>> > @@ -1105,8 +1144,7 @@ SMB2_negotiate(const unsigned int xid,
>> >               req->SecurityMode =3D 0;
>> >
>> >       req->Capabilities =3D cpu_to_le32(server->vals->req_capabilities=
);
>> > -     if (ses->chan_max > 1)
>> > -             req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI=
_CHANNEL);
>> > +     req->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL=
);
>> >
>> >       /* ClientGUID must be zero for SMB2.02 dialect */
>> >       if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
>> > @@ -1310,10 +1348,8 @@ int smb3_validate_negotiate(const unsigned int =
xid, struct cifs_tcon *tcon)
>> >       if (!pneg_inbuf)
>> >               return -ENOMEM;
>> >
>> > -     pneg_inbuf->Capabilities =3D
>> > -                     cpu_to_le32(server->vals->req_capabilities);
>> > -     if (tcon->ses->chan_max > 1)
>> > -             pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CA=
P_MULTI_CHANNEL);
>> > +     pneg_inbuf->Capabilities =3D cpu_to_le32(server->vals->req_capab=
ilities);
>> > +     pneg_inbuf->Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_=
CHANNEL);
>> >
>> >       memcpy(pneg_inbuf->Guid, server->client_guid,
>> >                                       SMB2_CLIENT_GUID_SIZE);
>> > diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
>> > index 3c09a58dfd07..d3f63a4ef426 100644
>> > --- a/fs/smb/client/smb2pdu.h
>> > +++ b/fs/smb/client/smb2pdu.h
>> > @@ -420,6 +420,8 @@ struct smb2_create_ea_ctx {
>> >       struct smb2_file_full_ea_info ea;
>> >  } __packed;
>> >
>> > +int smb3_sync_ses_channels(struct cifs_sb_info *cifs_sb);
>> > +
>> >  #define SMB2_WSL_XATTR_UID           "$LXUID"
>> >  #define SMB2_WSL_XATTR_GID           "$LXGID"
>> >  #define SMB2_WSL_XATTR_MODE          "$LXMOD"
>>
>> I also agree with Enzo that we could have an update_channels that
>> centralizes the logic of rescaling channels, but that could also come in
>> another patch as Steve suggested.
>Ack. We'll review that.
>
>>
>> --
>> Henrique
>> SUSE Labs
>>
>
>Thank you for reviewing.
>
>--=20
>Regards,
>Shyam
>
