Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C9EC7EE29
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Jun 2023 19:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjFJTs6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 10 Jun 2023 15:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjFJTs6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 10 Jun 2023 15:48:58 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BC930ED
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:48:57 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b1a4250b07so33066071fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 10 Jun 2023 12:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686426535; x=1689018535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEJ3+4vry4wwUKJ2Ebt6Wa7IFspgaPgPW1O4mrIUTlU=;
        b=nh2fgUKgz1QxzSmkQIxcuuFVezv7UPPFlH6gn/xDJkHPfCBw6wit/VEegc0qX/ZkDy
         OnXlEfXL65RSShwHVFOnfl07FYQ6AWfE2OCvsAndM284EtP5CY2dLisyVwkTP9wjYFgv
         poiG+/yqesL6FtbXLNWj9kKA+uC17xdfcNtnQRvVfca9lwCUaLwITztocamBGTtd+Mls
         WlCuIs0YePUiPGswuJhIPb4+g6CSPnAatSIHUQBewTB93MmEzGX5GGrar4pZyLTMwmEj
         jZG7IdgeQdel1yJHr+hVqRvqDeS2jkB4szjF6gBh0WJPmBzkiiJCqCv9EomSUZ0rUIrE
         5z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686426535; x=1689018535;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TEJ3+4vry4wwUKJ2Ebt6Wa7IFspgaPgPW1O4mrIUTlU=;
        b=X8mWavxFApzMDwDye7QQN+58pkY/kAjtyo5+VLxDwCLLs/WaiVFJBSgTNxWVYPElwT
         Z09wUXx3U4DO8p7ElPBwYizYix0DMIA3Y3DYb1R471o5CI377OvYoQyD9u3ykaHz5hYu
         SpfTb/zDDr8mmMX5RnVefymC54qZU9gKUhcsSnJZuhxavNZKUup441w38sGlind8AcQQ
         Pp2cbT40SBRnp0p0c9uaZuecBnle9a9VcwbdurjrA5ctMt5+9KBxZxEQQz18vHsm2tqS
         jTnrU3rrpQ6G6HNtug4Xfgn6CmVEg7PJ3VnSzHcOv60iLcwwN5g1Mqg3R5eItVQut312
         o42A==
X-Gm-Message-State: AC+VfDxbZ7inoceUm0Bl9AwkwnJP1JQAF13IEcSPvuhoFfvP+PgqNiNl
        OIjm1WEsoBUMHSFg8nDwzCLwG4eFqXW+wFjSzEw=
X-Google-Smtp-Source: ACHHUZ420mg0dlTLrzLLSXmgawcB5wMhphXZUr59I3wqpSA88f/Ijafk+ERxGNwwhqlqrkDk7dyGar6igXrrF3Me5ew=
X-Received: by 2002:a2e:8097:0:b0:2b1:bb66:7b69 with SMTP id
 i23-20020a2e8097000000b002b1bb667b69mr821149ljg.32.1686426534987; Sat, 10 Jun
 2023 12:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-2-sprasad@microsoft.com>
In-Reply-To: <20230609174659.60327-2-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 10 Jun 2023 14:48:44 -0500
Message-ID: <CAH2r5ms6tuYjPCdxhrmaRdOQ6CXKA4_1RRNT9Q77xweW4bfeHg@mail.gmail.com>
Subject: Re: [PATCH 2/6] cifs: print all credit counters in DebugData
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, bharathsm.hsk@gmail.com,
        tom@talpey.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending additional testing

On Fri, Jun 9, 2023 at 12:47=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> Output of /proc/fs/cifs/DebugData shows only the per-connection
> counter for the number of credits of regular type. i.e. the
> credits reserved for echo and oplocks are not displayed.
>
> There have been situations recently where having this info
> would have been useful. This change prints the credit counters
> of all three types: regular, echo, oplocks.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 5034b862cec2..17c884724590 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -130,12 +130,14 @@ cifs_dump_channel(struct seq_file *m, int i, struct=
 cifs_chan *chan)
>         struct TCP_Server_Info *server =3D chan->server;
>
>         seq_printf(m, "\n\n\t\tChannel: %d ConnectionId: 0x%llx"
> -                  "\n\t\tNumber of credits: %d Dialect 0x%x"
> +                  "\n\t\tNumber of credits: %d,%d,%d Dialect 0x%x"
>                    "\n\t\tTCP status: %d Instance: %d"
>                    "\n\t\tLocal Users To Server: %d SecMode: 0x%x Req On =
Wire: %d"
>                    "\n\t\tIn Send: %d In MaxReq Wait: %d",
>                    i+1, server->conn_id,
>                    server->credits,
> +                  server->echo_credits,
> +                  server->oplock_credits,
>                    server->dialect,
>                    server->tcpStatus,
>                    server->reconnect_instance,
> @@ -350,8 +352,11 @@ static int cifs_debug_data_proc_show(struct seq_file=
 *m, void *v)
>                         atomic_read(&server->smbd_conn->mr_used_count));
>  skip_rdma:
>  #endif
> -               seq_printf(m, "\nNumber of credits: %d Dialect 0x%x",
> -                       server->credits,  server->dialect);
> +               seq_printf(m, "\nNumber of credits: %d,%d,%d Dialect 0x%x=
",
> +                       server->credits,
> +                       server->echo_credits,
> +                       server->oplock_credits,
> +                       server->dialect);
>                 if (server->compress_algorithm =3D=3D SMB3_COMPRESS_LZNT1=
)
>                         seq_printf(m, " COMPRESS_LZNT1");
>                 else if (server->compress_algorithm =3D=3D SMB3_COMPRESS_=
LZ77)
> --
> 2.34.1
>


--=20
Thanks,

Steve
