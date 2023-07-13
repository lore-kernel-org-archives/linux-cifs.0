Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40634EB64DD
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jul 2023 05:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjGMFla (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jul 2023 01:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjGMFl3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jul 2023 01:41:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07334172C;
        Wed, 12 Jul 2023 22:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75E9861A1B;
        Thu, 13 Jul 2023 05:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432D4C433C8;
        Thu, 13 Jul 2023 05:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1689226887;
        bh=cFvPhsHRAQGBcJsAHyTV9CLT76m3zJ2Ubb41woaqqu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kjvr4XxLMpKUGdwNr5aw5n5zSuwPlFOFz6q2BVlkL+B9TKtOCrgtCEjts0bEsLO2j
         FhoSWPpI9HDhVx0RL8rRXbkdH+YMdIypZ7civIxVxk/nDfSGaWCGqDvk/fUCmgTNDf
         mF7tme5r5zcDIETRL2hF3DS1q8JkzP5/DLT31pa0=
Date:   Thu, 13 Jul 2023 07:41:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 4/4] smb: client: improve DFS mount check
Message-ID: <2023071306-nearly-saved-a419@gregkh>
References: <20230628002450.18781-1-pc@manguebit.com>
 <20230628002450.18781-4-pc@manguebit.com>
 <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bb4a367ebd7ae83dd1538965e3c0d2b.pc@manguebit.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 12, 2023 at 06:10:27PM -0300, Paulo Alcantara wrote:
> Paulo Alcantara <pc@manguebit.com> writes:
> 
> > Some servers may return error codes from REQ_GET_DFS_REFERRAL requests
> > that are unexpected by the client, so to make it easier, assume
> > non-DFS mounts when the client can't get the initial DFS referral of
> > @ctx->UNC in dfs_mount_share().
> >
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> > ---
> >  fs/smb/client/dfs.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> > index afbaef05a1f1..a7f2e0608adf 100644
> 
> Stable team, could you please pick this up as a fix for
> 
>         8e3554150d6c ("cifs: fix sharing of DFS connections")
> 
> The upstream commit is 5f2a0afa9890 ("smb: client: improve DFS mount check").

Does not apply cleanly, can you provide a working backport?

thanks,

greg k-h
