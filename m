Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13457EB64D9
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Jun 2023 23:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbjFOXKU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Jun 2023 19:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237326AbjFOXKS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Jun 2023 19:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1052972;
        Thu, 15 Jun 2023 16:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DFD760B4C;
        Thu, 15 Jun 2023 23:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B093C433C8;
        Thu, 15 Jun 2023 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686870613;
        bh=gUCosOlwBhLXkjfvtNnaPBXTtevVDuqaR314WQMK8Yg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=MOwq8M8mPBrP2lmsvJeAJwNsHilTkEnhJVGsMhoFkoQUTNaetbI7N4SWCyxlZP3Dh
         ISEOVqQ77n56jErzlnrkFDUm+9bw34W2YWLG1hwOqT5SytNpq/hlaJUrvmGTScsYiM
         xYGq6hQsLxbSYVfTX0uQiB9BFEOaiYdiuz4JpEP7qED3OU311/ZFHfDnCAezXfR7ed
         tFvxMrqB1rVk6nut5g3WOkc5bysRb/PUYxIRQ96R08Oq+r0qGcup7vWOxPA3dFHuCd
         B5TE68xccmf5eYljdrcrF8UbOTzVhnoXXp/MyvgBJXP4pwppiFp7r1r0P+kTTQ3gxT
         U9rbygKNH8TmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74F99C395E0;
        Thu, 15 Jun 2023 23:10:13 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5msGxr_kjUC=2GmALVuktLqhUtuVtRm6f=3fFPvAPH+OaA@mail.gmail.com>
References: <CAH2r5msGxr_kjUC=2GmALVuktLqhUtuVtRm6f=3fFPvAPH+OaA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5msGxr_kjUC=2GmALVuktLqhUtuVtRm6f=3fFPvAPH+OaA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.4-rc6-smb3-client-fixes
X-PR-Tracked-Commit-Id: e4645cc2f1e2d6f268bb8dcfac40997c52432aed
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a043feb6cc02c9273c34392c41d17e08804a323
Message-Id: <168687061346.8077.7452119781637217249.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Jun 2023 23:10:13 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 14 Jun 2023 23:36:08 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.4-rc6-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a043feb6cc02c9273c34392c41d17e08804a323

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
