Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23676C77B6E
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Apr 2023 01:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjDJBhl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Apr 2023 21:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJBhk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Apr 2023 21:37:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD5826B1
        for <linux-cifs@vger.kernel.org>; Sun,  9 Apr 2023 18:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681090617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=75dgOwEhY5WNPNjMS9XwJ+E4Ir6IzVhLdrPThF1GqJE=;
        b=PX63ll5RVz6kA1oE0RZ3QfepyneJFbuCQ6fdnQ6vH3uKxjQCbHxd0ERsBV0mZJbp9qPhBl
        msZF+VFUYyT/rnxo6wRm1UZWKpG+3YVSfTm3n/KwUSDomgooQKz14XrHXz1vpc8a0Ca0Q5
        q37pwxKHNEIZv6iFTp3g3hUwbJTYZJ0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-KUjMvwhNNiybs0imQ1on_g-1; Sun, 09 Apr 2023 21:36:55 -0400
X-MC-Unique: KUjMvwhNNiybs0imQ1on_g-1
Received: by mail-qt1-f199.google.com with SMTP id y5-20020a05622a004500b003e3979be6abso3144886qtw.12
        for <linux-cifs@vger.kernel.org>; Sun, 09 Apr 2023 18:36:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681090615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75dgOwEhY5WNPNjMS9XwJ+E4Ir6IzVhLdrPThF1GqJE=;
        b=qJP5ww+wapGQndPHOiNTylESTNfAKPjKOoWhjW7XpoTu7BDigs7VnMp/aXk8XlFpJx
         YWX0EEwTKRSYNqpWdl53hG7cJxNAM3q0ip/gkIkHqaKIo8pqdLr8RuZo8q0fSFPT7EKy
         wOTF0WZ0rYgcq2nWUPteuDyWSqTtAjFrtzLSx+f1+Em8JWon/yhkPWAVGztHoteprQnT
         NBF+TSltRZLvOdnwlkYDmqCs6vbnYs1PUkqXwDMegCOwr+tWf+F7QSQyOlJnRvo7nx95
         d0U3FJ3brM0DN6MXPr05CaxpqebcP2/7LGeggf2euE2U6v6vxzO4Txji2RxAjRQ0jofB
         GHAA==
X-Gm-Message-State: AAQBX9deOFQ7NvIWRNLg3k/9sbYICtow/RTTQe+5JPVYXOJ7gjBK2GlM
        9M379g2+KapzODVBjMe6r7NOnKMWPc2+aAMKfIidjzfr5KhHxbtU4OhyRQXhbXjdy6/ewXPBuL3
        LT2CIiAIO6zGS8lh2SwFeW55vzVHJ6RFUxHHjaQ==
X-Received: by 2002:a05:622a:1b8a:b0:3e6:71d6:5d66 with SMTP id bp10-20020a05622a1b8a00b003e671d65d66mr2950770qtb.8.1681090615358;
        Sun, 09 Apr 2023 18:36:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350YZxLilYVPW53TAnmAqmAOEQjA4EYXmWoNZ8NMYx0jGNHFm4dkEVjpcOHA5LgsKKk5NcOzLNva0dAzBXrwzAEo=
X-Received: by 2002:a05:622a:1b8a:b0:3e6:71d6:5d66 with SMTP id
 bp10-20020a05622a1b8a00b003e671d65d66mr2950766qtb.8.1681090615052; Sun, 09
 Apr 2023 18:36:55 -0700 (PDT)
MIME-Version: 1.0
References: <1efcd842-b6a3-353a-0bf9-3ebf890eb712@redhat.com> <CAN05THRJb_4edm9Hne1yY3D6VvtQ=CbYn+KhVy7Xw=i4GE-c+w@mail.gmail.com>
In-Reply-To: <CAN05THRJb_4edm9Hne1yY3D6VvtQ=CbYn+KhVy7Xw=i4GE-c+w@mail.gmail.com>
From:   Takayuki Nagata <tnagata@redhat.com>
Date:   Mon, 10 Apr 2023 10:36:44 +0900
Message-ID: <CANFaLqGJC2mvS58rDc_ux=f9OpR-faM5i0rPyCuwexY7mvg+XA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: reinstate original behavior again for forceuid/forcegid
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I do not think that forceuid is meaningful without uid=3D, because the admi=
n
does not intend to override uid for files on the share. So specifying force=
uid
without uid=3D shows "ignoring forceuid mount option specified with no
uid=3D option",
and forceuid is disabled (=3Dnoforceuid is enabled). Then any uid provided =
by
the server should be used for the files if the server provides it.

Takayuki Nagata

2023=E5=B9=B44=E6=9C=887=E6=97=A5(=E9=87=91) 19:14 ronnie sahlberg <ronnies=
ahlberg@gmail.com>:
>
> Looks good.
> The question arises, are there any situations where forceuid is
> meaningful without uid=3D argument and what would it mean?
>
> On Fri, 7 Apr 2023 at 15:09, Takayuki Nagata <tnagata@redhat.com> wrote:
> >
> > forceuid/forcegid should be enabled by default when uid=3D/gid=3D optio=
ns are
> > specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
> > changed the behavior. Due to the change, a mounted share does not show
> > intentional uid/gid for files and directories even though uid=3D/gid=3D
> > options are specified since forceuid/forcegid are not enabled.
> >
> > This patch reinstates original behavior that overrides uid/gid with
> > specified uid/gid by the options.
> >
> > Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> > Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
> > Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Acked-by: Tom Talpey <tom@talpey.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> > V1 -> V2: Revised commit message to clarify "what breaks".
> >
> >  fs/cifs/fs_context.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index ace11a1a7c8a..6f7c5ca3764f 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_co=
ntext *fc,
> >                         goto cifs_parse_mount_err;
> >                 ctx->linux_uid =3D uid;
> >                 ctx->uid_specified =3D true;
> > +               ctx->override_uid =3D 1;
> >                 break;
> >         case Opt_cruid:
> >                 uid =3D make_kuid(current_user_ns(), result.uint_32);
> > @@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_=
context *fc,
> >                         goto cifs_parse_mount_err;
> >                 ctx->linux_gid =3D gid;
> >                 ctx->gid_specified =3D true;
> > +               ctx->override_gid =3D 1;
> >                 break;
> >         case Opt_port:
> >                 ctx->port =3D result.uint_32;
> > --
> > 2.40.0
> >
>

