Return-Path: <SRS0=QLD2=UY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07D8C48BD4
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 06:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B42820659
	for <linux-cifs@archiver.kernel.org>; Tue, 25 Jun 2019 06:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nkFsChlN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfFYG36 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:29:58 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46235 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbfFYG36 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 25 Jun 2019 02:29:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so8897893pfy.13;
        Mon, 24 Jun 2019 23:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yp1pZjIgM8j6nAWCJwr1RviA9TCpOdWc0/KD/+kueE8=;
        b=nkFsChlNZt6IeXoodY2TGON55dXdvG9cyS5sonM/QFDihbw7N5eQ5pnSitRqcsn5XZ
         zaNCV4RsHRiOCAHGMrj3lzKN4NPV2/3Q/MJBBlioBzksDgO9oSMQAdfgrOAgzxrdhrz8
         igy3BH/2aytuFOizukyI1An0Xk1yxzXvef8Ilt7eiecBkcOFozeqAxwHKQI7FisPAHqr
         x+SiDz5eixHJjZcVFVwIpP20LgJn6BqHsMZHS2sZrcTsowVQztyCTHCN7rSP3qppfNyY
         Nrw8yFahwBmuE2ajQ1OOHMTyBBIyzzbjTr29CDsjjUKIxMfIL2K+9hP9ZEWM+1nXubGP
         G+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yp1pZjIgM8j6nAWCJwr1RviA9TCpOdWc0/KD/+kueE8=;
        b=Gdzrv9+Qv5sOp6BzdnYPvwM7H7dBpcbkMplkHWwejIYhtLXytpeimCEnzw+0MYCW1L
         hyMivkO0H7gikpn3o6NaAFN5AxTIhZmKtsfmpvNgMt0WCVf0Hu4Wo8qTxhDMDKmwaSUD
         ueHSY2ElqHZxd41x57iJYpKJrlznsacnUDL1rHuJaOoT+6VJBs8YhPqhcBK1IxA2L2IH
         XTe8pGrzpUAHoETLTKj7rjvQ48+UFKctaxz6bjuxVFES22qR3P/Acx3qosbv5PKhq/1k
         GCfmN9iNr1+KVuFgYf3UiVPtqCHC5QmRs40AnRSsYPx3kT4/CIJDIsNrGGJJR0t4IB1K
         AHTA==
X-Gm-Message-State: APjAAAUJV0i4/bPtRvrR/X7sHthSwTEZXpbq8/vLdWyo2IHvRfdmWI5n
        PHpPsJThJhWv7MZKaXmCUcLmJaY3VaOhM6rsPmGgkg==
X-Google-Smtp-Source: APXvYqzVcTKNjQWoRWqpshVelGz2/WVEbatr5RX3V5UecbE4d8qgv3csXOm9FYwbfR9FWhIFR3pRVjmDt9hAX76HG0E=
X-Received: by 2002:a63:8b4c:: with SMTP id j73mr26925363pge.11.1561444196820;
 Mon, 24 Jun 2019 23:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190624163943.6721-1-colin.king@canonical.com>
In-Reply-To: <20190624163943.6721-1-colin.king@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 25 Jun 2019 01:29:45 -0500
Message-ID: <CAH2r5mvSOS3khpwQ5bZ4OrTcuMXmxB_oaUuVLqaivD1w5g9n9Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix typo in debug message with struct field ia_valid
To:     Colin King <colin.king@canonical.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Jun 24, 2019 at 3:25 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Field ia_valid is being debugged with the field name iavalid, fix this.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/cifs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index d7cc62252634..06a4892e9973 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2415,7 +2415,7 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>
>         xid = get_xid();
>
> -       cifs_dbg(FYI, "setattr on file %pd attrs->iavalid 0x%x\n",
> +       cifs_dbg(FYI, "setattr on file %pd attrs->ia_valid 0x%x\n",
>                  direntry, attrs->ia_valid);
>
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
> --
> 2.20.1
>


-- 
Thanks,

Steve
