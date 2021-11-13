Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8C3C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 19:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3674A61168
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 19:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhKMTrW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Nov 2021 14:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236097AbhKMTrT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 13 Nov 2021 14:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0127C61168;
        Sat, 13 Nov 2021 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636832667;
        bh=Uiy60eRkvjP2wpBFgtdhiEC9WgcWzpXY6XCb6LbTXFg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=A/b0je8JpFPf25s+VFW6zXLm0+U98TY6zVz5wAQjc4UZNSEaER0Y+9Upacjgkuw29
         P1tr3DXDFHBKQoeTPZJ426HrpbNYeKJz80R53OkEOBiP8SuaNNMYp+K775ltZnRi3l
         AiTeBSStUkE43vnBW4hBz8TsqPWqW/RsVuOPwKpOUJ2Vpw36dp+AteleAhKc3cc4mp
         LYRXWs4FI+TISjQNUs/GG9U3JqBXNJI2djVZE919OXl+XsDQAeWkylZDpOIU/4Ygzs
         1RuyXxisF92CszJqVmm3TPLwhB8OK2ow+vNrijJvBJsCsO5BEKm7hSfmTV6lBjknwZ
         Xe8nCgheht2yw==
Subject: Re: [GIT PULL] ksmbd fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms0=2rMt4+jGi1nQC+EPrjozYezRjSiyt9DCxbkTwqgNw@mail.gmail.com>
References: <CAH2r5ms0=2rMt4+jGi1nQC+EPrjozYezRjSiyt9DCxbkTwqgNw@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms0=2rMt4+jGi1nQC+EPrjozYezRjSiyt9DCxbkTwqgNw@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.16-rc-ksmbd-fixes
X-PR-Tracked-Commit-Id: 26a2787d45c5af8ffe0f986c01c36bc9111aa9be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a613224169f916755aadf5b97c31b122ce070a88
Message-Id: <163683266697.24678.1309879503062844613.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Nov 2021 19:44:26 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 12 Nov 2021 10:19:05 -0600:

> git://git.samba.org/ksmbd.git tags/5.16-rc-ksmbd-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a613224169f916755aadf5b97c31b122ce070a88

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
