Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E00EC433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 19 Jan 2022 09:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353327AbiASJsh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 Jan 2022 04:48:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353343AbiASJsc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 19 Jan 2022 04:48:32 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A9DC06161C
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 01:48:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 30so8579158edv.3
        for <linux-cifs@vger.kernel.org>; Wed, 19 Jan 2022 01:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IVCPFov7KvarrvK7GFlUMAPRVZfDajPFlPM1dU7MIbM=;
        b=T46TRr4C71zCuHrX0pAzK8hrmH0PLpxp7l0am/j7i1AoFrGbw0KnF3lYzsyOZjTCGT
         /iiNB5eVYd4YPXT513WmWZrTkxRyNhgIEWsy9hbSodigoEXF/zN1wgAlwNo0PN7cbk7D
         Wv/I1Foj8if6+7QcNU6ddcqNnk4NjjR0FSKFOtEZ8CT2TnGePioGdV13AFfCMlD2zMdb
         cFkLvY+bpTqz5NCshNqgNuB+/V4b2MSZr01fhBts/Rbt5eMre4MbfmHWSeD213IPkOgI
         dNt6Sxn4ivRfORmBmZldKukyZy6Wy/oIxVbwzH9ZI4uNuGXQPofJgDf5eL5nyCSEPu4k
         U+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IVCPFov7KvarrvK7GFlUMAPRVZfDajPFlPM1dU7MIbM=;
        b=P0GwwLKz9BZ8qjYnQqCSCNt/p6mJxsO/ldUI8f33PEap4Aj1bTw0e11xJFwjjo3YnD
         SAcsiA8YPNeFZ8ec9HhYN4IuEe/z8u2l2eILPa9P/Rhmdw/7vjX2/+p/yAKhnJa7kPg/
         +O3O5HsrwqRVFtf4GJVTnrJZLQthQkx+O3Ge0INbNjwK4pcOr0o1TSIkzWJdR61A5EP8
         NXCb8E1wt5qkuwQFc53r9m8H12eXXVjNEGsh7BmbA3KDNBuQI7h224pNKydak4rFo0mc
         0f0k5Ztdqj/kCm8SApipvWDF2L6Rdvp4QIv2k4bD7TIocTHjzuR020yX7PIqvxcavAfw
         WCCg==
X-Gm-Message-State: AOAM531V1Qpx2FK62pS9QnEeBh+juNLXZG5hdfTv0Kq1qPAB5SQLq+4y
        1TNIgWZjJmuiDKcUj8l6yrvU7H+Q7AtaguyUa/M=
X-Google-Smtp-Source: ABdhPJzCDkCHHJSmgYyHBHjwzUvV/ayqcmc3H9a+8x0Q6kqS0IZ74NO6IWvs4Mk6BFUmhKSgNR1NHbOiR/b/TmRb8a4=
X-Received: by 2002:a17:907:20ad:: with SMTP id pw13mr2683714ejb.73.1642585710586;
 Wed, 19 Jan 2022 01:48:30 -0800 (PST)
MIME-Version: 1.0
References: <164251396932.3435901.344517748027321142.stgit@warthog.procyon.org.uk>
 <164251411336.3435901.17077059669994001060.stgit@warthog.procyon.org.uk>
 <CAH2r5muTanw9pJqzAHd01d9A8keeChkzGsCEH6=0rHutVLAF-A@mail.gmail.com> <3762846.1642581170@warthog.procyon.org.uk>
In-Reply-To: <3762846.1642581170@warthog.procyon.org.uk>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 19 Jan 2022 15:18:19 +0530
Message-ID: <CANT5p=pM_frmMwyLcXeCHsSDObz=nKXs_juy3vaKYh=rkNFFRw@mail.gmail.com>
Subject: Re: [PATCH 11/11] cifs: Support fscache indexing rewrite
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jan 19, 2022 at 2:02 PM David Howells <dhowells@redhat.com> wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > WARNING: Missing a blank line after declarations
> > #460: FILE: fs/cifs/file.c:658:
> > + struct cifs_fscache_inode_coherency_data cd;
> > + cifs_fscache_fill_coherency(file_inode(file), &cd);
>
> I have a small patch to abstract cache invalidation for cifs into a helper
> function (see attached) that I'll merge in that will also take care of this.
>
> David
> ---
> commit ff463eee039fbe119ae0d4185cb8a90aec10ec80
> Author: David Howells <dhowells@redhat.com>
> Date:   Fri Jan 7 18:08:37 2022 +0000
>
>     cifs: Abstract cache invalidation into a helper function
>
>     Abstract fscache invalidation for a cifs inode out into a helper function
>     as there will be more than one caller of it.
>
>     Signed-off-by: David Howells <dhowells@redhat.com>
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 27604eb01a94..015fd415e5ee 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -653,13 +653,9 @@ int cifs_open(struct inode *inode, struct file *file)
>                            file->f_mode & FMODE_WRITE);
>         if (file->f_flags & O_DIRECT &&
>             (!((file->f_flags & O_ACCMODE) != O_RDONLY) ||
> -            file->f_flags & O_APPEND)) {
> -               struct cifs_fscache_inode_coherency_data cd;
> -               cifs_fscache_fill_coherency(file_inode(file), &cd);
> -               fscache_invalidate(cifs_inode_cookie(file_inode(file)),
> -                                  &cd, i_size_read(file_inode(file)),
> -                                  FSCACHE_INVAL_DIO_WRITE);
> -       }
> +            file->f_flags & O_APPEND))
> +               cifs_invalidate_cache(file_inode(file),
> +                                     FSCACHE_INVAL_DIO_WRITE);
>
>  out:
>         free_dentry_path(page);
> diff --git a/fs/cifs/fscache.h b/fs/cifs/fscache.h
> index e444445d0906..b741d38df6c8 100644
> --- a/fs/cifs/fscache.h
> +++ b/fs/cifs/fscache.h
> @@ -71,6 +71,15 @@ static inline struct fscache_cookie *cifs_inode_cookie(struct inode *inode)
>         return netfs_i_cookie(inode);
>  }
>
> +static inline void cifs_invalidate_cache(struct inode *inode, unsigned int flags)
> +{
> +       struct cifs_fscache_inode_coherency_data cd;
> +
> +       cifs_fscache_fill_coherency(inode, &cd);
> +       fscache_invalidate(cifs_inode_cookie(inode), &cd,
> +                          i_size_read(inode), flags);
> +}
> +
>  static inline int cifs_readpage_from_fscache(struct inode *inode,
>                                              struct page *page)
>  {
> @@ -112,6 +121,7 @@ static inline void cifs_fscache_get_inode_cookie(struct inode *inode) {}
>  static inline void cifs_fscache_release_inode_cookie(struct inode *inode) {}
>  static inline void cifs_fscache_unuse_inode_cookie(struct inode *inode, bool update) {}
>  static inline struct fscache_cookie *cifs_inode_cookie(struct inode *inode) { return NULL; }
> +static inline void cifs_invalidate_cache(struct inode *inode, unsigned int flags) {}
>
>  static inline int
>  cifs_readpage_from_fscache(struct inode *inode, struct page *page)
>
Hi David,

Can you let us know the branch name that you're working on in your tree?
I do not see this last patch in fscache-rewrite branch. Is there
another branch we should be looking at?

-- 
Regards,
Shyam
