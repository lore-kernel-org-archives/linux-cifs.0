Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D06C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 01:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61B5420663
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 01:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pSz+glIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfCFBRI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 20:17:08 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:37360 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbfCFBRI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 20:17:08 -0500
Received: by mail-pf1-f175.google.com with SMTP id s22so7099675pfh.4
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 17:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LcNZNxw+kxjVxJ34fNmMVjt2501JTYvH8A6nbmwKoL8=;
        b=pSz+glImeF4B67jI3dGmaUH27U6X3wpjonoG3ImAmUWslrn+DExgbFUInryVZzfBZW
         VNPEnRPZt1kSz3gBl7pStZTKodymR9Jc3VPMGi/aJ0CDo6uEF8KqTS3gN6Yn818sShLO
         VXNUYAc3wvi4v8hZ4obwLfSUpr0uCSyW+OJDfwpE0GKXeuRzkdzUTK615EzGMKNvXCCI
         z7wsvqHfUC44Ue7vPslUgoA6k3xZ7ekMxDJLvMaOMlSqw6na50vaJozt+aDpnpSViq1x
         IJExNZl8A18XwK3w6Caib/WCc96GwqnYcfHY4dutCEmfxrb/ZINYZervnzIAEakANH+H
         e2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LcNZNxw+kxjVxJ34fNmMVjt2501JTYvH8A6nbmwKoL8=;
        b=A+xbBrZbf+ePudUJ74+Xgj+kgr+8Hb9wgqaXsf5icX8+gyZUagP5JCIrKbhXsAMQ65
         KZ+5ySZKmtfGhxrHdh7D+l2SB0U0P0Y0hwvnldTEK0uGBrFNYSqazOkhevI8sHlOTrrq
         gI4j5+fc6GxQ6suQSJ98bK9P3QM288Os1B3jvH0pVAWjHK+YNDwp/YXeWzCQKPiqe4ME
         Az6Y4wbq47di5oue+BkdyAxOdc73ZxrMO35zpl0QApAZ1ocdDNCwDeiTT8+WeaCDA9Zn
         ggI0nzzwfSHcDU9RogsYABjW7sU+bIpWJH1fGQyoxXSxdj20ZepXO1u25WEddRlNr9NP
         ztQg==
X-Gm-Message-State: APjAAAUC6NlBk7CX4AcNh1JNaZePifJBAXQ1VdZxh/S7491YZYPk9FkQ
        CvD+pb06+EHADfoRvoY7uT0NZT8/etZFCsHWVOwR/Q==
X-Google-Smtp-Source: APXvYqyw5N5tPGMBwzeTDWyO68OURJ7y6TUl+BApegLKi+CDBbbM8IpZMZHDDYZie8vBa9xoo6y2tbK5Wg+oTOFftrU=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr4181268pli.24.1551835027320;
 Tue, 05 Mar 2019 17:17:07 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5ms8C9cQSTY51neWvSRCahJ-dSMekZVza-9fA=LdZBY+qw@mail.gmail.com>
 <CAH2r5msbsfxHULn--6Y4SXxQRezrOhU65JMXRKA0rV0bhCMNcw@mail.gmail.com>
In-Reply-To: <CAH2r5msbsfxHULn--6Y4SXxQRezrOhU65JMXRKA0rV0bhCMNcw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Mar 2019 19:16:55 -0600
Message-ID: <CAH2r5mskbS9WVKYYr++LP6FpkH1a6JXVZivuyX3T+ZqmG=a9pg@mail.gmail.com>
Subject: Re: xfstests passing again to current for-next
To:     CIFS <linux-cifs@vger.kernel.org>, Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And DFS set of tests passed as well

On Tue, Mar 5, 2019 at 6:26 PM Steve French <smfrench@gmail.com> wrote:
>
> I also reran (directly on the buildbot)  the subtests which seemed a
> bit slower in that run earlier today - and most looked fine with
> possible exception of test 112 which seems about 20% slower than I
> would have expected.
>
> generic/001     163s
> generic/024     12s
> generic/100     278s
> generic/112     319s
> generic/117     141s
> generic/124     49s
> generic/129     530s
> generic/133     454s
> generic/198     3s
> generic/247     95s
> generic/249     2s
> generic/285     8s
> generic/286     30s
> generic/310     311s
> generic/406     4s
> generic/432     3s
> generic/524     16s
> Ran: generic/001 generic/024 generic/100 generic/112 generic/117
> generic/124 generic/129 generic/133 generic/198 generic/247
> generic/249 generic/285 generic/286 generic/310 generic/406
> generic/432 generic/524
> Passed all 17 tests
>
> On Tue, Mar 5, 2019 at 5:45 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Moved the xfstest git branch back to December 6th (just before the
> > testcase problem patch Xiaoli pointed out) - and cherrypicked tests
> > 524 and 528.  Looks like current for-next worked fine
> > (http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/111).
> > Will  kick off the cifs-testing bucket later today.
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



-- 
Thanks,

Steve
