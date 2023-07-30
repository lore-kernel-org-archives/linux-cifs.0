Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E609EEB64DD
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jul 2023 03:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjG3Dxk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Jul 2023 23:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjG3Dxk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Jul 2023 23:53:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313A01BC9;
        Sat, 29 Jul 2023 20:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C452460909;
        Sun, 30 Jul 2023 03:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B877C433C8;
        Sun, 30 Jul 2023 03:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690689218;
        bh=OBw8aJVrT+hGofvjQ/7LOP2RwmFtXtB9iZEBLUSuvg4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sdENXbEIwwXMsspJjH69gJUZqKlaahVL5Yo3QlEl4yEH3g2XHilHplvn7byuW6Et5
         /QbgZyzDAck0yyhJViMoA4/EkHOc3aGwbqBrxwbJXOnBhU+CFVrP2zDO4Wim45jNe4
         xdBmWOOUewMqLc84gwqfI9r5+SmErveoC/pCE1SI2u5NoRnA2ihCPC1qOF7BKZFcLd
         KwswPVoXs3NAkprRbMvhjkcLdFfi2jGg64dtXoaFLxc+c1T0zFkdyRkBZ5PgkCkcbb
         Q/dzATaRce834mYPdlM6BB53DEz2hrPbDkOJe059Wu31yu74mCWKCstLd+vQ+wBEMi
         dgnnwxDhUdj+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21DCDC6445B;
        Sun, 30 Jul 2023 03:53:38 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvzyVsou=Avw8GjxwV5CRgEMY_4XO+JEaZLk+GF-QjyzA@mail.gmail.com>
References: <CAH2r5mvzyVsou=Avw8GjxwV5CRgEMY_4XO+JEaZLk+GF-QjyzA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvzyVsou=Avw8GjxwV5CRgEMY_4XO+JEaZLk+GF-QjyzA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: a171eb5cac427fa8d084eaf5e47fbe4c0f1e279f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d31e3792919e5c97d572c8a27a5a7c1eb9de5aca
Message-Id: <169068921813.25281.17550201565429848923.pr-tracker-bot@kernel.org>
Date:   Sun, 30 Jul 2023 03:53:38 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 29 Jul 2023 14:07:53 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d31e3792919e5c97d572c8a27a5a7c1eb9de5aca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
