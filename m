Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C65C433E1
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C2746197F
	for <linux-cifs@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbhC1TLo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhC1TL2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4B746197E;
        Sun, 28 Mar 2021 19:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616958687;
        bh=y5F8QdL70s1Ws4URk3FtPtmVklf6LfvOctsF4HLWVvc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=npYYy7GXV4M78Ybe0cV50p+SBV3uBoB974L7+5U3xeA1SeEHM4kBREH7CnPpf9reg
         Vd0ia6klOAqTp4jS8TWxLFq4oBZcipHJAZlfavcp5avCpc2Xp4mCfwVnJKJCb3x2Zp
         Im26HVCqgqZn8ybQyTGmORYaA163qDmgmZLjFXDFXUEETJai6l6ry9XfuxMI1ned75
         3dywJBbyqumbH4LCdFR+Ml3prVw9py5MTkkOp8+rQymrCi+hL+7DHaXVJN9xArYn3T
         o9gCtM2CHQEudc2JhzBwR4wcUgGJVwd8qxfFjnZm1GF6QCNuLUHBWCz7pFgA2FNFJe
         ZBjw1wekajv6g==
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muJ0vRicetgiFOaMecoqGYZw7p+LAEYSs5OLADyzewFiw@mail.gmail.com>
References: <CAH2r5muJ0vRicetgiFOaMecoqGYZw7p+LAEYSs5OLADyzewFiw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muJ0vRicetgiFOaMecoqGYZw7p+LAEYSs5OLADyzewFiw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc4-smb3
X-PR-Tracked-Commit-Id: cfc63fc8126a93cbf95379bc4cad79a7b15b6ece
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 81b1d39fd39a0ecfd30606714bcc05da586044f9
Message-Id: <161695868777.24587.13257578771587511987.pr-tracker-bot@kernel.org>
Date:   Sun, 28 Mar 2021 19:11:27 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 27 Mar 2021 19:07:10 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.12-rc4-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/81b1d39fd39a0ecfd30606714bcc05da586044f9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
