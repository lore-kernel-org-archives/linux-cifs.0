Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DDBC433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 02:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiJFCTA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Oct 2022 22:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiJFCS7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Oct 2022 22:18:59 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E8691A6;
        Wed,  5 Oct 2022 19:18:58 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id p89so167433uap.12;
        Wed, 05 Oct 2022 19:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=eGPq4sodvo6Ap9hA+OuAlGWDufhHddw15s6Ys0QiE3Y=;
        b=HDtDXYS75xd0PAP+M6i2luT8JCAbCP0wSNHecW8HBU/QhdM9dmMtCo278eHPByDvT7
         6me3WTvEBgVxj3zV5A3Ro23L5e/AzkXyD+ydc2paazYC7YrZyFOpMxDYznFu90wXL8wg
         p/g/R808ehu5n1OxHs6eisBogkoA7JkX+/RywEZ6iaqc1P6KWsfRNpYNiqVdv2saFU77
         eHGwFHRZf95CKFzj1Yh7CgVbWJQ5bL8afGwmQNgO8+oCP33BJ+h9EJqC8mi9cp16GwTj
         qZORsIXFDOPMig+9wFupUz0X/y82NhvM4MgZowd22av91AGToKBprtBKppqltBTXrPVf
         H0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eGPq4sodvo6Ap9hA+OuAlGWDufhHddw15s6Ys0QiE3Y=;
        b=exw3OFjGfRmoRokzG9yugX9ypUmXkJLuZixgSLqeykqzOM25KaBVLoBiq0+WfJkgdA
         ViIccpLnGPLvcdWxPeuXFq+keOSZ2y0dyw3mppoZSUKR20rqmQaGfSqtPIM7a57urFnK
         YGwIQ2sjogxjcg0YGEhqDiVQVx5eTmfrGR5cgmwFgFYQpcecw4qtZRH8Qj4f0oGJwZD3
         QK2zyCk88OaRURaG/sQKXQDr07PGRwstuU+i0LyDg1UR3GXhncZJpc3CvnKBqY0u0N+3
         ltSpLAE5CJ0pLewe4MqAQuvqmWiNUUfhlMA7wvmDBa0xHoyDqCf+fOhlTF/dgtX5TfyW
         Zkxg==
X-Gm-Message-State: ACrzQf14hWb6b52k8yjmBV7DXVZN7e+ei4f1cj3vhfStqZrqCFrCKKHh
        8hjvo2pikV21mliRYloQjTn7BGk7yCTuemebyqFW8Eky
X-Google-Smtp-Source: AMsMyM5sPGObQZoB1XH86vMDw8pG4NjBxWkzpDRI5o//71KuFWzKAip2PEtTXTZfRD7Iwh1lYDM65RmYHYsJ7JC/fqM=
X-Received: by 2002:ab0:7c7c:0:b0:3d9:d475:29fe with SMTP id
 h28-20020ab07c7c000000b003d9d47529femr1360633uax.4.1665022737841; Wed, 05 Oct
 2022 19:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221006103009.35fca676@canb.auug.org.au>
In-Reply-To: <20221006103009.35fca676@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Oct 2022 21:18:46 -0500
Message-ID: <CAH2r5mtRMbwbpFCBgiN6qJhYkCjAeZ5WL=6gN7yZeq34TDxgKg@mail.gmail.com>
Subject: Re: linux-next: Fixes tag needs some work in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed

On Wed, Oct 5, 2022 at 6:30 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> In commit
>
>   395381a6c0f7 ("cifs: fix uninitialised var in smb2_compound_op()")
>
> Fixes tag
>
>   Fixes: 5079f2691f73 ("cifs: improve symlink handling for smb2+")
>
> has these problem(s):
>
>   - Target SHA1 does not exist
>
> Maybe you meant
>
> Fixes: d689449ef101 ("cifs: improve symlink handling for smb2+")
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
