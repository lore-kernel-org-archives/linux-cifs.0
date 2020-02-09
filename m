Return-Path: <SRS0=CoXL=35=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B96FC2BA83
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Feb 2020 21:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFA120726
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Feb 2020 21:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581283826;
	bh=AqfpAsWNvCK+7xERJ+mo+TrDvta9jJF9UoQ/RjeNrtA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=wdtgB2Cp9B4y4/f74QU5YoomUCI+wldwcbpHGPJ1wl6Dux0e2eg5e0jLcuTvYXETt
	 CYC3IhMGRpWkLZ/Rgjg+Mv+jKIF3MO+0IN02YWPUGA820aI3e/4PClmemmsyDdqznq
	 TIU7jWiDjh6XWM0OChkkbGqSki3UFU8x6jUaXeVA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgBIVaZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Feb 2020 16:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgBIVaZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 9 Feb 2020 16:30:25 -0500
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581283825;
        bh=AqfpAsWNvCK+7xERJ+mo+TrDvta9jJF9UoQ/RjeNrtA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=RFoB/Wq+tWMlTiglIEk8jHyUrCB4cJMxEtU9A45sIqGp8pqJaQ/ghcMrAc6bNBiIu
         D+RrunbJdhMMhJHmUywRzekWZDeDTNQr+JJ3+MCu+zDTd0JbFMUVJFQTu9nWm018HC
         gvusyrFdMcyOYAuqIYfif9OIaOfiPR7qypNQjrjE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms=hyEdeSLo2qN11rB41e-+yFn7Xg=8CVWwXVa1R0hooQ@mail.gmail.com>
References: <CAH2r5ms=hyEdeSLo2qN11rB41e-+yFn7Xg=8CVWwXVa1R0hooQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms=hyEdeSLo2qN11rB41e-+yFn7Xg=8CVWwXVa1R0hooQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.6-rc-smb3-plugfest-patches
X-PR-Tracked-Commit-Id: 51d92d69f77b121d8093af82eb3bd2e8e631be55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d1ea35f4cdd41ae6ac5a9e1ad6a55cc901681569
Message-Id: <158128382506.12209.12384867221149641940.pr-tracker-bot@kernel.org>
Date:   Sun, 09 Feb 2020 21:30:25 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 8 Feb 2020 19:45:26 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc-smb3-plugfest-patches

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d1ea35f4cdd41ae6ac5a9e1ad6a55cc901681569

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
