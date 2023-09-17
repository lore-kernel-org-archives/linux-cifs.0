Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43971CD13D1
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Sep 2023 18:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjIQSYz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Sep 2023 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238860AbjIQSYb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Sep 2023 14:24:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7834F129;
        Sun, 17 Sep 2023 11:24:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 207F9C433C9;
        Sun, 17 Sep 2023 18:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694975066;
        bh=NwzaGemdCz5tsv59zAUKRjcQmIf8BcuaLJ4N9QK+H0I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=BG1AIUknNeDK0pBc6TioFBRIJK5VhboIjP+K70VOELnjNwlzqw18GrMp5aWFi3C8r
         nVWLf5sf8DHFwtsMSHydN83ay2/OMwjn+Ix4mgCPbWUCBq9bNOETy3+NOJc5GJiF2p
         YTGSGPGXKgdAECA0HtiKhaelk8d0Iedty1Mgc+OVE6eF5hSddCS6m/YWaCRBws9NrT
         krcIJupQx45nJTXURw7BP5A8h3MB2tkmCBEHmMUQiDCW7SKO4AGuplZbGBZZ7VXEWG
         HU0u0Jh8KO/9NggKbquFWGmRqtC3rdgz1ywTgPyR7uKU+9NXeeeTLmUZ6wd3UOSVQC
         YqdzhGF3vLhOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06933E26884;
        Sun, 17 Sep 2023 18:24:26 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvynNQOCJFdVOTf82H3y_GF1UuF=EvcAw4FL1RVu5ieTg@mail.gmail.com>
References: <CAH2r5mvynNQOCJFdVOTf82H3y_GF1UuF=EvcAw4FL1RVu5ieTg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvynNQOCJFdVOTf82H3y_GF1UuF=EvcAw4FL1RVu5ieTg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.6-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 2c75426c1fea591bb338ba072068f83d2f6be088
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 45c3c627222f061a12e2f40612b80c17e915faf8
Message-Id: <169497506602.30007.16838396542261333254.pr-tracker-bot@kernel.org>
Date:   Sun, 17 Sep 2023 18:24:26 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 17 Sep 2023 00:42:07 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.6-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/45c3c627222f061a12e2f40612b80c17e915faf8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
