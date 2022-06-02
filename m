Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A978C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 18:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiFBSjk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 14:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbiFBSjj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 14:39:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482FDDF6
        for <linux-cifs@vger.kernel.org>; Thu,  2 Jun 2022 11:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ar+B2y/kDE9rRwmgjSvf8zLhtkLnNKS5NU4CJFqhQV9s+q9epFM3hk3DRD4Jav2GNihAicZ4/ntAUe8TmwNvyoDYTgUGHPDFK1s8+CCKXxPacE06V3BGw27CvzJgHBENUn534c17vKEciWqA3YmRb0N1yozZQQ0Qo7lFho9FOHlMcEj5gvoLfBHiv/zqBBQg0sNYnZOm+ZWibyBNAV1MIZKPBaCrqwFGmAbuFjpc7qyjEMhnGt7OBETmX0tF3peuZCs21JMRgtDziONrSQAHeIrKWjDEcWSDQSYQsKxvf7VsOccQ5NKXUqGoDrGMtbYQ4UpC5ssk/1KOVCwW2Uvujg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F34sJY98foH5SRmj/Y0oxdI7BUFaFUDlJ7NVNLmuqwg=;
 b=TF+UgJWkbLXBQ8Hptm+Brzc4S9ky8EhkjFxN2Gjfwn8lmq3W4eaI5phnOluKpQa/tuDwA8UUD3GB41ES/r2rQPmAduA4jpCpSMztZyaq0B/DuibpUsDrJ+CQjW1X18cVMWHOevv8GeZPvf0j7lB8Xfx7qfJOp8hGT4/YWmtNz+Wtmz/yBLa2+R9oDH29EQP51h8/BwBQoYAD/TKvSM47w0WOfoOjehhWbHtnZ0pJt6+6HL4yIYaeNDIdz+4z4pi8SjbUOEbbWo9qz8CGy+49SgOyNovcH4SO1pPhRRcyPVCldM/svKTgiwbkJPgvSun3gRCPBvGZP87NjAp76TsglA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR01MB2585.prod.exchangelabs.com (2603:10b6:3:41::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 18:39:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f%7]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 18:39:36 +0000
Message-ID: <359a28c9-1d6e-6908-6502-ffb29bcadca4@talpey.com>
Date:   Thu, 2 Jun 2022 14:39:35 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH][CIFS] Do not build smb1ops.c if legacy support is
 disabled
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mtUe2f0xi5zu0Np0bkyv7K9BKKgUkUJp2b25BteHBFjeg@mail.gmail.com>
 <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mufZdKWrUGbp0Pha5C6YrYqUR-=vT2Pw8TixtzVaQuk0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b84cf55b-83d0-483f-ecae-08da44c73e86
X-MS-TrafficTypeDiagnostic: DM5PR01MB2585:EE_
X-Microsoft-Antispam-PRVS: <DM5PR01MB2585B2E2BE06A1160E359D94D6DE9@DM5PR01MB2585.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZVJKe9oz3IjqKAufNnZOnz44fDxfS1/Zln8BR/Bx6bPOcaURdnNGdsiR4jbGcUuHjZktrFPEME7Rs/vbzEn8Fewm0EZ0/ufCo3otn4uRb7r6NOemZV6IykEsyN48HmfprVtRLTrKbh3uglYdgGHV5nFItScV2Pkdh6VET49haF1O7X0lIzFsPigynJZ3a6d8eTDny+aZHzBOozVVZkmDeNd+LtQ/JaIYWQCB752eos89McdMVi+X/uTDjSqCi7Qj968LbTpA6/xBD94SJzkNeulys7tjo+0zMydOccYNoQZe+k/Al0Ijkqwr7LUZafRmEgXnmfpm+ETg7FrxvWWUf2QO866umPu9B3l/5qtfg39AFDaZKCaHbRAdAEeECki7HYmOt6bev9hfjCnQdAhZz7+/GzlROrCjBRSpK+4wqHLW4tujOkMXsYe0DYahZ0lVRhfPUGU+eTTKuPbeBfn6jmp0Jp1tu0a7NL7oFMZTGtnvXsBdYF7bGV+reB6A2okaAauOcqvyyJv2HLkTy95eqQttc85aAf9TkkcjFsexjp38mtHJHGMRt/xV9XfvaaB+FIkJ0XeoXbrWy67kYHJlVLa6RMtwTa7wTp0QiVNngec6tYqIavjh5uIzTjxKCRAdkXEllDalCzpWm+UtBgC4Ehz8LqOd/QUYNpDKlok6BT2DdnzhSjl7ZVC8lJ5Q/0i2JLUbjzAP/E8bRYmeByF0R7z4S3ECJMWN6p9bLZt2qj3nB8ySgoDp9X4vRYjtFuD5cV6+j1t6iUzUpwYIan07Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(346002)(376002)(396003)(366004)(2616005)(110136005)(41300700001)(5660300002)(4744005)(66476007)(66556008)(8676002)(4326008)(38350700002)(38100700002)(6506007)(8936002)(31686004)(186003)(26005)(316002)(86362001)(83380400001)(6512007)(36756003)(31696002)(2906002)(66946007)(508600001)(52116002)(53546011)(6486002)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkNGMzNZT2ZuQXVPT3pISjNkR0R3d2NiVjZ4UjlYMDFwZWZQdnVYMCtjZGtJ?=
 =?utf-8?B?eW4rV29VVjVqREVSeXNIQ0hFT2NZSTJyTEsvUDR4SkJ6YTZiTVdsb3paSnM3?=
 =?utf-8?B?YllDckhIQStmTGNCOWIxbmJETFUwdGdwUm9Uc3FIM1ZCZy9vNlF0SitQa1Zs?=
 =?utf-8?B?aS9RdHVidFdNTFNScWNhQmdvZDJMb0x6WnZoNy9nSWFZTlIzd0hxSGY3RnFo?=
 =?utf-8?B?QnNRVWVWRmRPb3VxT2N0djdQS2UxYXZpUXV3dktyaTRjejVWT1Y1ai8vWDlz?=
 =?utf-8?B?Q2JnRklyWTdRNTBCTUJsQWNXMGNqLzlRWFhucTU5OXV5Tnh4QlVYS1ZzZ0or?=
 =?utf-8?B?c1NqeHYzS1pSQ2xyZGVUVU5zYlkwMDlHNUdVRU9QMUFuaTdXZStKSGpkUHFk?=
 =?utf-8?B?V3crTk9qUGRqODVtS1c0cVFNa2pEU3ZNQmpSYW1ncmFPa2dKSkJXUllOOWNZ?=
 =?utf-8?B?Nk9vdXRLWWhFU2hvTFZoa3Y4UEE3bXdVcmZ3Tll0cXk0d2Rmai9pS1orUURF?=
 =?utf-8?B?R2owR1QzcjlVeWV5YTl6N3NjL2FBV01sMDBHUFlZOHJNTFQ2MnRTZytXRkFT?=
 =?utf-8?B?S1dOZXozRlZoUmNRaElDNExpZmtyMmVCMjEwdlp4WjVqSy9XRTUxaUVaTUhZ?=
 =?utf-8?B?d3BmNU0xZzkyK0toV3hlTlVtNVdMd09TeU41NytPK1JqRmNoT05iUEFPSFNo?=
 =?utf-8?B?Sk5FdVVsM2QrZjJ1WUlmbmRMaFRSbHdaSEQwY0sya3ZzS2FaUU1IU2VrYXZh?=
 =?utf-8?B?ZE8wdTY5U0poZ1hyWDNQazVpQU0zaEhydHR3UmxhMy9GK2ZReFU3Q1pFeEo5?=
 =?utf-8?B?VVIxdm9Oa3VxUlZpeWwvQUZOTnJZK29CQlpZeWJydUpqVkZJeGR5c3krWlR0?=
 =?utf-8?B?T1pkaC9TQW85VWJwRDhqaG1sRlhaaXRuZjZkTGVKUUZFZ056NXQvYTE4aFVz?=
 =?utf-8?B?VnZPb2tBandzbkhnd2JRemViVHpHSC9jbXpIQiswc3V6cExJbk40UTVFSUgr?=
 =?utf-8?B?VVM3TGNLK0Yxamw1SlpjdG11THhUNlUrZHY1bk1tMzZRWnpmR3NlTGk5bXhn?=
 =?utf-8?B?a0tSQXl2YzJIZWp0TVJObFdlSUdwa01wV2lTVm5JcFB3Sm5LNjd3cnROSlpa?=
 =?utf-8?B?Vlg1Q3hENHNORTJxZ3d5eVhOUkM3eUN0MWZoTnByVVdyZmpjcGc4cUVaamhu?=
 =?utf-8?B?V20zdGRmdEg2SjZPS2N0SUREM2VXdkUwZ3NnS21JdDNTeDB2TkhjQjFZQS80?=
 =?utf-8?B?ZU5xVHk3eHU3MEh0MUFsdjF2LzBWQ0NWekxRbHVBaHQ4YlNWUEJ0K3hpZ205?=
 =?utf-8?B?NldkQjllT0puRWlTRXdXYjlSMHJMbjMweHVTRlB5cDFNTnU1ZDFMYXdGMWhR?=
 =?utf-8?B?YjVyeVY4RDlZWGwrb0tLY3lYMmxHUGRJeGhDSVV2TTE0TjlhTDYwL0R3OHFv?=
 =?utf-8?B?ZlQvbXg4OGdkaGFKYjFOY3hyRms2VGhIY1lPM3ZuWGFmZ1ZGZWhZbnBwYXVH?=
 =?utf-8?B?ZXNhZkp5ZWxiZ3krWlBxVG1OVWM2aWhJaFp0VmVvbnZkKzBCdmk3TFNnUUJ5?=
 =?utf-8?B?bkpEa0hOUG40TVYwL041K01mdCt2YTNBVzdqR3VqNG16V2Uyd0ROL2d1SlFT?=
 =?utf-8?B?UWl6MkxUUFhIMHY2WG5sN2VlT3F1Y1Y1RDNNTCtXM3cvN09RRnZsVjluSUNl?=
 =?utf-8?B?aVlUc2F1SVVJbW1uWTJQQVVSWERQWExMT0tWaTBjUVFoNWx5L2pQakwxSUMr?=
 =?utf-8?B?bW9IalkwTGxOTGxIbjNrNGZrSWNoM05vZ3ZscjZqaFZEYm83bi9vTzNjWnQy?=
 =?utf-8?B?TlREbkVhTEgxOU1UK1JxY3F5b0pWc1FNY2ZUeXM5Qk5Uc2cvcTJzaUFnd0t2?=
 =?utf-8?B?b0dRUmFQakJRSWRCZHNId2VOZkh0ei8rb1A2Nkt6RFJIVWw4VUxqZUcrbnEw?=
 =?utf-8?B?Tmdzbi9nWk5vbXpaM2w0ajh1b0tyL3JqTE80QUdQWnUyNUtiWTZNNzF5c2Qx?=
 =?utf-8?B?akRDaXRRT2RGa0VkSkJRRFlQTFczT3FnamlGV0lFYVFYU0l2ZTVtOEVFNTNx?=
 =?utf-8?B?am55Q0VzTmhUOVV5NjBDaEx1VU5waVl6VGhPZzVIdENBTFhPbWhDam9XLzVl?=
 =?utf-8?B?dWVvODdyUDZadS9uc3BRYWNlSjVDR0NDNDhnc0ozbHN0VXJPNjJJTkNkbXJP?=
 =?utf-8?B?bTFhK0NoeEt5TnZvaHlLVjZUZzFmWFVaMXBNQmJnN0xZQ1hPSjhoeEdGZlRP?=
 =?utf-8?B?bG5QcWNSZ1dPYjhMUzd6dVJVMWVUOUtLOEJRT2JxZnhzaGpJaUpQVVY4SWU3?=
 =?utf-8?B?WXdMWGNDS1JBcnRFRXpoK3FuZ3hhcU81Rnk1bE53WCtNQ1BMQVZBZz09?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b84cf55b-83d0-483f-ecae-08da44c73e86
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 18:39:36.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lus49uR24006tFbqyZhez59GjrssOA1oCcTp8eOaXZElh3fAsMZ2Ln6QyRgPncur
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2585
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

LGTM, but I had some additional suggestions that I found when
researching how to yank the entire SMB1 code into a module.
Which actually looks quite possible, but for another day.

This patch doesn't actually stop building smb1ops.c and cifssmb.c
however. Don't you want to deselect them in the kconfig?

Feel free to add my
Reviewed-by: Tom Talpey <tom@talpey.com>


On 6/1/2022 11:45 PM, Steve French wrote:
> Another minor one to remove some unneeded SMB20 code when legacy is disabled
> 
> 
> On Wed, Jun 1, 2022 at 9:39 PM Steve French <smfrench@gmail.com> wrote:
>>
>> We should not be including unused SMB1/CIFS functions when legacy
>> support is disabled (CONFIG_CIFS_ALLOW_INSECURE_LEGACY turned
>> off), but especially obvious is not needing to build smb1ops.c
>> at all when legacy support is disabled. Over time we can move
>> more SMB1/CIFS and SMB2.0 legacy functions into ifdefs but this
>> is a good start (and shrinks the module size a few percent).
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
