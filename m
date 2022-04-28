Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CBCC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Apr 2022 03:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiD1DNd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Apr 2022 23:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbiD1DNb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Apr 2022 23:13:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7628B1CB17
        for <linux-cifs@vger.kernel.org>; Wed, 27 Apr 2022 20:10:17 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id p10so6256780lfa.12
        for <linux-cifs@vger.kernel.org>; Wed, 27 Apr 2022 20:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=epgHeNVWl6tmHvKu6FcQWLK6aPclFDroYFEsSIkemD0=;
        b=dXspr/8tHWyLStZ9K2WxznPrDPe9nxykt4SL+iyju1GfP+ApT8UTv/0NScPdUAB6JW
         IpB77GsyoKd7eCjCWFLDze0epsEpVp/EvZMTjiI9jVGizELXoJQ5rFMEjQ/myseHJUft
         gC4Oj7L00CFXqKGWgoJKnW6J93FqzsVTFbnONGSBhbrlSCKDJRRwGatTMHdKXq8PWBaB
         BYHzDcP0fhCNYqUzswilce5z45rIKBq4xQNPJXKUyEYmR5xUWUOPbxI6yG+gemkXF7bJ
         yko0fkFwqN0EgDlmDOIWBFxhgx8790czjuU2oGvsf5BaBN4BjezPDg4t25/ZLK020Jtx
         QnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=epgHeNVWl6tmHvKu6FcQWLK6aPclFDroYFEsSIkemD0=;
        b=peG36C2qYVKlDXffUCTMexUUJqzU6lN01zlyGvYMe2aVNQ98L4ZFyiIbQafE8nB0WF
         +Mj70Mbft41yskOCTNALl/pqJ8gEN+d9TA9cNU6fcdp9B2pgrWM5/RvBSGkAymuWQDqR
         cjgOEQ/cw5MZzunQVsWvR2OhWnIqL676dgRzZ/qBmMqsH9rP8RJCjy2goGEEc5OLnHzT
         W0fhg9MpFIvosI2UofD4Oqg1HZHsWOI3FKLQJAy9Wq7oUbFwr1SlOXK40QHzO/fe9b5A
         Vfh7qaFhChx26wl/7Kw/nW2greA1m3V49fD9KVIWvXZLZ27sqbp8MhbtvRjUj7xjONPa
         rHIw==
X-Gm-Message-State: AOAM533RErBFLPPZbE9q6M+BHjk9LQ2eihTfICkSPqCcAOTwI3BVV7dy
        TzmBHE+4Ingur3jDsfrTphOF+YR69PEB9lFYiB4=
X-Google-Smtp-Source: ABdhPJwkhg/fWPI3Efa33sR5xY7ED7mQ80Wn2OmdqpAhY4q4Yh3e6VCv9wIOngSCLt4jBsqloNfctBdO8pSwkPwkzZ8=
X-Received: by 2002:a05:6512:c26:b0:472:b1d:1d2a with SMTP id
 z38-20020a0565120c2600b004720b1d1d2amr11665320lfu.595.1651115415625; Wed, 27
 Apr 2022 20:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com> <CAB6yy367MHRdxNCBUp9zWf1dJ2oOsJ6NZrLXja4GYfq0QnfjBg@mail.gmail.com>
In-Reply-To: <CAB6yy367MHRdxNCBUp9zWf1dJ2oOsJ6NZrLXja4GYfq0QnfjBg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 27 Apr 2022 22:10:04 -0500
Message-ID: <CAH2r5muxKEQxu1NFsjW1pSQyJyUF-upek300iUNJYSU8_EU3WA@mail.gmail.com>
Subject: Re: [PATCH] cifs: flush all dirty pages to server before read/write
To:     Kinglong Mee <kinglongmee@gmail.com>
Cc:     Steve French <sfrench@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

On Sun, Apr 24, 2022 at 10:41 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
>
> ping...
>
> On Mon, Apr 11, 2022 at 3:39 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
> >
> > Testing with ltp, fsx-linux fail as,
> >
> > # mount -t cifs -ocache=none,nobrl,guest //cifsserverip/test /mnt/cifs/
> > # dd if=/dev/zero of=/mnt/cifs//junkfile bs=8192 count=19200 conv=block
> > # ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/cifs/junkfile
> > skipping zero size read
> > truncating to largest ever: 0x2c000
> > READ BAD DATA: offset = 0x1c000, size = 0x9cc0
> > OFFSET  GOOD    BAD     RANGE
> > 0x1c000 0x09d2  000000  0x22ed
> > operation# (mod 256) for the bad dataunknown, check HOLE and EXTEND ops
> > LOG DUMP (10 total operations):
> > 1: 1649662377.404010 SKIPPED (no operation)
> > 2: 1649662377.413729 WRITE    0x3000 thru 0xdece (0xaecf bytes) HOLE
> > 3: 1649662377.424961 WRITE    0x19000 thru 0x1b410 (0x2411 bytes) HOLE
> > 4: 1649662377.435135 TRUNCATE UP        from 0x1b411 to 0x2c000 ******WWWW
> > 5: 1649662377.487010 MAPWRITE 0x5000 thru 0x13077 (0xe078 bytes)
> > 6: 1649662377.495006 MAPREAD  0x8000 thru 0xe16c (0x616d bytes)
> > 7: 1649662377.500638 MAPREAD  0x1e000 thru 0x2054d (0x254e bytes)       ***RRRR***
> > 8: 1649662377.506165 WRITE    0x76000 thru 0x7993f (0x3940 bytes) HOLE
> > 9: 1649662377.516674 MAPWRITE 0x1a000 thru 0x1e2fe (0x42ff bytes)       ******WWWW
> > 10: 1649662377.535312 READ     0x1c000 thru 0x25cbf (0x9cc0 bytes)      ***RRRR***
> > Correct content saved for comparison
> > (maybe hexdump "/mnt/cifs/junkfile" vs "/mnt/cifs/junkfile.fsxgood")
> >
> > Those data written at MAPWRITE is not flush to smb server,
> > but the fallowing read gets data from the backend.
> >
> > Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
> > ---
> >  fs/cifs/file.c  | 22 ++++++++++++++++++++++
> >  fs/cifs/inode.c |  2 +-
> >  2 files changed, 23 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index d511a78383c3..11912474563e 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -3222,6 +3222,7 @@ static ssize_t __cifs_writev(
> >         struct kiocb *iocb, struct iov_iter *from, bool direct)
> >  {
> >         struct file *file = iocb->ki_filp;
> > +       struct inode *inode = file_inode(iocb->ki_filp);
> >         ssize_t total_written = 0;
> >         struct cifsFileInfo *cfile;
> >         struct cifs_tcon *tcon;
> > @@ -3249,6 +3250,16 @@ static ssize_t __cifs_writev(
> >         cfile = file->private_data;
> >         tcon = tlink_tcon(cfile->tlink);
> >
> > +       /* We need to be sure that all dirty pages are written to the server. */
> > +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > +               rc = filemap_write_and_wait(inode->i_mapping);
> > +               if (rc) {
> > +                       mapping_set_error(inode->i_mapping, rc);
> > +                       return rc;
> > +               }
> > +       }
> > +
> >         if (!tcon->ses->server->ops->async_writev)
> >                 return -ENOSYS;
> >
> > @@ -3961,6 +3972,7 @@ static ssize_t __cifs_readv(
> >  {
> >         size_t len;
> >         struct file *file = iocb->ki_filp;
> > +       struct inode *inode = file_inode(iocb->ki_filp);
> >         struct cifs_sb_info *cifs_sb;
> >         struct cifsFileInfo *cfile;
> >         struct cifs_tcon *tcon;
> > @@ -3986,6 +3998,16 @@ static ssize_t __cifs_readv(
> >         cfile = file->private_data;
> >         tcon = tlink_tcon(cfile->tlink);
> >
> > +       /* We need to be sure that all dirty pages are written to the server. */
> > +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > +               rc = filemap_write_and_wait(inode->i_mapping);
> > +               if (rc) {
> > +                       mapping_set_error(inode->i_mapping, rc);
> > +                       return rc;
> > +               }
> > +       }
> > +
> >         if (!tcon->ses->server->ops->async_readv)
> >                 return -ENOSYS;
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 2f9e7d2f81b6..d5c07196a81e 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
> >         if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
> >             !CIFS_CACHE_READ(CIFS_I(inode)) &&
> >             inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > -               rc = filemap_fdatawait(inode->i_mapping);
> > +               rc = filemap_write_and_wait(inode->i_mapping);
> >                 if (rc) {
> >                         mapping_set_error(inode->i_mapping, rc);
> >                         return rc;
> > --
> > 2.35.1
> >



-- 
Thanks,

Steve
