Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C88EB64DC
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Jul 2023 05:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjGAFFV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Jul 2023 01:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjGAFFI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Jul 2023 01:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8125A44B7;
        Fri, 30 Jun 2023 22:04:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1631060F31;
        Sat,  1 Jul 2023 05:04:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E0DFC433C7;
        Sat,  1 Jul 2023 05:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688187898;
        bh=4LWOhASE8+HGVu8i8O4N4EliCDL8lrFffN6puZLpAxs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jla41Fk6USFMFMOAxpL68YvBg8s48uB7181Pk3pwDdwe0gIg8f2qMR8B9e4LzuQqF
         EP9jFuokOPclCJ7ciVrFmrh7t99p8fPdJ21usaUVcVNA8BmFggMqFWfK4bZAwAh2o8
         bl2gBcVKmx3elXjdt6D43/HfxPIFKsuLEpVOqEL3BOnzKVkzW8zdS7QBYxt+og+VbK
         DpK6C+bW3/ooU/wxBwNGv3FgCMLm/i+qUf+A73nOGv7TcV10yZwhBZGYaM4VVW/u3k
         GUk85r95nfqqxlGtkom8lOKZmgA3pCLEoO1pEQ1uiFGuPhIQ3vUfPqXfJDnZUp05Qz
         wLKLf+51AaK5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68EBAE5381B;
        Sat,  1 Jul 2023 05:04:58 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msFa0AjapQV_+bPf+upCNnCxppVgqkcDQP9GTh8o5bgdw@mail.gmail.com>
References: <CAH2r5msFa0AjapQV_+bPf+upCNnCxppVgqkcDQP9GTh8o5bgdw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msFa0AjapQV_+bPf+upCNnCxppVgqkcDQP9GTh8o5bgdw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc-smb3-client-fixes-part1
X-PR-Tracked-Commit-Id: 61986a58bc6abbb1aea26e52bd269f49e5bacf19
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a507db1d8fdc39802415e4d2ef6d1aecd67927fa
Message-Id: <168818789842.30776.10169180339933392249.pr-tracker-bot@kernel.org>
Date:   Sat, 01 Jul 2023 05:04:58 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 30 Jun 2023 23:20:39 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.5-rc-smb3-client-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a507db1d8fdc39802415e4d2ef6d1aecd67927fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
