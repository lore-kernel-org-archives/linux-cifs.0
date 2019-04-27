Return-Path: <SRS0=h6f3=S5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409F7C43218
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Apr 2019 08:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01810206E0
	for <linux-cifs@archiver.kernel.org>; Sat, 27 Apr 2019 08:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u0bQQTCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbfD0IIn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 27 Apr 2019 04:08:43 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39419 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfD0IIn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 27 Apr 2019 04:08:43 -0400
Received: by mail-qk1-f196.google.com with SMTP id f125so3294138qke.6
        for <linux-cifs@vger.kernel.org>; Sat, 27 Apr 2019 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ERU8cviK4Ntmj1GmBaU4abMIRobGJWMaaCBtEECyBYg=;
        b=u0bQQTCcbEXSSCo2plE4zKCtW9xQeTfqD5D0CLMHEsPyFJpmhSuKBlrUxNct8VW5Fz
         fgDi4YDvNyrOXOpMQPI3GiW31I4XvHBzjUMeDjUpBPefsG5SLfcEG80wm5UYIMWK5Z6t
         YaAA9CXCbQfIRs0ZYtwfRqJaeC8agZ1J95MNw2LyYzG83lUTO7E6K8+OBkHlermRstjH
         lX/HcZZ+EITtL+24z0syXlo9fCs/PhRMwx3pL5NknDxz3zdRuHukRJ1Vug/ZtmaSoKjC
         yOMdZcRwpW9uXS7XauaWW9y9fXLXfWg0nOBX4oAgKbwsOFhhsCKjs0fWJxntle4D1leM
         AaiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ERU8cviK4Ntmj1GmBaU4abMIRobGJWMaaCBtEECyBYg=;
        b=JHPCMxSzfjHl0qL05UaVIvERFRSJlxLChHWPKXsCCMJoKPBFmRna1FWstJeMPTojyB
         erUOg9tmJgM+0e5h9KcK8V/QjwX+leE73hH/tDvr5pbAyze7SUYtsKqtyvTli9XezbBx
         5EOVBt3rEnUMpDhg78idaIEPHemNco7H24Ry9F4wLcsInvsSi2wYmznYvtR0zrIfHcoB
         QggzAHzRCU6285mTNqk1ryEPrUyyWrPzv1pObg7X7+riwp408aFC2X03k9ej6w0iIjg1
         9zVSg6cpdIozQVrBCHY9W2he7IQIFj7tH3h3HWiyUW71P2ivAcPsu2b6NgaOKSEJBX6X
         KCww==
X-Gm-Message-State: APjAAAVXAcnul8oEnXlW4EKKFzpbGGyogL2pdsB8hjizUir9s4OsAcGd
        inEcNqVj8lhqrbWDy4lA7/KASs/4U+TfNk3uNX0=
X-Google-Smtp-Source: APXvYqyOhU5GOROh6wgX/4mYAcZIrmZQbB4364BLfVJQvK2BIb8U1ZOPFkqv5UR7/wn4ASznGl52Uf9IxGKTrEPL9JE=
X-Received: by 2002:a37:4757:: with SMTP id u84mr37603221qka.275.1556352522068;
 Sat, 27 Apr 2019 01:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190426003223.4763-1-lsahlber@redhat.com> <20190426003223.4763-2-lsahlber@redhat.com>
 <CAKywueSHDP06n+5a-z-Q3wB1nRSrceMDLLTYx+EsCtpoS_iTYA@mail.gmail.com>
In-Reply-To: <CAKywueSHDP06n+5a-z-Q3wB1nRSrceMDLLTYx+EsCtpoS_iTYA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 27 Apr 2019 18:08:31 +1000
Message-ID: <CAN05THRcm_tatCNex7DbuHNfcYkJnower3pAyPbsZ+HmiCqWtA@mail.gmail.com>
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

On Sat, Apr 27, 2019 at 2:38 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=87=D1=82, 25 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 18:43, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsglob.h  |  1 +
> >  fs/cifs/cifssmb.c   |  2 +-
> >  fs/cifs/transport.c | 10 +++++-----
> >  3 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 621640195713..7a65124f70f9 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1701,6 +1701,7 @@ static inline bool is_retryable_error(int error)
> >
> >  #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> >  #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sen=
ding */
> > +#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response =
*/
> >
> >  /* Security Flags: indicate type of session setup needed */
> >  #define   CIFSSEC_MAY_SIGN     0x00001
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index f43747c062a7..6050851edcb8 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_t=
con *tcon,
> >
> >         if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
> >                 /* no response expected */
> > -               flags =3D CIFS_ASYNC_OP | CIFS_OBREAK_OP;
> > +               flags =3D CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK=
_OP;
> >                 pSMB->Timeout =3D 0;
> >         } else if (waitFlag) {
> >                 flags =3D CIFS_BLOCKING_OP; /* blocking operation, no t=
imeout */
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 5c59c498f56a..5573e38b13f3 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -1073,8 +1073,11 @@ compound_send_recv(const unsigned int xid, struc=
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
>
> probably indicate that it is SMB1 oplock break?
>
> > +        * will not receive a response to - return credits back
> > +        */
> > +       if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
> >                 for (i =3D 0; i < num_rqst; i++)
> >                         add_credits(ses->server, &credits[i], optype);
>
> A no-op callback is still needed to be set here or above for
> CIFS_NO_SRV_RSP requests. Otherwise we may end up adding credits
> twice: here and in the demultiplex thread.

I don't think we need one. Since there will never be a reply we will
never invoke the callback from the demultiplex thread.


>
> >                 goto out;
> > @@ -1095,9 +1098,6 @@ compound_send_recv(const unsigned int xid, struct=
 cifs_ses *ses,
> >                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
> >                                            rqst[0].rq_nvec);
> >
> > -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> > -               goto out;
> > -
> >         for (i =3D 0; i < num_rqst; i++) {
> >                 rc =3D wait_for_response(ses->server, midQ[i]);
> >                 if (rc !=3D 0)
> > --
> > 2.13.6
> >
>
>
> --
> Best regards,
> Pavel Shilovsky
