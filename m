Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4703C6FD1C
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 05:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCXFbr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 01:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCXFbq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 01:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3172DF
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:31:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B78628CD
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 05:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7421C433EF
        for <linux-cifs@vger.kernel.org>; Fri, 24 Mar 2023 05:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679635904;
        bh=KHHcBACPX85+RiJwXdRio2bfuBhdJMJZ/1Gt9iXEs1A=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=au4Wqk6BnIa8i7IQIQDGtjDeAGa5CJ3JKlvjlSIO+/Yi3p2FWdRWpopZshOrAYiQA
         cFT1V0v6N60gyvhLx9GbRv2dgnWDh5f1rfUy6byqNiHHddbHPwXiEbuyM97AL24jUm
         M+RFtoKe/EkCZuqyINbzAMkUS1jOjircYqjLgu9CJUyMPOkFwEcG1slvtBiyXuXP4X
         9B9HQpgngdUzhsxFbJoha0UiAJXgD8EvMYxV6qv05OcNHUX7MFGJpTmJeDzZZ/rJwi
         x06G5Q+XTsXMMJwVQoZcdVLpjwqiCuTkgkoqUL7r0KpmBd2Lp307/ROVm+ZIUlIxYQ
         jsQCs58VyzgqQ==
Received: by mail-oi1-f172.google.com with SMTP id b19so533241oib.7
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:31:44 -0700 (PDT)
X-Gm-Message-State: AO0yUKUEA315CKByZv1rLvbDGmkqag37OLxjXICNmA9BcC2bZNKtcIXX
        XU+eDzzjpQ26A3AZNrkcHu+Wx3GF4vV07Mwkp3k=
X-Google-Smtp-Source: AK7set/dgdEkNG5FP2AWV3lXSfVAHyZhuzJmhWLWPBjL18+5JMRblNxWDmCwK24Aw5eQpP5oR20kqWWEx9pPjyfe7CQ=
X-Received: by 2002:aca:1b09:0:b0:383:fcba:70e6 with SMTP id
 b9-20020aca1b09000000b00383fcba70e6mr303896oib.1.1679635903915; Thu, 23 Mar
 2023 22:31:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Thu, 23 Mar 2023
 22:31:43 -0700 (PDT)
In-Reply-To: <CAH2r5mvd7tSEX-sh6tLhxS=5FbX6ZOVuwR2FoEbjXnnGksSiXw@mail.gmail.com>
References: <CAH2r5mvd7tSEX-sh6tLhxS=5FbX6ZOVuwR2FoEbjXnnGksSiXw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Mar 2023 14:31:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_zHm5QKzLNOOHs8Cwewq33nC0YJ02Jk2AZga9UK1ba0Q@mail.gmail.com>
Message-ID: <CAKYAXd_zHm5QKzLNOOHs8Cwewq33nC0YJ02Jk2AZga9UK1ba0Q@mail.gmail.com>
Subject: Re: Additional Functional Tests (xfstests) to run from Linux vs. ksmbd
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-24 12:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> Was looking at some functional tests runs with current for-next vs.
> current ksmbd and noticed a set of more recent tests that I had not
> been including in the xfstest runs to ksmbd that I should be (since
> they pass)
>
> xfstests generic/604 609 610 615 618 632 634 637 638 639 676 678 and 701
Thanks for sharing these tests. these tests are not in my test script.
I will add them.
>
> By the way the only suspicious failure I got in this run was an umount
> busy error in generic/509 (but it was not reproducible, it passed when
> I retried)
generic/509 tests is not included in my test list also. I will try to
reproduce it.
>
> Namjae,
> Are those tests included in your test runs?
They are not included. I will try to test after adding them.

Thanks!
>
> --
> Thanks,
>
> Steve
>
