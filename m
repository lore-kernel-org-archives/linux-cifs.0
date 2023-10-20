Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD62C001DF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 01:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjJTBOP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 19 Oct 2023 21:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbjJTBON (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 19 Oct 2023 21:14:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1C4112
        for <linux-cifs@vger.kernel.org>; Thu, 19 Oct 2023 18:14:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZQqL6a4pfbZWenTxX1Tf1R7ufwezcMufhIxlVzCvepA8RevuWmRphTQDhLpc9mlNNaModRcgUQaJ4TmB7HoP496xGEF9A5LIcTPnIEeDS4Q7WHKADLEHokPFtkDmeqXV2T17Uh7/rPD6IZSQS6fzv40MrChPu/CEBTb6SYixG45U8MP54cZuBWSPbcUAgbhBBzwdqVfTlqTgV5LrAfknsjrciKDcLjTVBrnFEIShydvLx+nO/GOZEUeMp8za3DeuWK0YIZnl/c0Q6oszNe6hXyi2vBsO3zvnOye01OcBZ59AsdOlvRWwKjdVRdSIXFDJ7Y9kxyIFKTEquWJEjRIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cS23UurgNZQqCios7t4wGK8VDimRGm3TzCwywSxFKSQ=;
 b=ERKjUqFBEEGK9DUWZWjyQ5YBe5JVAF/pwxU+xUjF0ko70uSIlK4OMSzxpQJGFtUxFreCz9A/KbvQNvlQE9sA7GjvltKCKbm4mGgGX9q2EjhfJSTnD82cTcbnsm13LnH2x44IAatlRiVDApEHnqacXDvPd6rx0UIuPLPfhCUST02SSLA1xf3KCnS36AIlyOXvE4Y+FJf1V/mvOBKSSK19SITuCF7O5Ds5yBXxgX1Pc0aGgjMc1VoRVYOb0ejRstfxMfxRanPFhY5jRkzAXZlWLBrSGdC5HJ7QlLD+MdcHSBcNgdZ3fiwGkygxxtZvKtrsrz6s4xsX1PsnI7OS45oBiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH7PR01MB8000.prod.exchangelabs.com (2603:10b6:510:271::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.23; Fri, 20 Oct 2023 01:14:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::28cd:b4e1:d64b:7160%4]) with mapi id 15.20.6907.021; Fri, 20 Oct 2023
 01:14:09 +0000
Message-ID: <e54f1a07-bc68-474f-83c1-a046d2b61b12@talpey.com>
Date:   Thu, 19 Oct 2023 21:14:07 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: fix missing RDMA-capable flag for IPoIB device in
 ksmbd_rdma_capable_netdev()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        "Kangjing (Chaser) Huang" <huangkangjing@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20231015144536.9100-1-linkinjeon@kernel.org>
 <11e5bc36-677d-474d-acae-ab7e6ade9b2b@talpey.com>
 <CAPbmFQZoXXdu6StcGrQO1iAzEyFfybt=GgTeqizP-KYQp7LLgQ@mail.gmail.com>
 <CAKYAXd-baiZEY=5Z4vaX=OQiSBKfKXsn+_tJOJo1mZ3uniRSzQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-baiZEY=5Z4vaX=OQiSBKfKXsn+_tJOJo1mZ3uniRSzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:208:239::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH7PR01MB8000:EE_
X-MS-Office365-Filtering-Correlation-Id: acffd660-ae78-4e66-22a3-08dbd109dc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 997uDOP+RMf4BWLoe/bQp2rZJyg1yIZNLpZUEvo1ar1vtoPJB0IaqnCdQgtqR/yTJ4g9UD8QSNXPmyNVGlMEEyg6EXXMb0zCI+HYJwky4VaTxMxSjnfCqJi79Z0WoG4hQK4HTckeyWJmKbd6/pxpwCrWdzPDn8rPDqz7UgtWHkD3H/2wpydV+NDtl5lMkDRsJnJ78dsa6Pi1eoQonxWZpzvKWITMHmJqBB6YufrjXJJ96Y2RdIq9w10yag443mamlftPYCkttqPg81rGxUFCAqMcQWhwukzynuzs52okuLLKhoLgUAvw+b3pPfPFB6orJDnStYODCZDg5N7+jZJewT67q3DxFtJA859JCN49AuXhOLf9wrnHPOvphnTfeoGF0gMoubA3VpDhKMg6NbecOmX1PhkFsEg6G0wVO6pWAA+lNAYaUvqtXH5Q+8sgPbJ9TSBuf6ewEmhCahBe1NICaGTEBLxN77zm9GyYoB/O49Q+TkaK/qOQ/s9yYINQRfmW7AnklYDH6RcL5ce1QbkLtzPHqOORaEn332gHXiUaB4q8uXSkEBvC9JTHJLO4uPpdBVDUM0Zc5WpGxjCRSlgcia9LbeJdFil6ih4GSMAF/ljBCm0uSsQBdzYQELA1EqhS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39830400003)(346002)(396003)(376002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799009)(36756003)(31686004)(110136005)(31696002)(66476007)(38100700002)(86362001)(66556008)(83380400001)(6512007)(26005)(6506007)(2616005)(53546011)(66946007)(4001150100001)(478600001)(6486002)(5660300002)(4326008)(2906002)(8936002)(316002)(41300700001)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXZJRnFhamJtRTc3VWZRMjV3K3JqblJEMHZwdy8vWXpkNExHWmtVQ1NpdS9E?=
 =?utf-8?B?MGhiM0RhOUZDWUNnL2V5R00wQk1obEg3bjV3d3FERFFsQzlmZWd4WEVzekV1?=
 =?utf-8?B?N0czSWZ0VGw5WHhSOCtPOXpmOUlPQVNxRHE3R3J1NVhHYUVQelMzSGZRZkRL?=
 =?utf-8?B?VGc1WkFuc0t4dy9FRmgwMjJ3ZnZhYjZXS3NLRWx2UTQrUHM0bE5RcDJoTEN3?=
 =?utf-8?B?anQzOXRnWkZkLzZrVmFhWE9YMnBZVGI4OEl3a3BCRGtIcy83VG82SUYwRWxR?=
 =?utf-8?B?UHBkTlE4TFgwbW15OUxhb3RRTXdpVlJkN3RZNjJ0SExPaWlVTXJvNUlZV1N3?=
 =?utf-8?B?TmZvaUJ6aXo1WGFOQlpvdGRlYm1LOXpmUGF6YWJiV3dFVXdUc1ZyMXhjMUNE?=
 =?utf-8?B?VWV2QVY4QWZvUkZTbG1La1piejhqcm5Kd2ZlUEFuNVh0VEdMU3VUaTAyaWli?=
 =?utf-8?B?MTVCdmhkMERVR3IwQjA2Z3lWNVowNWVqTC95QTQzZVI2dk5NZkd3VThndDdV?=
 =?utf-8?B?Rm1KQzVQVjBDMm5pRVZrWDdIQVhCYzVCUFdlU3dZOGRBVWFTTjNWdWtTSEJC?=
 =?utf-8?B?YVY0US9EK24weVkwc2ovUlZFdG13Zm9haEJBV25kcmZyY3Mxd0NEdnNGZisr?=
 =?utf-8?B?SmRnZS9EL2dRN2gvMktTaEtzN3dlZkhQUHNGSnkzeC9POTBKWHVQVjlldSta?=
 =?utf-8?B?WW9HOUJwVHREU2s2SGNid0FiUGNpVlVUYkl4MWo4MDB2UE90L1hOTFpkRlU4?=
 =?utf-8?B?R0pBUEpSNDdIdzdoUm1ST01LOTRDNXV6a3dVZzZ3aGVuNE11Qm9HQXl1Ukhi?=
 =?utf-8?B?S3RaSnFRcmQ4NzBKZkQxRC9ZWnd2VkRsbldKZ1h0WE00ZmVoM213R0oxMFd2?=
 =?utf-8?B?K1N0MnRyRXVGOUxVUC9XNjFBK29MWGE2UE9SNlZzcWp0ODZzZExqR1I1UVF3?=
 =?utf-8?B?MjROQm9rZEQxNURWdXZEL05HNWVGMXNHU0toUzF3SjB1VTFaV2RlN0RPOGlG?=
 =?utf-8?B?WS9WRWpOUW5ZU2FYU1VOWEVMemVsb0xVaVdPSVE5bzBQVGo1bnJaOG53K2Jq?=
 =?utf-8?B?QklkRVR6Q2UzYzRTTGVnNy82WkFqS2tkWDBZY1htV3dHSTVXSWhDczhtN0xT?=
 =?utf-8?B?eTg2MVU0bHREOG9KZjRUN0xaank2OEdDeVBMUXRiZWJxNWUxYnptMlVCZzVI?=
 =?utf-8?B?MXA4VEJCWERlUjhjSmJtbDNzdE9odktEbGRFM0ZVYmw3LzllWTdWKzBMVGtw?=
 =?utf-8?B?TFNiekpjWGk0MW1OK3hZSUYzaGd4c3V3bFcvU1ZOSk5lN2s1R3RveUl5bEpE?=
 =?utf-8?B?UU1CUXhSOUpIOUhDeG02QTNzNWx6d21WcHJzTU11OWxta1NGdFR6T0JaSnIx?=
 =?utf-8?B?S0VoNHpsRkZFRHJuVVczT21ZNmNxbkJhYmpjQUxBRTRJTDZQZVMrNWtnei9X?=
 =?utf-8?B?aU8xaTBQM0ZHT0pXY2JLY21zdC9Uc2twRkpNVzkvTUc2NWdjaXdnOFhISmtC?=
 =?utf-8?B?RzFzem9UOXlEMkNmSXFKZkJQOStFbUNyZnExRi96Yi9pQzl5WkJHSkw4U3NM?=
 =?utf-8?B?UTNRbnB0K3Rlcm9iYS9vWDh5b25LSjcyeEhZVEpFbXczMldQUWphSVpySW9P?=
 =?utf-8?B?NGpIalk4MGNlajZ4anN2Q0MzNjJYMzJWWmg4MTBRcndlWWM1SkhxeE9ZMkdw?=
 =?utf-8?B?dlMwK2lrNk5OODcvUy9CWlUyaDdPbkhWdWdhUHpobC9vLy9oQnJoMThZaEFH?=
 =?utf-8?B?TUdzNEFHS2x4bGlBanE4VUJqZ2tMTkdWNXNuTHoxVEEwZGIwR2daNWRLTklv?=
 =?utf-8?B?TnB5a1lpUUNvYm5HUzF2eHZVM1lKNVNXL0RMRGdtSi8vaXFhdXF2aDJPZ2Za?=
 =?utf-8?B?Rk83UHZwWnBabVpIMVhwWnVBWWFQNFo1K0xYRFZhYnNvSXlyZkxrSDJrSzc2?=
 =?utf-8?B?d0tuZzUwMndWOXlyOEUraCtzUm4vSk9Pck5HdE9qOHZmcDF4RUw1b1FvVU93?=
 =?utf-8?B?VjEvSjVGTVFRdjVTM2Rrb1RhdVkzVzF6alczR3hvMERzaStRY2FrR2d4Unlj?=
 =?utf-8?B?elhkbk1sZXp4VWJ2ZS84WDhBOXBaeVZGOWFwTjBrZ0VlaWxjUENlM3FoTERq?=
 =?utf-8?Q?aKQbAFOWN6WFQMlqj7YI6vaZU?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acffd660-ae78-4e66-22a3-08dbd109dc92
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 01:14:08.9890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07O7rYKF9A51kSGS0enE2NJ7kGX0gHj/s51SWBMdWcLUSLUnuwmFvl91K3fx6gzP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB8000
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/19/2023 6:37 PM, Namjae Jeon wrote:
> 2023-10-19 15:01 GMT+09:00, Kangjing (Chaser) Huang <huangkangjing@gmail.com>:
>> Thank you for the review. Also thanks a lot to Namjae for submitting
>> this patch on my behalf.
>>
>>
>> On Tue, Oct 17, 2023 at 10:07 AM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 10/15/2023 10:45 AM, Namjae Jeon wrote:
>>>> From: Kangjing Huang <huangkangjing@gmail.com>
>>>>
>>>> Physical ib_device does not have an underlying net_device, thus its
>>>> association with IPoIB net_device cannot be retrieved via
>>>> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
>>>> ib_device port GUID from the lower 16 bytes of the hardware addresses
>>>> on
>>>> IPoIB net_device and match its underlying ib_device using ib_find_gid()
>>>>
>>>> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
>>>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/smb/server/transport_rdma.c | 39
>>>> +++++++++++++++++++++++++---------
>>>>    1 file changed, 29 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/smb/server/transport_rdma.c
>>>> b/fs/smb/server/transport_rdma.c
>>>> index 3b269e1f523a..a82131f7dd83 100644
>>>> --- a/fs/smb/server/transport_rdma.c
>>>> +++ b/fs/smb/server/transport_rdma.c
>>>> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct
>>>> ib_device *ib_dev)
>>>>        if (ib_dev->node_type != RDMA_NODE_IB_CA)
>>>>                smb_direct_port = SMB_DIRECT_PORT_IWARP;
>>>>
>>>> -     if (!ib_dev->ops.get_netdev ||
>>>> -         !rdma_frwr_is_supported(&ib_dev->attrs))
>>>> +     if (!rdma_frwr_is_supported(&ib_dev->attrs))
>>>>                return 0;
>>>>
>>>>        smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>>>> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device
>>>> *netdev)
>>>>                for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>>>>                        struct net_device *ndev;
>>>>
>>>> -                     ndev =
>>>> smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>>>> -                                                            i + 1);
>>>> -                     if (!ndev)
>>>> -                             continue;
>>>> +                     /* RoCE and iWRAP ib_dev is backed by a netdev */
>>>> +                     if (smb_dev->ib_dev->ops.get_netdev) {
>>>
>>> The "IWRAP" is a typo, but IMO the comment is misleading. This is simply
>>> looking up the target netdev, it's not limited to these two rdma types.
>>> I suggest deleting the comment.
>>>
>>
>> I agree with this point and will update this comment in version 2 of the
>> patch.
>>
>>>> +                             ndev = smb_dev->ib_dev->ops.get_netdev(
>>>> +                                     smb_dev->ib_dev, i + 1);
>>>> +                             if (!ndev)
>>>> +                                     continue;
>>>>
>>>> -                     if (ndev == netdev) {
>>>> +                             if (ndev == netdev) {
>>>> +                                     dev_put(ndev);
>>>> +                                     rdma_capable = true;
>>>> +                                     goto out;
>>>> +                             }
>>>>                                dev_put(ndev);
>>>
>>> Why not move this dev_put up above the if (ndev == netdev) test? It's
>>> needed in both cases, so it's confusing to have two copies.
>>
>> I do agree that these two puts are very confusing. However, this code
>> structure comes from the original ksmbd_rdma_capable_netdev() and
>> this patch only indents it one more level and puts it in the if test for
>> get_netdev.
>>
>> Also, while two puts look very weird, IMO putting it before the if
>> statement
>> is equally unintuitive as well since that would be testing the pointer after
>> its
>> reference is released. Although since no de-reference is happening here, it
>> might be fine. Please confirm this is good coding-style-wise and I will
>> include
>> this change in v2 of the patch.
> There is no need to update code that does not have problems.

Well, there are now at least half a dozen stanzas of
	dev_put
	rdma_capable = <T|f>
	goto out

and I don't see why these can't be simplified to

	goto out_capable|out_notcapable

It woud be a lot clearer, at least to this reviewer. And more reliable
to maintain.

>>
>>>
>>>> -                             rdma_capable = true;
>>>> -                             goto out;
>>>> +                     /* match physical ib_dev with IPoIB netdev by GUID
>>>> */
>>>
>>> Add more information to this comment, perhaps:
>>>
>>>     /* if no exact netdev match, check for matching Infiniband GUID */
>>>
>>
>> Fair point, will update this comment in v2.
>>
>>>> +                     } else if (netdev->type == ARPHRD_INFINIBAND) {
>>>> +                             struct netdev_hw_addr *ha;
>>>> +                             union ib_gid gid;
>>>> +                             u32 port_num;
>>>> +                             int ret;
>>>> +
>>>> +                             netdev_hw_addr_list_for_each(
>>>> +                                     ha, &netdev->dev_addrs) {
>>>> +                                     memcpy(&gid, ha->addr + 4,
>>>> sizeof(gid));
>>>> +                                     ret = ib_find_gid(smb_dev->ib_dev,
>>>> &gid,
>>>> +                                                       &port_num,
>>>> NULL);
>>>> +                                     if (!ret) {
>>>> +                                             rdma_capable = true;
>>>> +                                             goto out;
>>>
>>> Won't this leak the ndev? It needs a dev_put(ndev) before breaking
>>> the loop, too, right?
>>>
>>
>> This will not leak the ndev. Please look closer, this else branch matches
>> with
>> the if test on the existence of ops.get_netdev of the current ib_dev. And
>> ndev
>> is acquired only through that op. In the else branch, ndev is just not
>> acquired.
>> The original code was indented one more level here so the patch might look
>> a bit confusing, but one of the if before this block is a deleted(-) line.
> You're right.

Ok, so I repeat my comment above!

Tom.

> 
> Please send v2 patch after adding comments that Tom pointed out.
> 
> Thanks!
>>
>>>> +                                     }
>>>> +                             }
>>>>                        }
>>>> -                     dev_put(ndev);
>>>>                }
>>>>        }
>>>>    out:
>>
>>
>>
>> --
>> Kangjing "Chaser" Huang
>>
> 
