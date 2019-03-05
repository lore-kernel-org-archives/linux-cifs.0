Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D44C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A6D620684
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:22:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNvw0b0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfCEFWl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:22:41 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43329 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfCEFWl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 00:22:41 -0500
Received: by mail-qt1-f196.google.com with SMTP id y4so7784266qtc.10
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 21:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GF6ixql2a8gjS9m7xGqk8pw8zazy+wVBFPFFsTQULLU=;
        b=HNvw0b0BhbmYLtThb9Pzzdphd3w7iT00V2rmk7zxp80J9dvLJBCk+N2C4KJDVpOMwm
         9OItETkGhxSUjwOz+akM7SNrLl4/hZGQF1fE68B+I4HArHRObhQl/uAtBvlxAry4/Qmb
         ajy3WehzP85Pk84PHh16CcpAJ3lUZyC5zgmMe4geu2WboP88bGqEiGhKM0Li4AWw6JB/
         RDUXZCasMWYubG8nr/+/Jo3/sRZC114G0kz3EbrFAa/a5HIJGIF3IYfm8l3LLs1cfn3V
         OCl975/VSdHMQLh2Rz46VjRFuqtGQJ269oGsuO0fGLaVr2VsVpKP2R/u2hD109ZvaUuG
         EryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GF6ixql2a8gjS9m7xGqk8pw8zazy+wVBFPFFsTQULLU=;
        b=flkZvrnepSpBX39WXpIf+CwOyKcsjLT4jSO/O39xUHLYBkday+wWijxjfgVi1xJDTb
         WxsABjEF0jm9fYXuue/dSaPHFScteak0nJUrk6VCZlw2vHiUtliKvwNX7/j1qCvvpqQ2
         VjEmjObsHYhlr6TilJuVQnTRATDiv7tTbDHPMhCglFLF8SnQvcT0w6dEKnnwCDtfKOZs
         jeXPndYp61pO38D2NBQ4770gZPcwem6PyCgKjl0WIkcqdIT2lgZ4bLMwOgi6N9SvZiUi
         FGz+CNIYFQfD+reIttTS/DXz4pvoLW22NuKH1W65bjscUxjXFynAKUcfQrh+jN3w2X5L
         2v2w==
X-Gm-Message-State: APjAAAVVX69ZaMDdmGd18+pFdLy/EkhtQskx+vukfnldtGq9PaPe5YZv
        PwqxwCkfpM/+//0a+djyx63uv8XLlC2bcNEPYpY=
X-Google-Smtp-Source: APXvYqwM4vWe8kQaGiMIEcTTlU8IL+O5ZR0YKag0iCkJZ8gPd59Fh+MNDgHgj4t0IlUQUmqSluDe5R/XEBKtPi4WUW0=
X-Received: by 2002:ac8:25d9:: with SMTP id f25mr107391qtf.156.1551763359765;
 Mon, 04 Mar 2019 21:22:39 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
 <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com>
 <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com> <CAN05THSm08PBhPCT4sEyx8_F2f63MkxZY0Sk46iMQL9BBg1_4w@mail.gmail.com>
In-Reply-To: <CAN05THSm08PBhPCT4sEyx8_F2f63MkxZY0Sk46iMQL9BBg1_4w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 5 Mar 2019 15:22:28 +1000
Message-ID: <CAN05THRo63OhSK9ZT+5pC47GBYZ4yR3iOTAaS77m2GC+7rjKNQ@mail.gmail.com>
Subject: Re: More tests added to buildbot
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Lets remove 075 and 112 for now.

On Tue, Mar 5, 2019 at 3:07 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Tue, Mar 5, 2019 at 3:00 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I tried it to Samba a few minutes ago and it worked fine with current for-next
> >  and also:q it looks important (data integrity etc.).  Test description
> >
> > # Test that mmap read doesn't see non-zero data past EOF on truncate down.
> > #
> > # This is inspired by an XFS bug that truncate down fails to zero page cache
> > # beyond new EOF and causes stale data written to disk unexpectedly and a
> > # subsequent mmap reads and sees non-zeros post EOF.
> >
> > I have two test targets, both Samba localhost.  One succeeds for all 8 of
> > the ones that we were worried about:
> >
> > ./check -cifs generic/013 generic/014 generic/024 generic/030
> > generic/069 generic/075 generic/112 generic/125 generic/346
> > generic/469
>
> generic/469 works against samba but not against windows.
> So we need to change the buildbot to run it against smb3samba instead of smb3.
>
>
> >
> > The other succeeds on all but 075 and 112 which worked on the 'old'
> > xfstests from a month ago, but fail on the one with the newer
> > xfstests.
> >
> > So I think we are ok with 469 ... but we do have to figure out what to
> > do with what seems to be either a regression in 075 and 112 xfstests
> > (a bug in the tests) or something that the updated tests are now
> > seeing as a cifs bug.  My theory is that it is due to this xfstest
> > commit:
> >
> > root@smf-Thinkpad-P51:~/xfstests-dev# git log tests/generic/075
> > commit ec295d73ac19a42d1f022cb074d0bd506252cb3b
> > Author: Christoph Hellwig <hch@lst.de>
> > Date:   Fri Feb 15 13:41:40 2019 +0100
> >
> >     generic/075,112: detect preallocation support for fsx tests
> >
> >     Currently generic/075 and generic/112 have two extra fsx passes each
> >     that exercise fsx with preallocation, which are only enabled for
> >     XFS.
> >
> >     These tests can also be run with other file systems, given that the
> >     XFS prealloc ioctls are implemented in generic code since the
> >     addition of the fallocate system call.  This also means a version of
> >     XFS that does not support preallocation (e.g. because it always
> >     writes out of place) can skip the prealloc tests while still
> >     completing the normal fsx tests just fine.
> >
> >     Signed-off-by: Christoph Hellwig <hch@lst.de>
> >     Reviewed-by: Eryu Guan <guaneryu@gmail.com>
> >     Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> >
> > On Mon, Mar 4, 2019 at 10:10 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > generic/469   does it work for you?
> > > It fails in the tests.
> > >
> > > I have tried it locally and it always fails here. With current
> > > for-next as well as for-next as of a month ago.
> > > Same for xfs-tests, with current as well as months old master.
> > >
> > > Lets remove it.
> > >
> > > On Sun, Mar 3, 2019 at 3:05 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > Added four xfs subtests to the cifs-testing buildbot (and 3 of these
> > > > were also missing from the Azure buildbot so added them to Azure as
> > > > well)
> > > > +        [ "generic/464", "smb3"],
> > > > +        [ "generic/469", "smb3"],
> > > > +        [ "generic/524", "smb3"],
> > > > +        [ "generic/528", "smb3samba],
> > > >
> > > > Testing the three new tests for Azure in
> > > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/105
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
