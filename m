Return-Path: <SRS0=ajoR=B2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8D4C433E1
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Aug 2020 01:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3DC20708
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Aug 2020 01:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597542951;
	bh=YFjlVCSFrDWnukoa1z63WpLlIwzU7Gc1rPIUVGZ6Mcc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=G8W7EQxH3IGcNVKk+1zp1JupSZMykUSwwnEsSluLY6UphNnjSHYKOTx7KAM1w2Snt
	 otWVEGM5jW2rX0cQe4xjrP+WmaH1oDcnNBdcjoborvlTnXXg+up1DQItO+L0qWG5gQ
	 UC9pFIBbKNf6OBlXjqE12GKcAkeFhFOR1N9oAEII=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729754AbgHPBzi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 15 Aug 2020 21:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgHPBzf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 15 Aug 2020 21:55:35 -0400
Subject: Re: [GIT PULL] SMB3 fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597542935;
        bh=YFjlVCSFrDWnukoa1z63WpLlIwzU7Gc1rPIUVGZ6Mcc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=bfsTkii5uta6jZ/JY2L2DBR11Nucgp7MWIrNr/167YtHKPbxdtuc85YUuKgrx1ArQ
         FItGxGkWzYv8xZq7OJcvB2E5qYZLaypHFajiUKSdyEFlXnn1THuHwCR8voRbM+07ME
         KThGnbNUBnoiTTwitRiCHXSYVlbyAM6xFFnPxfLc=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvJ=EZ2mC6LTnTmML5tCKpcKCOM7+nbbFSzpATBWh9Y_A@mail.gmail.com>
References: <CAH2r5mvJ=EZ2mC6LTnTmML5tCKpcKCOM7+nbbFSzpATBWh9Y_A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvJ=EZ2mC6LTnTmML5tCKpcKCOM7+nbbFSzpATBWh9Y_A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc-smb3-fixes-part2
X-PR-Tracked-Commit-Id: c8c412f976124d85b8ded85c6ac3f760c12b63a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f6513bd39c15af8f8a63b1fbfcb1bf4717241655
Message-Id: <159754293522.18953.9460070740804124461.pr-tracker-bot@kernel.org>
Date:   Sun, 16 Aug 2020 01:55:35 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 15 Aug 2020 00:32:46 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.9-rc-smb3-fixes-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f6513bd39c15af8f8a63b1fbfcb1bf4717241655

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
