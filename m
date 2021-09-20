Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93544C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 02:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE7561183
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 02:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348659AbhIUCYI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 22:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236805AbhIUBvb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 21:51:31 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6F1C0612A5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 15:46:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id i25so74544576lfg.6
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 15:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CSvzruZ7yrH3cGppBMPI3R0ozg6uVIR6o4wSeRhpPb4=;
        b=LDjsVKKmmK9IHt+0xSI4WhrZQsDZOajyP74jFpI8bn/RHKfwdF3Ntdcp/J0brBth6M
         rTFcXjE1Q4MISd6lo+ge52o8NsB3m0d7+jizr2EyMR9RJyZIV7tZwLV46WUCc9pBPv23
         ITXPDL/fZ/d87T0+EoSZ8Tgcw0UMBm/5jCT2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSvzruZ7yrH3cGppBMPI3R0ozg6uVIR6o4wSeRhpPb4=;
        b=puvBIoqDrYBafxHz69blPqvlQKjnV1mqJv2JKWQlJYjDUoKDTp0rlpg4PVQqa2JsMk
         qiErahJU7epj3bsb7ikxxjA51wS0JbCDj6NKj/vwQDnyEFD22A4whr1spRIymm1ki/9u
         AgTJEiRt4x3kYObe1g04JdggSdzF91PS84/aBIB0KdfMs3aG9rlGtzANjTuRnxx5pQNA
         +YZ6yC5ON8qb9041M8X7f0yHyaJsyUCaR2J4938p+WcJ0qvBPxpdDalVpWP4lEJCwUuT
         P0QYFATXImt85XEy6ppHRz7h4hFDQLvsvga3AEt5xuV2aZx8q8AiHjKfiBLB+XO82Bep
         DH2w==
X-Gm-Message-State: AOAM531Cifqb0JItA6MZtTSJT1nYHuLj150t/ULtX23pHVmpWAAu+PGb
        zxnhBZdOVpBSmr6p1dGx+Me+gUz/HLB0vt8EmGM=
X-Google-Smtp-Source: ABdhPJxOUYVg/dkTqq02sEOZ5E0yu9qAqkrA7joftISzrK555VMCZ3Cc/HFIgsizEQSQjCZKNLFr0Q==
X-Received: by 2002:a05:6512:3ee:: with SMTP id n14mr20788855lfq.589.1632177964783;
        Mon, 20 Sep 2021 15:46:04 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id e1sm9514ljp.114.2021.09.20.15.46.03
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 15:46:04 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id z24so47763936lfu.13
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 15:46:03 -0700 (PDT)
X-Received: by 2002:a05:6512:12c4:: with SMTP id p4mr1896311lfg.280.1632177963635;
 Mon, 20 Sep 2021 15:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
In-Reply-To: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 20 Sep 2021 15:45:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6_m_d88kx7wWYQS+waEk6hv5szwFYvy2PjP1naj87Hw@mail.gmail.com>
Message-ID: <CAHk-=wi6_m_d88kx7wWYQS+waEk6hv5szwFYvy2PjP1naj87Hw@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server security fixes
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Sep 19, 2021 at 7:22 AM Steve French <smfrench@gmail.com> wrote:
>
> 3 ksmbd fixes: including an important security fix for path
> processing, and a missing buffer overflow check, and a trivial fix for
> incorrect header inclusion
>
> There are three additional patches (and also a patch to improve
> symlink checks) for other buffer overflow cases that are being
> reviewed and tested.

Note that if you are working on a path basis, you should really take a
look at our vfs lookup_flags, and LOOKUP_BENEATH in particular.

The way to deal with '..' and symlinks is not to try to figure it out
yourself. You'll get it wrong, partly because the races with rename
are quite interesting. The VFS layer knows how to limit pathname
lookup to the particular directory you started in these days.

Of course, that is only true for the actual path lookup functions.
Once you start doing things manually one component at a time yourself,
you're on your own.

                   Linus
