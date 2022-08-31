Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10485ECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 02:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiHaCE6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 22:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiHaCE5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 22:04:57 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201BDCE3D
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 19:04:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fk3vFuGKB2JZXGTwwz3PUBdgfOp0gYOAGQ+seMOHTh/czL9TbZZf//+66mlkbx/CGHrDiKuA6F06sOh1WC8Znpq6CzJap3RowsMme/k5uFteXFH74bUDj3UkAK/42AynLkZFKzUr/OiPZYU+MyKoH/XaM/MlFsdvLR4ucGPU5gQ7z0KfxkhPGlcCRWTWRVVACgIh1W4sEMjhZzElraVxMPOAo1TBeMw/45reuminQEW0bfhfHlvqB0vHeMPzuAYnVSEJ3Q+eAMrg8Fh/8uVmTMNeSdkWMiNUrnCAD4tE6FktWJa66/FBX0x1fw5V9HEg8XwNb82lveTlpYDpeYzXVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYorY18CsV4lajJbQOqe2ofeL8PuOj+A5YieLGVWT1c=;
 b=cfIhsmmY7qJYHSy4fkz06+w5lwCqjItkwe2oh1teNnIguMNB6LmqojTAS+WoyC3LBdAKgNnZReI90E6Um4FQWhkN5jycQE/gQenboo1tLctDUvZTY3TaqhjpSkE6Oc/c9Gf39kA1+tyWLStLUaf2u1wlrK7t4un99Sf3BjXaOWI5/rqmAmCYQTSI4r5jZZ8V7PGRL126bx0VgGfDE+Nk8k00ONpksKTQbY8IyEcS82ZT/Tn1PR+wlSDydnV+RWrl+z5xx42fEr4PuLXEy+cdepwI2oE9if+Qi2GFHDHE+MGW3Vjhxy7TNRWkXFDAIrOIg5yo3JiUJhQJEtsnUHuFXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4619.prod.exchangelabs.com (2603:10b6:5:6e::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Wed, 31 Aug 2022 02:04:54 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 02:04:54 +0000
Message-ID: <54374c8c-4a16-1c18-a295-c5ea229e67ea@talpey.com>
Date:   Tue, 30 Aug 2022 22:04:52 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: smbd_max_receive_size == 8192?
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
To:     Long Li <longli@microsoft.com>
References: <4a349c98-0359-acc9-0d6f-0ccac6f53377@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
In-Reply-To: <4a349c98-0359-acc9-0d6f-0ccac6f53377@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:207:3d::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65a809e9-95be-4712-f27b-08da8af53286
X-MS-TrafficTypeDiagnostic: DM6PR01MB4619:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: silf4jt1JaxXVO1+R31h4EA1uCROcEeM4nwdL91omW3dAfq2wR5pyzFn5ZfxLLUlQATU+k4rGo7vGBrO/mHqwWXXLARIs1zxm6UYOrHyrhadHySGFwcEylnNzNvavm9jAeAdi1PFILKT7REI1HfqAZp+PorQwdqlv4VRhQMtlJFRFJp3+ZZzuggVpRlL1gsOVEx9Iwkf0Xz6fovgVcv/xdWxLa7C9EhyMjHPqA2vf04dvXOZj5Wm6vbH+6IWQBH5AjYl34oLAuK6ldl8ozS4lydft1G0AE9emaG9nEYW/RLZjUj572kO7gMdZHnK0nXGFOPjjVe7ebRO9d/N1mMQexaZ2kdiOKo48I+DYaLioSS8QWfYx4nZcsqLiVKTmDf98zYO1Ndk+6XIruQ/XMC14Sd7fdp1oETitcZjet34GwZHsNff6PvaDf6Go68hegFRXagZWeHtuVOvnWYScTeClW9/D+lOnyXyFm3PCCIAVrM7Cgo8UTjJke0mdC/7h42895nBBAxOkf/WB+IOecQ8Zazfc6X/5swcEFI5E7ygA3fGRzrfHOacAR8yBhgAKk58YIQPUlsWEq/Sw7bt6U5+s9KaTzarcHnz+OLGqqiuDAh3qm0zp7O5ZVqqUQtc1+GygwgX8Ocp2gFr7mBMupgHuEQ+antTjye/zWRI9um7KbnuliYPjL9TZLtVf40uPifrhxNjHDq49N0CkxOYVLVAtwIypeYhO5g30sG/57HXtZTrB/XvNhZedfrz9rpHFgfPCc8YVz+wGP0mlgZPt9DFKnpOecSeRMvX3SJ9pR0Tbvs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(376002)(396003)(39830400003)(4326008)(8676002)(83380400001)(66556008)(66946007)(6486002)(316002)(478600001)(6916009)(66476007)(5660300002)(8936002)(2906002)(4744005)(31686004)(38100700002)(38350700002)(86362001)(31696002)(53546011)(36756003)(52116002)(26005)(6506007)(186003)(2616005)(41300700001)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjRpN1hoUG05TkZQakE1a0JrWXp2YjRZdmFENXM1NlV5czgwY1R3citpTUJF?=
 =?utf-8?B?czJQdW9YbjNVd3dYbG9sTVpRUjNhc3dxUWxsNm5SaWZ4dHI3NEZEODcyNERn?=
 =?utf-8?B?cE9MRC96WVY4cjZxZmU4OFk3aGlub1R6M3U0MVdTM1RENTlseW03UWRnUVlB?=
 =?utf-8?B?ME01ME5CbmU2SEpJS0hWdzNXV2E4SVcrUTlzSHFXdTBzVU1CblliNE95UnNE?=
 =?utf-8?B?QUFkZktnd0hSQVpCU0F1cUtPNVBQcGd6dHc5cFpUZGptV0lzTHlWWS83cVZM?=
 =?utf-8?B?a1NLR0srdGxMMzQwQmVQQ0VML2dScmIwS2pvUUduT1VmcGtKaDNqKzFmM0Vj?=
 =?utf-8?B?TzZvU1hITktYZTlFZ29ReXE1Ky94UUVVa3Rab3FDaTZMZkhrS0cvQTRkU0ZL?=
 =?utf-8?B?aStHSmxScm1rQjB1VWFnc1Rlb3JnYWVDN3N4RTlVNlBRUXBSZXBFY1dGam5L?=
 =?utf-8?B?bkVtSEcyZXorYTl3THNoYUNNeXowa1RoT3VSekw3WHllbE4rQ0VSbmFONG9i?=
 =?utf-8?B?L0JVcEZmNTdTbDlJZko3YjVZNGRaaldVNzhxcEtLK1RkUDY1d0lJSyt1Z3JO?=
 =?utf-8?B?elR3U1NrQTg4Ukl2SEo1WElCaEIxNzFKTTFoc2xlTURkL0J6bU9sOGpNSGw5?=
 =?utf-8?B?em4wd2lLR0txblBkTnZXcTdFMzlkVE9JdVcyM0hHRFYrbGpGd1VzSHJ4Ni9C?=
 =?utf-8?B?RExEM2R2ZVpzNC9nNEQ4Z1VRUUttMnNxMjdlamFZOWlPWTNFQ0NaZlNGbmNw?=
 =?utf-8?B?eTNmN21PdVhpRnZzVmxZaEFHRkNwY0lsYkxicW1mVGUrYjZveDNZS09LaHRF?=
 =?utf-8?B?VE1oSFdaVjA3aHVNVjJUd3F5ejZscVlRTktGRGh2RWVMcEExMEM2QkV0NzB0?=
 =?utf-8?B?RUJNUkM5YzFxK21GUUUxRDY2V056UmZwRVI5QmszaFo1bW1TT0lUei9zdDh3?=
 =?utf-8?B?ZGJyMGQzUEZWMUpoZUg2VmZYcHk2b3EyTmRGbGZWcitDT2R4RTY0VTNsQ2p4?=
 =?utf-8?B?QktERHNwZklIa1lnUUV3L3RSWjE3eHpEVEJXSDVaR05WSTQ5QVI1QStNMTBi?=
 =?utf-8?B?ZXhqcXBrL2hCdXVPYWYvRVQ4blFoN1FEeHROWGRjN3M5MEt1QU4rT2J3MEdZ?=
 =?utf-8?B?UTNTVWZYa3JrTFh0OC8zYTBRc0RNZXhxL090OEdFK2R5aHh3STJzNUwvRDJ6?=
 =?utf-8?B?ekN2NmdJdGVSM2hCcm1RNXlpejZGNTVPRFFNSCtDWEpNSkZHeW1LWndyQ2gw?=
 =?utf-8?B?Wk5RSmsyVXA3L1B0R2pxejdBcWRxZjgvVFpwc0xjc2RUOERIdk5UbDhaMDdE?=
 =?utf-8?B?R3ozbWJoK1Bud1BFQ0QwY0JNL0VPWnNVRFk0Q0ZTaVFmcGhhOHdYUHBXRUtG?=
 =?utf-8?B?eGYwV0I5TzRDcm5ZUWhROHluWGZSbDhVc1NrUjBVMGJJMGRCREhXOGxsTDNJ?=
 =?utf-8?B?d0tCQ3JiTnN0UFpvK2NvRHRhb0h5dEJjanR5Z05WbVR2MUpQLzN2Vm02OTlJ?=
 =?utf-8?B?SlNmUVZVYTMrclc4RFkyR2xISzhlL2duUGZyd01DMFgxd3h2SWdlb09WbTNp?=
 =?utf-8?B?b3haSXVBRGo3Y2JiYlpSWEtVWGtRZVhtdVp0ZEF5bkJ1dUMwTzVCWTdCVXlQ?=
 =?utf-8?B?YlRQWURMbHBMTUZxdFByb0R5b09ma3VRZWhpaXFRVmJ5c1RPYms3aEEybFlt?=
 =?utf-8?B?dno2c0tPUkFKY1pKM1c2STI1YURWNkVYZC9iU3ZpWjIrMXYwbXhIaitrRk1Q?=
 =?utf-8?B?cm5vVjJaQmFiS1d3VldpYUF4U0pWMDAxSEpOeWd2RUQ1YStaRTF1N0xrRTEz?=
 =?utf-8?B?ZUVBWVFWR0prZVZhWmswb2YyNzMxR0pYUmpPZnFnREZ2TjRrZ3hWUVZqRTEx?=
 =?utf-8?B?RjRhdWZCTWtmMzNVR2c2ZEF3WHdxZDFvU1R6STRHb1Fxd2JIRlkwaHN1emQw?=
 =?utf-8?B?WjJORnptVnVHV3lHSUkvcHFya25CZFpHTXJHZXJBTXJmVnJGVTltU0pqQVFO?=
 =?utf-8?B?V1J1STlwckxUZkhNbWdyRUV3R0FmVi9na000c1JQcUFHZ3ZidmJ1ZFV5TEZ2?=
 =?utf-8?B?M043MTdkbG1mRWQzMVNvZU9ncFI2OEV4Si9VQnp2NTEvYUtIbXYxVGhPd2p3?=
 =?utf-8?Q?RW5g=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a809e9-95be-4712-f27b-08da8af53286
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 02:04:54.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zYQ1ox3GpTdDhxwXPU5YAr5tlCkHGp6xMcQGvzl/CT2RyPpBLBaaRLMbvmm+KplG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4619
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

...ping?

I have since noticed that the smbdirect default max send size is 1364,
so I'm even more confused on the 8192. And, ksmbd sets both sizes
to 8192.

On 8/24/2022 11:44 AM, Tom Talpey wrote:
> Long, I notice that smbdirect.c sets the max receive size to 8192.
> It's tunable, but I'm curious why the default is so large. The
> SMBDirect protocol normally limits its packets to 1364 bytes.
> 
> With an SMBDirect credit limit of 255, the present default allocates
> over 500 pages/connection, in O(2) granularity, when 85 O(1) pages
> would suffice. Kernel virtual mapping would also be greatly reduced
> as buffers can be arranged to share, and never extend beyond, a page.
> 
> Any insight into the 8192? Thanks.
> 
> Tom.
> 
