Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B51B8C001B3
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Jul 2023 05:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjGAFFX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Jul 2023 01:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjGAFFI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Jul 2023 01:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CB544B5;
        Fri, 30 Jun 2023 22:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2AFB60E97;
        Sat,  1 Jul 2023 05:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4ED90C433C8;
        Sat,  1 Jul 2023 05:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688187898;
        bh=TwMV9+uujIXgBDvKLQKqMpwS4JWhr03Q1a3M+yiL1No=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Kbn43dW+L67lmEcypWYShj+L8iAJFTPmGz0/oKCMu2MXOYBrjkz9vC3FTDnvhQGzm
         sgtQLmtCD5UFpqKbKzljM2HYxePFhGESCMzWXAWFfH6I1FjqV92taKQLtRhJafS1F1
         oevLCzA6bDMSW5/VpubNXfzIFMZlevVoVnXbnnLPsggspp1/CeLBF8jIK+PTiD6+eW
         Xv2zLwpzzvMtWCkUl0Fxe2+d1moIQVNpJV7nFg9BEFL8MZx5Y7ukYgcnAhg7BFzOei
         wGR8XfM9t8qpcZ226IYwvN1j14MqqloGvSxVtjcgpElnk7roBC1AP/G/rJsDqxzcZB
         ZI+DtFKUduCSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3EF8DC0C40E;
        Sat,  1 Jul 2023 05:04:58 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msmdAXS+55Mk0SjyBgGtgPb4vp5z--3=DdFodPgrEoeaw@mail.gmail.com>
References: <CAH2r5msmdAXS+55Mk0SjyBgGtgPb4vp5z--3=DdFodPgrEoeaw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msmdAXS+55Mk0SjyBgGtgPb4vp5z--3=DdFodPgrEoeaw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.5-rc-ksmbd-server-fixes-part1
X-PR-Tracked-Commit-Id: 9cedc58bdbe9fff9aacd0ca19ee5777659f28fd7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8976e9d0039574b2336044fa5e3adb717f3ba54b
Message-Id: <168818789824.30776.4400111826873013720.pr-tracker-bot@kernel.org>
Date:   Sat, 01 Jul 2023 05:04:58 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 30 Jun 2023 00:59:52 -0500:

> git://git.samba.org/ksmbd.git tags/6.5-rc-ksmbd-server-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8976e9d0039574b2336044fa5e3adb717f3ba54b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
