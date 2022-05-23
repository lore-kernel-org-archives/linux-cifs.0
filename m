Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBB5C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 23 May 2022 13:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiEWNpr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 May 2022 09:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbiEWNpp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 May 2022 09:45:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D875521D
        for <linux-cifs@vger.kernel.org>; Mon, 23 May 2022 06:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnLvGLonG4sKXmQv5ctMHSOrPtwx10ANLRUHhCD+APmvDLLMQBXq6KXANnIl4/9KwNKHNsdErQrqhwwPa/BTRcg+v2bq185UL/CvgFHbueiikh6HNQKDu9ERhwWdNrQ0PSYiVVNOhwy0h0R7UxAiL+8IdJFHwPTa5olloulNAyPMD7UKQgrjm5JV8Zr4qK307feDWLcoLxAWxn31JP2FU3qJSJ5/FSHSlexBq2iKRKhpBQ0a2GY6dsAilE2hNxEwcQeaQnpO0a1mGph1tPC2WRM6wvtKNJkG38BjtC4W3t7vptXzkBDA8iIoIl4qAuJZSMeunvha0sy246UInhZO3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAxYpsSYPYBYfoXG6KkNLbRta4czUZpTBBAFngKrhSQ=;
 b=nA7PwIeTpmwK69FliOrrECaHBYXuj998MQzWZAVEOF3ZYuiTBYvRcEJchib7ZD6SMUQAJ4WwSIMmJlBg6lJXgDD3StIegczxxY2HHNbUAVsqO/paFfqA0lYJEow9qvJOjCvz1RvY/sdpDHjvcCWuNVmqiM/cIU5g2oSBPaggUGnzITwxqk5pnK6QY17eHmi3NJYewbh/p6MBKMkSq9KcgGxQ3fU+KOVsLBBgCUOwRffGoupQRmI9xmVWwVN8Hr90lqbIx677gb0N/y4PDS9a61Wofl9999vCKiDx2HjYqnK+mmscBEZtQIWVlg36ffQHgmi1eygeQ6Gfk2Ek+muCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5288.prod.exchangelabs.com (2603:10b6:a03:91::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.17; Mon, 23 May 2022 13:45:42 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 13:45:42 +0000
Message-ID: <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
Date:   Mon, 23 May 2022 09:45:38 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>
Cc:     Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0024.namprd12.prod.outlook.com
 (2603:10b6:208:a8::37) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abe28778-b314-4461-15bd-08da3cc287c4
X-MS-TrafficTypeDiagnostic: BYAPR01MB5288:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB52883B5E4A6BF7C4E2867016D6D49@BYAPR01MB5288.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uxj2AEDGw10H+Gz5e+4d8XHMFpq8GVep6iA4j7RmW8WPOgjbwM+RjS/C9KRQWyNxvop2mzbQv/pfhtZcQ3ZVJpwZa2G64IJ1yrPiVcSb1HZLYm7uW8pw8eqClz/w73NRa9jq0mMGqGSpe4S61k9vlEMwoVfjQrSFyNPvTTxRa4NoDGHf0tANWLMI03+5HDb66UXI+DA+NNRRYmPKqD+z/rQ0TcguUx7CDscyi4Pl1qRte49rvxVlJEF5W5lOigDfb/DVamWFzKdmxfNZFCNeNbX2qtrZyhfOGQmndtHsKEtVsQtp/m7WeyV9DxEeKw27UWXaWH/ag0gNh9iOGU3k0Po2STeqd7uwNEb1p3dYkUYFr+Bk7jI+tza1p2V57XgZQ8q26Nss+IvetLxndmuF3joz2N0Fhf5aR4Ov5i0KpuhWqcMjDsPOFI94t7rRoEsbe8qeg+mvPI9FljgPBP/l1BBp2IMR+9H+7prRYb5QP8/CTeamm1cgy/feW8bp4wVDkNKIGdKUGleg0YjOOCjfMywBiX5/gZEDliRwHldJK3kPFPYae9Ggnvee71CenhLklRzPE16jiDZq5Ck6YlpBWpEPJRaBLWbGtHihDZpca6bQW1Vlu9IbAdFAy/7BWValj0R7WXqDShjxbReQGEYYioeqd+/ONUBaHfLlm+j2bU1RKY8fPclTqFICfLRU+Xgs9v6M1xRfQElIMZ5rTBcLk/fJfIU2Mah/Ae9mv2D+ek=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(136003)(346002)(376002)(366004)(39830400003)(5660300002)(8936002)(6486002)(508600001)(6512007)(26005)(83380400001)(186003)(41300700001)(316002)(31686004)(2616005)(52116002)(2906002)(6666004)(31696002)(4326008)(8676002)(36756003)(66556008)(66476007)(66946007)(6506007)(53546011)(54906003)(110136005)(38350700002)(86362001)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXBuSnRSaU1IcUxxckcyZm1ZcVYvWVNRTEZ3cjJUeEVXaWlzSm00MWFkbVBk?=
 =?utf-8?B?bno1OWVva0lkdUhXanZXRk5FTEg4TktYbG1lUGx4cFJUZHVhcXp3U3dqR0gx?=
 =?utf-8?B?SmJpUXdaWXQyN2NrRG9GNFRsK05HWDkrT3l3NFhJMG4vVEhxL1VNaWhRQlVh?=
 =?utf-8?B?dFYyMnBOWmlvb1VodTlJUTkwL1lBeFNNbUdGdmpiUzZjMnNyT2tIUjNuQ3JN?=
 =?utf-8?B?UlBOTVVPRXFoaVNwLzFnMlJDZy9JQk5pTFBlSUtveHlHWTQ4elU0dUZJYWpI?=
 =?utf-8?B?bFAwbE5UQTZjRThjOG9rUnB6THZmZjdwQ095YVVRem5ueXF1bnJhaTJqSW9V?=
 =?utf-8?B?TW1sRlVuR2NjWDhCb1ExZmtKaTdrYUZHTWJIWk12RzRSZHVJU2xxdGNXcHFM?=
 =?utf-8?B?Qnc5RDJ1eFNWUDhiaUlKTndRVzRVTWJTSWlJNlU4SUExQU9uU0ZmZmUxV2Qr?=
 =?utf-8?B?WnBybUxWS3lwOU9WamhHRTJGbTdnSEdUSDJhTEhGekwrOGFrT3hkOUdmK1o1?=
 =?utf-8?B?eVdDQzZGc0Roa29hOUZhVjljSXpqNGRYL3htMG5hQStLM1FuUVZmZzNQNWFQ?=
 =?utf-8?B?Q24zOVA0ZVVydDlKVTVhcFR1NEVjNGhRenZyWkI2Z09yMm5JM003NjRYTmZC?=
 =?utf-8?B?UHlEckVBUnhMYnBTcVR4KzNvOWJaZlBXbmVGQjRNT3VoWHNSRXM1R01zbUlL?=
 =?utf-8?B?ZVF6NWxsdWZYcDNaMWZqUFhqSkJKV2JvMGZ1Nzg2SWN6Z3BIMzRscURzOWZo?=
 =?utf-8?B?Rng3b1RMM20rNzNYYUxSU2o4SFBPdXk0eE5QRUhObG1LSzFaTzRrUkV1c0JD?=
 =?utf-8?B?cVR5S3JoeGFSbXRueGJ5WkZSZGdkSUdXbXNLc3h4clVlSVdhVnAweHl6MjhK?=
 =?utf-8?B?SGxrQ0JibnEzK0pGR3ZCUE9UUnF0dkNnakNONnBGUXFFTUIxRmtZZ050dmFu?=
 =?utf-8?B?RHJQNWxGSDJZRUJNcXp6TWp4RjhlMzUwckJZVEZqcTBxZEt5ZXIrTXI1ZXg3?=
 =?utf-8?B?ZVJSWEQyZ0tqK01PVVhiUElzazU5bkVySnBxTnQ0alhrdlp3cTY4RFJoYW5z?=
 =?utf-8?B?VVlGWGlybFdmdDB3cyttdTl5eUdyUUFNMW5IbkJWQ3FlZGJ3M1hObVBGRGxX?=
 =?utf-8?B?eUZtNnh1N3Vyd1RYN3hRNDh1Q1poQzdOVkl2QzFHZEZ2YzE5Q2ZybDYvMHJl?=
 =?utf-8?B?aVY3YnVCeE5Yb3JpVmozNVRZN1Q0OEZEeGk4MjVuQ0hidDVEUEdZb3E4VjJs?=
 =?utf-8?B?YkFoNkM3WHZ0SGhhd24xcldqeXFTK3JQYUhZdm9BNUdYUXlYUDB2ZDdHRHJx?=
 =?utf-8?B?akJLOG12VWh6RVhUZlpKc2V4QmdnWWRtQWk0cDFER1ViSGEzQkp0c3hkYUpE?=
 =?utf-8?B?am85cml3NG4wM05yeFhKRE83V2Q0aWdSRXlXMjhzbmdOOXBkc0lTYm9tUmh5?=
 =?utf-8?B?SU5GU1RXa1FvS2piYU0xQ1FxUnAxZUQrYU90SkRhbXQ4WXpFVWo3U3FKWWlr?=
 =?utf-8?B?SnFpbVlJQXVYQUZCQVpPSzc2T0orUHU3V2ZvSFdMTW1TZTEwTFBIaUx0SVJl?=
 =?utf-8?B?YWNCY3VsdUgxa3ZnQ0c4d1BrZmN5SFRvUkJOb3p4MWV4c0xNMk12YmdoTFYr?=
 =?utf-8?B?RTh4djFYWUFrZThuUHQzV3BtWXhGb3o3ck1KS0hwV3ZVNDhxWWdEd09JNm85?=
 =?utf-8?B?TzZaTU1RVUY3Q3V6Z3JBQkFyeWI1RnVBVmZsUmtaWVlkNFpPS2RXMHowMEQ3?=
 =?utf-8?B?cWQ0QW5na0g2ayszcnYwRU54M3dIL1FYOElpL09TRC9ZYWdJWjQ2SkxseUdq?=
 =?utf-8?B?QzBtWEhHNkcyZ1RTbEpNWG5lMHlkNXB2cCtnaERjZ2ZydUFSNVlvOXdzL0dw?=
 =?utf-8?B?RWx1bUFBaU1OQU04SzZ1QmlBUzRjQmo3bDRESjFwdiswa3EyRmRhaGl5aXow?=
 =?utf-8?B?c25US3lMb1VMV1NhNEpHT0JiNEV0ZUd6M21rbjEyV1c2THVqRXZSWSthTXpD?=
 =?utf-8?B?WEx0TVZ2bC9URm5jYnQ3aWk4MG9FSk5EbXJ4MzBSL25OM2FIZkl2VDBWVFVL?=
 =?utf-8?B?R2FPTm1ob2R5cjR4dzlHOFN6TmlMek9sdkRZOUNmOUNFV3JJU1hiaXFyUDlW?=
 =?utf-8?B?QUIzQ1pldTllZU13N25JS1Y3bU4zV3hWWEVpOUtTWTRTa2wrd3ducXdGUEJF?=
 =?utf-8?B?UkpVdE1kdmRJNm1nY2tTNWtKMExpK2FBdVFNSnFWODhpTC9MdWttbkc1NXVm?=
 =?utf-8?B?cnlVN09UQ0t0b1gxbU9KOUlVOHJyMFcwd1ZqNDVaZWJWWWtTS2cxZUxqcjlE?=
 =?utf-8?Q?m6m89GKSHQCubs12tR?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe28778-b314-4461-15bd-08da3cc287c4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 13:45:42.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0f20GCe2Euc3hcZ840kz3rISxnqL8FdeuMa1p0rad6BuTNiQJB8E2fGaeqCRGT0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5288
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/22/2022 7:06 PM, Namjae Jeon wrote:
> 2022-05-21 20:54 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>
>> On 5/20/2022 2:12 PM, David Howells wrote:
>>> Tom Talpey <tom@talpey.com> wrote:
>>>
>>>> SoftROCE is a bit of a hot mess in upstream right now. It's
>>>> getting a lot of attention, but it's still pretty shaky.
>>>> If you're testing, I'd STRONGLY recommend SoftiWARP.
>>>
>>> I'm having problems getting that working.  I'm setting the client up
>>> with:
>>>
>>> rdma link add siw0 type siw netdev enp6s0
>>> mount //192.168.6.1/scratch /xfstest.scratch -o rdma,user=shares,pass=...
>>>
>>> and then see:
>>>
>>> CIFS: Attempting to mount \\192.168.6.1\scratch
>>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too
>>> small
>>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too
>>> small
>>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>>> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too
>>> small
>>> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
>>> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too
>>> small
>>> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
>>> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
>>> CIFS: VFS: cifs_mount failed w/return code = -2
>>>
>>> in dmesg.
>>>
>>> Problem is, I don't know what to do about it:-/
>>
>> It looks like the client is hardcoding 16 sge's, and has no option to
>> configure a smaller value, or reduce its requested number. That's bad,
>> because providers all have their own limits - and SIW_MAX_SGE is 6. I
>> thought I'd seen this working (metze?), but either the code changed or
>> someone built a custom version.
> I also fully agree that we should provide users with the path to
> configure this value.
>>
>> Namjae/Long, have you used siw successfully?
> No. I was able to reproduce the same problem that David reported. I
> and Hyunchul will take a look. I also confirmed that RDMA work well
> without any problems with soft-ROCE. Until this problem is fixed, I'd
> like to say David to use soft-ROCE.
> 
>> Why does the code require
>> 16 sge's, regardless of other size limits? Normally, if the lower layer
>> supports fewer, the upper layer will simply reduce its operation sizes.
> This should be answered by Long Li. It seems that he set the optimized
> value for the NICs he used to implement RDMA in cifs.

"Optimized" is a funny choice of words. If the provider doesn't support
the value, it's not much of an optimization to insist on 16. :)

Personally, I'd try building a kernel with smbdirect.h changed to have
SMBDIRECT_MAX_SGE set to 6, and see what happens. You might have to
reduce the r/w sizes in mount, depending on any other issues this may
reveal.

Tom.
