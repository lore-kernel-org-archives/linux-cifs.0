Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168C6C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 04:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiCSELw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 00:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbiCSELv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 00:11:51 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7AD1BE4D9
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 21:10:31 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m3so4909648lfj.11
        for <linux-cifs@vger.kernel.org>; Fri, 18 Mar 2022 21:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=8wUVEGYVIVJbX4qefJS/+iJBTfN80xAnakIFBhGe5n8=;
        b=EWA/uHGaZ0eSqvnYh8cuj2cp/HUjZHZyD5q2+VZ8p4XNRtak3nrySPwEQq0+ZlSv7m
         agmwxNkRROEr/lrt2qWzKQfmv3GVR/W8DAkKVzRLwFSBtQsoFIi58gZT3lqii7mNZk3J
         JZBOg3FzZBdkVsjY6db1gGgOp8ANiXcZEzduEdNij2z8kd5gPpoc4bLxOSEnCKIZLNzg
         AsEu59OsZkFzEzWH8MpoUtc6Wd0Y3FORR71IswCcRyu9svlEwi+5nqpf4T/Ynd+omPBf
         OD2Wu5w342zXBKQvSkZZ03A74t+QL1IkY/Cx5dDwGBb13LQYQVkZXISZwvR76t/fNpWQ
         pgqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8wUVEGYVIVJbX4qefJS/+iJBTfN80xAnakIFBhGe5n8=;
        b=lUVpsw+74gpBnuu+jqCzZ2dwwl5gmPwpaBETO+36NkEAU1P7fpfbUDiZJzoMVR7Mwh
         h1bZ9xR9LBiGtMAQ0k8dgbLw9w7BvlDbqL094iytzJ5ADXT0Eyl95HIodcdUmMTxI5rL
         P0HWWA5fVXADif0nZJJmY+2x9qImzWf3ch49eOdSnD27vKcakJI2K3KWOb5htNdcf3a6
         OPuJA3ttUa/Q/ME8KUA3UkAl8ePxvuXpA/+W918zr46HlG1I2iOzRdv1qrxZyiNWmhC7
         Cw8GwhZ4CAPzcMtUfsi33eNhrPHL7Xd4DGGORcgCg24XsnX4yTuGuEQf9/7zBODCi1lv
         PEXA==
X-Gm-Message-State: AOAM532r/WBIj3UbYbCJoLOtaeD4SH8p3i7ZMe9kLPVcmfOS4s2nZmCX
        xigLlyhZdgtw05ZNpObxu0Hodrl42XOXBbJcDFBMuQWoa/M=
X-Google-Smtp-Source: ABdhPJztrcXB9CqLmm2C8viI1uZV56XTswBdifvKPpuoPJS+J123DWhrVd6VSOgkLcE2K3aVL+oZS1aGOykYXEvLBIE=
X-Received: by 2002:a05:6512:3d12:b0:448:5f9f:92ab with SMTP id
 d18-20020a0565123d1200b004485f9f92abmr7939811lfv.667.1647663029229; Fri, 18
 Mar 2022 21:10:29 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Mar 2022 23:10:18 -0500
Message-ID: <CAH2r5muJaVBkWeW847yn8Dz=VoTXg=FEKyBHy0KJannzSbHmzw@mail.gmail.com>
Subject: does "cifs: we do not need a spinlock around the tree access during
 umount" need to go to stable as well
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since "cifs: we do not need a spinlock around the tree access during
umount" fixes "cifs: fix handlecache and multiuser" (commit
47178c7722ac528ea08aa82c3ef9ffa178962d7a) which was marked for stable.
I marked "cifs: we do not need a spinlock around the tree access
during umount" for stable as well.

Let me know if you want me to change that.


-- 
Thanks,

Steve
