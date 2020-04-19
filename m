Return-Path: <SRS0=VDKF=6D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B07C54F70
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Apr 2020 19:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4FED21927
	for <linux-cifs@archiver.kernel.org>; Sun, 19 Apr 2020 19:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587324047;
	bh=D6zShpD0FIYFQaLEfYU5y9AOEA/E6ZxdfPij8D8SSv8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=O2IMUa1a6es3ha/3yp8nlpCXFf4QXYCL6fkQO1JL5/KpNJC8bzvHrFlwp27YNBegz
	 ItcYPblUvBIwBb8eWFaiwkn41OtLwp5O/yKgwYmSMTtCJdsJftrib3FEMRRLAvwUKM
	 MAogpohmdULnZhM2Q0m290YRyWL4vu++VOdJe+oo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgDSTUn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Apr 2020 15:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgDSTUW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 19 Apr 2020 15:20:22 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587324021;
        bh=D6zShpD0FIYFQaLEfYU5y9AOEA/E6ZxdfPij8D8SSv8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vhgtT++Jt0lcodK3RDktwKS7H5gG/XVsesc67corWINbDqinvF4QOU7xdXtfVnH+1
         f281qM9y8Db7Oe1Qydb5DjOkpG0hFmYaMsuK8RVHSP6IQwZFwd+2NfBT8l44jzk3Cp
         r5nS81F16Jztx0DvJGHfjAoS9scmrJt30gPQOblY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mu13W-JJoTRnoDTBnPTRjOLRqbDdTeK6NfrfAFS7f+Rbw@mail.gmail.com>
References: <CAH2r5mu13W-JJoTRnoDTBnPTRjOLRqbDdTeK6NfrfAFS7f+Rbw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mu13W-JJoTRnoDTBnPTRjOLRqbDdTeK6NfrfAFS7f+Rbw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.7-rc-smb3-fixes
X-PR-Tracked-Commit-Id: 9692ea9d3288a201df762868a52552b2e07e1c55
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aee0314bc330b9913ca99b7d358531905e4bf09f
Message-Id: <158732402191.20624.9236381213362901571.pr-tracker-bot@kernel.org>
Date:   Sun, 19 Apr 2020 19:20:21 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sun, 19 Apr 2020 07:50:06 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.7-rc-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aee0314bc330b9913ca99b7d358531905e4bf09f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
