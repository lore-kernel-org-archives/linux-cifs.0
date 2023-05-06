Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE24BC7EE24
	for <linux-cifs@archiver.kernel.org>; Sat,  6 May 2023 02:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjEFCUK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 22:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjEFCUJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 22:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7AF101;
        Fri,  5 May 2023 19:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED800641DD;
        Sat,  6 May 2023 02:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5604AC433EF;
        Sat,  6 May 2023 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683339607;
        bh=xhwjIeJR5ESGnA4DDITcj+rCAi+jdF01WbZ9r3O2A/I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ny+/TixONd5Eo+hkMg710YKlIQnCFle9sIpBQAzLXTmeZMUoibX7Xic6bDsYjGIsV
         pomdyDe7e50NyOssHm5q5AUqatO7rNSCqOq6Ci8835zuszvbu9ENmE39vkOBiid2Y2
         Oglc9juXqfNcVNnrKioHlkfChwVAUuaYkBou81bDaUDOzIbd+KcVtkfc0PjJnNeC+p
         swNGlObP6zw3u/bkwbdagvLnuDHn2T2BCCtUd211kSWG5sIslhXkctSrtOJ5IESKEO
         MmG/5DbsZdHk1sYT6NeZhPSv31TKnH2RBI6uP/at2qbzjjJC9M/eAoVVS2mOPaSLuq
         YsoRPJhhrMndg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 478E6E5FFFA;
        Sat,  6 May 2023 02:20:07 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msXNvALwEwtEyQuX_VjN=aNgfPZkvMbR74GeBHZyTDO_A@mail.gmail.com>
References: <CAH2r5msXNvALwEwtEyQuX_VjN=aNgfPZkvMbR74GeBHZyTDO_A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msXNvALwEwtEyQuX_VjN=aNgfPZkvMbR74GeBHZyTDO_A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.4-rc-ksmbd-server-fixes-part2
X-PR-Tracked-Commit-Id: eb307d09fe15844fdaebeb8cc8c9b9e925430aa5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e1e1337881b0e9844d687982aa54b31b1269b11
Message-Id: <168333960728.28237.14225405585433312318.pr-tracker-bot@kernel.org>
Date:   Sat, 06 May 2023 02:20:07 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 5 May 2023 19:19:00 -0500:

> git://git.samba.org/ksmbd.git tags/6.4-rc-ksmbd-server-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e1e1337881b0e9844d687982aa54b31b1269b11

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
