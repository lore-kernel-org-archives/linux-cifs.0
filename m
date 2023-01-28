Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB84C38142
	for <linux-cifs@archiver.kernel.org>; Sat, 28 Jan 2023 01:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjA1Bpp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Jan 2023 20:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjA1Bpo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Jan 2023 20:45:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205AB8CAAA
        for <linux-cifs@vger.kernel.org>; Fri, 27 Jan 2023 17:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E6ADB8220B
        for <linux-cifs@vger.kernel.org>; Sat, 28 Jan 2023 01:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5031C433EF;
        Sat, 28 Jan 2023 01:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674870339;
        bh=GwygOOeasKII1Hs7Wy611recrtzHbrYiegSqdoygfdY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=TyzCvZIzKuRPKHVoc6Y8RvqjxZs0fPFEmrMgBfdLoAKYftv/QRv1rlmVMPl5pqory
         VzbJu0LxlSziv8N4O2i7SUR/XvW3otV7IL73XLy1b586QvitWTowm1mCOCipTmu626
         2C0KuD6biG0/Cdjf2SzgKftEVd7z+83ejXr030alEojWE5TDiLFrlonGZbH8ZSViRZ
         ikyK26YuFDOR4h7QPyIT2Riv9iUvnFRzi7sZw4jdneQnY/oAYXyPPX28Li624PCZ1V
         uUcs4RS7w+/HqvB/aKTq4Ga7nQfOBmCoJmcRgky3D5iZBWgS+gcVcOE3yF4nlWC2RJ
         bYCq0EIPpTvhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9FD64C39564;
        Sat, 28 Jan 2023 01:45:39 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fix
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvPn-B8Lqy4Dh3kYRpMtEXCpUrChpE65ddzDy-W1oZ=4Q@mail.gmail.com>
References: <CAH2r5mvPn-B8Lqy4Dh3kYRpMtEXCpUrChpE65ddzDy-W1oZ=4Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvPn-B8Lqy4Dh3kYRpMtEXCpUrChpE65ddzDy-W1oZ=4Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc5-smb3-client-fixes
X-PR-Tracked-Commit-Id: b7ab9161cf5ddc42a288edf9d1a61f3bdffe17c7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5af6ce7049365952f7f023155234fe091693ead1
Message-Id: <167487033963.11362.4556918610686892098.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Jan 2023 01:45:39 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 27 Jan 2023 18:45:28 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc5-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5af6ce7049365952f7f023155234fe091693ead1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
