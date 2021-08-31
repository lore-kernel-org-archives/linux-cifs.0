Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC88C432BE
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 16:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AEB361057
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 16:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbhHaQm3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 12:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240105AbhHaQm2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 31 Aug 2021 12:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8775161057;
        Tue, 31 Aug 2021 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630428093;
        bh=ljqLuPzYv8WppsWs/tWae8XXXM5scWRtP9Jqcju0rrI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TC8Xddtl1HJt37Ps1nNyUH6n8QCnzqqMTRg0HsZnec0YiVtXPvOwJTYEaDI9a3PGS
         PY7zEUU3JVWozkYx6P1T94ACgAdZ+457o+WJMxhdkCX1/it90X12AU3FqytRqhBtO3
         92L6YwwyfvdmdBB6yMWDOWoZzjpwHsmhkz1+YKMLHtCLEI7EfOahXRq85XhMTmjjEb
         cffwz9vu3fLDOmxDD/a3IciYAiWBjii3scW6A5/gvRO9PvaFlKGCzgNxSfSmEmtb01
         oZy/duxs51NVPDoL38g9irImPQxEbwiN5YRmAS3OKqA3adNvOUPfYIzLuq28aelnX/
         RQP4ULQE9MLmA==
Subject: Re: [GIT PULL] new smb3 kernel server (ksmbd)
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msoKV7qAgoKipa+QNDJ+xR83YGuz+he+GH9sPTSzBMLHA@mail.gmail.com>
References: <CAH2r5msoKV7qAgoKipa+QNDJ+xR83YGuz+he+GH9sPTSzBMLHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msoKV7qAgoKipa+QNDJ+xR83YGuz+he+GH9sPTSzBMLHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc-first-ksmbd-merge
X-PR-Tracked-Commit-Id: 7d5d8d7156892f82cf40b63228ce788248cc57a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e24c567b7ecff1c8b6023a10d7f78256cef742c4
Message-Id: <163042809342.7406.683232852261811056.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Aug 2021 16:41:33 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 29 Aug 2021 19:32:41 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc-first-ksmbd-merge

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e24c567b7ecff1c8b6023a10d7f78256cef742c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
