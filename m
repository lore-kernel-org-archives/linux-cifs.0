Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48980C5DF9D
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EECF0208B6
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603479197;
	bh=6lqSSzbEk+bhoPnQ4k8IQCejb9vH63qm6+qYKe5nywQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=GxdutpsOdzvmDT3ZFAiugtiEaL0Gyy0IW2HcKGAkORmKOr0jjinGjvcJNGZjXOCez
	 2XoggNQz3giMbTOFzhUzmrLi39vo4Gge0J/qQjeEChr2nFjgTPOC9gYxkJqV/eKV3p
	 V9aW/jnjRLfd5oTsO2Ox+cru4nzt3vVPh6uWoCwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755122AbgJWSxQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 14:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751093AbgJWSxL (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 23 Oct 2020 14:53:11 -0400
Subject: Re: [GIT PULL] cifs/smb3 fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603479190;
        bh=6lqSSzbEk+bhoPnQ4k8IQCejb9vH63qm6+qYKe5nywQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=At6qeCR2KLBp5H3KK9lXaN1lt0Yav2U4cr2IsOholDdHpMAMl7CHuBJPCd7YA3Yu7
         ezCnuJ0MpIvil2RSLaDSXI6VFGL0/a+YfRwl2VKU3KgYjm+QK+N7S9vJIf1XknIJOm
         xKfZFtvycpEfA9IvEq0tauSfQSLZCHUV9BTIYB3k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
References: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvcYcC19PN4aNXjkDyPsAQ8wgnK-p2ikvhm_zVfTHsF+A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc-smb3-fixes-part1
X-PR-Tracked-Commit-Id: 13909d96c84afd409bf11aa6c8fbcb1efacb12eb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0613ed91901b5f87afcd28b4560fb0aa37a0db13
Message-Id: <160347919068.2166.4979983065641285958.pr-tracker-bot@kernel.org>
Date:   Fri, 23 Oct 2020 18:53:10 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 23 Oct 2020 00:09:01 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.10-rc-smb3-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0613ed91901b5f87afcd28b4560fb0aa37a0db13

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
