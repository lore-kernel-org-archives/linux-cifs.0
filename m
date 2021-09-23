Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC269C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BFE36109E
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Sep 2021 15:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242093AbhIWPyO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Sep 2021 11:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbhIWPyN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Sep 2021 11:54:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FC3C06175F;
        Thu, 23 Sep 2021 08:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=rfll4h7LdtMEWw8B/3NMhDmFRKX+I7KhoeBywQmmero=; b=knJgrUjXLrmnHS/i0SSqtm0YPO
        wmM8TWJEg5mw2CjZk3yyd+ANvjpNaFFb3wuyZEp4oaCfZs4iHpazy57XrYmGm/v9TYyCKCQGQhdQN
        mZxy/qmWbscnnUr9l5/TdgZHDkA62qc5/lkOSUZp4QTHDqDrOr+8mmuBV3Vkn/0vAMT9H16CccxnA
        KJJuGSmJSzYtfm8BBHsMmxOSW/Klevyn3H4AkqAe5i0zKQjjtW1kLULdBrPM6THi7EPEXBlNFwCZx
        tFo+iDvePrQek1xQu1LUYJhPwAtNpdkL0VPjPjJOfmEOsaLI6/5di+4SDD3srZLX1dxzYtV7b+E98
        hL+tXXSLkks7QOxVdQfeBPz2IckGk3qc01weP98BTQwPnym6bbiTCMhA1s2K2J+h4wppkbYCc/JBI
        Tj/r/vQHZTgRos585MODsmol4hHj1IjWg0sgHiTPF3ATOtoNA1hcMNQD/T/+BLofvGNWo4VsJxqZ1
        ip1cmePt0/izjR3onZ4IB70j;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mTQs3-007Wvr-U3; Thu, 23 Sep 2021 15:42:48 +0000
Date:   Thu, 23 Sep 2021 08:42:44 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [GIT PULL] ksmbd server security fixes
Message-ID: <YUygdDGXQhSZRqoo@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
 <202109221850.003A16EC1@keescook>
 <CAH2r5muNG4GvziyMG2unkYNjUiT4V+pz0pWUGkWQNxUZJnBadw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5muNG4GvziyMG2unkYNjUiT4V+pz0pWUGkWQNxUZJnBadw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 10:20:01PM -0500, Steve French wrote:
>On Wed, Sep 22, 2021 at 9:47 PM Kees Cook <keescook@chromium.org> wrote:
>>
>> Hi Steve,
>>
>> I was looking through the history[1] of the ksmbd work, and I'm kind
>> of surprised at some of the flaws being found here.
>
>I was also surprised that a couple of these weren't found by smbtorture,
>although to be fair it is more focused on functional testing of the protocol
>(and is quite detailed).  Most of my analysis of the code had been
>focused on functional coverage, and protocol features (and removing

Steve, you should have been surprised they weren't
caught by smbtorture, especially if your "analysis of the code
had been focused on functional coverage".

No one has been looking at the logic for this, and IMHO
that's a problem. It's good they are looking now, but
I think this code needs additional maintainers.
