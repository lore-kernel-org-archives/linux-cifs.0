Return-Path: <SRS0=r70z=SI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA57C10F06
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 06:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B156F21855
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Apr 2019 06:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbfDFGpJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Apr 2019 02:45:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55466 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfDFGpI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 6 Apr 2019 02:45:08 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AC0C883CC1C7FEF17790;
        Sat,  6 Apr 2019 14:45:06 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.120) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.408.0; Sat, 6 Apr 2019
 14:45:02 +0800
Subject: Re: [PATCH] cifs: Fix lease buffer length error
To:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>,
        <samba-technical@lists.samba.org>
References: <1554531283-134413-1-git-send-email-zhangxiaoxu5@huawei.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Message-ID: <b0053fdd-4f61-9316-a924-c0b6c38f4115@huawei.com>
Date:   Sat, 6 Apr 2019 14:44:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <1554531283-134413-1-git-send-email-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.120]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There are some misspellings in the description,
I will send v2 later.

On 4/6/2019 2:14 PM, ZhangXiaoxu wrote:
> There is a KASAN slab-out-of-bounds:
> BUG: KASAN: slab-out-of-bounds in _copy_from_iter_full+0x783/0xaa0
> Read of size 80 at addr ffff88810c35e180 by task mount.cifs/539
> 
> CPU: 1 PID: 539 Comm: mount.cifs Not tainted 4.19 #10
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
>              rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
> Call Trace:
>   dump_stack+0xdd/0x12a
>   print_address_description+0xa7/0x540
>   kasan_report+0x1ff/0x550
>   check_memory_region+0x2f1/0x310
>   memcpy+0x2f/0x80
>   _copy_from_iter_full+0x783/0xaa0
>   tcp_sendmsg_locked+0x1840/0x4140
>   tcp_sendmsg+0x37/0x60
>   inet_sendmsg+0x18c/0x490
>   sock_sendmsg+0xae/0x130
>   smb_send_kvec+0x29c/0x520
>   __smb_send_rqst+0x3ef/0xc60
>   smb_send_rqst+0x25a/0x2e0
>   compound_send_recv+0x9e8/0x2af0
>   cifs_send_recv+0x24/0x30
>   SMB2_open+0x35e/0x1620
>   open_shroot+0x27b/0x490
>   smb2_open_op_close+0x4e1/0x590
>   smb2_query_path_info+0x2ac/0x650
>   cifs_get_inode_info+0x1058/0x28f0
>   cifs_root_iget+0x3bb/0xf80
>   cifs_smb3_do_mount+0xe00/0x14c0
>   cifs_do_mount+0x15/0x20
>   mount_fs+0x5e/0x290
>   vfs_kern_mount+0x88/0x460
>   do_mount+0x398/0x31e0
>   ksys_mount+0xc6/0x150
>   __x64_sys_mount+0xea/0x190
>   do_syscall_64+0x122/0x590
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> It can be reproduced by the following step:
>    1. samba configured with: server max protocol = SMB2_10
>    2. mount -o vers=default
> 
> When parse the mount version parameter, the 'ops' and 'val'
> was setted to smb30,  if negotiate result is smb21, just
> update the 'ops' to smb21, but the 'val' is still smb30.
> When add lease context, the iov_base is allocated with smb21
> ops, but the iov_len is initiallited with the smb30. Because
> the iov_len is longer than iov_base, when send the message,
> copy array out of bounds.
> 
> we need to keep the 'ops' and 'vol' consistent.
> 
> Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
> ---
>   fs/cifs/smb2pdu.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5f011a8..696db37 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -832,8 +832,11 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
>   		} else if (rsp->DialectRevision == cpu_to_le16(SMB21_PROT_ID)) {
>   			/* ops set to 3.0 by default for default so update */
>   			ses->server->ops = &smb21_operations;
> -		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID))
> +			ses->server->vals = &smb21_values;
> +		} else if (rsp->DialectRevision == cpu_to_le16(SMB311_PROT_ID)) {
>   			ses->server->ops = &smb311_operations;
> +			ses->server->vals = &smb311_values;
> +		}
>   	} else if (le16_to_cpu(rsp->DialectRevision) !=
>   				ses->server->vals->protocol_id) {
>   		/* if requested single dialect ensure returned dialect matched */
> 

