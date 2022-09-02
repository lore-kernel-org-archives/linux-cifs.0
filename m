Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2433AECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 23:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiIBXsP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 19:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiIBXsO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 19:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083BE106DBF;
        Fri,  2 Sep 2022 16:48:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACE4B82E0E;
        Fri,  2 Sep 2022 23:48:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88851C433C1;
        Fri,  2 Sep 2022 23:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662162489;
        bh=/H7siXxAn3jQhcIWlQEl+1hwOO7kQAfI0CTcDiybsxg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=VcD/fASpCc+9o0RAMk2ovovxCKA7S7f2OWO7Fppvr3rjVpMj6aAixKLAuDQva9r0f
         yXQK96QHR8b8mnHBFVu4ABj271l/H9WSmZ86GjBsir0J186Pk43o0Q1cAYkedSeFdd
         O8IKGHHGFQc7EUdaQ41dAPe2WdtFhORH5SBNqDfSRjslmjOEUsJ67Toq2y4+ZvChfb
         kKPJtchxSBX1VM5d3zjxKWFd3ZzMwDGxeMDfkatdlwgcs8K9tFkQeA93VFcpllb8DZ
         zbK4XeBz/1dVKqQmyRByGholQdGZa0J4z71j1jfQcVzdS9kQvmO7Y77iXUC3YEMM+k
         jJqlA1npRlu6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77239E924E4;
        Fri,  2 Sep 2022 23:48:09 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt_+2zK_y3mdqkbQQ9YSK_2cvKzzLTGWjx7Jd0w55gNFQ@mail.gmail.com>
References: <CAH2r5mt_+2zK_y3mdqkbQQ9YSK_2cvKzzLTGWjx7Jd0w55gNFQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt_+2zK_y3mdqkbQQ9YSK_2cvKzzLTGWjx7Jd0w55gNFQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc3-smb3-client-fixes
X-PR-Tracked-Commit-Id: 27893dfc1285f80f80f46b3b8c95f5d15d2e66d0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1551f8f21e007e608fff00cf27caac8504283b43
Message-Id: <166216248948.12135.2705666265061404637.pr-tracker-bot@kernel.org>
Date:   Fri, 02 Sep 2022 23:48:09 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 1 Sep 2022 19:44:29 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.0-rc3-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1551f8f21e007e608fff00cf27caac8504283b43

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
