Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B9DC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 19:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1864420836
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552161331;
	bh=kM6pCPKYbOd0DJGlOtu0muQ+Rgjn8I9uqQW7l5Z9nsw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=XPxn/cv97F5mLBsM3XIDxfH9c7XOzQ0S7IHhoWdQv5xobuJwO38rQ0+PLImrQyDdx
	 baZ0/TTjcTiKcU0fl2CvU9lBtZozkP0mDQ2qXG2tX3leHGzlTfLlW7oCfohrwdGgXl
	 fohyHKUm9eg/oBwqxAFL0WmFEKHLG7Yc1BdViR04=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfCITza (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 9 Mar 2019 14:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbfCITzV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 9 Mar 2019 14:55:21 -0500
Subject: Re: [GIT][PULL] smb3 fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552161321;
        bh=kM6pCPKYbOd0DJGlOtu0muQ+Rgjn8I9uqQW7l5Z9nsw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Qx4W4nKfVi0bRZtGksPpBUiS4UVZtm1yHYSIlE0xfuiZvRfxrBaCbCcj/fMwuCh54
         zNrQEYG4LSp6jK34k8hH3bvX7b8BT5z4dcrQTdnsNi+AfnAEIswr4wAIZMLkZ7J7b+
         k8oHrvuegmS1dgyfb4WnjMhfqqe/N2zeDF2LIHE0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mst=W==ug8Xdt93P3iE1HqeXEjaxYj25TYTs9_1XLfCVg@mail.gmail.com>
References: <CAH2r5mst=W==ug8Xdt93P3iE1HqeXEjaxYj25TYTs9_1XLfCVg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mst=W==ug8Xdt93P3iE1HqeXEjaxYj25TYTs9_1XLfCVg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.1-rc-smb3-fixes
X-PR-Tracked-Commit-Id: 50cfad780bcf9e03d11aaf0a7296a4c0ed336b54
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e519a8c2c3431fbc27e453ff73f5b51df5afe6b5
Message-Id: <155216132118.23333.6593985846880138776.pr-tracker-bot@kernel.org>
Date:   Sat, 09 Mar 2019 19:55:21 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 8 Mar 2019 10:54:02 -0600:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e519a8c2c3431fbc27e453ff73f5b51df5afe6b5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
