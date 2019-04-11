Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D086BC10F13
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 20:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BDEA20850
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 20:02:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fI+kbDNu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfDKUC0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Apr 2019 16:02:26 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36641 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDKUC0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Apr 2019 16:02:26 -0400
Received: by mail-it1-f193.google.com with SMTP id y10so11684017itc.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2019 13:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=odbhAaiFuN6VMck8KiMn8C2eC5YXyuf4V7h3+cjgiQY=;
        b=fI+kbDNu4bvEgNPBfILgzJ2imvASk2icNsUO/G+mYPFnrjOyg9RGgiyqpagmAPmcRw
         Pe1uBse42z+x/NtvjGsSl5vJ/Q7LVbcSSQKY4q4bAvglOC0aDO3VtNRzdB4bSECsktwK
         SG89rZLniB4dT2q9CdQHRiWbRG1ELFq3FHsBWRKKr2gf7R97s2pmy9p7xe72tJx9udRq
         sQhi6SgppFJb8YUS6xqJgSLyQzitI7abQ8JxRm8BVgZc+Yka9Jcamb7FJSipB/Nu4whm
         u09xj3g60iYKpRnbFi0+MXaWWNZQzX/7EOHj265DatnrxOycjXX4Nsz+j69CoY6a0tur
         zGzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=odbhAaiFuN6VMck8KiMn8C2eC5YXyuf4V7h3+cjgiQY=;
        b=A+VYkfGT+SPtyKayUNyXmg+R3BC+Ga0JTVMtR2EhWaOJyoDce2inYhp5KmGZqub0SC
         MSZwtpjimY6EhHW3RVEhq43H3N51zIhhg+zgpCLILvtS22TKUKFX/22kXFLf8tk3OQCZ
         r+N8UX+SHRLeSg3JAzK0GXlPqvtQEeKjxizkF0z6Je2oum9W+7ClDPYsMWzwvSiqDVKE
         Wxv2P+cnkiTP2l8RiMVq5BUbOqvvYecPX0BAdyA6MpUEjQx22QW3iR4tROywNvNKaeGW
         8jT3mVdBGHk+PA8EZRH3JekrJlxqxwpaROEh1TkslTioJZOJcjpaZEfaNajCJx+m83I3
         02Fg==
X-Gm-Message-State: APjAAAWgkIN4infc3DP/xGDe82mJr8CIpdibSXZAFG2RAldrU3ycsXon
        zxZkVjKUd61JGV9c548b5L9ldZj0ceAhVnIUFhEQJw==
X-Google-Smtp-Source: APXvYqxRkrgnFH2lu6ZTkiY8623tXb2lOgTPFA79dTltP0+JdL4j76c3vQTUgRVTNTfEMv0OwkYuyWw4G3744U4lgMk=
X-Received: by 2002:a24:549:: with SMTP id 70mr8884186itl.108.1555012945410;
 Thu, 11 Apr 2019 13:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022017.24942-1-lsahlber@redhat.com> <20190411022017.24942-2-lsahlber@redhat.com>
 <CAKywueQOJd__BpyF_eki0_KbLvZFYRhtKRkaDo_oWwU6080OYg@mail.gmail.com> <CAH2r5mtvQgiit-s_YQLksOmmcJ5AMb4_uYQNfcm2ubBeZS_Ukg@mail.gmail.com>
In-Reply-To: <CAH2r5mtvQgiit-s_YQLksOmmcJ5AMb4_uYQNfcm2ubBeZS_Ukg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 12 Apr 2019 06:02:14 +1000
Message-ID: <CAN05THQa4KNKSJCU-F6JYf10HxXsWnKvVJSTHeytq8Avjho2jQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add support for FSCTL passthrough that write data
 to the server
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Apr 12, 2019 at 4:57 AM Steve French <smfrench@gmail.com> wrote:
>
> How about this small followon patch to address this?

Looks reasonable.

Reviewed-by me

>
>
> On Thu, Apr 11, 2019 at 12:49 PM Pavel Shilovsky <piastryyy@gmail.com> wr=
ote:
> >
> > =D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:21, Ronnie =
Sahlberg <lsahlber@redhat.com>:
> > >
> > > Add support to pass a blob to the server in FSCTL passthrough.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/smb2ops.c  | 17 +++++++++++++++--
> > >  fs/cifs/smbfsctl.h | 27 +++++++++++++++++++++++++++
> > >  2 files changed, 42 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > index 83a100dd2497..bb7522b882ea 100644
> > > --- a/fs/cifs/smb2ops.c
> > > +++ b/fs/cifs/smb2ops.c
> > > @@ -1382,6 +1382,18 @@ smb2_ioctl_query_info(const unsigned int xid,
> > >         oparms.fid =3D &fid;
> > >         oparms.reconnect =3D false;
> > >
> > > +       /*
> > > +        * FSCTL codes encode the special access they need in the fsc=
tl code.
> > > +        */
> > > +       if (qi.flags & PASSTHRU_FSCTL) {
> > > +               switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
> > > +               case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> > > +                       oparms.desired_access =3D FILE_READ_DATA | FI=
LE_WRITE_DATA | FILE_READ_ATTRIBUTES | SYNCHRONIZE;
> > > +                       ;
> >
> > This extra ":" looks unnecessary. Don't we need to add cases for
> > +#define FSCTL_DEVICE_ACCESS_FILE_ANY_ACCESS        (0x00 << 14)
> > +#define FSCTL_DEVICE_ACCESS_FILE_READ_ACCESS       (0x01 << 14)
> > +#define FSCTL_DEVICE_ACCESS_FILE_WRITE_ACCESS      (0x02 << 14)
> > ?
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
