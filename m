Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52D2EB64DD
	for <linux-cifs@archiver.kernel.org>; Sun, 16 Jul 2023 19:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjGPTKz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 16 Jul 2023 15:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGPTKy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 16 Jul 2023 15:10:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83F29F;
        Sun, 16 Jul 2023 12:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D75460E55;
        Sun, 16 Jul 2023 19:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E10C433C7;
        Sun, 16 Jul 2023 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689534652;
        bh=2xv23cyqChGOvmMFc4gjPsEPeAdHKXCa1xqaiod61p8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sv273MnVtjJXakzIkTQLlpd2JNk38A4njcF1xV+lSuffmbnNo9IecwLzm1zGbl805
         2poG/Z7//Gk2OTajfXu8PiSi4dJ+YKqcLbSu9XBKCyx9H+RATadZvoTXzsdxSRZWK5
         9MFLcAukeUaJ1w+askvIsa1KQD45qO+j/hMjmR7w=
Date:   Sun, 16 Jul 2023 21:10:50 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
Message-ID: <2023071646-freeness-untrue-230d@gregkh>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-4-pc@manguebit.com>
 <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
 <2023071306-nearly-saved-a419@gregkh>
 <b95eb538478eab38fac638dbeaf97e70.pc@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b95eb538478eab38fac638dbeaf97e70.pc@manguebit.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jul 13, 2023 at 06:48:00PM -0300, Paulo Alcantara wrote:
> Hi Greg,
> 
> Greg KH <gregkh@linuxfoundation.org> writes:
> 
> > On Wed, Jul 12, 2023 at 06:10:27PM -0300, Paulo Alcantara wrote:
> >> Paulo Alcantara <pc@manguebit.com> writes:
> >> 
> >> > Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
> >> > that are unexpected by the client, so to make it easier, assume
> >> > non-DFS mounts when the client can't get the initial DFS referral of
> >> > @ctx->UNC in dfs_mount_share().
> >> >
> >> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> >> > ---
> >> >  fs/smb/client/dfs.c | 5 +++--
> >> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> >> > index afbaef05a1f1..a7f2e0608adf 100644
> >> 
> >> Stable team, could you please pick this up as a fix for
> >> 
> >>         8e3554150d6c ("cifs: fix sharing of DFS connections")
> >> 
> >> The upstream commit is 5f2a0afa9890 ("smb: client: improve DFS mount check").
> >
> > Does not apply cleanly, can you provide a working backport?
> 
> Find attached backport of

> >From 435048ee0f477947d1d93f5a9b60b2d2df2b7554 Mon Sep 17 00:00:00 2001
> From: Paulo Alcantara <pc@manguebit.com>
> Date: Tue, 27 Jun 2023 21:24:50 -0300
> Subject: [PATCH stable v6.3] smb: client: improve DFS mount check

I'm confused, 6.3.y is end-of-life, and:

> 
> Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
> that are unexpected by the client, so to make it easier, assume
> non-DFS mounts when the client can't get the initial DFS referral of
> @ctx->UNC in dfs_mount_share().
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/dfs.c | 5 +++--

This file is not in the 6.4.y or any older kernel tree.

So what tree did you make this against, and where should it be applied
to?

totally confused,

greg k-h
