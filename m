Return-Path: <SRS0=C+hr=67=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAB0C433E0
	for <linux-cifs@archiver.kernel.org>; Sun, 17 May 2020 04:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281092067D
	for <linux-cifs@archiver.kernel.org>; Sun, 17 May 2020 04:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589690706;
	bh=ttZOMs5Oa9OIrdHh0/i9OPv396ks8JP/KwniQOvVbdQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=VOUXd2+HTrmdRboQv2N15z9HUqcHr/+IMy9PY30iV4OECWP1vGQrASJI8gMW4mGq2
	 +CoW1V6XGyG2o1WY2aixg7t+EI0nxH9z75zsfRMTRpYXSIKXGBLWln/GrnvqiBOiDD
	 EzFlv07CM6guTz8sl9XWp3oCwj3aun8og7Z6ojHk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgEQEpF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 May 2020 00:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:38680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgEQEpE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 17 May 2020 00:45:04 -0400
Subject: Re: [GIT PULL] CIFS Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589690704;
        bh=ttZOMs5Oa9OIrdHh0/i9OPv396ks8JP/KwniQOvVbdQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=JJWpBsbze2/RRRZw/hXd6RgxwL/D8QO9CuxQVKrwBMmd6uJ/ExPWM6A1+jahGDfsR
         ++ha4MOjQ9J7IaR34lZ5ANV/bV1DKIJzsgWmAn0SltZIy+pQ3oOgRCE3i7395XIxTr
         oODOPb34bVBa+xXjdLpRVYGQNqKGFNHLE6LgTa3M=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtJLcARTXSEjNjWnDacyr4MEcJk6TxZCu2mFy-_38uQng@mail.gmail.com>
References: <CAH2r5mtJLcARTXSEjNjWnDacyr4MEcJk6TxZCu2mFy-_38uQng@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtJLcARTXSEjNjWnDacyr4MEcJk6TxZCu2mFy-_38uQng@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.7-rc5-smb3-fixes
X-PR-Tracked-Commit-Id: a48137996063d22ffba77e077425f49873856ca5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5a9ffb954a3933d7867f4341684a23e008d6839b
Message-Id: <158969070438.26561.12889104890106664496.pr-tracker-bot@kernel.org>
Date:   Sun, 17 May 2020 04:45:04 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 16 May 2020 21:45:57 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc5-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5a9ffb954a3933d7867f4341684a23e008d6839b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
