Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60AEC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 03:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiHIDWF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 23:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235985AbiHIDVK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 23:21:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836D11EC6C
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 20:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5E2A60F98
        for <linux-cifs@vger.kernel.org>; Tue,  9 Aug 2022 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 241D0C433D6;
        Tue,  9 Aug 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660015210;
        bh=j8XUpcj0gZXSh39T7wDuBOogjV2N7h8PS388d5w0JWw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Pz3TvMGZOpPFpeUtU79bCyYHQU5WJUcIokkQFbX6FjT5TXW2q8DU9eq3R96Br4si9
         GVywgxByZtC/+r9pOqEVzOnFckhKX37vjIZpB7WEaWe8cRPpkRy+HEOcjmh7929WS9
         UV01/T0gqaYCh490L0a7GN2yLk3HgGeIEPrTBp/TTp4Wjak86sY8g/z/d8mgIAbKpG
         0a7hwD6Czl5kSPRJk9rYlmu0nZDJwOZ9bwtz58L9HXtnZu9jAlnTEtktjW5ZWb5LUt
         AXy+Lg4P2nS422jT1br5x44k9w2PIjp+VIrRhMxbF3AU2p0z5In5CR9dscAhwZuT+O
         rbmRfr/qmep+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E432C43142;
        Tue,  9 Aug 2022 03:20:10 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms0RwBabutvhVrMWYrepeYuH=8_Fv5jHqLCtgCGj9vehg@mail.gmail.com>
References: <CAH2r5ms0RwBabutvhVrMWYrepeYuH=8_Fv5jHqLCtgCGj9vehg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms0RwBabutvhVrMWYrepeYuH=8_Fv5jHqLCtgCGj9vehg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.20-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 8f0541186e9ad1b62accc9519cc2b7a7240272a7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: eb555cb5b794f4e12a9897f3d46d5a72104cd4a7
Message-Id: <166001521004.18352.9625120421666569004.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Aug 2022 03:20:10 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Mon, 8 Aug 2022 15:00:58 -0500:

> git://git.samba.org/ksmbd.git tags/5.20-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/eb555cb5b794f4e12a9897f3d46d5a72104cd4a7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
