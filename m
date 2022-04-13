Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45099C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 01:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiDMBmh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 21:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiDMBmg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 21:42:36 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967F6522C7
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 18:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gC2AJ4h1hPq+vFsgz3DvRjwXiJwMcU4e8YhBTfl3ko7umdePTzjihfkC96nFfE2atilkp5QDxYT0snE1s/r4clK+b4LpdVWKzWmJyD7WNtk9I/XZ4TPjF1Ihgc3jeAIhrbH5uAyGc5MUkimYo89UkLsfdUhoAInpU3Ngc900nqRfjKspfvGB5qWkDgQIcdlHPu55o27escon7wgPUuIfXv7m8rAQIvqPI3xdJT6+XrUG2czy+6m5OHIORIMS/zthZVyAzDw6EnazbYYiODI8zz5RLtficWZTSTuJzC3HdArVeQ1NorfU9JOHSe9rRmSzSNAF7ozn3GhbqIiXCB/juw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cba12mTBhIup6KkvxORypU54vRjP6l2KUobAjivWdXw=;
 b=nF58/wsBDKE9I4ROqU11SZlvJwsrXW/yZT5EJKD6SQpnIpJXRZKAmZ3xkvn0k6DlTtRzS1ztSIZpiXmno2Ny0E6ek1p/LFz8jQ7EeLjZDV9kvgWVkvWOKQ8GXwOkAcwHxpr/0IappaaaC91gD1rAGOw6TfL6vppjLDHM4mkuN8m7WWY0bEOM9cwHkAwy/SM5+Bt4lSIG7zqc8MquMgQcPY1Ezawah5e+alPGn6ldFcwAyvwhzKK79SPz23J/EEYgNWrvGSY0ygXK1AD7s4FhiSGTRCE1krjC+E0EAB6Ugl6VFrAzTB/0yUItXUzoMmqNkvFHWwAk9fvCEHlFsssCeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5400.prod.exchangelabs.com (2603:10b6:a03:11f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.27; Wed, 13 Apr 2022 01:40:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 01:40:14 +0000
Message-ID: <d7771443-f935-357f-3606-c09920a2341f@talpey.com>
Date:   Tue, 12 Apr 2022 21:40:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ksmbd: set fixed sector size to
 FS_SECTOR_SIZE_INFORMATION
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Christoph Hellwig <hch@lst.de>
References: <20220412225806.5647-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220412225806.5647-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c852216-1c65-41c0-fa68-08da1cee8e8a
X-MS-TrafficTypeDiagnostic: BYAPR01MB5400:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB5400992024B905DBE4A6C591D6EC9@BYAPR01MB5400.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bt+ZHB+S61TEVH9LSvbKEoh3cg9XKBdAp89s7ZFC/FY20g1ky/jlkye/NTrgFPKPLat+oQC3q74KVhO+96a5qbz81cEyhD456gAn3/jugT3hIDdxTBF4peYlI3NforK/EiQx0sBlX0tMU5mkQsq3TbHdNnNZhmqPZ3cEzeGGSh59gUnrUVRPXkgVUUYMENwKDPqSA6Ozzt61+c9Ukb77TBi7PahkAgaUCeVkRZJREQ0dC1PydQgLuktCxPVbDtbjg9MPCnPl0imQQDfORQ23FkIVzsnQtCsBZlxfOq4YMazI37vsxlbHCvB91qdAAsUYxhHmA4KlwG094fZa0ag2fYcz/dB7blbssS6ZsLb5dHMUu61jAsC6TnK4XKkGg2vuClmCGG/d0HRlzRZwqSpO4KqgwLGQ+6R85IH8EXqwyeCW8udeeCj7mwHXYsChQWVPlb79E8PfutC6r2uadjChqf3ffgRcHH50c8yCN2r4fx70YYm59NLC7h6kQAFhPZbFO53I6mcTlpCqV6WYQscACAnCbeWiFxwxkDc+A6JzCBOYvU7zIqRAkp2lLFR7FJ01AGJASYfmKT116XqSOtb4XfbwBa+z1KZ7zH/53RIUshaaZ81r0fwngCK19nWhSTR68zUnmZlqH2vsD8kUD2vMUfWIrslYvT1uYZFgOAJb05g5BwEHxQy5Makkj5uTzo8exP7+qOGJWTdoUn2jzacltT+ppku7RsC6dcPHjtiiSYj0D9gac1vL/F/gJmhopcyN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(39830400003)(346002)(366004)(396003)(136003)(2616005)(508600001)(186003)(6486002)(4326008)(36756003)(8676002)(86362001)(66476007)(66556008)(31696002)(31686004)(66946007)(8936002)(2906002)(5660300002)(26005)(83380400001)(52116002)(6512007)(53546011)(6506007)(316002)(38350700002)(38100700002)(43740500002)(44824005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW5CNXhISU1aKzRXNzlIdS90MEQ2ejFIVTl2WmpEOEMrQWdxbUtCblhUTUtn?=
 =?utf-8?B?U3R4TUVOZ3NtQU92dVpJYWNlRCtPcmFQWERVREdXbTdFQzRuMVlLK095NEIy?=
 =?utf-8?B?R3N5UGlCVkZhT1l2Sy9RNE9kRUVaV2p0V0hlV2ZPd3RnN2EvR3dmNWtlL1B5?=
 =?utf-8?B?L2lZK3RxcFhrenhCRzVYdm9Pem9RdTh0NnViK3c1MG9ES3orU0MveTdlbDdp?=
 =?utf-8?B?cnptckY4Y3BreUV5UVh5S2NCNUx5UWFXTWY5ZTR4N0llaGpMM3UvcTVxbXR6?=
 =?utf-8?B?YnlSM3dvcWlnUnBkRUY1THhuV3RSdWZCZy96aEdPdlNUV3AxSGQ3NExsSjRI?=
 =?utf-8?B?V1dPblUxeENkdjdXcmZKcitpYjNqQ1BxbHRodGRKZlFJeldpMDR0czJZUUMy?=
 =?utf-8?B?WHNZbWVYTVdLMGpPTG04eGU0aUxhQW1mSG1IK2duZHJpVUoreHFORWxpemJE?=
 =?utf-8?B?MWpTNTlrN29PN3Fad2w5WTBCMC9wRjltMUM5MmZ5dFpUNTNRZEtGTUhSVjZS?=
 =?utf-8?B?R3o4YUtnaHNPcUdkOXlNOEx3MThXL0Z0cEpWTHZPZlI0MUNRMVhMRC9OWnRJ?=
 =?utf-8?B?eTErU3ppcUQ3eTJzcU9NZHI3VnJ2dmNSYnlDQnVKUVRhQ1F3eHdPMHIzZTQ1?=
 =?utf-8?B?cWhwNHBzc0REL0dWbXVqMmJxTVFvdGlNUTBxN05jWE5pcmRFRW0rNkIrNmEx?=
 =?utf-8?B?akw1RTBrTUd0VVNTWTV5V3M3RzZzMXFqSUloMm9mSkhCckZIcXR4NDVwYWE4?=
 =?utf-8?B?bDk3OXhkenI3MU1BQ2tYQ0VhMHM4L0FKc1lKbnk2VGZRZFFiWnM4WmxrN215?=
 =?utf-8?B?NHZYdUJjUHc4SXFYT05icldtdnpuVEU0ODdBQUhQR0VNQmhFQ2ZLbU4wWmZN?=
 =?utf-8?B?eGQ5RFBSMVR4a3Jja1p1eFJFUkJIR2dLMjdFWm54SWxOdlppTUEwVmErRTM5?=
 =?utf-8?B?RVg3b21xUnF5Y2lDT1F0U1RGL2JaMjlXNlY2QzhtQXErV1E2M1hzLzRLV0tI?=
 =?utf-8?B?Skc1TTZQaTNmWnNWOG5jRDE0bm9HN1VUNVFwR1NERFFGVHFGbW90K2dIbEov?=
 =?utf-8?B?WXlUZmVVMSswTWcrVVdRanRpVU0wd2hQQk1WcktUYWtPdStKM3paMjFzdmZ6?=
 =?utf-8?B?YTBNMFIraUNVc1B2bkFOM1R5bFRCdE5lVXg0MG1kQnRKTUdsL1d1TVhrUmp6?=
 =?utf-8?B?aU0vTjZWMUg4ZzlQbU1aOHRwK2c0WVJlWDJCbHFVQy9zT09DT0JXQkhWTnZm?=
 =?utf-8?B?NVQ3aklFa2hsV1oxdXdaS1hhNERsUlhvTVUzZE94WWJCWUlHRGtWVnNYZmhY?=
 =?utf-8?B?RWVKQ2Myd0xsTTF4bFY0RFU5Q3ZZOXVqQ0VKQXAyNGVCYWl4S0JPS0lpT0ZV?=
 =?utf-8?B?Q3ZpRU9yeXZBaWRtQTVHT0lsbmxEU25oeHRmZEhWTVVUejVZZDZqQk84UHZp?=
 =?utf-8?B?Ty9DRHkyMTBKODJLaVlrSFBpREJ1Y1k1VnlLOEV3a01HQWVtT2d0akgvZjlY?=
 =?utf-8?B?UjJsSUJHSEp4RlI4VEJ0bGFzRzZwcU5qTms1VkRFVXlpWUtuald5L2NlU3Bm?=
 =?utf-8?B?U01PcERKbkoyOGMydHRPYmptNlhjbEdlMU0wOElhcmRxbjBKMlF3U3VuU2NU?=
 =?utf-8?B?Z2d2R1BkNXRJV2sxeTFQSHlIVW9HaG1HSlU4TEh4SVVMQ3hKQml1cXBSWE9y?=
 =?utf-8?B?SlJFRnFsNExuV29peHFMUllnTloxQnQxMnVWeG5MZ0dXVnRjaGtnTXRpOVhx?=
 =?utf-8?B?OFRQTkRLbnBxRkU4RG54dEtEUlNaZDZ4S3Q5N1BBRG9nQ2VRR2tiWTdIUGNj?=
 =?utf-8?B?NTgrTko2Y1UwZUNSSFFGc01ydndubzBmRHhHZ2x1NUVVK2xPTnpyaVNTOTRu?=
 =?utf-8?B?dW5uZTBVdUZ0RXQvMkJNZkZwOE14R2pLTWdXbXZZajhZZk80RlVmMnhQZDJH?=
 =?utf-8?B?NFdDbnR0aDBhZ245cHo0RnN5QlFMREtnMUF1bmRRMVpDakdlWmNPTjRvdXFh?=
 =?utf-8?B?aE04T0RQOHJzazNreVFydk9IQzhudFU4UmNxLzhPUFZjTzRkWXFnNzBkSm9O?=
 =?utf-8?B?MEdzUVppZG1uRkJHTDB5Sks1UmdMV1BsdVpnUW5ZRDlVRWtTUEVpanhEb3dV?=
 =?utf-8?B?ZlNtQWJEMFJDc3gyY3JpWUsxSmVrQjIrZHBRZEVEMW5uL25qWkM2NWNNMWln?=
 =?utf-8?B?bWRwdktEM1d1U2NHSkVRS1FlSXBoNVRvMmpCRm5MYmowY2pQdURUTDFuRWZ6?=
 =?utf-8?B?L2M4ays4ZGxpamFyY1RibTVocGFiMjg2akhVSDdtSlFvNUs5T2lxaDA5RjdX?=
 =?utf-8?Q?QzDucx9NFgAbMw4VOI?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c852216-1c65-41c0-fa68-08da1cee8e8a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 01:40:14.7800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svbXF8YV3uVe1RiYxB2OdDJwjI/IBXX2x+7w5NQ8SeEIEetI670LAW3YGyUjcQ69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/12/2022 6:58 PM, Namjae Jeon wrote:
> Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
> If fat/exfat is a local share, ->f_bsize is a cluster size that is too
> large to be used as a sector size. Sector sizes larger than 4K cause
> problem occurs when mounting an iso file through windows client.
> 
> The error message can be obtained using Mount-DiskImage command,
>   the error is:
> "Mount-DiskImage : The sector size of the physical disk on which the
> virtual disk resides is not supported."
> 
> This patch reports fixed sector size as 512B logical/4K physical to
> windows client to avoid poking into the block device.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 62cc0f95ab87..28ff7c058bc4 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4998,12 +4998,11 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>   
>   		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
>   
> -		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
> -		info->PhysicalBytesPerSectorForAtomicity =
> -				cpu_to_le32(stfs.f_bsize);
> -		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
> +		info->LogicalBytesPerSector = cpu_to_le32(512);
> +		info->PhysicalBytesPerSectorForAtomicity = cpu_to_le32(4096);
> +		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(4096);
>   		info->FSEffPhysicalBytesPerSectorForAtomicity =
> -				cpu_to_le32(stfs.f_bsize);
> +				cpu_to_le32(4096);

So, this sounds like a great approach, much better than returning 128K.

However, it's not at all universally true that 4K is going to be atomic.
And min(stfs.f_bsize, 4096) might be problematic too. Is there any better
option??

Tom.


>   		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
>   				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
>   		info->ByteOffsetForSectorAlignment = 0;
