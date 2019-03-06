Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C2DC43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 17:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15D1320842
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 17:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMHBDlRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbfCFR1A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Mar 2019 12:27:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39338 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfCFR1A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Mar 2019 12:27:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id g80so11624560ljg.6
        for <linux-cifs@vger.kernel.org>; Wed, 06 Mar 2019 09:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PgwqaCS0LnYcGYSa2/tixsvpTi4BYybK9QPKLeX2dKw=;
        b=AMHBDlRDI4H68Bl536dpcHufFmroyxjOz3WA4LShlaPL1A17GKDjW29F0I2832fgWl
         pgPdiiitBICrlWjPiqNxHB8WOJZ46Ety8li6Kl7H3CDilC0ya2s6lRuh2ayKF43DU/BR
         nWAWxboVM1qmFX2m12Y/5QfvC7m4kqrsA9E/eIF551sRMpPlK1Ntf0WpmSHKW7yeJtaD
         uDPzwMJ0UestQzRxmgnbkZenHMvqbilBSNFP79AnzwcXhs+qeyd5i2lc6ZrTOM6JwWMY
         eaNPct36ygB/4Szl3Nynh43+j8jZFAXfZj3Kg4BhbFauqSqFvMV/i/UUIYgXrEuaR9k6
         W9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PgwqaCS0LnYcGYSa2/tixsvpTi4BYybK9QPKLeX2dKw=;
        b=l73bHHXBXNKCnkacMs5IRh1ii4qS0bzEzHEACO50k+1R17GlCQuRUz848FPM0Id25i
         PTWo/GSV1CB7c0zpFmHu+qBbeoZEKetFI2fGqMpgwCtJPDMGc6fLeWxa2ABflTwmIIMx
         dwqRYMBk02R7nSR0ixX7+iyIbhpPm+x5TVADLLDPXvx6ZGrfqDLiLBGDhO9ySY4JftYS
         92jxzZ/XvsoDHZXPBWvy+XjWjXVskCnfc1COkjW2l6wDZ9SWSohVVHtGQfxZY+a4P3XT
         vUXTis5EMFK2KQ2QbkbyIFCSjOVWIwCj5M1m77w1SDAOeKAtVioFsu4XdGWXWVQ3x7QS
         Ytog==
X-Gm-Message-State: APjAAAVujz6RfSCxkRvaCgna6ubwmnctL9NDCOKSwmE5ceHYTLK6lRvP
        HYM4nASgeKbhyxN45P88t3g8QtfzcCEF0jP7bA==
X-Google-Smtp-Source: APXvYqzwewCqmifFImjTCyn5wQI6iSCzGGsW1hQyMnPCVz4wUioMB/IpirQpqNnLUn3fIt74RGVEtc58+Lyw7W6vLYM=
X-Received: by 2002:a2e:8644:: with SMTP id i4mr1983522ljj.192.1551893217245;
 Wed, 06 Mar 2019 09:26:57 -0800 (PST)
MIME-Version: 1.0
References: <20190306041546.10419-1-lsahlber@redhat.com> <20190306041546.10419-7-lsahlber@redhat.com>
In-Reply-To: <20190306041546.10419-7-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 6 Mar 2019 09:26:45 -0800
Message-ID: <CAKywueS=r-F5KmSWWC-vKgPH0Eq_3J8fJbBho0qGWr_9PFT=SA@mail.gmail.com>
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

=D0=B2=D1=82, 5 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 21:44, Ronnie Sahlb=
erg <lsahlber@redhat.com>:
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

Thanks for simplifying the compound_send_recv() and adding the
timeout. Although 60sec seems rather big interval, until we have
sequential fallback, it is the best we can do I guess.

>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 82 ++++++++++++++---------------------------------=
------
>  1 file changed, 21 insertions(+), 61 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 3263e8b3a57d..f759822dd2f2 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -592,6 +592,14 @@ wait_for_free_request(struct TCP_Server_Info *server=
, const int flags,
>                                      instance);
>  }
>
> +static int
> +wait_for_compound_request(struct TCP_Server_Info *server, int num,
> +                         const int flags, unsigned int *instance)
> +{
> +       return wait_for_free_credits(server, num, 60000, flags,
> +                                    instance);
> +}
> +
>  int
>  cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
>                       unsigned int *num, struct cifs_credits *credits)
> @@ -920,7 +928,6 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>                 { .value =3D 0, .instance =3D 0 }
>         };
>         unsigned int instance;
> -       unsigned int first_instance =3D 0;
>         char *buf;
>
>         optype =3D flags & CIFS_OP_MASK;
> @@ -946,70 +953,27 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                         spin_unlock(&ses->server->req_lock);
>                         return -ENOTSUPP;

The code above could also be moved into wait_for_free_credits() to
make compound_send_recv() even smaller.

>                 }
> -       } else {
> -               /* enough credits to send the whole compounded request */
> -               ses->server->credits -=3D num_rqst;
> -               ses->server->in_flight +=3D num_rqst;
> -               first_instance =3D ses->server->reconnect_instance;
>         }
>         spin_unlock(&ses->server->req_lock);
>
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
> @@ -1020,17 +984,13 @@ compound_send_recv(const unsigned int xid, struct =
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
> -               for (j =3D 0; j < num_rqst; j++)
> -                       add_credits(ses->server, &credits[j], optype);

Why removing this? We obtained credits and increased the number of
requests in flight but are about to return without sending the request
- need to return those credits back and adjust the number of requests
in flight.

I understand it may be confusing because the session changed and
add_credits won't actually add any credits *but* it will adjust the
number of requests in flight and possibly re-balance the remaining
credits in the current session, thus it is still needed to call
add_credits for all parts of compound chain here.

>                 return -EAGAIN;
>         }
>
> --
> 2.13.6
>


--
Best regards,
Pavel Shilovsky
