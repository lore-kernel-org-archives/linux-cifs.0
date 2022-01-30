Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D0FC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 30 Jan 2022 19:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355879AbiA3TFQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 30 Jan 2022 14:05:16 -0500
Received: from mail-bn7nam10on2058.outbound.protection.outlook.com ([40.107.92.58]:48127
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354597AbiA3TE0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 30 Jan 2022 14:04:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqKg+Vg1xZhvfGH4pHYckjISzHs7fu+QkUi6EWKEW63srD4X4kA3KJO6I5CFQ5G0DECSxG7SaavbCCTMApWX+mHcHhP5V7GYHJSCVaRHx8JyGhHMLbCMxnNl7Th6FnkzGmUWSOL7b6ERFYobNNJZPYkJiWVInJ9VMSj/DUvVs4a/IQdTiy8egVoCXU8d3DEx/GNr3U29/CQfBnakLwBQhsIDEvcmbdRwJnIcTVJHZsUx4a3PKOSLdiZORATQzxZVmyJA15ZaGDY1aGzYBYQ8aIicXVWOMbghsDkDYrBlzz8pL1NrHrdqrbGPIkCUI6st3B5WqrsVIFMYnL1whU1/pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMxDkcNu+tvBCRUV+dkhXe7wy94/uHIF5QtADcG3E2k=;
 b=CC3fo/Q9GvhlbiEkitxlAlw369NJQLNHfV47xkfaNx2bgZaYPyKTDaU6RqGwv8HsjT/g4bisVBCo4PQwPeKE5YyckWDuvf/+o5QFoidODNYj/EAmoL7wvxF+B65rln08L3MR+0iQiJbenc1+srlYE9/sHzhafbWUuxxn7h717jzIg1Shj5zNv/ltBfmLRmK39zJ9fMmP/R/7vgaS6ZmQGw/8Sj601sWYuiMAPVOCb7chLq0hf8OtkWtzbhUBvJvfxHZLWhsj1jUgaQqoOShZmsbycdiGWK0rFDgPgm5857xBvbYx72rA0Bu/5Jp7oPFj/Vzhakd6ShrmJBrZaUcJBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL0PR0102MB3313.prod.exchangelabs.com (2603:10b6:207:19::10) by
 BYAPR01MB4119.prod.exchangelabs.com (2603:10b6:a03:5e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.19; Sun, 30 Jan 2022 19:04:25 +0000
Received: from BL0PR0102MB3313.prod.exchangelabs.com
 ([fe80::1d3:342f:dc83:254e]) by BL0PR0102MB3313.prod.exchangelabs.com
 ([fe80::1d3:342f:dc83:254e%5]) with mapi id 15.20.4930.021; Sun, 30 Jan 2022
 19:04:24 +0000
Message-ID: <9bd2b636-ca5a-df2c-49ab-db14b7b453f1@talpey.com>
Date:   Sun, 30 Jan 2022 14:04:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/3] ksmbd: reduce smb direct max read/write size
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20220130093433.8319-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220130093433.8319-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To BL0PR0102MB3313.prod.exchangelabs.com
 (2603:10b6:207:19::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74587d26-3b63-4120-0561-08d9e42354ae
X-MS-TrafficTypeDiagnostic: BYAPR01MB4119:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB4119464E2EA8DDA463238FE0D6249@BYAPR01MB4119.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhdNAf7iujyVMUHwdWPBmKt5QFaWiohqB8hsVmZTGXDiBOMrGl0lgaQYfeVBdZfR8+Vd9XCVv0CGZKBPi5x9ReIv5Dg8iUewzdEjDnsexzRc1jo1NkIUIPFFjPTKDlY/xBFmkBB0H/58IchiGch4zWATKR9tJkN28ihAipz2ZTxxPcQCsZvNlFmxKroE3aIbKFmdFneToYUX21WaiYiPbZSHEgRYbah/GmVVN4lfIVIf+QaCsLaFVzwfK1TXX4WCR6+UTYkJI6gURH0KcH4EnYJ0nmpl0Iz9wulVRMNZq31GMj6a0WSdeQEawz7DTkwl2JEJVAt3J/t9tzMv/apTFnhYgLBt2ffpWguRFCHlnyKARdxhOgtYqznHwNFBeZ0vMdRRP6geFrUzhSG9kBTihwV9bASf3tzxM0GoD3DCrShQmyjT5fFY3kFDJZoLJhrnTWsfH1xGiBJL7STyhWnGCRk4d1fYmYo+BVY21VpHIwzAY0vgxCivjcM9JjQSb3PI7aOST2JcYDssUGt3+e39LG/G/7xLpMKneM5ly6lQDK0cCBw2TsxMaBYesqDu1EMrk6xcsnh14c9l3vCHVM9DOHwQD79U1iW01WJ0QCkbkfveyNX0IC89j0evNWfBsK+7gzMc4cIuLhJ+5exso/X00dWK2917oYirNjdv7DEqxB2BaAL5cSN/X0BZVitra1HdqPwvNErgyxBISDnFnXd9vcQVWZ/gSLZOwsUo4aB9GH4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR0102MB3313.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39830400003)(136003)(396003)(366004)(346002)(2906002)(31696002)(38100700002)(66946007)(38350700002)(8936002)(8676002)(316002)(66476007)(66556008)(53546011)(31686004)(52116002)(5660300002)(83380400001)(86362001)(36756003)(186003)(6486002)(26005)(508600001)(2616005)(6506007)(6512007)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEwvTE1IbW9jUzlIa3VaN2wwZU5uSmlVaCtwZFlrcFEwMVJTd1h2czdEMkdQ?=
 =?utf-8?B?WDVWTWZwRUFXcVRvcEh6czR1L2VJUUdPWUxNcThNcCtkRlBDdFhVbjIzZUlI?=
 =?utf-8?B?WjFjbWk3bHNyR1daVE4xLy9nWDdXNTlCZzY0RWVLU01vU0RMamgrZERUcW11?=
 =?utf-8?B?QjJla013QXB0RGVUZlRGOTdQclBnUDBHSFliZmlRZHNsaFNFM1IvQ0tiSktx?=
 =?utf-8?B?VE52NWRTWmlObzZDaVljOHhpQUl0MjlYSHFNVE1XUU5xRUxLMFRvSm5iY0Vv?=
 =?utf-8?B?UzdOZEFKUUJpL3pOOTVleTN1YWpNUW1Fd0JSWTdwR200ZWdVcjJBblVPZmlZ?=
 =?utf-8?B?QldGNDZSTm5RZGVJT2pxRTZXcDJBQm4yaSt6clFPOEM2V05tZHVZVjA0VkdO?=
 =?utf-8?B?TjZVQ3FzR25nQjFaWnNjK0NKaE96RG5GUm80SCt6bTNQNDlMVGxqWkNBckVQ?=
 =?utf-8?B?NTA2VEpwcTBtRzR3LzNsZWJrUXhMSjl2cHkycTRZL1JJK1dJeGMxYzQvVkFB?=
 =?utf-8?B?aWwrcFhzTmM3L3MvaVd6WEI3TUg5VVo0UUFSMTFuVFk2bEs3Q2o1YmZOSmsv?=
 =?utf-8?B?Z0pqUjU2dWhEc2xJWkphU1gvUU9aVHdHemgrOE55ZFhoc2VwMm93dGFPTkFV?=
 =?utf-8?B?OUFaTWZZU0hOUXoxYTA0YjZVN3FKWVJuQXIrRU5ZcFh3ejFjZVdhQm8wVG1B?=
 =?utf-8?B?c3FzUUVKekp2bTJkODlqUCtaZE5yQ25PYmU0ckJqdFowQlZJVUcwYklQNnVX?=
 =?utf-8?B?WDdleWZYRnY2VFhzV3c2QTFtZXJVUUkxUFpUeXhvOTRuZENTMzJVRXR4dnJO?=
 =?utf-8?B?SXNDWG84cng4ZitXWG9qVVNOZGREZFBtNFVVZWh4VXNMT0tGbEg2ZlZvcG9F?=
 =?utf-8?B?b1dUSjUyUzRFNzhPTVlkakhDK3lDd3FsMHo2U0lUL25SN0FjYWJaZ1BYdS9Q?=
 =?utf-8?B?RnViUnNtekhETSt4VVNxQVBCdk81RnZKYzZsSjcrQUZLTjVQYW1TV0txRDlo?=
 =?utf-8?B?R2oyR1lSTnRLZkFlbFFaNk9xNjgrc0MwSVQ5QXNvZ2cxd3RIYTE5Zmlja2M0?=
 =?utf-8?B?QXNmVjNoc3ZPaVpBVFBMRmwxVDJqUjQvRUM0VmRmV2hka0x0cVJDYzdOUnFD?=
 =?utf-8?B?c3VXV2xrUERhMGgxbDgrRWRRaWoycVZ1L0gzNjNNaHQxMnVqUVJJQlZTUS9s?=
 =?utf-8?B?NW9RbkdJRGozTVZUM1Qvc212Szk0Rkl6ejBwYVhYWWFINk9TNGlZQVBvWjR1?=
 =?utf-8?B?NjhrOTIySmNkUDY4TzlLZHRuSlpXZlpFYnMveEFuUW5reG1BL1h2UEtBdGdu?=
 =?utf-8?B?NGdjWTZNcm9ENjY5UnZaODlRc3VwYmswWURnYmViWEZKQjZuTHdWa3ZSNy9X?=
 =?utf-8?B?N0xVSkFSRmNtUDNNTXBDUTl2ZTk1QU10cXlCZkIxRGNFT0tkYWEzWFcwK0l4?=
 =?utf-8?B?VENSdTcvM3FlL21tWjNPUUV4eEdaekZSazlJUkR1OFcvaW95OHFqVWh0UEpx?=
 =?utf-8?B?Szg5ZWtIbGtaMldSM2IzVGFPN3FZMUExZldRbHhDVXRnTDRJOGlxcjh1K2Y3?=
 =?utf-8?B?OWVLM1orMG50WWEyVFJJRE1ONTh1N2xlZ0tRVUdIek1neGx5ZTZabnRrc0ZB?=
 =?utf-8?B?ZnJDS1FuRjJiWWdtNk5nek05dU1YQUs1OUhHZU1IWTQ4aVBiaWpLUHdXemVk?=
 =?utf-8?B?MWI1UDBUVFd2cEhQMks1MDVVckMzd0E1a1pJcTBGNXdjbE9GZXdvc1pBQ2Fj?=
 =?utf-8?B?K3VlYTY1cTdaajVPRGJXaFlsRDI3R1hRelA2TVowd05uRjFadUtoMDlxU0Qr?=
 =?utf-8?B?eUFMNjJyVllscVArSGE1bUZ1VXhxeDBuTkg3TkpQaXBwT2YxRk1ySFY5cmtz?=
 =?utf-8?B?WnlnZk10YktJazVBUDMyaTJDS0czVUg3RlBVTStKTU15YUJqaUJuemJnY0d3?=
 =?utf-8?B?aHU2NkVTdTd2d2pSRHZOVzZwNXdSRFNzZjl6YndvKzNsQVlwNERqdlM5RUdJ?=
 =?utf-8?B?UnpPaUxEZGpVZEdOYkxEQXkvNFRtZkhSbjlHd2kwUHRoc3d3YUxWUGRlanph?=
 =?utf-8?B?ZVpsSGIyNm02YTFQdTNoa1JYM3dyN1JkZFJMSnRJTTdJemovcmYrWkpkaGp0?=
 =?utf-8?Q?ZqMA=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74587d26-3b63-4120-0561-08d9e42354ae
X-MS-Exchange-CrossTenant-AuthSource: BL0PR0102MB3313.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2022 19:04:24.7189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/1w7oW2bevGxiWFI1RwesBspGar5Zi9STxk+tA0XxQ/wSrm/u56aab8yV9JanCr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4119
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/30/2022 4:34 AM, Namjae Jeon wrote:
> To support RDMA in chelsio NICs, Reduce smb direct read/write size
> to about 512KB. With this change, we have checked that a single buffer
> descriptor was sent from Windows client, and intel X722 was operated at
> that size.

I am guessing that the larger payload required a fast-register of a page 
count which was larger than the adapter supports? Can you provide more
detail?

Also, what exactly does "single buffer descriptor from Windows client"
mean, and why is it relevant?

Confused,
Tom.

> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/transport_rdma.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 3c1ec1ac0b27..ba5a22bc2e6d 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
>   /*  The maximum single-message size which can be received */
>   static int smb_direct_max_receive_size = 8192;
>   
> -static int smb_direct_max_read_write_size = 1048512;
> +static int smb_direct_max_read_write_size = 524224;
>   
>   static int smb_direct_max_outstanding_rw_ops = 8;
>   
