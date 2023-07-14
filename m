Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C3E0C0015E
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 15:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbjGNPh2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 11:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbjGNPhR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 11:37:17 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487313C16
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 08:37:11 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f95bf5c493so3536588e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 08:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689349029; x=1691941029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fu1o0qaKDW2jsQxPESxXPP11oWAExp0KUfk2k5WGyMQ=;
        b=Zugr/Nm8UH0WA4Jd0K9ERNXPoZp3vYLReAqrFnBsrr4qwgrGT715gJXzAGII4koPbP
         Ld2we9XGlSxyKehDv3jcJyvaEc/6/Zb/1iytoiHk2Q34q52X96+kqZo56aP82QeHMcgt
         utu7vegjnLHg711bVgHzcuW00PiCTcJJKuyUjxjYtYm/R7s9kpPVKPB4ArPHNGdjL23Z
         jbrOLFzYZxj9kAyXm3I2aEJt1Iqavf1HWuQ/rpRrcP4SY9ppypNo/vjONA8p3jE1Wtj0
         hfNz93R0dXAIXsWekKxAHRuoF/dw87Tcgk64wl7HOWzHBQhA2SojiE8Zd1+BCeYb1arn
         FN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689349029; x=1691941029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fu1o0qaKDW2jsQxPESxXPP11oWAExp0KUfk2k5WGyMQ=;
        b=HrnjT2IDVXoYBktz7AT09ABreqskAoVtvat7MmwwUiIqW3gMmy8+UcfMIcwnVZaw4O
         KChRYMMJxYl+ydcE9Msqr/tRKld34iJPnGeAH6mWsm/Q/9bzufJ8g0JQYTOd482dMBPK
         GP23viXXhXZuxM8/LwQQ/9Px0FKr8AuzokrTqpn+sK23AHlsGqktDnAeH4IrD37UAD8T
         tiEvtCRfFkyV8yjMNbMdWaVguyCGpDPKdbnmse7AO1qySHbt3jKhOjuXWogU+VcBJeQk
         PBszbkTH3HMI7UjMFsCmJVpcM/FEcykRczwp9Rq19valqSuwdEtO7jXTloPqY/GJ5OBy
         Wz4g==
X-Gm-Message-State: ABy/qLZg5KfTclJSDqwBRxroMa8hAqDSEFU4KDrpoyxtYfCOtJO0Kll5
        7DzxNKpjWpTIQ1BuHUK4yxkom9dfshQPckjbHIA=
X-Google-Smtp-Source: APBJJlHhfo/AW8fnTmToiW6JiGigHWXIZEw9R6XeLl49ss5Q5loTowe6ThVC5F5Fnbxxf4GX9bPp5qMlaXWb5fmYhuQ=
X-Received: by 2002:a2e:8082:0:b0:2b3:47b3:3c39 with SMTP id
 i2-20020a2e8082000000b002b347b33c39mr4396197ljg.23.1689349029155; Fri, 14 Jul
 2023 08:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230714085634.10808-1-sprasad@microsoft.com> <20230714085634.10808-2-sprasad@microsoft.com>
In-Reply-To: <20230714085634.10808-2-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jul 2023 10:36:58 -0500
Message-ID: <CAH2r5muDwakr_nXp+TbaSK2YB4wabJaskvJRWCSFczMCtxhRQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: is_network_name_deleted should return a bool
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, pc@cjr.nz,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

should we have a dynamic trace point for this event as well?

On Fri, Jul 14, 2023 at 3:56=E2=80=AFAM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> Currently, is_network_name_deleted and it's implementations
> do not return anything if the network name did get deleted.
> So the function doesn't fully achieve what it advertizes.
>
> Changed the function to return a bool instead. It will now
> return true if the error returned is STATUS_NETWORK_NAME_DELETED
> and the share (tree id) was found to be connected. It returns
> false otherwise.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h |  2 +-
>  fs/smb/client/connect.c  | 11 ++++++++---
>  fs/smb/client/smb2ops.c  |  8 +++++---
>  3 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index b212a4e16b39..bde9de6665a7 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -532,7 +532,7 @@ struct smb_version_operations {
>         /* Check for STATUS_IO_TIMEOUT */
>         bool (*is_status_io_timeout)(char *buf);
>         /* Check for STATUS_NETWORK_NAME_DELETED */
> -       void (*is_network_name_deleted)(char *buf, struct TCP_Server_Info=
 *srv);
> +       bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info=
 *srv);
>  };
>
>  struct smb_version_values {
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 87047bd38485..6756ce4ff641 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1233,9 +1233,14 @@ cifs_demultiplex_thread(void *p)
>                         if (mids[i] !=3D NULL) {
>                                 mids[i]->resp_buf_size =3D server->pdu_si=
ze;
>
> -                               if (bufs[i] && server->ops->is_network_na=
me_deleted)
> -                                       server->ops->is_network_name_dele=
ted(bufs[i],
> -                                                                       s=
erver);
> +                               if (bufs[i] !=3D NULL) {
> +                                       if (server->ops->is_network_name_=
deleted &&
> +                                           server->ops->is_network_name_=
deleted(bufs[i],
> +                                                                        =
        server)) {
> +                                               cifs_server_dbg(FYI,
> +                                                               "Share de=
leted. Reconnect needed");
> +                                       }
> +                               }
>
>                                 if (!mids[i]->multiRsp || mids[i]->multiE=
nd)
>                                         mids[i]->callback(mids[i]);
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 153b300621eb..d32477315abc 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -2391,7 +2391,7 @@ smb2_is_status_io_timeout(char *buf)
>                 return false;
>  }
>
> -static void
> +static bool
>  smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
>  {
>         struct smb2_hdr *shdr =3D (struct smb2_hdr *)buf;
> @@ -2400,7 +2400,7 @@ smb2_is_network_name_deleted(char *buf, struct TCP_=
Server_Info *server)
>         struct cifs_tcon *tcon;
>
>         if (shdr->Status !=3D STATUS_NETWORK_NAME_DELETED)
> -               return;
> +               return false;
>
>         /* If server is a channel, select the primary channel */
>         pserver =3D CIFS_SERVER_IS_CHAN(server) ? server->primary_server =
: server;
> @@ -2415,11 +2415,13 @@ smb2_is_network_name_deleted(char *buf, struct TC=
P_Server_Info *server)
>                                 spin_unlock(&cifs_tcp_ses_lock);
>                                 pr_warn_once("Server share %s deleted.\n"=
,
>                                              tcon->tree_name);
> -                               return;
> +                               return true;
>                         }
>                 }
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
> +
> +       return false;
>  }
>
>  static int
> --
> 2.34.1
>


--=20
Thanks,

Steve
