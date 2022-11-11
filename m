Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E45AC43217
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Nov 2022 16:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiKKQAB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Nov 2022 11:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234387AbiKKP7t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Nov 2022 10:59:49 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24424D5FB
        for <linux-cifs@vger.kernel.org>; Fri, 11 Nov 2022 07:59:47 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 754737FC02;
        Fri, 11 Nov 2022 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1668182385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gGl0DKOPZoVzi7R1kWtdng0rcjPljNxL+wihzIqBxkg=;
        b=WESPJkKfW/WSLr943at1eu8jY1kNngTG6XjuZRc/xsMpC2qVoL3YU+jxGuXh0dVrRhZ9O+
        1FMHrzR03IZSkYUul1VmV2630QGrj1k/OCeDtlwuXTJELX7BXsNmg1sdnfWzEAa3geYHhB
        1DAVTkGFCO887KJ7AUqRICB0oRtDgBVuVaMVsV4FU53qOUXSxb8HaufVhfwJwuWI2CI2K5
        o1JFr36/utnitbQnULekYRP6Mm60AVw+6ri4nccfeu5qkpTURBaU41W5LHEalZJFIkTzM1
        QoBep0OOHuAK7SYEJqSMz1H81VztknDQKlwXg3gf1gCoVXUk/TGTdtu2EMfRIQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        zhangxiaoxu5@huawei.com, sfrench@samba.org, smfrench@gmail.com,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Subject: Re: [PATCH v2] cifs: Fix connections leak when tlink setup failed
In-Reply-To: <20221111071212.132722-1-zhangxiaoxu5@huawei.com>
References: <20221111071212.132722-1-zhangxiaoxu5@huawei.com>
Date:   Fri, 11 Nov 2022 13:00:58 -0300
Message-ID: <87bkpdwked.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:

> If the tlink setup failed, lost to put the connections, then
> the module refcnt leak since the cifsd kthread not exit.
>
> Also leak the fscache info, and for next mount with fsc, it will
> print the follow errors:
>   CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)
>
> Let's check the result of tlink setup, and do some cleanup.
>
> Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
> v2: goto error rather than only put connections.
>
>  fs/cifs/connect.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
