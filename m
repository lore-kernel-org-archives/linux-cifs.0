Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DC2C0502E
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Aug 2022 18:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiH1SSg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Aug 2022 14:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiH1SSb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Aug 2022 14:18:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE85A26ADF;
        Sun, 28 Aug 2022 11:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B06D60DE7;
        Sun, 28 Aug 2022 18:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8BCCC433C1;
        Sun, 28 Aug 2022 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661710709;
        bh=vu0jNKaX/t9CwEWyzpOp7BM+j066FDi8hvehVB9+KDY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=hQx46cg4v0uYACUfOellsWxZFMdohtWkwpGCoUCGKusiQZxGlkqIUNpx8T9uNUp7k
         mK6T04E4o00RhiVVi4fQL30VO/j3I3QY0qFDFTejso0bMdQ13DHOg8HbJ0jyildlA4
         SWY9PLF9B50ftjKMuYmv10nA4EFHYrpARyzf8YGchG66Sb/NKlug/argEJ/aw0RUJa
         7W+1yWBV8Yd+X3IW4XSnUUEfpPxAjBFxlQDg05GOE1cXOu1ApfC6so2h10pnkKaR7i
         I7Pyzvk9Crn+gGyFY8PVlN72ZiUQmqBiPngPRPf8gvT4eLLHiqpjR5hQMhDteTgCzt
         ozcP3VwSZWPTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90849C4166E;
        Sun, 28 Aug 2022 18:18:29 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muNM-NJOc0pehkN8gh3=UZtq4P1N_baW4sdZHB7FyPHCQ@mail.gmail.com>
References: <CAH2r5muNM-NJOc0pehkN8gh3=UZtq4P1N_baW4sdZHB7FyPHCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muNM-NJOc0pehkN8gh3=UZtq4P1N_baW4sdZHB7FyPHCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc2-smb3-client-fixes
X-PR-Tracked-Commit-Id: d291e703f420d5f8f999fe54f360d54d213bddb4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c7bb3fbc1b499b56a8819b56978c514fd63f66cc
Message-Id: <166171070958.6107.7722898583372162322.pr-tracker-bot@kernel.org>
Date:   Sun, 28 Aug 2022 18:18:29 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 27 Aug 2022 16:43:51 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c7bb3fbc1b499b56a8819b56978c514fd63f66cc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
