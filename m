Return-Path: <SRS0=TF3n=VP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F58C76195
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C9922184E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Jul 2019 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563474623;
	bh=pmd53rOtUgsFpxoHIYQStrd3C0m/GR5h+29yHAh/Cwk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=sUsdOqrU7U6PQSPL19kwNDpWNCvS3Q80ObzxOXz9sUIk+Etr5uFIH2qsgZxet/ljI
	 Sl6HXh24N1g8QJ6DjwoQIieOSr+xz9LXnjKRfSfxmlUlOdPfo9ttnRNldnyXnYEvMA
	 +dt2sWd3bA+6RJuptR2xNqLFcaDNebReXWKLvS4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391236AbfGRSaW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Jul 2019 14:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391228AbfGRSaW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 18 Jul 2019 14:30:22 -0400
Subject: Re: [GIT PULL] CIFS/SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563474621;
        bh=pmd53rOtUgsFpxoHIYQStrd3C0m/GR5h+29yHAh/Cwk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=BLEP4Z71G9uxidZH/s6DJC14ZDnsCMGdEOUfD/RdlxePODI2TfpisUveQx0RZSGup
         Mc43JjXBehZt2953DqP8CuEp14zcQz9nNfAxIT5xA1+JAqEQHb0IHRMykHQuNE/Y5s
         oJGjRIBnbPYNdHRhRKGMMIUVSaWKIg4TqYSJ03C8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms6cYqfZvjwJ4m=U4bWktxERb6uz8-RSOaf7B9rzdUg6g@mail.gmail.com>
References: <CAH2r5ms6cYqfZvjwJ4m=U4bWktxERb6uz8-RSOaf7B9rzdUg6g@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms6cYqfZvjwJ4m=U4bWktxERb6uz8-RSOaf7B9rzdUg6g@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/4.3-rc-smb3-fixes
X-PR-Tracked-Commit-Id: e9630660bd9253b3ed3926e18278b740cf218365
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ae9b728c8dc0a9939d89f84e8603258ca2a0df22
Message-Id: <156347462168.12683.15157139278148479332.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Jul 2019 18:30:21 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 18 Jul 2019 01:10:02 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/4.3-rc-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ae9b728c8dc0a9939d89f84e8603258ca2a0df22

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
