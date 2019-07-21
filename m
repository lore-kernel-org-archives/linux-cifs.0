Return-Path: <SRS0=7sqO=VS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531A7C76195
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Jul 2019 17:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30487205C9
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Jul 2019 17:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563730534;
	bh=0c9wqIbTNNk+aeOzXcI2UuaBzNiigppZlLCMZ68AmIw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ouW2+p0qtq3lloA3iteeuQ4lDQeFioQYSfypm3yWXpFvPcYOPVFrHNvAawuTxpoAT
	 9sKh7q2fPj6lO+9zGeJG9b2dxxUxWH5WjdL+5YjGzJC62csFDQDrUgsQhYnND+P8r/
	 LzAOurkDIfpbfivhTDXts7JZzSfMR6RIPgqeNYkI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfGURfZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Jul 2019 13:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbfGURfZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 21 Jul 2019 13:35:25 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563730524;
        bh=0c9wqIbTNNk+aeOzXcI2UuaBzNiigppZlLCMZ68AmIw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=cvihYoiiozfZtRtt/ks/7gCSEumwwefcOwbysGgKuiStlpzSKwyy4/t7UrHuPTtDv
         aVkcOK9e9c8Kep8sI9xA3TlNmTKcCgX2dbkl7emlhfReWba26dddw8zIMkw4qaw1VJ
         3GPJ4usz+41wFavFaDil/SJ+Ybr8AxPyMD0YRrzM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muOA_2qm+Ah4TDDUA7zUAzYLxpwX-+XLuY95kmRMiPB0w@mail.gmail.com>
References: <CAH2r5muOA_2qm+Ah4TDDUA7zUAzYLxpwX-+XLuY95kmRMiPB0w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muOA_2qm+Ah4TDDUA7zUAzYLxpwX-+XLuY95kmRMiPB0w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.3-smb3-fixes
X-PR-Tracked-Commit-Id: 2a957ace44d4cf0f6194a4209d4fa67ee5461d8f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91962d0f79cb61776bfb97eb5ea912e49e809d6c
Message-Id: <156373052446.21043.1969421287821131790.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Jul 2019 17:35:24 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 20 Jul 2019 18:48:45 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.3-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91962d0f79cb61776bfb97eb5ea912e49e809d6c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
