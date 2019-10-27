Return-Path: <SRS0=GKCu=YU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818F1CA9EBC
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 11:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5893321928
	for <linux-cifs@archiver.kernel.org>; Sun, 27 Oct 2019 11:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572175825;
	bh=2VaHNPvCx/dmdR/cKdZwOAI/jgLgRvfZOTPcNXII2I8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=e25e5G1jjSqPai2OZLLuye+11dMawKXP33rOmIW0A6CypSRAEKruz+xfFpYv9sYhq
	 0ysFBb5CrSeEsdrOi6B1/Tj8GOgkMJZTGJVc28RlVStURGmdw3NqTyMIDE5pzLVpl9
	 LH5kDYdZDOZvNuWOdT75LvXU4a+WYALqXk8phYpM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfJ0LaV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Oct 2019 07:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfJ0LaF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 27 Oct 2019 07:30:05 -0400
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572175805;
        bh=2VaHNPvCx/dmdR/cKdZwOAI/jgLgRvfZOTPcNXII2I8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=odSZ15MmLnoqKYq1MgAOqtNeKKm/V2Rq97mpkxnP/CDoOobnRFipSV/E5glZH0mte
         79w+er4HPwnR6B1ulQRANmewenmiaUq1ANN6cPHNrOMByLesXwO247XK1teSDCMIIw
         WOIT1zu+NdBskQ6E/zgBRy0zhDEF5ZkwSVgZlukI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muwqB-D9=2ZxBkT-T77PkjAHh4TPpsr9vsDZD5nmu9jyw@mail.gmail.com>
References: <CAH2r5muwqB-D9=2ZxBkT-T77PkjAHh4TPpsr9vsDZD5nmu9jyw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muwqB-D9=2ZxBkT-T77PkjAHh4TPpsr9vsDZD5nmu9jyw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.4-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: d46b0da7a33dd8c99d969834f682267a45444ab3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c9a2e4a82905c4759d3894bbe827b84574a69b91
Message-Id: <157217580523.15608.9168706059879836770.pr-tracker-bot@kernel.org>
Date:   Sun, 27 Oct 2019 11:30:05 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 26 Oct 2019 21:40:04 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c9a2e4a82905c4759d3894bbe827b84574a69b91

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
