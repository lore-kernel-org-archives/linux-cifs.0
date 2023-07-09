Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A32C0015E
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jul 2023 17:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjGIRqh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjGIRqf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jul 2023 13:46:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF69106;
        Sun,  9 Jul 2023 10:46:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D195660BC1;
        Sun,  9 Jul 2023 17:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46737C433C8;
        Sun,  9 Jul 2023 17:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688924794;
        bh=3h6dWCxcJWkqRwR6bq2lRWtikw9ob6vntS5yLLwCNpg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=q5pMMbgOdwSafAAOfyHZoJz5mvn/GiSXpZBx3wEc5Sy/qVoXKCDfHa9PVuHrsVVp3
         KY5lnNUxGYoBjWK9kKEGih98QhnGuGfZ/vmNiCuyrPg3BG7+ccrUPEu4PbUaxI+SIq
         7iQX+j00YtjSbO+sAeYBONtwSCi/ISOlJ2aPbJsCZb8kSftKYXnBfVDR2lLU3U+Md3
         72sZkfUUqT0ktCjrpb30YZv7D7YiCC5XnLBYX+ETYMv68ptEswf0s4YuLgakfUAy7S
         226vUL5S63TMjjOGI2iURqqYKCQnU9wYvROVr2b+ja+xTwNbtGSbcA5SdtoI1IKJba
         CTKYIz4TNAQFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3629BE537FC;
        Sun,  9 Jul 2023 17:46:34 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv9U44-ypmJam9KTWNky=8+TOPsv=cdWj3sRd6DPjhU1Q@mail.gmail.com>
References: <CAH2r5mv9U44-ypmJam9KTWNky=8+TOPsv=cdWj3sRd6DPjhU1Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv9U44-ypmJam9KTWNky=8+TOPsv=cdWj3sRd6DPjhU1Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc-smb3-client-fixes-part2
X-PR-Tracked-Commit-Id: d14de8067e3f9653cdef5a094176d00f3260ab20
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4770353b660abc8b1a5d2afc233b6061d48e7d80
Message-Id: <168892479421.9789.16886483160589339456.pr-tracker-bot@kernel.org>
Date:   Sun, 09 Jul 2023 17:46:34 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 8 Jul 2023 23:39:10 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc-smb3-client-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4770353b660abc8b1a5d2afc233b6061d48e7d80

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
