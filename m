Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9B8C49EA3
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 01:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1339613AA
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 01:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbhFRBUa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 21:20:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4960 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhFRBU3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Jun 2021 21:20:29 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5gvc3cHzz7156;
        Fri, 18 Jun 2021 09:15:08 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:18:19 +0800
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:18:19 +0800
Subject: Re: [PATCH -next] cifs: convert list_for_each to entry variant in
 smb2misc.c
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Steve French <sfrench@samba.org>, <linux-cifs@vger.kernel.org>,
        <samba-technical@lists.samba.org>,
        <kernel-janitors@vger.kernel.org>, "Hulk Robot" <hulkci@huawei.com>
References: <20210617132250.690226-1-libaokun1@huawei.com>
 <20210617141717.GF1861@kadam>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <e1804505-b984-ac6b-a204-22d24ef7ae21@huawei.com>
Date:   Fri, 18 Jun 2021 09:18:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210617141717.GF1861@kadam>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thank you for your advice.

I'm about to send a patch v2 with the changes suggested by you.

Best Regards.


ÔÚ 2021/6/17 22:17, Dan Carpenter Ð´µÀ:
> On Thu, Jun 17, 2021 at 09:22:50PM +0800, Baokun Li wrote:
>> @@ -628,9 +624,7 @@ smb2_is_valid_lease_break(char *buffer)
>>   
>>   	/* look up tcon based on tid & uid */
>>   	spin_lock(&cifs_tcp_ses_lock);
>> -	list_for_each(tmp, &cifs_tcp_ses_list) {
>> -		server = list_entry(tmp, struct TCP_Server_Info, tcp_ses_list);
>> -
>> +	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>>   		list_for_each(tmp1, &server->smb_ses_list) {
>>   			ses = list_entry(tmp1, struct cifs_ses, smb_ses_list);
>                          ^^^^^^^^^^^^^^^^
>
> Please convert this one as well.
>
>>   
>> @@ -687,7 +681,7 @@ bool
>>   smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>>   {
>>   	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
>> -	struct list_head *tmp, *tmp1, *tmp2;
>> +	struct list_head *tmp1, *tmp2;
>>   	struct cifs_ses *ses;
>>   	struct cifs_tcon *tcon;
>>   	struct cifsInodeInfo *cinode;
>> @@ -710,9 +704,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>>   
>>   	/* look up tcon based on tid & uid */
>>   	spin_lock(&cifs_tcp_ses_lock);
>> -	list_for_each(tmp, &server->smb_ses_list) {
>> -		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
>> -
>> +	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
>>   		list_for_each(tmp1, &ses->tcon_list) {
>>   			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
>                          ^^^^^^^^^^^^^^^^^
> And this one.
>
> regards,
> dan carpenter
>
>>   
> .
