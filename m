Return-Path: <SRS0=OUN2=XO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A29DC49ED7
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 21:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E602218AF
	for <linux-cifs@archiver.kernel.org>; Thu, 19 Sep 2019 21:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568928646;
	bh=n1mK2jjgqiaWYwtS2AwsF/5w6niLcDmVIzqUwRa6xDQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=jd9fGsWqfM0g08/BRad3I2mq87hk+5LZcJbVxCZntF/Y5yeKCGYaClW26qy0CPfzB
	 eXdl2f8TYHk6BsdgXZXGoU8HHVHQJsQvR8pE+cb23UmBaZa3/nr9qVLhmKWn/fvLji
	 MxWqbMqDQSNUCOC81X30x0d86HlWEYGje3BxRbCA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404891AbfISVan (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Sep 2019 17:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404856AbfISVae (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 19 Sep 2019 17:30:34 -0400
Subject: Re: [GIT PULL] SMB3 fixes and features
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568928633;
        bh=n1mK2jjgqiaWYwtS2AwsF/5w6niLcDmVIzqUwRa6xDQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oTQyEAAOqqIIuINC0Khqeztqjl74ouNV971y5sHVTv5+JQaw7AsodZHqBdATiXyod
         ITPEwJqvnOnNr6NZkhJZOex7f3RHASYIs1ZPGS3KBa6kcWYKMm9xOwyyUsk9TIEGcc
         NB8+xg1Pos58ABTdBwRFXmlrRMf8xK9R3daT9o8Y=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv2X00FCZy9PUVmhTuRtYb+gN-fHbWQQgtH=Vq+gH+O3A@mail.gmail.com>
References: <CAH2r5mv2X00FCZy9PUVmhTuRtYb+gN-fHbWQQgtH=Vq+gH+O3A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv2X00FCZy9PUVmhTuRtYb+gN-fHbWQQgtH=Vq+gH+O3A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.4-smb3-fixes
X-PR-Tracked-Commit-Id: 4d6bcba70aeb4a512ead9c9eaf9edc6bbab00b14
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7e3d2c8210e67ebff472a0b371bb0efb4236ef52
Message-Id: <156892863354.30913.6835427313806930344.pr-tracker-bot@kernel.org>
Date:   Thu, 19 Sep 2019 21:30:33 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 19 Sep 2019 12:07:25 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.4-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7e3d2c8210e67ebff472a0b371bb0efb4236ef52

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
