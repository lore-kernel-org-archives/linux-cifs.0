Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE90DC43219
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 03:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75C47206C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 03:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jFZHc5o9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfDZDo5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Apr 2019 23:44:57 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:56038 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfDZDo5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Apr 2019 23:44:57 -0400
Received: by mail-it1-f194.google.com with SMTP id y134so3669010itc.5
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2019 20:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dmwfnXgvT6Qiqn30WsLd5SS1VYxhNhzoSjnRduYW3EY=;
        b=jFZHc5o9UKI8R3CKgG0eJp5CmWwCaBKbINnRt5gYXBAX5ESwtU4X6FERYj/an7whw0
         S8gymAYjcAYxiUL4ZR9oO+m48ircGgMV9FQrmOaEIM3Oj8okX6mJmxg1YE96nmRUILhv
         1PWVkWLGSR6aUbdt0BN9C/uc5YDriQR699RIJogQn+tKVl6tcgBnuCigWqXbflVoCBkw
         zDBdeGoKQ2/Sx80+tMOYcjr2JFAdBOu1cAHbVhnOe+8Ba3IQyrumGALGy5OxVfUVogGt
         UzJ10BLyTX3a765dDPmZq611AUclDc5Wd2Nv8EiRCzU+jU+tyTxUKBDJg85aUwdXXtCC
         DL9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dmwfnXgvT6Qiqn30WsLd5SS1VYxhNhzoSjnRduYW3EY=;
        b=WNWdohcSD67Z8PK/3km05c8iAPymotynq9dwsjrzFgdnB0UdWE4k4LuCAkTU/comAA
         xnua2QCpUu3kRxEG1Dx68YJ8SDgWKrR4cdNUTzO9lWXuLMPartAwNlaKg/reuHugVHYd
         PmgNSMtZc1mQbptS+yZpfSO4/g5LAW3uwwhwKl+ribRPLByWRE3UcYUPqA+AWcECsSVN
         ptB2pPpVVHZ3O3VE0uORmPvQ9IRI8IA/HUGcSr+Bwnt8InpCiK0soJqN6+9LZsebXSOe
         Zo4hA7I0lB73BEr4bin0vO8XpKDwOc2drKKRSktFqpRLAyjjopqs4JrWcI3LnkSqtE5h
         mKkw==
X-Gm-Message-State: APjAAAUUj8q9uk4mRe/bd6su9u1MOrGE0PZjuyTefrfQQhclyOrO7uEb
        wg1P5KwpqXQHN6XknDKnIs2IEM3c9/5EyELw8jU=
X-Google-Smtp-Source: APXvYqygJPuhw3J/CyDt+oCbsPOXLRDB7V75iiGlCqz5gqpIMqG+H185JYy45q2EcpMhMGb5skAGqmIPRoZdLKpQqxQ=
X-Received: by 2002:a02:8243:: with SMTP id q3mr31037789jag.37.1556250296643;
 Thu, 25 Apr 2019 20:44:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190423032749.30799-1-lsahlber@redhat.com> <CAKywueQCViFC3W083J6tb=-oMP2iHAdm89oG73W+hAn451s4ig@mail.gmail.com>
 <CAN05THT5qQ0NwjoCHafhh5YbSSGi46P5abbV-SCOcKXFSGS-JQ@mail.gmail.com> <CAKywueS7-=59Y-Yz2_GHJWWi9bS1msQz+srq8bcM4H8kHG2UwQ@mail.gmail.com>
In-Reply-To: <CAKywueS7-=59Y-Yz2_GHJWWi9bS1msQz+srq8bcM4H8kHG2UwQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 26 Apr 2019 13:44:45 +1000
Message-ID: <CAN05THToer5kb7t0rq=LvPcrVh2TqZhUJfiOQt35N93Y_ej2NA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
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

On Thu, Apr 25, 2019 at 5:28 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=B2=D1=82, 23 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 17:45, ronnie sa=
hlberg <ronniesahlberg@gmail.com>:
> >
> > On Wed, Apr 24, 2019 at 4:04 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> >
> > Thanks for the thoughtful review. Some comments below
> >
> > > =D0=BF=D0=BD, 22 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 21:40, Ronni=
e Sahlberg <lsahlber@redhat.com>:
> > > >
> > > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > > ---
> > > >  fs/cifs/transport.c | 12 +++++++++---
> > > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > > index 5c59c498f56a..3b80884ddf0f 100644
> > > > --- a/fs/cifs/transport.c
> > > > +++ b/fs/cifs/transport.c
> > > > @@ -971,7 +971,7 @@ compound_send_recv(const unsigned int xid, stru=
ct cifs_ses *ses,
> > > >                    const int flags, const int num_rqst, struct smb_=
rqst *rqst,
> > > >                    int *resp_buf_type, struct kvec *resp_iov)
> > > >  {
> > > > -       int i, j, optype, rc =3D 0;
> > > > +       int i, j, optype, opmask, rc =3D 0;
> > > >         struct mid_q_entry *midQ[MAX_COMPOUND];
> > > >         bool cancelled_mid[MAX_COMPOUND] =3D {false};
> > > >         struct cifs_credits credits[MAX_COMPOUND] =3D {
> > > > @@ -981,6 +981,7 @@ compound_send_recv(const unsigned int xid, stru=
ct cifs_ses *ses,
> > > >         char *buf;
> > > >
> > > >         optype =3D flags & CIFS_OP_MASK;
> > > > +       opmask =3D flags & (CIFS_ASYNC_OP|CIFS_NO_RESP);
> > > >
> > > >         for (i =3D 0; i < num_rqst; i++)
> > > >                 resp_buf_type[i] =3D CIFS_NO_BUFFER;  /* no respons=
e buf yet */
> > > > @@ -1073,8 +1074,13 @@ compound_send_recv(const unsigned int xid, s=
truct cifs_ses *ses,
> > > >
> > > >         mutex_unlock(&ses->server->srv_mutex);
> > > >
> > > > -       if (rc < 0) {
> > > > -               /* Sending failed for some reason - return credits =
back */
> > > > +       /*
> > > > +        * If sending failed for some reason or it is an oplock bre=
ak that we
> > > > +        * will not receive a response to - return credits back
> > > > +        */
> > > > +       if (rc < 0 ||
> > > > +           (optype =3D=3D CIFS_OBREAK_OP &&
> > > > +            opmask =3D=3D (CIFS_ASYNC_OP|CIFS_NO_RESP))) {
> > > >                 for (i =3D 0; i < num_rqst; i++)
> > > >                         add_credits(ses->server, &credits[i], optyp=
e);
> > > >                 goto out;
> > > > --
> > > > 2.13.6
> > > >
> > > Thanks for looking into it. Let's me clarify the defines here because
> > > their names are not straightforward and require changes:
> > >
> > > #define   CIFS_ASYNC_OP         2    /* do not wait for response */
> > >
> > > meaning that we don't need a response - probably there won't be a one
> > > (in SMB1 Oplock case). This is confusing because we also have
> > > cifs_call_async that does asynchronous processing of the responses.
> >
> > CIFS_ASYNC_OP is overloaded.
> > In two places it means we will get a response eventually (in one of
> > which "eventually" might mean unbounded time) but don't wait for it.
> > In the third place it means that there is no response to this command.
>
> Agree, we should define another one.

I added a new flag for this in the respin I sent.
There are more things we need to do but that should wait until the
next merge window I think.

>
> >
> > >
> > > #define   CIFS_NO_RESP      0x040    /* no response buffer required *=
/
> > >
> > > meaning that a response buffer is not needed but the error code is.
> > >
> > > The problem with SMB1 oplocks was introduced when credits calculation
> > > was moved to the demultiplex thread. The server might not respond to
> > > such a request at all - that's why it is a special case.
> > >
> > > So, CIFS_NO_RESP flags should be handled like we do today - no change=
s
> > > are needed here. We wait for a response but just do not return a
> > > buffer to the caller. CIFS_ASYNC_OP handling has a bug that it missed
> > > to add credits back once we send such a request. Prior to credit
> > > movement to the demultiplex thread label "out" has the code to add
> > > credits back. So I think the only fix that is needed here is:
> > >
> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > index 5c59c49..26e249d 100644
> > > --- a/fs/cifs/transport.c
> > > +++ b/fs/cifs/transport.c
> > > @@ -1095,8 +1095,11 @@ compound_send_recv(const unsigned int xid,
> > > struct cifs_ses *ses,
> > >                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
> > >                                            rqst[0].rq_nvec);
> > >
> > > -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> > > +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
> > > +               for (i =3D 0; i < num_rqst; i++)
> > > +                       add_credits(ses->server, &credits[i], optype)=
;
> > >                 goto out;
> > > +       }
> >
> > The reason I did it the way I did was that I wanted this change to
> > only affect the smb1 oplock breaks and leave all other commands and
> > behavior unchanged.
> > Maybe we need a new flag that means that there will never be a
> > response at all to this command so we must add all credits back
> > immediately once we have sent the pdu out on the wire.
> >
> > We use CIFS_ASYNC_OP for three different cases.
> > When sending an oplock break, in which case we know we will never get
> > a response from the server (and thus we need to add the credits back
> > somehow which is not the demultiplex loop)
> > but also when we send an Echo request or when we send a Notify request
> > both cases where we WILL eventually receive a reply back from the
> > server and where we should add the credits back in the demultiplex
> > loop.
>
> Only SMB1 oplocks uses compound_send_recv() to send CIFS_ASYNC_OP.
> Notify uses SendReceive() but Notify itself is not being called
> anywhere. Echo uses cifs_call_async which is a completely different
> code path.

This is all for a separate patch for the next merge window, but:

We can remove Notify() since it is not used.
Since this is the only callsite for SendReceive() that uses CIFS_ASYNC_OP
we can then also remove the check for it in SendReceive()

With the new flag I added we no longer need to check for CIFS_ASYNC_OP
in compound_send_recv()
either so I removed it in the patch.

This leaves CIFS_ASYNC_OP used in only two places and the only thing
it is used for is to indicate that
we do not want to block in wait_for_credits().
Thus possibly we should rename this to CIFS_NON_BLOCK.

The semantics then become :
* CIFS_NO_SRV_RSP :  indicating that we will never get a response.
I.e. smb1 oplock break.
* cifs_call_async() : this is what is used to request async processing
of the reply.
* CIFS_NON_BLOCK : in both/all cases used to indicate we don't want to
block in wait_for_credit()

and we might also rename CIFS_NO_RSP to CIFS_NO_SRV_RSP to make it
clearer what this flag indicates.


>
> > So if we add the credits back already here for all CIFS_ASYNC_OPs,
> > doesn't that mean that we could possibly add the credits back twice?
> > Once here and then once again in the demultiplex loop when we
> > get the response?
>
> You are right. In most cases we will manage to delete the mid going to
> "out" label but it is still possible that the server will respond too
> fast for SMB1 oplock and the demultiplex thread will add the credits
> twice. We need a special no-op callback to set for such mid in the
> same loop I propose, so we do not add credits twice.
>
> > Since CIFS_ASYNC_OP suggests that it is an async operation but that we
> > will eventually get a reply (well that is how I parse the name) I feel
> > uncomfortable with that change since it conflates async operations
> > with
> > send-only-and-never-get-a-response operations.
>
> Agree. CIFS_ASYNC_OP is being parsed for me as "return immediately
> after sending a request and handle a response asynchronously". We
> should use this one only in cifs_call_async(), I guess.
>
> >
> > Maybe we need a new flag to better describe the unique case for
> > requests we know will never get a reply ?
> > CIFS_NO_SERVER_RESPONSE  or something?
>
> Let's do CIFS_NO_SRV_RSP to make it shorter - it will be set by SMB1
> oplock only and compound_send_recv won't be handle CIFS_ASYNC_OP
> operations at all truly reflecting its name - we have cifs_call_async
> for those purposes.
>
> > What do you think?
> >
> > >
> > >         for (i =3D 0; i < num_rqst; i++) {
> > >                 rc =3D wait_for_response(ses->server, midQ[i]);
> > >
> > > It worked locally against Samba server for me.
> > >
> > > I would also suggest as a separate change to rename:
> > >
> > > CIFS_ASYNC_OP to CIFS_NO_WAIT, and
> >
> > Not sure about that. I think "async operation" and "don't wait for
> > reply" are pretty equivalent so I don't see a need to rename here.
> > What is unique with smb1 oplock releases is not that they are async (I
> > could argue that they are not) but that they are requests we send that
> > will never have a response pdu from the server.
>
> Ok. Another option is to let cifs_call_async know about the new
> CIFS_NO_SRV_RSP flag and pass a combination of
> CIFS_ASYNC_OP | CIFS_NO_SRV_RSP to the function that will just send a
> request and then delete a mid. No-op callback is still needed there.
>
> >
> > >
> > > CIFS_NO_RESP to CIFS_NO_RESP_BUF
> >
> > I think this would be a good rename. But lets put it in a different
> > patch that only does a rename but does not change any logic.
> >
>
> +1 for a separate patch. Probably RSP instead of RESP, but don't have
> strong preferences here.
>
> --
> Best regards,
> Pavel Shilovsky
