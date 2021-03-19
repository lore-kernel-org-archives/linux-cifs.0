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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FCFC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 17:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 856986197B
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 17:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCSRm2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbhCSRmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 13:42:15 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351E3C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 10:42:15 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 15so13056963ljj.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 10:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f7jERcNSWG8Z4amQ72Rr6M281tm+mc/ro8S/RkZhvDY=;
        b=qKAlE4lprGMRcweNmt5Yu2Vo0sQaF8ormwzErqAbrT6szOkfNhGnsD/Twn0CY7SSs1
         nrBVNdEYR3d5PkDLeEynE6fujmbTOoCeHcEid42gygB9orIfDFPeY++h37SaqUL+psFu
         XhH8hmlOKV+nAIMXAv6uTyBWsIwwa1lI7mVPO0Asl0QmGXQ2efCz41cXOW5lx+UM4kzO
         qvpGsk0y0pza9whQA+Ep8dGakyqUeXqHsVazBS9LkDlhlwYkVEduUuVRIm/YacbS75ya
         j1qPxTYqNAU1Qe441G48YKjXRvLj8auaBt/XkBsxTY9rRiQWdQ18XJA3yPGKH4zHR4O1
         bQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f7jERcNSWG8Z4amQ72Rr6M281tm+mc/ro8S/RkZhvDY=;
        b=JNk/Z4Hv/cBdQnPy5fx8R14UTqHKR66nPbclFv0QE3PTD6Y+E2liUcdf8g7bTn4kRF
         n39dqFXOIEheaQ4xHiD0Azb90RF9ps9qb3A1zirLaDFcC1kKHTkBZd52a7hiwN+Qex/U
         SEx9S18EzOXVvesd+5vC38NICL2kze8fLVsowbo3BENvjlxvFPtiiSzVahiVYSXwvI1+
         KggU1bXcQHhVIsFN7Mdjc+8THoVa100fNDq/OlYYPpnLbBV1uXjo22aNFJCtynoSaqHy
         FTVL3p0VgYkZh63MQuqVMYPlZ1YPdKtQ7VGQ/jNPThwQophpWvjdzDlZjAmf5/HjJguT
         CrSQ==
X-Gm-Message-State: AOAM530jPOg092gwM9aE9w9TcxhE6RKbdX+BKDzRK+DFy/Pc3XGfKqIj
        we/2gygYjG+/WEHzXN26N32RRxrsvr/jQ9oZdcCUwzVQ6ZaG0Q==
X-Google-Smtp-Source: ABdhPJwjnUIPU29yrp+ven15jutyur/8klcxoERBPQMoOdD3P5hoOmH1FrFBuZe5thEzwb1u+DBP8NJlleW7TX9sWgw=
X-Received: by 2002:a2e:9858:: with SMTP id e24mr1604570ljj.477.1616175733675;
 Fri, 19 Mar 2021 10:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
 <750943d3-9717-fcd8-71ec-986a07e7eca0@talpey.com>
In-Reply-To: <750943d3-9717-fcd8-71ec-986a07e7eca0@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 12:42:02 -0500
Message-ID: <CAH2r5muawhYVa7a=TEmaDgH1t6fvubEJvaUP1-XscNq9Qjy4rw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We report the block size properly (typically much larger) - but the
kernel API returns allocation size in 512 byte units no matter what the
block size is.   Number of blocks returned for the kernel API
     inode->i_blocks
is unrelated to the block size (simply allocation_size/512 rounded up by 1).

On Fri, Mar 19, 2021 at 12:38 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/19/2021 1:25 AM, Steve French wrote:
> > Applications that create and extend and write to a file do not
> > expect to see 0 allocation size.  When file is extended,
> > set its allocation size to a plausible value until we have a
> > chance to query the server for it.  When the file is cached
> > this will prevent showing an impossible number of allocated
> > blocks (like 0).  This fixes e.g. xfstests 614 which does
> >
> >      1) create a file and set its size to 64K
> >      2) mmap write 64K to the file
> >      3) stat -c %b for the file (to query the number of allocated blocks)
> >
> > It was failing because we returned 0 blocks.  Even though we would
> > return the correct cached file size, we returned an impossible
> > allocation size.
> >
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > CC: <stable@vger.kernel.org>
> > ---
> >   fs/cifs/inode.c | 12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index 7c61bc9573c0..17a2c87b811c 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2395,7 +2395,7 @@ int cifs_getattr(struct user_namespace
> > *mnt_userns, const struct path *path,
> >    * We need to be sure that all dirty pages are written and the server
> >    * has actual ctime, mtime and file length.
> >    */
> > - if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
> > + if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> > STATX_BLOCKS)) &&
> >        !CIFS_CACHE_READ(CIFS_I(inode)) &&
> >        inode->i_mapping && inode->i_mapping->nrpages != 0) {
> >    rc = filemap_fdatawait(inode->i_mapping);
> > @@ -2585,6 +2585,14 @@ cifs_set_file_size(struct inode *inode, struct
> > iattr *attrs,
> >    if (rc == 0) {
> >    cifsInode->server_eof = attrs->ia_size;
> >    cifs_setsize(inode, attrs->ia_size);
> > + /*
> > + * i_blocks is not related to (i_size / i_blksize),
> > + * but instead 512 byte (2**9) size is required for
> > + * calculating num blocks. Until we can query the
> > + * server for actual allocation size, this is best estimate
> > + * we have for the blocks allocated for this file
> > + */
> > + inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
>
> I don't think 512 is a very robust choice, no server uses anything
> so small any more. MS-FSA requires the allocation quantum to be the
> volume cluster size. Is that value available locally?
>
> Tom.
>
> >    /*
> >    * The man page of truncate says if the size changed,
> > @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
> > struct iattr *attrs)
> >    sys_utimes in which case we ought to fail the call back to
> >    the user when the server rejects the call */
> >    if ((rc) && (attrs->ia_valid &
> > - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> > +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> >    rc = 0;
> >    }
> >



-- 
Thanks,

Steve
