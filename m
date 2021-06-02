Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22BAC47083
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 16:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E02A1619CD
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 16:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFBQr3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Jun 2021 12:47:29 -0400
Received: from mx.cjr.nz ([51.158.111.142]:35540 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhFBQr3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 2 Jun 2021 12:47:29 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D5EA97FC02;
        Wed,  2 Jun 2021 16:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622652344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ZIh9iu8Rc1ZzW2C3idSWWMHPMcbXTw8RNQnGd6mtvI=;
        b=HeIS2jQxM+xTGDmJ4H8rRtWR82cTOG/61Cq1rLUmCydEBuKiFdl4I+zjh3a2ZyynmP16cE
        Kv6y3/BmhhM7CFlj4KO7QR2GN76qTIbtKIetW7z1+fQKx2yjyLTCOsPIqVqTQVFpmInnAV
        eqMeSBR9x1BhMRQw9YfCnIGOvtQhEu4Cu6cYYKT4Y5suW60nnRnH7pe/1pqN1mMXcj/Tac
        MsamU9b8s5C+ncL7nxkYBBCcPRTtoimTTge6sFU8StgGc0r6S9jEgvNuQ8Fv34cO8e5nyk
        qqgRQ7dw4h4xzyuNG30k/c+nzCPFtxgA/u6C4w12gu/Gt0j4A2igTD03KqAzdw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Subject: Re: Multichannel patches
In-Reply-To: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
Date:   Wed, 02 Jun 2021 13:45:38 -0300
Message-ID: <875yywp64t.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> P.S. There is a logic in cifs_reconnect to switch between the targets
> for the server. I don't think these changes will break the DFS
> scenario. The code will likely take effect only for when the primary
> channel reconnects (as DFS server entries are cached with super block
> as the key). Perhaps more changes will be needed there to also switch
> between the targets for individual channels (maybe use superblock +
> channel num as the key for caching entries?). Folks with better
> knowledge than me with this code may want to check on this?

I don't think your changes would break it as well.  The super is only
used for providing cifs_sb_info::origin_fullpath as key to find the
corresponding failover targets in referral cache.

I can help you testing your changes with some DFS+multichannel failover
scenarios.
