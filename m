Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D5FDC433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 20:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B37961040
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Apr 2021 20:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhDZU6I (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Apr 2021 16:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhDZU6H (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 26 Apr 2021 16:58:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6719761006;
        Mon, 26 Apr 2021 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619470645;
        bh=OAMGFyO1/fidKOjLw3/Ql8/KRpF53/CXAAyPPS1dk4I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Nka4AWIkKLpKi3Q6evqURGB6vWf/osfhbAn4H6Kzf78BdQqMYVLjuGZUB+dGCp0mt
         od/kkSAZgNROxPNsB6MM6d50IqzurAaRs1CHZIG+lYzCd48vF8s2Gxout/laeZ7U6W
         AocQ+Lpar/3SxRXiBxxdEXYZC/VPg3xjzbu2L3If8DlSBNG/JoYAUBbosYQ2pr1Jky
         lEw0U47s2Car+T97ybU8FsQz3+r2sIqvAMfc1m9GjmXoGhGUQUOUn/HRyEAkgDisS6
         T70Lx6ulI8UslUh4rMxBpgOu0oq1qyIvMG6chnR2CTEhCWqG0r/iAGKunVU5zG9b4p
         2Oo3yRIQcdiZw==
Subject: Re: [GIT PULL] CIFS/SMB3 fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvK3_dmwbtH6v0unMEnrdR5Rny+Aki3GnyD=uRU2GH4=w@mail.gmail.com>
References: <CAH2r5mvK3_dmwbtH6v0unMEnrdR5Rny+Aki3GnyD=uRU2GH4=w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvK3_dmwbtH6v0unMEnrdR5Rny+Aki3GnyD=uRU2GH4=w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc-smb3-fixes-part1
X-PR-Tracked-Commit-Id: a8a6082d4ae29d98129440c4a5de8e6ea3de0983
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a19866b6e4cf554b57660549d12496ea84aa7d7
Message-Id: <161947064531.16410.13523451458836871835.pr-tracker-bot@kernel.org>
Date:   Mon, 26 Apr 2021 20:57:25 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Mon, 26 Apr 2021 14:50:57 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc-smb3-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a19866b6e4cf554b57660549d12496ea84aa7d7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
