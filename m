Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28882C32793
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 21:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352295AbiHSVOq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 17:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352299AbiHSVOo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 17:14:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083EBD399A;
        Fri, 19 Aug 2022 14:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 744C1B8291D;
        Fri, 19 Aug 2022 21:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35C57C433D6;
        Fri, 19 Aug 2022 21:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660943681;
        bh=YuFtBXqKqreyuBvRgWE4Zy6IXCdiZO53jnlUmpHUi14=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=L/KYz4rONEkYOqPGmZTcqu9IB6JBpyYWUqzmpUL1+E7bwWLvi6BpZRhs8Ywe4wY/x
         oyJx+KkHXxswy6xlgpN7k1LAseXwcuicvUpmIHMQeE/x6kLPNybUSmLSJn9nvBrPzz
         TxguQJSVSyTIh/Yp0fX72T3HG6i+Bj6ZQ7UUKLLocgy+vOF6lc5z+DT2R3YOLpcwu8
         1jj3vO/iGGJf0rkgGbi1x7jnFXdnU9ruCEY7ZQmqxlEuEnYKp5tL32g9yek9ffc5o1
         7DbYJNJErPjCVoNdwkSTX8/864g0Zg8GfQd82ArO4Eqht6QOmvoWy3CqA79f63bOM5
         3tZc9feC68Tmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24AA7C43142;
        Fri, 19 Aug 2022 21:14:41 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mso_xy2RpCcez+NuR91nCUkv7R6Dffs6yT32zjzymRz=w@mail.gmail.com>
References: <CAH2r5mso_xy2RpCcez+NuR91nCUkv7R6Dffs6yT32zjzymRz=w@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mso_xy2RpCcez+NuR91nCUkv7R6Dffs6yT32zjzymRz=w@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.20-rc2-ksmbd-smb3-server-fixes
X-PR-Tracked-Commit-Id: 17661ecf6a64eb11ae7f1108fe88686388b2acd5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3a78b6332ba8e1949541150efcc8051ceeb2762
Message-Id: <166094368114.15089.13668576699000821083.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Aug 2022 21:14:41 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 19 Aug 2022 00:03:49 -0500:

> git://git.samba.org/ksmbd.git tags/5.20-rc2-ksmbd-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3a78b6332ba8e1949541150efcc8051ceeb2762

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
