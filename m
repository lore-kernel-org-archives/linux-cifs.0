Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C07C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 20:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0A9206EC
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 20:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgLHUnZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgLHUnZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 15:43:25 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B924C0613CF
        for <linux-cifs@vger.kernel.org>; Tue,  8 Dec 2020 12:42:39 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id s11so13214981ljp.4
        for <linux-cifs@vger.kernel.org>; Tue, 08 Dec 2020 12:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ft01ixDjhdMXYC7Mgsod0M++OXFzXUTcyJAuNtzcj70=;
        b=M2vRBqyC+SNxzdDbjKQdrgSdhld8cFgPZkIp9nsf8Epp8gHnFQBoIAjEVXhnntqLwz
         z3YY4tdrh+olh5qftyl+TR92xTWZf3L+KkM8O3qnIEGKIMu+W1zs92QGalKckj8TxPpl
         iyV6dY13RznL739jOa6PLnYN29uyP8XNC700gNfH62fWc8ogV9BNkXILMUb8tWevUWZU
         ZtziSZna1f89P1z4XT2U0pBepXu9wog4/fw9rRbPjXdY/7aoKQi+2m60AKCF0zZnVbCF
         puFW0VS8Nstz0B6DuxAMYRSm13fDVBfyck+BFuuzGyBfLTZ+UnY9z+nZbFsKX4nlUwZG
         I3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ft01ixDjhdMXYC7Mgsod0M++OXFzXUTcyJAuNtzcj70=;
        b=lFzRarnsTP926eojlTC3Ebp0sun6LrTt73kXX5hFScNVC+PY2SAHSLwYktLfkd/3sz
         u1kByFQoWlmumjpPMm+Ld2sUsLiXJYukRF/uLyCMtiEZAvYZOelKDKcDy7TlzL2BxHVo
         EMu9Y5ZCRyrtWzHhQGu4Kyf/0fbbOs0Yb9NoFhpYyotEfVgkys1IQ9f9By+Mz2XW+41u
         pWsxSsyi6Lj+MAjDTqtEhZm/OS7U/7VGwJPhOrZmQ7gtNjC2AM2lK9m2P7rS7YZhwsk0
         OQYdaqfzlOpmJM8Ky2setj7Aj1jO7jxZPunlMN5XtZXaCo6FEsbqNpyBTrGm68js+z05
         t0Xg==
X-Gm-Message-State: AOAM530KXq6zhV8kru7UBOZW3g5fyGaZeyUJt9E4f68eiAI+LWMlVLdj
        JBxz2EIj7xVk4GZ+3pb1aMCS2E2EEZDWxq0lc3oN8E/axZY8
X-Google-Smtp-Source: ABdhPJyLwp9dpfr2BumVlPiJpl6Fl16bY3dHNe7RCsvDoAfJ8AC+sIR4NwEZlq00gCECm+zXD/wC4J40l8hQ41VeFk0=
X-Received: by 2002:a17:906:2582:: with SMTP id m2mr23886483ejb.271.1607452936024;
 Tue, 08 Dec 2020 10:42:16 -0800 (PST)
MIME-Version: 1.0
References: <20201207233646.29823-1-lsahlber@redhat.com> <20201207233646.29823-14-lsahlber@redhat.com>
 <CAH2r5mu_AGjT6T-gNOn5Z7eb7zXgm44Br+AES_=FVUdi6WnPSQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu_AGjT6T-gNOn5Z7eb7zXgm44Br+AES_=FVUdi6WnPSQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 8 Dec 2020 10:42:04 -0800
Message-ID: <CAKywueRVB96NKx89Te0OD_O1GcZjbZO+utDN9Lx2A=tGSKeGAA@mail.gmail.com>
Subject: Re: [PATCH 14/21] cifs: we do not allow changing username/password/unc/...
 during remount
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 7 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 21:07, Steve French=
 <smfrench@gmail.com>:
>
> Minor nits pointed out by checkpatch:
>
> 0015-cifs-we-do-not-allow-changing-username-password-unc-.patch
> ---------------------------------------------------------------
> WARNING: Missing commit description - Add an appropriate one
>
> WARNING: kfree(NULL) is safe and this check is probably not required
> #76: FILE: fs/cifs/fs_context.c:673:
> + if (ctx->field) { \
> + kfree(ctx->field);
>
> On Mon, Dec 7, 2020 at 5:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrot=
e:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsfs.c     |  2 +-
> >  fs/cifs/fs_context.c | 55 ++++++++++++++++++++++++++++++++++++++++++++=
+++++---
> >  fs/cifs/fs_context.h |  2 +-
> >  3 files changed, 54 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 80117e9d35f9..13d7f4a3c836 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -490,7 +490,7 @@ cifs_show_options(struct seq_file *s, struct dentry=
 *root)
> >
> >         if (tcon->no_lease)
> >                 seq_puts(s, ",nolease");
> > -       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> > +       if (cifs_sb->ctx->multiuser)
> >                 seq_puts(s, ",multiuser");
> >         else if (tcon->ses->user_name)
> >                 seq_show_option(s, "username", tcon->ses->user_name);
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index edfdea129fcc..542fa75b74aa 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -629,10 +629,53 @@ static int smb3_verify_reconfigure_ctx(struct smb=
3_fs_context *new_ctx,
> >                 cifs_dbg(VFS, "can not change sec during remount\n");
> >                 return -EINVAL;
> >         }
> > +       if (new_ctx->multiuser !=3D old_ctx->multiuser) {
> > +               cifs_dbg(VFS, "can not change multiuser during remount\=
n");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->UNC &&
> > +           (!old_ctx->UNC || strcmp(new_ctx->UNC, old_ctx->UNC))) {
> > +               cifs_dbg(VFS, "can not change UNC during remount\n");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->username &&
> > +           (!old_ctx->username || strcmp(new_ctx->username, old_ctx->u=
sername))) {
> > +               cifs_dbg(VFS, "can not change username during remount\n=
");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->password &&
> > +           (!old_ctx->password || strcmp(new_ctx->password, old_ctx->p=
assword))) {
> > +               cifs_dbg(VFS, "can not change password during remount\n=
");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->domainname &&
> > +           (!old_ctx->domainname || strcmp(new_ctx->domainname, old_ct=
x->domainname))) {
> > +               cifs_dbg(VFS, "can not change domainname during remount=
\n");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->nodename &&
> > +           (!old_ctx->nodename || strcmp(new_ctx->nodename, old_ctx->n=
odename))) {
> > +               cifs_dbg(VFS, "can not change nodename during remount\n=
");
> > +               return -EINVAL;
> > +       }
> > +       if (new_ctx->iocharset &&
> > +           (!old_ctx->iocharset || strcmp(new_ctx->iocharset, old_ctx-=
>iocharset))) {
> > +               cifs_dbg(VFS, "can not change iocharset during remount\=
n");
> > +               return -EINVAL;
> > +       }
> >
> >         return 0;
> >  }
> >
> > +#define STEAL_STRING(cifs_sb, ctx, field)                             =
 \
> > +do {                                                                  =
 \
> > +       if (ctx->field) {                                              =
 \
> > +               kfree(ctx->field);                                     =
 \
> > +               ctx->field =3D cifs_sb->ctx->field;                    =
   \
> > +               cifs_sb->ctx->field =3D NULL;                          =
   \
> > +       }                                                              =
 \
> > +} while (0)

If ctx->field is NULL we won't assign new value from
cifs_sb->ctx->field and the procedure will become no-op. Is this an
intent?

--
Best regards,
Pavel Shilovsky
