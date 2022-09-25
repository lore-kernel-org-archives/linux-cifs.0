Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695A9C04A95
	for <linux-cifs@archiver.kernel.org>; Sun, 25 Sep 2022 15:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiIYPqk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Sep 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiIYPqj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Sep 2022 11:46:39 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A5F2BB1E
        for <linux-cifs@vger.kernel.org>; Sun, 25 Sep 2022 08:46:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c6MSthypMEbkNxNv0+k+Xbn64sOB5sE9xn89wwc+Bo6FcFaM33g6RCF2BTiZgaqG3vEyHgGdZ4RSxfFZC4gJbcabNfShUdxkFwmABO/6N6RhX1cXdv8vWOaEVUKYDKV+DhWHzQb7ale6nFMdOR8Qi/oGPGSq3FMA5ICp0hGwdZjEE/iQybo2eTsefqLS9cddFnEZZn3crjqPhWsH1au1n/XTXasA04SBTjjObMTea2mulk8H2BlOnRLJC3N+8LPGGuUpF7XRjBEMkluyaXc59zBX+UPASr3oCfbEQg/wchj85MS3yj2lMhD/N7GNTVXhYZA608Jbyxiw/tdDhydEIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvAm1+kkWkKbrfU507Fgw9lubCwOkqvkdOVkj+Mysgk=;
 b=L2r9e6mNisqFTKgOj33z5hYhca21rqgzbSU9RNYtHHJ6yAfTHBzd6XTTnTQy9O5csL/+0RV2ywcVx+K4lPNICXAh53STmZ36qoXmoqcJIhG4xpHn6tWj2tERbi08JvYoOLNYjrwlSv6j0iyg2MkB1oofF8G9cXHN9CKmIg6lzkyoQ+lFu29yjicbBu926gDH5+iyy9NDF4BlgIWsKl8NzmNJPegH9HC4eDtBIUC3J/KjADLdqsM7RdwKMr/rAuqOd0td48NeRJEKJqQtbenxkQcqlaFQwZS0pp8K5M8KGe4WLRvS5tLzlbwh7ZI2lTGvOjqdOIPC6Y6+3LVzPEGAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4098.prod.exchangelabs.com (2603:10b6:208:4e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.24; Sun, 25 Sep 2022 15:46:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Sun, 25 Sep 2022
 15:46:34 +0000
Message-ID: <4df42326-ba6c-d52e-2374-47c7efbc1b81@talpey.com>
Date:   Sun, 25 Sep 2022 11:46:33 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
References: <cover.1663961449.git.tom@talpey.com>
 <CAKYAXd-53MEeq5RwM4jeSU1VT7oNdn3xOzQSGSnPaBnA5euBJA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-53MEeq5RwM4jeSU1VT7oNdn3xOzQSGSnPaBnA5euBJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR01MB4098:EE_
X-MS-Office365-Filtering-Correlation-Id: 912b36d4-eac9-43ec-f4bb-08da9f0d1fa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DMzuwdziGdRhATlUYRMTUCzt1wVFW2PpAZ5BO2+9FzJvIvPED22U/qbmE8bhm/U75bPEroGXi75yjrIT//EsaIQ89D+dBiHxFVokQGvVU2p7vFLVJSj6kkD2zlxxQLSpWeXpV85bxGbCt0C4C2iTsIlLXmc12WoAiC+JheuoYM+DkZ3Ry7Cw4U0mqSxLDwSDVYUKFphCwB6K+sYKsPPKO2zE1keMchh22ekbyv9i7+fkCFzvI5SLizGtnyhLqaYyicz/OVK8/cTPg0Ygpyv8Fil0cLhxi/JSAM2RZotWxpuZ2R2qcVb08Rb0UmEBaIEbE/eLtfnkOKERqDkzvSjGOAtDNz/m+1AgkmeR+LLNCtPqzp9jvVFd5RpPsTRAfeYGe47Tt9eD5WNSXlR22mxteInnZs/wx8VvQ+ih7g2j1i+/R5PU6f2N6Eus7a1KBFIkpUW6yBBMsxJZ0Q0lmu+lKLpjK+9oFHkWwDfd8HMxQpjt5Jpy7Y4Z5RNh+jS2BHS/42nJPU/T6FBbjboigi7djmmAjBqn6mrg5xNaCUTtdjiJFeQoSExGEdYE+wnRmktApZlKZHV1G+i28z+6vo3L7+0nqs5f1kEtPEDeeBwX6lilAMUZGc3h3M/e8G6YsRAFTqZgqCjK7JoCLenqlSNJQxKCexqSA7K9iqlk1O3kWqJWv41j/PyBnGTJCa6PRPNwvnAU3nzKhZmwUZSI5oRHtfoZjAWAYfa8xDuyh0XAdLh6UvHT7q5HE4RIJ8hYZTJoDVZ/A7EaR//ZGvBsn1JLf4JCO6WaB2Cxs8Gtu3lpbbo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(376002)(346002)(396003)(366004)(451199015)(6512007)(316002)(31686004)(36756003)(6486002)(186003)(2616005)(31696002)(83380400001)(38350700002)(38100700002)(86362001)(478600001)(8676002)(53546011)(52116002)(26005)(6506007)(4326008)(41300700001)(6916009)(66946007)(66556008)(66476007)(5660300002)(8936002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkM1SlQzRTlnKzZRUjg3cXR2T2o5VUZkVFBjMVRsdXRJOHpMRFN1VzhmU3Fr?=
 =?utf-8?B?aTZxRVNsMzZRVmhnbE9ibzNXVW9PVFkwVlZiWmtmdHN2S0d6ck10VDJKWHVX?=
 =?utf-8?B?akdBamJpK0paOS9Pc2d0MGxkSDBEU3dYMFpaYlh2Mm1YRTBkbWNNc3RXTmVD?=
 =?utf-8?B?ZlZJWjhtWHJHNXlhMWlDL3dJcU13dWhMWUk4aWhFNnFoT0VjZlpYamNoaVNW?=
 =?utf-8?B?TTdRdzVCSzJYQkhobzU2UWV3V3p3a2g4NW41aDc2VGhFaTlvLzBNWk1IYXFW?=
 =?utf-8?B?QmlZYVBPckN2OTFtajZvbnUzM0lTelgyS0FNOUNxM0xHQ2J6TXZTWGc5TDJR?=
 =?utf-8?B?a1U1MlVNVmNOdERNVnU4TjJIM0EzdkR2VTVhYUY0RDltcnk4VGg0UTlmRVY2?=
 =?utf-8?B?RExldXZUVzI5RXBEOXBKanhkdXdrbW4yNUxIbXROQlFQWHp5ZkY3eDBuVXRN?=
 =?utf-8?B?MjFNdllLR01wMXMvWG1SN2ZYNmZvdHlXUXgvT05tKzloeXIxbTNKM2paUVNt?=
 =?utf-8?B?Zld4UGsxRmNieEd4dy9PRFJWdjJtdTB5Q2VHMmF4ZXhFbmtrQjd5U1AyeDkx?=
 =?utf-8?B?TzBjWTdqbUJibVN6dHhkSXdIY3VJaVJ2bW1SWFJraTJRWHoyQUNZS0NlSFdu?=
 =?utf-8?B?NEVLNklTcVlucGt5dDI4MzdWWDNlUitFMnMvaWVUeUNWb1h1eFFFWkR1RzUx?=
 =?utf-8?B?TGFGeFRtcU9tdXA2REY4RFBhNG41UzYvZXE3eE91RTY3WjNMV2x6eGVNbCsw?=
 =?utf-8?B?VlkrNWVhd0ZJYnhlTjhWdEJXRjJFdXJVazdKN0V0OCtNUmNPM05ETTAxUlR1?=
 =?utf-8?B?TWFVUHd4MXpQZThlK1gyREhWeWtjM0xKNXkvdmxHMnlCdmwrVkVwTURXTjNC?=
 =?utf-8?B?TzVZbmUvUzBybjJjaXF4SGhMUDVHeXJBWTRmQjVVUTZOVzNSNzlsMnBGbHFM?=
 =?utf-8?B?bWN1NmtJZU1RUUlFVDFBWHFKdFRwM2MybWNWR0JTMGlGenNpbzJMU0V6b0dQ?=
 =?utf-8?B?L1R5ajBCRDZubFVnSDdnWTNKOHRVQ3E2dzhyQWVEeDN3VEt1MTYwMFdIejdu?=
 =?utf-8?B?eXFXejZnWmdKZ2hJcEVyaThPQlNnbGFWaDd1Mm15WVJJQ1p6cWdiQmdSbWc3?=
 =?utf-8?B?YzBEbzhFSUc3Q0h3UVZ0VmRpNnBmNGdLaG4zRTFRMWRzb256bElhaTNobVIr?=
 =?utf-8?B?MWxIa002cGl4Ly92cGk5S3lrblpuMDkrN2RxK2pDWHMzdmF6Nm1aSHlEVXpQ?=
 =?utf-8?B?R3l6WVNWQVZuSFJjYmY1SzJQRDM2ZitNbWdaZm5KcVlUdkprS3ROaTJNYnJv?=
 =?utf-8?B?cmJGU0FNbnkzdVFCdFlMT2wyak9PWDFkYUU2RHRuVGJYZGZjODNLdTI4VmVm?=
 =?utf-8?B?LzFkVUNUd0pmcUtudXZnMTZGRHM0cThwLzNFbGVSTTBQazRmSXZWblhYUDZR?=
 =?utf-8?B?TnNzRlRiZEdTa1BYNFJNMm1nZ2Y1UlQ3aVNKanpST3c5Q0JPSXFVUFc1UEh2?=
 =?utf-8?B?dVBORXBJWXI5bUUwa01YQ0paSW1IMk9WaFlHcU9xcldPVXZuMlA3S3M4blVQ?=
 =?utf-8?B?RWovRWgrKzFpQTVOSzEwVUh2aHlheW4wdlhsMGR2cHZLTFB1UVhWczRFbDJV?=
 =?utf-8?B?V3E0Y1A4MUVJTW5HeDlpR1llcE1EU0dLRVEyZXZFQ3JBNTR2SHc1MU84eEJ5?=
 =?utf-8?B?ME15VkE4blZ4WFkzc2ttQklwQ1k0TGlzeXdIeTcyS1hXS1U2TzVrNzlnaDN3?=
 =?utf-8?B?S01rdWwvZVhDb1VLRnNMSHVIbkx0ZnlrNnFnRzI0TXBVaUFDb1FRUjVwTGd5?=
 =?utf-8?B?WG5EMWYrZG9CaklxTXpGT1BGMkhjRjBLZEdGTmFXUGtpZUZCNFc2ZVBwT3V3?=
 =?utf-8?B?c2x2WGtUa3pQMmI1N0JuU1dEMTJSL2lqTnZtVlVyUHdCcDdHQ08rdnArRzg1?=
 =?utf-8?B?SGhXcjcyQnBSSnhZcTdMeTJFQzUzQkxvMTZyS2xhenRJcXdWSmtlOW9EZzN3?=
 =?utf-8?B?VGpTeGwwYVY4UzFkOUUvZ2h4R0J0ZHdsRXlSWUU3Tit6RXVZbTRnd1ZaTkhP?=
 =?utf-8?B?T0xINjBkYkRuZmdGUy8rL3c5QnQzUzd4STRYWnR6VVB3ZFNaRmVTZ1RLZm9k?=
 =?utf-8?Q?WyKHQIgh4tHpJrvd5+NkvebUO?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 912b36d4-eac9-43ec-f4bb-08da9f0d1fa6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 15:46:34.2647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O93Yvp8qcEb0wELt681RGhKi6YirRs+wpiz/cx4vaIkbO4bfSpSo6oSQ3RLLB2Nu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4098
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/24/2022 11:45 PM, Namjae Jeon wrote:
> 2022-09-24 6:53 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> Allocate fewer SGEs and standard packet sizes in both kernel SMBDirect
>> implementations.
>>
>> The current maximum values (16 SGEs and 8192 bytes) cause failures on the
>> SoftiWARP provider, and are suboptimal on others. Reduce these to 6 and
>> 1364. Additionally, recode smbd_send() to work with as few as 2 SGEs,
>> and for debug sanity, reformat client-side logging to more clearly show
>> addresses, lengths and flags in the appropriate base.
>>
>> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and
>> general.
>>
>> v2: correct an uninitialized value issue found by Coverity
>>
>> Tom Talpey (6):
>>    Decrease the number of SMB3 smbdirect client SGEs
>>    Decrease the number of SMB3 smbdirect server SGEs
>>    Reduce client smbdirect max receive segment size
>>    Reduce server smbdirect max send/receive segment sizes
>>    Handle variable number of SGEs in client smbdirect send.
>>    Fix formatting of client smbdirect RDMA logging
> You are missing adding prefix(cifs or ksmbd:) to each patch.

Ok, sure I'll add those.

Tom.

> 
>>
>>   fs/cifs/smbdirect.c       | 227 ++++++++++++++++----------------------
>>   fs/cifs/smbdirect.h       |  14 ++-
>>   fs/ksmbd/transport_rdma.c |   6 +-
>>   3 files changed, 109 insertions(+), 138 deletions(-)
>>
>> --
>> 2.34.1
>>
>>
> 
