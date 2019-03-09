Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F11C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 22:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD08206DF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 22:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bitlLVLC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfCIWEr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Mar 2019 17:04:47 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40768 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbfCIWEr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 9 Mar 2019 17:04:47 -0500
Received: by mail-pg1-f195.google.com with SMTP id u9so983212pgo.7
        for <linux-cifs@vger.kernel.org>; Sat, 09 Mar 2019 14:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kxV1PVobNNI8vHdiTcpsSYKNq+dGzr0oY8+LVyWfXFE=;
        b=bitlLVLCTjHS50uSpslxoBMyfhrkRqA4y2Iyn2CYApWijCbdFl9W4QeO3iQzkCDGbf
         QX6G6FkNahw6VqxQM93eQLrbnKCITPhqKj7J8sb0a6XTtFBxIELsFtPHNNsE0c/q2LH3
         GWRvnvwaZcHgUfRD6HRm4ydIYAoNWVRKzpbCeQ5ZuWWmUIk4VdeDOrEbTDSLF0BiiQKx
         RAYul2MiJR9LaKhYHvCTbsOF4to/Ne7lGH3Dh8F0LAt3dnTYk6Se61W6d8zBoFzoxCiC
         5bTIt8B5ilBM20oLqTt7NGKSQ7CBLrM5CoHJBIubJMbzCv5/cW7gC25rzovyU6Fl4OhO
         NRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kxV1PVobNNI8vHdiTcpsSYKNq+dGzr0oY8+LVyWfXFE=;
        b=geuMVLqRPIvphD6OfTJK77LFrF0RjsgS60yBb6iZaTApWrxZ2ZfCNJwyw/5UT6OtdP
         nW0InAoksd5lfZpvcO/NDAStXmhEF90yqvT7IjrdYXdwvsT1OgIYZNy3kE7hpzzAEwU5
         muKuFDWbg4ZyDFkyqrO7Yb5YBMy3Y4S6u9vsBVCvdTZ9c8ivngE8IXWIOZjdB+G5e2cY
         YyX6KWQRTT+tyJ1QWuP4BvAXXY/v7s4teYx47NPABWDSqx0+4qaST9BQE8iMZkw2J121
         89136lv3+KcEGPzzZD/PeZRWqLbNkVi8DybE+5wZ67f8hDHQtVfTuDGqWTs/5Z+l8nI4
         tyZw==
X-Gm-Message-State: APjAAAUCiaNzJTPnFBnBwvk8UaaXgCx5flObl24xOMAD85I9x6z1zMTy
        QTj41jIZ9oXVL5taooJ5P5jRNZtg2xora0Yg6Ss=
X-Google-Smtp-Source: APXvYqwAlLB86Q0RUNk9ed+BRlXOE+jPPLnflfTtJ78xLqpDLR8uQa/KsU4QSDB1pgrDsjMIYO+qvvcbkuAfMYW1W7E=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr26120189plk.290.1552169085980;
 Sat, 09 Mar 2019 14:04:45 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-7-lsahlber@redhat.com>
 <CAKywueTMZwSz1baoxXQn4PnhybnJzBwq_SRGT0uZijutVhxwBA@mail.gmail.com>
In-Reply-To: <CAKywueTMZwSz1baoxXQn4PnhybnJzBwq_SRGT0uZijutVhxwBA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 9 Mar 2019 16:04:34 -0600
Message-ID: <CAH2r5mtx2-ckO=PZh+1qvC1jmvnGVCdmxLyKyf0A8WxXuvjVgA@mail.gmail.com>
Subject: Re: [PATCH 6/6] cifs: simplify how we handle credits in compond_send_recv()
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I will wait on minor update to this patch before merging it - but
tentatively merged the other 5 in the series to for-next pending more
testing

On Fri, Mar 8, 2019 at 6:53 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D1=87=D1=82, 7 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 19:35, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > Since we can now wait for multiple requests atomically in
> > wait_for_free_request() we can now greatly simplify the handling
> > of the credits in this function.
> >
> > This fixes a potential deadlock where many concurrent compound requests
> > could each have reserved 1 or 2 credits each but are all blocked
> > waiting for the final credits they need to be able to issue the request=
s
> > to the server.
> >
> > Set a default timeout of 60 seconds for compounded requests.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/transport.c | 106 +++++++++++++++++---------------------------=
--------
> >  1 file changed, 34 insertions(+), 72 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 62c58ce80123..3e30b6f9d7c6 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -592,6 +592,27 @@ wait_for_free_request(struct TCP_Server_Info *serv=
er, const int flags,
> >                                      instance);
> >  }
> >
> > +static int
> > +wait_for_compound_request(struct TCP_Server_Info *server, int num,
> > +                         const int flags, unsigned int *instance)
> > +{
> > +       spin_lock(&server->req_lock);
> > +       if (server->credits < num) {
>
> The patch that introduced this behavior contained a minor error: we
> should check against
>
> credits =3D server->ops->get_credits_field(server, optype);
>
> not
>
> server->credits.
>
> There is absolutely no harm in that: the only possible operation that
> has different optype is oplock/lease break, it consumes 1 request
> (num=3D1) and there is no way that server->credits =3D 0 (normal bucket),
> server->oplock_credits =3D 1 (oplock bucket) and server->in_flight =3D 0 =
-
> credits are re-balanced every time we don't have requests in flight
> and are moved from the oplock bucket to the normal bucket.
>
> But it would be nice to fix that. Can you squash the fix into this patch =
please?
>
> > +               /*
> > +                * Return immediately if not too many requests in fligh=
t since
> > +                * we will likely be stuck on waiting for credits.
> > +                */
> > +               if (server->in_flight < num - server->credits) {
> > +                       spin_unlock(&server->req_lock);
> > +                       return -ENOTSUPP;
> > +               }
> > +       }
> > +       spin_unlock(&server->req_lock);
> > +
> > +       return wait_for_free_credits(server, num, 60000, flags,
> > +                                    instance);
> > +}
> > +
> >  int
> >  cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int siz=
e,
> >                       unsigned int *num, struct cifs_credits *credits)
> > @@ -920,7 +941,6 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
> >                 { .value =3D 0, .instance =3D 0 }
> >         };
> >         unsigned int instance;
> > -       unsigned int first_instance =3D 0;
> >         char *buf;
> >
> >         optype =3D flags & CIFS_OP_MASK;
> > @@ -936,80 +956,24 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> >         if (ses->server->tcpStatus =3D=3D CifsExiting)
> >                 return -ENOENT;
> >
> > -       spin_lock(&ses->server->req_lock);
> > -       if (ses->server->credits < num_rqst) {
> > -               /*
> > -                * Return immediately if not too many requests in fligh=
t since
> > -                * we will likely be stuck on waiting for credits.
> > -                */
> > -               if (ses->server->in_flight < num_rqst - ses->server->cr=
edits) {
> > -                       spin_unlock(&ses->server->req_lock);
> > -                       return -ENOTSUPP;
> > -               }
> > -       } else {
> > -               /* enough credits to send the whole compounded request =
*/
> > -               ses->server->credits -=3D num_rqst;
> > -               ses->server->in_flight +=3D num_rqst;
> > -               first_instance =3D ses->server->reconnect_instance;
> > -       }
> > -       spin_unlock(&ses->server->req_lock);
> > -
> > -       if (first_instance) {
> > -               cifs_dbg(FYI, "Acquired %d credits at once\n", num_rqst=
);
> > -               for (i =3D 0; i < num_rqst; i++) {
> > -                       credits[i].value =3D 1;
> > -                       credits[i].instance =3D first_instance;
> > -               }
> > -               goto setup_rqsts;
> > -       }
> > -
> >         /*
> > -        * There are not enough credits to send the whole compound requ=
est but
> > -        * there are requests in flight that may bring credits from the=
 server.
> > +        * Wait for all the requests to become available.
> >          * This approach still leaves the possibility to be stuck waiti=
ng for
> >          * credits if the server doesn't grant credits to the outstandi=
ng
> > -        * requests. This should be fixed by returning immediately and =
letting
> > -        * a caller fallback to sequential commands instead of compound=
ing.
> > -        * Ensure we obtain 1 credit per request in the compound chain.
> > +        * requests and if the client is completely idle, not generatin=
g any
> > +        * other requests.
> > +        * This can be handled by the eventual session reconnect.
> >          */
> > -       for (i =3D 0; i < num_rqst; i++) {
> > -               rc =3D wait_for_free_request(ses->server, flags, &insta=
nce);
> > -
> > -               if (rc =3D=3D 0) {
> > -                       credits[i].value =3D 1;
> > -                       credits[i].instance =3D instance;
> > -                       /*
> > -                        * All parts of the compound chain must get cre=
dits from
> > -                        * the same session, otherwise we may end up us=
ing more
> > -                        * credits than the server granted. If there we=
re
> > -                        * reconnects in between, return -EAGAIN and le=
t callers
> > -                        * handle it.
> > -                        */
> > -                       if (i =3D=3D 0)
> > -                               first_instance =3D instance;
> > -                       else if (first_instance !=3D instance) {
> > -                               i++;
> > -                               rc =3D -EAGAIN;
> > -                       }
> > -               }
> > +       rc =3D wait_for_compound_request(ses->server, num_rqst, flags,
> > +                                      &instance);
> > +       if (rc)
> > +               return rc;
> >
> > -               if (rc) {
> > -                       /*
> > -                        * We haven't sent an SMB packet to the server =
yet but
> > -                        * we already obtained credits for i requests i=
n the
> > -                        * compound chain - need to return those credit=
s back
> > -                        * for future use. Note that we need to call ad=
d_credits
> > -                        * multiple times to match the way we obtained =
credits
> > -                        * in the first place and to account for in fli=
ght
> > -                        * requests correctly.
> > -                        */
> > -                       for (j =3D 0; j < i; j++)
> > -                               add_credits(ses->server, &credits[j], o=
ptype);
> > -                       return rc;
> > -               }
> > +       for (i =3D 0; i < num_rqst; i++) {
> > +               credits[i].value =3D 1;
> > +               credits[i].instance =3D instance;
> >         }
> >
> > -setup_rqsts:
> >         /*
> >          * Make sure that we sign in the same order that we send on thi=
s socket
> >          * and avoid races inside tcp sendmsg code that could cause cor=
ruption
> > @@ -1020,14 +984,12 @@ compound_send_recv(const unsigned int xid, struc=
t cifs_ses *ses,
> >
> >         /*
> >          * All the parts of the compound chain belong obtained credits =
from the
> > -        * same session (see the appropriate checks above). In the same=
 time
> > -        * there might be reconnects after those checks but before we a=
cquired
> > -        * the srv_mutex. We can not use credits obtained from the prev=
ious
> > +        * same session. We can not use credits obtained from the previ=
ous
> >          * session to send this request. Check if there were reconnects=
 after
> >          * we obtained credits and return -EAGAIN in such cases to let =
callers
> >          * handle it.
> >          */
> > -       if (first_instance !=3D ses->server->reconnect_instance) {
> > +       if (instance !=3D ses->server->reconnect_instance) {
> >                 mutex_unlock(&ses->server->srv_mutex);
> >                 for (j =3D 0; j < num_rqst; j++)
> >                         add_credits(ses->server, &credits[j], optype);
> > --
> > 2.13.6
> >
>
> Other than the minor comment above, the patchset looks good. Thanks!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
