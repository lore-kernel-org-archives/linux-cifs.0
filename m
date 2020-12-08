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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A202C4361B
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 21:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 629AC23A7B
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Dec 2020 21:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgLHVjN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbgLHVjM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Dec 2020 16:39:12 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEA2C0613CF
        for <linux-cifs@vger.kernel.org>; Tue,  8 Dec 2020 13:38:32 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id t8so18391960iov.8
        for <linux-cifs@vger.kernel.org>; Tue, 08 Dec 2020 13:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=idIAjwUqOQoTCrc2M3BunD/opokATh5yOfx8CxyLCd8=;
        b=GfRzJi4OXfdO7hlhutTzODVYtiE/enYkBZHGRLPdQT0upRZFHDBwttXkpcd1rNfJwN
         oCzGZ7Khb0SlgLAPsq4EcMX6HgADBrF1pvRqRyyHuYFoMWcx4KjOSNaiQR3GyWVyIuvB
         1w38OcPBMYswdswo0ct8/mfWr9KsXWy476L588Rap2eHfLIYqcRMbXyFuDtewbEoDS3T
         3CHcRTDPhKktapUKyslbuTGhCDZF4BXa60IYPbAQusXe2fdiI5r3002lapJd61IEuDIn
         tMYKV+Zb01TFX3cE1QwVu+cl21WXP44W0GZloDHi/+SUJKB6dSEwYwC+Zsu0xHU0h304
         ZxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=idIAjwUqOQoTCrc2M3BunD/opokATh5yOfx8CxyLCd8=;
        b=AGYt8tM067dBG50/+2RJ0Qyn9aF3zZlPGwqfYNatnwCP5Z60cmoBZb79Q21rtZAm+I
         LC3wFcJBAhPZfsSbjyOJH9NKAw7Yu+tpgH5qAi+gHRX3rau1Nyn9Mxe2GukBycWSgbS3
         IJ6LRT05FeH+Asw9xemOyUyA0xyh0ZKbpP+jOAVcxOIDTVNyWQiPUq6e/aigkUcgN9bq
         2ky1s2tNprrZ2GTgMTken7BU5z0Xq+pGNiAw32prxxVUYssHpKahy7HNabl5eVUfhqAv
         xyBR8qFwjbKqO6jRewOZOO3nHVkb0pwFmA1qSFtRTRoFjtogwFXWVm5LiyAFmPh6QWtf
         5+vw==
X-Gm-Message-State: AOAM533OUkFkwqpK30A/eWHGkMGt38E/QnlwRmSWlGmEx682zJuiFosM
        qvChYN4cjX2KduVzX71gFABYUqGpQIk1nZIzbvM=
X-Google-Smtp-Source: ABdhPJy/JAETPqoQLFl62PfzG1Tawg1mpGXAxqxbdjjv3MyxN+XDRERPxJiQGAHI6dPGGeoTfyF7lD38r0LFW4eJxgw=
X-Received: by 2002:a5e:8e0d:: with SMTP id a13mr16185391ion.1.1607463511936;
 Tue, 08 Dec 2020 13:38:31 -0800 (PST)
MIME-Version: 1.0
References: <20201207233646.29823-1-lsahlber@redhat.com> <20201207233646.29823-14-lsahlber@redhat.com>
 <CAH2r5mu_AGjT6T-gNOn5Z7eb7zXgm44Br+AES_=FVUdi6WnPSQ@mail.gmail.com> <CAKywueRVB96NKx89Te0OD_O1GcZjbZO+utDN9Lx2A=tGSKeGAA@mail.gmail.com>
In-Reply-To: <CAKywueRVB96NKx89Te0OD_O1GcZjbZO+utDN9Lx2A=tGSKeGAA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 9 Dec 2020 07:38:20 +1000
Message-ID: <CAN05THSM2QdRjZ48NHEDeqfGP8kMB19dOdgj91qF-_U_sq8i2Q@mail.gmail.com>
Subject: Re: [PATCH 14/21] cifs: we do not allow changing username/password/unc/...
 during remount
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Dec 9, 2020 at 7:08 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D0=BF=D0=BD, 7 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 21:07, Steve Fren=
ch <smfrench@gmail.com>:
> >
> > Minor nits pointed out by checkpatch:
> >
> > 0015-cifs-we-do-not-allow-changing-username-password-unc-.patch
> > ---------------------------------------------------------------
> > WARNING: Missing commit description - Add an appropriate one
> >
> > WARNING: kfree(NULL) is safe and this check is probably not required
> > #76: FILE: fs/cifs/fs_context.c:673:
> > + if (ctx->field) { \
> > + kfree(ctx->field);
> >
> > On Mon, Dec 7, 2020 at 5:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wr=
ote:
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/cifsfs.c     |  2 +-
> > >  fs/cifs/fs_context.c | 55 ++++++++++++++++++++++++++++++++++++++++++=
+++++++---
> > >  fs/cifs/fs_context.h |  2 +-
> > >  3 files changed, 54 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index 80117e9d35f9..13d7f4a3c836 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -490,7 +490,7 @@ cifs_show_options(struct seq_file *s, struct dent=
ry *root)
> > >
> > >         if (tcon->no_lease)
> > >                 seq_puts(s, ",nolease");
> > > -       if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
> > > +       if (cifs_sb->ctx->multiuser)
> > >                 seq_puts(s, ",multiuser");
> > >         else if (tcon->ses->user_name)
> > >                 seq_show_option(s, "username", tcon->ses->user_name);
> > > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > > index edfdea129fcc..542fa75b74aa 100644
> > > --- a/fs/cifs/fs_context.c
> > > +++ b/fs/cifs/fs_context.c
> > > @@ -629,10 +629,53 @@ static int smb3_verify_reconfigure_ctx(struct s=
mb3_fs_context *new_ctx,
> > >                 cifs_dbg(VFS, "can not change sec during remount\n");
> > >                 return -EINVAL;
> > >         }
> > > +       if (new_ctx->multiuser !=3D old_ctx->multiuser) {
> > > +               cifs_dbg(VFS, "can not change multiuser during remoun=
t\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->UNC &&
> > > +           (!old_ctx->UNC || strcmp(new_ctx->UNC, old_ctx->UNC))) {
> > > +               cifs_dbg(VFS, "can not change UNC during remount\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->username &&
> > > +           (!old_ctx->username || strcmp(new_ctx->username, old_ctx-=
>username))) {
> > > +               cifs_dbg(VFS, "can not change username during remount=
\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->password &&
> > > +           (!old_ctx->password || strcmp(new_ctx->password, old_ctx-=
>password))) {
> > > +               cifs_dbg(VFS, "can not change password during remount=
\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->domainname &&
> > > +           (!old_ctx->domainname || strcmp(new_ctx->domainname, old_=
ctx->domainname))) {
> > > +               cifs_dbg(VFS, "can not change domainname during remou=
nt\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->nodename &&
> > > +           (!old_ctx->nodename || strcmp(new_ctx->nodename, old_ctx-=
>nodename))) {
> > > +               cifs_dbg(VFS, "can not change nodename during remount=
\n");
> > > +               return -EINVAL;
> > > +       }
> > > +       if (new_ctx->iocharset &&
> > > +           (!old_ctx->iocharset || strcmp(new_ctx->iocharset, old_ct=
x->iocharset))) {
> > > +               cifs_dbg(VFS, "can not change iocharset during remoun=
t\n");
> > > +               return -EINVAL;
> > > +       }
> > >
> > >         return 0;
> > >  }
> > >
> > > +#define STEAL_STRING(cifs_sb, ctx, field)                           =
   \
> > > +do {                                                                =
   \
> > > +       if (ctx->field) {                                            =
   \
> > > +               kfree(ctx->field);                                   =
   \
> > > +               ctx->field =3D cifs_sb->ctx->field;                  =
     \
> > > +               cifs_sb->ctx->field =3D NULL;                        =
     \
> > > +       }                                                            =
   \
> > > +} while (0)
>
> If ctx->field is NULL we won't assign new value from
> cifs_sb->ctx->field and the procedure will become no-op. Is this an
> intent?

No, that is a bug. I will fix that.

Thanks.

>
> --
> Best regards,
> Pavel Shilovsky
