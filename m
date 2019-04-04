Return-Path: <SRS0=TNZY=SG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8F9DC4360F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Apr 2019 06:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B585C20855
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Apr 2019 06:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554359409;
	bh=N1cjutw3r+8Q+pbVRsLiDXC1ty1m5AvYGNg2ctpc5dQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=u3GDOjuw2mrRBEcUWHkz0p4BxLQ3njlCLp76V0dRSNf66AzjBIQJzXxxAyvCSsaRL
	 L4XENq7cP10UNOYPaNwo7diwXmISVn24R6fIhKvClhwPg96M1T7Z3M48Dhv04V5sGf
	 JQj8xDZjX7hGm4N+NB+ITAWik+7+pWA48ytILVAM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfDDGaJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfDDGaJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:30:09 -0400
Subject: Re: [GIT PULL] SMB3 Fixes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554359408;
        bh=N1cjutw3r+8Q+pbVRsLiDXC1ty1m5AvYGNg2ctpc5dQ=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=XFsGIPyrd70j9F13YbtXhVamXkQWAxZFZ1OpOV8a7Nn8NsRhHeONKn2qzv9YIfHIV
         12wTWL1x4jQYGLTlTx3L8oW99X4WrUzuU3U8LTvbQHzL+pklEYns6+uEo/sGyCFCzv
         Jo+OYKB4GPRc8kJnip/C8/1Yz6MY8mYTEJB9wFdw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <CAH2r5mv70K=Mj7ehKB2iAZc95emcWGYC5eBKOV-1tkD=euyatQ@mail.gmail.com>
References: <CAH2r5mv70K=Mj7ehKB2iAZc95emcWGYC5eBKOV-1tkD=euyatQ@mail.gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <CAH2r5mv70K=Mj7ehKB2iAZc95emcWGYC5eBKOV-1tkD=euyatQ@mail.gmail.com>
X-PR-Tracked-Remote: git://git.samba.org/sfrench/cifs-2.6.git
 tags/5.1-rc3-smb3-fixes
X-PR-Tracked-Commit-Id: 4811e3096daaa56e145a1d2bec45e2e9fe790729
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 145f47c7381d43c789cbad55d4dbfd28fc6c46a4
Message-Id: <155435940868.29869.8423602875865195219.pr-tracker-bot@kernel.org>
Date:   Thu, 04 Apr 2019 06:30:08 +0000
To:     Steve French <smfrench@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The pull request you sent on Wed, 3 Apr 2019 13:03:47 -0500:

> git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc3-smb3-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/145f47c7381d43c789cbad55d4dbfd28fc6c46a4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
