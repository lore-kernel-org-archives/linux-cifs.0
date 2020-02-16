Return-Path: <SRS0=zJQV=4E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7E3C7619B
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Feb 2020 19:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8FE420857
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Feb 2020 19:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581882629;
	bh=sB/vufOEvmQ45ty5tmh+DsYCIhFHuK0fdMMza9D3je4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=nyYRyVgEyLTjB7Gjp2RZeYMSs1tjeWA7/vmHA6Uk5i8sHTQpcF8PvG4+Y4lHhBayK
	 hHBpOG98P+LSkNrpNSW5FlXbOL2Hz2WD5rWLR9vGEDC0ePk9NClKkx0NM/6rv4sNZA
	 ayi6olV43hJ5fLsobI3m8XWcAjvwlaYiXYG6N+mI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgBPTuU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Feb 2020 14:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:45718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbgBPTuT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 16 Feb 2020 14:50:19 -0500
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581882619;
        bh=sB/vufOEvmQ45ty5tmh+DsYCIhFHuK0fdMMza9D3je4=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=J+SloLGG765Mit5Ykk0z/5+byFPRiGJPNt3g1CQ8T3f9NTxWJzbgZyhrqdCjt3uA6
         KUs4wVQ+sk4Gtz9vWxLEaGSFcJaasO4QElBXD8vWd9uD8BbAejcK1fG9Vnk4y1ghyQ
         qsf5FlhgHdB1eQDMvzoj0YMOzuh6a6GdgHp2mUZI=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt=_P2tUC6H+bmFL-FAyKYQuvim2fYqa27gMdJj3882=g@mail.gmail.com>
References: <CAH2r5mt=_P2tUC6H+bmFL-FAyKYQuvim2fYqa27gMdJj3882=g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt=_P2tUC6H+bmFL-FAyKYQuvim2fYqa27gMdJj3882=g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.6-rc1-smb3-fixes
X-PR-Tracked-Commit-Id: 85db6b7ae65f33be4bb44f1c28261a3faa126437
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 288b27a06e4f8f7bad63792cf015c160ae578d89
Message-Id: <158188261896.7458.9742510133908572108.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Feb 2020 19:50:18 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 15 Feb 2020 20:58:53 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc1-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/288b27a06e4f8f7bad63792cf015c160ae578d89

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
