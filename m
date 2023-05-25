Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8286BC7EE29
	for <linux-cifs@archiver.kernel.org>; Thu, 25 May 2023 15:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbjEYPEC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 11:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233992AbjEYPEB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 11:04:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDA418D
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 08:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iT3x1I4BkrreDgZqQR73g89GuhJ9kmQvY23lPIupCuq9MkEgwnkT+lURYzJ0/bTGW5I79meeNR+zpXoWc27RIWRr0RpKnA1//H9QrVHI6MhXxx0u8rII/1rf48Xx7UfiIw7iC7KxrCVmg99UFATreF+Y1yB6p/vLAuWRl6pP07cbG6lJyQpiAOOX1BTulOmuOJ2OG/4jLz6dkRiQjxXKyxKQkF/dEZs6M2rI5VqkBn0ni+1gWNcuorJqtzSDeZ+UlqUVcEbWDGA321udb/Gik5B2hrEEM0yNip5q8eYlC4TiMy7/4joldhmABKI/2Kj/7vwp3p0a7P46dtKFdAZy4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRBVMDmA5d0DnJ7ho89smQuc9jHy1lBT3853hA1NqRA=;
 b=PuOvpljy+YXsuxY+Ku5+KADVgqUNAV72Q5OeGj7NgjU52/SPcBqDrqQpWDLH1MihRKzYStrMLbqGXh8/YbZbDWtrZtDma8iH+bc4AKoy3juBlYUnD7ZxFyjxyqVvP0u8a7CrOWChvGCIyPy8e9B5ekUCwO839676gQGVfg7eM/CqMDUg5ay9qBNTRhKVRrO5RdBsOF1cG221u1knkPcso5fpe8gqs2an9e32lzcqYabmFUcogHg0Ynuqbaiboth2t6yYBAA+jChnYqpyLkP6KD6ksL2yjXS0T/9KbzKSec1LP5zzYTO9XDhtEAv7LQeHMwQVpWMQMXFESmhEtWR5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA1PR01MB8355.prod.exchangelabs.com (2603:10b6:806:375::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.17; Thu, 25 May 2023 15:03:53 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b%7]) with mapi id 15.20.6411.027; Thu, 25 May 2023
 15:03:53 +0000
Message-ID: <7503c650-cb2f-0a7b-4d33-c64d03744e91@talpey.com>
Date:   Thu, 25 May 2023 11:03:51 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] ksmbd: fix out-of-bound read in deassemble_neg_contexts
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        atteh.mailbox@gmail.com, Steve French <smfrench@gmail.com>
References: <CAAn9K_vV2RVQSRvVp5q+Ksc6ZzxLhRHhD98LSA-JprxmAWZ49A@mail.gmail.com>
 <CAKYAXd9SZd8n8D3pr0pZQupZy53ku1w7Z5P6ppQOt6BeR79tzQ@mail.gmail.com>
 <CAAn9K_s=xKdj0xny9QYUPm6k7gM5bjG1Ukd8LSZVxo5Fghqw5g@mail.gmail.com>
 <CAKYAXd9OVdSd_Fcc_iwTGcyZZ5=iEn2KZTdFor3NtHScJjiqtQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd9OVdSd_Fcc_iwTGcyZZ5=iEn2KZTdFor3NtHScJjiqtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:208:236::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA1PR01MB8355:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f5ff6f8-db70-47b2-72df-08db5d314121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wytmJ3ZgWVtIVmaQBSrF+Akul/7mwypjtxZWdB6EmZtxETorORbRrLmLEL4r0xpb8TOssT0hPwpqDqdpD0QAW9jsDerUzRiXJ179Z3PsWw6woa2I+e9sjkSc45MKSpawnlLd/2pIpVG13SGXqPEDteIazw73rG8+DAHqDaRiFItt8yRLTS9zHLv7ssa+BsWWi00I+32AF4i8cVU6CIG/N+vjhCXuYLSyXIHDbjd22d9qxmWhY5oC+QwgnhUlpfjdXcXQrrVnOaXN3/e8OVVdaiegAl7fntnwtTEnl1jlcqxL0QUlD5FijqFoTat/E4lvX1NwyE/38u4KiNXtnblU/nxHPPaGInNHYvafrYGh100TUqbEUsT9pHCthS/UeEgIvOvE0PxIB2oDwpJ/uSkDWZC+6xnvw+upxS3IwRZJ5Btz67FSRzwyf+7Hz1XXmWZOC3aqvpmFFXjns4lUNqaf6Z03/YISAo5zNEbyVueHkhHkFh+yrxAJnB4qMuUKTYTq75ifGL+hvz9lSwnfol93Fc6R9jauX1fi3IGziGUokn5fN/QbKSPspYPsrM1ZtU9P9v0QuV1weXCB35Wsr3jBDSqFnXHSKrnEswhOB3aapFcdSrkShEzyWA5HR0jSIA3jp9e1CDu8WldNT05vmcZyDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199021)(66946007)(4326008)(31686004)(110136005)(66476007)(66556008)(316002)(54906003)(478600001)(6486002)(52116002)(41300700001)(186003)(86362001)(6512007)(6506007)(26005)(8936002)(8676002)(83380400001)(2906002)(31696002)(36756003)(53546011)(38100700002)(5660300002)(38350700002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHNWSTZjc2J3ZjlUN0Q5bEx4aGNpRUE1OFRia0MwMUZScWFyQSt5bmNWdnZu?=
 =?utf-8?B?RTE5TU9MMW1BM2dsV2dHOWlxM1ZjdVhvTDd3a3VJejcvb3pmSEp0KzA1eGZi?=
 =?utf-8?B?eGswMnIrWERhVWxXNzhXT1ozUFh6Uk5weUh4U0xRL1hweFlSbHF5ZkRmUDJx?=
 =?utf-8?B?ckpjeURqSXl3d1hVN08zRFhsVDRZcUczejJTalIvTTFlWjBWOEo4ZXZpTHl3?=
 =?utf-8?B?T0o0OU9wb05WK3ZGcy8xMHE1aTVtY1l4MVhielFjUFdzWFF6NXhXWEx3Vncy?=
 =?utf-8?B?Q05MN2x4TFIraDhiZlVBU0YxV1JlbVhTTlQyaUdDOHZlcTlydFVxcVVqbG9I?=
 =?utf-8?B?azh4UkhyeGMvVlpTa0Vud2dUSXhvcG9CRUdnc1Q1T0JlSUROaGxjeXlWSURD?=
 =?utf-8?B?RmVBMDFjcHovZzB4WVhneU9QdEdJb0JyQVM2YnVPencxdnptZ0FaOXFTK3VS?=
 =?utf-8?B?TzJmTENSay9DNnZEQ3g0K1o1NVU2Y3pHYnJMVVU3Uk95dEFRNzIzYjd4RDc4?=
 =?utf-8?B?R2lLYXlldmJEd3V4b2xmZWlLMTd1TGh3cHRMRjdzd0ZadnFyNHVQdkNiWVUx?=
 =?utf-8?B?VHczRXZ2ZW1JSVVQZnBYeDNjQ2RMWXFBZWhtbDNzclJBeHRMVzhmcWZ3M3NS?=
 =?utf-8?B?dDlxenR0Vjh0R0NCZ3FHdzJpZVdTMHBvbk5kN3NuczJxOStGYVZrRnB3SWZK?=
 =?utf-8?B?a29sZWdmaDNZejNCN0lqdlMwYVpGeXIvTTBMUTZtelhFZUFzd0FaMDl5Yko2?=
 =?utf-8?B?UEtXcUlIZDZYS0hXNGo3MlR0SUtaZlhWY3pkVXpaM3JFVkpINlJ1anRXZzZ6?=
 =?utf-8?B?Q0xkZnYwSHQxTEcyUlllY1Q3QWthVFZTRlFSUkV3WWlQT2llZzhvMFlYSGZC?=
 =?utf-8?B?a3ZxZExKdm1NdFlCTkYwWEFZSEVXK29YS3l4WmtHcFpGc2dBUDNIT2VQVUxG?=
 =?utf-8?B?aUFrM1lzamc0citwTytQbTF2SS9KTjZ3Q0s0bVNRS2ZjTjArcU1TL1E0Tlg0?=
 =?utf-8?B?cVlCTkNnMG9OS1dCNzI5UnRmZkFlSWNqMHZPdHNQMzdCMytTZ01ETi9LNi9h?=
 =?utf-8?B?MUlTK1VBZlhqYjA2dHJTZGdIQ1NHRzlwYlN3VDF2ejZHUGdzWWt2M3hKaDZW?=
 =?utf-8?B?R2p1NkplVXRkeUN1U0RJd0hKLyttOE14MXBJNXQ0VmVwb1hWWnUyUTFLVzE3?=
 =?utf-8?B?RkVld3JqQTlQMlI5Z1ZFeVM0dkltbGhtQ0paYWZvcVFNRFR3c04vNmQ1UStq?=
 =?utf-8?B?L1dkeExPTFNVRGxDb3JZS0ZmcmRraW50eTJLQzc3VExXUHVXU1kwMmhjbVhU?=
 =?utf-8?B?TWluYzJPNFdGT3l0UzhvMjNuUnZsWDhuRTFjVTYwSk9rMEQvTWEveUx6NDhy?=
 =?utf-8?B?RFQrai80cE1Id3FTUXk1djNrSmFBZk4xZVVqbWc1ZkN2N0xDcFRQNVE5Uks0?=
 =?utf-8?B?Qmt0b1lVZHNQdWNPdnhQL3B2My9sbG1tMjR6dklNRXJDam1xazhUWFVkV1BJ?=
 =?utf-8?B?anNjMVZKWG1OdmVKU3ZwLzByc2pvb2wzRjF5UTkxSm03UUhsT3ZXUzU0VE54?=
 =?utf-8?B?M0tpQUxUbWwyTmlIcDVkbUo2d1VmQStpMzlqUSt0aGp0N0J0Wkw5a1VCcXl1?=
 =?utf-8?B?b1R3d3cvYkxLdUVuNW9zU2VOVUpBamlRQ2F1aVZpcHp1WlhsTEdTZThYYUlm?=
 =?utf-8?B?TlJxU1dyNHJaNUIzVW1KME1Ic2IyaU5McXNDdGJjZ21KNHh1LzdjRHR1aGtN?=
 =?utf-8?B?L1ZaaGx2WW5hWllNMjFFVnBsWG5rTEoxaHdjSWdtMUkrMTVqcnFGRUZWQ2FF?=
 =?utf-8?B?NkszMUxoK0dIS28ycE5sTzFqSHozMVVDcVRZU3BPRDJvNkM4ZnlBZW5sZGti?=
 =?utf-8?B?YUNoZU9BbTRpRkpwVWtpNXJBQVZZRWZZbXk2dU1kOHdoSkNBMDRZdjY4bmRQ?=
 =?utf-8?B?QUVLSTlWdU1majd2T2ZuaGIyRThJYkxMR0U1OVdySzB3NE4rUXRXblJiSnZq?=
 =?utf-8?B?a3NwWDNwL09LUXBiL2ZhQlkwazFicXBHRXMwR2MvaVhzditiZjloODgzcHov?=
 =?utf-8?B?UllEeHFLUWZvQk5wd2I2d3BRT0VaTHQ4TDB6aWFKUHFwSUEyYU9INGNJZWU1?=
 =?utf-8?Q?cdaVGfIUHWO9RqsGWHOStcJ0n?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5ff6f8-db70-47b2-72df-08db5d314121
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:03:53.2379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jd3r/sS/P5jFUCJg0TnzfUtKprY/DQP32N5c/FOoZ/tgq+B+9pcu//moPb2HI2w1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB8355
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/25/2023 8:58 AM, Namjae Jeon wrote:
> 2023-05-25 21:18 GMT+09:00, 張智諺 <cc85nod@gmail.com>:
>> `len_of_ctxts` is signed and 4 bytes (int), and `sizeof(struct
>> smb2_neg_context)` is unsigned and 8 bytes (unsigned long).
>>
>> When comparing values with different size and different sign, first
>> compiler will add instruction cdqe to extend small one to 8 bytes,
>> then casting signed one to unsigned, which is `len_of_ctxts` in this case.
>> So a negative `len_of_ctxts` will be viewed
>> as a large unsigned value, which is totally larger than `sizeof(struct
>> smb2_neg_context)`.
> Okay, Can you update this check instead of adding new check ?

The len_of_ctxts should not be signed. There will be some necessary
overflow checks, to replace the incorrect underflow checks of course.

I'll observe that the len_of_smb, offset and neg_ctxt_cnt in the
same function are similarly incorrectly typed.

Tom.
> 
>>
>> I use program below to verify my guess:
>>
>> ```
>> #include <stdio.h>
>>
>> int main()
>> {
>>      int a = -4;
>>      unsigned long b = 0x8;
>>
>>      if (a < b)
>>          printf("expected\n"); // will not print
>> }
>> ```
>>
>> Namjae Jeon <linkinjeon@kernel.org> 於 2023年5月25日 週四 下午7:49寫道：
>>
>>> 2023-05-25 14:31 GMT+09:00, 張智諺 <cc85nod@gmail.com>:
>>>>  From 16b1d22ae886206def5fc71b26584c329755c81c Mon Sep 17 00:00:00 2001
>>>> From: Chih-Yen Chang <cc85nod@gmail.com>
>>>> Date: Thu, 25 May 2023 13:17:27 +0800
>>>> Subject: [PATCH] ksmbd: fix out-of-bound read in
>>>> deassemble_neg_contexts
>>>>
>>>> The check in the beginning is
>>>> `clen + sizeof(struct smb2_neg_context) <= len_of_ctxts`,
>>>> but in the end of loop, `len_of_ctxts` will subtract
>>>> `((clen + 7) & ~0x7) + sizeof(struct smb2_neg_context)`, which causes
>>>> integer underflow when clen does the 8 alignment.
>>>>
>>>> [   11.671070] BUG: KASAN: slab-out-of-bounds in
>>>> smb2_handle_negotiate+0x799/0x1610
>>>> [   11.671533] Read of size 2 at addr ffff888005e86cf2 by task
>>>> kworker/0:0/7
>>>> ...
>>>> [   11.673383] Call Trace:
>>>> [   11.673541]  <TASK>
>>>> [   11.673679]  dump_stack_lvl+0x33/0x50
>>>> [   11.673913]  print_report+0xcc/0x620
>>>> [   11.674671]  kasan_report+0xae/0xe0
>>>> [   11.675171]  kasan_check_range+0x35/0x1b0
>>>> [   11.675412]  smb2_handle_negotiate+0x799/0x1610
>>>> [   11.676217]  ksmbd_smb_negotiate_common+0x526/0x770
>>>> [   11.676795]  handle_ksmbd_work+0x274/0x810
>>>> ...
>>>>
>>>> Signed-off-by: Chih-Yen Chang <cc85nod@gmail.com>
>>>> ---
>>>>   fs/ksmbd/smb2pdu.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>>> index cb93fd231..2d2a2eb96 100644
>>>> --- a/fs/ksmbd/smb2pdu.c
>>>> +++ b/fs/ksmbd/smb2pdu.c
>>>> @@ -1030,6 +1030,9 @@ static __le32 deassemble_neg_contexts(struct
>>>> ksmbd_conn *conn,
>>>>    clen = (clen + 7) & ~0x7;
>>>>    offset = clen + sizeof(struct smb2_neg_context);
>>>>    len_of_ctxts -= clen + sizeof(struct smb2_neg_context);
>>>> +
>>>> + if (len_of_ctxts < 0)
>>>> + break;
>>>
>>> There is a condition to check len_of_ctxts in this loop. How is this
>>> check not making a break ?
>>>                  if (len_of_ctxts < sizeof(struct smb2_neg_context))
>>>                          break;
>>> Thanks.
>>>>    }
>>>>    return status;
>>>>   }
>>>> --
>>>> 2.39.2 (Apple Git-143)
>>>>
>>>
>>
> 
