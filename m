Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBF0C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A86206B8
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 05:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="muciqd5V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbfB1Fo2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 00:44:28 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42830 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfB1Fo2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Feb 2019 00:44:28 -0500
Received: by mail-pg1-f196.google.com with SMTP id b2so9132344pgl.9;
        Wed, 27 Feb 2019 21:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kPKaM/wVu0wENlWjhvWM4RJ2peaamOVUwtIcYrhOH2M=;
        b=muciqd5VcXHq0UgaSxyVGqu8Fwt9PbQzUUQLIdJFDPL0UlC41rI4NPFAkbhZf83whf
         94SFREZMsTNEdUfNt6YB1Cnyil9Cdg8v62LigsGLlfDf5icrfAYlJnY4T4bYTyEfhRGq
         BKhD0xbVHhAd962GtH/sotucC1dO85E5lo9nWI19q88uYM+P+79GM1fl43hBcDg3/b9f
         ggdN82zauOFzYgQBc/WBxMKVCOX1IJzz5UxfLp/F0WxCV7aCTSaySQrqA6YEvpJgU0W/
         8jUxvgZ50nm7WJ8VWINTZpBk4Lrww2eQ8lOhRmJP3d0C/bb/MPlHk/bvE+ghQhsXbfEE
         xRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kPKaM/wVu0wENlWjhvWM4RJ2peaamOVUwtIcYrhOH2M=;
        b=UfC1hFbdV4AKMnky2En4vzuO8J8IY7Mp/F1IhcX/3dTghRjCFGU50F//uVkTzP0Uzj
         7Gou9+/8Kmnblda/QtNZe/f5bvn1lD2s41hKYlnATPy6HO/Xsiqh0p8Y9trHtKmlY+Zq
         fUKjOdrS5Ab7bGmY6y6lCi7naf6GjZzSPbSDZC4x8RMG5O0idHh6firSP4z3yMJu/nf9
         m1AgBgV0bCU0WBCAc5VT5V9bbdJFWAvkkCpcFLJUXCFmwuJEEKYzFjxK6r6Pf+hwfGgR
         78RT06dNPKHXoJC95mGtjlPZBSq7qI/4H6RDrZmNuvxuI9NvV7+knpTOJYe+EW9Kvr5r
         wRLQ==
X-Gm-Message-State: AHQUAuaElATSZAOJ4eST0JsN4OF0OM0A8/APqQzwjFM7KzdzlxRbYzGw
        y5LHOrlHi+D1KuWG/SQOwlv02QjZjhQ4Snvf2ws=
X-Google-Smtp-Source: AHgI3IaKnQSswnsaHYhPSUtp7AxVPXbJsbQei87wRYbohZn+qLOg8jJ+Lt5s3a0VS4nIqawEIK5E0CQcoZaXPfSyZqI=
X-Received: by 2002:a65:42c6:: with SMTP id l6mr4463163pgp.344.1551332666820;
 Wed, 27 Feb 2019 21:44:26 -0800 (PST)
MIME-Version: 1.0
References: <20190228052659.GA3253@kadam>
In-Reply-To: <20190228052659.GA3253@kadam>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Feb 2019 23:44:14 -0600
Message-ID: <CAH2r5ms1+5Kj_qmWx3oww7Af_rfiCSBbkGos_gqieqH7jW98BQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Clean up an error code in cifs_root_iget()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Won't that change behavior and cause the success case (server returned
0, and does support POSIX and &inode pointer is ok) to now return
-EINVAL.

Before if rc was 0 and inode was filled in we wouldn't execute this else block:

    } else if (rc) {
        iget_failed(inode);
        inode = ERR_PTR(rc);
    }

But with your change, won't we return EINVAL for the success case?

How about just changing:

iget_no_retry:
    if (!inode) {
        inode = ERR_PTR(rc);
        goto out;
    }

to

iget_no_retry:
    if (!inode) {
        if (rc == 0)
              rc = -EINVAL;
        inode = ERR_PTR(rc);
        goto out;
    }



On Wed, Feb 27, 2019 at 11:28 PM Dan Carpenter via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> This patch silences a Smatch warning:
>
> fs/cifs/inode.c:1094 cifs_root_iget() warn: passing zero to 'ERR_PTR'
>
> The shouldn't have a noticeable effect on runtime, it's basically
> a cleanup.  The code is checking to ensure that cifs_get_inode_info_unix()
> returns -EOPNOTSUPP when we have the UNIX extensions.  From the patch
> description in commit b5b374eab11e ("Workaround Mac server problem")
> this affects Macs.
>
> Presumably most of the time "rc" is zero, which means we return
> ERR_PTR(0) which is NULL.  This cifs_root_iget() function is only called
> from cifs_read_super() and if we return NULL that causes d_make_root()
> to return NULL so in the end we fail with -ENOMEM.
>
> After this patch is applied we instead return with -EINVAL.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 0f53ecb071ac..e40c554bb2f3 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1080,8 +1080,10 @@ struct inode *cifs_root_iget(struct super_block *sb)
>         if (tcon->unix_ext) {
>                 rc = cifs_get_inode_info_unix(&inode, path, sb, xid);
>                 /* some servers mistakenly claim POSIX support */
> -               if (rc != -EOPNOTSUPP)
> +               if (rc != -EOPNOTSUPP) {
> +                       rc = -EINVAL;
>                         goto iget_no_retry;
> +               }
>                 cifs_dbg(VFS, "server does not support POSIX extensions");
>                 tcon->unix_ext = false;
>         }
> --
> 2.17.1
>
>


--
Thanks,

Steve
