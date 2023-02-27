Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C8FC64ED6
	for <linux-cifs@archiver.kernel.org>; Mon, 27 Feb 2023 22:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjB0WnG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjB0Wmw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Feb 2023 17:42:52 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD42BECC
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 14:41:48 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id h9so8178602ljq.2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Feb 2023 14:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oaWDfcc29e7hIX3DqlYAVHM/dSt/l/ONmBjo0xUqyfE=;
        b=k/6kGvXNamvJ3uNK6gBKyuyS0czsU7bTthzFUDKDNR+VEN0HMry5Dchi1gSHXuAZh1
         VjUtdLUczjE97/p1Ar7c5S/cMU+tuncyGpJNp2IlpMIXmenrhG/kqAMvl9MLvMpgxAXC
         VmaMcX3JTdJVZZO5L5HSGMC3Lp5qR9sD8xneUxQhRUYjOGCNpciF6odA1fxPug1xoy2c
         x89BN/9RC6b9QHQoBSqEwRIYA8fGw34JVXtJt61Aps7Imot6ET6ldMtAPkyglk6IXcZ3
         i99SpasVWBb8n8xsRKqyCsYiKf+4oNU7T/nJZGkGR3c+3gr8RvjKLnurb6Jm/xCa4CF2
         zNuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oaWDfcc29e7hIX3DqlYAVHM/dSt/l/ONmBjo0xUqyfE=;
        b=mvwIKboJ9IC47FhOBz503TBEZc9SkAxOlw+UEJbmL6LXRoNwyAemd4Kiu9LM/kMIiM
         iTB2Oc1eiKfowtIU4gnPk6xq7n0iW/otjtauuh6yIkgb9Z5lbqsZRe92DZEOaa20o7G2
         6EpWE/b9oF/IcclC8xsOy1cHN90ejVj1mMkHwKgGDV2y8YR9KiQH/Ph4dMWeJJyBa1Fd
         Yp7EQMEcSYr8DPr+ybG/s/0smhuLw0qIuIZc2xV48xQC2x5k1ilIY1z0rFZSyj7Q7LlK
         Ug1mKaBVeS/yLiJfdP44BSPtvik+QshM28L/rRq7Ibu4JDbYADHMg+YY4Q9+FLoeTxmP
         J2ng==
X-Gm-Message-State: AO0yUKWJQRby/09oogeahO41bQ369RRw15Ai7eRxgs/zIhdbNk48JLOG
        3D1uPFEUh6fpriGqik3Nj+omvta/dpIOlqCI65UPlGaIyZY=
X-Google-Smtp-Source: AK7set+iSFjadvlKb1X+QSS8Sl2h9uAQk9y72H21x9Upf79EpPwfMsTrKwjHa2AbDakJj3IQdZ7UAzYExptAf5DtNCM=
X-Received: by 2002:a2e:b94d:0:b0:295:a64f:9d50 with SMTP id
 13-20020a2eb94d000000b00295a64f9d50mr106876ljs.5.1677537626074; Mon, 27 Feb
 2023 14:40:26 -0800 (PST)
MIME-Version: 1.0
References: <20230227135323.26712-1-pc@manguebit.com> <20230227135323.26712-2-pc@manguebit.com>
In-Reply-To: <20230227135323.26712-2-pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 27 Feb 2023 16:40:14 -0600
Message-ID: <CAH2r5mufi6BRa3tDdzpDNsLDsE2g8ApTTYgK4zF_wU9ExEc1EQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: prevent data race in cifs_reconnect_tcon()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

  CHECK   /home/smfrench/cifs-2.6/fs/cifs/smb2pdu.c
/home/smfrench/cifs-2.6/fs/cifs/smb2pdu.c:204:20: warning: context
imbalance in 'smb2_reconnect' - unexpected unlock


There is a double unlock here:

dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 186)
spin_lock(&server->srv_lock);
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 187)   if
(server->tcpStatus =3D=3D CifsNeedReconnect) {
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 188)
 spin_unlock(&server->srv_lock);
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 189)           /*
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 190)
  * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 191)
  * here since they are implicitly done when session drops.
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 192)            */
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 193)
 switch (smb2_command) {
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 194)           /*
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 195)
  * BB Should we keep oplock break and add flush to exceptions?
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 196)            */
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 197)
 case SMB2_TREE_DISCONNECT:
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 198)
 case SMB2_CANCEL:
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 199)
 case SMB2_CLOSE:
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 200)
 case SMB2_OPLOCK_BREAK:
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 201)
         return -EAGAIN;
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 202)           }
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 203)   }
dc9dc86eabc46 (Paulo Alcantara 2023-02-27 10:53:23 -0300 204)
spin_unlock(&server->srv_lock);

On Mon, Feb 27, 2023 at 7:53=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
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
> index 003b0a522fea..5cd7db817bee 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1265,3 +1265,47 @@ int cifs_inval_name_dfs_link_error(const unsigned =
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
> index ca9d7110ddcb..62c125e73b73 100644
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
> +               spin_unlock(&server->srv_lock);
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
