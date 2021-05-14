Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D15C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 04:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD05611AE
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 04:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhENE26 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 May 2021 00:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhENE25 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 May 2021 00:28:57 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4C7C061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 21:27:46 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id g4so11957088lfv.6
        for <linux-cifs@vger.kernel.org>; Thu, 13 May 2021 21:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LXjBY2wuf8kJ94IxTWm6+cHYw65vuEULS3hitg9Cq2s=;
        b=qbYqQptcaBNavKfa52OlveHFg10CpKTa8y9w328QGkBjvMG7gbPcr1e2INmOxbFRGf
         Wwu6/ki5pInkk/+26N7TKdEdnVECVHv+teBycbZF7N31+HedanAraBcUbVIuOZTzvXzF
         pKnFpcsytHH4kMC6v0XUxNC96pFWkuf60IUUU5zFUNuL22RhuC5Svafq21b+ZfXlVHPd
         UWdvh64kzl7hCzf7jK+PiiC3P0nXzA9ICU/Wi62Cr1iuKYN1t4ZqX+haWvaYS90l3mbs
         uTy8nh7KQ9kZGjMUIjNzSe//uikQJIqFMmqEapOlqI4S4taq1SO+Fj4FO7GWK0BlAAZy
         0a9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LXjBY2wuf8kJ94IxTWm6+cHYw65vuEULS3hitg9Cq2s=;
        b=uYjlWpbbYjcd7/vcm8B6toGguX6wyMl8FaUkiOxFp4Ia/qcaahdtEP/T5/OacfNRnR
         sNFAWLC0v7yGdGtMs7TQEI0BHqKsrLMeoZrVnTySwmBndUrL7q39LUUaMp3mdpqhcBHx
         xCWYlud5Qeggb/Vxk/PZTbCfaP6eQjdpNzK0SySREqbNB3Oj6tCuuUTBzb0h6FduoIOf
         1n6gG83GW8+uu+cToWiGl3Iyr7LmrsQg5b5vygqdjxYetHsnYFLnJi1f/+08JJHtLjn6
         2Jmo09xE1SfCT3Fe4pqtVJuJ3moFleu0jVet5rxsx2PGaWLqcNc9eYChPFPemSPoZXOd
         3WMw==
X-Gm-Message-State: AOAM533aFyROwQSN+n1sHVpMXzc+PJJ+m4XOSnpiCNqtIsiKOSizElCq
        Ogn027cf2QNwySPF2Y7fujFpkEpSWwGn5ji6ryt+RxGj+4ZKQw==
X-Google-Smtp-Source: ABdhPJw422gachSXMP1OkQ5SZ/4+WayFrqay+lpxosebcJGvTypFYnBNGNLzwATeAwALfcZ7ziBaOSHvlSlOx7rQzhk=
X-Received: by 2002:a19:5f11:: with SMTP id t17mr31346507lfb.282.1620966464632;
 Thu, 13 May 2021 21:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtxZx3RG4Z_b6-9bsaLBMAHObGas-yPe3rttj1tXcFtnA@mail.gmail.com>
 <CAH2r5mtkjSwU4mqbkUJomdB3o0Uo84agSVS_Vn+Yz7t1uLYoCg@mail.gmail.com>
In-Reply-To: <CAH2r5mtkjSwU4mqbkUJomdB3o0Uo84agSVS_Vn+Yz7t1uLYoCg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 13 May 2021 23:27:33 -0500
Message-ID: <CAH2r5mtfVHbbucj6gtWQcE4zHXX+zdYf2XzqQOW2T7-duDr04A@mail.gmail.com>
Subject: Re: Additional xfstests
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And just added six more:

xfstests 461, 590 and 615 (and 630 and 632 could also be run) more
generally across multiple test groups

and tests 458, 518, 525 for target server of Samba running on btrfs

On Thu, May 13, 2021 at 10:47 PM Steve French <smfrench@gmail.com> wrote:
>
> 26 more tests added (33 more if you include the ones added last week)
>
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/641
>
> On Thu, May 13, 2021 at 5:49 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Did some experiments running more xfstests today, and we continue to
> > be improving - can now add significantly more (e.g. to Samba server
> > running on btrfs), 25+ tests that are now working in my quick tests
> > this afternoon.  That is in addition to the ones we have added over
> > the past few weeks.
> >
> > 051, 110, 111, 115, 116, 118, 119, 121, 139, 144, 163, 164, 165, 170,
> > 183, 185, 188, 189, 190, 191, 194, 195, 196, 197, 201, 245 ... and
> > more
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



-- 
Thanks,

Steve
