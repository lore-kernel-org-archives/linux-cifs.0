Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C302C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 18:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbiETSDI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 14:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbiETSDH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 14:03:07 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230A118C045
        for <linux-cifs@vger.kernel.org>; Fri, 20 May 2022 11:03:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiPqOw+hHEZKwIWfXWgwQVJ2KKnVZ9QJuR2YED0F7y40OAjOOP5wZhWyFgjZqYd0fPuG/dBs2KAqf1JC3Lxk2EtYBBDFxgjVmG6iYMGfJU0EFmvs/Is7yYA+SC8nI/LI4/Wm/0dY19jeogJEhLP9gI2HaTjQDnqI1B960bldg5l+Ayu6e6iUnm/5/LGy8okLDnoC/+bjox2bt1jA1EWqW2iUByMqHAETbnvw78qQ0l/GepYGYBxrp73hbftJi/2Kojx3EXLFUPiyE7nYB7A8J4nyM9GjGlyvqVeuZDuP+dXUdoYF6EqPB0Lcra3ounaKaU4WGoH0sjIZlglcgwcf1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IGPZZtqH2tCS/KQDyBFiOOdIapBhGLx4md+864Xy0u4=;
 b=AbZgjNRz96EiPNAzOf7THkI7QsDEwAOgG2+C6aoNpEEczBuxuJzNjnZn/QfKu5qj+PUvpgHl77LxUb0QSRZL4ZbIfBBGlB2/9G+250xG0pzskihzrmrFf0UH/30dPGkygtwGlPnDKawwlIZEsRtaTR/Gbcv3oDdBJVadEphqm6otf6Tu654eQGoArdLUevDc1PFAswOnfI6OWhICmHOmxUvp2Vrs096k0eklSortZy4pQyBNfTYbp6Ta6W6dZ4NVmP1kXHEWFt+zMmwl4T41TOTtRHHZk9M1J7Gx3xzx3Tn01WCcOr9ivO8x9xH1PdINsnfEB2lbrDO3Ew9ULTtOiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5016.prod.exchangelabs.com (2603:10b6:a03:77::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Fri, 20 May 2022 18:03:03 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 18:03:03 +0000
Message-ID: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
Date:   Fri, 20 May 2022 14:03:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>, Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:207:3d::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e07837b2-2e3f-494c-98ea-08da3a8afbb4
X-MS-TrafficTypeDiagnostic: BYAPR01MB5016:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB50167D276819F25B46FCD7ECD6D39@BYAPR01MB5016.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AEr48OwpcbdGs/6GMQA7RnlySoU4UEpI7vxH3r38NuzQjEBA1Eq+N2WPwfw3SpfV75wONvMTiPdAepjdxaG7RT97Y8E3Ct+/ny7rZykMwlqJjdO8C3ExxI+yy6k5X6cnKc8v4E4TNAoOdkVtLaMB3GTt2PUpuskAZh9xws8FIlV3QSSPhRjp4pyxKIHYl7nWgh1eSOp6udoIbj9GGqbmBhOvCVImAUiAXEuLKqiSSiML5IxYUFatQ2A0I/ReTcPqluNXgHhpQ82q4mJ3zZfxf7fxFbkCy4a/ju+h2M54HsfUaoCSl3JkHfBdZ0BXD/UUi3fNGQjkcXZwRhsbdJYPh9QkoVsduAhtVBKHA766sFmBYJFctlg0T6cutg5mERqeZQ8eglT3Sks2nuhRWeE6KaEDDNArwSxV+irW3Z35AIY4gRZ9mHB1ozoSOXHPpDVcKFdZfa/BowP5E/vIYtwIvrPbf8oayjh6ixA4s5hybkVNFnnI72cIZX64I55f1Hu97fB6Pt0mQVCJvRW123sBisbChrjiy1ZL1WhrjG9ui0/xv0+DFb+ME55U/SvzV7+QiV++yGOA4F1AqVY1wIrNp06/p8eUosKQ4vaMUKofkUOhR/zcZPz/QACtKqkCqOu8RsvyBFVZRUtDiGPg2GhoY+E5IgUTz69xmBG0Iofk4o48OeBQ4zrCIF8tMgIQ+ZLogM8L3UTejXQjRLpkmpBxHUVy4Kl5Dz44TGP6WCnq0U9T6rUnZyjyqilU4oZHfR9OTAvtRTxfxZu7p18BQQm8N2zOLgKIBKf4Fs/i+1WXxs5jOUmKmK+5djBrLo4xF1r1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(136003)(376002)(366004)(39830400003)(396003)(66946007)(36756003)(66556008)(4326008)(966005)(8676002)(86362001)(66476007)(54906003)(31696002)(31686004)(316002)(110136005)(8936002)(6486002)(38350700002)(5660300002)(508600001)(38100700002)(2616005)(53546011)(26005)(6512007)(186003)(6506007)(2906002)(41300700001)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlhPVi9jU09rM0RYdlBTNVkwdlcrNGlFWEN0eXZZTEVySG9jZUtiKytPeVpa?=
 =?utf-8?B?bm51WWtoNHU2UHpPcGtldkpIcWFrZEFyVlhvN3JwelNQNGt0MkFaRi9iNmlE?=
 =?utf-8?B?OEhlRDljT3VUZmZ0aGR5emcxRWF0aWFkWXNNaUtXbkh3WVlrR2lpMTNXbzVC?=
 =?utf-8?B?N2tycWdDTjlxelJWRUNocUxoZVZSYVFoZnBYUGhtZG0zdTRSc2JDcXRXYzlz?=
 =?utf-8?B?SEVNU1c3T2FwY1BiUHY0QVpZV0RUVC9rL2pCS0c2eWVqZWdjWDRGbU8va0hq?=
 =?utf-8?B?dU1EbXFTL1FwNExvSm9HSDY4c3hVbVJKSWxidW9NY3pxaDk1Z0ZpNzAzbjVu?=
 =?utf-8?B?ZVA1cmdtL0VNaVZFL2ZhRXR2Z3V1UGxZTytWbjFFcEhhRkF2Mk9ZdzRWOEpi?=
 =?utf-8?B?RmF3WDJjVk9KYjY3MlRGWldnRW4rVG1mUzhYR01KQXQrcnp2d1RSeVBQVFhU?=
 =?utf-8?B?RXNOZkdMSFV0UTRMUWEzMjFJMmh5Qjk5b0xtVkZXekRCRlJ0NnUyYjA0MGc0?=
 =?utf-8?B?Z3JNUVFsMzdTamVocE05RWNnTVgxYWNvbFpPS2U5eTFCR2NmUkk3NXFpMFc0?=
 =?utf-8?B?Um9ZeU9sUk83WnI5UUVlS0RPWEhrY0ZsVHIrTDNPajgzOGJiRWdkVHNjdWxO?=
 =?utf-8?B?aU5RYjhwbkNEZWZGTUpJeVVWNi96NDhTNDJEbTVzQ1J5b2Ztckc0Y2RJaTIz?=
 =?utf-8?B?SDgvUmlmZGtseUExMEFSY2QyMDloVmFlSVF5VFNYNGsxMG5DOFFqUUFOYjRz?=
 =?utf-8?B?TjNvTWVCOW5IcVdPYUNoSXRMQkhlb1RPUWtDRGY3NnJXelZNM0J6aGx1cmVH?=
 =?utf-8?B?bWRtcXNBeGt2TXgzRUZOdDNXa2NveVhoSTFpNFMyWGVqR1BLRE9GckVpaFZT?=
 =?utf-8?B?QzdxYXljaW8xc2grTEJIMXZTbUZvOXh4MDNJc3NZT3dFNHNQWWJQYUs3WXln?=
 =?utf-8?B?RjZLZHo3SGd0aXErcHpsWjkwOWE3azQvc2NvMVk3dUR3bTNDZ2lsRkZjRDZv?=
 =?utf-8?B?cFcybU0wenYxWUpGbGYxK3FyalNzWW1tLzc4NGRiVmhzN3k4SUFZV0lVM21T?=
 =?utf-8?B?c09QQ0Nsc3NvL3J5UDZIUmU0d3owNCt5VnVVc1F1MGNpUExxRWgraUlWa24z?=
 =?utf-8?B?UzdOUThrSWJsY0dqWEp3OEN0TjkyRjBablQ4T0J6YlByM2ZZdDBhZ2NsQzZn?=
 =?utf-8?B?Tk9XcFdXOVg4RjFWcjV1VWZhRk9vNms3R0RJWnlBTjB6aVVmektpUEJmeVNB?=
 =?utf-8?B?T2pxdmQzb1JPVUtldjlEWUJ5QjNTd3BtaFZGRllKaDVVT0NNOTJmVUxjRSth?=
 =?utf-8?B?a1RUTzRDQ0xrWEF2Qzl4bjQrTkpkR2JndFl2YUQyTUMyQWVxWGwrWWxhQkdL?=
 =?utf-8?B?ZDJ5NWdFMzI1SnpUSGtkbllKNkN1bDR1cms2TlBVbFA0eUZVa2hGY3FjVUlo?=
 =?utf-8?B?T2N5c0xOSW1vbUdBVlVyZWZnWEtEWEN5ZTZ2MklkUzhsamxTMmFaWmtoSEc4?=
 =?utf-8?B?cUY0ckpZSEd1VzhmMlFGSmpsa00xa29XRHozbjlobDJ2b0JCRGNJWkN6SjhP?=
 =?utf-8?B?RHVuNEtNSk4wdmVZeHl6bVA5UXllM3N0Q0ZWeHBDT01NTGorTVNkSVJURkJ4?=
 =?utf-8?B?elVyM2ZBQVhjTElOdjczd0lkNkJETE5HWnhvYjRnTHZVTUF0ZERIcXpaaEto?=
 =?utf-8?B?d0JLY1VGdU5ia3U4MHYweGJUQXlnZWxYTDhDYkh0cEErMGJCQk5CY3lFMm5z?=
 =?utf-8?B?M1NrQStHNkQzYmNCY3JsVmJITUdkbEhKUVY0OEZob0VBbUlSeGxTNTBQZHZR?=
 =?utf-8?B?WnRlME1xM2FpeXJpMmRnT2xHVHdISGRkaTg1OGJLbm5DeEZNVFJocUlVNzNr?=
 =?utf-8?B?UUY1V2J5S1pkT3NGa3FtaHVLZXptWVpON24xYnJKRllZRnI3MW1rdDZiQkpM?=
 =?utf-8?B?alBKWjNUazdxV01ZK1BoRE1zNVZqdnBUSWU2MmdJK3hEdERBazdlS1N4bUR6?=
 =?utf-8?B?ZStuazU5d04zeER2RG5VaG1hMTVTYzRvWlV5TmtzaU9qRDkxdFE3TUtVN2k2?=
 =?utf-8?B?U2RuaEZLSmxHT0ROeTJlbk9LWHZEdmI2Z1liaTZNT21JajlVNnc5MTdHalJF?=
 =?utf-8?B?bGpQQVMybGIvTjhmVE1kWExUTEx0SEdMOUtJT2lXcjIyaHpWSjBZbXBDaTdh?=
 =?utf-8?B?Rld1ZkVZdTdUdVJQUFZoZWlaMGVTSlVGUmRJanFqSTBHUFdiV0Z5NmpGUFdT?=
 =?utf-8?B?YU10NElDaTdDdFpCRXdHNnBjaHpwMkZKdUROeC9ib1NHM0RZZmxHUVlIV29K?=
 =?utf-8?Q?ryBhkCX2I4A28Pn49B?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07837b2-2e3f-494c-98ea-08da3a8afbb4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 18:03:03.1192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbcMdup/Y+PSesikwK8RaVDNVQQeG5wMg/ekesAF+VwisGraNb6kFod/Q4+fe7/E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5016
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SoftROCE is a bit of a hot mess in upstream right now. It's
getting a lot of attention, but it's still pretty shaky.
If you're testing, I'd STRONGLY recommend SoftiWARP.

Tom.

On 5/20/2022 2:01 AM, Hyunchul Lee wrote:
> Hello Steve,
> 
> Please refer to the page below to configure soft-ROCE:
> https://support.mellanox.com/s/article/howto-configure-soft-roce
> 
> These kernel configs have to be turned on:
> CONFIG_CIFS_SMB_DIRECT
> CONFIG_SMB_SERVER
> CONFIG_SMB_SERVER_SMBDIRECT
> 
> And you can mount cifs with SMB-direct:
> mount -t cifs -o rdma,... //<IP address of ethernet interface coupled
> with soft-ROCE>/<share> ...
> 
> 
> 2022년 5월 20일 (금) 오전 8:06, Namjae Jeon <linkinjeon@kernel.org>님이 작성:
>>
>> 2022-05-20 5:41 GMT+09:00, Steve French <smfrench@gmail.com>:
>> Hi Steve,
>>> Namjae and Hyeoncheol,
>>> Have you had any luck setting up virtual RDMA devices for testing ksmbd
>>> RDMA?
>> You seem to be asking about soft-ROCE(or soft-iWARP). Hyunchul had
>> been testing RDMA
>>   of ksmbd with it before.
>> Hyunchul, please explain how to set-up it.
>>
>> Thanks!
>>>
>>> (similar to "/usr/sbin/rdma link add siw0 type siw netdev etho" then
>>> mount with "rdma" mount option)
>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>>
> 
> 
> 
