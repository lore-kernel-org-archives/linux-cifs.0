Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C76C46499
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 21:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0154721670
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 21:07:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vE8p7x+g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfGEVHs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 17:07:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46829 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbfGEVHs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jul 2019 17:07:48 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so3533536plz.13
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2019 14:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aQsZ8tnSw2A6Y/hR9pk5Ii1SWprFEaj5sUW2qdiBjb0=;
        b=vE8p7x+g6svDFfMkuP3xVIotcLsMLnzQ68/8LP+Pxg+Dnu/W8CySoBZLDFRstnZKwJ
         nVsSHOjyIyCj5djk+ya8E4wmBxHSGwgBxYdQAwp7yM8vPGUnjWrDc5IXdNvr9q9bPWAS
         rhCdqgiW/n/hFkSnduFDKe3IAXrbLQala6cx71ohgNjzcACQuO81/YthpSpXWueGWQOA
         6nkHQeiQ6WRowGKTZJBLiF+TbI2PkkCGJr8sHy7iX2lr36eQnNmD3mhDEaO7hI4pNGGo
         AKlSZ3TnWTZ5FVEhtmT0EeWH3a9YdT3uWBZavTffEO5mTUS4W0T4BI4YV0yma59AuJ19
         3GZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aQsZ8tnSw2A6Y/hR9pk5Ii1SWprFEaj5sUW2qdiBjb0=;
        b=EC5hurhI6uCiYNlIixhy5GbMdyylY9frMfvDrrP9gFESl0JerjatdEhajcGCxZtWtY
         4eLkznY2TYCzap244rgP4qN5N13KI1JuvFhD8sq77mautgDRB/hI8WRMofEh8n4MfZKQ
         V/E7ZKm1FY+t/IcNVX2izSh8DRwaX2MDLQpTVr4jjmOihkH7wJ3cqVSX8acIPsIZmSDB
         U/09RsplGV+wiuLHYJczOVbDCkdD6G9uCIpMwpvLKYkEl7QIvwLMGX6yp/iW5hXYSZCz
         m6lR5G6KBvOl6c1d193wK74ZV4cYeY9F97TKzkMXzwF5H8YggKwbjobSGUWxpc/8beqV
         nz5A==
X-Gm-Message-State: APjAAAWXNFYeuEbc7iwDbsc2CIyAiATKP2HeAKIMjkjEU3/1eEIsLvQe
        exIrjPqtKB10wz6m5W/w6DcXU7Nfg/jzFhsauBd+R/9c
X-Google-Smtp-Source: APXvYqy6GyvOi/QHr6FjZGGcDbejOfAs5FkcQhYcWay0wR/8VHYMHR7+iN2mEXucUe9Q+eft7PouafSD76gZbPeHa88=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr7975959plc.78.1562360867875;
 Fri, 05 Jul 2019 14:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190705204308.10039-1-lsahlber@redhat.com>
In-Reply-To: <20190705204308.10039-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 Jul 2019 16:07:36 -0500
Message-ID: <CAH2r5muJNCpjxvD0PoHo2jbg8uG9fivAcyuK2K+CtQRztsmV7Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: always add credits back for unsolicited PDUs
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged these two patches into cifs-2.6.git for-next pending testing

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
