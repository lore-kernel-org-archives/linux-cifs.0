Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69891C433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1513D65275
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCIAlV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhCIAkw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 19:40:52 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61821C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Mar 2021 16:40:52 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id u20so12046417iot.9
        for <linux-cifs@vger.kernel.org>; Mon, 08 Mar 2021 16:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wHEzgUe8efxkolybVG611pJ2MfXMQjK+KtH9XASGIww=;
        b=gDxyWlSt+yA28CPqgAP4ROerDQeb++szhjLqIEj02gODi1H36wSwivP0B5XdZK5jGl
         2DDsPBvseOB14233EWiTpaVG0+/Y7fxuhEM3cXC/eFCExzHXcOqJxo/zBqpAa3xu2zlQ
         cY3GnUHEpcWbo3BS44OIUxBPtiZYOVgcL8buTPSR+yUBgf6hlSGsZ2IcPMJs8gdfPzO+
         7dR4AeG8ENVl/gBa4jVaHNLI8dgSQCMXzp/UxTDyBTDQPJREpUMHb3zjJ/dwspUMpQYe
         UuFU3JiHV3ynsIvTrELRCAIziQWV1q+Z4M+ExGBxyiCn93geP14VnHSeYiuiRcinxIKR
         DF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wHEzgUe8efxkolybVG611pJ2MfXMQjK+KtH9XASGIww=;
        b=Y/IxL4qdWJxrhqXQcpv/WuPeUDtofVo/0PsbTrwa0Q+1kMaY/VUNchKvoxrOtIj0Ns
         0AbuS95aFZr0mVA8fsciCz/XVAnSK2bVHsCn9DwesEktQYxUtd/kYnra+zEQpW3wcDew
         Ia9/gt2N/cwwNLyfKI3KpgeefqpZhr5qhVJNNFXS6cAZ9k9Hj+lQtwhgWJ1BeQ3i4Xtm
         72xl4Zjy9+n4n/tWrqAxBZLHUlLw6njGnz19Yb7AoicNbtmG+x06JognN5eBAz7HUtUL
         PHE69zJFJ7PvQ3fBBpoC7pFvNiX48L2PkKfmnPyuSibQ5n7fLRj60NSPMcmCypgC5sWp
         yTkA==
X-Gm-Message-State: AOAM5332qwyV7s+kjMoe8nb9pgfyvppAFVEIgA040Q88+1WVwi9Xvp4D
        GPPABdNWbTK8ch7EbRSpUGpUwv6ExF69aY1nAXw=
X-Google-Smtp-Source: ABdhPJwrn+pBUtmiW6aHhhHamMUh164WnYHRtIB4wOvz/yjfJDhzr5ArK+ncjtzRx0+nkx+aYl/GP9tBLCvizsnzvDA=
X-Received: by 2002:a6b:ec14:: with SMTP id c20mr17053641ioh.122.1615250451971;
 Mon, 08 Mar 2021 16:40:51 -0800 (PST)
MIME-Version: 1.0
References: <20210308150050.19902-1-pc@cjr.nz> <20210308150050.19902-3-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-3-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Mar 2021 10:40:40 +1000
Message-ID: <CAN05THRYsU2Hk2YKU8HByR==1KJ_=HxgEhy9PjLro1chgpP6AA@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: return proper error code in statfs(2)
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Tue, Mar 9, 2021 at 1:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> In cifs_statfs(), if server->ops->queryfs is not NULL, then we should
> use its return value rather than always returning 0.  Instead, use rc
> variable as it is properly set to 0 in case there is no
> server->ops->queryfs.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d43e935d2df4..099ad9f3660b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -290,7 +290,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
>                 rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
>
>         free_xid(xid);
> -       return 0;
> +       return rc;
>  }
>
>  static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
> --
> 2.30.1
>
