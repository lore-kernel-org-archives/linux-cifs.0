Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62290EE498F
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Aug 2023 17:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379107AbjHRRtF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Aug 2023 13:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379253AbjHRRsm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Aug 2023 13:48:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3303F2D79;
        Fri, 18 Aug 2023 10:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63AF96528D;
        Fri, 18 Aug 2023 17:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF61CC433A9;
        Fri, 18 Aug 2023 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692380919;
        bh=3AIFYP9vHueu9XlT8TVFWICjTAeUq5bvsP2IX6xA1dw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LgmMvlhNEhqcxyA/h87n7nP/M9uxnWev8d3YAgZcTYatv9Z+lipK/Y48lwv9LNt48
         9m4cr7s2NP0Ww+R3XrPp5y2KytgxOHLtbTdp+WOgzwrqGifwpyAsJf3pS20nOmzH6N
         RY+Wq5zSlKMGXs7QbZVo0+Iib14fTdixGcbWxj33+5cIFJKYkte8Y1cYmUywtyn8LG
         Sv9SGzAbhOWDOKfANSxkNixamYF5kHmoB+042KghgFoY6vu8g0nU4UP/i6PWQs/e56
         YJE7M8dBTcmYsw2f9kRT4BWxusZy4EwDng8m5lMSG49b3Sbq+1n0kuOnhV7401fkcX
         g/GlYEFBTyShw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D406E93B34;
        Fri, 18 Aug 2023 17:48:39 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtF7UiHyNArEancsoUnnzghBNjh3YRBAfzjjMU=KaE6SA@mail.gmail.com>
References: <CAH2r5mtF7UiHyNArEancsoUnnzghBNjh3YRBAfzjjMU=KaE6SA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtF7UiHyNArEancsoUnnzghBNjh3YRBAfzjjMU=KaE6SA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc6-smb3-client-fix
X-PR-Tracked-Commit-Id: 270d73e6507f9c7fff43844d74f86365df000b36
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8abd7287db9231485261d36c17d77f044de32d20
Message-Id: <169238091964.10816.13969586347022820406.pr-tracker-bot@kernel.org>
Date:   Fri, 18 Aug 2023 17:48:39 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 18 Aug 2023 10:55:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc6-smb3-client-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8abd7287db9231485261d36c17d77f044de32d20

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
