Return-Path: <SRS0=CJ3z=R3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5347AC43381
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Mar 2019 18:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2445E2133D
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Mar 2019 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553452852;
	bh=ZV5EJNolKIvs+5KwA5v+icx1qJFbpDEkxW3x2LfO3oY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=FZIeNmRtZsWHAy930aH9TTbU0WrYU5RSwaSoVjsw7TqhglFjVRn3dhzGUupMgyzPK
	 24k/JP9ho4fw4lRfakTK68qJanIi+4HQ6pvS5EPYhADKzQ7Y7CkEMHHjDR1Jv5kYWa
	 uyOY7j3XOUori5Rr2i8VTQdmK/ziv1GjsKYFWJ84=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfCXSkh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Mar 2019 14:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728935AbfCXSkN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 24 Mar 2019 14:40:13 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553452813;
        bh=ZV5EJNolKIvs+5KwA5v+icx1qJFbpDEkxW3x2LfO3oY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=n6FBw1SrklUp3xOn0y4tkPMdez6XYClBqvqjDpkfuHT9pVAHOHk3qf4xBf4u9Eq4g
         VGogA5XUvHPmpzMQCs2ML0EJA82KHtNhU1xkIYv1HTPlAz+CgWwImnQptQVB+u6fX5
         3HCGPXvClrZu1nDZrDQ/nPrdEyTW5xaS+ttoVubI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5musNnYwS04DgN5W8yZMDvZG1UhLraOo_qsRjA8nVudacA@mail.gmail.com>
References: <CAH2r5musNnYwS04DgN5W8yZMDvZG1UhLraOo_qsRjA8nVudacA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5musNnYwS04DgN5W8yZMDvZG1UhLraOo_qsRjA8nVudacA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.1-rc1-cifs-smb3-fixes
X-PR-Tracked-Commit-Id: cf7d624f8dcc9b833a8489208b6ef6dcc5dd308b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 38104c00200898120e12a73db27cea2b7055ea3c
Message-Id: <155345281295.5356.14418180419225073288.pr-tracker-bot@kernel.org>
Date:   Sun, 24 Mar 2019 18:40:12 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 23 Mar 2019 22:22:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc1-cifs-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/38104c00200898120e12a73db27cea2b7055ea3c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
