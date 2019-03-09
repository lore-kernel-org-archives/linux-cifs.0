Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EBAC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB45E20851
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O+YCQdG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfCIA6s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:58:48 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42504 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfCIA6s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:58:48 -0500
Received: by mail-lj1-f196.google.com with SMTP id d14so18922663ljl.9
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7VpsTRPrZXm6n78VgkN+4IzE0bznX1oJz0MGqs2AdRs=;
        b=O+YCQdG4eDVKZe8T0pg9sRBYfG8I+fNWmnLtaUUQdiqAaffs0FOUNYvkvgUacgYT5M
         onPO5h1FaP2EApKEwBRbExaQln6/YNOASCm2D8A4L6k7SHdNMTuqLE63974TlTbhcpys
         MWbUi2bZJMHB5D4WssIGLcdKFXeSkY6UMhZhJq+hdiX52+XCBfkHVKz32zoEhMBrK1Z0
         BEhNzD1saT2UFqpGusk1etVU+DOsL2BQXFGU1o6Imk1q40y8WPCWwtYhI7haS/6bDgok
         BIPt2/fh/0QXV39TmAJlPsqosINw4szyO6EgSBkv3bwX0dYCaUGpJknJ9KVJfwcEQJVG
         UfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7VpsTRPrZXm6n78VgkN+4IzE0bznX1oJz0MGqs2AdRs=;
        b=FotE+1wJzWRdN3K6rxNC8sQf1zLCVdtkJ2RSmp/gI3FFBBDkLv5FIVKXsBUOUJQBtI
         dxqfVjrVPXjF5YYW89/P8nrz4HZz45WOqZ/dihMt8e1To8Su+nKBgS56bCoy/kj/tv7+
         SsTDXiU3WJZR0NbY2sS2l/3y60msYXqANyP8TVCJmG2bH1rUSy5HT9PL92w3OaMNUMm5
         mc1tS8xANDU8hs4MXhYYxsR11+B5JgQK1E8xFUgwT35PTQw7HG2x3ANbpUgC48YbyUlp
         PqBGq3U7Rd7RAXtKpxhCL/3KwL09SGWfJjTOorgEhDEk3cuQpAkTvKwPmqwlfSyVeLef
         HVNg==
X-Gm-Message-State: APjAAAUlQlnDyT+wXQcCLzZqMgy3OZEs68fkltceZM2S8hsioE9whqdS
        3TL/zKfOyP7T5KZk2rKlgYN1q35gW0CiEF5vRB0PDrg=
X-Google-Smtp-Source: APXvYqzOCiZb4mgJpLvy98yyJZO4s39FLRsYNgPd81YzdZY8RloWgL+NP6/rziTOk5nUWHbZjxxwayeRK6fOt/bNXMQ=
X-Received: by 2002:a2e:9b15:: with SMTP id u21mr10536140lji.82.1552093124961;
 Fri, 08 Mar 2019 16:58:44 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-6-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-6-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:58:33 -0800
Message-ID: <CAKywueRQwi1qxmtO3q9v_sCHB+tQxVY1uba9mi468-y9=18H_w@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 7 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:35, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
>
> A negative timeout is the same as the current behaviour, i.e. no timeout.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 40 ++++++++++++++++++++++++++++++----------
>  1 file changed, 30 insertions(+), 10 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f4ec9635dab2..62c58ce80123 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -478,11 +478,18 @@ smb_send(struct TCP_Server_Info *server, struct smb=
_hdr *smb_buffer,
>
>  static int
>  wait_for_free_credits(struct TCP_Server_Info *server, const int num_cred=
its,
> -                     const int flags, unsigned int *instance)
> +                     const int timeout, const int flags,
> +                     unsigned int *instance)
>  {
>         int rc;
>         int *credits;
>         int optype;
> +       long int t;
> +
> +       if (timeout < 0)
> +               t =3D MAX_JIFFY_OFFSET;
> +       else
> +               t =3D msecs_to_jiffies(timeout);
>
>         optype =3D flags & CIFS_OP_MASK;
>
> @@ -507,11 +514,16 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int num_credits,
>                 if (*credits < num_credits) {
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
> -                       rc =3D wait_event_killable(server->request_q,
> -                               has_credits(server, credits, num_credits)=
);
> +                       rc =3D wait_event_killable_timeout(server->reques=
t_q,
> +                               has_credits(server, credits, num_credits)=
, t);
>                         cifs_num_waiters_dec(server);
> -                       if (rc)
> -                               return rc;
> +                       if (!rc) {
> +                               cifs_dbg(VFS, "wait timed out after %d ms=
\n",
> +                                        timeout);
> +                               return -ENOTSUPP;
> +                       }
> +                       if (rc =3D=3D -ERESTARTSYS)
> +                               return -ERESTARTSYS;
>                         spin_lock(&server->req_lock);
>                 } else {
>                         if (server->tcpStatus =3D=3D CifsExiting) {
> @@ -537,12 +549,19 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int num_credits,
>                             *credits <=3D MAX_COMPOUND) {
>                                 spin_unlock(&server->req_lock);
>                                 cifs_num_waiters_inc(server);
> -                               rc =3D wait_event_killable(server->reques=
t_q,
> +                               rc =3D wait_event_killable_timeout(
> +                                       server->request_q,
>                                         has_credits(server, credits,
> -                                                   MAX_COMPOUND + 1));
> +                                                   MAX_COMPOUND + 1),
> +                                       t);
>                                 cifs_num_waiters_dec(server);
> -                               if (rc)
> -                                       return rc;
> +                               if (!rc) {
> +                                       cifs_dbg(VFS, "wait timed out aft=
er %d ms\n",
> +                                                timeout);
> +                                       return -ENOTSUPP;
> +                               }
> +                               if (rc =3D=3D -ERESTARTSYS)
> +                                       return -ERESTARTSYS;
>                                 spin_lock(&server->req_lock);
>                                 continue;
>                         }
> @@ -569,7 +588,8 @@ static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int flags,
>                       unsigned int *instance)
>  {
> -       return wait_for_free_credits(server, 1, flags, instance);
> +       return wait_for_free_credits(server, 1, -1, flags,
> +                                    instance);
>  }
>
>  int
> --
> 2.13.6
>

We may consider adding trace points for cases where we timed out.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
