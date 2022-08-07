Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9722AC19F2A
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Aug 2022 17:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbiHGR5u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Aug 2022 13:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235180AbiHGR5s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Aug 2022 13:57:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F51009;
        Sun,  7 Aug 2022 10:57:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16A3760EC2;
        Sun,  7 Aug 2022 17:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EC3AC433D7;
        Sun,  7 Aug 2022 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659895065;
        bh=kd0bwjvFUCZhLzG0N9FWUoXqoeSwdRTRG0pYhyrdz+k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=osxxASxAa0qx3aAqhWzNLpJEVuxzESslFoQsX62oKc6yAlKwdgfy/0Gti0KNmTSmc
         l017bwrhXHBhGT1IsjzVPiyGxhYgrxtuXAkpiGbg0G0GFes/kWM3xX8C1cqQCR9Iit
         JWMYGke0kavIxWoUsICNLVZbVrASvHnRPKW29nsJ0+KoNzuqflIgAGLBlmWqqTMFRu
         gr3goFseqf6n8WrsJal6rxXq6pUiW2ZjvjAntgYIDVS0n7MZDaaZgvtO3Ks5cHphTM
         K5U7G2GNmBYx+YWhievzADQ43IexWR4daPl3yhMfGprfXY2DpXVnPnsXsHgmi6XAed
         8K3ah9b+HtNfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E7B5C43140;
        Sun,  7 Aug 2022 17:57:45 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvaTWyWnPpYk=OPCbud85LEo5Oj=K2ZK56jmri6452zRQ@mail.gmail.com>
References: <CAH2r5mvaTWyWnPpYk=OPCbud85LEo5Oj=K2ZK56jmri6452zRQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvaTWyWnPpYk=OPCbud85LEo5Oj=K2ZK56jmri6452zRQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.20-rc-smb3-client-fixes-part1
X-PR-Tracked-Commit-Id: 0d168a58fca34806b575c7cba87afb11208acb54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3bc1bc0b59d04e997db25b84babf459ca1cd80b7
Message-Id: <165989506518.6057.15950755031817245971.pr-tracker-bot@kernel.org>
Date:   Sun, 07 Aug 2022 17:57:45 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 7 Aug 2022 00:03:50 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.20-rc-smb3-client-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3bc1bc0b59d04e997db25b84babf459ca1cd80b7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
