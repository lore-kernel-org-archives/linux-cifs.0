Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7370CC433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Feb 2022 18:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbiBMSEZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Feb 2022 13:04:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiBMSEZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Feb 2022 13:04:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E1D5B890;
        Sun, 13 Feb 2022 10:04:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F2F361218;
        Sun, 13 Feb 2022 18:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6CDAC004E1;
        Sun, 13 Feb 2022 18:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644775457;
        bh=WC5gxCNADkAGCTKXDGfgw4uJLA8GmzBGdQ/FNyYnj3o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nIKfhTKE6va4RxKtRYrk8wNFXdbKr6rFIqw7QOTbddzFdRDmy3H3/NLcT8wB41u2a
         jGAMd7BVS1RcCd9oJJsv5BgNvJ9+NBQLhxIUUJJB1NU+P5OEwGbN0XmTzEAKaMX4EO
         ZdM+kydATx2b3wmLrKTxgY5HCIxUOVksyMTn7ICX2/+0/DQTrn5bztcJBOdagH/r6e
         16h9jaVTjGrATpdyrpLZd7U4uu2jD2g0oUGyxnzzBdYSiH9hNR28wmGApOhece4qTY
         A6D0EomfziMikDltjbXysEjW3PYaueQ9UPlVSBuX5M66YaUIWkPQjuyyibyLtw68YQ
         gZHy7ZOMGfixw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5DEEE5D07E;
        Sun, 13 Feb 2022 18:04:17 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvoW2O5c6_SRTBaC5R0FQ1y70WZ-3hfs-k8jQ7UuqUMAw@mail.gmail.com>
References: <CAH2r5mvoW2O5c6_SRTBaC5R0FQ1y70WZ-3hfs-k8jQ7UuqUMAw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvoW2O5c6_SRTBaC5R0FQ1y70WZ-3hfs-k8jQ7UuqUMAw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.17-rc4-smb3-fixes
X-PR-Tracked-Commit-Id: 2a05137a0575b7d1006bdf4c1beeee9e391e22a0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e9c25787db080cb28601ce182088ce77659f684b
Message-Id: <164477545773.17492.7319817686272305175.pr-tracker-bot@kernel.org>
Date:   Sun, 13 Feb 2022 18:04:17 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 12 Feb 2022 14:20:30 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.17-rc4-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e9c25787db080cb28601ce182088ce77659f684b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
