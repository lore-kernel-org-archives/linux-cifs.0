Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C064FC43334
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 21:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237716AbiF3Vxg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 17:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237700AbiF3Vxf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 17:53:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AD738DA7
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 14:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsdyO5saUM05PiKM31CHD8r849rdXNdYcku4M9Gs0J7VD+Bl1y6JkWYmDLpeNWnZW2TYP8ci0GFKxqPamMj9D1Ux1IjSZVkLce9oJ/HXtiXOACydQ69aqXXJquX9uwa9bWe88PzsYIrplcgwukDmgZRQYpdrNBQFddhrbxRsq5PKhkiMpIr2ec6Ckf4+/G0OvncDZEwH+ivvxLI29s2scLl5bWUk0XiRtA9znP0o+3G6PtrCCr0HHby3e/P5d35BvcQFCZFuHJYLqGCKOXs/3lX9x7sGAYPf7iXvSfKm9ZaNwJafctGAxHhCmbN3boyMN+PjVXethC2SUbPljy9otQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edglcP6EJMsLvaLzLIqvWWSjWBzfxawNIZSQZIGHVEA=;
 b=MKkfWrhumlLlOJEGQ+vWHRI9bmI8Jmu5sK2FOjaWYxX65qbdTSRfnXmZrsGz+t/OffnSmFk1Hwbr0hRhql3B6h3paH8C0Rw0MKc7lcIVt35JYYvVIbX7/bADyHdjRROPQYgdXePw+fgqKVkFRz0yOQAXPOivpGt1xfPTLdR1FWuTDTJR6PmM4iudv+VWRPwPfTOH6+hkAm9N1yfKvt53vyrPCYMxzze4VSKbPcfOsVOuGoQ3EJHtMXGS4O5jCzFubk7MT++d582NZokdvy6wYtmhNtV+JWGe0JTuDSW0sTtv6ojcj4RDU25bbMH1TS+/rVAQ89AvOcAjQErhaVzGrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4283.prod.exchangelabs.com (2603:10b6:5:1d::27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Thu, 30 Jun 2022 21:53:32 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac%4]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 21:53:32 +0000
Message-ID: <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com>
Date:   Thu, 30 Jun 2022 17:53:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close
 timeout
Content-Language: en-US
To:     Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>, rohiths.msft@gmail.com,
        lsahlber@redhat.com
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0049.prod.exchangelabs.com
 (2603:10b6:208:25::26) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8401650-b79b-4bab-c72c-08da5ae2f94e
X-MS-TrafficTypeDiagnostic: DM6PR01MB4283:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8pZiH1u71mzRGpV/cKwVBgHQNTdKRN8U5HIILMyH+5DuDDPSN3zAab9aCG0wrmWxiwQUqugx4uneFa9B8Asr/54uDNwWYGNeRDT/hh/6vg61t5kagjIBOM4zE6VY158ulL1b2XefgDcWQ087kRHdHNdt7PbctyNc2K/aslBeNm56zKhkpLtcd/aSN+N1pVuedBrXd7386aveBAkNj3BAVevpNaNzrnW3gfmPM4VGa00Epy+dvXJd37au5on8BmMTuh61/KYaDTVgB/urhY3YSUCUFo4Wve9WNcW31hRyuU1KCSG11USg4s5EkclSVe/T4bEQSV6Zy84xiWyDBzOStWolfxR5YSt8GE2qGZhIOHXk9CwdoMf4yszLN8jn04Q3bFw/QwJ4lNspfOkbjoBcBqJWnn1aUddgCmL5IC18d01JBekQ2j8+IqPPfHhx1rGFeYSWlpl3IsihPRKYjzS7+NK9oru3E69hyBSVyUupHjhtMFBaKxfTBrdg58WqoAWEfinZSYQ+6nhXqh84T3nU24UIqFW33wx9pFLTgWMfrRYojUHxtYlR+O7cpQ8kP81pxUkSWqhTWtLTSQm47X+676YlRTBmPg1Oss84kMDh4M6DZrc259T+ah8YL86hGnqJ9crPrkQ6CtnaU1Vv94EMl4RUf2H4hS+kf9Ow/aWqbCB8hOA8vZrMH4Zq3BuY4nkLksrDGgZF3ylhr6sghU99fyAczYWQedwrZxN/0DdkIOsagPLW2Mvs1DyIyd/kW4/750MNwj540SfUGxQyOf953xCbvNSdyM9klJErQZ/WR8shIwJQ7F8pDnTSPuNrhJygVBbueMZza1UhFBPROyvrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39830400003)(396003)(136003)(346002)(366004)(52116002)(478600001)(186003)(8676002)(6506007)(53546011)(2616005)(66476007)(83380400001)(31696002)(41300700001)(26005)(66946007)(6512007)(38350700002)(66556008)(4326008)(36756003)(8936002)(5660300002)(86362001)(316002)(38100700002)(110136005)(558084003)(2906002)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEQxM3ZjU0NJN2hDVlY1dytxcGNBQmJTZlZZdTQzSC85aHJ5USt0QzB3WDZQ?=
 =?utf-8?B?bnFtR0JTT1NaZnJ1VWQvOFA5WEdkTC9HSnZBNWphcUNxQ0VpS3NRMGFOOHRw?=
 =?utf-8?B?RnZjY0svanQxbjN5cncrSDNrK0JGUlVaVkliTTV0TjRGcXZmM2VtT0xXcUg5?=
 =?utf-8?B?SGEwMElkUjNqTVUxOFVzRnBGWHNPeExLblZBbGxYSDJTT1RIdHBkNXp0V2sx?=
 =?utf-8?B?QUdHdytNWGRuQnU2ckt5dGQwL3VjWER4eFJYdjBxZzN6cjFVR28vZE55cDkw?=
 =?utf-8?B?eXJ2NitNdDJsemt4SkwwMHZCanlLUTdwZDdPMXhlck5XOEJQSWFXYStpY2po?=
 =?utf-8?B?WEhsRkZLc3FsbjR4QkszNUVDQzd3T2UxaXdueWNWTFZTQ290UjkrQ0J1MmVj?=
 =?utf-8?B?Mjh1SHViQ2U0TGl0di91Yk1oMDBRV3NoemFBT2RLR092Sm9ieU1YUGg3Vksx?=
 =?utf-8?B?V3p2TjhZeDZsR3VQOFBkcnZNSDZMZEZCc0g1UDRwekxhOGY5N3diUEdsaG9I?=
 =?utf-8?B?clR4OWU1M2NrbHovSGk2aXBrcGxUcUJCbWpyeGFZQi9ZclJUekpNN0pZd0ky?=
 =?utf-8?B?TnYvK3hWNW8zZlNqVkVjeXVCQWc3VWZDTHpJTkpXZ2JKL3lna1NSY3FuLzR6?=
 =?utf-8?B?aHpDT0diaHc3ckZGNjZtQU1maFkrZGVpZzhqb3VvbEJPQUF0Z0Y0RVFMbHdH?=
 =?utf-8?B?NitYV25zc2V4TjFKKzA1QktkV0s5Y0R1UFRlSlhsWmJaUWJ6azlDL0Y0dDRk?=
 =?utf-8?B?cjhyL1BiZUZlb1IyZG1ScGc4TDBkWFFVUVJmVkJpYlRCNy9aNzJNMy82L215?=
 =?utf-8?B?cFhTZWVacHl6OFFXclZvaWFPeVk5U28xR3p5eGZaN1pEM0hrd01TM20xM1VV?=
 =?utf-8?B?V2d0d1ZPTFRLMkpkdkFnY3NYWGI2STBpTml1RVFQK29PcXpOaHNZV0t5RWdZ?=
 =?utf-8?B?Y0RocmFyYVdXSWdaN0U5TzFZUG5rVzgyMzhZR2RzbktmVUQrV0c0MEVTanpF?=
 =?utf-8?B?VXJLWFJvRkNZUWRWUjd0OHFiZ2RVbUdKT2lBcFF0M0ZPTWg3N29ZaVp1OVox?=
 =?utf-8?B?L3EyaUFFc1BiZHMvdHpKRDIwa0Jrb0dnUlQxWHVLS1p5dGlISGRwVE9HYWFi?=
 =?utf-8?B?blBjQzFkMGNSc3Z4NUc2b0JpSEJIZU5SS25BTzZEOTVCcGhlSTJlQTIvZFFl?=
 =?utf-8?B?ZVFPYmlJWU9lWXozbDFraVVmTG9jVGJ1cnRTR1FnNXNrR0Y3WGZIUG43Qm0w?=
 =?utf-8?B?WC9Ba1g3VlY2bVJtbTZJN2pDOUphVi9VYlk0QnJTMVpmck95VHlwSzhKRGhl?=
 =?utf-8?B?Z2VrWjdoZ1I2dzAxSGp5K3haQlVsNVY1cE14eHRPRFQ2TldzN1hObEREalBp?=
 =?utf-8?B?OEJ4N3dWR0RIdUhjcGZHZENXY0JLZTVGNGcrUVhYb2xxOXcyQ2V6S3UxUzdF?=
 =?utf-8?B?TWl5Q1U4eUFLZ0FOeVk3VDhZKzc5V2tiSFdvS3g1NWhUd2hKWFJhRURKUkpk?=
 =?utf-8?B?NFRjT2xZS3llVjVjb0gyRTNyUHR3bGE4Y0RQSjNGUmxhcmgzcndjcjlGaExr?=
 =?utf-8?B?Ui92TmlkK3Rqbjc2Tk1uM1RmeTRNT21wazRTMHJIZktraHBIekdtNUZoNEJW?=
 =?utf-8?B?MzFpY3FESHEwb2ROTmNBQjlWa2g4Qlg4cm1zV1BlT1EvZFFTMy9YTWNscDlX?=
 =?utf-8?B?T0tDckRXYWNsQzFIVzkwQVIxSy9vVm85YnJjZmRqbTJybGd4Z3RaaXUwUlJU?=
 =?utf-8?B?R01oRG5iY0VoM3FqY2N2SXVvTHJGY3VnQ3Ixb202VnI2ZWxxdXZMekV2ckFT?=
 =?utf-8?B?VGhIdDdVNG5DeEpJZXEyc2Y5UFRKcXBOM0F1bzVjbk1MaDNCQW9XKzMxczE1?=
 =?utf-8?B?VkZBZmlCbVV1QUp2K2M0RmsxK0FHcHB4SnNROU1CM3g2T0ZpSkl6eDdzdzBP?=
 =?utf-8?B?UTlEbXVEeUl6b0Izc3FqemppSEZqMlo0TjJ2bHJpNVhuMk5DejZwS2ZxTEtL?=
 =?utf-8?B?V3dwMVlHanBaaGw3b21iVi9mU1FEWUJnREtubGxrLzdNZDRrRlhwZjZ4aDM4?=
 =?utf-8?B?Y1dlejhFQWErTy9nVWtGZ3Z0dzZUQ0FjWFBXSUZDeWtIRlU3OWVHbVoyZXhz?=
 =?utf-8?Q?bt4w=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8401650-b79b-4bab-c72c-08da5ae2f94e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 21:53:32.0019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xt94htZY3BMvYSuLXK0cr6zuaevf6/QH2XTqe+i8dHjbyBT3KN8KlBcIU+plbK24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4283
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is there a justification for why this is necessary?

When and how are admins expected to use it, and with what values?

On 6/29/2022 4:26 AM, Bharath SM wrote:
> Adding a new mount parameter to specifically control timeout for deferred close.
