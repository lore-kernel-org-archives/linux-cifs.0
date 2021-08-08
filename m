Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747F4C4320A
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 20:34:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5581D60F38
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Aug 2021 20:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhHHUe0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Aug 2021 16:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHUeZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 8 Aug 2021 16:34:25 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14E4C061760
        for <linux-cifs@vger.kernel.org>; Sun,  8 Aug 2021 13:34:04 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id n6so7334761ljp.9
        for <linux-cifs@vger.kernel.org>; Sun, 08 Aug 2021 13:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ABwPSDZlngzaPtZ4oTTKY3RQYyDa6eKhnI9WnZtU/9A=;
        b=K80HLdHGRNvK+x5C2D5UqSJESwk8kTR3hRr5z6qZPhqmhNzz2CS+K7M1dd64SyiXkC
         4LHA1p5xp1bql3T9GSwJTgC+e6rmOAoYOcZlJDIWIRmt9Jq+R5gHrIzWIafzLupwMly0
         uXSO6z2CoaS9dayED/ASq4UZCIAZHxiOLDF9cdZHk4Ogf79JpoJk1kyNT807kqtFc3ZI
         yvU8w1gc58yv66aXEivStqcrdKjf9LrYGFMO3eY231e7FySy8QAtEgcZm7owimvAWdsm
         TXAKtOBWKWRllhw5xM24GvCtrlASNTMcAoAZaYoNIHw8Xw34dzGFETl59IjPrHdLPlAC
         Xnsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=ABwPSDZlngzaPtZ4oTTKY3RQYyDa6eKhnI9WnZtU/9A=;
        b=B6onSzhc909mE3aHPr0nTh3MlKmGt5vlc5EqkFGS9AW+8zL1O8EBiXhJV2NAKyc75K
         glqVk+C50w/I3i6jo9+NnJaXls1z9bNquscNXxdaoiuH3YEjpAP9rDWE7jefZNu9VInG
         s6auebq+NNE3+56OwExnBjC+cclQWgQM+oijdYyZntkJrdjvxsUWYtFepTOLC1LpfiNR
         QwZPBU7YSJzWkInAEs+82SWVMFR8fC1UaKbAvwnIRXs2xqlh31Q15Gcw3um3bTlbzBjI
         L8PgDK+uR5dEVhO5cRVYSd9QsM9zVWXfrGQclVhmFIAJnfKuttzCCdo7+5aFJ1DBGQyG
         ORPQ==
X-Gm-Message-State: AOAM532BKQcZZsrXkUMsuMlZT7C1xVI6o9LD5hgSjBxIRfNFcFuGZbto
        /0KKBDUtwYfQZJWatu9E8jAnuM57UKeLL/wwFtanUZWR7Odkmw==
X-Google-Smtp-Source: ABdhPJwgerpmLM4IdN/YxHxNXohSuQorVEnYW4yCFoCvE3uU+lJBwfygpFPHT7CN4Psla+I8mEOHPaPAQBlihmR6iMU=
X-Received: by 2002:a2e:a44a:: with SMTP id v10mr13556805ljn.497.1628454843053;
 Sun, 08 Aug 2021 13:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAJK_Yh-m-p8r=9WhrHn=V5yMWBpYZCRZeqWyci+NbUEGNPwpYw@mail.gmail.com>
In-Reply-To: <CAJK_Yh-m-p8r=9WhrHn=V5yMWBpYZCRZeqWyci+NbUEGNPwpYw@mail.gmail.com>
From:   =?UTF-8?B?U1pJR0VUVsOBUkkgSsOhbm9z?= <jszigetvari@gmail.com>
Date:   Sun, 8 Aug 2021 22:33:27 +0200
Message-ID: <CAJK_Yh_tWGoRkCSfSwPBHi2SAPi9cKeyb8L=Lg1Gx=xtEDY29w@mail.gmail.com>
Subject: Re: rsync copy operation fails on a CIFS mount
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dear Members,

I work for a company that (among others) sells Ubuntu-based log
storage appliances. I ran into a problem, where I'm trying to copy a
large amount of data over to a CIFS mount from a Ubuntu 18.04 based
appliance to a Windows 2012 R2 Storage Server, and rsync fails after
1-2-3 hours into the copy operation with something like:
rsync: failed to set times on "FILENAME.U5EgGX": No such device (19)"

and I see a number of kernel logs just prior to that, that look like this:

kernel: [3819786.441711] CIFS VFS: No task to wake, unknown frame
received! NumMids 1
kernel: [3819786.441717] 00000000: 6c000000 424d53fe 00000040 00000000
 ...l.SMB@.......
kernel: [3819786.441718] 00000010: 00000012 00000001 00000000 ffffffff
 ................
kernel: [3819786.441720] 00000020: ffffffff 00000000 00000000 00000000
 ................
kernel: [3819786.441721] 00000030: 00000000 00000000 00000000 00000000
 ................
kernel: [3819786.441722] 00000040: 00000000

I also tried to google around for a while, and I found the same exact
package hexdump on the linux-cifs mailing list from 2012:
https://www.spinics.net/lists/linux-cifs/msg06634.html

In that thread the person reporting the problem failed to reproduce
the problem a few weeks after reporting it.
There it was recommended to try and mount the share with SMB v1, but
that is out of the question nowdays.

We tried forcing the mount to happen with vers=3D3 and 3.02, but it made
no difference. The error still re-occurred.

Best Regards,
J=C3=A1nos Szigetv=C3=A1ri
--
Janos SZIGETVARI
RHCE, License no. 150-053-692

LinkedIn: linkedin.com/in/janosszigetvari

__@__=CB=9AV=CB=9A
Make the switch to open (source) applications, protocols, formats now:
- windows -> Linux, iexplore -> Firefox, msoffice -> LibreOffice
- msn -> jabber protocol (Pidgin, Google Talk)
- mp3 -> ogg, wmv -> ogg, jpg -> png, doc/xls/ppt -> odt/ods/odp
