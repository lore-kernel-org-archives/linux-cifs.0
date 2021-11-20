Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACB9C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Nov 2021 19:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhKTTXY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Nov 2021 14:23:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231325AbhKTTXW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 20 Nov 2021 14:23:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 35D3960E78;
        Sat, 20 Nov 2021 19:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637436019;
        bh=ftEJNZ2QfKM3eLMFRijzFwpxU4lf8BYGKrwmGeb2Ukk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HxpGB6kvnkaOYD67uuSuNWWhDJZQRMV0IokfAeDIeFfdY1SXyksZX1oehB4BXjk3D
         9NX03DBOQLEZ13BNwcYr5juG15YPeEaINm2g1N+H4qdLgze5XuKAj0SXJ//B+59n+y
         XKCp6K5Vf3rFJcTJvq4kdn5jYg2k0MGJCoIPPZM34MFFL6QRxr1aWodEiE4jYSCdOP
         gyrJQOVjpO/nAXRs/SdGuhufTwY3cNQ8xs/XLVlzGEBosuuTqhbS1H3/tgMDjvAoqO
         FOgE7FJjYXCcc28PLxxnrNXQDR/dYeAluKanpx0ivZ378iH4D0vsDZ4Bq4vmSGOlUB
         nSGaae5uCWYLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30A42609B4;
        Sat, 20 Nov 2021 19:20:19 +0000 (UTC)
Subject: Re: [GIT PULL] cifs/smb3 fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvH+e=5dxKsmnKVYttaQk=7u+KO0uucQ+z4fxH9RemwhQ@mail.gmail.com>
References: <CAH2r5mvH+e=5dxKsmnKVYttaQk=7u+KO0uucQ+z4fxH9RemwhQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvH+e=5dxKsmnKVYttaQk=7u+KO0uucQ+z4fxH9RemwhQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc1-smb3-fixes
X-PR-Tracked-Commit-Id: 8ae87bbeb5d1bfd4ddf2f73f72be51d02d6be2eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b38bfc747cb48a3f73a196a11400f5094b887a56
Message-Id: <163743601919.29153.18328651547749272907.pr-tracker-bot@kernel.org>
Date:   Sat, 20 Nov 2021 19:20:19 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 19 Nov 2021 16:45:10 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc1-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b38bfc747cb48a3f73a196a11400f5094b887a56

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
