Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E7CC07E96
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 00:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C49061404
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 00:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhGIAXE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 20:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhGIAXD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 20:23:03 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A876CC061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 17:20:20 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u18so9955539lfl.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 17:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3aaDIfzK8wfk0E7LcklJet7AvIIG3ts8Fc7Z5W8KeLE=;
        b=WdhjXagB74J1ulowpUbhbtN5nMvzptz1EQf4Nyv4PZXkTAi6ENMdIese6OPX3DaAGX
         20Q1EshVRgAp7ENmpcUxsnYE8gI/gXb6kmd86IwktHWgN2Kv++EhxsLNrYe58CDW5lQd
         xwzzDyFnAbl14f6DmDXf+ptSibmlDCBeLsbd2sH+W4MQTGz2RKmvdvbY6XjGu8qVrN7W
         LZjiHyE/tOI+ylFiiDpWiaDbpZI7NK3AuR2A5GQelyD0muZKWya59OUxXstA42adrn5T
         L09RAYuT5L8+NH5BrPciFSx2AmcUJ5mvnG/ON1yuYAj8VZBess8UiiiYh5aiwget3lbf
         wWAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3aaDIfzK8wfk0E7LcklJet7AvIIG3ts8Fc7Z5W8KeLE=;
        b=Y8T0IeI3sqULQa2xgWG8UegKldZByhQORFh8gr7tComduglJoMrmeLw1aDLTbHqu1Z
         KyD6mN2wkDX0OGmtjaWPeQr6AVRGOo5gco6XpbS6zToZ+3VDlTqDrxP0Zx6QnyGISaLp
         HY4PPmitC+yZtbrr2Zw+lHKml342NpSdT6linAY72KrsqmZRc525rWwL5L5whbsU3T22
         IxSPv/pS4azkjXIb9bSeQDfv5dN2cUv8uYBAUZF7a8JoDXrrU7URaG+25ZwGMvG3aujI
         4dfF1y9PL2bukEMFuDoyk6fzGB02Tz9hJ09slw3n8oKUKqsz6XNjAp+PMpgwFnyPoRJV
         81Iw==
X-Gm-Message-State: AOAM5328B8aPuWS9JzKrK0AjOZagzMbPJWMOT4feuLe6723o5vmJH67/
        SlA/7mSCqqNNu6BvTZZJYmqv6jWeSonDzdyFzWQ=
X-Google-Smtp-Source: ABdhPJx24Mld4SVouRScG3s5zJTKvrqSUxGUOxe8O9uLu5wX+8g3LrPPPiQxFSFU/nBQJo6jtf0yrH1JQywQxEIs3hg=
X-Received: by 2002:a05:6512:114c:: with SMTP id m12mr7062473lfg.395.1625790018287;
 Thu, 08 Jul 2021 17:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210707232416.2694911-1-lsahlber@redhat.com> <20210707232416.2694911-2-lsahlber@redhat.com>
 <CAKywueSiuJU4YipMtsyf+CYDywSX3ySgMrmsvt9swJT4GkjTZg@mail.gmail.com> <CAN05THRzn29As=NO6vNyGyJocuJx4ddiuZeXQ05g2Am6Z+2GjA@mail.gmail.com>
In-Reply-To: <CAN05THRzn29As=NO6vNyGyJocuJx4ddiuZeXQ05g2Am6Z+2GjA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Jul 2021 19:20:05 -0500
Message-ID: <CAH2r5mvFmSx=E-bc+yfahj2EwuRhcsohUbX+XO0-n2M-p0SxvA@mail.gmail.com>
Subject: Re: [PATCH] cifs: use helpers when parsing uid/gid mount options and
 validate them
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

mildy easier to leave it in at the moment - if you want to remove it
later with a followon that is fine too

On Thu, Jul 8, 2021 at 6:25 PM ronnie sahlberg <ronniesahlberg@gmail.com> w=
rote:
>
> On Fri, Jul 9, 2021 at 8:12 AM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
> >
> > =D1=81=D1=80, 7 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 16:25, Ronnie S=
ahlberg <lsahlber@redhat.com>:
> > >
> > > Use the nice helpers to initialize and the uid/gid/cred_uid when pass=
ed as mount arguments.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/fs_context.c | 24 +++++++++++++++++++-----
> > >  fs/cifs/fs_context.h |  1 +
> > >  2 files changed, 20 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > > index 92d4ab029c91..553adfbcc22a 100644
> > > --- a/fs/cifs/fs_context.c
> > > +++ b/fs/cifs/fs_context.c
> > > @@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_c=
tx, struct smb3_fs_context *ctx
> > >         new_ctx->UNC =3D NULL;
> > >         new_ctx->source =3D NULL;
> > >         new_ctx->iocharset =3D NULL;
> > > -
> > >         /*
> > >          * Make sure to stay in sync with smb3_cleanup_fs_context_con=
tents()
> > >          */
> > > @@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
> > >         int i, opt;
> > >         bool is_smb3 =3D !strcmp(fc->fs_type->name, "smb3");
> > >         bool skip_parsing =3D false;
> > > +       kuid_t uid;
> > > +       kgid_t gid;
> > >
> > >         cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param=
->key);
> > >
> > > @@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct f=
s_context *fc,
> > >                 }
> > >                 break;
> > >         case Opt_uid:
> > > -               ctx->linux_uid.val =3D result.uint_32;
> > > +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> > > +               if (!uid_valid(uid))
> > > +                       goto cifs_parse_mount_err;
> > > +               ctx->linux_uid =3D uid;
> > >                 ctx->uid_specified =3D true;
> > >                 break;
> > >         case Opt_cruid:
> > > -               ctx->cred_uid.val =3D result.uint_32;
> > > +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> > > +               if (!uid_valid(uid))
> > > +                       goto cifs_parse_mount_err;
> > > +               ctx->cred_uid =3D uid;
> > > +               ctx->cruid_specified =3D true;
> > >                 break;
> > >         case Opt_backupgid:
> > > -               ctx->backupgid.val =3D result.uint_32;
> > > +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> > > +               if (!gid_valid(gid))
> > > +                       goto cifs_parse_mount_err;
> > > +               ctx->backupgid =3D gid;
> > >                 ctx->backupgid_specified =3D true;
> > >                 break;
> > >         case Opt_gid:
> > > -               ctx->linux_gid.val =3D result.uint_32;
> > > +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> > > +               if (!gid_valid(gid))
> > > +                       goto cifs_parse_mount_err;
> > > +               ctx->linux_gid =3D gid;
> > >                 ctx->gid_specified =3D true;
> > >                 break;
> > >         case Opt_port:
> > > diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> > > index 2a71c8e411ac..b6243972edf3 100644
> > > --- a/fs/cifs/fs_context.h
> > > +++ b/fs/cifs/fs_context.h
> > > @@ -155,6 +155,7 @@ enum cifs_param {
> > >
> > >  struct smb3_fs_context {
> > >         bool uid_specified;
> > > +       bool cruid_specified;
> >
> > Is it going to be used somewhere?
>
> I use it in other patches,  and may add a similar variable to the
> session structure as well so we can change the code where we print the
> mount argument and make it conditional on whether cruid was set on the
> original command line or not.
> We currently always print cruid as a mount argument in the mount
> output and print it as cruid=3D0 if it was not specified, which is fine
> but may be confusing/redundant.
>
> I am fine with either leaving it in or removing it, and I can add it
> back later once it actually starts being used.
>
> >
> > >         bool gid_specified;
> > >         bool sloppy;
> > >         bool got_ip;
> > > --
> > > 2.30.2
> > >
> >
> > Acked-by: Pavel Shilovsky <pshilovsky@samba.org>
> >
> > --
> > Best regards,
> > Pavel Shilovsky



--=20
Thanks,

Steve
