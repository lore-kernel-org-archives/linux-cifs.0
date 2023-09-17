Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BDCCD37B4
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Sep 2023 18:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbjIQSYz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Sep 2023 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbjIQSYb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Sep 2023 14:24:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF8498;
        Sun, 17 Sep 2023 11:24:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09F7DC433C8;
        Sun, 17 Sep 2023 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694975066;
        bh=FDGdHwkRNPrTVp38hUytJBNar8UC14Cnym3MXmktDVE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=nC8/qGFEf569OptY63IHS3UXeEuMBs/k94mo/gB21JO/iin0DJ5Ckg2FqfSTPbvKM
         LFhe383p7tJQN89sHHg0v0DzrY6xF/ejcBbh5PcD5xTWnEHtqIx5FO/jIpETNnM2A2
         dbUf3zHt6BBZfBRqctTtg00z9AM+tYTULSS6HDqB/695PzUml65AhM5oapDahlZjGE
         YkdHEoza9+9gqbMqx+WGRIAP8kGpik1qtzbiRBN/CrETDxvaDSE8TP0YjCKVNfpbVy
         chqfpbVu19oL1rVkQAukCG72KIA/Lvfvto1ERaP86MjXG4eO+oYeky72H/5CdJoqCJ
         Lo9tAC3pD3t/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC919E26880;
        Sun, 17 Sep 2023 18:24:25 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtanACUTG3pjXuroE6RUw1WHOw1N4k1bbTmNHrydUK_sg@mail.gmail.com>
References: <CAH2r5mtanACUTG3pjXuroE6RUw1WHOw1N4k1bbTmNHrydUK_sg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtanACUTG3pjXuroE6RUw1WHOw1N4k1bbTmNHrydUK_sg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.6-rc1-ksmbd
X-PR-Tracked-Commit-Id: 59d8d24f4610333560cf2e8fe3f44cafe30322eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 39e0c8afdce04157ce229c3d4aa21f80356e88c1
Message-Id: <169497506596.30007.11928975574136827008.pr-tracker-bot@kernel.org>
Date:   Sun, 17 Sep 2023 18:24:25 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 16 Sep 2023 20:55:46 -0500:

> git://git.samba.org/ksmbd.git tags/6.6-rc1-ksmbd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/39e0c8afdce04157ce229c3d4aa21f80356e88c1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
