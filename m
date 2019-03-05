Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A02EC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0301620675
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:00:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FS8mceGq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbfCEFAM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:00:12 -0500
Received: from mail-pf1-f178.google.com ([209.85.210.178]:39051 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfCEFAM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 00:00:12 -0500
Received: by mail-pf1-f178.google.com with SMTP id i20so4721089pfo.6
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 21:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ip9F6zy7L1XHC8G2foMiZfP9rukb2OtQKuT4BDOIkbo=;
        b=FS8mceGqfTPvnB585ZLe0HVRhRMAUKrXEeEur2w6ZlN5bCQLdtUCr8DKaWrfNmcOv9
         q/b3UfjMIDhN3o6sxT3c28JCQteypzd+f/1dvqkx4S5lLPXj/7RZd4CGvwgek4hrVlZR
         OoVo3RYGYySoP8BQAlNEdChzJfKYS3KLX1WuMsIpJOUpDOZkHBLJZkYDFcDDYUxFGP0Q
         fJPD55HeB9Rj2h+PUtzJG9OBoZbbDaxdXQ6894lMils+/QBJL6IBepgJ3zWT9VGtKOpp
         KxCmzAAg+QatQ3pKYdpIcoSELjvSisobc8tyQtdkNkBeOVxbxY1tnRXhHx2M+c581KIJ
         CHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ip9F6zy7L1XHC8G2foMiZfP9rukb2OtQKuT4BDOIkbo=;
        b=tOoZPwWTgDX+TiCoITFnaI+lCmya42IIcOkoV416fPHRA3RmTdB6RM1+BlpF2hD9qg
         Ky8QYNG+ZKEqvtD33zk+t5+Esa/XwYI1WslQxL80GEYCJTlrHuiUJJOQ28q4e0y67s6n
         40j7aXGbur4qxbCeosmn0Oo9MaQvMgnla9cEvEl/qBTu6SAYPUg+j4ePqWDpG2ZOHBgh
         hVmj9ddq1qrlzepkl/phxx5U8UYwO+bNw7Zdu4pZ77M0l3ywV/6HyT3iWSH4IC5yelIk
         G1zhQCFE6QzulRzboXVxZMI6dYYZBCXbAEeKs5+NgJL8yzp4LTAjYBCg9fUiQL6V11b5
         wASg==
X-Gm-Message-State: APjAAAW7PsXyZT02p7Ye4zOmUL+8Mz1JNUS4ZC7t5n1SxfZqt1nOoPZX
        v78ZglO4kLwFmu4+dLxsDQzLaoW99RmsQKPb8Wvzrsze
X-Google-Smtp-Source: APXvYqxhcjvJOCgXDZpTK68KwWj2D1MtGKxhlXPwSRtcmnsci84wHMSDH2EthpM3L/37tbT6Lami8FNpXwYAHlFNxK8=
X-Received: by 2002:a17:902:822:: with SMTP id 31mr24320361plk.290.1551762011505;
 Mon, 04 Mar 2019 21:00:11 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
 <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com>
In-Reply-To: <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 4 Mar 2019 23:00:00 -0600
Message-ID: <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com>
Subject: Re: More tests added to buildbot
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tried it to Samba a few minutes ago and it worked fine with current for-next
 and also:q it looks important (data integrity etc.).  Test description

# Test that mmap read doesn't see non-zero data past EOF on truncate down.
#
# This is inspired by an XFS bug that truncate down fails to zero page cache
# beyond new EOF and causes stale data written to disk unexpectedly and a
# subsequent mmap reads and sees non-zeros post EOF.

I have two test targets, both Samba localhost.  One succeeds for all 8 of
the ones that we were worried about:

./check -cifs generic/013 generic/014 generic/024 generic/030
generic/069 generic/075 generic/112 generic/125 generic/346
generic/469

The other succeeds on all but 075 and 112 which worked on the 'old'
xfstests from a month ago, but fail on the one with the newer
xfstests.

So I think we are ok with 469 ... but we do have to figure out what to
do with what seems to be either a regression in 075 and 112 xfstests
(a bug in the tests) or something that the updated tests are now
seeing as a cifs bug.  My theory is that it is due to this xfstest
commit:

root@smf-Thinkpad-P51:~/xfstests-dev# git log tests/generic/075
commit ec295d73ac19a42d1f022cb074d0bd506252cb3b
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Feb 15 13:41:40 2019 +0100

    generic/075,112: detect preallocation support for fsx tests

    Currently generic/075 and generic/112 have two extra fsx passes each
    that exercise fsx with preallocation, which are only enabled for
    XFS.

    These tests can also be run with other file systems, given that the
    XFS prealloc ioctls are implemented in generic code since the
    addition of the fallocate system call.  This also means a version of
    XFS that does not support preallocation (e.g. because it always
    writes out of place) can skip the prealloc tests while still
    completing the normal fsx tests just fine.

    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Eryu Guan <guaneryu@gmail.com>
    Signed-off-by: Eryu Guan <guaneryu@gmail.com>

On Mon, Mar 4, 2019 at 10:10 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> generic/469   does it work for you?
> It fails in the tests.
>
> I have tried it locally and it always fails here. With current
> for-next as well as for-next as of a month ago.
> Same for xfs-tests, with current as well as months old master.
>
> Lets remove it.
>
> On Sun, Mar 3, 2019 at 3:05 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Added four xfs subtests to the cifs-testing buildbot (and 3 of these
> > were also missing from the Azure buildbot so added them to Azure as
> > well)
> > +        [ "generic/464", "smb3"],
> > +        [ "generic/469", "smb3"],
> > +        [ "generic/524", "smb3"],
> > +        [ "generic/528", "smb3samba],
> >
> > Testing the three new tests for Azure in
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/105
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
