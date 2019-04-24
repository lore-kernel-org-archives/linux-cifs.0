Return-Path: <SRS0=97vz=S2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB8DC10F03
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Apr 2019 00:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C209218D2
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Apr 2019 00:45:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfwvyRcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfDXApQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Apr 2019 20:45:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33147 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbfDXApQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Apr 2019 20:45:16 -0400
Received: by mail-io1-f66.google.com with SMTP id u12so3715066iop.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2019 17:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wk3qKGk6rpFrcjm0z94ztQuRZX13zUU/BwQQLPT9y9w=;
        b=NfwvyRcEHR5BBIUXOm7Z3jIaWxjXlyRc2blWOv+nnn8Y3qa+E/b+RgKOVrC5HlY8F2
         ICZt8NctSBeMrCRLTJ3aVuF9Kl/KDarlPpgRzDpiv5IaVFTSorbT1XWLNc/uSuXCBhLF
         d/lY+kjwDjHM2Tky5RPBEjpfqH4EmKjAI+lfFg2x/GLOSoPw9bf397GJ7LUwVSIJnl76
         liSZ+XOyg2ieyqt9LP9IOd+VtCQjAX6iEJFZmfIVkyDVaeRqjclRYLoELBYk6rWioWQB
         ayBNVH0GYdklw9GnlRl0rvKa4X20QY4gudN7jIuG9XuL0qhxFLbpee6MgUNsI7EMqVJn
         CKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wk3qKGk6rpFrcjm0z94ztQuRZX13zUU/BwQQLPT9y9w=;
        b=NUvdJ/LUe/mOb3C7iUgyVNbHJ32nD6Niabb8uS3jo+FL01aZzXZypzQ4XutoosNyWa
         0stgQo7rYe/EXL1+bX2Ln0uDANE1TokynS+RdfnjLR9QsYg9EBFVEjxuhVn9zk9JQeWV
         lhqmdlEqBPGciMM/mXoeUW1QmjvBdOfFZnDiiHq/wkAZHVXdFuAYK0wo4V5H4hySlLO7
         pcLD15n7CWE93hmhbZA3ybxXLkTsnRvVV9+7weC8VbgJbeiADDVPNfjOoeuRIbmzR2Zk
         6PUBRSZVO6b14+J1xwdASo1zTbiNVhSfVwTC5c21evwihqz0kzGeJhNGhKiSetXknsg2
         pVxw==
X-Gm-Message-State: APjAAAXR4s4g/Fk+6Sm4yJNtCRz3CKeCybjyZYSyPHS3hmHd62jKPj7d
        A+GOeeQl2qSFaObjnTTrqHVnRgiprV7EttGOC2M=
X-Google-Smtp-Source: APXvYqza2wXxMIACcte5VD12vc9mwdfHuJn2Q6jR4YJpavM2ituiv1qm5iHPxr5pFZu6Qda2DmsvI/XBYJLApQBB04w=
X-Received: by 2002:a05:6602:20d6:: with SMTP id 22mr14091199ioz.163.1556066715609;
 Tue, 23 Apr 2019 17:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190423032749.30799-1-lsahlber@redhat.com> <CAKywueQCViFC3W083J6tb=-oMP2iHAdm89oG73W+hAn451s4ig@mail.gmail.com>
In-Reply-To: <CAKywueQCViFC3W083J6tb=-oMP2iHAdm89oG73W+hAn451s4ig@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 24 Apr 2019 10:45:03 +1000
Message-ID: <CAN05THT5qQ0NwjoCHafhh5YbSSGi46P5abbV-SCOcKXFSGS-JQ@mail.gmail.com>
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

On Wed, Apr 24, 2019 at 4:04 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>

Thanks for the thoughtful review. Some comments below

> =D0=BF=D0=BD, 22 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 21:40, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/transport.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 5c59c498f56a..3b80884ddf0f 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -971,7 +971,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
> >                    const int flags, const int num_rqst, struct smb_rqst=
 *rqst,
> >                    int *resp_buf_type, struct kvec *resp_iov)
> >  {
> > -       int i, j, optype, rc =3D 0;
> > +       int i, j, optype, opmask, rc =3D 0;
> >         struct mid_q_entry *midQ[MAX_COMPOUND];
> >         bool cancelled_mid[MAX_COMPOUND] =3D {false};
> >         struct cifs_credits credits[MAX_COMPOUND] =3D {
> > @@ -981,6 +981,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
> >         char *buf;
> >
> >         optype =3D flags & CIFS_OP_MASK;
> > +       opmask =3D flags & (CIFS_ASYNC_OP|CIFS_NO_RESP);
> >
> >         for (i =3D 0; i < num_rqst; i++)
> >                 resp_buf_type[i] =3D CIFS_NO_BUFFER;  /* no response bu=
f yet */
> > @@ -1073,8 +1074,13 @@ compound_send_recv(const unsigned int xid, struc=
t cifs_ses *ses,
> >
> >         mutex_unlock(&ses->server->srv_mutex);
> >
> > -       if (rc < 0) {
> > -               /* Sending failed for some reason - return credits back=
 */
> > +       /*
> > +        * If sending failed for some reason or it is an oplock break t=
hat we
> > +        * will not receive a response to - return credits back
> > +        */
> > +       if (rc < 0 ||
> > +           (optype =3D=3D CIFS_OBREAK_OP &&
> > +            opmask =3D=3D (CIFS_ASYNC_OP|CIFS_NO_RESP))) {
> >                 for (i =3D 0; i < num_rqst; i++)
> >                         add_credits(ses->server, &credits[i], optype);
> >                 goto out;
> > --
> > 2.13.6
> >
> Thanks for looking into it. Let's me clarify the defines here because
> their names are not straightforward and require changes:
>
> #define   CIFS_ASYNC_OP         2    /* do not wait for response */
>
> meaning that we don't need a response - probably there won't be a one
> (in SMB1 Oplock case). This is confusing because we also have
> cifs_call_async that does asynchronous processing of the responses.

CIFS_ASYNC_OP is overloaded.
In two places it means we will get a response eventually (in one of
which "eventually" might mean unbounded time) but don't wait for it.
In the third place it means that there is no response to this command.

>
> #define   CIFS_NO_RESP      0x040    /* no response buffer required */
>
> meaning that a response buffer is not needed but the error code is.
>
> The problem with SMB1 oplocks was introduced when credits calculation
> was moved to the demultiplex thread. The server might not respond to
> such a request at all - that's why it is a special case.
>
> So, CIFS_NO_RESP flags should be handled like we do today - no changes
> are needed here. We wait for a response but just do not return a
> buffer to the caller. CIFS_ASYNC_OP handling has a bug that it missed
> to add credits back once we send such a request. Prior to credit
> movement to the demultiplex thread label "out" has the code to add
> credits back. So I think the only fix that is needed here is:
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5c59c49..26e249d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1095,8 +1095,11 @@ compound_send_recv(const unsigned int xid,
> struct cifs_ses *ses,
>                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
>                                            rqst[0].rq_nvec);
>
> -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
> +               for (i =3D 0; i < num_rqst; i++)
> +                       add_credits(ses->server, &credits[i], optype);
>                 goto out;
> +       }

The reason I did it the way I did was that I wanted this change to
only affect the smb1 oplock breaks and leave all other commands and
behavior unchanged.
Maybe we need a new flag that means that there will never be a
response at all to this command so we must add all credits back
immediately once we have sent the pdu out on the wire.

We use CIFS_ASYNC_OP for three different cases.
When sending an oplock break, in which case we know we will never get
a response from the server (and thus we need to add the credits back
somehow which is not the demultiplex loop)
but also when we send an Echo request or when we send a Notify request
both cases where we WILL eventually receive a reply back from the
server and where we should add the credits back in the demultiplex
loop.
So if we add the credits back already here for all CIFS_ASYNC_OPs,
doesn't that mean that we could possibly add the credits back twice?
Once here and then once again in the demultiplex loop when we
get the response?


Since CIFS_ASYNC_OP suggests that it is an async operation but that we
will eventually get a reply (well that is how I parse the name) I feel
uncomfortable with that change since it conflates async operations
with
send-only-and-never-get-a-response operations.

Maybe we need a new flag to better describe the unique case for
requests we know will never get a reply ?
CIFS_NO_SERVER_RESPONSE  or something?


What do you think?

>
>         for (i =3D 0; i < num_rqst; i++) {
>                 rc =3D wait_for_response(ses->server, midQ[i]);
>
> It worked locally against Samba server for me.
>
> I would also suggest as a separate change to rename:
>
> CIFS_ASYNC_OP to CIFS_NO_WAIT, and

Not sure about that. I think "async operation" and "don't wait for
reply" are pretty equivalent so I don't see a need to rename here.
What is unique with smb1 oplock releases is not that they are async (I
could argue that they are not) but that they are requests we send that
will never have a response pdu from the server.

>
> CIFS_NO_RESP to CIFS_NO_RESP_BUF

I think this would be a good rename. But lets put it in a different
patch that only does a rename but does not change any logic.

>
> to reflect the exact meanings.
>
> --
> Best regards,
> Pavel Shilovsky
