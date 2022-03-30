Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3ABC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 13:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346308AbiC3Nsg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 09:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbiC3Nsf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 09:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384D9A94F2
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 06:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C89C6135B
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 13:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B55C34110
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 13:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648648007;
        bh=tDb7wwWv3gQNUIHXO6yPHzZ6yYx8eivzPA220KxjOJU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=PAE8a5AkitlD3K3qeE+gAGnucLixitusivgLU3PwE+vVqvfRSnrBV/zHKqABPNtsY
         5rWOxdA7h+iRKVtDLECCpyp5N0NtckLz6SkYVzW1KutTuLCYin2Kg1jiGIW1ENAiMu
         szGFkmJjLd82GNUUUqNPOQjcWSP7XLbYZM0GF/pfYPA8/BpeHPz9/nYAliw0uUW7xq
         tax7Fu6RXtOTeoBT0NGxLLXbm2fioHhniRByTyQuxkYCK9J/T2ctCIAJPZ4nWexsiM
         hfL4vV1ICJ0xOyvTOelCAI9mHNhpzSq6CAtUkVLYFJqB0HYOh7u0Bo1e80ECMMUmXU
         EhM5PW6JrHzuQ==
Received: by mail-wm1-f48.google.com with SMTP id p189so12293225wmp.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 06:46:46 -0700 (PDT)
X-Gm-Message-State: AOAM532LdfI31/KEwtuAJk2qs51gzW7SC9M9H6wXNSw3EbIL0y4qSo24
        FoobxgQIdaR/kHWKd0+DFIS1+UBZuK9F4gDDcrA=
X-Google-Smtp-Source: ABdhPJyMtW5lkuH+oijHdek0TRhlFrhOHdxfR9Xl7wZ987ANJzEbQ3d1BwCyOlJvyYxdsol/UIh6Ypnl5btmVwJWkss=
X-Received: by 2002:a05:600c:214a:b0:38c:aa5d:1872 with SMTP id
 v10-20020a05600c214a00b0038caa5d1872mr4611819wml.9.1648648005188; Wed, 30 Mar
 2022 06:46:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Wed, 30 Mar 2022 06:46:44
 -0700 (PDT)
In-Reply-To: <YkQdYwyBKl5hxJHu@infradead.org>
References: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
 <YkQdYwyBKl5hxJHu@infradead.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 30 Mar 2022 22:46:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-=nER-6QeqLUQegY1=Axt1rd2hkT7d7-HCRHzH=aKfrg@mail.gmail.com>
Message-ID: <CAKYAXd-=nER-6QeqLUQegY1=Axt1rd2hkT7d7-HCRHzH=aKfrg@mail.gmail.com>
Subject: Re: Regarding to how ksmbd handles sector size request from windows cllient
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-30 18:05 GMT+09:00, Christoph Hellwig <hch@infradead.org>:
> On Wed, Mar 30, 2022 at 04:53:32PM +0900, Namjae Jeon wrote:
>> I have received a report that the problem occurs when mounting an iso
>> file through windows client on ksmbd & zfs share.
>
> ZFS violates the kernels licene.  Please tell the reported to go away
> as this is completely unsupported.
Okay.
Thanks for your reply:)
>
