Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D9DC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67B3764DC4
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 18:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCJSNQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 13:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhCJSNN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Mar 2021 13:13:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3340C64E77;
        Wed, 10 Mar 2021 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615399993;
        bh=AcaUU6NCsux5jw12K6DF2rB+hOGNY8tuatvv3EEq9ak=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=HhAFet7DRFVAXFd0sgQFndDPtCQFrVhaD2HTa4bERsAt9oqXphPahAaMDRqmTnujg
         10yZegnbwmhfPiohqAweaebO7+A1XoFZzVV9z2CzQso3zDKj/I418WKPM+xzlJXB8q
         nCUQqXRJw1A8uNyTaq4aebsMrR3++XSWmIYeQqrxWXF4r7pt2L/Vuuc9R56hqGq6Ai
         YkNH673My81FD8YcAEmTQsIu4aBNDzq4OhQkwkbW7u8qRmc7DnKJsQ2GOudU0zdVGp
         LoCIO0AVAvhvg1yGCbrhfKbRNsgcjOoDfmExcriuABzw0jS4wTS7OCl3D7ZOuIIsMa
         1nKiWQfJCjZEg==
Subject: Re: [GIT PULL] cifs fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt9OWkr_sGjYXSEzRghSsOaO9O6sqfHLM2E07Am15ceAA@mail.gmail.com>
References: <CAH2r5mt9OWkr_sGjYXSEzRghSsOaO9O6sqfHLM2E07Am15ceAA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt9OWkr_sGjYXSEzRghSsOaO9O6sqfHLM2E07Am15ceAA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc2-smb3
X-PR-Tracked-Commit-Id: 04ad69c342fc4de5bd23be9ef15ea7574fb1a87e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d0df9aabefda4d0a64730087f939f53f91e29ee6
Message-Id: <161539999307.11123.14741065855493528757.pr-tracker-bot@kernel.org>
Date:   Wed, 10 Mar 2021 18:13:13 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Tue, 9 Mar 2021 20:49:00 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc2-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d0df9aabefda4d0a64730087f939f53f91e29ee6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
