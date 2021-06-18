Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A17C2C49361
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 07:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE2861209
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 07:47:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhFRHtX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 03:49:23 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5037 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhFRHtX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Jun 2021 03:49:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5rV91v4CzXh5N;
        Fri, 18 Jun 2021 15:42:09 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 15:47:13 +0800
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 15:47:12 +0800
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
 <fa589904-ac16-fb97-bb7a-df081954d363@huawei.com>
 <20210618051400.GG1861@kadam>
From:   "libaokun (A)" <libaokun1@huawei.com>
Message-ID: <4adc3507-6b34-1f23-36cb-21336d5e8e91@huawei.com>
Date:   Fri, 18 Jun 2021 15:47:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210618051400.GG1861@kadam>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500020.china.huawei.com (7.185.36.88)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

在 2021/6/18 13:14, Dan Carpenter 写道:
> On Fri, Jun 18, 2021 at 09:44:37AM +0800, libaokun (A) wrote:
>> I don't know what the difference is between
>>
>> list_for_each_entry() and list_for_each() for 'struct channel *chann',
>>
>> but I don't think there's any difference here.
> Correct.  There is no difference, but Coccinelle is smart enough to
> parse list_for_each_entry() and it's not smart enough to parse
> list_for_each().
>
>> Would you give me more detial about this, please?
> There is a Coccinelle script scripts/coccinelle/iterators/itnull.cocci
> which will complain about the NULL check in the new code so this patch
> will introduce a new warning.  We may as well remove the unnecessary
> NULL check and avoid the warning.
>
> regards,
> dan carpenter
>
> .

I get your point, but this bug has nothing to do with my patch.

It's  from e2f34481b24d(cifsd: add server-side procedures for SMB3).

Thank you.

-- 
With Best Regards,
Baokun Li



