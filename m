Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7819C64EC4
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 22:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjB1WQ2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 17:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjB1WQ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 17:16:26 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CE53609A
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:16:25 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z5so11930560ljc.8
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 14:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1l5OiusQlvPJy9NH2edfV6UyIGjqDkSzEjtlagnWV/Q=;
        b=iHN1P6X7mvf7iYkaxtghG9sCGOQdAz5j7I2rLDmk3rs8q0OMPLIFfOm146hkJ34lq7
         6shjW91WtyX+slhZpgEI9dDD/agmuuz+IK29KmscYSrB/P0ZSat98x5LSHQ6TkK1RyIs
         XCmZ5/IQDoWTveP1RFi4mIRfTwfmiO1xod1ou/NmL8F8S2aSxn95Oirk11kiemut6hmU
         cNJcASrX4g4imBxm2NnkMob/dbjnh2ZY6x7ksl1t+RBmWGIk+3geAU3qJJG1CZQaxI/M
         cge7iOG/x9zBxMkEFvEWNi0qhcgLav36DekIb/2Mt8v2rVpDp50AmMWbi1FDRqggkTZK
         EMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1l5OiusQlvPJy9NH2edfV6UyIGjqDkSzEjtlagnWV/Q=;
        b=nivmkTeajJ33QROjwJdvtUKBr2UKXDB8ssfyRotXtEUg5I2A2JwPYySUI9JKzvHZAt
         ery7n3GYTU3XQHDIwEAg/yIIiUvbzy3EKG2PjzsOEwo35tEEsDqzkORgy0eWZNS+aMjV
         APwnR5kdmNZ8/15ksJivG+Wm2saIMbv/42Ta98hw9weL30m2ftEhLQLq8MQi/7G1bhPq
         9zO5VGRYa8HjVIeZkmKwBwPtJyY8I7KpuZhhF/6zJQyhavKdW7kdsWrArb5ctrbWLI5C
         BToti18lb4aKj5DwgOBU6iQqVCArc1/vv8Gb1lW2VhUf4M5ZC7K0uvh+GpR8SMtbFk3d
         VIfw==
X-Gm-Message-State: AO0yUKWPV1USHuzFpb7hR3sgHbZzzr7reTMmjHQrFtJETv5COqio35Bz
        n1tShYHy9+MyQsY1QwMRFB7OMbo+VY97pFbtX3xj9dHD
X-Google-Smtp-Source: AK7set9fdgzulyVgClZPtyrIlwDGFrpKjcM4L4ZrWAUu61dCpy18v2BFP7C7wPhoBeNyNrjk5tW5+7akUfngWAlvuj4=
X-Received: by 2002:a2e:b8d2:0:b0:293:4862:5e31 with SMTP id
 s18-20020a2eb8d2000000b0029348625e31mr2163282ljp.5.1677622582978; Tue, 28 Feb
 2023 14:16:22 -0800 (PST)
MIME-Version: 1.0
References: <20230227135323.26712-1-pc@manguebit.com> <20230228220155.23394-1-pc@manguebit.com>
 <20230228220155.23394-2-pc@manguebit.com>
In-Reply-To: <20230228220155.23394-2-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 28 Feb 2023 16:16:11 -0600
Message-ID: <CAH2r5mso-anitA0n85+MgAX9G52SVF0NjJ+PLw7Y+1Q+OjOx0Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] cifs: prevent data race in cifs_reconnect_tcon()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated cifs-2.6.git for-next with these two patches

On Tue, Feb 28, 2023 at 4:02=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
> to waiting the server to be reconnected in cifs_reconnect_tcon().  It
> is set in cifs_tcp_ses_needs_reconnect() and protected by
> TCP_Server_Info::srv_lock.
>
> Create a new cifs_wait_for_server_reconnect() helper that can be used
> by both SMB2+ and CIFS reconnect code.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
> v1 -> v2: fixed double unlock pointed out by Steve
>
>  fs/cifs/cifsproto.h |  1 +
>  fs/cifs/cifssmb.c   | 43 ++----------------------
>  fs/cifs/misc.c      | 44 ++++++++++++++++++++++++
>  fs/cifs/smb2pdu.c   | 82 ++++++++++++---------------------------------
>  4 files changed, 69 insertions(+), 101 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 20a2f0f3f682..e2eff66eefab 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -694,5 +694,6 @@ static inline int cifs_create_options(struct cifs_sb_=
info *cifs_sb, int options)
>
>  struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
>  void cifs_put_tcon_super(struct super_block *sb);
> +int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool =
retry);
>
>  #endif                 /* _CIFSPROTO_H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index a24e4ddf8043..a43c78396dd8 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -72,7 +72,6 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_com=
mand)
>         struct cifs_ses *ses;
>         struct TCP_Server_Info *server;
>         struct nls_table *nls_codepage;
> -       int retries;
>
>         /*
>          * SMBs NegProt, SessSetup, uLogoff do not have tcon yet so check=
 for
> @@ -102,45 +101,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_=
command)
>         }
>         spin_unlock(&tcon->tc_lock);
>
> -       retries =3D server->nr_targets;
> -
> -       /*
> -        * Give demultiplex thread up to 10 seconds to each target availa=
ble for
> -        * reconnect -- should be greater than cifs socket timeout which =
is 7
> -        * seconds.
> -        */
> -       while (server->tcpStatus =3D=3D CifsNeedReconnect) {
> -               rc =3D wait_event_interruptible_timeout(server->response_=
q,
> -                                                     (server->tcpStatus =
!=3D CifsNeedReconnect),
> -                                                     10 * HZ);
> -               if (rc < 0) {
> -                       cifs_dbg(FYI, "%s: aborting reconnect due to a re=
ceived signal by the process\n",
> -                                __func__);
> -                       return -ERESTARTSYS;
> -               }
> -
> -               /* are we still trying to reconnect? */
> -               spin_lock(&server->srv_lock);
> -               if (server->tcpStatus !=3D CifsNeedReconnect) {
> -                       spin_unlock(&server->srv_lock);
> -                       break;
> -               }
> -               spin_unlock(&server->srv_lock);
> -
> -               if (retries && --retries)
> -                       continue;
> -
> -               /*
> -                * on "soft" mounts we wait once. Hard mounts keep
> -                * retrying until process is killed or server comes
> -                * back on-line
> -                */
> -               if (!tcon->retry) {
> -                       cifs_dbg(FYI, "gave up waiting on reconnect in sm=
b_init\n");
> -                       return -EHOSTDOWN;
> -               }
> -               retries =3D server->nr_targets;
> -       }
> +       rc =3D cifs_wait_for_server_reconnect(server, tcon->retry);
> +       if (rc)
> +               return rc;
>
>         spin_lock(&ses->chan_lock);
>         if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconn=
ect) {
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 0c6c1fc8dae9..a0d286ee723d 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1266,3 +1266,47 @@ int cifs_inval_name_dfs_link_error(const unsigned =
int xid,
>         return 0;
>  }
>  #endif
> +
> +int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool =
retry)
> +{
> +       int timeout =3D 10;
> +       int rc;
> +
> +       spin_lock(&server->srv_lock);
> +       if (server->tcpStatus !=3D CifsNeedReconnect) {
> +               spin_unlock(&server->srv_lock);
> +               return 0;
> +       }
> +       timeout *=3D server->nr_targets;
> +       spin_unlock(&server->srv_lock);
> +
> +       /*
> +        * Give demultiplex thread up to 10 seconds to each target availa=
ble for
> +        * reconnect -- should be greater than cifs socket timeout which =
is 7
> +        * seconds.
> +        *
> +        * On "soft" mounts we wait once. Hard mounts keep retrying until
> +        * process is killed or server comes back on-line.
> +        */
> +       do {
> +               rc =3D wait_event_interruptible_timeout(server->response_=
q,
> +                                                     (server->tcpStatus =
!=3D CifsNeedReconnect),
> +                                                     timeout * HZ);
> +               if (rc < 0) {
> +                       cifs_dbg(FYI, "%s: aborting reconnect due to rece=
ived signal\n",
> +                                __func__);
> +                       return -ERESTARTSYS;
> +               }
> +
> +               /* are we still trying to reconnect? */
> +               spin_lock(&server->srv_lock);
> +               if (server->tcpStatus !=3D CifsNeedReconnect) {
> +                       spin_unlock(&server->srv_lock);
> +                       return 0;
> +               }
> +               spin_unlock(&server->srv_lock);
> +       } while (retry);
> +
> +       cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
> +       return -EHOSTDOWN;
> +}
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index ca9d7110ddcb..0e53265e1462 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -139,66 +139,6 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2=
_cmd,
>         return;
>  }
>
> -static int wait_for_server_reconnect(struct TCP_Server_Info *server,
> -                                    __le16 smb2_command, bool retry)
> -{
> -       int timeout =3D 10;
> -       int rc;
> -
> -       spin_lock(&server->srv_lock);
> -       if (server->tcpStatus !=3D CifsNeedReconnect) {
> -               spin_unlock(&server->srv_lock);
> -               return 0;
> -       }
> -       timeout *=3D server->nr_targets;
> -       spin_unlock(&server->srv_lock);
> -
> -       /*
> -        * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
> -        * here since they are implicitly done when session drops.
> -        */
> -       switch (smb2_command) {
> -       /*
> -        * BB Should we keep oplock break and add flush to exceptions?
> -        */
> -       case SMB2_TREE_DISCONNECT:
> -       case SMB2_CANCEL:
> -       case SMB2_CLOSE:
> -       case SMB2_OPLOCK_BREAK:
> -               return -EAGAIN;
> -       }
> -
> -       /*
> -        * Give demultiplex thread up to 10 seconds to each target availa=
ble for
> -        * reconnect -- should be greater than cifs socket timeout which =
is 7
> -        * seconds.
> -        *
> -        * On "soft" mounts we wait once. Hard mounts keep retrying until
> -        * process is killed or server comes back on-line.
> -        */
> -       do {
> -               rc =3D wait_event_interruptible_timeout(server->response_=
q,
> -                                                     (server->tcpStatus =
!=3D CifsNeedReconnect),
> -                                                     timeout * HZ);
> -               if (rc < 0) {
> -                       cifs_dbg(FYI, "%s: aborting reconnect due to rece=
ived signal\n",
> -                                __func__);
> -                       return -ERESTARTSYS;
> -               }
> -
> -               /* are we still trying to reconnect? */
> -               spin_lock(&server->srv_lock);
> -               if (server->tcpStatus !=3D CifsNeedReconnect) {
> -                       spin_unlock(&server->srv_lock);
> -                       return 0;
> -               }
> -               spin_unlock(&server->srv_lock);
> -       } while (retry);
> -
> -       cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
> -       return -EHOSTDOWN;
> -}
> -
>  static int
>  smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>                struct TCP_Server_Info *server)
> @@ -243,7 +183,27 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon=
 *tcon,
>             (!tcon->ses->server) || !server)
>                 return -EIO;
>
> -       rc =3D wait_for_server_reconnect(server, smb2_command, tcon->retr=
y);
> +       spin_lock(&server->srv_lock);
> +       if (server->tcpStatus =3D=3D CifsNeedReconnect) {
> +               /*
> +                * Return to caller for TREE_DISCONNECT and LOGOFF and CL=
OSE
> +                * here since they are implicitly done when session drops=
.
> +                */
> +               switch (smb2_command) {
> +               /*
> +                * BB Should we keep oplock break and add flush to except=
ions?
> +                */
> +               case SMB2_TREE_DISCONNECT:
> +               case SMB2_CANCEL:
> +               case SMB2_CLOSE:
> +               case SMB2_OPLOCK_BREAK:
> +                       spin_unlock(&server->srv_lock);
> +                       return -EAGAIN;
> +               }
> +       }
> +       spin_unlock(&server->srv_lock);
> +
> +       rc =3D cifs_wait_for_server_reconnect(server, tcon->retry);
>         if (rc)
>                 return rc;
>
> --
> 2.39.2
>


--=20
Thanks,

Steve
