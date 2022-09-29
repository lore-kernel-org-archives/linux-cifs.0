Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E1DC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 15:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbiI2PPm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbiI2PPk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 11:15:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9512C12FF32
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:15:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TCrc/dq99+KuZXMs019AEGNjNfrsnCjeZ6N8Ym3/S0qdA+fQ3C0DRkHw8zEa1fNv9wOjIEUWj8mlvdKvy0G0i1j14N2t4JE4o+J28GHvnFsqzGC1RWXVWNbGO6RO1oj3NX1921M0S+1N895K1mS73gnVpQJRjERUryteCBik6ypxJajaNiwm9/nRJDC8iEyZ6dBZ6JpxGIwYPHXQrQspCRqA99BtNPES3ViX1Nff3bLXdgA7L+cqbTk+l1lFztdbTBeUJgR/8zpJY3OAeCdI3p2PIYLDjO0qLw/gaBAAaOdbbcOChrwVlOmUgBhY66CE4KjWzfkHlebhzJDRy7JNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7CVuvii7qqRYfBxchirWm2356dl1aU5gk9jh4WrG6M=;
 b=d50c0gswwoLBRfLS+UGVWfURvfqvzE1BZvJGAz8ps+66NjHiWbiDrUyjr4MMgJYxc0DqquzQBizLEX0o4PnynAWg700tgKQOSQhsTRGFQNgegYtoNwtqOmqNrGuMTJ5i63piIjcwPCJ1uf4v0S202vmfyJWInDi/yhmAwPxKjit/fd5/za4YktaI4E+2UwNUzildbaGVsTLSN1qsFW7XwEr2h6pa9l7DfIR8LOw26xKEvnCpwuQMCGLWD+6f1HFtiSK2aLFVigKbQXJZXfgV8m45sNjo8CA/DzKfD8dUW90vQdFIbG7otBwK0EhlJ8DFfMBEllB+/0/kbs21+b+rRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DS7PR01MB7733.prod.exchangelabs.com (2603:10b6:8:79::19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Thu, 29 Sep 2022 15:15:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 15:15:36 +0000
Message-ID: <c4273f7e-6024-8f1d-5514-39501fa9943c@talpey.com>
Date:   Thu, 29 Sep 2022 11:15:35 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 0/6] Reduce SMBDirect RDMA SGE counts and sizes
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, linkinjeon@kernel.org,
        senozhatsky@chromium.org, bmt@zurich.ibm.com, longli@microsoft.com,
        dhowells@redhat.com
References: <cover.1663961449.git.tom@talpey.com>
 <CAH2r5msZ85dBBU=rPyzgBOPJmMrJ2ACCG+DhrJJprvDJcr9QPg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msZ85dBBU=rPyzgBOPJmMrJ2ACCG+DhrJJprvDJcr9QPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DS7PR01MB7733:EE_
X-MS-Office365-Filtering-Correlation-Id: 86c37c2d-7fbe-4ecf-cb2d-08daa22d7606
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyCLWyFy6SfTEx07E5dBEAN+gn6ASeLHWaenGcpw9AJf6OK/pJN7XQjqMJbr2xvqxbar6DXAij5h0trDW/7JbgjfmrWx6IHYorA6DIwONQbUAcyMaGgJ7khTKdGH329RJrUb+9zhIbaL7W8Guk1a0X0iLpHTGvJCTyaOSJ5wgJBxpxuT983mV7WXp0Q1sZ1rta0N5Ybf4HMRKe8LDJsxA68n/ezWhIIZxUP79uy/ETqDLcBDqFitK16t8OkL2cY54cx/edWutKE4lZK5nqMi/3C59DHKzVWVCY+pS1oNlSlH1qIn/tVuN1qGZB2vaYFrSQ8q84mVgVQMSukmCu6VLnVIpdtm4zxaUCyZO543kuFY6B1/QMBXHdYXeMet6gDerOQXPSddgpS1phVsB+RolGZ8VSrn5f8Jco0lWwMb0H4QxWV6k0z7fDYHMdPYV5dl7raLR4o2O95upOrsFQYt6SbGYjABA3YAw6XYyNv3CWoRNUBlv2JAunbCy0anHhupo6XuoVbj2JTthj41/gp2JUg6iCaw1ubtPyWuEfrVxaFzLlicPj8vfhx/UKkJgQriMGKtKI6vRMMbZxUjVd5EYnmXbbo871+Npvl+Nvi4ku/orkt69EAqITKTIMcVOsf85n4OKJlaytaz5dnOBbmhV7sjBKpe7y/vKMYyYx7auyt6DaT6s7axGmL2EcL4cm7n2J5BdKwkZekUtbqld+jNyZnAMQ7yYFFJKJvbLxC3eMFBIxa9/97O7hHD8UZCRcCezCBhyaozeJSddgeIsQz0Mgybc7OCGX9Covwr2ADTsgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(396003)(366004)(39830400003)(451199015)(66476007)(66556008)(478600001)(2906002)(53546011)(36756003)(6512007)(26005)(6506007)(5660300002)(186003)(2616005)(8936002)(41300700001)(83380400001)(52116002)(38100700002)(38350700002)(66946007)(316002)(6916009)(4326008)(6486002)(31686004)(8676002)(86362001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aW9vMjdjQy9JNEhOaGFRd0E3Q3ZLSXVZRytzTG5kV2c4QmFXUXNDQzl1Uk9H?=
 =?utf-8?B?Umx6QzByNjVRWVFhbEtNWHI0KzFUT0Z4amJUVnJhVnZPNm1oS1dkT21vMCt2?=
 =?utf-8?B?aEw1Wi9tVTM0Y3FHNXVTc25JUmhkTDdWWjB0UDZTWUxCUGFoaTRPSmlXMUMx?=
 =?utf-8?B?Z2ExYi9MVFc1WExxOXpOWGxHZzJ2aE1zRXBDY1pJQzJNWXkxWDVPOUplT0RU?=
 =?utf-8?B?ZlZZdWc3RXJuVUlWelVDL3J0Q2I3VnZ1ZzVIK1pjY0NtSkxhZUUxemtDNGtx?=
 =?utf-8?B?emM0SU5nTy8xamxHNmZpeDE0OUt3Vk1CZlpOOGlxU0dqY2dadmo1Z1p6QUkv?=
 =?utf-8?B?ZHVsaVFZTjdSREVqNW9kYVVYMW9YUWJxNXhxYmpxcEt5YUlQQ2wxZVVzMUhX?=
 =?utf-8?B?NnM3bWJuUE5meGltaXRaZng0MUJSaUl0SksxVVM4MGU5c1UxejJiaVhEVHZO?=
 =?utf-8?B?cjgwRGhsbFg0b082OW0wVGk5U1g0K0RwK1djWUxRbFhtdG5mcWVRS0toUnk1?=
 =?utf-8?B?UVJmVlRubkpCeVdtWlBQazFmRjdKdTMrem53T3ZZSXRUaFBManRib3czT0FL?=
 =?utf-8?B?V3lCZzNBYWZHMHZQWUJUbGl2dE12YjMyaEZlRHFVQThjZjhvczVRTy9keHZC?=
 =?utf-8?B?ZlRnS0FDTkIxS29GZklGbkRCeGNFTHNrTGtTRVd4bnF3L09ud3dtbVVHR296?=
 =?utf-8?B?eFdzcC9TTEN4bFIwa000Ykg3dTl0L3UwLy8yUWtYVjdWSVFWcE80ZGFBSkRY?=
 =?utf-8?B?dUFTbG4rMWZiblhjTW1MTEtQNHNwanlpT2xheTdaMXVaODF6eEltMUJlOGVL?=
 =?utf-8?B?YVJaRjljbzgySEdsZGdkODZvelBtUzVBdm5xMUR6dkxYQ3RWY1FyMEY4UDBa?=
 =?utf-8?B?Y3dEZ1o1SU1BampTZFdicURGbFJqV1RaUU1LWXVvYnVSZHFzZmE1YVFGaERr?=
 =?utf-8?B?WWk5REkycFVjZUEzNUtFbnlRa3QzMDhZMnlyS1g0dGh1bFVYczY4Y3F6L1hy?=
 =?utf-8?B?ZFRZWHFuMVUwTWVOa1c2KzJLNk93TTFiaktaUStaSVBEN0dUV0ZGbUxEWWNE?=
 =?utf-8?B?Sk9EQ3ZUQ1BocWU5cFFsREdCYTc3YU5kam0zMzdHYmM2L2pVb2k0d1ZYWjlK?=
 =?utf-8?B?YUlYWlJkcUM2M0FOdUs1TnloV3RNUUZ6aktNMGdvQTdVRStJRHdZaFJvVi9G?=
 =?utf-8?B?Zm9CRDJVVVplUE5kVy9mS3RJcDQzdVNTMkVJK3Z3Z0lMRG5vR2xTRTlFNTJu?=
 =?utf-8?B?b2g4TGpEZ3NDUzA5K0gyaWlsMUFJNlpEakxIeHpsQjZ2RVQ1VG84WGh4K1ZL?=
 =?utf-8?B?VlI0c0FFbnlJNlVhb1JWcENkNC93Q0JnU2dYM0puOWhadlUva0l6dTVvVk1E?=
 =?utf-8?B?cEhNaEY5dUhEQkgyam5lcWo3ejRNenVBcUwvUWVKYnk0VWFUUW8wYWx0Vk5W?=
 =?utf-8?B?bm9CSTI1SkdVZnJ3NEFtdldXQ1kvMUFJbVhLZ21EZ3lPTVQvdnpHUTdhK2xx?=
 =?utf-8?B?KzVvbmFGVWlDcmpjOElBTkpRWFl3akowVERFNEFKd0R0eklKS29JYWtkK1li?=
 =?utf-8?B?Ky82ZkFsZlJ5SElRUUdCYUhFcTdjVzRIR21qeXdXQzNBUk1ZZkRwcncwTmdH?=
 =?utf-8?B?T1BkK25Nd2ZsZ2ZieTBhY2Zla21tdVRqQkdxTjlzMEhzWWZjV2RabmYvRm1W?=
 =?utf-8?B?alJpQnB2RFBMUHprN3AralF3TGxjcTl5RGxaR29aZmJtQ0lqMWZ5SURqN2k2?=
 =?utf-8?B?d25ZNWdKeDQycTQ5dEpVMnY0c1F3UHhpcmVYNll0VVB2TWFZeGhnTmQxcWRo?=
 =?utf-8?B?Tjh2Nm5EbkhYcXNLM2ZoT2tmQnZWT1Z3NFFHeFZqNGcwREhXaDhUdTdSSGo4?=
 =?utf-8?B?UHJiaVBEbFRDNGRUM21uM3FSQks2cW02eHJidGc0b2VreG05Wm15KzhXREIx?=
 =?utf-8?B?eFFpdlFPbmwvbk16SHdZcTE1cHVTVSt6R2c1TnRSL2xYMm1QVUNDTnhYUHNz?=
 =?utf-8?B?S095d3RNeUNhWGhXNCt4YU96QmVFamFCUDJMYXFGU2RjMFZwaGIrNVpQb1VG?=
 =?utf-8?B?Y2FzRU9yUDVsamFlUE1Ca1h4U3BNMk50dFZIMVUwbUNyRVdTdFFCL2Z0NUV6?=
 =?utf-8?Q?d2mPT1VpZoWCX7XD7al0CmTWD?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c37c2d-7fbe-4ecf-cb2d-08daa22d7606
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:15:36.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jof7IhI3ZpGWSp7VxkuQ1s14lgmYy0xqiXEeOjiADW/91RDWR/TTPVQJXM7Pbjmk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7733
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I need to add the "cifs" and "ksmbd" prefixes, and a couple of
Acked-by's. I'm still pretty ill so not getting much done just
now though. I'll try to get on it later today.

On 9/29/2022 1:02 AM, Steve French wrote:
> merged patches 1, 3, 5, 6 of this series into cifs-2.6.git for-next
> (will let Namjae test/try the server patches, 2 and 4) pending
> additional testing.
> 
> Let me know if any Reviewed-by to add
> 
> On Fri, Sep 23, 2022 at 4:54 PM Tom Talpey <tom@talpey.com> wrote:
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
>> Tested over SoftiWARP and SoftRoCE with shell, Connectathon basic and general.
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
