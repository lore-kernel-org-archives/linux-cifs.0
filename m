Return-Path: <SRS0=0I05=7S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48A02C433E1
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 23:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB54207DF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 23:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591401023;
	bh=8sa8+tY0nNPpk4uOlsn9fgBG5+XIi8tB3sm+CCMbxoo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=drKemrtpv2ap8e9EngNgTQUblGpZpvHUhkojXXP6KsinfUgjOe5916riA1FpsAm51
	 sfZXLzCBTwjX/rtlPRH8cF/CT4EKEddPwxgz+bJzrsFrNasXfuGxZZAuVRii2mpeYV
	 yFmb/6DirsUvkBYjGWlMtDy9DT1z5oILha95Xg0A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgFEXuV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jun 2020 19:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728616AbgFEXuV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Jun 2020 19:50:21 -0400
Subject: Re: [GIT PULL] SMB3 updates for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591401020;
        bh=8sa8+tY0nNPpk4uOlsn9fgBG5+XIi8tB3sm+CCMbxoo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=YxF46JAS0BOG/0hIEmnwCfRT0mFzzVwQgL3ZrzSuqklPE4jZdpfLI5rHiBYSuO3eo
         +BMc36jsc3y0U2Bqb/0wnnui4slg3cA+5lJCX9Pi0OFRWwmJRkwc3Xx5h51eYlhZeu
         zUUjWWGdrmjXe8v3aZg1IZzIjcI/KXqbo8+u1cm0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mtZ-TLv-rNn_A_KcPR+djGQ9CpfVyvXSj-Uv-s+XiWq3A@mail.gmail.com>
References: <CAH2r5mtZ-TLv-rNn_A_KcPR+djGQ9CpfVyvXSj-Uv-s+XiWq3A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-cifs.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mtZ-TLv-rNn_A_KcPR+djGQ9CpfVyvXSj-Uv-s+XiWq3A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.8-rc-smb3-fixes-part-1
X-PR-Tracked-Commit-Id: 331cc667a99c633abbbebeab4675beae713fb331
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3803d5e4d3ce2600ffddc16a1999798bc719042d
Message-Id: <159140102065.11239.743902383036607481.pr-tracker-bot@kernel.org>
Date:   Fri, 05 Jun 2020 23:50:20 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 5 Jun 2020 12:10:52 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc-smb3-fixes-part-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3803d5e4d3ce2600ffddc16a1999798bc719042d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
