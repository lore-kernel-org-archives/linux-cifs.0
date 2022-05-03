Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A64C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  3 May 2022 09:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiECJPo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 May 2022 05:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiECJPn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 May 2022 05:15:43 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2154C18359
        for <linux-cifs@vger.kernel.org>; Tue,  3 May 2022 02:12:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f2so18112946ioh.7
        for <linux-cifs@vger.kernel.org>; Tue, 03 May 2022 02:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6POublWc4WvGUKmhnPfIk+ge9lrK5PZXXw0EC+W4fAc=;
        b=bGvpQuz+0uyQdtSGCzHXbHIPeVh6Lcd9hdLMN7PRjjQY5v98c/i/z5C7MFiEZOL2Hb
         mAnB00QnZcLEsDxGGgHq4KQFbed6Xm3DTvcCdrsGt7s30PJIxVmmL3ErMJeNGktIT4zI
         JLv7FhvGu1H1/r9l9XX5fVIn9Zhmw7LF5lCc4kCXCFAxwcMMTr7DMAKe5ilkOGstFUmP
         yogpysAU11PVCkSihLi+bJOVmQ6jUpOKYHj+kFEVE/6gBdpU/4xrFtwqir3Kk1ljrOcF
         U+7xktsJi3TdNvjnlyQ8x2ajcnSOBL8s9hLUe1W7bzJT2Y6+df6EtFAxeBt8+Oi63xoM
         m5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6POublWc4WvGUKmhnPfIk+ge9lrK5PZXXw0EC+W4fAc=;
        b=F+KK6yVHN8XB47X8YpxIgtGAFQjsXeIX1TxxyT70aruycAiIv6La3gubd+lblFEdBK
         fDBblX1NBW0MqJX9a3hvsFVhBb5Z/3vGO58wGlaRrXqtih3dKYQy7ttum08Ij4+TnN6Y
         Jh0w2RQmc0Epgw2xupVjmZZCCxJ/XHs4ghDM0lIvDivPwOdfLukJooBuMx4GDMScwS3g
         T8bsKljhmaPt81ObTp3indM5s/qY8KUd/sQgcB93pCwmUJJEZdydOXxwFBVpSp/oyifw
         Ea/WKnhXNnZWezq0CJJfge8CUD+CPEOzIrNxiH4gzsGrtAlWts5WuWdmKdygcj3zSCoA
         nWvQ==
X-Gm-Message-State: AOAM530PEpzkJvsYKiROlRkIO292U2GFIlq+0satDk6kNavkC7gfae0a
        owlT1nwg5yc0kGW+pTa+KCM8K4wGw/qFcadyEgA=
X-Google-Smtp-Source: ABdhPJxzg+eKA2Su44XYjeMCEuh+cnBfsv+VghbpTaBdmkw//j35l4DrVPYky3VNaTQ7t+SGAj/p+erraJPII/3+Ycc=
X-Received: by 2002:a05:6638:300b:b0:317:a127:53ac with SMTP id
 r11-20020a056638300b00b00317a12753acmr6116675jak.77.1651569130379; Tue, 03
 May 2022 02:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <DDB2AB1F-38C5-4295-97AA-2C55616E7CFB@gmail.com>
 <CAB6yy367MHRdxNCBUp9zWf1dJ2oOsJ6NZrLXja4GYfq0QnfjBg@mail.gmail.com>
 <CAH2r5muxKEQxu1NFsjW1pSQyJyUF-upek300iUNJYSU8_EU3WA@mail.gmail.com>
 <CAH2r5msU2oHWoEQhaAGRm6Ob67btPTfvpHXHAwpAae==EFypAw@mail.gmail.com>
 <374470f5-232d-83f2-0f81-9addb07e8773@gmail.com> <CAN05THT=GFbXmGdY1Kt4gT0wTN7=M8A5L+Qpf1o1bmnyjAeq6w@mail.gmail.com>
In-Reply-To: <CAN05THT=GFbXmGdY1Kt4gT0wTN7=M8A5L+Qpf1o1bmnyjAeq6w@mail.gmail.com>
From:   Kinglong Mee <kinglongmee@gmail.com>
Date:   Tue, 3 May 2022 17:11:59 +0800
Message-ID: <CAB6yy36+-T6K7Hma-OAtt4okjhgWqbRORSJXJRTB=vt3FtnPoA@mail.gmail.com>
Subject: Re: [PATCH] cifs: flush all dirty pages to server before read/write
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, ronniesahlberg@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi steve,

What's your opinion about the new fix as nfs does?

On Sun, May 1, 2022 at 6:02 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Sat, 30 Apr 2022 at 06:57, Kinglong Mee <kinglongmee@gmail.com> wrote:
> >
> > Hi steve,
> >
> > On 2022/4/28 10:47 PM, Steve French wrote:
> > > Got some additional review comments/questions about this patch.
> > >
> > > In __cifs_writev isn't it likely that the write will be async and now
> > > become synchronous and also could we now have a duplicated write
> > > (flushing the write, then calling write again on that range)?
> >
> > Yes, you are right.
> > But for a direct write, cifs must writes those buffer pages to server
> > before the direct write is send to server.
> >
> > >
> > > For example, the change you added
> > >
> > > +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > > +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > > +               rc = filemap_write_and_wait(inode->i_mapping);
> > >
> > > will write synchronously all dirty pages but then proceed to call the async
> > >
> > >          rc = cifs_write_from_iter(iocb->ki_pos, ctx->len, &saved_from,
> > >                                    cfile, cifs_sb, &ctx->list, ctx);
> > >
> > > a few lines later.  Won't this kill performance?
> >
> > Yes, it is kill performance.
> > But for cache=none, i don't think the local dirty pages should left
> > when a new direct write coming.
> >
> > >
> > > What was the reason for this part of the patch?  Doesn't the original
> > > code end up in the same place around line 678 in mm/filemap.c
> > >
> > >                          int err2 = filemap_fdatawait_range(mapping,
> > >                                                  lstart, lend);
> > >
> > > called from:
> > >
> > > @@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace
> > > *mnt_userns, const struct path *path,
> > >          if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> > > STATX_BLOCKS)) &&
> > >              !CIFS_CACHE_READ(CIFS_I(inode)) &&
> > >              inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > > -               rc = filemap_fdatawait(inode->i_mapping);
> > > +               rc = filemap_write_and_wait(inode->i_mapping);
> >
> > This fix is the other case when mounting cifs with nolease,
> > # mount -t cifs -ocache=none,nolease,nobrl,guest //cifsserverip/test
> > /mnt/cifs
> > # ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000
> > /mnt/cifs/junkfile
> >
> > fsx-linux fails too.
> >
> > After rethinking of this problem, i think the core problem is
> > the buffer io between direct io. In cifs_getattr, it flushs dirty pages
> > if !CIFS_CACHE_READ(CIFS_I(inode)), but when oplock is granted,
> > it's always false, so the dirty pages are not send to server.
> >
> > With write oplock granted, it's right of don't send those dirty pages to
> > server, but the following direct ios, should be send to server directly,
> > or gets data from the local dirty pages?
> >
> > Maybe cifs should flush all dirty pages at cifs_getattr as NFS
> > nfs_getattr does,
> >
> >          /* Flush out writes to the server in order to update c/mtime.  */
> >          if ((request_mask & (STATX_CTIME | STATX_MTIME)) &&
> >              S_ISREG(inode->i_mode))
> >                  filemap_write_and_wait(inode->i_mapping);
> >
> > After modifing cifs_getattr as following without changing
> > __cifs_readv/__cifs_writev, the fsx-linux test pass at
> > -ocache=none,nolease,nobrl,guest and -ocache=none,nobrl,guest.
> >
> > @@ -2438,9 +2438,8 @@ int cifs_getattr(struct user_namespace
> > *mnt_userns, const struct path *path,
> >           * has actual ctime, mtime and file length.
> >           */
> >          if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> > STATX_BLOCKS)) &&
> > -           !CIFS_CACHE_READ(CIFS_I(inode)) &&
> > -           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > -               rc = filemap_fdatawait(inode->i_mapping);
> > +           S_ISREG(inode->i_mode)) {
> > +               rc = filemap_write_and_wait(inode->i_mapping);
> >                  if (rc) {
> >                          mapping_set_error(inode->i_mapping, rc);
> >                          return rc;
>
> Thanks, Kinglong
> So with this patch, that matches what nfs does, we have a less
> intrusive fix that solves the issue.
> Can you send this as a separate patch to the list for review?
>
>
> >
> > thanks,
> > Kinglong Mee
> >
> > >
> > > On Wed, Apr 27, 2022 at 10:10 PM Steve French <smfrench@gmail.com> wrote:
> > >>
> > >> merged into cifs-2.6.git for-next pending testing
> > >>
> > >> On Sun, Apr 24, 2022 at 10:41 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
> > >>>
> > >>> ping...
> > >>>
> > >>> On Mon, Apr 11, 2022 at 3:39 PM Kinglong Mee <kinglongmee@gmail.com> wrote:
> > >>>>
> > >>>> Testing with ltp, fsx-linux fail as,
> > >>>>
> > >>>> # mount -t cifs -ocache=none,nobrl,guest //cifsserverip/test /mnt/cifs/
> > >>>> # dd if=/dev/zero of=/mnt/cifs//junkfile bs=8192 count=19200 conv=block
> > >>>> # ./testcases/bin/fsx-linux -l 500000 -r 4096 -t 4096 -w 4096 -N 10000 /mnt/cifs/junkfile
> > >>>> skipping zero size read
> > >>>> truncating to largest ever: 0x2c000
> > >>>> READ BAD DATA: offset = 0x1c000, size = 0x9cc0
> > >>>> OFFSET  GOOD    BAD     RANGE
> > >>>> 0x1c000 0x09d2  000000  0x22ed
> > >>>> operation# (mod 256) for the bad dataunknown, check HOLE and EXTEND ops
> > >>>> LOG DUMP (10 total operations):
> > >>>> 1: 1649662377.404010 SKIPPED (no operation)
> > >>>> 2: 1649662377.413729 WRITE    0x3000 thru 0xdece (0xaecf bytes) HOLE
> > >>>> 3: 1649662377.424961 WRITE    0x19000 thru 0x1b410 (0x2411 bytes) HOLE
> > >>>> 4: 1649662377.435135 TRUNCATE UP        from 0x1b411 to 0x2c000 ******WWWW
> > >>>> 5: 1649662377.487010 MAPWRITE 0x5000 thru 0x13077 (0xe078 bytes)
> > >>>> 6: 1649662377.495006 MAPREAD  0x8000 thru 0xe16c (0x616d bytes)
> > >>>> 7: 1649662377.500638 MAPREAD  0x1e000 thru 0x2054d (0x254e bytes)       ***RRRR***
> > >>>> 8: 1649662377.506165 WRITE    0x76000 thru 0x7993f (0x3940 bytes) HOLE
> > >>>> 9: 1649662377.516674 MAPWRITE 0x1a000 thru 0x1e2fe (0x42ff bytes)       ******WWWW
> > >>>> 10: 1649662377.535312 READ     0x1c000 thru 0x25cbf (0x9cc0 bytes)      ***RRRR***
> > >>>> Correct content saved for comparison
> > >>>> (maybe hexdump "/mnt/cifs/junkfile" vs "/mnt/cifs/junkfile.fsxgood")
> > >>>>
> > >>>> Those data written at MAPWRITE is not flush to smb server,
> > >>>> but the fallowing read gets data from the backend.
> > >>>>
> > >>>> Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
> > >>>> ---
> > >>>>   fs/cifs/file.c  | 22 ++++++++++++++++++++++
> > >>>>   fs/cifs/inode.c |  2 +-
> > >>>>   2 files changed, 23 insertions(+), 1 deletion(-)
> > >>>>
> > >>>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > >>>> index d511a78383c3..11912474563e 100644
> > >>>> --- a/fs/cifs/file.c
> > >>>> +++ b/fs/cifs/file.c
> > >>>> @@ -3222,6 +3222,7 @@ static ssize_t __cifs_writev(
> > >>>>          struct kiocb *iocb, struct iov_iter *from, bool direct)
> > >>>>   {
> > >>>>          struct file *file = iocb->ki_filp;
> > >>>> +       struct inode *inode = file_inode(iocb->ki_filp);
> > >>>>          ssize_t total_written = 0;
> > >>>>          struct cifsFileInfo *cfile;
> > >>>>          struct cifs_tcon *tcon;
> > >>>> @@ -3249,6 +3250,16 @@ static ssize_t __cifs_writev(
> > >>>>          cfile = file->private_data;
> > >>>>          tcon = tlink_tcon(cfile->tlink);
> > >>>>
> > >>>> +       /* We need to be sure that all dirty pages are written to the server. */
> > >>>> +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > >>>> +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > >>>> +               rc = filemap_write_and_wait(inode->i_mapping);
> > >>>> +               if (rc) {
> > >>>> +                       mapping_set_error(inode->i_mapping, rc);
> > >>>> +                       return rc;
> > >>>> +               }
> > >>>> +       }
> > >>>> +
> > >>>>          if (!tcon->ses->server->ops->async_writev)
> > >>>>                  return -ENOSYS;
> > >>>>
> > >>>> @@ -3961,6 +3972,7 @@ static ssize_t __cifs_readv(
> > >>>>   {
> > >>>>          size_t len;
> > >>>>          struct file *file = iocb->ki_filp;
> > >>>> +       struct inode *inode = file_inode(iocb->ki_filp);
> > >>>>          struct cifs_sb_info *cifs_sb;
> > >>>>          struct cifsFileInfo *cfile;
> > >>>>          struct cifs_tcon *tcon;
> > >>>> @@ -3986,6 +3998,16 @@ static ssize_t __cifs_readv(
> > >>>>          cfile = file->private_data;
> > >>>>          tcon = tlink_tcon(cfile->tlink);
> > >>>>
> > >>>> +       /* We need to be sure that all dirty pages are written to the server. */
> > >>>> +       if (CIFS_CACHE_WRITE(CIFS_I(inode)) &&
> > >>>> +           inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > >>>> +               rc = filemap_write_and_wait(inode->i_mapping);
> > >>>> +               if (rc) {
> > >>>> +                       mapping_set_error(inode->i_mapping, rc);
> > >>>> +                       return rc;
> > >>>> +               }
> > >>>> +       }
> > >>>> +
> > >>>>          if (!tcon->ses->server->ops->async_readv)
> > >>>>                  return -ENOSYS;
> > >>>>
> > >>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > >>>> index 2f9e7d2f81b6..d5c07196a81e 100644
> > >>>> --- a/fs/cifs/inode.c
> > >>>> +++ b/fs/cifs/inode.c
> > >>>> @@ -2440,7 +2440,7 @@ int cifs_getattr(struct user_namespace *mnt_userns, const struct path *path,
> > >>>>          if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE | STATX_BLOCKS)) &&
> > >>>>              !CIFS_CACHE_READ(CIFS_I(inode)) &&
> > >>>>              inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > >>>> -               rc = filemap_fdatawait(inode->i_mapping);
> > >>>> +               rc = filemap_write_and_wait(inode->i_mapping);
> > >>>>                  if (rc) {
> > >>>>                          mapping_set_error(inode->i_mapping, rc);
> > >>>>                          return rc;
> > >>>> --
> > >>>> 2.35.1
> > >>>>
> > >>
> > >>
> > >>
> > >> --
> > >> Thanks,
> > >>
> > >> Steve
> > >
> > >
> > >
