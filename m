Return-Path: <SRS0=Tl6u=Y2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079D9CA9EC7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Nov 2019 21:40:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4DA921783
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Nov 2019 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572730805;
	bh=hJnnOEeR8LuBmz4p+oJZg9WeyhFNhSgNbSW/IosW+Yg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=sQWPJD5RxKLdrFG0q8q+u9uS0+fEzHhfvH6NPMcQiwwAUDYL/+4VI3ud28KuR/WZv
	 AEYNYhWO1odbAkgfGz77ROoQHPQ23xZsZNQrL25Irpvy0Cawpu/KUl3eTL65UuJ4ei
	 JcrFH3jqXMZNf+fozuIUWCT/VQ9sPxr1JXelheCc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKBVkF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Nov 2019 17:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfKBVkF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Nov 2019 17:40:05 -0400
Subject: Re: [GIT PULL] SMB3 fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572730804;
        bh=hJnnOEeR8LuBmz4p+oJZg9WeyhFNhSgNbSW/IosW+Yg=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Ghb5DgrkcMzCi+3JOBDMCwg1likqydXqAeWULYspk7ptte2CZzXqRmvxaRxKb1foe
         Q7TvgghT1c5liIwuSSKP9pLqu7l6JHn44Sy67dSMxG55LSjcJvwHiGSzXVANDDuZm1
         kQG2St6b1N8cVUZcYhdD6l1lfwcAx1jM+PDFbrR0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt+UYbU6=K4f_5FQLuDH2fJHwWhGKVGW3wzX-UYDcLMww@mail.gmail.com>
References: <CAH2r5mt+UYbU6=K4f_5FQLuDH2fJHwWhGKVGW3wzX-UYDcLMww@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt+UYbU6=K4f_5FQLuDH2fJHwWhGKVGW3wzX-UYDcLMww@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.4-rc6-smb3-fix
X-PR-Tracked-Commit-Id: a08d897bc04f23c608dadde5c31ef194911e78bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 56cfd2507d3e720f4b1dbf9513e00680516a0826
Message-Id: <157273080442.25617.456837500894323042.pr-tracker-bot@kernel.org>
Date:   Sat, 02 Nov 2019 21:40:04 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 2 Nov 2019 14:36:25 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc6-smb3-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/56cfd2507d3e720f4b1dbf9513e00680516a0826

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
