Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6AEC433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Jun 2022 02:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbiFECbe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 4 Jun 2022 22:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243467AbiFECbe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 4 Jun 2022 22:31:34 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8D57672
        for <linux-cifs@vger.kernel.org>; Sat,  4 Jun 2022 19:31:33 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id b144so4950317vkb.13
        for <linux-cifs@vger.kernel.org>; Sat, 04 Jun 2022 19:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUMQmIE1O5vONhDSIji951/cB4tnUeRigORUdlEwxdE=;
        b=df3uegDBPjFKzbAzoEQbj2PkkKjTDlHB4QVO0wAg6o/GOu4EbVIqE7UJ0XsF48eegC
         4sauPNlMuiwuv2hI33t1HvwK04/O8xuLyeN0vbbSf5iO9+DTvOcEDtL1NNm5tz/Az9mb
         Covmx/9VHJo4YuOOfQ2liPCDiOepAPMmnQY9aNnubK4ObUcNXTsnqU/xbyqLcInQFwwX
         kdmwEiMd7/2uW2l2oom0l3LIgM94CHSd8m/Fdd8GxJOVx57p0ZwMHutIQlv8bxxo8iN/
         /ZShbpVA83K5bCEUMHnOFx+TV4lKBHtRJ9FDVrv+TA21U6TXerhHsudsLafzV80rTRlL
         YrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUMQmIE1O5vONhDSIji951/cB4tnUeRigORUdlEwxdE=;
        b=KvoA6UjHj/t/+YjcBbadm+oMuYpmy0rV9yQJ/D6v1ECVuXL4j59rW07gl+8lGV683/
         AnedPY1qbCLawxjgBnT4Ku/EA7wcM3yc01PqWVbIN+Fpq4ZcZNn71ALB8l/cmJf3o+tX
         MhBwffg8hWRk8T333wW9uzeH4p8QEmdQQLn3TsCCxdQzJDuP38lP6hkICYJ/3UgS8wqV
         cnkJGOwq+/k+r3lxbf0DUhaVW8NN0lcboe+XZ0dIzcDzqFeyHs9iARuapI2bvo3AYLQL
         Sy4cUK8L+hga0BweVfzAEZw17qmXgNw8qthxIxKcSu4+M+qEgX2GrfhMrM6ajcxdfFNg
         9LAQ==
X-Gm-Message-State: AOAM532wT3F1DTmus4Z/iVzkEdRaR4YBn+NndZ26PFKj7mgpmwO/IzUk
        kqmcuC2UI5dSJ/iyR4XkyqCvN4l9PahWBLsnR/s=
X-Google-Smtp-Source: ABdhPJy8Lv7Kriwlrm7iLnwMla8F31OtfxLw4eOf/3ihN0dZ8irrikk9BULyZYMROxQxDtlY9dwhqam05ofSJQjDE+0=
X-Received: by 2002:a1f:5d07:0:b0:35c:e895:934c with SMTP id
 r7-20020a1f5d07000000b0035ce895934cmr10245300vkb.29.1654396292154; Sat, 04
 Jun 2022 19:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <87k09wz0ec.fsf@cjr.nz>
In-Reply-To: <87k09wz0ec.fsf@cjr.nz>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Sat, 4 Jun 2022 22:31:20 -0400
Message-ID: <CAFrh3J9Mrnw0bhJ-S3wYoZfNkKB-QjcLa5=r+vXMNudZ+zATFA@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch appears to fix the issue on the problematic bisected
pre-5.16 kernel. (I let the machine sleep for 3 hours and the mount
still worked after resume.)

I'm now booted into a 5.18.1 kernel with this patch, and I'll be able
to tell tomorrow morning if this also resolves the issue with this
newer kernel.

Thanks for the help in getting this issue resolved!

Regards,

Satadru

On Sat, Jun 4, 2022 at 3:36 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Hi Satadru,
>
> Thanks for providing all requested files off-list.  With that, I ended
> up with below changes that should fix your issue.  Please let us if it
> works.
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 12c872800326..325423180fd2 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1086,7 +1086,7 @@ struct file_system_type cifs_fs_type = {
>  };
>  MODULE_ALIAS_FS("cifs");
>
> -static struct file_system_type smb3_fs_type = {
> +struct file_system_type smb3_fs_type = {
>         .owner = THIS_MODULE,
>         .name = "smb3",
>         .init_fs_context = smb3_init_fs_context,
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index dd7e070ca243..b17be47a8e59 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -38,7 +38,7 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
>         return (unsigned long) dentry->d_fsdata;
>  }
>
> -extern struct file_system_type cifs_fs_type;
> +extern struct file_system_type cifs_fs_type, smb3_fs_type;
>  extern const struct address_space_operations cifs_addr_ops;
>  extern const struct address_space_operations cifs_addr_ops_smallbuf;
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 35962a1a23b9..eeb2a2957a68 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1211,8 +1211,12 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
>                 .data = data,
>                 .sb = NULL,
>         };
> +       struct file_system_type **fs_type = (struct file_system_type *[]) {
> +               &cifs_fs_type, &smb3_fs_type, NULL,
> +       };
>
> -       iterate_supers_type(&cifs_fs_type, f, &sd);
> +       for (; *fs_type; fs_type++)
> +               iterate_supers_type(*fs_type, f, &sd);
>
>         if (!sd.sb)
>                 return ERR_PTR(-EINVAL);
