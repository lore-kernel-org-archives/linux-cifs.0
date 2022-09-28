Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE10C04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 14:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiI1Oxu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiI1Oxt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 10:53:49 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38A07C33F
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 07:53:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G//Kb9J7NFjek/Otm/oGr8YCEAEQueKIK/O2UJ0Kx5qXHGroMwQYUWHttvnkyhmQy7hp/jf5wVpzWIHHPAv1u94TV6MszhvVBrEw20RPu8cZnW92shbrGEnKSanwYduCZJK3RoKi1b7fWuH78XPEGKNcXFvyvPlo+08vApQSQbKm8hgNrKdc8Si5ry/I6nhAW40eGcoaoMXHd477Ljux8e9Mphu3EDYJSnF/EnmDakfp+bF/74oQ7pbD02JkUMg8dQNiWDiwCu+SuJouEfZqPbwyeYK6RPQM5HU/b5YnbbSU34oLhTWqBhUIiDOWOU7k0/LrSR65SHd7yILzBwVsHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ifORox+KYCW+FXp62FRFfn1ZH0szT3TVC/JmSnXNu4=;
 b=eOeWJnN1vNjN0+0syG3hKhk6mTvvv0bSaN1ZgR5wLjtVhocnwivnME+g8x9AmJCzkTDF3NrceIcJa5UwRbkq6Ps2hKi9VVna6iaggCFq71PnHtEVTbvIHNo78ShrDcqGRnNSo4ZkobtzS+EIaimDSgmRLQ6utOoIUGyUhv70L0aeQ+/7kd5k6O9YjmvjbApOpzM2PXWl7YSBLqO75H+2vnR3QeNT7OJJPSVFmaEKcL8nDnxurjoiauAToKvWCFxawjJNjg9X1P1/ccpgBzPePJpfPOcDjxFeVKDeaVudhmsarF54yvi+ZQyIL1MrU3NfDgPG9f83NEPnZ4cgJpy8DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5439.prod.exchangelabs.com (2603:10b6:208:113::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.18; Wed, 28 Sep 2022 14:53:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Wed, 28 Sep 2022
 14:53:43 +0000
Message-ID: <8fa8a09e-599b-df31-d500-9c8b8bc7a7cc@talpey.com>
Date:   Wed, 28 Sep 2022 10:53:42 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive segment
 sizes
Content-Language: en-US
To:     Bernard Metzler <BMT@zurich.ibm.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     "smfrench@gmail.com" <smfrench@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>
References: <cover.1663961449.git.tom@talpey.com>
 <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
 <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
 <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
 <80b2dae4-afe4-4d51-b198-09e2fdc9f10b@talpey.com>
 <SA0PR15MB39196C2A49C71FF1838B27D499559@SA0PR15MB3919.namprd15.prod.outlook.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <SA0PR15MB39196C2A49C71FF1838B27D499559@SA0PR15MB3919.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0036.prod.exchangelabs.com
 (2603:10b6:207:18::49) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5439:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d185a23-ed32-4739-73bd-08daa1613d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qR7BQbO16nLNy02Nsqy8lOQi2nd9Id8UEOJjvfPGg6tL7Sfq0ukxAcdMv+DqZGAHDRVnUNcoVzlYff8Oln5BhGaXnEShHM7aQ+4xxcZwm/WLRKMjxJRRcZT9Mwnq0GsTjmJixHdGdH7tzhZ57kNLOTmDMu/d82zh/dGU18u1G9Zx7YRvSTMsmGPZ+jpKRKghz6gQm941nSv4nBiLVYcwDYNUsThE39UqKFFyz2oVvdGZdeNaUWdQfn6sdOkyOEMHe2AHZEuei5jgU8lLhgvWAV3rpsra/qHI6W83y18euSff26f/S4l1mItm7poHSMjStRnDsFe/SMaERU38RHha8hViiCQHNbb86ofI+Ri8/rMsrNWok2svcqChS4s+57EuVVJMY4RgrRlNtPq2WH9Z62uCfpdsAOTKjJraeXujH+GGSxJAE5eDgyj6yZg+X+9dG+ZX21jiaJRWvH1/d9Ud+adchYBW+1zBf2W4Em8JliQfnUZS9N/VTe8slVPfuboq6V53KNOReUEGDXsMlneSINr0TtnlKUofbVzckI3XvA3pK0bmavZSBH2aI7Nwl7EgdzVsyUm9nDeAj8JF4YXbGY3cLLc0Fgm4MxUqKMyjauij7ikRjK9G5yqz7MxlmjmkKhgNRKLvU0dkJXYD2KWjO3do+bgmci6axSviYvyTRaSBVgnkjjues4cBZyy0QvShnt0sM28yQ0rpAyUb6Kv5D+tYdqMtG/5YeoAgSfr34SQmlwAgLULbce5cFJPrE8vI1q4A7l3iqrRfv/Wrs1aoOP5vRv6zT9h+KFQdRTG57a4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(376002)(366004)(396003)(451199015)(86362001)(31696002)(31686004)(38100700002)(38350700002)(36756003)(2906002)(186003)(2616005)(8936002)(6512007)(478600001)(26005)(52116002)(53546011)(83380400001)(6506007)(6486002)(45080400002)(110136005)(316002)(54906003)(66556008)(66476007)(66946007)(8676002)(4326008)(5660300002)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFRudjQ4QmRnZzlrMDZjUi82bSt1VFZBN2ZaZ0IycUtia3VCT253ZUxqUkp1?=
 =?utf-8?B?SVllblo1OWdLT2FGTFJkQ2tKTnJJZ21QV09rbzhFUVFBeEN6OVU0TmdNWkJO?=
 =?utf-8?B?RjlSclA2dnkxbHYxalZrelozZEliU0VKaWNUbFpIMVgzb3hTRW1OVDZ1cU9V?=
 =?utf-8?B?aUhDUGYrNENsR0F1QnU3Y2l6YTB6ZStqU1FlZlJRRFdVTFNLMWR1MkMvUzhv?=
 =?utf-8?B?enJmZWJVdjlkOG5OMG1XcDd3RHhKK1hmdEpGZThpOHpoS3p5SVo5eVhiMEJq?=
 =?utf-8?B?TDE5dEJXSWJTTnZSU0hGMGxpSHhzSHM1azVPUy9VT2VsdVB5M2YybGN2Mmd2?=
 =?utf-8?B?aFYxenZFSkttK3ZLS3lSNWtQTmRtNld1Y2lxMFBYTnFsWG4ySmpXODN2UUtq?=
 =?utf-8?B?N3pNcjdndiswTlhxMkhtRkNIRzJrZHJjdzh1Ri9iK1ptZXNLU1NkTjNXZWhZ?=
 =?utf-8?B?NTBnVVkxWXZZYUI3b1RnWUZCSDVWMFVsL2ljOExkdGs4ZEpYRS81MmF2YjBZ?=
 =?utf-8?B?dGFnQkxGVjNsYkE0YjhEYmFNbEdjajdpLzZUMVM3cGYxNGpRWlQzWGlIem5n?=
 =?utf-8?B?aWlxTTlXUDBQaFVZT2Y4RllwdHBxNzRCZVptUWw5MkFaMnhqUm5jUFh3V2NL?=
 =?utf-8?B?cE4wQ1dMU1gzYWYydnZEOXJ3cHFlcFoyMnpnL2VtMEZaTlBGL0QwbWR1RTVX?=
 =?utf-8?B?M3NEd09LQk9ON1dScitwUTh0RUpUSW4zc2orRjZTZGhRTFNZWjRKN2xQd3VJ?=
 =?utf-8?B?djltbG5hYTErNC9UL2lySVBpM3pZUFVGeVZ4MWIxa1RnVWdPUlFUNjF4RnJR?=
 =?utf-8?B?cVdmT3dLOWdnNFErS29KeFJmNkpFSjhRdGkrUVIzOFZvRW1FREQwZFhsUkZy?=
 =?utf-8?B?V3I4NDYyM0JpeW9sVlQydU5MQml3bjV2eGZXSUtQYnpxOStIYUlQQzVyU3Rj?=
 =?utf-8?B?SEswRkJZemlmSS9jQk4zZEJQLy9HbnF3SmMvbVl5azhTUnljei9Yc295SjFt?=
 =?utf-8?B?Yk1Pb0dldVJkd2k1T2EvWENKY2lXRU9QclB2QkhROXFoUlZYd3dXdzhzVTY1?=
 =?utf-8?B?RTBEMjFmRlNGeURGbVNRc3VLeUVJUkRJVmd3eFd1U0l6Y0s2WWU2NFNVOFFR?=
 =?utf-8?B?eUpyT2M1M0NWbWc3czI4SHBMb3l4aURLQmI2ZnNGaGhILytHTml0d3gvOE5v?=
 =?utf-8?B?cWxYKzFLK2tWaGJUVDNnaUxNU3ZPMVZ4dldLbm5QeTMxeGU3dWZjNTdvcWxl?=
 =?utf-8?B?Z2laV3pMTnZaOTJXenhhV3JQd2lSV0RyVXd3NnVaVWFTcW9jSnNMWWtON1F4?=
 =?utf-8?B?cXVMQkxQZU9naG0zcGhQdHl0R2puY1RrdkNpMFgwWURPQSsxcjg1MlJWbHBW?=
 =?utf-8?B?OXc4SEFzMUxrUE00M3F5TmZWN0E5OFc2aVJDcmJ1cysrY0YzNmhvZDRjWm5Q?=
 =?utf-8?B?ZW92YlRSMjhEN1EyMEJLYmJQY2tsaWxlZEUxRVpyZzY4cnA5NllnNUFHZ0tK?=
 =?utf-8?B?T0dnL1hBdzNvRUZMSnd6VmNYYlpFcHVud3lNNjlINGcrd2VvYk43bHljMCtj?=
 =?utf-8?B?TVFYZHdOd2ZsRnhTWWNsR1BOM3kzUE5jZjZKMFV1bWUwVGgvazNJS0tub2xu?=
 =?utf-8?B?SDN4cTFrM25JZ0d0dDhEeUoxWjJxcVVkMTRDWmZ4Q2k4WnJjRXYvaGZTeDdj?=
 =?utf-8?B?Vis2bmQ0azRTNlVJaVJsM2NLOFJCTndtMHI4cHRDN1VPdHA3eGlLdS9HUVBm?=
 =?utf-8?B?a05xUTl6MUJoV0FTZnFyL2J2UndmSFZMQzhzR1NPVi93dEQwMnlPMmYvdEJF?=
 =?utf-8?B?clMrL2ttakk3QUI2VXhBNUJqYkVocVZabWpKcmkrZ2dyVmtqdHVJUm5TK2Rw?=
 =?utf-8?B?NDJuZHpGbmM2WG96eHJYeko1bmdzdnlxdnp4ZGdnY1ZQeGxjemRwUEp2cFlu?=
 =?utf-8?B?RFBiUThLa3FWcWxUakdsMzRJckZIT3BMbldXMDdpUzBWQ05Ob0M4RjhyZFd4?=
 =?utf-8?B?VlNVak9XRnFXSHdvZEhXb2J4NWpnL2VScGl4WEhwYkg1TUpqODdybThvb0hu?=
 =?utf-8?B?Y1liT0pZaG1YdFFqTkZ1aFVzVkU4Y0wwNFgwVGIyTDF4eHJ6MDF1S3B6R3l2?=
 =?utf-8?Q?rQSU=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d185a23-ed32-4739-73bd-08daa1613d08
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 14:53:43.6866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCOmoru6ok6g8mA0uAwQNoqZ4du3hv/6BzYusLgiBC9eKZvZ3fr60w56BPxk2jFB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5439
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/27/2022 10:59 AM, Bernard Metzler wrote:
> 
> 
>> -----Original Message-----
>> From: Tom Talpey <tom@talpey.com>
>> Sent: Monday, 26 September 2022 19:25
>> To: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: smfrench@gmail.com; linux-cifs@vger.kernel.org;
>> senozhatsky@chromium.org; Bernard Metzler <BMT@zurich.ibm.com>;
>> longli@microsoft.com; dhowells@redhat.com
>> Subject: [EXTERNAL] Re: [PATCH v2 4/6] Reduce server smbdirect max
>> send/receive segment sizes
>>
>> On 9/25/2022 9:13 PM, Namjae Jeon wrote:
>>> 2022-09-26 0:41 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>> On 9/24/2022 11:40 PM, Namjae Jeon wrote:
>>>>> 2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>>>> Reduce ksmbd smbdirect max segment send and receive size to 1364
>>>>>> to match protocol norms. Larger buffers are unnecessary and add
>>>>>> significant memory overhead.
>>>>>>
>>>>>> Signed-off-by: Tom Talpey <tom@talpey.com>
>>>>>> ---
>>>>>>     fs/ksmbd/transport_rdma.c | 4 ++--
>>>>>>     1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>>>>> index 494b8e5af4b3..0315bca3d53b 100644
>>>>>> --- a/fs/ksmbd/transport_rdma.c
>>>>>> +++ b/fs/ksmbd/transport_rdma.c
>>>>>> @@ -62,13 +62,13 @@ static int smb_direct_receive_credit_max = 255;
>>>>>>     static int smb_direct_send_credit_target = 255;
>>>>>>
>>>>>>     /* The maximum single message size can be sent to remote peer */
>>>>>> -static int smb_direct_max_send_size = 8192;
>>>>>> +static int smb_direct_max_send_size = 1364;
>>>>>>
>>>>>>     /*  The maximum fragmented upper-layer payload receive size
>> supported
>>>>>> */
>>>>>>     static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>>>>>>
>>>>>>     /*  The maximum single-message size which can be received */
>>>>>> -static int smb_direct_max_receive_size = 8192;
>>>>>> +static int smb_direct_max_receive_size = 1364;
>>>>> Can I know what value windows server set to ?
>>>>>
>>>>> I can see the following settings for them in MS-SMBD.pdf
>>>>> Connection.MaxSendSize is set to 1364.
>>>>> Connection.MaxReceiveSize is set to 8192.
>>>>
>>>> Glad you asked, it's an interesting situation IMO.
>>>>
>>>> In MS-SMBD, the following are documented as behavior notes:
>>>>
>>>> Client-side (active connect):
>>>>     Connection.MaxSendSize is set to 1364.
>>>>     Connection.MaxReceiveSize is set to 8192.
>>>>
>>>> Server-side (passive listen):
>>>>     Connection.MaxSendSize is set to 1364.
>>>>     Connection.MaxReceiveSize is set to 8192.
>>>>
>>>> However, these are only the initial values. During SMBD
>>>> negotiation, the two sides adjust downward to the other's
>>>> maximum. Therefore, Windows connecting to Windows will use
>>>> 1364 on both sides.
>>>>
>>>> In cifs and ksmbd, the choices were messier:
>>>>
>>>> Client-side smbdirect.c:
>>>>     int smbd_max_send_size = 1364;
>>>>     int smbd_max_receive_size = 8192;
>>>>
>>>> Server-side transport_rdma.c:
>>>>     static int smb_direct_max_send_size = 8192;
>>>>     static int smb_direct_max_receive_size = 8192;
>>>>
>>>> Therefore, peers connecting to ksmbd would typically end up
>>>> negotiating 1364 for send and 8192 for receive.
>>>>
>>>> There is almost no good reason to use larger buffers. Because
>>>> RDMA is highly efficient, and the smbdirect protocol trivially
>>>> fragments longer messages, there is no significant performance
>>>> penalty.
>>>>
>>>> And, because not many SMB3 messages require 8192 bytes over
>>>> smbdirect, it's a colossal waste of virtually contiguous kernel
>>>> memory to allocate 8192 to all receives.
>>>>
>>>> By setting all four to the practical reality of 1364, it's a
>>>> consistent and efficient default, and aligns Linux smbdirect
>>>> with Windows.
>>> Thanks for your detailed explanation!  Agree to set both to 1364 by
>>> default, Is there any usage to increase it? I wonder if users need any
>>> configuration parameters to adjust them.
>>
>> In my opinion, probably not. I give some reasons why large fragments
>> aren't always helpful just above. It's the same number of packets! Just
>> a question of whether SMBDirect or Ethernet does the fragmentation, and
>> the buffer management.
>>
> 
> One simple reason for larger buffers I am aware of is running
> efficiently on software only RDMA providers like siw or rxe.
> For siw I'd guess we cut to less than half the performance with
> 1364 bytes buffers. But maybe that is no concern for the setups
> you have in mind.

I'm skeptical of "less than half" the performance, and wonder why
that might be, but...

Again, it's rather uncommon that these inline messages are ever
large. Bulk data (r/w >=4KB) is always carried by RDMA, and does
not appear at all in these datagrams, for example.

The code currently has a single system-wide default, which is not
tunable per connection and requires both sides of the connection
to do so. It's not reasonable to depend on Windows, cifs.ko and
ksmbd.ko to all somehow magically do the same thing. So the best
default is the most conservative, least wasteful setting.

Tom.


> Best,
> Bernard.
> 
>> There might conceivably be a case for *smaller*, for example on IB when
>> it's cranked down to the minimum (256B) MTU. But it will work with this
>> default.
>>
>> I'd say let's don't over-engineer it until we address the many other
>> issues in this code. Merging the two smbdirect implementations is much
>> more important than adding tweaky little knobs to both. MHO.
>>
>> Tom.
>>
>>>>>
>>>>> Why does the specification describe setting it to 8192?
>>>>>>
>>>>>>     static int smb_direct_max_read_write_size = SMBD_DEFAULT_IOSIZE;
>>>>>>
>>>>>> --
>>>>>> 2.34.1
>>>>>>
>>>>>>
>>>>>
>>>>
>>>
