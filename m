Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93702C25B48
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Oct 2023 13:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjJZNJh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjJZNJg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Oct 2023 09:09:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38B31B2;
        Thu, 26 Oct 2023 06:09:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68744C433C7;
        Thu, 26 Oct 2023 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698325773;
        bh=vLtTWv/ZXAwWN12pv3/dVO7bz32AKqwKVCQQHN3iznY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OM528WhCh6iPSwzmv1DJU3ufjYkaUJzYCRb9aWQjrn+DmaMHFj7K1GfmfzlI8zNZj
         ole1GaSiM0jekzEzL+Ag+5Trxex4iAJrXP6bx/6fX7h/h4fNqqWk1w2xz5WR7gWMWC
         fgNBwdvpFmkFGOmUmNL9tqqDplWqlvpNChqX4UBdMajFm0P5/dymayeq8jW/4PLSXg
         QlTTZEApOljM6o4fkGMjBL+sCayRlcBTLkMBoFOFmThx/NGNltYMnTHh0aIJ72muwf
         Mxiyl2n0MtfnETdD150bGd7Xy7zlSTrwL7/VpvQ9aJF3mYr3UiFeUVpZVfdoISE/HE
         4wsQnaRizbYow==
Date:   Thu, 26 Oct 2023 09:09:31 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Stable <stable@vger.kernel.org>,
        Paulo Alcantara <pc@manguebit.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Linux Regressions <regressions@lists.linux.dev>,
        "Dr. Bernd Feige" <bernd.feige@uniklinik-freiburg.de>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Some additional cifs patches for 6.5 stable to address issue
 brought up by kernel regression tracker
Message-ID: <ZTplC1_qJYL1wR2G@sashalap>
References: <CAH2r5mvHUnxfOU1URs2s6O3As8WLyMEkK+KNdUy6Ct9u+=d5YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mvHUnxfOU1URs2s6O3As8WLyMEkK+KNdUy6Ct9u+=d5YA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 23, 2023 at 11:32:21PM -0500, Steve French wrote:
>There were a set of issues brought up in 6.5 by the introduction of
>the "laundromat" (which cleans up directory leases).  After discussion
>and testing with Paulo, Bernd Feige and others, we request that the
>following set also be included to address these problems.  They are
>all in mainline (added in 6.6) and the patches (from mainline since
>they apply cleanly) are also attached.
>
>        238b351d0935 ("smb3: allow controlling length of time
>directory entries are cached with dir leases")
>        6a50d71d0fff ("smb3: allow controlling maximum number of
>cached directories")
>        2da338ff752a ("smb3: do not start laundromat thread when dir
>leases  disabled")
>        3b8bb3171571 ("smb: client: do not start laundromat thread on
>nohandlecache")
>        e95f3f744650 ("smb: client: make laundromat a delayed worker")
>        81ba10959970 ("smb: client: prevent new fids from being
>removed by laundromat")

Queued up, thanks!

-- 
Thanks,
Sasha
