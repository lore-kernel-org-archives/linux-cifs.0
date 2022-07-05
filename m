Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE2CC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Jul 2022 15:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiGEPWm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jul 2022 11:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGEPWl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jul 2022 11:22:41 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A479018B15
        for <linux-cifs@vger.kernel.org>; Tue,  5 Jul 2022 08:22:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFNSm6ODJKpCDkePSWd1Psw/s32V3Ab+/uVwVXJvzU4i4y3Fb3yeP9ttRFnppZ1DoZ9d3hgswZbl7kO0blEjKR/He/u+7WtgWilG0FeBQg8rl2hgqo2Bxhhqq6bBGOTbfDNW2LpsVdlnxRhS2ABONXh1aFM5n1aOjx70p1MczMLE7EK3nUxstuVOSDm+cAWE+OQQaE2tWAs9b428OYGSl3UvJsmWPvBZT4uSWExco0KA2OLuVNIuO5HYgIB8kLRZ0IN6VXsnny7TQu3+WKs9oop27ELxHcAJljo1L8Q6gFsAikHNS2Q1XAZwAgt0TLa53mR7thD4lu+T6S76fW9J0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LEczmp1PPE7PMSSKX+i+CMllMY0TqhEM3/MxLaxQwM=;
 b=Z1lqrkgD4IIZSOeVhR10usBPAJ2qN8mtVlJuR/FlqpxwYh4N1DrBO3MCITy1CCeV+apOO3/9nxWpMz4ZyfBcTt9/u3FPRquSk1BK5/Nhq/5TdFZRDmsyTALk87G7cOlCA8BfedZS3zbuLCgmKbBcJMKDy32D3mHUuWp9DI4dLQS9Zvjx+cbnNCpxvsGFgbyM824p7Go7Qt6Hc5x2QmMjlpI01nP3eCshysUSZLrE1b0YdDd6eL8kBKX8BWDfkTdHFvq8/PzWEIhESHpbTjQqEFzjlClzMV/13/QNN1im8bF7Wpfg/MUxSal2haXwD8w9d3pf/NRW8XtLcA4HJZf+6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4665.prod.exchangelabs.com (2603:10b6:5:64::14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.14; Tue, 5 Jul 2022 15:22:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 15:22:36 +0000
Message-ID: <ce681879-9e21-bf21-555e-1015b0fe7429@talpey.com>
Date:   Tue, 5 Jul 2022 11:22:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close
 timeout
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com>
 <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
 <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
 <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com>
 <35b03fb9-1500-865f-f67a-c24817531ca1@talpey.com>
 <CANT5p=qetdByFLOV0=1VXXa0xMukAggaDtjaQ=K0KH4upVRa1A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=qetdByFLOV0=1VXXa0xMukAggaDtjaQ=K0KH4upVRa1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5646e1fd-be72-4630-5b58-08da5e9a3085
X-MS-TrafficTypeDiagnostic: DM6PR01MB4665:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VCTpePAmJF8Jzxl9sv9jtzLbzQYh4159vQAocnX+rdMYR47o/4ucoYMPISyNA/lnk96zumcVvZy3pK4GnKyEJJ7OcD+g2M55AS3ulcAZA00hHZOMZbKCjIXBneDhXT/dnekpyT33GJ78ZKNRe5oQ8mkPBNvzI1mEi1PWqF7J3Z7Ztsg7dhwz1DOUAMElGJiiPdyUa72E0s7FmKVqq13S6vMIuw+tQkDGdc3mpf+HHQPKceL2zgnB+GeU+HbdMTMbhNghs3LUZPnXnFs/6tJxZ2XWy1qjxZ/P79PLIP/bSzCwM+GgtVN8rOjgZ8l+CFW2pK/BCQ7f9id31CJXkggABwjiFyRMDN1vVQocg3lLfV8JKIPHc1fmjmfW2QMdJQunCy8pZNFy8TiAAIlP3cG9VVRr1HGDb9+0uPdwA3IaF8UKB+uYN8QAE2hjtczQDU/HbiYzpHqtFbHu7XzSQaDNf1OdGGUnKMp9SKdT5IIRUF2pSBA4xfa5nNLqNAA/gXNshgyMVsUgl4vHMujRAw/xPVfcKJyjq84L/gPY8WPIT60h4bSP9fIylVEcI1Bx6fOtk4QRZkAtftQT3NkwjCKqxrxX+5dk2gnYonqCs5fBaT+rnG8kFHI6XnPH1/RV0Ct9/H9xxVQUw5SxnCRfuWHYcCzXX1mmj8866umvrNypbnq7toi84Kj2qqCm/kf64Q5oCauFNu0m3TztMrSygNTx77a2kHDFMdwg3NuUU3Znk8//J4ldNojbnaBvPpVLOF6RwefkrW7wp24wp67N+bgB9nhO5MPRNroDNvM94hK5wiklvl1I6QtkMKhtG/Kd5KAQ1ryYn0vo7RC/BkUHIbwyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(396003)(39830400003)(346002)(478600001)(6512007)(2906002)(6486002)(26005)(2616005)(31686004)(38100700002)(38350700002)(186003)(8936002)(31696002)(54906003)(5660300002)(8676002)(6916009)(316002)(86362001)(36756003)(53546011)(52116002)(83380400001)(6666004)(41300700001)(6506007)(4326008)(66946007)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmdoejZRSURRRXUwN1JuRHlWWXpUc2duc3Q1Tnlwam1MNk84SWZYdnd6eDJT?=
 =?utf-8?B?V2lLYUVObkpkUHJwVkFzK0dNeU9PYXdUUXFRRUd6aFB0WUoxdXRBVEM4S2VO?=
 =?utf-8?B?azdMd21UVnhoSUoySVd2enRaU3dmeFdQVlJuY1o4ZjJGVXdDR29VbnlUMjNh?=
 =?utf-8?B?eFppYUNyTXNPWDAvUmJndm5hbEF3V3dQdlk2cUlWS3lXbFY1Z0o3cm4rYkhX?=
 =?utf-8?B?TjNGWFZHWWtRVExIUlpldUhicnBDMVdEMkJqYi9DNkd1MlpkNXl5em4zdzRn?=
 =?utf-8?B?V0pRYW5qNmpMOHEvdElBc0xpYmtUL3FSQm5MMGkrc0lkNTB1b2NKRVlNTWRw?=
 =?utf-8?B?ZnQ4Z2RPVDdhTXBBTmtTWFc5S1VaZnhZS3JzR2ttTW50MzdWeTIzbXByelFn?=
 =?utf-8?B?THgxcDZwNHRURnJPSjlaeVV4NG15Qlp2OFZVWC92aEJOMEN0TEQrd0tLRjBu?=
 =?utf-8?B?bjh4MGw2aVd1WjU3Y2JyWUJpZm8rd1h6a0tsZzE3Q05QRUVRUTRJR0tpNFBt?=
 =?utf-8?B?TTlsTnQxUzN5NklYRGhaQXBDdFQyQWgrQlRYUFNkZ0RDU0VOWWM1RGNyUWNH?=
 =?utf-8?B?YXdPMFluM3V0aVEwS3g1WFJpNGlKYm04QXUyZEJPcFdIbU80QWhvMXgwS00y?=
 =?utf-8?B?ZlJSUENHLzV3eW5HWHpreUxpaG41c3Mrd3A1dXorZklQd05RblFMQWVhU0ZU?=
 =?utf-8?B?SVRIbW5jYm9UcmNUSjU4d01aTEtpR1RyQkZVQ2ZjMTNzYkd4NHh2Z2d2b2Fk?=
 =?utf-8?B?QnNYL2JJajhUSFZpKzdBbEtIWFpsaUFLMWl1Tko0L21RNzIxekxreXh1dFBj?=
 =?utf-8?B?bDFyS1RFbEJqQXI5UHQzS2RBQUxqK2o2UHBhMGNtMDh2RlMvdytWL3QvL2pt?=
 =?utf-8?B?QW4waFVkbE5JWWYySUwzS3NPOHU2S2pSQ3BkUVRRK0RwcEFYVWc0UEZLRGl0?=
 =?utf-8?B?bE9vcWVXL2lOb1BBVFV6Uk5CVE9DWVVXUGwxcUZzT0FKMXMyRW1TY1NHTFJq?=
 =?utf-8?B?K1RjY1kxaFBub0hVT0M3Y3k1KzFHQTFsbGRQU015ZklyV0hGYTVUVlpCU000?=
 =?utf-8?B?UHFtbVl1eWxOUDhmS0Ria3NGQ0RxT3QwSjhhSFIzcXkwTlNtQjZ3K3dpYTdH?=
 =?utf-8?B?bDlzZ2xZaU1rZlVJanV1KzM4bmEyQzI3bEZHTjU1aGxmWFN1TUZ4SXYzR1Jv?=
 =?utf-8?B?NHBJZmluUUFOVWlYbTd4QVhidWZTY1F3WnM0My9aMm1FNmt6Ykt3a2ZpYUhC?=
 =?utf-8?B?dnZMeit3YnEvTUtyNWo0aUdweTZFcTlBYnpwWVdxY01YNFBrOGR3MG1xNlVW?=
 =?utf-8?B?dVI2Q1Evc1AvUlBmdHhhUXNMdmFTQ3orTkppQXdMZUV2dmgwQ1lUT1RRSXlD?=
 =?utf-8?B?RTRLZlFHV2J4QmtsRWxKd2doQUk2SmxjZHMvVVY5VURJam15Q0Nid3hLQVkw?=
 =?utf-8?B?UG5hS3NTU0d0aGV6cnp4ZnltWnRJVzhhQ1MyR3JhcHFNdmtYMjVFY1o4aEJo?=
 =?utf-8?B?TG9VVFNjOE40SnFqQ1lMVXFaTVFmN2JPSVdsTCtLTjNaU29WWHZJMFJQTUhR?=
 =?utf-8?B?U3dLM2hIR0hCU3ZrV3BJQ1F0RkluQmZGZ211VFhHSDJjRzVCZTFGdUpPaTkx?=
 =?utf-8?B?QlBORERQVW5ReEt0MmNha1MvbHpua0U4UEQ4TFBFNjcybUp5a2k5dmNyNDhk?=
 =?utf-8?B?Mk1WODRLRjd3Q3B3V1A2WkN1VmQ0UkdFMUxsbGRIWUJyVEJOaDFOcnJ0OVdD?=
 =?utf-8?B?WGR3MGxRRzY4TFFzL2poaVJORndXdTNidERQNmIvQkl5NjI2THBwb0g1ZWQ5?=
 =?utf-8?B?S05hSWk0clpMZTNHdG1XaDUvMm85TmEya3ZNYk9YRDYwMjRzOG5Lei9YSXBo?=
 =?utf-8?B?cXdqbTZiUXZxUVc5cGtCY1JEUGt1M2huVDBMZUdoL0NPLzRzT2h1UTVCUmxm?=
 =?utf-8?B?cGtSYWVidldabVpNVktvM0M3YUlTQmxOZ0pNUHA5dFVPRWlMUUlJOXZENlM5?=
 =?utf-8?B?Q3JUU0lXK0xydGpZOEpuZEpIbW04TVo1YmlMSU9RZkJCb095RzNuR3E2akpM?=
 =?utf-8?B?N0c4YU8wajBRQURadnNOTklLbzRYWHBCTTYxNFpzV0ZjUEZFMXpkdzJoZTRE?=
 =?utf-8?Q?om2A=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5646e1fd-be72-4630-5b58-08da5e9a3085
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 15:22:36.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQ2MOm2Q9AJbe2WWT4J23nqhRfDCO5BhaQW/MP1/qxkdBn56J1LqjTvcAwWLzrqE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4665
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/4/2022 9:52 AM, Shyam Prasad N wrote:
> On Fri, Jul 1, 2022 at 9:00 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 7/1/2022 7:00 AM, ronnie sahlberg wrote:
>>> On Fri, 1 Jul 2022 at 18:44, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
>>>> <ronniesahlberg@gmail.com> wrote:
>>>>>
>>>>> On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>>>
>>>>>> On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
>>>>>>>
>>>>>>> Is there a justification for why this is necessary?
>>>>>>>
>>>>>>> When and how are admins expected to use it, and with what values?
>>>>>>>
>>>>>>
>>>>>> Hi Tom,
>>>>>>
>>>>>> This came up specifically when a customer reported an issue with lease break.
>>>>>> We wanted to rule out (or confirm) if deferred close is playing any
>>>>>> part in this by disabling it.
>>>>>> However, to disable it today, we will need to set acregmax to 0, which
>>>>>> will also disable attribute caching.
>>>>>>
>>>>>> So Bharath now submitted a patch for this to be able to tune this
>>>>>> parameter separately.
>>>>>
>>>>> Ok,  will the option be removed later once the investigation is done?
>>>>> We shouldn't add options that are difficult/impossible to use
>>>>> correctly by normal users.
>>>> We didn't intend to. We thought that this could be a useful tunable
>>>> parameter that the basic users need not even worry about, but advanced
>>>> users / developers could suggest changing it to tune / troubleshoot
>>>> specific scenarios.
>>>
>>> If it is just for developers needing it to debug specific issues  it
>>> should absolutely not be a mount option in upstream.
>>> Maybe have it as a /proc/fs/cifs/Debug thing or just provide custom
>>> builds for the customer when debugging specific issues.
>>
>> Absolutely agree. Upstream isn't a developer sandbox.
>>
>> I'll point out that this patch:
>> 1) Doesn't change any behavior as-is
>> 2) Doesn't give any guidance on values
>> 3) Doesn't update the userspace mount command
>> 4) Doesn't ever go away because it changes the ABI
>> 5) Increases the total number of cifs.ko mount options to 102.
>>
>> I'm not sure about that last one. It might be 103.
>>
> I understand that the concern is mainly around this being a mount option.
> So let's discuss what's the correct place for tuning such configurations?
> It could be a module parameter. It would make it global. But I guess
> that's okay.
> Thoughts?

Ronnie suggested /proc/fs/cifs/Debug which sounds appropriate to me.

Let me be clear - if the mount option approach is properly justified,
thoroughly documented and integrated into mount.cifs, I'd be more
inclined to agree with it. Your patch description doesn't give me
confidence it will actually fix anything though. Convince me/us of
that, too.

Tom.

>>> Once they become mount options they need to be documented, what they
>>> do and why you would use them and exactly how to determine what to set
>>> them to.
>>>
>>>
>>>
>>>>>
>>>>>
>>>>>>
>>>>>>> On 6/29/2022 4:26 AM, Bharath SM wrote:
>>>>>>>> Adding a new mount parameter to specifically control timeout for deferred close.
>>>>>>
>>>>>>
>>>>>>
>>>>>> --
>>>>>> Regards,
>>>>>> Shyam
>>>>
>>>>
>>>>
>>>> --
>>>> Regards,
>>>> Shyam
>>>
> 
> 
> 
