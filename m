Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B59ECAAD5
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Sep 2022 02:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiIECT2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Sep 2022 22:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234233AbiIECT1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Sep 2022 22:19:27 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E9F2AC6
        for <linux-cifs@vger.kernel.org>; Sun,  4 Sep 2022 19:19:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4MLXGn642NzKMc5
        for <linux-cifs@vger.kernel.org>; Mon,  5 Sep 2022 10:17:37 +0800 (CST)
Received: from [10.174.176.83] (unknown [10.174.176.83])
        by APP4 (Coremail) with SMTP id gCh0CgCHSYmpXBVjlyuGAQ--.23444S2;
        Mon, 05 Sep 2022 10:19:22 +0800 (CST)
Message-ID: <d671638f-e151-0fed-fdee-f17cc99c16bd@huaweicloud.com>
Date:   Mon, 5 Sep 2022 10:19:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of
 FSCTL_VALIDATE_NEGOTIATE_INFO
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-3-zhangxiaoxu5@huawei.com>
 <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
 <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
From:   huaweicloud <zhangxiaoxu@huaweicloud.com>
In-Reply-To: <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCHSYmpXBVjlyuGAQ--.23444S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGF15Cr17uF13JrW8tF43ZFb_yoW5GF1rpF
        93W3Z2kFZxXr4Ikr18tw4v9a4av3y09F4UWrnxGw1fXF9ayr10va4UGr98u39ak3y8tr40
        qa1ktFZxtFyUAaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1F6r1fM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
        e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
        6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
        14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
        7IU1zuWJUUUUU==
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
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
Thanks Tom.

I will send next version.

In smb2_ioctl, validate the in_buf_len with offsetof(Dialects),
in fsctl_validate_negotiate_info, validate the DialectCount
>>

