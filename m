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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC42CC433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 03:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF094611AD
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 03:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhDJDDc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 23:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDJDDc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 23:03:32 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482E1C061762;
        Fri,  9 Apr 2021 20:03:18 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id r20so8691258ljk.4;
        Fri, 09 Apr 2021 20:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I/wRxX1R9oNjkGChxLuwTfeQJQhzEhqKDOWET2I+Z38=;
        b=Inm5K8AjwQqChONCOH2iIzctpL24AM9K15FYc7zoX4EmBpBFDlscB28ar6tATAXdiQ
         i8moRrgkrIne0xlJPE9Xktry0vkMTrDxy+qq1EX5DsoB4XP8VBLCsTCLOdzQAUvj6A0V
         LMrFVk+Q5fk0yEop1v78k232vs0BlWgOuMerKG4NudZllZR39DW8ZlD5tMaPpYsVDz5f
         8Z6NDmdz6CBq+hIcOGmuqJBql6rlJURdK5Af8iIGVUoDXgLYmQC8KYWkbN33ulCr4jcD
         Y7lkdk83bSb9guzF5idArczgsySr9sftB97Vcu2oC4z3rd9q7qIhkUmebhVHsJweXpY9
         pqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I/wRxX1R9oNjkGChxLuwTfeQJQhzEhqKDOWET2I+Z38=;
        b=Vi/rMSt5/Q2v4sdTOuMs7bpgw/Isd72ES5lLTuksnFqZAFWoJd6++W+YhGosZGhIcJ
         bhV+imONOqJAPvaLfj+KfGbLuRK4MYTObgrglBJx8dfCdOv5U2ZnDxxq61dcxZY5AtZ0
         b2QtPVgHwN/p0K3G6lA1BQWFFaBNiB8jS0aO39kWslIbkL94kRkGJVq0nYInNTMU1QSi
         UpRt9e0orgqQzIs8SLj00UTp1tO6tW6mb6/VvNgHIJjo/W46Sr/Xd0mvFX486EE7Fu63
         FneOPl7mPYM5AOLs2GG0qenbVduWPadBfV8tkoxmKXiDmeUt3ctBxld1Tzdih3wl1sA7
         kBNA==
X-Gm-Message-State: AOAM5306EAnccDobgY7RSJqqfqWpwkEHo9UIDHfqpIjXHkQ7WD8hTAvI
        CHRbDFxnJvb8EaMozsql+C34rR4CyLIWEVKusLI=
X-Google-Smtp-Source: ABdhPJy0Xm/gsEDLh86mOz6oX3ooDgaOPzxzCaUH9nFk0p40AUJcPhgInDJ4vmIP9xN3+2agu03CTlIEtMRvagckUIE=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr10967483ljp.406.1618023796589;
 Fri, 09 Apr 2021 20:03:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210407022655.21124-1-liliu_096@163.com>
In-Reply-To: <20210407022655.21124-1-liliu_096@163.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 22:03:05 -0500
Message-ID: <CAH2r5msQd88mgu_AOFRckzxmqA19NLcKyNggR253HawA2dM+og@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: Fix spelling of 'security'
To:     liliu_096@163.com
Cc:     Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "jack1.li_cp" <liliu1@yulong.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next

(strangely ... this patch was sent to my spam folder in gmail so
didn't notice it until today, and by accident).

On Wed, Apr 7, 2021 at 9:03 AM <liliu_096@163.com> wrote:
>
> From: "jack1.li_cp" <liliu1@yulong.com>
>
> secuirty -> security
>
> Signed-off-by: jack1.li_cp <liliu1@yulong.com>
> ---
>  fs/cifs/cifsacl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 562913e..d2d8e26 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1418,7 +1418,7 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>          * Add three ACEs for owner, group, everyone getting rid of other ACEs
>          * as chmod disables ACEs and set the security descriptor. Allocate
>          * memory for the smb header, set security descriptor request security
> -        * descriptor parameters, and secuirty descriptor itself
> +        * descriptor parameters, and security descriptor itself
>          */
>         secdesclen = max_t(u32, secdesclen, DEFAULT_SEC_DESC_LEN);
>         pnntsd = kmalloc(secdesclen, GFP_KERNEL);
> --
> 1.9.1
>
>


-- 
Thanks,

Steve
