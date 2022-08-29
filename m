Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF76C0502C
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Aug 2022 07:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiH2Hon (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Aug 2022 03:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiH2Hom (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Aug 2022 03:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB24F1B7;
        Mon, 29 Aug 2022 00:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C666112E;
        Mon, 29 Aug 2022 07:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B814DC433D6;
        Mon, 29 Aug 2022 07:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661759080;
        bh=00t5wHTvz51utbPGJygEKXuRE1eRby5ZijJFCGeaNTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KcA/15zh/W7l4v1oIx0UXNFWTUmIxGgChJttuUHo9+PBOL0LkrffSqEGwp5+hs4iE
         /fFeiIcXJ4XNmLEH/HPh2PaZenMZ3gkm6wLK/cTx3Teo+KMOQvOafxP+Dgb9FMbRTH
         Ql63gugv1TeR1DWay+DJeRDSnt+HDgBjFlmL69oM=
Date:   Mon, 29 Aug 2022 09:44:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: cifs backport request
Message-ID: <YwxuZfeLJV7IEidp@kroah.com>
References: <87r110nocu.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r110nocu.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Aug 28, 2022 at 04:45:53PM -0300, Paulo Alcantara wrote:
> Hi Greg,
> 
> Could you please pick these commits for >= linux-5.7.y
> 
>         ef605e868212 ("cifs: skip trailing separators of prefix paths")
>         ee3c8019cce2 ("cifs: fix uninitialized pointer in error case in dfs_cache_get_tgt_share")

These do not apply at all to any of those kernels.  Please provide a
backported and tested set of patches and we will be glad to queue them
up.

thanks,

greg k-h-
