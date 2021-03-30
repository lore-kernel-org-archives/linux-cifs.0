Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF80C433C1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 22:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97BA9619B1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 22:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhC3WPo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhC3WPf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Mar 2021 18:15:35 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7576DC061574
        for <linux-cifs@vger.kernel.org>; Tue, 30 Mar 2021 15:15:34 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id o126so26161337lfa.0
        for <linux-cifs@vger.kernel.org>; Tue, 30 Mar 2021 15:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V7IEFFGXviHyXyoSKSR/vzZ5rfk2pwQTi5mqadJ72fU=;
        b=h4fXht+asY0xVbtw8pDJaIghtkb1qCLGvyiEvlf89iq/ZWTycC/taHUhfcCQw9Gj1k
         tn/j7VUycv+3DZ0iVSxeSDVg/qhcXSN9I8p2lasP5/KFJQ1tOfruWootZse0KltHsMqX
         khzE9uihgwa06H+fB26aUu7U5bV87PWP8Ce9KmTuWJyGbJJJ8NZsCB0JNp3kyReeDHab
         GO1l1a4hdEQfWPiHrB9wv5NrVluS/Dexx6d8GPL8d3Y5ZBPYx/UwqMV5rWxDAiTGrYur
         UqzmDBVdlTTByb2lt28Cu/px4RYuSoCIgLgp7NJL/ZeTjXoY1WZJ+NhGZuhBi/BW8lai
         f2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V7IEFFGXviHyXyoSKSR/vzZ5rfk2pwQTi5mqadJ72fU=;
        b=CTdQq+E81NPlAlg93bacAsHY1lvct3ICcLQuHKMcVIEQhpKWRLsEgvATcYMl2Vu5sc
         qOr8bceiRL8dqPvoPAi3bc2ncgJfNJStIHgyyxSe5aEZekXdi/RsrXevPvFVAFy0xbri
         ZMZE09GomNj1L1TNpXTyiATu+uuAbmWxmjkhXKGfq4AHj/iPXb7UtPFon/dGBaxyyzxG
         BucrWgCvuNWs+szKqIN9IVb2jFg5x+iIvhKxocXKBvWeOaT4jjVE4e27lHlM3FinvuJj
         Z8/DqEkFX02eZln+G5COSAbJZYWNlmTS5CPdLTxWdDKAkppDLOl7kVsAcHuxKAtgM5OE
         6Jjw==
X-Gm-Message-State: AOAM533OmOk1Nap/+hwqZ5JX/ixP0a2v3gwCAe89ztHQ101hCeHoPXjU
        bDnJM3Cd5UIacSgigYvT+tY7WHNX2SpvmyEeS08=
X-Google-Smtp-Source: ABdhPJwPFnU0nvFavtnZ+rgELT1ZXemQ9d+SVxscaRnHvLpXRfgQIA3NoXNezjzFJNQpgBtn/3UjqdpqdY9UsIP+Lbc=
X-Received: by 2002:ac2:4471:: with SMTP id y17mr176744lfl.307.1617142532941;
 Tue, 30 Mar 2021 15:15:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210326195229.114110-1-lsahlber@redhat.com> <87eefwpvsc.fsf@suse.com>
 <CAN05THR6kWTL0qyCAoYc1p7bguAS7okxQ0jRDigfyXaE_jr5eA@mail.gmail.com>
In-Reply-To: <CAN05THR6kWTL0qyCAoYc1p7bguAS7okxQ0jRDigfyXaE_jr5eA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 30 Mar 2021 17:15:21 -0500
Message-ID: <CAH2r5mua0KMT4-=WT3_a2iTJfke4jbuJ-=FnTc03JD13yE9bRg@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 30, 2021 at 5:09 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Mar 31, 2021 at 12:22 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wr=
ote:
> >
> > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > > +static long smb3_collapse_range(struct file *file, struct cifs_tcon =
*tcon,
> > > +                         loff_t off, loff_t len)
> > > +{
> > > +     int rc;
> > > +     unsigned int xid;
> > > +     struct cifsFileInfo *cfile =3D file->private_data;
> > > +     __le64 eof;
> > > +
> > > +     xid =3D get_xid();
> > > +
> > > +     if (off + len < off) {
> > > +             rc =3D -EFBIG;
> > > +             goto out;
> > > +     }
> >
> > loff_t is defined as 'long long' for me which is signed, and signed
> > overflow is Undefined Behaviour, unless we compile with -fwrapv which
> > I'm not sure it is something we can assume.
> >
> > Also, vfs_fallocate() in fs/open.c already does an overflow check befor=
e
> > calling f_op->falloc(), this is probably not needed. (It's also relying
> > on signed overflow so I guess it is ok...?)
>
> Thanks.
> Steve, can you drop this check from the patch?

Yes.   I was trying to run some xfstests on it vs. Windows with REFS
(and Samba with BTRFS after that).  Any observations on these two
patches and xfstests?

> > Rest of the patch looks good otherwise.
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team




--=20
Thanks,

Steve
