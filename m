Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF289C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 02:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D67A218D4
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 02:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ch4Wh6ai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfCPCPK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 22:15:10 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43280 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCPCPJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Mar 2019 22:15:09 -0400
Received: by mail-pf1-f196.google.com with SMTP id c8so878308pfd.10
        for <linux-cifs@vger.kernel.org>; Fri, 15 Mar 2019 19:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UIaIrCkAJyIdQ9VKFV2L4geqDuAirIEi3X/q5thyjDE=;
        b=ch4Wh6aimKbu0oRO5BlLGGNlo4MtoB6tr/56NyKEaCde9yYjE4kvw26whio02ff79U
         X/RiQhLt6QyeuDyKTuXnaco2aDyhKPUXRVATEvu2IlIICuWQFx9oGsgzsydm8GWsydBT
         VDu6W4quWUlZPpE4zHoqQcgaNOIUkDq9HqYwoIwXH0nn8ECmHZsSFLUqMjxS/LY8udKP
         nytuSqTpxyO9yMjrT2gvuqA9V5ldvTAeoQ/Ljc7pD24TcJCH3GsTrmqrCvBdcikypMg3
         CnhKtIe56Fiv1SXnVqLbAnVh2/5TlITK1+jnbq4QhwvLQvFQ6eSbjvJzvXJ1kJLKuE+L
         JM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UIaIrCkAJyIdQ9VKFV2L4geqDuAirIEi3X/q5thyjDE=;
        b=gAyXHxtiiuxm9SRuvx1ZrABUF8oj03a80BynPAeY8KQ3o3jF1Bo1HP440rJ0SaCPh+
         gcLi/ZicarN+b/IQyvxHL4YsNoUWu9h0a4MWUd57i4zckcTEFUWNzAhb6HGf1JTC4fWb
         JkEPQj8xYHJwysWqpoJw6KyOAIf52gQtb/EAMMxMyejJMi8ZaRVUeyYJzTij4jRpep3g
         Whfs015M3OPmOF3jmff7rQuYG2+gzxiHKEQLq86DrLK6KZ9dFF7V7X2x6IvH2M7G4fW4
         906/tbSj+7VuKtA52ucX4h23gPkLEtA+xXzUB82bgMH6U89to7QS0FnqLvgBNPVHmi9c
         Ooog==
X-Gm-Message-State: APjAAAViP7UzESladqcBvZ0giRAJHmBHSO4IBKrPWMN1q+elzQ800xn3
        EK3O9BgBliFw5RfG9PAKY4Otlv+5tbGdliaQByk=
X-Google-Smtp-Source: APXvYqwO9uKcxGkRLW5IW0WMP4AvEG0aOzQ5SDVJOJ0Buv3+dVHikW8dmU10OIjiuIVjLmJ61+G8Rtr8bWqEzXpD9/c=
X-Received: by 2002:a63:540c:: with SMTP id i12mr6466033pgb.69.1552702508672;
 Fri, 15 Mar 2019 19:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190316020217.28011-1-xifeng@redhat.com>
In-Reply-To: <20190316020217.28011-1-xifeng@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Mar 2019 21:14:56 -0500
Message-ID: <CAH2r5msYYV_Mx9BES0s-_nG-DHnqC0ipU3g40yHyP_0NvVJBVg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix that return -EINVAL when do dedupe operation
To:     XiaoLi Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Xiaoli Feng <fengxiaoli0714@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do you have a list of any xfstests that this also helps with?

On Fri, Mar 15, 2019 at 9:10 PM XiaoLi Feng <xifeng@redhat.com> wrote:
>
> From: Xiaoli Feng <fengxiaoli0714@gmail.com>
>
> dedupe_file_range operations is combiled into remap_file_range.
> But it's always skipped for dedupe operations in function
> cifs_remap_file_range.
>
> Example to test:
> Before this patch:
> XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>
> After this patch:
> XFS_IOC_FILE_EXTENT_SAME: Operation not supported
>
> Signed-off-by: Xiaoli Feng <fengxiaoli0714@gmail.com>
> ---
>  fs/cifs/cifsfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 217276b8b942..f9b71c12cc9f 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1008,7 +1008,7 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
>         unsigned int xid;
>         int rc;
>
> -       if (remap_flags & ~REMAP_FILE_ADVISORY)
> +       if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
>                 return -EINVAL;
>
>         cifs_dbg(FYI, "clone range\n");
> --
> 2.18.1
>


-- 
Thanks,

Steve
