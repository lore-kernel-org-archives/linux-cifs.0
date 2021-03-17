Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C9CC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 06:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F1F64FA8
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 06:11:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQGKt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 02:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhCQGK3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Mar 2021 02:10:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3BAC06174A
        for <linux-cifs@vger.kernel.org>; Tue, 16 Mar 2021 23:10:28 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 18so1222148lff.6
        for <linux-cifs@vger.kernel.org>; Tue, 16 Mar 2021 23:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Gwc9BQwopLJ0/1LEGxqJss4hU7H3GU/zaFpZKQA/qeA=;
        b=PlsP04+3ohSJU5aHJdGiTaHAT3ZaFiVO5mtEwFfbjMBuPAc6N4slG+WemBND2KmU/L
         OB0TlBLILFQ4BnqfV/brf01u4GJA1P/Y5dAj++FluZJExyB2pXG3Jd7w6ahKW5sQ9Auh
         +FVxAdHn8C7wGHbAuqXobVh/VJ9YzXmmnJOgk6pEYFlDuy0oCx5frmzeHc/yga1AyUgg
         TNLCFhP4qZxw7D97QPHa8xePR7/UXI3lVBwTNt64ANV8D9k4rpPthATOMf58QeYCR2zd
         XIBw8FdMJwX7egMdZNKvX/0fZCyvXH0bya8c820UNXBSKJM1BQQ0t+ey4wscFpLc+hnU
         TRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Gwc9BQwopLJ0/1LEGxqJss4hU7H3GU/zaFpZKQA/qeA=;
        b=uN9xLJJX8hnBQGSpjTKru3xkujALIqUxUidePK45GDGUYxeW6aWqRLyHb/rfKEWddj
         kBSd0SrjTdNmfoMGIJbi8rc3RsBJqXWKrN6t2c5oVdBaBEd/bZhKJLkuj2rf10yMPzzd
         W9Z5ke+eRWAqhI38dVJotmVRExjeiMsZjTAT8xiuKSbmdq4qgszViFulkWV075tcF5AR
         wdRCcJa8PUTKLCEnbBWAGIf8RClislN5OxqRdVdcI+RoZ7W1Z+ThUG6EtGyc0ssGMAYb
         uZL+8x2iKVxaDWTw5CTMYmUvNKoa0U7bvKZzhsR4YYXJkyh4+xvddvxPqR1LUDe/W5p2
         Kitw==
X-Gm-Message-State: AOAM532HBdSTRcOE7hjdkPm+iud8IZD+MYiAJ67LAdfrzVheZxsW9N3R
        6llSoJx6aR0dZqRkOSJAqUucyBWskJOfPvtgcQQTsWpafhXqUw==
X-Google-Smtp-Source: ABdhPJzXDP9lpko8oGNpGbL6yC4L2PQlXnX58FSlmGwb7NcOEy21wRrJIohOdXw8ci//6ugIqpmTGlDA3+0TlMgPJg4=
X-Received: by 2002:a19:7515:: with SMTP id y21mr1450281lfe.282.1615961427028;
 Tue, 16 Mar 2021 23:10:27 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Mar 2021 01:10:16 -0500
Message-ID: <CAH2r5mvD4CRP_iZRNhS+809wxOj8FSc4FHbN+UVFp8+pMJcpyg@mail.gmail.com>
Subject: xfstest 614 and allocation size should not be 0
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Was examining why xfstest 614 failed (smb3.1.1 mount to Windows), and
noticed a couple of problems:

1) we don't requery the allocation size (number of blocks) in all
cases we should. This small fix should address that

--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2390,15 +2390,16 @@ int cifs_getattr(struct user_namespace
*mnt_userns, const struct path *path,
        struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
        struct inode *inode = d_inode(dentry);
        int rc;
        /*
         * We need to be sure that all dirty pages are written and the server
         * has actual ctime, mtime and file length.
         */
-       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
+       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
STATX_BLOCKS)) &&


and 2) we don't set the allocation size on the case where a cached
file on this client is written, and to make it worse if we queried
(post query attributes flag) at SMB3 close for compounded operations -
the Windows server (not sure about others) apparently doesn't update
the allocation size until the next open/queryinfo so we still end up
with an allocation size of 0 for a 64K file which breaks the test.

What the test is doing is quite simple:

xfs_io -f -c "truncate 64K" -c "mmap -w 0 64K" -c "mwrite -S 0xab 0
64K" -c "munmap" foo1 ; stat -c %b foo1

And it fails - due to seeing a number of blocks 0 rather than the
correct value (128).  With actimeo=0 we do a subsequent open/query
operation which would cause it to pass since the second open/query
does show the correct allocation size.

Any ideas?

-- 
Thanks,

Steve
