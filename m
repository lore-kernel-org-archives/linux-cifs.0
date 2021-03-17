Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C7BC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 12:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C96464F41
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 12:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhCQMSZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhCQMSX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Mar 2021 08:18:23 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D3FC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 17 Mar 2021 05:18:22 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id f26so2841068ljp.8
        for <linux-cifs@vger.kernel.org>; Wed, 17 Mar 2021 05:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n39fsVpscC9Cd2XEvqKUaY41gLMIVPcbNQTwUzBusFU=;
        b=Ee77Z1o/KXyQldEb0iIaoURNYMZbXHdQmz3wV0haPfKmiAJPcJdLAIO7b22lcuoLZ+
         Pa4RsLztaAph5VggRmGbz+AaT+NvQAk4s1r/23MWyptKkE9WenkY+3LEamUUbFkAkh23
         lXYZSpWp+3RBEYxCe9rDBYHiDEhtTh5Px1tYQwvkNTfv0Yl38TD2JF1jJbgPzKuE0Mbh
         /cstpB4KlJ6FDMwNfHfpQlPVxO0A+/tUWS1HXriLAegVepwPWEe7H67IuuSAf8bOcjB/
         hFoELaYvyxKPwSPC33N0GXvTpqZw0QSRdHOc8NqwAOW+g0T3Q59V5MuNQclkesGtDBGn
         1dmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n39fsVpscC9Cd2XEvqKUaY41gLMIVPcbNQTwUzBusFU=;
        b=VHjZAYKqD3w9DZK+OJRsWZiybNYPp+Rz96FG8Yucz/KKEEMNb5TZAOox+QpBMCPwsR
         gZn6irFdlDmxy702KewZY7w6GTQcypjra7wlSFEy5BAUf7VTFt5sLy4SKr1eASoeTMY+
         7nIAe2eqreBXP34Nhzc2xi9ndNlpXV7UTnQ/UvJE2XR5SIMOY/v2airY+Oyp0Hi9431T
         HEolv+nT2I97Lc9Sr/8bOW5/fRRuRYwZEvHGsWkhwAnENio+2Hn/JbV0byLwRkNUQPtC
         n0Ma5YrKlmTgR/rY81tgr9OzQ67i8oBUCtwjVGfJKQp2aBihovPB+WoeuOTVazu9JKXm
         RrXg==
X-Gm-Message-State: AOAM530Q1Bn+GtXl3QTW6x3b8dHtHQ3SmYzBG2JxuXvh1YZO9knuuMlk
        7SdKGU2CR/MQHP2KHOGP6BVzI6kfNBOUykLvzIdxS4ODHKs=
X-Google-Smtp-Source: ABdhPJxSmTMKF42Gm4Ygv7yF5RXUZlI9h3n8oLkYx9jCA8mVvCKnOp0CbRxx55VOhxXzB+Qg/5AgWWkm2o0ch39tOlw=
X-Received: by 2002:a2e:8503:: with SMTP id j3mr2270904lji.272.1615983501246;
 Wed, 17 Mar 2021 05:18:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvD4CRP_iZRNhS+809wxOj8FSc4FHbN+UVFp8+pMJcpyg@mail.gmail.com>
 <fef5a851-6ce2-457d-ccf9-3d8a13193193@talpey.com>
In-Reply-To: <fef5a851-6ce2-457d-ccf9-3d8a13193193@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Mar 2021 07:18:10 -0500
Message-ID: <CAH2r5mu97zZ_PXMAxyqFrNVEXv2Y=3cp0MkJSHR0ATXeFWzQsw@mail.gmail.com>
Subject: Re: xfstest 614 and allocation size should not be 0
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 17, 2021 at 6:25 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 3/17/2021 2:10 AM, Steve French wrote:
> > Was examining why xfstest 614 failed (smb3.1.1 mount to Windows), and
> > noticed a couple of problems:
> >
> > 1) we don't requery the allocation size (number of blocks) in all
> > cases we should. This small fix should address that
> >
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2390,15 +2390,16 @@ int cifs_getattr(struct user_namespace
> > *mnt_userns, const struct path *path,
> >          struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> >          struct inode *inode = d_inode(dentry);
> >          int rc;
> >          /*
> >           * We need to be sure that all dirty pages are written and the server
> >           * has actual ctime, mtime and file length.
> >           */
> > -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
> > +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> > STATX_BLOCKS)) &&
>
> Seems obviously enough correct.
>
> > and 2) we don't set the allocation size on the case where a cached
> > file on this client is written, and to make it worse if we queried
>
> Also obviously the cache needs to be kept in sync, but is it accurate to
> set the allocation size before writing? That's the server's field, so
> shouldn't it be written, then queried?
>
> > (post query attributes flag) at SMB3 close for compounded operations -
> > the Windows server (not sure about others) apparently doesn't update
> > the allocation size until the next open/queryinfo so we still end up
> > with an allocation size of 0 for a 64K file which breaks the test.
> >
> > What the test is doing is quite simple:
> >
> > xfs_io -f -c "truncate 64K" -c "mmap -w 0 64K" -c "mwrite -S 0xab 0
> > 64K" -c "munmap" foo1 ; stat -c %b foo1
> >
> > And it fails - due to seeing a number of blocks 0 rather than the
> > correct value (128).  With actimeo=0 we do a subsequent open/query
> > operation which would cause it to pass since the second open/query
> > does show the correct allocation size.
> >
> > Any ideas?
>
> What actually goes on the wire diring the test? It looks like the
> munmap step should be msync'ing - does cifs.ko not write the data?

Oddly enough this works to Azure but not Windows. What we see
on the wire is simple enough:

1) create/getinfo foo1 --> file not found
2) create foo1
3) oplock break of root's cached handle
4) close root handle
6) open of root/getinfo("FileFsFullSizeInformation")/Close
6) Flush foo1
7) ioctl set sparse foo1
8) setinfo FILE_ENDOFFILE_INFO foo1
9) create/setinfo(FILE_BASIC_INFO)/close of foo1
10) read 64K foo1 (all zeros)
11) write 64K foo1
12) close foo1   (post query attributes of close show size 64K,
allocation size 0  ---> should be allocation size 64K)

But it works to Azure ...


-- 
Thanks,

Steve
