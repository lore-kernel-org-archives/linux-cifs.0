Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CF0C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 19 May 2022 20:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiESUmE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 May 2022 16:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243853AbiESUmE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 May 2022 16:42:04 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAFA39814
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 13:42:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u30so11069907lfm.9
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 13:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=WbbrgtXffDQrx7eylb2BFA8SEujlV/fvAbIXmU6lokw=;
        b=QFKUS/tPsjm6UkGMp3R0bW3xW5Jm+YQuhV3DvNGK4fgqwXyIQeb7/dmD4n0OK44Haa
         ct/4Q1/2DHEY9I/SjyRVVr564GWCiFQGbUEccBxLh4qnMo0+BV2PZm8Yy2jR/q0UtWFN
         kJVJneE9SJNUvw0ryy2XjBt0+NEANGLhKx3Ms6Bk7LqL0SuOG7Wa1g8tsEpBLflcwDi8
         7IhfeNnbYdg0n5dnDP7aev+4nbCGF7jnmJS3ctEHmoJ8r8J3ezmRg5alRgdhcWXvG/57
         AfCwtV8khpTnKUwOpRME04uw+oKz2qmCsqKXTifSTVdEzwB4zN6zCvYUoNE3ivzpKY0p
         IVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=WbbrgtXffDQrx7eylb2BFA8SEujlV/fvAbIXmU6lokw=;
        b=Zx0t9Ms3brLurtfvTqj5xMktYnL0X/DYzMEWO/WNeb+pnPxfWoDWovRC47vXpK0j+k
         3z/kafKew1hD+qyY4+lTCmSIZMDM9P/MesdkJYbaCRJokyRvdp6MsfKw9o/7ZSGSOEzB
         F2Y5Wcti/njyzXXh6IscLyqhvhHDzD7gELwVdndEQ0pnnQK6H7SVdieD1fK13xFvwenf
         5M5W8SLCkED+fnx8g4yFmFH6eBVqxdTlo9ZkmGS+DTYKBeuAHmwa03xi9mruBG5pyQhY
         r/ULKLOlgKZM54jCaJ3I8nPJMQzC6BrPwewOAklKjebT98gnwiOrLfphu5ErNJXMXr9U
         pBfQ==
X-Gm-Message-State: AOAM531Z35BDjRewzeVCga3qKfiMSlOZJG5AbIyeZXB62wkDEcp3q+YQ
        YbeZGlNdFXJRozB5zP9ltMvl/Lm4ZPFZvUXHnlE=
X-Google-Smtp-Source: ABdhPJwE7CZe8Dt+8XNHcAs9Udd1gyD1umPC1C9W1CLF0wWMB9GlMAFNgOJm7CDGh2hx40qNfD94KpGmmDu0MMmfHe4=
X-Received: by 2002:a05:6512:3451:b0:473:dc7d:4d32 with SMTP id
 j17-20020a056512345100b00473dc7d4d32mr4382997lfr.667.1652992921073; Thu, 19
 May 2022 13:42:01 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 19 May 2022 15:41:50 -0500
Message-ID: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
Subject: RDMA (smbdirect) testing
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae and Hyeoncheol,
Have you had any luck setting up virtual RDMA devices for testing ksmbd RDMA?

(similar to "/usr/sbin/rdma link add siw0 type siw netdev etho" then
mount with "rdma" mount option)



-- 
Thanks,

Steve
