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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3175C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 18:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 884836194C
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 18:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCSStN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 14:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCSStH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Mar 2021 14:49:07 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF7EC06174A
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 11:49:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id o126so2032801lfa.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Mar 2021 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3qt5YbNKbHS2c2l3xh7sL7UsRmdCKIRfyB+qQfZY+Gw=;
        b=X1QMqNGN4G/vddcAPMqZavTZPQTJjMabm3jNVd9FEJ/cIPAdqyYGQmgGxgeRswCUjr
         Bh0wYOTsCF2V4sLfh3WHZ50mNXuQSXLOQJRSm9CRR7AW7eveFa2P8S3Ma5xETzJ4367/
         hTm1BDgvX/MXQDQQYQdpXPoEnJH/ttGsAythFtUznqc4NM8tI7UgA1hs5dvwl5z37t3h
         cUKPYhBV/stZN8HIACXBEyPJZt4p6KnMbRvDMLe2I52z2Fd2RDBJiYY3Pj0vM2kSUFv5
         sJ2ihfGnhNWm7mce5TW95bOSu3z84fTgsIAiZTrUrOkJ5SwHLO1AE3PEdhbvpI0+BgDG
         Rcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3qt5YbNKbHS2c2l3xh7sL7UsRmdCKIRfyB+qQfZY+Gw=;
        b=l7K1fyA0XsvSsEYEFWxxsBOSRo6uAid6Hxvclr/QrlNzqd9aYB2fIL2Vdb0oEHTw9b
         lbEtoAfrTpO0qAew6pdVYBLAiuDHgKhWlUU7mQrLwveQjNYNd07DtcuvIxtvuf+Q/LEj
         rh2XKMSpYKIFP8TICr2RmashTZvgMKs8GwwuH8XSSGbEe4Th7aoUrv/xo+mwzidKLOVm
         XJOAdXtvk1Nhx3ZSUmw85Bb2eHJO7/6GZYCUzEYeLw+u/82VzLacUlL0RNB9jg7rC5O8
         B4QYA1d2gktSrsRhJdSAmB8JnL1YtV8gQlAm4z5z97H2Y/i8FUYL3Rm+urJ9rEEJmygc
         wLBQ==
X-Gm-Message-State: AOAM53384K7sabrAnySPHAinZxkuNKIoxfl47K7jFxesnp2nwYW11qbd
        4XgvigIdbC3xXy3pDihxxAG3pDLxZLId2uk6d5a0KM0j9T0=
X-Google-Smtp-Source: ABdhPJzJcC2zy9DCcDBp6BV45z/PgKy6zuUocUbx1QuqwncDeOivL/FcUHHF6/PLlHNDngdVW2DZq8lgIUjOk8sa0v4=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr1665018lfd.175.1616179745206;
 Fri, 19 Mar 2021 11:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
 <750943d3-9717-fcd8-71ec-986a07e7eca0@talpey.com> <CAH2r5muawhYVa7a=TEmaDgH1t6fvubEJvaUP1-XscNq9Qjy4rw@mail.gmail.com>
 <CAH2r5muLbbyhPzjD_Uk_XPd=A4dsuf4uT8X-YjrN616g=ENDBQ@mail.gmail.com>
 <0537089f-edd6-1c75-8695-055f37e022f8@talpey.com> <CAH2r5mujRuk6RhoHXJk0BkqCKTY36X2BDutydzWf1zZNP=yC5Q@mail.gmail.com>
 <a4bbf093-39b7-e724-b835-d5ebc2e82d04@talpey.com> <CAH2r5mu2S1DbfQCqgzx-edZN8qWSpD20xVDoC05ZEs4LeOaYgg@mail.gmail.com>
In-Reply-To: <CAH2r5mu2S1DbfQCqgzx-edZN8qWSpD20xVDoC05ZEs4LeOaYgg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 19 Mar 2021 13:48:54 -0500
Message-ID: <CAH2r5mvJ2AtLuMaWDA1pt664gTSsJ5F2OjnNVU+EtS3rw4tVcw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

(ie even if there is a Windows bug on close with delayed updates to
allocation size)

On Fri, Mar 19, 2021 at 1:48 PM Steve French <smfrench@gmail.com> wrote:
>
> Well ... it is a little complicated to query it on close in the
> current cifs.ko compounding code and allocation size can change on the
> server so returning a 'plausible' allocation size rather than an
> impossible one is progress.
>
> On Fri, Mar 19, 2021 at 1:26 PM Tom Talpey <tom@talpey.com> wrote:
> >
> > Hrm. I am still uneasy about making up a number. It could break
> > an application. And the issue isn't even in the client!
> >
> > Did you ping Neal, or contact dochelp about the Windows server
> > behavior? I'd be happy to but I don't have any context, including
> > which filesystem is doing this.
> >
> > On 3/19/2021 2:08 PM, Steve French wrote:
> > > Yes - the Linux terminology is confusing.  Quoting from Ubuntu docs
> > > e.g. about stat output
> > >
> > >             "IO Block" in stat's output is the preferred number of
> > >             bytes that the file system uses for reading and writing files...
> > >             "Blocks", on the other hand, counts how many 512-bytes blocks
> > >             are allocated on disk for the file.
> > >
> > > So for NFS and SMB3 mounts they return 1MB for "IO Block" size.
> > >
> > > statfs on the other hand shows what the server thinks the block size
> > > is (often 4K) but
> > > that is a different field.
> > >
> > > And of course number of "blocks" in stat output is meant to return
> > > allocation size
> > > (in 512 byte units for historical reasons, even if most file systems
> > > don't use 512
> > > byte blocks anymore)
> > >
> > >
> > > On Fri, Mar 19, 2021 at 12:52 PM Tom Talpey <tom@talpey.com> wrote:
> > >>
> > >> But it's not the block size here, it's the cluster size. Block
> > >> size is the per-io hunk, allocation size is the number of blocks
> > >> lined up to receive it.
> > >>
> > >> Perhaps the safest number is the file size itself, unrounded.
> > >>
> > >> On 3/19/2021 1:46 PM, Steve French wrote:
> > >>> e.g. stat reports much larger than 512 byte block size over SMB3
> > >>>
> > >>> # stat /mnt2/foo
> > >>>     File: /mnt2/foo
> > >>>     Size: 65536      Blocks: 128        IO Block: 1048576 regular file
> > >>> Device: 34h/52d Inode: 88946092640651991  Links: 1
> > >>>
> > >>> and local file systems do the same ie "blocks" is unrelated to block size
> > >>> the fs reports.  Here is an example to XFS locally
> > >>>
> > >>> # stat Makefile
> > >>>     File: Makefile
> > >>>     Size: 66247      Blocks: 136        IO Block: 4096   regular file
> > >>> Device: 10302h/66306d Inode: 1076242180  Links: 1
> > >>>
> > >>> On Fri, Mar 19, 2021 at 12:42 PM Steve French <smfrench@gmail.com> wrote:
> > >>>>
> > >>>> We report the block size properly (typically much larger) - but the
> > >>>> kernel API returns allocation size in 512 byte units no matter what the
> > >>>> block size is.   Number of blocks returned for the kernel API
> > >>>>        inode->i_blocks
> > >>>> is unrelated to the block size (simply allocation_size/512 rounded up by 1).
> > >>>>
> > >>>> On Fri, Mar 19, 2021 at 12:38 PM Tom Talpey <tom@talpey.com> wrote:
> > >>>>>
> > >>>>> On 3/19/2021 1:25 AM, Steve French wrote:
> > >>>>>> Applications that create and extend and write to a file do not
> > >>>>>> expect to see 0 allocation size.  When file is extended,
> > >>>>>> set its allocation size to a plausible value until we have a
> > >>>>>> chance to query the server for it.  When the file is cached
> > >>>>>> this will prevent showing an impossible number of allocated
> > >>>>>> blocks (like 0).  This fixes e.g. xfstests 614 which does
> > >>>>>>
> > >>>>>>        1) create a file and set its size to 64K
> > >>>>>>        2) mmap write 64K to the file
> > >>>>>>        3) stat -c %b for the file (to query the number of allocated blocks)
> > >>>>>>
> > >>>>>> It was failing because we returned 0 blocks.  Even though we would
> > >>>>>> return the correct cached file size, we returned an impossible
> > >>>>>> allocation size.
> > >>>>>>
> > >>>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
> > >>>>>> CC: <stable@vger.kernel.org>
> > >>>>>> ---
> > >>>>>>     fs/cifs/inode.c | 12 ++++++++++--
> > >>>>>>     1 file changed, 10 insertions(+), 2 deletions(-)
> > >>>>>>
> > >>>>>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > >>>>>> index 7c61bc9573c0..17a2c87b811c 100644
> > >>>>>> --- a/fs/cifs/inode.c
> > >>>>>> +++ b/fs/cifs/inode.c
> > >>>>>> @@ -2395,7 +2395,7 @@ int cifs_getattr(struct user_namespace
> > >>>>>> *mnt_userns, const struct path *path,
> > >>>>>>      * We need to be sure that all dirty pages are written and the server
> > >>>>>>      * has actual ctime, mtime and file length.
> > >>>>>>      */
> > >>>>>> - if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
> > >>>>>> + if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> > >>>>>> STATX_BLOCKS)) &&
> > >>>>>>          !CIFS_CACHE_READ(CIFS_I(inode)) &&
> > >>>>>>          inode->i_mapping && inode->i_mapping->nrpages != 0) {
> > >>>>>>      rc = filemap_fdatawait(inode->i_mapping);
> > >>>>>> @@ -2585,6 +2585,14 @@ cifs_set_file_size(struct inode *inode, struct
> > >>>>>> iattr *attrs,
> > >>>>>>      if (rc == 0) {
> > >>>>>>      cifsInode->server_eof = attrs->ia_size;
> > >>>>>>      cifs_setsize(inode, attrs->ia_size);
> > >>>>>> + /*
> > >>>>>> + * i_blocks is not related to (i_size / i_blksize),
> > >>>>>> + * but instead 512 byte (2**9) size is required for
> > >>>>>> + * calculating num blocks. Until we can query the
> > >>>>>> + * server for actual allocation size, this is best estimate
> > >>>>>> + * we have for the blocks allocated for this file
> > >>>>>> + */
> > >>>>>> + inode->i_blocks = (512 - 1 + attrs->ia_size) >> 9;
> > >>>>>
> > >>>>> I don't think 512 is a very robust choice, no server uses anything
> > >>>>> so small any more. MS-FSA requires the allocation quantum to be the
> > >>>>> volume cluster size. Is that value available locally?
> > >>>>>
> > >>>>> Tom.
> > >>>>>
> > >>>>>>      /*
> > >>>>>>      * The man page of truncate says if the size changed,
> > >>>>>> @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
> > >>>>>> struct iattr *attrs)
> > >>>>>>      sys_utimes in which case we ought to fail the call back to
> > >>>>>>      the user when the server rejects the call */
> > >>>>>>      if ((rc) && (attrs->ia_valid &
> > >>>>>> - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> > >>>>>> +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> > >>>>>>      rc = 0;
> > >>>>>>      }
> > >>>>>>
> > >>>>
> > >>>>
> > >>>>
> > >>>> --
> > >>>> Thanks,
> > >>>>
> > >>>> Steve
> > >>>
> > >>>
> > >>>
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
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
