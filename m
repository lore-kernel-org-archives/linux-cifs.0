Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50F8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Apr 2022 14:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiD1OvP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Apr 2022 10:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbiD1OvO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Apr 2022 10:51:14 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A63B0D12
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 07:47:59 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x33so9107793lfu.1
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 07:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DcUuB+IvXL4budKrIbxbTPAn+gJvdZqYuiSmYz4Gp1E=;
        b=bZoZk1eK+7wuTJvDFRA6nv2RyX55B/iu7yfJNNUiUO/IvtjfbMIrceVCx0YVF3+cHd
         LXrYsDKaxPJ5o4JKNRh5jO09X85VSo9x7dpjgWl1bGHkFelR8aTaJjZA5p9D64VhCvxp
         wrhNrm0lVigXQ9Lg6W5xTPaZ0WdKx0r6ybCx6djLxWSo1PXVklPv7jVGQ+ehoemwrlL1
         ChJpMevCIn267SXyMYyoGC7GJIHZ2L0S6GI22qGXdjzPi1blI6+x9lk64ElxEKFg8Iuk
         qZPqNzwEYOSz3sJPzdYArWkMBrSTfZZ0l0vuLLaVIxdGo2AkYVQUVTfFn46oO/YLUlFo
         HFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DcUuB+IvXL4budKrIbxbTPAn+gJvdZqYuiSmYz4Gp1E=;
        b=2EOGziTpv8IiaKZFtBqOsaZULaDczFeVXgUlmqLZHU7cqdLIkUS0LGEg3L/N/0iTpz
         VzOj3lnOR+fg6mDH3PBurfqYVvFa718fCI0zThpmvop0vOH9lGYejuGkwfaDUPfDyO1o
         VesKgduDPsc/d53EP3kUdn0O7mEy2+XDSNe9Wu0GqErjqMpobB9AJpPn+7myVdEfxJYH
         c9xKAlBKW/n1zlDlkCj73uLWyzB2jjjLInSeaaMrrqwZH5HFOITNb3YUKlk6eeq6UMeQ
         T/fQqNhr1IhSQu8aZ9xdIV1ahLtkJmEESTF3XAlGrRP1zjU49h/LQ+rmCDO+aQ7IQrYS
         mdwA==
X-Gm-Message-State: AOAM5315CEQo4MuIMbirULIYM9Av+y/GPpzJKip0PbWDi+XHDX6YpylB
        xLC0AFQgTAGb2XtRB/Y9ZONOAiFL+i070+9iE28=
X-Google-Smtp-Source: ABdhPJxsNCmlX2ux9wFhgLpAgdrLFuPsicDZ3Oe13sjRGiFul6/yj+jLehekUgoSRGYPdmp1ANz2yxjF3t0+Mpy6ar0=
X-Received: by 2002:a05:6512:1389:b0:471:a7fa:d5d3 with SMTP id
 p9-20020a056512138900b00471a7fad5d3mr24053823lfa.667.1651157277471; Thu, 28
 Apr 2022 07:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com>
 <CAB6yy367MHRdxNCBUp9zWf1dJ2oOsJ6NZrLXja4GYfq0QnfjBg@mail.gmail.com> <CAH2r5muxKEQxu1NFsjW1pSQyJyUF-upek300iUNJYSU8_EU3WA@mail.gmail.com>
In-Reply-To: <CAH2r5muxKEQxu1NFsjW1pSQyJyUF-upek300iUNJYSU8_EU3WA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 28 Apr 2022 09:47:46 -0500
Message-ID: <CAH2r5msU2oHWoEQhaAGRm6Ob67btPTfvpHXHAwpAae==EFypAw@mail.gmail.com>
Subject: Re: [PATCH] cifs: flush all dirty pages to server before read/write
To:     Kinglong Mee <kinglongmee@gmail.com>
Cc:     Steve French <sfrench@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Got some additional review comments/questions about this patch.

In __cifs_writev isn't it likely that the write will be async and now
become synchronous and also could we now have a duplicated write
(flushing the write, then calling write again on that range)?

For example, the change you added

+       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
+           inode->i_mapping && inode->i_mapping->nrpages != 0) {
+               rc = filemap_write_and_wait(inode->i_mapping);

will write synchronously all dirty pages but then proceed to call the async

        rc = cifs_write_from_iter(iocb->ki_pos, ctx->len, &saved_from,
                                  cfile, cifs_sb, &ctx->list, ctx);

a few lines later.  Won't this kill performance?

What was the reason for this part of the patch?  Doesn't the original
code end up in the same place around line 678 in mm/filemap.c

                        int err2 = filemap_fdatawait_range(mapping,
                                                lstart, lend);

called from:

@@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace
*mnt_userns, const struct path *path,
        if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
STATX_BLOCKS)) &&
            !CIFS_CACHE_READ(CIFS_I(inode)) &&
            inode->i_mapping && inode->i_mapping->nrpages != 0) {
-               rc = filemap_fdatawait(inode->i_mapping);
+               rc = filemap_write_and_wait(inode->i_mapping);

On Wed, Apr 27, 2022 at 10:10 PM Steve French <smfrench@gmail.com> wrote:
>
> merged into cifs-2.6.git for-next pending testing
>
> On Sun, Apr 24, 2022 at 10:41 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
> >
> > ping...
> >
> > On Mon, Apr 11, 2022 at 3:39 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
> > >
> > > Testing with ltp, fsx-linux fail as,
> > >
> > > # mount -t cifs -ocache=none,nobrl,guest //cifsserverip/test /mnt/cifs/
> > > # dd if=/dev/zero of=/mnt/cifs//junkfile bs=8192 count=19200 conv=block
> > > # ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/cifs/junkfile
> > > skipping zero size read
> > > truncating to largest ever: 0x2c000
> > > READ BAD DATA: offset = 0x1c000, size = 0x9cc0
> > > OFFSET  GOOD    BAD     RANGE
> > > 0x1c000 0x09d2  000000  0x22ed
> > > operation# (mod 256) for the bad dataunknown, check HOLE and EXTEND ops
> > > LOG DUMP (10 total operations):
> > > 1: 1649662377.404010 SKIPPED (no operation)
> > > 2: 1649662377.413729 WRITE    0x3000 thru 0xdece (0xaecf bytes) HOLE
> > > 3: 1649662377.424961 WRITE    0x19000 thru 0x1b410 (0x2411 bytes) HOLE
> > > 4: 1649662377.435135 TRUNCATE UP        from 0x1b411 to 0x2c000 ******WWWW
> > > 5: 1649662377.487010 MAPWRITE 0x5000 thru 0x13077 (0xe078 bytes)
> > > 6: 1649662377.495006 MAPREAD  0x8000 thru 0xe16c (0x616d bytes)
> > > 7: 1649662377.500638 MAPREAD  0x1e000 thru 0x2054d (0x254e bytes)       ***RRRR***
> > > 8: 1649662377.506165 WRITE    0x76000 thru 0x7993f (0x3940 bytes) HOLE
> > > 9: 1649662377.516674 MAPWRITE 0x1a000 thru 0x1e2fe (0x42ff bytes)       ******WWWW
> > > 10: 1649662377.535312 READ     0x1c000 thru 0x25cbf (0x9cc0 bytes)      ***RRRR***
> > > Correct content saved for comparison
> > > (maybe hexdump "/mnt/cifs/junkfile" vs "/mnt/cifs/junkfile.fsxgood")
> > >
> > > Those data written at MAPWRITE is not flush to smb server,
> > > but the fallowing read gets data from the backend.
> > >
> > > Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
> > > ---
> > >  fs/cifs/file.c  | 22 ++++++++++++++++++++++
> > >  fs/cifs/inode.c |  2 +-
> > >  2 files changed, 23 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index d511a78383c3..11912474563e 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -3222,6 +3222,7 @@ static ssize_t __cifs_writev(
> > >         struct kiocb *iocb, struct iov_iter *from, bool direct)
> > >  {
> > >         struct file *file = iocb->ki_filp;
> > > +       struct inode *inode = file_inode(iocb->ki_filp);
> > >         ssize_t total_written = 0;
> > >         struct cifsFileInfo *cfile;
> > >         struct cifs_tcon *tcon;
> > > @@ -3249,6 +3250,16 @@ static ssize_t __cifs_writev(
> > >         cfile = file->private_data;
> > >         tcon = tlink_tcon(cfile->tlink);
> > >
> > > +       /* We need to be sure that all dirty pages are written to the server. */
> > > +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > > +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > > +               rc = filemap_write_and_wait(inode->i_mapping);
> > > +               if (rc) {
> > > +                       mapping_set_error(inode->i_mapping, rc);
> > > +                       return rc;
> > > +               }
> > > +       }
> > > +
> > >         if (!tcon->ses->server->ops->async_writev)
> > >                 return -ENOSYS;
> > >
> > > @@ -3961,6 +3972,7 @@ static ssize_t __cifs_readv(
> > >  {
> > >         size_t len;
> > >         struct file *file = iocb->ki_filp;
> > > +       struct inode *inode = file_inode(iocb->ki_filp);
> > >         struct cifs_sb_info *cifs_sb;
> > >         struct cifsFileInfo *cfile;
> > >         struct cifs_tcon *tcon;
> > > @@ -3986,6 +3998,16 @@ static ssize_t __cifs_readv(
> > >         cfile = file->private_data;
> > >         tcon = tlink_tcon(cfile->tlink);
> > >
> > > +       /* We need to be sure that all dirty pages are written to the server. */
> > > +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > > +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > > +               rc = filemap_write_and_wait(inode->i_mapping);
> > > +               if (rc) {
> > > +                       mapping_set_error(inode->i_mapping, rc);
> > > +                       return rc;
> > > +               }
> > > +       }
> > > +
> > >         if (!tcon->ses->server->ops->async_readv)
> > >                 return -ENOSYS;
> > >
> > > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > > index 2f9e7d2f81b6..d5c07196a81e 100644
> > > --- a/fs/cifs/inode.c
> > > +++ b/fs/cifs/inode.c
> > > @@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
> > >         if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
> > >             !CIFS_CACHE_READ(CIFS_I(inode)) &&
> > >             inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > > -               rc = filemap_fdatawait(inode->i_mapping);
> > > +               rc = filemap_write_and_wait(inode->i_mapping);
> > >                 if (rc) {
> > >                         mapping_set_error(inode->i_mapping, rc);
> > >                         return rc;
> > > --
> > > 2.35.1
> > >
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
