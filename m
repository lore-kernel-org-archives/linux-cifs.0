Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D99C46467
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 11:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbjAJLgo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 06:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237998AbjAJLgh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 06:36:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7C051322;
        Tue, 10 Jan 2023 03:36:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F4CD6160D;
        Tue, 10 Jan 2023 11:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1F0AC433EF;
        Tue, 10 Jan 2023 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673350595;
        bh=zRWVFsaYAu+MFZGYLMxUYwKWyxja897JN2VGkHVIaZw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uXGpUEZpZvQxpdaFvyFKfDmUEtLMUhrRYNGr3frGmVU3V+Bn5hCECEfQsUFi2XMX7
         pEKeOUG83Ne8vB7AsqFReJ5eHTB8As0KpOxG+fXpC+hZL8FMmnDJ0GeJvghMGRonQS
         YDERkKYMse8+Ky1PZbyGaClnER43ZQYpgQmC42Vy0R5f2dDINT/lfdlQHT5BV/G87H
         EdZOBQujmZzsemhl9TKW41+orX21pxD2RUlkqU6ULw5PBYhLFfAELd6baHoH/MXba8
         EC8lzwAqq/xBkYQ7NR7iRR4dFocaCHt97w4ST9NAvRm8Je6qjQ7+okA5bjCzQdp+M6
         iiIjv+svAgl1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F5F0E21EE8;
        Tue, 10 Jan 2023 11:36:35 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msyEy20e=FBx6wPWWc3kXzNR4b+zHshSqidRdFKVf_7Jg@mail.gmail.com>
References: <CAH2r5msyEy20e=FBx6wPWWc3kXzNR4b+zHshSqidRdFKVf_7Jg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msyEy20e=FBx6wPWWc3kXzNR4b+zHshSqidRdFKVf_7Jg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.2-rc3-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 83dcedd5540d4ac61376ddff5362f7d9f866a6ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 40c18f363a0806d4f566e8a9a9bd2d7766a72cf5
Message-Id: <167335059564.31233.54465897927371082.pr-tracker-bot@kernel.org>
Date:   Tue, 10 Jan 2023 11:36:35 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Mon, 9 Jan 2023 21:13:09 -0600:

> git://git.samba.org/ksmbd.git tags/6.2-rc3-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/40c18f363a0806d4f566e8a9a9bd2d7766a72cf5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
