Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFADC43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 07:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F79F20675
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 07:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfCEHV6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 02:21:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfCEHV6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 5 Mar 2019 02:21:58 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 122CC83F51;
        Tue,  5 Mar 2019 07:21:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06C6D26566;
        Tue,  5 Mar 2019 07:21:58 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id EFA1618033A1;
        Tue,  5 Mar 2019 07:21:57 +0000 (UTC)
Date:   Tue, 5 Mar 2019 02:21:57 -0500 (EST)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Message-ID: <2112823803.3575766.1551770517713.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAH2r5mur3wySL-miCrabnHT9obskZqnBiGM9gJ238eywK73u+g@mail.gmail.com>
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com> <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com> <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com> <CAH2r5mur3wySL-miCrabnHT9obskZqnBiGM9gJ238eywK73u+g@mail.gmail.com>
Subject: Re: More tests added to buildbot
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.12.126, 10.4.195.6]
Thread-Topic: More tests added to buildbot
Thread-Index: ZURzij1iQ9vCRvkCbMUKAQwC6o/qKw==
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 05 Mar 2019 07:21:58 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

JFYI. As I know,  generic/075 generic/112 are failed for cifs because cifs doesn't support 
this function:
  ioctl(fd, FIDEDUPERANGE, fdr).

And this function test was included by this xfstests patch:

commit e7b6734822aa4ea4986c1576f0414b1174da33c7
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Thu Dec 6 22:24:20 2018 -0800

    fsx: add FIDEDUPERANGE support
    
    Add support for the dedupe range ioctl to fsx.
    
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Eryu Guan <guaneryu@gmail.com>
    Signed-off-by: Eryu Guan <guaneryu@gmail.com>


----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "ronnie sahlberg" <ronniesahlberg@gmail.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Tuesday, March 5, 2019 2:01:45 PM
> Subject: Re: More tests added to buildbot
> 
> Rather than back 075 and 112 out I reverted xfstest tests/generic/075
> and 112 to their state from a few weeks ago by backing out the patch I
> mentioned below
> 
> Kicked off
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/110
> with that change to the buildbot
> 
> On Mon, Mar 4, 2019 at 11:00 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I tried it to Samba a few minutes ago and it worked fine with current
> > for-next
> >  and also:q it looks important (data integrity etc.).  Test description
> >
> > # Test that mmap read doesn't see non-zero data past EOF on truncate down.
> > #
> > # This is inspired by an XFS bug that truncate down fails to zero page
> > cache
> > # beyond new EOF and causes stale data written to disk unexpectedly and a
> > # subsequent mmap reads and sees non-zeros post EOF.
> >
> > I have two test targets, both Samba localhost.  One succeeds for all 8 of
> > the ones that we were worried about:
> >
> > ./check -cifs generic/013 generic/014 generic/024 generic/030
> > generic/069 generic/075 generic/112 generic/125 generic/346
> > generic/469
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
> 
> 
> 
> --
> Thanks,
> 
> Steve
> 
