Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D844C07E9E
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B41E61436
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhGHX2N (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHX2N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:28:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB74BC061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:25:29 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id b2so12636819ejg.8
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rYyKzD+T3flwSWChNVVWaElFtehY14S7KzJVsqnLjl4=;
        b=Tz6EXJgeailnzQtMYptAAUq4WvtidNICQZtgHpImIejdmtwyiEWOPzbkWBzY0Kjgey
         8DV6Dpp/akc4I1e5cQG+iRv0hZF1C9TBnkqc86mbvF0o11206dspedB7/pqtrOF690nN
         hmUqF1AiBpRKkNRPBlqQD6FWEYJDlEajK7dDMGVxVLNkv0p00I+hSB6JsIcCi/DAYcpd
         hG8fiuCr9DwzhGfgKv7pDqIVhopuJAALm7B0g6gxH4R1PPuSFzSL7+vtELPV9zIKm27R
         fI7SX7LgbOc7GgeWcqSwpx01bedud6D5/UDLXc2+FfOC+6cn3SRccb+kx3ne2wjzEF+l
         aZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rYyKzD+T3flwSWChNVVWaElFtehY14S7KzJVsqnLjl4=;
        b=anJh94drs7kahZEVfx8AmLAF7yse3LdGhPg6d8S3I/hJ60/5unlVoHZMNthBH7XSRz
         2QImWgZSN1qeH6Rr0SUGs5WuTWa8npIGdYRS9MMbiR4hyibNGOibLbuN7RCjcwn5KBPc
         Jbsc3uKUnjh0YzhFLbkuPdkzKfDrLM1BYj4PtNoSO0JLqhqX+zkiZ1mHUdwOSncHz53V
         8PavZ4LqKbmml7ra4eO6QGdJwWU7njFEMxJDYL91fOAq1PgosoefAuS2bionD9x9dYgn
         IHF1YcPKQWwEoX9eW4wah6+yGR0dOdI3jpjVYPn02sW8SdnooPqz7lH+ztBWqejFeyCO
         8A2Q==
X-Gm-Message-State: AOAM530HoF5s2H8ic9/18oF8SOjR11iHueUDvjII1l7ekqwDrMTXBd1E
        jqFOqRCYud183En+coDPV6wA3IZBoKxyke6dBoA=
X-Google-Smtp-Source: ABdhPJyI442Or3jFR5AadJGVJXkXRZHi8NoiP60DP8e0I10havzXGtlpQfBaTO+osk3xcK72eMiz8X/cEYyyLe4u8y0=
X-Received: by 2002:a17:907:94d5:: with SMTP id dn21mr32495882ejc.124.1625786728433;
 Thu, 08 Jul 2021 16:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210707232416.2694911-1-lsahlber@redhat.com> <20210707232416.2694911-2-lsahlber@redhat.com>
 <CAKywueSiuJU4YipMtsyf+CYDywSX3ySgMrmsvt9swJT4GkjTZg@mail.gmail.com>
In-Reply-To: <CAKywueSiuJU4YipMtsyf+CYDywSX3ySgMrmsvt9swJT4GkjTZg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 9 Jul 2021 09:25:16 +1000
Message-ID: <CAN05THRzn29As=NO6vNyGyJocuJx4ddiuZeXQ05g2Am6Z+2GjA@mail.gmail.com>
Subject: Re: [PATCH] cifs: use helpers when parsing uid/gid mount options and
 validate them
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 9, 2021 at 8:12 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D1=81=D1=80, 7 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 16:25, Ronnie Sah=
lberg <lsahlber@redhat.com>:
> >
> > Use the nice helpers to initialize and the uid/gid/cred_uid when passed=
 as mount arguments.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/fs_context.c | 24 +++++++++++++++++++-----
> >  fs/cifs/fs_context.h |  1 +
> >  2 files changed, 20 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index 92d4ab029c91..553adfbcc22a 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -322,7 +322,6 @@ smb3_fs_context_dup(struct smb3_fs_context *new_ctx=
, struct smb3_fs_context *ctx
> >         new_ctx->UNC =3D NULL;
> >         new_ctx->source =3D NULL;
> >         new_ctx->iocharset =3D NULL;
> > -
> >         /*
> >          * Make sure to stay in sync with smb3_cleanup_fs_context_conte=
nts()
> >          */
> > @@ -792,6 +791,8 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
> >         int i, opt;
> >         bool is_smb3 =3D !strcmp(fc->fs_type->name, "smb3");
> >         bool skip_parsing =3D false;
> > +       kuid_t uid;
> > +       kgid_t gid;
> >
> >         cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->=
key);
> >
> > @@ -904,18 +905,31 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
> >                 }
> >                 break;
> >         case Opt_uid:
> > -               ctx->linux_uid.val =3D result.uint_32;
> > +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> > +               if (!uid_valid(uid))
> > +                       goto cifs_parse_mount_err;
> > +               ctx->linux_uid =3D uid;
> >                 ctx->uid_specified =3D true;
> >                 break;
> >         case Opt_cruid:
> > -               ctx->cred_uid.val =3D result.uint_32;
> > +               uid =3D make_kuid(current_user_ns(), result.uint_32);
> > +               if (!uid_valid(uid))
> > +                       goto cifs_parse_mount_err;
> > +               ctx->cred_uid =3D uid;
> > +               ctx->cruid_specified =3D true;
> >                 break;
> >         case Opt_backupgid:
> > -               ctx->backupgid.val =3D result.uint_32;
> > +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> > +               if (!gid_valid(gid))
> > +                       goto cifs_parse_mount_err;
> > +               ctx->backupgid =3D gid;
> >                 ctx->backupgid_specified =3D true;
> >                 break;
> >         case Opt_gid:
> > -               ctx->linux_gid.val =3D result.uint_32;
> > +               gid =3D make_kgid(current_user_ns(), result.uint_32);
> > +               if (!gid_valid(gid))
> > +                       goto cifs_parse_mount_err;
> > +               ctx->linux_gid =3D gid;
> >                 ctx->gid_specified =3D true;
> >                 break;
> >         case Opt_port:
> > diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> > index 2a71c8e411ac..b6243972edf3 100644
> > --- a/fs/cifs/fs_context.h
> > +++ b/fs/cifs/fs_context.h
> > @@ -155,6 +155,7 @@ enum cifs_param {
> >
> >  struct smb3_fs_context {
> >         bool uid_specified;
> > +       bool cruid_specified;
>
> Is it going to be used somewhere?

I use it in other patches,  and may add a similar variable to the
session structure as well so we can change the code where we print the
mount argument and make it conditional on whether cruid was set on the
original command line or not.
We currently always print cruid as a mount argument in the mount
output and print it as cruid=3D0 if it was not specified, which is fine
but may be confusing/redundant.

I am fine with either leaving it in or removing it, and I can add it
back later once it actually starts being used.

>
> >         bool gid_specified;
> >         bool sloppy;
> >         bool got_ip;
> > --
> > 2.30.2
> >
>
> Acked-by: Pavel Shilovsky <pshilovsky@samba.org>
>
> --
> Best regards,
> Pavel Shilovsky
