Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8E0C19F2A
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Aug 2022 12:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiHDM67 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Aug 2022 08:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiHDM66 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Aug 2022 08:58:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE992A735
        for <linux-cifs@vger.kernel.org>; Thu,  4 Aug 2022 05:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nc1s5wWrGry5O1lJSrwxLEnx6ckcFO1zQL9hagRCmt5NI9r3GMZ3fNhYRStsP9dswdN99ohoJJfpHvebnPnUn03/COMI6Z7LoP9BP1fpTH+iu96asOZ4b9TpGv+1giA7CUc7jVMMO8sNJE9jQtmiHN+ZI9jpB2S6nbZ9ly/mnQ6JgsiVDBUYC7J1hO2y6Xp0rTxp4EXJ8ouG2MyE6ASJfokI2+kqqM8H1BFegke/bFhigg7d6Amg/A8ep561USHQB621LdUG5AOWUat0R97yvtCosaZY2HV7JtjVdTkehoPBAyqqNY3oewPEKmUQZrK2dGyOeAe3eHgSzJcDZ37dpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7dRa4bCCsHp5ItH3ZegBYuzz1aH/BkDEG3BOZ0SrAY=;
 b=lZrrtLwMShfwblxopbyhqtGvknmqIUY86TN47Hz2K4D0NTMtQDdwXE+5MK2wXJDw/7fo5cjBY56q9c0uFT5saDeFgXFiF7/1QiwFdfRuUukwr3vKswvkcerdisQFhs221tLZQGdXqnTt/EWaMB4CVggR3ZonlrvCXbgfqR7dJYuF0NCuo256Sugc+j1RNxUWUVEgzrqOknHYeLy0X1VU9vFXgQntcVGx8/f5dWLyYasoDg4iVKBq+FuylamUwAABqaE8ZIvYpzgo46Tg6IR1YJQMSuR7CDOxw9Z+5IzQOL4UDvtgF5op+pxBpXewcp6FYayI6mWnkbTnEwC/43bzIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM4PR01MB7668.prod.exchangelabs.com (2603:10b6:8:67::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Thu, 4 Aug 2022 12:58:54 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 12:58:54 +0000
Message-ID: <5110ec45-466e-b2d0-67e8-21a251fc4f27@talpey.com>
Date:   Thu, 4 Aug 2022 08:58:52 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] cifs: smbdirect: use the max_sge the hw reports
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Long Li <longli@microsoft.com>
References: <20220803022042.10543-1-linkinjeon@kernel.org>
 <d1e09264-bec2-8dfd-c793-6fc7c528b1c5@talpey.com>
 <64fa262a-9629-1a94-4314-a218b686b46b@talpey.com>
 <CAKYAXd9tJsvs6GKFXW6_V8jug+zvKjw0hc4ej1_mkmpfwZFK=w@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd9tJsvs6GKFXW6_V8jug+zvKjw0hc4ej1_mkmpfwZFK=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:208:e8::33) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a5498bd-f126-49fe-0676-08da76191614
X-MS-TrafficTypeDiagnostic: DM4PR01MB7668:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: II+yji7ba2OVT6P/8V+h20g7bwv9Xrt/2FOdcvgSTNl0y1l74c1I9ni7/WH/6SZ7D3WnrupnYo+uRSZXs9wrWwrf5OC59+R9RWDOPv9dIxCyd/eKrAu7PUQvorlyYd6DIQIXgHqUJAVjMzn1CGwBXubPCgsQiou0vIGuUoJy9VH1RDl1b06pagS0/EHuLWeJ60Go6/mHVjJxaDJXpLIqEIPdv8CNV/87BvdUB7UBseR90aBQ0oKzfS9j8nF8//BNr1Fn6SkoJwB5NIQSVhAaBFAHHX/iwoOsUdyUKSd8c56zVAOxyIMX660fNCdhwgnMV3zgS/47prVrj9GYhMXAV6i5Axm61BcJU8sIe2TtagcLltQbeSrXQn33dteLQgkwBQWpa48moiei1NaoPAz+DFKaGU8c/I4BJhUweOqgDA8MLB1OCGKjjlLtJIStasRxUNNmSswe/FS1e5iTuj5eUpxkPy4U/xPUhs6mAZVQAWcqbYd1rltFIp3znclC9OivFAuFViSzcwInJbeCVWF6mGZFZIM4Dw9arBlGSqLdofIb0OzanqK7VHFPfvoOUtqkxNfDhyhikeuCkwGYCTPtFKCJPVr/8WDcIUNhNe0y8c0sHOjbNNY9i4yn6MphOgaAowuAeLIx6sCbHqMVW03fv7SkxuAUF7RbKTdcdGT1foSIbtGM8Whwo1cA+n+UCMewuKwuqRbvs1xRytmExe+IfsEaNwEMD64CEHYIFHtgh4Nf+eYoFhf7WfgpmL+F7lkXclgKUcG7sj7Rfp58/5ryguWk4zwVbxGpK9HHNb7aHCJVHwnFZZ2yulO3UUojkGSCc4yxzyc8Xdtb0edTR6XxfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(376002)(396003)(39830400003)(36756003)(83380400001)(186003)(8676002)(66476007)(66946007)(66556008)(4326008)(45080400002)(31686004)(54906003)(6916009)(316002)(8936002)(6486002)(5660300002)(478600001)(26005)(53546011)(52116002)(6512007)(6506007)(2616005)(31696002)(86362001)(38100700002)(38350700002)(2906002)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG9xMXJwSVpmZXRDQW9kZFZLYVUxR3FNQ3J4UDlkNlRGQVpSS3k4STlCbmFE?=
 =?utf-8?B?MnM4blZ4RVZuak9INi9KWW9XdjBEbXY2UjhkQ1p0SWxVRlp0N3lsMXJhOUkx?=
 =?utf-8?B?U2RaL2ZXVzkrTzQwMEtseHNhcWZhUURuc0R2ZVJKK1IyNDJMRGNqMzlMWVFD?=
 =?utf-8?B?dzE4L0ZRa1JDWDJWQUhFTUN3c1U4R09GOXRNUGdqbmJoM0pJRlVjbWMwWFlX?=
 =?utf-8?B?aDFLeWRIMy9lM2d5Q0s2dGZFT1ZKUjF4SDlhUDhJVDhzYzZ2cTVrcW03Ulha?=
 =?utf-8?B?b3RmTnB3dGZFWEVSS1lwUmpmM0h1TElQYzBwRERCYWVhR2xYV1Iybjg5Ty91?=
 =?utf-8?B?WFZWLzF6ZEVqSEg4UG1YakhrdkwyQk96YkRKOGd4V0ZOZTJEblRVSEdiNEtW?=
 =?utf-8?B?RCtTREhrNGpqdEp4WlZOSnhrajUxaVpTS2xvYkRPTWFxTVZ5Smhhb3R0OWdY?=
 =?utf-8?B?NTFCRjRhZSsxcnVaYUFRTmZqMUthNjR2OVhWbWNPV2l0VTdxNVcxUG94ODZh?=
 =?utf-8?B?MXgwaDQwKzNnRE9CZUVIZ0E2ekFkZ1pXbW5HOGNNL3kxNHBBYkUxMFJkakNN?=
 =?utf-8?B?YkszOC9Uck5PeDg1eGNiQ01EVnlmWktkZGlQdjZpbUkrSGJyMHhwSk5wZytH?=
 =?utf-8?B?cmhUY2xDSExXOThVY2swMldYZHBWRE1RN1ZhVGFEamV0aENOZjM5WjJqZWVV?=
 =?utf-8?B?V2FhZXZSTjRUZ2JxVWsvTk11STEveXhXM0paK3dnb3pGSnhJYzRyaVNzNzgv?=
 =?utf-8?B?OFVCOVRIeXlCY0JSSUF3NmcybkVHYlNxL0pMOUhIbnRYN0R5SjZ2dlFQL3kz?=
 =?utf-8?B?NzF2aDBJSmVFL21uNDF1QS9yNVpjR0V6ek5vWTVNa2Zodjg2RVpaLzAraDhJ?=
 =?utf-8?B?Q1Mya01VSWlTdytuV09ySU1YUzVwRlk5dTVkVi9ZanRtZDI4UmpkSVNXcDJp?=
 =?utf-8?B?V0l1UXNyelEvMFcvbXl1Vm54a0NveklJMXhxWjhEY0RQQWRkTlFSSUltbmZn?=
 =?utf-8?B?aXVnRjUzdlI4bGJqUlNoTlBtNFlIZ2NEeHNBYURwaC9aL1BJMWNYWXBnaTFR?=
 =?utf-8?B?cXNlMjJ1d3o0MTJxVUtBdEp3UHN3QXRpdU14NUNjKytWL0RxQ1ZZYXI5S05m?=
 =?utf-8?B?bFQ5ajVFS1hVR3Q0Z0FqSVpqbWdxdUFUbjBrM09UYUFYQ0w4ZjV2OG0rbmpU?=
 =?utf-8?B?SE5ucmhwVlFDU3lLNlZzNWpSQUk4d2pINkZDcTR2ZmRpUUZRTm1FVzliaEhD?=
 =?utf-8?B?MUhJTkQvWVlWa2p0cXZHWXhZRDlub2l1SmZ2cDBrcGlPYXl4enY3L01GWmZZ?=
 =?utf-8?B?MjlERHoyZ0I0SDgybnhwTGZ4OW5wUWx1dzFlSmZ3QW40MkNWTXJ6dWJ2NkRB?=
 =?utf-8?B?SmRmK1lVdDZFUm9WZ0h2ejVQTDd2dnR2T25OMGhzZmI1UkRZQkovRnI0eWlm?=
 =?utf-8?B?RGhNWjB6dVVNYm5BRCtwQUFqcEtGOGxoMkd6SjFaUlZiQVl1TFJRMkdXVzZH?=
 =?utf-8?B?em9VOHo0bFE4ZEcySlp1VitYblovc21nWGxDV2RYNG9wWWlCam43azdBUHJl?=
 =?utf-8?B?azRscHFWUmtVempURDkwRGpSeFoxOEtlVTFKd2R1RmZsanJtcGRPR3ZJWk9J?=
 =?utf-8?B?OWV3c2ZkbFNBZFIvNmFWMFBscVVpNzBIcHc5Mm9VS2NyblAxbTdzZXZjV0lR?=
 =?utf-8?B?WjVIQVozcHJlWmpMenliR3pEL2dacDl2cDJrQW5YWjBGS0s4b2FmSUJVYndw?=
 =?utf-8?B?bmF2YjdPM2ptRkhvenV4UFA1L2RtaGFoODgxbnkvR2M2MzVlNXByaVNEbDQ2?=
 =?utf-8?B?VjJ5Z2ZkcW0yRkJ0OFNoR3NGeVh3Q3lESitXcFJMWnovRUVzeUFpNEhnOTB2?=
 =?utf-8?B?eUhvanZQdE8rYnJWS2lJV09maElCckgvaGJXOC9LUVR3ZHBQaGFpdTkvRjFk?=
 =?utf-8?B?TlhrbVJkVVpFM1FhbmdIK3JDU3Vza2pHM1RwOWdWSlJZSDdCYXVzN3h2b0l6?=
 =?utf-8?B?ZFlkSDM1QkIwREsvN3RmaUsrS1NsZlZNYU5WdW5MeWpHM0U1dnM2cEQ4NXF1?=
 =?utf-8?B?dXhXR0syZFRaUEdqYkNDU2tNeUhkR2laNWd2ODBLZnMvRmkzYmxMT3JxMHpH?=
 =?utf-8?Q?J2J4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a5498bd-f126-49fe-0676-08da76191614
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 12:58:54.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGwV27ebhgk6BF4577SZ4QC0CaMK6COtHR7h0ew3Y1mQIb3DFGzOsGjQY5KvdZcs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR01MB7668
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/4/2022 1:58 AM, Namjae Jeon wrote:
> 2022-08-03 23:34 GMT+09:00, Tom Talpey <tom@talpey.com>:
> Hi Tom,
>> Oops, I typed "ksmbd" below, I meant "smbdirect client".
>> However, fewer sge's are always better, and ksmbd may
>> well have different requirements than "cifs", making a
>> hardcoded value even less appropriate.
> Yes. Agreed. but I don't know if I can properly answer your questions.
> I have not looked deeply into the cifs smbdirect code, so I requested
> Long who is an author of smbdirect in cifs for a proper fix before.
> And it's still there. I just wrote a stopgap fix patch as on David's
> request. I expect Long or someone else with a deep look into cifs and
> smbdirect will give the right solution later.

Ok, well, I'll do it. The patch is a NAK from me, because it adds
new, and incorrect, logic. If enabling SoftiWARP is the main goal,
then simply one line would fix this:

#define SMBDIRECT_MAX_SGE 5

> Thanks!
>>
>> On 8/3/2022 10:26 AM, Tom Talpey wrote:
>>> On 8/2/2022 10:20 PM, Namjae Jeon wrote:
>>>> In Soft-iWARP, smbdirect does not work in cifs client.
>>>> The hardcoding max_sge is large in cifs, but need smaller value for
>>>> soft-iWARP. Add SMBDIRECT_MIN_SGE macro as 6 and use the max_sge
>>>> the hw reports instead of hardcoding 16 sge's.
>>>
>>> There is no issue in SoftiWARP, the bug is in ksmbd, so I think
>>> the message is incorrect. May I suggest:
>>>
>>>    "Use a more appropriate max_sge, and ensure it does not exceed the
>>>     RDMA provider's maximum. This enables ksmbd to function on
>>>     SoftiWARP, among potentially others."
>>>
>>> More comments below.
>>>
>>>> Cc: Tom Talpey <tom@talpey.com>
>>>> Cc: David Howells <dhowells@redhat.com>
>>>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>>>> Cc: Long Li <longli@microsoft.com>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/cifs/smbdirect.c | 15 ++++++++++-----
>>>>    fs/cifs/smbdirect.h |  3 ++-
>>>>    2 files changed, 12 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
>>>> index 5fbbec22bcc8..bb68702362f7 100644
>>>> --- a/fs/cifs/smbdirect.c
>>>> +++ b/fs/cifs/smbdirect.c
>>>> @@ -1518,7 +1518,7 @@ static int allocate_caches_and_workqueue(struct
>>>> smbd_connection *info)
>>>>    static struct smbd_connection *_smbd_get_connection(
>>>>        struct TCP_Server_Info *server, struct sockaddr *dstaddr, int
>>>> port)
>>>>    {
>>>> -    int rc;
>>>> +    int rc, max_sge;
>>>>        struct smbd_connection *info;
>>>>        struct rdma_conn_param conn_param;
>>>>        struct ib_qp_init_attr qp_attr;
>>>> @@ -1562,13 +1562,13 @@ static struct smbd_connection
>>>> *_smbd_get_connection(
>>>>        info->max_receive_size = smbd_max_receive_size;
>>>>        info->keep_alive_interval = smbd_keep_alive_interval;
>>>> -    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
>>>> +    if (info->id->device->attrs.max_send_sge < SMBDIRECT_MIN_SGE) {
>>>>            log_rdma_event(ERR,
>>>>                "warning: device max_send_sge = %d too small\n",
>>>>                info->id->device->attrs.max_send_sge);
>>>>            log_rdma_event(ERR, "Queue Pair creation may fail\n");
>>>>        }
>>>> -    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
>>>> +    if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MIN_SGE) {
>>>>            log_rdma_event(ERR,
>>>>                "warning: device max_recv_sge = %d too small\n",
>>>>                info->id->device->attrs.max_recv_sge);
>>>> @@ -1593,13 +1593,18 @@ static struct smbd_connection
>>>> *_smbd_get_connection(
>>>>            goto alloc_cq_failed;
>>>>        }
>>>
>>> Why are the two conditions treated differently? It prints a rather
>>> vague warning if the send sge is exceeded, but it fails if the
>>> receive sge is too large.
>>>
>>> I suggest failing fast in both cases, but the code gives no way
>>> for the user to correct the situation, SMBDIRECT_MIN_SGE is a
>>> hardcoded constant. That's the bug
>>>
>>> IIRC, the ksmbd code requires 3 send sge's for send, and it needs
>>> 5 sge's when SMB3_TRANSFORM is needed. Why not provide a variable
>>> sge limit, depending on the session's requirement?
>>>
>>>> +    max_sge = min3(info->id->device->attrs.max_send_sge,
>>>> +               info->id->device->attrs.max_recv_sge,
>>>> +               SMBDIRECT_MAX_SGE);
>>>> +    max_sge = max(max_sge, SMBDIRECT_MIN_SGE);
>>>
>>> This is inaccurate. ksmbd's send sge requirement is not necessarily
>>> the same as its receive sge, likewise the RDMA provider's limit.
>>> There is no reason to limit one by the other, and they should be
>>> calculated independently.
>>>
>>> What is the ksmbd receive sge requirement? Is it variable, like
>>> the send, depending on what protocol features are needed?
>>>
>>>> +
>>>>        memset(&qp_attr, 0, sizeof(qp_attr));
>>>>        qp_attr.event_handler = smbd_qp_async_error_upcall;
>>>>        qp_attr.qp_context = info;
>>>>        qp_attr.cap.max_send_wr = info->send_credit_target;
>>>>        qp_attr.cap.max_recv_wr = info->receive_credit_max;
>>>> -    qp_attr.cap.max_send_sge = SMBDIRECT_MAX_SGE;
>>>> -    qp_attr.cap.max_recv_sge = SMBDIRECT_MAX_SGE;
>>>> +    qp_attr.cap.max_send_sge = max_sge;
>>>> +    qp_attr.cap.max_recv_sge = max_sge;
>>>
>>> See previous comment.
>>>
>>>>        qp_attr.cap.max_inline_data = 0;
>>>>        qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
>>>>        qp_attr.qp_type = IB_QPT_RC;
>>>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
>>>> index a87fca82a796..8b81301e4d4c 100644
>>>> --- a/fs/cifs/smbdirect.h
>>>> +++ b/fs/cifs/smbdirect.h
>>>> @@ -225,7 +225,8 @@ struct smbd_buffer_descriptor_v1 {
>>>>        __le32 length;
>>>>    } __packed;
>>>> -/* Default maximum number of SGEs in a RDMA send/recv */
>>>> +/* Default maximum/minimum number of SGEs in a RDMA send/recv */
>>>> +#define SMBDIRECT_MIN_SGE    6
>>>
>>> See previous comment, and also, please justify the "6".
>>>
>>> David Howells commented it appears to be "5", at least for send.
>>> I think with a small refactoring to allocate a more flexible header
>>> buffer, it could be even smaller.
>>>
>>> I would hope the value for receive is "2", or less. But I haven't
>>> looked very deeply yet.
>>>
>>> With sge's and an RDMA provider, the smaller the better. The adapter
>>> will always be more efficient in processing work requests. So doing
>>> this right is beneficial in many ways.
>>>
>>>>    #define SMBDIRECT_MAX_SGE    16
>>>
>>> While we're at it, please justify "16". Will ksmbd ever need so many?
>>>
>>>>    /* The context for a SMBD request */
>>>>    struct smbd_request {
>>>
>>> Tom.
>>>
>>
> 
