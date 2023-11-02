Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2507DC4167B
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Nov 2023 12:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjKBM1L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Nov 2023 08:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjKBM1K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Nov 2023 08:27:10 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8825B112
        for <linux-cifs@vger.kernel.org>; Thu,  2 Nov 2023 05:27:07 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c5039d4e88so12826271fa.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Nov 2023 05:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698928026; x=1699532826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jQEZtM+3KKY7Q3Jp1ngPgnyOkeb6cayMob2X6ys/pXc=;
        b=ncFWA/x+w3CzAXgtNJerAdLwBM4c5oYwlsRye6ADxO0fxzRpBkq+3HoRWtkg/WtJl/
         HhDfS1ppscXgES75DsRVkyAq1cq0emOS9RbmlNY1tk9F6FEjB2BkmaR1CMaBk1P2QKwh
         JPt3mOSMHx8S6OmguU4zouB9Gn7wY6Dnc4lYZIbPc5Uqdbz7HeLSJtk56hXYA44Z2CKx
         maX3USf926YEhsBov6DkyYH5JgF1HP4fmkwOZRgap9srNSVUVdv/XUB29ceJn8W63Nv5
         lM+wP2OHh/rddhA7F3uqWBgS+2SmVbulcaRaUpO7HW7st17OKHW2IAITOX4STYDBz68Z
         Pseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698928026; x=1699532826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jQEZtM+3KKY7Q3Jp1ngPgnyOkeb6cayMob2X6ys/pXc=;
        b=Mj/hH+J7bap6SE0wqwPwyStUiiPQCA6vD9DQGYYbj2QlyJx2kQ5OAd1RPnXKbSLzK3
         llwTyD8/PTnKlbTDrxBioT/0HJqcqwMjczMLIBDx+iwnlVNp+hByQ2ifl8HCyHl2TfJA
         8bFDoTxUGBgJu96HC3gW94cWXn9Oz/k8be5xZneJeVUDx6VNkw4kvyQOAVxWsU9py5YB
         8cApxCmDoo8K1lJ2mOFJgDGounbltSFiLjnmg+RiUiHixTN3Es6vbicISDQsJJF7fSWd
         hU0ZbZdwy3Ja6/G18JtItHlb6qWZNMtauHfGtgAel0r+pvz/zowmA3bcCoVO1rrQAO71
         ONFA==
X-Gm-Message-State: AOJu0Yy3tnUBzrPql3JAB6ZOP5toFqFb/ReCpbszadVDtTwXR0Shkncf
        0z2Fzm80EDXKdzCaTi0YKkFYoyrZTgZNl8pMJ1M=
X-Google-Smtp-Source: AGHT+IFFFfg/gZRUPZilA8yPe9KNw6R2GKvP6g6i2vzUTLbRnlFpBC+xUi4UMFItHiqt99NDpfkdBxZHwNn3EFel0Mw=
X-Received: by 2002:a2e:b5b0:0:b0:2c5:2813:5534 with SMTP id
 f16-20020a2eb5b0000000b002c528135534mr12869327ljn.51.1698928025298; Thu, 02
 Nov 2023 05:27:05 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-6-sprasad@microsoft.com>
 <CAH2r5mv_yaHaGiKvy0FyAVKvUhH4LVb-rKduEHuSwi3tD+6fQg@mail.gmail.com>
In-Reply-To: <CAH2r5mv_yaHaGiKvy0FyAVKvUhH4LVb-rKduEHuSwi3tD+6fQg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 2 Nov 2023 17:56:52 +0530
Message-ID: <CANT5p=rfBOnGjdM-_EBcx1V7FsMZHFcoOic6dDs8zMb30mQkOA@mail.gmail.com>
Subject: Re: [PATCH 06/14] cifs: handle cases where a channel is closed
To:     Steve French <smfrench@gmail.com>
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 1, 2023 at 8:39=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> This patch wouldn't merge due to a merge conflict here.  Am I missing
> an earlier patch of yours before the series?
>

I think the conflict is with:
0779365fc10d smb: client: remove extra @chan_count check in __cifs_put_smb_=
ses()

Let me resolve the conflict and give you an updated patch.

> I have these in for-next:
> d1ea8f36fa51 (HEAD -> for-next) cifs: force interface update before a
> fresh session setup
> 1e27cedcaf4e (origin/for-next) cifs: do not reset chan_max if
> multichannel is not supported at mount
> e257df806ae0 cifs: display the endpoint IP details in DebugData
> 9d95130c9f78 cifs: reconnect helper should set reconnect for the right ch=
annel
> 7ac6866076bd smb: client: fix use-after-free in smb2_query_info_compound(=
)
> 0779365fc10d smb: client: remove extra @chan_count check in __cifs_put_sm=
b_ses()
> 4cf6e1101a25 cifs: add xid to query server interface call
> 52768695d36a cifs: print server capabilities in DebugData
>
>
> --- fs/smb/client/connect.c
> +++ fs/smb/client/connect.c
> @@ -2037,7 +2041,9 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>
> kref_put(&ses->chans[i].iface->refcount, release_iface);
>                                 ses->chans[i].iface =3D NULL;
>                         }
> -                       cifs_put_tcp_session(ses->chans[i].server, 0);
> +
> +                       if (ses->chans[i].server)
> +                               cifs_put_tcp_session(ses->chans[i].server=
, 0);
>                         ses->chans[i].server =3D NULL;
>                 }
>         }
>
> On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
> >
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >
> > So far, SMB multichannel could only scale up, but not
> > scale down the number of channels. In this series of
> > patch, we now allow the client to deal with the case
> > of multichannel disabled on the server when the share
> > is mounted. With that change, we now need the ability
> > to scale down the channels.
> >
> > This change allows the client to deal with cases of
> > missing channels more gracefully.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifs_debug.c    |  5 +++++
> >  fs/smb/client/cifsglob.h      |  1 +
> >  fs/smb/client/cifsproto.h     |  2 +-
> >  fs/smb/client/connect.c       | 10 ++++++++--
> >  fs/smb/client/sess.c          | 25 +++++++++++++++++++++----
> >  fs/smb/client/smb2transport.c |  8 +++++++-
> >  6 files changed, 43 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> > index a9dfecc397a8..9fca09539728 100644
> > --- a/fs/smb/client/cifs_debug.c
> > +++ b/fs/smb/client/cifs_debug.c
> > @@ -136,6 +136,11 @@ cifs_dump_channel(struct seq_file *m, int i, struc=
t cifs_chan *chan)
> >  {
> >         struct TCP_Server_Info *server =3D chan->server;
> >
> > +       if (!server) {
> > +               seq_printf(m, "\n\n\t\tChannel: %d DISABLED", i+1);
> > +               return;
> > +       }
> > +
> >         seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
> >                    "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
> >                    "\n\t\tTCP status: %d Instance: %d"
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index 02082621d8e0..552ed441281a 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1050,6 +1050,7 @@ struct cifs_ses {
> >         spinlock_t chan_lock;
> >         /* =3D=3D=3D=3D=3D=3D=3D=3D=3D begin: protected by chan_lock =
=3D=3D=3D=3D=3D=3D=3D=3D */
> >  #define CIFS_MAX_CHANNELS 16
> > +#define CIFS_INVAL_CHAN_INDEX (-1)
> >  #define CIFS_ALL_CHANNELS_SET(ses)     \
> >         ((1UL << (ses)->chan_count) - 1)
> >  #define CIFS_ALL_CHANS_GOOD(ses)               \
> > diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> > index 0c37eefa18a5..65c84b3d1a65 100644
> > --- a/fs/smb/client/cifsproto.h
> > +++ b/fs/smb/client/cifsproto.h
> > @@ -616,7 +616,7 @@ bool is_server_using_iface(struct TCP_Server_Info *=
server,
> >  bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface=
 *iface);
> >  void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
> >
> > -unsigned int
> > +int
> >  cifs_ses_get_chan_index(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server);
> >  void
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 97c9a32cff36..8393977e21ee 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -173,8 +173,12 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_=
Info *server,
> >         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) =
{
> >                 spin_lock(&ses->chan_lock);
> >                 for (i =3D 0; i < ses->chan_count; i++) {
> > +                       if (!ses->chans[i].server)
> > +                               continue;
> > +
> >                         spin_lock(&ses->chans[i].server->srv_lock);
> > -                       ses->chans[i].server->tcpStatus =3D CifsNeedRec=
onnect;
> > +                       if (ses->chans[i].server->tcpStatus !=3D CifsEx=
iting)
> > +                               ses->chans[i].server->tcpStatus =3D Cif=
sNeedReconnect;
> >                         spin_unlock(&ses->chans[i].server->srv_lock);
> >                 }
> >                 spin_unlock(&ses->chan_lock);
> > @@ -2033,7 +2037,9 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >                                 kref_put(&ses->chans[i].iface->refcount=
, release_iface);
> >                                 ses->chans[i].iface =3D NULL;
> >                         }
> > -                       cifs_put_tcp_session(ses->chans[i].server, 0);
> > +
> > +                       if (ses->chans[i].server)
> > +                               cifs_put_tcp_session(ses->chans[i].serv=
er, 0);
> >                         ses->chans[i].server =3D NULL;
> >                 }
> >         }
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index c899b05c92f7..9d2228c2d7e5 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -69,7 +69,7 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct =
cifs_server_iface *iface)
> >
> >  /* channel helper functions. assumed that chan_lock is held by caller.=
 */
> >
> > -unsigned int
> > +int
> >  cifs_ses_get_chan_index(struct cifs_ses *ses,
> >                         struct TCP_Server_Info *server)
> >  {
> > @@ -85,14 +85,16 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
> >                 cifs_dbg(VFS, "unable to get chan index for server: 0x%=
llx",
> >                          server->conn_id);
> >         WARN_ON(1);
> > -       return 0;
> > +       return CIFS_INVAL_CHAN_INDEX;
> >  }
> >
> >  void
> >  cifs_chan_set_in_reconnect(struct cifs_ses *ses,
> >                              struct TCP_Server_Info *server)
> >  {
> > -       unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       int chan_index =3D cifs_ses_get_chan_index(ses, server);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return;
> >
> >         ses->chans[chan_index].in_reconnect =3D true;
> >  }
> > @@ -102,6 +104,8 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
> >                              struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return;
> >
> >         ses->chans[chan_index].in_reconnect =3D false;
> >  }
> > @@ -111,6 +115,8 @@ cifs_chan_in_reconnect(struct cifs_ses *ses,
> >                           struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return true;    /* err on the safer side */
> >
> >         return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
> >  }
> > @@ -120,6 +126,8 @@ cifs_chan_set_need_reconnect(struct cifs_ses *ses,
> >                              struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return;
> >
> >         set_bit(chan_index, &ses->chans_need_reconnect);
> >         cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
> > @@ -131,6 +139,8 @@ cifs_chan_clear_need_reconnect(struct cifs_ses *ses=
,
> >                                struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return;
> >
> >         clear_bit(chan_index, &ses->chans_need_reconnect);
> >         cifs_dbg(FYI, "Cleared reconnect bitmask for chan %u; now 0x%lx=
\n",
> > @@ -142,6 +152,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
> >                           struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return true;    /* err on the safer side */
> >
> >         return CIFS_CHAN_NEEDS_RECONNECT(ses, chan_index);
> >  }
> > @@ -151,6 +163,8 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
> >                           struct TCP_Server_Info *server)
> >  {
> >         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server=
);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return true;    /* err on the safer side */
> >
> >         return ses->chans[chan_index].iface &&
> >                 ses->chans[chan_index].iface->is_active;
> > @@ -269,7 +283,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct=
 TCP_Server_Info *server)
> >
> >         spin_lock(&ses->chan_lock);
> >         chan_index =3D cifs_ses_get_chan_index(ses, server);
> > -       if (!chan_index) {
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX) {
> >                 spin_unlock(&ses->chan_lock);
> >                 return 0;
> >         }
> > @@ -319,6 +333,9 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct=
 TCP_Server_Info *server)
> >
> >         spin_lock(&ses->chan_lock);
> >         chan_index =3D cifs_ses_get_chan_index(ses, server);
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> > +               return 0;
> > +
> >         ses->chans[chan_index].iface =3D iface;
> >
> >         /* No iface is found. if secondary chan, drop connection */
> > diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transpor=
t.c
> > index 23c50ed7d4b5..84ea67301303 100644
> > --- a/fs/smb/client/smb2transport.c
> > +++ b/fs/smb/client/smb2transport.c
> > @@ -413,7 +413,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
> >                       ses->ses_status =3D=3D SES_GOOD);
> >
> >         chan_index =3D cifs_ses_get_chan_index(ses, server);
> > -       /* TODO: introduce ref counting for channels when the can be fr=
eed */
> > +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX) {
> > +               spin_unlock(&ses->chan_lock);
> > +               spin_unlock(&ses->ses_lock);
> > +
> > +               return -EINVAL;
> > +       }
> > +
> >         spin_unlock(&ses->chan_lock);
> >         spin_unlock(&ses->ses_lock);
> >
> > --
> > 2.34.1
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
