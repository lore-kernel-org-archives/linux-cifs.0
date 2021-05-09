Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80247C433B4
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 20:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E2F6140B
	for <linux-cifs@archiver.kernel.org>; Sun,  9 May 2021 20:50:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhEIUvE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 May 2021 16:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhEIUvD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 9 May 2021 16:51:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B1160611F1;
        Sun,  9 May 2021 20:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620593399;
        bh=Or2wtFw29TMPQHK396LbfoTr1B0IMGRhF3w9vb5ms0o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZSjRiYYa6FrihjdgKXn551Fy1BO8K39Bnxf+vi3WN3jZ1kxhDiokF2IkZPDXYduXy
         D1cwK7IXy6gqUYzRvIFIh8lpmuMh3ezVVPzkdsQ8JGqY9uPJ/k9J7Ha92/9/1EkZBl
         slO7sYZEZt6ulBIVHlVteWCOD5q7dS11YSA/q322A38UlDPtgeGJQX8KbOQAX5Etz9
         +STVFtUWIH4ZS5BL5AGYXHhvjRDBvO8QbuyBDdh+uRT4xC2ilBmqojwF9V6sEXruTu
         //2KpmkNT8i6Z0ScHWntabhHRdfukCBhwHwFkYZb3BAb8aDLfDNpQKYWdNUWs8V0sP
         RWkx6XvItEcNg==
Subject: Re: [GIT PULL] SMB3 Fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mspgQ7Xh22vuiSVbfJ00QGeQNJL_J1V4u+Mt=-U5jK+Pw@mail.gmail.com>
References: <CAH2r5mspgQ7Xh22vuiSVbfJ00QGeQNJL_J1V4u+Mt=-U5jK+Pw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mspgQ7Xh22vuiSVbfJ00QGeQNJL_J1V4u+Mt=-U5jK+Pw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part3
X-PR-Tracked-Commit-Id: c1f8a398b6d661b594556a91224b096d92293061
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0a55a1fbed0b65ed52491caada7d2e936573d464
Message-Id: <162059339969.8686.13569292928881369544.pr-tracker-bot@kernel.org>
Date:   Sun, 09 May 2021 20:49:59 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 9 May 2021 09:37:17 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0a55a1fbed0b65ed52491caada7d2e936573d464

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
