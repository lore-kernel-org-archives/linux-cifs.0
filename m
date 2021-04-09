Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4445C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 02:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B9E8610FB
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 02:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhDICEc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 22:04:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232683AbhDICEa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 8 Apr 2021 22:04:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 78CF6610FB;
        Fri,  9 Apr 2021 02:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617933858;
        bh=GnbPjBp/xLjIrbgzFdIwMsC/+ErL8tOpukjJ9GhF18s=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sJgUM1yortP+QxJnprmJ9O+6nTGfixxy0IUXBJgwCPLTVP4ixvG3JrjLdB/1FxPgi
         /vCM6a0JaVP2o5nDvPdV1g9G/2vOpHnpywwStc3cuAJGp3jjNzevo78l6Q3ytrV3LC
         qb+UNTm8Ez4IRUjojii9rKPPvUkPdKinZ5b5/JZIAub2ZSATtek+kJPlBs0k0mOwTs
         7IukDsekQfIiShZYh7NTHAdZwTOYPHMra+/OG0hT62Qyr6Qg30kStsosNf6GtluO8c
         P2hglJCs1XdHldg/6B+QjcMKWSaePu8E2yhXFiy8Nm5yyl007xmsizzEoKw5DrH4sv
         HGd0Q71n53ClA==
Subject: Re: [GIT PULL] SMB3 Fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvZEvGskzcrcd=PbQ7zqAyH0=uDyvVG7vu9XEPM7qJLHA@mail.gmail.com>
References: <CAH2r5mvZEvGskzcrcd=PbQ7zqAyH0=uDyvVG7vu9XEPM7qJLHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvZEvGskzcrcd=PbQ7zqAyH0=uDyvVG7vu9XEPM7qJLHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc6-smb3
X-PR-Tracked-Commit-Id: 0fc9322ab5e1fe6910c9673e1a7ff29f7dd72611
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17e7124aad766b3f158943acb51467f86220afe9
Message-Id: <161793385832.2209.9197883738761728779.pr-tracker-bot@kernel.org>
Date:   Fri, 09 Apr 2021 02:04:18 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 8 Apr 2021 20:48:16 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc6-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17e7124aad766b3f158943acb51467f86220afe9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
