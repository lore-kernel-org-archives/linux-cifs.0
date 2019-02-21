Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FDDC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 01:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D242086A
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 01:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPkWO9zL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfBUBje (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 20:39:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:47056 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfBUBjd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 20:39:33 -0500
Received: by mail-lj1-f195.google.com with SMTP id v16so22509172ljg.13
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 17:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MfS2AWN2P1HP/n7JR9UAeqqpa4TIRDC3cHorqVuFoMw=;
        b=RPkWO9zLTCt3FUwtiymJd1xHovIcHEIxwN3j/+h0MFXQqXdcV9kUQEe+jjY7+XpRJV
         ki22I81EGbQynRIPl5LYdafum4ZiqInZmj4LPdDpJFFVOU0ulebscJzyueN5+t8mGLQ7
         u2IDETMz1tSpOPpz8HuyhBcsgvk/K2MFogK4+d5pajEKWzG8EScAXKdIBRR5mr9B8U4N
         tFy3Sro2CNHRNeTjdAAhel14Z3GxbJFnuqwEYCal6BU7lLdCqKvssMggKdHtOsJKYMqq
         ix4atB6Q5oGP+KgBn526Nw8qUwapQrcI3q7iZUTPnEkqDaby9g8IA8QK0K1+HvlLFQAT
         o79g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MfS2AWN2P1HP/n7JR9UAeqqpa4TIRDC3cHorqVuFoMw=;
        b=V2T+S+TFhfXnnmBHCBTExkvU+G+pAUvhFvglOJv+1Sxez0LDRRIbIahy0qsS+rpf1x
         hJqs/dbDcEgrcbY7g49gR+aRlin/EMuh2A9l4QAuap0QsPLnHuzavtjqXW9yigywhSiT
         ++W4AI8YmhCf8cTrMciMWQFWYB5/l1tiJ7LbQCd3QRqKlSniLGWDBOesszMGM7qtFgdL
         taQG3FpW1rmjC42coOI9OG1LPP8ERE1d88m81V2wK6mrQ8Jh42PbylYoGeUrGpnkWcU6
         tl7jugN2mqwt2Ci6iH/i8cIvSPnQWjo7xXIgyMwdq02CNbS97igLp6t6j8WFvT2YyFb9
         3SWQ==
X-Gm-Message-State: AHQUAubCZy4Qo52kFGfXtRSNLrI6oobWazy0QGsw2nxPmYPtOj1rMpKG
        hjt+66w+OdDekyOsLNdWeZ9DhNI0dEd88b00oA==
X-Google-Smtp-Source: AHgI3Ibv2ZlstGK+1wmdyf4rn0BeyoaCXmbnLdHnvTiG7kCEmqqfpcWov3xaCnUbS9Oj/VTpdz5SWaI8ttUoHjq6WUI=
X-Received: by 2002:a2e:124e:: with SMTP id t75mr23030621lje.23.1550713170619;
 Wed, 20 Feb 2019 17:39:30 -0800 (PST)
MIME-Version: 1.0
References: <20190220061145.28241-1-lsahlber@redhat.com> <20190220061145.28241-2-lsahlber@redhat.com>
In-Reply-To: <20190220061145.28241-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 20 Feb 2019 17:39:19 -0800
Message-ID: <CAKywueQEnaPfdCBRz4AJk8FAFDTfr5UC60wiM=7av3f9U050=A@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: change wait_for_free_request to take number of
 requests to wait for
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 19 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:12, Ronni=
e Sahlberg <lsahlber@redhat.com>:
>
> Change wait_for_free_request to allow specifying how many requests(credit=
s)
> to wait for.
> Pass 1 from all callsites.
>
> This should not change any behavior but will allow future callers to
> atomically wait for >1 requests.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |  4 ++--
>  fs/cifs/smb2ops.c   |  2 +-
>  fs/cifs/transport.c | 25 ++++++++++++++-----------
>  3 files changed, 17 insertions(+), 14 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 5bf463c2d9dc..1b3f62eee4d0 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -732,13 +732,13 @@ in_flight(struct TCP_Server_Info *server)
>  }
>
>  static inline bool
> -has_credits(struct TCP_Server_Info *server, int *credits)
> +has_credits(struct TCP_Server_Info *server, int *credits, int num_credit=
s)
>  {
>         int num;
>         spin_lock(&server->req_lock);
>         num =3D *credits;
>         spin_unlock(&server->req_lock);
> -       return num > 0;
> +       return num >=3D num_credits;
>  }
>
>  static inline void
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 080929a64c64..372a3563b79b 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -185,7 +185,7 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server,=
 unsigned int size,
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
>                         rc =3D wait_event_killable(server->request_q,
> -                                       has_credits(server, &server->cred=
its));
> +                                has_credits(server, &server->credits, 1)=
);
>                         cifs_num_waiters_dec(server);
>                         if (rc)
>                                 return rc;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d4f1224fb7cb..8ce5b6e787c6 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -478,7 +478,8 @@ smb_send(struct TCP_Server_Info *server, struct smb_h=
dr *smb_buffer,
>
>  static int
>  wait_for_free_credits(struct TCP_Server_Info *server, const int timeout,
> -                     int *credits, unsigned int *instance)
> +                     int num_credits, int *credits,
> +                     unsigned int *instance)
>  {
>         int rc;
>
> @@ -495,11 +496,11 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int timeout,
>         }
>
>         while (1) {
> -               if (*credits <=3D 0) {
> +               if (*credits < num_credits) {
>                         spin_unlock(&server->req_lock);
>                         cifs_num_waiters_inc(server);
>                         rc =3D wait_event_killable(server->request_q,
> -                                                has_credits(server, cred=
its));
> +                                has_credits(server, credits, num_credits=
));
>                         cifs_num_waiters_dec(server);
>                         if (rc)
>                                 return rc;
> @@ -517,8 +518,8 @@ wait_for_free_credits(struct TCP_Server_Info *server,=
 const int timeout,
>
>                         /* update # of requests on the wire to server */
>                         if (timeout !=3D CIFS_BLOCKING_OP) {
> -                               *credits -=3D 1;
> -                               server->in_flight++;
> +                               *credits -=3D num_credits;
> +                               server->in_flight +=3D num_credits;
>                                 *instance =3D server->reconnect_instance;
>                         }
>                         spin_unlock(&server->req_lock);
> @@ -530,7 +531,7 @@ wait_for_free_credits(struct TCP_Server_Info *server,=
 const int timeout,
>
>  static int
>  wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
> -                     const int optype, unsigned int *instance)
> +                     int num, const int optype, unsigned int *instance)

Waiting for more than one credit without a timeout is a source of
possibility to be stuck. We already have 'timeout' argument which
contains some part of flags passed to transport layer from PDU. We
might consider renaming 'optype' argument into flags and use 'timeout'
with its true meaning - timeout of the waiting for credits.

Once implemented, we can define some default period of time which we
can *afford* to wait for credits and then fall back to sequential code
if we timed out.

I also suggest to add another function wait_for_compound_credits and
make wait_for_free_request calls it - doesn't require changes to all
the places where the latter is being used.

>  {
>         int *val;
>
> @@ -538,7 +539,7 @@ wait_for_free_request(struct TCP_Server_Info *server,=
 const int timeout,
>         /* Since an echo is already inflight, no need to wait to send ano=
ther */
>         if (*val <=3D 0 && optype =3D=3D CIFS_ECHO_OP)
>                 return -EAGAIN;
> -       return wait_for_free_credits(server, timeout, val, instance);
> +       return wait_for_free_credits(server, timeout, num, val, instance)=
;
>  }
>
>  int
> @@ -646,7 +647,8 @@ cifs_call_async(struct TCP_Server_Info *server, struc=
t smb_rqst *rqst,
>         optype =3D flags & CIFS_OP_MASK;
>
>         if ((flags & CIFS_HAS_CREDITS) =3D=3D 0) {
> -               rc =3D wait_for_free_request(server, timeout, optype, &in=
stance);
> +               rc =3D wait_for_free_request(server, timeout, 1, optype,
> +                                          &instance);
>                 if (rc)
>                         return rc;
>                 credits.value =3D 1;
> @@ -923,7 +925,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>          * Ensure we obtain 1 credit per request in the compound chain.
>          */
>         for (i =3D 0; i < num_rqst; i++) {
> -               rc =3D wait_for_free_request(ses->server, timeout, optype=
,
> +               rc =3D wait_for_free_request(ses->server, timeout, 1, opt=
ype,
>                                            &instance);
>
>                 if (rc =3D=3D 0) {
> @@ -1212,7 +1214,8 @@ SendReceive(const unsigned int xid, struct cifs_ses=
 *ses,
>                 return -EIO;
>         }
>
> -       rc =3D wait_for_free_request(ses->server, timeout, 0, &credits.in=
stance);
> +       rc =3D wait_for_free_request(ses->server, timeout, 1, 0,
> +                                  &credits.instance);
>         if (rc)
>                 return rc;
>
> @@ -1354,7 +1357,7 @@ SendReceiveBlockingLock(const unsigned int xid, str=
uct cifs_tcon *tcon,
>                 return -EIO;
>         }
>
> -       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0,
> +       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 1, 0,
>                                    &instance);
>         if (rc)
>                 return rc;
> --
> 2.13.6
>

--
Best regards,
Pavel Shilovsky
