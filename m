Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FBEC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Apr 2021 15:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F35F610CC
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Apr 2021 15:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbhDBPmY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Apr 2021 11:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbhDBPmY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Apr 2021 11:42:24 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AEDC0613E6;
        Fri,  2 Apr 2021 08:42:21 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u20so5946881lja.13;
        Fri, 02 Apr 2021 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ggySz5ziFujBJxLBrs7YHDp8OTC2HkWK1c+xKFsqIgE=;
        b=Nz7dQjym5qVZsccPilJbfmOGjEgHU6MXQXCryAUdG0ybN3lGI6mBsl1Gwi5F340fnw
         gmubvWwqdURU3W9hFdxCyhNPvu1p+4RJX6Z+wIYQmnMyPANbC8Xs0K1Qc1mBQ4YuFzby
         LIk5wcLuGcoVsX2RibIRZAEVSk9K5Myr8Pu3yiY25+9FTJyRA+BNBXYdxVM+qtHqn6q5
         r6Ln0yccRTPax8JfcUYyH/YPdCi92DgtkFyZCk6Gb9xxfAgbk8NduhwlqnfZYcKYyRC6
         Hh7y+8VlmQf64Rn56rNL1Ct6jnZK3poF7hWlU6CSVLBX9DSCIwnIUSgqL4/+gQqObfPn
         neEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ggySz5ziFujBJxLBrs7YHDp8OTC2HkWK1c+xKFsqIgE=;
        b=Z/uE0PDJmCZ63uujwD8aAQ3G4ewYh3G//07aSIvHLj0XEaVMT2oD1o60VIMchyNTDb
         RAKFFooq0NpN7dzDfD+B/9R4HLXmNwaLHk0g7jAaYiLiyELcNBKY5e2AvVBQgx9WiYKS
         h4yiTzXMqXRDVC3CF4HQKsJFroNyKcytHUNHWrBiEkEJL5sdgnoNUECI5MomQ+K5rQst
         B9Wdrn6jkJhIfBemvs3ylV6ZdfR3i51fSLXVCWIY4KOtTMi9FwGf3SlqIa8gqxzsWDT0
         /xc4nVWKMQNKSMk4Zw4tWph6DGSM7M11vC8im6F/xCOguLIMha8QIWDSJuC2T/uoE06f
         62iQ==
X-Gm-Message-State: AOAM530T2qYDxRuFtlCFw2hUQwQEDi+gnL8iWDeFWE54BiJrj4BOpFBt
        tdfotsBRT2YdjAfH815gynizDusba5dDeB24bV+FPsjDCaQ=
X-Google-Smtp-Source: ABdhPJyV8JUgqosPubOwp84IVUCKDKLhg6YVBOoZt9qxKxatixf45J3IS0QozRVb6PrEBUw8/o36RQRXg8sJYO1+fUA=
X-Received: by 2002:a2e:8503:: with SMTP id j3mr8627596lji.272.1617378140014;
 Fri, 02 Apr 2021 08:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210401075117.998330-1-wanjiabing@vivo.com>
In-Reply-To: <20210401075117.998330-1-wanjiabing@vivo.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 2 Apr 2021 10:42:09 -0500
Message-ID: <CAH2r5ms-rZPZi9TLE6f4Xoc33B51YKbuT+pVy8xaeNFzg9jLVg@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: Remove unnecessary struct declaration
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, kael_w@yeah.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Apr 1, 2021 at 2:52 AM Wan Jiabing <wanjiabing@vivo.com> wrote:
>
> struct cifs_readdata is declared twice. One is declared
> at 208th line.
> And struct cifs_readdata is defined blew.
> The declaration here is not needed. Remove the duplicate.
>
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  fs/cifs/cifsglob.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 67c056a9a519..ec824ab8c5ca 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1283,8 +1283,6 @@ struct cifs_aio_ctx {
>         bool                    direct_io;
>  };
>
> -struct cifs_readdata;
> -
>  /* asynchronous read support */
>  struct cifs_readdata {
>         struct kref                     refcount;
> --
> 2.25.1
>


-- 
Thanks,

Steve
