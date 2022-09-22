Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC1FBC54EE9
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 19:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiIVTfp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 15:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbiIVTfm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 15:35:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2C210AB20
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 12:35:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zk4NhfpQqLdbOB3EAsWI9LRDb2B+5E0u/HPk7/mfXJpSZJ8C1vkk3ROkJFIMFOvbfL/mOzVUommS6WBn584Rch60UK9Gp0i5Ut9htuS+S4Nb2V//dYbqoM6UoddKorv+nhK2yknOvxBscbS/A0lfxQqjnxx4ElXaIVEUni5uKKbP/2ucPay7CxgJs1bCC8T9xv5dPE6r3qskd7yIIXW24mg0Itowq9YH/aOXjJ73idU/SLmFte+FAQS/LP7DOwrMmMi8OdquOvYQdA8mJHHY4voGyLYKGM7tm+FAdKGhPTgbIhm/5pSZ/PJ8WQsrJAJkcjotcugEalxu3PCgeiW1Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQgc4XCLpgy2ER0Mvzx38I2n8iXCFOV0HQYtXubRo/k=;
 b=ie9r49Zk5xmFJFlj1ghrHxdFU9aOza9p+TAPmQRBlAgntoaNuinlKzzi+FWPlkOV45qLJSe1rjxgaAzcI53iCTTIgd72aLqiapUhu0sx2SU06pM/2qpf9oVCOp4aKX4wMnOE0701RqPZTILiPk47RzJshUjakncGFZ9icuO5vjvy2C0VrjLnT+xJOEDtGL6VIgFfhJ7hfxIiTJM5fI+0HytN7G27B80T0SqrKRpYyGDkBBVM4+ntdiBccvliEJ+Z687SuoaUOTJvA7jqcIL0+uZtGOUn8d14ofcTpu0C4m7v8EeOfigaCGYVU6u3Xc6bplIl0bhYW7hgxGkG2eVT7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM8PR01MB6949.prod.exchangelabs.com (2603:10b6:8:16::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Thu, 22 Sep 2022 19:35:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 19:35:38 +0000
Message-ID: <c68dd87d-0c42-2673-6467-e1063c4fa9a3@talpey.com>
Date:   Thu, 22 Sep 2022 15:35:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Tom Talpey <tom@talpey.com>
Subject: Re: [RFC PATCH 0/6] Reduce SMBDirect RDMA SGE counts and sizes
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com
References: <cover.1663103255.git.tom@talpey.com>
 <CAH2r5muhROptfZ+fUjhCfwzoeJqNku4Nkpjv63N5WTdhpEWWoA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAH2r5muhROptfZ+fUjhCfwzoeJqNku4Nkpjv63N5WTdhpEWWoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0075.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM8PR01MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6615bc-9910-4132-2505-08da9cd1a09b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4U13NAxn8mFErqqz8DtEE+GgeKKf9VCHXEIM2Uzfl0Ye2sKaBeqbuBT5PvfjLB5w2DrXvyWTTheR7bu0vnhjqtT5pcmMQB0vkqHH6Ff1DPGrKlkjCrdwQVcvRVUul2l+w2dW9hpchdUhomTbryAlgB5sUQZC0njfktxsiqVckzT2+30emNqrzWqX4ixRaj8QX5FdbkDSrrvHyU4+DdAXhA7KmMgzwyCDMCLjzUQc9vLiGZL9oTXlAxKTXEczUhl6WrPLxSszB1/N7LHTmk2Vl4EHTj90b3xsf40owOQrNitDgPfx1PUza7W5S+B1rtEJ7Timw3WwpWANOdNgd/+zBHOfnaR9wE/d0g6jUPiTVuWbQsXioF9qHmIzomIUhC4PH3HR4FTuFqSdO9lnV4f041Wr2B+y0b0xIPfHDU8XjdMRTY1M8oEzNWrj+oODJeeNbpIPCC6/aPQ5T5b8uMdN6l+QOPM1nxpoHWGJFazEfOqXeSTLlRpDpt5RiOYy6er6iaQb0PRsIVvyRLil3SVZiShZXCJZQHMEdk2CY7RI/dvWb8xfnQ7NndGVpUSmQjy3VqiLvIVgSXkzDRRU+xzsj1xVFdT99gdwqW1cLcSc/K5ZdzwgkM7KsoQ4EDCzSwqzLUkBgJirgIz4kmxR8xkQnoaK2WhtidbWStvnvmYuT3+Vn1ErpB1Ci0xo8n5ZpEjQgEjDvDmm6EdWAYE8fm+OHPrXsDfu6WWb7RIL8oUKi6f650Fr5wiGoDe0HA/SX0sHfAksf+TyZorfC4+8gruWnt5wwCxhPD7O/fUd5SWC3O4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39830400003)(366004)(346002)(136003)(451199015)(6512007)(53546011)(36756003)(2616005)(26005)(478600001)(52116002)(41300700001)(86362001)(38100700002)(38350700002)(6506007)(31696002)(6486002)(6916009)(316002)(83380400001)(186003)(5660300002)(2906002)(66899012)(31686004)(8676002)(4326008)(66556008)(66476007)(66946007)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXR5REJmZitscGNVOHlEb1VqbEJlT2duVkFlanRPOTlxb0NwM1BQZjYyWGZ4?=
 =?utf-8?B?VUtYei8rSkM3dHA3NHpNUFZPbG9NRTcvcGJYWnRQN0RaZTl5OEI4VHlFaVJN?=
 =?utf-8?B?b2dNa25maU94b0hmNlRaOC9YMS9sM0IzQitIQkt2a05ZeDloZVdHNU9GcWZQ?=
 =?utf-8?B?VnRPMzh4NG45YXc3THNQVUNiZi82MWJJMW5MMDh6OFFTNURNUURrbUJlcU1P?=
 =?utf-8?B?WmhITVRKL1ZqMVBXUVJDcmFyNWpFQTdFdnh1S3BVdHhQaDJYWU9Td3EyUkJ5?=
 =?utf-8?B?T0VPL3U4Qk10bDFDMGl6VGQzR25Sc1V3TTNqMWsvUjV2MVF5NlhOTHovY2lk?=
 =?utf-8?B?RlhPdysxRFRXQjY1OCszanJNQTNHTmZ4eGxkRGY3ZTMxZGhJV2JLdDVLNkxY?=
 =?utf-8?B?T1JDWlBLMnVkZS9BM3pjTWxIY01hTDdOVUxBaHNoYStVcXJzV3V0bzlMZEE4?=
 =?utf-8?B?aGJNOFg4eUZwY0VhY0cwSEJTQVBCMmhnb0RXeERwa2ZERDFuODJsSzVZVTJw?=
 =?utf-8?B?dlNQQWlnY2xHZ081dHBrakhHY1ZOL2xrbkFscFBzNjJJcTFDREJDbnF3WFV5?=
 =?utf-8?B?YVI0MEZDQlZ1aThWZ3JYVTJ0SERKZW80R21KVTBTMjhEbDRScWdnQWo5N3BH?=
 =?utf-8?B?aW5lNjNvM2lvUE9mKzY5c25DTityRlVqRktBQnFBbUhBeUkycjhwVThzNXlm?=
 =?utf-8?B?V1RBQ2hPV2NOSlBwQUNLandOMlAvdnQxWGZNNzFTZys5S0VhL3RKZklrR003?=
 =?utf-8?B?SDlYU1U0UmJEMDZHekhKRHQ5NTJyQm5CbWkyY3hyTDdoUzVSdDRSc25ubW9o?=
 =?utf-8?B?Ymc5RG5iQTZhWE9JZ0NLU3FUckduQUtUZWxnRTZ5YjhCcUQwU0RYMUg2L3BO?=
 =?utf-8?B?cEdVeFVtMjgvS1YvdUVYQzgvY05HSjQvNzhtQnlzNWd5MXV4U1RnblFFVGxG?=
 =?utf-8?B?aTRZMGJScmJhV3B3MC9VcjlkYko3b29xUkpwdVhYRVc5dDh2bTl1QkZ3dmZB?=
 =?utf-8?B?Wlo5WWY2bTFPV1ZZdDQ2RGJYZmRnQytXL2hlWENwM2NaSnBDdGs0dVJHQ294?=
 =?utf-8?B?ZEE5anZ1V0pKUjVYaTFYZ1lGbnR4aXJqREloZHBLR1pGR0FOb1FFejg2Z0JS?=
 =?utf-8?B?L2FyTlNZbnl3c1YwZzdPMjVtWlB6NnNzbDEwTjduMGdTTGdMelZhbEt2WTlZ?=
 =?utf-8?B?VXFOT0cxTmJmNG5kNFczeVRQZW82NUNHbkhNcjBhRTBuS29ZVVZ0c2dOdGhH?=
 =?utf-8?B?RVVkOFRqQzhNNUNCcTRxYmh0Wmh4VUpXUFZJR0FvL2NpWG5abDI0c1Z1NTY2?=
 =?utf-8?B?blJ3Q3lWc0ZES1NoYjVoYmxyWDJPMTJZUXd2bnBvR3Vtc1VFTlQ5WlZQOHZ1?=
 =?utf-8?B?V29YTVE2eU9wZmRHWVAzTzhTSGdtSmRldm11RUNBWHpNbHBhVzhKSlRZNkVJ?=
 =?utf-8?B?YmhseUoyV0tONUMxeUtMaFdkOTFRZkJHMjVMMFlCdmdmMjZJUWNoSmc1ZjFx?=
 =?utf-8?B?M0RybHJDOForenZpaWhDbDM2R1RaREJybGIrcnF0RllMQUFJYUJLbDQ1SlZF?=
 =?utf-8?B?T3lCTDFQTUdJZS80WDNXT08rN0xMeWJnL2FjcEMrVldBc0EyZ3VreGFROEU3?=
 =?utf-8?B?K0VKaUtLVVBFRG5xOG05WXJpV2tGYUtCVkw5dG5KbGt4aUxSeGZHc2VhUlQx?=
 =?utf-8?B?SHhIWXVVVW55dHp2Z3Q1S2JiUXlDRnBJbTJ0Y1NzanUyTGRJN0pqRUUxU3U5?=
 =?utf-8?B?azJDVWZOdDNPdUd4MzdJemF1em5RSE1ONWtiTlVacFJQWE0wTkgxdVhBLzZX?=
 =?utf-8?B?NHhPV3duY3kxTldrMGc3Y3JBekVSWDVncnVTOWx2TlNLT1BxVXBKZnoyRTdD?=
 =?utf-8?B?Y3A5cTBZQkp0TWkyeTdRQWhyK1lWNlFsbVh1SkpCZjlXb1dLSGVlRG1kM3ZH?=
 =?utf-8?B?YUR5ZnlpT2N4L21yT1lhU21QNGJPcU9MTlJtKzA4em5IaUJhQXJDNi9KSjZG?=
 =?utf-8?B?U0RiV3VVMDg4UjZQa0NpWEJSUEhKN3JSTytxMkJ3Qmk2WlV2SXRINks4ZFdF?=
 =?utf-8?B?K2dTVU9Yc1NFMWNYR0l1aTA0aVhtcThsS01qQVBUbWE3YjJna2VIOFZtVmdP?=
 =?utf-8?Q?yDJcNDRN/jn9E1d7rHmwUoPTf?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6615bc-9910-4132-2505-08da9cd1a09b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 19:35:38.4216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vh8yYjY4Ye8O23CW2xqcnsfTAeFQAmX4abDMmkWQxvFZgy0MGxyYbsgIbDCxLfJ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB6949
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[ Resending to fix the missing "vger."! ]

On 9/20/2022 9:58 PM, Steve French wrote:
> are these still current?

Hi Steve, yes these are current. As you know we were going to add
siw-based RDMA testing to the buildbot during last week's IOLab,
but we didn't get the chance. And this week, I've been forced to
self-isolate and I therefore have had no chance to test further.

Here's the deal:

1) The changes are tested by me as described in the message. They
passed all my confidence checks, including artificially reducing
SGEs all the way down to 2.

2) But, I haven't seen any reviews, or anyone testing.

3) I won't be very productive until next week, assuming I feel better.
I'll be back on it as soon as I can.

4) Because neither client nor server ever worked over softiWARP before,
the patches shouldn't go to stable.

5) Because they only address RDMA operation, they won't break ordinary
users.

Your call.

Tom.


> On Tue, Sep 13, 2022 at 5:04 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
>> implementations.
>>
>> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
>> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
>> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
>> and for debug sanity, reformat client-side logging to more clearly show
>> addresses, lengths and flags in the appropriate base.
>>
>> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general,
>> and to be tested with XFStests here at SMB3 IOLab this week.
>>
>> Tom Talpey (6):
>>    Decrease the number of SMB3 smbdirect client SGEs
>>    Decrease the number of SMB3 smbdirect server SGEs
>>    Reduce client smbdirect max receive segment size
>>    Reduce server smbdirect max send/receive segment sizes
>>    Handle variable number of SGEs in client smbdirect send.
>>    Fix formatting of client smbdirect RDMA logging
>>
>>   fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>>   fs/cifs/smbdirect.h       |  14 ++-
>>   fs/ksmbd/transport_rdma.c |   6 +-
>>   3 files changed, 109 insertions(+), 138 deletions(-)
>>
>> --
>> 2.34.1
>>
> 
> 
