Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEB6C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 23:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FBC660F56
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 23:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240695AbhITXfh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 19:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239085AbhITXdg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 20 Sep 2021 19:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 587C26121D;
        Mon, 20 Sep 2021 23:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632180729;
        bh=9K7VkBoxjMkVaL8LnX1YocrReLW+mb0ycx3R9hIYoVw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OPDyYpuKv4Ir5ZXZVvgh/ffvkvneQQsWkle1mFSFXaE/NHe4hOUaauWfcLCyZHpj9
         giiehE1bjlJAKLEPSWzuPjjHQLaJ0SSBj/BsK2hOizQE2yOrvwL7e9laQhVv6uRhGG
         AclQm8bJKAbNmezWfwajwE+0givKM8K43VSYtcM4TWK2Mp3nEH0M5SRuCJHeCLuNNs
         GHrrh1PDclGUNq5DoTt5ZVvul3ZgRdzlTvXtaDw5CppSzCiQx2YBldbMuRBn0GOYHz
         g4QGT0xx2XtaeJB/lJQaPcc6chvjoTtd2BOfMwL9EujXl3f19DB0LF65ahL6E7CJ5+
         emUGqaZhPSJFA==
Subject: Re: [GIT PULL] ksmbd server security fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
References: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvu5wTcgoR-EeXLcoZOvhEiMR0Lfmwt6gd1J1wvtTLDHA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.15-rc1-ksmbd
X-PR-Tracked-Commit-Id: 6d56262c3d224699b29b9bb6b4ace8bab7d692c2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 707a63e9a9dd55432d47bf40457d4a3413888dcc
Message-Id: <163218072933.25470.7744855585761498313.pr-tracker-bot@kernel.org>
Date:   Mon, 20 Sep 2021 23:32:09 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 19 Sep 2021 09:22:31 -0500:

> git://git.samba.org/ksmbd.git tags/5.15-rc1-ksmbd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/707a63e9a9dd55432d47bf40457d4a3413888dcc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
