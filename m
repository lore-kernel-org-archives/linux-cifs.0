Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814CBC433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 19:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B731611BD
	for <linux-cifs@archiver.kernel.org>; Mon, 17 May 2021 19:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhEQTQc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 May 2021 15:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbhEQTQb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 May 2021 15:16:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA7C061573
        for <linux-cifs@vger.kernel.org>; Mon, 17 May 2021 12:15:14 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id i9so10394081lfe.13
        for <linux-cifs@vger.kernel.org>; Mon, 17 May 2021 12:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=I/en9ExFFAmHa+2LvHenGz+69URsY0wDxMIxqoGMxQk=;
        b=Ko4/dNtbCBmL/maGvfs3hnkppoldwzF4JD9VHcOpIpdFj3qBABB4lkqNRjK4mzWGrb
         bpXKTPyC0RcaT53mYl0MKhbnWKmvx1gF88+ca5VqJSTXx1vK0wZIgNeNhFm9tnRpPKB4
         kUqqQOsbu/ZuXj6zNXouhKp1gIE297LWeAYpJuJisVAteoJH9D/L/QplU1WEMr+BbtLQ
         9Wzvjmp0eih4sxK6xWPMnLq8gk1/C38CN4PZkWxkqVD14BWAp705K+wuOeRUmK4ixJuG
         vD3JlTt45OE0uLlPMNJ0RZ+B4evlCercFzhJ0SXCZPq5D4PIs7nZLlUyaN1z7Wu4b0Db
         R4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=I/en9ExFFAmHa+2LvHenGz+69URsY0wDxMIxqoGMxQk=;
        b=FFpbl6OLZIWD1yGQfKFS2FbKJ6e1O/YGXQEMIhmGVtlPiKUkIZO79aqnB+nm4b8Wkm
         8zwNA1Cr1JGgJ7oEWjdtDuyq5QJOqAvvoPbzqWbUjfzye8GrFoZqpC6KoCRE5kB2d6LD
         bpbkNdzL4HzFWdcDB//I0JdgRbNeP7PTk8UuEIyMXSjPc4uWKAECxNBrdN9PhzfmnzIm
         BN9oUz9ZHQQ/51IIFOsHHTxaWTTG9+w/czuAtlVSNw13EhcCFfl624/pb039mL4eyqXL
         Gp0rRP8ANt5g13cdVYdTA0Cg5fs7DBTDcCaySE16qBR/wtiA6AgO8imFs+l0BfgJVVvd
         YTUA==
X-Gm-Message-State: AOAM532lSWlqz4eCA3zZVpsD/TuLeaF3ypS2I8YSMRRxdZnl742a4lt3
        Dz4Dm/Hd5PSEYnKZU/jnkGSSpuVfY2stfUBeLmE/2CmV8nkX3g==
X-Google-Smtp-Source: ABdhPJyLWjWwloyp15e6xa7jOMua1Y0b27PCptAq7dEeTLW870uOTdVKrGx+yNRyHNypBW1zXuALtyoIFEmr/zAMOh0=
X-Received: by 2002:a05:6512:b17:: with SMTP id w23mr932256lfu.133.1621278911412;
 Mon, 17 May 2021 12:15:11 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 17 May 2021 14:14:59 -0500
Message-ID: <CAH2r5mtOj24Rh8-3fJBz0X2kXY7m3Zt6LZfPqL+YBu_MzT7eMw@mail.gmail.com>
Subject: current Linux client vs. current ksmbd
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed two failures in the latest test run - not sure if reproducible
yet (tests  cifs/105 and generic/464)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/35
-- 
Thanks,

Steve
