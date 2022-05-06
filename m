Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E43C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  6 May 2022 12:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378642AbiEFMSC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 May 2022 08:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241905AbiEFMSB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 May 2022 08:18:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300C16541D
        for <linux-cifs@vger.kernel.org>; Fri,  6 May 2022 05:14:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWSOFiYREGrLvhm83DSUnPq/FS0ifY87RX7FK64uT7CTntiqe08LUkQhD3YekCvvF36wbqdrc2NhV1pCDQMjMurqKuPP6faOCwUZlauzpy//GfMfNzmV7owqpsRMgqlzr3UtvKk/VHvCRrUMSHyQTDV2UXYqRliqi3d2hpfZ/i+58wkRAouEkTCarCgAbYd7ly2euCNQ8Wmc4LrOuQ/jdas83Bs9tGpauiDG/DdvzaQcFukJ+qZCq7nWf72k7xuxHFeTr+5oCn9kVkYSvi1eNvanRc+bx1EcVgUV6KOeJeOevsrnlKwU9IdZjAZG05ttcKWRH2EKuY/rKQyt4aKaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tM/O2W1lm/2WwCerwZHR0tYNIUzMhiwR6oUge1B+Xrs=;
 b=AVtQ6MhhaNGj1iq2PMTqCa7RURNEJKhw8C32RYW/9RyOT4MnUCt8aeC351UC0Uhe5D71D14gE177lmRJyyfnPcy4Pia0Z2A+Jr1ZwYn+mgq6EAQonNuNBSIHLh8qs38po8T1jXm2CDe3fJReTs5QEPupl5aE05fYJ11bMitt9bMEKD/s0IHNimCNksFax7yYMGYj3dgS+eZmdh0YxH0dD4u0op/06Pv4KXMMNC5IK4aOXPsN6jwEBN2WcM1ETZ8F0YKn96IDX0kJ9vv2Q+M+BBW4Y+6JWs+uM1eIKoJIkhQBD0+Kto9zJRa0EVloJ0qRMomGGxhYE1MBjkBWRlhlCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BY5PR01MB5842.prod.exchangelabs.com (2603:10b6:a03:1bf::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Fri, 6 May 2022 12:14:16 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d41:91cf:552e:b16b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d41:91cf:552e:b16b%7]) with mapi id 15.20.5206.013; Fri, 6 May 2022
 12:14:16 +0000
Message-ID: <efb4251a-d203-2783-7590-afc25580e9ce@talpey.com>
Date:   Fri, 6 May 2022 08:14:14 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Improving perf for async i/o path
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <CANT5p=rgt8bcy4PrEP8r-KXFwu2msTk2pRNFSbHrpVSFrAYkaQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=rgt8bcy4PrEP8r-KXFwu2msTk2pRNFSbHrpVSFrAYkaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:208:160::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fe14c4c-20ee-40f3-6dba-08da2f59f0c4
X-MS-TrafficTypeDiagnostic: BY5PR01MB5842:EE_
X-Microsoft-Antispam-PRVS: <BY5PR01MB5842BC3DED9673735E86AE86D6C59@BY5PR01MB5842.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQAPwJaURvvmhnt+khyVsqMBBOdJDIcvFz7XrAsbiAB01UEP6DSWAh/BgCuXAcZLzY0YMw624Ek1BpNrX5PlF36StHHUEAAgz6pjoddkBWcKIuFhsnNt4cEYr2RH4SRpjQX1bCdcpMARHkXn2A1BD9CvN+BiCF8QGXbeBJ55asNJ0sDifRv0dGSruQgxd9JCbkOQfuKp75aQSUW9dXbpw4EgKRJc38xC1eaASxCVTQWH0GBPQJUFjJYgAXmDKTxx2S55wSMQ+MMCq0ovruO58nhKYid1bZvzGznA5rykoTkBllycdWp3RoZZE5gtmPDmGH0632Ja9umQnYUQBanYQEBLpKgsxdqZc/ZJ4TC9pM39vveJSz3q1Dp2S62HhFDxdg7MTa35apqragQyOdzjy8UW48F7By80R8Xr4PFWLWfCn550GLf6IMcXdchG9KwI8mKhrTJ4th9Gs9z40kcqO6fhQcm678DfDdYD+c8sr8NEFJmW30Jyp4jaVwy4DW1KKFQbfx2OEV80LWfMJVrFgPHXjuxs6Kl1ZXyWHEuhlNPbemo6wjtVyDxcO+/hXIPhsgZUQCFoLR9hqelyJF3E5unxfi2IIVVgnoThTBdRTt5HmuZpVOrfEgr5UEFg3TjiKy0r8Gp5W+M3ZXCyUSXPaIX3NSg2BRcs/Sfz21twLTdJaHcNxlgNxWYSe2JhoNZtO95lKgubl1OXaZLSFWRfQdAa93YRTokQehcdeXdP7Ok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(366004)(39830400003)(346002)(376002)(26005)(6512007)(110136005)(8936002)(66556008)(66476007)(508600001)(186003)(2616005)(66946007)(6486002)(8676002)(5660300002)(31696002)(31686004)(53546011)(6506007)(2906002)(83380400001)(52116002)(36756003)(86362001)(38100700002)(38350700002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzZUeEc0V3NyS2d0WlhORUhJdjRab3liejc5a0ZhRmpITDJBZFNZNlhUYmND?=
 =?utf-8?B?ODl4TllFV3NHL1F2WHNneU8wMTZaN3NrQnVsdTlscG5NN0hyc2tVMElSOHpN?=
 =?utf-8?B?Q25hajhaMXUrR01yRmdiMnFRMGlHLzdHYXBOeHd4STkxalFDUURvZUwvOGll?=
 =?utf-8?B?aFBmNFRwTENNcnVMRXpmeTVudTV2alJqWFZuajd4QjZYUXJ4TzFWTzluRGNn?=
 =?utf-8?B?Ni9jOFI2NFN6aGdlanFwMnd3Z1pMaWNBOWowVzBZZXNZYkRXYWovc0llVDh3?=
 =?utf-8?B?ZXZRUGhCeG4vVCtGc3VjdjJ2SkhkZ2lHc1JYODF3TlRKbElEM01oRlhmOWNm?=
 =?utf-8?B?dUZISWpFNWFtck5NQmFOeHo1dGtXajFjK2o0K2ViVVY4REJPMS9GNjRPUWhI?=
 =?utf-8?B?RDRydDBncjVDb1pSUFloU250a09pdWpZK3prYmFsaDZQNkp2cE5JSzF4OUVE?=
 =?utf-8?B?elprUkd6cDRrb0F5Y1JKc29yTWgrbCtveDViNVE0RW51dFpXNHBuQ0FqWVV1?=
 =?utf-8?B?RS9Ed3JyNnJZMGNkV251dzZuV2JYV0JtUG5PNTZHRU5RcHAxOXVyNlNBU3RU?=
 =?utf-8?B?Z3VvZ2RkdWJ4L2NRRE9BQlE1ZW82Tms5YzkyS2VRbThRd05INis5dUEvTlRF?=
 =?utf-8?B?eVBHditab1NKYndaOUJ4RkgrSkM0MzYreGRwUCtzekxLdFdkN1ZZN3VkTlNa?=
 =?utf-8?B?eExkTk1jZXFDdTVMSUIvblE5UHQ2Z1BFL3M1WHBDeFYzaGd3a29BV21WOU1J?=
 =?utf-8?B?aG1OclhWY0FYTWozRG5QdWZ4eHV2ZUFFUFFTZW5SSUZrWGdtb2FIYjQ3RVhW?=
 =?utf-8?B?NWIvb1hVVVVLYWZEa3VZZ1JmQXFYdUx5OEkxMHYwa244eitXYnYyZUthcXU1?=
 =?utf-8?B?MmMxQ3V5VzJpTm10a3pWcFF5SWpybnM0cDBXbGk0Vjdnbk84eFhXMUViM2c1?=
 =?utf-8?B?UUFFQzBmalVJaThzd0U5QWtJRmJ3U0RiSEMveGpPNCt0QlVJWjNyQ0g3Y1Ra?=
 =?utf-8?B?alQrYmJwVmRzbmJzK0tiVm1yNEQvYXE1ckdZWW1BV0FmQWp1RmcrVkFON2Y4?=
 =?utf-8?B?azhJd3hQYUV5QjBJQVhhUUdzMVZ5SzZWQ3lWd0xTd0UzbWgzRkJkaWJuUUM4?=
 =?utf-8?B?UWUycTdaR2FyUlpTZExDTkdTTGlEbTRiLy82Y1pQemZtZ1JPNEpWbXlNcTgy?=
 =?utf-8?B?eG9JcnFRd3B5aU4rTlpuV0tyczA0ZlVGOUhORnhNWmRLSXhjK256b3RqY2Vj?=
 =?utf-8?B?MVc1aWdDdURhR0cvdmhuVXZkK1Jha2lqaStxVUhjVkNFQlJ2Y3JtTHlNWWR0?=
 =?utf-8?B?bUNZSFByNSs1QTZ2eGtRWEhxSTNTTklUMExkSHdTbmN2c2haRm1UNmZOYVJH?=
 =?utf-8?B?c0tQeGxUM1lFSHRQcGg0Q0RVNmF4bmsyd0ErbU5YSHJnc0VtalZQRjFybHlk?=
 =?utf-8?B?elN2WC96c2NpOGF4SGhnUjVWaCsyWHEwU1NYTElrU0lQZ1J1RThwNklzbHZx?=
 =?utf-8?B?UkM0LzFBa2QxdXdTTk5ZQXNHK25FUURrYUdBbkcyQXVGZHo4cnVaMDVGdk1W?=
 =?utf-8?B?NUpEVkpUWi94cGtYaUFqaXBRM28rYnZ5R3BTcjd1RFQ2d29nQjZYUHlYZWJx?=
 =?utf-8?B?MC9NQ1BPcU5DMGk3czg3NHJ5ZHlaNC9xRDNWcUFuaTRXRUphQWFBWFlNd1lu?=
 =?utf-8?B?NEQ3Qld1aGR0dE14bjA0SDdkNU9nWEJFd1g0cHZXZldLQjhkTDk3SlpqSU5k?=
 =?utf-8?B?c2ViOG5TaWcvNEdmalpYUTBGMHEyUzRCU0lHSUt2bDFtTWxWSVdxSnZCYUxj?=
 =?utf-8?B?NVcvV1ZPTXdMQzI5NDkzRkUrOGJQeEtQb2hzVDdPQWJxMWhZNG5iek15WXhD?=
 =?utf-8?B?UFVYU2V4RVh3Q3NDanJoZEJMUUdwTk5kRlNYRVdCM0NvSk1NTkd1cjd0VW5M?=
 =?utf-8?B?TVFFeXFVb1RpRFZ6MVkvdUJtOW9QbUZQbEVMSjVJaWJkY1RYNFFYRHpxS1JG?=
 =?utf-8?B?eERjUk1GL1pnT2VubkVycnVySkJLaGprSzJIZmNIaFlRSktLaDQ5WGNha3lt?=
 =?utf-8?B?TUUwbkJPa25IVndVRzA1VDh1VGhoQ1lBL3ZZeUtzRDBvaUZpYkRCTWFDNzJW?=
 =?utf-8?B?UlpBU1BGT0tYM3NoKzVVd25wcVRISk1Jc0ZSOEFlNG9EOHAyNVJnSGhnMXN0?=
 =?utf-8?B?dWtnaG9iN1ZVbnQ0Q2ZMYXJYei9qWUZJL0p0bHRmY0U2cEJ2YU94a2UrOS9P?=
 =?utf-8?B?WWNiTDBiRUE3TERBZEdrdkNSbEplT3hmd2VSUnIyYmQrY2JQdDRtRU1Eb0dV?=
 =?utf-8?Q?gsRLsI65SundzvCwiF?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fe14c4c-20ee-40f3-6dba-08da2f59f0c4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 12:14:16.6064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZKeuc21tl5b3tBKKurGHKKEnHwKpbBr33rt1mZLyctebpM6pTdg5l3ldvlzHbz5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR01MB5842
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/6/2022 7:28 AM, Shyam Prasad N wrote:
> Hi,
> 
> This is a question for anyone who understands the async I/O codepath
> better than I do:
> 
> Today, we have the esize mount option, which delegates the task of
> decryption to worker threads. But the task of encryption still happens
> in the context of the i/o thread.
> 
> If the i/o process does synchronous read/write, it isn't such a big
> deal. But if it's an async i/o, there is a potentially significant
> perf gain that we can make if we can offload the heavy lifting to
> worker threads, and let the main thread move on to the next request.

How do you measure "perf gain"? Won't the extra context switching
increase the client CPU load? Generally speaking, an application
doing async i/o is already carefully managing parallelism. Are you
certain that adding more will always be a win? Will the application
performance overall actually improve?

> What do you all feel about moving the server->ops->async_writev (and
> async_readv) to a worker thread? Do you see any potential challenges
> if we go that route?

Need more data.

Tom.
