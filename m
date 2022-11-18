Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1EFBC4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 14:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiKROyX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Nov 2022 09:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbiKROyS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Nov 2022 09:54:18 -0500
X-Greylist: delayed 444 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Nov 2022 06:54:17 PST
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F182911C2F;
        Fri, 18 Nov 2022 06:54:17 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C526A7FCED;
        Fri, 18 Nov 2022 14:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1668782811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i4KIqUADj/IJllVAyObmkbmWGqEBQfr/5CjaR+2wZao=;
        b=v+gUuexlcJgBUnllEq88k6vkD5GyDzJojlJ/cZgyU993jASZyrhs/bgoURLsUCaKKksrsg
        yuNVNiUKAqD2G7lm/1b9Ga3AXV5PugeDSXfsQtVexZYriAL1j1y3Hitf1ejerCZNw4gueI
        iyPS7CUqru7bhjl/ZjkaEPMhqhX/6mTbOV0VTtRShLbNSAxkQmS/XgPxbXUXhAsxJIfAgj
        EETTeHSg/HFhVT2hFCB9Yd/gr9pvUlp9Swc2cQLD/BIdlliSGftcNr2w6MeT8HNStOnazz
        1/0/AY5TfTOkGeFM1/WmgVAlkQzqWpfRu3wnh3AWDt66iPdhclJHZG7+pDCRzg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Dan Carpenter <error27@gmail.com>, Steve French <sfrench@samba.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] cifs: Use after free in debug code
In-Reply-To: <Y3dw8KLm7MDgACCY@kili>
References: <Y3dw8KLm7MDgACCY@kili>
Date:   Fri, 18 Nov 2022 11:48:08 -0300
Message-ID: <87edu0jp3r.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dan Carpenter <error27@gmail.com> writes:

> This debug code dereferences "old_iface" after it was already freed by
> the call to release_iface().  Re-order the debugging to avoid this
> issue.
>
> Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/sess.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
