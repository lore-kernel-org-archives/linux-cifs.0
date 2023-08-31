Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A02CA0FE1
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Aug 2023 22:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347875AbjHaWmx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Aug 2023 18:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbjHaWmw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Aug 2023 18:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396B5E8;
        Thu, 31 Aug 2023 15:42:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C42AB60BBA;
        Thu, 31 Aug 2023 22:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ED51C433CC;
        Thu, 31 Aug 2023 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693521765;
        bh=lBuLmR7sMzaYvwSC0UjddYmyisoAQY7yO4HT3g9vVbA=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=T1eMSkl63WiEfXphFDmJy5pa8pqRkOvTbJ7mbbupufMMa1qbgQ4JC7U1SBVPPeY4p
         ZcSXUEICeTkp5bbu3T9YrumWhWP/+FcEqzeRwhqYcHx3HBb+LeJfnZH255FDnrDvcu
         EbL+kq3v0dxq/XTO/PSsSdW0najyOcA/L/74sX9FbR13NGujirRITTLGtdZlcw7DbG
         6gdhG8+vy0V/YASvRFWIS+k3mlCJlOHeDVGhh0tHfl9KWrSOPQmPS03qdEQe73Io0n
         hlf/GKNqgsfz6qH5pS+P5ibreMZWz2szrDllsttBIl27LXzeofbCGJfePg7nzLBa3C
         BCW+nh6k/BKeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E327C595D2;
        Thu, 31 Aug 2023 22:42:45 +0000 (UTC)
Subject: Re: [GIT PULL] ksmb server fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mvMSeqLQkNqwrxr5Q1FpJrQ85VUkp7_c4WP0BugQfpHPg@mail.gmail.com>
References: <CAH2r5mvMSeqLQkNqwrxr5Q1FpJrQ85VUkp7_c4WP0BugQfpHPg@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mvMSeqLQkNqwrxr5Q1FpJrQ85VUkp7_c4WP0BugQfpHPg@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/ksmbd.git tags/6.6-rc-ksmbd-fixes-part1
X-PR-Tracked-Commit-Id: 0e2378eaa2b3a663726cf740d4aaa8a801e2cb31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8ae5d298ef2005da5454fc1680f983e85d3e1622
Message-Id: <169352176511.24475.1672811562650246330.pr-tracker-bot@kernel.org>
Date:   Thu, 31 Aug 2023 22:42:45 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Thu, 31 Aug 2023 10:30:05 -0500:

> git://git.samba.org/ksmbd.git tags/6.6-rc-ksmbd-fixes-part1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8ae5d298ef2005da5454fc1680f983e85d3e1622

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
