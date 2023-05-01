Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A013DC77B73
	for <linux-cifs@archiver.kernel.org>; Mon,  1 May 2023 19:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbjEAT10 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 May 2023 15:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjEAT1Q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 May 2023 15:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837B8213E;
        Mon,  1 May 2023 12:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EBF161EDB;
        Mon,  1 May 2023 19:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FB01C4339B;
        Mon,  1 May 2023 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682969162;
        bh=WANaJ6hpamRufnLdA+BwZiyH5ZDt0NbEy/LY9fBR0eg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=I2y6IndckdEVkDRh7eM4QmNZkEFe57upmyNpH6lx2s7tyX7KVKbDkE6VOED8aRpkM
         IYRRsLcib8XruxfapBJAGSTy8MIj4/dvVNNCzIvfufiz6QGLnwYsSSjKg8fQoaQK/L
         WqtfFCcdCHUEUJH8FPTJ0NYhhFmhr1ZoYdupIWmzCdlypBLFEabPJhPDE4i9HDCc0k
         g7JTWXA0cJV7oX0LKJs7IGGXS/gnr3PkKlqMX3SCZXeDHRYjyup1uddZ7iW/ufMxov
         VFSToyJXyyIzmdtJBoZICP8U4O7PXVJiMHCy99d4jQBAbO5aYCh5xCXIciKyLU6lQa
         fu9WneHARMStg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DFD0C395FD;
        Mon,  1 May 2023 19:26:02 +0000 (UTC)
Subject: Re: [GIT PULL] smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtWYqepZSYBvSbC5AHiJv70ETtNobBbSH1Oc2K=2qO6UA@mail.gmail.com>
References: <CAH2r5mtWYqepZSYBvSbC5AHiJv70ETtNobBbSH1Oc2K=2qO6UA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtWYqepZSYBvSbC5AHiJv70ETtNobBbSH1Oc2K=2qO6UA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/6.4-rc-smb3-client-fixes-part1
X-PR-Tracked-Commit-Id: 9be11a69315e26363a4de8930bc50d0901a96775
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 26c009dffca89b0f8fe7facc41d1ccf88a66825a
Message-Id: <168296916244.17937.15989336939630290745.pr-tracker-bot@kernel.org>
Date:   Mon, 01 May 2023 19:26:02 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 30 Apr 2023 10:35:04 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/6.4-rc-smb3-client-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/26c009dffca89b0f8fe7facc41d1ccf88a66825a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
