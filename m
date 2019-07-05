Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB6EC46499
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0161E20693
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZMji0Zm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGEUxH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 16:53:07 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37977 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUxH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jul 2019 16:53:07 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so5095150ple.5
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2019 13:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvjsA0xutB1OqtMtQgXtsBfdWkGY37LjHSsC0axHs4Y=;
        b=gZMji0ZmQfOlCy2wCGEN6U/TjLDwasgNWnSo4m5yc82JIGKjWS6WSifrNtz5F3VwSB
         9wV8nCWZKwfi9x/b7V8CrhN/9frV6Fqy6oSAZZ9ti0C9qtjNMbtGak9XEXRnR/8kyfu2
         g+HLVEA2GAymt6DccFhQjShggvuVQqxYUyZhoIwd1na+NQ2gzhAjrR8SClwLofyhyfEe
         ruOJiJagqcHwmcYV5uijKtLWqJ7iRl9MGHd+W77RK9CJ7SLaCDDdXEfgBdi+AD1NpR2C
         wV+lO4NKI6hXzkhnu7BS7I/oMjjSw7+uK/Zpt+5MLfOtzloEb0033HjM0ortoNt7rDc3
         ap5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvjsA0xutB1OqtMtQgXtsBfdWkGY37LjHSsC0axHs4Y=;
        b=JfzVIRAfCJhaMzy5kBRHakiHS7ugpSLV0yqos63CyP8pXOcrnyCk4CUasN9tcgBFFZ
         UGVzNb8Sd0AcbjfygxAXs6wLJjkTRWSzqTag3FYwj+VI72oS0WylS2/JireKdM3BUmA8
         LYYUk4f+3CiDPma8WEPN+abje3DJZ2nuOu5liNFgEFb7hpLiYO5IwKmkBb30yb++m1x7
         EiC+uICx+BNli8AeAtnEVQjw6+IVLawd7bwgUCQdmjOMDxIhbqXKc+DA839U6nGYO+TF
         u+uQu+YWZWnpDby6MxGJLyXXfU1mO39JVuvJ3lDtV9J02/11k5tXEM91Del943AC4TYk
         XPdw==
X-Gm-Message-State: APjAAAWUDnWBeAqcJgw67QlEVc6G3Hprr0BeUi+HsnJ49qjmkipBgVcd
        UZsPSYvXpXy4t9ucXLaUr9cXLjPlgqdBkGlkwyCzlWve
X-Google-Smtp-Source: APXvYqybkmXn3WXOamjlRSdZh80oKxURkv1uCzjrLUxbrhjydOJ96+z7T7Ay5Mv034oVSY0vGEfMLCtbpZHWzl8EqLM=
X-Received: by 2002:a17:902:2a29:: with SMTP id i38mr7856216plb.46.1562359986811;
 Fri, 05 Jul 2019 13:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190705204308.10039-1-lsahlber@redhat.com>
In-Reply-To: <20190705204308.10039-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Jul 2019 15:52:55 -0500
Message-ID: <CAH2r5msoNnX0ZQ2GKMzoa8_-J1kukbQ=uiAC4m=w7XM86b-uZA@mail.gmail.com>
Subject: Re: [PATCH] cifs: always add credits back for unsolicited PDUs
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thoughts on stable?

On Fri, Jul 5, 2019 at 3:43 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> not just if CONFIG_CIFS_DEBUG2 is enabled.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8c4121da624e..11adca981263 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1221,11 +1221,11 @@ cifs_demultiplex_thread(void *p)
>                                          atomic_read(&midCount));
>                                 cifs_dump_mem("Received Data is: ", bufs[i],
>                                               HEADER_SIZE(server));
> +                               smb2_add_credits_from_hdr(bufs[i], server);
>  #ifdef CONFIG_CIFS_DEBUG2
>                                 if (server->ops->dump_detail)
>                                         server->ops->dump_detail(bufs[i],
>                                                                  server);
> -                               smb2_add_credits_from_hdr(bufs[i], server);
>                                 cifs_dump_mids(server);
>  #endif /* CIFS_DEBUG2 */
>                         }
> --
> 2.13.6
>


-- 
Thanks,

Steve
