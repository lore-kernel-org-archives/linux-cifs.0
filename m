Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29353ECAAD5
	for <linux-cifs@archiver.kernel.org>; Sat,  3 Sep 2022 11:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiICLYm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 3 Sep 2022 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiICLYl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 3 Sep 2022 07:24:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E86513F37
        for <linux-cifs@vger.kernel.org>; Sat,  3 Sep 2022 04:24:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrxH4VfTxQzy82zUZXijMri6zo9Oh7F+Zc7zyXQ0TeIk19DZMLLMi+tXArCjf6Hq2cCoWVJJjyupHsr4tBVxZKfK7cFecK8NHRAT1U5QVoA1yFHLFndYTC4B5c9p5vFC5x8JtqrmmCSqzyEt4J4gsTkSOqG8aKr5BrFh6401zdupLLcm4cdmD97R0W0nfT9zTEaQUGM44p51Xynoni7ekryPaGUirZoCO1jUCLm4hmZFvdtJ7dnHCz5+sJKWykQiVx7akrZp1fRyndK8LCP0mZ5R+QehiO+rjYOYVf/E905dW3PkUDfz3kiVUuczcXjXe3oTHU8fzQzWmiZBCvI34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJJNNXb/veWMYJAxgqRsd5x/fYZf4f1fa+lXzGCtnuQ=;
 b=N4rFdLVJHv0oUojhv5AOmvLWaTreOx+ytO2Tgk8cM1fCIOPnslhBC3w+cVAN16SbP1CPYeMttbBaQSamGYv/2f4W47LwHEDJ5WNzCCRXs0IuC5vEwBp8qF4PN6X3QnVQQX/BM14sF6MNdj20+Yk66yYpqa/44m33bSoxMHxT/IQj7dIP0Db8Ko18GY8FBY4T9wJ44ktrr9paou4JXimBImz5kuCi5GfOnVUJCAmJFR5Y6+qKx6E1LzLPPQxkazBdw2SOqAeX4KnxZ9VmvE+aT/N4K2xXHU02rAjBC52WuV23Kx4ZbWlzIejvQ56bXNNg6HyvSegMzGlsp70EiJDWHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR0101MB2968.prod.exchangelabs.com (2603:10b6:910:40::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.19; Sat, 3 Sep 2022 11:24:37 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.015; Sat, 3 Sep 2022
 11:24:37 +0000
Date:   Sat, 3 Sep 2022 11:24:35 +0000 (UTC)
From:   Tom Talpey <tom@talpey.com>
To:     Long Li <longli@microsoft.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Message-ID: <ed0c4723-18a5-4115-837c-08a9f8a60b55@talpey.com>
In-Reply-To: <PH7PR21MB326340D5131AD6CAAD6100DCCE7D9@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <4a349c98-0359-acc9-0d6f-0ccac6f53377@talpey.com> <54374c8c-4a16-1c18-a295-c5ea229e67ea@talpey.com> <PH7PR21MB326340D5131AD6CAAD6100DCCE7D9@PH7PR21MB3263.namprd21.prod.outlook.com>
Subject: Re: smbd_max_receive_size == 8192?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <ed0c4723-18a5-4115-837c-08a9f8a60b55@talpey.com>
X-ClientProxiedBy: BL1PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 300a93fa-7f41-4586-f1f5-08da8d9ee2bf
X-MS-TrafficTypeDiagnostic: CY4PR0101MB2968:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmB8mzMNaMwNnnuuPPrxoDt+5MjIevP/ZENrlkMdlzC83NvNVX2tIEJB6AGIbpcvZw19PpRCl01W4W1df7GbwvqlYVpzJvj8JDoAF/UkDClvo1nwQ/5rFhC0z52UFeRKntJwZGYPjsvPUdJ+f5SHE58dAPm80xN8f6NfqqGCH34yv0h44++bUzAgt2SMROCh+3o/mgS3GoU/5m9B9loNGs3RlyeEUEWq2lQ9Vvy42+k8f1phE0BDh3+RmIQxx3Df6HKjb9Ij0cGlNmHdPPxlpEgGUjCyQ+ECqUkq2DmQP6fvMnTUmGx3e4m9Y2odZE/nzvMLS9lpoTSztYwFoTdeernr/iPlFXxSgtcRV3FIi82nfPZJC3T+CrtMM8H/nU3xJMQa7Ad3cvLZLr/TP3ZTyxqCXhL459YF/bfufpKBCm26fen1Qcsv2OJ71I225tugalYPD7xsPcHCgi6R0fs0ssKGoQYZtH0sn8WQL1H7CujSW7J2XbOKBbhbf5qY28zgDHDiG0F+anmJbufYj495x2ZpOqQlhwjme6OoTMWz5hmcEJfJ9etFnih8UfYYrAnBvEazDKU2TX0E2DMJvQ+pz7UHcILUCRRVgQimvblFvUIFT9ap6p/S8qJfRmMsxdBficqU/htGasTpTC/y4ra1+pEcRi8mzXHVbzFXxwx+0rvmZpahMBTsd2sG1CRNdVBGi0HBUKuHiBuJq59UiploVGW22B4W6j2ADqYKzXfB/zwoLBzRZyVqUGEWb0KKBG5k3mS6LtSqSTzlPg9tjXR9qA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(376002)(346002)(478600001)(53546011)(41300700001)(6506007)(52116002)(6512007)(36756003)(66476007)(2906002)(66556008)(26005)(66946007)(31696002)(86362001)(31686004)(6486002)(316002)(6916009)(45080400002)(38350700002)(38100700002)(186003)(2616005)(8936002)(5660300002)(8676002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QkhkUy9zYUFSK2RjRVlFVkhWSjBkS0xRKzdnM0pURFBkU0dMWExrSDB1bU1K?=
 =?utf-8?B?azNxSWFoT3Rrb0hid1Y5VGhUMTdCY3FPdFRMRVpRNkE2YUNqRE5hQUxCaGVK?=
 =?utf-8?B?a01XcnBqMktNNlV0emtXRDhxZ2dvaW55MUJDQnNLdWovd3lYOWZYVDg0dVpK?=
 =?utf-8?B?b25HRGlBa3FiVkxrSG42NUIwMlhtNDFSMUI1N3lzMVlsNk1VT3pBWjBUUi94?=
 =?utf-8?B?M1RPMCtOR3o0cnpweHV0QTRMWStnbE9rV1pnakpVdk56NjliSDZYZ0FISU5N?=
 =?utf-8?B?akpuOElMZWt3b2I1c0g4bzZFOStMbmVyU3BXQjJKT1VrWHRYSDcxWFBVd0hR?=
 =?utf-8?B?S0oyZUpMTEVxMG1YcVZFeC83WFprUnRybXdTSU8xeGFMRTZxQXZ4MVVFalpK?=
 =?utf-8?B?ZHNVODUrUlhRL0pNOVNLZXdvcmxCVnI5bjM1UFVpTTRuZmdZYW4xWFZRSEp1?=
 =?utf-8?B?NmN3UzFpcGdDUGwwSDZmd2JUSHN6dVZQVVV6REEyQjBYQ3pwS1djbTVBdzhF?=
 =?utf-8?B?cE44TGlRaXBSczdyRWszc01QV3VUVUJjSVRZSjVQRlFSdXZ5ZnBQbDlJbXJF?=
 =?utf-8?B?cEs0WkRHRTN6dm9KbFFGZ0xWMFhaYzZjVUdMeUlTMzVqeGEzOWRZRTZnYW4z?=
 =?utf-8?B?TlNHTW1UR3lwUkROejJwZUpZNzZBalUzam44cFlsT0ZzTEtPVmUyNUppa0F0?=
 =?utf-8?B?UXN5UlFmT3RSdnB6WnhrOVFDTy9raHU0TTg5aXNBYWdyZ1dZclBvL0dYMXY5?=
 =?utf-8?B?UVdnd01SWHN3QlIzbHBxSTRMUktmMUVFbWJSTmo1Z256OG45dC90aE1FYUM2?=
 =?utf-8?B?cGFqOXZYcmFrUkhYYWZ2NnpMN1E5V0NVTnZSM0hESnp1c0M5NGx2RHJjcEp3?=
 =?utf-8?B?NlZuTUo4MGtPRE80em5TRzJvNkVxMG9uVS9veUp6Mm1PSlNqbi9GUGxhM1NY?=
 =?utf-8?B?VUJiSk5sVE5aWXpnYUN4Q2J5NU1YK2gzRjhJOENYZFFGN2UyRnFySlRwei9k?=
 =?utf-8?B?eEhoV2VJQlkvR0swejdOMlhyaitJWFFrYkZMUFdQN1cxRjAweFFLYWV3aERB?=
 =?utf-8?B?V2grSGFvOUd1QjVISW1SVnNITlBEQTYyREdETENnWDZCcHRYUk5HUnJ6YXFQ?=
 =?utf-8?B?bitKT3BWVHdmbGVlZnp1Y1RxRVZFVnYvVVBWRUkrU1M4UlVjbTZJa0hkMjV6?=
 =?utf-8?B?VUV5Z0FUZ25tVVJQWElJbWJqbU91QWZMaUtSMndiZGpwM21tL0daQjdYTkFt?=
 =?utf-8?B?ZWtCVkk0SGdHai90c21aT1ZMNUlVYk8yWkVyQk16aUZYcnBQRnZ6dGkxckFY?=
 =?utf-8?B?ZWoxSDErelQyK01lWFp4dk5YQlFGSFdBdXBUOTVIcHVIUzl5UEJYL0lFaWJT?=
 =?utf-8?B?alNRYlRBdnIvZERoejU1aVVzc051UDMwTXhUdW94Z1B6YXFpblgwME1KTmY4?=
 =?utf-8?B?NldieXdKajJoaE0yOEtOVFZRZDBhQlZjbURiNTBrcnd2Z1dkSmVmaTh6ZzMy?=
 =?utf-8?B?VDBRbVBpc1pCVHpJbXhNS2RiTFNpNmRtMlFjbjVTaW5vREl3V3ppQW9xUWhs?=
 =?utf-8?B?RHFxckxyZzBmVFFDMmJGN1NDTTRxeC84OGZWWG0wTERIMThMcHhWK25kU3BZ?=
 =?utf-8?B?azJMSldMcnJmMXpHTGdHQzBvNEkyR0UvT0JFRUhmVVVzM1pWeGZ1N0ZHcHRN?=
 =?utf-8?B?TGhrN3Nyd2NFYlVaN043M3dNdHZoM3JhVWhJeDhyZXFXMkVJS3hFSmpkTFEy?=
 =?utf-8?B?bTVqbTdWOWU0cEsrTk5mYmFFcWllUXJ1cStqb2ZKcTN2cmoxWkJSQm4vRVJN?=
 =?utf-8?B?Ulp0NldNMEd1V2wwLzRvTVEwbUNRTkNIWlBFMHZpTHFaOGdGdXJ6TFdyZ0Fl?=
 =?utf-8?B?emFRNGdXVWpJQmErVS93STlndEFNNHlZRm9BRm0vNFlDMkw0ZFJMZW1jak9J?=
 =?utf-8?B?U29BU2VrYU9OVHlSMVFGZzNWeTFmWEE2QTJ3eWdjNmpVVHFsSDZSQ2R1OXRZ?=
 =?utf-8?B?VndHVGpsRzNTOTEvbG9GT1didGRKYTVjVzVuZ1MwWWZLMDZ4TXFjZGRCTUh4?=
 =?utf-8?B?MXhJYkdENGljY2NGZmJDWmpMY2x6ZjI1cVZoQkk0VWdJbUdzTkVlMytvcndU?=
 =?utf-8?Q?LNxE3gFH9/ZbXHY1nS9Vjx9I2?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 300a93fa-7f41-4586-f1f5-08da8d9ee2bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2022 11:24:37.6019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jjhx9VsT2a4SvB/iKzzPsOqbpJK6/BVi8FUn1qm1LVvR4SvA8dXv6Y0mXQO4u0VU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0101MB2968
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks. As part of my "too_many_sges" branch I'm experimenting with smaller buffers, with very good results. Using standard 1364-byte segments and 6 SGEs on both sides, it passes connectathon tests and normal workloads over both softiwarp and softroce. I have another patch to use fragmentation to further reduce SGEs that should improve performance on hardware adapters.

It bothers me that there are two implementations of smbdirect in the code, fs/cifs/smbdirect.c and fs/ksmbd/transport_rdma.c. Because smbdirect is purely a framing protocol and therefore peer-to-peer, this seems to be unnecessary duplication. I plan to experiment with refactoring them and split out the common code later.

Tom.

Sep 2, 2022 10:17:32 PM Long Li <longli@microsoft.com>:

>> Subject: Re: smbd_max_receive_size == 8192?
>> 
>> ...ping?
>> 
>> I have since noticed that the smbdirect default max send size is 1364, so I'm
>> even more confused on the 8192. And, ksmbd sets both sizes to 8192.
> 
> Yes, it seems it can be reduced to a smaller value. I don't remember the reason why it was set to 8192 initially.
> 
> This value is further override by the preferred_send_size in SMBD negotiation response from the server. In practice, it could be much lower than 8192.
> 
>> 
>> On 8/24/2022 11:44 AM, Tom Talpey wrote:
>>> Long, I notice that smbdirect.c sets the max receive size to 8192.
>>> It's tunable, but I'm curious why the default is so large. The
>>> SMBDirect protocol normally limits its packets to 1364 bytes.
>>> 
>>> With an SMBDirect credit limit of 255, the present default allocates
>>> over 500 pages/connection, in O(2) granularity, when 85 O(1) pages
>>> would suffice. Kernel virtual mapping would also be greatly reduced as
>>> buffers can be arranged to share, and never extend beyond, a page.
>>> 
>>> Any insight into the 8192? Thanks.
>>> 
>>> Tom.
>>> 
