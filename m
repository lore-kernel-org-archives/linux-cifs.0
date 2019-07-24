Return-Path: <SRS0=zjVJ=VV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AAAC76186
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Jul 2019 03:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 311482182B
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Jul 2019 03:27:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lx8x34YK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfGXD1o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Jul 2019 23:27:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38041 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfGXD1o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Jul 2019 23:27:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so20166401pfn.5
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2019 20:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XCqLGB31XeenGmjW1ZGVvTF2OxpAvcXJWj+OVs7Y/Y=;
        b=lx8x34YKyAyPonsbIsPqgwUJ9sw+xoXyc8+6cl9pGg/tns6wzNz9RYX82Xd+Lb9WOO
         RWPlQT4y29wdEmM/d3RY3Ofx7tJk6dZssM6lzscuQaY6sGqeP+7iogVyuatbwuZfqWfI
         JGClBgo93Dta0uP1/NImktGgoIOQveyf6yPgP2lZifyh7Zt6xIZhbrZu65xtgsTU0xGw
         Cwai/Eq7L6/fhBznjzqQbcWile1ZKPDUuQapikcGTZWfPDoWqew5XXncZ6N7Fo9bNOTf
         vfNaaRTjy+LGgYTzjou+pLChvR4Q56exGzjU1fJqJK7g+iCWRzVHrcWCDltc9i8ERLsH
         VdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XCqLGB31XeenGmjW1ZGVvTF2OxpAvcXJWj+OVs7Y/Y=;
        b=k77JJV+QPdHceGG3vgZW1i4C5mf5wIFQEfUrsBxUjCsK5CzU71q9n+MdTIp9zVsy2C
         sEolidKuLvyk24QY/pZOg3RLXPe9FF0psxllG7srWNphTX7DQ0Dp4wIbGRsM7WLfOeVa
         Cdf4sERCfEHhojuXh3hsJxrtWOePtaYCXnGKjbEbsdipTvhempuASwIf2ChyIBUMX5pV
         FzVmNmHf3Ra4w1kzCzKEfCw4V84QSrmqAeWYmWwuxyu3eOIKS1q3wU7Qa7QG7YgPSlGv
         GZcQKHx4PJoEZjS8gv0bksj5xJimg5skoR83Y3hVCSoNV2RF5Y2ojyX6XH81RnEzJ5Iv
         iUUg==
X-Gm-Message-State: APjAAAWSP23k5YnoedOcDeFOtUalYRHLp2y/S9dojT9Hfp3Sf5gsQT9Y
        gl4iO7B0pslWR+soIT7ttgdeELxtXnreDx7d94U=
X-Google-Smtp-Source: APXvYqxTpyWKhJTwZrKzVLcg+jvje1kLdqtAWaComyN92Jpi0pXhywfWng2yP+rxmre05aF1MR1j5VEEz8z+2LLJR1o=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr86667497pjb.30.1563938863715;
 Tue, 23 Jul 2019 20:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190724014349.6479-1-lsahlber@redhat.com>
In-Reply-To: <20190724014349.6479-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 23 Jul 2019 22:27:32 -0500
Message-ID: <CAH2r5mtxMe=9Hki+eczZ7qHrQj7=n=t6no-F3M2KoW2tX+UoCQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix a comment for the timeouts when sending echos
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Jul 23, 2019 at 8:43 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a4830ced0f98..78fb5cc37644 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -712,7 +712,7 @@ server_unresponsive(struct TCP_Server_Info *server)
>          * We need to wait 3 echo intervals to make sure we handle such
>          * situations right:
>          * 1s  client sends a normal SMB request
> -        * 3s  client gets a response
> +        * 2s  client gets a response
>          * 30s echo workqueue job pops, and decides we got a response recently
>          *     and don't need to send another
>          * ...
> --
> 2.13.6
>


-- 
Thanks,

Steve
