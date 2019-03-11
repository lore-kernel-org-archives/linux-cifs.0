Return-Path: <SRS0=BRhE=RO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C28C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 17:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10D1220643
	for <linux-cifs@archiver.kernel.org>; Mon, 11 Mar 2019 17:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcfALYXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfCKRyb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Mar 2019 13:54:31 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45731 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbfCKRyb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Mar 2019 13:54:31 -0400
Received: by mail-lj1-f193.google.com with SMTP id d24so4878554ljc.12
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2019 10:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DkxBIGE1rPw2gZFMwL37HlEPX8LfJNvZapAxZtZ/804=;
        b=bcfALYXGkGMpeHeB8pikBB4D6i0V+hsBc9gEDArUHbOkh882PQ9CablntdEDc6pkMI
         JkAM5S+74t02Zwz7OzhixyyrykumO7IVsic+tHH/JWVttn6V6SDvykBCmS+GE8lWX/JM
         iEQ5HeginWI9gD4S54HrTIZtUDjLiaNebkX82atirJHTLsKoVkXgrNFzOA5d2d6NJEH5
         l37IRAaLiKGXj6skqe83keiGU0tFm0xyJ2WQ9lsL/fq4Arzzk5XP3qKs8VHfMLvvOIyX
         FT6sCFuR50ODtSw/ab2iSnc1ESInaxF1AyH7pyi4pV0XO50uFgyVpKytBcw49MrOnoJs
         m2NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DkxBIGE1rPw2gZFMwL37HlEPX8LfJNvZapAxZtZ/804=;
        b=LVOKT/4PzAILkCed3QMzBlNk1l7HqFjRqaPjsdLdqXrrJ45cmPe4rMKuZgpYdcCd7q
         5TFPHS2QGDqFWigLJyA/rneqv9E2p3TzMGbqwCQvX/mXhjZDDiT4xNJU+p8lGgWH8/Ab
         pnz6JxvN/ViDj9rMN+JCBDpgUQ8uemqxXG0ftGrwC7We/wlrzte9Q5geuJKwOVR26vXo
         i7icI6chYdNZtFGDwfBVgKbLbkEO6EKWhl4S1lOOnKeftehwXwpXnYZCTXbQ1fhyak1s
         Jp/KP4KSohlSBgVSyKajggIR64KWxwyRl9oQJ3NOpMscHTGycBz8o+Hzu1CohLj3zQk6
         gVmA==
X-Gm-Message-State: APjAAAVJyheqGesV1Mm2MbF/t/JXJefpPAAbl8eyY2D3h0qeiuL24veo
        odzwH09SRS+xvFZTlKnsP7OfxG6TG4wxk0ie8w==
X-Google-Smtp-Source: APXvYqxvPegLaGyMzl3EBK/S9R4kNAcZoE7ZCkj+SnfJe8dSaeAWFIINjzpRiWdTQUtEsre/Jue4k4g/tbTeJTHPUbw=
X-Received: by 2002:a2e:251:: with SMTP id 78mr17276574ljc.90.1552326868304;
 Mon, 11 Mar 2019 10:54:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190311021858.1504-1-lsahlber@redhat.com>
In-Reply-To: <20190311021858.1504-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 11 Mar 2019 10:54:16 -0700
Message-ID: <CAKywueTds6bYqYMTC_LpzfBRJ0sh6+r5kKZJk9EYMKF+3O7g2Q@mail.gmail.com>
Subject: Re: [PATCH 6/6] cifs: simplify how we handle credits in compond_send_recv()
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

=D0=B2=D1=81, 10 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 20:20, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> Since we can now wait for multiple requests atomically in
> wait_for_free_request() we can now greatly simplify the handling
> of the credits in this function.
>
> This fixes a potential deadlock where many concurrent compound requests
> could each have reserved 1 or 2 credits each but are all blocked
> waiting for the final credits they need to be able to issue the requests
> to the server.
>
> Set a default timeout of 60 seconds for compounded requests.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 110 ++++++++++++++++++----------------------------=
------
>  1 file changed, 38 insertions(+), 72 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 62c58ce80123..5539c5c8ed75 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -592,6 +592,31 @@ wait_for_free_request(struct TCP_Server_Info *server=
, const int flags,
>                                      instance);
>  }
>
> +static int
> +wait_for_compound_request(struct TCP_Server_Info *server, int num,
> +                         const int flags, unsigned int *instance)
> +{
> +       int *credits;
> +
> +       credits =3D server->ops->get_credits_field(server, flags & CIFS_O=
P_MASK);
> +
> +       spin_lock(&server->req_lock);
> +       if (*credits < num) {
> +               /*
> +                * Return immediately if not too many requests in flight =
since
> +                * we will likely be stuck on waiting for credits.
> +                */
> +               if (server->in_flight < num - *credits) {
> +                       spin_unlock(&server->req_lock);
> +                       return -ENOTSUPP;
> +               }
> +       }
> +       spin_unlock(&server->req_lock);
> +
> +       return wait_for_free_credits(server, num, 60000, flags,
> +                                    instance);
> +}
> +
>  int
>  cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
>                       unsigned int *num, struct cifs_credits *credits)
> @@ -920,7 +945,6 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>                 { .value =3D 0, .instance =3D 0 }
>         };
>         unsigned int instance;
> -       unsigned int first_instance =3D 0;
>         char *buf;
>
>         optype =3D flags & CIFS_OP_MASK;
> @@ -936,80 +960,24 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>         if (ses->server->tcpStatus =3D=3D CifsExiting)
>                 return -ENOENT;
>
> -       spin_lock(&ses->server->req_lock);
> -       if (ses->server->credits < num_rqst) {
> -               /*
> -                * Return immediately if not too many requests in flight =
since
> -                * we will likely be stuck on waiting for credits.
> -                */
> -               if (ses->server->in_flight < num_rqst - ses->server->cred=
its) {
> -                       spin_unlock(&ses->server->req_lock);
> -                       return -ENOTSUPP;
> -               }
> -       } else {
> -               /* enough credits to send the whole compounded request */
> -               ses->server->credits -=3D num_rqst;
> -               ses->server->in_flight +=3D num_rqst;
> -               first_instance =3D ses->server->reconnect_instance;
> -       }
> -       spin_unlock(&ses->server->req_lock);
> -
> -       if (first_instance) {
> -               cifs_dbg(FYI, "Acquired %d credits at once\n", num_rqst);
> -               for (i =3D 0; i < num_rqst; i++) {
> -                       credits[i].value =3D 1;
> -                       credits[i].instance =3D first_instance;
> -               }
> -               goto setup_rqsts;
> -       }
> -
>         /*
> -        * There are not enough credits to send the whole compound reques=
t but
> -        * there are requests in flight that may bring credits from the s=
erver.
> +        * Wait for all the requests to become available.
>          * This approach still leaves the possibility to be stuck waiting=
 for
>          * credits if the server doesn't grant credits to the outstanding
> -        * requests. This should be fixed by returning immediately and le=
tting
> -        * a caller fallback to sequential commands instead of compoundin=
g.
> -        * Ensure we obtain 1 credit per request in the compound chain.
> +        * requests and if the client is completely idle, not generating =
any
> +        * other requests.
> +        * This can be handled by the eventual session reconnect.
>          */
> -       for (i =3D 0; i < num_rqst; i++) {
> -               rc =3D wait_for_free_request(ses->server, flags, &instanc=
e);
> -
> -               if (rc =3D=3D 0) {
> -                       credits[i].value =3D 1;
> -                       credits[i].instance =3D instance;
> -                       /*
> -                        * All parts of the compound chain must get credi=
ts from
> -                        * the same session, otherwise we may end up usin=
g more
> -                        * credits than the server granted. If there were
> -                        * reconnects in between, return -EAGAIN and let =
callers
> -                        * handle it.
> -                        */
> -                       if (i =3D=3D 0)
> -                               first_instance =3D instance;
> -                       else if (first_instance !=3D instance) {
> -                               i++;
> -                               rc =3D -EAGAIN;
> -                       }
> -               }
> +       rc =3D wait_for_compound_request(ses->server, num_rqst, flags,
> +                                      &instance);
> +       if (rc)
> +               return rc;
>
> -               if (rc) {
> -                       /*
> -                        * We haven't sent an SMB packet to the server ye=
t but
> -                        * we already obtained credits for i requests in =
the
> -                        * compound chain - need to return those credits =
back
> -                        * for future use. Note that we need to call add_=
credits
> -                        * multiple times to match the way we obtained cr=
edits
> -                        * in the first place and to account for in fligh=
t
> -                        * requests correctly.
> -                        */
> -                       for (j =3D 0; j < i; j++)
> -                               add_credits(ses->server, &credits[j], opt=
ype);
> -                       return rc;
> -               }
> +       for (i =3D 0; i < num_rqst; i++) {
> +               credits[i].value =3D 1;
> +               credits[i].instance =3D instance;
>         }
>
> -setup_rqsts:
>         /*
>          * Make sure that we sign in the same order that we send on this =
socket
>          * and avoid races inside tcp sendmsg code that could cause corru=
ption
> @@ -1020,14 +988,12 @@ compound_send_recv(const unsigned int xid, struct =
cifs_ses *ses,
>
>         /*
>          * All the parts of the compound chain belong obtained credits fr=
om the
> -        * same session (see the appropriate checks above). In the same t=
ime
> -        * there might be reconnects after those checks but before we acq=
uired
> -        * the srv_mutex. We can not use credits obtained from the previo=
us
> +        * same session. We can not use credits obtained from the previou=
s
>          * session to send this request. Check if there were reconnects a=
fter
>          * we obtained credits and return -EAGAIN in such cases to let ca=
llers
>          * handle it.
>          */
> -       if (first_instance !=3D ses->server->reconnect_instance) {
> +       if (instance !=3D ses->server->reconnect_instance) {
>                 mutex_unlock(&ses->server->srv_mutex);
>                 for (j =3D 0; j < num_rqst; j++)
>                         add_credits(ses->server, &credits[j], optype);
> --
> 2.13.6
>

Thanks for fixing it!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
