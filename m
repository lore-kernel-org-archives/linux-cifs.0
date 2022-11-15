Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4819C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Nov 2022 19:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiKOTHX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Nov 2022 14:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKOTHW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Nov 2022 14:07:22 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC08213E85
        for <linux-cifs@vger.kernel.org>; Tue, 15 Nov 2022 11:07:20 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id bp15so25884081lfb.13
        for <linux-cifs@vger.kernel.org>; Tue, 15 Nov 2022 11:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5YokOKGVYUFmXJ7sMkSANG7OKZJbZMJNrmda7teqtIc=;
        b=QKlEx6oSCkZ7yPfq51u6Y25M+JsWbBdv7/g4g+fxyOqpHPFTJbdjtckdaBfLclc5wf
         V54/yUqUzgIWWH7gJF8Y8rpEbfFpFLbgC+KHVZnro4S4yUkXuakVpju5lcseFDGJc5qq
         ugPubfbrX/qiVyFlxQGrEuht0XfcOJyxnkH1XbI2a/qlR1dwMwATkDVz8ixv5+rANNFW
         qn3wjrLRynMBXL9aKYUpuSys4/pKwCnbAI3ELdc9MXbQ7PdjVz1RWu/ee+4+dD3xv79B
         Am3ClzmdhiswOrACi/Blt6cVxbDe4uEUTSOtrdMiP5DMjMWjoVj61ygEnyvxMBcxiE+T
         Wg+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YokOKGVYUFmXJ7sMkSANG7OKZJbZMJNrmda7teqtIc=;
        b=HaTKwhrCE3Bf31p/4DRVw46kJdlEw9qMLJTisr6vjkqYVXtAQuKa9XbT3SMV+EgLIB
         iRvjq+W6Qn3m41tx9/ABCPG5ENOyoal1xSdgelQZr/ef6E1zX9LV2g494FqZZpVMsz89
         uDR0f7CviKe3hadWMV1hspQkAUeeuofYngMeBCtTcAnAKuBkmwVBTDTubNgTlRyREBAs
         GxfQMZWdebNXErcR79Yiu5tHjbnvcR41Wl009kBbcSxjaEDhWewPxzpD6o0h5wYwSjKT
         QAtnn0wFDPFx1fJT1oQx+c2szL1RaXCSH2zA83JvoGTYvKYmCtrJEoQkAwwL6RDhiPOC
         cjtw==
X-Gm-Message-State: ANoB5pls60o1z+JQ1Frf/c/wSu++WZx6vMcJhtJGeaEDaZVNAKl96ZNa
        V4IavTvhAYY1kSq6d7ypjMiYAWq4OXO7wIfOwOk=
X-Google-Smtp-Source: AA0mqf65dijrMzfGhX+DaJhZyW7lJvN2wmir5qb6hAPVt68z5doLyzPFJ9WGJU2P0+zBWUIwEnaWDqIe+bi+vfx24mk=
X-Received: by 2002:a05:6512:138f:b0:4ab:534b:1b2c with SMTP id
 p15-20020a056512138f00b004ab534b1b2cmr5811592lfa.426.1668539238577; Tue, 15
 Nov 2022 11:07:18 -0800 (PST)
MIME-Version: 1.0
References: <20221115103936.3303416-1-zhangxiaoxu5@huawei.com> <20221115103936.3303416-2-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221115103936.3303416-2-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 15 Nov 2022 13:07:07 -0600
Message-ID: <CAH2r5mvxC=8Pe5SJ9HHyCbNFo48Xfzdyyji-ZqPnZMD28A1tog@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: Fix wrong return value checking when GETFLAGS
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

good catch - merged into cifs-2.6.git for-next

The other two look reasonable but I wanted to do a little more testing
on them - feedback/reviews on them welcome (especially patch 2)

On Tue, Nov 15, 2022 at 3:35 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> The return value of CIFSGetExtAttr is negative, should be checked
> with -EOPNOTSUPP rather than EOPNOTSUPP.
>
> Fixes: 64a5cfa6db9 ("Allow setting per-file compression via SMB2/3")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/ioctl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 89d5fa887364..6419ec47c2a8 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -343,7 +343,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>                                         rc = put_user(ExtAttrBits &
>                                                 FS_FL_USER_VISIBLE,
>                                                 (int __user *)arg);
> -                               if (rc != EOPNOTSUPP)
> +                               if (rc != -EOPNOTSUPP)
>                                         break;
>                         }
>  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
> @@ -373,7 +373,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>                          *                     pSMBFile->fid.netfid,
>                          *                     extAttrBits,
>                          *                     &ExtAttrMask);
> -                        * if (rc != EOPNOTSUPP)
> +                        * if (rc != -EOPNOTSUPP)
>                          *      break;
>                          */
>
> --
> 2.31.1
>


-- 
Thanks,

Steve
