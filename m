Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49101C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 20:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC7F6056B
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 20:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhKMUfM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Nov 2021 15:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhKMUdJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 13 Nov 2021 15:33:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D5FDD6056B;
        Sat, 13 Nov 2021 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636835416;
        bh=i2TZ5HNt0MYmClRUEdpi+Q4Zg/bLHVZMMBe1c77UJtY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=N7dMTYnn0VW7BtFLxcvPSJZmTZweNnGMcEapoOKQJAXtIkPtHnPyd9w0OPHTSlML4
         sWqZE6+a0HLfdJSt9LQwI0m2Pb7m584m788qnRFtOttWPCu5B2fUQ6jKQRTl5RPSre
         ytx71Liq/6tYw3IB+T7j8/tOacTx2dSKr4EAocPwQjYVnfhKNF0/H8j63+JFy3sR3M
         Rjdq4OS+1JuD+SgfeP0+G6RkJ6HrjMoBklMIl7lIDDKxaETp/tjBXfrRioIpg4CBKx
         omyhGqg/ZKMcaALonPZgf82XnlzKFCxGDFHiEz2/T/vyab1rGBGZTSrslSsi/jNuio
         rGxaol3G6yNEA==
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msPS_afwd3goRMC5vrmtKg0qSYcvX6qe0rs+f80M7OD0w@mail.gmail.com>
References: <CAH2r5msPS_afwd3goRMC5vrmtKg0qSYcvX6qe0rs+f80M7OD0w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msPS_afwd3goRMC5vrmtKg0qSYcvX6qe0rs+f80M7OD0w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part2-smb3-client-fixes
X-PR-Tracked-Commit-Id: 46bb1b9484aeaf701da50c9ee063f3e93ce2a37b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c8103c2718eb99aab954187ca5be14f3d994c9be
Message-Id: <163683541675.15395.13921707940238231740.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Nov 2021 20:30:16 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 13 Nov 2021 14:17:53 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part2-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c8103c2718eb99aab954187ca5be14f3d994c9be

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
