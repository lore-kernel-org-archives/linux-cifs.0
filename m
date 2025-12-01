Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1DF2FBDFA
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764580890; cv=none; b=WbezVSrParDYM9ZqK+wSk+VMQTnu37Y8HH6tbvAKqbFrpP/JhndeRmD+d+XaV7HFeRhHvB0d3lkjsrWRreG7GZ5u/6jh8fem0MHqB8hooqEcMAZx/Mb+BjtBYffsH0Jgrtsq6t+n1RzrCh3P4oBv2tmkQYLL7ns7JSMYFPhVkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764580890; c=relaxed/simple;
	bh=P7rdvU7v1z2JjVT2FGVNFOAfrOmMGW3buomSv5yOsWs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l3sCgXUlFvzUAER8WiQDOSpjQK4qx1878NE62bu6IniWK565WtLXwIv2IDiqb/6r8sXgjTjQft0ZKiJQwcaAkN7BU1J8R+N2DdD2diKAwoUEAWHctDDp54N1gPiExbexOfDRJqro0JoupcSGlVPNKsa2yH7M9eNdoA4tSZoir6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2Eq6oiL; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2Eq6oiL"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so6822940a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Dec 2025 01:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764580886; x=1765185686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5mKIxMAzp6gEYAYWkXYhTxJx9bOYOxdUOEOtIPv4hJw=;
        b=K2Eq6oiLNCT503b5RK9bEZvsdBOXEBsXPyudsbuifqhkXuNk9FUQVT90Ex4zSBFI3P
         cdRndhss2flt3T0uZdm4xQTJcr8bsUIx2JQV0ss5ct6EbU+yAa3+XBNooOw21Dm2i5OW
         pnuTiyivRygpgHjZJ3a65/7MOyANI8L1o2COPRqEaEsfY6rkeYVlZ7ax3l+OQEYBIb1G
         V+ZWzphAE+1u8XCqTkPiV7/UqkuNfnwAjoGmoqCgXqqN3n1tP1EAnN7+Rp8iCaDqMs0o
         eL3y2CI4fLpsG57S0cFnD0BhxoJVluLhCTk4Sf5E/AuQpjUyLLsJwXgzdkbSWqtbtu16
         J4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764580886; x=1765185686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5mKIxMAzp6gEYAYWkXYhTxJx9bOYOxdUOEOtIPv4hJw=;
        b=Li51+frHQKmLnq2dmvC39xHpjLvbJYnmOzA6jbNx8kRDfslI1gDNQHnA2RNstPc9gE
         Ux0cPkAF5u0KOsqKQatimOCzhnAHy48FiXLuAUo8UstHatF6Y1mcKCBVVbuymIo5RpCe
         YMHvkzvuwnKnS8XH5LeoknHvWQUfunSO3SN8mapgxDBbbe6KASIBKzuLYQeg7AT2eLAA
         ZLRiFfR2OrsdypotVc6jpkhSgxdTAv/KcYbc25nMZyycw7CqRvnJZdK8GXXg/g8NrRCg
         8xXUL6BIWI+xLIpYLTJsxRbt8u0g+J3/fN1tEDrNfXkHI2+OGRfG/jaSjhF3uNIAS5jf
         gaiA==
X-Forwarded-Encrypted: i=1; AJvYcCXL4tDGxSD6UMjxFez+OR49cQnxwq62wajgVFl4AIPA1fhRDkNOwRyNz6w9pmHdTB+p0SG60WG7v/V0@vger.kernel.org
X-Gm-Message-State: AOJu0YwQMIXkuTliLF1JM4y96E00fUOqHZGHGdqEDL3E5FzbKxRcfCa4
	SBI9cFi/HzNSfQT5XK+qOoo+jOC9yMVZCokrVeRmzYswTxELn9deVmEI8huXC/RWw+YGS1HBnYe
	aW/e5U70e3fU1aqVWW9aXKeHk4ikNpa8=
X-Gm-Gg: ASbGncsNJidQSfZch7Ir4o/vOgYYx42BfzkWZ6Tr5pE8OyPjnrjWASKfaMDOz8SSGR4
	Oyz5kmVaQOeLJ+endYYQabMYc+t7SjG1AHzzlo+JdYwtWoZAlrJME37BxqxKOI9Ex/zIwA7IE4x
	ozSkFUMPyLnYelNfLQSosSt7diwmNakgcYDmVd8yOxmZkBFZ5yoEeDc+Vki8hDPJmXLjAqCf6lP
	IDXGSb/SVVOP46JOArIPdpKx+JIfBTVw6gOhtAcR2eYRruIguoKzzEKGGp5yiZF2VcUjyM5zA==
X-Google-Smtp-Source: AGHT+IE70kZm+oZAgOBbzYWL9CT7mr1pSq79v4J3gqi3BwtwYNRic00q0TGyPChM8l+mQijXetNIIHkFnCkCNIyI7is=
X-Received: by 2002:a05:6402:4313:b0:645:d3fe:8c57 with SMTP id
 4fb4d7f45d1cf-645d3fe8d77mr27494563a12.18.1764580885485; Mon, 01 Dec 2025
 01:21:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251118022655.126994-1-rajasimandalos@gmail.com>
 <CAFTVevWRXF8TCDQstp7r1uu8eZ21M4m1EPs3zXANPTDj8bh_ZQ@mail.gmail.com> <CANT5p=ohMvQ+0+YYCQrkSw7sPW24gs60TQzBoiAyfedO8GXgfQ@mail.gmail.com>
In-Reply-To: <CANT5p=ohMvQ+0+YYCQrkSw7sPW24gs60TQzBoiAyfedO8GXgfQ@mail.gmail.com>
From: RAJASI MANDAL <rajasimandalos@gmail.com>
Date: Mon, 1 Dec 2025 14:51:13 +0530
X-Gm-Features: AWmQ_blGa_JymJ6PVNWzO0n6Sj-NIa0Iy9yfWx7BOUMrEnUVdIDKilvxHRlj7Gs
Message-ID: <CAEY6_V2Rc_yBSTL3ozK1TJo-qM0HixeE5kgXiPuOS5g2MZAErg@mail.gmail.com>
Subject: Re: [PATCH] cifs: client: allow changing multichannel mount options
 on remount
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, sfrench@samba.org, 
	linux-cifs@vger.kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: multipart/mixed; boundary="000000000000db8acc0644e080a5"

--000000000000db8acc0644e080a5
Content-Type: multipart/alternative; boundary="000000000000db8aca0644e080a3"

--000000000000db8aca0644e080a3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sending a follow-up patch with corrected comment as pointed out by
Meetakshi. Attaching the new patch here for easy reference.

Regards,
Rajasi

On Mon, Nov 24, 2025 at 5:20=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com>
wrote:

> On Thu, Nov 20, 2025 at 11:40=E2=80=AFAM Meetakshi Setiya
> <meetakshisetiyaoss@gmail.com> wrote:
> >
> > Hi Rajasi,
> >
> > On Tue, Nov 18, 2025 at 7:59=E2=80=AFAM Rajasi Mandal <rajasimandalos@g=
mail.com>
> wrote:
> > >
> > > From: Rajasi Mandal <rajasimandal@microsoft.com>
> > >
> > > Previously, the client did not update a session's channel state when
> > > multichannel or max_channels mount options were changed via remount.
> > > This led to inconsistent behavior and prevented enabling or disabling
> > > multichannel support without a full unmount/remount cycle.
> > >
> > > Enable dynamic reconfiguration of multichannel and max_channels durin=
g
> > > remount by:
> > > - Introducing smb3_sync_ses_chan_max(), a centralized function for
> > >   channel updates which synchronizes the session's channels with the
> > >   updated configuration.
> > > - Replacing cifs_disable_secondary_channels() with
> > >   cifs_decrease_secondary_channels(), which accepts a from_reconfigur=
e
> > >   flag to support targeted cleanup during reconfiguration.
> > > - Updating remount logic to detect changes in multichannel or
> > >   max_channels and trigger appropriate session/channel updates.
> > >
> > > Current limitation:
> > > - The query_interfaces worker runs even when max_channels=3D1 so that
> > >   multichannel can be enabled later via remount without requiring an
> > >   unmount. This is a temporary approach and may be refined in the
> > >   future.
> > >
> > > Users can safely modify multichannel and max_channels on an existing
> > > mount. The client will correctly adjust the session's channel state t=
o
> > > match the new configuration, preserving durability where possible and
> > > avoiding unnecessary disconnects.
> > >
> > > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> > > Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> > > ---
> > >  fs/smb/client/cifsproto.h  |  4 ++-
> > >  fs/smb/client/connect.c    |  4 ++-
> > >  fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++++++++-
> > >  fs/smb/client/sess.c       | 32 +++++++++++++++-------
> > >  fs/smb/client/smb2pdu.c    | 55 ++++++++++++++++++++++++++++--------=
--
> > >  5 files changed, 119 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > > index 3528c365a452..a1fc9e1918bc 100644
> > > --- a/fs/smb/client/cifsproto.h
> > > +++ b/fs/smb/client/cifsproto.h
> > > @@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct
> shash_desc **sdesc);
> > >  void cifs_free_hash(struct shash_desc **sdesc);
> > >
> > >  int cifs_try_adding_channels(struct cifs_ses *ses);
> > > +int smb3_update_ses_channels(struct cifs_ses *ses, struct
> TCP_Server_Info *server,
> > > +                                       bool from_reconnect, bool
> from_reconfigure);
> > >  bool is_ses_using_iface(struct cifs_ses *ses, struct
> cifs_server_iface *iface);
> > >  void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
> > >
> > > @@ -674,7 +676,7 @@ bool
> > >  cifs_chan_is_iface_active(struct cifs_ses *ses,
> > >                           struct TCP_Server_Info *server);
> > >  void
> > > -cifs_disable_secondary_channels(struct cifs_ses *ses);
> > > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool
> from_reconfigure);
> > >  void
> > >  cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info
> *server);
> > >  int
> > > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > > index 55cb4b0cbd48..cebe4a5f54f2 100644
> > > --- a/fs/smb/client/connect.c
> > > +++ b/fs/smb/client/connect.c
> > > @@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
> struct smb3_fs_context *ctx)
> > >         ctx->prepath =3D NULL;
> > >
> > >  out:
> > > -       cifs_try_adding_channels(mnt_ctx.ses);
> > > +       smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
> > > +                                 false /* from_reconnect */,
> > > +                                 false /* from_reconfigure */);
> >
> > Shouldn't this be added to the non-dfs cifs_mount() too? I see that
> > even cifs_try_adding_channels() is not present in this function,
> > @Shyam Prasad is this expected?
>
> That's a good catch.
> I think this is a day-0 bug.
> I can see that the original change by Aurelien has the change only in
> DFS cifs_mount:
> commit d70e9fa55884760b6d6c293dbf20d8c52ce11fb7
> Author: Aurelien Aptel <aaptel@suse.com>
> Date:   Fri Sep 20 06:31:10 2019 +0200
>
>     cifs: try opening channels after mounting
>
> We should have a follow-up patch to fix this.
>
> >
> > >         rc =3D mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> > >         if (rc)
> > >                 goto error;
> > > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > > index 0f894d09157b..751ed6ebd458 100644
> > > --- a/fs/smb/client/fs_context.c
> > > +++ b/fs/smb/client/fs_context.c
> > > @@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,
> > >  static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
> > >                                             void *data);
> > >  static int smb3_get_tree(struct fs_context *fc);
> > > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned in=
t
> max_channels);
> > >  static int smb3_reconfigure(struct fs_context *fc);
> > >
> > >  static const struct fs_context_operations smb3_fs_context_ops =3D {
> > > @@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct
> cifs_sb_info *cifs_sb, struct cifs_se
> > >         return 0;
> > >  }
> > >
> > > +/*
> > > + * smb3_sync_ses_chan_max - Synchronize the session's maximum channe=
l
> count
> > > + * @ses: pointer to the old CIFS session structure
> > > + * @max_channels: new maximum number of channels to allow
> > > + *
> > > + * Updates the session's chan_max field to the new value, protecting
> the update
> > > + * with the session's channel lock. This should be called whenever
> the maximum
> > > + * allowed channels for a session changes (e.g., after a remount or
> reconfigure).
> > > + */
> > > +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned in=
t
> max_channels)
> > > +{
> > > +       spin_lock(&ses->chan_lock);
> > > +       ses->chan_max =3D max_channels;
> > > +       spin_unlock(&ses->chan_lock);
> > > +}
> > > +
> > >  static int smb3_reconfigure(struct fs_context *fc)
> > >  {
> > >         struct smb3_fs_context *ctx =3D smb3_fc2context(fc);
> > > @@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_context
> *fc)
> > >                 ses->password2 =3D new_password2;
> > >         }
> > >
> > > -       mutex_unlock(&ses->session_mutex);
> > > +       /*
> > > +        * If multichannel or max_channels has changed, update the
> session's channels accordingly.
> > > +        * This may add or remove channels to match the new
> configuration.
> > > +        */
> > > +       if ((ctx->multichannel !=3D cifs_sb->ctx->multichannel) ||
> > > +           (ctx->max_channels !=3D cifs_sb->ctx->max_channels)) {
> > > +
> > > +               /* Synchronize ses->chan_max with the new mount
> context */
> > > +               smb3_sync_ses_chan_max(ses, ctx->max_channels);
> > > +               /* Now update the session's channels to match the new
> configuration */
> > > +               /* Prevent concurrent scaling operations */
> > > +               spin_lock(&ses->ses_lock);
> > > +               if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
> > > +                       spin_unlock(&ses->ses_lock);
> > > +                       return -EINVAL;
> > > +               }
> > > +               ses->flags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;
> > > +               spin_unlock(&ses->ses_lock);
> > > +
> > > +               mutex_unlock(&ses->session_mutex);
> > > +
> > > +               rc =3D smb3_update_ses_channels(ses, ses->server,
> > > +                                              false /* from_reconnec=
t
> */,
> > > +                                              true /*
> from_reconfigure */);
> > > +
> > > +               /* Clear scaling flag after operation */
> > > +               spin_lock(&ses->ses_lock);
> > > +               ses->flags &=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;
> > > +               spin_unlock(&ses->ses_lock);
> > > +       } else {
> > > +               mutex_unlock(&ses->session_mutex);
> > > +       }
> > >
> > >         STEAL_STRING(cifs_sb, ctx, domainname);
> > >         STEAL_STRING(cifs_sb, ctx, nodename);
> > > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > > index ef3b498b0a02..cfd83986a84a 100644
> > > --- a/fs/smb/client/sess.c
> > > +++ b/fs/smb/client/sess.c
> > > @@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_ses
> *ses)
> > >  }
> > >
> > >  /*
> > > - * called when multichannel is disabled by the server.
> > > - * this always gets called from smb2_reconnect
> > > - * and cannot get called in parallel threads.
> > > + * cifs_decrease_secondary_channels - Reduce the number of active
> secondary channels
> > > + * @ses: pointer to the CIFS session structure
> > > + * @from_reconfigure: if true, only reduce to chan_max; if false,
> reduce to a single channel
> > > + *
> > > + * This function disables and cleans up extra secondary channels for
> a CIFS session.
> > > + * If called during reconfiguration, it reduces the channel count to
> the new maximum (chan_max).
> > > + * Otherwise, it disables all but the primary channel.
> > >   */
> > >  void
> > > -cifs_disable_secondary_channels(struct cifs_ses *ses)
> > > +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool
> from_reconfigure)
> > >  {
> > >         int i, chan_count;
> > >         struct TCP_Server_Info *server;
> > > @@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs_ses
> *ses)
> > >         if (chan_count =3D=3D 1)
> > >                 goto done;
> > >
> > > -       ses->chan_count =3D 1;
> > > -
> > > -       /* for all secondary channels reset the need reconnect bit */
> > > -       ses->chans_need_reconnect &=3D 1;
> > > +       /* Update the chan_count to the new maximum */
> > > +       if (from_reconfigure)
> > > +               ses->chan_count =3D ses->chan_max;
> > > +       else
> > > +               ses->chan_count =3D 1;
> > >
> > > -       for (i =3D 1; i < chan_count; i++) {
> > > +       for (i =3D ses->chan_max ; i < chan_count; i++) {
> > >                 iface =3D ses->chans[i].iface;
> > >                 server =3D ses->chans[i].server;
> > >
> > > @@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_ses
> *ses)
> > >                 spin_lock(&ses->chan_lock);
> > >         }
> > >
> > > +       /* For extra secondary channels, reset the need reconnect bit
> */
> > > +       if (ses->chan_count =3D=3D 1) {
> > > +               cifs_dbg(VFS, "server does not support multichannel
> anymore. Disable all other channels\n");
> > > +               ses->chans_need_reconnect &=3D 1;
> > > +       } else {
> > > +               cifs_dbg(VFS, "Disable extra secondary channels\n");
> > > +               ses->chans_need_reconnect &=3D ((1UL << ses->chan_max=
) -
> 1);
> > > +       }
> > > +
> > >  done:
> > >         spin_unlock(&ses->chan_lock);
> > >  }
> > > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > > index 8b4a4573e9c3..d051da46eaab 100644
> > > --- a/fs/smb/client/smb2pdu.c
> > > +++ b/fs/smb/client/smb2pdu.c
> > > @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16
> smb2_cmd,
> > >  static int
> > >  cifs_chan_skip_or_disable(struct cifs_ses *ses,
> > >                           struct TCP_Server_Info *server,
> > > -                         bool from_reconnect)
> > > +                         bool from_reconnect, bool from_reconfigure)
> > >  {
> > >         struct TCP_Server_Info *pserver;
> > >         unsigned int chan_index;
> > > @@ -206,14 +206,41 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
> > >                 return -EHOSTDOWN;
> > >         }
> > >
> > > -       cifs_server_dbg(VFS,
> > > -               "server does not support multichannel anymore. Disabl=
e
> all other channels\n");
> > > -       cifs_disable_secondary_channels(ses);
> > > -
> > > +       cifs_decrease_secondary_channels(ses, from_reconfigure);
> > >
> > >         return 0;
> > >  }
> > >
> > > +/*
> > > + * smb3_update_ses_channels - Synchronize session channels with new
> configuration
> > > + * @ses: pointer to the CIFS session structure
> > > + * @server: pointer to the TCP server info structure
> > > + * @from_reconnect: indicates if called from reconnect context
> > > + * @from_reconfigure: indicates if called from reconfigure context
> > > + *
> > > + * Returns 0 on success or error code on failure.
> > > + *
> > > + * Note: Outside of reconfigure, this function is only called from
> reconnect scenarios
> > > + * when the server stops advertising multichannel (MC) capability.
> > > + */
> >
> > I see that function is being called during mount too. Did you
> > mean cifs_decrease_secondary_channels()?
> >
> > > +int smb3_update_ses_channels(struct cifs_ses *ses, struct
> TCP_Server_Info *server,
> > > +                       bool from_reconnect, bool from_reconfigure)
> > > +{
> > > +       int rc =3D 0;
> > > +       /*
> > > +        * If the current channel count is less than the new chan_max=
,
> > > +        * try to add channels to reach the new maximum.
> > > +        * Otherwise, disable or skip extra channels to match the new
> configuration.
> > > +        */
> > > +       if (ses->chan_count < ses->chan_max)
> > > +               rc =3D cifs_try_adding_channels(ses);
> > > +       else
> > > +               rc =3D cifs_chan_skip_or_disable(ses, server,
> from_reconnect,
> > > +                                               from_reconfigure);
> > > +
> > > +       return rc;
> > > +}
> > > +
> > >  static int
> > >  smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
> > >                struct TCP_Server_Info *server, bool from_reconnect)
> > > @@ -355,8 +382,8 @@ smb2_reconnect(__le16 smb2_command, struct
> cifs_tcon *tcon,
> > >          */
> > >         if (ses->chan_count > 1 &&
> > >             !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) =
{
> > > -               rc =3D cifs_chan_skip_or_disable(ses, server,
> > > -                                              from_reconnect);
> > > +               rc =3D smb3_update_ses_channels(ses, server,
> > > +                                              from_reconnect, false
> /* from_reconfigure */);
> > >                 if (rc) {
> > >                         mutex_unlock(&ses->session_mutex);
> > >                         goto out;
> > > @@ -438,8 +465,9 @@ smb2_reconnect(__le16 smb2_command, struct
> cifs_tcon *tcon,
> > >                          * treat this as server not supporting
> multichannel
> > >                          */
> > >
> > > -                       rc =3D cifs_chan_skip_or_disable(ses, server,
> > > -                                                      from_reconnect=
);
> > > +                       rc =3D smb3_update_ses_channels(ses, server,
> > > +                                                      from_reconnect=
,
> > > +                                                      false /*
> from_reconfigure */);
> > >                         goto skip_add_channels;
> > >                 } else if (rc)
> > >                         cifs_tcon_dbg(FYI, "%s: failed to query serve=
r
> interfaces: %d\n",
> > > @@ -451,7 +479,8 @@ smb2_reconnect(__le16 smb2_command, struct
> cifs_tcon *tcon,
> > >                         if (ses->chan_count =3D=3D 1)
> > >                                 cifs_server_dbg(VFS, "supports
> multichannel now\n");
> > >
> > > -                       cifs_try_adding_channels(ses);
> > > +                       smb3_update_ses_channels(ses, server,
> from_reconnect,
> > > +                                                 false /*
> from_reconfigure */);
> > >                 }
> > >         } else {
> > >                 mutex_unlock(&ses->session_mutex);
> > > @@ -1105,8 +1134,7 @@ SMB2_negotiate(const unsigned int xid,
> > >                 req->SecurityMode =3D 0;
> > >
> > >         req->Capabilities =3D
> cpu_to_le32(server->vals->req_capabilities);
> > > -       if (ses->chan_max > 1)
> > > -               req->Capabilities |=3D
> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> > > +       req->Capabilities |=3D
> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> > >
> > >         /* ClientGUID must be zero for SMB2.02 dialect */
> > >         if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > > @@ -1312,8 +1340,7 @@ int smb3_validate_negotiate(const unsigned int
> xid, struct cifs_tcon *tcon)
> > >
> > >         pneg_inbuf->Capabilities =3D
> > >                         cpu_to_le32(server->vals->req_capabilities);
> > > -       if (tcon->ses->chan_max > 1)
> > > -               pneg_inbuf->Capabilities |=3D
> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> > > +       pneg_inbuf->Capabilities |=3D
> cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
> > >
> > >         memcpy(pneg_inbuf->Guid, server->client_guid,
> > >                                         SMB2_CLIENT_GUID_SIZE);
> > > --
> > > 2.43.0
> > >
> > >
> >
> > Thanks
> > Meetakshi
> >
>
>
> --
> Regards,
> Shyam
>

--000000000000db8aca0644e080a3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sending a follow-up patch with corrected comment=C2=A0as p=
ointed out by Meetakshi. Attaching the new patch here for easy reference.<b=
r><br><div>Regards,<br>Rajasi</div></div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Nov 24, 20=
25 at 5:20=E2=80=AFPM Shyam Prasad N &lt;<a href=3D"mailto:nspmangalore@gma=
il.com">nspmangalore@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On Thu, Nov 20, 2025 at 11:40=E2=80=AFAM Meet=
akshi Setiya<br>
&lt;<a href=3D"mailto:meetakshisetiyaoss@gmail.com" target=3D"_blank">meeta=
kshisetiyaoss@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi Rajasi,<br>
&gt;<br>
&gt; On Tue, Nov 18, 2025 at 7:59=E2=80=AFAM Rajasi Mandal &lt;<a href=3D"m=
ailto:rajasimandalos@gmail.com" target=3D"_blank">rajasimandalos@gmail.com<=
/a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; From: Rajasi Mandal &lt;<a href=3D"mailto:rajasimandal@microsoft.=
com" target=3D"_blank">rajasimandal@microsoft.com</a>&gt;<br>
&gt; &gt;<br>
&gt; &gt; Previously, the client did not update a session&#39;s channel sta=
te when<br>
&gt; &gt; multichannel or max_channels mount options were changed via remou=
nt.<br>
&gt; &gt; This led to inconsistent behavior and prevented enabling or disab=
ling<br>
&gt; &gt; multichannel support without a full unmount/remount cycle.<br>
&gt; &gt;<br>
&gt; &gt; Enable dynamic reconfiguration of multichannel and max_channels d=
uring<br>
&gt; &gt; remount by:<br>
&gt; &gt; - Introducing smb3_sync_ses_chan_max(), a centralized function fo=
r<br>
&gt; &gt;=C2=A0 =C2=A0channel updates which synchronizes the session&#39;s =
channels with the<br>
&gt; &gt;=C2=A0 =C2=A0updated configuration.<br>
&gt; &gt; - Replacing cifs_disable_secondary_channels() with<br>
&gt; &gt;=C2=A0 =C2=A0cifs_decrease_secondary_channels(), which accepts a f=
rom_reconfigure<br>
&gt; &gt;=C2=A0 =C2=A0flag to support targeted cleanup during reconfigurati=
on.<br>
&gt; &gt; - Updating remount logic to detect changes in multichannel or<br>
&gt; &gt;=C2=A0 =C2=A0max_channels and trigger appropriate session/channel =
updates.<br>
&gt; &gt;<br>
&gt; &gt; Current limitation:<br>
&gt; &gt; - The query_interfaces worker runs even when max_channels=3D1 so =
that<br>
&gt; &gt;=C2=A0 =C2=A0multichannel can be enabled later via remount without=
 requiring an<br>
&gt; &gt;=C2=A0 =C2=A0unmount. This is a temporary approach and may be refi=
ned in the<br>
&gt; &gt;=C2=A0 =C2=A0future.<br>
&gt; &gt;<br>
&gt; &gt; Users can safely modify multichannel and max_channels on an exist=
ing<br>
&gt; &gt; mount. The client will correctly adjust the session&#39;s channel=
 state to<br>
&gt; &gt; match the new configuration, preserving durability where possible=
 and<br>
&gt; &gt; avoiding unnecessary disconnects.<br>
&gt; &gt;<br>
&gt; &gt; Reviewed-by: Shyam Prasad N &lt;<a href=3D"mailto:sprasad@microso=
ft.com" target=3D"_blank">sprasad@microsoft.com</a>&gt;<br>
&gt; &gt; Signed-off-by: Rajasi Mandal &lt;<a href=3D"mailto:rajasimandal@m=
icrosoft.com" target=3D"_blank">rajasimandal@microsoft.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 fs/smb/client/cifsproto.h=C2=A0 |=C2=A0 4 ++-<br>
&gt; &gt;=C2=A0 fs/smb/client/connect.c=C2=A0 =C2=A0 |=C2=A0 4 ++-<br>
&gt; &gt;=C2=A0 fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++=
++++++-<br>
&gt; &gt;=C2=A0 fs/smb/client/sess.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 32 +++++++=
++++++++-------<br>
&gt; &gt;=C2=A0 fs/smb/client/smb2pdu.c=C2=A0 =C2=A0 | 55 +++++++++++++++++=
+++++++++++----------<br>
&gt; &gt;=C2=A0 5 files changed, 119 insertions(+), 26 deletions(-)<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.=
h<br>
&gt; &gt; index 3528c365a452..a1fc9e1918bc 100644<br>
&gt; &gt; --- a/fs/smb/client/cifsproto.h<br>
&gt; &gt; +++ b/fs/smb/client/cifsproto.h<br>
&gt; &gt; @@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct =
shash_desc **sdesc);<br>
&gt; &gt;=C2=A0 void cifs_free_hash(struct shash_desc **sdesc);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 int cifs_try_adding_channels(struct cifs_ses *ses);<br>
&gt; &gt; +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Se=
rver_Info *server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0bool from_reconnect, bool from_reconfigure);<br>
&gt; &gt;=C2=A0 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_s=
erver_iface *iface);<br>
&gt; &gt;=C2=A0 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);<br>
&gt; &gt;<br>
&gt; &gt; @@ -674,7 +676,7 @@ bool<br>
&gt; &gt;=C2=A0 cifs_chan_is_iface_active(struct cifs_ses *ses,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *server);<br>
&gt; &gt;=C2=A0 void<br>
&gt; &gt; -cifs_disable_secondary_channels(struct cifs_ses *ses);<br>
&gt; &gt; +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from=
_reconfigure);<br>
&gt; &gt;=C2=A0 void<br>
&gt; &gt;=C2=A0 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Ser=
ver_Info *server);<br>
&gt; &gt;=C2=A0 int<br>
&gt; &gt; diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c<br=
>
&gt; &gt; index 55cb4b0cbd48..cebe4a5f54f2 100644<br>
&gt; &gt; --- a/fs/smb/client/connect.c<br>
&gt; &gt; +++ b/fs/smb/client/connect.c<br>
&gt; &gt; @@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb=
, struct smb3_fs_context *ctx)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ctx-&gt;prepath =3D NULL;<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 out:<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_try_adding_channels(mnt_ctx.ses)=
;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0smb3_update_ses_channels(mnt_ctx.ses,=
 mnt_ctx.server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0false /* from_reconn=
ect */,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0false /* from_reconf=
igure */);<br>
&gt;<br>
&gt; Shouldn&#39;t this be added to the non-dfs cifs_mount() too? I see tha=
t<br>
&gt; even cifs_try_adding_channels() is not present in this function,<br>
&gt; @Shyam Prasad is this expected?<br>
<br>
That&#39;s a good catch.<br>
I think this is a day-0 bug.<br>
I can see that the original change by Aurelien has the change only in<br>
DFS cifs_mount:<br>
commit d70e9fa55884760b6d6c293dbf20d8c52ce11fb7<br>
Author: Aurelien Aptel &lt;<a href=3D"mailto:aaptel@suse.com" target=3D"_bl=
ank">aaptel@suse.com</a>&gt;<br>
Date:=C2=A0 =C2=A0Fri Sep 20 06:31:10 2019 +0200<br>
<br>
=C2=A0 =C2=A0 cifs: try opening channels after mounting<br>
<br>
We should have a follow-up patch to fix this.<br>
<br>
&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D mount_setup_tlink(cifs_sb=
, mnt_ctx.ses, mnt_ctx.tcon);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (rc)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto=
 error;<br>
&gt; &gt; diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_contex=
t.c<br>
&gt; &gt; index 0f894d09157b..751ed6ebd458 100644<br>
&gt; &gt; --- a/fs/smb/client/fs_context.c<br>
&gt; &gt; +++ b/fs/smb/client/fs_context.c<br>
&gt; &gt; @@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct=
 fs_context *fc,<br>
&gt; &gt;=C2=A0 static int smb3_fs_context_parse_monolithic(struct fs_conte=
xt *fc,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0void *data);<br>
&gt; &gt;=C2=A0 static int smb3_get_tree(struct fs_context *fc);<br>
&gt; &gt; +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigne=
d int max_channels);<br>
&gt; &gt;=C2=A0 static int smb3_reconfigure(struct fs_context *fc);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 static const struct fs_context_operations smb3_fs_context_o=
ps =3D {<br>
&gt; &gt; @@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct=
 cifs_sb_info *cifs_sb, struct cifs_se<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; +/*<br>
&gt; &gt; + * smb3_sync_ses_chan_max - Synchronize the session&#39;s maximu=
m channel count<br>
&gt; &gt; + * @ses: pointer to the old CIFS session structure<br>
&gt; &gt; + * @max_channels: new maximum number of channels to allow<br>
&gt; &gt; + *<br>
&gt; &gt; + * Updates the session&#39;s chan_max field to the new value, pr=
otecting the update<br>
&gt; &gt; + * with the session&#39;s channel lock. This should be called wh=
enever the maximum<br>
&gt; &gt; + * allowed channels for a session changes (e.g., after a remount=
 or reconfigure).<br>
&gt; &gt; + */<br>
&gt; &gt; +static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigne=
d int max_channels)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&amp;ses-&gt;chan_lock);<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;chan_max =3D max_channels;<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;ses-&gt;chan_lock);<=
br>
&gt; &gt; +}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 static int smb3_reconfigure(struct fs_context *fc)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct smb3_fs_context *ctx =3D =
smb3_fc2context(fc);<br>
&gt; &gt; @@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_cont=
ext *fc)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-=
&gt;password2 =3D new_password2;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;ses-&gt;session_mut=
ex);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If multichannel or max_channels ha=
s changed, update the session&#39;s channels accordingly.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * This may add or remove channels to=
 match the new configuration.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if ((ctx-&gt;multichannel !=3D cifs_s=
b-&gt;ctx-&gt;multichannel) ||<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(ctx-&gt;max_channels !=
=3D cifs_sb-&gt;ctx-&gt;max_channels)) {<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Synchr=
onize ses-&gt;chan_max with the new mount context */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0smb3_sync=
_ses_chan_max(ses, ctx-&gt;max_channels);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Now up=
date the session&#39;s channels to match the new configuration */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Preven=
t concurrent scaling operations */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock=
(&amp;ses-&gt;ses_lock);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&=
gt;flags &amp; CIFS_SES_FLAG_SCALE_CHANNELS) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;ses-&gt;ses_lock);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0return -EINVAL;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;f=
lags |=3D CIFS_SES_FLAG_SCALE_CHANNELS;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlo=
ck(&amp;ses-&gt;ses_lock);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unl=
ock(&amp;ses-&gt;session_mutex);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D sm=
b3_update_ses_channels(ses, ses-&gt;server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 false /* from_reconnect */,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 true /* from_reconfigure */);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Clear =
scaling flag after operation */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock=
(&amp;ses-&gt;ses_lock);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;f=
lags &amp;=3D ~CIFS_SES_FLAG_SCALE_CHANNELS;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlo=
ck(&amp;ses-&gt;ses_lock);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_unl=
ock(&amp;ses-&gt;session_mutex);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0STEAL_STRING(cifs_sb, ctx, domai=
nname);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0STEAL_STRING(cifs_sb, ctx, noden=
ame);<br>
&gt; &gt; diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c<br>
&gt; &gt; index ef3b498b0a02..cfd83986a84a 100644<br>
&gt; &gt; --- a/fs/smb/client/sess.c<br>
&gt; &gt; +++ b/fs/smb/client/sess.c<br>
&gt; &gt; @@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_se=
s *ses)<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 /*<br>
&gt; &gt; - * called when multichannel is disabled by the server.<br>
&gt; &gt; - * this always gets called from smb2_reconnect<br>
&gt; &gt; - * and cannot get called in parallel threads.<br>
&gt; &gt; + * cifs_decrease_secondary_channels - Reduce the number of activ=
e secondary channels<br>
&gt; &gt; + * @ses: pointer to the CIFS session structure<br>
&gt; &gt; + * @from_reconfigure: if true, only reduce to chan_max; if false=
, reduce to a single channel<br>
&gt; &gt; + *<br>
&gt; &gt; + * This function disables and cleans up extra secondary channels=
 for a CIFS session.<br>
&gt; &gt; + * If called during reconfiguration, it reduces the channel coun=
t to the new maximum (chan_max).<br>
&gt; &gt; + * Otherwise, it disables all but the primary channel.<br>
&gt; &gt;=C2=A0 =C2=A0*/<br>
&gt; &gt;=C2=A0 void<br>
&gt; &gt; -cifs_disable_secondary_channels(struct cifs_ses *ses)<br>
&gt; &gt; +cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from=
_reconfigure)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int i, chan_count;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *server;<=
br>
&gt; &gt; @@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs=
_ses *ses)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (chan_count =3D=3D 1)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto=
 done;<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;chan_count =3D 1;<br>
&gt; &gt; -<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0/* for all secondary channels reset t=
he need reconnect bit */<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;chans_need_reconnect &amp;=3D=
 1;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Update the chan_count to the new m=
aximum */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (from_reconfigure)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;c=
han_count =3D ses-&gt;chan_max;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;c=
han_count =3D 1;<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 1; i &lt; chan_count; i++)=
 {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D ses-&gt;chan_max ; i &lt; =
chan_count; i++) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ifac=
e =3D ses-&gt;chans[i].iface;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0serv=
er =3D ses-&gt;chans[i].server;<br>
&gt; &gt;<br>
&gt; &gt; @@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_=
ses *ses)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin=
_lock(&amp;ses-&gt;chan_lock);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/* For extra secondary channels, rese=
t the need reconnect bit */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&gt;chan_count =3D=3D 1) {<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_dbg(=
VFS, &quot;server does not support multichannel anymore. Disable all other =
channels\n&quot;);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;c=
hans_need_reconnect &amp;=3D 1;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_dbg(=
VFS, &quot;Disable extra secondary channels\n&quot;);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ses-&gt;c=
hans_need_reconnect &amp;=3D ((1UL &lt;&lt; ses-&gt;chan_max) - 1);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 done:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&amp;ses-&gt;chan_lo=
ck);<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt; diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c<br=
>
&gt; &gt; index 8b4a4573e9c3..d051da46eaab 100644<br>
&gt; &gt; --- a/fs/smb/client/smb2pdu.c<br>
&gt; &gt; +++ b/fs/smb/client/smb2pdu.c<br>
&gt; &gt; @@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le=
16 smb2_cmd,<br>
&gt; &gt;=C2=A0 static int<br>
&gt; &gt;=C2=A0 cifs_chan_skip_or_disable(struct cifs_ses *ses,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *server,<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0bool from_reconnect)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0bool from_reconnect, bool from_reconfigure)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *pserver;=
<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int chan_index;<br>
&gt; &gt; @@ -206,14 +206,41 @@ cifs_chan_skip_or_disable(struct cifs_ses *=
ses,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retu=
rn -EHOSTDOWN;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_server_dbg(VFS,<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;ser=
ver does not support multichannel anymore. Disable all other channels\n&quo=
t;);<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_disable_secondary_channels(ses);=
<br>
&gt; &gt; -<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_decrease_secondary_channels(ses,=
 from_reconfigure);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; +/*<br>
&gt; &gt; + * smb3_update_ses_channels - Synchronize session channels with =
new configuration<br>
&gt; &gt; + * @ses: pointer to the CIFS session structure<br>
&gt; &gt; + * @server: pointer to the TCP server info structure<br>
&gt; &gt; + * @from_reconnect: indicates if called from reconnect context<b=
r>
&gt; &gt; + * @from_reconfigure: indicates if called from reconfigure conte=
xt<br>
&gt; &gt; + *<br>
&gt; &gt; + * Returns 0 on success or error code on failure.<br>
&gt; &gt; + *<br>
&gt; &gt; + * Note: Outside of reconfigure, this function is only called fr=
om reconnect scenarios<br>
&gt; &gt; + * when the server stops advertising multichannel (MC) capabilit=
y.<br>
&gt; &gt; + */<br>
&gt;<br>
&gt; I see that function is being called during mount too. Did you<br>
&gt; mean cifs_decrease_secondary_channels()?<br>
&gt;<br>
&gt; &gt; +int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Se=
rver_Info *server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0bool from_reconnect, bool from_reconfigure)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0int rc =3D 0;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If the current channel count is le=
ss than the new chan_max,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * try to add channels to reach the n=
ew maximum.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Otherwise, disable or skip extra c=
hannels to match the new configuration.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&gt;chan_count &lt; ses-&gt;c=
han_max)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D ci=
fs_try_adding_channels(ses);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D ci=
fs_chan_skip_or_disable(ses, server, from_reconnect,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0from_reconfigure);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return rc;<br>
&gt; &gt; +}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 static int<br>
&gt; &gt;=C2=A0 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,=
<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct TCP=
_Server_Info *server, bool from_reconnect)<br>
&gt; &gt; @@ -355,8 +382,8 @@ smb2_reconnect(__le16 smb2_command, struct ci=
fs_tcon *tcon,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&gt;chan_count &gt; 1 &a=
mp;&amp;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!(server-&gt;capab=
ilities &amp; SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D ci=
fs_chan_skip_or_disable(ses, server,<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 from_reconnect);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D sm=
b3_update_ses_channels(ses, server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 from_reconnect, false /* from_reconfigure */);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (=
rc) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0mutex_unlock(&amp;ses-&gt;session_mutex);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; &gt; @@ -438,8 +465,9 @@ smb2_reconnect(__le16 smb2_command, struct ci=
fs_tcon *tcon,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 * treat this as server not supporting multichannel=
<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0rc =3D cifs_chan_skip_or_disable(ses, server,<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from_reconnect);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0rc =3D smb3_update_ses_channels(ses, server,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from_reconnect,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 false /* from_reconfig=
ure */);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0goto skip_add_channels;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} el=
se if (rc)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0cifs_tcon_dbg(FYI, &quot;%s: failed to query server=
 interfaces: %d\n&quot;,<br>
&gt; &gt; @@ -451,7 +479,8 @@ smb2_reconnect(__le16 smb2_command, struct ci=
fs_tcon *tcon,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&gt;chan_count =3D=3D 1)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_server_dbg(VFS, &q=
uot;supports multichannel now\n&quot;);<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0cifs_try_adding_channels(ses);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0smb3_update_ses_channels(ses, server, from_reconnect,<b=
r>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0false /* from_reconfigure */);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br=
>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mute=
x_unlock(&amp;ses-&gt;session_mutex);<br>
&gt; &gt; @@ -1105,8 +1134,7 @@ SMB2_negotiate(const unsigned int xid,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req-=
&gt;SecurityMode =3D 0;<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;Capabilities =3D cpu_to_=
le32(server-&gt;vals-&gt;req_capabilities);<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ses-&gt;chan_max &gt; 1)<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;C=
apabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;Capabilities |=3D cpu_to_le32=
(SMB2_GLOBAL_CAP_MULTI_CHANNEL);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* ClientGUID must be zero for S=
MB2.02 dialect */<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (server-&gt;vals-&gt;protocol=
_id =3D=3D SMB20_PROT_ID)<br>
&gt; &gt; @@ -1312,8 +1340,7 @@ int smb3_validate_negotiate(const unsigned =
int xid, struct cifs_tcon *tcon)<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pneg_inbuf-&gt;Capabilities =3D<=
br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0cpu_to_le32(server-&gt;vals-&gt;req_capabilities);<=
br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tcon-&gt;ses-&gt;chan_max &gt; 1)=
<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pneg_inbu=
f-&gt;Capabilities |=3D cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0pneg_inbuf-&gt;Capabilities |=3D cpu_=
to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(pneg_inbuf-&gt;Guid, serv=
er-&gt;client_guid,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0SMB2_CLIENT_GUID_SIZE);<br>
&gt; &gt; --<br>
&gt; &gt; 2.43.0<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt;<br>
&gt; Thanks<br>
&gt; Meetakshi<br>
&gt;<br>
<br>
<br>
-- <br>
Regards,<br>
Shyam<br>
</blockquote></div>

--000000000000db8aca0644e080a3--
--000000000000db8acc0644e080a5
Content-Type: message/rfc822; 
	name="[PATCH] cifs_ client_ allow changing multichannel mount options on remount (1).eml"
Content-Disposition: attachment; 
	filename="[PATCH] cifs_ client_ allow changing multichannel mount options on remount (1).eml"
Content-ID: <f_mimxuw9g0>
X-Attachment-Id: f_mimxuw9g0

Return-Path: <rajasimandalos@gmail.com>
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be4fb434e8esm10898565a12.4.2025.11.30.22.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 22:26:04 -0800 (PST)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	samba-technical@lists.samba.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH] cifs: client: allow changing multichannel mount options on remount
Date: Mon,  1 Dec 2025 06:25:17 +0000
Message-ID: <20251201062517.1513683-1-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Previously, the client did not update a session's channel state when
multichannel or max_channels mount options were changed via remount.
This led to inconsistent behavior and prevented enabling or disabling
multichannel support without a full unmount/remount cycle.

Enable dynamic reconfiguration of multichannel and max_channels during
remount by:
- Introducing smb3_sync_ses_chan_max(), a centralized function for
  channel updates which synchronizes the session's channels with the
  updated configuration.
- Replacing cifs_disable_secondary_channels() with
  cifs_decrease_secondary_channels(), which accepts a from_reconfigure
  flag to support targeted cleanup during reconfiguration.
- Updating remount logic to detect changes in multichannel or
  max_channels and trigger appropriate session/channel updates.

Current limitation:
- The query_interfaces worker runs even when max_channels=1 so that
  multichannel can be enabled later via remount without requiring an
  unmount. This is a temporary approach and may be refined in the
  future.

Users can safely modify multichannel and max_channels on an existing
mount. The client will correctly adjust the session's channel state to
match the new configuration, preserving durability where possible and
avoiding unnecessary disconnects.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cifsproto.h  |  4 ++-
 fs/smb/client/connect.c    |  4 ++-
 fs/smb/client/fs_context.c | 50 +++++++++++++++++++++++++++++++++-
 fs/smb/client/sess.c       | 32 ++++++++++++++++------
 fs/smb/client/smb2pdu.c    | 56 ++++++++++++++++++++++++++++----------
 5 files changed, 120 insertions(+), 26 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 3528c365a452..a1fc9e1918bc 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -649,6 +649,8 @@ int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
 
 int cifs_try_adding_channels(struct cifs_ses *ses);
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+					bool from_reconnect, bool from_reconfigure);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
@@ -674,7 +676,7 @@ bool
 cifs_chan_is_iface_active(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server);
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses);
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure);
 void
 cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 2f94d93b95e9..6557b3546398 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3927,7 +3927,9 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 	ctx->prepath = NULL;
 
 out:
-	cifs_try_adding_channels(mnt_ctx.ses);
+	smb3_update_ses_channels(mnt_ctx.ses, mnt_ctx.server,
+				  false /* from_reconnect */,
+				  false /* from_reconfigure */);
 	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
 	if (rc)
 		goto error;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 2a0d8b87bd8e..46428181699e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -717,6 +717,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 					    void *data);
 static int smb3_get_tree(struct fs_context *fc);
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels);
 static int smb3_reconfigure(struct fs_context *fc);
 
 static const struct fs_context_operations smb3_fs_context_ops = {
@@ -1013,6 +1014,22 @@ int smb3_sync_session_ctx_passwords(struct cifs_sb_info *cifs_sb, struct cifs_se
 	return 0;
 }
 
+/*
+ * smb3_sync_ses_chan_max - Synchronize the session's maximum channel count
+ * @ses: pointer to the old CIFS session structure
+ * @max_channels: new maximum number of channels to allow
+ *
+ * Updates the session's chan_max field to the new value, protecting the update
+ * with the session's channel lock. This should be called whenever the maximum
+ * allowed channels for a session changes (e.g., after a remount or reconfigure).
+ */
+static void smb3_sync_ses_chan_max(struct cifs_ses *ses, unsigned int max_channels)
+{
+	spin_lock(&ses->chan_lock);
+	ses->chan_max = max_channels;
+	spin_unlock(&ses->chan_lock);
+}
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -1095,7 +1112,38 @@ static int smb3_reconfigure(struct fs_context *fc)
 		ses->password2 = new_password2;
 	}
 
-	mutex_unlock(&ses->session_mutex);
+	/*
+	 * If multichannel or max_channels has changed, update the session's channels accordingly.
+	 * This may add or remove channels to match the new configuration.
+	 */
+	if ((ctx->multichannel != cifs_sb->ctx->multichannel) ||
+	    (ctx->max_channels != cifs_sb->ctx->max_channels)) {
+
+		/* Synchronize ses->chan_max with the new mount context */
+		smb3_sync_ses_chan_max(ses, ctx->max_channels);
+		/* Now update the session's channels to match the new configuration */
+		/* Prevent concurrent scaling operations */
+		spin_lock(&ses->ses_lock);
+		if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+			spin_unlock(&ses->ses_lock);
+			return -EINVAL;
+		}
+		ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+
+		mutex_unlock(&ses->session_mutex);
+
+		rc = smb3_update_ses_channels(ses, ses->server,
+					       false /* from_reconnect */,
+					       true /* from_reconfigure */);
+
+		/* Clear scaling flag after operation */
+		spin_lock(&ses->ses_lock);
+		ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
+		spin_unlock(&ses->ses_lock);
+	} else {
+		mutex_unlock(&ses->session_mutex);
+	}
 
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index ef3b498b0a02..cfd83986a84a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -265,12 +265,16 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 }
 
 /*
- * called when multichannel is disabled by the server.
- * this always gets called from smb2_reconnect
- * and cannot get called in parallel threads.
+ * cifs_decrease_secondary_channels - Reduce the number of active secondary channels
+ * @ses: pointer to the CIFS session structure
+ * @from_reconfigure: if true, only reduce to chan_max; if false, reduce to a single channel
+ *
+ * This function disables and cleans up extra secondary channels for a CIFS session.
+ * If called during reconfiguration, it reduces the channel count to the new maximum (chan_max).
+ * Otherwise, it disables all but the primary channel.
  */
 void
-cifs_disable_secondary_channels(struct cifs_ses *ses)
+cifs_decrease_secondary_channels(struct cifs_ses *ses, bool from_reconfigure)
 {
 	int i, chan_count;
 	struct TCP_Server_Info *server;
@@ -281,12 +285,13 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 	if (chan_count == 1)
 		goto done;
 
-	ses->chan_count = 1;
-
-	/* for all secondary channels reset the need reconnect bit */
-	ses->chans_need_reconnect &= 1;
+	/* Update the chan_count to the new maximum */
+	if (from_reconfigure)
+		ses->chan_count = ses->chan_max;
+	else
+		ses->chan_count = 1;
 
-	for (i = 1; i < chan_count; i++) {
+	for (i = ses->chan_max ; i < chan_count; i++) {
 		iface = ses->chans[i].iface;
 		server = ses->chans[i].server;
 
@@ -318,6 +323,15 @@ cifs_disable_secondary_channels(struct cifs_ses *ses)
 		spin_lock(&ses->chan_lock);
 	}
 
+	/* For extra secondary channels, reset the need reconnect bit */
+	if (ses->chan_count == 1) {
+		cifs_dbg(VFS, "server does not support multichannel anymore. Disable all other channels\n");
+		ses->chans_need_reconnect &= 1;
+	} else {
+		cifs_dbg(VFS, "Disable extra secondary channels\n");
+		ses->chans_need_reconnect &= ((1UL << ses->chan_max) - 1);
+	}
+
 done:
 	spin_unlock(&ses->chan_lock);
 }
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 8b4a4573e9c3..37a3216b37e4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -168,7 +168,7 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 static int
 cifs_chan_skip_or_disable(struct cifs_ses *ses,
 			  struct TCP_Server_Info *server,
-			  bool from_reconnect)
+			  bool from_reconnect, bool from_reconfigure)
 {
 	struct TCP_Server_Info *pserver;
 	unsigned int chan_index;
@@ -206,14 +206,42 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
 		return -EHOSTDOWN;
 	}
 
-	cifs_server_dbg(VFS,
-		"server does not support multichannel anymore. Disable all other channels\n");
-	cifs_disable_secondary_channels(ses);
-
+	cifs_decrease_secondary_channels(ses, from_reconfigure);
 
 	return 0;
 }
 
+/*
+ * smb3_update_ses_channels - Synchronize session channels with new configuration
+ * @ses: pointer to the CIFS session structure
+ * @server: pointer to the TCP server info structure
+ * @from_reconnect: indicates if called from reconnect context
+ * @from_reconfigure: indicates if called from reconfigure context
+ *
+ * Returns 0 on success or error code on failure.
+ *
+ * Outside of reconfigure, this function is called from cifs_mount() during mount
+ * and from reconnect scenarios to adjust channel count when the
+ * server's multichannel support changes.
+ */
+int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *server,
+			bool from_reconnect, bool from_reconfigure)
+{
+	int rc = 0;
+	/*
+	 * If the current channel count is less than the new chan_max,
+	 * try to add channels to reach the new maximum.
+	 * Otherwise, disable or skip extra channels to match the new configuration.
+	 */
+	if (ses->chan_count < ses->chan_max)
+		rc = cifs_try_adding_channels(ses);
+	else
+		rc = cifs_chan_skip_or_disable(ses, server, from_reconnect,
+						from_reconfigure);
+
+	return rc;
+}
+
 static int
 smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
@@ -355,8 +383,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 */
 	if (ses->chan_count > 1 &&
 	    !(server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
-		rc = cifs_chan_skip_or_disable(ses, server,
-					       from_reconnect);
+		rc = smb3_update_ses_channels(ses, server,
+					       from_reconnect, false /* from_reconfigure */);
 		if (rc) {
 			mutex_unlock(&ses->session_mutex);
 			goto out;
@@ -438,8 +466,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			 * treat this as server not supporting multichannel
 			 */
 
-			rc = cifs_chan_skip_or_disable(ses, server,
-						       from_reconnect);
+			rc = smb3_update_ses_channels(ses, server,
+						       from_reconnect,
+						       false /* from_reconfigure */);
 			goto skip_add_channels;
 		} else if (rc)
 			cifs_tcon_dbg(FYI, "%s: failed to query server interfaces: %d\n",
@@ -451,7 +480,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			if (ses->chan_count == 1)
 				cifs_server_dbg(VFS, "supports multichannel now\n");
 
-			cifs_try_adding_channels(ses);
+			smb3_update_ses_channels(ses, server, from_reconnect,
+						  false /* from_reconfigure */);
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
@@ -1105,8 +1135,7 @@ SMB2_negotiate(const unsigned int xid,
 		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(server->vals->req_capabilities);
-	if (ses->chan_max > 1)
-		req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	req->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	/* ClientGUID must be zero for SMB2.02 dialect */
 	if (server->vals->protocol_id == SMB20_PROT_ID)
@@ -1312,8 +1341,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	pneg_inbuf->Capabilities =
 			cpu_to_le32(server->vals->req_capabilities);
-	if (tcon->ses->chan_max > 1)
-		pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
+	pneg_inbuf->Capabilities |= cpu_to_le32(SMB2_GLOBAL_CAP_MULTI_CHANNEL);
 
 	memcpy(pneg_inbuf->Guid, server->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
-- 
2.43.0


--000000000000db8acc0644e080a5--
