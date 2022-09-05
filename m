Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6F2ECAAD5
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Sep 2022 02:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiIEC3o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Sep 2022 22:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbiIEC3n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Sep 2022 22:29:43 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB7E1A83E
        for <linux-cifs@vger.kernel.org>; Sun,  4 Sep 2022 19:29:40 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MLXSb1SWfzlWmt;
        Mon,  5 Sep 2022 10:26:07 +0800 (CST)
Received: from [10.174.176.83] (10.174.176.83) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 5 Sep 2022 10:29:38 +0800
Message-ID: <307b7cba-9c73-bcaf-d3f2-02c40ebaf836@huawei.com>
Date:   Mon, 5 Sep 2022 10:29:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of
 FSCTL_VALIDATE_NEGOTIATE_INFO
To:     Namjae Jeon <linkinjeon@kernel.org>
CC:     Tom Talpey <tom@talpey.com>, <linux-cifs@vger.kernel.org>,
        <sfrench@samba.org>, <pc@cjr.nz>, <lsahlber@redhat.com>,
        <sprasad@microsoft.com>, <rohiths@microsoft.com>,
        <smfrench@gmail.com>, <hyc.lee@gmail.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-3-zhangxiaoxu5@huawei.com>
 <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
 <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
From:   "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
In-Reply-To: <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.83]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2022/9/2 22:47, Namjae Jeon 写道:
> 2022-09-02 22:28 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
>>> The struct validate_negotiate_info_req change from variable-length array
>>> to reguler array, but the message length check is unchanged.
>>>
>>> The fsctl_validate_negotiate_info() already check the message length, so
>>> remove it from smb2_ioctl().
>>>
>>> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and
> I think the fixes tag is wrong. Isn't the below correct?
> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")

Before commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and
move its struct to smbfs_common"), the struct defined in fs/ksmbd/smb2pdu.h:

   struct validate_negotiate_info_req {
          __le32 Capabilities;
          __u8   Guid[SMB2_CLIENT_GUID_SIZE];
          __le16 SecurityMode;
          __le16 DialectCount;
          __le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
   } __packed;

After this commit, the struct defined in fs/smbfs_common/smb2pdu.h:
   struct validate_negotiate_info_req {
          __le32 Capabilities;
          __u8   Guid[SMB2_CLIENT_GUID_SIZE];
          __le16 SecurityMode;
          __le16 DialectCount;
          __le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
   } __packed;

The 'Dialects' array length from 1 change to 4.

Before commit c7803b05f74b, the message should contain at lease 1 dialects,
but after this commit, it changed to should contain at lease 4 dialects.

So the fixes tag should be c7803b05f74b.

> 
>>> move its struct to smbfs_common")
>>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    fs/ksmbd/smb2pdu.c | 3 ---
>>>    1 file changed, 3 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>> index c49f65146ab3..c9f400bbb814 100644
>>> --- a/fs/ksmbd/smb2pdu.c
>>> +++ b/fs/ksmbd/smb2pdu.c
>>> @@ -7640,9 +7640,6 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>    			goto out;
>>>    		}
>>>
>>> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
>>> -			return -EINVAL;
>>> -
>>
>> This actually fixes a different bug, which the comment needs to mention.
>> The structure size includes 4 dialect slots, but the protocol does not
>> require the client to send all 4. So this allows the negotiation to not
>> fail. Which is good.
>>
>> But there are two other issues now.
>>
>> 1) The code no longer checks that a complete validate negotiate header
>> is present before dereferencing neg_req->DialectCount. This code will
>> fetch the DialectCount potentially beyond the end of an invalid short
>> packet:
>>
>>     fsctl_validate_negotiate_info():
>>
>>           if (in_buf_len < offsetof(struct validate_negotiate_info_req,
>> Dialects) +
>>                           le16_to_cpu(neg_req->DialectCount) *
>> sizeof(__le16))
>>                   return -EINVAL;
>>
>>           dialect = ksmbd_lookup_dialect_by_id(neg_req->Dialects,
>>                                                neg_req->DialectCount);
>>
>> 2) The DialectCount is an le16, which can be negative. A small invalid
>> negative value may pass this test and proceed to process the array,
>> which would be bad. This is an existing issue, but should be fixed
>> since you now need to correct the test anyway.
>>
>> Tom.
>>
>>
>>>    		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
>>>    			return -EINVAL; >
>>
