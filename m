Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07921C04A6A
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Aug 2023 05:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjHJFCn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Aug 2023 01:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjHJFCm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Aug 2023 01:02:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5292112;
        Wed,  9 Aug 2023 22:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8050564D5E;
        Thu, 10 Aug 2023 05:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDB86C433D9;
        Thu, 10 Aug 2023 05:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691643760;
        bh=1JWYfYzQIxC8qLRUPGAeiYfCj7cQn8F2X277FTh1lyA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Hxw/UWAP9Lqe1oYxbXDg9CMXAGfi8k+ENeNzYzjexnplLQg64JXCOxQbVg1AFO0dS
         xWx1qNDGhTreuuwP0DNqRZXG3xa31ki6FYaqaPqlE3Pm579Afb/GoBFesE3zx1b2Lo
         D4ZnvPbEGtGTcqtoL9EaD7ZYQRbKAblWobOWzGdZ3ERTW4CtNHQOYNv8W083jiIocj
         JbGSO+2uwPs9XPH21yvlfL9X/jaQ4E2UserM3BZXBMQ8aUaAUfMoze91fUeygQjZ5l
         JmFN7xMah+hVNZASvc/R1G+cAK/u5a8KRY/Jv1gNTbjVUGQy6jw1SJMJ7ijnzqD7e6
         Qw4ndyfuR0Y8w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBDCAC395C5;
        Thu, 10 Aug 2023 05:02:40 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv+Sy5mrZThrQUf1na-mg-B9DiLd5fkYs9sPo97GWirCA@mail.gmail.com>
References: <CAH2r5mv+Sy5mrZThrQUf1na-mg-B9DiLd5fkYs9sPo97GWirCA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv+Sy5mrZThrQUf1na-mg-B9DiLd5fkYs9sPo97GWirCA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.5-rc5-ksmbd-server
X-PR-Tracked-Commit-Id: 79ed288cef201f1f212dfb934bcaac75572fb8f6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 374a7f47bf401441edff0a64465e61326bf70a82
Message-Id: <169164376083.10677.9868147352244358392.pr-tracker-bot@kernel.org>
Date:   Thu, 10 Aug 2023 05:02:40 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 9 Aug 2023 18:11:07 -0500:

> git://git.samba.org/ksmbd.git tags/6.5-rc5-ksmbd-server

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/374a7f47bf401441edff0a64465e61326bf70a82

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
