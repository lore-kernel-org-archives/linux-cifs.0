Return-Path: <SRS0=t+Ft=AK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D501C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6606C206C3
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Jun 2020 01:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWEGavXB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgF2Bno (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 28 Jun 2020 21:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgF2Bnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 28 Jun 2020 21:43:43 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF860C03E979
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2020 18:43:43 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id j202so7651943ybg.6
        for <linux-cifs@vger.kernel.org>; Sun, 28 Jun 2020 18:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=0Km95PiXvt8YcjjLHTYKyBvq8nZQm142W8W3bUFdbOY=;
        b=BWEGavXBU0qUU7OX/lznbolM1MSz1XPKiHiQsl9RCK6ctAgZoAhRwcmHeyOv/fz171
         x6dKGWnSwqM7mDEnnzBNv+l1iq9WGPHEhHJZNFCgaCQ7QgHz4Nvm4V88lxiXRFwgq3R+
         A3YdJak6gqO5Bl537Vn0H0Rjzu16XzYEwUoBwQa0IarOIaSItTU5E2cdmLhsKgw2KjYA
         /PYzovcJL+RLgLnAt2P4+zROskz8BiuVUht7+9kFYPIC7kv6/HXpQFZMawW8sS8MAuk/
         YIfOmUm8FgzVTVNofMvYIyXmqdsmicciu1Ni7gKm/KSeXs457AgSLORtBV3aGktwCUf7
         Naag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=0Km95PiXvt8YcjjLHTYKyBvq8nZQm142W8W3bUFdbOY=;
        b=exAadrsD3clPs7rmUkiMhOsa1Kseg6xHRqbFf60UDDJsEj++or152c0eA7g1tnIU+U
         k/C6xczO4qof19IrW/6ub3bzsG1C0S3llYF1k1lMFxmsfbp+3YUavthLOmzCexO9r5oH
         qO9L0EhHpICpabUqS+5OFXC0gdSD12XdW7u9+WNhQyp7WF4lKynU06UgjJJ8mI3d0YN9
         Oxtj0hpwGMddiTWoujhQhL7fZGwb/DaEmRSBreGgxotjnrgxhjgcTODGNu/4peiktjeM
         jX+1E7uMSAlD8LockRiaURlNMKeIhW/MTHQm5uDiwyF3Tj6xZn7pzbJXN+WXRG7zTII0
         L9hQ==
X-Gm-Message-State: AOAM532r+M6E+HKO3Y9TpwEesdRJmxx22v6TLZiyB7hEt+pQfo8xVEKi
        N6iAvRpfLBpKXVWgVIEaivgtKARP2Erdinmbls0=
X-Google-Smtp-Source: ABdhPJzvHWVDUuDCP7xrMK2Cuid5Na4OYZevAkx9QlaBb2Zm7bLdgShRLjLE7P9Yz04wsiYIuxE1is6tSyL+qg/7ofE=
X-Received: by 2002:a25:d217:: with SMTP id j23mr22422400ybg.85.1593395022855;
 Sun, 28 Jun 2020 18:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200629010638.3418176-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20200629010638.3418176-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 28 Jun 2020 20:43:32 -0500
Message-ID: <CAH2r5msXBPpGzFfYY+R7RB5XxrFmw5kJTFEwVL4-tKZGcb6YLw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix the target file was deleted when rename failed.
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git pending review and testing

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/5/builds/73

On Sun, Jun 28, 2020 at 8:05 PM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> When xfstest generic/035, we found the target file was deleted
> if the rename return -EACESS.
>
> In cifs_rename2, we unlink the positive target dentry if rename
> failed with EACESS or EEXIST, even if the target dentry is positived
> before rename. Then the existing file was deleted.
>
> We should just delete the target file which created during the
> rename.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/inode.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index ce95801e9b66..49c3ea8aa845 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2044,6 +2044,7 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
>         FILE_UNIX_BASIC_INFO *info_buf_target;
>         unsigned int xid;
>         int rc, tmprc;
> +       bool new_target = d_really_is_negative(target_dentry);
>
>         if (flags & ~RENAME_NOREPLACE)
>                 return -EINVAL;
> @@ -2120,8 +2121,13 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
>          */
>
>  unlink_target:
> -       /* Try unlinking the target dentry if it's not negative */
> -       if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
> +       /*
> +        * If the target dentry was created during the rename, try
> +        * unlinking it if it's not negative
> +        */
> +       if (new_target &&
> +           d_really_is_positive(target_dentry) &&
> +           (rc == -EACCES || rc == -EEXIST)) {
>                 if (d_is_dir(target_dentry))
>                         tmprc = cifs_rmdir(target_dir, target_dentry);
>                 else
> --
> 2.25.4
>


-- 
Thanks,

Steve
