Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AE9C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 02:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29EFB218D4
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 02:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552702215;
	bh=hHIwMNbIaWpmkIf8jSXaWGj8QI9zwXfiprq0JA11rp0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=zfv6mIUAyn7OK9Z9gjiNnSQ7KzitgVsjMGyCR4k6zW5fmE3+7KOf8laOxPM9UE2Jy
	 toM9XqbTDYWJNpeANCnZonfVMJynucLwaUfjp714vLK8+EoQ78QnyU079wb2/LuM/p
	 gDnrqkDKHF6Y5FMsrnY81HwqYMJAfykqI+2qMlyM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfCPCKO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 22:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfCPCKO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 22:10:14 -0400
Subject: Re: [GIT] SMB3 Fixes and debugging improvements
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552702214;
        bh=hHIwMNbIaWpmkIf8jSXaWGj8QI9zwXfiprq0JA11rp0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=mDpItP7nmHLfdy4qitzDmfjZu3mNFpYzDDjbi+8Lpx6qOhhFzAyKTF8/hp/mOZlHQ
         PN1o0XDTwivYBZ7C6zibkHgJ8wetgJWpmS9Kj9gChBa8+bgfIJnOiICDpfeARA7Mbj
         8o7eVBmZIS06Y4E5N2V4R2tTV1vrL1MiIQ5/N+VY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
References: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvDGcGD=GP+-5984DJ9U_cYLWvkMsJORX4LZ7_1sVKpgw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3
X-PR-Tracked-Commit-Id: bc31d0cdcfbadb6258b45db97e93b1c83822ba33
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9c7dc824d9a48f98b4ee20041e865d97bc73a626
Message-Id: <155270221394.23881.9821248224931349150.pr-tracker-bot@kernel.org>
Date:   Sat, 16 Mar 2019 02:10:13 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 15 Mar 2019 18:39:21 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9c7dc824d9a48f98b4ee20041e865d97bc73a626

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
