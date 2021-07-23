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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E029C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 02:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 300EB60EC0
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jul 2021 02:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGWBp3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 21:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbhGWBp3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 21:45:29 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482C1C061575
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 19:26:02 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id b26so11558285lfo.4
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 19:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eu5y6PwPeTl7+lzc0ZYq/q/z+iVy2oY+toaq93aDqsQ=;
        b=dfAAAOLPLCHquOkOF0JshKHADdA7/dx91HKCyin6wJ1ze9sYYF9sjDyod7CjrdJVCy
         kpS/Z4aW468uVqpfLdXdZ5QmWH/os5SJiFSSDVp0nZ+tkjNjrjXRCJ2BNbQF1MMBjCGx
         Zce0D+rGjpbSsLG1E2K7KOJy7V5kU3Cqv67V1k0v73suLb/tpzj+rneKMjyk9jrq6sgr
         9+wxwxNdH80L+5GfP2rUoyF2wXC77T5HXTkAejeg+yE5b/VahJU1yPcHpL6BQhydvngK
         a/s17fEG3IWYTpvbdz1GN+1hTFwo4Yp46AAxybsU3mcin8qp8HW4xP9gWUr3JOqkEeCZ
         T3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eu5y6PwPeTl7+lzc0ZYq/q/z+iVy2oY+toaq93aDqsQ=;
        b=EVGLdJqD5MjeHgC0QvUbChBzL8kKHHOMod4Vh6bxroPX4dHMPKa3ZPzjYhzXt9QYL0
         4JsInHDv4HpKsl6rMjPTFaf1aGjvqiKKoqSIZILyCMxxNL/CjcuLmW/sNKrJOr+mvGzI
         PF1XrhYUjZEUl9oaPlKej2DZ5rzrsOyRQ0LMIQ/6pSNx4f/J40nYLY7E8wuGaduIMIxL
         +fH/9LA955zVTDYD6q3OJyvchemHZl6D7DXGUinjHBHCVMdKIVd5wF8WdNGeRU7Hcd1x
         cDw6yZAxJt4ACehmLnzZcMYoapImXoC14PocZXl+QbsMJIvT06g5K1dcphkMwFkYcO6V
         IINA==
X-Gm-Message-State: AOAM531t96nkQLSCJ4OpkQ3mNuHcTfPs9Xbn2DzD1YyQT8392Xg0vB2B
        o6opsky0MitYyjZrm3A0TaIDi3esaXiXi0+78n4=
X-Google-Smtp-Source: ABdhPJwMfEgoNSZBYS/aZjM0ENfj1CkxylOXRZ5CmyzWwDmrHzNpTtWvemG0L6yEeipwE+u77rB/4QDOs2mg/Ubodw4=
X-Received: by 2002:ac2:4845:: with SMTP id 5mr1537430lfy.313.1627007160537;
 Thu, 22 Jul 2021 19:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210723012124.3405007-1-lsahlber@redhat.com>
In-Reply-To: <20210723012124.3405007-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 22 Jul 2021 21:25:49 -0500
Message-ID: <CAH2r5mvQbdcCpHW+g+p54Sjdj+DP-pwtbsJ=o7KxFaRweo-Yew@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix fallocate when trying to allocate a hole.
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With the minor fix to change the rc from EFBIG to 0 to address the
xfstest 071 failure, tentatively merged into cifs-2.6.git for-next
pending more testing

On Thu, Jul 22, 2021 at 8:21 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Remove the conditional checking for out_data_len and skipping the fallocate
> if it is 0. This is wrong will actually change any legitimate the fallocate
> where the entire region is unallocated into a no-op.
>
> Additionally, before allocating the range, if FALLOC_FL_KEEP_SIZE is set then
> we need to clamp the length of the fallocate region as to not extend the size of the file.
>
> Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 5cefb5972396..238717654e46 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3667,11 +3667,6 @@ static int smb3_simple_fallocate_range(unsigned int xid,
>                         (char **)&out_data, &out_data_len);
>         if (rc)
>                 goto out;
> -       /*
> -        * It is already all allocated
> -        */
> -       if (out_data_len == 0)
> -               goto out;
>
>         buf = kzalloc(1024 * 1024, GFP_KERNEL);
>         if (buf == NULL) {
> @@ -3794,6 +3789,24 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>                 goto out;
>         }
>
> +       if (keep_size == true) {
> +               /*
> +                * We can not preallocate pages beyond the end of the file
> +                * in SMB2.
> +                */
> +               if (off >= i_size_read(inode)) {
> +                       rc = -EFBIG;
> +                       goto out;
> +               }
> +               /*
> +                * For fallocates that are partially beyond the end of file,
> +                * clamp len so we only fallocate up to the end of file.
> +                */
> +               if (off + len > i_size_read(inode)) {
> +                       len = i_size_read(inode) - off;
> +               }
> +       }
> +
>         if ((keep_size == true) || (i_size_read(inode) >= off + len)) {
>                 /*
>                  * At this point, we are trying to fallocate an internal
> --
> 2.30.2
>


-- 
Thanks,

Steve
