Return-Path: <SRS0=fTzl=XL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52996C49ED7
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 08:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F69214AF
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Sep 2019 08:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPheMWPf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfIPIra (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Sep 2019 04:47:30 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45250 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfIPIra (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Sep 2019 04:47:30 -0400
Received: by mail-pg1-f171.google.com with SMTP id 4so19401445pgm.12;
        Mon, 16 Sep 2019 01:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gyn3btCz9cNXYEqkvH7pmaZl3Kq7Fu1fE9/8V04nDY4=;
        b=LPheMWPfWx/BFOboUl96lKkaxRdmSNiIHB5ABSlQfLq60whuuTvqc6V5F1uMOiwDiS
         LsmhNm5PiuFje1CXtYBgTvXrZvKtm4M7n6ojX1mtdFYw3hIrFC+0iaMmCEDQ24AetR24
         M/Ij6SpCLwyrWW1IA9V0tmkf97g4MGYU/Taa4IGg1mA7oFpmqd/lrYGPWgmZtMEbxKsA
         oDOxtoHqOl2TSvQS8s/yRnCMSmey9vjhLxnBWlZCtn9SHFgdoaHCLRBWMbfvMJ0moSr6
         zuZUxYtuWKlxaTCxqg2f6gw5zt9uD92Q1TIokcAhDMffB7NBnL2du4UpbrT9b2EutcMW
         5sDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gyn3btCz9cNXYEqkvH7pmaZl3Kq7Fu1fE9/8V04nDY4=;
        b=ZBsmFomHIzusqh4eeipEbo98ULJiYzW8x4kpeBozTAQkSiGy3xVj4AtkX8ABgi+Scl
         K//PJdB3P3eFB0n6i8I06azCpa4NhwBIF/Rm4+txuOAAnMmF9HMahPz7FsFAep0ROt5q
         MXWe6YC2tB4aRJ5gb03Nmd5onN2z/pcZPU9NivezaBfgnYFAdKQG7Itc9SJq5FJYxYfQ
         4xFPLYJKLtAcELENZ9llfAwL4yVdXcWT6pyKrdg7DpAaGkLDipxhBjJjpvUTLTCfWVvt
         66vWXkX3bJQ/2qi576Wrdrk2J26ifQmAoFVTg0DNJnsi5k8xx7B9JgAOM2XRbfWZNGgm
         f1ww==
X-Gm-Message-State: APjAAAUgzboT5/I/In0ucjiho2vm/kn8f2TdR+GRCgtONnqTZu5oLwtC
        EEcV1n3iavwiX75fFisUYtT/NFd2
X-Google-Smtp-Source: APXvYqxQ7x5j3ArgClajmu/ymyOGy1G0n52CRk9oWIfvxSRpUkvFTHQvzef6b61uyH97KPLlfAWK1A==
X-Received: by 2002:a62:8209:: with SMTP id w9mr32821817pfd.112.1568623649481;
        Mon, 16 Sep 2019 01:47:29 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 127sm4736675pfc.115.2019.09.16.01.47.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 01:47:28 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:47:20 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, amir73il@gmail.com,
        fstests@vger.kernel.org
Subject: Re: seek sanity check failures
Message-ID: <20190916084720.l4ln6l3tv36aqbja@XZHOUW.usersys.redhat.com>
References: <20190915020810.jy5pxjtk7buenmqk@XZHOUW.usersys.redhat.com>
 <CAH2r5muncmiTKBuaYEie6L7PeXmQ-MjKsBy9WrET4v85f36=qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muncmiTKBuaYEie6L7PeXmQ-MjKsBy9WrET4v85f36=qA@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Sep 14, 2019 at 11:11:49PM -0500, Steve French wrote:
> Test 285 and 490 broke when xfstests were updated on the buildbot, and
> are temporarily deleted (commented out in the buildbot script).  We
> had a difficult choice - update xfstests and add 10 new tests but
> disable 3 tests which broke with updated tests, or not add the 10
> tests by keeping running last year's old xfstest test suite.
> 
> Ronnie and I did some investigation of why 285 and 490 failed and any
> additional data would help - since we both got distracted with other
> features and fixes

In Apr 2019, Amir updated seek_sanity_check:

(xfstests commit 34081087748)

pwrite a file, then double the filesize by ftruncate, then SEEK_HOLE.
If SEEK_HOLE returns EOF, and fstype is in this list:

+       btrfs|ext4|xfs|ceph|cifs|f2fs|gfs2|nfs*|ocfs2|tmpfs)

It's the default behavior and it's NOT allowed. Test prints error and exit.

If cifs is removed from above list, all seek sanity check tests pass on cifs.

cifs SEEK_DATA SEEK_HOLE support were added in May 2019 with Linux
commit dece44e381a

A xfstests patch removing cifs from the list can address these failures,
but is the "default behavior" of SEEK_HOLE on cifs expected?

If it's not expected and need to work on, we should keep current status.

Thanks!
M

> 
> On Sat, Sep 14, 2019 at 10:14 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > Hi,
> >
> > On latest Linus tree, several seek tests fails:
> >
> > generic/285 generic/490 generic/539    fails on v3.11 v3.02 v3.0
> > generic/285 generic/490                fails on v2.0 v2.1
> > generic/285 generic/448 generic/490    fails on v1.0
> >
> >
> > Are they expected or being worked on?
> >
> > Thanks!
> >
> >
> > FSTYP         -- cifs
> > PLATFORM      -- Linux/x86_64 hp-dl380pg8-14 5.3.0-rc8+ #1 SMP Thu Sep 12 07:31:21 EDT 2019
> > MKFS_OPTIONS  -- //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch
> > MOUNT_OPTIONS -- -o vers=3.11,mfsymlinks -o username=root,password=redhat -o context=system_u:object_r:nfs_t:s0 //hp-dl380pg8-14.rhts.eng.pek2.redhat.com/scratch /mnt/testarea/scratch
> >
> > generic/285     [failed, exit status 1]- output mismatch (see /var/lib/xfstests/results//generic/285.out.bad)
> >     --- tests/generic/285.out   2019-09-12 08:04:14.120990746 -0400
> >     +++ /var/lib/xfstests/results//generic/285.out.bad  2019-09-12 08:36:49.151230335 -0400
> >     @@ -1 +1,3 @@
> >      QA output created by 285
> >     +seek sanity check failed!
> >     +(see /var/lib/xfstests/results//generic/285.full for details)
> >     ...
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
