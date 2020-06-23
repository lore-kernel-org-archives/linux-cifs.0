Return-Path: <SRS0=n4et=AE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA417C433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 19:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBEB207F9
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 19:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LeJIgsST"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387446AbgFWTCB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jun 2020 15:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733302AbgFWTCB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Jun 2020 15:02:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A32C061573
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2020 12:02:00 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y10so8321401eje.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2020 12:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6bTjlis/JQxZZYEX63I+IFlfqIZ3AlM1gGPkUH9Y0xY=;
        b=LeJIgsSTyhtxyRT7ufDl18n/squxHPhhWXtI+KsbA+nXXFFNm7YdMBZfv9noe/fViT
         PCWcybK0LmOioHKb7iE4b3YIoEw88BNZu0dSP+4J62yJi1NFdA0/MP24STsVNLI4yyyh
         20ORv/+74i+18JqLHGnKQtq4OQeCvzmHGOf+zIxmQ4px9iM3qgCz65XdOEr+YR8JKYv3
         vpKI3FKMaiL5KzjGO9dl81+Cj06t7UtR0MvsnvIIrnGwiL/BG9ftaB4/br/akY4hvv+5
         +Su0ghjshvTU9D/UkXwk3o6szB45AdKzbq5Th+gDJ5AztUu4WrUkevikmbarR6XVzY3U
         TlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6bTjlis/JQxZZYEX63I+IFlfqIZ3AlM1gGPkUH9Y0xY=;
        b=q0y8GBBixM5oHpcngjgtejQZT8gE2cZn09CJle71ZeAauZ746g+q4C4izy5npAorUP
         ib31ysrGhgF61G4NpHh+IX/2SZ3g42cODwp+bTKjcIkfpFbZLvNMYM73b7QJBOq2CtGe
         Z+tsSX8s0AkWyA6WCwYVVh2qRz8+YsaCMAXyhflANo2IJgP9XCmE9XW1f6iUplOCPhaL
         XvYFCZzR/EG1jHkunaHvd37wyTL5xILcsjF5gMAtlHw2ZFm8TRSEAG6hegIQ71Dm5MYV
         UTgvdG5KOxwK+CIn4EwVhupHdEthKCCVCZd3K/96ZNntm72GP7OU4gdeuDJeLiosQ0Bt
         JDxQ==
X-Gm-Message-State: AOAM531kxvYQCJcpYReU82aYDdn7/L3atQEc4adKPPD4ZUUe5XCYoBor
        r0LjEyXe7A40eianWoIGsn0SsRPTwPkcyNUL+A==
X-Google-Smtp-Source: ABdhPJwCSc6O5p71X4RctvdCXd5SGwSqeT8Kru9BCBBkm8WHi7UJodgV1B81sB9P4QDnZgA5D0YBZEQGt1OydMaXWMk=
X-Received: by 2002:a17:906:b748:: with SMTP id fx8mr781819ejb.341.1592938919478;
 Tue, 23 Jun 2020 12:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20200623113154.2629513-1-zhangxiaoxu5@huawei.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 23 Jun 2020 12:01:46 -0700
Message-ID: <CAKywueRq=kAVK86DSLQRRREvND7z8sQ1prv60Y_eTRp3Vd0J7g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] cifs: Fix data insonsistent when fallocate
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 23 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 04:30, Zhang Xiaox=
u <zhangxiaoxu5@huawei.com>:
>
> *** BLURB HERE ***
> v1->v2:
>   1. add fixes and cc:stable
>   2. punch hole fix address xfstests generic/316 failed
>
> Zhang Xiaoxu (2):
>   cifs/smb3: Fix data inconsistent when punch hole
>   cifs/smb3: Fix data inconsistent when zero file range
>
>  fs/cifs/smb2ops.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> --
> 2.25.4
>

Thanks for fixing the punch hole code path too!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
