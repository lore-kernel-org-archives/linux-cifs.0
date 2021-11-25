Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04568C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Nov 2021 19:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhKYTRM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Nov 2021 14:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232862AbhKYTPM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Nov 2021 14:15:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 967EF60ED4;
        Thu, 25 Nov 2021 19:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637867520;
        bh=MwXpLXct3+iASCGdlRHHVuAHAUg4f3xY9UT1TJV7seY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=t12xTwrlExjlABN8FTnhUBVGGgWUjS+AuaQB3YV+8FqeIAR6xvQAypUn79Ztxp/Gk
         NSo7Ep4NqSi+BiMWUuCmjOKbhy5T9TFoShalmdGt+ZIrrQwLI9qc20cyfKiKzfeVc5
         9btVzeibqm6IEIVpU8dy3xcu2NXy4vG7BUrRKTAw73F+s4E8s0sB6i3Wvc6vx4nUce
         pZjoGAHPZR/hhLzd30efuU/eLf/FtVpXqAycn2vvfP81tY1g5aGovdwBZ5t6hM/Vfx
         w0+jS/ce3wOW7fyJt5uGj1b/5d6qjGHDZZbgZdfHpumeB5I/oVmeF32q6uFpltVGZY
         tjdo8/KKZyfzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91477609D5;
        Thu, 25 Nov 2021 19:12:00 +0000 (UTC)
Subject: Re: [GIT PULL] cifs/smb3 fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mstBrgQYtmmV36BB_MAUqxy4dAKWzuMTmHcjXLjge4Epw@mail.gmail.com>
References: <CAH2r5mstBrgQYtmmV36BB_MAUqxy4dAKWzuMTmHcjXLjge4Epw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mstBrgQYtmmV36BB_MAUqxy4dAKWzuMTmHcjXLjge4Epw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc2-smb3-fixes
X-PR-Tracked-Commit-Id: 0b03fe6d3ae21a7769d867ccdce33737eb348454
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ef4678f2f8ea3add47e6aeb84d902bd7f71fdf5
Message-Id: <163786752058.29201.12016447694370013523.pr-tracker-bot@kernel.org>
Date:   Thu, 25 Nov 2021 19:12:00 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 24 Nov 2021 22:31:34 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc2-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ef4678f2f8ea3add47e6aeb84d902bd7f71fdf5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
