Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DBDC433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Apr 2022 22:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiDVWEI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Apr 2022 18:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiDVWEE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Apr 2022 18:04:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE6341A281;
        Fri, 22 Apr 2022 13:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C44EB83260;
        Fri, 22 Apr 2022 20:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15B76C385A4;
        Fri, 22 Apr 2022 20:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650660404;
        bh=lAIpsA8GwlDp91+/3Nl/q7BJTfG0dlG2sKdtR4AeAqg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AJqNmlYygWXwZEVMiilBNTxQdo5aWr2Wb5lbq9M9XHy2U0FchXcPLnXKHjQJYjZ3f
         zRjRZPuNJ3YQL0Ox0F4k0+tkczKbQZz1b536eSHyCzLHo4o2DW+U0ocJS6r50T3ZRT
         hQPsgs1CdtCf3AtezxjiDjeqjk/KCwpv96xTl6yIxOhPt+ZYv9al449HZ3IltTvWxb
         u7Cjw5877G3zwP3l++5S5PpVzeEaZdh0zqJmvV1lUpxaMu9jIbLrM9skdS8dbPKHtl
         3hCPw9zueWGx2srn9QO0wO1I7PbHOnXawWEgdcEnb545/4luo+HGi0PkA/uPrOAQfF
         +Y9ExMsqJoLYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02723E8DBDA;
        Fri, 22 Apr 2022 20:46:44 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtNyRzY2zxrS9Qgoj-NxAEyOEHjrWc1a6bingt61=xWHA@mail.gmail.com>
References: <CAH2r5mtNyRzY2zxrS9Qgoj-NxAEyOEHjrWc1a6bingt61=xWHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtNyRzY2zxrS9Qgoj-NxAEyOEHjrWc1a6bingt61=xWHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.18-rc3-smb3-fixes
X-PR-Tracked-Commit-Id: f5d0f921ea362636e4a2efb7c38d1ead373a8700
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 88c5060d56d8f756653bbee89fa45a752e241c9c
Message-Id: <165066040400.3510.2984080535215544463.pr-tracker-bot@kernel.org>
Date:   Fri, 22 Apr 2022 20:46:44 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 22 Apr 2022 12:00:06 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.18-rc3-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/88c5060d56d8f756653bbee89fa45a752e241c9c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
