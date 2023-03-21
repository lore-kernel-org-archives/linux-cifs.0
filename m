Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9263AC6FD20
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Mar 2023 19:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCUTMr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Mar 2023 15:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCUTMp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Mar 2023 15:12:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20912570B3;
        Tue, 21 Mar 2023 12:12:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B517FB8197B;
        Tue, 21 Mar 2023 19:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73704C433A0;
        Tue, 21 Mar 2023 19:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679425926;
        bh=3oQnKbOQRcz+1a1mG3KN8MbM5OfK9jqbMpXvELJ/eWE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=D35ZgZ9+4kB2KhmgVMOC/L0qeExzqOyJ7gXm8aGbgBPDa5VA+rQ7+oW7XBrzpTpQQ
         3otgRIE183mYD2ly4pEihSIA2gMfSQ/StXLKQAC6kLPOkNp4koMoA0uH3sUf/O2ZFE
         whz+oiACRxJskrkvmtw65FxBxaQw/oZ65u9dZZQJMsy6dGWHHfmEHCZRcxrn+goYay
         7knCJTILIJQJFWTND+hNqUGhBfp2v5fUikGWY3lQH0MRDAvvZaWqdgjO3JPXzOq9kT
         Kvfral3XDQ0ADsTCyvR1Co+qVRw8lW2MZgb9T9HkLT/kT6e1YPZRbCtZoxE/FMXECp
         +Oe6ieVw4fyKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60B89E4F0DA;
        Tue, 21 Mar 2023 19:12:06 +0000 (UTC)
Subject: Re: [GIT PULL] keys: Miscellaneous fixes/changes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <2851036.1679417029@warthog.procyon.org.uk>
References: <2851036.1679417029@warthog.procyon.org.uk>
X-PR-Tracked-List-Id: <keyrings.vger.kernel.org>
X-PR-Tracked-Message-Id: <2851036.1679417029@warthog.procyon.org.uk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20230321
X-PR-Tracked-Commit-Id: 3584c1dbfffdabf8e3dc1dd25748bb38dd01cd43
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2faac9a98f010cf5b342fa89ac489c4586364e6e
Message-Id: <167942592638.7771.15271996800197050832.pr-tracker-bot@kernel.org>
Date:   Tue, 21 Mar 2023 19:12:06 +0000
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, dhowells@redhat.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Robbie Harwood <rharwood@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Tue, 21 Mar 2023 16:43:49 +0000:

> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-fixes-20230321

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2faac9a98f010cf5b342fa89ac489c4586364e6e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
