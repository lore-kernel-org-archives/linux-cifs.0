Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2459EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 18:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjFUSZK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 14:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjFUSZJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 14:25:09 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1BCFE
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 11:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1hgKfORjgDfW7kb9jYQlo9wGFLDBIW8hNyfjArXHoMP9gOu/nAwa0nft+FqSJDaLCkTYdocaDiGMpIU8tOfOSy1ojqzdLFI3eyIGhtCCX5o3mPaZHBircVFa9Se7FAvTRHom/Q7Y0Zn2qJUEjG5f9xle1bgYS+jYzrGKW2MueEmx90KL9jKLHwlecdVNBCrjenXJl76VDnx0MRGxfYevONKUHW/04BOvyj+L3tbhGeHD8l1/3c80qWV527O4eEWizp0t/OPfNUi1am3dW0FsQ2UXHmP8L33SBwQRVmcRhNdicHGn41nhAUD19jX1KMA1Qr9Js21BxxuoPgvySsgsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzARY04fc9o2gnARw2lVesHVEYu9RBQ7yt9PgvGpTF4=;
 b=kWAxEOvO8fi7ECub5QOJUwpDwYyyp4YlAkHByeeVTL28ytbyjIo6Pxml5mK6GxDJbyHSBjNqGftK983EP31lZdJnLeBrfRi1HMLKFc/dQNNn39eGVDINLGkUbeefofl+CwT4YQFvhG0QVcKwq4+0eR937KmkbWspVn4QM4+4j7hQqtgALds+5CiNB9hLwt12aCgt1GKytBufCVDDYje14EamNYU/y5Nou/l+N1/fSwHd1yFuv/1sj19XubyQ++tAmlgwtpjG+DjDoc7Fx3r7F3Eot7rT2nfHsLaHO4Q4q4c8NDt2Q8h4wd/xGxgxHZvumOc1RaIuDjs5Pge812pVWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM8PR01MB7046.prod.exchangelabs.com (2603:10b6:8:1b::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.23; Wed, 21 Jun 2023 18:25:05 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 18:25:05 +0000
Message-ID: <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com>
Date:   Wed, 21 Jun 2023 14:25:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
 <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0154.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::9) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM8PR01MB7046:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b27a7a4-d9c2-4fe8-5b6d-08db7284d5d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/NudII/n5HTfxX6iTyd2F2ZqlUQRbHlu3Z1HKOsjqdTaxPmRi8VuJ3OPrvOyPB19ANss8ceoh9J2ButWhiqTAFRzZDLCMn3/SyNJWzgvBbBGiOFpIS7v2Nm84ZrECXQB7VWTjdyPQ5Lo7o4KsIhLBMSpBIU956hZ97HTAUW/tx+86kzb0yFHaB1MTY/wRLthsau4HXdiLBiO0cK7BsOCK1httBxe6qxRO/NgDm8UcasdrjFH51ZcO6B5SrPVw6U9aUPcw5+Xe//xoOdKaAa9efvqqAT4qTjyhau+VjD1DEd+JWwfVMY/wJEj6Sdk+4GC54BoaiOFLbAaPlFpQRTtWDbKK65AHFFWtqadCNM4gBUoGK3SmjnvDlsakZ91Lrq1pZW9ymxHegU0ljoUK62CoJYZQpmCKP22/ao5BJCLJRQ/pKPe4yOvWu5PTgITYieBfyUyza461icoxWubBpJEeZiXXQS7r8Mq7JaTs1ysZQdzTLGaihcgf14keg2yNe0jfAiCwzj1YoN3339pSreZGYFJHFyiDMW9+EoOk2sSVmo3Go2AMBhKotRZqW1VzIDaJHbcar72r9+/FmiF7V2wymel53Z+I/0uDpfrZNfsEiNedTJX8n3iUP6O68+dvA7HLz7e/dyeYR+4gSFuJsd2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(39840400004)(346002)(366004)(376002)(451199021)(6486002)(38350700002)(38100700002)(52116002)(83380400001)(186003)(53546011)(6512007)(6506007)(2616005)(36756003)(66476007)(316002)(4326008)(66556008)(66946007)(2906002)(8676002)(8936002)(26005)(31686004)(86362001)(5660300002)(31696002)(41300700001)(110136005)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emtLcEt3c3dyOXd3UGFqd2pBQ1N5SWJ0VTNRdGpoRFl5OE1HNkV0ZEV0aVhv?=
 =?utf-8?B?TkRpOXBiOURRbkV4OVBqM0FSQjkwQ09MWTZJT2ZDQ0NmYlYxTm1adkhhQmcv?=
 =?utf-8?B?enZ3a0hqd2ZVckpNU0orZTJYVitIN3JuRHRWNmx4Y0ZNOFVuMzBIdFUrUnBI?=
 =?utf-8?B?V0tkVWJmT0h0Sk5RWjlJeVppZm5yRFVoR3FPemcyMUNGMm0yb1p3RW52di9y?=
 =?utf-8?B?NDAwanpNamJ5OEZ0bGxrSUxvam9LWUNyQmdkd1U4MW1ReEhJWi9NZXFVS21S?=
 =?utf-8?B?ejd6YjlrZ3lXZ3pzMC96NEhOYlZvMVNsWXNaL2g2a3hQdmxPb1Q0RWp3aTBo?=
 =?utf-8?B?SGtwek9DdWwydEEzUTRXVnRlVFEwOTlHUnJSWFdGOVJTZ2J1Sm8zek9jSXhz?=
 =?utf-8?B?cG9RNUx2djU1bHF6ZHlYUUZySk1LMHlLVlUxQzNURkxMbkpmL2U3THVKWXdx?=
 =?utf-8?B?bzJiRFBBTTZkejJ1OHlDaVY5Z1BFMnAyUzVjenFGRWxqekIybEs0TElXZ3JU?=
 =?utf-8?B?TDVrZWk0cmdhOXBBZlcxWG1yelBQOVlOQzA2cnJhb2pCTHp6Y1FLeXJXUjN0?=
 =?utf-8?B?TEhFVFZrMGpJYjViSFdVL05zOXA5NXRKTFcreVF4VG02Z0tTakFTMDRVaysx?=
 =?utf-8?B?QTdxNXNiQ0dQejNRMWptekN5Wi9Oa0pyUU9HbGlGck5qdVZrSW80Z0hhUjU4?=
 =?utf-8?B?UjIwQmJuU1gxS2dJSjVCMkVXNmNKWmRwOVdJQmZDbnV2NS9CWUdoaGVVdGJa?=
 =?utf-8?B?aUZNR3Z1aHdOeU5PaDJJZjkvZWxreEZtRS9UYjRiNkNLZHM3YXlSSlV3STlz?=
 =?utf-8?B?WXFrL1lBOWpsMWVxeS83V3hBcHlINFNYRmRtQlRlZEhPbThSV29namlRZkdG?=
 =?utf-8?B?dHFMTTZMdlhnemtENGMrMVN3VCtMSE5FMWFaZUV2SllOajVzT2FRTmFRSkth?=
 =?utf-8?B?b3NEZXZIZFlxaVl3SnFFbWRITlh6RHBPWGVtUWxYWW9rQ2wwVysweGQvL1Rt?=
 =?utf-8?B?RXdOWkxVWEVoV09wRWRRUk15SDRMT04rV2ZOYXp2eU1aRkxBUTdjUGZXcFYr?=
 =?utf-8?B?SFBVelFyUzc1WkpPYnNtUWc3QWd5T0FWU1czSmlpencwdVRPd0s0RWxjL3hJ?=
 =?utf-8?B?WTYvenZUcmI4dHprRmlENUo5UDFFSjJvbzIwQWhRWG1pYjZUWjl6c1hIOTUx?=
 =?utf-8?B?Z3hIUkV5bmJTVVkyVXJvTmtpYVpFM296SFQ5QzMrNWxhRzc1OVdSZFNPWXVC?=
 =?utf-8?B?ZktCQjV6ZzJyTjFnbDFHTkhoTGkrbHZuMUJPVHdYcXNpWGJ4bklTMzdKY0hM?=
 =?utf-8?B?elNpVEhTdGpYbUlpeUlBNUg2eW0vREprM1lSUzAvSyt1bUpjRm9zMngvYjJo?=
 =?utf-8?B?LzNzZUs0TkovelBhWVVhZTVkcFhnbWwzcmllYjd0S01FZ2owMWlBMXVUZWhp?=
 =?utf-8?B?ZTJxR3FQNUkrUVRkOXNyNlZFcXJ4UkVyaGFmakZraXNqQUgycTRWZWR1UkJa?=
 =?utf-8?B?dGYxZEhLbmZ1WitxTDVaNmpjQ1puaXZBVVF2Uk1sVzZzWGFYbmsxRVNpN01E?=
 =?utf-8?B?TkJxVWRQVkphQlo3MGx4aGtrZzk1YnRjemNxTTVZMUdxWjlheWR1aERzZzBH?=
 =?utf-8?B?TldjMXlKdjRrWlVrd3BvT3FoOHNjeitUY0lHL2xIT1VwQjQrbEtienNra25S?=
 =?utf-8?B?MHR0Rm9CMUd6VXhlb2wyTEszN3JOdFFEY2ptbnoxWXNVVm82Tks3NGtwUVRt?=
 =?utf-8?B?TngrRE84VmxNUVBaQ002SGJZbkJDMGZMdHJGMzVSSVZsMjZwdk9Ja0VyeURB?=
 =?utf-8?B?bGdRWnhwNHpHbEp3RjRqaHQxOXY3R2JPMFZ4Kzg2VXEzdVM5emRiNUo2Yk5H?=
 =?utf-8?B?cVFaUExTdnZpellFVG1LN3gvbG81TjVZdHMwZnEzSlZ3TzFBcWZJK3FGNkwz?=
 =?utf-8?B?aWlEYnlRcHRaZDlzd3lRbFgwZkhvc2FJRUpGMXRHeXdWTGk2bjJTOThIcE4r?=
 =?utf-8?B?RVJCVGVhd1ROMWxXWVhzVTFpM05hODJLSGxocVpsS2M1ZU9uSG5IU0NUY0RM?=
 =?utf-8?B?ZWgxazl2MVJFN3BxUzRvZXdqaEtFcmlTOU8zM3prYnFheGdYSE9xSTdaem1W?=
 =?utf-8?Q?zAbX2CRmkDqHTqFQe1v39NjIw?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b27a7a4-d9c2-4fe8-5b6d-08db7284d5d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 18:25:05.3069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dNv6XRNOA7cqdyOHoGH4W8w2DkVqP4nRc0CaAUVrpo6S7FXh+gZBpaxYLemS+fl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7046
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/20/2023 11:57 PM, Steve French wrote:
>> Why this value of 10? I would go with 1, since we already reserve 1
> credit for oplocks. If the reasoning is to have enough credits to send multiple
> lease/oplock acks, we should change the reserved count altogether.
> 
> I think there could be some value in sending multiple lease break
> responses (ie allow oplock credits to be a few more than 1), but my
> main reasoning for this was to pick some number that was "safe"
> (allowing 10 oplock/lease-break credits while in flight count is
> non-zero is unlikely to be a problem) and would be unlikely to change
> existing behavior.
> 
> My thinking was that today's code allows oplock credits to be above 1
> (and keep growing in the server scenario you noticed) while multiple
> requests continue to be in flight - so there could potentially be a
> performance benefit during this period of high activity in having a
> few lease breaks in flight at one time and unlikely to hurt anything -
> but more importantly if we change the code to never allow oplock/lease
> credits to be above one we could (unlikely but possible) have subtle
> behavior changes that trigger a bug (since we would then have cases to
> at least some servers where we never have two lease breaks in flight).
> It seemed harmless to set the threshold to something slightly more
> than one (so multiple lease breaks in flight would still be possible
> and thus behavior would not change - but risk of credit starvation is
> gone).    If you prefer - I could pick a number like 2 or 3 credits
> instead of 10.  My intent was just to make it extremely unlikely that
> any behavior would change (but would still fix the possible credit
> starvation scenario) - so 2 or 3 would also probably be fine.

What do you mean by "oplock credits"? There's no such field in the
protocol. Is this some sort of reserved pool for the server to send
unsolicited messages, such as recalls or STATUS_PENDING async stuff?

If so, I really don't think any constant is appropriate. If the client
can't calculate an expected number, we should keep it quite small.

Tom.

> On Tue, Jun 20, 2023 at 2:48 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>
>> On Tue, Jun 20, 2023 at 9:12 AM Steve French <smfrench@gmail.com> wrote:
>>>
>>> There were cases reported where servers will sometimes return more
>>> credits than requested on oplock break responses, which can lead to
>>> most of the credits being allocated for oplock breaks (instead of
>>> for normal operations like read and write) if number of SMB3 requests
>>> in flight always stays above 0 (the oplock and echo credits are
>>> rebalanced when in flight requests goes down to zero).
>>>
>>> If oplock credits gets unexpectedly large (e.g. ten is more than it
>>> would ever be expected to be) and in flight requests are greater than
>>> zero, then rebalance the oplock credits and regular credits (go
>>> back to reserving just one oplock credit.
>>>
>>> See attached
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>> Hi Steve,
>>
>>> If oplock credits gets unexpectedly large (e.g. ten is more than it
>>> would ever be expected to be) and in flight requests are greater than
>>> zero, then rebalance the oplock credits and regular credits (go
>>> back to reserving just one oplock crdit).
>>
>> Why this value of 10? I would go with 1, since we already reserve 1
>> credit for oplocks.
>> If the reasoning is to have enough credits to send multiple
>> lease/oplock acks, we should
>> change the reserved count altogether.
>>
>> --
>> Regards,
>> Shyam
> 
> 
> 
