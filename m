Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDECC38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 17:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiJ1RMF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiJ1RLo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 13:11:44 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF9468CF8
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:10:11 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id n18so4460196qvt.11
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SGoG4+kkpjFKIiC1aB206pNaNNu8WHtjUzbD9QY9Ydk=;
        b=AHLpWHbvaJj6iAHcMzE5M/XFIEJbvJiM188nPc4sZcuDlddbnWJj2scjftscU4cF4x
         7ek2zIay9rBYB96uXxrfVQTv5OfVuThw3qxUxjLeEdzSlmmCOyQ3PY8Gh2POJX82KNSM
         0yIW2D4UUkVkaewo1+mavlSqKbWHmteTLXE9Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SGoG4+kkpjFKIiC1aB206pNaNNu8WHtjUzbD9QY9Ydk=;
        b=IeXeuVXM0x7fIzDizKFHy6WhdgsuFDmSuReIgyKyjm+w0U0jr9XczDSdnfHW1t1CAa
         brJ97rbUrkNgFnNzNRuLspSM01L3Ndh4tLbwK7MPdc3K3IoPYwU7NnRsHcw57LaZwBpM
         NxqWP2T/YrCrvO2hQQRhfonJvjab5Y5Wo/LeGQ8gxW/AFZMPb35retQ5f9GxbsgE05yb
         wQ4ez5zBhko8L7C1rWpcKMOZdoQlZFYhknLWnrjNFvvfzXSndeM1z7LJMiG2Ib7RoVKS
         7jevFuHsGBKIGzKxMcqOuVx5czZtpa4UsLpFATNXT4HWkxzWBS3/vCRVQmozHNzB53Fb
         2vyQ==
X-Gm-Message-State: ACrzQf3EvR6VGUyCPo1lWIneLJf9JFsdKc4LkVg1WkyDLrrKU3s+2Ijv
        4nBaUcNpMRFs1CZHwjA9Qw385PSc2N1ppg==
X-Google-Smtp-Source: AMsMyM5xFvZk2Sghl24aHklqZ8W2BlTLoplPeCi8kpVG5yPaKsOmreXhKry2mcIBfAltgSYpQa53kQ==
X-Received: by 2002:ad4:5968:0:b0:4b4:7d98:7ede with SMTP id eq8-20020ad45968000000b004b47d987edemr432292qvb.130.1666977010517;
        Fri, 28 Oct 2022 10:10:10 -0700 (PDT)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id cm11-20020a05622a250b00b003a4f6a566e9sm938653qtb.83.2022.10.28.10.10.08
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 10:10:08 -0700 (PDT)
Received: by mail-yb1-f182.google.com with SMTP id m125so6817574ybb.6
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 10:10:08 -0700 (PDT)
X-Received: by 2002:a25:bb44:0:b0:6bb:a336:7762 with SMTP id
 b4-20020a25bb44000000b006bba3367762mr192268ybk.501.1666977007965; Fri, 28 Oct
 2022 10:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <Y1btOP0tyPtcYajo@ZenIV> <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
 <20221028023352.3532080-12-viro@zeniv.linux.org.uk> <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
 <65441.1666976522@warthog.procyon.org.uk>
In-Reply-To: <65441.1666976522@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Oct 2022 10:09:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgMAxxw3n5gvURUV68zHr6vXbcvhXSzXdi2obKo2bK=Dw@mail.gmail.com>
Message-ID: <CAHk-=wgMAxxw3n5gvURUV68zHr6vXbcvhXSzXdi2obKo2bK=Dw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] use less confusing names for iov_iter direction initializers
To:     David Howells <dhowells@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 28, 2022 at 10:02 AM David Howells <dhowells@redhat.com> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> > Honestly, I think the *real* fix would be a type-based one. Don't do
> >
> >         iov_iter_kvec(&iter, ITER_DEST, ...
> >
> > at all, but instead have two different kinds of 'struct iov_iter': one
> > as a destination (iov_iter_dst), and one as a source (iov_iter_src),
>
> Or maybe something along the lines of iov_iter_into_kvec() and
> iov_iter_from_kvec()?

For the type-based ones, you would need that to initialize the two cases.

But without the type-based approach, it ends up being yet another case
of "you just have to use the right name, and if you don't, you won't
know until the dynamic WARN_ON() tells you".

And the dynamic WARN_ON() (or, WARN_ON_ONCE(), as it should be) is
great, but only for the drivers that get active testing by developers
and robots.

Which leaves potentially a _lot_ of random code that ends up being
wrong for years.

I really like static checking that actually gets noticed by the
compiler when you get it wrong.

It may not be entirely realistic in this situation, but it would be
really nice to try...

                  Linus
