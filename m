Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1060EC7618F
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 19:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC5A221019
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 19:16:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5/jeRnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391148AbfGRTQs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 15:16:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43577 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbfGRTQs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Jul 2019 15:16:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id y17so3870209ljk.10
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jul 2019 12:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rx+6w8XptityNCdEgx5pTTlMbRzV7PLUr2FP+Exj/Ww=;
        b=Z5/jeRnwo3XyLf+X3ZoKp2KbGfNINKZGquH7fYcG7EGQFMSJ1My27nSwMVVu0XXE81
         uqP1mQuYHpHkl3fxryZ519UD7PnNFz8O8BVpXymgPmU3TWYCuq8QSUh8eMO4BsThgpjn
         9drGnDxFU4+kWg3CgMD8qFLE76kyMCWdYDqhIMTTfRm50bWu9bIyoUyyD3zTXnP25LY5
         IExaS5kOlf6SGFvvnR61QuhnMUYuR4mNPK+n1qkMBm1r4r/g2BWlIPYE94wn/025TVaA
         7oDxRKPfFimE3su3jQRBA8wXI8AV7YbeXWfSbiXox5MCcyil2NdY+SWjwRJsrv4WPALF
         aDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rx+6w8XptityNCdEgx5pTTlMbRzV7PLUr2FP+Exj/Ww=;
        b=r9oHHxapvF7dQet1RhKIBAtqyLUK9nE2QCGE7MCeisoxSUBldsoUJVy0LJ0plJ/xDY
         wDxdZP4irSty1wjRgaYo4c961xghdwWOanKXS/ab/bBg0MtzqhSKpqltEUTSFaUoSgel
         fPTo9nqci5MzDam9UCc4TNQIhQsQIT+I8lJjwxIkxK+fDpO0XDMyWbUvJKlxu/P7fitX
         FGhQrUI5wjMdZ/abT46ViRuwEjT1IGCMDHlWj9IgkTz3Q8fHy8RusaARsx9ffzg09f8h
         HiOEPuPADnHVMmx+Df/Zc+eCUH+NXhKg3LgOTGOo52SWT+5Okti9usQZanuU1CPHlPOo
         /6gA==
X-Gm-Message-State: APjAAAXauDeCweHJaEyb5z+BZbXdQ28PfRoq+D7QdvigHfkxi+qNXDIR
        5UlYqidW9la0Rat9BwL3GA5wG5jIRuHh0H405q0P
X-Google-Smtp-Source: APXvYqxXl7Cu8GUcPGMjyavqcwmw+SmdIOB5sgUavusLwqrHG7iC3Wv7lFBqrI9QMl4LvYt1JnvUA50/G8ABVne0inQ=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr17585296ljq.184.1563477406566;
 Thu, 18 Jul 2019 12:16:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtn5SyUao9Y3f-_ubqgSV8t3RSj2fzAR9bE5ZQQ5dFcRQ@mail.gmail.com>
 <CAKywueQEk84q-3PNNvGQNYLc9DXfygy+75LNBfyTKRo-iFvmGw@mail.gmail.com> <CAH2r5mu4y69J4ChFhbejFhG50P5CnKLwKRUAZZ+C+aMx09Qg2Q@mail.gmail.com>
In-Reply-To: <CAH2r5mu4y69J4ChFhbejFhG50P5CnKLwKRUAZZ+C+aMx09Qg2Q@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Thu, 18 Jul 2019 12:16:35 -0700
Message-ID: <CAKywueQbwNiQsn70-Meu46pyGUCncYDKYLRD7SnyzqoAddGmUQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Speed up open by skipping query FILE_INTERNAL_INFORMATION
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is good improvement at almost no cost! We should definitely get
this functionality in!

Best regards,
Pavel Shilovskiy

=D1=87=D1=82, 18 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 11:46, Steve Frenc=
h <smfrench@gmail.com>:
>
> Also fyi - did some experiments today.  Perf across the open vfs entry
> point averaged about 20% better with the patch
>
> On Thu, Jul 18, 2019 at 12:37 PM Pavel Shilovsky
> <pavel.shilovsky@gmail.com> wrote:
> >
> > index 54bffb2a1786..e6a1fc72018f 100644
> > --- a/fs/cifs/smb2file.c
> > +++ b/fs/cifs/smb2file.c
> > @@ -88,14 +88,20 @@ smb2_open_file(const unsigned int xid, struct
> > cifs_open_parms *oparms,
> >   }
> >
> >   if (buf) {
> > - /* open response does not have IndexNumber field - get it */
> > - rc =3D SMB2_get_srv_num(xid, oparms->tcon, fid->persistent_fid,
> > + /* if open response does not have IndexNumber field - get it */
> > + if (smb2_data->IndexNumber =3D=3D 0) {
> >
> > What's about a server returning 0 for the IndexNumber?
> >
> > - if (rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE)
> > - *oplock =3D smb2_parse_lease_state(server, rsp,
> > - &oparms->fid->epoch,
> > - oparms->fid->lease_key);
> > - else
> > +
> > + *oplock =3D smb2_parse_contexts(server, rsp, &oparms->fid->epoch,
> > +       oparms->fid->lease_key,
> > +       buf);
> > + if (*oplock =3D=3D 0) /* no lease open context found */
> >   *oplock =3D rsp->OplockLevel;
> >
> > oplock being 0 here probably means that the lease state which is
> > granted is NONE. You still need to keep if (rsp->OplockLevel =3D=3D
> > SMB2_OPLOCK_LEVEL_LEASE) gate.
> >
> >  /* See MS-SMB2 2.2.14.2.9 */
> >  struct on_disk_id {
> >
> > Please prefix the structure name with "create_".
> >
> > Best regards,
> > Pavel Shilovskiy
> >
> > =D1=87=D1=82, 18 =D0=B8=D1=8E=D0=BB. 2019 =D0=B3. =D0=B2 00:43, Steve F=
rench via samba-technical
> > <samba-technical@lists.samba.org>:
> > >
> > > Now that we have the qfid context returned on open we can cut 1/3 of
> > > the traffic on open by not sending the query FILE_INTERNAL_INFORMATIO=
N
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
