Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6A1C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Oct 2021 17:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA1760F57
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Oct 2021 17:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhJXROt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Oct 2021 13:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:54978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhJXROs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 24 Oct 2021 13:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B918260F57;
        Sun, 24 Oct 2021 17:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635095547;
        bh=6LLZ/Uy4Y4V5vtZiJniIctam32DQV8odrSmP2OdRbZE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TxpM4/kOiLaqT8icWPHQm64yRktio8JgmsSB+d66VoxkNkoTj8hmFkvQoIYITgiq4
         FvQeuVaVHG+noMPeAXKZkteU95FIUSMKP42ubG8I6nua/nYADrvV3D0rqz69KWCgpZ
         Uhh3Zy6kajOlVVAvmRZ+u+DMkbMKaa1IUTbwO4jgwMuPrEYqrw49Tk9ko70V5rdAyV
         ANMqsKhDNkogcx7qz3JWYZ5oZFBCMkbr22V0vvTC/sitB50MyTBI8ACWo+2E/1qZlN
         gcN/P7bXmsfy9EBJio8bgp2f7POD95LZjUVfR0lvKrCDapyDPweL/L8b8nxnvWp0T6
         2nrD2zuKrJ4tg==
Subject: Re: [GIT PULL] ksmbd fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvY5kWAHs=0Lzgst0rjRaej+VW1ZLdFc8kDJ-07QmWQsA@mail.gmail.com>
References: <CAH2r5mvY5kWAHs=0Lzgst0rjRaej+VW1ZLdFc8kDJ-07QmWQsA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvY5kWAHs=0Lzgst0rjRaej+VW1ZLdFc8kDJ-07QmWQsA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc6-ksmbd-fixes
X-PR-Tracked-Commit-Id: 0d994cd482ee4e8e851388a70869beee51be1c54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c460e7896e6906d4e154f2e7fb7f40d46edbd006
Message-Id: <163509554761.13231.1579725077807302134.pr-tracker-bot@kernel.org>
Date:   Sun, 24 Oct 2021 17:12:27 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 23 Oct 2021 10:06:41 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc6-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c460e7896e6906d4e154f2e7fb7f40d46edbd006

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
