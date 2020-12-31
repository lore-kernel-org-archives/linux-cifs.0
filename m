Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4221DC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 19:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03F2D207C8
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 19:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgLaTtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Dec 2020 14:49:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgLaTtu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Dec 2020 14:49:50 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7BC061573;
        Thu, 31 Dec 2020 11:49:09 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id m12so45849562lfo.7;
        Thu, 31 Dec 2020 11:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4GADhOM3Di9puOis0bQoYcmPc7qddXCQPPvPPHyXN8=;
        b=TZit+ZzpGhp+HstDglk2xvwufzq5vwAD6YVTIeLC2EKa9ovWoXhOWSQzksvKm5hyeW
         vv83RGbTT/RXmmG2g6Ao7bAw9T89m4iw1QX3t1ltaidvjLLPd/eIPJg00O4pk4ZWMfkW
         0j8qwoeWcgMFPMxyUxdmHFGjjlELv2XhIZhJ3ulNIiYYLgomEpfT9/P4KJD7pp89CDXU
         vcFI2xJjz+h1eTZ1My73fFvYH16TPO3xiFA4+/byi90kuhM+JYN5/Cf/uHzBiUGPIls6
         jCCDXPajjR8yuai/Jfj12ITdIONkO6rBZv1ytpqNZ36pJnnZ9o1I1/biHqbfXwNDNC7K
         mgyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4GADhOM3Di9puOis0bQoYcmPc7qddXCQPPvPPHyXN8=;
        b=lL5Gbqrk3x/nzk5CHn3QNxAu/N4BT2ohp7AVtmdD0SOd1ud21w0w6+myLHzjVIIeo3
         ExzEHHKAmfSqwi9oyzGpsXuG8qRqUQVENWIndNoarj5CoAEqsxkOwJs4IZQZTifL4FUZ
         Jo9dfmWueRgWpgoiMF7LCmQE91rcHiB+wzdmCLiyMj8qRMJ5M4RzlJ8bu5yVFJ4Ew5dk
         fBKPryTt03Yjevf6YodveYkw6ThFZkme60t6VwWrtoOcUuMyNqc4+6lsMUvj6VDI9anS
         m7BPJzM93SFj5vePTfI7WD93BMD6rFv3QpYRreTO8dKWAxz890P3G/jDHlY0jfPLUbGn
         J37w==
X-Gm-Message-State: AOAM533SEJgEa5354LG8HNEbsYOGa8zTeLo7qKGLTodbaBcvq3IAWPKX
        Z9nf9P+Wv+c/69EFESbmysoJEr/i7RGiMEXVIOy2yrZ2GEM=
X-Google-Smtp-Source: ABdhPJzh0FiWoAo5nbILBFboXjTjGWuHbZudk/ItyhPYbOzhyw2Yoeia6xoE5mC6mbYqHLE1SMbO3mrJ6DyMaHBpaZI=
X-Received: by 2002:ac2:5689:: with SMTP id 9mr26659052lfr.175.1609444147846;
 Thu, 31 Dec 2020 11:49:07 -0800 (PST)
MIME-Version: 1.0
References: <1609310145-75787-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1609310145-75787-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 31 Dec 2020 13:48:56 -0600
Message-ID: <CAH2r5mtvuz+Ro2Y7upQQcmSk2Q2sgxykYrKgq0wmhGPKjEeJvw@mail.gmail.com>
Subject: Re: [PATCH] cifs: style: replace one-element array with flexible-array
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Dec 30, 2020 at 12:37 AM YANG LI <abaci-bugfix@linux.alibaba.com> wrote:
>
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use "flexible array members"[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
>
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/
>     deprecated.html#zero-length-and-one-element-arrays
>
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---
>  fs/cifs/smb2pdu.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index 204a622..d85edf5 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -424,7 +424,7 @@ struct smb2_rdma_transform_capabilities_context {
>         __le16  TransformCount;
>         __u16   Reserved1;
>         __u32   Reserved2;
> -       __le16  RDMATransformIds[1];
> +       __le16  RDMATransformIds[];
>  } __packed;
>
>  /* Signing algorithms */
> --
> 1.8.3.1
>


-- 
Thanks,

Steve
