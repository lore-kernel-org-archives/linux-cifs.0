Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4530C77B73
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Apr 2023 17:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDPRnd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Apr 2023 13:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjDPRnc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Apr 2023 13:43:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AFA92;
        Sun, 16 Apr 2023 10:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8440160F16;
        Sun, 16 Apr 2023 17:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2CEAC433D2;
        Sun, 16 Apr 2023 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681667010;
        bh=F9wIe59tW2PbE5CLE3rAMhRvz96M/v4L51DB2U2OCDI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=XWDSBdWHv803TqB0RxJzt4lPEOQk/GvP6hTj4FCCF7KEj18xgzeeNwMoVSlixR+Gr
         2YPewQXbirYMk3XL86lAN8yjk/0FNZmn1OMXr2TgV41pJjaY3TFjlcPf7FfD/+gI0D
         y3NtJkag0uuovAme4uVeUZhMAQ1OXO4KLs1Tb+7gHU2vrlLr3nhkzadWDi031u/Cg/
         QU9GmIeH5eqsDVbJiDgoWQ2ARrU1xni+3Eooo6A9axU4M2pkmnD9crQBMv4HDjIywA
         noMKuUSEK/SleHWnHuUNrfGe1JzuDv2xx3LjzIzGV2k6B6CrKKzaQkmcMpv89BkyD7
         4/YBg6gCKVtYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D09BFE21EE8;
        Sun, 16 Apr 2023 17:43:30 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
References: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mumQ=wg8H4d+vYGZZGPz1cbK5+LOeCoBxo+VbYta05QBA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.3-rc6-ksmbd-server-fix
X-PR-Tracked-Commit-Id: e7067a446264a7514fa1cfaa4052cdb6803bc6a2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6586c4d48018eb62d3df8af8ebe5436510ed04b1
Message-Id: <168166701084.4218.14311554525104785543.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Apr 2023 17:43:30 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 15 Apr 2023 22:52:20 -0500:

> git://git.samba.org/ksmbd.git tags/6.3-rc6-ksmbd-server-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6586c4d48018eb62d3df8af8ebe5436510ed04b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
