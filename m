Return-Path: <SRS0=fxvP=RX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49325C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 08:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185DC2146E
	for <linux-cifs@archiver.kernel.org>; Wed, 20 Mar 2019 08:11:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKsiTlKG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfCTILw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Mar 2019 04:11:52 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:46039 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfCTILw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Mar 2019 04:11:52 -0400
Received: by mail-qt1-f178.google.com with SMTP id v20so1434253qtv.12
        for <linux-cifs@vger.kernel.org>; Wed, 20 Mar 2019 01:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0crSl+mxAIML8zrU1NGz12Tnfdtcjrw3Kbtp6tXnXSU=;
        b=NKsiTlKGqABr4Mn3ahhqH82MQEnx2ykoeG9oK4PKCpE0hiG1s+xzYUR3NaBqP5780b
         THoxX+jd7x1JQL6Hrq1UgcRAHTt3hF5VUqaVR6+zAyay2cX2srpQqkqIEzunfT1VKYsA
         mBMPlHM7Bc3ryUxBduk4xXXE0yJBNssomPq6spMCvDV5ayh9ow42eNUIIELstHrXI8NB
         7gSFHu/clkWv/zWXDfWVKp0pfQR+6NOJXiIhtwmm0bW0TxtQ4FABv4oBp7gPtS6vu5jF
         8jQC2nDWFyCyn16Aje8h8ZgxvqaepLZ5JydxfQeHZVPGzkXIUBmxCVhlfjtZUEk9tm3f
         E++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0crSl+mxAIML8zrU1NGz12Tnfdtcjrw3Kbtp6tXnXSU=;
        b=YNGKkJWAhkx/NxAVAp0T4L2BLtM3m43ZKm67uLcipL39wu/hOpKeVMUO1IjT422G3m
         PaYfO7/RkEh+J/rQDKCJZQb71XvpopdENOi2HrMUJLV77T1AoGOhPGCXpU7wuUT0gaSG
         vR+ZtzLRsI8cNq2it0yWrZn1VjKafiIbE63p9w/rzkEzDrdUz2tnVBYhyBty1yvLjTRo
         QaXTPkaAP/hGrro3jB8A+zy57VaadplxYfCvxj2CFwqYBnbDSt5Nc6eVgSkhyK+fWOUg
         lq+HgadWoZy/Y/HOdqJzTQYr/MIeQfs8oKw28iprQxWhmuJ+yebhF7DRWkKJ494Ma7Ey
         8/ig==
X-Gm-Message-State: APjAAAX/zKl2oB/20K2xc+YT+E1Blsh9/ypsVhEpRgzzTkNZjWurrJsw
        pv5Rx1qURPRd0fODC/wvqsA4C7kvz6fOYk4z++E=
X-Google-Smtp-Source: APXvYqwXBLK7uhnr9nKh6WK6ESaRKuLfyLaItx2u8xxxkF7/4pg8t1860V5WPnRAceHtX5e5afJBrbNNj8pzRIEMMJo=
X-Received: by 2002:ac8:3957:: with SMTP id t23mr5778169qtb.331.1553069511615;
 Wed, 20 Mar 2019 01:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msUqScwN99iUnyEKBYOic4fMCpnjFmc=dfaJJax0XnxdA@mail.gmail.com>
In-Reply-To: <CAH2r5msUqScwN99iUnyEKBYOic4fMCpnjFmc=dfaJJax0XnxdA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 20 Mar 2019 18:11:40 +1000
Message-ID: <CAN05THTHPoTiYOZN55rVaxDhy0U8SmfQ_UJX6CpoDLyjK9edkQ@mail.gmail.com>
Subject: Re: Buildbot cifs/smb3 testing improvements
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 20, 2019 at 12:20 PM Steve French <smfrench@gmail.com> wrote:
>
> Just added 2 more tests (339 and 450) to the cifs-testing group of
> automated 'buildbot' tests, and 3 more tests to the Azure group (339,
> 450, 451), and thought it would be a good time to recap the progress
>
> We now execute:
> - 89 xfstest subtests in the 'cifs-testing' group (various servers),
> some repeated with various configurations.  This is about 3x more
> tests than were executed  four months ago when the buildbot was setup
> and we had our first successful runs.
> - 17 tests in the 'DFS' group
> - 78 in the Azure testing group.  Just in this month we have added 14 tests.
>
> Our goal is to continue to add tests as we fix more bugs and add more
> cifs/smb3 features to reduce the possibility of regressions (it has
> already been useful for that and caught a few potential regressions
> before merges).   This is very exciting, and made possibly by good
> work by Ronnie, Paulo and Aurelien.
>

That is very good news and progress for cifs.ko
so a round of self-applause and self-congratulation is
in order.
Hooray for us. We have made good progress.
(We are adopting good development practices.)

I really like how this project have allowed us to focus better on problem areas.
If nothing else, the huge number of bugfixes that have allowed us to so
significantly improve quality and how many tests are passing is testament
to the importance of a test infrastructure.


At some stage I would really like to see a Soft-ROCE server with samba+rdma
in the test environment so we can at last have basic testing of out RMDA code
automatically done before we send push requests upstream.
Anyone that knows how to set up samba with RDMA and Soft-ROCE
please ping us.

But for now, lets celebrate the progress we are making.


Regards
ronnie sahlberg


>
>
> --
> Thanks,
>
> Steve
