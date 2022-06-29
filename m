Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4613CC43334
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Jun 2022 16:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbiF2Qol (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiF2Qok (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Jun 2022 12:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D1A2CCAC;
        Wed, 29 Jun 2022 09:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02C9EB825D3;
        Wed, 29 Jun 2022 16:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE380C341C8;
        Wed, 29 Jun 2022 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656521077;
        bh=m15YOLBCQzWiMbd2XCpklYoAw02Jy5jbBvqg6MsHPe4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=J1CmNhxIzOQxiKmcJfN5jFIrnd4iG905LqVA307jluRYPy8BA4Fo5B8EW16LIZyZ4
         zGAYDABlv5Ezltpg4kzP6jfLX1cHqAECIEu+CunluJXmo4AUWkNCPtHAWNy8G/WmfL
         beyT/xqkDdeyVsgQ8I/Cp6UxcfPv7GyX9+GEKJGj+JdaHqBac2dCLe9wXQ60zE3C7E
         InJ3nVqOEz0/gfXA2Sx6kE9OgMTAeDYtWwqU+GNE7rI+9efn1Hqi5QR7kFnRrYgaDB
         cdRmcP8HDLZqHGJgwawLUbl7sQYlEXAbLXe/2Lzr3R3h5OUag523IaF6Pl1qIowECx
         M3ZeY0I11pKFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA5D2E49BBA;
        Wed, 29 Jun 2022 16:44:37 +0000 (UTC)
Subject: Re: [GIT PULL] ksmbd server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5ms0EHq5zqwjE6PXVC_NCydY7d6+=NSnQcdjtNhbA6bf=A@mail.gmail.com>
References: <CAH2r5ms0EHq5zqwjE6PXVC_NCydY7d6+=NSnQcdjtNhbA6bf=A@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5ms0EHq5zqwjE6PXVC_NCydY7d6+=NSnQcdjtNhbA6bf=A@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/5.19-rc4-ksmbd-server-fixes
X-PR-Tracked-Commit-Id: 067baa9a37b32b95fdeabccde4b0cb6a2cf95f96
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 732f30694325ab586a4d90412ace81e50dfe448e
Message-Id: <165652107768.8432.1861360584555780047.pr-tracker-bot@kernel.org>
Date:   Wed, 29 Jun 2022 16:44:37 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Tue, 28 Jun 2022 17:07:09 -0500:

> git://git.samba.org/ksmbd.git tags/5.19-rc4-ksmbd-server-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/732f30694325ab586a4d90412ace81e50dfe448e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
