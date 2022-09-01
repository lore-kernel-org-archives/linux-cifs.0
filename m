Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D37ECAAD1
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 03:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiIADYB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 23:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiIADYA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 23:24:00 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B1C155D73
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 20:23:58 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MJ5r421tCzYcpg;
        Thu,  1 Sep 2022 11:19:32 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 11:23:56 +0800
Message-ID: <f41f9dd3-e4b4-5a45-be58-799c1bf7271d@huawei.com>
Date:   Thu, 1 Sep 2022 11:23:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 0/3] Fix some bug in FSCTL_VALIDATE_NEGOTIATE_INFO
 handler
To:     Tom Talpey <tom@talpey.com>, <linux-cifs@vger.kernel.org>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>
References: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
 <3b13302f-28b4-60b2-7f3e-0c62703ee7b7@talpey.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <3b13302f-28b4-60b2-7f3e-0c62703ee7b7@talpey.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2022/8/31 22:50, Tom Talpey 写道:
> On 8/31/2022 3:52 AM, Zhang Xiaoxu wrote:
>> v1->v2: fix some bug in ksmbd when handle FSCTL_VALIDATE_NEGOTIATE_INFO
>>     message
>>
>> Zhang Xiaoxu (3):
>>    cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
>>    ksmbd: Remove the wrong message length check of
>>      FSCTL_VALIDATE_NEGOTIATE_INFO
>>    ksmbd: Fix wrong return value in smb2_ioctl() when wrong out_buf_len
>>
>>   fs/cifs/smb2pdu.c  | 4 ++--
>>   fs/ksmbd/smb2pdu.c | 9 ++++-----
>>   2 files changed, 6 insertions(+), 7 deletions(-)
>>
> 
> Sorry but these are a NAK from me - they don't actually change
> the definition to a variable-length array, they just attempt
> to undo the broken "4", in several places. The real fix begins
> in smbpdu.h in this line:
>          __le16 Dialects[4]; --> Dialects[]
This patchset just for fix the problems, the patches for refactor to
variable-length array is on the way.
> 
> Also, the change to ksmbd is incorrect, it is critical to check
> that the inbound buffer holds at least enough data to be able
> to dereference the DialectCount, followed by a second check
> that all the counted array elements are present. Also that
> the outbound buffer is large enough to return a single dialect.
The 'fsctl_validate_negotiate_info' function already check the inbound
buffer length, so remove the wrong inbound check in 'smb2_ioctl',
do you mean move the inbound check from 'fsctl_validate_negotiate_info'
to 'smb2_ioctl'?

7387 static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,                                                                                                                                                                         │  ksmbd_spnego_negtokeninit.as
7388                                          struct validate_negotiate_info_req *neg_req,                                                                                                                                                     │  ksmbd_spnego_negtokeninit.as
7389                                          struct validate_negotiate_info_rsp *neg_rsp,                                                                                                                                                     │  ksmbd_spnego_negtokentarg.as
7390                                          unsigned int in_buf_len)                                                                                                                                                                         │  ksmbd_spnego_negtokentarg.as
7391 {                                                                                                                                                                                                                                         │  ksmbd_spnego_negtokentarg.as
7392         int ret = 0;                                                                                                                                                                                                                      │  ksmbd_spnego_negtokentarg.as
7393         int dialect;                                                                                                                                                                                                                      │  ksmbd_work.c
7394                                                                                                                                                                                                                                           │  ksmbd_work.h
7395         if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +                                                                                                                                                         │  ksmbd_work.o
7396                         le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))                                                                                                                                                              │  Makefile
7397                 return -EINVAL;
> 
> Tom.
