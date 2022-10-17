Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C30C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Oct 2022 21:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiJQVD6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Oct 2022 17:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJQVD5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Oct 2022 17:03:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FBD6D870
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 14:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/Kz+gnhQg4tgHplHvUsGYqpf4cxWs1snNJ8p+JOyMHTA4udqwIF65LW5RGDW8xSl59xrqJ7PB2Aau0Zm6N8snJ9RnggS5Z93idC5jVwMFtkQV5JFGcEIS5f1fWzhHtzhKC/RdZEU3tn6qidCDv6NxPBP8S372shNFhEyaAHxIy0vwnOyxFYRKqJ3FObZdrwSU69UWfreacczIL4bokRZg77iLeIE8Vt+O2gzwZXFclHcSrrN+auztlFbqkF7g9sl7XEvWqL9fQTi40r2dCTLNEDlzKe70UFhouigebzMqlZ5tvV82C7XbMA2Q44XW4VMJUe/w1fV0HKykJFvqBGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8p08rR/lwcnVmzzxtCQcea589rqQ90SYTrVI2GzJB0=;
 b=AilxwBqSa3ZX6xeCjdLMwYMRdOeiJ8uc6pvGLmpbOYfTbBxCdFSI5a+hS/DagQQSGNK5g9OTUKU9h+v0Rn/vzSzgrvLog0hKtOmHcVS0Sk0pKOHsHAXIfKsHXnLP6h5bTNkpvaTDLqVBFtICq4zaTenTA5CiYy6P35IzMIOFcAWjSWLNxwBZQ+OUFpbOviD6QUaC+Mjoa1XrfOLPTWAPuExs0yIvgCJqTxWqO12vTzNBohEBiFy6puVQOL0ee2NGf+IDH9Aihoz7I7F1c60HDafeOhc8eg7oblww9plkaR9s2+aSQx2bKAPlbMVZ/NY0JpoVbAVoLUn3QbMDNbf6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5327.prod.exchangelabs.com (2603:10b6:208:119::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Mon, 17 Oct 2022 21:03:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5723.032; Mon, 17 Oct 2022
 21:03:50 +0000
Message-ID: <bc73fcd9-3a30-75f1-5745-94f0e2509cf4@talpey.com>
Date:   Mon, 17 Oct 2022 17:03:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH][SMB3 client] Server interface count incorrectly
 calculated
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
References: <CAH2r5mvf3zjMb3=ceL9wknZhMwp6CrOQEyzZ7HaXDNidYpLCBQ@mail.gmail.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvf3zjMb3=ceL9wknZhMwp6CrOQEyzZ7HaXDNidYpLCBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0217.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::12) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5327:EE_
X-MS-Office365-Filtering-Correlation-Id: 399a7693-b4ba-4b9f-4156-08dab0831757
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Xeku0DqUS36vaC6LwEe9eQLKhP35K2iHhPrQzXg50PQlzyMBwcK4qOKnzzjhzLhJAG6wPvkzEgymDjzBLKi/FWp7DucZc97fSL5hAVf1t3fD7VK3wRV87EpeLCvNsb2zBx99rnO/59BnoJqentuoKqTyEmA7Pv6d07kisMp39cuW3XJmlJl1wSNxSoJlNigGVzdEecpbuK5NX+Bx7nicCLVC0F6Xizt8NZgOfY5oR4fts26pK2+XyDVjn4H9fTqGfRku4vpsBWJBxZri99ADjDLxeRJdeL9NA4GZUcSs3SK7WihueEjvCMWAS31L6tA4IkZRh0vIpHQT2OhQ24CxzQodlor2yf9/F0tth9IIyLF1CG7IANJfS7odoVaY0KvrhfOESaxjb7ZDus3i36i4FoF8jkQWC0wGZkyT2YS9O889oS0ktfAQ6/ypVmgu6n45R6uiwaPE7Qai8H1g99DSrcC9uB+oMsaOf4OwYbvs8xPYLYMvKrEMm1LmpEOEwwjGLE92oIxRQHuz+w1TXPRd5WO04/M2xCsCoqS9G+2+TX9XVyVc0EnSD7BRM7VQJOS/UxfeoFsHYEkE4/F7BluKhaBUQXloiqFcmXFFYLK4qnT655sFbUut8HlDgwZVuXwtib+UmzkQYK5dDZKRbi6bt6pwNSm2Z7V65h0AmNRlr7QWVrSRKd+bEHwGgwulXF6MLlf+df83NTQuF5bUoOwYmx9vMT4MPp3VKGVkvR83rAZSsy8Sg1j4Dt9Z5imLD18gO9yuBT3Rj1MeMTLckrnkzaPz14ZcFmFMlxOBAGGCJc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(396003)(366004)(136003)(346002)(376002)(451199015)(36756003)(31686004)(52116002)(38100700002)(38350700002)(5660300002)(8936002)(4744005)(83380400001)(31696002)(86362001)(110136005)(26005)(6512007)(6486002)(186003)(2616005)(478600001)(316002)(66946007)(66556008)(66476007)(41300700001)(53546011)(4326008)(8676002)(6506007)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHR1Um1aTk1Qb2Facm9OZ2ZiU002NFlJWUlkVHpLZUZUVS9NOVo0bVFoWmxB?=
 =?utf-8?B?dlJieitINHEwTG5QSVNZSWxESjlRcXQ2dkNINUFoSkdkb3lFZmw5TUtHVXI1?=
 =?utf-8?B?UGQydHcram5FU2dNRnNwSVhBSWtWOHlMZlFWOWpERlhTWXNBR0d0YWZ1K0po?=
 =?utf-8?B?ZmdHYWpDMW52ZEUvbUhCOGI2Qk5rSlg3S3drdmV6RWxCZnVSTVd3dksxR0lz?=
 =?utf-8?B?cEdwbklkajY1QitKcDM4b0RRdGViQkRaNlZTU1FKWjZ3UXZGZHlvUk5xSHF6?=
 =?utf-8?B?ck9uTS90bzRZN0U5WDVmMks4bmRtZFRHOXIvSGd1TndVQy9OZHo5Q0VrTFMx?=
 =?utf-8?B?M3Y0WFVHZ1UwbnJCY09RK0FIVHBEUVoxUmcrRmF2dS9zRnc5RXV1TzlEMmFs?=
 =?utf-8?B?QXNHUGRNTnNLSHFoeTU4S3c5aUxkWXltYU5oZk1EMW93cG56LzJNUG1uRVJ5?=
 =?utf-8?B?QXhSektOdmZCK21NdnB0QXlIMmpXKzBzOE9SMC9KVng5YVUwaXEvSjRNdXB1?=
 =?utf-8?B?c1hrTzFIMEk1Ui9ibE54bkxzWUdBUFdjWjVZVHlDcjIySHlrOHVtZDFaeVhU?=
 =?utf-8?B?V3BGaFozQlA3bUt4WWJBYjQ2UmsvQ0ZFU0JxTWJEQUU4MWN2dnRVYlQ0dTk1?=
 =?utf-8?B?UVpBb1F4RGtSblZuWmYwMk43MUlNYjVJYzhoY0xydDN1TzArWHZMOEtuaEhM?=
 =?utf-8?B?NzFLYW1ROHNhUWxxZ1RXZHJtdHVQb3FSeHdpaUpnSUNXU0RuVE5DMngrN3Nq?=
 =?utf-8?B?UzVCNm5BbmNGMHZ3UmttZ3Zwc1ZVek5jenF3c0xhQkVKUUxyNzFHdDFoRWJm?=
 =?utf-8?B?NmZ0RlZPMGVvb3p1Zm1uOVBxMzdqYmFiZEFYMy9tenFqVkVsTjkvNldIUlZB?=
 =?utf-8?B?cmZmNW1OaTdielBFQ2ttNGl5Q1FvcHRBbWo0WVpMN1dvOUJUQ2tobDNWbHB2?=
 =?utf-8?B?OENwUTFrQ2hKS0xKNEVQMUEwakZjQnp6YWJNVHVDdlBBUFBZRnJLWFU1U2tW?=
 =?utf-8?B?b0R3WGRidEJYTmxvMDIrYittYWRHQWhoR21sWDhGbVBZL1BOR3F1b21FMGlY?=
 =?utf-8?B?SlMxV1NGcW9XNjVPbnloVWsyKzZ1Q3YxNWhPbktpeWFYOHV4Zmx5YVJkSmNL?=
 =?utf-8?B?U2hNSi91cFN6WlBFNmNzWmRjVStRRjE4alVMS3VxS05CbHAxVndFNm1kVDhV?=
 =?utf-8?B?UjlEc25RVmE3VUs4eGZjYUZUalhnbGVkK3VMUStpZFcwUUo4VXJmQnR6clpK?=
 =?utf-8?B?NTA0NDh5REdCcXFGL0REbWU1OVdyWDREam5LZ0FBRkdBRnZySmV5UU1sUk1G?=
 =?utf-8?B?cjJTZlJBa1B3ZU1WT3M3RDczUmRxL0NSSDVwWkNieDdiUVhMd2ZvRjlkcTFm?=
 =?utf-8?B?a093Y2JFOUdyNXNuUkx4Z3VaVGJSbGpSS1ZBWlF2VHlNZ1pyRjM1S2cvemZi?=
 =?utf-8?B?TmRKVXRXVGhQWklaNlhKRE5HaCt6UGlPb0xydXRLMGtPc1ZvdGZLWnlnV3M1?=
 =?utf-8?B?bm5NbDNyUElZakNORXVTU2FXSWc4YUYzYUlDV0t2MlBpN2JMc3dmQjVqbUdu?=
 =?utf-8?B?ZTFRSEN3YmdtRC9BaENXbmZod2FhdzZlL3FEdzd4UzJxWkowV09lVXhveVl5?=
 =?utf-8?B?VmpHQ2VKSi9Ma1pDeVV6cFlSRGlsbTFOaDJBSVVpbEk5MzdtYTd5Rk8xejla?=
 =?utf-8?B?RWdDdHVQNGtFbGFYUXducWJqVXBjdXBGYTcrU0c2YjlFalB5UXFCU0VvNTc5?=
 =?utf-8?B?aXlJUWJsaldGclk2WlZsSnJxNEtPTDZNcVc1bXgrRkR2WmpTVTNXVGRzdE9u?=
 =?utf-8?B?OEZUcDd2bzdwR0p2UHAwZWRzSmJ4ZG5SbXEzVFV5RUpCMVk1ZWdONmhxMHVG?=
 =?utf-8?B?NUg2SkdUMWwxbk8rSjRkTHR4N0kvNlh4UGlPZFkxMlc0UjYxRUNyY3F0YjhU?=
 =?utf-8?B?OWxOazQ1eGRUTUNiSG85QytkTjc0bTI3bUZxUXVSc3VBK0JSc3pqNmlPSTFK?=
 =?utf-8?B?bDluNmxPTk45K0Y5d0VGck52UUUwOC9IY2NsNzZuNEk0SUNwSHNoazBuZDQr?=
 =?utf-8?B?aFd4SDQzZDJlOWVsb3d4VkdnVUQ0UGdOdDJGdjViWHo0WENIYjJ5bk1tY1FU?=
 =?utf-8?Q?POaE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399a7693-b4ba-4b9f-4156-08dab0831757
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 21:03:50.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7fU+44g915Bzr3k0BHIZ064pTmz8I1kUvOztmgn8bkLmFnKrFNN3GGVkxTR3yTi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5327
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/15/2022 6:10 PM, Steve French wrote:
> smb3: interface count displayed incorrectly
> 
> The "Server interfaces" count in /proc/fs/cifs/DebugData increases
> as the interfaces are requeried, rather than being reset to the new
> value.  This could cause a problem if the server disabled
> multichannel as the iface_count is checked in try_adding_channels
> to see if multichannel still supported.
> 
> Cc: <stable@vger.kernel.org>
> 
> See attached
> 

This zeroes the ses->iface_count under the lock, but the whole
routine is dropping and re-taking the same lock many times,
and finally sets the iface_count without holding the lock at
all. Isn't this whole sequence broken?

Tom.
