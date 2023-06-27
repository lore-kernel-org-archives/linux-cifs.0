Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93B0EB64D9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 19:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjF0Tke (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF0Tkd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 15:40:33 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A234B19B0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 12:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1C0WlGQY2fPMb3DTihQwcbYwXN33z2k0nrciPYpgBUGvEiF9UhhSY9NDr9puXy52onDaM8af6dbkjZ2EHz28z4S2gQ/5GnuUr53Xz5OEUi0fk6yM4Qu6DikEmkhRF56mhUMQwk+6SRpE91AoHv3ENFI3pHfz1PgIsd9UMj5rqfbadtxUldIapiBRtFIKXv3rwKfOhrAwxQSrebwH1nA/nrm9V1izqI0M8a3xfOyL4moFgNL4GBiEWTf8rululaCHU2XelA498a8zYydATypm5hO9KbrpzgpyUQNQQMV5D365wPxAOh2nNIlzHAlMVcDhEWl7Dsg4O/PsV3FckPj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tALt0xKEGbNw2pvRmTWiVZCgbMT8zjdP9Xis1L4kIRI=;
 b=W4b+k4yfu1M6jcrgd8ELYrw5RLoK3N6NyTX1/i3ofH6m0atjnJzzxPWwRvZ2m5u3kRRAEdak6qR/8IE/oQ92WG1Pk6m0+odFgSJ7pfwIgiNUjmeJFq00UIkj/+AkyglUUi7rlhw4gPXLPZ/k9okbvmZyF/xhx+VVc4tD51JG+a1hx2mVci0wkSc0XYCmvp9SaPPx/FYNzKgagskR6h9NInu3M9mPvwnggCX9Kt7XjqRexJxjGrR6XDkkL0MIUcY7f/qBv/gecFF1Xy/milYtCsXjYN9SJ+qW/Zl6db2Z2K+XcexGhAsWCoAhuY4DyMrh43ML1oRQo3UATIC51WScdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH3PR01MB8492.prod.exchangelabs.com (2603:10b6:610:19f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6544.15; Tue, 27 Jun 2023 19:40:29 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 19:40:29 +0000
Message-ID: <10914d74-e302-2430-8497-8532fae0348f@talpey.com>
Date:   Tue, 27 Jun 2023 15:40:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/6] cifs: add a warning when the in-flight count goes
 negative
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-3-sprasad@microsoft.com>
 <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
 <CANT5p=pa39qfZxu0jDp01L1AtvQTqoGdk1cB3jwq-rGOY-2+hg@mail.gmail.com>
 <9a9b5fc2-8905-7169-90d9-d0ee3454f5a6@talpey.com>
 <CANT5p=p62mGd8uwgNEHeAa9pEnC0TcJSx-pXDCwzFSCaX16O5g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=p62mGd8uwgNEHeAa9pEnC0TcJSx-pXDCwzFSCaX16O5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAP220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CH3PR01MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab3f1e0-e124-46e7-6a51-08db77465d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHOnpaEs2LFy/1RRgZ83zVH43ZwFDNe9cas380ut6H4QOIh1hcietTjH8uDcIR7mc2hfo18NFVMGHO0YKoihtkabYHY6ib1qqi9/ynNOAfiY7KSXGv+r6YmGln8S+0vkC+B4oDk8o+fEE/pYt3qg4LUPw57NLoKX9C4P5leVc/S1+EenJ/bqwlejiPeiypbTEuRONxqKCECnPdCVu3IvH1ffuijF4MnDpaGyi/boMmXrpJL/fxWmOu7k7X+71Ms7ce4J5ftNnvwbLvJY0vPW8uLfefcVQlqzDqiHQwz4oYx9zFnpa77l4eJ6Hx5IZ42uEYNnzirI/kF42Brn7ioZhvfj4CNMVaaepqsygz1XYAAy84imm4PoBBfb+cLVWUSeVmojKswaMFJwGjea2qidhVI1ND6aFjJr/+UJvzpp0Rha27biVDE1fNtiAu6fclVrU9oQOdA01v+Wj18AbbVKPsMt0Ip4JmSaIl/txZQitxm2hygKrNufmoBEUbBBti5k+Xve+LXOOtm+b1odhYVLEa63Y5xo/oyodym3XQSC54+OEX/R/FDsHhB60RFXp9KnWOYzxF4iFh1jrlJsbHRQe7TamMFsPrnpiM84HJggNec81KY/LJTPXXqO08DRB4ZVILFJmHtH4ReBetzM4ZV+tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39840400004)(136003)(346002)(366004)(451199021)(83380400001)(2906002)(186003)(2616005)(66556008)(6916009)(66476007)(4326008)(66946007)(52116002)(316002)(54906003)(478600001)(45080400002)(5660300002)(6512007)(26005)(6506007)(8936002)(53546011)(6486002)(41300700001)(8676002)(38350700002)(38100700002)(36756003)(31696002)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3ZyU2dUdmlweWpWSnllRFZRTWtrNVV6ZFdpdDNQWklMdG1Nb3R4OFU5MUJi?=
 =?utf-8?B?amo5SEZhQkFtb2JqdjltMTFuL1I5UHA1WWxyU3VaY0lTdmpWUUJjZ2dhMkxQ?=
 =?utf-8?B?d3Q2QmFOczRobmJEalFTS1hiaFRId0dtNFVOcWRLOWJiaWsrdFJkalhaWnlD?=
 =?utf-8?B?cU8vWjRPWlFxc2ZjZHRUMGtpRDJybUdsMDhWT1oxR0pWYkJDdGhrcmgxd0xZ?=
 =?utf-8?B?VTIzUXlYZWc4UWZLQSt0eFc3MTRCRVFpU3N0bmdObyszMitReE4relJzQWxT?=
 =?utf-8?B?ei9lYkFHbHRQd1hWNmpnYVJCSFliM2dqT214aUg5SCtkeU9reFQwT2l3UE82?=
 =?utf-8?B?K05VQkJ6NUdPR1ZlYWJxbVhsUFR5UzVybk0vRjVjNk9FWEF3RlpTd0RxSzBs?=
 =?utf-8?B?dHk2bFp1KzdxbTVxd1VERDRZVUdIbkw3QkJVWDByYmtiR0tkVmYydWdmWURq?=
 =?utf-8?B?SWpEMzBNaFFmZVlxcFhaenc0VWtjYXdySDhaTXdDOWYxNWp6Mm5xNWt5MHFO?=
 =?utf-8?B?L01yOUNWUklsTThXSmF6QUROL3RIY05XSS9OZ1pIbndndHN3Sm5ueDl3aEhO?=
 =?utf-8?B?aVE5djNTa3dzS1VJU3MwelFDTTZ4cCtVdzRWQ0F1TFduYjArS0xCcFNsUVpS?=
 =?utf-8?B?QllYWjNNMUZwTWs5WHZNVG5TOVZhcUVURXZjY1VGbXp2eE0xemV5WmNJbUxU?=
 =?utf-8?B?SStFUDZqWmR4dlIrY1FKZ1ZIZ3lieVNyU0JvMzVvZUFjaEFEcjVwaU5Yb2xt?=
 =?utf-8?B?NW1Pak5Ua0ttc1J1WFAyREhVYTNtYm1NSnl1ZVd1NHhyK0NoZmg3M2JISFVz?=
 =?utf-8?B?K1ltQi83YmMrVEVNMS8yQ2RxSm1jTko4ZllMaHRKWEhFYjg5MnpCcERPQmF5?=
 =?utf-8?B?b2FmajkrZ0FUcnVyUE83Z3VYaHdXLzRHN0UvNVZuM2FINVVsYnpXWUpzV0pV?=
 =?utf-8?B?dll4SnRlZUhOdHY5ZXhBOG5zTDNKUHVHVU5WOUQ2RmpmbmJiUy81L0NHaGFo?=
 =?utf-8?B?cld6elgrZXdkejlsUVBhdlp2cDByOUpqSnlQRG9tMi9iMFFNbW91c3NxSWs0?=
 =?utf-8?B?NFZmR1loVzV6SHJlRy83cndHa0QzUlhtWHBhM3N3Sno5cDAyYXE2eDRRVk1P?=
 =?utf-8?B?MDZ2UTNxelBNTUozdERUeWVWcEpqSWlldEZ0SUh2cmRaRjArVUh2a3RBU2VN?=
 =?utf-8?B?TmtrOFVhMzVCUVZhTTZraHh4SHdiTGlZc1o3THNTQWpmWUVxMXZBQWlWMEtl?=
 =?utf-8?B?QVZkbm11VlBSUkpzRERLWjZ6T0gwL3N3N0NOQ3V2bFdrOUJSTG1FTkhEUXMx?=
 =?utf-8?B?RngxMUVBTjhEWGgxQUo1RS9ZYm9nTktJSldEM0lSZkNKYng2SVllcjFCTWwz?=
 =?utf-8?B?bUhyeVo5Q1B0bHVsVWExNjYxWmw2M09abTdXbTV3N3pkZkhPQk1hZmtmd1Na?=
 =?utf-8?B?UUJtLzE5OXZtSlh2MnRKQzFCRmo0bEcrR1dmU1o2dFRGaGJGbzNZMWlYYjlQ?=
 =?utf-8?B?R0dGNnR5M1NzaXBlL3VWajkwY2xCR0pjQy9LQW4zdWpmNENSWllNQlhJWnB1?=
 =?utf-8?B?Yjh5R2d4TlBXOHlwZTMwZHY3dVJHZnpTUmlYS1VLaUVHTWdkcU5TQjBVY2M2?=
 =?utf-8?B?K2hmeUxpczAxYmtxalVuaU05a0dUS3Nsc2Qvdk1xN2RiZmtPdnlsWFpLYjZ0?=
 =?utf-8?B?K2YwNy9obGJUWldzU09wWVFiMTcyOGdmcmpvY2l6U1U2MmdSaFdWVUdDMHpt?=
 =?utf-8?B?cmliR3BDdGJ2MldFZ1dGNkRDR2NYa2lFbS9wQ0RZUmJGR1R3OHB6ZldKcSt6?=
 =?utf-8?B?bFl4emRVSnJjNHR3WjlKY0hzVWlEQ0hSWWtSWEN1S1B2aEpaaGd6UmFIZzkw?=
 =?utf-8?B?MEJxQ3d1a2Vmbk9KVDhwOU8wQm0wWVF1WWVBSXl2Q2p0U1hKRUUyVjFVYVNZ?=
 =?utf-8?B?N0tWRyt6OUV6QmhKbzBkWmNDeXloOUE0NWYwbzg3UzdnRTZzYk55bmFNMTVB?=
 =?utf-8?B?RkhsVHR6dWlZUG11VElzRmRSbGo4NVczTGlOZGdaR2FucXlMWDROMjBKbkdF?=
 =?utf-8?B?MFNWalU1dTNJUlIvVzNub0hmWWZsMFp3ZWNNSHNtOEpwQ3J3aHA1WTZMTjdh?=
 =?utf-8?Q?Sy91pHD1MhQ8e0p1xjpPmKr+H?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab3f1e0-e124-46e7-6a51-08db77465d12
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 19:40:29.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UK2BhkQrlKWm6/dHYF2152JoN236j3i0oMx3FIPyITIuMdj11KNN8IF5juPlWFs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8492
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/26/2023 2:33 AM, Shyam Prasad N wrote:
> On Fri, Jun 23, 2023 at 9:52 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 6/11/2023 4:01 AM, Shyam Prasad N wrote:
>>> On Sun, Jun 11, 2023 at 1:19 AM Steve French <smfrench@gmail.com> wrote:
>>>>
>>>> should this be a warn once? Could it get very noisy?
>>>>
>>>> On Fri, Jun 9, 2023 at 12:47 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>>
>>>>> We've seen the in-flight count go into negative with some
>>>>> internal stress testing in Microsoft.
>>>>>
>>>>> Adding a WARN when this happens, in hope of understanding
>>>>> why this happens when it happens.
>>>>>
>>>>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>>>>> ---
>>>>>    fs/smb/client/smb2ops.c | 1 +
>>>>>    1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>>>>> index 6e3be58cfe49..43162915e03c 100644
>>>>> --- a/fs/smb/client/smb2ops.c
>>>>> +++ b/fs/smb/client/smb2ops.c
>>>>> @@ -91,6 +91,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
>>>>>                                               server->conn_id, server->hostname, *val,
>>>>>                                               add, server->in_flight);
>>>>>           }
>>>>> +       WARN_ON(server->in_flight == 0);
>>>>>           server->in_flight--;
>>>>>           if (server->in_flight == 0 &&
>>>>>              ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
>>>>> --
>>>>> 2.34.1
>>>>>
>>>>
>>>>
>>>> --
>>>> Thanks,
>>>>
>>>> Steve
>>>
>>> Makes sense. We can have a warn once.
>>
>> Which sounds great, but isn't this connection basically toast?
>> It's not super helpful to just whine. Why not clamp it at zero?
>>
>> Tom.
> 
> So there's no "legal" way that this count can go negative.
> If it has, that's definitely because there's a bug. The WARN will
> hopefully help us catch and fix the bug.

To be clear, I'm ok with the warn, it's the fact that the code
goes to all the trouble to say it but doesn't do anything to
recover.

> We could also have a clamp at 0. I'll send an updated patch.

Sounds good.

Tom.
