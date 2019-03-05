Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B79C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C7672075B
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 06:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONfBlqsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfCEGB6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 01:01:58 -0500
Received: from mail-pg1-f182.google.com ([209.85.215.182]:40979 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfCEGB6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 01:01:58 -0500
Received: by mail-pg1-f182.google.com with SMTP id k11so3878757pgb.8
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 22:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gz/ijmUjXGgLfiKIfPcWwrbWmXQbvej5vVdw+HMDMBU=;
        b=ONfBlqsik1dCZOF/Pb012drp03kahOY0eMFtfrJLx+qVMWJvNqpfWjwk/g60s/TnSZ
         dhqmpRZiRrlxRgFWJRYgfyMoWhdkxEvThS4VIJy3YbLR5e5O3TU4nXdiNbvJevRiYXQa
         9ldADuFfULNl/2BQuZrKTPIhpGN4xEGmmxr9+nrHeP3Rf1PCeJq0oKUDmURTtWwzWZ7Z
         GlbG76CcV/dno/VndFTLaIEO9CpYDur5FFXOpoBehCDe5RglLHtX+9gl3Wdrh0doQ1g6
         GWC/nthCutFlxgbQKl/8Y96ZxbDcrF9pPATftrgu6tA1YIYGTIf/nftoEEe4baiqPLVj
         UyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gz/ijmUjXGgLfiKIfPcWwrbWmXQbvej5vVdw+HMDMBU=;
        b=i2h3BUsxf/T6InniD012PvWJk9KGjjsJ3GS4KXQ9qvJ+a8ROjxsGx27IhA/3KFdfI+
         9BQbfakotDttUMNaiVmgbQ8wB6p1eaqRK4BR1VQ8amlHI9W2tIQ2LucHx/0lgIDgljp0
         5KdlLOL5oV9GGVu+iJYAK54Jg9oI0EZHzpL4/7/mYv7Qf57+XXieHDalvFTAzXmi+BfR
         3TTesYc37LP+GNEVvNYRBGNwLD90imaXTdIcZH946BGuCF1ODaKyCxHEgneuVtz4X0A3
         eHSwhsicgcQgoU+eeTBu8MHpOtbjPIJfiOIWD3w5Z6wDjY/8H1gA0EcEPVEpb36OQ1av
         eg6w==
X-Gm-Message-State: APjAAAW1xCtzthFTY5xhbQmLeS+Ay2j/jmpjNdRmoVpXPo7CSySwnTVE
        lwxnpc10G26xkETJHPsFmvglILWTddBWVerCoNs=
X-Google-Smtp-Source: APXvYqzzQCxbswwULHb/3L0xGIGHTwi6rH6N7ojCeLfiuE6TMU2IbgmQjJ3UIMxyNemt+hCJmwOdt4b8vNkJRsFp+cM=
X-Received: by 2002:a62:ac10:: with SMTP id v16mr206071pfe.111.1551765717672;
 Mon, 04 Mar 2019 22:01:57 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
 <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com> <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com>
In-Reply-To: <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Mar 2019 00:01:45 -0600
Message-ID: <CAH2r5mur3wySL-miCrabnHT9obskZqnBiGM9gJ238eywK73u+g@mail.gmail.com>
Subject: Re: More tests added to buildbot
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rather than back 075 and 112 out I reverted xfstest tests/generic/075
and 112 to their state from a few weeks ago by backing out the patch I
mentioned below

Kicked off http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/110
with that change to the buildbot

On Mon, Mar 4, 2019 at 11:00 PM Steve French <smfrench@gmail.com> wrote:
>
> I tried it to Samba a few minutes ago and it worked fine with current for-next
>  and also:q it looks important (data integrity etc.).  Test description
>
> # Test that mmap read doesn't see non-zero data past EOF on truncate down.
> #
> # This is inspired by an XFS bug that truncate down fails to zero page cache
> # beyond new EOF and causes stale data written to disk unexpectedly and a
> # subsequent mmap reads and sees non-zeros post EOF.
>
> I have two test targets, both Samba localhost.  One succeeds for all 8 of
> the ones that we were worried about:
>
> ./check -cifs generic/013 generic/014 generic/024 generic/030
> generic/069 generic/075 generic/112 generic/125 generic/346
> generic/469
>
> The other succeeds on all but 075 and 112 which worked on the 'old'
> xfstests from a month ago, but fail on the one with the newer
> xfstests.
>
> So I think we are ok with 469 ... but we do have to figure out what to
> do with what seems to be either a regression in 075 and 112 xfstests
> (a bug in the tests) or something that the updated tests are now
> seeing as a cifs bug.  My theory is that it is due to this xfstest
> commit:
>
> root@smf-Thinkpad-P51:~/xfstests-dev# git log tests/generic/075
> commit ec295d73ac19a42d1f022cb074d0bd506252cb3b
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Fri Feb 15 13:41:40 2019 +0100
>
>     generic/075,112: detect preallocation support for fsx tests
>
>     Currently generic/075 and generic/112 have two extra fsx passes each
>     that exercise fsx with preallocation, which are only enabled for
>     XFS.
>
>     These tests can also be run with other file systems, given that the
>     XFS prealloc ioctls are implemented in generic code since the
>     addition of the fallocate system call.  This also means a version of
>     XFS that does not support preallocation (e.g. because it always
>     writes out of place) can skip the prealloc tests while still
>     completing the normal fsx tests just fine.
>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Eryu Guan <guaneryu@gmail.com>
>     Signed-off-by: Eryu Guan <guaneryu@gmail.com>
>
> On Mon, Mar 4, 2019 at 10:10 PM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > generic/469   does it work for you?
> > It fails in the tests.
> >
> > I have tried it locally and it always fails here. With current
> > for-next as well as for-next as of a month ago.
> > Same for xfs-tests, with current as well as months old master.
> >
> > Lets remove it.
> >
> > On Sun, Mar 3, 2019 at 3:05 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Added four xfs subtests to the cifs-testing buildbot (and 3 of these
> > > were also missing from the Azure buildbot so added them to Azure as
> > > well)
> > > +        [ "generic/464", "smb3"],
> > > +        [ "generic/469", "smb3"],
> > > +        [ "generic/524", "smb3"],
> > > +        [ "generic/528", "smb3samba],
> > >
> > > Testing the three new tests for Azure in
> > > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/105
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
