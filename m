Return-Path: <SRS0=cd/P=TT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDDCC04AB4
	for <linux-cifs@archiver.kernel.org>; Sun, 19 May 2019 19:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C0AD206BF
	for <linux-cifs@archiver.kernel.org>; Sun, 19 May 2019 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558293322;
	bh=2NPU35+R0BIDd+eDKQ995xuCgF6F2m6s+/JE6TRSog8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=kytk7XAF9smZIHWnYR+Ls/82gmRvJ20X/mOO8raAVeoxr+MwuRmyF9leJW+1+42RW
	 Ov9RvO/YVD1oiBDY5FzxGMCJ+9gwcyQSKjm6g9aUUN08PKQO9Qie7lszR5sugd1syn
	 rMUN/JiLLkUr12nTZNDWsrbrCvCBihFtKUEUbAxQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfESTPW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 May 2019 15:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfESTPV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 19 May 2019 15:15:21 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558293321;
        bh=2NPU35+R0BIDd+eDKQ995xuCgF6F2m6s+/JE6TRSog8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Y7YMa6h5cBZhhpKEFbrEXYWLWiMd3PDgERKytfi13v6Y4tUGRw66lPJ4penVk1L3h
         W9Nu1OjMGhua5+73pyPLDtg5Hytz/6ZC6mLlisQvYsk1DLS/j/obVVAVNZu6eD2xKM
         jftngKG+uOmjnO/Z1Ss9H+hWCFjd/0fO8rl/5el8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msEB_bvDTOPLwtoH0Ty6ttXhb3RP+18d47xNjN7q0apYA@mail.gmail.com>
References: <CAH2r5msEB_bvDTOPLwtoH0Ty6ttXhb3RP+18d47xNjN7q0apYA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msEB_bvDTOPLwtoH0Ty6ttXhb3RP+18d47xNjN7q0apYA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.2-rc-smb3-fixes
X-PR-Tracked-Commit-Id: dece44e381ab4a9fd1021db45ba4472e8c85becb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d8848eefc1d541dd0e3ae175e09fb5c66f1d4de6
Message-Id: <155829332124.24875.10913503700761281896.pr-tracker-bot@kernel.org>
Date:   Sun, 19 May 2019 19:15:21 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 17 May 2019 22:37:33 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.2-rc-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d8848eefc1d541dd0e3ae175e09fb5c66f1d4de6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
