Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF0FC77B7D
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 06:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjERGaq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 02:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjERGap (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 02:30:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E582B1FD8
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 23:30:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-95fde138693so171867566b.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 23:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684391441; x=1686983441;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ys29LIwa4Bgb8NNoDjiMh6Rl/wMPbmttk6wklcbbtPY=;
        b=rOsuCmjwZCNbDgFv/eLzZ9Glykdyep/qRkk4zo3vEA3le4vRZyxcG47DdF1UZ7kWSK
         ktvXPR1m1BiQLCZZ2JR3ojDTC3tNDgsHgUlXndhIl0hZfKiKWERwkRvmjzrHuMGjhW/Z
         1AZyeBVNQH56jAW80QM21xhd0nyIuWIkFniAZBG+IcHJqmS891AVwsX3FCwsQ38u1TMC
         ZtOPV6fwNas+RE65KYxwcZX7BYY2E6UVkYZILBifvUxrCoA5TsbI6n4bTf5U7d2PdrIW
         YN5Etq1PYi51YzgQO1rEXXNmWYaboUVmyZl4gyiW8ttr2T07uQj5Mxnz4FT8n82yMIRP
         M6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684391441; x=1686983441;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ys29LIwa4Bgb8NNoDjiMh6Rl/wMPbmttk6wklcbbtPY=;
        b=XsfZyKNY9o5f1q371pyZpckLD/r0S1AjPz2wIM4t8MdsXte/5BsxRgE1Yuev/9E72f
         DThxtwK+ZDTt+G6doFmJ1oGO8vx7JqvYi9QFHM5+N2WPmEakgl701nLxRqXwvNtYu7On
         LjIMbgdFB2ky/wn6wr0NlEgzBoYwc4yrmnzB9KAiTjbkqbIkNv7GaEJv3GF1ETzCAK86
         yjHutaXd9BonaLFUacWjcXvazT/Pyu82D6/Lgz3GBnlFSldIA+givP5jWjtvQMGFX7tC
         kIRYOR9kym2EKShtO+2WY7B2X7AxIn8BBb6L1RC+quzu/UR23KHhTsb1AjNy7TsvyUne
         MUzQ==
X-Gm-Message-State: AC+VfDwcCOp4vAqWj0f3BO0rWAvVepGaxolfM8SFv4M6q0reYJByYHll
        /m+4vNvjR1eLdahADeEAeFt+H4myztIaFTz4GGysDMXh54dN5Q==
X-Google-Smtp-Source: ACHHUZ7y3Gmtx4aaa6bCaHhc0r0KC4iLR/qozQ0V5Xbmcl5SaZb/Rb4Aviec1m2WkIA1/yp66cCAvvZsoi+uiNidHlY=
X-Received: by 2002:a17:907:a407:b0:965:6a32:451f with SMTP id
 sg7-20020a170907a40700b009656a32451fmr4269734ejc.6.1684391441075; Wed, 17 May
 2023 23:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230517185820.1264368-1-h3xrabbit@gmail.com> <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
In-Reply-To: <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
From:   Hex Rabbit <h3xrabbit@gmail.com>
Date:   Thu, 18 May 2023 14:30:29 +0800
Message-ID: <CAF3ZFec9Osx4h1CVaWc=w5p71hwHuX-bZCghtcwbgPRX6bEhvg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> You need to consider Ciphers flex-array size to validate ctxt_len. we
> can get its size using CipherCount in smb2_encryption_neg_context.

I'm not checking the flex-array size since both `decode_sign_cap_ctxt()`
and `decode_encrypt_ctxt()` have done it, or should I move it out?

```
if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
   len_of_ctxts) {
    pr_err("Invalid cipher count(%d)\n", cph_cnt);
    return;
}
```

```
if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
   len_of_ctxts) {
    pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
    return;
}
```
