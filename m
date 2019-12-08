Return-Path: <SRS0=hgbo=Z6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C45D0C43603
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Dec 2019 21:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 925A2206D6
	for <linux-cifs@archiver.kernel.org>; Sun,  8 Dec 2019 21:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575841241;
	bh=Y2/+nRGil84kB1YAUg4GuMY135VpMF2/SHRBNBk3S98=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Hgt1dyxR2y+tG73+bxl9fU/E0bvDA3JW2lKQ1YSHs/vYv7pgiHuqt2Kfw+HjGnUJA
	 ba6GhXbD2PAaY2eabPqXWNWSy11/oumU/O2pmoCSiTl0YpIPqB2E8XdjLYOBGi6DBY
	 A/ocn4QIgFKhiMVKKhVxl1/yP9eEhXTBue5htlGE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLHVka (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 8 Dec 2019 16:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726975AbfLHVk3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 8 Dec 2019 16:40:29 -0500
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575841229;
        bh=Y2/+nRGil84kB1YAUg4GuMY135VpMF2/SHRBNBk3S98=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Y082qrptHZD0E7/ifr4VqTTP+mAuDh6J/p/7eiFyT3U05ed7XSQh+g027FQ9udIJu
         rcmdYuzT0iFziELLrnUK0D/zXwNH11h0+ZFr4kLyic2du9DOlfhG7PcZV11WRjFepa
         e4whye4doFlQZ2pXSunsGXZFtMrhNAM5OvzBW0rk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvexWusg28E6jn7C-=_TFnnZC-MJB1JUh6zFqyapkPv8Q@mail.gmail.com>
References: <CAH2r5mvexWusg28E6jn7C-=_TFnnZC-MJB1JUh6zFqyapkPv8Q@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvexWusg28E6jn7C-=_TFnnZC-MJB1JUh6zFqyapkPv8Q@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.5-rc-smb3-fixes-part2
X-PR-Tracked-Commit-Id: 231e2a0ba56733c95cb77d8920e76502b2134e72
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a78f7cdddbbb2bb2ed6851fbb792072570517650
Message-Id: <157584122926.22418.7130546428545261488.pr-tracker-bot@kernel.org>
Date:   Sun, 08 Dec 2019 21:40:29 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 7 Dec 2019 23:41:06 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc-smb3-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a78f7cdddbbb2bb2ed6851fbb792072570517650

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
