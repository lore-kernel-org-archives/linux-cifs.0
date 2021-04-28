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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F56C433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 15:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22BE861407
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 15:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239791AbhD1Peh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Apr 2021 11:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240009AbhD1Peg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Apr 2021 11:34:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B279C061573
        for <linux-cifs@vger.kernel.org>; Wed, 28 Apr 2021 08:33:50 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 4so40005569lfp.11
        for <linux-cifs@vger.kernel.org>; Wed, 28 Apr 2021 08:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=szKWFr1oXEmrYM8i/tUaOrRSGsXmPlZ1MKJ+PCJ1YlQ=;
        b=cW26L2+vn/UkX36bYSx2AidKMU0RzLpwruk58psqOVRSFXMs+d/5edJEQ0S+Mlb8v9
         c1jjYdzQvMeqOdgv8TGhL3V47dwkEdxEwqi2Jf+iCLgqt6kfcmFRkIm7L6aYxeSE8q3E
         jvhzu+5Tp3VNb0FRTd+XJGDinXxF9HUmW1LNNIOvWR5WRR34VWwY7l7hK1WKDhonWhbu
         eeXtNqF9LXLh/fl96rbr3YVwZOYA4UiB/LvuoHbjAR/3Q40RLeoBe/ErENc4vOasUH/F
         9GD4fXxnjC2lPo2YZUfhCuJx8pEIHJC4HVhucGvDl0zXV1dDat+NABRL9HqhXbsKQcwX
         KEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=szKWFr1oXEmrYM8i/tUaOrRSGsXmPlZ1MKJ+PCJ1YlQ=;
        b=tUbsfB6qit+HFHWKpHtOVbk59h4tRrwMV/PW99SOdRCEFKrfi/SMsOWTHsvM4zgQmU
         +mIYWZFJEve3IImslGH9zpdbxtBFr37A9Fljuyr4VQ9I7+McgyZ3Pe3Me7/sSWnZFfZr
         QLI+n7HGPtoViiAru2sdMvFezGZwbXmA4oACMblItIcxfqNzmEy7GUmcoF1KrIJ8lyF9
         07GYdVnomPQaP+e88ngVK9OhCaeOLruc0g82vTj2cDVT4xYiIeHFoANVxYLFL1pK05p6
         DMuy2TlOsXHr2KRWaiUcS45MzCIVImrbGffduRW6si4YPuViwONE1TpqxYvEfazIQrZR
         PJIQ==
X-Gm-Message-State: AOAM5334FjGfcZy/dIhJWks1caRJayGbWP2lHlU+5bbgMy2QxZV2sSPI
        xHySldttoLT663Jc/PytzOWpAC9e7TteauGCU78=
X-Google-Smtp-Source: ABdhPJx8XypWliAdz2RnL8wU0cZll/9jW89W7aUx6lHZJh1XGR0h7yrp77l7mxYmpsSgzyVMeYdhq8BfjjIXFV3rSA4=
X-Received: by 2002:ac2:5519:: with SMTP id j25mr7902433lfk.282.1619624028449;
 Wed, 28 Apr 2021 08:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=peB0L90CN1pVDe6uyrbz2=9jTm865N6938i5-ZJN42Bw@mail.gmail.com>
 <87bl9ywhzf.fsf@suse.com>
In-Reply-To: <87bl9ywhzf.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Apr 2021 10:33:37 -0500
Message-ID: <CAH2r5mtXGJm=GkLVtJYCrO4WY7x5updXmX7Ouoj-fm0UNUrJMw@mail.gmail.com>
Subject: Re: [PATCH] cifs: when out of credits on one channel, retry on another.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have a simple repro we are looking at now with 4 channels

We start with reasonable number of credits but end up with channels 3
and 4 reconnecting and only having one credit on reconnect

On Wed, Apr 28, 2021 at 10:23 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > The idea is to retry on -EDEADLK (which we return when we run out of
> > credits and we have no requests in flight), so that another channel is
> > chosen for the next request.
>
> I agree with the idea.
>
> Have you been able to test those DEADLK codepaths? If so how, because we
> should add buildbot tests I think.
>
> For the function renaming, there is a precedent in the kernel to use a _
> prefix for "sub-functions" instead of the _final suffix.
>
> > This fix mostly introduces a wrapper for all functions which call
> > cifs_pick_channel. In the wrapper function, the function is retried
> > when the error is -EDEADLK, and uses multichannel.
>
> I think we should put a limit on the number of retries. If it goes above
> some reasonable number print a warning and return EDEADLK.
>
> We could also hide the retry logic loop in a macro to avoid code
> duplication when possible. This could get rid of multiple simpler funcs
> I think if we use the macro in the caller.
>
> Something like (feel free to improve/modify):
>
> #define MULTICHAN_RETRY(chan_count, call) \
> ({ \
>         int __rc; \
>         int __tries =3D 0;
>         do { \
>                 __rc =3D call; \
>                 __tries++; \
>         } while (__tries < MULTICHAN_MAX_RETRY && __rc =3D=3D -EDEADLK &&=
 chan_count > 1) \
>         WARN_ON(__tries =3D=3D MULTICHAN_MAX_RETRY); \
>         __rc; \
> })
>
>
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/cifs/file.c      |  96 +++++++++++-
> >  fs/cifs/smb2inode.c |  93 ++++++++----
> >  fs/cifs/smb2ops.c   | 113 +++++++++++++-
> >  fs/cifs/smb2pdu.c   | 359 ++++++++++++++++++++++++++++++++++++++++----
> >  4 files changed, 593 insertions(+), 68 deletions(-)
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 7e97aeabd616..7609b9739ce4 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -2378,7 +2378,7 @@ wdata_send_pages(struct cifs_writedata *wdata, un=
signed int nr_pages,
> >       return rc;
> >  }
> >
> > -static int cifs_writepages(struct address_space *mapping,
> > +static int cifs_writepages_final(struct address_space *mapping,
> >                          struct writeback_control *wbc)
> >  {
> >       struct inode *inode =3D mapping->host;
> > @@ -2543,6 +2543,21 @@ static int cifs_writepages(struct address_space =
*mapping,
> >       return rc;
> >  }
> >
> > +static int cifs_writepages(struct address_space *mapping,
> > +                        struct writeback_control *wbc)
> > +{
> > +     int rc;
> > +     struct inode *inode =3D mapping->host;
> > +     struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> > +     struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> > +
> > +     do {
> > +             rc =3D cifs_writepages_final(mapping, wbc);
> > +     } while (tcon->ses->chan_count > 1 && rc =3D=3D -EDEADLK);
> > +
> > +     return rc;
> > +}
>
> cifs_writepages can issue multiple writes. I suspect it can do some
> successful writes before it runs out of credit, and I'm not sure if
> individual pages are marked as flushed or not. Basically this func might
> not be idempotent so that's one codepath that we should definitely try I
> think (unless someone knows more and can explain me).
>
> Same goes for /some/ of the the other funcs... I think this should be
> documented/tried.
> >
> > +static int
> > +smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> > +              struct cifs_sb_info *cifs_sb, const char *full_path,
> > +              __u32 desired_access, __u32 create_disposition,
> > +              __u32 create_options, umode_t mode, void *ptr, int comma=
nd,
> > +              bool check_open, bool writable_path)
> > +{
>
> I would use an int for flags intead of passing those 2 booleans. This
> way adding more flags in the future will be easier, and you can use
> named enum or defines in the code instead of true/false which will be
> more understandable.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
