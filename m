Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9097C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 08:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E3E60FC0
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Sep 2021 08:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbhIMISw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:18:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237874AbhIMISv (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Sep 2021 04:18:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42F9E60EE9
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 08:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631521056;
        bh=Ymwjqp+FOMrGcOz3jmz8G/XUFS9fuxhjwZpz2AJA1qQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Kbtm5KuQDTmyMt/rDt9zUEz0idv6n3QDyHZilRp84+zsSzq1qb98nIxD59dSqyFnt
         IJp8A8jmfDJ/afX3V6fPBbtlrxbV5HPtLFWWJYD9FAG1JzXhOfEgJk5ueT1Kk1OKd1
         auAodyx1xP2yqTBtZ+ujLYmpRn2UN9tAVYlFTXIh112fQRWGYCR3q+jO+yolh9Om4R
         eq5ueXW08TJMPG3FcTGxrKuDvsWfufLGkCPrx8mS1tzYQVqNBEL4tjFezl4txQCAjA
         F4Rtip8dRL1NP2YEu33j9OD+KS2C5+Sfjs9wRvsYeywz8SBV5aA81URfiZxGdK3mPa
         c+Za0rAl8BYhg==
Received: by mail-ot1-f41.google.com with SMTP id a20-20020a0568300b9400b0051b8ca82dfcso12248518otv.3
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 01:17:36 -0700 (PDT)
X-Gm-Message-State: AOAM533AV7MSzh0HqOpXjshNLwqCeERaIN6Zm3rE7VBEPY8WX6OsTuJK
        Vxnm3Wj5huycw5LpJZP2+Jr20kXYhinFRM7hwdg=
X-Google-Smtp-Source: ABdhPJzo36hF+3qXTtpK7yiahLk0aZCwUQ+5Kmg2micOAItwxpp4VweUHgEv64gxAunypwc0zZWCS88WIShIeWY1JCI=
X-Received: by 2002:a9d:5e05:: with SMTP id d5mr8527438oti.61.1631521055650;
 Mon, 13 Sep 2021 01:17:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Mon, 13 Sep 2021 01:17:35 -0700 (PDT)
In-Reply-To: <CAH2r5msfMxY5NSULfUr91j-QLJV7U0CD_BsyzvuNDRvBF7pcTA@mail.gmail.com>
References: <CAH2r5msfMxY5NSULfUr91j-QLJV7U0CD_BsyzvuNDRvBF7pcTA@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 13 Sep 2021 17:17:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8jndu748oK92Q3xEASFT_5fjX4GuvJxCG5GgUpQANrzQ@mail.gmail.com>
Message-ID: <CAKYAXd8jndu748oK92Q3xEASFT_5fjX4GuvJxCG5GgUpQANrzQ@mail.gmail.com>
Subject: Re: newly passing xfstests
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-13 14:54 GMT+09:00, Steve French <smfrench@gmail.com>:
> Do you notice additional xfstests that we should be adding to the
> ksmbd buildbot group?
I am relying on the xfstests test list you shared. I haven't recently
ever run the total tests. And some tests may have pass/fail
differences depending on the local fs (i.e. reflink).
>
> e.g. I noticed xfstests generic/115 116 and 121 passing ... do you see
> those passing in your test setups as well?
Yep, You have shared these tests passed since ksmbd support
FSCTL_DUPLICATE_EXTENTS_TO_FILE ioctl. i.e. Local filesystem need to
support reflink.
After a while, I'll re-run the total xfstest tests including them and
share if there are any additional ones.

Thanks!
>
> --
> Thanks,
>
> Steve
>
