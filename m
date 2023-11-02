Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BEFC4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Nov 2023 12:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347452AbjKBMbB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Nov 2023 08:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347477AbjKBMa6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Nov 2023 08:30:58 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C448A198
        for <linux-cifs@vger.kernel.org>; Thu,  2 Nov 2023 05:30:55 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c5720a321aso11649331fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Nov 2023 05:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698928254; x=1699533054; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZM4eNDeCWA8zTTgOcbEk9SILxrnFERjBHFgYRsyxKmE=;
        b=ZV+JjoorivJO2wrhaGsan9O5EbhoFhrRARxIEa/mIbGVBtrutj9RPB6kitWo/2LUPI
         Vj+Sk6Tu6mpEtt5FSKbFBbkEf32aaqo0aIPMvEOXp1Shh7geUeTliVm764LmwgGasLjA
         n41NBud/kD7o0ii9sao22vgfHqLokooJSIi0MEG2a1ENZceHloZ10cHPqAqmH+lds9Ii
         NjwnkNs0LF/XRieNN5oD8jEouy6HEs2LCyl2YmSABAs26WNZ2HPkYFHv0sIcZlDbvWpE
         nMWSXS2zTXiDzUemumm2hKmUiiUvT46hw5mH2Ww0gp4Yb3T95UDDANO5+7TKKWztrxBi
         Aagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698928254; x=1699533054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZM4eNDeCWA8zTTgOcbEk9SILxrnFERjBHFgYRsyxKmE=;
        b=uyJu2zSWMjcMrIEbPaBTFybPvYYzwasevaoDFCjPvW59nW2t/ts/UkBFsXYnJpBZqM
         DA0+A/bcQ2OI/1xCKrGcEwaXCCf7voThdvJXFdnZtNWPzzg7gtTnVqrgvvZ1BlMUDP3k
         rxbs4atBhVy8e44vlTFJa68As2qYY7WM0j+aXGxply2FBj6Yc3Zpm7sQhNpVDcPkEsZO
         FlJwUa1ODDLTuT4Cz+ndqm00vmMdDGshgr+DljHCdBGliclx+vIxoDtL7Gaw02KYZKkr
         AEnM1lFBt1KDdPUZSMpq/wDiRSktdKsOmHS6CnwSbjnFCqW4r55Ool+TKSJVInypLaaC
         NFNA==
X-Gm-Message-State: AOJu0Yzwz6WpVjyyE7JaSnV/4aDoZ7KZwcVWLCO40/34K1j0R2V9WiI2
        bJoF5+h/D/s+iE8dYKPkHlF3P3v7SBacWIPqSEM=
X-Google-Smtp-Source: AGHT+IFEKraquRQcM+oZPseapLuTF3sXqsS6LRpYyRSZppnvfj8P6Nw6ZdqqgBHuUd8WNwcR68PUVioV98NaEqjz6hY=
X-Received: by 2002:a2e:3e1a:0:b0:2bf:ab17:d48b with SMTP id
 l26-20020a2e3e1a000000b002bfab17d48bmr15478772lja.34.1698928253556; Thu, 02
 Nov 2023 05:30:53 -0700 (PDT)
MIME-Version: 1.0
References: <20231030201956.2660-1-pc@manguebit.com> <CAH2r5msgiaECqxROb04g9FHGxe5ZWawZRbmUzmPqJW4DcKGSmA@mail.gmail.com>
In-Reply-To: <CAH2r5msgiaECqxROb04g9FHGxe5ZWawZRbmUzmPqJW4DcKGSmA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 2 Nov 2023 18:00:42 +0530
Message-ID: <CANT5p=oK6XSKMbb0KxiYxzbCLpfuRnciDdBU4NV=sbbO9hv+Lg@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: remove extra @chan_count check in __cifs_put_smb_ses()
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 31, 2023 at 8:54=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> tentatively merged into cifs-2.6.git for-next pending review/testing
>
> On Mon, Oct 30, 2023 at 3:20=E2=80=AFPM Paulo Alcantara <pc@manguebit.com=
> wrote:
> >
> > If @ses->chan_count <=3D 1, then for-loop body will not be executed so
> > no need to check it twice.
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> > ---
> >  fs/smb/client/connect.c | 23 +++++++++--------------
> >  1 file changed, 9 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 7b923e36501b..a017ee552256 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1969,9 +1969,10 @@ cifs_find_smb_ses(struct TCP_Server_Info *server=
, struct smb3_fs_context *ctx)
> >
> >  void __cifs_put_smb_ses(struct cifs_ses *ses)
> >  {
> > -       unsigned int rc, xid;
> > -       unsigned int chan_count;
> >         struct TCP_Server_Info *server =3D ses->server;
> > +       unsigned int xid;
> > +       size_t i;
> > +       int rc;
> >
> >         spin_lock(&ses->ses_lock);
> >         if (ses->ses_status =3D=3D SES_EXITING) {
> > @@ -2017,20 +2018,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >         list_del_init(&ses->smb_ses_list);
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> > -       chan_count =3D ses->chan_count;
> > -
> >         /* close any extra channels */
> > -       if (chan_count > 1) {
> > -               int i;
> > -
> > -               for (i =3D 1; i < chan_count; i++) {
> > -                       if (ses->chans[i].iface) {
> > -                               kref_put(&ses->chans[i].iface->refcount=
, release_iface);
> > -                               ses->chans[i].iface =3D NULL;
> > -                       }
> > -                       cifs_put_tcp_session(ses->chans[i].server, 0);
> > -                       ses->chans[i].server =3D NULL;
> > +       for (i =3D 1; i < ses->chan_count; i++) {
> > +               if (ses->chans[i].iface) {
> > +                       kref_put(&ses->chans[i].iface->refcount, releas=
e_iface);
> > +                       ses->chans[i].iface =3D NULL;
> >                 }
> > +               cifs_put_tcp_session(ses->chans[i].server, 0);
> > +               ses->chans[i].server =3D NULL;
> >         }
> >
> >         sesInfoFree(ses);
> > --
> > 2.42.0
> >
>
>
> --
> Thanks,
>
> Steve

Looks good to me.
You can add my RB.

--=20
Regards,
Shyam
