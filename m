Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04C1C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 15:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343931AbiDAP4M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355304AbiDAPOe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 11:14:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98A32B3D5F
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 07:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nf6M5VvHQ9LwqXc3W5s5z92IvdVqphH+LwGir98eZXVNlRQssveuY6jpkYSrbjdWf63bCUSwqL5Qm+SUypKekE8RTuZmOrgu/KznI2Z/mPz82mhki3ZJupqTcbWmkvaBAIdyI4I1kmlwwSd/yNJxRGZQsH9A0N0RbVR2ca/nZf6cQJPDQ5f2d5loS+BWGsVS3wDkEOwRszQ3/EJ4f3W23pXOx5tGIbsbmvOTQcoyOexTcuwAeLP115GL849342PK0HTNAJRfLzc9CtAdrSDe5hl4xt/wRspr9GpdSWuHb9lsi7X8zg0CiEApfRqgAPO0ZhG6vREXfwF1d+RDDG6VAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KI156Ce3DXd3dNofbfpFbfx8FDoCSbuPxirXCGXFtFQ=;
 b=BOYwQCjoqroXCaOKVxTXUlVP/ut7pKL8xge0S8O1XFhbcuA/2e69X9Cu+Ak2MIlDRwymLum8XhsgXVqzPOonwQJ7xQP5M+/xL39w+8r4zinRnksOMvkK/VSkxRaMDTM/ZY9G4S26aFCDAInOguU8bJIMvUnk5O0bfL3DRB0WJRZrGr/fX8fy+UOD5+c5fWABxwyseLWpmWAEsF6HMRtvIZ/Vga9aSmnGRZLdCkWIMgcw871Ft23qN/PCktRrB+sXbHxhewQhTfaLVWjL3Qz+HSLDBnZNIAyslGbz7Y/V+oIF2qSQxNa+BLRZjFzPHsl6gv2JbQJLL2mFHCmUmKDWbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4640.prod.exchangelabs.com (2603:10b6:805:d3::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Fri, 1 Apr 2022 14:56:48 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5123.024; Fri, 1 Apr 2022
 14:56:47 +0000
Message-ID: <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
Date:   Fri, 1 Apr 2022 10:56:45 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     pshilovsky@samba.org, smfrench@gmail.com, pc@cjr.nz
References: <20220331235251.4753-1-ematsumiya@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220331235251.4753-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0392.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::7) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55ded2ef-5a8c-4d6c-b56b-08da13efd841
X-MS-TrafficTypeDiagnostic: SN6PR01MB4640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB4640B1DF609A908A8E2C0F0BD6E09@SN6PR01MB4640.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+qpPnr92x79AWbBgAYsYcQqtUdyIRzGuCdSXDYq/i6ZexKxLvWrR0DhzEMrUGB8YbFZAyHyvjyLveBI102CvyIzgbuX6z6Reg9pZolPrqV6EgGma5I3Anxycv9BFNNsFVBezTd3NlRkciMYB6J/qkGKaUHakFDCGwLKmBEUaQGprstDO9iipn41dPfODZ3lmnJU4FTkF8m1sIcj8ZJCJsFEiiyOke21utETJdAx5I7HuMBIXFFdIWR15cjkOVK/krkT5S2ms3hSNyj2bdSuO7Ld0LcY+QRhPRgc9hma0X11IDUK/jG03hqxoygi4cwz+p0tSqFSuo1Fn9g2B4jp7L1eI7cUoTV/HoRr2RcBxadxpb6ip09uA+RIZ2YI9CHo0VCRuoSHNxNgplZrTIGysGCiDK36Xa1PfNqrzpGJ0q9tMWnoAmmGPF0HJ1TNdxgjN48wCoPXqQQoIIwTbNLthI8XRakt0D6GRXXUE3hCEBdFDUUAu1Nv23PepEy882G1nhbsOt2OcIkpBVRsNKe0J5Sd2OwxVKHdFK0mu1YtKJq+6xaZbTHIC0XzIAjuIKjFF3kyuiaBv6Pktx1ct2Mew6Cv5QzXARQpDcs4UDN/IG+4CCknclFEtw5rqs1oiec+YElEpnZX50jUa1agi27e9Yn0Xmj8TCMJbqgCYzEgR8w5R84OszwKknUqJYS9yvIn7bBLqsM3pV12B7LFfdvDCjutC3HITlAO+9cB7QbwyZk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(136003)(396003)(39830400003)(376002)(8676002)(6486002)(66476007)(186003)(66556008)(2616005)(26005)(316002)(4326008)(508600001)(38350700002)(38100700002)(31696002)(36756003)(86362001)(31686004)(66946007)(83380400001)(2906002)(6512007)(8936002)(5660300002)(6506007)(52116002)(53546011)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVJRRWNoYmpmV3h3aUVjcmJVU1FuSjZObERheDdpWjIwUTJMU3pwL1NBLzhX?=
 =?utf-8?B?dDRiQm00aG0yU0htUTJ3b0JDL05nOW5wWVN2OWc5WFRCaE1KcTV6cEZBaVJG?=
 =?utf-8?B?WVJhTVNQbUhyYm13REI4aGpWRmJ1d3ZHcW5oVjlOUlVzTUg1cEpJU2tETi9k?=
 =?utf-8?B?VlQrMlJtU3k1czJWdy9kT0pGVWZ1SkpBY3JFelJGWWt5OG85ODJNaWNQRStz?=
 =?utf-8?B?UTlSUHN3cnF6WUNQRGN0Vm54UXNRc2lFOURLMjB4aXRKaGtBczU3dFFDZ1JX?=
 =?utf-8?B?Qll6bFFEc1dPWEx5TFZYbU4vWno0cGxHTlFkR0wvWHpOTTl0NDFtMGEvUUl3?=
 =?utf-8?B?V2ZZN05tczhiSVVPTlBERjM0UGRCWW85WjJHdFh1T3JlU202dk5rZGV2SW5x?=
 =?utf-8?B?Qk42Mm8vbytsMnRQSWl3VVhoTUF2YTVtWUJubHl3WkgzUVRtdy9wNTRyQmhS?=
 =?utf-8?B?K1B3T3REMXhrcTRlRHVJZGxaR1krbUR0cFVxREFRZlNya2w0RTdKOWpZTXho?=
 =?utf-8?B?NDRLWlcybzVkc1pOdVNkNVJJMTJmZlZuVnE0OU16VThyK1lhY3lkWThpSWFr?=
 =?utf-8?B?NXR2RDFvK3kyQnFsRHIzTWpvVkJlaGc4NG9Vd0MrVG00eEhVbk5CSzJ1eUwv?=
 =?utf-8?B?WHlDbGRxcTJNSWNoTk9kaFQrNm1MS0lWNUlUekNJczluRG5yeFpoSjhBNnFW?=
 =?utf-8?B?RjRiejR5ZGxqcXNManlNYktpTDBqWThlbnZSWi9qWDdjMFd2cWh2UGUvVkFp?=
 =?utf-8?B?eElueGxHOUUwWHliNXB1c3FiWkRxWDd5ZmZ3ekZRa29vQ0pldzNmT0xqRk9j?=
 =?utf-8?B?YUtPTW1oOGJWeGtZV0NBeVNqazNielFXZGRocGdhSFJUT1dEUlVRcUk4U0lR?=
 =?utf-8?B?RmRPZHdoeWI2Sm1qYjVTRlhxeGl4NTlOVHZYOTJSUDFOSDFYekVNRWN6RGln?=
 =?utf-8?B?V2F2RjYrYys0Q0NlR3YvRndDMVIyZklLUFQzT0FjRGZ0K3hwSXZDeDNDZ2Q2?=
 =?utf-8?B?b3B6YkdWZVpzeiswVGcvR0tnVml3bUI4cGJZZjhEM3BzTXFDYWFPNldtUWNF?=
 =?utf-8?B?RWRvTjZoY21icHMvN1FWYzlVekluNmMzMmJnYXovU2k2QmRaU3MyUUswcUho?=
 =?utf-8?B?YnlKMVdDTUwwd0tWbEh3amhUdDVRaWVNZWdLQUJGd1U4Q2NwaC9KTUdqbWxY?=
 =?utf-8?B?SWJuSlFrbEFCdTQ5djdzV3dGRUFjeXZOUk5XTFJDVmVZWk9MY1F5KzlIanFQ?=
 =?utf-8?B?SlM4enY5SmY5YjAvY3M3b0FrWEF5SWFnVkw4Q0lweFRxdUtUdjhNa09jRGQz?=
 =?utf-8?B?MFR4MUFGZ2t1QmZSbVE2dWRxRVFPeG9wajhscXhvL3hxMFlUMnhVM2lzdUpl?=
 =?utf-8?B?YzFST1BDL1ZaM0o1RmdLbVdxb3NiV29LclhIbDFIUGU3QWpYcG5YV0p4UzJB?=
 =?utf-8?B?R2ZSY1duMWF5cVF1MVJSN3h0Q25tMm93WkFlMkFNcjJQK0RmY2o2Y2xYK0ts?=
 =?utf-8?B?RjhqN3d3cktNRHBpeUdRS3AxaTg4Q2V1b1JPb1RTMUlBZ0UvTUJpUklhN09F?=
 =?utf-8?B?TGY2dHQraTB1Vll1blJxTElvSlBOMnFZYnRua2kyRFhkc3M0VXJ4blFXT0FG?=
 =?utf-8?B?ZTdRdGxVQUtJQ2ZxelloZjAvVmJFS0tMc2N0L0ltRzZuQmZoUGxnUHVNbkVC?=
 =?utf-8?B?YzJBR2pBM216eEN0ZFhNMHhIcVNYM3ZpN25VbDJOeEtoSHAwRURGcm5hQ0FD?=
 =?utf-8?B?c2NpS0lWOUg3MjIxNUxNYm5VSDBkejQ2R0tVdHZKZGRmcU1YTkJiQmwrb25X?=
 =?utf-8?B?N25BK1V5Y0NuRzFSZGFBQUhBM1dVR1hTcTdPelpYYVNQNVROeHIxdUlKVGp2?=
 =?utf-8?B?UlY5WXhBRWRFbTdGMUp5ZFRKTlNKa2F0R01PekRTK0p4M1ZEMTN5V2hBNmxu?=
 =?utf-8?B?SkNDajNWczN2NXM1bkVBU0xvcjRFMXg1ZWFZSjMrK3pHY3N0OWZpdWlMQlIz?=
 =?utf-8?B?NFkva0dYRG9ITDBSaUlTWEVVaUhCZFdCbUhYaFd5MFZGbFhaeFA0UE45Z2cx?=
 =?utf-8?B?eENkZ2Izc3Qra3FmS1ZFMWZERW56a1hEVm5ZTmxKZmlXMGhPVEhJdHd0d0FG?=
 =?utf-8?B?bVFQYzZUcW5KWmRLNGowbTFpR0Z0UStpb2dmVW1WK3FTVE5WK2Y0UGhuRlhv?=
 =?utf-8?B?NTMxR1U1S0tSaEpmSUpKQWxQc1dmQTlEREFNN2Nobzl1dS9KbG9CTDZtcEhS?=
 =?utf-8?B?Rno1M2FRTXMrQStzNkY5VnRhc2RVM0xZTFdIa1JCSjVaYVZ6L2pQNjRrS1B4?=
 =?utf-8?Q?f6b2/eTDiEbMMkhfkF?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ded2ef-5a8c-4d6c-b56b-08da13efd841
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 14:56:47.5299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IBRpj6Qrt2g1E2swh+nHXrjQ6FdInVMXz8r+gVt5qoyb1rQBBlKIJUQV66jzi+uA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4640
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 3/31/2022 7:52 PM, Enzo Matsumiya wrote:
> Add FIPS 140-2 compliance information regarding mounting SMB shares.
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
...
> @@ -624,6 +628,9 @@ vers=arg
>     kernels prior to v4.13, the default was ``1.0``. For kernels
>     between v4.13 and v4.13.5 the default is ``3.0``.
>   
> +  For environments that requires FIPS 140-2 compliance, only version ``2.0`` or
> +  or newer is allowed. See section `SECURITY`_ for more information.

Is SMB2 really FIPS compliant? Even if it is, a server that doesn't
support anything higher is obviously far out of date. I think it
would be better to recommend, or maybe even require, SMB3 here.

Tom.
