Return-Path: <SRS0=reoz=6K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D275C54FCB
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Apr 2020 19:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57D032071C
	for <linux-cifs@archiver.kernel.org>; Sun, 26 Apr 2020 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587928817;
	bh=C38MRgrqRkhkRmIOFj3RqZnYG1PIdyHwF/euHzdaVSo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=zF1c3JGmPGQZv/9duPF14nNWaLttR7NXXV9EB98NUDgrzFRuOrmfKEH1TVVrh3R2q
	 5JGZwY3tXGH4R6uBJ/iuyg3fjGRpITaozgHRsa4oxx2FdI8xhQ7+Y54EsAE6vXealm
	 xKXRr4Xomz3kgZFXffujvrX0k8BUiUqurt2AwRnY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgDZTUR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 26 Apr 2020 15:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbgDZTUQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 26 Apr 2020 15:20:16 -0400
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587928816;
        bh=C38MRgrqRkhkRmIOFj3RqZnYG1PIdyHwF/euHzdaVSo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DKuXF8toGVezbeLXzdjyZaEb4eVewf8N71e96VyoDymaMP7nTxWxffSh4lm2AHGXJ
         xx1hEyXoHuODFO9A6ZEEqtjb5Hb3YTLCWC82fKsg6/WMUJNZHvzaUDpUrZtHmb5JXf
         LQlgUAINmyoPq2jD97/HwtY5pe+NKKEUksLikCJQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvFb--OkoyHwPeML_CoRH=UfbFLRhUcoGBSKbLgok2VXg@mail.gmail.com>
References: <CAH2r5mvFb--OkoyHwPeML_CoRH=UfbFLRhUcoGBSKbLgok2VXg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvFb--OkoyHwPeML_CoRH=UfbFLRhUcoGBSKbLgok2VXg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.7-rc2-smb3-fixes
X-PR-Tracked-Commit-Id: 0fe0781f29dd8ab618999e6bda33c782ebbdb109
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d4fb4bfb37172dbe107aa6f093508fe80c73a46d
Message-Id: <158792881654.11395.10856286078229103394.pr-tracker-bot@kernel.org>
Date:   Sun, 26 Apr 2020 19:20:16 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 26 Apr 2020 09:23:51 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc2-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d4fb4bfb37172dbe107aa6f093508fe80c73a46d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
