Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37E1C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 13 Jan 2022 17:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiAMRnj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 13 Jan 2022 12:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiAMRni (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 13 Jan 2022 12:43:38 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E15CC061574
        for <linux-cifs@vger.kernel.org>; Thu, 13 Jan 2022 09:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-ID:Cc:To:From:Date;
        bh=AX+apUDBrxobioPT77OGxzifvo+Bt2Sj6om9k9Xxl0s=; b=TJl6A/qtoPvVJsNpAfh6C0D4dW
        sOyUyR3I6IcTnvhGL4oBARDDe7WKqYYeP91biqm6wadMe5AaPxr0KfZmdO6u4+hqjV8B5zLkR96HP
        bCfSILn486lOqndtsGPjgp7BJOpWzLcOp/VwM+lQUF8R/LmkpWPcWA2X5yswUqktqgc8F0mjSfEHi
        OSCJYfq7mrQy5NkHuBXoP/i3eyijyjiGPI9zNAtHY6WFMIzgAOWyqe4haGyZIh1lErUZhYW92vi3i
        +h6EGfSK7qd5yycBtw5KoZo5+C1F/X6gKZhxWqjglsfYlxmxTMx9wGu4zI0YhRV666xcSjgjyOxc6
        bK0hI0+dY9YFlTxIWbmqpf484Jx3eJl+1CrvMLllqNoAhxKmoQoD0ZMrVzm13uhCel/6Xaon45qyG
        zVhx9RRjX/4ZRBS5HGF6wnQrxsmNtVN96OQobKlb3pSLI26xGrY0Fm8JqLz4EQ7IkrWJPf61vnHXJ
        JQmxemLuhCWVfpz75ASUPtNj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1n848N-0078QB-4G; Thu, 13 Jan 2022 17:43:35 +0000
Date:   Thu, 13 Jan 2022 09:43:32 -0800
From:   Jeremy Allison <jra@samba.org>
To:     David Howells <dhowells@redhat.com>
Cc:     smfrench@gmail.com, Shyam Prasad N <nspmangalore@gmail.com>,
        jlayton@kernel.org, linux-cifs@vger.kernel.org
Subject: Re: Incorrect fallocate behaviour in cifs or samba?
Message-ID: <YeBkxLnh8+sUv968@jeremy-acer>
Reply-To: Jeremy Allison <jra@samba.org>
References: <1828480.1642079920@warthog.procyon.org.uk>
 <1856457.1642087232@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1856457.1642087232@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jan 13, 2022 at 03:20:32PM +0000, David Howells wrote:
>David Howells <dhowells@redhat.com> wrote:
>
>> If I do the following:
>>
>> 	mount //carina/test /xfstest.test -o user=shares,pass=foobar,noperm,vers=3.0,mfsymlinks,actimeo=0
>> 	/usr/sbin/xfs_io -f -t \
>> 		-c "pwrite -S 0x41 0 4096"
>> 		-c "pwrite -S 0x42 4096 4096"
>> 		-c "fzero 0 4096" \
>> 		-c "pread 0 8192" \
>> 		/xfstest.test/008.7067
>> ...
>>    31 0.321638749  192.168.6.2 -> 192.168.6.1  SMB2 206 Ioctl Request FSCTL_SET_ZERO_DATA File: 008.7067
>
>So what I see is that Samba does:
>
>	fallocate(24, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 0, 4096) = 0
>
>for this... but that's not what cifs was asked to do.  Should Samba be using
>FALLOC_FL_ZERO_RANGE instead?

This is from fsctl_zero_data() in Samba. We have:

         /*
          * MS-FSCC <58> Section 2.3.67
          * This FSCTL sets the range of bytes to zero (0) without extending the
          * file size.
          *
          * The VFS_FALLOCATE_FL_KEEP_SIZE flag is used to satisfy this
          * constraint.
          */

         mode = VFS_FALLOCATE_FL_PUNCH_HOLE | VFS_FALLOCATE_FL_KEEP_SIZE;
         ret = SMB_VFS_FALLOCATE(fsp, mode, zdata_info.file_off, len);
         if (ret == -1)  {
                 status = map_nt_error_from_unix_common(errno);
                 DEBUG(2, ("zero-data fallocate(0x%x) failed: %s\n", mode,
                       strerror(errno)));
                 return status;
         }

         if (!fsp->fsp_flags.is_sparse && lp_strict_allocate(SNUM(fsp->conn))) {
                 /*
                  * File marked non-sparse and "strict allocate" is enabled -
                  * allocate the range that we just punched out.
                  * In future FALLOC_FL_ZERO_RANGE could be used exclusively for
                  * this, but it's currently only supported on XFS and ext4.
                  *
                  * The newly allocated range still won't be found by SEEK_DATA
                  * for QAR, but stat.st_blocks will reflect it.
                  */
                 ret = SMB_VFS_FALLOCATE(fsp, VFS_FALLOCATE_FL_KEEP_SIZE,
                                         zdata_info.file_off, len);

Note the "currently only supported on XFS and ext4" problem
with FALLOC_FL_ZERO_RANGE.
