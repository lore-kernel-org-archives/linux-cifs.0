Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16068C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0B264E05
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 01:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbhBJBQM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 20:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhBJBOK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 20:14:10 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773A6C06174A
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 17:13:29 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id u127so268329vsc.10
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 17:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=kAjTSovJCoMxG4OvEV05URfeIyx7H7PF8m+xWUNSFek=;
        b=Q0alT5GlcvArUg+uG3yfzGf3j+150wZpmKeIyIy7Oh1oshuXPfQBsTn+gaZ1rJH6EB
         7SEajAwdpHwHHLVFpukV8yhiFnFi4Y7fSHTMv8tviyDQ0lCMNyfvaaslpcxRNsv3mnTN
         d7RCViEDxGb9ALxXFI2qGcMgyib2iC1IidYWt9CM6f63fxPW3q1yC3xNrL0JRon2BOv9
         LOT3Cjnqlm/xp3Q9FbGFqiFAqPkS7TiIahaiZsOABEbrW9R/cIypYPXyiF2S1fE64HK1
         LJsW/HjQgwFjOlywWhzRjwkKAWOmWYbVYGSuAPw6RF0dapsN1hBGSDTcZLJwLyVzik1F
         5NbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=kAjTSovJCoMxG4OvEV05URfeIyx7H7PF8m+xWUNSFek=;
        b=Dlnd07rxjQoOXZ1zqzB3a7G/sEhcEdevAOLKFEPFRaQ0ueGR8OMi6DRxtsYkjZbqZs
         rQ3bEYwLBTfhhJW/RJ/U8CHQitre9qZ3v6b07u0qFYFHCeJQ6PFeT8ySxU5hZDToTw0e
         +9tGFIEXZy610vePt9vn8oIkEZQQ0dyN5Zcgr/3G9SGY8+iEaL9efaXM/yR1Cv7ywSjD
         qWvzH1V62iptf3K9gEDOybdvhzeI/NnZVppRT2IICCsV6vduqv8NZFjLNjVxTxS/2dkD
         1q69Zmgh0RKUimO18vScSTlAztkB9lGqqF/+ZAANzomemkuG8qyONVVUbWLRakVE0YSk
         9Adg==
X-Gm-Message-State: AOAM533Nl2tC329Tciun37ykiReIcHaAa+IvGxPwU9MQnR+3HOs6LPH3
        BsMVFeJvARPgS/OQ5CgZzI5FSoHwH2mfOMGV4s4=
X-Google-Smtp-Source: ABdhPJy7fGACZ+JIFoiN9Qpzf81APvm2RtG6E+YRz2XSl8fm5ALsq0kfunp0Zdg3XfOWCWWMqbxAELtnYIxMMlTPPxs=
X-Received: by 2002:a67:ecd5:: with SMTP id i21mr400697vsp.18.1612919608765;
 Tue, 09 Feb 2021 17:13:28 -0800 (PST)
MIME-Version: 1.0
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 10 Feb 2021 10:13:17 +0900
Message-ID: <CANFS6ba33DORg99OYHwaD9yJ+r6rt8A7v_R36_Uf_hHkw=agyw@mail.gmail.com>
Subject: "noperm" mount option not working
To:     lsahlber@redhat.com
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie,

from the commit 2d39f50c2b15 ("cifs: move update of flags into a
separate function"),
"noperm" is disabled if "multiuser" is not given. this happens even if
"noperm" is given.
Could you explain why this is required?

Thank you,
Hyunchul
