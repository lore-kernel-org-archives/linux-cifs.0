Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3196FC32789
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Aug 2022 18:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiHUSmm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Aug 2022 14:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiHUSmm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Aug 2022 14:42:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DD517589;
        Sun, 21 Aug 2022 11:42:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF1C960A67;
        Sun, 21 Aug 2022 18:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55FD3C43140;
        Sun, 21 Aug 2022 18:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661107360;
        bh=De5Vnxd6xWWT+usTN3xck2FR4fVpjzVxn/cdXzh5Q1M=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rGLUlD+mD1yRA/lyYiPb64RzNulgYuumnvFzFk3ayKDPpdQgf0AhW7ymGqUb3N0MT
         DQq6BJUvhxCnbYkQka4bbN3FP/tFsCxyuDcydGgXQyFaeE6TCTXtlj5m2E4Stf63Y+
         JhOx3Jg53AahMfkl/Ll6Tadsu9ijg6ruOUzwaa3k8eJFFlV4v4bQy4I1tWpW2jkrw8
         bYUCA6JWsxOdstTWkoTFI4N4Zxnxk5Mwh52/tFo8Z4cjetGFBvCzE9EFxPjMFpPOX6
         r2xp4rxBAlnuJeZ1Am51YGUWh1RlbMCH6pn8YEz3nvqHMOHRCl203FXNS4aG3zXaP4
         zTpHvHv/5u/zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42CBCC43142;
        Sun, 21 Aug 2022 18:42:40 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtDFpaAWeGCtrfm_WPM6j-Gkt_O80=nKfp6y39aXaBr6w@mail.gmail.com>
References: <CAH2r5mtDFpaAWeGCtrfm_WPM6j-Gkt_O80=nKfp6y39aXaBr6w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtDFpaAWeGCtrfm_WPM6j-Gkt_O80=nKfp6y39aXaBr6w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc1-smb3-client-fixes
X-PR-Tracked-Commit-Id: 13609a8b3ac6b0af38127a2b97fe62c0d06a8282
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 367bcbc5b5ffc7164fb6ce1547e84dbf21795562
Message-Id: <166110736027.1794.11382703436922944063.pr-tracker-bot@kernel.org>
Date:   Sun, 21 Aug 2022 18:42:40 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 20 Aug 2022 17:34:30 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/367bcbc5b5ffc7164fb6ce1547e84dbf21795562

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
