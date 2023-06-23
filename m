Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320EAEB64DD
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 15:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjFWPzD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbjFWPyt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 11:54:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35561992
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 08:54:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTDMvIWndySIksC4Q6Rs2VPWVl2sEwzHhR8T4Jn1FWB1USTcrir+9M06TctUUlUZoeDP+i+CqChUOjVzzc8DReIyQF2a+FqNn+ECTqfNhQKN4Kp+84d0CUv63bKCtvYZ21wiBopYzEJoxXOtKQtdb5QUPifA9mLf/rx7XJRjgg4pZGzsbFvoFq7hWGlpp7EogAmo3aSbpq4Y4hWKs6ZfDYAzxu0Wymw1/YTCdSbtQCnJ4oMxitemLxl+BpWEbGWMpEZ3cqeLlby0J6UchyBm3abL9l3ioc0SbOR+fo++m1z/5XIRa+i2vA325j7tpzpqf7cMEEr+RhiQNZfULyS/XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40hXL75+fatQXMfV+4D30H1Zhm2J4ZHJm5IVvxL/3kg=;
 b=GraFiQbvbAZFW2zBOnFKe/e4oEY0q481sNv+W6kvmdim/ai+ffvo3EtHqcKS9X9ccA17UvCyXIoUF+a1sxokMJ7gcpKYiK4GDh7hSHGs8bSTRZD84c0cLrgLok22u8xEDu3ncuD9YC/gUMG17jaTvxdeVK5OfjoDxLB0mMvSdQLzui9SeGDQFKbgUwTQlubyV7dGZLYMByf2q/18sY7LwUw2k6gsUwFIAAl/WTO4zaVBdKrnMZV+cO8eRfmFGrPDTt1wiv2Zyn9qE4YqulObx40OfWyPXCGL/+PriBG11lDNS+fTmFxIeZII29Sk1hJDgrI4EISo3QrumnsiEP9ymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN0PR01MB7779.prod.exchangelabs.com (2603:10b6:208:37e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Fri, 23 Jun 2023 15:54:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 15:54:43 +0000
Message-ID: <1ca61d08-6e34-48aa-62b2-e246a5bb3ef2@talpey.com>
Date:   Fri, 23 Jun 2023 11:54:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/6] cifs: display the endpoint IP details in DebugData
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-4-sprasad@microsoft.com>
 <nlpmf2nsqosbz5ifzycdpoqmi22tkcoouuk4pjsp4exa2jtyqm@wzdmdh625e5p>
 <CANT5p=oGXceYkn=+7KjbN=9oC14S0ue16LAPB_56hyX588iOXw@mail.gmail.com>
 <CANT5p=rPRPVaRe2S4j=OqJTbOhs9onqR2ZNTMPNE1L_71aNQbw@mail.gmail.com>
 <a38028f0fbc7d6abb1f118f110537f21.pc@manguebit.com>
 <g6yidp2mk3sseniwodvdz6d3svgq2kt6jzsbuiuh4gb2zmj3g3@yl6cqh37q7bx>
 <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=qPivH8p+_SXMN0phKPTKqkSoEHdc+omhvM10YckbSvFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN0PR01MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4ec6cb-9583-4c92-6467-08db74022947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yESVkqL3DRvIXQl0rrvf8yjQYZRJANM9/c3g2+H7312rFsE+csmkuRZ6TlC/lR+uaCzN//mzR88ZNj0zAeMmR5OOWy1AaK+O1ph/150lQW8/wwF5sNgP3nmWcNtfH/3/zQ4vFAXp8REWtwEvP5MjGaGKz8A1dcStiygzINm5br4w9cxVTOxmU27han9XMnWrVpTnKjxjudAZ+IoLqeIAneF3AwSj+sTXFstnMXHCl+KgkBGIZnoZ9l3dnPoYa1xwckHej6Z02ePR5mhq4U38zWT1zv+sDNQDgipa23F6RbsTBOZVldX6GfrM/UgmBNGw4d8jtvXjrQwCJRrAeqTlpvY03pbWF303+PFQNES81aOj2cFqQ/OUjNIiwxrQrTuKY0iMy0lqLfA26GbzJp4lzKQTnQSBeUCukueFPkXCBGCkMnbDWPnIM3GgmxXLw4XXfSLhpTu3FFvurPIHnskCkBHxOf+HdIGJNfce6Z6z49Wd5oUQsx+avIRK+aFGI40gvs3S2q29mNisUZd0rHVZhGcVc9bpHjg6+tbgEDNe4SoQU4cxzzW2H6edhTJXl49BMNBAPPHXN0xAa55Rw8mOITc9wE3I0TTuCW2gWk+Q12Y8cKyQYhAg/Jc3NX723UcxKcSqDGw+5SaQYmnsd3svWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(396003)(376002)(366004)(136003)(346002)(451199021)(38350700002)(2906002)(6512007)(4326008)(54906003)(26005)(186003)(110136005)(31686004)(31696002)(86362001)(36756003)(2616005)(316002)(41300700001)(66946007)(8936002)(66476007)(66556008)(52116002)(5660300002)(478600001)(6506007)(53546011)(6486002)(83380400001)(8676002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qkpodis1M1NKNWRxWEJCWW1NbW1NL2FNNGtxZExWdHhsWlczOCtqVHFDNzgr?=
 =?utf-8?B?VlpzT3p6TnFhTE01SVZNVmZaN3k1cXNFWFl1c043c24wbXBadEFpdGYxN1VR?=
 =?utf-8?B?MHRlU1BqRklaWDNIaVk0Q3BaSnY5dUlsMkdtT21aVERTL2pUNlVvaFhodmhv?=
 =?utf-8?B?U09WMmVtSDFJYmY0MVhVckJHNDllUnRJZVJFNitjam9oNkp0clpjWFdvVzd6?=
 =?utf-8?B?aVdIT296S1lJdm56US8vZzZtc2dUVnBtQ2JWbjRCbWF2MkhtdEh3QjhJZFV3?=
 =?utf-8?B?MUgybHZLem9pLzJDRnBCdzQ1bTNueWdDV2l5THNiUGZUbW9RczlFVHhqcHBw?=
 =?utf-8?B?STJ0T2xuVXd2UjBwZnBFRzNaZ0lLcDB3SW1aNC9CaEcyR0xtNkxVQ1pKL29n?=
 =?utf-8?B?bzBFT29pNlVyT00zbVNSUnpuOWlUYVNqMU5OZHI1SmFYUFVENGxjaUorVVY0?=
 =?utf-8?B?RFZ2blpTWDROY1BHUGN5K3ZRYTRqYWFSSzJLMHBManpZV1NoWitFWU5uK1ls?=
 =?utf-8?B?WHNpYmZKcFhIZHV1cXdJN1hjQ1VhajM2Q3pCZ3RDQ3VmQWptTmpmaUdVbEZl?=
 =?utf-8?B?czRZR1pHdXcyUVgwakIvTis0bTF0cis5TUlIYXVOamlLWko1R016UUkxZnA3?=
 =?utf-8?B?aUdvU1U1Q1NtVmhNaUhkU3NScU5wT2VaWCtvVDFhSis2YWxvVEZiY1Vka0R3?=
 =?utf-8?B?VEoraENiajc5Rm9GZXY5TVBBQnAvMnNFTnE4NEhVUStBWmNBcnBJc0YrYXZ5?=
 =?utf-8?B?RWp6UUxGcWtxYWxPZjF4ZnFZZ2NEYWl1N3hDVGV3SXByYThXUFNxRGtWa2ND?=
 =?utf-8?B?YXl3TjFwWThSMklUdmdOQ1JXbDZSQ1FMZG1FZGpyLytPRXVMMnhyMm5BZVN5?=
 =?utf-8?B?ZTdUbkJOd0xJNWNmTnhUaWNwVnlINExRbGNlUmU3WVZVSEJLNkV2VUtuUW1n?=
 =?utf-8?B?ZDNZWXhvUjNJUktiWWNoem4rMEIwVEliVmdUaXF4cGc4bFRUSHJUQ0k2cHZI?=
 =?utf-8?B?RUhsR1ZOdjVIbCt3TXBiUDFnSkM1K05TQURQY1l4bHMrUFFuYXhDWXlRb1NI?=
 =?utf-8?B?M2pqWFNac2NaMllMaFZUcmNjV05uSVllM25JK0w2SUxDMEsxMlBsNHM1QkRJ?=
 =?utf-8?B?OW1QRHNIT050MFl1N3FxZ3FjK3dWMDRBSi9qcFJ6S1NwV05JdkZYcTRIRE9j?=
 =?utf-8?B?S1J5blR6NHgrUGVPOFNFbDFUNUlkWU54OTdkbGszY0QzWkVGRExpOGxMU3lV?=
 =?utf-8?B?eVRKMzk4cXliVjNLWUVCUTJLb0VnbEJISjBabHhSSjBwdU0xV3hXUHNNS0FT?=
 =?utf-8?B?MUtxNC9FbW5ta2x5QS9TTW9BcmtudVJrT1VaeTlMQkU2OWlweDU5R2lGYlRH?=
 =?utf-8?B?VE0yenU1c29kNzFsejBrQzBzQlhDbWVUbE9UYUhqQzZUSllUbDkrZGpLb294?=
 =?utf-8?B?OXpPN0Jaemw5UmR0cmNpbnVmVldDdDRXT0xPekVWT3p6Q29keDFldVZSL2V4?=
 =?utf-8?B?U09PZVRubUd2KzFseUd0bGRJb09vV0pLMmliNGI5T0hUQXI5U1MzcGZOQTZm?=
 =?utf-8?B?TlJQWG1JVTcyRUpwdWJZSU84VmU2bzg1SnlqWXRxcS9qOXZVWTJyMmVUUzFp?=
 =?utf-8?B?RzE5UVJueGZObkQyS1RrR3cxRWdMZmI0TmRCR2dXMDhCMTQ5M2NsNHE4OEhz?=
 =?utf-8?B?ODJXVHp4QVExUGc4STUrd2JSN2VPa2YvMUJ0eTN2eVJTRU5xR3l1Mjg1SkpQ?=
 =?utf-8?B?cjlaa1hFSGhhLzVUL2I0bkNPNCtzQmZiOTkwZkZ6cWw0dUdTL3dNN2tjUThZ?=
 =?utf-8?B?YnZ1OS9zRTBrNHp1TmFMbExrbnRkYlM5UjVPV3hLdjlQWS9EQ1dYQjhPc1hG?=
 =?utf-8?B?R1kyWHRtREFRVElpeXUrOFh0Y1lKRWg5VVQ2b3BKUlBzb0p4alJ1bEY1Sm5p?=
 =?utf-8?B?NDhQUlROb3FyaC9ZWGJFMk0vSmJkSXhpU3ozb0VSOFBjbjJ3UWxCd3p5WGZZ?=
 =?utf-8?B?cnltTndUMjVWL1ZPRXF2WWJZdEYwS2ZTVEZWUXRsMTUyV0VuemlvU285STd4?=
 =?utf-8?B?OVdZMU1XcEh4cXZDWEVma3Zzb0ZERUJ4T2VHL3AxYnl5MkkwcVJHSjZEUFdC?=
 =?utf-8?Q?+/DTeDeOjKrBRFHwpASxEXlqL?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4ec6cb-9583-4c92-6467-08db74022947
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 15:54:43.5977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fx55NAjDo1CydEdV5m+DneBRDmBoey2BeP2KNuiR495rttsC/FGCeXxheBaDlbPp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR01MB7779
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/23/2023 12:21 AM, Shyam Prasad N wrote:
> On Mon, Jun 12, 2023 at 8:59 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 06/12, Paulo Alcantara wrote:
>>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>>
>>>> I had to use kernel_getsockname to get socket source details, not
>>>> kernel_getpeername.
>>>
>>> Why can't you use @server->srcaddr directly?
>>
>> That's only filled if explicitly passed through srcaddr= mount option
>> (to bind it later in bind_socket()).
>>
>> Otherwise, it stays zeroed through @server's lifetime.
> 
> Yes. As Enzo mentioned, srcaddr is only useful if the user gave that
> mount option.
> 
> Also, here's an updated version of the patch.
> kernel_getsockname seems to be a blocking function, and we need to
> drop the spinlock before calling it.

Why does this not do anything to report RDMA endpoint addresses/ports?
Many RDMA protocols employ IP addressing.

If it's intended to not report such information, there should be some
string emitted to make it clear that this is TCP-specific. But let's
not be lazy here, the smbd_connection stores the rdma_cm_id which
holds similar information (the "rdma_addr").

Tom.
