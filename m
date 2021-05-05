Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7296EC433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 20:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C9C613E9
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 20:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhEEUuN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 May 2021 16:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhEEUuM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 5 May 2021 16:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0373E613E3;
        Wed,  5 May 2021 20:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620247756;
        bh=gwueOB4fS/E03vmhMzzOPK+lr/eGjxj2vebkVQQMny8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sHOuahBCxGk5UzCefxZfh75JksYf+sL/ERHDmsRHO11V2AR3RSYkGc9IZPyMYVNC3
         plNOy63FCMaQPLRPsoklB1TnNQocsxoS7zFifaYF6A8WhCUoDiip8V9juXQCL2CwmB
         KfyNVZDgALWyz5/Mma6AeH62LNldH8p1WEPAT5jURCdUaONDk3pqmGi2H+IAsg4wFK
         kQK8PBNUSoNznAA0vojBqAWzGzmVwv1NIN6psXPnk7mmBGTKIQHqFZon459KKvcSCG
         jlRjSciWqH7EWC3D+YKSMQMDcxQ/ttzScDzFi0My5LK0s+uPkeYUxC6szOz0iegDcf
         9RbKhX9C/wqKQ==
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5muJhWfmbsz+T1adiAT0n5DSPfsMDVBWFEY=xb22ptzGiQ@mail.gmail.com>
References: <CAH2r5muJhWfmbsz+T1adiAT0n5DSPfsMDVBWFEY=xb22ptzGiQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5muJhWfmbsz+T1adiAT0n5DSPfsMDVBWFEY=xb22ptzGiQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part2
X-PR-Tracked-Commit-Id: bae4c0c1c2d576d32e37925ef972a5d45f34e36d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7c9e41e0ef7d44a0818a3beec30634f3f588a23d
Message-Id: <162024775598.12235.3628264606448962756.pr-tracker-bot@kernel.org>
Date:   Wed, 05 May 2021 20:49:15 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 5 May 2021 09:22:06 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.13-rc-smb3-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7c9e41e0ef7d44a0818a3beec30634f3f588a23d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
