Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25689C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2278205C9
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:12:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCP979uG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbfB1FMW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:12:22 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33600 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfB1FMW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 00:12:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id x9so11400717qkf.0
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 21:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ceIEim+YuW8+jpF1ECliSjo7JDKKfUfAryS/wZNFrWk=;
        b=LCP979uGW0XIJuy+0dM5r0Hp3hJZZCHrXcu7Zzw9HHAE8QuZ8kB4Oc/CHDJKiQISP4
         PlZL4/hH+Zcq3mdcSKzB0TXSwOvg0nyblx56t6ZWG9umadntyfVAK2pdLGghlvQRRo9e
         NZzMNWeHmfTLeaLxiUU1Ms2TmI12daORPdlVXHpNQ8krCm3/3QZxM/jw8/+wZwqapnIF
         iP+17wVlwLBpXL8xVyaEgKeC3R6SA9GaTDh0ESL2es0p6Uz2xXWgW4jf+Cp4OE70V/Vn
         VNqrilMPIYrqP/x76i0ryz8n2/Ox3msGH4qhJPzHVmkA5kZfUGGQnmYoQ2x5lsltBx6o
         3+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ceIEim+YuW8+jpF1ECliSjo7JDKKfUfAryS/wZNFrWk=;
        b=p9M9upNZzbOEFHLjWi/JKORwO0YYZd26oXt4IqVbZQSAg0k5pcg7wam540Z533UgJ7
         5VFiaAjg1PRxS9kzlmGX7UPKjH7kbNO0nR+zNA+q0Px3Fly0WmXe/YcXUz0PR+Yy3mYa
         JDsIwHtmbKAsKRqEbw5agOg1X30TOp5L+QUp5nOVZwv0W0Ez5VJ2EU1APTmmdyZZR/4i
         stJ4IbFnpnwOhZqhNXrkwKesU9WPR9LAJWVHhbChPmMNHblsQ7KFPLkKLYZVZDjlljyp
         kW/OxbDUaxsoYpQjea+uF6dZo46Z1lXpu+5msOH20j/fj797IjzthymllTxYKogRHgEK
         2rOQ==
X-Gm-Message-State: AHQUAuYKYXmH3vicgpWgLhj8TwF0Y/agjH/OUSV7AGLyzcIA6IWnfF6c
        UzL6eThn6tMj798CE4ay5bWWdTKKgXN5d3zoNIU=
X-Google-Smtp-Source: AHgI3Ibm2QpSwPaPvIdJBcCmPly4/KzhHlA79U3TVtQrWZhLdz43D65o0AQ71y/6XE0+yR9lAfijmKJ7rlMQKG63g74=
X-Received: by 2002:a05:620a:1348:: with SMTP id c8mr5150156qkl.246.1551330740727;
 Wed, 27 Feb 2019 21:12:20 -0800 (PST)
MIME-Version: 1.0
References: <20190220061145.28241-1-lsahlber@redhat.com> <20190220061145.28241-2-lsahlber@redhat.com>
 <CAKywueQEnaPfdCBRz4AJk8FAFDTfr5UC60wiM=7av3f9U050=A@mail.gmail.com>
In-Reply-To: <CAKywueQEnaPfdCBRz4AJk8FAFDTfr5UC60wiM=7av3f9U050=A@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 28 Feb 2019 15:12:09 +1000
Message-ID: <CAN05THRN=QaC_taKTHyVF8m=bJPLtQCgBe6_qnhhXzWUh=p_Hg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: change wait_for_free_request to take number of
 requests to wait for
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 21, 2019 at 11:39 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D0=B2=D1=82, 19 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:12, Ron=
nie Sahlberg <lsahlber@redhat.com>:
> >
> > Change wait_for_free_request to allow specifying how many requests(cred=
its)
> > to wait for.
> > Pass 1 from all callsites.
> >
> > This should not change any behavior but will allow future callers to
> > atomically wait for >1 requests.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsglob.h  |  4 ++--
> >  fs/cifs/smb2ops.c   |  2 +-
> >  fs/cifs/transport.c | 25 ++++++++++++++-----------
> >  3 files changed, 17 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 5bf463c2d9dc..1b3f62eee4d0 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -732,13 +732,13 @@ in_flight(struct TCP_Server_Info *server)
> >  }
> >
> >  static inline bool
> > -has_credits(struct TCP_Server_Info *server, int *credits)
> > +has_credits(struct TCP_Server_Info *server, int *credits, int num_cred=
its)
> >  {
> >         int num;
> >         spin_lock(&server->req_lock);
> >         num =3D *credits;
> >         spin_unlock(&server->req_lock);
> > -       return num > 0;
> > +       return num >=3D num_credits;
> >  }
> >
> >  static inline void
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 080929a64c64..372a3563b79b 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -185,7 +185,7 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *serve=
r, unsigned int size,
> >                         spin_unlock(&server->req_lock);
> >                         cifs_num_waiters_inc(server);
> >                         rc =3D wait_event_killable(server->request_q,
> > -                                       has_credits(server, &server->cr=
edits));
> > +                                has_credits(server, &server->credits, =
1));
> >                         cifs_num_waiters_dec(server);
> >                         if (rc)
> >                                 return rc;
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index d4f1224fb7cb..8ce5b6e787c6 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -478,7 +478,8 @@ smb_send(struct TCP_Server_Info *server, struct smb=
_hdr *smb_buffer,
> >
> >  static int
> >  wait_for_free_credits(struct TCP_Server_Info *server, const int timeou=
t,
> > -                     int *credits, unsigned int *instance)
> > +                     int num_credits, int *credits,
> > +                     unsigned int *instance)
> >  {
> >         int rc;
> >
> > @@ -495,11 +496,11 @@ wait_for_free_credits(struct TCP_Server_Info *ser=
ver, const int timeout,
> >         }
> >
> >         while (1) {
> > -               if (*credits <=3D 0) {
> > +               if (*credits < num_credits) {
> >                         spin_unlock(&server->req_lock);
> >                         cifs_num_waiters_inc(server);
> >                         rc =3D wait_event_killable(server->request_q,
> > -                                                has_credits(server, cr=
edits));
> > +                                has_credits(server, credits, num_credi=
ts));
> >                         cifs_num_waiters_dec(server);
> >                         if (rc)
> >                                 return rc;
> > @@ -517,8 +518,8 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int timeout,
> >
> >                         /* update # of requests on the wire to server *=
/
> >                         if (timeout !=3D CIFS_BLOCKING_OP) {
> > -                               *credits -=3D 1;
> > -                               server->in_flight++;
> > +                               *credits -=3D num_credits;
> > +                               server->in_flight +=3D num_credits;
> >                                 *instance =3D server->reconnect_instanc=
e;
> >                         }
> >                         spin_unlock(&server->req_lock);
> > @@ -530,7 +531,7 @@ wait_for_free_credits(struct TCP_Server_Info *serve=
r, const int timeout,
> >
> >  static int
> >  wait_for_free_request(struct TCP_Server_Info *server, const int timeou=
t,
> > -                     const int optype, unsigned int *instance)
> > +                     int num, const int optype, unsigned int *instance=
)
>
> Waiting for more than one credit without a timeout is a source of
> possibility to be stuck. We already have 'timeout' argument which
> contains some part of flags passed to transport layer from PDU. We
> might consider renaming 'optype' argument into flags and use 'timeout'
> with its true meaning - timeout of the waiting for credits.
>
> Once implemented, we can define some default period of time which we
> can *afford* to wait for credits and then fall back to sequential code
> if we timed out.
>
> I also suggest to add another function wait_for_compound_credits and
> make wait_for_free_request calls it - doesn't require changes to all
> the places where the latter is being used.

Thanks, I am reworking it and will resend shortly.
Passing flags down into these functions instead of timeout/optype
makes sense and I will do that.

I am not sure we need to add a timeout to represent a deadline after
we return -EAGAIN or similar.
But for sure we need to prevent waiting atomically for >1 credits to
block forever.
This could happen in two scenarios, the first would be if the number
of free credits are persistently pegged at <=3D1 credits
due to persistent and massive number of threads causing single credits
SMB2 I/O.
I.e. we are constantly starved for multi-credit requests.

The second would be if we get stuck at <=3D1 available credits even when
the session is idle.
This would be a bug and the best is probably to let the reconnect
eventually happen and thus force the credits to be in sync again
between server and client.
So I don't think we need t do anything explicit for that case here.

The first case is a genuine case, but I think we can handle that in a
different way instead of switching back to a "grab one credit at a
time" like we have now.
In that scenario we would have a different problem that is  there
could be so many concurrent calls for compounded operations requiring
>=3D3 credits each
that we eventually consume MAX_CREDITS number of credits across these
threads. Each thread having already allocated one of more credits less
that it needs for the full compound
and the the threads are now all deadlocked each waiting for one or
more credits that will never become available.
Making the allocation of credits for a compound allocate all of them
atomically solves this type of deadlock, but would be prone to the
credits starvation issue.

The way I propose to solve the credits starvation problem for
compounds is something like this (I haven't coded it yet so I dont
know exactly what it will look like)
* After the session has been fully established, we should be able to
assume we WILL have a whole bunch of credits available.
Modulo a hypothetical situation where the sever will just never grant
us more than 1 or 2 credits in total. I don't think this is a
reasonable situation we need to worry too much about and maybe the
right thing to do here is just to block all compound
operations until we get a session reconnect where hopefully the server
will be more reasonable.
* We can define a new MAX_CREDITS_FOR_COMPOUND which would be the
largest number of credits that we will ever create a single compound
for.
I think that would be 4 at this stage.
* In the loop in wait_for_free_credits(), If this is a request for a
single credit AND iff it is a normal operation, i.e. &CIFS_OP_MASK =3D=3D
0
then we will NOT grant the single credit but continue looping.

I.e. basically reserving the last MAX_CREDITS_FOR_COMPOUND credits
before we completely run out to only be available for compounds.
That way we do guarantee that compound requests will be making
progress and will not be completely starved by non-compound requests..



>
> >  {
> >         int *val;
> >
> > @@ -538,7 +539,7 @@ wait_for_free_request(struct TCP_Server_Info *serve=
r, const int timeout,
> >         /* Since an echo is already inflight, no need to wait to send a=
nother */
> >         if (*val <=3D 0 && optype =3D=3D CIFS_ECHO_OP)
> >                 return -EAGAIN;
> > -       return wait_for_free_credits(server, timeout, val, instance);
> > +       return wait_for_free_credits(server, timeout, num, val, instanc=
e);
> >  }
> >
> >  int
> > @@ -646,7 +647,8 @@ cifs_call_async(struct TCP_Server_Info *server, str=
uct smb_rqst *rqst,
> >         optype =3D flags & CIFS_OP_MASK;
> >
> >         if ((flags & CIFS_HAS_CREDITS) =3D=3D 0) {
> > -               rc =3D wait_for_free_request(server, timeout, optype, &=
instance);
> > +               rc =3D wait_for_free_request(server, timeout, 1, optype=
,
> > +                                          &instance);
> >                 if (rc)
> >                         return rc;
> >                 credits.value =3D 1;
> > @@ -923,7 +925,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
> >          * Ensure we obtain 1 credit per request in the compound chain.
> >          */
> >         for (i =3D 0; i < num_rqst; i++) {
> > -               rc =3D wait_for_free_request(ses->server, timeout, opty=
pe,
> > +               rc =3D wait_for_free_request(ses->server, timeout, 1, o=
ptype,
> >                                            &instance);
> >
> >                 if (rc =3D=3D 0) {
> > @@ -1212,7 +1214,8 @@ SendReceive(const unsigned int xid, struct cifs_s=
es *ses,
> >                 return -EIO;
> >         }
> >
> > -       rc =3D wait_for_free_request(ses->server, timeout, 0, &credits.=
instance);
> > +       rc =3D wait_for_free_request(ses->server, timeout, 1, 0,
> > +                                  &credits.instance);
> >         if (rc)
> >                 return rc;
> >
> > @@ -1354,7 +1357,7 @@ SendReceiveBlockingLock(const unsigned int xid, s=
truct cifs_tcon *tcon,
> >                 return -EIO;
> >         }
> >
> > -       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 0,
> > +       rc =3D wait_for_free_request(ses->server, CIFS_BLOCKING_OP, 1, =
0,
> >                                    &instance);
> >         if (rc)
> >                 return rc;
> > --
> > 2.13.6
> >
>
> --
> Best regards,
> Pavel Shilovsky
