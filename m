Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C23C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5309217FA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 21:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555535705;
	bh=D8u2wWXpdIkXaFmYblhRAxpa+Bj7dFLI/sxJ4XCZumc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=JL49K6sd2QQzO74nvHMjg7kzFiCVPU/lyN6nvuYLCHUZNnaU9lMmRMUTYep9GMAI4
	 Ol54FxaTy58S5xBFTCZ7B15a27yQgHd1Z5n9EpcYkaaFZEK9JDgPnzAptOh8W0nYl3
	 7XHK83cVbMoQLBjCWPqZk8rs4FmLkW3HBG4fVewQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfDQVPF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:15:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbfDQVPF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Apr 2019 17:15:05 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555535704;
        bh=D8u2wWXpdIkXaFmYblhRAxpa+Bj7dFLI/sxJ4XCZumc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=IuD+cZeaJrYlwVwKm7jgn59yiKhtYkmcCfm1FsuXSq0D4KjCf6K1XWcBtiaPA11yC
         eithwmC22hOqJLNMY0G6JRxqc+mJQkTU1PSBWoOmUYclEtYXDn8kwKbpcUFogBooar
         qpgMwDf3ykrZt7K7581VQQ5CjHN0gb/p6DvtldIU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtuPCiGMV+oFMxDXzP_ior8iYm_ZQHQvS1+CyNN4dkRRw@mail.gmail.com>
References: <CAH2r5mtuPCiGMV+oFMxDXzP_ior8iYm_ZQHQvS1+CyNN4dkRRw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtuPCiGMV+oFMxDXzP_ior8iYm_ZQHQvS1+CyNN4dkRRw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.1-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: b98749cac4a695f084a5ff076f4510b23e353ecd
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e53f31bffe1d552f496b674cd1733658a268e177
Message-Id: <155553570437.8040.913241706766392608.pr-tracker-bot@kernel.org>
Date:   Wed, 17 Apr 2019 21:15:04 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 17 Apr 2019 14:40:26 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e53f31bffe1d552f496b674cd1733658a268e177

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
