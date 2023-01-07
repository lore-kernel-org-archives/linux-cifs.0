Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEAEC678D5
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Jan 2023 18:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbjAGSnV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 7 Jan 2023 13:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbjAGSnT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 7 Jan 2023 13:43:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378BA1BC92;
        Sat,  7 Jan 2023 10:43:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4796B8069C;
        Sat,  7 Jan 2023 18:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C669C433F0;
        Sat,  7 Jan 2023 18:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673116995;
        bh=t8oFbteuHleMYMX/TCZigNH4jj4T+HHQHGSfXFfIyV0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=n/Rbb7/4BWVBMphOEROKgu5l/tgeLOGn1RhBYCyfoV5aH/GYWNF9c2ByNVjkgXqFz
         k7C+E8hpFnyotXtuN1yZ/NNBcoBlz6N0uL5sByS6Vm9Dx1XiSnZDDZ2EaWzFPdOUWn
         ZqpVtIR/ZvKZVRMgCK+jRcDDvGevN6bwTi4ldXzQwuxxb2j0RiOgCB/fximuddfyfm
         atKLjFJEgVt8Uxu2fW5R2xJj5PWvvqadpRXS1H7VpnF9qSeSuNer3FVYThCTv29fsy
         5Jty39Hr2QM0jJc4QBpztT1hB9z2Md/vXnVCWPvPT87svTPUw9EcOGDXPLXRn97yJF
         +qjLH9xQZ09Fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A1F6E57249;
        Sat,  7 Jan 2023 18:43:15 +0000 (UTC)
Subject: Re: [GIT PULL] cifs/smb3 fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muwatnq0rkQzeeWw9pYdd4fZJTMLAiW2j_44cfyMYs1ag@mail.gmail.com>
References: <CAH2r5muwatnq0rkQzeeWw9pYdd4fZJTMLAiW2j_44cfyMYs1ag@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muwatnq0rkQzeeWw9pYdd4fZJTMLAiW2j_44cfyMYs1ag@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: cc7d79d4fad6a4eab3f88c4bb237de72be4478f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f18fca98ac1622220dfdf795fefa91dc52d3707d
Message-Id: <167311699556.9095.7863282434122676334.pr-tracker-bot@kernel.org>
Date:   Sat, 07 Jan 2023 18:43:15 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 7 Jan 2023 11:27:27 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f18fca98ac1622220dfdf795fefa91dc52d3707d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
