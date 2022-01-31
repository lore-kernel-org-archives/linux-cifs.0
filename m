Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531A2C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Jan 2022 03:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357395AbiAaDSQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 22:18:16 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12983
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236781AbiAaDSQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 30 Jan 2022 22:18:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKxrn3bWNEJbVvBHsnPTQ7hiRhoIWT5TjujjaqIGme3MRBdPQVeIeK7NhRasmRkPiMoDYTFwoHf0vYtYEqqaS2iBI/JV/5laOMpDCF178i/i2L8Xo1tAGZiHFlyWCU0sb8+mH2dwR6vON5FKS8NfZ+Xg19YsOJ5jIfIwq+SXtjQQ5brpxduH7wButtqMy4SAxlSToV5RlYK+ubYO/EaR+blhMAyPKKwHzpi6hYlKIYMQ5STxO/CKMLgBQaSmiJgnW34c1Xrfu3h1bhQ5naCHPLN84gfVxEujNT5OZxj5BSUeeLGtOiHr+5O+n56ezGXHjUVPbYNhyODWaGJNf9PAJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Pr37hqNA6uStuwb98Wuqp997nRANjclizk6iHV4CfY=;
 b=EGKJ5H0KsV4+KUqaolofMUYRUWTuOKAD9IazKfyn5S1K87mDNLOmu5RwCb9L0xgJ0zHfZIFlpd5JpjNgHLM3SgcMOcPViwAtoe7QiGi2Jch02RujlM/FNzAuLAX+hMWZT9MR32LY6GiXxi4lthQFtzLjIE8FUUojK9N+f0WV0kXZedBYlsh8k7haHGF7IEbxcT7tT9V5uJnhkYlbqAyTjT+xUPKSN/1EVoDDObhEtWHGqBEFilzcSLHi4givlU4tHhpKItyAsC1FApa2tmb2zqMcLz2eF/XLiHbGh3V/IlL1L+jPlvi5MhJiIkJcRKOH2FNXfOtmL5mjbNTX6rknww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL0PR0102MB3313.prod.exchangelabs.com (2603:10b6:207:19::10) by
 BYAPR01MB4903.prod.exchangelabs.com (2603:10b6:a03:1e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Mon, 31 Jan 2022 03:18:13 +0000
Received: from BL0PR0102MB3313.prod.exchangelabs.com
 ([fe80::1d3:342f:dc83:254e]) by BL0PR0102MB3313.prod.exchangelabs.com
 ([fe80::1d3:342f:dc83:254e%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 03:18:13 +0000
Message-ID: <b22e3dd4-51d4-31d2-ac69-7cb4510860fc@talpey.com>
Date:   Sun, 30 Jan 2022 22:18:12 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/3] ksmbd: reduce smb direct max read/write size
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
References: <20220130093433.8319-1-linkinjeon@kernel.org>
 <9bd2b636-ca5a-df2c-49ab-db14b7b453f1@talpey.com>
 <CAKYAXd_kaQBYyj68-ijxnxt1VsZMj09Qovss1vuzDGdF3CsP2A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_kaQBYyj68-ijxnxt1VsZMj09Qovss1vuzDGdF3CsP2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0031.namprd02.prod.outlook.com
 (2603:10b6:208:fc::44) To BL0PR0102MB3313.prod.exchangelabs.com
 (2603:10b6:207:19::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff69b97b-8507-46fb-d6a9-08d9e4685099
X-MS-TrafficTypeDiagnostic: BYAPR01MB4903:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4903D73D7AAEE72159B0B2B1D6259@BYAPR01MB4903.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +c6bS3XXTeeSmR1q2CNd2jV93bHghokJysy+kGl1GF3OkXe5l5kDzf6UVTwagyGnzmKZOl8q9D8AGRHmRjHLrUgaXQTU8ny+awsDyQPFm1KVD6l7cO/nm5wIaW7eCcMYjHoI60gUYOd/WDHfbwqBDS3IunjqvLLbfDqBZ/NmA3PICL49IOJZGCREd09tlmVbZc2giEcSnac0KZ9S/YpJ08p8TWLHI/tucION8xfwW7pgQTZknzWh50b1Hx1IED/Tb7m6A97aFgLn1aXOonkl8mESRpayJwl8gPgNnKvjdFxFoCzn0YVLXxTPvzSMLCn8YqUowmL5rITm0LGRAjdmpAeYB1wRNa/6CzHtUecZJ31OZ2sDDYo+FJl8NSHdJ9skXxacJPdXDjE7QsYQA+zHr9yyePrI69nNAaCt5D10vrTrsr6ff18kq/rbw+ggiS77WqVVaEgqHyfT6tZdCmFNAIisydMTG2ffnnxNItZfLhUnZ+IMIOBP/41c4f/0ErzEoK5Z783l/rok9omixPW1jN13PW338Z/N98pxDT1jZEpQtKoH4YwNYHnKi5jqghVMpKyRvLsK1A7rN2SAbMoYgoMcodylgRmzvpEw16051KzltcLxs4Vb4ZQqR1Ofx8qznPALI+2ABoVYUotYopo+IK9llBSvzSpY/CvLfhqXz5fvxv7sQcmA2cjIuEoyFl5q5Jue3vE+TeO6zUVinQfJkRExMCFls8ngZgAod6f1Zmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR0102MB3313.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(366004)(39830400003)(396003)(346002)(316002)(4326008)(86362001)(83380400001)(31696002)(508600001)(38100700002)(38350700002)(36756003)(6916009)(31686004)(66946007)(8676002)(8936002)(66556008)(66476007)(6486002)(6512007)(5660300002)(6506007)(53546011)(52116002)(2616005)(2906002)(186003)(26005)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QytrNmtnVk5sdUl2NHB0cXVHSlR6ck5DUW9kYkZFUk9VVHVDOXkvSVVGNlNi?=
 =?utf-8?B?UXRlQ2Q3eEQ0Rm9idjI2NVVsSE1FVnA5MVRUVDFkenp4Tnd6a0V5M2lGQXZ5?=
 =?utf-8?B?R052ZUdIRUZkbHdIYUlZZjluVDJDR21JSDNmVXQ1VVJUUFNrbmwwSUZYRHpS?=
 =?utf-8?B?QlhTWVRqaG9PbGZjbThPNVY2NkgvVjdIOGJBSEViOHRESU56Y3UvekdkN3p3?=
 =?utf-8?B?WS9aYTlZd3VSRzNXOWxsdm95RlVGRlhmNTZEQWYvT2ZYVm5URmtGaXNCaTlP?=
 =?utf-8?B?TjJXSEtSOUtmbGVSdnpBbExMS1hyUFZ2VDQwVVVyOWlTaEd6VGE5RlkyUlEv?=
 =?utf-8?B?aU1jWTZrVnVXTHBSdVMrN1p2WUkxTnpKOWh2VVRUWEt1MWx2TW1tWjRzU25r?=
 =?utf-8?B?ZUpCckhnUWxQb3IwLzl2OVpzOVhaMENPc3hYeS90UWRTVHNSdTFPNzZVN1JR?=
 =?utf-8?B?Z1NrdW82SVhxK0IvTGcyMW5xU05GNkV5L3VsSVQ0Ky9XU0o5MHZ5a2c2TTFC?=
 =?utf-8?B?V1REVTRBUDU5VUFIc2pzVTNxYmJ1dElJc2tWMmQ5bk53amExTTdVbkNEcDVW?=
 =?utf-8?B?M0Q1ejBqZVVYSlQ5MUNSVVpjU2hWM1JMOVRlU3ZBTVk4OUVxb3RQVGxYZlhw?=
 =?utf-8?B?VWo2RGVnVmJQdGQxUy8xTllSVkNTcGdyb3ZSWUVzVjFIdDNqODB6MlY1TmlL?=
 =?utf-8?B?blI0RUQ5K2xHOE50OERobTg0aFAxNG1sUTlKc0U5T0g1OTk4SkNqTDFsVWF1?=
 =?utf-8?B?OGN2N0FDVlFMSnNKUTNnU3lVWVQzWjlNV3RDN2tNZlFwRkZDUU1WczNCZjBW?=
 =?utf-8?B?N3drNlBhVCtBWU9wN1N3Qm8xa1pMVnIwbjQvQzFmKzFKSXI4aFVoa0xGVXQ1?=
 =?utf-8?B?T2FrRUdEYnc2ZDlNU2kySkd2UTFyeWFjVENBZXdYaklXeXJna2NHZm9BeExH?=
 =?utf-8?B?RTBXWklDY0k1NzUxNTFub3o3eTRBMUtnYTF2dU1wNVhQaXpEVW54TzdwSlQx?=
 =?utf-8?B?UU5VZ2RXb0RGblZjZWN4NXFHUVg0b3NOYlVEWW45bUFWS29VZlZHeEl4UGNH?=
 =?utf-8?B?NW1jdHpZNTlIeTlrUEcvUzl2RG1YSjYvZENSdFNnNTFaRlVPK1ZPRmxDQzRL?=
 =?utf-8?B?dThiaG5iSm1sZzZCK3c2b01VenlYL0FQRGFXLzZZTXVjeFg0d3NraEp5WkFz?=
 =?utf-8?B?TVdlS25Fenk1eDB5REJKbStFb2ZkK0J3YWgxUE1UUmMyMndjSVhMMkx1R1RP?=
 =?utf-8?B?NzUxSHZiRUhPZXhRL2NHSUFaRGZTWFc1eTBGSTJ4Y1JRY0dxdWMzS3dZSnRo?=
 =?utf-8?B?MjlGeUVtL3doT3VVdGgreE80ZnQ4VmpPcDg4RitDTlk1cWxLbTYyRFdUY1Vs?=
 =?utf-8?B?UGpQTnhzWXo4emxVOHRJdjZTVkRIVFRscTF1WjFqc3l0TWg1em1tUTJMa0ty?=
 =?utf-8?B?ZFRkNHVEckR0S0dudTZxa0ZWaThkR25TRnM1NHRnNEErZEVXUVpXRysvb0Nz?=
 =?utf-8?B?dE5jUzJ6U0p5VDRmei8xS0Uva0w0SjhubkJBUlEwTFJPeEI3Nk5IeGIwSXlP?=
 =?utf-8?B?dnBzamtRVmhMb3E5anZSWStlbnVkT0ZXTHhkSDZTOE03UHJqSnFDN000cmR2?=
 =?utf-8?B?MTNiWHU1c3lYVHBteVQzbFVVR2lVNWVicEpkM0o3N2tnOXZHUllFSTlzQ253?=
 =?utf-8?B?QmpUT0xEbDI3NXhML2hiUHFZVld4MERFRzI3YndKUW4yMytZSzJGbWRXbXVF?=
 =?utf-8?B?OVJ6dUw0U0FZcXBBWHJLaTI0V0hZTlA0aHFLQmhhU2c1M2IwZVFPSEV0OXRq?=
 =?utf-8?B?bHU4SGJSYXlsNkM1VXh0Qy9udzE3THpwRXg2YTI5a3lkTDA2YXM3bHhKaXhl?=
 =?utf-8?B?aHgwb3J1ZjFGTHRwTWlMYy9kTEdVRzd1SUhCN2kzcmQrMTk5RnY2SjBGTGh1?=
 =?utf-8?B?Sy93SWl3aHQ4c3loNVMwUHBQMWRHMVkrWE1FeWV1NzQ2S3hXRDlyYk9wYmVK?=
 =?utf-8?B?ZUQrenJBdXRiZEd3ZU96ZjZubEhUS3BMZUQvNHFMYUI0UXRxekRGMjducGdL?=
 =?utf-8?B?VVJVYXl3VG1aRGlBWmlGVkVVcjBDTEY4WW9FNUFkU3lUNkVHbFhUdDJiWnBS?=
 =?utf-8?Q?/YX8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff69b97b-8507-46fb-d6a9-08d9e4685099
X-MS-Exchange-CrossTenant-AuthSource: BL0PR0102MB3313.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 03:18:13.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQA2NbyIuEOoBpLa8GJQZb0l2eqoEgCy6bxt3dlDcPjtQa/oF1DpGHH5WyJ9Cb6F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4903
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/30/2022 8:07 PM, Namjae Jeon wrote:
> 2022-01-31 4:04 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 1/30/2022 4:34 AM, Namjae Jeon wrote:
>>> To support RDMA in chelsio NICs, Reduce smb direct read/write size
>>> to about 512KB. With this change, we have checked that a single buffer
>>> descriptor was sent from Windows client, and intel X722 was operated at
>>> that size.
>>
>> I am guessing that the larger payload required a fast-register of a page
>> count which was larger than the adapter supports? Can you provide more
>> detail?
> Windows client can send multiple Buffer Descriptor V1 structure
> elements to server.
> ksmbd server doesn't support it yet. So it can handle only single element.

Oh! So it's a bug in ksmbd which isn't supporting the protocol.
Presumably this will be fixed in the future, and this patch
would be reversed.

In any case, the smaller size is purely a workaround which permits
it to interoperate with the Windows client. It's not actually a fix,
and has nothing fundamentally to do with Chelsio or Intel NICs.

The patch needs to say these. How about

"ksmbd does not support more than one Buffer Descriptor V1 element in
an smbdirect protocol request. Reducing the maximum read/write size to
about 512KB allows interoperability with Windows over a wider variety
of RDMA NICs, as an interim workaround."

> We have known that Windows sends multiple elements according to the
> size of smb direct max read/write size. For Melanox adapters, 1MB
> size, and Chelsea O, 512KB seems to be the threshold. I thought that
> windows would send a single buffer descriptor element when setting the
> adapter's max_fast_reg_page_list_len value to read/write size, but it
> was not.
> chelsio's max_fast_reg_page_list_len: 128
> mellanox's max_fast_reg_page_list_len: 511
> I don't know exactly what factor Windows client uses to send multiple
> elements. Even in MS-SMB2, It is not described. So I am trying to set
> the minimum read/write size until multiple elements handling is
> supported.

The protocol documents are about the protocol, and they intentionally
avoid specifying the behavior of each implementation. You could ask
the dochelp folks, but you may not get a clear answer, because as
you can see, "it depends" :)

In practice, a client will probably try to pack as many pages into
a single registration (memory handle) as possible. This will depend
on the memory layout, the adapter capabilities, and the way the
client was actually coded (fast-register has very different requirements
from other memreg models). I take it the Linux smbdirect client does
not trigger this issue?

Is there some reason you can't currently support multiple descriptors?
Or is it simply deferred for now?

Tom.

>> Also, what exactly does "single buffer descriptor from Windows client"
>> mean, and why is it relevant?
> Windows can send an array of one or more Buffer Descriptor V1
> structures, i.e. multiple elements. Currently, ksmbd can handle only
> one Buffer Descriptor V1 structure element.
> 
> If there's anything I've missed, please let me know.
>>
>> Confused,
>> Tom.
> Thanks!
>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/ksmbd/transport_rdma.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>> index 3c1ec1ac0b27..ba5a22bc2e6d 100644
>>> --- a/fs/ksmbd/transport_rdma.c
>>> +++ b/fs/ksmbd/transport_rdma.c
>>> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 *
>>> 1024;
>>>    /*  The maximum single-message size which can be received */
>>>    static int smb_direct_max_receive_size = 8192;
>>>
>>> -static int smb_direct_max_read_write_size = 1048512;
>>> +static int smb_direct_max_read_write_size = 524224;
>>>
>>>    static int smb_direct_max_outstanding_rw_ops = 8;
>>>
>>
> 
