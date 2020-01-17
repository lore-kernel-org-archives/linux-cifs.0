Return-Path: <SRS0=TaZu=3G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 950B0C33CB1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 07:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D252073A
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jan 2020 07:53:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0g5FOnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgAQHxT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:53:19 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:44946 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgAQHxT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jan 2020 02:53:19 -0500
Received: by mail-io1-f68.google.com with SMTP id b10so24956068iof.11;
        Thu, 16 Jan 2020 23:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMzj5rXvmC6rcg3TGp0r+bv48vd8zx3O/Jl+lBOM824=;
        b=K0g5FOnwioEbhVTO/BB7URoUfu9qb/FKRVhJNukEXzEcdEzffhUQKolWV8ixV8a7Ql
         xFLdWsxq8Av2nupseHiPC88OUDhbCcfiDYe5i84XCPS3BpSB7KBC8g25Hcjd/mmia4ay
         COb+x/3lurZ7DkxeqOCcly2NPnxkEQdtaKlqJXHCfNIx3hlqRoN7VN2fr85ES+Ef1UrX
         SaUZUssibEMJ/laFLSq7TjRa5WirOPf48kY2FEghBSgNl8LmmYoOP1304+W5RQnL8Efj
         RvJY3Im8zc+K5phoKOAm/24EjL1DVBv1MFGCc2HCPGcNQq5nXsYlD7LRF4wOoAUk4xrq
         jGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMzj5rXvmC6rcg3TGp0r+bv48vd8zx3O/Jl+lBOM824=;
        b=MmZInXI553kuddtBk53gzkYH0HjLgH22JRu+w4KIlpw5i8es95OZm+ErI9Wke8rt0J
         Ra1gMvSYSHOIeRyuXrgLxBiyE0kvICtOPK/OQJvJhjDNZ60beXhrjVnRoJPlGQmqSdnn
         CLrtDzDoT4c8mTUZqqkjXR9P5UI9LCQ71pwR+uVymCPP3W0tCPKAmiZ5Z0Sd64xF9/OU
         cT1bzKyx+lZY9Vp/RC44lucoP+7wtUOV7zk4E5aG5z92INcjICjHkqORY6kszAEIRSPT
         SioFMOPD2mMizXQ0PtXPKxeThVTe7aoyoFLrzXWl89lUDo5NZ5SRYEDLDpO3eX/TTvoc
         VQHw==
X-Gm-Message-State: APjAAAXWBDxR0p9QzAX/b7Jx0O45jt8oBMWnDjKIP/UCeX8NoWBsIc72
        3ZX0p+6sLoplrqm5+d9ymInwC4D0gsXognT1e0E=
X-Google-Smtp-Source: APXvYqxN68umXck1USsTe5u758BVy+E8O+lfkcQxQNEs+860tNQagotavXediT7gRuQQRBW9n2gyJQvwSeK0rhiaKns=
X-Received: by 2002:a02:cd12:: with SMTP id g18mr32281878jaq.76.1579247598887;
 Thu, 16 Jan 2020 23:53:18 -0800 (PST)
MIME-Version: 1.0
References: <20200117022156.57844-1-yuehaibing@huawei.com>
In-Reply-To: <20200117022156.57844-1-yuehaibing@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Jan 2020 01:53:07 -0600
Message-ID: <CAH2r5muybvVnEF=HzT1-xi=X2209PtE5F4zKr2OnMvaMcdLJHQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix return value in __update_cache_entry
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Steve French <stfrench@microsoft.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Jan 16, 2020 at 9:58 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> copy_ref_data() may return error, it should be
> returned to upstream caller.
>
> Fixes: 03535b72873b ("cifs: Avoid doing network I/O while holding cache lock")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/cifs/dfs_cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 5617efe..03cfaa1 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -593,7 +593,7 @@ static int __update_cache_entry(const char *path,
>
>         kfree(th);
>
> -       return 0;
> +       return rc;
>  }
>
>  static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
> --
> 2.7.4
>
>


-- 
Thanks,

Steve
