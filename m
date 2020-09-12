Return-Path: <SRS0=nPt4=CV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18364C433E2
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Sep 2020 20:01:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56F22151B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Sep 2020 20:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599940911;
	bh=h/1KOfd2TqTSi//lfIGGOxG+zaYP8F/XCxqYsvdAa5k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=P+x5oGJPSP4KwyawmPaKJ2c6D9G1/fEAZxokOVE/qLjSauiOncqzEuffipJ6ZbAoj
	 8iFvkEbZaxX7ECZmW4b5MlL9p80ETsAq/dD9Egw0/VHUwrazS5/wWnq0z56oHaTMIw
	 fxgSu9cNrg7/+fWYx9do+WUgJLxJ65qXduwDNPkg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgILUA0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Sep 2020 16:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgILUAX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 12 Sep 2020 16:00:23 -0400
Subject: Re: [GIT PULL] SMB3 DFS Fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599940822;
        bh=h/1KOfd2TqTSi//lfIGGOxG+zaYP8F/XCxqYsvdAa5k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=xbSuZmJQsX8ZDCZpleN2blbI5WxrzExHG0HXfD4bxm2b/T5d5sPMnWkFQurrnEv60
         JsVYDUc9aHAsBhZM7C6C1RArcGoQoyDo6DVDB6FZ4FFVYupU4FSEHFuMzIh5VCxFgc
         /vHP/kco7rX/MyNOLyq1NlEPqF8zw6XnVB5yY5NY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtri0syQbck4DG0o1t9Ri8vHmb_q3PUg0nca7nHbnLTQg@mail.gmail.com>
References: <CAH2r5mtri0syQbck4DG0o1t9Ri8vHmb_q3PUg0nca7nHbnLTQg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtri0syQbck4DG0o1t9Ri8vHmb_q3PUg0nca7nHbnLTQg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc4-smb3-fix
X-PR-Tracked-Commit-Id: 01ec372cef1e5afa4ab843bbaf88a6fcb64dc14c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a3c558a9f05f4664f569b06f04d6b217785fd21
Message-Id: <159994082277.28783.4514566928537891429.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Sep 2020 20:00:22 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 12 Sep 2020 11:56:45 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc4-smb3-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a3c558a9f05f4664f569b06f04d6b217785fd21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
