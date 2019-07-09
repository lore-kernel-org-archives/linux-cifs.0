Return-Path: <SRS0=dv7Q=VG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAA8C606B0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 03:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72FEA21707
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jul 2019 03:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562642132;
	bh=boTuLsU2t2PBkQzaviQYR4IqG4XrFTvJAKfUCSM+R/E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=jEapKrwM3h4OfqDs8pRii/8XKExHipu6JunNZ3oO/7vwQXYVlkObaHk416VbviKqR
	 idTOM2B5CGfBvCqvYrnX5i7lUoK64J5OeZ2BwDysaKD2qUO51ALDKjPvYlSXRFUSAx
	 JXHN1WCaa8gc3woZxR4IcNyxLxKRYwYe5C20Kl6I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfGIDPD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Jul 2019 23:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbfGIDPD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Jul 2019 23:15:03 -0400
Subject: Re: [GIT PULL] Keys: Set 3 - Keyrings namespacing for 5.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562642102;
        bh=boTuLsU2t2PBkQzaviQYR4IqG4XrFTvJAKfUCSM+R/E=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=wnKgAxEAjs1SrLbnFRTFo8VOhIXp2h4KlIsZHZbnYiQDNEdH4oMLwKZT3Wa3ZPPHe
         656RITGkFcWftW9m9Z+wWQ0gApC0mewdpNJwwxPnV2nVessD1dLIyqpLnTYGXk5Py7
         FkaVBeu89G6xOsk7tLXwB5HSg69JP5xk+tWx4l/8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <27850.1562361644@warthog.procyon.org.uk>
References: <27850.1562361644@warthog.procyon.org.uk>
X-PR-Tracked-List-Id: <linux-nfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <27850.1562361644@warthog.procyon.org.uk>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
 tags/keys-namespace-20190627
X-PR-Tracked-Commit-Id: a58946c158a040068e7c94dc1d58bbd273258068
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e12256b9a76584fa3a6da19210509d4775aee36
Message-Id: <156264210219.2709.3738517122070198743.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Jul 2019 03:15:02 +0000
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org, dhowells@redhat.com,
        jmorris@namei.org, ebiederm@xmission.com, dwalsh@redhat.com,
        keyrings@vger.kernel.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-afs@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Fri, 05 Jul 2019 22:20:44 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-namespace-20190627

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e12256b9a76584fa3a6da19210509d4775aee36

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
