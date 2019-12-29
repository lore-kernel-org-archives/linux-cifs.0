Return-Path: <SRS0=MPZ3=2T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA978C2D0CE
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Dec 2019 19:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F12E208C4
	for <linux-cifs@archiver.kernel.org>; Sun, 29 Dec 2019 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577648107;
	bh=VA2PNe7EHtMwnyNTfXbhD2csLpbuw+O4ePPjAc9+z2M=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=sSjJteUZdT1O+k4wDwRMOKEryyLVEpveQMBxRzHcTsrl6shAGQtWJZafYs1JbWQjZ
	 3PeIG31zMlwEcnDtTk+H+8w8g0LiI1nZ0b6/G2gjXiJycfghdkSrHcEsc9qSeaNSIu
	 4Gu2haHwhhBvQLaSLQsFGO4z3tys5ZPAvUhQMsEk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfL2TfH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Dec 2019 14:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbfL2TfH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 29 Dec 2019 14:35:07 -0500
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577648106;
        bh=VA2PNe7EHtMwnyNTfXbhD2csLpbuw+O4ePPjAc9+z2M=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=m3VMUc/42fVuF9HjSmy+MD6ZBh8YD7HzXf8M4S5V9Zv0LCHCDjyUgpKE8Y6/CN8t0
         U6rW6kHfBtRe2gNLTW+iVXCHpjiGiDo8VsCno20rJ9bvvyB2FseNF28aU8UwPIycUT
         TW6Q5gWJrR+gsSH/jF4GdL/ggtd3ktsS0pWLuGFU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvWwwSA70MnKBZXm_ji9iT+DxVPu-33EcFb9L+GgEwcXA@mail.gmail.com>
References: <CAH2r5mvWwwSA70MnKBZXm_ji9iT+DxVPu-33EcFb9L+GgEwcXA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvWwwSA70MnKBZXm_ji9iT+DxVPu-33EcFb9L+GgEwcXA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.5-rc3-smb3-fixes
X-PR-Tracked-Commit-Id: 046aca3c25fd28da591f59a2dc1a01848e81e0b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: cc2f36ec7188e48c2afb1428fc3ce18884ad634b
Message-Id: <157764810649.31581.368065453512872010.pr-tracker-bot@kernel.org>
Date:   Sun, 29 Dec 2019 19:35:06 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Sat, 28 Dec 2019 23:06:35 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.5-rc3-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/cc2f36ec7188e48c2afb1428fc3ce18884ad634b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
