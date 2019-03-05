Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093A2C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C154820663
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 05:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Df3f+hxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfCEFRO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:17:14 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42942 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfCEFRO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 00:17:14 -0500
Received: by mail-pf1-f175.google.com with SMTP id n74so4756337pfi.9
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 21:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJMy36/29NS3k4DeHfvpVi6yLEMC8gtVFNLT50Cd3kc=;
        b=Df3f+hxKgtvIUh87iv5MKZot2QGNLYhG9dQGs+C+1FXNUIs++S/7FvJF/jhL84G5qg
         Rr6fRV3b7eS15lRWJQQe+cRF8oR3c5cLX1NnwhBgl0d5yDCGosRputqp6ejWejae8J+J
         NRaPZd6Iqyoxlk/ZmyzW/2hvwZuTKY8SGerC5HZEWZZ9yXXkMuRIx4ahCGPuo9TJJ1xI
         FUPvFnZiNL3tc8QNw/EBOLmbn7XAqxwUewHZHf5yG7Jbp7eb8N1EtpHd/GKK+aS/uC1f
         6ZjVKs19qrRLLPzS1rY35C57EPkhTx039cMGgiZqIFvXtoFvPYPwuA04yNQ6Nd3GII23
         58kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJMy36/29NS3k4DeHfvpVi6yLEMC8gtVFNLT50Cd3kc=;
        b=NeNSCm0yeeGtqRGQ8hhuKlrEVhL5e4peB6x01ylc52caS7aC3qdFV5UZ2j+0eQx+/s
         yQBVQGdupJGU4s41EoGl6pKYVuk051RMdwh35ejO2zd3NGUzwAlkX7MfEdWRzdOhcCFi
         Vpo0SmfXpVGmBCyVmbVsBkdJQT+8VXvdR2EGInEn8ZoZD58THVFyjJw+G6GNa0j6QSDw
         CdPrY2CrCCq/+1HTcI9GBKWbEwtsBGu9fiZx0+Rf8EoYHV5duYEjcK+nEYeRgn+zgn1o
         rV2OiUfcK1jbQk0w4eC0TkKeImYspZhbsOj2LTeomD2aOtdVXqyH+WaUQG46rjkdgJiN
         TbwQ==
X-Gm-Message-State: APjAAAURL+HnBybwANMbp5ZZcPnfbTVRJfb0T+Zhh42S0Hu7GmK4Eo6U
        uH6N3LZKIZ3YxGT/mT2iyBxDtkoLdbQAjPsAxk8=
X-Google-Smtp-Source: APXvYqwVAUH10TPw7a7BQXyNNNNmNGYLh97NymuK/oIbQRdRqxI1wZY3Xa2a3BoZCdytOJgyaLIugWMey0Tc3TK8DkU=
X-Received: by 2002:a63:1053:: with SMTP id 19mr22218388pgq.55.1551763033022;
 Mon, 04 Mar 2019 21:17:13 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
 <CAN05THTyukBUmbLu-pB+xjLQDq_LByxz=twkUEP1hktGdjdbBg@mail.gmail.com>
 <CAH2r5mvF-gD08nwcXFmu+_=ZRcn5nC7t2DcaSBg__BpFMW5oyw@mail.gmail.com> <CAN05THSm08PBhPCT4sEyx8_F2f63MkxZY0Sk46iMQL9BBg1_4w@mail.gmail.com>
In-Reply-To: <CAN05THSm08PBhPCT4sEyx8_F2f63MkxZY0Sk46iMQL9BBg1_4w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 4 Mar 2019 23:17:01 -0600
Message-ID: <CAH2r5ms2_hoaiF=_4wTG64UHNMUG1BGnKeW_QS_bj1c7jQKxaQ@mail.gmail.com>
Subject: Re: More tests added to buildbot
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ok - sounds reasonable - although that sounds like a bug (that a
simple test like this could fail against Windows)

I am a little puzzled about the xfstest change a few weeks ago that
affects tests 075/112 (now that our xfstests have been updated)

I think it is due to it running more loops, due to seeing we support
preallocate:

running strace on that I see an ioctl ioctl(3, _IOC(_IOC_WRITE, 0x58,
0x2a, 0x30), 0x7ffdf08d0080) = 0
strace xfs_io -f -c "resvsp 0 1" testfile
so that succeeds ... so presumably it thinks we support fallocate and
then do the extra loop which fails?!

On Mon, Mar 4, 2019 at 11:07 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
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



-- 
Thanks,

Steve
