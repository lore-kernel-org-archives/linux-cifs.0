Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE324EB64DC
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jul 2023 16:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbjGNQbO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jul 2023 12:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjGNQbO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Jul 2023 12:31:14 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ADC271F
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 09:31:12 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b74fa5e7d7so33188231fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 14 Jul 2023 09:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689352270; x=1691944270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hUTHuE3IDn+xOtk0qx5jh1+/BXQMnbfK1dOeYvlje3A=;
        b=OGDyK5NBYnM2c4dNLclXHfqbpz4qcpl1KMQ76j96OVXedwbfKiEd55frxmTllyMd5s
         iT+/UU/gJg2MWdgX62rlCFGpt047wYED0WbkkkvhWYhb010b89GzX0hkmXFOm96CwXwb
         uCi67YxUlj4iyK17Dq26LkGnA7XPWH0A8nCUc+ewrAcdo/gXivhiz+VOOz5MbNzYPgpP
         c6mnphp7k/Bt78TKRfHy2xqH3BauJHCrrd22XdhZz7tPLqrWXqLNrMJLhYhqQOSQvl4e
         h5BoUQmby1n1vfzvyjE9FTz9/jhlGxCpHZnE5ZcsvrQYoOnz2CpU1Wj8WKCKUIhvQqsw
         hS7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689352270; x=1691944270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hUTHuE3IDn+xOtk0qx5jh1+/BXQMnbfK1dOeYvlje3A=;
        b=ZRjOqdhe8OILQX5xgjjgPLUKmy9oANiO1ThjA0uGylcP3YEaP2Wt+ntIk2KwL+i4xK
         QR8MwiWX1+7P/bAN853hQp21LCG4jUOcaCOtZMZbxMlZdzd5HTQDrAT81xWXwxNLksO6
         +E4DMBJIXB7PBEA3DULAhw8CCjC5jpZWgVJ/LmWVU8Jcr9+1cRAPKZx4HZyE/zC3D0Db
         ZLXCgeevWD7DUoHPwEEt3Dkg3zfCAoDMZyFmJIUuEYtyQSP+g2VkTEuB3dmBJs5cVTcm
         ds98e2uk5cKQ9oPwFPY/i+AQlT7msx1N2Ewg9xUvoD72lpuys2xCwhD0Cv/pO0OjvDs6
         0lJQ==
X-Gm-Message-State: ABy/qLb52zy5fh0jcV5sTzTUamFHG6ai2YMdLH4V7+7ZYK807lFVA0J8
        FCsjWBC2i8NZQFSfEzlGxDmo/MtN9z89TGj7hLc=
X-Google-Smtp-Source: APBJJlEfCaic73rIALhw4ndY+Q7wIkO2PQQzzzqWHtO9t49w+P7C7ddr0cymtAWeptBKd+ejB3iQYETGlFVj44If1eE=
X-Received: by 2002:a2e:9455:0:b0:2b6:f009:921a with SMTP id
 o21-20020a2e9455000000b002b6f009921amr4365252ljh.13.1689352269979; Fri, 14
 Jul 2023 09:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230714085634.10808-1-sprasad@microsoft.com> <20230714085634.10808-2-sprasad@microsoft.com>
In-Reply-To: <20230714085634.10808-2-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 14 Jul 2023 11:30:58 -0500
Message-ID: <CAH2r5msDQMHw6s+2H5p3qEfGBGg0kkYLmbNJwfeo06WpGfuDXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: is_network_name_deleted should return a bool
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, bharathsm.hsk@gmail.com, pc@cjr.nz,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing (e.g.
http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/1/=
builds/72)

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
