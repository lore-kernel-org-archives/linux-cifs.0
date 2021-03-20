Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC4BC433E0
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2CB61944
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Mar 2021 18:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhCTSGc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Mar 2021 14:06:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229772AbhCTSG0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 20 Mar 2021 14:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F5FD61948;
        Sat, 20 Mar 2021 18:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616263586;
        bh=hvVSzWcq8ckQd9TSzPHVojg2lIYDx/suxKMrulYqUs8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=YpKjxS/lt2zSENyxpr24cg1OhIJU1LHYuNOd1fyNOnPZJRSQcTbSI7ZLbBWjFtv6p
         zUWjHejFIqRrjQZS6URqzLi4lg43i+c6ulpaaicBPOrFncf7XmBb3V6JMj3DuKdoeg
         L8eU7aYG0jA0BKo0swXoV2izXNGM/Tq7yGFc2LM8Nec02ra9HlHAb29DVI4kailshb
         8Ip1ZHdzugRJW1gqfw6ztjWJQgdCA9fDTLGiYsXcuVnmO7Ivzqbvv9k+dX+48+/skj
         gIAblk/egGUnfBE+2bVgdiGgBkjavnAa6q4XAfSu/LGBJ4/DNCbm2KCvvTBD1Hlq3J
         odpI4KNYHoX8w==
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt9Mj-gE4fhj4=bH9CyXuTa4er4T2OC5E+VgpacmR4zvA@mail.gmail.com>
References: <CAH2r5mt9Mj-gE4fhj4=bH9CyXuTa4er4T2OC5E+VgpacmR4zvA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt9Mj-gE4fhj4=bH9CyXuTa4er4T2OC5E+VgpacmR4zvA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc3-smb3
X-PR-Tracked-Commit-Id: 65af8f0166f4d15e61c63db498ec7981acdd897f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bfdc4aa9e99204d1bf925cdbfea9a1d903ebed29
Message-Id: <161626358630.25184.17477925130779725390.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Mar 2021 18:06:26 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 20 Mar 2021 11:18:54 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc3-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bfdc4aa9e99204d1bf925cdbfea9a1d903ebed29

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
