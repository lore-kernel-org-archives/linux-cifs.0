Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 406AFC43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10B0C20684
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ca88VfZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfCFA1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 19:27:05 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:38075 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfCFA1F (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 19:27:05 -0500
Received: by mail-pf1-f172.google.com with SMTP id n125so7000760pfn.5
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 16:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qjs1R6+sS3BgZAh6PvNRd5PDP4c0IJgiwGlmNbD8roE=;
        b=Ca88VfZOw2Ybo2C7rz9Ur0jwUgn0gbOxLMYFNqOxkgvv/g4nb/FFPyGXlw9FcRmoT3
         kxc6tcboiGYo7ocZFrwO9Qf7+KOJNuEjDRPOqBjkYhMGbYtwQdFau0OCV4GhnkqnTvxd
         b4mWDcoeSLbLmmKamop9QKhWuG2BShHjMMRruxryhGiWlMD2GdifP28n5MgT3VWGHlmD
         HyjAjwAprOXy/Q8oL4d8+BowjbvSxE2nEi85bX22gTZPj5xf2M8EjxWFIiYrULDXSFnP
         7gEY7Xhisp0Plde3or41qCWUV8JQfYovji04Md6bcrFDXqMOGdXKjGck7f/vR1zfjHnR
         TQLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qjs1R6+sS3BgZAh6PvNRd5PDP4c0IJgiwGlmNbD8roE=;
        b=rovrPUn7aoCoOh8Ya67g8dLoX2E055cNgEI/BsBoQp9S/ZOO6gH+PEXUmAbMuagI76
         pg5/PgwNIoMjadQrB+Tp5pRtIAqP3pGKEjCchbwCy/FNd6ewKq4IKyRandxqyo4FEKWv
         YAPZ3oKa9UfdxIjBu2tQHMWskZjl6U0Gg/DNpHwXihulINg8PthiaIrCnz0q3UvzvVlQ
         w+Hx56lr1afNOniqTNKWOXLDCfOdBfYRuekDicZV6SEESyODHDQFxm+vN7sJvi6SBDA8
         eTyVz3GXmJ0x6Z4bbnCwswBA6uWFGDA4l57DdRDOYimznn6CJ+xogx23U/iX2aRuE79E
         SIiQ==
X-Gm-Message-State: APjAAAUZkZ/sVahlV8t25PC0rKakf0RblAdUtueml81AGGuqxE5mDFvo
        XcAj9hvBdABNHIYfrrtPhFSPOkttNDyMBBgAX45kgnRN
X-Google-Smtp-Source: APXvYqz5bi+4V2wue+TgSBIGUucMhAEgSnZTOUVKwwkXdNHaIq3/u+Vz5ibFbTQXwl58kqTMcDxr5Y54TQvRc0j742s=
X-Received: by 2002:a62:ac10:: with SMTP id v16mr4648570pfe.111.1551832024255;
 Tue, 05 Mar 2019 16:27:04 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5ms8C9cQSTY51neWvSRCahJ-dSMekZVza-9fA=LdZBY+qw@mail.gmail.com>
In-Reply-To: <CAH2r5ms8C9cQSTY51neWvSRCahJ-dSMekZVza-9fA=LdZBY+qw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Mar 2019 18:26:52 -0600
Message-ID: <CAH2r5msbsfxHULn--6Y4SXxQRezrOhU65JMXRKA0rV0bhCMNcw@mail.gmail.com>
Subject: Re: xfstests passing again to current for-next
To:     CIFS <linux-cifs@vger.kernel.org>, Xiaoli Feng <xifeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I also reran (directly on the buildbot)  the subtests which seemed a
bit slower in that run earlier today - and most looked fine with
possible exception of test 112 which seems about 20% slower than I
would have expected.

generic/001     163s
generic/024     12s
generic/100     278s
generic/112     319s
generic/117     141s
generic/124     49s
generic/129     530s
generic/133     454s
generic/198     3s
generic/247     95s
generic/249     2s
generic/285     8s
generic/286     30s
generic/310     311s
generic/406     4s
generic/432     3s
generic/524     16s
Ran: generic/001 generic/024 generic/100 generic/112 generic/117
generic/124 generic/129 generic/133 generic/198 generic/247
generic/249 generic/285 generic/286 generic/310 generic/406
generic/432 generic/524
Passed all 17 tests

On Tue, Mar 5, 2019 at 5:45 PM Steve French <smfrench@gmail.com> wrote:
>
> Moved the xfstest git branch back to December 6th (just before the
> testcase problem patch Xiaoli pointed out) - and cherrypicked tests
> 524 and 528.  Looks like current for-next worked fine
> (http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/111).
> Will  kick off the cifs-testing bucket later today.
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
