Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FA5C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FD620684
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rJder8Jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfCIAxk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:53:40 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33104 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfCIAxk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:53:40 -0500
Received: by mail-lj1-f194.google.com with SMTP id z7so18923937lji.0
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Et/BSS8abCDcUN1fuJX0k5n06d0qFi8fmCWuEo7pQjo=;
        b=rJder8JqTpBiOAzZeVULx/uOqXLfGRRR5auUUnABzDpTgaQeRXiufw2Vu1lgQppTyz
         ZWvD0UeutlOOX6+38iScXjY8XxhCweTO3mWLuaH6xTPInXXpusbZf2n1UR0+UXYRgANa
         2IpsxCWaYF59+vP7rmfpybCXvQvpcmf+xkDCOFdeMZ415loy6pZ+kn7F5eTuNl8dfis/
         DWSx3wjTRmcumHd2IwcveUO6KgfNOhFtbxWqOdXmRkNhj3b04vNEWgLHxgJ9c3W9zKVe
         w0m0qoi5dtTOrRI3vRYw+Q4zqqxci76ioRDfcLkTIMWeD3/yCDXngRDGvqqvrIyiXtJ3
         1hQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Et/BSS8abCDcUN1fuJX0k5n06d0qFi8fmCWuEo7pQjo=;
        b=UEWJMCHjM/Es7aOJjfXo1Bhh/+PvbLdztgsLwVopzdbgALZdqKzjfbt/7cCHZdeCg+
         CCsg7ACbNbyD2u1CVZdhC92r7oTi7SPo78kCQzv+rTmO2Mphp+3GSlvmYOZbU/fYSfGk
         anyYoLTby64IdgnIgj/6tm60qx6lCm9fgX+kuMXYaZi47VtBQT8Ap4uRxO1uoZ/LCno1
         oGz6uofCpkpYMkw/RhOnqcBs3uWM59jYgtnaOL7vZvNUTSApb0QAZRX5biCKpUqZWI4U
         NdLLz492hgGdpgxtmwsGhOeSqEVXZBAjOsMc2O8c2X59nakigrNfyXl7UtYxTHc+j2PO
         lOrQ==
X-Gm-Message-State: APjAAAXFNHpT7VJ0UMa1aoeTeVN1go/d8/bBkR2/GRo5kpTmCk2kl4Ad
        6Mnr6g/l7QjD40cgKmbWlWInUyJ9uAsSIGJuC+Il6hQ=
X-Google-Smtp-Source: APXvYqwr3wD4vFckhgYpbzWHaVrEbQRcXvOJORkLI6n9k0gB1sUD2/HTfzkvrPvPr9ZirtaB3lWShYwRYWmXi1wUQ2o=
X-Received: by 2002:a2e:251:: with SMTP id 78mr10528611ljc.90.1552092816992;
 Fri, 08 Mar 2019 16:53:36 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-7-lsahlber@redhat.com>
In-Reply-To: <20190308025823.24382-7-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:53:25 -0800
Message-ID: <CAKywueTMZwSz1baoxXQn4PnhybnJzBwq_SRGT0uZijutVhxwBA@mail.gmail.com>
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

=D1=87=D1=82, 7 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:35, Ronnie Sahlb=
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
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/transport.c | 106 +++++++++++++++++-----------------------------=
------
>  1 file changed, 34 insertions(+), 72 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 62c58ce80123..3e30b6f9d7c6 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -592,6 +592,27 @@ wait_for_free_request(struct TCP_Server_Info *server=
, const int flags,
>                                      instance);
>  }
>
> +static int
> +wait_for_compound_request(struct TCP_Server_Info *server, int num,
> +                         const int flags, unsigned int *instance)
> +{
> +       spin_lock(&server->req_lock);
> +       if (server->credits < num) {

The patch that introduced this behavior contained a minor error: we
should check against

credits =3D server->ops->get_credits_field(server, optype);

not

server->credits.

There is absolutely no harm in that: the only possible operation that
has different optype is oplock/lease break, it consumes 1 request
(num=3D1) and there is no way that server->credits =3D 0 (normal bucket),
server->oplock_credits =3D 1 (oplock bucket) and server->in_flight =3D 0 -
credits are re-balanced every time we don't have requests in flight
and are moved from the oplock bucket to the normal bucket.

But it would be nice to fix that. Can you squash the fix into this patch pl=
ease?

> +               /*
> +                * Return immediately if not too many requests in flight =
since
> +                * we will likely be stuck on waiting for credits.
> +                */
> +               if (server->in_flight < num - server->credits) {
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
> @@ -920,7 +941,6 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>                 { .value =3D 0, .instance =3D 0 }
>         };
>         unsigned int instance;
> -       unsigned int first_instance =3D 0;
>         char *buf;
>
>         optype =3D flags & CIFS_OP_MASK;
> @@ -936,80 +956,24 @@ compound_send_recv(const unsigned int xid, struct c=
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
> @@ -1020,14 +984,12 @@ compound_send_recv(const unsigned int xid, struct =
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

Other than the minor comment above, the patchset looks good. Thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
