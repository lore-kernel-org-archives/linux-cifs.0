Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91188C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 21:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D95460F70
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Sep 2021 21:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhIZVMi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Sep 2021 17:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhIZVMh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 26 Sep 2021 17:12:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1F6BA60F70;
        Sun, 26 Sep 2021 21:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632690661;
        bh=W5FAKcYQVXHUxsRdEb8/vW3rA3Jw+LK2yaacxVzq/8E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LVScMsPCcpBqmEPLEUIrbLKos52VEt+IKc2LCAslbYiNH/EMkmST+HUovQLtejXv0
         d5QWB+NshywWPagnrWp41DCYJlWH31QZ5IxUyQr32HhY04l2MuXpvvpZyYDwfMByc6
         5wg3rxwHdtkyEVrg8F4r0ZQGCyXpMAqIVBl4SxnB13AiiwcMCmo9zHzC2+aNmk2e8V
         RYI6B7aIsiot+EfEga1xNy01Zp6HeWujsZDkebjeMZxlXzrF5ipmOYlvNdL7WfFmdl
         06xnW84C+9X8rxVPPnlj+JjqJ5UBiHEvAH3uJCENZGpuZLc4UqkhXi17RX9hPPa3Bv
         QQPTJY4CsL3bQ==
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv2fC4ugsUzB5T1ozvPnxeatwMsPrukiPF53WOREFxJXA@mail.gmail.com>
References: <CAH2r5mv2fC4ugsUzB5T1ozvPnxeatwMsPrukiPF53WOREFxJXA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv2fC4ugsUzB5T1ozvPnxeatwMsPrukiPF53WOREFxJXA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc2-ksmbd-fixes
X-PR-Tracked-Commit-Id: 265fd1991c1db85fbabaad4946ca0e63e2ae688d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5e5d7597637c64588f5cf4db798664a560fbec67
Message-Id: <163269066098.28986.15043405983301859044.pr-tracker-bot@kernel.org>
Date:   Sun, 26 Sep 2021 21:11:00 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 26 Sep 2021 07:13:53 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc2-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5e5d7597637c64588f5cf4db798664a560fbec67

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
