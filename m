Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C90A2C48BE5
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 01:44:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F87613A9
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 01:44:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbhFRBqt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 21:46:49 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8264 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbhFRBqs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 21:46:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5hRq33JKz1BNgv;
        Fri, 18 Jun 2021 09:39:35 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:44:38 +0800
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:44:38 +0800
Subject: Re: [PATCH -next] cifsd: fix WARNING: convert list_for_each to entry
 variant in smb2pdu.c
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        "Hyunchul Lee" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
References: <20210617064653.3193618-1-libaokun1@huawei.com>
 <20210617092639.GD1861@kadam>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <fa589904-ac16-fb97-bb7a-df081954d363@huawei.com>
Date:   Fri, 18 Jun 2021 09:44:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210617092639.GD1861@kadam>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I don't know what the difference is between

list_for_each_entry() and list_for_each() for 'struct channel *chann',

but I don't think there's any difference here.

Would you give me more detial about this, please?

Thank you.

Best Regards.


ÔÚ 2021/6/17 17:26, Dan Carpenter Ð´µÀ:
> On Thu, Jun 17, 2021 at 02:46:53PM +0800, Baokun Li wrote:
>> convert list_for_each() to list_for_each_entry() where
>> applicable.
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> ---
>>   fs/cifsd/smb2pdu.c | 15 ++++-----------
>>   1 file changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c
>> index ac15a9287310..22ef1d9eed1b 100644
>> --- a/fs/cifsd/smb2pdu.c
>> +++ b/fs/cifsd/smb2pdu.c
>> @@ -74,10 +74,7 @@ static inline int check_session_id(struct ksmbd_conn *conn, u64 id)
>>   struct channel *lookup_chann_list(struct ksmbd_session *sess)
>>   {
>>   	struct channel *chann;
>> -	struct list_head *t;
>> -
>> -	list_for_each(t, &sess->ksmbd_chann_list) {
>> -		chann = list_entry(t, struct channel, chann_list);
>> +	list_for_each_entry(chann, &sess->ksmbd_chann_list, chann_list) {
>>   		if (chann && chann->conn == sess->conn)
> "chan" is the list iterator and it can't be NULL.
>
>>   			return chann;
>>   	}
> regards,
> dan carpenter
>
> .
