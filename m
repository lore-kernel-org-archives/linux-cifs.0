Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B717CC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 05:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiFFFpa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 01:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiFFFp2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 01:45:28 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69D51D331
        for <linux-cifs@vger.kernel.org>; Sun,  5 Jun 2022 22:45:26 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id r12so10110473vsg.8
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jun 2022 22:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sX7izraImmF85GOi3wrVKEgZL35ae8uJAx8ihwkmAu0=;
        b=g0M6XKaGGHsrIy+Dzgaf74UuzsEeV6ZbjirAfQyy8Is+b1fWm2rgXFMMsD3mMOuwm1
         Hh8NDqPtHkVaAmvKlUJkiyS1IZWq0Qhz0KdwMQOEeDWUV63MRDmoAJWq1BOa6vfx2J4T
         rXm1G1pM4Uq6s2VRI8EfkhY5HrOLPbFDh5Yrvo67ZhnAqjeCk53w6yq1zIQ0xXKmSEHi
         /kPgr8JvcpzR8w/bRoSZ8H6QW00ArcbkSPeoaHbQqNQJmIagdZ/UlhKMZG5kKxLeGxwH
         DChyRVUTMx04oyBB75FCKmovNtppxCVROWJi+bfBK08rMaidto0EzOKoZ3hGwB4Hr/M+
         8DDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sX7izraImmF85GOi3wrVKEgZL35ae8uJAx8ihwkmAu0=;
        b=jvNeslTWLyASSV/SEsFVFTWs+KlBhgeJJ/vsOC0wodkGOK6NamrUkjJbOUMNr174Pj
         9VLEk3U2KsRaGX7BL6BhXCXmXQERl2HBDovXHR5JGHAyZRiOx7tACTmPeBxvkvRW7C7Y
         c5wk7nZQfunLYfrSi2vYCTmes4q2NMZNgwX5qzgk2g0Xdu3BndyIlMZyk8F7vBmX8RV0
         l6hJNszQl66ueKwcwYvUzeC9CUonjYRrz1O/Pu+SlhYo4xr1HPe5oMUuEmmLjvH+mCgD
         L6zGLS2mwx/J+CDfep4eVpEZcf3DaVh8E9/c66+5thvIfjlxsfzjeOUwa+33t8zcFtfj
         RBcA==
X-Gm-Message-State: AOAM533XGf0pg9lGMvx6KojTfcEZmArh0RodFCXx9JLdq5fLmYNnGyq1
        LvDbzHnAA0wOc64RHImHcGcpMr0xvhfB5LBP2BM=
X-Google-Smtp-Source: ABdhPJzuFO96nVn6ea012qz4pLm0NXZzg3PPPkGaAAK4IweR2mlGGEGLhT5Akln5mMQ0S8EDRIsQ/EaTAx59xUU4Nnw=
X-Received: by 2002:a05:6102:1052:b0:34b:8a41:b963 with SMTP id
 h18-20020a056102105200b0034b8a41b963mr7914293vsq.17.1654494325686; Sun, 05
 Jun 2022 22:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220605225426.8558-1-pc@cjr.nz>
In-Reply-To: <20220605225426.8558-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 Jun 2022 00:45:14 -0500
Message-ID: <CAH2r5msEhVTuSqeBuife=sOen0YRdOg0utwLAR5PfYOngOzeFg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix reconnect on smb3 mount types
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Satadru Pramanik <satadru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added cc:stable and tested-by and put updated patch in cifs-2.6.git for-next

On Sun, Jun 5, 2022 at 5:54 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> cifs.ko defines two file system types: cifs & smb3, and
> __cifs_get_super() was not including smb3 file system type when
> looking up superblocks, therefore failing to reconnect tcons in
> cifs_tree_connect().
>
> Fix this by calling iterate_supers_type() on both file system types.
>
> Link: https://lore.kernel.org/r/CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com
> Reported-by: Satadru Pramanik <satadru@gmail.com>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsfs.c |  2 +-
>  fs/cifs/cifsfs.h |  2 +-
>  fs/cifs/misc.c   | 27 ++++++++++++++++-----------
>  3 files changed, 18 insertions(+), 13 deletions(-)
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
> index 35962a1a23b9..8e67a2d406ab 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -1211,18 +1211,23 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
>                 .data = data,
>                 .sb = NULL,
>         };
> +       struct file_system_type **fs_type = (struct file_system_type *[]) {
> +               &cifs_fs_type, &smb3_fs_type, NULL,
> +       };
>
> -       iterate_supers_type(&cifs_fs_type, f, &sd);
> -
> -       if (!sd.sb)
> -               return ERR_PTR(-EINVAL);
> -       /*
> -        * Grab an active reference in order to prevent automounts (DFS links)
> -        * of expiring and then freeing up our cifs superblock pointer while
> -        * we're doing failover.
> -        */
> -       cifs_sb_active(sd.sb);
> -       return sd.sb;
> +       for (; *fs_type; fs_type++) {
> +               iterate_supers_type(*fs_type, f, &sd);
> +               if (sd.sb) {
> +                       /*
> +                        * Grab an active reference in order to prevent automounts (DFS links)
> +                        * of expiring and then freeing up our cifs superblock pointer while
> +                        * we're doing failover.
> +                        */
> +                       cifs_sb_active(sd.sb);
> +                       return sd.sb;
> +               }
> +       }
> +       return ERR_PTR(-EINVAL);
>  }
>
>  static void __cifs_put_super(struct super_block *sb)
> --
> 2.36.1
>


-- 
Thanks,

Steve
