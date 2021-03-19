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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419BCC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 18:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 094B061952
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 18:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCSSJ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCSSI5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 14:08:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F9EC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 11:08:57 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id w37so11348140lfu.13
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 11:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0PrLCa5GtnLcfkwV4y3/dSy2w4KFR+0PPCsh1mnj1h4=;
        b=YdcHChyHwotyJEYpqi0g1uKufcD1DNmgI+8SeAqHGqaCHqMRkGPv5uLaK1/WTBm+A6
         2XEgHhPjE5JQisxJJ7j25vzwV78W8KCJelukhYkcRlYHtITCQ0yQ4CyiVBgcSG4EPGZf
         GLyYXU27jrpmXz/DQlcpp8vlsNe74nUcfxCx3VoOrXpo+WmRwKsTgKInh84/oJoyzxrp
         wKT+ahD82X22SfX9LhLvhodlPe0ZyXx6AqlhdWhUWFxZSSpTFBGRGDQ1H8v8XtIAcpud
         0bgoG7eJJ61z/hgG7ch/+slsGuZSherrQXcFK55E93wOg8U6RrFuJDjbEi6s1e++Nmc4
         oRJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0PrLCa5GtnLcfkwV4y3/dSy2w4KFR+0PPCsh1mnj1h4=;
        b=aBjGsBBP2iOfWCnHpQeM+Dc9Mi21BUvmdCcUXvKw7gXlxD/1ZIN7XUGBNapnJ0xsgn
         vLfo/C8UD9fJaN6la0m7117ag/XxyUo0LXo2f6GPWEFbDBlcuIvmKZYvEF5mZrahXaA3
         +GaO/l5t40IS1owTLWpJC6UVz2gfk930d1X7HnMfOvxAQkqWZSsSi1M+iwWm7wnHS3Zi
         8//YdqmsPrF2GHRgtjIA7Z/lc9z8sqhgJeBd6G3AUseMB5zdqnFVmTBCAG2IsHNwoNJo
         TYxw7sMCLOAMjEs1dmdQ6KLnLpuWeXLKPqQ/LZaQunq2bvVdJWD1znv1lauBlf875OdW
         r3hg==
X-Gm-Message-State: AOAM533rzOutcI3PMuxy4kh7HMWmdyFNvQxC+AGFregW+0i2LZCtnKqs
        Sy9cReRZTdZPFQDwKuLLF4GyTJ/9wIZemBy8fzY=
X-Google-Smtp-Source: ABdhPJxTMC5f3+eTyLNNCCh/ecDezciGWV6NwvjqG7jd4QpLkaOvYwXiMx3+SvGXgB1kiycJ8itP1vUQVAprmBblcGc=
X-Received: by 2002:a19:7515:: with SMTP id y21mr1556241lfe.282.1616177335965;
 Fri, 19 Mar 2021 11:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
 <750943d3-9717-fcd8-71ec-986a07e7eca0@talpey.com> <CAH2r5muawhYVa7a=TEmaDgH1t6fvubEJvaUP1-XscNq9Qjy4rw@mail.gmail.com>
 <CAH2r5muLbbyhPzjD_Uk_XPd=A4dsuf4uT8X-YjrN616g=ENDBQ@mail.gmail.com> <0537089f-edd6-1c75-8695-055f37e022f8@talpey.com>
In-Reply-To: <0537089f-edd6-1c75-8695-055f37e022f8@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 13:08:45 -0500
Message-ID: <CAH2r5mujRuk6RhoHXJk0BkqCKTY36X2BDutydzWf1zZNP=yC5Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes - the Linux terminology is confusing.  Quoting from Ubuntu docs
e.g. about stat output

           "IO Block" in stat's output is the preferred number of
           bytes that the file system uses for reading and writing files...
           "Blocks", on the other hand, counts how many 512-bytes blocks
           are allocated on disk for the file.

So for NFS and SMB3 mounts they return 1MB for "IO Block" size.

statfs on the other hand shows what the server thinks the block size
is (often 4K) but
that is a different field.

And of course number of "blocks" in stat output is meant to return
allocation size
(in 512 byte units for historical reasons, even if most file systems
don't use 512
byte blocks anymore)


On Fri, Mar 19, 2021 at 12:52 PM Tom Talpey <tom@talpey.com> wrote:
>
> But it's not the block size here, it's the cluster size. Block
> size is the per-io hunk, allocation size is the number of blocks
> lined up to receive it.
>
> Perhaps the safest number is the file size itself, unrounded.
>
> On 3/19/2021 1:46 PM, Steve French wrote:
> > e.g. stat reports much larger than 512 byte block size over SMB3
> >
> > # stat /mnt2/foo
> >    File: /mnt2/foo
> >    Size: 65536      Blocks: 128        IO Block: 1048576 regular file
> > Device: 34h/52d Inode: 88946092640651991  Links: 1
> >
> > and local file systems do the same ie "blocks" is unrelated to block size
> > the fs reports.  Here is an example to XFS locally
> >
> > # stat Makefile
> >    File: Makefile
> >    Size: 66247      Blocks: 136        IO Block: 4096   regular file
> > Device: 10302h/66306d Inode: 1076242180  Links: 1
> >
> > On Fri, Mar 19, 2021 at 12:42 PM Steve French <smfrench@gmail.com> wrote:
> >>
> >> We report the block size properly (typically much larger) - but the
> >> kernel API returns allocation size in 512 byte units no matter what the
> >> block size is.   Number of blocks returned for the kernel API
> >>       inode->i_blocks
> >> is unrelated to the block size (simply allocation_size/512 rounded up by 1).
> >>
> >> On Fri, Mar 19, 2021 at 12:38 PM Tom Talpey <tom@talpey.com> wrote:
> >>>
> >>> On 3/19/2021 1:25 AM, Steve French wrote:
> >>>> Applications that create and extend and write to a file do not
> >>>> expect to see 0 allocation size.  When file is extended,
> >>>> set its allocation size to a plausible value until we have a
> >>>> chance to query the server for it.  When the file is cached
> >>>> this will prevent showing an impossible number of allocated
> >>>> blocks (like 0).  This fixes e.g. xfstests 614 which does
> >>>>
> >>>>       1) create a file and set its size to 64K
> >>>>       2) mmap write 64K to the file
> >>>>       3) stat -c %b for the file (to query the number of allocated blocks)
> >>>>
> >>>> It was failing because we returned 0 blocks.  Even though we would
> >>>> return the correct cached file size, we returned an impossible
> >>>> allocation size.
> >>>>
> >>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> >>>> CC: <stable@vger.kernel.org>
> >>>> ---
> >>>>    fs/cifs/inode.c | 12 ++++++++++--
> >>>>    1 file changed, 10 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >>>> index 7c61bc9573c0..17a2c87b811c 100644
> >>>> --- a/fs/cifs/inode.c
> >>>> +++ b/fs/cifs/inode.c
> >>>> @@ -2395,7 +2395,7 @@ int cifs_getattr(struct user_namespace
> >>>> *mnt_userns, const struct path *path,
> >>>>     * We need to be sure that all dirty pages are written and the server
> >>>>     * has actual ctime, mtime and file length.
> >>>>     */
> >>>> - if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
> >>>> + if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> >>>> STATX_BLOCKS)) &&
> >>>>         !CIFS_CACHE_READ(CIFS_I(inode)) &&
> >>>>         inode->i_mapping && inode->i_mapping->nrpages != 0) {
> >>>>     rc = filemap_fdatawait(inode->i_mapping);
> >>>> @@ -2585,6 +2585,14 @@ cifs_set_file_size(struct inode *inode, struct
> >>>> iattr *attrs,
> >>>>     if (rc == 0) {
> >>>>     cifsInode->server_eof = attrs->ia_size;
> >>>>     cifs_setsize(inode, attrs->ia_size);
> >>>> + /*
> >>>> + * i_blocks is not related to (i_size / i_blksize),
> >>>> + * but instead 512 byte (2**9) size is required for
> >>>> + * calculating num blocks. Until we can query the
> >>>> + * server for actual allocation size, this is best estimate
> >>>> + * we have for the blocks allocated for this file
> >>>> + */
> >>>> + inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
> >>>
> >>> I don't think 512 is a very robust choice, no server uses anything
> >>> so small any more. MS-FSA requires the allocation quantum to be the
> >>> volume cluster size. Is that value available locally?
> >>>
> >>> Tom.
> >>>
> >>>>     /*
> >>>>     * The man page of truncate says if the size changed,
> >>>> @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
> >>>> struct iattr *attrs)
> >>>>     sys_utimes in which case we ought to fail the call back to
> >>>>     the user when the server rejects the call */
> >>>>     if ((rc) && (attrs->ia_valid &
> >>>> - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> >>>> +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> >>>>     rc = 0;
> >>>>     }
> >>>>
> >>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >



--
Thanks,

Steve
