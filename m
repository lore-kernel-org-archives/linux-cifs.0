Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AE0C5ACAE
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FE802084F
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 08:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vDw24V+L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbfILItW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 04:49:22 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:44736 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfILItW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 04:49:22 -0400
Received: by mail-pg1-f179.google.com with SMTP id i18so13081803pgl.11
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 01:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nIco7KOs5UC7GPdDf53bolKaqmkba7oM6V0yA+H3C6Y=;
        b=vDw24V+LhtTUgtyfhjFf/nIIEfTh2Qdwhf51iCwa6PhHv9rTq94+DZYI2Wqoyr9XUS
         4M1sSpvpDmzKGmTOiRUxVRKeeqC0W/n/u+tYV2Key2CMqKUGsDFcUK37ojpui8gXcDTL
         g2QZSbh+j5P/qz4vj5iykWFAhr/79jYX1yP4g3+EohlUmZPZJQOCCrdqQbZBNjLs5HAy
         Clv5lAGYAu9ZrD0TW9ARm8XCdcfn/GOBuNckuvzvRRt5Xz4byhPk7zcSW38FfHBQ+0JD
         lVjNdTIhkN6LNGY6z+Xh7C4xDDSjKJgssb/cG2da3KE+sFO3luGYCF8JgBt9vjINhlph
         j1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nIco7KOs5UC7GPdDf53bolKaqmkba7oM6V0yA+H3C6Y=;
        b=ljoSxWzGM7R0UnRucmNmtMOTn5Nm9WdUcexsqjlp0lh02q2sNqFoYE7r4WApO8bvck
         zCQHDxA4hiQHod6KsvJkHNInaIDBhDnrMHc5gxSudzy1xp2GcsbL9X/NYHD8FVIiTi13
         bWSdnmXmLRDjp41cXC/XfIyOHNoa00zSy5y+ndZ9ailukBqQ2Xc78stDjKDmorMnEEaC
         1GPRTABwcR5e2WPTUgMPdRzp+JFnqurRYglgv+uxSsZNLJ2qAg260cwSX6k0pW7YgwtE
         kXdVkEKacpiYqnOWcUQJvPclZkns1b2uYgopswntl7mBa9CCJMi0uJN6sBahP9B28TG4
         Ym5A==
X-Gm-Message-State: APjAAAVZm5PMLzBjc9+QQZUudYAOWUi5kS7ntZL7Px+KrN1+jyOnUSLR
        /qqE/ji4+v/w9Z5F15Qci/G0S15G
X-Google-Smtp-Source: APXvYqy+lPHS9AT7qMNG/I9Bzv4pJ744Hlmow0+zCA6bSD2YMNktJS5o6N9Qvzn+8Zee2ICA/3+BJQ==
X-Received: by 2002:a63:a060:: with SMTP id u32mr9913241pgn.150.1568278161663;
        Thu, 12 Sep 2019 01:49:21 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e66sm36367691pfe.142.2019.09.12.01.49.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 01:49:21 -0700 (PDT)
Date:   Thu, 12 Sep 2019 16:49:14 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
Message-ID: <20190912084914.4hwfptpaqdod6f6k@XZHOUW.usersys.redhat.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com>
 <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Sep 09, 2019 at 06:23:10PM -0500, Steve French wrote:
> We have done a lot of work (with Ronnie, Aurelien, Pavel and others)
> on xfstest automation.

Kudos!

> 
> As you might guess it is frustrating for two reasons:
> 1) updated xfstests can be flaky (as the tests themselves are updated,
> they add subtle required features, or regress from time to time)
> 2) test automation can run into resource constraints (VMs trying to
> run tests with less memory than might be optimal - especially those
> run against Samba with "VMs inside VMs").
> 
> But the good news is that we have VERY good data on which tests pass
> to various servers (just as noted, need to update the external pages)
> and we should have even more data as we go through two weeks of SMB3
> testing events in late September.
> 
> In general we want to test against all typical servers and have test
> targets setup for
>  - Samba (reasonably current stable) on ext4/xfs and Samba with btrfs
> (which has various optional extensions enabled in the server)
>  - Samba with POSIX Extensions
>  - Windows (and against both NTFS and REFS server file system)
> - Azure (Cloud0

Thanks for sharing this!

Besides server type, server configuration options and client mount
options also make this matrix even bigger..

How that is handled in the buildbot ?

> 
> But would really like to add test targets for other common servers and
> in a perfect world would like to be able to have external test
> automation pull our trees periodically to run these (similar to what
> is done for the six targets above):
>   - Macs
>   - NetApp
> (and any others of interest to the community)
> 
> Obviously xfstest has a few hundred tests which only make sense for
> local file systems with block devices, but there are hundreds of
> xfstests of value, and most should run on cifs.ko and we are working
> through them but already have a very good set running.

Agree!  Thanks!

Murphy

> 
> On Mon, Sep 9, 2019 at 5:50 PM Aurélien Aptel <aaptel@suse.com> wrote:
> >
> > "Murphy Zhou" <jencce.kernel@gmail.com> writes:
> > > As $subject. Is this wiki being maintained ?
> > >
> > > Looks like the last update was in January 2019.
> > >
> > > https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files
> >
> > We have a buildbot running xfstests relatively often here
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/
> >
> > Each group has slightly different tests run, you can see which one gets
> > run by clicking on a build:
> >
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/249
> >
> > Overall xfstests+cifs is very finicky and frustrating to get working
> > reliably. Not to mention long. So good luck :)
> >
> > Cheers,
> > --
> > Aurélien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
> > GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
