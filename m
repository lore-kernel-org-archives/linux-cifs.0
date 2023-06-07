Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7DFC7EE25
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Jun 2023 18:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjFGSHE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbjFGSHC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jun 2023 14:07:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466202132;
        Wed,  7 Jun 2023 11:06:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCA656419F;
        Wed,  7 Jun 2023 18:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC230C433EF;
        Wed,  7 Jun 2023 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1686161205;
        bh=C/lHo+ZleFjO9LWFKlT+1j26eXRjziuLsc+qH3svza4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QzWaZ33ZncOK/LsiwA3boNsDl4XQVmccX89UKv3/6Sy91XNSeMnvrLyd8lNkFxs6l
         V6XS2QUKtVuzFeq9126guglD4ucAkL2SWPesUht16gE8z9RsGjecV3UdYtHf+gix/A
         78YaBJTRRAM1clbJW6zr+WdG4hzOAneLMxl0274Y=
Date:   Wed, 7 Jun 2023 20:06:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rishabh Bhatnagar <risbhat@amazon.com>
Cc:     sfrench@samba.org, stable@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.4 1/2] cifs: get rid of unused parameter in
 reconn_setup_dfs_targets()
Message-ID: <2023060758-identify-awkward-8f86@gregkh>
References: <20230601205817.3957-1-risbhat@amazon.com>
 <20230601205817.3957-2-risbhat@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601205817.3957-2-risbhat@amazon.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jun 01, 2023 at 08:58:16PM +0000, Rishabh Bhatnagar wrote:
> From: Paulo Alcantara <pc@cjr.nz>
> 
> commit baf3f08ef4083b76ca67b143e135213a7f941879 upstream.
> 
> The target iterator parameter "it" is not used in
> reconn_setup_dfs_targets(), so just remove it.
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---

When passing on patches from other people, you too have to sign-off on
the patch, saying that you are ok with it.

Please resend this series with your signed-off on it as well (after
reading the documentation to understand what you are agreeing to.)

thanks,

greg k-h
