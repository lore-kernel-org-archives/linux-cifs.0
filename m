Return-Path: <SRS0=e7zQ=TO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6223C04AB4
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B661C2166E
	for <linux-cifs@archiver.kernel.org>; Tue, 14 May 2019 21:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKwbqJc6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfENVMK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 May 2019 17:12:10 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38422 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfENVMK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 May 2019 17:12:10 -0400
Received: by mail-lj1-f195.google.com with SMTP id 14so560136ljj.5;
        Tue, 14 May 2019 14:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5HK6LtklZKGH421gmcApL4yH8ev/jh7IW3djR5lopgw=;
        b=dKwbqJc6C6lhuaCVZTUW26OKn8zL9FapIRRRZ98ruAxPUzpFY65+LkXuSqYRAO/rMR
         wofjKbtpNBpZipTh5qnJ/eH+pZ47J+IyZF4t1oyjXEY95Jm6o1ldXtWmWM0c8wSvHi0E
         6b0O3DeL5GSFYUUSfs8Kb1142It4qw8DwUNvGhfouTYHQOfdBdVUbNV8e41+lV6yeSLn
         OQSSpRAQC8T1wh1LTw7puOP2vpAcIGu0B5KBMn6omhgAK/DnaXQcKgRYOewMvSZZRGsh
         p+CJj+UAshO4080ixCjUq9PkhcSi8xeUDT5IWyHASMRwyHx6ZXajyZeSqdtcqzc+iAUd
         gwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5HK6LtklZKGH421gmcApL4yH8ev/jh7IW3djR5lopgw=;
        b=TrBeDyYAXYaQBgz2JBoT+vxUnrIDk/wKo+NasqJqegu/VJKCNAOTVaspqOOfIUpLD4
         tukDwM5cFN6OQLwjmQYKFuwWWgF6sLsBFSYwUGbRX/Nd6pfla+0+jz4v8qUWvHuP4FJl
         vNKNBYoJs410ZRpXUaNtgXvhVas+1+hET0cOMnTyPemxkplqYeLdAKM+AdzeUYrx6ZkQ
         XxlS0X8zlGVBPZFoW0UszKKa4VqR2Y/vLoBQ11bQqQYOP8vSUTYJ5LlnVKiXANGV56Kl
         3jtFpHrGt9SE4FkNsm83ygQvLq0Q/dydMTY6U7RZNfVBibf4gaDGfeWJzQ4DhLkE93eW
         cZqA==
X-Gm-Message-State: APjAAAWjnCtEH6aHFjICJDi9mDD5ndmKVm94EWkBZ8gJXewuDz+R6cTq
        wDQxx69oihxEXlsqC44gmyKklf8x/1m7lLg+CA==
X-Google-Smtp-Source: APXvYqxkuip2D74Iaik0DhKwZgR5cPse/BklawSVOzA4jrvdNT6zJd147/ff+853912d6dH99v3+R082z4X0xe6qF1Y=
X-Received: by 2002:a2e:96da:: with SMTP id d26mr8743538ljj.9.1557868327733;
 Tue, 14 May 2019 14:12:07 -0700 (PDT)
MIME-Version: 1.0
References: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557806489-11272-1-git-send-email-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 14 May 2019 14:11:56 -0700
Message-ID: <CAKywueTP17C6khnDauXYOfs9CG35bvZq8pQeKzrMJvSBE=sPfg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs:smbd When reconnecting to server, call
 smbd_destroy() after all MIDs have been called
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 13 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 21:02, <longli@linu=
xonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> commit 214bab448476 ("cifs: Call MID callback before destroying transport=
")
> assumes that the MID callback should not take srv_mutex, this may not alw=
ays
> be true. SMB Direct requires the MID callback completed before calling
> transport so all pending memory registration can be freed. So restore the
> orignal calling sequence so TCP transport will use the same code, but mov=
ing
> smbd_destroy() after all MID has been called.
>
> fixes: 214bab448476 ("cifs: Call MID callback before destroying transport=
")
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/connect.c | 37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 084756cfdaee..0b3ac8b76d18 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -528,6 +528,21 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         /* do not want to be sending data on a socket we are freeing */
>         cifs_dbg(FYI, "%s: tearing down socket\n", __func__);
>         mutex_lock(&server->srv_mutex);
> +       if (server->ssocket) {
> +               cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
> +                        server->ssocket->state, server->ssocket->flags);
> +               kernel_sock_shutdown(server->ssocket, SHUT_WR);
> +               cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
> +                        server->ssocket->state, server->ssocket->flags);
> +               sock_release(server->ssocket);
> +               server->ssocket =3D NULL;
> +       }
> +       server->sequence_number =3D 0;
> +       server->session_estab =3D false;
> +       kfree(server->session_key.response);
> +       server->session_key.response =3D NULL;
> +       server->session_key.len =3D 0;
> +       server->lstrp =3D jiffies;
>
>         /* mark submitted MIDs for retry and issue callback */
>         INIT_LIST_HEAD(&retry_list);
> @@ -540,6 +555,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 list_move(&mid_entry->qhead, &retry_list);
>         }
>         spin_unlock(&GlobalMid_Lock);
> +       mutex_unlock(&server->srv_mutex);
>
>         cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
>         list_for_each_safe(tmp, tmp2, &retry_list) {
> @@ -548,24 +564,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 mid_entry->callback(mid_entry);
>         }
>
> -       if (server->ssocket) {
> -               cifs_dbg(FYI, "State: 0x%x Flags: 0x%lx\n",
> -                        server->ssocket->state, server->ssocket->flags);
> -               kernel_sock_shutdown(server->ssocket, SHUT_WR);
> -               cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n",
> -                        server->ssocket->state, server->ssocket->flags);
> -               sock_release(server->ssocket);
> -               server->ssocket =3D NULL;
> -       } else if (cifs_rdma_enabled(server))
> +       if (cifs_rdma_enabled(server)) {
> +               mutex_lock(&server->srv_mutex);
>                 smbd_destroy(server);
> -       server->sequence_number =3D 0;
> -       server->session_estab =3D false;
> -       kfree(server->session_key.response);
> -       server->session_key.response =3D NULL;
> -       server->session_key.len =3D 0;
> -       server->lstrp =3D jiffies;
> -
> -       mutex_unlock(&server->srv_mutex);
> +               mutex_unlock(&server->srv_mutex);
> +       }
>
>         do {
>                 try_to_freeze();
> --
> 2.17.1
>

Thanks for quickly fixing it!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
