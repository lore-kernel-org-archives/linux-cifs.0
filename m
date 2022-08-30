Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ADE2ECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 16:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiH3QUI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 12:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiH3QTm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 12:19:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D50CF8ED4
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 09:19:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljUEhWyktaNtywp8w+QG/rqLGRb3vHyJu1tnhic6pNdmaNDdc7KKGSrH6iTRZrG+LbI1/eriPgmJQjtM3b+LlamGnU52lEfo0ivrE/Pg0G/aJmZFMhv/anlJwqcSFwlaGdMYyCLUrAlVu6o5yiq/hp6Anp99xEiQ6j66rvEwCaSxtFwuo/ZoWD/ThxwxsJa0dckyJmOnromPr//gUHNIeKNh/KV7cGwo4864eSrn5Lt4fGTNLcEWZFYVA6PKQGwf7b+qK5Wruca/lJz11PQn6aiXVNFYCverHc8OYMN4J6K7j28dGiaLxIbjcSrtbR1z2FBwNwKuYEhNs89KEOsysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SbAVH8/dWcGywgmPssY4WcG/Bkrx4rtgZThRCPMW/I=;
 b=fxdamHCBNkhjd1m4XF9FAcSJtAlWMWyr2L6EBXMBygexnhhk9IX8+jqc0fTxjuHjYciSG6wYht51cTNhYU2pFOT9XPHetpWLCEdrK+OTK3C/YXQs1iVV8PUPeN6DO1CyQCRY8SUC8DiWIXvCmMJJNd3qdShVwKGzYOE2YSugl7DKL2IJMdpS7MmoimRTxm+GD3dNnTzD9RqDlV3ugS9AMBIUhPu/eAsQ/8ykitxvVPPEpKCNV63Jf1lQT+ZHRNV5hMTxqTBDFjNVrOsX+y5MuWkKtK8pR2qyljoRyvHNsi+75y9jaH4zDBxDZ6zd03/6SMqTMfOzC+4Ub0E2zImvFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN6PR01MB2755.prod.exchangelabs.com (2603:10b6:404:cf::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.19; Tue, 30 Aug 2022 16:19:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 16:19:35 +0000
Message-ID: <e62b79c6-762c-2d4e-cca6-181eb1520409@talpey.com>
Date:   Tue, 30 Aug 2022 12:19:34 -0400
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
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <3215c221-1c88-28f9-20f1-e492bb62cc50@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:207:3d::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3528e343-c593-4a2c-4c9e-08da8aa36e0e
X-MS-TrafficTypeDiagnostic: BN6PR01MB2755:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NS5e8dqbyIJ9AHBDe09mWfcWQWhiED43NvU8wb1Q+3IvG+wwPzarEjg3MG2lUXkXmqcBLL/epUuayipKugBBNneLPtqK/00Q32wOjJ5YfzP5pVwzy1nxE46i1NCZj0et//e7HmgiPXMmZdAYkZlep/kDGsxritkzOfGQmeI4NNnuB+ppIt4XjXWFw9AGDbMniLwgxkv6OlhadYvkElhpYsdJG4aijWgXeb6WAwxouZ6EZtulIxsASvEN24Ncs3X4WqsYt763pxNXLqifalpwU65reobQYiYdqgKbtyBpqQM9cuNCmsm2quABLSbOdfrOlPjy3TGna+/81LBA9JTBcsOU07KQ0iNwykLjFpu1zP0zbbyFBRlNubFt4XCpV7o6kl0VvwwdzE9NxYRrpxdlMemzSPiYk8Ci4hb9yW/0kJgH7V7Z4ySpQkWllTH8SyBve/J4ONQJWZwpWpPTR32M+fFqxB4qYmyxGCQ5HYpoTsVUxvvoHiq9TKlk8sQCYklIi63dgOD2gYPiokIXlTv6fFCoH7MEfTfEEuwk2xtH5ZGbErr/R1bEN49UulS23XXSVI6oAsXAE2GQ2yufnL+Y1eajwaYYppn0XdIAeD1z9zGopVo60nWxafaEDWQXn/N6oLDEw/3uEelCaOqpyxNhql+J4wrcMDZ5jsuHXJFV5SPbEEfvBUfUH7GOmRWoUnZ6wx4/MUyRx2OILNAVVF4+yke8CFZeQmUCTXpPBl13RrdmrIrsZOROEVriFIJ1HyAgwmTJL2Z7g6JE6nIxhC7MeMmH1ohM22qPXlNczlSd2cg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39830400003)(396003)(366004)(346002)(4326008)(8676002)(66476007)(316002)(38100700002)(5660300002)(38350700002)(2906002)(66556008)(66946007)(8936002)(26005)(36756003)(6506007)(86362001)(15650500001)(53546011)(52116002)(6486002)(31696002)(41300700001)(478600001)(6512007)(2616005)(186003)(83380400001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWh0Ui9PN2lqUlEySFV1Umkzbi9IOHh6MllXL3F1UHNLMUkwWjdHdGp0ekd3?=
 =?utf-8?B?V2JzLzFBbUd0UzIxdE1oZDdPTFZsWDgwYXZYVVJWQlJyNEpZVHpIMW55WnNI?=
 =?utf-8?B?cEJQWXJIVFdCU1hQdytkMXJFbEVjYXdmR0FtSVZEWjhrQjdHVWVrQTl5dFRM?=
 =?utf-8?B?RWdZeFlVSDloeDVaN0JGRzVuNnZRM1p6amc1MzlOV2RpUnJqL016MG1LSG9y?=
 =?utf-8?B?bXg2NTBkakNteVRGUWJ5YzlhRTdYQlRWc1dFVlpOcUl4R2FRNUU1TnhlVWRS?=
 =?utf-8?B?T1VpbVMrTS94dUZTd1d0bDhMdG1DcHJONG84MVkrY2hPeVN6dnIrNzZtaUJz?=
 =?utf-8?B?eFdRelBVNnp6N1RXbDlLbElYTlFsY1BmSnJHSEZGQ0c4UERteGZ1VHRLNlY3?=
 =?utf-8?B?TVBZNjJ1QWVFRlVrWGwvdzFWWVRwdTdFZUU2L05JODMwLzFGK1BaNmZzSFU3?=
 =?utf-8?B?UWZVTnluY0MramRSWFFpc2tyVkVYb2x6QjFjR0RnNUQ1TGFFR0UzNnl6YmpE?=
 =?utf-8?B?NmZJeWpTOWgvaTJKbm91YlFSNUxNaWUrY1psdVo2bG1KdW1XQzQ5T1VBck9y?=
 =?utf-8?B?K2VQOFZjejVFRkdSTTRac0tDSXF3bVZJdGN0a2ZWRGFpV2kyMHdmbWRZNE1X?=
 =?utf-8?B?K2dhWWFtMzFUWmpnWEJQWlFaZ3hVOHJld3FBcTlORnduNDFYbEFIRWdtZUhS?=
 =?utf-8?B?RUVhWkJOOUVFaHhBVi9BTnNTMkc4SWZQTHZyYWJOUWk4dTQ0cG1XWUo3cjFO?=
 =?utf-8?B?V21WZG12N3pVa1JXRWlJcnlPWk9jUDdXUWErWlFKejhxS1RnUFllanVZM1Ax?=
 =?utf-8?B?SzdOQlZXTkZ1dXUySm5aVlhERnFEK20za0pVNnpScmxOYWVrRHM2ZHdFRUh2?=
 =?utf-8?B?L0RidmpUYnA0d2dmN3lNUlhNcTR6TXRWYVN0K3dFaVhFNGxkeFdnbHVMN2gv?=
 =?utf-8?B?REVVYnR0RnJkUDJZUFFGUWd1ZUd3SmQvMHlIbDVoN3J1d3dRNkVyM2lJRnh3?=
 =?utf-8?B?MERFUXBKRlJDNHNRTCs1di94dEYvMVVkazNiMTJKQVg1YU1BSERlVVNOK3do?=
 =?utf-8?B?MXcvbWZjRGdZOGJuTlQ1c1RSeGtmcS9NdytRVUlNVjg5bm5UTlZteEVZUUt3?=
 =?utf-8?B?ZUhnakloa0NyRWNtZVNwancxbEN4Vzd3S3lsMXVGSHo4SGRZR0VPalIyTE15?=
 =?utf-8?B?RnZQcWtlNUp0cnNHWWlXTmNmRGIyektma0NLUVJUZ2kycFBjN1l5R0dUQ2pj?=
 =?utf-8?B?ZDRtUGtoMlZUL1hMd0VpQUtLODNkbVQvR3JsTCthT25yVWtBaEd1SzJ1RGp4?=
 =?utf-8?B?bnVodTFyK0pEL1JsUksvVjNoWCtETk9qRG5aemFjaWozS2krQXNoSmE3YmE5?=
 =?utf-8?B?YUphb1RrWktHeTZhak5tMGFwam94Ump3cEFOWnZxU3FhbWJYYTFVendONk43?=
 =?utf-8?B?UTFxN1pSS25nRnNFQlBxUHBhY0lwUkVyVElKMHNoWDNYZVJRZ213bHB4VWpi?=
 =?utf-8?B?R0RseHJjRnY3TXRLRFZ6aXdWbzQ1VjJ1R1ZEeHcyVGlwSTBDc0RwakcwOTN5?=
 =?utf-8?B?Um12SjIvNHZ1QmJMQWs0c0ZUQURiNnNsTkRoWWtyTE9ManB6bDl0WXVwb1dF?=
 =?utf-8?B?SFVQVnptZ2t5UStqTndHZnpnbERndVdXWktUTGo5YWFvbW9CK05KZkhITVV0?=
 =?utf-8?B?TnBwSWduWThPRG9XMzlSV0xwM0xvbzZsNGMxMFRwTE84QUtPYjA2cEtyVzNo?=
 =?utf-8?B?VS94MXNTY3Izb2FYKzJGSVZReC9ESW5TdFA4bUNTU1d5aElXNHdXQ0ZPakhp?=
 =?utf-8?B?bWRlT2RsVFJRdmlTV3NzUVg3NVVyRXlaZVBKK1l4MkYvSlBydDBXcDZqYkxG?=
 =?utf-8?B?SGtBUkJKNTdsQXUzb1l6cExkQ2I3a2pwYlN2K096YWF6U210eFZpQzl2dHBn?=
 =?utf-8?B?SlFvcTB4eTdhK1ZBLzFpMG5nczd5MVp1V2xjakw5a0UxWVNLalA1N1Z3UThp?=
 =?utf-8?B?WFNSRGxRcXR1SExZUlRRa0MxY3FmbXgrOXpDYmhqMG5kQ1l5dEVVN2xHL2lW?=
 =?utf-8?B?RURYQkw4OG9pYk4rT0RlcnV2eHdHanpFNVEwaTJhOWRVaFEyNkowUy9LMFNP?=
 =?utf-8?Q?qmzPtfv2vucLjEZPtp57tDxv/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3528e343-c593-4a2c-4c9e-08da8aa36e0e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 16:19:35.8798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+9V9eF61J4Pfa19cfC2Uq9IoJ55OLLiXqCxl4+/1v7//6aRoHUK0t54f5y2y0l3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2755
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/30/2022 10:30 AM, huaweicloud wrote:
> I think the struct validate_negotiate_info_req is an variable-length array,
> just for implement simple, defind as 4 in here.

But that's my point. The code picks "4" arbitrarily, and that
number can change - as you discovered, it already did since
it used to be "3".

smb2pdu.h:
struct validate_negotiate_info_req {
	__le32 Capabilities;
	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
	__le16 SecurityMode;
	__le16 DialectCount;
	__le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
} __packed;

I repeat my suggestion.

Alternatively, change the code to make it a variable array and
allocate it properly.

Tom.

> According MS-SMB2, there really not define the length of the package, just
> define the count of the dialects, but just send the needed data maybe more
> appropriate.
> 
> Thanks.
> 
> 在 2022/8/30 22:03, Tom Talpey 写道:
>> Wouldn't it be safer to just set the size, instead of implicitly
>> assuming that there are 4 array elements?
>>
>>    inbuflen = sizeof(*pneg_inbuf) - sizeof(pneg_inbuf.Dialects) + 
>> sizeof(pneg_inbuf.Dialects[0]);
>>
>> Or, because it obviously works to send the extra bytes even
>> though the DialectCount is just 1, just zero them out?
>>
>>    memset(pneg_inbuf.Dialects, 0, sizeof(pneg_inbuf.Dialects));
>>    pneg_inbuf.Dialects[0] = cpu_to_le16(server->vals->protocol_id);
>>
>> Tom.
>>
>> On 8/30/2022 3:06 AM, huaweicloud wrote:
>>> Hi Steve,
>>>
>>> Could you help to review this patch.
>>>
>>> Thanks,
>>> Zhang Xiaoxu
>>>
>>> 在 2022/8/24 16:57, Zhang Xiaoxu 写道:
>>>> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>> extend the dialects from 3 to 4, but forget to decrease the extended
>>>> length when specific the dialect, then the message length is larger
>>>> than expected.
>>>>
>>>> This maybe leak some info through network because not initialize the
>>>> message body.
>>>>
>>>> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
>>>> reduced from 28 bytes to 26 bytes.
>>>>
>>>> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>>>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>>   fs/cifs/smb2pdu.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>>>> index 1ecc2501c56f..3df7adc01fe5 100644
>>>> --- a/fs/cifs/smb2pdu.c
>>>> +++ b/fs/cifs/smb2pdu.c
>>>> @@ -1162,9 +1162,9 @@ int smb3_validate_negotiate(const unsigned int 
>>>> xid, struct cifs_tcon *tcon)
>>>>           pneg_inbuf->Dialects[0] =
>>>>               cpu_to_le16(server->vals->protocol_id);
>>>>           pneg_inbuf->DialectCount = cpu_to_le16(1);
>>>> -        /* structure is big enough for 3 dialects, sending only 1 */
>>>> +        /* structure is big enough for 4 dialects, sending only 1 */
>>>>           inbuflen = sizeof(*pneg_inbuf) -
>>>> -                sizeof(pneg_inbuf->Dialects[0]) * 2;
>>>> +                sizeof(pneg_inbuf->Dialects[0]) * 3;
>>>>       }
>>>>       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>>>
>>>
> 
> 
