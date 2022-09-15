Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBDDAC32771
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiIOSoI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOSoG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:44:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBDB95E46
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:44:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdMjIsd0UEiviOMS9XS0RDysOmtJa9wo+fLGM7xb+T6dhfs4cnJDAxOOUm56hnmJZJf7rmc8xrzCNbaTCi5k7X1EJw8VYNVvqam9Z7lDG8bmd5V4KdWQz31yLNXkqTpLlOI/e0DsB7UWJxAPuIGkmfR5ampFG6WGwQcudB1Z3dt/7VpnvQ9bXIE2kEUN50wmYoNKNxjht35XkM1SsjQLEVLsf0I8R3Oit8I2uplVmslppYmoAu6+k1vuU3Mng24IlwTk8iPZpltB/5L4qq5oaOqjYukiayxiflFS+9cIXD38C/6pwQNu6sneEnuERiULDLolMJ1zAM9V3HeZLPL0xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7kPiMIZsQWTPbE5Hf010LcCcetOt6UgFf4Lqhu2thI=;
 b=ML+sh6BQip2wIP880vdJ3qqKShKlrH5BgoKiy0QvHJUu/H/4ahfcLXmGNNgEPFLZSHiEI2moRPB5/J3uhavQESZ06swzJxF4jNTs3/vuX3K0SpLSTODYejiXB22RlRDK2xyMSGk/z4D0WaZHngNgaUClHPnm70QTSfasZ9P0wWUTStCtDxmuPaDa4LODn996ejRYUmFHB17o+MtIIe7pCGfAHsbkuxMKEz3PB/rZzXwk+PwS8wUJ/DqLLmtuZh6jNG9mr/4hvr+LIwc6vylJH5zXcMcFh/ODnpkgi32gljgbkvG55gBYzjRsQZt/jffnCXrKBBeW+N1rmSJHARrYoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5584.prod.exchangelabs.com (2603:10b6:208:114::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 18:44:03 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:44:03 +0000
Message-ID: <8f99206e-5972-3e9a-3c3b-bca19e6aa263@talpey.com>
Date:   Thu, 15 Sep 2022 11:43:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 2/5] ksmbd: Fix wrong return value in smb2_ioctl()
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-3-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220914021741.2672982-3-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5584:EE_
X-MS-Office365-Filtering-Correlation-Id: da365338-34e2-49e7-a758-08da974a4291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aMUg5OaDHvWm4mIDysZcWyTnZS+EZY1m7KlvrDbeHUdUKHou3jWN1nSLYsDr6WbqZe56yM+QGFAFnxkHxxpoVOvvoIf5ZeZHy+adVZ6s45oTWy2v2JQoA0glfdSN5I4lo1+OCV77etmyqT3ygKV5O/eUzPTDVD8owsVjf3F863zoFVUVevrtPFQrXxu8eCWldcQwHVzCmZBlUw7ZwvXBpDlBRkhWpkYYFiEYrptoXYn9azThugKyUuWkDpSmLx0tF/iXCAoEufYaGFkdNXwASvCpyoe0Tj4+0C6xHr1B8wCAlsURJ35Wvy49a1BJK+g3EgcdiWJqdyLn5o7jUokvCdKUqQ58fY6hWWSnZJCuf0H8ZZDoDOCkvN/JiYZsP74bHs2fud+/ulntqxP94G5V1hKuePXbZKYWi/sP78XG3NL9BbWUE/gL6cZ7bZh2tdEVBuVKPWQaMM5n4DhttILu3XWVBcSXL1ezfxSrdYOzOYHBjDRxKki6WXQUDjPDTDdYIv2tDa9GWsoKKHFVT/WstjmPYSi7kCrFS/8eWPZI0E1eYMg0AS5XR8VwCEYgQDzoeW74hOHgzyu2FqNaJaXsaWMUWBDVMdCZlfC3MRMOkn/wmJ1aicdYE5dkXMqFViVI6ZopLrXvb9iXoZdFVTZSa4qyBx82NKIuj+g0TC4Ey9OLbtSdfKo/xnHqvp9sMZ6BdbOMl8Q87Jau1NPhBc90lnbvUhnNnAhw9f9KY7pWTDmy/80Hjs9mu4ou00kchWeDihDLHO3kkVAdIMmSgTCQDpDUXkolHoDhw0hfOEYsG1zlk/ZiLrh7m1KsQeikvy5t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(136003)(366004)(396003)(346002)(376002)(451199015)(478600001)(52116002)(6666004)(6486002)(41300700001)(83380400001)(6506007)(26005)(53546011)(6512007)(2616005)(2906002)(7416002)(186003)(316002)(8676002)(5660300002)(8936002)(66556008)(66476007)(66946007)(31686004)(31696002)(86362001)(38350700002)(38100700002)(921005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmFrdUlyN0IzcjYzdTQzMTBQU1RZMjBZblU4SlNNMVk1TDNzMlViS04vT2t2?=
 =?utf-8?B?TXNpL09GTm5yQXNCV2EwaEI0bGxKQ29yOGg0UWUzNnBCN3ZtNE00NDdUNEtT?=
 =?utf-8?B?eERkbHNkZmgvc1VXaFZYM2xuWUhuajNHVzFWZFk1di9QT1pnWm93Z2VhVUQ0?=
 =?utf-8?B?Mmw4YUVBRTlZeFl4d0dFYWZpaXMyZE95bzNjMFZIYlZ0VTQ0U3VpcDRCUExm?=
 =?utf-8?B?V0pTbDU4b1M4UzY5ZkdZOXZXT3FxS1N0U0JyTUhpanNwRUR4VGVWeHQ2R1Fl?=
 =?utf-8?B?a0xjM2VJWWt2OXdURGtaN2dHeUE0QXhKN0hiUjA1cG1vVmxvWkZtNmxienZ1?=
 =?utf-8?B?WmJrYXV1U01vUXJQdlF0Ly9QR1BRQXBnNXQrSGRkY3k5aUZTZy9POGdRb0Nl?=
 =?utf-8?B?V1p5T25SS0NJdWtyOTFBcDJVa08wczZOVE14VnFzcmRBbzJ6d3YybG5NUGc4?=
 =?utf-8?B?aDk1d2RGT3BzWm5qZHVJbnphQmxrUDFEUjR6QmV3SWNVWVAzTnlvTWVTWHdx?=
 =?utf-8?B?UTZCYmdrZVBWbTRTc2VlUWppaEFKQUplSjEwMVBqZTNuNmJJWTVseDB3S0Zu?=
 =?utf-8?B?eFJxN21sMmw2eUNTa3QxbmtZZGVtc1dFUW8vUDViZ2lKek0rd2xOWmtsNWJV?=
 =?utf-8?B?QjZXeDY4Q0dEcjR3K1VtMmQ4TXFpQ3QrTy9EN25XQ0ZKOWlyVndnNWpOTFRM?=
 =?utf-8?B?L1RaVjhUdkFRM1U3SzlyZElKZDJSbGhNM3M5UmlrM0JFbEEyUHlvbmVJbk1K?=
 =?utf-8?B?QjdISldVYmJPQXpqOXFOQ0RNNGtudytKa21CKy9sYVh1Tm9CdTRERXV5ejFB?=
 =?utf-8?B?NDJRbmowTHdOKzhZQUZXZ2RIZk54dy9BeVhlblc0K1R2WmVvVTUxMUFlSGMw?=
 =?utf-8?B?MSs1OHQ4MXM3Ulg2RWJGcnpYSHFuYkEweWhqbkdoWFhsNGlJdHhTZ2wvL1lM?=
 =?utf-8?B?WGY1M3lkTXF1WDZzWjdweHBHelZyaERUZUJLSmJsU0Rka2dFTSt5aWdiTHl6?=
 =?utf-8?B?NHF4RXM5cGlBMXZaQ2s0R3B4cTVZQVhPSFU5a0hkNVdSUGFDSWwzL1Q2RlR3?=
 =?utf-8?B?SlhNQUpKaVlvYm1mK0hnd3p5alBrbStDa0FxVndHMTVMRmpaczkxVkVEd1lD?=
 =?utf-8?B?SHMybkRMQ21hUWNEUnJleWhPV2MzVW9rMlBGMkVWVnBJLzZ2RUVSZDRPekdZ?=
 =?utf-8?B?L3AvejRadkc0VHpZRkgvTmkvVE92S1hOb2V5WnppU3dQNjMwT0YxcXdUYXBY?=
 =?utf-8?B?K2t0WHJsN1hxY3dodW1uNFZZMGxiOGQwSHlUL1R6T3c4U0d5RXgyaUpvK3Rx?=
 =?utf-8?B?M3NGZFc4eldKVmg4K0twWG9JZGR5M1pHVFVKandLU09mbUJhbERJbTEyOGRs?=
 =?utf-8?B?Tk1QQVZmTU9uaDQxQzdtQjlvd1ovNFBxRUY4VDdFaHJKUXJTNzlraE9sb1BO?=
 =?utf-8?B?cFBtZ2xxakowdVBlMzdIaE0wdFNvUVFFRlNwQ0NUakpoZVdwaTB2UDQ4Vjcv?=
 =?utf-8?B?SkFHR2huVE9LWktyYlV1bVdld2pmWFVIVEFmTG1jRTJSbkdOV0NWUlZRWDJT?=
 =?utf-8?B?VGU0alMrWnhyUzNidmdYUlpwSmJnMGwzL3VVek5TOXR5M3dQYXpTcjdTdFh4?=
 =?utf-8?B?aWpqNVA0U3pSdUtySzRoUW9PQTAzR1pKQVluN1lXdWdCUHlDdkxlRG5laHZI?=
 =?utf-8?B?WVNwYkZad1A5Y0xMa1BJMEhkKzdUaFpiS1lUbHZtOVM3L2ZKN3JmNjRpZG9R?=
 =?utf-8?B?ODFreVp6ZDl3SHZhb1RKeXdVUXVTc3d0RElqVzdxMCsxN01jQWlZcTJGVE83?=
 =?utf-8?B?ZXdaKzd6VWZ2T2tDRUFQM0FCVm42UXk3K3FPNnFYK3dXZkY0em52RnBOdnhN?=
 =?utf-8?B?TWV3clp2OGVJenB6K09WaEpDMkZlMHZLY3E3N000TjRBcWRiY3d1M1pkNGZV?=
 =?utf-8?B?MUtrc2dGZzFwVkJQanpiRG9tL01tR0d3YXpNL3JTT0dwWk5uREtuUU90eXlT?=
 =?utf-8?B?MitVYTRRNHM2bjRobjBXd2NGNWY2eE44U2VNWGQyVWxObGZrZng0MzB1ODFB?=
 =?utf-8?B?ZXRlTThCNzRla2JJL01uWjRwd2krOWlCTnRkaEVHcVdtK0JMM3pIL1FRRXhy?=
 =?utf-8?Q?kUgI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da365338-34e2-49e7-a758-08da974a4291
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:44:02.9999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1pgB9bHqJYoY1lg87lE6QKH81hi4ArtGnXU7wpJmPVlkp6mZc3TF7nCujIvaq7YC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5584
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/13/2022 7:17 PM, Zhang Xiaoxu wrote:
> When the {in, out}_buf_len is less than the required, should goto out
> to initialize the status in the response header.
> 
> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c49f65146ab3..b56d7688ccf1 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7640,11 +7640,15 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   		}
>   
> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
> -			return -EINVAL;
> +		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}

In itself, this doesn't really fix the problem of requiring 4 dialects,
because it's still comparing to the incorrect Dialects[4] size. It's
only a fix once the 3/5 patch is applied.

So, I don't think it's appropriate for stable.

If you squash 2 and 3, then ok.

Tom.

> -		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
> -			return -EINVAL;
> +		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
>   		ret = fsctl_validate_negotiate_info(conn,
>   			(struct validate_negotiate_info_req *)&req->Buffer[0],
