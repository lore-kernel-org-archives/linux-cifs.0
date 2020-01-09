Return-Path: <SRS0=5TF8=26=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A5DC282DD
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 13:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3D8C2072A
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 13:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="dsk7vEUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbgAINGp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jan 2020 08:06:45 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40934 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgAINGp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Jan 2020 08:06:45 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EAF9E808C0;
        Thu,  9 Jan 2020 13:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578575203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sZasYUESR4DSh0lVK71V9TVjOHaoB9cH6O288Vq1hBM=;
        b=dsk7vEUUIeB8blQoqvqhwh3A6qV+S6SS0+PIT+980dLp+xJTIqxy6XcbSTTehUncGygyrj
        rpwZoQPn3q0sYF0UPRjOpx3Ln1/AdRD5CAa3TYFEbqkjWxAxEIACY69rNTyt6p9cfSPs28
        U6SqOHip0JuLbMeJcUwl15xlT40KpNuKQ9twUY32wdlSxoy2klLE0O48MEZmgpqyzeUDUY
        1hC5bjnDZmmIQbGMYjLDj9bF+dSGc/iuT/7vG7GjzXFKyn9A5YodMCwjjZZnstPk9hyWDL
        9Hj1P+wzumc52nSE1jazsAIs/tXsEnUpVemuKjkfKRkL561riy5EkFQzKksiTQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
In-Reply-To: <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
 <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
 <878smoqouf.fsf@cjr.nz>
 <VE1PR02MB55503665681374E805CA7815F53C0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87k16417ud.fsf@cjr.nz>
 <VE1PR02MB55502AA359141C1D29B2AB82F53F0@VE1PR02MB5550.eurprd02.prod.outlook.com>
 <87y2uh264k.fsf@cjr.nz>
 <3ddf0683-0213-1c43-bcc7-cfc3cb8bc28b@prodrive-technologies.com>
Date:   Thu, 09 Jan 2020 10:06:40 -0300
Message-ID: <871rs8eq3j.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Martijn,

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:

> Yes, so far so good. Thanks a lot for the quick response! Not a trivial 
> patch as far I as i can judge.

Cool! Thanks for the confirmation. Just sent a patch with this fix, BTW.

> Also the machine we have running with your other DFS patches is running 
> for 8 weeks now and survived several relocations of our dfs shares and 
> adding/removal of DCs!
>
> Is there any news on the acceptance of your [PATCH v4 0/6] DFS fixes?

I don't have any news, but I'll talk to Steve and Aurelien about them.

Thanks,
Paulo
