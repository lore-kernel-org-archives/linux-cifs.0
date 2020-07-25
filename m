Return-Path: <SRS0=A+kX=BE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C354FC433E4
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Jul 2020 22:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C72C206C1
	for <linux-cifs@archiver.kernel.org>; Sat, 25 Jul 2020 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595716210;
	bh=/NjHQrw2DSxtORPlDdlH9dbJmmGdFhBePiVrPliOWw0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=aC/YoYPfyu4/ndt25qXBg3pNMSk/nCUUBkkQemibwSVj7hcWCWkYQisi++zdff4I2
	 uhb101bRJS+Hpuibv6ujs3giyOuR9lFk8MTNr8oDjuk1+ysnQxvJmv0xxrbYK34vna
	 xnIe8WwhaeyKCoyJ/ZJDUc/yiEt0OB4wSE3RwZ8g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbgGYWaH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 25 Jul 2020 18:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728253AbgGYWaH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 25 Jul 2020 18:30:07 -0400
Subject: Re: [GIT PULL] CIFS Fix
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595716206;
        bh=/NjHQrw2DSxtORPlDdlH9dbJmmGdFhBePiVrPliOWw0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DSeNEiKb28umHhmS1QYt0yc2Vl/kkqr3uZFj7muaV8qZe/yXLtBjrmUat0UwbpRcx
         pnlZ8DmIldLSsiSVMWEbw99Pi3/pW2zG2FMR1A92lTsaYYb7SNN1xhrWO8FBxOrcx6
         yz6zjcZQn4Mr5gNHipg3UUFOSM5E8I8aHe/IM4Qo=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mt_fhSnNDaCdn=DKE9_TkLMZQtCZ9hTTDVQmk5RL9PTbg@mail.gmail.com>
References: <CAH2r5mt_fhSnNDaCdn=DKE9_TkLMZQtCZ9hTTDVQmk5RL9PTbg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mt_fhSnNDaCdn=DKE9_TkLMZQtCZ9hTTDVQmk5RL9PTbg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.8-rc6-cifs-fix
X-PR-Tracked-Commit-Id: 0e6705182d4e1b77248a93470d6d7b3013d59b30
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7cb3a5c5f6478ac0c14d01e35bc49e0ba7525e21
Message-Id: <159571620684.7388.1800445024865272164.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Jul 2020 22:30:06 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 24 Jul 2020 21:38:36 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc6-cifs-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7cb3a5c5f6478ac0c14d01e35bc49e0ba7525e21

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
