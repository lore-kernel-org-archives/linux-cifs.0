Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D4BC4361B
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 02:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C12C23BE3
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 02:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgLRCMi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 21:12:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732286AbgLRCMf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Dec 2020 21:12:35 -0500
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes and Improvements for 5.11-rc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608257515;
        bh=VrHjuIVeO1xLgLicxFmb80QEHw9GQv7JvBFwFVL8pt0=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=lLZS8cUEy137FsrgqmXCO2yv1xL6BrAeCqdKO2HGC+MJ6s3nGr1pshiEV9+7cI1Zh
         YnRnAfqjxYhLRjJBv2NA1QmhUdO7XOL/7KzDHszz+X5sH6vAlxk1pGjbbw1wWEm5tZ
         uw6aNA7KBemoVQ6DErb+pp7yCCRDSlJvNmBJbLhep9cjWfQ4uVMUu5By76jot8lFFE
         wpf4PmXP7OICiFC/wYvPp/M32NUVuo1BNiFSMQcKZv76P20mjgoCZfb+BN5lniEteU
         q13XC0SjafQVyc8c+rhR+obVsHm5M4zysyqTC5D3Vw1TRkCVQu72J1tU3UMie3tTpn
         yJZ4ZeRkNWWQg==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtnwFY4dYMzOij1ZhkQVaF+d9sGcwV3Vx2VywMsVaahQA@mail.gmail.com>
References: <CAH2r5mtnwFY4dYMzOij1ZhkQVaF+d9sGcwV3Vx2VywMsVaahQA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtnwFY4dYMzOij1ZhkQVaF+d9sGcwV3Vx2VywMsVaahQA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc-smb3
X-PR-Tracked-Commit-Id: afee4410bc6c50e1422c5a45d633ad0e478ea960
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e13300bdaa68f5487000e66baed1ff69bcb510bf
Message-Id: <160825751544.20122.125736420792536798.pr-tracker-bot@kernel.org>
Date:   Fri, 18 Dec 2020 02:11:55 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 17 Dec 2020 19:05:32 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc-smb3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e13300bdaa68f5487000e66baed1ff69bcb510bf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
