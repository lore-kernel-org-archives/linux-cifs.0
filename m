Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A92C43217
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Apr 2022 23:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiDEXUA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Apr 2022 19:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455337AbiDEP7z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Apr 2022 11:59:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F624131A
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 08:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 779BEB81E52
        for <linux-cifs@vger.kernel.org>; Tue,  5 Apr 2022 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870C3C385A0;
        Tue,  5 Apr 2022 15:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649171694;
        bh=TB8EjLkGSdcHt+1J8kRxrkSq1sFSEjEB9nj9jncyKq8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EM7+7ObZZgyrGLLPzuVCd5dXgdOvNWFo7C8wdkm17uh5x+OE7E8NAw0Fm8y71fB6C
         qY/9sCcZxo3rqIyS6tHAv2vrzC3jP8tjrNaiLim6jkCY2i5tWaWiZH8VcLPCknAqES
         s0xLSMSHPyfvZ/yK21dJQjokIOZvR/1itbRDjkoBVVfH37bYyQqile9MMhdWXcud6A
         +0vVTvaE5hSHKX0L9AIC3jVYTyJHMUYpETXswOiHzmaQFwjHPG6TyjOZ6oUm3MBxDC
         j9Q/gn6+c1a7vQ658aOF6c8+6y+2SOOEbCCe1E+c7lmBFUuTLhVFkM3zynaS/j3xic
         qR6x8/UAi6g9g==
Message-ID: <db91644d8ffda763fe19d4f47466a3bd4a0f3b55.camel@kernel.org>
Subject: Re: [PATCH v2] cachefiles: Fix KASAN slab-out-of-bounds in
 cachefiles_set_volume_xattr
From:   Jeff Layton <jlayton@kernel.org>
To:     Dave Wysochanski <dwysocha@redhat.com>, dhowells@redhat.com
Cc:     linux-cachefs@redhat.com, smfrench@gmail.com,
        linux-cifs@vger.kernel.org
Date:   Tue, 05 Apr 2022 11:14:52 -0400
In-Reply-To: <20220405142810.8208-1-dwysocha@redhat.com>
References: <20220405142810.8208-1-dwysocha@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2022-04-05 at 10:28 -0400, Dave Wysochanski wrote:
> Use the actual length of volume coherency data when setting the
> xattr to avoid the following KASAN report.
> 
>  BUG: KASAN: slab-out-of-bounds in cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
>  Write of size 4 at addr ffff888101e02af4 by task kworker/6:0/1347
> 
>  CPU: 6 PID: 1347 Comm: kworker/6:0 Kdump: loaded Not tainted 5.18.0-rc1-nfs-fscache-netfs+ #13
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-4.fc34 04/01/2014
>  Workqueue: events fscache_create_volume_work [fscache]
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x45/0x5a
>   print_report.cold+0x5e/0x5db
>   ? __lock_text_start+0x8/0x8
>   ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
>   kasan_report+0xab/0x120
>   ? cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
>   kasan_check_range+0xf5/0x1d0
>   memcpy+0x39/0x60
>   cachefiles_set_volume_xattr+0xa0/0x350 [cachefiles]
>   cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
>   ? __cachefiles_free_volume+0x90/0x90 [cachefiles]
>   fscache_create_volume_work+0x68/0x160 [fscache]
>   process_one_work+0x3b7/0x6a0
>   worker_thread+0x2c4/0x650
>   ? process_one_work+0x6a0/0x6a0
>   kthread+0x16c/0x1a0
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x22/0x30
>   </TASK>
> 
>  Allocated by task 1347:
>   kasan_save_stack+0x1e/0x40
>   __kasan_kmalloc+0x81/0xa0
>   cachefiles_set_volume_xattr+0x76/0x350 [cachefiles]
>   cachefiles_acquire_volume+0x2be/0x500 [cachefiles]
>   fscache_create_volume_work+0x68/0x160 [fscache]
>   process_one_work+0x3b7/0x6a0
>   worker_thread+0x2c4/0x650
>   kthread+0x16c/0x1a0
>   ret_from_fork+0x22/0x30
> 
>  The buggy address belongs to the object at ffff888101e02af0
>  which belongs to the cache kmalloc-8 of size 8
>  The buggy address is located 4 bytes inside of
>  8-byte region [ffff888101e02af0, ffff888101e02af8)
> 
>  The buggy address belongs to the physical page:
>  page:00000000a2292d70 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101e02
>  flags: 0x17ffffc0000200(slab|node=0|zone=2|lastcpupid=0x1fffff)
>  raw: 0017ffffc0000200 0000000000000000 dead000000000001 ffff888100042280
>  raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
>  page dumped because: kasan: bad access detected
> 
>  Memory state around the buggy address:
>  ffff888101e02980: fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc
>  ffff888101e02a00: 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00
>  >ffff888101e02a80: fc fc fc fc 00 fc fc fc fc 00 fc fc fc fc 04 fc
>                                                             ^
>  ffff888101e02b00: fc fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc
>  ffff888101e02b80: fc fc 00 fc fc fc fc 00 fc fc fc fc 00 fc fc fc
>  ==================================================================
> 
> Fixes: 413a4a6b0b55 "cachefiles: Fix volume coherency attribute"
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> ---
>  fs/cachefiles/xattr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
> index 35465109d9c4..f13b642c1d14 100644
> --- a/fs/cachefiles/xattr.c
> +++ b/fs/cachefiles/xattr.c
> @@ -198,8 +198,7 @@ bool cachefiles_set_volume_xattr(struct cachefiles_volume *volume)
>  
>  	_enter("%x,#%d", volume->vcookie->debug_id, len);
>  
> -	len += sizeof(*buf);
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = kmalloc(sizeof(*buf) + len, GFP_KERNEL);
>  	if (!buf)
>  		return false;
>  	buf->reserved = cpu_to_be32(0);

I hit this bug earlier today too.

Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
