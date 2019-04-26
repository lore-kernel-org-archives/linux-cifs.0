Return-Path: <SRS0=UR+C=S4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA71C43219
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BEEA20679
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Apr 2019 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556297414;
	bh=hOelocWnR51tLRtqJvkZMcF9Mx6VTZ9xVokW9xTEFks=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Y/OVQ954V4cV5JnA570yIwMaJiXeRhTN/F5YjgF/IV6RHREG8eBjfjTjWE/EZJko7
	 ymmFWxWBmrRsgIF8zSBqb1kKwksEKegdDe8Mn+1Y67En+tbod5CzKcOrC1ZVjblCnm
	 haB6Z7j+8ej2Hw0ALVdcHRmZSQmmlvLOXaouQ6as=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfDZQuE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfDZQuE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Apr 2019 12:50:04 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556297403;
        bh=hOelocWnR51tLRtqJvkZMcF9Mx6VTZ9xVokW9xTEFks=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=FLIebNgvkBgNPn29OQFk7DtchHS9ghXccCazVGSnKD09M1tLAQa6X0Dzdc0eqiYQt
         3CxKYhAYs8GsvOvXw1v72GUxQlaLawQE73kOX2HrYatqoizNElcx+lEJFsiULeX6vL
         v+uOPMhXOigLiMGyUn+SQnEnHEvyMb6yb0dhHUio=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv8tvPpdbwJCrUeumxUG5G9QGm2j9zn-gWbU2bc3qS=WQ@mail.gmail.com>
References: <CAH2r5mv8tvPpdbwJCrUeumxUG5G9QGm2j9zn-gWbU2bc3qS=WQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv8tvPpdbwJCrUeumxUG5G9QGm2j9zn-gWbU2bc3qS=WQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.1-rc6-smb3-fixes
X-PR-Tracked-Commit-Id: 13f5938d8264b5501368523c4513ff26608a33e8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 58130235bfcceb9198a3d979c91b04ea383a0fae
Message-Id: <155629740380.7104.14864053840962838346.pr-tracker-bot@kernel.org>
Date:   Fri, 26 Apr 2019 16:50:03 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 25 Apr 2019 19:23:40 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc6-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/58130235bfcceb9198a3d979c91b04ea383a0fae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
