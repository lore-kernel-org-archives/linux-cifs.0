Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA8CC4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJCO2H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCO2D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:28:03 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D05D5281A
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:28:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEMVUwtscR2+KfKXz1SIs6f5lBdttUKBpbGZAj4e6PcJFUKBlWwF8qRmqi1t2wS1PNZmFz3rip3zPYEufQYLQAqRoZ8B9FV+6rImsRo8z4iaSGgvszLJ7hQAN0C0ztKXSeGYvWTS/9beTsupp+gP3duJ+5Yp0tOaVw5JB7v2NOcUvKC7s1MWd9w8TBrbyCsv2B2pADBNksKlce/XowbJ4DEUDg0XRlkdaDI9lSoIu5cuI54syucCH0vxG1D4IC/tSO51Zj3aAY83q4aV8ioaKEXiknLZxR4bNj+NaAyFvrDqJyO7cL+tSZ6nFvdi8bvVs1miYNhNqfJwmuHWsIeUyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH/0uMMs5hrSE1nYSqpOLDBb64gK3YHQEbBQ3+l52QI=;
 b=FOw5Ml1kfMLjZ8LjjqBXtfM7GIgnwlyiqexBR5+kHfUGUyXQTR+BdDHdLOhDMhQS4/2K5zPsbRURm+KhZYC9ACzFLdUAp7wTAceOU629CYL9dv0JRdwtElJ0ZPJ+FEuv24b+HBmTJCFFcLNTd5SB3Hh0yoLTkMX8aVeUKeOfyzmx/Co6r/DUoPUlZKngTXOhB378wXDsPySKq6IMEhrcBWbNh54Mqgk1ZIgx2bK018kzXQwxGTfQkQuHukpR1AvTbsYjgXQIx4wrp5Yyb4nlmRnoXk3qkWeuEwrkbq0Kf+aGrVAgMMZvCUbrS2+Qn6D0PboQ+AZHLYwg4BOGNBy8tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB5123.prod.exchangelabs.com (2603:10b6:208:67::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Mon, 3 Oct 2022 14:27:59 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 14:27:59 +0000
Message-ID: <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
Date:   Mon, 3 Oct 2022 10:27:57 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:2d::14) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR01MB5123:EE_
X-MS-Office365-Filtering-Correlation-Id: 38a5bf81-e83c-43dd-e754-08daa54b78a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VxGRLXz0EPBgCTrXMv88pRtRAtMYXktbD8LHo8Nk7rPGCwGJ9KQphs3QAFDggofbt2xMCk1jQo/LsbBYWBnLtoesG/CFYHTMmFo/Bqqt+WuBgGYQtUAlQq94UKl0uvls+ZJLRvSiTJyH9Xtmq4QJdaIrC882mEaQTRTnodt+2SKgGQNeYL3fleUzOrQyCH1jBzMTDNj7gRi8Uufzq3DlwnmpO+p9XZrAcPfl1WmU55vxir2j6T3CCnpG5r/cDXx1QwB8zJoHi+kwXbChZw4+uZgXhJrPq+8STsf56+mFkrisHnZCJu+8WZcKH0nZeqved27ckeOq0/j2N+W/zaNJyMggH8/6c+Kb4c7CX0G08P829p+E1iRu3l3Uu3O+ANP+vOZ9HSfTwNnfNSA/tyDJtLCPq0P3FjcHO0Uyst9TwpZHnSuhljrn3vd6kkqvm1c/ndLNzRequAOjivb7lGY9B30AECbi/PJEqPzVfX4g30x+RZgo7i1FQC5B8bH5/4Z1EHX0NRpCy176j9GOwHEgc8y1wEU8T/jk74gC6bAxuHIF1zPhTwb/cggKUUkGbm49XyatxeKFRgsyUxidX2Wmb5qiMi6QST+lQnng2fvCGJcygCjVRcUN7uRQ5HKb3g0y3uySHLgGb26sZxwoP5PVmxrIOPSYpw2JSzceL4+vuQQXLI9/bdwhYBkEN6jYhcqutm3Et4JlxkuuUrXXI6D1aCHEmqj/CHcdTxSmNBv9giyy84YsacmWyyFPNJIQXVgQPwoFUbFsuY1txz4biMsdXXK4i/LpQxHtk9Q387T0t8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39830400003)(376002)(451199015)(52116002)(6506007)(31686004)(38350700002)(66556008)(66476007)(66946007)(38100700002)(8676002)(45080400002)(86362001)(31696002)(36756003)(2616005)(53546011)(478600001)(6512007)(26005)(6486002)(186003)(2906002)(316002)(110136005)(5660300002)(83380400001)(8936002)(41300700001)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDZsb2ZVWnlzeThhMEo2SGd5Mis1ZUhEenlRYjZWRkZEc0NkSGVJV2ZmamQ5?=
 =?utf-8?B?d0JEZzU5NXVLYld2TUtBemhlVDFQdFp0a1lBY1Z4WDQ4bmgwRm1QQWdqUm5r?=
 =?utf-8?B?OExyMndvZXZqN2FPaSs4WVpPRXd4YTlHeWtVbmNzNi9XWmdKT3JSangvWjRU?=
 =?utf-8?B?WlVHRmxsanIvL09DY1YvSGVoU1NQRXFxUkl1N05QTTlXUTFxdDNwVXJUV0ta?=
 =?utf-8?B?TFM5Z2I4WS9mTktzQy9qTmw4WWM4eWgvVlc4L0duWU85ZStQNUM1RHVGLy9Z?=
 =?utf-8?B?cHR0NkVLaTBVU3g0aG1DV3F0d2pwKzI3TlZKMXVMT2RZL2lkS09WWFlhZzln?=
 =?utf-8?B?bklvN1Q3VXVubk1ZK2hDM01kYkxHL1dBamUvSnV2RjA4M0FKWFNKMmMvdlVG?=
 =?utf-8?B?NEZBZVVDVmFlQXhnclNPQ2ZLRERRakZNTkhEakRraElNNTJ5bk9VSjBFS0tT?=
 =?utf-8?B?YXBCa1BLcFlLL3hyRXVFVFcydzB1alB4cE9qL2IydzA3Qm96VTU5VnM0OGhU?=
 =?utf-8?B?VDVmaHZJM2tFWnV4WDh6eTZhcGlaK0RhVG4xM2ZvcXhNSG1nYys4UnJMVHI4?=
 =?utf-8?B?bVl6ZlZvVEdPWFpHVFIrdk1Tb3lKYlNUdmM0SC9EQzlsVWhMa0lBTUtUWHJ0?=
 =?utf-8?B?T2ZuVi9BQWdGRjc1Z1FYTm5uLzFaQlN5YjNjM2ZkcEt0YTlGV0xUcVBzV0l1?=
 =?utf-8?B?K2RDQW53UlAzM3h5ZmhXUTFhN3JiUmtIRGZLRm1iSGdPRVNsQUZ0MzRGMW5R?=
 =?utf-8?B?b0QraGxHUzV2T2E4UkRZZ3pEQzQwNTg2RFkvRlBBcFBoREU4QXlPYnVoV3Fw?=
 =?utf-8?B?MFBrcU04cXVZY2d6TDRBd3drRFo1TE1aMlBMaFBIeFFMaXdNcnFQNjc1WTdZ?=
 =?utf-8?B?bjJ3dmJ6Z2JZbEdiOExuY2d1bFVtWDNlT3p2RTFCVXNhU0YwcDg5bUw5Vkdu?=
 =?utf-8?B?bW9xSmg1a213dnVPSmNqY0NQRlBwSlNGRldsQmRGTGtodjdpeURPZXpiU2ph?=
 =?utf-8?B?bnYySWdGQUZUeUw4ckZHVEtRMW1XQ0tYMVpFSXU5djFYOVlWNUNtN01xdHRm?=
 =?utf-8?B?Lyt4SHh2YS9NaXAzU0pZR0dnTm5MU01WOS8yYVFjTEFvTDZvUnVqT1Zzd2ZG?=
 =?utf-8?B?ODZIQjJiNlZId1Z2eFJjRHBQMkY1cittT2hDOCtBaXNEYVBraUM1VEtqeWtE?=
 =?utf-8?B?SmFUYnlvSTBaNGx5cmpEczFjSXVPR2N2NkpvNHdWVTFqckswQVEySGhEN0ZR?=
 =?utf-8?B?Umc0eXZvWDc5WC9BUFJSOFFFVnViaGwrQXdyNHJTQktBUEc3WGN5SFhaKzRn?=
 =?utf-8?B?SHh0bkM4c0pBVjRMY1E0UDhzeG9FZFFsdnJsc1BtdmlIeTJHRmJ4bERiakxI?=
 =?utf-8?B?Rk9uT2dLZjU2NDBwQlZxQlF2b2x4YTJxTVlqbERZTkN4KzRTQTFud3g4NE43?=
 =?utf-8?B?QnBYSXJtRTluaDB0a1d4RnllMDBqbndCM3lpZlZ3cWZmUjA0TTlSb3ZxUlht?=
 =?utf-8?B?b3cvbWU1bHFIa2lTQTUxRlRlTGZ6amo3aHd1cUVKNmZxd2lZaEpjNlcycVlV?=
 =?utf-8?B?SXExa1JRSzlaSjAxQ3ZWYkEwVVdWQVI4dkYyRWlIcmJkZm9uVzc2cTFNejFZ?=
 =?utf-8?B?aThpcVhpTmZFTVJXWkRVc2F3S3NGUVIrS2xZa3REaloyL1VzZWdPMm4va1VJ?=
 =?utf-8?B?RTBXTlB6dnp4VkI5M2xGSnFTdlZPeW45QzViTE41TmloR3Y5a2lRMnRPUE5Z?=
 =?utf-8?B?aGt2RHdXMDdHeTU2TWF4cWhNS0l2NGZKbmp2TXlMU1BhM3NZK2NKTmpBSkJC?=
 =?utf-8?B?QjZ3NERKOTE3MVFZdWJtbXVKUWZ3ZU5wVEQ1WkhDOXBWZ0c1aEFjK09RWlV5?=
 =?utf-8?B?U2dETmRRdW9MZ1JEejZBMHpMd3FHYTcxQXZ2WFhETzZZWXU3MTNROEl4cXYx?=
 =?utf-8?B?aVFIQVJOdjh6SjROeUhpVVZYUENwbnNoa2FqRklhY1NlUnhxek90MklIWGZv?=
 =?utf-8?B?amRLWVdjS3pkWVFzWFVPazgvMFZCdFAyTFduZlJISGhrd2lWUlAwT2lOZ0xS?=
 =?utf-8?B?THNoM2w4OW5kemVVMW5NeThjYUQzdlVtZEVnbFR6bjQ3a2poQTUvdlF2Wjh4?=
 =?utf-8?Q?1b/4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a5bf81-e83c-43dd-e754-08daa54b78a3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 14:27:59.3046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OnhaRmPsF7FTxGlOPYxzMeMcm+JiXKpCUnIP82aNNNbhJ3HHIRe53pqnsEzH1Tu3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB5123
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/2/2022 11:54 PM, Steve French wrote:
> shash was not being initialized in one place in smb3_calc_signature
> 
> Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> 

I don't see the issue. The shash pointer is initialized in both
arms of the "if (allocate_crypto)" block.

But if you do want to add this, them smb2_calc_signature has
the same code.

Tom.
