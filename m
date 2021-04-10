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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4C2C433ED
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 373E261108
	for <linux-cifs@archiver.kernel.org>; Sat, 10 Apr 2021 00:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhDJA6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbhDJA6C (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 20:58:02 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE34C061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 17:57:48 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r20so8489138ljk.4
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 17:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZ1/mXgiIVj20MK89nYN1cMM5W2kDNX7QlRoFCNwVXM=;
        b=DGJ7bYVZgGQtLYCP7uwNNj5/HsR4bf/aNCdVMZSEDHj6wmHHLVmrIFYorfBrvf7h3i
         4EYHtHCShRmzRdxanscFMFm01kPVeTHaE07TJNL3eTFGqwgzG8K52IzOHmmy/XuGb2i4
         T71AiQzjEBIt2txEGo+xe5SYSu+AWcTV3df/kTS7K2hn8G/OKl6+vWGp24vQuyea1e9A
         zgoc27eEgIDGegl89Q0/LUAQSgT64SnDg4DX5dE1TspTr7aeH8icjf3oS8AG3d4THQ5T
         Kr1cDd7ynhNr3IZl4SUfdsZFdu+Q7rky2xhIomPgqAIruLfiBkmQHwVbP5vIV0wU3RMD
         G9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZ1/mXgiIVj20MK89nYN1cMM5W2kDNX7QlRoFCNwVXM=;
        b=XuXYjE270unHcZARqXKDH1IfaCAoSNwNsVZQyJLtXQKVQXtNnIvshXLQqtfJ/N1wvF
         JXyrjENZdYsNGK8cmE6V7MASwhNjOxly2ZCDzt5ALmQo/VgbXbygAE73bIHa/vSBVmAx
         LsGOywgrKpHSWPii5xQGUl2CPUwwLe9dGEJJcL7BqqzW26Pk9bPGZqYVGVSGvoLkz+HC
         5tuyKOoIN0irzFAmYfMFfglqgKLnVt5RG0lNFbkwRIGbTz1wxy+7c++Rds2iFN/aoNpp
         KR6NLPHWAyLoSeR8puM0O0nUBmQa7K8wo1h5I7pHLB6VwT4Q8gHd2xTsoodDZi5nVDOY
         0gdQ==
X-Gm-Message-State: AOAM532/kHICIxUrWGpiOuU0VPXlthuganHiwNqr9A0FpMr57j6ZkdGB
        GK5NVU8HjcYj59yN1h98EM3wV4pjmkI5VFcphww=
X-Google-Smtp-Source: ABdhPJxM5JTfajJXkydNfKk85RUXRnr7WwaTfjgRhrq73ecUx1VTogD3CxBxuQRD+FNt0KmPR6vSfgZy/DjX+GNWJCU=
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr10781018ljj.148.1618016266868;
 Fri, 09 Apr 2021 17:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210308230735.337-1-lsahlber@redhat.com> <20210308230735.337-5-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-5-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 19:57:35 -0500
Message-ID: <CAH2r5mtM5zc5RTgv4tp+cr1DNuYLk+9Nb-5=E_DNAMtOn3MNOw@mail.gmail.com>
Subject: Re: [PATCH 4/9] cifs: store a pointer to the root dentry in
 cifs_sb_info once we have completed mounting the share
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

looks reasonable

On Mon, Mar 8, 2021 at 5:08 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> And use this to only allow to take out a shared handle once the mount has completed and the
> sb becomes available.
> This will become important in follow up patches where we will start holding a reference to the
> directory dentry for the shared handle during the lifetime of the handle.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_fs_sb.h | 4 ++++
>  fs/cifs/cifsfs.c     | 9 +++++++++
>  fs/cifs/smb2ops.c    | 5 ++++-
>  3 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index aa77edc12212..2a5325a7ae49 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -81,5 +81,9 @@ struct cifs_sb_info {
>          * (cifs_autodisable_serverino) in order to match new mounts.
>          */
>         bool mnt_cifs_serverino_autodisabled;
> +       /*
> +        * Available once the mount has completed.
> +        */
> +       struct dentry *root;
>  };
>  #endif                         /* _CIFS_FS_SB_H */
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3b61f09f3e1b..c075ef1dd755 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -257,6 +257,12 @@ cifs_read_super(struct super_block *sb)
>  static void cifs_kill_sb(struct super_block *sb)
>  {
>         struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> +
> +       if (cifs_sb->root) {
> +               dput(cifs_sb->root);
> +               cifs_sb->root = NULL;
> +       }
> +
>         kill_anon_super(sb);
>         cifs_umount(cifs_sb);
>  }
> @@ -886,6 +892,9 @@ cifs_smb3_do_mount(struct file_system_type *fs_type,
>         if (IS_ERR(root))
>                 goto out_super;
>
> +       if (cifs_sb)
> +               cifs_sb->root = dget(root);
> +
>         cifs_dbg(FYI, "dentry root is: %p\n", root);
>         return root;
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d2858c25ff17..7f4da573b9e8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -751,8 +751,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>         if (tcon->nohandlecache)
>                 return -ENOTSUPP;
>
> +       if (cifs_sb->root == NULL)
> +               return -ENOENT;
> +
>         if (strlen(path))
> -               return -ENOTSUPP;
> +               return -ENOENT;
>
>         mutex_lock(&tcon->crfid.fid_mutex);
>         if (tcon->crfid.is_valid) {
> --
> 2.13.6
>


-- 
Thanks,

Steve
