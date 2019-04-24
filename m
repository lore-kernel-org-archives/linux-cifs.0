Return-Path: <SRS0=97vz=S2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830DBC282CE
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Apr 2019 19:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 450F32175B
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Apr 2019 19:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JN3t1y9b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbfDXT2g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:28:36 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36684 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfDXT2g (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Apr 2019 15:28:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id l6so3171665ljb.3
        for <linux-cifs@vger.kernel.org>; Wed, 24 Apr 2019 12:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GOkJA65LaAQ2ZNInkstap04lxCSoVl3RrL0od3ndeBA=;
        b=JN3t1y9bnZvdgOMmLYrHWmCqeV0UCx6cDzEftWg6AIXxttLw65q+UeXrJOqS3rlK7a
         szoomeF9l7D8ab5/PMTzZelo4XYoJitDdBzwDN/CCJDYpH9uHiEqX9eNTL+mO8TiMA4X
         QRmKugrJlLW8ZxzovSFT/UUy8l7rx58CbX72OPqPRqS8jY8plhfSFwXSCZ7UbzNGcHbo
         +W2VxCkPgywVLRT5vAJv/R1pbf6K/8EvnHeAEEEH+VzxBi3bBHIzA//VEfD8oyfj66TS
         QJb0OJQmq8u1B4yUwM2sj04R/V6RcyawD/MRj0zYp5/oorrXq45TKTHbOB8z1q5WD4Pq
         tKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GOkJA65LaAQ2ZNInkstap04lxCSoVl3RrL0od3ndeBA=;
        b=hN5Z9ydipeu2J0W4mfrXN2fiA5r5BFmOwCsLCm2UXRpUSFe5E5ZDGTLT510vuHbLzC
         b1apCpxHj+OVugEv9jgBex52l73ZavIDQSLlrHC8MpuhcNe3pvvn6W1tUym5X0bLUaL+
         vTpitRxsNJw2dipBxKannSW8HkFsBCZfmnD48KzeojwxyvKZ9Yc8/8nBXyxl/rmSB6JK
         VEBc3S+muKHmhcMCfX09l+4sIvujvQIXufY3B6+wY9oWtcSFDZbRgFhTymDtJidRlqoG
         hNcViq+/7WJqEZimOuZ9SjKI3FQsUxVDS3wRXtJVUjXzbOlmmFZPH0p+kKv7jKU8lzUe
         SiZg==
X-Gm-Message-State: APjAAAUoMrgyC9egjE6IH/7DTxdoyaEpJk/XbZp7zNWWafIyfqwQ/cIz
        h1q4U8TPvcF8jBH7K2tt4VgLCB6vraixIFofww==
X-Google-Smtp-Source: APXvYqyeMtohNu7iIR8BUUvP97yEh9liUqrRwPVRn0tSunJwJLLqbu+JZ7CW6pVxuALNrmvkGftAp5iArr7YxDDTo2w=
X-Received: by 2002:a2e:9348:: with SMTP id m8mr18733746ljh.23.1556134113478;
 Wed, 24 Apr 2019 12:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190423032749.30799-1-lsahlber@redhat.com> <CAKywueQCViFC3W083J6tb=-oMP2iHAdm89oG73W+hAn451s4ig@mail.gmail.com>
 <CAN05THT5qQ0NwjoCHafhh5YbSSGi46P5abbV-SCOcKXFSGS-JQ@mail.gmail.com>
In-Reply-To: <CAN05THT5qQ0NwjoCHafhh5YbSSGi46P5abbV-SCOcKXFSGS-JQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 24 Apr 2019 12:28:22 -0700
Message-ID: <CAKywueS7-=59Y-Yz2_GHJWWi9bS1msQz+srq8bcM4H8kHG2UwQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix credits leak for SMB1 oplock breaks
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
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

=D0=B2=D1=82, 23 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 17:45, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> On Wed, Apr 24, 2019 at 4:04 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
>
> Thanks for the thoughtful review. Some comments below
>
> > =D0=BF=D0=BD, 22 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 21:40, Ronnie =
Sahlberg <lsahlber@redhat.com>:
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/transport.c | 12 +++++++++---
> > >  1 file changed, 9 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > index 5c59c498f56a..3b80884ddf0f 100644
> > > --- a/fs/cifs/transport.c
> > > +++ b/fs/cifs/transport.c
> > > @@ -971,7 +971,7 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> > >                    const int flags, const int num_rqst, struct smb_rq=
st *rqst,
> > >                    int *resp_buf_type, struct kvec *resp_iov)
> > >  {
> > > -       int i, j, optype, rc =3D 0;
> > > +       int i, j, optype, opmask, rc =3D 0;
> > >         struct mid_q_entry *midQ[MAX_COMPOUND];
> > >         bool cancelled_mid[MAX_COMPOUND] =3D {false};
> > >         struct cifs_credits credits[MAX_COMPOUND] =3D {
> > > @@ -981,6 +981,7 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> > >         char *buf;
> > >
> > >         optype =3D flags & CIFS_OP_MASK;
> > > +       opmask =3D flags & (CIFS_ASYNC_OP|CIFS_NO_RESP);
> > >
> > >         for (i =3D 0; i < num_rqst; i++)
> > >                 resp_buf_type[i] =3D CIFS_NO_BUFFER;  /* no response =
buf yet */
> > > @@ -1073,8 +1074,13 @@ compound_send_recv(const unsigned int xid, str=
uct cifs_ses *ses,
> > >
> > >         mutex_unlock(&ses->server->srv_mutex);
> > >
> > > -       if (rc < 0) {
> > > -               /* Sending failed for some reason - return credits ba=
ck */
> > > +       /*
> > > +        * If sending failed for some reason or it is an oplock break=
 that we
> > > +        * will not receive a response to - return credits back
> > > +        */
> > > +       if (rc < 0 ||
> > > +           (optype =3D=3D CIFS_OBREAK_OP &&
> > > +            opmask =3D=3D (CIFS_ASYNC_OP|CIFS_NO_RESP))) {
> > >                 for (i =3D 0; i < num_rqst; i++)
> > >                         add_credits(ses->server, &credits[i], optype)=
;
> > >                 goto out;
> > > --
> > > 2.13.6
> > >
> > Thanks for looking into it. Let's me clarify the defines here because
> > their names are not straightforward and require changes:
> >
> > #define   CIFS_ASYNC_OP         2    /* do not wait for response */
> >
> > meaning that we don't need a response - probably there won't be a one
> > (in SMB1 Oplock case). This is confusing because we also have
> > cifs_call_async that does asynchronous processing of the responses.
>
> CIFS_ASYNC_OP is overloaded.
> In two places it means we will get a response eventually (in one of
> which "eventually" might mean unbounded time) but don't wait for it.
> In the third place it means that there is no response to this command.

Agree, we should define another one.

>
> >
> > #define   CIFS_NO_RESP      0x040    /* no response buffer required */
> >
> > meaning that a response buffer is not needed but the error code is.
> >
> > The problem with SMB1 oplocks was introduced when credits calculation
> > was moved to the demultiplex thread. The server might not respond to
> > such a request at all - that's why it is a special case.
> >
> > So, CIFS_NO_RESP flags should be handled like we do today - no changes
> > are needed here. We wait for a response but just do not return a
> > buffer to the caller. CIFS_ASYNC_OP handling has a bug that it missed
> > to add credits back once we send such a request. Prior to credit
> > movement to the demultiplex thread label "out" has the code to add
> > credits back. So I think the only fix that is needed here is:
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 5c59c49..26e249d 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -1095,8 +1095,11 @@ compound_send_recv(const unsigned int xid,
> > struct cifs_ses *ses,
> >                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
> >                                            rqst[0].rq_nvec);
> >
> > -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> > +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
> > +               for (i =3D 0; i < num_rqst; i++)
> > +                       add_credits(ses->server, &credits[i], optype);
> >                 goto out;
> > +       }
>
> The reason I did it the way I did was that I wanted this change to
> only affect the smb1 oplock breaks and leave all other commands and
> behavior unchanged.
> Maybe we need a new flag that means that there will never be a
> response at all to this command so we must add all credits back
> immediately once we have sent the pdu out on the wire.
>
> We use CIFS_ASYNC_OP for three different cases.
> When sending an oplock break, in which case we know we will never get
> a response from the server (and thus we need to add the credits back
> somehow which is not the demultiplex loop)
> but also when we send an Echo request or when we send a Notify request
> both cases where we WILL eventually receive a reply back from the
> server and where we should add the credits back in the demultiplex
> loop.

Only SMB1 oplocks uses compound_send_recv() to send CIFS_ASYNC_OP.
Notify uses SendReceive() but Notify itself is not being called
anywhere. Echo uses cifs_call_async which is a completely different
code path.

> So if we add the credits back already here for all CIFS_ASYNC_OPs,
> doesn't that mean that we could possibly add the credits back twice?
> Once here and then once again in the demultiplex loop when we
> get the response?

You are right. In most cases we will manage to delete the mid going to
"out" label but it is still possible that the server will respond too
fast for SMB1 oplock and the demultiplex thread will add the credits
twice. We need a special no-op callback to set for such mid in the
same loop I propose, so we do not add credits twice.

> Since CIFS_ASYNC_OP suggests that it is an async operation but that we
> will eventually get a reply (well that is how I parse the name) I feel
> uncomfortable with that change since it conflates async operations
> with
> send-only-and-never-get-a-response operations.

Agree. CIFS_ASYNC_OP is being parsed for me as "return immediately
after sending a request and handle a response asynchronously". We
should use this one only in cifs_call_async(), I guess.

>
> Maybe we need a new flag to better describe the unique case for
> requests we know will never get a reply ?
> CIFS_NO_SERVER_RESPONSE  or something?

Let's do CIFS_NO_SRV_RSP to make it shorter - it will be set by SMB1
oplock only and compound_send_recv won't be handle CIFS_ASYNC_OP
operations at all truly reflecting its name - we have cifs_call_async
for those purposes.

> What do you think?
>
> >
> >         for (i =3D 0; i < num_rqst; i++) {
> >                 rc =3D wait_for_response(ses->server, midQ[i]);
> >
> > It worked locally against Samba server for me.
> >
> > I would also suggest as a separate change to rename:
> >
> > CIFS_ASYNC_OP to CIFS_NO_WAIT, and
>
> Not sure about that. I think "async operation" and "don't wait for
> reply" are pretty equivalent so I don't see a need to rename here.
> What is unique with smb1 oplock releases is not that they are async (I
> could argue that they are not) but that they are requests we send that
> will never have a response pdu from the server.

Ok. Another option is to let cifs_call_async know about the new
CIFS_NO_SRV_RSP flag and pass a combination of
CIFS_ASYNC_OP | CIFS_NO_SRV_RSP to the function that will just send a
request and then delete a mid. No-op callback is still needed there.

>
> >
> > CIFS_NO_RESP to CIFS_NO_RESP_BUF
>
> I think this would be a good rename. But lets put it in a different
> patch that only does a rename but does not change any logic.
>

+1 for a separate patch. Probably RSP instead of RESP, but don't have
strong preferences here.

--
Best regards,
Pavel Shilovsky
