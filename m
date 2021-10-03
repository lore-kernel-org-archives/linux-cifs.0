Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F2BC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F932617E1
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 00:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbhJCAyd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 20:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234312AbhJCAyd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 20:54:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DCEE1617E1;
        Sun,  3 Oct 2021 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633222366;
        bh=KkldJ/GgFHlwi1ufc6bEIVU51AvyFvGPXVYtPaom1JE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=rX0uqb9XBFHCmxkKkL7KXRzWNdY2gm0jl7iaKIszFhcertRD51+9z44lPCLU1p9eE
         1VBo+1uow7J050vw11wB0/m9tRQVauxgNtHj6AwhHwafvAq8fk2Hu97AWvoyGXrBz4
         w93kIemN6nx3BZPNV3KeKU9z+S+zS9lKiixRX7nHlL1wJJWh8Fs8mk/bHGeo9biP9/
         JUd29r/tn8QfuBaVs3EVBSR1cWrbJ2RiJFc8iw25HmmOGaL2ImqI1Hx3eoYrpBJV43
         n14kFVtKMN48T8q0CSRgGecZG+pbgN6qd7GpULNHPIYLk0Ds2pBdncaiYKBfriZRok
         5eWXYSbrPHZYw==
Subject: Re: [GIT PULL] ksmbd server security fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muy3GtTQPoaVXiD_tU-cG4FAQk4SCmmiR8vS4_pWvPanw@mail.gmail.com>
References: <CAH2r5muy3GtTQPoaVXiD_tU-cG4FAQk4SCmmiR8vS4_pWvPanw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muy3GtTQPoaVXiD_tU-cG4FAQk4SCmmiR8vS4_pWvPanw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc3-ksmbd-fixes
X-PR-Tracked-Commit-Id: 87ffb310d5e8a441721a9d04dfa7c90cd9da3916
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e25ca045c32a0d787b143fef0acc5a43cc9ccc66
Message-Id: <163322236676.17155.15570923256805470867.pr-tracker-bot@kernel.org>
Date:   Sun, 03 Oct 2021 00:52:46 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 1 Oct 2021 23:14:41 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc3-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e25ca045c32a0d787b143fef0acc5a43cc9ccc66

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
