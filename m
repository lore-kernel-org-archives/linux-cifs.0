Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9FEC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Nov 2021 01:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E09A61075
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Nov 2021 01:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhKABf7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 31 Oct 2021 21:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhKABf7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 31 Oct 2021 21:35:59 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5E0C061714
        for <linux-cifs@vger.kernel.org>; Sun, 31 Oct 2021 18:33:25 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id h133so7313452vke.10
        for <linux-cifs@vger.kernel.org>; Sun, 31 Oct 2021 18:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1jzsi8EbcPg3S5hy9DlCjU1k0fxYkCK8iD6vD4j6eTY=;
        b=JOejFtzeXAE6XPTD4X31PeP0VjtGrwfzR/SM6U+qn3Zww+WJqc08XbYrDNdZmkZN6e
         PH6WHS0AS9plI0jse9yrpa9ttNUOWnnkStkyRLQ6JvbuKX76F7auR6dwM0F4TMOma92R
         AIcuDKRSWcWJC8heRrzxTDD2r9cikZSzh9gObT0gwAVtocvVDvZKJbBF8S9D0r6mysNU
         3ngxawC74A6UUmC1ECALcLMnMvo3UhIsrShTpsWTdqihWWbWxlHi2NF+9PiCB3C8V3B2
         AvnaAvRdHU7JQi6RzHUC9vA5uPeK0M8rwru0ls+R/bY5nqgD1LzjBCpiP3WGW4EXlMCi
         o3oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1jzsi8EbcPg3S5hy9DlCjU1k0fxYkCK8iD6vD4j6eTY=;
        b=OHoiZ7wMoC77+Ml0g3wtHpkVc5nvIjWqi1EaoNsvN1/AnQ9kVXNWHifKmRm3SEtgU7
         xfCYWVeQnXfuB8ZnAFg+9GwGfuaJaTBpLKUho3B6DqWSzUdCfrUDCYmqt+TD8iv6nqfq
         1Hle7l3nUEL+xRKkwG60YQLBLOp7JRGgLLd48xHH/VeE9iTGw9bbqB+JPrv16geZXdot
         82ZpywLdGBF+MCjqlajRXTgqknXdVqM8kzRQEDhJMMk8lmLAAXbgqWZzuj4nMfutbzIc
         qha7Ss6BZNVNbdpyyv1owahELGQUKKYF/jnMom7ps/SBETl2YIMzyxq9k8LORoFt4yno
         cnIg==
X-Gm-Message-State: AOAM530RXZ9X+DLU9GayxriZ4Fo7tDrL0cpUiIjrCzFqhtp5kBHMTHUO
        K2PSCFTw8Dcxj0p65HI02bNLGJ+t0zk1Ucsivsc=
X-Google-Smtp-Source: ABdhPJyuuLkfveKWr8tgCmOrjyySefyguZRBl0GlXfOLK6LO14VWI5uc6tK3EAd8OJ7LrjM6cjwwNW0gvrAtnYuhFdw=
X-Received: by 2002:ac5:c845:: with SMTP id g5mr2474vkm.26.1635730404644; Sun,
 31 Oct 2021 18:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211031010407.11078-1-linkinjeon@kernel.org> <20211031010407.11078-2-linkinjeon@kernel.org>
In-Reply-To: <20211031010407.11078-2-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Mon, 1 Nov 2021 10:33:13 +0900
Message-ID: <CANFS6baZx91yC9tTyndF3NrQgwZtUQm+rMd1X80etwZbpU-wkg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: remove md4 leftovers
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Acked-by: Hyunchul Lee <hyc.lee@gmail.com>

2021=EB=85=84 10=EC=9B=94 31=EC=9D=BC (=EC=9D=BC) =EC=98=A4=EC=A0=84 10:17,=
 Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> As NTLM authentication is removed, md4 is no longer used.
> ksmbd remove md4 leftovers, i.e. select CRYPTO_MD4, MODULE_SOFTDEP md4.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/Kconfig  | 1 -
>  fs/ksmbd/server.c | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/fs/ksmbd/Kconfig b/fs/ksmbd/Kconfig
> index 6af339cfdc04..e1fe17747ed6 100644
> --- a/fs/ksmbd/Kconfig
> +++ b/fs/ksmbd/Kconfig
> @@ -6,7 +6,6 @@ config SMB_SERVER
>         select NLS
>         select NLS_UTF8
>         select CRYPTO
> -       select CRYPTO_MD4
>         select CRYPTO_MD5
>         select CRYPTO_HMAC
>         select CRYPTO_ECB
> diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
> index 36d368e59a64..2e12f6d8483b 100644
> --- a/fs/ksmbd/server.c
> +++ b/fs/ksmbd/server.c
> @@ -622,7 +622,6 @@ MODULE_DESCRIPTION("Linux kernel CIFS/SMB SERVER");
>  MODULE_LICENSE("GPL");
>  MODULE_SOFTDEP("pre: ecb");
>  MODULE_SOFTDEP("pre: hmac");
> -MODULE_SOFTDEP("pre: md4");
>  MODULE_SOFTDEP("pre: md5");
>  MODULE_SOFTDEP("pre: nls");
>  MODULE_SOFTDEP("pre: aes");
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
