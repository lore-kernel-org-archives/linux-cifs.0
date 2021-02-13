Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E917EC433DB
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 20:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D07364E29
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Feb 2021 20:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBMUE0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Feb 2021 15:04:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbhBMUEY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 13 Feb 2021 15:04:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6549E64E00;
        Sat, 13 Feb 2021 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613246624;
        bh=Mi2e3XpMsFLpQL40uqcrnqIGq07lJDUBvfHRdmeez5I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UvRJcuVnnaHWElWzCH9CQACj6y0NBClxW50D+oUXLQfXQBQNROpBZOYj09+2Pob2q
         L1sLwJSHxurtRtzCS1sn/HFbAbu/l7Po10wTMF8AwyCAUIgPlYhdGZUX5j5wK4c5xq
         7lOzdfuZskUJ3e0YuqnVaml63G/3vJEuuBdmJfUxDjmy3HRwDgtYiubk0HXA4cAoho
         dkVUZPmVL3AhzE9dq8sf3A7qfsw3bWSGycud4r7iYjpR7V3G5qsEkJ2Z2c0NER5ozb
         sRcIgNDCQ9FoMqVwFht4o1/8xvB69191OlBFldovAIiGaU7b/TmQyL4ry4JSww45GR
         mqjQHh403Nyyg==
Subject: Re: [GIT PULL] cifs fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3
X-PR-Tracked-Commit-Id: a738c93fb1c17e386a09304b517b1c6b2a6a5a8b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7989807dc0c95c4b787698eba10905a5baac42e8
Message-Id: <161324662438.16511.16513100434895733477.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Feb 2021 20:03:44 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 12 Feb 2021 12:15:57 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7989807dc0c95c4b787698eba10905a5baac42e8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
