Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B600C77B7E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Jun 2023 21:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjFAVP3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Jun 2023 17:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbjFAVP3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Jun 2023 17:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295D8128;
        Thu,  1 Jun 2023 14:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA1DB63C9A;
        Thu,  1 Jun 2023 21:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E643C433EF;
        Thu,  1 Jun 2023 21:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685654127;
        bh=sPHH42zQhcbv5wXnR8Qim6l9rFXcjPPAWrLXLszXZ7o=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bXCima/wsZrldEt/rnz5tj7NCgCHgXSl8AEGFWFyQQ80F+serBCRlqXHUiApkfinn
         jAtcp+SSrYGBuZnStTZEeeYdVQNAukKZsbL2TC8jgWbsW2J4uyoE6XMtI/m0Z63bSo
         o9WJattCs0wiUYvI+VqhowxugDpvxs/YKHLn/Tidd4Z30N2KeEG9/RS1iSJuKBgK3Q
         J6DjYGCOO7BgmRDS34PXT8ZqZROPwBsev3geRzpVMf9XbfPRxntaA8wkJE5ItUDDzy
         SkqrJwZCEmnSkUPR271q3Fa3EaK3kNxMy61SFhM37MBGZiKOLiiXLxEFKiFOwG55yN
         NtNClDLWqxbqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D0D8C395E0;
        Thu,  1 Jun 2023 21:15:27 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms4QAu6Kets9riO5CN6d-4wOaGoawoyadL0EviKdf-9Bw@mail.gmail.com>
References: <CAH2r5ms4QAu6Kets9riO5CN6d-4wOaGoawoyadL0EviKdf-9Bw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms4QAu6Kets9riO5CN6d-4wOaGoawoyadL0EviKdf-9Bw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.4-rc4-smb3-server-fixes
X-PR-Tracked-Commit-Id: 6fe55c2799bc29624770c26f98ba7b06214f43e0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8828003759391029fc45c15ac346622cdae19b6d
Message-Id: <168565412704.3839.4682678458042277340.pr-tracker-bot@kernel.org>
Date:   Thu, 01 Jun 2023 21:15:27 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 1 Jun 2023 02:17:46 -0500:

> git://git.samba.org/ksmbd.git tags/6.4-rc4-smb3-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8828003759391029fc45c15ac346622cdae19b6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
