Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C60BC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Apr 2022 05:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbiDHFkl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Apr 2022 01:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbiDHFkk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Apr 2022 01:40:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59596188A32;
        Thu,  7 Apr 2022 22:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B449B829D7;
        Fri,  8 Apr 2022 05:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF428C385A1;
        Fri,  8 Apr 2022 05:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649396315;
        bh=QLVlWrKAHEpEH/oXkUUTSLaQGR0aOiZ/iOvi5Grxgcw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jZTfgJfEHeLtKcIhMomoErL10riEOHHtW7Ft7sAsx7Q+xHLC4lvhZrRNRFcWZ8Bz0
         puf59w+9SQ6+GehmgOogWpM9hL9FKqYJfAcKVQx8FKqpMb14i05a7NlWkn8KoMpR8l
         nSlTWfM57+K+0DLn0QJnNK9O1m4eaq/ZtGeT/DdcPVQKKYI9jNyvpjEhSBVQPgSEBy
         C6AHUpGw66v3KMXsBRcQm4qW2+WTXM8JBtuq8Isye4QyQ/Gb3SXkJf/0D4YJOw3oJx
         l5jzDCkl/0b8H6cqJrkVYRV9vSwIHQdSlHOj95xgeNI+3mZVwYTl7S9NOuSWNP4DZ4
         bkDRL9zWJnmEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBBA8E85BCB;
        Fri,  8 Apr 2022 05:38:35 +0000 (UTC)
Subject: Re: [GIT PULL] cifs client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtTvgsopF33=mxKxMW5WJDs_ErLGG4p-PPofDEM-cwwkQ@mail.gmail.com>
References: <CAH2r5mtTvgsopF33=mxKxMW5WJDs_ErLGG4p-PPofDEM-cwwkQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtTvgsopF33=mxKxMW5WJDs_ErLGG4p-PPofDEM-cwwkQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.18-rc1-smb3-fixes
X-PR-Tracked-Commit-Id: 7cd1cc415dd8d0dca7244c9eafb9a0adc8036805
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a5dcfd1e8789053730908c96639151b4151c4d0
Message-Id: <164939631583.5614.13271867538823225589.pr-tracker-bot@kernel.org>
Date:   Fri, 08 Apr 2022 05:38:35 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 7 Apr 2022 17:43:59 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.18-rc1-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a5dcfd1e8789053730908c96639151b4151c4d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
