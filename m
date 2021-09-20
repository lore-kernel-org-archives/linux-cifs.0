Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11305C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 23:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E90B26121D
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 23:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhITXfg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239084AbhITXdg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 19:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 30E0860F48;
        Mon, 20 Sep 2021 23:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632180729;
        bh=KeJverb6JHqfOnBMfUCmPZv4ASGMoxZ4WaHMmdXayB4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ahL+aKvfixjvcKfVpGzjDTpjamjks/K/Im6q1+I+decfcToFJVecYwSivauXiVmFN
         m162IytF3cre0Zhu9pjaCI4YpEZ9xHMnJ6+gSyc+TMNtc3Pnn22KLdzOaXLU2J0xst
         a9L4r+xwd7Si0twTntqY/ZvoEN7UsDLu/8SBI/yS5wXKdnZlDuLSIIKuYKmr5IxOzm
         tLPEI1tL+CMFB4b0Mrh95HQDbTy/FRqPK7Pb6Jrdavtw87Y5M5ANDOXaq5GDFWYyh8
         o3fc0JfU3qrzNNImfDqwW/IRYyAAzc0N/hHjiscwg7bHLAEi+ZmZnYCqjZ93hchXiX
         KoJOBJoZfSONw==
Subject: Re: [GIT PULL] cifs/smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtYiadLYKVhkBFo9=a9+y0BK2z20r7dNGrdvRkyzXYJHA@mail.gmail.com>
References: <CAH2r5mtYiadLYKVhkBFo9=a9+y0BK2z20r7dNGrdvRkyzXYJHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtYiadLYKVhkBFo9=a9+y0BK2z20r7dNGrdvRkyzXYJHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc1-smb3
X-PR-Tracked-Commit-Id: 35866f3f779aef5e7ba84e4d1023fe2e2a0e219e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fdf5078458793fca9e9c0fb5e58a1a970ca0fdef
Message-Id: <163218072916.25470.5666451145016996044.pr-tracker-bot@kernel.org>
Date:   Mon, 20 Sep 2021 23:32:09 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 18 Sep 2021 14:54:43 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.15-rc1-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fdf5078458793fca9e9c0fb5e58a1a970ca0fdef

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
