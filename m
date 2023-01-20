Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A04C38159
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Jan 2023 22:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjATWib (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Jan 2023 17:38:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjATWia (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Jan 2023 17:38:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A6722A25;
        Fri, 20 Jan 2023 14:38:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A09ECB82A68;
        Fri, 20 Jan 2023 22:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57AA0C4339B;
        Fri, 20 Jan 2023 22:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674254307;
        bh=QLbPU9eAYmoROBLx3KkIcxhf9AIMhTr5gxbMIOoCkVk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uWSY6Fva9TlKBhqyRQwP0L95svJ1kLUo/yQ6PchHLJup/YQhd9d6hqlGuggMujzRJ
         tAq3LRBUK9+11QeV3JDGKsyHYvsX790pNQN1hh/ci3EqnXwlySKCJQVeSa42ZO4vVs
         mJpUEGfTmKSQgXusDUSs2R0PW2SppFr2LcVnz4oQ3rga3qEM820xE7oT9HV2ceD0WP
         CQ1SPb7ldjo1y7hRZt3aVlQZ/PW2c5BHQKJKBZQplpJulQJUs5UKYy5rnIoXhKHnQZ
         pP7DCJ4LA16dbQ4gttSVGUY+EHdWS3OA3G/8yDYvf4sxTalhdv2Pl19umAfZn9LD9J
         1SoJhB6FZmZqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47B09E54D2B;
        Fri, 20 Jan 2023 22:38:27 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtJDpG9COgrDSrytNvcsCruxe1svD5CtjeYnakQDjrVCQ@mail.gmail.com>
References: <CAH2r5mtJDpG9COgrDSrytNvcsCruxe1svD5CtjeYnakQDjrVCQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtJDpG9COgrDSrytNvcsCruxe1svD5CtjeYnakQDjrVCQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc4-smb3-client-fixes
X-PR-Tracked-Commit-Id: a1b7c8457ecc062f612a1aca174c2e1c21f9ac10
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e31badaa188d0e2923f5082c041083c05bda3ff
Message-Id: <167425430728.2096.9732513153474237440.pr-tracker-bot@kernel.org>
Date:   Fri, 20 Jan 2023 22:38:27 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 20 Jan 2023 15:23:33 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.2-rc4-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e31badaa188d0e2923f5082c041083c05bda3ff

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
