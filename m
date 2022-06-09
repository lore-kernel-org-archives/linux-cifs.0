Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5733C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jun 2022 14:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiFIOSD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jun 2022 10:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbiFIOSD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jun 2022 10:18:03 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3633A156470
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jun 2022 07:18:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKdAV9VmCJntsq/fXjZAZ4TwrbnYcVWTDqJuiffiHFomFYIeYtUkNdua3gemSUALM0eAhJPpo0Qw7Qd75A0bS7P4+viNWvXFPS91M24ypR7Gg4Rf9doQFCmnodR26h3Yj6nA5WJyIrxkAcG57wiypWTufoUUP4uL99rqP2jl/xdce+ip2gKhcV0Iux8clzSAJPtSr7DCgTht1gYwoVzEXFsJvL2DbtCrZzh7wHOxb0ZDtoIelP8apmCQvAgEfTg930khpw5MzbqWXNaHZWYwtTQIwG7kmER1HvRwXsodYmxgxirTujIBfUOSvxmRecGAQQIcK4hnyhWl1G71EgtQJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqZHTEm7Rwx5ZiakuCUH/LxIOmm5IXQ7iqVdmB8yZig=;
 b=ct92unV0MwV5PTssamsgplPa+ntNhqrBu0uJYCFFTz5kRiYYnrAWzyg4XuESFDxeXeuyaskEVNBViBGrXLZo+FfMqJM1XpogVZGH4C+FX3hXPS3q9BIXKA8OKspvMoKWKycfKEIkNjQnNOnSCLCQyO4wdFtV0uqx0WQD9nseMaXKAdEPB5DvPpn6Wc5cbCmX3oDyZTbhw11JgYXkbbjRw6dKH1j37+McUyF3FeB6scNxRFJOCkkqs4sWeJ1afPMA0vspqLk2CyNUNcu3Wqj6CRN5I038QbPNuXuk7jPib6fU7BHFj1aJj0XHm/JUMlzhR36Ls2YuBk4Pgnz/yvJOsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4483.prod.exchangelabs.com (2603:10b6:208:36::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 9 Jun 2022 14:17:58 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f%7]) with mapi id 15.20.5314.019; Thu, 9 Jun 2022
 14:17:58 +0000
Message-ID: <df02056a-3c88-aab3-f90d-2b5ceaa5bd6f@talpey.com>
Date:   Thu, 9 Jun 2022 10:17:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/2] Introduce dns_interval procfs setting
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220608215444.1216-1-ematsumiya@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220608215444.1216-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0143.namprd02.prod.outlook.com
 (2603:10b6:208:35::48) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ca7db34-63a6-4274-5c48-08da4a22daa1
X-MS-TrafficTypeDiagnostic: BL0PR01MB4483:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB448306E8A02484D939AE0DC0D6A79@BL0PR01MB4483.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4ayeYO0rT349XpB5kx0Nzkxg/EyF2Ipw0HNGn211H/NR95i1nzdkAxzw7vfGfvFWl10WGpHhT/8BE7tN6QvBJczr9su254pkZhVXDxuUVIes+0xjWThtV7y9LrdVBq0nUrhIf5iauGZnx4hkMo+NYmSqatK/hNJ/KkAFrzEao0gtS0aIrV6+z3i3tPJTl6pwtlrtZpL1k2di5aGsBM5KTJwJ3q6iYZHbwgwxjRy0+p6cNg3b11laTWiNEvJiWaMQhPPRUqYqz1c5++movX8rlP+4uxYML8PeVnu9FYJypqROFF9ELc4MuArrDwCsDoKypek8H+HGF1wlsmnAh3ZbdAxUtQzxkmDfXwidf8/7JcrC+vuMoWSOsY6yFdWNTfLqhsgMMQzwUvzi/E2X4U1VnGjlTTkGXFiFnIoU1G2+p0Bf6KEOWs4wCN3g4bibSIit9naz+D/Tzj/yFcUGAlWXHyUaRFBXAGg4egcggR7rzelG3RPmguA+/IMQcZzjb2QJqL2XM/o27gQ3v1ZlKLH5tRYNLt3FuaiH1Z2Qa8UOZSHyN/Eg8IikJMyaKjnlLX9FLA5mceEbqV9aqALbXwd7zsIf+6FhmCAwz8NGkyt9RmktGfhQXSdU2Q85cUYG4woeU71+Pxizi8oxx6rKQzyP5IuePghPlelnyynLgZGKuIIh4HjMgt/FZvV4iHDnuShpA6CWt5maymUWcC5oQXaAlx740og+w69lFW0zBHs+vw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(136003)(346002)(366004)(4326008)(83380400001)(66556008)(66476007)(316002)(66946007)(26005)(31696002)(6506007)(6666004)(2906002)(6512007)(2616005)(52116002)(53546011)(36756003)(508600001)(8936002)(41300700001)(186003)(8676002)(6486002)(5660300002)(38350700002)(38100700002)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1V6cXBvdk9rRm5YV0VNa1ZkeklEbndNNmZNZll3MmVSUUJRdUdQdTRpR2Mz?=
 =?utf-8?B?UUNhVU5kaklpZzQ4UEZTc1BybHZqblYxT3MwdFFTR1RsZDZob2R1eUxvZncx?=
 =?utf-8?B?RnNhbjhKbEVlQ2wrdlljeTNjRDVnN3NhWHJieVFoeUJ3YkQzU1VxUTBHOHBN?=
 =?utf-8?B?d3E1YW1XK2gweFE1dWp5T1lxbEc4WTlsYlFTWDc4d1BLZ21kbHZvVnllOEhh?=
 =?utf-8?B?UWFLK1k3c2RiczJnNmJxZ0RvdkVBZ1ltU3JjOXhrY2NnSVc3aS9DcmFXeEJV?=
 =?utf-8?B?RjIwRXR1U0EycGFYOGZWbTJIY1hHZ1NDMkJXRmk5WTBZMmtwZElaNzNlQTlw?=
 =?utf-8?B?djB5ekhrTWx2bkxFeGEvYUpwTFRxcHhubEFlNGJLdURXT2cvTVdnbXJGaHZP?=
 =?utf-8?B?VVg5RHNuV2xlVWRFbGRjMEtpeDVhTUtwa3Q0MzV4Sy94aWNzd21WYVZmSzY2?=
 =?utf-8?B?emRVMFlidFhhdGNDOFJPT1l4elJPQ0J3Ylh0cmNFUnNBZkNWWkJNMzU1UGtq?=
 =?utf-8?B?N1NwcVJFRy8vM0NncytLclRxWlEzL1B5UFBtMm1MdVIzcHBNL0NjTll3WktB?=
 =?utf-8?B?dnpmWkJUZ3pjSmpxbUxienRKY0x4UW5VbUU1S01adzV6a0hQMXUrSmlkQ0pz?=
 =?utf-8?B?RjJwY1oyYTdPSy92NENLU0ZvS3dFbmx6bFJpT3lZczMzWi93YUt2bTFUUjlk?=
 =?utf-8?B?U1dhNlU2L04rOFV0WmROdFgzV0hDMmhVTGVHS0tqR3pxZTJ3OGNNM3IrMkdL?=
 =?utf-8?B?Y0tCUk9rYUxLZ1FFanJLK1FvV0RubHdVWGFLc0NRdHpwWXlNY2dLZ1JZeXR0?=
 =?utf-8?B?Zm54bjRzSWxjeFQvdjlpMWpTOENzUGtMbWNJOVVnSUJqZWk2ckpscUhobUdj?=
 =?utf-8?B?MkFGOXIrRmFyUEVFclErakxkaUZQVGpPTTJxb3A3T09ndVlMaThnZlBSeXRu?=
 =?utf-8?B?UzB6TTNrR0E1UTUwUHFkcmpwZExlLzJJZVIrUUhpcWZhdGJTekYzWmhXWWdy?=
 =?utf-8?B?c1YwYXQxTVkxdE12amM3L2JLVnlwZHVCWkxRKytvN012V0dlTlgydEcySXVt?=
 =?utf-8?B?M1YvdW1XR3JnZDMzbmdBSFJEK3ZlM21jbDNQTVlVT1VoNHpTZ0t4Q1lpMzdF?=
 =?utf-8?B?OENFZU9wK2JOaGlhbW9pN2pUMldLVjdEOGxiUC9saEl5UDk2c1d0SzNLZGRa?=
 =?utf-8?B?allxU0VSS2FIdGtFOSt6by9vSVpUWUxVRzZXQzloL04zWkVDMlJQb3VaQUFD?=
 =?utf-8?B?ODBnTG90RGhWQzRZNEcxNjNFLzRIQUZzZHJXL1pubWRCR3MzdzVQbkFFNFh1?=
 =?utf-8?B?R0Y1cUdhd3FXVXNQdCtNTkp4QTNJSGs5c29DWjdyVFlxNE9VQkxVZXVmSzUz?=
 =?utf-8?B?eGhOa05oQUJjaVFGZjhyVTNhaXJVNXQrRmJtOWFUcDJyQXpyam5LVjhGcE5S?=
 =?utf-8?B?TUlla1JFd3lRWVlERlNSZEhTeWh4R1FuWE5vandrZmZaenJ0ZFczMW55N0xC?=
 =?utf-8?B?OG9XSU5mOGNSNnZyR3JWdERFaDhleWRwWTdCZXd5d3dJTGRhWFRRYVRkM2ZR?=
 =?utf-8?B?WXEzd01RZWVYQnk4cWU1Tk01dU5sTllubTltMld3VG43bUM5Tll5dUdOZ3Rj?=
 =?utf-8?B?Y2pRby9BdUpkaUxONVppQXRVTzdjOGpBT0l6bTdiaUVuREFrYXUwNVBxUlgy?=
 =?utf-8?B?czJJcFp0eHNyLzkraFd4MW0zSnNPNHJYUVlRZlFpakg5V1A5SHdrN2djcyti?=
 =?utf-8?B?dmtXZlgvMnNtUjZVUDZ6cnRUa3kxWUk4YVB5Um9EODZPSHJwbWVJZ1d2dmhE?=
 =?utf-8?B?bDJOekxBYkd3S2FiblVMeUZTY3JyeGthaTY5VGdtaldqZjJERnprL2hVVThN?=
 =?utf-8?B?ZGtNTm43NWV3dXFUSERuV0N2bGkxRENCekZFeGZGMitscmZzMUx3dTNzcDlX?=
 =?utf-8?B?QW84bGpMNG81SGlMY0lPcmVaTTUrSHZJYnVHa09OaDRDN2RFOHdRSFNuejlK?=
 =?utf-8?B?RkczNWVnR1phR0tsajdJQm5xT1JzMTRHOHhrOGpJSm9ESmYzQnB2a0J2Z3cy?=
 =?utf-8?B?YlJvUTc1Mm9DckRlM0N0NVNpUVdFZlB0VnVKeTJXSU9RQTl5SjN0SXNRQm1u?=
 =?utf-8?B?Mjk1blBYZUIzRjhzTzJEZTlLOVluUXNTblI3Ni9NU0lHa2NHbjVGZ20rMjVK?=
 =?utf-8?B?Z09pYjVJRDJocHk4NENZU3hnT1RXeVIwZi9HbzZBNUMySitpSmhRZnNrMy9z?=
 =?utf-8?B?cE9Pc3JoWU1QR2sxdjYzVUdKSXBhVkEyWFZLRGlQblZGOWI0enV2RElNQks0?=
 =?utf-8?Q?8s/psIH9QNPzFSPKbW?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca7db34-63a6-4274-5c48-08da4a22daa1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 14:17:58.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsqYkHCBOr+ekFMXHYeN3LPdDqOIlo1/XA09iFplY0GtAbyZZmhSOjGrYooFkSZZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4483
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/8/2022 5:54 PM, Enzo Matsumiya wrote:
> Hi,
> 
> These 2 patches are a simple way to fix the DNS issue that
> currently exists in cifs, where the upcall to key.dns_resolver will
> always return 0 for the record TTL, hence, making the resolve worker
> always use the default value SMB_DNS_RESOLVE_INTERVAL_DEFAULT
> (currently 600 seconds).
> 
> This also makes the new setting `dns_interval' user-configurable via
> procfs (/proc/fs/cifs/dns_interval).
> 
> One disadvantage here is that the interval is applied to all hosts
> resolution. This is still how it works today, because we're always using
> the default value anyway, but should someday this be fixed, then we can
> go back to rely on the keys infrastructure to cache each hostname with
> its own separate TTL.

Curious, why did you choose a procfs global approach? Wouldn't it be
more appropriate to make this a mount option, so it would be applied
selectively per-server?

Tom.

> Please review and test. All feedback is welcome.
> 
> 
> Cheers
> 
> Enzo
> 
> Enzo Matsumiya (2):
>    cifs: create procfs for dns_interval setting
>    cifs: reschedule DNS resolve worker based on dns_interval
> 
>   fs/cifs/cifs_debug.c  | 63 +++++++++++++++++++++++++++++++++++++++++++
>   fs/cifs/cifs_debug.h  |  2 ++
>   fs/cifs/cifsfs.c      |  1 +
>   fs/cifs/connect.c     |  4 +--
>   fs/cifs/dns_resolve.c |  8 ++++++
>   5 files changed, 76 insertions(+), 2 deletions(-)
> 
