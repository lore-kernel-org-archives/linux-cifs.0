Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E248EC07E94
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 15:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C378061400
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 15:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFDP12 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 11:27:28 -0400
Received: from mx.cjr.nz ([51.158.111.142]:21990 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhFDP12 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 11:27:28 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1F89F7FC02;
        Fri,  4 Jun 2021 15:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622820340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oOxmSNZCPWeZDQdiSOSqEVY+DJjrSsroiEI4mEB5+qE=;
        b=CRdRs9bm2eQ8sWBJx/KKVJk6hiDw2mKEj0Mta4pXZdbiMlzIm9O/1papdblx3KTnDaEW+7
        QBT9nR6BxbZ6zyNLpOYknQ1w5JX5nU0cZxjvXDzYZfXvksyDQMznt8GUO9bK4Bcdlve3rN
        4jSAimYdDEaTwJLnQ/tv3ZkgZcVqs2pEI6QmBvoAZWC8ifwR+XSCZGF8VHgODHO9nT1EKY
        +83GlWc9DfhKeqBKsunVk0cMykkkRLjQnwH/27M6tzsgGcwH62lkj/vTb6p42A7XOe0aBv
        BGejbZ4nvVsWIkZg24EwcJS5glvKd+HlTPNcUW5MSy0VnQpiJO3YCLYbav2h3A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Subject: Re: Multichannel patches
In-Reply-To: <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <875yywp64t.fsf@cjr.nz>
 <CANT5p=o6Oq-27Xj4Z6-XzXKL45Dwg7JjGw2HA9jv5+YFQKpHUg@mail.gmail.com>
Date:   Fri, 04 Jun 2021 12:25:33 -0300
Message-ID: <87y2bpk5xu.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> @Paulo Alcantara That would be great if you can help testing my
> changes. Please test with these new changes.

OK.

>> The super is only used for providing cifs_sb_info::origin_fullpath as key to find the corresponding failover targets in referral cache.
> I'm wondering what would happen if there are multiple tcons to the
> same origin_fullpath (possibly in different sessions)?

That is certainly a problem, indeed.  I'm waiting for the DFS tests to
finish and then send a series that contains a potential fix for that --
e.g. not sharing TCP servers when mounting DFS shares.  We used to not
share tcons with DFS mounts because they might contain different prefix
paths but connected to same share, however that wasn't enough because
multiple DFS mounts may connect to same target servers, although they
might failover to completely different servers.

> Also, doesn't failover targets apply to each channel under a session?
> Shouldn't we switch targets on reconnect of secondary channels too?

That's a interesting question.  I recall discussing this with Aurelien
some time ago while running a few DFS + multichannel tests.

So yes, I agree with you that when we successfully reconnect to failover
target (primary channel), then we should also update all secondary
channels with the new server's ip address and reconnect them.
