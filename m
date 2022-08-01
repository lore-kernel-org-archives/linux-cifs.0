Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2A3C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 19:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiHATSF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiHATSE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 15:18:04 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E53326A
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 12:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/QRg65dEn9fLtjAZPEeKmuGUBYZDuNvgETkFAfXNvijAIVtkC6dt5SPZcys2mJG3opXfpDUvTTO/rXwMpHytiOOWQkVkSF7mQ+dOPLy6vTrsJz09DKUuPF3/3W+HRvPc1po+FFBGHjjT9ndqMg8ITuuOlI5zouJ1D2ZiggxfHu7C0KrIOpamnoFHrhggx8cEwo+G2YrIY+GGkYadiPVGTxKkAxJZXPDhmS4n664oCyo5WFsjMkpDP1HyguhNKj7afeMLWIgy1EdiNmDZoc6HMa7sTcaA3loQDet+o4Iv0YGzptMB6XC4M7g4llG1Tl8QJ7McgaWgx/Oaq3vEQgxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ZMv+VLdEAkU/ztnfTt4NLrxdweaMPsQIDusa+ga7u0=;
 b=KjyDbgFvdwSrk3Pczc4OGm4glaJJjGfdpB9iBfmh49UioVCT2nsJnD2U7K+0pp6JOSEXJvN7PaWdOw4eFMZ29BbzMU4UjDWMGecuqd55L++JYwtTXcHgPz5lyQ0iLxbL6j77czyxZXo6XQ3DfTAMWSUT+1hOQYLi48sizSd8w1CPqI3QT7i5F1Nh5YDYl5dkekBNJyFcqOE1rnASc8KDmYWkDaMq20Kdhn0vRrtKjejIvWPqIFGtvzeqF2ucRgFOmYTybUgF/PBfZDGA2uz/dXqKlHWRIfSNPjfGDYHoUtq3BZLVV0NARXxBXE8OH0lWAA9A7Qc4fjMYSqKilAhJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5062.prod.exchangelabs.com (2603:10b6:a03:7f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.11; Mon, 1 Aug 2022 19:18:00 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 19:18:00 +0000
Message-ID: <570bc5ea-9354-5696-dd41-225d3883be72@talpey.com>
Date:   Mon, 1 Aug 2022 15:17:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
 <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
 <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
 <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5muP5ZgcsypLSFm1t2cE8x4n_8fmu7heoUiW5x2L6rN__Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:208:23e::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55885755-93e9-44e2-bfd7-08da73f28c7d
X-MS-TrafficTypeDiagnostic: BYAPR01MB5062:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BIM6iAHflk1hDCcchVJRzz/zcJqCKRKmY+UVXCDR15fP3VnEPOkdaYCWl/mZtGZwLJuKub0DYn3ikEGm9PV5TIF1VehgihNSLUtB6XjS5Wex+DNyBrhhrl1i+M7fUNgD2Nkoa3Y11Mh7zrTeL1lEaRYsvmX3M4uTa9qr9ZPanV87HxV/7Z51TbOllgPo1YhW/xWdDdWzfm+jiOHNF5VbyDqmp44RhPaSb5hzCr/Yubd7Y3BJ8quFkIIfNohkZo/yuUbniOenqaDseToIk6i8SD4OzjyqU03MYZkLENWQ6HGCLByqWa4mn0/tjx2gI0UiSPPY1+KOuB31S4zCWKE5aF9hmGSyothJxyVqvqxK1igOsSF2RED9YimASpxSnh7QXZmmXcwQ7V6C985jdFlSYP6adqAK/DNJuzauQnNBkbwljS0oUIBlrAeQPDTF4SkSh3G/Wwjw7h3IFKsHqceH7806liMh3rg93Y59JQveTER4bdgwzsBlIEAbXsCwVPQKR/TxSuNnJdhrzHSOBVSDykfdbkwQLSl79VBmua5qXXWbl50y7dMMV6i/YiQUdTDizJgvtmVwv78JU6X8hldwCfZSwG5xVZu8rSv9ywYjY6fwFdFwddJfOUTCwWZ9Othx3J5Liyx2dzRkFcmbyl5tIvYbUepmuiIJhvnwIfkUvM8lejGAMgHH4oe3o0Zyeoc1fp17589K4k+TDyjsSX+EkhPokETirxnmb7iyEzyiteSUP9bEB1GQr6Xe7pW1QsS1DRzcXk5M6Fu2nji8lcyQiDwNM5K7S/blh5JbWz14q1muajM4oDOW2B6aROdvrPo1uIDI/9YQBrPncKFJqITLmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(136003)(39830400003)(396003)(346002)(8676002)(31686004)(66476007)(4326008)(4744005)(66946007)(66556008)(36756003)(5660300002)(41300700001)(6916009)(54906003)(316002)(478600001)(8936002)(6486002)(53546011)(2906002)(6512007)(26005)(2616005)(186003)(52116002)(6506007)(38100700002)(31696002)(38350700002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3FhQyt0bzFBQjYwa3R3aHRpc3h1d2g2SG4vUUcyRE9xRXdlNVVZSGF3d1hS?=
 =?utf-8?B?Q2RGeit4VitTczZTUGRjaWtON0dIQjBtR2Y3YWl5YU9PU0RWVkFhWmpXYThk?=
 =?utf-8?B?OElDM1pqZ2NCbmFHWUdZYmFyYkc2TWtYSDBRbWdYYS91UEszWm1nWWNRcjQ0?=
 =?utf-8?B?MUJBQWtnL1BIem1qOGk4Mm1QZ2NhZXRRQzBVbldUOTNFZnkwZGsvWTZPN24w?=
 =?utf-8?B?T0hQK2pHU3JOTUtaZU4xTzZPZllKNUt2VmtGd1JoYnhLNGdnQUVQenNaVjF6?=
 =?utf-8?B?NEhJTi9HVFAwVVNzTStFVWloQkxwOUxzb2JiZzlyQ2NOUFo0dWYyTXBqclNG?=
 =?utf-8?B?dmovTUgyVlpGeThtTm43dDljTHp0NUw5alNxSzZnbDFPbFQ2UFFlWk1jT2M4?=
 =?utf-8?B?Uk9hVWJsTW96L1A1L1JHVjVWcnNueVVtT3VtVW9zWmxPRDIrRWRwREI2Zks3?=
 =?utf-8?B?dHlDdysvSUYxRTgyZDlpcEV3Rnh1TmRCMGliWmlSVTNLSzRUV3NsdjBpZndM?=
 =?utf-8?B?aXhadzFoV2tvbThXK0VhaHNvLzVrYnMwdXUyOGRiZWN6RmNRZndNUEJINDAz?=
 =?utf-8?B?a0NlY0NnMzVKS3pBZHBDa1JZVWtjTHpFcU1pV0hua2l4Mjd5MFEzU0UyQ0Jn?=
 =?utf-8?B?Sk1hbzBTeEo5MkRRZTl0SVRoU1ZDU0hRa0srWG82RTJMaEQ4R3dyQ05vd2x2?=
 =?utf-8?B?TEtqY0NHcUE1VEc3NUc0RGcxU3c5QVg2MkNyaG9sQnRjY0UyT3JpY3hhK1ZT?=
 =?utf-8?B?N1pxYXIrYWJxTWlmVnorMEtSb1RPOW1udVpacHdlYTNKVG5tQ2dXUjRrSWxE?=
 =?utf-8?B?REM3MTR3MXdYdy8zSGpJemhNTzZlWGE4VjdkbFNwZG82QkM3d25MYjVxUTNI?=
 =?utf-8?B?NkRyMysvVnp2UVRmNG93dHh5KzVGeVJtZUU1a3QzYTUxNE0zWFdpZUp2QThy?=
 =?utf-8?B?ekhmc0VrdzNCbHhxSlhQK05jSCtPQjB3NDNkbmlSdUF4WDdjRzQzemhUMFFq?=
 =?utf-8?B?K1JsNERyYnZqa1JvQXdLcWRoaWNMcGliZ0kyNG92Z0RrZFFoYTQ4VHM3QW01?=
 =?utf-8?B?cUpHUENFOUxZcnZ4ditReDV1VHFoL29hMTJwd0lUVWtHZWVzcXQyaW5HNmlr?=
 =?utf-8?B?L1B6aEZaTTdvR3ZVL1U3VFRhd1dZN2dXcjEvR1IvRDVGRUxrRmFZbWUvVXVY?=
 =?utf-8?B?LzRXZzhncmxrZkVrbUowNXd2WCtzcTdaMjM5aEZJdDJzRldCMmQzc25BNEpl?=
 =?utf-8?B?b1E0cmtmelZETENJSEh5aWtDdEF3ckp0QzJtTW5zdzQrQnJnZFRsd2VGZG1q?=
 =?utf-8?B?YTU1c0RmUnUzMmRYSXp3SWg4TitCWHBDNVZkNmtFOEVHK0VGTXRldkduNDFl?=
 =?utf-8?B?QzBONWlBanhqNmE5Q3FOWStzc2ROelM4Z2lLOURmRjZDSHc5b2lIMGV1alpE?=
 =?utf-8?B?Mlp4ZE1vSnBHdnpLdzhoNkNRQWswTFhucjVrWE4xL0Z5M2xZUC9KSC9DMWF6?=
 =?utf-8?B?UllsVzJpaFh6bXdYL1E1RUg0REVuWms0eHpqaXZXZlU2ZnZzN2FkaGpqK3ZP?=
 =?utf-8?B?SmNJQnI3TnowV0VNLzJNeXNiZDNtd09OL1I3eXV4bzQvN2pCSGd3K2FmalBS?=
 =?utf-8?B?ZENiWVJOSmF6WVJqTkUrRjVzVnI1eEFKRmU1NVpJVHA0N25zSDdMR2lYc05I?=
 =?utf-8?B?aFgzMlpqOUxiakZHbUc4T0tacnl1Q0FIRi9zdFFSNWFPQnpZSkJtMzhDOGlK?=
 =?utf-8?B?MzFQM2tZNVhpUzB4T1NsUnNKdVNxL1Q3WDlvekdBdlFnNzQ0dVlvTFY2dGpO?=
 =?utf-8?B?NVkzelhFeFNYMW1KZ3BFaTNqNHN1cjVHRTd2UE1xUTQzNGkvTFVLVVdxYlRu?=
 =?utf-8?B?Sjd5Vk1xQ2tTUXNpd28ya000bU5JendEdldIOW1mcUFHL0lQbUNLR2krS2Za?=
 =?utf-8?B?MkppMXJTaFBPUUJTelQxSVQ3NjFZTjJFOUtFKy9LMWg5dzJJNDhoQXdneEJv?=
 =?utf-8?B?VkZ6UHdrNVZIVVFqOWFjakdudHgwQjhmZlZvZk1SMG1YUVN4aisyM1Z4NHU4?=
 =?utf-8?B?WmJZTGdvTUFqRmVWK2k1a1p3UkQrY2x0WjdFZ3BWZ3piZXI3NytNcjJXK05J?=
 =?utf-8?Q?ng3w=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55885755-93e9-44e2-bfd7-08da73f28c7d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 19:18:00.4083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwO7qk6WtUgFXBZ2HacpiEEMIHoqUein/ZNFP5beM2rLzPqbU5ECdnURzoartnXU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5062
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/1/2022 12:36 PM, Steve French wrote:
> On Mon, Aug 1, 2022 at 10:49 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> I think a big chunk of cifsfs.c, and a boatload of module params,
>> can be similarly conditionalized.
> 
> Good point - and will make it easier to read as well.  Perhaps I can
> move most of cifsfs.c to smbfs.c and just leave smb1 specific
> things in cifsfs.c so it can be optionally compiled out?

Sounds good to me!
