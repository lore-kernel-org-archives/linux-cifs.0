Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE50C6379D
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 23:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACD772100A
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 23:48:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uP131fcw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389690AbgKXXrg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Nov 2020 18:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:43644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389688AbgKXXrg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Nov 2020 18:47:36 -0500
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606261655;
        bh=75iVrFW8JETWV6JpVwwtosnIHY3TQJTqBN43wtI8E1g=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=uP131fcws6U/rSqdsFCBemhW1ESq2eIX1jdixaLXetuIoZyV2IQmvnkERxI14S/Qr
         YDpPEiCQzAp1+Y7hSZXPN/Z+B/9rTFzdR9u88VYX2amS9RKencL/ppF/Ad7F0SdBLg
         gQrOT0qWOWrNxokefGMMCXdsB15em4bTIXyAqgBI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvPQWxW2feT+ELLpNR2fNCHqqchauuVoadiGpCwu2bAQg@mail.gmail.com>
References: <CAH2r5mvPQWxW2feT+ELLpNR2fNCHqqchauuVoadiGpCwu2bAQg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvPQWxW2feT+ELLpNR2fNCHqqchauuVoadiGpCwu2bAQg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: 1254100030b3377e8302f9c75090ab191d73ee7c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 127c501a03d5db8b833e953728d3bcf53c8832a9
Message-Id: <160626165553.526.12141216753579579480.pr-tracker-bot@kernel.org>
Date:   Tue, 24 Nov 2020 23:47:35 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Tue, 24 Nov 2020 16:00:10 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/127c501a03d5db8b833e953728d3bcf53c8832a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
