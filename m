Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7AFC6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 19:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiITTFB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 15:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbiITTE6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 15:04:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABAB193CD
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 12:04:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAuN4CErPJEY8HtmhRfCw4NmkehSE9YeXRfejUFGWnvAWGIL+vDgVYaAAPKPyf4cTx0CqZ7rP2wBj0ZL3SPk++O/weij7U4xtLrcvfsjCZndHxPaPJlKkpTabu2uWzVgpkdJ2YJ912HBi4qXjkNS46G2zti2rmX0CoSKcb8Y3rBXJ5r6IMXsNyO8hqyBxEcArvLZLT9uY2D81msrmrWN04BltaAG+QSbsuULxK6WE7hKUN9ULFXjg6+mFookhY5QhePJb8PjlbUaywvEwrSSgl+D0Ig3vLzaoUQlXzgxMbQvbsQedzShH83FrYTfumbZvGYN++Fo+KlV8f7aGxffYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQHNY7qeBAS+ishr8lS9P7ZrlD2b6Ex8Ylr4yex9JMY=;
 b=Rqu62CgcLBK3B1C8eJjBnC3VeP+nhhvfSddPUYWUSbCAM8voD/uJm7y48/2/pFrgl0x0K44CNbiq3Pc80hYHW8nrt1Xxr/ySDo6Cu3j0LAYO7H6s1iqcqTg4aUj9pGs0OW9dl3jheGLe/bRLmc+YdcVUdXNPJzK6E6sjD1V59zDnACMSKwn36hPrE2G88k/ihRKcykAaFWNqROjjKXxcaPFVvCnTV+Gnb5ooml6onrDL3pMIebnKLpMRafE4q6gyaKXTaoyXwC5rYey+Dsp/5klsch7sh27WYzyYqsRrxo9V5PvJa2EpGf3YSs80xr22avBSHq76JQ30qmApNco9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 MN2PR01MB5983.prod.exchangelabs.com (2603:10b6:208:188::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14; Tue, 20 Sep 2022 19:04:54 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 19:04:54 +0000
Message-ID: <6a8059e8-9757-afb7-8c06-b98a9877f30b@talpey.com>
Date:   Tue, 20 Sep 2022 15:04:52 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: verify signature only for valid responses
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220917020704.25181-1-ematsumiya@suse.de>
 <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
 <20220917162827.g3c32bh62maw7da3@suse.de>
 <3e03b3ec-f733-06b1-3023-592801414ae8@talpey.com>
 <20220919002158.wgta4konh6c4wfjr@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220919002158.wgta4konh6c4wfjr@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:208:23c::27) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|MN2PR01MB5983:EE_
X-MS-Office365-Filtering-Correlation-Id: c4479d0c-b72f-4683-9a52-08da9b3b0085
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3D70tuC8JDNYdCb0/dyG181yNJdh8x2amjw1SHAA70cYZltWrsIBFV/JHcOSwI+/s4mmqDZSLc3HbaYIu90kDCXeApcozah1B/nuituMlFYldoJ8hPNIAZbgo/wqLwO6EBrQoE3GiNTDJr9oinifFn/sOdzHVY3zEPlcaazbvdEm63sFX3eyR6gtMKdcMkqsykZ1+Zl1Cpk57bP90bGsZ1MMntpq27ZWaii6NHiG9ctNzFJUxROQ4RBIr1Ouz9Ec+6KmsNF84BEHZZniGqq7p9W8dzwvg8qImKibYnpCpWWiDSoTVZx2d5BFvK/VMLUwwlHRADDkrCcYIJVOZBX2evPcnEZU71bDqhIIjgv+VJsnqyqadoxmM1YtxE3uvxsiiSstJe0NZlrXpT9dW5mr2BgzAyTHMOo8x2709IPfMkIbaK6xis9MZpBM3EFCfmzz4RDTPOiNa5lCt5XzhiRfSvSg7bWm5opFkJN7Ijdv2lN3Af2kWkyGSC3/9o48UCZSE0WAukjl+HOfiDUAGhTq1+ecOAXhCnB4LGMYvTbn6H9kjWeqFIBSlaUNF915wg7z1TAow8ZauttKzZTXSlARjwuzCsDJpkKao57LeW7VBWm36N7qP0pjxo1s9VF2AquJg52YbBmWULoEZwzNTf85vWYNNm1iLMciKEtaB9wo/N5EzSt1KpchHE26OJrQqT1jpDqVSSWTtbRoT9f11Bx74xVZ0TKiDN13GcwMVcT8ylhUcfLyY58RTtps+RYKbYoxaOpFAW9rtosT3MlvnU9UVVqAVm4KxHWHCHFR2c3buwZIeTe8/6eQICieLBhRJAfxC8nMhn2dk1FZ0nSNMtVYSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(396003)(346002)(376002)(366004)(136003)(451199015)(86362001)(52116002)(53546011)(6506007)(8676002)(41300700001)(4326008)(66476007)(31696002)(8936002)(26005)(66556008)(966005)(6486002)(478600001)(36756003)(66946007)(6916009)(316002)(186003)(2906002)(15650500001)(2616005)(83380400001)(5660300002)(6512007)(38100700002)(38350700002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlpMNm5rZHJ0VklxUHlvNUJOWVgzbWs3cVl2TTgzc2I0NTlCTEJwY202a2RD?=
 =?utf-8?B?cXBnb0dzUDhJUVN6aGc1bitXMjZlZUVVdEFUa3Q3aHlEaVNGdXNmNUV5YXdp?=
 =?utf-8?B?RXJONWNlWWcvN2ZCd3pOcXRHVElOYUg4OVNjNjE2SnIyZ0FwMStwTHY2NytC?=
 =?utf-8?B?bUxBaTMvWW5wakRMMSttYmpQK3BzWjdrbktEWjRQckRrMFJCVWM2ODk1ZVlI?=
 =?utf-8?B?MmpRckdkbXo4L3U3Ymp4akYwVjhqcU5zcGp0T0R5bFRLQUswUTI4UHFyUFpG?=
 =?utf-8?B?Y2JFbXRHb2NWZGN3em4wdUVzSzR1S0gvMVg1bUlMVVIrNzlNT3N5TjllOUhV?=
 =?utf-8?B?OC83R1FERmk3RkZMU3pPc3AvYUxJSC8wblZXRVo3UFdmUXpIVFJRRDJUNjBN?=
 =?utf-8?B?KzA4cFNDeWtKMjZQeFFyR2dpOEdrL2R4WEJ0Z2xvcEJ2WVFLOWhVejVMRlJx?=
 =?utf-8?B?REJwbVdmc0RXUHZuQ0FTMlJjc09OSmhhblVTY2lwaUxVY0NWM3N4Y053b3BZ?=
 =?utf-8?B?TkloUVlHMXZIR2FucThHWFlaQmY0c2Q3bVNxb2tkV0MxR2xXbHhSU0liUHNt?=
 =?utf-8?B?MnU4QmdIR1hHUTBsS0VlWFRrV1lWMGpubWR2MElNWGJoU3ZYTGsydC83T3Fr?=
 =?utf-8?B?eUY1WW9IVDBBTHBsSSs5SjAxTVF0RzIvRS9DREJwMGFhNjZ5YW1CYy9UZ3Zw?=
 =?utf-8?B?Q1hZVEpLV3hYbGFCdjFrYjFqNzd2K0o4bHBTdEd2cFk3OHhXTjRjSmRUT3ZG?=
 =?utf-8?B?bi9waWxESWZrRndwNXo4Z3B0dUdQUnF6QS9KNlpxNS9VYXNYazQxMGV2U3gx?=
 =?utf-8?B?VC9LaFhYUDJrdTdLa0NPOWpFemZacXoxSFcwcGZsSVhER1ZET0gxVE11aFEr?=
 =?utf-8?B?TGlFOHgxdjdZaVlRSHhOcktQOERYK0pLdnZWR2haaWJLNDcwUkw5ZUJXbVgv?=
 =?utf-8?B?NnF6SWlkd2IzRDJxVENXS3N1WTBOeUU0NFlyZHo2bjVLdElFbW5QUVRFWlNB?=
 =?utf-8?B?RzJjaHJ4YjRJYkU3ZWFrblJHdnZnYkw4NDRuazA5YzEyamp5VE9NRVBYZ1ZD?=
 =?utf-8?B?OEJ0NjNZazhmVEVwUEFUelJUOGF3RHJXdDFYU1pwS0NoVnR4bmxVMGZFZXk0?=
 =?utf-8?B?QkcxZldzT2YrblpnVmJUZXJ0OHVQc3k0YmRSb0UzOEJMNnEvbzhlNDlwYWEy?=
 =?utf-8?B?NkZSY3NVcmZEWUxPY3N0bDBWK2ZYdDVPQmcyZ0ZJS0ZENHJFNnhJTWZKTXBZ?=
 =?utf-8?B?RnFTY0l0NGxlU3ZjdGRwbm4wZ2JOVlZWUDh4VWhYVjZmSW1vNy9UblJqK0NJ?=
 =?utf-8?B?MzI4NldlQnREMU9pdU9ZNHAzN2tPUnREVTlLbzVTdFRrdlh2UWxiM2ZaTFBI?=
 =?utf-8?B?TnZOTmVSL1lTVnhIWWpuNDBYa0IxUTRLaC9TaEgyRXN5aHFKaXROOXVhdGlr?=
 =?utf-8?B?eUd3N0cxbHFDeHVyUDBUOXpEQlY2THBHc1V0ZnhRVlpLcXBKMCtJRFlPTGdE?=
 =?utf-8?B?ZUs3aENIdjQ5Z2NRcEJhallyVDhqKzZ0bHJQUCtvUCsyWXJxKzVIQjhiSE1p?=
 =?utf-8?B?YkdqQ2Y3ZGYwMXZrR1JTSmRadGVXejFqSFJWV2taOFE2bzlCQkFqNGhrZlJZ?=
 =?utf-8?B?bnE2S0haeW5pMXlWN3NaRWE2MHpyVDRIK3BGN0dzc0RtYVQzNk9qclpyd2dH?=
 =?utf-8?B?bWJucVJKdEdMM0pGcUZjZ24wSzBsNzVuNkNFb1h6WlpRSzRvN08vR2tXOHYr?=
 =?utf-8?B?RkhGUXhqdnpvelJUZFpGZWpuNEhyelhlT0FiV0xxTUcweWRMVWxqWHh5SWhC?=
 =?utf-8?B?NjBOb251cjUwNXZDRUZDbFltRkY0Zk1CSTVLR2RETThtSUN0OXR1NTlBY1Iv?=
 =?utf-8?B?YlV4QnlTWnFtNmVhbnpuNGpuK054K3NXTnkrWFlKbDJZTXExTXYzb3lSYkY3?=
 =?utf-8?B?OWRMZlAzbHA4UGZySFJBZHpJMkRpZEdCc3NEOEMxZzdVd0VXMld3QmczUExj?=
 =?utf-8?B?RzlzcmF2TzBXS2xOdGtRdzQ2K2NEb09wSndPSFVwY0V4dWV6eHJ1b3dRd2sx?=
 =?utf-8?B?VzJoMWROODZ5bkZMeFhkNDBXM0RXNTc3QlJ3NG84Z0l5aExZRTVyc0tGbE1B?=
 =?utf-8?Q?kXS4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4479d0c-b72f-4683-9a52-08da9b3b0085
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 19:04:54.4696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCWmV7DZXIWKJzTly3lXwZt0X0+Kj35DQbwdYLZ53TPEbBLXDUC/l0THGFIWuUjv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5983
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/18/2022 8:21 PM, Enzo Matsumiya wrote:
> Hi Tom,
> 
> On 09/17, Tom Talpey wrote:
> <snip>
>> Wait, we process the message *before* we check the signature??? Apart
>> from inspecting the MID and verifying it's a response to a request we
>> made, there isn't a lot to cause such an error. See 3.2.5.1.3.
> 
> You're right. By processing I actually meant "parsing" done right after
> receive, but even that doesn't have many failure spots.
> 
> I found that the mids with STATUS_END_OF_FILE are being discarded,
> apparently as per 3.2.5.11:
> 
>    If the Status field of the SMB2 header of the response indicates an
>    error, the client MUST return the received status code to the calling
>    application.

I don't think it follows that the signature MUST NOT be validated.
That processing is fundamental, and is independent of returning
results. 3.2.5.1.3 has only three exceptions, and STATUS_END_OF_FILE
isn't one of them.

> What I found is that mid->callback() (smb2_readv_callback()) was being
> called from another thread, so even though the mid had been dequeued by
> mid->receive() earlier, smb2_readv_callback() was treating it as a
> valid (non-NULL), existing (mid_state == MID_RESPONSE_RECEIVED) mid.

That certainly sounds like another bug. Why are two threads processing
the MID? Is this an async response?

>  From this perspective, it makes sense to me to skip the signature
> verification when the mid wasn't supposed to be there in the first

That's not what is documented. Only if the MID is 0xFFFFFFFFFFFFFFFF.

> place, but if we consider that other messages with status !=
> STATUS_SUCCESS have their signatures correctly computed (apparently),
> then I'd guess there's something wrong with computing signatures for
> STATUS_END_OF_FILE responses.

I agree.

Tom.

> Sent this just now:
> https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/T/#u
> 
> I'd appreciate your, and Cc'd folks', feedback.
> 
> 
> Cheers,
> 
> Enzo
> 
