Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 100BEC433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 23:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E45E061139
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 23:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhKFXw5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Nov 2021 19:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231373AbhKFXw5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Nov 2021 19:52:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9585B61139;
        Sat,  6 Nov 2021 23:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636242615;
        bh=YBiFXar4FSiNFA+RpIefCLY61wuU9ZQzjfM2F2jlBR8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=cWSPAAbGUwXPcFFIkSHnLCLQlJtzELflltmS4ZaZSQVeFXwT6Fuf0Sta5RJoOVu0u
         WgxDVpABEm7wJDUsQiEZQaw1njvVhkj5JMcgBpw24ZavsP3Lq/719B6qjJgbkYXrO2
         lL2z3mI4uRLsKBbp3eSU0PZ95WKMzBg2O+UUw89PoAQ+ldcVrVnJFFSPUUUj+Lv218
         tVEZkT7OhFelGIoxuHvcmmeC5gl1rH/gZBF8luuc9m2vvhToyoitxymdUy0F4koJuu
         x7xfnCZZhF6QB1Dmz0fz49I/f1tXVXJP1/uCzQR0hYKn4YSWVsja8RKHPeZ/oC4kPo
         73bUKhSF+72KA==
Subject: Re: [GIT PULL] cifs/smb3 client fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mum6Fm=4jybfZ2fcvP9yBioXV4mi6TTjwnTZhasZLnRnQ@mail.gmail.com>
References: <CAH2r5mum6Fm=4jybfZ2fcvP9yBioXV4mi6TTjwnTZhasZLnRnQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mum6Fm=4jybfZ2fcvP9yBioXV4mi6TTjwnTZhasZLnRnQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part1-smb3-client-fixes
X-PR-Tracked-Commit-Id: d7171cd1acf70eb949ece8ccc95be27b3dfcf4da
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b5013d084e03e82ceeab4db8ae8ceeaebe76b0eb
Message-Id: <163624261541.31518.7762085719102833853.pr-tracker-bot@kernel.org>
Date:   Sat, 06 Nov 2021 23:50:15 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 6 Nov 2021 08:49:31 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.16-rc-part1-smb3-client-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b5013d084e03e82ceeab4db8ae8ceeaebe76b0eb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
