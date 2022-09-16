Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEAFC54EE9
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Sep 2022 14:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiIPOWF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 10:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiIPOVt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 10:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36DFB24A1
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 07:21:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A51362C2D
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 14:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0380C433D7;
        Fri, 16 Sep 2022 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663338107;
        bh=Gx3oiaNx2J8W1cHy7B1tz0WbRAgTfCT43hdP4lQ5NNk=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=e5J17Ouw/E14DS7T0VHbwN7NXFMGBIgWveK3Hzhb5OMkSYL2dOtcPTnHoPp2ODUrO
         OBddZZlFtjciqD3UgWxWL6i95ZTJX4Cz4jaYcOzg20U6q1g2wSIEVdzeqbHjv8QyQI
         gNoOt7zWyUMYVw7CSBltUjR6obM7fXlt50X2Ay+qrENBtHhdfLKVkF+hYPIkTozX+F
         bTKLthebVx10tnsRPPZai3Hi81+Mr/TGgeZ0/7lINRPB76iLVm3u6lePAQZY9ZC3nc
         Xn/XN3gXIpI7E82T7yr1AtXiCH6ypHBL7+uoqtQEJl/OSMQZqlwTk/GOAHiGaQkguP
         Wc3dmwzqJ1ZWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9F7DC73FE5;
        Fri, 16 Sep 2022 14:21:46 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms3vpm_h3NgzNkoOUCJM+jJYzifMCyZeCyBAtSbDLfXRA@mail.gmail.com>
References: <CAH2r5ms3vpm_h3NgzNkoOUCJM+jJYzifMCyZeCyBAtSbDLfXRA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms3vpm_h3NgzNkoOUCJM+jJYzifMCyZeCyBAtSbDLfXRA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: 8af8aed97bebe8b26a340da5236e277c3d84a8ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 714820c63914c7c4c1fd37fafdd2baa14cb605ec
Message-Id: <166333810688.10979.3879785890578381738.pr-tracker-bot@kernel.org>
Date:   Fri, 16 Sep 2022 14:21:46 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 16 Sep 2022 00:25:02 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/714820c63914c7c4c1fd37fafdd2baa14cb605ec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
