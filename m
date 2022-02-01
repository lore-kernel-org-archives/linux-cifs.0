Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AE7EC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Feb 2022 13:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiBANRw convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Feb 2022 08:17:52 -0500
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:46400
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238590AbiBANRo (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 1 Feb 2022 08:17:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVqE7J5Q92GhAjPkynd6uMyPXBwue58vHcFfRJjOrZ7VFDOCvpZ4vOm2ScjJKl/32zrW6AwS1cbvZddUhCpcqAXS47Jh5g48e7yBCpEEma+821sQDXH4TxzLANwAe55s+u7ezIib7fG97sj1ai/dor1e1VadvCGsqOac+2Tb7HGneer733njSYapdvwr75RLRm7eRmflAhg1W3oRCBtuO67tYdjg1yMJxXlQ3aVXns9CkkeeNq8YGosaZtb460ate4boihAAeXKOA9UfCGYtlQHGNnEAvbqdrpq++Jtu3i3gEs5YeiwxJ680XiwYQ55wdGduchTaPRv12IiInpNI7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwqLESqS10r8WngdzaOoaWxLTYXZBQCakjPFitJ03OY=;
 b=lTlBkbPVSnaDkrlFetiV7B1k02+owS0HLnCcAoqlrwDc63GbK8J36TnmZ5y1v4bwNXBaL4etnS/M/6aaw8wYzHwZgrAWPBbmx8udW9wC2a5yR4WuiiZkeHcY8tSxwwa23KdiWpOkcuZsvqAV65cHqtIuuMAbAJLrcJqwUkFHs72KJOg8jJKYe4vxyWNnT72f2aYT9bcjHmtqfbXhvKS8oip0cH8Jrcn4k3jqoe1MUmr+aXLbmOfDe6s9WuX4wJU5Z7/w3MVGr5fsnmjNgTneY/oXMxrGiTCBYFn/quLLAR2HbuCKa5aEv0u29OhklJSGbyRBPectIOrrHqSrOr7qag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4673.prod.exchangelabs.com (2603:10b6:208:75::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Tue, 1 Feb 2022 13:17:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f94e:e0e0:4d0f:ef81]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f94e:e0e0:4d0f:ef81%4]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 13:17:42 +0000
Date:   Tue, 1 Feb 2022 13:17:43 +0000 (UTC)
From:   Tom Talpey <tom@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
Message-ID: <0ea60b70-ec27-4d1b-b2bc-ef062fa86312@talpey.com>
In-Reply-To: <20220201091512.11167-1-linkinjeon@kernel.org>
References: <20220201091512.11167-1-linkinjeon@kernel.org>
Subject: Re: [PATCH v2] ksmbd: reduce smb direct max read/write size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Correlation-ID: <0ea60b70-ec27-4d1b-b2bc-ef062fa86312@talpey.com>
X-ClientProxiedBy: BL1PR13CA0087.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 022eabeb-7711-42d3-cafc-08d9e5853a7a
X-MS-TrafficTypeDiagnostic: BL0PR01MB4673:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB4673205C8CB1E677C4E8F454D6269@BL0PR01MB4673.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Dbhk3b490MAf+4LYETZV3NmG/8wedb8Ubq70age/quwZN0QkyuCry3nwg56MWFMCpHD8RPd5QV6Q1RqJAg4vL8bYEtS2Lph5+23hcD1tKcCHNQz4DqrDNSGQ1cMXdpXNLBWep80c8AYdncOuXOO/mmG5FfnO9ZX68TR3spnqlvLcoHYy7gEkL4Ab4xnUyaxVl0v/yAJfkDv/kbxWdDxv8l79+Ud/Vm8inS9txFBsm4tsXNyPb6J9fl5YTbWjOTMyJfzr3Zde0wQXdO0ArnrE48+EOoX8vOJwMEIkOfr2TebxwKhVVrUSQfu7KuC+lx6LMM+77AShpGcJdvO26xjIhjKPAPQ7EcIGrXlWZaKq64ihxwQqj8GjtNkuvQZzsW3z/wQaBsJVrjDk0afZt2oXIyWnstM+wH19KtkO5CwZ7k1dq8RJyJhIIhEhkfwZy945onzS8owdoGu9zOrp3hNKqzeUwHEbaPz+DpmSsSvM9Ror+tAgmrPTXZTAbayfLWgN8qSg2URjD/4SjRNnpaLnMF5Pdbp79xljK1iWco3DHP6AoRobvb5p3YbbGHFTGE1k9WWkV7dLkh8FfL3Szt6nh3bVlFc77hNtyo36sdXZpvqn8M67d0IycVjNcJ8a5wdbaRuOu0vUeBI7FkOR81dIUvNI8BSO5Fx6xFd8TO8Hd/5Mlnc6+XH6zPPi7razoUd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(396003)(366004)(39830400003)(66556008)(66476007)(508600001)(31696002)(6916009)(86362001)(6486002)(316002)(31686004)(38100700002)(66946007)(4326008)(8936002)(36756003)(8676002)(186003)(26005)(2616005)(2906002)(52116002)(6506007)(38350700002)(6512007)(83380400001)(5660300002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MFIxM3pMRGpPYUVIbnM5UjcvSWJkbDFwM3hXeENLTFdkSC9kUXR0M0loNzR1?=
 =?utf-8?B?VXRkYzA0aDNUS1NQS0hYc3QrMTQxamJmMGx6SFJpSER3QlBtZmpBY1RPay8z?=
 =?utf-8?B?MTVvUmFIYzZYTTE1ZnJJN1pSR1BtYzhMbjJHUDZVR0RTZWNzbEdYbnRwUktZ?=
 =?utf-8?B?Wms1dzljSUtlSTdOUlhKZloramR2UVZ4SXBQM2JGS3grUloremxyeVJrck0v?=
 =?utf-8?B?KzR2Z3pGUk96RTN2T3hIdFYyeENLcFZGc0hGMjd1VnZGOXhpZHA2a0tEaXJX?=
 =?utf-8?B?TFovVVArSThkMkZqd1VjRzExMG51NEpjYUtTRnFlRlFPTHUzOS92bUFoRCta?=
 =?utf-8?B?aFN2ZUhOSnVmN3dCZkRoYkhqcE9XUVBSQzVoaDBoSzlKR3M5dmRyaHQwSGVM?=
 =?utf-8?B?aWtIU1pubWRlMkIrQUgrTGcyM0VkUUoyYWJJQ2srRlNidEhLYUpRLzBwMHUr?=
 =?utf-8?B?aFNubU9LcWlVUDNPRzRjOFEyVDNQSWorb1NpeGxxZWVidVpLNm9IdVErN2xV?=
 =?utf-8?B?TmlYWVVyanNiclg5R2gwTldxUHFHZTF6Z0IxNXRia3Bua2p2TmtXQmJSOEg1?=
 =?utf-8?B?UzAvbHJUYU1WZDJEUXRGaVJHMmxDOFBsMFhVa0hnMDdNSEFYZGhHQ09qUXJY?=
 =?utf-8?B?ODROMkwvOGZlOUJmTThIYUVzK0pWQTM5VGt3MjVZQzVhR2o0QTlzaWxiQis0?=
 =?utf-8?B?TXQxSTN0d1FvdGRQOUxSSi91NVpPRjUxQlFEN1dIeUc1T3MzZ3J1UFFpaDJI?=
 =?utf-8?B?R2NFdUJ3TW1LcVVyMS9vWk5uS2FUVERxSnFoZ0dJS0c5QW5FaTFaeXIvZG9M?=
 =?utf-8?B?cENTR1RYR3Fub1lWalhXZ25lRmt2cVRjR1Fza0xwUUlzUXZrZTJ6Q2FzQlZY?=
 =?utf-8?B?MU1lVGcyN0lVWWFTL3g1em96ZHNaYnF5VHhjNzg0NW9mUjBKUXg1UlVYK1lL?=
 =?utf-8?B?eGxyNWlGcStZY1hieFh0SFlSTHZ5OHQ4NGxIT1Jnd0FOV2djTFFVMTJVWmI3?=
 =?utf-8?B?clZickZEUE5TcDd4MnhJeHRjOTNlNWUwS3V5cXpDVHZCMHM2Zk1HaWhzNEE3?=
 =?utf-8?B?dm5wellLaHNyODRTajB1NXJZcGRuRVJmZWRGdm41dnNxdXdtbFZYMWxwN0xp?=
 =?utf-8?B?U2lITHBEM1lHOWlaNC9rQUF1SE93bXY1RUxpY0NTZ0YvN0lYNm9DeHI1SGQx?=
 =?utf-8?B?WHFUblRxRXRxbXZZWDBoWjYyWFdoMWV3WWdRdEp1R2FUWXlDR25rLzd3NnhQ?=
 =?utf-8?B?bEp4cTU2SjVZNkwvc2hhbW14SkJYTm1aWVdIVHcyRkRwbGtSR012bVNFMVMy?=
 =?utf-8?B?NzVYSHRJRFpqZGZIenBScC83bmVuK3ZTcGttcDdMem5reWZoNlBmU1R5SjQz?=
 =?utf-8?B?OXN4d0JkK1U5VXR6R29oRUgvb0xkL2M0KzYxT01iWnExaXM2ZFg0R0lDZ1Jj?=
 =?utf-8?B?STFFRHBVeGErVDA5Y2JLcEREMUdpaVhHQnNhcWZ5T2JHc2xkRzNBcGN2M1JM?=
 =?utf-8?B?UkNCTU5Oc0VrYUJlZkhkQ0VobU5aTWUraDhzMnduUlJoM0x4Wk02N2RpRUdr?=
 =?utf-8?B?SFh4M1BzOThtL1VGSmFwai9EMm1wS01MQnpvT21vMkx0aVpWNmt5WlhTRk9R?=
 =?utf-8?B?Ym8xSEV0UUVQU1RyYkVzMmFieWFBNXJuQStoUDdSdkFGUXRacXVHN3YySzI3?=
 =?utf-8?B?cC94K2RFMjZaemNmN3VFSVBHZmxjdk5DZGRVcTRJemFLMEEyYjA5dWt2OGNz?=
 =?utf-8?B?aVIybUhCVElwZlZEVThkbjFtNFBMV28waTIxdlRZSlJ0alRLZEJUT2hDbGhk?=
 =?utf-8?B?N2Q4MUtMdUxOcGJWWExNR3puUWVZYkgrZmF2N29GRGwySHNaNmtOekF0UmVz?=
 =?utf-8?B?T3J5Zzg0MmJQZHlyemxBL1NEam43QTVVdnNwQ3NLOFF6UWw5RTRWelU3Uith?=
 =?utf-8?B?SS9McUVncEtFTFpRNXMrbDY1bWxGTytLcVhOcnA1aVA4NFBDc29PWk0yRjRU?=
 =?utf-8?B?YUtlNG9YYTRQK2EzQVpUSGhnYkNsZDcxTnVNQ2xpOFU3ZURXL1lteHlEb0ho?=
 =?utf-8?B?MHF3SzdNd2hWSS9hd0tiSUZWL2ZETFpUR2tVRWR2R1JDci84ZVdTaUJ0WGxZ?=
 =?utf-8?Q?XCL4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022eabeb-7711-42d3-cafc-08d9e5853a7a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 13:17:42.6516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R/4en20cU9/WPLf7lDMweDK96+VLieI2EEh2s9//uQ8p2m8x8z0SWk9R33AdKNfs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4673
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for walking me through the explanation.

Reviewed-By: Tom Talpey <tom@talpey.com>

Feb 1, 2022 4:16:59 AM Namjae Jeon <linkinjeon@kernel.org>:

> ksmbd does not support more than one Buffer Descriptor V1 element in
> an smbdirect protocol request. Reducing the maximum read/write size to
> about 512KB allows interoperability with Windows over a wider variety
> of RDMA NICs, as an interim workaround.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
> v2:
>    - update patch description (Written by Tom Talpey).
> 
> fs/ksmbd/transport_rdma.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index 3c1ec1ac0b27..ba5a22bc2e6d 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
> /*  The maximum single-message size which can be received */
> static int smb_direct_max_receive_size = 8192;
> 
> -static int smb_direct_max_read_write_size = 1048512;
> +static int smb_direct_max_read_write_size = 524224;
> 
> static int smb_direct_max_outstanding_rw_ops = 8;
> 
> -- 
> 2.25.1
