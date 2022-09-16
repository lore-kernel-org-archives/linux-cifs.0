Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E66ECAAD8
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Sep 2022 11:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIPLUH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiIPLUF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 07:20:05 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B908C4F699
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 04:20:03 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MTWhC6vY7zMmxp;
        Fri, 16 Sep 2022 19:15:23 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 16 Sep 2022 19:20:01 +0800
Message-ID: <560f7201-3703-d2d4-88e3-0604c35dbdb3@huawei.com>
Date:   Fri, 16 Sep 2022 19:20:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v6 3/5] ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message
 length check in smb2_ioctl()
To:     Namjae Jeon <linkinjeon@kernel.org>
CC:     <linux-cifs@vger.kernel.org>, <sfrench@samba.org>, <pc@cjr.nz>,
        <lsahlber@redhat.com>, <sprasad@microsoft.com>,
        <rohiths@microsoft.com>, <smfrench@gmail.com>, <tom@talpey.com>,
        <hyc.lee@gmail.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-4-zhangxiaoxu5@huawei.com>
 <CAKYAXd-g8E8wpJDPSdiW7W_0JGudxUTJj6wr7C5wcnBUUTZF0A@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <CAKYAXd-g8E8wpJDPSdiW7W_0JGudxUTJj6wr7C5wcnBUUTZF0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2022/9/16 8:26, Namjae Jeon 写道:
> 2022-09-14 11:17 GMT+09:00, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
>> The structure size includes 4 dialect slots, but the protocol does not
>> require the client to send all 4. So this allows the negotiation to not
>> fail.
>>
>> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and
>> move its struct to smbfs_common")
> NACK. I am still thinking this tag is wrong.
Thanks for your comments.

In the v2, I remove the validation expression, and as your comments
in v2, duplicate check is unneed.

I add it back in v6 because tom's comments, we should ensure the req
has 'DialectCount', before validate the req has enough 'Dialects',
otherwise, dereferencing 'neg_req->DialectCount' will be OOB read.

Maybe the validation expression as below much better:
@@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
   ...
   if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects[1]))

If even there's no one Dialects, 'the fsctl_validate_negotiate_info'
still return -EINVAL:

   fsctl_validate_negotiate_info
     ksmbd_lookup_dialect_by_id(neg_req->DialectCount=0)
       return BAD_PROT_ID
     ret = -EINVAL;

Same as before commit c7803b05f74b.

Could you give me more help about the fix tag.

Thanks.
Zhang Xiaoxu
> 
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index b56d7688ccf1..09ae601e64f9 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>>   			goto out;
>>   		}
>>
>> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
>> +		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
>> +					  Dialects)) {
>>   			ret = -EINVAL;
>>   			goto out;
>>   		}
>> --
>> 2.31.1
>>
>>
