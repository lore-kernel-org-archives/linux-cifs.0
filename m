Return-Path: <SRS0=XhbU=S7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF939C43219
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Apr 2019 18:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B30822075E
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Apr 2019 18:59:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tYkNVfWN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfD2S7L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Apr 2019 14:59:11 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45559 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfD2S7K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Apr 2019 14:59:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id t11so8715376lfl.12
        for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2019 11:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3KHoLadEAQW4TYPGuVExL2GRVQAuAxs+gVUG4Qt+wFg=;
        b=tYkNVfWNpyDkCikbZchhS/Jt8YBIWyUwPiGpTcEvJfWy501j5dE94CmHUVI/1/9SyI
         A8Kr1T2Z7JQb9KspHC3ik8cYTLrmQR+P5xjLf1M3ILQ3qqZBIlahsyE68lHyeSDkHbWU
         NXdL9IrBYRDrSmxHzSSz1wFy6FQIviGfFk6b2a3G+yoCI04i29KftCJ9YY/FwMyrUtTz
         OaXx4XUBiUxd9YMhd9weoPapGykCFYmNTvktOfEocSnLjoW3w7QH2zTbeH2mzU+mMnID
         wkhHe5RLLkxqlbgyYRPSaFRyIDv4OTGLFqeEIVUUvSXgrK9SCCpxiZS41/4maP9fU8Pu
         RS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3KHoLadEAQW4TYPGuVExL2GRVQAuAxs+gVUG4Qt+wFg=;
        b=b8p069cznB3tOgKy+vaLMfAQXBfZ3xvMuA0acnfl5gl1Lc/yjtMJA6tu24WhhJICAL
         6ygNVXhoEuchB/z7lc7QrxV8ldERUrBaQ/VS7qRG2W8s3L4dCAJr/M2m2/FMF5B5dEVi
         Q2/Djoq4mGY28HQf6hnrcrmSv29geq7gRkryzd3KwXS79JpnJFLY0GxH+vqU3O1GF330
         52p5X5m72Cy3AfoaU+bkptv/PajmfpW1z+zD6gV8ow6+MIIo24ZIO9uhCnWCIe58CiHf
         njO4yTXTRbYU5As5i+wXITpe9mqJfRo4UWW+4AwNmqEno6v9hn8U/abb9xMjW84nD64i
         SK/A==
X-Gm-Message-State: APjAAAVQ75wil5YeliS979ash/mjr0vFdzxPsM7ZnUObPK5DEFLrOqtA
        A+QJAtXW+zl79iuw/0px+KZzG/Tr1WRriAN81A==
X-Google-Smtp-Source: APXvYqwHn6sbLpyXEohbYGyX3OPhYysQAkb0PgDLiBzyNOPVw3j3Mz1Z/9gp5LsdcNlslQImpn9E6AYww8mPMIPLRU8=
X-Received: by 2002:ac2:4ac3:: with SMTP id m3mr34907100lfp.97.1556564348716;
 Mon, 29 Apr 2019 11:59:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190426003223.4763-1-lsahlber@redhat.com> <20190426003223.4763-2-lsahlber@redhat.com>
 <CAKywueSHDP06n+5a-z-Q3wB1nRSrceMDLLTYx+EsCtpoS_iTYA@mail.gmail.com> <CAN05THRcm_tatCNex7DbuHNfcYkJnower3pAyPbsZ+HmiCqWtA@mail.gmail.com>
In-Reply-To: <CAN05THRcm_tatCNex7DbuHNfcYkJnower3pAyPbsZ+HmiCqWtA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 29 Apr 2019 11:58:57 -0700
Message-ID: <CAKywueS9kMHTzpTQwaUyg+8roF=1vxcE-WH1Y6JVRceURKQk-w@mail.gmail.com>
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

=D1=81=D0=B1, 27 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 01:08, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> On Sat, Apr 27, 2019 at 2:38 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D1=87=D1=82, 25 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 18:43, Ronnie =
Sahlberg <lsahlber@redhat.com>:
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cifsglob.h  |  1 +
> > >  fs/cifs/cifssmb.c   |  2 +-
> > >  fs/cifs/transport.c | 10 +++++-----
> > >  3 files changed, 7 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 621640195713..7a65124f70f9 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -1701,6 +1701,7 @@ static inline bool is_retryable_error(int error=
)
> > >
> > >  #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> > >  #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before s=
ending */
> > > +#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server respons=
e */
> > >
> > >  /* Security Flags: indicate type of session setup needed */
> > >  #define   CIFSSEC_MAY_SIGN     0x00001
> > > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > > index f43747c062a7..6050851edcb8 100644
> > > --- a/fs/cifs/cifssmb.c
> > > +++ b/fs/cifs/cifssmb.c
> > > @@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs=
_tcon *tcon,
> > >
> > >         if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
> > >                 /* no response expected */
> > > -               flags =3D CIFS_ASYNC_OP | CIFS_OBREAK_OP;
> > > +               flags =3D CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBRE=
AK_OP;
> > >                 pSMB->Timeout =3D 0;
> > >         } else if (waitFlag) {
> > >                 flags =3D CIFS_BLOCKING_OP; /* blocking operation, no=
 timeout */
> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > > index 5c59c498f56a..5573e38b13f3 100644
> > > --- a/fs/cifs/transport.c
> > > +++ b/fs/cifs/transport.c
> > > @@ -1073,8 +1073,11 @@ compound_send_recv(const unsigned int xid, str=
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
> >
> > probably indicate that it is SMB1 oplock break?
> >
> > > +        * will not receive a response to - return credits back
> > > +        */
> > > +       if (rc < 0 || (flags & CIFS_NO_SRV_RSP)) {
> > >                 for (i =3D 0; i < num_rqst; i++)
> > >                         add_credits(ses->server, &credits[i], optype)=
;
> >
> > A no-op callback is still needed to be set here or above for
> > CIFS_NO_SRV_RSP requests. Otherwise we may end up adding credits
> > twice: here and in the demultiplex thread.
>
> I don't think we need one. Since there will never be a reply we will
> never invoke the callback from the demultiplex thread.

Ok, this is according to the spec. Having a no-op callback would save
us from the server error but it's probably not worth the attention.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>.

I think this patch belongs to stable because the bug exists in 5.0.
Could you please add a description together with a stable tag and
resend?

--
Best regards,
Pavel Shilovsky
