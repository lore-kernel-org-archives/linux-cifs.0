Return-Path: <SRS0=79/A=CI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C456C433E2
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 19:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A240206F0
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Aug 2020 19:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598815032;
	bh=Smp7rdArAfXO/SuafC7EkEbhf4T/X6GhDs3NyOWaSMo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Rho/KtKNvrzmb0yPqrZj/Mo01wrf34NGIYU7+MzBTRsm/rtWuHIvgRnG+8DTjY5ra
	 HOPFSU4c0CGVZPTTLuw0VwYI4gc3Qe8sseSXwUnZm+MsdQXrkIOXkOlb7sOWMoHIOZ
	 J1x3SvpDFEOUvl3sEsJSdecT52W7WnL8lJjWILf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgH3TRM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Aug 2020 15:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgH3TPd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 30 Aug 2020 15:15:33 -0400
Subject: Re: [GIT PULL] CIFS Fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598814932;
        bh=Smp7rdArAfXO/SuafC7EkEbhf4T/X6GhDs3NyOWaSMo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=R5suTdPIVuTJxcOJu38LSAoXO1pr7UDCmvDe4wrbogFfcWNjj8w5JVjJPTpi7V038
         volIrx5wtIL8IJjhunczhhpJv2PHteaz4uXkXDqQ10x/WybF1hhS0APkV8v9ocHYpG
         dC0Od7DZFhjbETVWl36X09KYWkaDcMsoK3qpgnVM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvs8Rdy_615XjMea7cCL1YrWthhr=GJW0ffTyDUwjtSrg@mail.gmail.com>
References: <CAH2r5mvs8Rdy_615XjMea7cCL1YrWthhr=GJW0ffTyDUwjtSrg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvs8Rdy_615XjMea7cCL1YrWthhr=GJW0ffTyDUwjtSrg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc2-smb-fix
X-PR-Tracked-Commit-Id: e183785f2529b4135f00a0330a3b08e7c86530c8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3edd8db2d53fe6c96ad66248bb1479ae62807268
Message-Id: <159881493275.11937.16692614311127964701.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Aug 2020 19:15:32 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 30 Aug 2020 10:24:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc2-smb-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3edd8db2d53fe6c96ad66248bb1479ae62807268

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
