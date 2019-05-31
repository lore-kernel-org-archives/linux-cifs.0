Return-Path: <SRS0=zOxz=T7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C23C04AB6
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 20:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 647D126EEE
	for <linux-cifs@archiver.kernel.org>; Fri, 31 May 2019 20:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559336115;
	bh=W0Pdxvg7LRWYomnlBfhyOP7Wa9SKZbTdwsLyl/SmF6Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=cWSDh8B2DEiFQwpQ24n0CXWX/855lym52gqYPaE91e7fiItFnMPBJy5iYHU28UmE9
	 H3h5S3vtH4+llksUrCsNC57pe6VVmW5AIAC+YCh2PUc3kcf/HtiDe2XvfJ7mijPsC4
	 i6PYf1KYEyvjYPYPjsnj3rEOX9n77Z3MwkM5V6EU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfEaUzO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 31 May 2019 16:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbfEaUzO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 31 May 2019 16:55:14 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559336114;
        bh=W0Pdxvg7LRWYomnlBfhyOP7Wa9SKZbTdwsLyl/SmF6Q=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=avyRfxWmqQO/GeiJmaYJThRAq+a6FM9mnZjw3LX/eERQt00zEuSFV576y/x9HY0JN
         e3VXaxkG7w7YzG+wcLk4+8UEFAO7QSXqJmcO0T7F+F6fexbUj8zdZxC5HA9NqRYqc3
         V9S00Emw43Ksohkbb8wmtAhfEbGEFLHssmDqzOzI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms=pUiZQPmX_-AoUceAWgr4Y5RwrkLC0o8dyfcMSKpuCQ@mail.gmail.com>
References: <CAH2r5ms=pUiZQPmX_-AoUceAWgr4Y5RwrkLC0o8dyfcMSKpuCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms=pUiZQPmX_-AoUceAWgr4Y5RwrkLC0o8dyfcMSKpuCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/v5.2-rc2-smb3-fixes
X-PR-Tracked-Commit-Id: 31fad7d41e73731f05b8053d17078638cf850fa6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 41e7231fab9d76e906b6d8abe09c44c7b9656d33
Message-Id: <155933611418.3628.18268123204511844583.pr-tracker-bot@kernel.org>
Date:   Fri, 31 May 2019 20:55:14 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 31 May 2019 12:55:21 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/v5.2-rc2-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/41e7231fab9d76e906b6d8abe09c44c7b9656d33

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
