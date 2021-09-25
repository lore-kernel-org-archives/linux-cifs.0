Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BB4C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 19:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C94861090
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Sep 2021 19:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhIYTI2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Sep 2021 15:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229711AbhIYTI2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Sep 2021 15:08:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3E1CB60F21;
        Sat, 25 Sep 2021 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632596813;
        bh=q04A9ypAsYSv2vrV0NyiUYkOR63+DjriFSB3N3AsLDU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=b6yks09HtRy1XpCmS2Gv9aFb+Xv2woA6D+jLmyU0nBWuYGpDeX/pFwktzmkO6RyFZ
         xxhnaTTIYGh3F/byMxv129kcZOsH8MNbuCrUG7NKBsuY5xiWXpHbWGNAtuEAzu2/0B
         5l8guW7dInciBeN97PHZU6iJQAHtrrpHSd1U7NOrxclFFr0+NJoEUbaocHdJphP1JC
         HiUu+eF41k7ClWADfGwupCAolo1DmG7SF7sMMMBLQAiOj6GvcOOKXWjgg4Rgm1syC5
         CAKDXLru70qaXfwJ8MKkpYU7cF/S7FDS2BQbYSG+ljiziQ5/Nf5nn9Ur6l465pjbcu
         pVvWK+IXXoA+Q==
Subject: Re: [GIT PULL] cifs/smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msXrOGB1_JC-4jg0F4jbq5G33bGE8-uvdO6Doyw79E_mA@mail.gmail.com>
References: <CAH2r5msXrOGB1_JC-4jg0F4jbq5G33bGE8-uvdO6Doyw79E_mA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msXrOGB1_JC-4jg0F4jbq5G33bGE8-uvdO6Doyw79E_mA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc2-smb3-fixes
X-PR-Tracked-Commit-Id: 9ed38fd4a15417cac83967360cf20b853bfab9b6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b8f4296560e33e4e3cbed17a674d1b6dd23191af
Message-Id: <163259681312.4077.4575437466377837829.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Sep 2021 19:06:53 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 24 Sep 2021 18:23:14 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc2-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b8f4296560e33e4e3cbed17a674d1b6dd23191af

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
