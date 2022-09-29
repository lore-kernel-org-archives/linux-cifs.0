Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A6DC04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 04:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiI2EyX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 00:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbiI2EyW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 00:54:22 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4021181FC
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 21:54:21 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id q26so351656vsr.7
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 21:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Mx1+Ok50Mdf3vBcixQVMQ7nj4e0WbOZI3BBrxMJMLgE=;
        b=NlW7N2A/TEPkH++hbnf/LaW/KGHOBxhBpkQY0aJZM6ffvrGx/PmvgfN2MJBreuY//Z
         WhSNWe8HVvdDJo/pU1y5hPkHdwaGlFT6D2CQvohUXNWjMz7ozBwifyJ5p7lAFHSm0PmV
         JZb85tovxw/WjjnwLBHYS4SRsyxm41qEZ5It5NPhqMW0ronJFYpQ8P6S+qE+98o0TA8B
         ie73My0FI2VCUPnfnlxC6GUQgiztMUyfT5UcN4TxAbgNaxyzmpMl+W8J2+fs6DSiw/Qx
         TI0kGdx14e1ypQRD7bLJFCW7M2YHzvM9Cwfx4HaJzYpK7hCHQMJRO/Hetj3sBs3uXmVJ
         R+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Mx1+Ok50Mdf3vBcixQVMQ7nj4e0WbOZI3BBrxMJMLgE=;
        b=zorK33kJ4vLd0Q9oegKT27HoAWZnu6FCRKtUF3AJrKHd6+Zh2fQyzrMOw53qrH49OB
         uc70hchm9xDrOZNZIsV3NQKjVWn24fHdonJKCjHcR8Jg+buV+EakJi/1pNXXb6Z5GWlq
         hlt9Km6VBKT2kDv9E4LVSGMDdMZ45UGUWflvIDom9SnCvn/82CfnqH7sfohhcqZ3t+AY
         hUwr9dB/y+4PaT2DZGXVUT0usDO4scN/k7xejBpOvwiqoPUoJTgtuAyk1Kcm6u3mcdFb
         ua7RlBQp+Kh94jgAd/Ht7Ms1isz0MHotVOTkW+eNOslUJr9ZiM/naV6mwT4LAkm2qQVl
         Yy9g==
X-Gm-Message-State: ACrzQf3smuKq+4xA+50yLnQSjDCDjHOInGmZfS83yAKyA/092Cvs7Cnk
        7kNirZ8pFlrIRVs63NPFXnAzsO1277IR7SKijCw=
X-Google-Smtp-Source: AMsMyM5TmyCcW7Cc8o7BBTFVHFg9N1SNtEYi1dPGwtZF9KCDJUccrxklLjaGv+CCswoKbhQuz7IPKVIhEZJL+ey+Q0w=
X-Received: by 2002:a67:ad15:0:b0:398:6aef:316b with SMTP id
 t21-20020a67ad15000000b003986aef316bmr499696vsl.17.1664427260088; Wed, 28 Sep
 2022 21:54:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220926033631.926637-1-zhangxiaoxu5@huawei.com> <20220926033631.926637-2-zhangxiaoxu5@huawei.com>
In-Reply-To: <20220926033631.926637-2-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Sep 2022 23:54:09 -0500
Message-ID: <CAH2r5mtdZKOcH939kTw_q9qSTZ9iYCU+=QaHPgaWfjvxN4ffkA@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO
 message
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, rohiths@microsoft.com,
        tom@talpey.com, linkinjeon@kernel.org, hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next  (waiting on additional
review/testing of patch 3 in the series before merging that)

On Sun, Sep 25, 2022 at 9:35 PM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> extend the dialects from 3 to 4, but forget to decrease the extended
> length when specific the dialect, then the message length is larger
> than expected.
>
> This maybe leak some info through network because not initialize the
> message body.
>
> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
> reduced from 28 bytes to 26 bytes.
>
> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Tom Talpey <tom@talpey.com>
> ---
>  fs/cifs/smb2pdu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 40da444c46b4..90ccac18f9f3 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1169,9 +1169,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>                 pneg_inbuf->Dialects[0] =
>                         cpu_to_le16(server->vals->protocol_id);
>                 pneg_inbuf->DialectCount = cpu_to_le16(1);
> -               /* structure is big enough for 3 dialects, sending only 1 */
> +               /* structure is big enough for 4 dialects, sending only 1 */
>                 inbuflen = sizeof(*pneg_inbuf) -
> -                               sizeof(pneg_inbuf->Dialects[0]) * 2;
> +                               sizeof(pneg_inbuf->Dialects[0]) * 3;
>         }
>
>         rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> --
> 2.31.1
>


-- 
Thanks,

Steve
