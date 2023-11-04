Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCFDC4332F
	for <linux-cifs@archiver.kernel.org>; Sat,  4 Nov 2023 19:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjKDTjT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Nov 2023 15:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjKDTjS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Nov 2023 15:39:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78875194;
        Sat,  4 Nov 2023 12:39:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22F9FC433C7;
        Sat,  4 Nov 2023 19:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699126756;
        bh=kl7OdQ66DpF8N2FGT3Ii0JOgx9GbRPC7XkqEO9EcJIE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ZImmqtnE3CAs6IykwcOWOESyVjzA0vlmprEkFwqyUFG+urOBA7hNbEFo705w6GG3F
         OVfSZ0a649/xXxBuRZQZWaUiilyoBoXn2r7Kwxw3v7d76kS5lmAo0usClAhLCVHy6M
         uSEddL4iO66C8Pv9t4ZWi4hF6P7fuzyTyJ8ws3SKB+H9obqrhJrFPLaZbN3vR83Dng
         hfF8u04xymu+wt+4xhJLVdDYULLjB7EAksjEsM3OMK6HlGVwENzImcYoQ5C4JA/Hb6
         VMskiyT3MRi22LYMsbiYt1wx3dmO+eLpprRTQH29wcdsMPtiuwPsn3IJce8dJBwHWZ
         VdZlf955NzTeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10A19EAB08A;
        Sat,  4 Nov 2023 19:39:16 +0000 (UTC)
Subject: Re: [GIT PULL] smb client fixes part 1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvutKF1meVmfiRu46tpYRckRuNf5j-gY02b0P=KTV2mpQ@mail.gmail.com>
References: <CAH2r5mvutKF1meVmfiRu46tpYRckRuNf5j-gY02b0P=KTV2mpQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvutKF1meVmfiRu46tpYRckRuNf5j-gY02b0P=KTV2mpQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc-smb3-client-fixes-part1
X-PR-Tracked-Commit-Id: d9a6d78096056a3cb5c5f07a730ab92f2f9ac4e6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 766e9cf3bd64c45fcace3acc6f8b3df815448ea3
Message-Id: <169912675605.21555.10000327327480138420.pr-tracker-bot@kernel.org>
Date:   Sat, 04 Nov 2023 19:39:16 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 3 Nov 2023 22:36:24 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.7-rc-smb3-client-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/766e9cf3bd64c45fcace3acc6f8b3df815448ea3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
