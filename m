Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F00ECAAD4
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 12:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbiHaMuR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 08:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiHaMuA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 08:50:00 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238BD4F48
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 05:49:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzD5BAPHrpP5QR6717bZkpFYrugslesS8v1EgL1rv3jzKf77IFKAmQpnzBztsuYE4H+wOwiC60AGJ96Jz2mrOitjAVhKH/hzHUlV8qP5EHNJopfgaceC/dj28Y1VLUGnOtbrT+t0aYtZQNU1akGvLX8LwBFeIAhyx2LOVpw8jqax5M9dxzsFw5mOahZUv2LaqVM2JHGDG2jV5yGU/hsMRtL4qGUJNq0CKyfaucnThPaW//lRGC+PN0UbgrdXyZRGmHxCB6/2bUofl8ovrP6CzbpbK37APx4l2AqAMSNPcM7pUWwbNSD2YPpNyUFbNNrAgL3UQt85VUcJuvL32XX3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMbdB+6lwWKN6UI+NH2RPBL7Y3cOchYj0++r+TCc7O4=;
 b=fI1cjkMDqI5IDwP+JdBAwc0hmeVRZ//5fgclW6/Fmx7cbKGCsyD9csXjFTkR0U8tYzizyiQ+cBpP4fKNwJLsLvntpqeqQlpxlXGmPQyH3DP5Z6qphqkCXn1Trll6buXor6ajP77/CoriAsJgyhOQjlT554R1Y3wRw8B6IpXLnZUoKK6IxwkGqT1ewf16iBX+1sWHuBwJ5jVYEFCkqlThsBStbbU3ZAkIXyIlENpa7PPF4R4cGbVJLoTVpi+QT7K7yvaDlmrzZFfaGwRNagl35xrcCqfNBj3B5hiXwdqXryNLKTvePpKL1Uj184rUNBY6nq0hYtbOFcJsfn4f0amzKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4674.prod.exchangelabs.com (2603:10b6:208:73::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Wed, 31 Aug 2022 12:49:35 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 12:49:35 +0000
Message-ID: <78d4c0ca-1f1d-e8d2-1a13-ff7aaea9841e@talpey.com>
Date:   Wed, 31 Aug 2022 08:49:33 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO
 message
Content-Language: en-US
To:     huaweicloud <zhangxiaoxu@huaweicloud.com>, stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, pc@cjr.nz
References: <20220824085732.1928010-1-zhangxiaoxu5@huawei.com>
 <495c09a3-003f-7852-ef14-ba7e26984743@huaweicloud.com>
 <4d6633a3-43a5-8a4b-991c-d8148ce949b1@talpey.com>
 <3215c221-1c88-28f9-20f1-e492bb62cc50@huaweicloud.com>
 <e62b79c6-762c-2d4e-cca6-181eb1520409@talpey.com>
 <d317cfcb-222a-8f2c-0ad6-de2a21db8926@huaweicloud.com>
 <3aa9c4f7-6d25-db42-e98c-44960e98eb06@huaweicloud.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <3aa9c4f7-6d25-db42-e98c-44960e98eb06@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:36e::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee9f8216-f356-4b85-02ca-08da8b4f4203
X-MS-TrafficTypeDiagnostic: BL0PR01MB4674:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQIsCcftHDN9mJ30XnHJfXBFBhpT7Ldeu2nVbV8AXug9C+3XuLaDFRXAORFxxqqm5b2U4MkopIStbtePYzfK5Ok5kITEJNSfXEM6n0+21T25rsUcQ7K6v3as9h+PVwLwCx8TyiK8jpqQolW1Hx+QOBj89Agt+8bxVCy0s6CA7i+/jT3oys3sAAmUqUYh9ESI+MZFneZzyNzdW7Mg6YKnd9zvWeLdEs2C2BWk5QBn0AXRSOmsX5g0EMX8vk2uf2DAlrEqNrz8U2X5AHyo9f3eCUHlMR4LK/O1XZoYdzrsogglrUVn3TUvC9jE7lST0nF2VsPeWossXbpsh5X42Ve60Md4l+BGg9Cgrq3o9t7P7SoDtQr7Lrjhtj9c8Ju9ZXvDgCdsGxKoScP0nz1TkPz1gkBbkZExvSvSQWmXzSJSWsWQ6cMY5O/jj1Irj6ugxxBSouYas+rwodBWcbL+UqCC7HV3vZ9hN9A5GKBUGgyPk5afvE5Ad5BAYpTcblfG4qoDo3+TNVcLxpd+ZoLSNjXLzJ9XVI8oE+utUZs+wtpSp2D8O9e6vzx5GyKPeT4sl1Oo+xEJec6B3q4zg+dpHtAu8HuPmZMCZIv7GKYKUxt8NUfPPOFvsDpsaa7t354o0dUibTOti0LgPSDI5nwqxXcvv/4+tfODiOHlWZj6sp96Jl72jmjy0MM3CDy6SZpXi+RfkQVGSk8AzZ4WdpDCTwx+UnIbH3mDBq45o18vkNnTxfpOrQ+GpxzAnj7wuYUekJOopTmmYL+dlqq0DbPNAQykxRwrCmle/Uo9BPd1G9QbTyQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(396003)(376002)(39830400003)(316002)(186003)(52116002)(2616005)(26005)(6506007)(53546011)(6512007)(41300700001)(6486002)(478600001)(86362001)(31696002)(36756003)(15650500001)(2906002)(38350700002)(38100700002)(83380400001)(8676002)(4326008)(66946007)(66476007)(66556008)(8936002)(31686004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVhqU3BmZ1ZQMDZlSTloa2ltVDZkUVZ1SnFpUzY3bGVqMVVnVkx6dUVBUHBr?=
 =?utf-8?B?MmZ5WTZFQzNlbi9kMTZTNXJvZXZ0WHBLWVZ3SWpIelZhdW5LSVdDaWt3OHFa?=
 =?utf-8?B?ZG1CaWtWVFRxeGJralZzazN4RlZ3cjB0dHV0TFdkSEcvQUc4WTh2MVhQTWlH?=
 =?utf-8?B?Y0tyVGJiUDBBV0s2SDFGb2VmTzRZWnRDR0grdHQyeGVObGo4ZG45cUFQbE5y?=
 =?utf-8?B?ZTdxTG0wNENhc2w3dW1kY0tsSFE2dVdsYmdPZVY2QlRWbTBoczBybFNHSGxx?=
 =?utf-8?B?UkZBbjFXZTlZWHFtd2sxUWV4ekFrMk4rbC9qcWpCVnc5OTdNRGdieXdXVjVk?=
 =?utf-8?B?ODBVZmkrUlFTOTNscEJtKzhtMG1EQXhqQk9pczFva3hZY2NwOWNXNWVqakVN?=
 =?utf-8?B?ZmZSaXhyWmd5TVNSVFhIK3RnUDRrcUZYQ2NZRTl6eGEwU2g1NExyYVR4eUVZ?=
 =?utf-8?B?SHRDRGR2T0g3VnE3dWE1ZGlTVG94MVJoUElpTjVERUNNY0M2L2FJL3k2UUU0?=
 =?utf-8?B?aTA3NUlMWWprN2Y3TXlPTUwzRkdRcDFHZld5ZzFteWt0SmpvSjJjdzZqYmov?=
 =?utf-8?B?Yk43YW9Xb3N1ODlJSHE3S2drdkhkbmxIQWFCSm9hM2RNTVZNdUNlSWlZVlEz?=
 =?utf-8?B?TFEyRWNDYzJZck5XNnJHdkNua2lyTVZBVDJlT1dvZ1VaQ2dwbHIyNHNwdUsz?=
 =?utf-8?B?TEdOSCtBeDlqMnVQQ3hxZXhmbCtURWRGSWpxbEVwbmdYOW1MM2N6cDNBVTBH?=
 =?utf-8?B?c2lUbWsyYzM2eTVGdnNjYmxKNmlDQ2V0MC9pZGZvQ0FLcHYzR0F0Q25TOU5X?=
 =?utf-8?B?dnBCSEdSZ2FSSGJNWUJheVNjVUhUaUhveStQYis2a2NWc0dHVmN2dWEvYWRG?=
 =?utf-8?B?aGJEVVJNYnAreEtjcW4vcmg1S0Q5V1VGSzVVMFZBK0NpSFJkMkRWL3VMMmln?=
 =?utf-8?B?ZldKOEVLYWpPMW5HSWhNZjZMc01OamVXQVlJakhRSU5sMzJNVDFoN0VkWmp4?=
 =?utf-8?B?TEhNRVI5RXJSNjNQU0hVVVRjRVpUeUVSbFpJM215dHBXRWZSS1Z1Q3BmU2Nu?=
 =?utf-8?B?c3F2NkRWc2R3cUZwZWlOa3N5aVZTQTNEZ2hjdUROYjYzRFlsNnpPNllWV1Fm?=
 =?utf-8?B?WXBsdkFmdmx5UjRqZy9MckhBZGlVUHlqNVBDV3V3aUh0N3BVK0RpZitrSHdm?=
 =?utf-8?B?OFhpdHh4M0pudjVGeGZmTlRLL2hra0VDeXM5MnlYVEFSTHRZY1k2YTNDUEpU?=
 =?utf-8?B?WWhkNnVMTmZIaDlTZTZXWGVVM3ZRaFNhbEJiNVY0TGF4VktSZG84RkJaKzYr?=
 =?utf-8?B?N095SGhtT2E0Uk1zRzFPQUpmRTVCVVBXTUQwNm16NDNHVXlFL0c1dTBQa09P?=
 =?utf-8?B?U0J3Nk9pM1NXY3RaeHhaZGc3OTRCSjhkdzZ1YXdKSVRCbmFGc0p1cjh4WlFQ?=
 =?utf-8?B?UE53YXJOeXVOLzk0R1BvMm9hU1RoN3NZV2UzemhDWnNzR2hYNVM0c1JtNjAz?=
 =?utf-8?B?bHduQTdkZTlJKzVjclBOSmJLd1h5TmJBNDIyRzFuR2JMRXdMTU1tVXdla1Bt?=
 =?utf-8?B?R0czWkNMM3lpM05UTlpLaHRDUFlCcmtFVkhOYThvN2dZYlVSNlZOL2xaMHpS?=
 =?utf-8?B?N3FtL0lIL3BrdFZkYTVMTGc1Y3J4SVFkQXpReHl3cW9PME81cjZMRmh4RDVE?=
 =?utf-8?B?K1BIQ1lqTHlxVWVEWjZGWTlpNXFRYVpWckpUbVAxNGErVUtsaVcrOGdxbmFV?=
 =?utf-8?B?QmVod3FBU05uYTJISGx2d2NLd0J4bmJEVGI2L3ZnZmh4TGpWS0xnQ3lpT0Jn?=
 =?utf-8?B?bk1RMWllRUNmZXNhYTFlNkxURENJTjVaL2RCTFZxNzlDQm11aGhLQUhOaXlo?=
 =?utf-8?B?Yzh1cmd1dTcvWUt1S3d4M1pFOWRMM2VDK3R6K0VkVXRDUFRWZ0NTM2FCNTJo?=
 =?utf-8?B?ZnFzT0tPK0tIamtWYUNqc0RBNnBvemVTUG1wWm5ubTRMdE5xTTZYd1UzWGpW?=
 =?utf-8?B?YWNNRVFpWkQxNVF1YmR6NkxYUEk1S3VxcWFIb1p2QzVNd0VqWkRubllnQUM3?=
 =?utf-8?B?SnRROCtZZW5Ib1pZdGc3MUZiY2FBMW54WHJ3WHAwNmVQSWtjVUdmVmQwQTN3?=
 =?utf-8?Q?AIXFwZe9CikjtRs0h5l+luzh8?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9f8216-f356-4b85-02ca-08da8b4f4203
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 12:49:35.4235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCHTKTUGkBwuMGcYBsbgzm6w/7iX+K54oezCw0dZdAKSU/tZ5yitljyGXlh6fRYT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4674
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/30/2022 11:39 PM, huaweicloud wrote:
> 在 2022/8/31 10:03, huaweicloud 写道:
>> 在 2022/8/31 0:19, Tom Talpey 写道:
>>> On 8/30/2022 10:30 AM, huaweicloud wrote:
>>>> I think the struct validate_negotiate_info_req is an variable-length 
>>>> array,
>>>> just for implement simple, defind as 4 in here.
>>>
>>> But that's my point. The code picks "4" arbitrarily, and that
>>> number can change - as you discovered, it already did since
>>> it used to be "3".
>>>
>>> smb2pdu.h:
>>> struct validate_negotiate_info_req {
>>>      __le32 Capabilities;
>>>      __u8   Guid[SMB2_CLIENT_GUID_SIZE];
>>>      __le16 SecurityMode;
>>>      __le16 DialectCount;
>>>      __le16 Dialects[4]; /* BB expand this if autonegotiate > 4 
>>> dialects */
>>> } __packed;
> 
>>>
>>> I repeat my suggestion.
>>>
>>> Alternatively, change tqhe code to make it a variable array and
>>> allocate it properly.
>> Agreed with change it to variable-length array.
>>
>> Since the struct validate_negotiate_info_req also used by ksmbd and it 
>> not
>> treat it as the variable-length array:
>>
>> int smb2_ioctl(struct ksmbd_work *work)
>> {
>>          case FSCTL_VALIDATE_NEGOTIATE_INFO:
>>
>>                 if (in_buf_len < sizeof(struct 
>> validate_negotiate_info_req))
>>                         return -EINVAL;
>> }
> Before commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock 
> break, and move its struct to smbfs_common"),
> ksmbd also treat it as variable-length array.

Whoa, looking at the ksmbd code, these are significant interop bugs.
The server should definitely not be rejecting a negotiate which does
not carry this arbitrary "4" value, in addition to the client sending
it properly too.

I look forward to your updates, sorry they're more work now! :)

Tom.

>> But in samba, treat it as the variable-length array:
>>
>> static NTSTATUS fsctl_validate_neg_info(TALLOC_CTX *mem_ctx,
>>                                          struct tevent_context *ev,
>>                                          struct smbXsrv_connection *conn,
>>                                          DATA_BLOB *in_input,
>>                                          uint32_t in_max_output,
>>                                          DATA_BLOB *out_output,
>>                                          bool *disconnect)
>> {
>>      in_num_dialects = SVAL(in_input->data, 0x16);
>>
>>      if (in_input->length < (0x18 + in_num_dialects*2)) {
>>          return NT_STATUS_INVALID_PARAMETER;
>>      }
>> }
>>
>> now, I'm trying to make it to variable-length array,
>> but this patch, just fix the wrong message length sent by cifs client.
>>
>> Thanks.
>>>
>>> Tom.
>>>
>>>> According MS-SMB2, there really not define the length of the 
>>>> package, just
>>>> define the count of the dialects, but just send the needed data 
>>>> maybe more
>>>> appropriate.
>>>>
>>>> Thanks.
>>>>
>>>> 在 2022/8/30 22:03, Tom Talpey 写道:
>>>>> Wouldn't it be safer to just set the size, instead of implicitly
>>>>> assuming that there are 4 array elements?
>>>>>
>>>>>    inbuflen = sizeof(*pneg_inbuf) - sizeof(pneg_inbuf.Dialects) + 
>>>>> sizeof(pneg_inbuf.Dialects[0]);
>>>>>
>>>>> Or, because it obviously works to send the extra bytes even
>>>>> though the DialectCount is just 1, just zero them out?
>>>>>
>>>>>    memset(pneg_inbuf.Dialects, 0, sizeof(pneg_inbuf.Dialects));
>>>>>    pneg_inbuf.Dialects[0] = cpu_to_le16(server->vals->protocol_id);
>>>>>
>>>>> Tom.
>>>>>
>>>>> On 8/30/2022 3:06 AM, huaweicloud wrote:
>>>>>> Hi Steve,
>>>>>>
>>>>>> Could you help to review this patch.
>>>>>>
>>>>>> Thanks,
>>>>>> Zhang Xiaoxu
>>>>>>
>>>>>> 在 2022/8/24 16:57, Zhang Xiaoxu 写道:
>>>>>>> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>>>>> extend the dialects from 3 to 4, but forget to decrease the extended
>>>>>>> length when specific the dialect, then the message length is larger
>>>>>>> than expected.
>>>>>>>
>>>>>>> This maybe leak some info through network because not initialize the
>>>>>>> message body.
>>>>>>>
>>>>>>> After apply this patch, the VALIDATE_NEGOTIATE_INFO message 
>>>>>>> length is
>>>>>>> reduced from 28 bytes to 26 bytes.
>>>>>>>
>>>>>>> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>>>>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>> ---
>>>>>>>   fs/cifs/smb2pdu.c | 4 ++--
>>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>>>>>> index 1ecc2501c56f..3df7adc01fe5 100644
>>>>>>> --- a/fs/cifs/smb2pdu.c
>>>>>>> +++ b/fs/cifs/smb2pdu.c
>>>>>>> @@ -1162,9 +1162,9 @@ int smb3_validate_negotiate(const unsigned 
>>>>>>> int xid, struct cifs_tcon *tcon)
>>>>>>>           pneg_inbuf->Dialects[0] =
>>>>>>>               cpu_to_le16(server->vals->protocol_id);
>>>>>>>           pneg_inbuf->DialectCount = cpu_to_le16(1);
>>>>>>> -        /* structure is big enough for 3 dialects, sending only 
>>>>>>> 1 */
>>>>>>> +        /* structure is big enough for 4 dialects, sending only 
>>>>>>> 1 */
>>>>>>>           inbuflen = sizeof(*pneg_inbuf) -
>>>>>>> -                sizeof(pneg_inbuf->Dialects[0]) * 2;
>>>>>>> +                sizeof(pneg_inbuf->Dialects[0]) * 3;
>>>>>>>       }
>>>>>>>       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>>>>
>>>>>>
>>>>
>>>>
>>
> 
> 
