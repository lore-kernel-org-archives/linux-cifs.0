Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87D7ECAAD5
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 02:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiHaCDn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 22:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbiHaCDh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 22:03:37 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C576EB3B01
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 19:03:33 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4MHS8v3fBjz6S3M8
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 10:01:51 +0800 (CST)
Received: from [10.174.176.83] (unknown [10.174.176.83])
        by APP4 (Coremail) with SMTP id gCh0CgC3eopywQ5jIZuhAA--.56473S2;
        Wed, 31 Aug 2022 10:03:31 +0800 (CST)
Message-ID: <d317cfcb-222a-8f2c-0ad6-de2a21db8926@huaweicloud.com>
Date:   Wed, 31 Aug 2022 10:03:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO
 message
To:     Tom Talpey <tom@talpey.com>, stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, pc@cjr.nz
References: <20220824085732.1928010-1-zhangxiaoxu5@huawei.com>
 <495c09a3-003f-7852-ef14-ba7e26984743@huaweicloud.com>
 <4d6633a3-43a5-8a4b-991c-d8148ce949b1@talpey.com>
 <3215c221-1c88-28f9-20f1-e492bb62cc50@huaweicloud.com>
 <e62b79c6-762c-2d4e-cca6-181eb1520409@talpey.com>
From:   huaweicloud <zhangxiaoxu@huaweicloud.com>
In-Reply-To: <e62b79c6-762c-2d4e-cca6-181eb1520409@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC3eopywQ5jIZuhAA--.56473S2
X-Coremail-Antispam: 1UD129KBjvJXoWxuF45GryfJr4DuFWUWF4xXrb_yoWrZFWfpF
        yvqFyDKrWrJr18Cw12yr1UW345Kw18Ww1DWr1DKa43J3Z0yF12gF48Wr90grnayr48Jr1j
        qw4UtFy3Zry3Ar7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: x2kd0wp0ld053x6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org



在 2022/8/31 0:19, Tom Talpey 写道:
> On 8/30/2022 10:30 AM, huaweicloud wrote:
>> I think the struct validate_negotiate_info_req is an variable-length array,
>> just for implement simple, defind as 4 in here.
> 
> But that's my point. The code picks "4" arbitrarily, and that
> number can change - as you discovered, it already did since
> it used to be "3".
> 
> smb2pdu.h:
> struct validate_negotiate_info_req {
>      __le32 Capabilities;
>      __u8   Guid[SMB2_CLIENT_GUID_SIZE];
>      __le16 SecurityMode;
>      __le16 DialectCount;
>      __le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
> } __packed;
> 
> I repeat my suggestion.
> 
> Alternatively, change the code to make it a variable array and
> allocate it properly.
Agreed with change it to variable-length array.

Since the struct validate_negotiate_info_req also used by ksmbd and it not
treat it as the variable-length array:

int smb2_ioctl(struct ksmbd_work *work)
{
         case FSCTL_VALIDATE_NEGOTIATE_INFO:

                if (in_buf_len < sizeof(struct validate_negotiate_info_req))
                        return -EINVAL;
}

But in samba, treat it as the variable-length array:

static NTSTATUS fsctl_validate_neg_info(TALLOC_CTX *mem_ctx,
                                         struct tevent_context *ev,
                                         struct smbXsrv_connection *conn,
                                         DATA_BLOB *in_input,
                                         uint32_t in_max_output,
                                         DATA_BLOB *out_output,
                                         bool *disconnect)
{
	in_num_dialects = SVAL(in_input->data, 0x16);

	if (in_input->length < (0x18 + in_num_dialects*2)) {
		return NT_STATUS_INVALID_PARAMETER;
	}
}

now, I'm trying to make it to variable-length array,
but this patch, just fix the wrong message length sent by cifs client.

Thanks.
> 
> Tom.
> 
>> According MS-SMB2, there really not define the length of the package, just
>> define the count of the dialects, but just send the needed data maybe more
>> appropriate.
>>
>> Thanks.
>>
>> 在 2022/8/30 22:03, Tom Talpey 写道:
>>> Wouldn't it be safer to just set the size, instead of implicitly
>>> assuming that there are 4 array elements?
>>>
>>>    inbuflen = sizeof(*pneg_inbuf) - sizeof(pneg_inbuf.Dialects) + sizeof(pneg_inbuf.Dialects[0]);
>>>
>>> Or, because it obviously works to send the extra bytes even
>>> though the DialectCount is just 1, just zero them out?
>>>
>>>    memset(pneg_inbuf.Dialects, 0, sizeof(pneg_inbuf.Dialects));
>>>    pneg_inbuf.Dialects[0] = cpu_to_le16(server->vals->protocol_id);
>>>
>>> Tom.
>>>
>>> On 8/30/2022 3:06 AM, huaweicloud wrote:
>>>> Hi Steve,
>>>>
>>>> Could you help to review this patch.
>>>>
>>>> Thanks,
>>>> Zhang Xiaoxu
>>>>
>>>> 在 2022/8/24 16:57, Zhang Xiaoxu 写道:
>>>>> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>>> extend the dialects from 3 to 4, but forget to decrease the extended
>>>>> length when specific the dialect, then the message length is larger
>>>>> than expected.
>>>>>
>>>>> This maybe leak some info through network because not initialize the
>>>>> message body.
>>>>>
>>>>> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
>>>>> reduced from 28 bytes to 26 bytes.
>>>>>
>>>>> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>>>>> Cc: <stable@vger.kernel.org>
>>>>> ---
>>>>>   fs/cifs/smb2pdu.c | 4 ++--
>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>>>> index 1ecc2501c56f..3df7adc01fe5 100644
>>>>> --- a/fs/cifs/smb2pdu.c
>>>>> +++ b/fs/cifs/smb2pdu.c
>>>>> @@ -1162,9 +1162,9 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>>>>>           pneg_inbuf->Dialects[0] =
>>>>>               cpu_to_le16(server->vals->protocol_id);
>>>>>           pneg_inbuf->DialectCount = cpu_to_le16(1);
>>>>> -        /* structure is big enough for 3 dialects, sending only 1 */
>>>>> +        /* structure is big enough for 4 dialects, sending only 1 */
>>>>>           inbuflen = sizeof(*pneg_inbuf) -
>>>>> -                sizeof(pneg_inbuf->Dialects[0]) * 2;
>>>>> +                sizeof(pneg_inbuf->Dialects[0]) * 3;
>>>>>       }
>>>>>       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>>
>>>>
>>
>>

