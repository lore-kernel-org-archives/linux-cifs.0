Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3BEC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Apr 2022 03:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiDUEAI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Apr 2022 00:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiDUEAH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Apr 2022 00:00:07 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B0CBE15
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:57:18 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id c15so4221304ljr.9
        for <linux-cifs@vger.kernel.org>; Wed, 20 Apr 2022 20:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HvRwRALQH249Uz+daKe0GJEjkJCepCv9E5ai9UtWMtY=;
        b=nh5ZNDsg7Ui7Z0z8V5+4nXJ8HPT6mge8SkH1ulVZcnoDFs8UZ4RObrIK2Nict3A7F3
         2X6S/R3nPqf57lHmoTZ791rte4+aoonxfhQMZy7rR/NYNchmODXHhplooFK9LiuaCk3i
         EEjuPI6rprQUp/VeZwI5FEd2b5HRQfmiZZLRxeJ+yhgvMiLhKHauRZiNmkv+txbe1v4d
         jd/J0gt8xl1TaUNHA0ieCflPG5joeCvf6WHDtzxoZ/nbWN5JlnjfEmplNbFsRouzlspE
         mC5YY0x9k0R6HtrcXjXxbLN+3gth7oyuMIqqAVg51iQKIwX/WWaq8+bsUlfixcaK+W4S
         COwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HvRwRALQH249Uz+daKe0GJEjkJCepCv9E5ai9UtWMtY=;
        b=hTvqBTSEtuDYJyn3qN4c4PATwJWIVk0nCYvFk/gDKwANTxzsYSkdXUODHQTdZM8KIK
         jDL4jKeb2nBAAiKIQdycsAUMOR6mhx0ZJO5cFu1LC+QZZKYeczO95cPKMVXhmS1OKY0Y
         XQHn/kDwTpNTFEbdbCLirrF2kf8HULSO6pv+txKnTQjEsSy3vDGxlSFTld85Eyorgp+q
         nUmjpQ4CUSWkfwZlct0agoMRzS9SE+NfVtoFYqvgDjvg41q53zALkZm4NJ3JqoL3j4tA
         tIaLKR+Pd+XlUOqbbXg4/xCg9vcPnCgV5ToDMeVY1cJiVNK/FRt+jQh9mdvG/spql9+O
         Mg9Q==
X-Gm-Message-State: AOAM5326zoyIGGfUAzU3/sIjNLJxJiQg1r9MSAh04ISp/yClJdrMSoaF
        5ya/ehTqBwSlhS78I6OAhobP2qbduiFpUt3++wwhal48
X-Google-Smtp-Source: ABdhPJyMT6q4iSoPY0fofl9QuF2HG0Bh17oYN9MIjfQlhg3SlDVaAkvsUQH2dyQjmOhFyyMYuQrZp2vR1Gwyvh1genw=
X-Received: by 2002:a05:651c:1542:b0:249:5d86:3164 with SMTP id
 y2-20020a05651c154200b002495d863164mr15573932ljp.500.1650513436332; Wed, 20
 Apr 2022 20:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220421011536.1859398-1-lsahlber@redhat.com>
In-Reply-To: <20220421011536.1859398-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 20 Apr 2022 22:57:05 -0500
Message-ID: <CAH2r5mtVTnXZ4LZt1e_cyB=MywxDoxVOg=AaBSzUvhikoihixA@mail.gmail.com>
Subject: Re: [PATCH] cifs: destage any unwritten data to the server before
 calling copychunk_write
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, Apr 20, 2022 at 8:15 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> because the copychunk_write might cover a region of the file that has not yet
> been sent to the server and thus fail.
>
> A simple way to reproduce this is:
> truncate -s 0 /mnt/testfile; strace -f -o x -ttT xfs_io -i -f -c 'pwrite 0k 128k' -c 'fcollapse 16k 24k' /mnt/testfile
>
> the issue is that the 'pwrite 0k 128k' becomes rearranged on the wire with
> the 'fcollapse 16k 24k' due to write-back caching.
>
> fcollapse is implemented in cifs.ko as a SMB2 IOCTL(COPYCHUNK_WRITE) call
> and it will fail serverside since the file is still 0b in size serverside
> until the writes have been destaged.
> To avoid this we must ensure that we destage any unwritten data to the
> server before calling COPYCHUNK_WRITE.
>
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1997373
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index a67df8eaf702..d6aaeff4a30a 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1858,9 +1858,17 @@ smb2_copychunk_range(const unsigned int xid,
>         int chunks_copied = 0;
>         bool chunk_sizes_updated = false;
>         ssize_t bytes_written, total_bytes_written = 0;
> +       struct inode *inode;
>
>         pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
>
> +       /*
> +        * We need to flush all unwritten data before we can send the
> +        * copychunk ioctl to the server.
> +        */
> +       inode = d_inode(trgtfile->dentry);
> +       filemap_write_and_wait(inode->i_mapping);
> +
>         if (pcchunk == NULL)
>                 return -ENOMEM;
>
> --
> 2.30.2
>


-- 
Thanks,

Steve
