Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45FFC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiCUMHY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbiCUMHX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:07:23 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9D971A0A
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:05:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYD267d7dIv47aPDDkzfXKSsEFIE9lgLh5jsKK2Y/IYho6AYtZJgHcHpxz8c2e7/jTwNIXUvtVpt6YbK4PyrJXgf+oRW0FgMkiYLz+5hMVC8k5tqzKqpV5nNIpy3zYIOjMY0NHaoK3arVPPvHOEXksMx57h0wV2I2cHvI9DRYLvDzereEmKpjfkpSgtdGYYI6UH+J1DjG7nEGceGc81tykdu546wAVZUKsnwFveBEs8CBvP7Y2xkS6hquU2TmvUGKrB9nKIW3UxjSMbCJ0YuAHvCdXXsC+30vmDKsM9OVMiWYN1fDM4sWBvw1WM7zmVLxFY7Xgl+83vaIQHaIcCnFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmMnS5BoUPN+75+1HnX2130pKzpi2xc8CVFf48E9b6I=;
 b=LpqFFVV+0H1j5HGuBWVXk/cmbUlT484azMRGQmSJi8u4HLy6yvmdYuITTmAYYNvDwfvAzZxyQa6U1LDkpc3qv4pc1oBm4Z+vHTwq9bHi3k80Q43F/aAcrmM3Z0nIidT//d+KQ4ofo7XuDZH7nlBdBmAsUEW5YB1EUOiDCt6tZYrdZAntG5t48czvqQKe/xzxvde+lfn4sD7LMyXDfKJZHBe0gZS/sLRHSl+1VHFkTMRMeVlXAtipRtA7AQhQJYK+n4V9cOwIX3EqPCX39RasJiR3Sqi//ZO/Xy68VZixjcahQiuOMFSgcasWR8aw3NfUdfu9m+apTBN19D59pDyxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB2287.prod.exchangelabs.com (2603:10b6:300:27::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 12:05:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 12:05:56 +0000
Message-ID: <df0c672a-f19c-ba2c-141b-ef9f386015a9@talpey.com>
Date:   Mon, 21 Mar 2022 08:05:54 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com>
 <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
 <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
 <CAN05THQTnerXYrN8bCuXU2zf3pQjRiC+TVpBW+u4F5n2U+-M2A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAN05THQTnerXYrN8bCuXU2zf3pQjRiC+TVpBW+u4F5n2U+-M2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0057.namprd03.prod.outlook.com
 (2603:10b6:208:32d::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e5e603f-5e21-4af4-ef19-08da0b33276e
X-MS-TrafficTypeDiagnostic: MWHPR01MB2287:EE_
X-Microsoft-Antispam-PRVS: <MWHPR01MB2287AA670E4386317A7BF3FAD6169@MWHPR01MB2287.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5M2Jpt7aC2EBeaqxvuaCj8N8dCS0+MDaR9V5a8YEYPwsH7Q7NWrON/HVYT9V+Vk4buBxX2zAB/RijNuiJw9XlfffK5XSUhYi2wYSCPW760yzRIlL7yqizt1uWsdXnLdaa4RqHKA7pyUIfBXtpRgRMKOR/3assUGNSsu5/cl5HXiHAOo45dAULf1mkes0CbxYYsh11VpICjIF3tsWHLS3yfnX5hc7W6u3fiibC8pbHO1HbEPBLz4xTYmVHu+0qDPa8qtNSlblAbET/1fSYJZLGziZ5tFXD9myQdIfUbTTYdSDB1VuajNP9NhbHNvV3tECwlS4Es0c7TLlh2/VECBkT4GYRhtBKVVBAYaAjFkeD0TJoQTRPDindZk/UeIydfHvqsLHAUxBdvmsp5uhBfs5vL5bAni6OjrS0GehOg5/7MY8QTiOVCJBcgmWlaEkF0EZGsWy2YreFPG+LP2Q/Qn8nlLM+GF8l3Sw0e5D+dbSUeA2gW4sfvHrK9swdCXQKH09XmJw2XFpDV1R/wFtt2fSikMturcaXiuwJHGSfjmEq6NEfZqQPXPKq7g0VCidBqv+T6MDHHp0ouq5LApPXYJMbx3CxMofgZzk/JwVOao5nAuXCitHFuF6Z3ju0crPTWpchb2SRhRv5DaVqDkpp0zacBehKcax6z4n1/d9pUhziAYM94eRB3FpVyD4+0ad+pP4HqUPUbFGCgOBiv00P9jL6R9SfvcbHk896JS2e47UpeOrnOAkXbjo9lGzlkVTW3wGbNleAWzfuhio+Ml3eD1ONpG5/Vb5TYFDcYwvmin+9AvOmGAAvfJiTh7rM9C4rCA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(396003)(376002)(39830400003)(966005)(6486002)(508600001)(2906002)(31696002)(83380400001)(66556008)(66946007)(66476007)(4326008)(8676002)(110136005)(316002)(54906003)(86362001)(5660300002)(38350700002)(38100700002)(8936002)(36756003)(186003)(26005)(6506007)(31686004)(6512007)(2616005)(52116002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlNqQVh6Y0lIZk40MU9nVkFIbnNRTnZvSVBmNnN5VGYwdHZQSWlYZmNLQzN3?=
 =?utf-8?B?dmM2RE11aXJ4VStCOTVJQUtSSzdHQjZZNmY2OWhyNlBYYVRHYVpEK2FjQ2Zp?=
 =?utf-8?B?ck9UYXFGaENSMm92RUNRaXRxQWxiTTdjLy91QTh6Q2kzSlp4Q2hIbkt2RTYr?=
 =?utf-8?B?MmVVSEF5bEF5OFdvRVdzVTJFNlJrV3dZSVZVKzRxN1RWdVdtVTJqK3doVzhG?=
 =?utf-8?B?dExBUUJ6cFY2MmFtUnRaRGhCUWlCc2QxcHBhWDNFSzJ5YzNIdUczOU5EeVlQ?=
 =?utf-8?B?cndiNTZEQWxYMEduS2JNL3lCcmxCOUdtTzFpOW1ORGZ4ZkV5K3RzNEhncjZo?=
 =?utf-8?B?bXA4Tm50ZDV1YmpLRHhhc3F0MHowQ3lkN1d2OWJaZ0pobFlWM0VVT25sTUpQ?=
 =?utf-8?B?YlhxemVzSUY2Uk1QUVZGenZkMHhXUGdhaVc1bGxWMkwrY24ycWR4TklpQU9P?=
 =?utf-8?B?bEFDNVJUangzUXNzS3cra2JrOGxTUXJOL3RmN0p5UVBDR3Zrc0N6M1ZDOWw2?=
 =?utf-8?B?V1JGU3hKY0RBSWptejN2dlVVZHdCQVpNRWdrQ0Z6TGNvby94SHRhd0t0eGlQ?=
 =?utf-8?B?QWRTWGtxMEpSRjRmcUNYdmorR2RYa2pidzJPMkRTVVY3dk5qd1o0a3RuZHA4?=
 =?utf-8?B?VE5RL1l0WUU0U1NodXBzb25EWkY3Q1VteHA4MTZFLzlvMEViallZMldFQ1N1?=
 =?utf-8?B?T1lYWi9TYTlzK295dlZ0bVVJODZyT0ZJZTc2b3lPcWhDd1lnZVc1QmUvWTFP?=
 =?utf-8?B?RE4xREtRUi96ZVRnOXMySTkxUFUrVWN2cldpVDgzRDVvNTJVSHp5c3ZCSWdK?=
 =?utf-8?B?UGVMVE4zOFZPQ2kvcWlmbzMvZHJJaEt1c212b0xBM1pVdm41V3JNZml0Zi9U?=
 =?utf-8?B?OXJPYzRqODk5UkJka0hYY21hUWNWYUVyaHErdUM3OVBhZEpxT05NTTZkNkdY?=
 =?utf-8?B?b3NCSDQyeDdtd2FsN1U3Q2pSZHdBK0hZdERHdkM2V016YkJPUDdXV05tVGZU?=
 =?utf-8?B?Vm9lQ3JHbXZqcEo1bm1qeEpmcHZjN1YzMndOd3ZjSWpiOXZuQ2hLalNNc2xR?=
 =?utf-8?B?Uit5NEZIUHNBVWs2WGc3R1JraU5vcWhaVW9LNThvRWFvclhWSEV2dEJpVWNq?=
 =?utf-8?B?WkF1M1ZiQlRUTVE3VUJvYkE0YjBpcVVIV1NyenB0VmxEUEowOG9RaFBvbEpz?=
 =?utf-8?B?K2twNGQxTHhyN2c3SHp3NDhkTEVCa1VkdjhLbiszS2xFL3crRnIzaHRrL1d5?=
 =?utf-8?B?R1liNzN6RWZ0b0VCOXB3NHVFZ0h2MG42TlMvdVBUUUZvd2lDa3hPVmZFOXBE?=
 =?utf-8?B?WG0xa1ZVSmkrR0lDWkZiWmhXY0I5MjJFRnZaRHNJK3ZtK3M2cVl1ejJrT0w2?=
 =?utf-8?B?dW4yekRON2d6VDZjZnB5dGpqRE9JajF0Z3dIM3RnN1hoZ2FzdCtqZ2pncGFp?=
 =?utf-8?B?eVY4MEd6eitFV2xRQ0paTEwzNFJRalNKbDdXVXdSdzltQm1qT2ZBczRhQUg3?=
 =?utf-8?B?UjJvODJOY3ZQSjczRzRCQy91VFJiNmVNV1ZFOW9vd0s5azJkWE91L1BhbUF1?=
 =?utf-8?B?U1h1cXJaU3U4VkplOXNRcEY3VlQzekplVnhyVWpiQ0pQNFo2amxCa3hRMVRh?=
 =?utf-8?B?b1VmR3gzb3FTcTR1Nm00NFVNRzRkWWFnMG5lTXhkUjdDSHN2M0tVemM5bUZ3?=
 =?utf-8?B?dVdFK1YyNjVkOFV2RCt5WVIzRDBHR3R4RWZGaHBreHJxdGNkMUhDWDJDMjZi?=
 =?utf-8?B?R1F3OEtYSUxCS3pVbHJPVWtyM1V1cGZGVGsxY3ZHYytyd2k1R2t5NnBtNEZH?=
 =?utf-8?B?eUttVENVWXUwTVVGQmc2eVVlelR6ZjVpV3JRNUJUdVB4Vm9ESG9vbkJmRkEx?=
 =?utf-8?B?dVJXN0diZFkvZ2k5dmVMZW1CRGFEU0NyMkhMWERQc1JHNG9jbjh5Y2JxRTQ4?=
 =?utf-8?Q?KjnyyRtvb5g=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5e603f-5e21-4af4-ef19-08da0b33276e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 12:05:56.0884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPGzDxfnrB9stHnv7i4ts/0PpbNS+iem3znuwWbPV15gsgrH0zr0QEj6IKfuLXmw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2287
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/20/2022 10:13 PM, ronnie sahlberg wrote:
> On Sun, Mar 20, 2022 at 7:24 PM Steve French <smfrench@gmail.com> wrote:
>>
>> They probably should be always 'u64' everywhere (not le64) and change
>> the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
>> using the file and converting these fields in fs/smbfs_common) rather
>> than the ones you changed
> 
> I agree, they should not be le64 as that implies there is a byteorder
> for this field, so u64 seems better.
> 
> (Technically, it should probably not even be an integer and instead be
> unsigned char[8]
> but that seems like overkill.)

So that was my original suggestion. The FID is not an integer at all.
I don't think it's overkill personally.

Tom.

>> On Sat, Mar 19, 2022 at 11:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>>
>>> Yes, I agreed. Why not simply store them as le64 and avoid the byteswapping altogether?
>>>
>>> On 19 March 2022 09:06:55 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>>
>>>> On 3/19/2022 12:23 AM, Steve French wrote:
>>>>>
>>>>> Any comments on Paulo's patch? It fixes an endian conversion problem
>>>>> that can affect file ids used on big endian archs.  I will add cc:
>>>>> stable
>>>>>
>>>>> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3
>>>>
>>>>
>>>> It seems a bad idea to be storing opaque fields in le64 integers, then
>>>> byteswapping them when they go back on the wire. Wouldn't it be better
>>>> to make them u8[8] arrays and just use memcpy/memcmp?
>>>>
>>>> Tom.
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
