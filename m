Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13EBCC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E373C6108B
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 23:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349177AbhIIXZJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 19:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346783AbhIIXZJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Sep 2021 19:25:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3CBBF6113E;
        Thu,  9 Sep 2021 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631229839;
        bh=F2mdJPSRhKZ6f+I4u+Yb0RC5Y/kC0kncZaHV+l4AOqs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=NP9LoTh7ki7PhiMDG3QC7B5Apmxex9vN+VhWCu4w859lzREGwvyrCBRfxgxpxGIhL
         4vhKLh47PfX7i2OJzwKj8NLml+pyKVvOM24lb7h6Y1+RgEIdy57bNfcwFnFb3BLtlJ
         ZTCodpnhJLBiB2Z+hqCIzcUVcddzysRnCxyHndLtXT4B0RcaUn5ndgx8NWcfTMjuTE
         HIKuJhUpsd/1dZSNdX6QIZlYh/kZZvJX6roBSkhPEBh3wDwwaUaMzXQ/epfE/yJZzo
         jKFTwyJWDZazwFB4bEES/swGdawdGjhqQKQukqgTSPFFaHucbPj6XWb8ESiA7CB9WH
         0F5HSg++93Q1A==
Subject: Re: [GIT PULL] ksmbd fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
References: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvadF7FkC1NhVyYNBG_XzwH4daryt42YLJrHnn5ws1Y=A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc-ksmbd-part2
X-PR-Tracked-Commit-Id: 4cf0ccd033d9cedef870eb8598a55851e680a173
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf9f243f23e6623f310ba03fbb14e10ec3a61290
Message-Id: <163122983921.18294.13926470763924446690.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Sep 2021 23:23:59 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 9 Sep 2021 16:59:10 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc-ksmbd-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf9f243f23e6623f310ba03fbb14e10ec3a61290

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
