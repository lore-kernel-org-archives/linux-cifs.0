Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857ACC43219
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Nov 2022 22:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbiKQWK6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbiKQWKn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Nov 2022 17:10:43 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3C125F
        for <linux-cifs@vger.kernel.org>; Thu, 17 Nov 2022 14:10:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoyoTaBJeTMdgU8QDHjzPvpNEnAuPAgFR3sZaaQFJY7MJNg8CALKi+OU7Hg9rw8xINl4xCQEW4/1JaD9PNfPNbLyvTRe4zEd9Bfj4Vaq+qoRUThOtPoqL11BaU6Oq6Yqe1qNenht3xRIqVaiQjvvbohmUD4DsuzZ22HUWQ8qGsQC3dLe0p93121xH9ZQiU8+pC5ls6dpfq90HA5Pil3qrlAWVK3UA9Ee1TqtPMXarzCpvPWyEVy/3zomdxEjq209KOBdTqXw5MvuzG/4zEas6+bAN9agLZGZ5BGhit/Y1HC2/kgbJRLMvMsTgQLY0B8pXhSqohVB3/RFwgS+egwaCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNZnlUQkJM3ZZZipbv609SLDIzREnsYJsZbu2YRBCr4=;
 b=YesJJkns0QCKAA0e2ROJiG4YpY4e6OV9/rJj0VLP4lvdzT39kn3fyL90rtDyow1awgJ2YbkRIhSI9Y6NGSJnxLpsHHN08aN2pbYK8WVC/ndy5WqxlwBye/mixoIUydX+rReCI/E7onlfKCk/4YQrhztP/4AQPd/jdZmVdihHdK8Fe8pBl0vzY0y++l4VDvdyFwwCcv/yEPKctGXPwigsokPPPnH3LkZlQ0L60Sbax+jB91wNPSxp5Y1z4tCYrjCZBUjonUsxcNT5K84PVZ0lGSdwzkyeHClIqu0jPZnAjhep4E3Y+uPU/wnGSNIL5iXT78UpWFSmcEC4OyCegnqDvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN2PR01MB2176.prod.exchangelabs.com (2603:10b6:804:d::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.16; Thu, 17 Nov 2022 22:10:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a621:8f2f:c5a6:9d33]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a621:8f2f:c5a6:9d33%7]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 22:10:33 +0000
Date:   Thu, 17 Nov 2022 17:10:32 -0500 (EST)
From:   Tom Talpey <tom@talpey.com>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, smfrench@gmail.com,
        pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com
Message-ID: <afb743ba-f043-47d7-97c1-cc5838cd6635@talpey.com>
In-Reply-To: <20221117154555.2973509-1-zhangxiaoxu5@huawei.com>
References: <20221117154555.2973509-1-zhangxiaoxu5@huawei.com>
Subject: Re: [PATCH] cifs: Fix OOB read in parse_server_interfaces()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Correlation-ID: <afb743ba-f043-47d7-97c1-cc5838cd6635@talpey.com>
X-ClientProxiedBy: BL1PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::28) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN2PR01MB2176:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b1fd738-261a-4487-deda-08dac8e88c3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y6BYRHEBFupQwdqG2sqopL3K1UA5hpxPi/NWTBuAsprt12S7CigtoaRr2JVE0WcpnEqjndqb6nBuhyL0NsUW1i8F2+p1J4/11dekPBZXaVpU4OVmrj2dgaVQb1zxXc0ucv7NPxTbwWUanLeAv03xrr8t/ichiS6sKEBtVCOfcN6IJVKuBSJOLoB34JcDX6ZIekkjbXgzyLGfbJdr6vVFz90nHG5DvHQxlfNJM/J5oOIPShCdC6RZ5qBeUpPqDKAMt3ctqe3B7+CPQhgBbEMEnyC6aV3/rfR5xJldjaYY4Teznva/IkEn/EJnjkiTDOb4uemBz7WrFBVH13a9oH4VgQQE8de73X/rMj1mObn3rFxL0XoY4OxC7fjma6bVfTIh1olIHIKOjAKmPXd6xcSxoj/EWKt1P9Le0x6DSzbBF+9y6rRju1aFotz8hqSMKhk0acfx6dfZN99OQoqL5z+S0VmBlihuVOpI0JF04OTsxTuMWPWPaEIm4LHBs/t/4ATv+J44zy9VtLxEp3SH2aCEng3hs/eawgamn9MJOYhl/xmSh8Qqjn0bo1LZxlxZQ1wWlcYzAxHMavPqWmXcbRG9GPyZm6Up4tIod34HFwu8hrSdBnarsEboqi0cMi8nEoYz25JfrSBVLCEJROCiYnv70iUM2G27+n4izwNgpS9cOl856xgDJMhOs5r+XvRMovtT+7QWR6aFxzeOnQiJlKlYqNc64sBTouSBLq72hfYaDGo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(366004)(396003)(346002)(376002)(136003)(451199015)(86362001)(83380400001)(31696002)(66946007)(38350700002)(38100700002)(8936002)(2906002)(4326008)(8676002)(66556008)(66476007)(41300700001)(5660300002)(6506007)(52116002)(26005)(6512007)(6916009)(2616005)(186003)(316002)(478600001)(36756003)(6486002)(84970400001)(31686004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHJhdHFKVWxBZnpXSGdEQmYzMGowYzloNFhxUXBLZ1hzdDBCZk1JWGg3VHI3?=
 =?utf-8?B?VGg1U2FZWi92RWJWUU1iU2lzMUNSbk5wbmZMbWxMZHRwRkhNMGc0NjljVlpC?=
 =?utf-8?B?bW4xa2sxYWFuTEVyWkpUYnAxeVZPZVkvbXA0TUtvdVU5Q1RmTXdoNFlZaTJa?=
 =?utf-8?B?WkRNZ3d3VkR0MTVBSVg1R3F4cVQyOEdMYm96NVlZd1AwUmRsU21vSGZIUkQy?=
 =?utf-8?B?WW1LY2ZFOXJNaWExVjJ0NmdlRFZnYzRyM2dGODFiZDJadENIZWZidHdFYVVX?=
 =?utf-8?B?QUV6SkVnejUxY055aUZhL2t0cVgrVGxrVHlRcmF6VXkvblFDbUkxUEwra1dh?=
 =?utf-8?B?U0VlZlRXTGFMclFiYTJtTDVmcjB4MktZdG1YMlpvZDBqb2k5YmgxcFJzVWRG?=
 =?utf-8?B?ZWM2Y0RHdzZjZU5HbzlLS3o2UCtEWjFjUzhJNFgxUGN3UkNxNEk0VHpPZlNW?=
 =?utf-8?B?M3VFUm01bGZ0U2dyelNVMWxDbFFndUViQk9YRGRTRFE5VVV4ZzRIK1krLzhB?=
 =?utf-8?B?MDQ5cEhrZUp0MEtGY2FveEQ5NXJDK0ZSWDI2VFVEWWlnREJWUXNhTTNvcXdw?=
 =?utf-8?B?M2txZER2TWp1Zm84QXBwemUzazQ1MkcrR3VJaUpjY1dqZlVZVDIvU1VBanI1?=
 =?utf-8?B?cG82WitTVVhPVENpZk0vakVnTkN1dXVkMzB5VU5jUnY0cytYWkkxcVZHa3By?=
 =?utf-8?B?MTVLMnp6V1RQWXhlTGRuQ0V0TEZLRlAwSUwzRnA3U3RUa21BaHp6SHhSQzJy?=
 =?utf-8?B?VVFhOXpSVGhUVnY0ZDVaUGRjcGF6UUhmOHdtd3dCY1RiaW9aQmVJMmNpV2Nj?=
 =?utf-8?B?bERYTUh0dEptdDJaQm9xQjhYckZ0c0NqQmFsMzlPamoxWXFMWTlkTzBFQjAy?=
 =?utf-8?B?dGRMUjNQUFFONWZCMWlCUHpDWVk3RHM1OTBxZ24zNnloZCtqTHUxamx3WWVn?=
 =?utf-8?B?WFFObVJKelFhaDlyaFgrTjUyKzJ0UmlRbnptaDhZWFNsWnB4alZIeS9jWms1?=
 =?utf-8?B?dmp3MXBKM0pBZWc5eTJxcnpVcDYwSEhzaklPOVVRZUErZW5yVjk4UWNObko5?=
 =?utf-8?B?bmMxeVgxUkExVTJLeVIwZWtoNjBOK0wxbzNySXoyYmp3NVdHWFZnblo1Vk5a?=
 =?utf-8?B?Y0wrVGk5ZmxiTkM2K1htL0tpaTVCRzFMOVF3UHlDWmI1eEh1V2diZjVBdjQw?=
 =?utf-8?B?Z1JrUFQrRWVGc2RWR1p3SnlUVDlIWUZqRExRQVRZK1ZEOSt0dFB6bERJbGR3?=
 =?utf-8?B?c29CNzZxejVIbmpiS3o5M1BBanU1NDFPVElydllsWDRkRkVnWlduY0NTWFNa?=
 =?utf-8?B?UXl1cWxHZGV4VlZ4eXREdUtGOFhld2VKV3JQZVRuWTlUMWFMM0hXWUtsRDRu?=
 =?utf-8?B?MytHMDZXN0Nic1QwSlpoRnlKTmRsVXNjbTJzbzQ5OW5rWlc2L2U2YnV4alJh?=
 =?utf-8?B?Sjc3dUFyZzd1TW94MGlMTzFJREh2TFkwYXQvL3BFNTdza2Q3cnFlSmhodFVq?=
 =?utf-8?B?dVlveG5sU1Y2YWxMQXJ3UTZTSC8yQVY3d0dwWnNRUnc2bG8vU05xcXVKVGlP?=
 =?utf-8?B?cWJYb09JbUZ2bStNckwwR3hZRk14OHRGYlU3SUNuL2xPRmJDSytFOUdieXFE?=
 =?utf-8?B?THZZQVBpMHErQlFxaVVsMVhKZ2lwbFkzTEJwSll1WXM1OHdscUJzU0NmVGU5?=
 =?utf-8?B?TkxzcVVya005Znc2ZVRRckc3Z2dXZ2JTLzBnWXVlSVh4TWtnVmxpdkN3OThy?=
 =?utf-8?B?N2paMno3SDFaVlpoamxlSFk2L094MEVWZXVQcUJRRHBVZEpSdk54cWFDSGlu?=
 =?utf-8?B?a01HU0drbFYzY1I0K0xCLzg3dm9janIxR1BPVUd3VU55K0MvU2JtN1QxZW02?=
 =?utf-8?B?REVUdUVtbjhsN2J1anFIRk5oMVE1Nzd1dVRxM01wVDNra1FxNWNkaFQ4VkRN?=
 =?utf-8?B?ekFBN3FrUXNWN1RiVFNscEx3RktIQno1aGJKakl1N1VzL1grR0R0a0hWYXFN?=
 =?utf-8?B?ZU4zTEJLREsxZ0E0MnVQdVBLQ1pCSnc5bHZJNmFpaE9IRmh6Q3Jha2drVzJy?=
 =?utf-8?B?K09rM0dpZ2xGbWlaSHBVeDVVWktmaUhWVFVBd2ZuWG9OYjZqM3NUd1h1UTY4?=
 =?utf-8?Q?+dxY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b1fd738-261a-4487-deda-08dac8e88c3a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 22:10:33.8232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vp8Kzr25fC9kaWkTJqiywMWESu3Tr2SBxLJh041jMYHW6ub2ejXFq8zCtpeFLy7I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR01MB2176
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

So, this only happens when the mount is over RDMA?

Nov 17, 2022 9:45:35 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:

> There is a OOB read in parse_server_interfaces when mount.cifs with rdma:
> 
>   BUG: KASAN: slab-out-of-bounds in parse_server_interfaces+0x9ca/0xb80
>   Read of size 4 at addr ffff8881711f2f98 by task mount.cifs/1402
> 
>   CPU: 6 PID: 1402 Comm: mount.cifs Not tainted 6.1.0-rc5+ #69
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x34/0x44
>    print_report+0x171/0x472
>    kasan_report+0xad/0x130
>    kasan_check_range+0x145/0x1a0
>    parse_server_interfaces+0x9ca/0xb80
>    SMB3_request_interfaces+0x174/0x1e0
>    smb3_qfs_tcon+0x150/0x2a0
>    mount_get_conns+0x218/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
>   Allocated by task 1402:
>    kasan_save_stack+0x1e/0x40
>    kasan_set_track+0x21/0x30
>    __kasan_kmalloc+0x7a/0x90
>    __kmalloc_node_track_caller+0x60/0x140
>    kmemdup+0x22/0x50
>    SMB2_ioctl+0x58d/0x5d0
>    SMB3_request_interfaces+0xcd/0x1e0
>    smb3_qfs_tcon+0x150/0x2a0
>    mount_get_conns+0x218/0x750
>    cifs_mount+0x103/0xd00
>    cifs_smb3_do_mount+0x1dd/0xcb0
>    smb3_get_tree+0x1d5/0x300
>    vfs_get_tree+0x41/0xf0
>    path_mount+0x9b3/0xdd0
>    __x64_sys_mount+0x190/0x1d0
>    do_syscall_64+0x35/0x80
>    entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> If all the interface decoded from message, should not check whether
> has next one, otherwise there will be OOB read.
> 
> Let's just check the bytes still not decode to determine whether
> has next interface.
> 
> Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
> fs/cifs/smb2ops.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 880cd494afea..39c7bee87556 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -673,8 +673,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
>         goto out;
>     }
> 
> -   /* Azure rounds the buffer size up 8, to a 16 byte boundary */
> -   if ((bytes_left > 8) || p->Next)
> +   if (bytes_left > 0)
>         cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
> 
> 
> -- 
> 2.31.1
