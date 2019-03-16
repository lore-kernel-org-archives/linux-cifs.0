Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A42BC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 05:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 449F0218E0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 05:34:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhkkrBw3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfCPFe5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 01:34:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45678 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfCPFe5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 01:34:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id 125so7827235pgc.12
        for <linux-cifs@vger.kernel.org>; Fri, 15 Mar 2019 22:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJwRbay8Ah/Gre9RcWy8FUQ3oX58AUkl2tFe9XC6T7U=;
        b=OhkkrBw3i6rRrEvvI4isewBsZSJxk7lQ3xD3yQ2kXWDnxrZ7TWK5IV/5a40+DekW1F
         hLmfDJaHKTsuCqB8TBF1ROs2OEAhozb8/TI+K4AVdRxlUoDlL/gd7arhq5AfRQsnpqwL
         ZxxAbMIh7PqG8dE5O6H98nr3KnKNBHPhhQfmF/5H79UlL6cLdnZil8wTvVk/RNwuCuQU
         UJXh0WLFX/hkVnuUVyQuj8I3YBo8cHWnhtYGmdi0X93RnkyJnfrOsiKsZt9DIbFqugy6
         9UvGcTiTs9S7R1nl4oG8bo8WLDDG+hgsltVoEi7h1aZwLXydsUlwg5ObmhC9vt/ZYf2X
         urOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WJwRbay8Ah/Gre9RcWy8FUQ3oX58AUkl2tFe9XC6T7U=;
        b=P09PWt7+pmqiz55rDX3R/7oEuMVm1P2EX/6cvVicOAvtZ8gezaLChC/1S+2zGCHJPq
         ulWOFO81/XaWHghlt3s3nzeFgiZmYlVrQuHe6EMfiE2JPHr3HW9HiQQToen4LJTidhPX
         3WVrpqQX5qLl1qabdVkLAIAKMMk5uaJkbNhfiMaZd2qkPBdHLl6RhwcUhwSyuZ7WwKjt
         W1D+iOtNncnFOMRwgOvmV1vIjRpK/rDsbOQEXf6pg83UtAXfBCaLQQH3Rnp6dWusocVB
         nvRj585/ALUGGxvE/fiLQfFRvmCpy3rB5YA57iCJMJa4+Yqtno9GoArddkgdgm9HMmUk
         BDzg==
X-Gm-Message-State: APjAAAXRTkGY8mPr9UUpKxPLGVYe5lbHDJc0oGZRKc0H6LhXeJAGBrvP
        9QuFtIpHZuGBgdk5Uzoz5QHSx6aZD1j+xx4XZVs=
X-Google-Smtp-Source: APXvYqzUPd5CbBM4aOI9TZEkDIUC2DjnsACRNjAcsvtBCK89owNY71u3eAEmmvxF3oR3K/3XmhADbwjt5NhK6FgUWLY=
X-Received: by 2002:a62:ac10:: with SMTP id v16mr8139789pfe.111.1552714496456;
 Fri, 15 Mar 2019 22:34:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190316041154.27619-1-xifeng@redhat.com>
In-Reply-To: <20190316041154.27619-1-xifeng@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Mar 2019 00:34:45 -0500
Message-ID: <CAH2r5mv=WVFgrPAg1LkUYgnsk0z4X94wv2o40Kz0As2aSdqgeA@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix that return -EINVAL when do dedupe operation
To:     XiaoLi Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Xiaoli Feng <fengxiaoli0714@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated and tentatively placed in for-next - running the automated tests now

On Fri, Mar 15, 2019 at 11:12 PM XiaoLi Feng <xifeng@redhat.com> wrote:
>
> From: Xiaoli Feng <fengxiaoli0714@gmail.com>
>
> dedupe_file_range operations is combiled into remap_file_range.
> But it's always skipped for dedupe operations in function
> cifs_remap_file_range.
>
> Example to test:
> Before this patch:
>   # dd if=/dev/zero of=cifs/file bs=1M count=1
>   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
>   XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>
> After this patch:
>   # dd if=/dev/zero of=cifs/file bs=1M count=1
>   # xfs_io -c "dedupe cifs/file 4k 64k 4k" cifs/file
>   XFS_IOC_FILE_EXTENT_SAME: Operation not supported
>
> Influence for xfstests:
> generic/091
> generic/112
> generic/127
> generic/263
> These tests report this error "do_copy_range:: Invalid
> argument" instead of "FIDEDUPERANGE: Invalid argument".
> Because there are still two bugs cause these test failed.
> https://bugzilla.kernel.org/show_bug.cgi?id=202935
> https://bugzilla.kernel.org/show_bug.cgi?id=202785
>
> Signed-off-by: Xiaoli Feng <fengxiaoli0714@gmail.com>
> ---
>
> Sorry, there are some missing in commit log of last patch. Because they
> are beginning with the world '#". The git will ignores these lines.
> And add influence for xfstests.
>
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
