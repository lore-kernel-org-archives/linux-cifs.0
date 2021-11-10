Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01845C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 16:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC86461058
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 16:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhKJQoK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 11:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhKJQoI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 11:44:08 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36262C061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 08:41:20 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id f3so7347050lfu.12
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 08:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=d4Q45xU1Wk2bRrrgcfr76tGMplqiY/cosdBysHdNoUg=;
        b=L59VOzEQOC63/HqrE/vZQumbKIJKy6Sl1i01KK0dj+AP4cZN7s1R1tVg1YCHQteirq
         R4b+meoziTb4Lesl0y1U1+QFoaufEMFf5Ar5eZMDZY+7VFK98A0si23PyhQ+JFnFzy01
         WsWQq/ClxqjY2LIMIljI1NSq8IYxHa4IZaXhwM431msBm/W1mmiZZyVmK0RK3OfTG29b
         h3+hhlxN77SFCAeu2pebRHwhCxotxP61kqXS/ytCyTLOEmH4Kk9jPhCudU0yC+lBaEKd
         yliUQ5SmXPHezgBbofRlIWRgNImbYOZ5bWUXXYvsuQL6BBI4P8bQEKHF4Gnoj5uPkEyN
         m6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=d4Q45xU1Wk2bRrrgcfr76tGMplqiY/cosdBysHdNoUg=;
        b=CmE8ONzzjMKQF01WUbfsd5I7uuR/ObK0BqrkUqcdCnX2yTlblUap9K0ba5/5c5I0jE
         HAbHSGLg3qasSJv0RYuPySUv9IvfsFpj6C4Zd6iX4ijCIEB5rpx76xpeA7IiQCwa0frG
         i3gm6a/MJqCVwSZLucE1wArf9Lpd9w0I+neliuE3Z4bmeM0sh+UJltqa6Zc5CvrRi01d
         i+9I+IiMUXhBIjZd6iZ23/2D3pfhPGl7N97cUqTGf9kHbahwvzgZay5H4iuGJq7BxL1N
         olfqF/w5mzNG6eGzDIC9vmmPR2hf6cd4+slzNRA/KM9xGSDpj5uXFuaUgXVC+JOX2+z6
         /rng==
X-Gm-Message-State: AOAM530OSXuh9X/XA3ZY4byd+65XYyy3KDQy2NU+1+JD6Zdcgd5joHL7
        HifxT+17QPFgO/Sk+LpqDw+/yncbMcPKxG3g95qk2Se77OM=
X-Google-Smtp-Source: ABdhPJzJDFezjpvZQt5iSKoyWKgduF7FCywpiA7adebsmaRVyd2wwIZ87pZG2l5bAKhlKcU98fWA3XoKizB2nKP7QtY=
X-Received: by 2002:a05:6512:3991:: with SMTP id j17mr376096lfu.545.1636562477094;
 Wed, 10 Nov 2021 08:41:17 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Nov 2021 10:41:06 -0600
Message-ID: <CAH2r5msdAjuFxup-MehxEFvtr8BFW3WwfjjK=STmvMtiUqu0GA@mail.gmail.com>
Subject: current ksmbd-for-next passes regression tests
To:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The fix from Matthew Wilcox for the readpages oops worked and
regression tests passed to ksmbd

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/93

-- 
Thanks,

Steve
