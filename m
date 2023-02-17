Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56D69C636D6
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 21:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjBQVZ6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 16:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjBQVZ4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 16:25:56 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBFD5BD8B
        for <linux-cifs@vger.kernel.org>; Fri, 17 Feb 2023 13:25:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiIWEmkBJ5UjAITuE/Z4BiuO//Hv/4Z0cBH8+shFnWdC+4Am7eDMaihUgZsLTnbEJl6EjpEHqIPR9f854x5Sypp3A8BnhHVu8dntcM/80YAB7lRHQKLxhggolKRAVoGhP7k2LqjU9GBHiCOuPsxLr0NfUQNYhpuJYbO9eJMWHZPQDf7W6IQmzaT4vdS6U3KTPwXeAnqcrfHm96FAKy2aT2kz16Lixqmht5Ncv7X4NEboGqu7gGwAvi+yop0zu9vVRI/BLsoTCohY+xATgYItckHsscgY3xByOUO78MRv4iBLHudS9te2wIV4pVOGmZdESFVx0KCj8FnlM4ADO/WgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOA9J0BfX9Jfcx5DVFbjGJCR75fge9tOpoi1zfUVW5M=;
 b=GjgjeXy0xKp9aWexSTzHuSWHtxRgxlSrcyQObz3JUYaZXq7Rz1Q2nHbaO2Z+5FvhXWefUW8L6Zo6YMV/ywlecJV0emZKH+spQicsCx8uwLyX/Tdt4/t5f4PWSZpay+xzCjA4Ocj6ORzf+SibvBznJy7jM0baTjE/qFDxBWBDR3sx6yoSKgqQ9Ar+pzsAsK9vUb4Rm/w2m2/CkyGINdtYDjLAHw3ZjQ/wP9T+Zpfh085HhuZtXJuCA9BQpERsEIQ9wyoz/FA+nQT8UBiH2RNZzdjwBr+gGkXoR+rYLxJWIrwmbr3mByV85e8M5zgBrcqhdn2hZVz0/zGRV/oO0LkezA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR0101MB2943.prod.exchangelabs.com (2603:10b6:301:35::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Fri, 17 Feb 2023 21:25:45 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e58f:c83c:6b17:d3ba]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e58f:c83c:6b17:d3ba%6]) with mapi id 15.20.6086.026; Fri, 17 Feb 2023
 21:25:44 +0000
Message-ID: <79b90809-e460-8e59-b7f7-2335606cec30@talpey.com>
Date:   Fri, 17 Feb 2023 16:25:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 2/2] cifs: Fix warning and UAF when destroy the MR list
To:     Steve French <smfrench@gmail.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, longli@microsoft.com,
        David Howells <dhowells@redhat.com>
References: <20221118084208.3214951-1-zhangxiaoxu5@huawei.com>
 <20221118084208.3214951-3-zhangxiaoxu5@huawei.com>
 <CAH2r5mtvh0K5-eJqaX8KgUCMP4G_F=7ma_k38Oa2dP6GDKHdYA@mail.gmail.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtvh0K5-eJqaX8KgUCMP4G_F=7ma_k38Oa2dP6GDKHdYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR18CA0006.namprd18.prod.outlook.com
 (2603:10b6:208:23c::11) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MWHPR0101MB2943:EE_
X-MS-Office365-Filtering-Correlation-Id: bf8f1ee5-7c4a-4810-7638-08db112d8767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ECQ3wZovST+G1nslFLe4BjxLnaPT5FiQwRjSVColr4f6VFV9dCkOkR3cwaXnCi3ZeZLot4cKNXsKvWHXinvjAdsx+zt88reviX6NVGgqK2acU45cBRTIHA0SXZnQtZv0RCLap2unGIXlgl94kkyBc+13mwxvIauSN4iNF2FxHMny3dVr1nFtpdTzT/CfHzpbMSJNVr++n6QVARUNfUQ/nQH7gBQdVnXN9bTHDmqEyq/zBmhcWCfvYfPnwoz3rBGqd9yXA34/z+bEcCcMjd2BKZno1vQXbCEhjFAX6igOUJox09wWR04aTefmOTVVqZ/NcBIayftPlaR1RXgZUKm0JtxqFxVxKcXWJp/rmM7YoSp4QmnneloOeDMcgSITFQQ1t/I/tX1pXuupGyMxZrOA5U2M8AJIwh0PeeXG5ErrjtmwRn6VM66nLClqNPBh3OXC3kPqVKkwUUjcMoBePAxcjGEC0EOppzxCjsl2tn+cOOvHGyx532e8XEvYQyz+yZVJmUrkW+CJtfe2ZcYSrKrgHuFfmxGT0N6ggIMvGhAyqStlmyk4eWxiVwzVIf/os+5OZWiIw8RtOH6tc3Qr/vRhuuIOHC6OJZjv48cCSFoawTfbp4LjdEHBhupIyk8cfGkMJIuLYkk8tHnJFeFYh4FVEiRt9+riTAb3VBTpVq6BNzcydS3WdYJw5tUllNZnYeQbYS8e0ADFYAdLKE0sb06tAMIm+tLotXo8RF2EeRzIHRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(346002)(39830400003)(376002)(396003)(451199018)(66946007)(2906002)(478600001)(53546011)(66556008)(4326008)(8936002)(8676002)(38350700002)(316002)(84970400001)(66476007)(31686004)(52116002)(6486002)(110136005)(41300700001)(31696002)(186003)(6512007)(86362001)(6506007)(5660300002)(38100700002)(26005)(83380400001)(2616005)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b21QcWJxekU2cVRIeElBTzNLaGZHNTlBSGEwcjQwbStoanNwRmxnUlV2M1JV?=
 =?utf-8?B?dktxUm5CNXFvMHVLZ2MxaXFtMmU3em0zTkh3enlJNHJmcnJIUEc4aGowcjIr?=
 =?utf-8?B?ZGRtSTNkZVZiTjhHN2N5alEwcnJhRERYSUFaN2lKQnBHZ3BwTVFqbSsyb2Ux?=
 =?utf-8?B?aUQxSzYyeVpEdm04UXI4eWRaODVMR1VUdytFeVBpUDJSL0JUb2dTTzdleFUx?=
 =?utf-8?B?MnVYdVpIcFZ4bTFBb1VCTUlBOVp4d2lPSnhMV2Q4dzZ1eFhoUi9xSlJSYTFi?=
 =?utf-8?B?U3dlVzNBTW5rd3o0cTlubEhrbm83MFJiR2YyTndncGtra0cwN09PUjdYTVc3?=
 =?utf-8?B?dGp1emE1bkI1Zll6cHo5dGlCeWNLTHpxb29CZE5jc2VqbUNjd3JyN0dFVEtq?=
 =?utf-8?B?NEpnSTQvM21HUVdHblJhZGVlS0JScll5RExyMTFhY0lEU2F0VGtIeitKZlVN?=
 =?utf-8?B?bEpYZDhsMERDb3dmYStiQTVZbEtpOEFjZ01vcjN2SExyY1pZN0lrR0hIV25E?=
 =?utf-8?B?dTZGTE9KbnA3NThKRXV1OEpjODRkSlBXbThVdUlNZjF4MkMrSEdoVkVIK3Ey?=
 =?utf-8?B?eXJUNTh5TEVqU2prSjZXa0hIVWprNzhsdWRlMm5ZMUp2RWpPTTRRZWdjbUJG?=
 =?utf-8?B?eS9mRkZLVkF0OVBFbTNWcHpuUkxSSDUzVnFQQm1zdnE4UUcwSXRwTkVWVnVQ?=
 =?utf-8?B?VUJkR3hVcnd1bFpKaGU0em8zSFdKZm5ySUNDNW9Cd1Y0R25NSnlNQTZPMmd3?=
 =?utf-8?B?UG4vZWIyYVNrS2xBMFJIZzIrMUcyTldqVy8vZ0J5VEh1aDMrWWNlSm1rc2pT?=
 =?utf-8?B?c25ZdEJYNlJZYlJTYkVlUzNxOGFveVdpUHgyK2hLeDNaNmhRcHo5N1h6dUV6?=
 =?utf-8?B?VDZTSCtIYmVmdDA1N2cwSk9jVkFrR01jRVBEZyt3cS9YUE54ZGkxOEpaYTlV?=
 =?utf-8?B?dUM2OTZRWGRhZnUzeHlYdURXbUNXMlYzL0I1eVNJQkFqd21NUGJsQ2F3WG11?=
 =?utf-8?B?UHFXTDUwL01POGJRemZuYUVqTE1qRFRxcnU2dnQwOU8zWVg3Rk1xdDNIMVhR?=
 =?utf-8?B?NUlGN1MrVWUvZnBkeit4TFNWTXQzTUhSTmZEazVHYUphZDk2Y3FDeUYyQ21O?=
 =?utf-8?B?N1lGNURESXlyZUpaSWRiUHA3SkNjNHI5VVVPMzY0a1FyM2ZHUXZWbXJ3VWdC?=
 =?utf-8?B?QTdFQlFhZ0FGSitSYjlWYU1YR1B0VmFSK05EeXFIRzJOSitoc2JmWGo4b1RR?=
 =?utf-8?B?S3BuYjR1QWxzdysyYTRsVmUxd1FSSDdmZWUya1dWT1ZzeW9WaUhqUWMwS2ZH?=
 =?utf-8?B?MTcwazRWVFhaMmk4OVppMkJNLzFzY01xU01WdnhLT0tkVzlNbUJ2WlcvR01O?=
 =?utf-8?B?N0I4MEV0S0o2MWJZdlRjZGgvcSswS3lySmpPOWVGamlMTlg5QUw3c3VxNm9l?=
 =?utf-8?B?aTI2alpCQ1ZkZnp1UUNqa0U5UTZmVnplSE9BUE1Nbnp5TkF4ZGIydE5MbUhN?=
 =?utf-8?B?cW8zeElpVW9ybkJnRFp2YnBmeWN2L1hZUUlHYloxOFAybmc3WEtaaHhLVkNT?=
 =?utf-8?B?eVJpejdTSlI3MnNGSmdaSnZHbUZ1aEh2V1lZeUxwZmFhb0tvNlRBODNEUFg0?=
 =?utf-8?B?SlRuNkJzdUNQOTdGQjFkcllyTjk5elpYWG12VWRXbHoxY1ZLOXNTTk1SREs0?=
 =?utf-8?B?eHQzb2tvbmdSY2N4MGlRVXVyR3c0cFNOMjZ3R3FaNkZlbmU0N09mRUcvTHlp?=
 =?utf-8?B?UHAvMXROTVNZT092bkh1a1puSnVYSVY0VEErbHdjcWVkNmFZT21hMnFjVzM1?=
 =?utf-8?B?VlZVczdVckJSUUk4cEVoR1p6S2VER2MxTTBkSlBvMERJb1JBMlpTbTNMRGFN?=
 =?utf-8?B?Y29STWJSb2xmTEs1eEFqQ0RVOVd6TGFYWXBSWk15RjUrcGY2cUpYM1AvaWwx?=
 =?utf-8?B?SFRjZGhwNWtTYlo5akNXbzJGNHd3TzBkUEg1RzIwUERra2U2TnR0Ry9VRU90?=
 =?utf-8?B?TnRQTWJOak12Y3VSK3U2dnJZVlhVbXZkakNmM3lnNHdCOG90WlpaRGxncnNi?=
 =?utf-8?B?NnB0UXYxNDJldjI4SVZtUVhhR2d2cDJ0L1h0L2VXU0owczgzajBhMHJ5ZEl6?=
 =?utf-8?Q?c7eVq413Pl+ybmv5LkjXAmBiB?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8f1ee5-7c4a-4810-7638-08db112d8767
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 21:25:44.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JotqBMX+CXTilAvV1xzOwuhE/xfvSEQZIjg1RvvHsUe2CTS2azjLAqqbQIM6ewLS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0101MB2943
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/17/2023 4:15 PM, Steve French wrote:
> Dave Howells pointed out that around this line (2246 of fs/cifs/smbdirect.c)
> 
>             list_add_tail(&smbdirect_mr->list, &info->mr_list);
> 
> shouldn't there be locking on that?

I don't think it's necessary, because neither the smbdirect_mr
nor the smbd_connection ("info") have been linked anywhere yet.

Regarding the proposed patch:

> On Fri, Nov 18, 2022 at 1:37 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>>
>> If the MR allocate failed, the MR recovery work not initialized
>> and list not cleared. Then will be warning and UAF when release
>> the MR:

Reviewed-by: Tom Talpey <tom@talpey.com>


>>
>>    WARNING: CPU: 4 PID: 824 at kernel/workqueue.c:3066 __flush_work.isra.0+0xf7/0x110
>>    CPU: 4 PID: 824 Comm: mount.cifs Not tainted 6.1.0-rc5+ #82
>>    RIP: 0010:__flush_work.isra.0+0xf7/0x110
>>    Call Trace:
>>     <TASK>
>>     __cancel_work_timer+0x2ba/0x2e0
>>     smbd_destroy+0x4e1/0x990
>>     _smbd_get_connection+0x1cbd/0x2110
>>     smbd_get_connection+0x21/0x40
>>     cifs_get_tcp_session+0x8ef/0xda0
>>     mount_get_conns+0x60/0x750
>>     cifs_mount+0x103/0xd00
>>     cifs_smb3_do_mount+0x1dd/0xcb0
>>     smb3_get_tree+0x1d5/0x300
>>     vfs_get_tree+0x41/0xf0
>>     path_mount+0x9b3/0xdd0
>>     __x64_sys_mount+0x190/0x1d0
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>>    BUG: KASAN: use-after-free in smbd_destroy+0x4fc/0x990
>>    Read of size 8 at addr ffff88810b156a08 by task mount.cifs/824
>>    CPU: 4 PID: 824 Comm: mount.cifs Tainted: G        W          6.1.0-rc5+ #82
>>    Call Trace:
>>     dump_stack_lvl+0x34/0x44
>>     print_report+0x171/0x472
>>     kasan_report+0xad/0x130
>>     smbd_destroy+0x4fc/0x990
>>     _smbd_get_connection+0x1cbd/0x2110
>>     smbd_get_connection+0x21/0x40
>>     cifs_get_tcp_session+0x8ef/0xda0
>>     mount_get_conns+0x60/0x750
>>     cifs_mount+0x103/0xd00
>>     cifs_smb3_do_mount+0x1dd/0xcb0
>>     smb3_get_tree+0x1d5/0x300
>>     vfs_get_tree+0x41/0xf0
>>     path_mount+0x9b3/0xdd0
>>     __x64_sys_mount+0x190/0x1d0
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>>    Allocated by task 824:
>>     kasan_save_stack+0x1e/0x40
>>     kasan_set_track+0x21/0x30
>>     __kasan_kmalloc+0x7a/0x90
>>     _smbd_get_connection+0x1b6f/0x2110
>>     smbd_get_connection+0x21/0x40
>>     cifs_get_tcp_session+0x8ef/0xda0
>>     mount_get_conns+0x60/0x750
>>     cifs_mount+0x103/0xd00
>>     cifs_smb3_do_mount+0x1dd/0xcb0
>>     smb3_get_tree+0x1d5/0x300
>>     vfs_get_tree+0x41/0xf0
>>     path_mount+0x9b3/0xdd0
>>     __x64_sys_mount+0x190/0x1d0
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>>    Freed by task 824:
>>     kasan_save_stack+0x1e/0x40
>>     kasan_set_track+0x21/0x30
>>     kasan_save_free_info+0x2a/0x40
>>     ____kasan_slab_free+0x143/0x1b0
>>     __kmem_cache_free+0xc8/0x330
>>     _smbd_get_connection+0x1c6a/0x2110
>>     smbd_get_connection+0x21/0x40
>>     cifs_get_tcp_session+0x8ef/0xda0
>>     mount_get_conns+0x60/0x750
>>     cifs_mount+0x103/0xd00
>>     cifs_smb3_do_mount+0x1dd/0xcb0
>>     smb3_get_tree+0x1d5/0x300
>>     vfs_get_tree+0x41/0xf0
>>     path_mount+0x9b3/0xdd0
>>     __x64_sys_mount+0x190/0x1d0
>>     do_syscall_64+0x35/0x80
>>     entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> Let's initialize the MR recovery work before MR allocate to prevent
>> the warning, remove the MRs from the list to prevent the UAF.
>>
>> Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> ---
>>   fs/cifs/smbdirect.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
>> index a874c2e1ae41..7013fdb4ea51 100644
>> --- a/fs/cifs/smbdirect.c
>> +++ b/fs/cifs/smbdirect.c
>> @@ -2217,6 +2217,7 @@ static int allocate_mr_list(struct smbd_connection *info)
>>          atomic_set(&info->mr_ready_count, 0);
>>          atomic_set(&info->mr_used_count, 0);
>>          init_waitqueue_head(&info->wait_for_mr_cleanup);
>> +       INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
>>          /* Allocate more MRs (2x) than hardware responder_resources */
>>          for (i = 0; i < info->responder_resources * 2; i++) {
>>                  smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
>> @@ -2244,13 +2245,13 @@ static int allocate_mr_list(struct smbd_connection *info)
>>                  list_add_tail(&smbdirect_mr->list, &info->mr_list);
>>                  atomic_inc(&info->mr_ready_count);
>>          }
>> -       INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
>>          return 0;
>>
>>   out:
>>          kfree(smbdirect_mr);
>>
>>          list_for_each_entry_safe(smbdirect_mr, tmp, &info->mr_list, list) {
>> +               list_del(&smbdirect_mr->list);
>>                  ib_dereg_mr(smbdirect_mr->mr);
>>                  kfree(smbdirect_mr->sgl);
>>                  kfree(smbdirect_mr);
>> --
>> 2.31.1
>>
> 
> 
