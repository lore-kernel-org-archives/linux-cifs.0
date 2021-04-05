Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DE0C433B4
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 15:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCCD1613A3
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Apr 2021 15:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbhDEPyp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Apr 2021 11:54:45 -0400
Received: from mx.cjr.nz ([51.158.111.142]:3144 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238793AbhDEPyp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 5 Apr 2021 11:54:45 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9F6C37FCF3;
        Mon,  5 Apr 2021 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1617638077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nyp2G/QoGumWzJqM5xr+5Zo3AdLEieT6ze2XVZ+ufLg=;
        b=YxZKZrrjhd40sRV/dpXVTlngU4PfYtTtmcNhVMWM14Y2IqCCrDX40Y47Ucv/hOHUBDQxgw
        pUFjEoZ7A+dDIkhCj/GUNF2QM9y/1f+n/Eg7uLRbQkFTvf71QIWrExd+kL6yM6uQceqSvV
        B/zOxdIGossBu+fuRDPzehr0MwLidHi1GDabCEq0ORsCL4spv5rDTZ71YJjPlQmAML3SAO
        AfhH9WapIM2KPRMtATY/6CVPUv6k7aR4LkN7545/oo1w2X1I/N+YQhy+3DHMG2Pkj4gyoa
        NBCQ4PrFLW4X93oeaXqKvbDIIWlj171d/aOHIZmt7Tbo5zncTkyuC7+O/dmPzw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
In-Reply-To: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
Date:   Mon, 05 Apr 2021 12:54:36 -0300
Message-ID: <87im50vi9v.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Please consider the attached patch for performing the DNS query again
> on reconnect.
> This is important when connecting to Azure file shares. The UNC
> generally contains the server name as a FQDN, and the IP address which
> the name resolves to can change over time.
>
> After our last conversation about this, I discovered that for the
> non-DFS scenario, we never do DNS resolutions in cifs.ko, since
> mount.cifs already resolves the name and passes the "addr=" arg during
> mount.

Yeah, this should happen for both cases.  Good catch!

> I noticed that you had a patch for this long back. But I don't see
> that call happening in the latest code. Any idea why that was done?

I don't know.  Maybe some other patch broke it.

We should probably mark it for stable as well.

> From 289f7f0fa229ea181094821c309a2ba9358791a3 Mon Sep 17 00:00:00 2001
> From: Shyam Prasad N <sprasad@microsoft.com>
> Date: Wed, 31 Mar 2021 14:35:24 +0000
> Subject: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
>
> On cifs_reconnect, make sure that DNS resolution happens again.
> It could be the cause of connection to go dead in the first place.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/connect.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)

This patch breaks when CONFIG_CIFS_DFS_UPCALL isn't set.

Please declare reconn_set_ipaddr_from_hostname() outside the "#ifdef
CONFIG_CIFS_DFS_UPCALL" in connect.c.

Otherwise,

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
