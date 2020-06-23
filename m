Return-Path: <SRS0=n4et=AE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056F2C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 01:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E32DB20767
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Jun 2020 01:42:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbgFWBmJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Jun 2020 21:42:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37372 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730322AbgFWBmJ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Jun 2020 21:42:09 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C116CF19D8E1436E2B68;
        Tue, 23 Jun 2020 09:42:04 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.161) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Tue, 23 Jun 2020
 09:42:00 +0800
Subject: Re: [PATCH] cifs/smb3: Fix data inconsistent when zero file range
To:     Pavel Shilovsky <piastryyy@gmail.com>
CC:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <20200620025033.4180077-1-zhangxiaoxu5@huawei.com>
 <CAKywueQD0aM3uJYmC0GbAj_F5RwcKNX1PS1_q+3dn6gyUR_+Xw@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Message-ID: <e4f864b2-929d-eb7e-4ccc-a85192b88d39@huawei.com>
Date:   Tue, 23 Jun 2020 09:42:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAKywueQD0aM3uJYmC0GbAj_F5RwcKNX1PS1_q+3dn6gyUR_+Xw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.161]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2020/6/23 1:46, Pavel Shilovsky 写道:
> пт, 19 июн. 2020 г. в 22:04, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
>>
>> CIFS implements the fallocate(FALLOC_FL_ZERO_RANGE) with send SMB
>> ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
>> remote file to zero, but local page cache not update, then the data
>> inconsistent with server, which leads the xfstest generic/008 failed.
>>
>> So we need to remove the local page caches before send SMB
>> ioctl(FSCTL_SET_ZERO_DATA) to server. After next read, it will
>> re-cache it.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> ---
>>   fs/cifs/smb2ops.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
>> index 736d86b8a910..250b51aca514 100644
>> --- a/fs/cifs/smb2ops.c
>> +++ b/fs/cifs/smb2ops.c
>> @@ -3187,6 +3187,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>>          trace_smb3_zero_enter(xid, cfile->fid.persistent_fid, tcon->tid,
>>                                ses->Suid, offset, len);
>>
>> +       /*
>> +        * We zero the range through ioctl, so we need remove the page caches
>> +        * first, otherwise the data may be inconsistent with the server.
>> +        */
>> +       truncate_pagecache_range(inode, offset, offset + len - 1);
>>
>>          /* if file not oplocked can't be sure whether asking to extend size */
>>          if (!CIFS_CACHE_READ(cifsi))
>> --
>> 2.25.4
>>
> 
> Looks good!
> 
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> 
Thanks.
> Don't we need to do the same for smb3_punch_hole()?
The problem also exists when punch hole.
# dmesg > dmesg
# strace -e trace=pread64,fallocate xfs_io -f -c "pread 20 40" \
                                               -c "fpunch 20 40" \
                                               -c"pread 20 40" dmesg
pread64(3, " VFS: \\\\192.168.26.62 Cancelling"..., 40, 20) = 40
fallocate(3, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 20, 40) = 0
pread64(3, " VFS: \\\\192.168.26.62 Cancelling"..., 40, 20) = 40

When punch hole success, we also can read old data from file.

I will send a new patch to fix it.
> 
> --
> Best regards,
> Pavel Shilovsky
> 

