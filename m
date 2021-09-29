Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 946C1C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7560461247
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 15:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbhI2PoM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 11:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbhI2PoL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 11:44:11 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995A7C06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 08:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=Nx7wwcH2Co9xkTvQZbVrgQiOxdyy9p03iTRC6gpeKME=; b=hbLU0rtWNJDRF9N2sahNdAlXNZ
        VkvRLNNaaASFUE2HPuBUNtaFdd2LvTZ7cOAQKgIr+9lbBYIq7aunccoTPijXLPYLg+spBBCLmkJ8x
        I0PIwP5cW1aSyhGXIifPFDS3wkMmbtcWbRU734zZ6KXfZBaA1ZxAxg/TdzdE3xJ4qk5mjcA1QJ+so
        a+fe8NWJ0az7gYgqyVg2BMQXAQwXSwUxzJpcfwbLcLMRblE9I4PVe4aoooN9DYkNX3z+wMmhKCL+W
        7M9OMOkY2xiZJLpOIZQ9+6BRT1jgdvexCik7yzUJyDIBnk2YJ151EeBnhmdZWuHsAeTvzNecZ4fH7
        I+nkLvFttKxGjiGJymSNB0A+gK4jPVfTD+2suQKWJnWNduxy/QI01z7s8EtKfqcfDf+d3aBWVzGcz
        Haeoqu9+zgBh1UU9rSO1n7jRHCOXfC/04a/mPSfglAUYVp/F/L/J7XCmz7NBd+BNSze/zwkkA29cY
        NWUt7sUA08hF58EGkwr3R1iF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVbiu-000ibW-1J; Wed, 29 Sep 2021 15:42:20 +0000
Date:   Wed, 29 Sep 2021 08:42:16 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Tom Talpey <tom@talpey.com>
Cc:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
        linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v3 0/5] ksmbd: a bunch of patches
Message-ID: <YVSJWPa8dalyzsl0@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20210926135543.119127-1-linkinjeon@kernel.org>
 <a15a1d99-1a2f-0f41-773e-def5b83f2304@samba.org>
 <CAKYAXd8G5xBBLTS0vS_p1TFoULuxSf-CFjE4n98D+sQrtjpjcw@mail.gmail.com>
 <b9449e7f-5c27-c766-f8e0-1564b8848f7b@samba.org>
 <8f57cac6-1c8a-cbce-b245-bb4015575569@samba.org>
 <CAKYAXd88PNFg4oXisxw8fnUBzCQyceC=2KvPhdU7q6DUgatQbw@mail.gmail.com>
 <79ed52be-c92e-1c62-423f-ee126b3da409@samba.org>
 <YVNR6w7dq0HMIcFA@jeremy-acer>
 <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76fcdc45-0a94-d9e6-14c8-1c638d0bd00f@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 29, 2021 at 11:28:09AM -0400, Tom Talpey wrote:
>
>I completely agree that email is inefficient, but git is a terrible
>way to have a discussion. We should attempt to be sure we have
>those, and that everybody has a chance to see the proposals without
>having to go to the web five times a day.
>
>Please take this as a request for regular git-send-email updates to
>this list, so I can see them if I'm not online. Maybe add a boilerplate
>line to direct to the git repo webui. I'm sure a few others will
>appreciate it too.

Samba does well with the web-based discussion mechanism
around merge-requests (MR's) in gitlab. I assume github
has something similar.

Maybe send the initial patch to the list with a link
to the github MR so people interested in reviewing/discussing
can follow along there ?
