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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 146D3C433B4
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Apr 2021 20:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E323661245
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Apr 2021 20:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhDQUFm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Apr 2021 16:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbhDQUFl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Apr 2021 16:05:41 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BABC061574
        for <linux-cifs@vger.kernel.org>; Sat, 17 Apr 2021 13:05:14 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n8so50047714lfh.1
        for <linux-cifs@vger.kernel.org>; Sat, 17 Apr 2021 13:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=92hqxEfiAwYzcl8jaurnYrwiNVLgDeGafEpgA4E0JYM=;
        b=oL8SCqswyOgdE2ijyxOTJY/NniAI0XIMUNzaMkmQEMj6Ydj0LVQflvyjxsDJTNPv0k
         hedL06A6fKOujpctrKJvCSKRQ/JAcQ+BXU/HL/44i2Q1WrvVt93Qh5428YMee1VpVmic
         LIJeBx1sGNRd8/a0JAJJGY73gKJwsQpGMMeNXPIJkFpf5YuW6Q/e7x574AEv5wHNxVfO
         IILvBFHYpXP1FrV32Q1gjOy/jPBuZRJoZSR2FWxDDrhCpSPJvVwDI2ia1eDSTh5X6Sys
         k3B6ajS4fxnTmJ+4al6HrSIzIu9AKNgs9QR5hxnchSoi0q0dXy3jGfKT4u/vMJXI8vqm
         zLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=92hqxEfiAwYzcl8jaurnYrwiNVLgDeGafEpgA4E0JYM=;
        b=EXOPOnSqHnqj7idEsTozhBdHi8jZZL4kCUpcgZAxS/9QOrYmNZDzD+bLgs8j/Llpwf
         upSD9cD2h6U2DAFbfTg9CCo5+N6BmULzwyA5eqHYYE8EYU9giE1JZgAfbqXBxVrcBD++
         WUtLBLWIImQgGtRTJKn4+0+jqWqRnnYK3U7f/NjPyAa8irjitu6NRc+EiQK0dgXZtc5x
         oYj42bGrfwS9FWVg0vT+g5hgj104lTLwiJCtwaN7ytowL2KN1hHpWQn0z3zxJj7uoRRF
         N9i5WcIYytC6MFmX+0oFYn4mFcmjyFt27z90Ipw0orbSou/tRhSQyp5TbqXCkHnIVQYb
         vvjQ==
X-Gm-Message-State: AOAM532YgBx2MVR0/kW+mtum28KuJ/0M35QMcBxVdq22kzLkBin5ps/V
        VDqRr391N5PM1cLVZjJeXdDu9kW7pqTDHjNU21/La0T9yBU=
X-Google-Smtp-Source: ABdhPJyVcAZeI5DWyg+/rSmuPBlfbAbHHbqtUqclIiIF9sO4IL0y7mTZyKexKz8oTYbRGaPsNjVYf6Oc3xrLQlwHJyE=
X-Received: by 2002:a05:6512:1322:: with SMTP id x34mr6858799lfu.133.1618689912968;
 Sat, 17 Apr 2021 13:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210416073530.GA21974@himera.home>
In-Reply-To: <20210416073530.GA21974@himera.home>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 17 Apr 2021 15:05:02 -0500
Message-ID: <CAH2r5muwTAmOQ69GRQJgw7uVsqp0z7yi+1jBhjrk8=L5-24HiA@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix out-of-bound memory access when calling
 smb3_notify() at mount point
To:     Eugene Korenevsky <ekorenevsky@astralinux.ru>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added:
   CC: <stable@vger.kernel.org> # v5.6+
and merged into cifs-2.6.git for-next

On Fri, Apr 16, 2021 at 2:42 AM Eugene Korenevsky
<ekorenevsky@astralinux.ru> wrote:
>
> If smb3_notify() is called at mount point of CIFS, build_path_from_dentry()
> returns the pointer to kmalloc-ed memory with terminating zero (this is
> empty FileName to be passed to SMB2 CREATE request). This pointer is assigned
> to the `path` variable.
> Then `path + 1` (to skip first backslash symbol) is passed to
> cifs_convert_path_to_utf16(). This is incorrect for empty path and causes
> out-of-bound memory access.
>
> Get rid of this "increase by one". cifs_convert_path_to_utf16() already
> contains the check for leading backslash in the path.
>
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=212693
> Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index caa5432a5ed1..b13a8e3e1e24 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2264,7 +2264,7 @@ smb3_notify(const unsigned int xid, struct file *pfile,
>                 goto notify_exit;
>         }
>
> -       utf16_path = cifs_convert_path_to_utf16(path + 1, cifs_sb);
> +       utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
>         if (utf16_path == NULL) {
>                 rc = -ENOMEM;
>                 goto notify_exit;
> --
> 2.20.1
>


-- 
Thanks,

Steve
