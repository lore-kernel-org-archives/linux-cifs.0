Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20FCC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Dec 2021 20:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242614AbhLBUO4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Dec 2021 15:14:56 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40986 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242416AbhLBUOz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 2 Dec 2021 15:14:55 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6F7EA808AC;
        Thu,  2 Dec 2021 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1638475891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JDBvf9aqogE+CEZtaTifdNx+Cd7bsW/9rwsXJ2U1U3M=;
        b=UHCcBdocXvj/Hff7bP/2AJGbcApeupRpisO/YynUttyH81jNwmOyzcEZm+yZvNZkzK+w7k
        gR/sMAWYRXZ53wDm6AUMyGCngtchLaldOh3t8Z0SWDG2cmSUOcuskah5Rktol5U9o6Ry55
        AmGEm++dMF4O/QAZGtjD0BHvJCSDnp7FnvMmW+aFt7B4FY9pCSlrfq+iXjyjdnL/EFLEbd
        qrFoVWxFOOvrUzIt1J/LCL7t+11DutvPCNNYY1FKzFGEEGWI1aprulHHHNHSxlORCaEIgr
        93KWe6/e+r3+c/KC2Jx5dsRKFKay2vgFlgLF0TJ62HA68S47gUxBljSZ1QTLKw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH SET] fscache fixes
In-Reply-To: <CANT5p=qfOdaFQF+EUgjgQx=zGb09FCu=zjZ7q622G--dUy7F3w@mail.gmail.com>
References: <CANT5p=qfOdaFQF+EUgjgQx=zGb09FCu=zjZ7q622G--dUy7F3w@mail.gmail.com>
Date:   Thu, 02 Dec 2021 17:11:24 -0300
Message-ID: <87tufq7onn.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Please review and consider the following fixes in fscache integration
> of cifs.ko.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d70e50047c7daa3de17c7c41a0c4ef4f9e4443c9.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/089dd629653b857b6096966e9d2df301653a36ea.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a9a62cdfe26c782dadd0b94ab529b883426d0acd.patch

Thank you!  BTW, this fixes the duplicated cookie warnings I noticed
while running DFS tests with fscache enabled today.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
