Return-Path: <SRS0=KHP/=WR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A0CC3A59E
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Aug 2019 16:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D9122D6D
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Aug 2019 16:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGM+I4cV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfHUQkl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Aug 2019 12:40:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44149 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728125AbfHUQkk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Aug 2019 12:40:40 -0400
Received: by mail-pf1-f196.google.com with SMTP id c81so1765907pfc.11
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2019 09:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=apmBza1D/jgq8ysrAYJLKFCh2KTiNJiS02F85HTZxwM=;
        b=MGM+I4cVFJCHEZ3U9SQoxWMpfs5tfCg2ijgNS8TzK9IKDpoS7c63wFR1+BPJ8zxw2Y
         uwbj8cMdLVUwQAtAqj6UmdXXhLVnRLGPWgMtn0l8SaVmn7RKECeqknEMSoqOerbh2mKz
         yKGnZZaQOCWRnOLFYrW85l0xhctwqSgiAquO5s5z7mJHO+fPvd9BPDjGdpGg95qmuRT9
         TBB9056F17W+8OcJds43/dy1hEVfU8X4qd8nzULm+abvqfDbKZWQBMJwEeeF/+gePg2d
         SfiwedOR4z2D+dcyYSawFQ6wVBIox2DVeqMte4TRnK0ov+WsZg6rp2mx47MtmbIt9TAG
         8AYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=apmBza1D/jgq8ysrAYJLKFCh2KTiNJiS02F85HTZxwM=;
        b=j7PYrL+l29YpFUtK9Mpp/FPS2rgGhSMuzAiwbvgjIV1hqoTDAhaMwRcVGbZHlLSi2O
         G+ocpRAOhoN+0IRsT8P0KaxhFZVD+ZGcyr8Ti7V+1lrHA0wOHBH0Xm27HfiABwz9vkSn
         mMvD++tg0XodEmb6RSfpsyOuvgitHja6TJxs7gYb6as3ZL+pS2/DWEK/xdMumY/22yap
         WXk5gOu/IRnJVhlTAzXwhZJXgV/WOx2A5ESX0o8v00/UwuAoIDZYRsBsA6Td/leNecxt
         VZkROWI7hvQm2bRrmJNQfwwMcEIUgvVHCZe+HjBwPzVlvKTjPi1cod/Dxma7xOs2UV9G
         0H0A==
X-Gm-Message-State: APjAAAV8fLIsnve7co36Xm5dBsqYeSeXkgbYiNcBo46wjo777Bs0ada2
        6xPI1KeqkWkcb/Rrw+X4B3pQtL4CQ/wGyzasm4c=
X-Google-Smtp-Source: APXvYqySFNV7Fiio1XWiDQwaqpb6e509tE0QUHo6kTe+WUBLdA3o1pY/qTnJRfbmVkPpvjdkUcQtRwI1933ObaswpKQ=
X-Received: by 2002:a63:7245:: with SMTP id c5mr30322787pgn.11.1566405639720;
 Wed, 21 Aug 2019 09:40:39 -0700 (PDT)
MIME-Version: 1.0
References: <1566309647-67393-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566309647-67393-1-git-send-email-zhengbin13@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Aug 2019 11:40:28 -0500
Message-ID: <CAH2r5mvx7y7B-LsgFY-MSJ1B2OM-87zaVYrQDO3VToey-VjcUw@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove unused variable
To:     zhengbin <zhengbin13@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Aug 20, 2019 at 8:54 AM zhengbin <zhengbin13@huawei.com> wrote:
>
> In smb3_punch_hole, variable cifsi set but not used, remove it.
> In cifs_lock, variable netfid set but not used, remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  fs/cifs/file.c    | 2 --
>  fs/cifs/smb2ops.c | 2 --
>  2 files changed, 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9709069..ab07ae8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1695,7 +1695,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>         struct cifs_tcon *tcon;
>         struct cifsInodeInfo *cinode;
>         struct cifsFileInfo *cfile;
> -       __u16 netfid;
>         __u32 type;
>
>         rc = -EACCES;
> @@ -1711,7 +1710,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>         cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
>                         tcon->ses->server);
>         cifs_sb = CIFS_FILE_SB(file);
> -       netfid = cfile->fid.netfid;
>         cinode = CIFS_I(file_inode(file));
>
>         if (cap_unix(tcon->ses) &&
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 64a5864..f5bbd1d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2939,7 +2939,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>                             loff_t offset, loff_t len)
>  {
>         struct inode *inode;
> -       struct cifsInodeInfo *cifsi;
>         struct cifsFileInfo *cfile = file->private_data;
>         struct file_zero_data_information fsctl_buf;
>         long rc;
> @@ -2949,7 +2948,6 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>         xid = get_xid();
>
>         inode = d_inode(cfile->dentry);
> -       cifsi = CIFS_I(inode);
>
>         /* Need to make file sparse, if not already, before freeing range. */
>         /* Consider adding equivalent for compressed since it could also work */
> --
> 2.7.4
>


-- 
Thanks,

Steve
