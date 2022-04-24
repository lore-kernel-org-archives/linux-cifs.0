Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2803C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Apr 2022 09:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238957AbiDXJ6H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Apr 2022 05:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238999AbiDXJ6A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Apr 2022 05:58:00 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3F26D3B2
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 02:54:58 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id 79so12966617iou.7
        for <linux-cifs@vger.kernel.org>; Sun, 24 Apr 2022 02:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQkAqS6x1OsDoWrqTjJtSXoyc+xNlwSsm67A8S3TVHU=;
        b=iuHi9RzGfYhCTyIkSZQWN4w2A5vpGHt8CJPNgHKUBzpYqgFol/2oapTABZ+C3xHKYe
         IwBv0puHmsQOn4xKqEe901m4YEewPfAcVrbQgMZZff5m/dm3ljAtElMoQFRv+1WHbJwj
         5ODo7kSketzS2gc8blGDbOx122m2JEyVEMKhbScWqr5tEa9RjgXfDuzllcViWTPhKW7R
         R7YoEsm1hZNUjETiJK5hAr8m3YFMH5yMZdE7bbQ8eg6nKcVrvK8MefRag/fO7LHT0S5h
         fucTwz7vtyO5ezPxiYJ8WtI6hRwmXCCLwMkVXvJV2E/5y46bGiUIPjkXsuqQs4+PtbbW
         dcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQkAqS6x1OsDoWrqTjJtSXoyc+xNlwSsm67A8S3TVHU=;
        b=7YRjiD6bp6nSRPPmGeeCfl5dJEvURDBfaUT0sw4+0TVYouygCA6Jva9vjulh2csVZy
         GeIG0ZPhZSEWuv1XZlh9dhl29O98t3qT9vLCZpVNUTNXDcwGU7q4OPvSjdRraG/qcxCO
         cB5q2jKyFRfhk+JTAa5O893NEfRRyCJg4VBCWt6dCiNUJnAXtEn6ayr3k5pHmhnUa7v3
         StCrddNcN/st4+P4/PZT3T5CCnq9vnvDOXmXAmW5RHJX/qhNiXJvLtppjsiM8UlIpm3I
         AdoR+dzo74mFRwqFk9E7QdbBr8Tjh+jwqEvKBzFmPfpaapOEdMwmL+t4hCl//EYcIeLF
         3Fuw==
X-Gm-Message-State: AOAM530oOKMHbh1PO9KA2/7Fz0TKO2UJkYDZjlnuzJve7yaTtNNKiovG
        nZqNkX9uoWY87Sn+qGRLQLrmddTImvaJSUNPG0zFPwB/
X-Google-Smtp-Source: ABdhPJxRYnkTAHGSbg2ksL2DypfCmwpT6GxPZ66OzAhLJYlgcIU537FdT1BC3osovqDUG/xsnXp8q1sR/gKrtljlgKE=
X-Received: by 2002:a05:6638:24d6:b0:323:cda4:170d with SMTP id
 y22-20020a05663824d600b00323cda4170dmr5472171jat.269.1650794096261; Sun, 24
 Apr 2022 02:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com>
In-Reply-To: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com>
From:   Kinglong Mee <kinglongmee@gmail.com>
Date:   Sun, 24 Apr 2022 17:54:45 +0800
Message-ID: <CAB6yy367MHRdxNCBUp9zWf1dJ2oOsJ6NZrLXja4GYfq0QnfjBg@mail.gmail.com>
Subject: Re: [PATCH] cifs: flush all dirty pages to server before read/write
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ping...

On Mon, Apr 11, 2022 at 3:39 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
>
> Testing with ltp, fsx-linux fail as,
>
> # mount -t cifs -ocache=none,nobrl,guest //cifsserverip/test /mnt/cifs/
> # dd if=/dev/zero of=/mnt/cifs//junkfile bs=8192 count=19200 conv=block
> # ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/cifs/junkfile
> skipping zero size read
> truncating to largest ever: 0x2c000
> READ BAD DATA: offset = 0x1c000, size = 0x9cc0
> OFFSET  GOOD    BAD     RANGE
> 0x1c000 0x09d2  000000  0x22ed
> operation# (mod 256) for the bad dataunknown, check HOLE and EXTEND ops
> LOG DUMP (10 total operations):
> 1: 1649662377.404010 SKIPPED (no operation)
> 2: 1649662377.413729 WRITE    0x3000 thru 0xdece (0xaecf bytes) HOLE
> 3: 1649662377.424961 WRITE    0x19000 thru 0x1b410 (0x2411 bytes) HOLE
> 4: 1649662377.435135 TRUNCATE UP        from 0x1b411 to 0x2c000 ******WWWW
> 5: 1649662377.487010 MAPWRITE 0x5000 thru 0x13077 (0xe078 bytes)
> 6: 1649662377.495006 MAPREAD  0x8000 thru 0xe16c (0x616d bytes)
> 7: 1649662377.500638 MAPREAD  0x1e000 thru 0x2054d (0x254e bytes)       ***RRRR***
> 8: 1649662377.506165 WRITE    0x76000 thru 0x7993f (0x3940 bytes) HOLE
> 9: 1649662377.516674 MAPWRITE 0x1a000 thru 0x1e2fe (0x42ff bytes)       ******WWWW
> 10: 1649662377.535312 READ     0x1c000 thru 0x25cbf (0x9cc0 bytes)      ***RRRR***
> Correct content saved for comparison
> (maybe hexdump "/mnt/cifs/junkfile" vs "/mnt/cifs/junkfile.fsxgood")
>
> Those data written at MAPWRITE is not flush to smb server,
> but the fallowing read gets data from the backend.
>
> Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
> ---
>  fs/cifs/file.c  | 22 ++++++++++++++++++++++
>  fs/cifs/inode.c |  2 +-
>  2 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index d511a78383c3..11912474563e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -3222,6 +3222,7 @@ static ssize_t __cifs_writev(
>         struct kiocb *iocb, struct iov_iter *from, bool direct)
>  {
>         struct file *file = iocb->ki_filp;
> +       struct inode *inode = file_inode(iocb->ki_filp);
>         ssize_t total_written = 0;
>         struct cifsFileInfo *cfile;
>         struct cifs_tcon *tcon;
> @@ -3249,6 +3250,16 @@ static ssize_t __cifs_writev(
>         cfile = file->private_data;
>         tcon = tlink_tcon(cfile->tlink);
>
> +       /* We need to be sure that all dirty pages are written to the server. */
> +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> +               rc = filemap_write_and_wait(inode->i_mapping);
> +               if (rc) {
> +                       mapping_set_error(inode->i_mapping, rc);
> +                       return rc;
> +               }
> +       }
> +
>         if (!tcon->ses->server->ops->async_writev)
>                 return -ENOSYS;
>
> @@ -3961,6 +3972,7 @@ static ssize_t __cifs_readv(
>  {
>         size_t len;
>         struct file *file = iocb->ki_filp;
> +       struct inode *inode = file_inode(iocb->ki_filp);
>         struct cifs_sb_info *cifs_sb;
>         struct cifsFileInfo *cfile;
>         struct cifs_tcon *tcon;
> @@ -3986,6 +3998,16 @@ static ssize_t __cifs_readv(
>         cfile = file->private_data;
>         tcon = tlink_tcon(cfile->tlink);
>
> +       /* We need to be sure that all dirty pages are written to the server. */
> +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> +               rc = filemap_write_and_wait(inode->i_mapping);
> +               if (rc) {
> +                       mapping_set_error(inode->i_mapping, rc);
> +                       return rc;
> +               }
> +       }
> +
>         if (!tcon->ses->server->ops->async_readv)
>                 return -ENOSYS;
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 2f9e7d2f81b6..d5c07196a81e 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
>         if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
>             !CIFS_CACHE_READ(CIFS_I(inode)) &&
>             inode->i_mapping && inode->i_mapping->nrpages != 0) {
> -               rc = filemap_fdatawait(inode->i_mapping);
> +               rc = filemap_write_and_wait(inode->i_mapping);
>                 if (rc) {
>                         mapping_set_error(inode->i_mapping, rc);
>                         return rc;
> --
> 2.35.1
>
