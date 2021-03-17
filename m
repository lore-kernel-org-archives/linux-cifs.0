Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D957C433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 11:26:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2938C64F6E
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Mar 2021 11:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhCQLZm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Mar 2021 07:25:42 -0400
Received: from p3plsmtpa06-06.prod.phx3.secureserver.net ([173.201.192.107]:44075
        "EHLO p3plsmtpa06-06.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230171AbhCQLZN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Mar 2021 07:25:13 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id MUIalRxa8EYmdMUIblBzbC; Wed, 17 Mar 2021 04:25:13 -0700
X-CMAE-Analysis: v=2.4 cv=adukITkt c=1 sm=1 tr=0 ts=6051e719
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=zilokg64RarliigfnAMA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: xfstest 614 and allocation size should not be 0
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvD4CRP_iZRNhS+809wxOj8FSc4FHbN+UVFp8+pMJcpyg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <fef5a851-6ce2-457d-ccf9-3d8a13193193@talpey.com>
Date:   Wed, 17 Mar 2021 07:25:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvD4CRP_iZRNhS+809wxOj8FSc4FHbN+UVFp8+pMJcpyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfAbNFX4/UFj7g8W46YZ2RbRvAVdhTy+HBrjcOOw1zyJGchk3zKqlS7jY/1Eaa0W59vq4dbIK1HK58qvX/aG2355iOgZa60Yjxe2XaWXKbH4Xs6KTnbzL
 VIxVsAEOUQr1AT3pCkvlvejVxPE1WKx6hmzCmtGEp2ygAx1gS3jT02G+MlG44V0G4EWYtip5D0GOYArOeSp1TCbxKIVr+YUtONSoW49Xf7qXD7q0ql2cLI4s
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/17/2021 2:10 AM, Steve French wrote:
> Was examining why xfstest 614 failed (smb3.1.1 mount to Windows), and
> noticed a couple of problems:
> 
> 1) we don't requery the allocation size (number of blocks) in all
> cases we should. This small fix should address that
> 
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2390,15 +2390,16 @@ int cifs_getattr(struct user_namespace
> *mnt_userns, const struct path *path,
>          struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>          struct inode *inode = d_inode(dentry);
>          int rc;
>          /*
>           * We need to be sure that all dirty pages are written and the server
>           * has actual ctime, mtime and file length.
>           */
> -       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE)) &&
> +       if ((request_mask & (STATX_CTIME | STATX_MTIME | STATX_SIZE |
> STATX_BLOCKS)) &&

Seems obviously enough correct.

> and 2) we don't set the allocation size on the case where a cached
> file on this client is written, and to make it worse if we queried

Also obviously the cache needs to be kept in sync, but is it accurate to
set the allocation size before writing? That's the server's field, so
shouldn't it be written, then queried?

> (post query attributes flag) at SMB3 close for compounded operations -
> the Windows server (not sure about others) apparently doesn't update
> the allocation size until the next open/queryinfo so we still end up
> with an allocation size of 0 for a 64K file which breaks the test.
> 
> What the test is doing is quite simple:
> 
> xfs_io -f -c "truncate 64K" -c "mmap -w 0 64K" -c "mwrite -S 0xab 0
> 64K" -c "munmap" foo1 ; stat -c %b foo1
> 
> And it fails - due to seeing a number of blocks 0 rather than the
> correct value (128).  With actimeo=0 we do a subsequent open/query
> operation which would cause it to pass since the second open/query
> does show the correct allocation size.
> 
> Any ideas?

What actually goes on the wire diring the test? It looks like the
munmap step should be msync'ing - does cifs.ko not write the data?

Tom.
