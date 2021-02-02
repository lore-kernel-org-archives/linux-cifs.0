Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41604C433E6
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0216864F5E
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbhBBSa6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238554AbhBBS2x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 13:28:53 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ED3C061793
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 10:27:42 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id c3so10965922ybi.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 10:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wKb1jYnrQ+NKm3dq6MT3ahvjiTKs0PMUryvMe9hElCE=;
        b=IS4Dl3iBJ+iFPN6K1dQl8Tl4L9O2ePM9piBRR36o/F/uB5OqmP6ziwY3pZlal46YiO
         QaGNkfTRrbWm6zDhS6nws7/L+KTypT0P7+T1HPW7kyz2fxv02MBLiH/Go/qbnKcZhwKS
         zpTPyvWRQAnI4XbbwbcOidKoXRQsrw3r8/Ul66/cZh8P7LQMgR1H41H3r9IaKuZa89WS
         LKH5BHL6xUJcKNJXJWjRuQUQOK2dU9RR5ZGC3jvXSu6ggxLOvSU/9pf4JJKsQNCm8Y1n
         C+0tRAX8yxypHZtPTyp1Ws3Kn+6PJ4y6iALw0ySb8VSWZ1jaisjxMedKj8N1n7crRwP+
         UBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wKb1jYnrQ+NKm3dq6MT3ahvjiTKs0PMUryvMe9hElCE=;
        b=pzqYg4SGQWw5v7GF1GJM4CY122S03FRJm8q112ANiHhSYpVY3uHiQBkUyFA99uR5n1
         17OmvukNDahseZ8DHX9I2Vi54mNzsTVDsq1X7kEu9uDZo1ToEbp8E/OGQGyK/mjfnaUl
         OXoys+pCKte31N8TSVy4TpERqvpD2zLsw2eTFyVylndIvxMT/3J5aitpW3wcxf+wtD1T
         PY1fvQMyO9Db9fNyXycFDLqi/2Urrnxtr7/Vx0Spfh4COP0feMUxkkXx2yJZFaURj1Tq
         znbDGPu9Ibr3sILX5hTUgOf2Us6ycT9d0M3gqPsvvHVqev7iE2KLLLE/cDi+UwujfS6x
         WTWA==
X-Gm-Message-State: AOAM532lfvO5Ojl4KAisPKI1KhRrTSVE6hORGdNPLlOJPxSloj5GZQuC
        IQWzQJN94RY1JpI2QkaGvyHuumOc0LaORoUxumI=
X-Google-Smtp-Source: ABdhPJxJOb3NVax8NWCyzrNof4jFTT9eEsfxiiPTRU/Oestl2YRJKdbUR5LvL0SLdYarv9JyoEXzm8q19962GNqWt1c=
X-Received: by 2002:a25:83cc:: with SMTP id v12mr23486088ybm.293.1612290461470;
 Tue, 02 Feb 2021 10:27:41 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=pK3hQNTvsR-WUmtrQFuKngx+A1iYfd0JXyb0WHqpfKMA@mail.gmail.com>
 <20210202174255.4269-1-aaptel@suse.com> <CAH2r5muLRXp_VhaPRVYZNpYoRc9Qpyko9doSmzMm4JgE1bAoSg@mail.gmail.com>
In-Reply-To: <CAH2r5muLRXp_VhaPRVYZNpYoRc9Qpyko9doSmzMm4JgE1bAoSg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 2 Feb 2021 23:57:30 +0530
Message-ID: <CANT5p=pUN=iULXD_UwCyNcAqN8kPh7J2M6ChaPFhpgANHJwy=Q@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: report error instead of invalid when
 revalidating a dentry fails
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree.

On Tue, Feb 2, 2021 at 11:25 PM Steve French <smfrench@gmail.com> wrote:
>
> presumably cc:stable?
>
> On Tue, Feb 2, 2021 at 11:43 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > From: Aurelien Aptel <aaptel@suse.com>
> >
> > Assuming
> > - //HOST/a is mounted on /mnt
> > - //HOST/b is mounted on /mnt/b
> >
> > On a slow connection, running 'df' and killing it while it's
> > processing /mnt/b can make cifs_get_inode_info() returns -ERESTARTSYS.
> >
> > This triggers the following chain of events:
> > =3D> the dentry revalidation fail
> > =3D> dentry is put and released
> > =3D> superblock associated with the dentry is put
> > =3D> /mnt/b is unmounted
> >
> > This patch makes cifs_d_revalidate() return the error instead of
> > 0 (invalid) when cifs_revalidate_dentry() fails, except for ENOENT
> > where that error means the dentry is invalid.
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > Suggested-by: Shyam Prasad N <nspmangalore@gmail.com>
> > ---
> >  fs/cifs/dir.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 68900f1629bff..868c0b7263ec0 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -737,6 +737,7 @@ static int
> >  cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
> >  {
> >         struct inode *inode;
> > +       int rc;
> >
> >         if (flags & LOOKUP_RCU)
> >                 return -ECHILD;
> > @@ -746,8 +747,11 @@ cifs_d_revalidate(struct dentry *direntry, unsigne=
d int flags)
> >                 if ((flags & LOOKUP_REVAL) && !CIFS_CACHE_READ(CIFS_I(i=
node)))
> >                         CIFS_I(inode)->time =3D 0; /* force reval */
> >
> > -               if (cifs_revalidate_dentry(direntry))
> > -                       return 0;
> > +               rc =3D cifs_revalidate_dentry(direntry);
> > +               if (rc) {
> > +                       cifs_dbg(FYI, "cifs_revalidate_dentry failed wi=
th rc=3D%d", rc);
> > +                       return rc =3D=3D -ENOENT ? 0 : rc;
> > +               }
> >                 else {
> >                         /*
> >                          * If the inode wasn't known to be a dfs entry =
when
> > --
> > 2.29.2
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Regards,
Shyam
