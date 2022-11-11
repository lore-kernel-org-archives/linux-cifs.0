Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03209C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Nov 2022 01:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiKKBL0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Nov 2022 20:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKKBLX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Nov 2022 20:11:23 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EB3623A7
        for <linux-cifs@vger.kernel.org>; Thu, 10 Nov 2022 17:11:16 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7gXz2StbzqSGq;
        Fri, 11 Nov 2022 09:07:31 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 09:11:13 +0800
Message-ID: <c7660b6b-7ecf-a3c7-27bb-d464c05be737@huawei.com>
Date:   Fri, 11 Nov 2022 09:11:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] cifs: Fix connections leak when tlink setup failed
To:     Paulo Alcantara <pc@cjr.nz>, <linux-cifs@vger.kernel.org>,
        <sfrench@samba.org>, <smfrench@gmail.com>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <tom@talpey.com>
References: <20221110030009.2207092-1-zhangxiaoxu5@huawei.com>
 <87eduawlaa.fsf@cjr.nz>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <87eduawlaa.fsf@cjr.nz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



On 2022/11/11 5:29, Paulo Alcantara wrote:
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:
> 
>> If the tlink setup failed, lost to put the connections, then
>> the module refcnt leak since the cifsd kthread not exit.
>>
>> Also leak the fscache info, and for next mount with fsc,it will
>> print the follow errors:
>>    CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)
>>
>> Let's check the result of tlink setup, and put the connection when
>> error happened.
>>
>> Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> ---
>>   fs/cifs/connect.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 1cc47dd3b4d6..e699e45e70c4 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -3855,14 +3855,19 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>>   	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
>>   
>>   out:
>> -	free_xid(mnt_ctx.xid);
>>   	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
>> -	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>> +	rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
>> +	if (rc)
>> +		goto put_conns;
> 
> Good catch.  However, this would partially fix the leaked connections as
> you must still call dfs_cache_put_refsrv_sessions() to put all other
> connections that were used for chasing DFS referrals.  For non-DFS
> mounts, it wouldn't be a problem, though.
> 
> What about something like below
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1cc47dd3b4d6..083ba70f3c1a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3855,9 +3855,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>   	uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
>   
>   out:
> -	free_xid(mnt_ctx.xid);
>   	cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
> -	return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +	rc =  mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +	if (rc)
> +		goto error;
> +
> +	free_xid(mnt_ctx.xid);
> +	return rc;
>   
>   error:
>   	dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
Thanks Paulo, I will check this point and send v2.
