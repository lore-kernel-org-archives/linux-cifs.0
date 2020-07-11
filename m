Return-Path: <SRS0=3VLN=AW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EEDC433E2
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 04:25:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82A71207BC
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Jul 2020 04:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594441510;
	bh=PzRVaXTy2tvGmrp+Qlg/Fv7fKbs/z266tcTyVcifFg8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=vh6/tETsbSDwUdNugeX1GQrEEhtlse09otSUy+2n18qW0tG3P+jVttJIl+kFAAsei
	 YUcvrctPSJSV0KNJpdXxx7MXpq6qHdtcbpzVTkIsFp5uxLi0ItRpQ/UNSpmjGh/RqC
	 9MH/R5tPtKE9gRX3Wudq4sQDTzI+/kK2d+d0VvGA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgGKEZJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Jul 2020 00:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgGKEZD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 11 Jul 2020 00:25:03 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594441503;
        bh=PzRVaXTy2tvGmrp+Qlg/Fv7fKbs/z266tcTyVcifFg8=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=wMQ8BhHatXEcEEI/3U3DKKK1YtY/bK8z7RCLVFNJZt5yFda0qpP8ImFKDsvb/sivf
         R9hAO7xmMskaA7gzlVasOY3PcFO8k15kt0DQOHtji+CLnndIf+PGKX+LOcbwuFvGGp
         B4+uQ4LEEF4vgM9jKCxcTbKnBN0HPUAnCz6n434o=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms400MbvDKxUg+Z8MsyVPwiL6ZEjZDUgXNwuQGR+yMYbA@mail.gmail.com>
References: <CAH2r5ms400MbvDKxUg+Z8MsyVPwiL6ZEjZDUgXNwuQGR+yMYbA@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms400MbvDKxUg+Z8MsyVPwiL6ZEjZDUgXNwuQGR+yMYbA@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.8-rc4-smb3-fixes
X-PR-Tracked-Commit-Id: a8dab63ea623610bb258d93649e30330dd1b7c8b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ab39e08ff1558ed80d93f5c5217338f19369a40
Message-Id: <159444150334.19180.17050675116114651653.pr-tracker-bot@kernel.org>
Date:   Sat, 11 Jul 2020 04:25:03 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 10 Jul 2020 19:53:30 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.8-rc4-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ab39e08ff1558ed80d93f5c5217338f19369a40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
