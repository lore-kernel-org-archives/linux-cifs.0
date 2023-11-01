Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61EA9C4167D
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 03:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjKADKJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234599AbjKADJj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 23:09:39 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2980E107
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:09:33 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-5079f9ec8d9so505312e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698808171; x=1699412971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=16oz2WmwBJCrnOhKwKvEyZ/OpErtzr4a7599xCyDO88=;
        b=BSywwY7YwXsw/ku190yMCaYEu1A0frlrsN0nR3OMPAyiUsPMQO8LjLJW9WMI90lcCG
         yHPXSR+mTzIGD+y9rFjyHVpnZSdCV93XhBxM3TUKWR12twxG6PC/BCNbAUlStm5+R/OY
         aSKwcbCt22F5yiwKRoe9in5GGKHVfBh1LGJ7lCYRA6+i/MFKrPs45nUEo0T6csPrKE0S
         PVDupNaC6yAOz5uCZY9cOJDROtz8CoHRGhvz0NiD3gmYDT8JFqzI1gfViVvrvsWA6dBn
         3ZhpcZ7YIBYZ4YTf0pGMNoAyivwyaBRmILlRcUHbpLyDqZ5ndRSGU7biO4SQjGz9IDH8
         FFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698808171; x=1699412971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16oz2WmwBJCrnOhKwKvEyZ/OpErtzr4a7599xCyDO88=;
        b=aYAusVZzV7aWwMUQyezjBmCr+okMGXS9k4yrIxqWno/N8rKSTKcwR2WpfEkC6ozQmp
         50QqUY/cRW9tPHzwq5dwY1zf7PmnLYpsC/O+GL9BhBP5N5Zf8EmVvp5qTBH4yJ4RYYWS
         HEGBdZR+oXfHdr/V5nHMNuOe1gmOYT+GsckjJULvJUlvd2ljQn6aOYeqmMup/tJtCHfF
         oqY/628Jufr/+sJ4zIqS/ZlK5NdXZsU+cSSfgFA4PyNfa1JOs80UBm8fCOaMnH7uGIYM
         bRm8VuwOlNR1YYgO87amq++bYM38G4rAnXE+AdORuJ16YMmbAE24IfY/wWzqM7mY/DGS
         LInA==
X-Gm-Message-State: AOJu0YxRGXa7xP98OgMgZZ8cfvfUYF0UBL54eveIjXRB2K2REHUHaEWU
        f1rrWFAt/KkLlRRV10IRTShOaKuIlydyDy5P2MY=
X-Google-Smtp-Source: AGHT+IF6d2v5D+16h6NmsEToR07r2ZW/xdpQKEoXO4SbItmyNV+VufNw4uYmpEB4qmPtkoC4ey6izyS+wmJapupKo/I=
X-Received: by 2002:ac2:4e0d:0:b0:4ff:839b:5355 with SMTP id
 e13-20020ac24e0d000000b004ff839b5355mr451561lfr.18.1698808171090; Tue, 31 Oct
 2023 20:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-6-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-6-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 22:09:19 -0500
Message-ID: <CAH2r5mv_yaHaGiKvy0FyAVKvUhH4LVb-rKduEHuSwi3tD+6fQg@mail.gmail.com>
Subject: Re: [PATCH 06/14] cifs: handle cases where a channel is closed
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch wouldn't merge due to a merge conflict here.  Am I missing
an earlier patch of yours before the series?

I have these in for-next:
d1ea8f36fa51 (HEAD -> for-next) cifs: force interface update before a
fresh session setup
1e27cedcaf4e (origin/for-next) cifs: do not reset chan_max if
multichannel is not supported at mount
e257df806ae0 cifs: display the endpoint IP details in DebugData
9d95130c9f78 cifs: reconnect helper should set reconnect for the right chan=
nel
7ac6866076bd smb: client: fix use-after-free in smb2_query_info_compound()
0779365fc10d smb: client: remove extra @chan_count check in __cifs_put_smb_=
ses()
4cf6e1101a25 cifs: add xid to query server interface call
52768695d36a cifs: print server capabilities in DebugData


--- fs/smb/client/connect.c
+++ fs/smb/client/connect.c
@@ -2037,7 +2041,9 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)

kref_put(&ses->chans[i].iface->refcount, release_iface);
                                ses->chans[i].iface =3D NULL;
                        }
-                       cifs_put_tcp_session(ses->chans[i].server, 0);
+
+                       if (ses->chans[i].server)
+                               cifs_put_tcp_session(ses->chans[i].server, =
0);
                        ses->chans[i].server =3D NULL;
                }
        }

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> So far, SMB multichannel could only scale up, but not
> scale down the number of channels. In this series of
> patch, we now allow the client to deal with the case
> of multichannel disabled on the server when the share
> is mounted. With that change, we now need the ability
> to scale down the channels.
>
> This change allows the client to deal with cases of
> missing channels more gracefully.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c    |  5 +++++
>  fs/smb/client/cifsglob.h      |  1 +
>  fs/smb/client/cifsproto.h     |  2 +-
>  fs/smb/client/connect.c       | 10 ++++++++--
>  fs/smb/client/sess.c          | 25 +++++++++++++++++++++----
>  fs/smb/client/smb2transport.c |  8 +++++++-
>  6 files changed, 43 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index a9dfecc397a8..9fca09539728 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -136,6 +136,11 @@ cifs_dump_channel(struct seq_file *m, int i, struct =
cifs_chan *chan)
>  {
>         struct TCP_Server_Info *server =3D chan->server;
>
> +       if (!server) {
> +               seq_printf(m, "\n\n\t\tChannel: %d DISABLED", i+1);
> +               return;
> +       }
> +
>         seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
>                    "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
>                    "\n\t\tTCP status: %d Instance: %d"
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 02082621d8e0..552ed441281a 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1050,6 +1050,7 @@ struct cifs_ses {
>         spinlock_t chan_lock;
>         /* =3D=3D=3D=3D=3D=3D=3D=3D=3D begin: protected by chan_lock =3D=
=3D=3D=3D=3D=3D=3D=3D */
>  #define CIFS_MAX_CHANNELS 16
> +#define CIFS_INVAL_CHAN_INDEX (-1)
>  #define CIFS_ALL_CHANNELS_SET(ses)     \
>         ((1UL << (ses)->chan_count) - 1)
>  #define CIFS_ALL_CHANS_GOOD(ses)               \
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 0c37eefa18a5..65c84b3d1a65 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -616,7 +616,7 @@ bool is_server_using_iface(struct TCP_Server_Info *se=
rver,
>  bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *=
iface);
>  void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
>
> -unsigned int
> +int
>  cifs_ses_get_chan_index(struct cifs_ses *ses,
>                         struct TCP_Server_Info *server);
>  void
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 97c9a32cff36..8393977e21ee 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -173,8 +173,12 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_In=
fo *server,
>         list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
>                 spin_lock(&ses->chan_lock);
>                 for (i =3D 0; i < ses->chan_count; i++) {
> +                       if (!ses->chans[i].server)
> +                               continue;
> +
>                         spin_lock(&ses->chans[i].server->srv_lock);
> -                       ses->chans[i].server->tcpStatus =3D CifsNeedRecon=
nect;
> +                       if (ses->chans[i].server->tcpStatus !=3D CifsExit=
ing)
> +                               ses->chans[i].server->tcpStatus =3D CifsN=
eedReconnect;
>                         spin_unlock(&ses->chans[i].server->srv_lock);
>                 }
>                 spin_unlock(&ses->chan_lock);
> @@ -2033,7 +2037,9 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
>                                 kref_put(&ses->chans[i].iface->refcount, =
release_iface);
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
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index c899b05c92f7..9d2228c2d7e5 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -69,7 +69,7 @@ bool is_ses_using_iface(struct cifs_ses *ses, struct ci=
fs_server_iface *iface)
>
>  /* channel helper functions. assumed that chan_lock is held by caller. *=
/
>
> -unsigned int
> +int
>  cifs_ses_get_chan_index(struct cifs_ses *ses,
>                         struct TCP_Server_Info *server)
>  {
> @@ -85,14 +85,16 @@ cifs_ses_get_chan_index(struct cifs_ses *ses,
>                 cifs_dbg(VFS, "unable to get chan index for server: 0x%ll=
x",
>                          server->conn_id);
>         WARN_ON(1);
> -       return 0;
> +       return CIFS_INVAL_CHAN_INDEX;
>  }
>
>  void
>  cifs_chan_set_in_reconnect(struct cifs_ses *ses,
>                              struct TCP_Server_Info *server)
>  {
> -       unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return;
>
>         ses->chans[chan_index].in_reconnect =3D true;
>  }
> @@ -102,6 +104,8 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
>                              struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return;
>
>         ses->chans[chan_index].in_reconnect =3D false;
>  }
> @@ -111,6 +115,8 @@ cifs_chan_in_reconnect(struct cifs_ses *ses,
>                           struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return true;    /* err on the safer side */
>
>         return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
>  }
> @@ -120,6 +126,8 @@ cifs_chan_set_need_reconnect(struct cifs_ses *ses,
>                              struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return;
>
>         set_bit(chan_index, &ses->chans_need_reconnect);
>         cifs_dbg(FYI, "Set reconnect bitmask for chan %u; now 0x%lx\n",
> @@ -131,6 +139,8 @@ cifs_chan_clear_need_reconnect(struct cifs_ses *ses,
>                                struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return;
>
>         clear_bit(chan_index, &ses->chans_need_reconnect);
>         cifs_dbg(FYI, "Cleared reconnect bitmask for chan %u; now 0x%lx\n=
",
> @@ -142,6 +152,8 @@ cifs_chan_needs_reconnect(struct cifs_ses *ses,
>                           struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return true;    /* err on the safer side */
>
>         return CIFS_CHAN_NEEDS_RECONNECT(ses, chan_index);
>  }
> @@ -151,6 +163,8 @@ cifs_chan_is_iface_active(struct cifs_ses *ses,
>                           struct TCP_Server_Info *server)
>  {
>         unsigned int chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return true;    /* err on the safer side */
>
>         return ses->chans[chan_index].iface &&
>                 ses->chans[chan_index].iface->is_active;
> @@ -269,7 +283,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>
>         spin_lock(&ses->chan_lock);
>         chan_index =3D cifs_ses_get_chan_index(ses, server);
> -       if (!chan_index) {
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX) {
>                 spin_unlock(&ses->chan_lock);
>                 return 0;
>         }
> @@ -319,6 +333,9 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct T=
CP_Server_Info *server)
>
>         spin_lock(&ses->chan_lock);
>         chan_index =3D cifs_ses_get_chan_index(ses, server);
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX)
> +               return 0;
> +
>         ses->chans[chan_index].iface =3D iface;
>
>         /* No iface is found. if secondary chan, drop connection */
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.=
c
> index 23c50ed7d4b5..84ea67301303 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -413,7 +413,13 @@ generate_smb3signingkey(struct cifs_ses *ses,
>                       ses->ses_status =3D=3D SES_GOOD);
>
>         chan_index =3D cifs_ses_get_chan_index(ses, server);
> -       /* TODO: introduce ref counting for channels when the can be free=
d */
> +       if (chan_index =3D=3D CIFS_INVAL_CHAN_INDEX) {
> +               spin_unlock(&ses->chan_lock);
> +               spin_unlock(&ses->ses_lock);
> +
> +               return -EINVAL;
> +       }
> +
>         spin_unlock(&ses->chan_lock);
>         spin_unlock(&ses->ses_lock);
>
> --
> 2.34.1
>


--=20
Thanks,

Steve
