Return-Path: <SRS0=aVrN=3R=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB88BC33CB3
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jan 2020 23:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B191922522
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Jan 2020 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580254816;
	bh=t2KBhxLlzR26P92snPvSso37bkIr9FDpyXy4784d0Os=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=u1fIRmtgHPMA7sOyWaaUCMdZ6fDVTXF8tvU+0el7/mYQmb128LRLTiR9lRi9Rz5w1
	 +yNEHr27vFzc6IJtXZbrzvXxMfx0FuVrjIJrdz3LZuWx65zmFQkmBYRwaEWoDq0je8
	 iAUWLMszuh6l8aiMLMdMpuIPbXbnK7sqYe8L+Y58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgA1XkQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Jan 2020 18:40:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgA1XkG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 28 Jan 2020 18:40:06 -0500
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580254805;
        bh=t2KBhxLlzR26P92snPvSso37bkIr9FDpyXy4784d0Os=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=aR72bIdadi/TEf+fP+fnnEXPsT+aSekz4yHYpKoh7ZK8F7i4zzxxuuU3dGJnqWIcn
         Fi2DzSX4YCfIQ+cKXWwy2wKuu/sNNfe3/wHOvdnpLe7dqSZlv3/0CgFp4WCDXSAlPo
         BzfXpSJdKEovRD4Ma3Y4xq26id08nZD0MgZ/yzIM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms5g+iVOJzQorgSws9tK+aNY7MzsNaMVO_Yx_NYgS9nRQ@mail.gmail.com>
References: <CAH2r5ms5g+iVOJzQorgSws9tK+aNY7MzsNaMVO_Yx_NYgS9nRQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms5g+iVOJzQorgSws9tK+aNY7MzsNaMVO_Yx_NYgS9nRQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.6-smb3-fixes-and-dfs-and-readdir-improvements
X-PR-Tracked-Commit-Id: f1f27ad74557e39f67a8331a808b860f89254f2d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 68353984d63d8d7ea728819dbdb7aecc5f32d360
Message-Id: <158025480568.16364.10674114982000260724.pr-tracker-bot@kernel.org>
Date:   Tue, 28 Jan 2020 23:40:05 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Tue, 28 Jan 2020 12:31:30 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-smb3-fixes-and-dfs-and-readdir-improvements

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/68353984d63d8d7ea728819dbdb7aecc5f32d360

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
