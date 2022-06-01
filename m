Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2028DC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Jun 2022 20:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiFAUpj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 16:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiFAUpR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 16:45:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA821203F7;
        Wed,  1 Jun 2022 13:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A011DB81C4B;
        Wed,  1 Jun 2022 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D86CC385A5;
        Wed,  1 Jun 2022 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654112083;
        bh=R/eV2ESj5TDDvndftPdRemnhTK/jSqQR+Fabf7jBK/E=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Xg7DmQUsEU4JP/Pt5W8H8j7WmzRjKP80FV3/b0IQWc9YMIFzKSUrOU4kLfEgv/eKj
         EMT8vkBis7Nov3rzv4yz4fizJRdBPCQE0rlmkHy0GXK/2PavlXnsRpnxlTlrCjmNig
         C6/xi8aRRftfF/RbP8DL8NFLFeuuUkwjiAUNOsc/SCYoKfGLgw0Kk5baCP/lbb5kAe
         O5Y6Mc2ihwLZMaslzHsMXNsP1YzXDUE5wiuwfLoiCktT62ouo7iMW6GbnR/nd8hwS7
         EEFVXslSSje+BFK5/zMLhe0FSgFBKK19F7pWw8rx2J2gm2lAz3Bbae/4vXbtW5/2bf
         yA+irNDhsYgJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B343F03944;
        Wed,  1 Jun 2022 19:34:43 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms4eeQy-2bu_5BxFAW=GUR7T4VWM9khi7F0Hc-RSb8Uew@mail.gmail.com>
References: <CAH2r5ms4eeQy-2bu_5BxFAW=GUR7T4VWM9khi7F0Hc-RSb8Uew@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms4eeQy-2bu_5BxFAW=GUR7T4VWM9khi7F0Hc-RSb8Uew@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.19-rc-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 621433b7e25d6d42e5f75bd8c4a62d6c7251511b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5b0208713326cdd3f0a83540e31f9b6f280da38
Message-Id: <165411208308.25874.13836131531452728780.pr-tracker-bot@kernel.org>
Date:   Wed, 01 Jun 2022 19:34:43 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 1 Jun 2022 01:20:28 -0500:

> git://git.samba.org/ksmbd.git tags/5.19-rc-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5b0208713326cdd3f0a83540e31f9b6f280da38

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
