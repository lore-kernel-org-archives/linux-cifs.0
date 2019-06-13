Return-Path: <SRS0=0jCz=UM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C5AC31E45
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 19:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0261A2147A
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jun 2019 19:34:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F5HSuzZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728804AbfFMTeo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jun 2019 15:34:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37029 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfFMTeo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jun 2019 15:34:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh12so8567678plb.4
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jun 2019 12:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xRaW1S7o1g60mJUxLPzjAGd6ZHjbQ7soCFNMzlD8hfQ=;
        b=F5HSuzZFgZH1Vuf1DQzeBUtXeIbIHArxcB2ZWuBXYTnXQBeBDzjBEqTlKTtUCQKL0G
         h3F+QU5OHXySrEPF0s/nntwSgwE6t+d/rLBd6nT2DPEGMx4WrNfLxF8MP8c2UK8bMNQx
         LGOfxO6MpkNgM6JV8mOdjtMY2PIwh/mR213VTaLgNxXQQm8saN8I7FXNQcwSNY1tmvrW
         HP0Wx4Lb6dglYLmWHbuo3Ww4XFsYSFNm9sQaQzP+h8K9PhA2+76h9LasXV5QNhw0ES97
         uZOwC3W9Enp3cJhAj4r92kWiUCpE4Fr4YZh6K0QePoqHXPEOUZYyKB/bl2YxD3tyfG2o
         O1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xRaW1S7o1g60mJUxLPzjAGd6ZHjbQ7soCFNMzlD8hfQ=;
        b=O/jNqcXeMKISH5mbWEtNts7sN2/IMx86LrUfzqeO75IIs78L99k2bNR36Sb22Bcykg
         h358Tu3bzHZa3tJDfNM+CDOwg9QkXcTzvNq52voqW0TngudqHUyD0PtuAZhqaPuBozOF
         +UhFy/fPZQeK84Cqr+/cHMw1jN9l/1OmAPGRlA+uigC77S1pGNZ9fwNygM5ESx1Eoze3
         4cFPrlT11dtpnaTPnQfqzyZfCWxOAq+Eed/pFDYuMpnoH9UjexI4V9B5OolJX6Xu9rIN
         ievZjciMLRyPv9a1hLbP5AO4kzy7MUP6EDaVH/z3Ql+5fw2XaMQCGVFqwu45WYXFV9Y/
         kFng==
X-Gm-Message-State: APjAAAXLy9E9iJgRnNPWDqAWMrPCohKpDk8n6nQc4KEKwhNBDPajMUz1
        kd9M5GUHtiuIzkTqKPsBfspjXTzt9F5PLbrarb4=
X-Google-Smtp-Source: APXvYqz9NPMOEFhO82DqYboNmdK2Z6nkL3hkKiSXj8s28ESxvt1zDD0CZ+6cvhl6cmQXf9Y6uZB0UegP3ayzpzjbAzU=
X-Received: by 2002:a17:902:2a68:: with SMTP id i95mr90809089plb.167.1560454483717;
 Thu, 13 Jun 2019 12:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvRQj1hyDbBY8DTMtDShr2uxmJqYWWJg+H=iO3RUDc3oQ@mail.gmail.com>
 <CAKywueRHrFjuJOxPv=L1H2Ju4_A7SPUQ15VzH8DKn9sh3LeCzw@mail.gmail.com> <CAH2r5msPGVUXWytnaUEnks-rTphCStwx706GToCfQkTKi=t9=Q@mail.gmail.com>
In-Reply-To: <CAH2r5msPGVUXWytnaUEnks-rTphCStwx706GToCfQkTKi=t9=Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 Jun 2019 14:34:32 -0500
Message-ID: <CAH2r5msYijupzdYSWC0L_eWxDkHMonvuFT=NpvkyyOAJD6toZA@mail.gmail.com>
Subject: Re: [PATCH][CIFS] Fix match_server check to allow for multidialect negotiate
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since this patch - I also fixed the misspelled word 'specifying'

On Thu, Jun 13, 2019 at 2:32 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated version with your suggestion - see attached
>
> On Mon, Jun 10, 2019 at 1:41 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D1=81=D0=B1, 8 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 02:06, Steve Fr=
ench <smfrench@gmail.com>:
> > >
> > > When using multidialect negotiate (default or allowing any smb3
> > > dialect via vers=3D3)
> > > allow matching on existing server session.  Before this fix if you mo=
unt
> > > a second time to a different share on the same server, we will only r=
euse
> > > the existing smb session if a single dialect is requested (e.g. speci=
fying
> > > vers=3D2.1 or vers=3D3.0 or vers=3D3.1.1 on the mount command). If a =
default mount
> > > (e.g. not specifying vers=3D) is done then we will create a new socke=
t
> > > connection and SMB3 (or SMB3.1.1) session each time we connect to a
> > > different share
> > > on the same server rather than reusing the existing one.
> > >
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/connect.c | 21 +++++++++++++++++++--
> > >  1 file changed, 19 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index 8c4121da624e..6200207565db 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -2542,8 +2542,25 @@ static int match_server(struct TCP_Server_Info
> > > *server, struct smb_vol *vol)
> > >      if (vol->nosharesock)
> > >          return 0;
> > >
> > > -    /* BB update this for smb3any and default case */
> > > -    if ((server->vals !=3D vol->vals) || (server->ops !=3D vol->ops)=
)
> > > +    /* If multidialect negotiation see if existing sessions match on=
e */
> > > +    if (strcmp(vol->vals->version_string, SMB3ANY_VERSION_STRING) =
=3D=3D 0) {
> > > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > > +            return 0;
> > > +        else if (server->vals->protocol_id =3D=3D SMB21_PROT_ID)
> > > +            return 0;
> > > +        else if (strcmp(server->vals->version_string,
> > > +             SMB1_VERSION_STRING) =3D=3D 0)
> > > +            return 0;
> > > +        /* else SMB3 or later, which is fine */
> >
> > May be better to check
> >
> > if (server->vals->protocol_id < SMB30_PROT_ID)
> >     return 0;
> >
> > ? SMB1 case should work too because protocol_id is 0.
> >
> >
> > > +    } else if (strcmp(vol->vals->version_string,
> > > +           SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> > > +        if (server->vals->protocol_id =3D=3D SMB20_PROT_ID)
> > > +            return 0;
> > > +        else if (strcmp(server->vals->version_string,
> > > +             SMB1_VERSION_STRING) =3D=3D 0)
> > > +            return 0;
> >
> > and here the same way:
> >
> > if (server->vals->protocol_id < SMB21_PROT_ID)
> >     return 0;
> >
> > > +        /* else SMB2.1 or later, which is fine */
> > > +    } else if ((server->vals !=3D vol->vals) || (server->ops !=3D vo=
l->ops))
> > >          return 0;
> > >
> > >      if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
> > > --
> > > 2.20.1
> >
> > In this case we can avoid nested IFs - should be cleaner I guess.
> >
> >
> > --
> > Best regards,
> > Pavel Shilovsky
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
