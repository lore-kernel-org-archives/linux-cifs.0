Return-Path: <SRS0=0jCz=UM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6E6C31E45
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 23:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9998620896
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 23:33:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSo+PzLl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfFMXdV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jun 2019 19:33:21 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35143 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFMXdV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jun 2019 19:33:21 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so410496lfg.2
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2019 16:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KCzS8FmrPd/oQs7G3DKGWLEFCDeWDj7JfrdKQZEbOHU=;
        b=WSo+PzLlrIETNvks71QmFmDKOF5RCsgFJlUZsgrI9mhBi9+WxNKJjHt/3iP/gzTmzN
         jBIHYt2Y38Sin4bOZYDpiiscyYIIOrxIXj/kH1rjcqbWj/g+WMBkndIXbd4AJeOcAw7c
         mICa/FGqB0zm4BJLM/qV7zIOA+pvmKuQINS0q83LMVb5P1tv44m2MdL4MO5tNTJO13Fk
         AH0d/KAIMMFUV62csfvwnva7Cb09RajduwIsfPm8Ofd68EY5IIa/uhhhphVOx2KTO34g
         DW//o4qUAOW8//34QhiuRBeSnI6WndFc+zvAyM6jh3lx8J/G5DDARzdvEZP1eUDQp0cj
         Qtjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KCzS8FmrPd/oQs7G3DKGWLEFCDeWDj7JfrdKQZEbOHU=;
        b=cPW6QVYr+lgj9nR+JTNf7D7XS2sBEfV2OWa9xE/lZ4MvrJT/Fv5tZInguWaqQVb3wB
         2Aa1m/PKIUZJwvuVIUjISeGqvLDDM3TcaAkrgjhJvR7EoUF4kEnC/hdBdhIlUHhvZ6Px
         BTV1M53ADFAldquF62G0nK0K6Nx8mmPTiTZ50WxwW31IwAp/4NbbqYqEFdAqH1Lw39Tx
         9IpEQKxPR/cZQGum2hDGoPTU2wKrm+74E8oVEe2SD3VfgdqcikF/BFwxfKoZro/Z+qAk
         8Q+VCu3C/wpiMVk1iFV4fvYEQGoe/49MtldQjgvgsLHMMBGnEcxw2PgPMTRGjplfJWmk
         iTxw==
X-Gm-Message-State: APjAAAW0j7630V4UBoHhGcWXaQT5YnFkHxXQEouYWg1ODhlcOxbjsB+C
        0as0zggitCWn65oqYd01BDRLCt/aCJw7a0llBr9G00c=
X-Google-Smtp-Source: APXvYqznAFxFmpI7LtFwcYnDiOL3mNULVJfXgTVr9t+JuFfT0eH+C3A2kuGGf624+l3m8xeOqvA7RK0biQO9qBEukuM=
X-Received: by 2002:a19:7110:: with SMTP id m16mr46385000lfc.4.1560468798790;
 Thu, 13 Jun 2019 16:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
 <CAKywueRHrFjuJOxPv=L1H2Ju4_A7SPUQ15VzH8DKn9sh3LeCzw@mail.gmail.com>
 <CAH2r5msPGVUXWytnaUEnks-rTphCStwx706GToCfQkTKi=t9=Q@mail.gmail.com> <CAH2r5msYijupzdYSWC0L_eWxDkHMonvuFT=NpvkyyOAJD6toZA@mail.gmail.com>
In-Reply-To: <CAH2r5msYijupzdYSWC0L_eWxDkHMonvuFT=NpvkyyOAJD6toZA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 13 Jun 2019 16:33:07 -0700
Message-ID: <CAKywueSyw9cxnnG016-=TDxCC4EbTtDs=jGGtNiA8O+UyYN70Q@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix match_server check to allow for multidialect negotiate
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 13 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 12:34, Steve Frenc=
h <smfrench@gmail.com>:
>
> Since this patch - I also fixed the misspelled word 'specifying'
>
> On Thu, Jun 13, 2019 at 2:32 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Updated version with your suggestion - see attached
> >
> > On Mon, Jun 10, 2019 at 1:41 PM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > =D1=81=D0=B1, 8 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 02:06, Steve =
French <smfrench@gmail.com>:
> > > >
> > > > When using multidialect negotiate (default or allowing any smb3
> > > > dialect via vers=3D3)
> > > > allow matching on existing server session.  Before this fix if you =
mount
> > > > a second time to a different share on the same server, we will only=
 reuse
> > > > the existing smb session if a single dialect is requested (e.g. spe=
cifying
> > > > vers=3D2.1 or vers=3D3.0 or vers=3D3.1.1 on the mount command). If =
a default mount
> > > > (e.g. not specifying vers=3D) is done then we will create a new soc=
ket
> > > > connection and SMB3 (or SMB3.1.1) session each time we connect to a
> > > > different share
> > > > on the same server rather than reusing the existing one.
> > > >
> > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > ---
> > > >  fs/cifs/connect.c | 21 +++++++++++++++++++--
> > > >  1 file changed, 19 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > > index 8c4121da624e..6200207565db 100644
> > > > --- a/fs/cifs/connect.c
> > > > +++ b/fs/cifs/connect.c
> > > > @@ -2542,8 +2542,25 @@ static int match_server(struct TCP_Server_In=
fo
> > > > *server, struct smb_vol *vol)
> > > >      if (vol->nosharesock)
> > > >          return 0;
> > > >
> > > > -    /* BB update this for smb3any and default case */
> > > > -    if ((server->vals !=3D vol->vals) || (server->ops !=3D vol->op=
s))
> > > > +    /* If multidialect negotiation see if existing sessions match =
one */
> > > > +    if (strcmp(vol->vals->version_string, SMB3ANY_VERSION_STRING) =
=3D=3D 0) {
> > > > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > > > +            return 0;
> > > > +        else if (server->vals->protocol_id =3D=3D SMB21_PROT_ID)
> > > > +            return 0;
> > > > +        else if (strcmp(server->vals->version_string,
> > > > +             SMB1_VERSION_STRING) =3D=3D 0)
> > > > +            return 0;
> > > > +        /* else SMB3 or later, which is fine */
> > >
> > > May be better to check
> > >
> > > if (server->vals->protocol_id < SMB30_PROT_ID)
> > >     return 0;
> > >
> > > ? SMB1 case should work too because protocol_id is 0.
> > >
> > >
> > > > +    } else if (strcmp(vol->vals->version_string,
> > > > +           SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > > > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > > > +            return 0;
> > > > +        else if (strcmp(server->vals->version_string,
> > > > +             SMB1_VERSION_STRING) =3D=3D 0)
> > > > +            return 0;
> > >
> > > and here the same way:
> > >
> > > if (server->vals->protocol_id < SMB21_PROT_ID)
> > >     return 0;
> > >
> > > > +        /* else SMB2.1 or later, which is fine */
> > > > +    } else if ((server->vals !=3D vol->vals) || (server->ops !=3D =
vol->ops))
> > > >          return 0;
> > > >
> > > >      if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
> > > > --
> > > > 2.20.1
> > >
> > > In this case we can avoid nested IFs - should be cleaner I guess.
> > >
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
