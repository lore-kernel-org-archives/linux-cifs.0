Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129CDC2BBD4
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 13:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBCBF23A9F
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 13:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgLRNrG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Dec 2020 08:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgLRNrF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Dec 2020 08:47:05 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7629AC061257
        for <linux-cifs@vger.kernel.org>; Fri, 18 Dec 2020 05:46:08 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id a12so5539684lfl.6
        for <linux-cifs@vger.kernel.org>; Fri, 18 Dec 2020 05:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EyowfG5EMP/bElJmWv0EyRjwwaKfSxZtzW/jKkuzcY=;
        b=ku7laebsyDQmObM8QRNePVVwUWj7C7SBI8ttv7pGIizBzY31k5zjj2h+/I6NMFwECk
         HQ0/IORsFbjDupeT40qDzheXG/gtmN3x8P0CWNijIXuPeYyGa3iizdD7OUcx1NWGbEtx
         o7w7JwyVIJvQq90diQnq4YowMpKjh4MGdUa0xltg5SiSFAIlRTaKfwd6qN9bN8HzJjzM
         QoOuXRhssU3IkM3aK56lntv3BVzJs1NVJFVthhTDd9n8ZK310xaiKXxix6b84CyPhJU0
         lm4e0tmqAECXmF4ncWgEQGPu46TeQK7fPtdhgwEpdNKDKaVfI4Ifq4N0w80yUkDedJmq
         grYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EyowfG5EMP/bElJmWv0EyRjwwaKfSxZtzW/jKkuzcY=;
        b=ksXrk6+kcQxN4UmXqgyBVtbGSXW+9DwKVr8IF/+ubcj2SGxK6rRkt4ZUycbpxJUXwQ
         dSpXoxye4o8S6QZr/p9OxeztrRLcAENJuyTsyoOLgcWWxRxDiva2GWIyqjoI+vteipEM
         ftwwLeiTzFzI4xL9+vWPU0t62RviIKFiWAlz8TVxhRq77J/YiueNgwwYVNt6Fxk8JuXP
         j1tftnJSVVxBte2V2j3dt0C0sa1kv25il9or5ZpzfPSKy4LaDbzhXoK+kvLUsibMr3u1
         qv8Dt7ha7a+7F18ErjtWzAU7mZZbI+vCu43c64IquY52bNSA2W7udQvFWWNUHOX5eCSy
         fmrg==
X-Gm-Message-State: AOAM531uObo2Ffox8GHVvvnGpJw4iv9R9t47xsZ9sX/twj9Efnu1h0tX
        0O+MjJRicUF1hOsEKQ+S8c2KrPSqTOt1keKD9zc=
X-Google-Smtp-Source: ABdhPJxMoDdBiC+P6akqI12pRf+g8rs0aXTJJTzevQS99sYEKleVBpyh3du42bwr/lBWu8b7neGFh+hok3/GauB2K1M=
X-Received: by 2002:a19:950:: with SMTP id 77mr1444326lfj.133.1608299166901;
 Fri, 18 Dec 2020 05:46:06 -0800 (PST)
MIME-Version: 1.0
References: <X9tNXBJunTCYCoSw@mwanda> <20201218092949.1767-1-scabrero@suse.de>
In-Reply-To: <20201218092949.1767-1-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 18 Dec 2020 07:45:54 -0600
Message-ID: <CAH2r5mtMrVuB_tC-ATOfhH2csHmnrAYjfYsCHTzP-YgCtEvbbg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Avoid error pointer dereference
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Fri, Dec 18, 2020 at 3:48 AM Samuel Cabrero <scabrero@suse.de> wrote:
>
> The patch 7d6535b72042: "cifs: Simplify reconnect code when dfs
> upcall is enabled" leads to the following static checker warning:
>
>         fs/cifs/connect.c:160 reconn_set_next_dfs_target()
>         error: 'server->hostname' dereferencing possible ERR_PTR()
>
> Avoid dereferencing the error pointer by early returning on error
> condition.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/connect.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 509a41ff56b8..b9df85506938 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -155,6 +155,7 @@ static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
>                 cifs_dbg(FYI,
>                          "%s: failed to extract hostname from target: %ld\n",
>                          __func__, PTR_ERR(server->hostname));
> +               return;
>         }
>
>         rc = reconn_set_ipaddr_from_hostname(server);
> --
> 2.29.2
>


-- 
Thanks,

Steve
