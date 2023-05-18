Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33251C77B7D
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 06:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjERGgv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 02:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjERGgv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 02:36:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1916AAF
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 23:36:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2CC264D34
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 06:36:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB33C433EF
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 06:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684391808;
        bh=bxlpyMdqiY7zodM75yx0aX1fdE3Q3pn7UPxt/8c8ZKM=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=oa4NJmc63xy9746Af39GrLElUJvvHpNv5tLp6RnUmTOaHSTYzNGraLG7QY7bPN3rX
         0RBwLBX+ShwbM7fxrs19wMFucWvU9CLhKjxW43QF4EB0/IQJEl70pbOScXqNa7MXZg
         Wckq0/Yq6kzpxv3tvbfWAU6uVU2PHW4LNKqk1J32t9cPBjZiT597umDT+n6X3iDa9r
         Oh5v+g1ML6PrHJ7JP+vLDLrr5UB1OLSAWw9zrCjTgDvT5n0/JsNmN+Mhc+TuqLxjmk
         UyEFhcWWDGcTII8/MSGMcxKMyQXqW4PZxiv02YLxc41QjAvSFRGvyb4I5oy2FvqlZ4
         T6m6oOOIR/YYw==
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ab2d14e999so1203633a34.0
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 23:36:48 -0700 (PDT)
X-Gm-Message-State: AC+VfDxz0p+LF4qsNLBwp7BYqU4mU1lPbVcsRk6ilByAlF/tYuNrMPKV
        X7160uf4jd4hNMlz0e194Vubgsa/x8+WKf5ZKuM=
X-Google-Smtp-Source: ACHHUZ5gYFWaeLgo5ik4EfNjRaChXxGk2TcUcKkWWbp4VFjq8xu1YZ2IA4qqTTqaA2gefWLTyMpD62IUb6/S1shSySw=
X-Received: by 2002:a05:6808:15aa:b0:396:26bf:d692 with SMTP id
 t42-20020a05680815aa00b0039626bfd692mr991402oiw.3.1684391807122; Wed, 17 May
 2023 23:36:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Wed, 17 May 2023
 23:36:46 -0700 (PDT)
In-Reply-To: <CAF3ZFec9Osx4h1CVaWc=w5p71hwHuX-bZCghtcwbgPRX6bEhvg@mail.gmail.com>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com> <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
 <CAF3ZFec9Osx4h1CVaWc=w5p71hwHuX-bZCghtcwbgPRX6bEhvg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 18 May 2023 15:36:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Lu_NQKH5Nc8aPibNtBXj_vyLj5=bWRokZyLE6vK-Bdg@mail.gmail.com>
Message-ID: <CAKYAXd9Lu_NQKH5Nc8aPibNtBXj_vyLj5=bWRokZyLE6vK-Bdg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Hex Rabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-18 15:30 GMT+09:00, Hex Rabbit <h3xrabbit@gmail.com>:
>> You need to consider Ciphers flex-array size to validate ctxt_len. we
>> can get its size using CipherCount in smb2_encryption_neg_context.
>
> I'm not checking the flex-array size since both `decode_sign_cap_ctxt()`
> and `decode_encrypt_ctxt()` have done it, or should I move it out?
Yes, We can move it out. Thanks.
>
> ```
> if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
>    len_of_ctxts) {
>     pr_err("Invalid cipher count(%d)\n", cph_cnt);
>     return;
> }
> ```
>
> ```
> if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
>    len_of_ctxts) {
>     pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
>     return;
> }
> ```
>
