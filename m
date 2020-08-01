Return-Path: <SRS0=NoDE=BL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019E1C433DF
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Aug 2020 14:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D53D42076B
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Aug 2020 14:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEI+g4g0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgHAOtz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Aug 2020 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgHAOty (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Aug 2020 10:49:54 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8727C06174A;
        Sat,  1 Aug 2020 07:49:54 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so22108452ioe.9;
        Sat, 01 Aug 2020 07:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVNdjfkuEymtlCMjYVhcJ1dm1EhRpHn4gFio0XQo7YU=;
        b=kEI+g4g0e4gyRGxDXB6HuB4aGlGy4Lm3cI4tsQCYmzgt4A3SiVkWv6KTOGppNfi6Zh
         u5aOg5BDskxdER9ke/NyCE4oP3jqdOYU5Gr9KcgYG/+xIy0JN4FAbOggeOYXSZRi2dru
         7RDosvnh8Erp/OC0akp3krFR8J97rsJL65i8jTueW5i8MipD/KYOW300Wb2bL6dvtAvE
         AaTzBJu+gSI0SXChEoYIxjGiNrbZqp7EBql4Th9kIslh7Vd950kVD0OLqhewLixPKIkv
         5lUzvGyk3nOYpBmjCstlHi+kYT5TRQghw9RXAo7xWORz2egPO1kzKNibz7VWvsyd0NGH
         8THg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVNdjfkuEymtlCMjYVhcJ1dm1EhRpHn4gFio0XQo7YU=;
        b=b2hmqnMksJGftC/uOFeRq5Kh+wgbNFpo4IRnvfIGYMlITogvpGncRdfrjC4Nevv0V7
         krOL35d8/b28qnA97XeQEAIjIRX2hDILNq8tLkLcbQZrqUa9rZ8Qg2xZgap74TuUB4Cq
         g6Ebs3RK59sRZmfBW419Xe4BzAIIjlSVM1urFneH/LNqlPnOSD2wd2iES2qB12xF/Zce
         YWM+fwqoTOzMjK27rwvuUQxeWHDEpeVskuZsARH06OaTlKfCUpMP0dJprEYZnmnVZuqQ
         DRy8FEhtaYV5OZtE3ZCrYbuCXbgMM/W+9yJ4LInhBQNzWEW7y5/AFqSLxISxfxoVzhQ1
         I17w==
X-Gm-Message-State: AOAM530ozUHUCD+88gaAT63WlX/yp8hPZiCHgASjFTlmixfwPDl52LRE
        mETNJQ+M5XokSH+b/m8KrpJf8CwgcDW23/XuvSM5h3kS
X-Google-Smtp-Source: ABdhPJx/jOwTXIJbiM7v1rANDakrJ2QmDFARmK57MOV3E6LasX1X6K+1lQca48VHVG+yOiEIFE8ph0FlqouO8Eq1wEc=
X-Received: by 2002:a5e:a607:: with SMTP id q7mr8479532ioi.16.1596293394048;
 Sat, 01 Aug 2020 07:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200731171342.36636-1-colin.king@canonical.com>
In-Reply-To: <20200731171342.36636-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 Aug 2020 09:49:43 -0500
Message-ID: <CAH2r5mv8pWOcQfKknec=JksKVLvLTu2NbowAKwSguAb5-eojSw@mail.gmail.com>
Subject: Re: [PATCH][next] cifs: fix double free error on share and prefix
To:     Colin King <colin.king@canonical.com>
Cc:     Steve French <sfrench@samba.org>, Aurelien Aptel <aaptel@suse.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Jul 31, 2020 at 12:15 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently if the call dfs_cache_get_tgt_share fails we cannot
> fully guarantee that share and prefix are set to NULL and the
> next iteration of the loop can end up potentially double freeing
> these pointers. Since the semantics of dfs_cache_get_tgt_share
> are ambiguous for failure cases with the setting of share and
> prefix (currently now and the possibly the future), it seems
> prudent to set the pointers to NULL when the objects are
> free'd to avoid any double frees.
>
> Addresses-Coverity: ("Double free")
> Fixes: 96296c946a2a ("cifs: handle RESP_GET_DFS_REFERRAL.PathConsumed in reconnect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 3c4dd4e1b9eb..4b2f5f5b3a8e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -5574,6 +5574,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
>
>                 kfree(share);
>                 kfree(prefix);
> +               share = NULL;
> +               prefix = NULL;
>
>                 rc = dfs_cache_get_tgt_share(tcon->dfs_path + 1, it, &share, &prefix);
>                 if (rc) {
> --
> 2.27.0
>


-- 
Thanks,

Steve
