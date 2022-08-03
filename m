Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5000C00140
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 00:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiHCAz0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 20:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiHCAz0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 20:55:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A35FC4
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 17:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BEA8B82012
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 00:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13DCC433D7
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 00:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659488123;
        bh=wSi44aMGHDVvDR7izB29i6aCNKPMdqAeBDRPr+wCS6M=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ZJdO7S2bQT5clzh+t9h0z9xxf62i21mBguoLZ6rx7KZMv89+E3CtlVhqekIMz4gti
         X8L8DBrRZL8Owi1J7UKWBRZP/WTfxnj7AyVEfG+8kK6KHjuqCkFZgcOELF2qbPb5RW
         uQoXLVsEzaYvan4sygjfkyz7Xh2KyrP+xvc/tOjpmNNB9/SKTPTj7DrmIp+uDm+mnk
         H/qDpBS85G61xFb2vdaRVVlPRK7OyT8d0xjq4kE+1ey/0bozdRd26j8vkqmBSzkpkQ
         PlPFiDMCxMVkyrzITtuldS47gLYrAqAtUodzYjpE7fGepnnYKAIuY0fan9J2G9veve
         wAJaBw0h10tBg==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-10dc1b16c12so19162874fac.6
        for <linux-cifs@vger.kernel.org>; Tue, 02 Aug 2022 17:55:22 -0700 (PDT)
X-Gm-Message-State: ACgBeo1pb5X6gsPGkAJ+1AstYyfu5X40zxcwE7qktFoKkfhkSZOrIfqe
        CT3R2i8yA70FP6wmM981C9aRz2LXBzWexiaTvC4=
X-Google-Smtp-Source: AA6agR559jT8xHot4e9UtA9QbzL7HCucasTcZZp5bfObDf0ydI+TkYqkKjCujL0L6kzzVYkakKqX63mhR64MVjN4Ca0=
X-Received: by 2002:a05:6870:f69d:b0:10d:81ea:3540 with SMTP id
 el29-20020a056870f69d00b0010d81ea3540mr906972oab.257.1659488122075; Tue, 02
 Aug 2022 17:55:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:41a4:0:0:0:0 with HTTP; Tue, 2 Aug 2022 17:55:21
 -0700 (PDT)
In-Reply-To: <3343812.1659453040@warthog.procyon.org.uk>
References: <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com> <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk> <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com> <1922487.1653470999@warthog.procyon.org.uk>
 <3343812.1659453040@warthog.procyon.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 3 Aug 2022 09:55:21 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-sWDpGKZpns=yW-TcOytbVZXdFK9h2BGdmP4g0+p6v-g@mail.gmail.com>
Message-ID: <CAKYAXd-sWDpGKZpns=yW-TcOytbVZXdFK9h2BGdmP4g0+p6v-g@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     David Howells <dhowells@redhat.com>
Cc:     Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-08-03 0:10 GMT+09:00, David Howells <dhowells@redhat.com>:
> David Howells <dhowells@redhat.com> wrote:
>
>> With that, iWarp works for me.  You can add:
>>
>> Tested-by: David Howells <dhowells@redhat.com>
>
> Would it be possible to get this pushed upstream as a stopgap fix?  iWarp
> still doesn't work in 5.19 with cifs.
I will try this.

Thanks.
>
> David
>
>
