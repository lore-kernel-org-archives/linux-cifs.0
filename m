Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3068C32771
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Sep 2022 17:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiIZRwB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Sep 2022 13:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiIZRvd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Sep 2022 13:51:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6832DC2
        for <linux-cifs@vger.kernel.org>; Mon, 26 Sep 2022 10:24:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaQhearA5RpA2QEHSS0tnXIriqhNDEoX9FxjG5nFpWmBfeUSRJMdpsNwYjR1A5cixYtEJFEEiN16sPIZ5WD+/JTrp28JnbIeDG/9522gpgivPMCV1QixlXndvGeb1uka2jlf2wmSWRhUB1uI/sr8Q07txeN/PGjgCUMkzkzhAizqln6yT7etacO2ovkTVP2sExvBqcKBzpKtntIGX+zFmmK5Kc+VTA5nSFOWsloGRx3wrT/5qDx8tS8ibxNBwQl6loVaZlalE30RrX2gVwgTWzbWV2pm//1Rn9DRoXQ9f+elSj2812387l6Fgkex7ODC0udaKFJBmu+lm/1kx0mKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dPSvVsige29xZyTudv7g2Qo074QHYWAuA2QCqKZhwlQ=;
 b=A771pUzHSYfr7tKrkCp3pKtkiyb9Najg1keRoB9eKwNkRme4bLcflRrlmNV01LeyPnlC5SDPKUkUxTb8WaMRmpLM4pypqYcTybPXdBb9w9cIEoTlHHWgVHzE1OKkFYGP9ZY9fbtcaIadsudKFMNTe8UMevB/tI1xe7l4OMNd+c5aia5ayLRl9MOV2PALlWPpd0QjND6PfWTxnqn0JNGY6Tlgfjbn6NMKkvWIl0q6A7ghJByKIEAwL9Jnd69A5/Q8jqxaG2ZEpc7Ki8Nu3HhmNuv581qxHAAtSCPUqFNdwfE1msINzrPGrVnjCp46QBvzvhV+4M4tlzKZbOBwuQO+DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4870.prod.exchangelabs.com (2603:10b6:a03:8d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.25; Mon, 26 Sep 2022 17:24:50 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 17:24:50 +0000
Message-ID: <80b2dae4-afe4-4d51-b198-09e2fdc9f10b@talpey.com>
Date:   Mon, 26 Sep 2022 13:24:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment
 sizes
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
References: <cover.1663961449.git.tom@talpey.com>
 <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
 <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
 <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB4870:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c6dee41-04a6-4ee0-ca2c-08da9fe40481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMYEnmHz3QxgN4a6toLd2TC5pOZqcYunSotKvqSAMy1QHRMZ4gv5AwB4EI8fiAyr3JzgZbTwNVcVLYe4Y+jSn5JkoyjPUuYr2fY8uzyptTj1juVcad+SkyGyM6PEFql35TMnTlpWIXV9LNQHzLsYRrKO05opeEOB/uwQ3H1P3XKeFPXn97mZHevPhvLbTL7NwzXQ2m7fDRG7C05Kc4DoyoMpgwkkVX7sG8n0bA4m6uSYZWmaVyE8042Kzg72Ulp9VgGPDmDUFPY0Rsffx8Umx5vf33uSW8dXqmb+rj2GeZhwhDYkNSgp1O91o2luHcq8dZBKWKDGrNeYA0jZ1xgjMG0/3pKKktaJMQ9lEzcX4Wz/fTvmQH4310Y+mletAf2XP/+baoA1FrV1HdworVPQRDb1u5kxAMmQbmBqV2EWTqzfSdErP8UtYVzLoKNwbhdTK2zQtAZ52maMwysi6K2KMFXQRYpxKPhNEPcdr4WZsoX9FXHVbwdtoExhBIItqnVHomqXqMwPb1+NPd/0NgF6uINwdLyT254Dn/K8wwZMRpvSx/wKpbRyxOGvwZzRakAQJUJ+I1liQ0fsTdsyMN8eR5lKDP9IeYOA4XE9mxe0UXFEXgbYv/WKTJp2q6zPGMfEXT8rJF9LUmqoIP9ZrGPTCpGxjsuSv/tMv0u8aBh6COpdTFemQ0ftyz8liFoahed4CTiIwq96FcFaztUvZvsAEC8PROGFwT3PS/56guvtXdMLIGd/QNsLTcHd+heCExo6OEbzFm4cII+VPW20UoBAQMP6BT3XtmBehxvBdvhvK4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(39830400003)(136003)(346002)(451199015)(66946007)(83380400001)(8676002)(66556008)(4326008)(66476007)(478600001)(2906002)(52116002)(6506007)(36756003)(2616005)(8936002)(53546011)(6512007)(26005)(38350700002)(5660300002)(38100700002)(41300700001)(186003)(31696002)(86362001)(31686004)(6916009)(316002)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDU4azRFK3JQMFpVYlFnY2Qzd3ZrNlVmVEJaNzJqUS9aQVFUU3lZS3VzM2kr?=
 =?utf-8?B?SjRiTGRxYWZwbHByekRHSGJYeVllZ0pXT00wQ1dkazJJeFdEMWM5a0lQWXZo?=
 =?utf-8?B?ZFo3bzZkcTUyUVZNcXVWNFpoa0VwYTZwTWluYUl6WGF1K0c4MVA5VnUzUnhi?=
 =?utf-8?B?Qk15MFhNWWtiRzFRWEdVeFVhcWZkUHdsUXJtWXRvTHRCZlV4UW9BU3NlMU1P?=
 =?utf-8?B?TGhtazJLS2ExNlVkZ3l4dzkwaXhWMlFXdDdVNnozandpdHVGdysxdk1Zd1Qy?=
 =?utf-8?B?dVVJbTRReTF5MFpPTjAybkRYR3lnT3FBYnRNK2NrNHdlQktWL0RCeGZNdFB3?=
 =?utf-8?B?OCsvSnJvNkRMbWxtYlE5Qk5hV1krMkg5aE5GeVFTNUNCbXRzS1Q4ZkFsY1E3?=
 =?utf-8?B?bk84ZFlRMStZbmpPRWptVWxxaG1mTGtSZWNMY1B4QWpaVXJsc2FQbmF2WDRx?=
 =?utf-8?B?YkQ2bURickxieWk0eHZ3MlptY3BkTFA1K1U4dnRsZkw5S0xjOVlidCtKWEtW?=
 =?utf-8?B?czN1czhtS1JUOStQc0Z3c2J0WlFTVTFIQXltUTdnZm5pMGlSdDh0anRublNX?=
 =?utf-8?B?SkZFbndtamh1RmJVTFdvd1hHVVdmSnp5aE1GcEJEcDZ5NnpNUWk1aHNLNURN?=
 =?utf-8?B?NGVla3JIdkhaL29haFlhdllNdDhxWTQ1WG12ZkZOVlU0N1BjNS9penhDU1pz?=
 =?utf-8?B?VW1DWnFuNjVsWnk5NVVtMjhrT1NnMUJlNStvSG85UnpzN2FUN1J1eGl3Z0ZJ?=
 =?utf-8?B?MHZCWHI0bWhBUjZVejF6dCtTczFwOVphaU1vM2tvd0Q3OFpQZ0VXbDNzWWtB?=
 =?utf-8?B?NU5PaDZrckpUT2FJSTJMN21RUW9lamI1MUI5bitKT3hlVkM1b2x5YzlaMkJN?=
 =?utf-8?B?QzNJdzZpZW9rZzFUalloMmdKaXZIVmtaMTZJZDlaeTRURGtVUm13MEQ2YUlJ?=
 =?utf-8?B?UFp4RW5HSTdSY3M1K3FaTlhvWWxHS3ZOb1VpUzBJWGZDU0V1QWN3UzZHeExt?=
 =?utf-8?B?VEphT2N3ajQ0NnZ2TnVHTE5yS1d3dXBid2orSmVueWJ1bnV5cmN0ekxmeFlH?=
 =?utf-8?B?M1RaWjU3c0x4UnkvQWlFNW8vMHlaZVhNZ29MbXVRaG5EeWJEbytKd2ErazZW?=
 =?utf-8?B?dEQrdUVFeUhKOG5GOVkrQzEvTmxjL2NVZkwyMEFRdVdtandyNXhmajh0WkZX?=
 =?utf-8?B?SWY3QWFlelcwZDVSSEVPaGduUlJROSthUGhoU3ZCcW0wTS9nQU5TdEk0NG95?=
 =?utf-8?B?UGFQZzlYeFdtb1pPZ0VFdXBLUWJOZndyU3VYSEdWQzJ4NW4zUm5NZDd5ZkRl?=
 =?utf-8?B?ZUJDSll1TFM1MklkZnE5U0RYZUhjbFFUN1pDdDlmdkJFdGxLaWFibTdsVlVN?=
 =?utf-8?B?Q2t2dU9kN2FRdXZCdnB6TFBESnMxWVJ2UTVOSW50ZXlIVmFPbER3bW9SalJQ?=
 =?utf-8?B?cTBTMVlRKzdyY2pxYzdXN2N3aXdrOUdWbHoxR2RGZEpyVnAyU080TVV3NmdP?=
 =?utf-8?B?UUxucG9KeFNIZ01vdUZvRzlhQ3JEd0VkTUk4Rjc5YUFHUHIzckNnTWRXRVBG?=
 =?utf-8?B?RjVMUHpOMDZvMFB3ZldjdmNJM2RQWmd3VUNIWlhDV0hvelRpdEp4Zy9QWG44?=
 =?utf-8?B?WDZRRXRUZldWdHBYeU1IU0R0TGI3a09leTNkVllyenB1dlY3NlYyc0x4clo2?=
 =?utf-8?B?dllZQml2dUloTDIwejBVQ1NlR2pTNmI0TjNwajh6U0xNcTI5cDJKTmd6YnZG?=
 =?utf-8?B?bWFRcE8rNkEvMFJtWU53bTlUa1hyS1ZtMVgrNXgxandpdzdnQzRHMGNCVE1Q?=
 =?utf-8?B?Qm0wWE9RMEpvRDYvQzVTaUlERjVqdUlubElOQlo5Z1BwV0hJd1JWRCt4bmx4?=
 =?utf-8?B?YkVlMlA2MUx3Y2RIWm1Fc3lHdUIrL0R1WUwvTWR3elpQNWI2a1M3TTkrN09J?=
 =?utf-8?B?S0tWZE95SWJPVjFNdStHaEVMVlBPVEY1SUs1aFlGZUVaLzR6ZzNtR1J2RFRK?=
 =?utf-8?B?MURZSUlFcE9STndZVmtNWmtXU3FCaGN5NVNkeGlwMCtCcHRReFZIQWpNVVBv?=
 =?utf-8?B?b3ZNamV4a1daS3cxY1hhQys4WGs2aHE3ek85OXpIZVVXZ1N2ZEcvMVJHeFky?=
 =?utf-8?Q?6taNeiPp89t7s7Nhi9vWhYQ8A?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6dee41-04a6-4ee0-ca2c-08da9fe40481
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 17:24:50.4414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OapV2VAX5bxB0xWdt9r1FKwXTwvavbYjJQEQJb4yixiGt2lA7D/D46hmm6yYchSf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4870
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/25/2022 9:13 PM, Namjae Jeon wrote:
> 2022-09-26 0:41 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/24/2022 11:40 PM, Namjae Jeon wrote:
>>> 2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>> Reduce ksmbd smbdirect max segment send and receive size to 1364
>>>> to match protocol norms. Larger buffers are unnecessary and add
>>>> significant memory overhead.
>>>>
>>>> Signed-off-by: Tom Talpey <tom@talpey.com>
>>>> ---
>>>>    fs/ksmbd/transport_rdma.c | 4 ++--
>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>>> index 494b8e5af4b3..0315bca3d53b 100644
>>>> --- a/fs/ksmbd/transport_rdma.c
>>>> +++ b/fs/ksmbd/transport_rdma.c
>>>> @@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
>>>>    static int smb_direct_send_credit_target = 255;
>>>>
>>>>    /* The maximum single message size can be sent to remote peer */
>>>> -static int smb_direct_max_send_size = 8192;
>>>> +static int smb_direct_max_send_size = 1364;
>>>>
>>>>    /*  The maximum fragmented upper-layer payload receive size supported
>>>> */
>>>>    static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>>>>
>>>>    /*  The maximum single-message size which can be received */
>>>> -static int smb_direct_max_receive_size = 8192;
>>>> +static int smb_direct_max_receive_size = 1364;
>>> Can I know what value windows server set to ?
>>>
>>> I can see the following settings for them in MS-SMBD.pdf
>>> Connection.MaxSendSize is set to 1364.
>>> Connection.MaxReceiveSize is set to 8192.
>>
>> Glad you asked, it's an interesting situation IMO.
>>
>> In MS-SMBD, the following are documented as behavior notes:
>>
>> Client-side (active connect):
>>    Connection.MaxSendSize is set to 1364.
>>    Connection.MaxReceiveSize is set to 8192.
>>
>> Server-side (passive listen):
>>    Connection.MaxSendSize is set to 1364.
>>    Connection.MaxReceiveSize is set to 8192.
>>
>> However, these are only the initial values. During SMBD
>> negotiation, the two sides adjust downward to the other's
>> maximum. Therefore, Windows connecting to Windows will use
>> 1364 on both sides.
>>
>> In cifs and ksmbd, the choices were messier:
>>
>> Client-side smbdirect.c:
>>    int smbd_max_send_size = 1364;
>>    int smbd_max_receive_size = 8192;
>>
>> Server-side transport_rdma.c:
>>    static int smb_direct_max_send_size = 8192;
>>    static int smb_direct_max_receive_size = 8192;
>>
>> Therefore, peers connecting to ksmbd would typically end up
>> negotiating 1364 for send and 8192 for receive.
>>
>> There is almost no good reason to use larger buffers. Because
>> RDMA is highly efficient, and the smbdirect protocol trivially
>> fragments longer messages, there is no significant performance
>> penalty.
>>
>> And, because not many SMB3 messages require 8192 bytes over
>> smbdirect, it's a colossal waste of virtually contiguous kernel
>> memory to allocate 8192 to all receives.
>>
>> By setting all four to the practical reality of 1364, it's a
>> consistent and efficient default, and aligns Linux smbdirect
>> with Windows.
> Thanks for your detailed explanation!  Agree to set both to 1364 by
> default, Is there any usage to increase it? I wonder if users need any
> configuration parameters to adjust them.

In my opinion, probably not. I give some reasons why large fragments
aren't always helpful just above. It's the same number of packets! Just
a question of whether SMBDirect or Ethernet does the fragmentation, and
the buffer management.

There might conceivably be a case for *smaller*, for example on IB when
it's cranked down to the minimum (256B) MTU. But it will work with this
default.

I'd say let's don't over-engineer it until we address the many other
issues in this code. Merging the two smbdirect implementations is much
more important than adding tweaky little knobs to both. MHO.

Tom.

>>>
>>> Why does the specification describe setting it to 8192?
>>>>
>>>>    static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
>>>>
>>>> --
>>>> 2.34.1
>>>>
>>>>
>>>
>>
> 
