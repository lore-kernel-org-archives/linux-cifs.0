Return-Path: <SRS0=bDWC=DO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96583C4363D
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 02:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A298207EA
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 02:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H78cLiUK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJGCsa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 22:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgJGCs3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 22:48:29 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58545C061755
        for <linux-cifs@vger.kernel.org>; Tue,  6 Oct 2020 19:48:29 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z8so521240lfd.11
        for <linux-cifs@vger.kernel.org>; Tue, 06 Oct 2020 19:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KCsZOvnnkn4pzCTFdj25qgSKDx14zPxN7zlKZET527w=;
        b=H78cLiUKlfqAiuQQIIJpcb0MrKTQT68d77PQycZFqsoV6anFv0xaeBVyxLag2sGCIX
         ltrGGtqc9ki5DmQbevnZ6eRCSmm0E/2+JeEwvpK7w+a5GX0LU08CodyKSN9mzGyQaO46
         j8JNKQK4bMgL8TsGeEgydUzFwsRRwTaBXKBS8wvg2yaUshB+a/BR81OConKcEPFGHNH6
         SSB1Qx80Rv9mA5eVsARUmS23dQBOAXhsuT7O+apwQooA+gvZwNgxaHCE9XP+Iqpq+Pt9
         7VdAstyiXQssPk007LbFw9xD/sMj1ifZqnAdhnzIxblmvtW1HQ53UqY9xBPUABFfmmlD
         xhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KCsZOvnnkn4pzCTFdj25qgSKDx14zPxN7zlKZET527w=;
        b=TC6KjXlSuemRvRzfYfOxKlpgBgSifHmbZVdW9xH1E/8hfAakt7+Aj47cfJXZDZuP29
         5qjzs5uHHiAG97/K5Tl9Wo1QTwAz9mcCGWewFN9mZjg9buakSOIPwL4BSTWqG6DkXvxc
         jHK0g71XtTaU1pRpvRGr9RHAII1lqe1iX14A9pnq5EN6zVMVk+s/zs+jIXLv2CHNpNQz
         9oROkssxXuGRLvj403m7CSHM1xju8A6sTs+vwj4dZuBRE3fKz3xikp6x+iU2IHmkkxut
         OuVt0ywiODOIM6GJmGwXVjsBd1CyVJyc4iA2Zzh6q8p8uE0IPgGjkQtT/po/d6mf6Yxe
         0t0w==
X-Gm-Message-State: AOAM531oLQdX8qHgyQ1KSXZJEEdHbs7/akCPO1JdxFw3FDEHkCBnv1Cc
        9TeyMcABz5NvA9bnwh9PMddqhrZ4D3rWiiUigso1UTlLRoM=
X-Google-Smtp-Source: ABdhPJxeZ/Ip132tO8EImmFEKX7cjMqW799XzdnayGL1F92uvDnoKpT2B4yfFiQR1vzCugWxKrmyFuF/qTsrRPWJAEs=
X-Received: by 2002:a19:c68a:: with SMTP id w132mr221668lff.106.1602038906993;
 Tue, 06 Oct 2020 19:48:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201006052643.6298-1-lsahlber@redhat.com> <87ft6ripw9.fsf@suse.com>
 <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com> <CAH2r5muszEqf9zbv6Xv8UzAmcPq6gvhYEhb5LBPEbPfW61tRGA@mail.gmail.com>
In-Reply-To: <CAH2r5muszEqf9zbv6Xv8UzAmcPq6gvhYEhb5LBPEbPfW61tRGA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 6 Oct 2020 21:48:15 -0500
Message-ID: <CAH2r5mvkS_x9zoWt_REx5TyPWuWQqxZ2YYx8aoQPChOB3ZRfoA@mail.gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also FYI- I made a minor modification after discussing with Ronnie,
reducing the retry count

On Tue, Oct 6, 2020 at 8:44 PM Steve French <smfrench@gmail.com> wrote:
>
> Tentatively merged updated version of this patch into cifs-2.6.git
> for-next pending more testing and reviews
>
> On Tue, Oct 6, 2020 at 5:22 PM ronnie sahlberg <ronniesahlberg@gmail.com>=
 wrote:
> >
> > On Tue, Oct 6, 2020 at 8:57 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wr=
ote:
> > >
> > > Hi Ronnie,
> > >
> > > Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > > > Some calls that set attributes, like utimensat(), are not supposed =
to return
> > > > -EINTR and thus do not have handlers for this in glibc which causes=
 us
> > > > to leak -EINTR to the applications which are also unprepared to han=
dle it.
> > >
> > > EINTR happens when the task receives a signal right?
> > >
> > > https://www.gnu.org/software/libc/manual/html_node/Interrupted-Primit=
ives.html
> > >
> > > Given what you said and what the glibc doc reads it seems like the fi=
x
> > > should go in glibc. Otherwise we need to care about every single sysc=
all.
> >
> > glibc have handling for EINTR in most places, but not in for example ut=
imensat()
> > because this function is not supposed to be able to return this error.
> > Similarly we have functions like chmod and chown that also come into ci=
fs.ko
> > via the same entrypoint: cifs_setattr()
> > I think all of these "update inode data" are never supposed to be
> > interruptible since
> > they were classically just updating the in-memory inode and the thread
> > would never hit d-state.
> >
> > Anyway, for these functions EINTR is not a valid return code so I
> > think we should take care to not
> > return it. Even if we change glibc adn the very very thin wrapper for
> > this functions there are applications
> > that might call the systemcall directly or via a different c-library.
> >
> >
> > >
> > > Cheers,
> > > --
> > > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnb=
erg, DE
> > > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
