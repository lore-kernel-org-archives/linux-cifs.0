Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CA3C1B087
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Dec 2020 19:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075432311C
	for <linux-cifs@archiver.kernel.org>; Sat,  5 Dec 2020 19:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgLETW2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 5 Dec 2020 14:22:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgLETWY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 5 Dec 2020 14:22:24 -0500
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607196104;
        bh=KD51PfZl61UK/kr/fSJ/Xa5owIIMr0P200dmV6RACsY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=f4G9mPepP2bn6vGIRHMqxQkuG5mH37wp6H2DyIzaVvNwh7Gm/DThXozOC1lF+FzLz
         QcLBG0UHcgcl5icC3xdpowndJZOgwI0ORF61A9pxS3sQye+KopMwSEUyOe/xEJjZXl
         It98J7FDZvKri/e0bASmkI39anW5XgSxNWbr+2oIbIIZtCxqetBffQ0HaYvB5XsI81
         uLKL4aoNDZbJbTpit3to/UcOYQkFz0bAkdfbApar3B//iozzu6EHKq1QXLv5x/wpHv
         8ysK9TYvq7GH2ToiSCHLI+6iZueB1UlejpSug3TUzoyX44e/18b3P9+OA9HBU060E4
         kzr+AAPBLEbnA==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mso+e44kRcGVf4aQ6qc5iwLp4gr6AsQGpLA06phqRA+ew@mail.gmail.com>
References: <CAH2r5mso+e44kRcGVf4aQ6qc5iwLp4gr6AsQGpLA06phqRA+ew@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mso+e44kRcGVf4aQ6qc5iwLp4gr6AsQGpLA06phqRA+ew@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc6-smb3-fixes-part2
X-PR-Tracked-Commit-Id: ea64370bcae126a88cd26a16f1abcc23ab2b9a55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4e904198c5b46c140fdd04492df6ec31f1f03a5
Message-Id: <160719610403.18711.6860857102463324084.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Dec 2020 19:21:44 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 4 Dec 2020 19:23:07 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc6-smb3-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4e904198c5b46c140fdd04492df6ec31f1f03a5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
