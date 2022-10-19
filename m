Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EFAC4321E
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Oct 2022 15:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbiJSPv6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Oct 2022 11:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiJSPvo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Oct 2022 11:51:44 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CE91DDDEB
        for <linux-cifs@vger.kernel.org>; Wed, 19 Oct 2022 08:47:36 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0B6227FD02;
        Wed, 19 Oct 2022 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1666194375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMoY+tYHKX2sWxbud/7EqWtt1KiGxVtUXUerjT5q1YU=;
        b=Wc6fR7HZeINtBJ5SL7QImZMOK+CyGZ5/M+oUL7tZJrFgQPIUoYSZhS3FjxcTNplqEugAvl
        3w7ka3Ki6Er+FPcC0Jmm73KZWZXlBvVUWH2jWgKzEEBCc08UMoUnWNpWW1VZ3mRuyWS01m
        Lg5p+KRifYvy4qK+NvUIQrjGws+bdtBLj6j3c14il2ojvNlQmeXy8dBj8EhaQqZOw09GbR
        bvl/ArneZSRLiXSGE95yPv3yf6NRz94PPEAWgoGm5U647HPmpwOUEkP3TZ6kKQ7yAC84T7
        sWYlz6KV3+QjADgC5AbNHqWccmUeD3tJFI1Uh/l2asVsW3zJiPazHYtitV6Kjg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: fix memory leaks in session setup
In-Reply-To: <CAH2r5mshYDHUPyJ2ZysirA-jhJonTQUvhvMC4Q0xKOuTo2Jb+A@mail.gmail.com>
References: <20221019142537.23718-1-pc@cjr.nz>
 <CAH2r5mshYDHUPyJ2ZysirA-jhJonTQUvhvMC4Q0xKOuTo2Jb+A@mail.gmail.com>
Date:   Wed, 19 Oct 2022 12:47:15 -0300
Message-ID: <878rlblssc.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Is this a cc:stable? or Fixes: tag?

Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
