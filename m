Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39410C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 01:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C86660F4C
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 01:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbhIVBx4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 21:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhIVBxz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 21:53:55 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153E3C061574;
        Tue, 21 Sep 2021 18:52:26 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id e15so5207989lfr.10;
        Tue, 21 Sep 2021 18:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iJIazCWnX6yOgFmMKuP81y+fh3OFoGS5C6d27wUgHy4=;
        b=UEniQJTLhBnggz7K4ch50uBlvN1Q6S4zao1gXrs3QRUv2V2RxKmOTlw6Utk1vTwsoZ
         iLl3VNQixS/wfPpDcVJ2hUGBmVR+Wx5eJdT27Fo5ElDKEnan13fJ8nvDp1F7jPbcEg2L
         OvqwJbat5aukAMULGbolSUMfWG0yV5/Nj4rB1knfM/Q7QyGc5gjY/o55lj4R6/YIkvff
         6U+OVZ62grGNMQo+VQa38NHp2iwoCFF5p1D/BaoUrfrEk8i6Ty26pJMK6ySFHmgZmk80
         0YBMLtaiLdPne+9TR7/kneUG08mrb2I3txk+EC/oU/H2lEsbSIeF08RfVIaaR44As12/
         x+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iJIazCWnX6yOgFmMKuP81y+fh3OFoGS5C6d27wUgHy4=;
        b=h25sgdOy2x8s+YNzo3yCo1f5N2ZqLvHQiEk2jVb7mBsYYbcauoKL3/MzbDOowXAC1T
         VdBeaR0HpVdwNC0KH0Ls9yX5ZFctj9LG9Gb1deiScq/+incewM5+LZYDMTV44wgeazrx
         Q2p0oDAWrldzZX8BYrYUvSvYEgQZKl2JFV1lYhfn2e9LxTrsa/Z7WBdTTuBdH+u1zmfr
         WTWfcYinVvmMvDoPRyHu+BC1MmDTlpJZedNnxIx2GXZAyQe1RlekXW5rg/3akZ2riPOa
         J7VqAO/8YXTPkFcTDBfMvVwdP74ountvhXRzcLS3z65K/gMt7XyenwRMmiPm4x4lIS3u
         n0Gw==
X-Gm-Message-State: AOAM531rLE858pZOpOTD7QldU46ZsfMTJwY1zqfAjmmjhaK8Uz5Y1C5X
        diyPAo3hGOm+LDHJ/73l/hbw5x4RQERRLpntrjIhlWJD
X-Google-Smtp-Source: ABdhPJzhYWusxsBksZjNLTQcc3upAL5LW4sq47+0/jy75RwLwASzEru/d4rRbgjSjey9bNe80Qk/Q7RPlNqtcOsk6os=
X-Received: by 2002:a2e:a288:: with SMTP id k8mr21782791lja.229.1632275543995;
 Tue, 21 Sep 2021 18:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210921203335.GB16529@kili>
In-Reply-To: <20210921203335.GB16529@kili>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Sep 2021 20:52:13 -0500
Message-ID: <CAH2r5muJ3zXHszfGUiPoqziVqQi2rRVX=NBtzqhJR0+X66GjSA@mail.gmail.com>
Subject: Re: [PATCH] smbfs_client: fix a sign extension bug
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Sep 21, 2021 at 4:13 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The problem is the mismatched types between "ctx->total_len" which is
> an unsigned int, "rc" which is an int, and "ctx->rc" which is a
> ssize_t.  The code does:
>
>         ctx->rc = (rc == 0) ? ctx->total_len : rc;
>
> We want "ctx->rc" to store the negative "rc" error code.  But what
> happens is that "rc" is type promoted to a high unsigned int and
> 'ctx->rc" will store the high positive value instead of a negative
> value.
>
> The fix is to change "rc" from an int to a ssize_t.
>
> Fixes: c610c4b619e5 ("CIFS: Add asynchronous write support through kernel AIO")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/smbfs_client/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smbfs_client/file.c b/fs/smbfs_client/file.c
> index 4d10c9343890..7db9ddb3381f 100644
> --- a/fs/smbfs_client/file.c
> +++ b/fs/smbfs_client/file.c
> @@ -3111,7 +3111,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
>         struct cifs_tcon *tcon;
>         struct cifs_sb_info *cifs_sb;
>         struct dentry *dentry = ctx->cfile->dentry;
> -       int rc;
> +       ssize_t rc;
>
>         tcon = tlink_tcon(ctx->cfile->tlink);
>         cifs_sb = CIFS_SB(dentry->d_sb);
> --
> 2.20.1
>


-- 
Thanks,

Steve
