Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1ADC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 12:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiDMM2J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbiDMM2J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 08:28:09 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB5251E4E
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 05:25:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqvbpjPiG4rEPNTKp5uyFGA+SliVz78MN3ZKw/XeKFPvAxiutM1ZAyorLV0MgnuWi/E16sQDsLzXjjXnAe6HH3kAQI4Dnsn93NUtFhl+jGxsYb8NE63DH2VlZI/NWbY07P1V1olP6MN3eWTcotmgKN/hGum634y6X8Sze+oztUeYMk3zagucilbl3mEIor7DjGQANXKOJbo1r1odzRQBuhp12eKQq5eAJ2/pXV0xF4pz8Vkv5lpKq1bGuJDBV3f2T0AYu1AFOv3Okrf7sRUeKuO/cbxLJ1RlWUrt25coNOb8G25/VQOgHg8M0PLGgG2DuVGfcQcMXkgqWrU3enNSzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WFFhrFb3/GH98ejEp0U5jmkgA98Fup/jBliLpcv8WI=;
 b=dh4lIpAidQ0FHzY561M1PI1nxFF34TTwkOWITB4SbhvzwLXvs9+AxD6leHWj/Hexa6hUfaDKDdS8JuUeoVzEpP7UWNqDZPl+lZhc12idC6EUCuD1hMXb2kIT+MC1JFJMP6Q8en0hXhKHyKI6t5Ds7JJ/F0AMVbjEuHgV5FuaT0Qyc+6XDW5u2HKN3XOJwh6kYeAK6Q+Rbp+SQ3qKxYTMr4csL4fyC1U3B4Y3dzF78lCpkV9QBesHs8xTi/bHg7O9U1fvGZ6mP9YZDc4CtRSX8hbMpOck4qj7wAiyiXhvmSblcBgyTRRwzZqrnw1blfJWWZ6E6nAqv+rT7MpIPyPmBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4146.prod.exchangelabs.com (2603:10b6:208:4f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Wed, 13 Apr 2022 12:25:44 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 12:25:44 +0000
Message-ID: <66e6f078-43d9-7e46-d6d3-767a5ac0a557@talpey.com>
Date:   Wed, 13 Apr 2022 08:25:43 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] ksmbd: set fixed sector size to
 FS_SECTOR_SIZE_INFORMATION
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, Christoph Hellwig <hch@lst.de>
References: <20220412225806.5647-1-linkinjeon@kernel.org>
 <d7771443-f935-357f-3606-c09920a2341f@talpey.com>
 <CAKYAXd_Esmq__t6JCYCYT0rFS5EdrvUOtGitX-b9MV4ogg3dAw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_Esmq__t6JCYCYT0rFS5EdrvUOtGitX-b9MV4ogg3dAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:208:329::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75fac989-a8cf-4684-8ede-08da1d48bb2c
X-MS-TrafficTypeDiagnostic: BL0PR01MB4146:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB4146B754AC17BE65820FC66ED6EC9@BL0PR01MB4146.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2ja3EH2R7hNuwhICoXkgt31tKCudtxW3ltUXf4YIe3pYMpEMUujHeMUUbdGHpjanbXtrOUOhy0Qj9QudH7gTCtmAus3AkcnGBlUsWJBorkJS8y89bFnmTz7UziEC6s8p5x2rWq4OFESigKJPxBFAoNiIAhJFy+UITwBPhfo1XGYhLEazW0GMb2rRBUKdrZIvxOqU7zYzmqY6qMhACF/JA4Pe3vCB9rZ57bqR3lNusTjB8SGdbndx9g0hf6sJtIvsBxFL7XPFK6SouZhgYOR0J+FrNAfjzFAvvFMtCxcyb/0Q2uvZbJmQDXofWjbEXN6w3lTOydZ+7EB7TvpDS7QiSkeO3GmEMBDumSmyjulwtJNG+P1TelDt58XvYNkR0kMa6l6tWJ2YI6C7AZqFjYcIZeus8w1rI6VCJu/VZDs4lFnJLO+tuq1VbaHHMp9LPs7Npw/Dslk5WQoQYOpq2l39pmcyQBeuO3Zddm9y9wiUfEAoL/zOtNTCJmVMBlfpHCoDiZr1M2zGzJDwLZIAbpm4+xfL0ghq0EhXAg0WjfWgWwFFaFugm6YS6h6vq34fgJ3tRtDdafqm2R6CiJR08uezqeeowKJuWUQyCoH7xj0MpQBfH7uLWjToEoQMk8cWMMpCmvyqv/FmgEujKndcrbd6/3LnQDWUUZchel3VHZdtc6+RfZac8J2RDQKlvkueC40oslkKVZ7DRSGLMqwGUZ2P2yK32HG7j0OadGMQR6lNvJA68XWUOrpaOwjTej9UJnYTXsR+3q6JMVxCRmA8BoXqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(376002)(346002)(366004)(396003)(136003)(83380400001)(186003)(26005)(6512007)(52116002)(316002)(66476007)(66556008)(36756003)(31686004)(6506007)(6916009)(508600001)(6486002)(53546011)(4326008)(8676002)(5660300002)(2616005)(66946007)(38100700002)(38350700002)(86362001)(8936002)(31696002)(2906002)(43740500002)(44824005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTZ5SGdWTzE1cnBrMExOdXZoVTBaVnk2ZEt1bG53T3BkN1pma0JDMlBrMWZz?=
 =?utf-8?B?cE9HZ091eDdXWHRTSTkvaC9zclJaRHVrUGJ6QlVjSWk5TWhxejJWSnAzWlBx?=
 =?utf-8?B?ZVRCZzRJTmhyemJBMEhoZnNyajlSMDlFVkFuTzVXcjF0Ui9RWGRvbGdPek5p?=
 =?utf-8?B?UUdqbEVlRHpHZzlvUnZTY1E0N0krY0M5dUhQRkZQQlRZbk1SVGtJYVVHalBZ?=
 =?utf-8?B?UUptQ0FPcW5pM21qamRxU3FCZVNUN1R1RFJXTkdHOGRjb0dKQ01ZWmVhTkI1?=
 =?utf-8?B?ZG1QdXVIaTNUQ0R0TmlDTWhVVWpzb3NENVdHdmRINVR0dWhSeHpxSHgzNGJX?=
 =?utf-8?B?VGNBZE9pbVhMUkRlN0ZkcGFMZmNNTnpvaVlDMGIrbkJiUXRlbU9qZkVLUDk5?=
 =?utf-8?B?Y2pVeTlHclZRRE8zYXZjd3AzUWx2b1MyTDg4ZkhLY2dEUW5UQUVhRUFyVno4?=
 =?utf-8?B?N3V5T2JQRnVtU28yUGRGREdzWUQvanZ2c3BDa2k0MC9jYjJoNW1MQmVCNE5x?=
 =?utf-8?B?dWNvTWRPUGQ1VHFtMVgzUC8yMTVuTDkwZTIzRVdmTDJNMUE5V2NyNlltekFH?=
 =?utf-8?B?bU1ZTkJtazFOVHBNcE12Ykl1Q0RuU0NjWFZJSEFYcTF3OGxUTC9PUjkzT2ly?=
 =?utf-8?B?aGNRK2k0N2p5aGkvblphcGlXUVE1bEQ1ZWIxL2ZlUHpnODNpbTZjMWQ1TENH?=
 =?utf-8?B?R1FVWUx0N0N0RlRVVVptbkg5dHEzVndnV1pleDIyd294d3pIVnB5UGphSG9D?=
 =?utf-8?B?TXJMUmZOWGZOUWdxQktZaXAxZVRxWmQvVzNWVkJyUnFNd09LUFdQYTAyWXJv?=
 =?utf-8?B?Z3FFR0p6Z3FRUkw5dzAzZnY0RHFuelh4RWRUendzYUlnWlJZMVZsZVZWbkI2?=
 =?utf-8?B?NFIzZVBDTlBIV2s1cHdWNEFSeWRsWUloNCtCbWd1RUd3akhTMEFTU1FzRzZR?=
 =?utf-8?B?STFGNHo4bjl1QjhGNjZ3SnFxS09oZzk0MTJpZmpmVVFkWEs5aStIT1d6V0d6?=
 =?utf-8?B?Y08zT295clA3bDVHbndRK3k4ODY0RERRZEZjSk1nMlFzMWRjWDcwdHZhbHQ2?=
 =?utf-8?B?MVhwblZHK3NzZzRMNEJnaW9OckVQbjRsYjZ5M2JKYkttUTJJRlVpQjRDTXhZ?=
 =?utf-8?B?S3k1V3ByN080Ylp2RVEzd3piWC9qOXZheGwvZUFqWSt0UlBPSG9sdTFIczN2?=
 =?utf-8?B?aUxYdjNISnZkVU9jUzlJdjdzSnFLT3V6RmVyNTNDZUtPTHpvUDZUR0QzM0ZT?=
 =?utf-8?B?STRNcmZVMEFkcFhqTTFGbDBrcVpxOEsxd2ppZ2NIbWh0NjgxZS9jSC9sK1hj?=
 =?utf-8?B?d1M1QmdsaDdtNEJQWlZ1MGkybGJJY2dhVEI1bjJsM1NUZkNMVllkZ2JVQTRH?=
 =?utf-8?B?RHB4QzNGSGdHRWgxOEthd0tnUmJScFZrNXhqZUplaDN3WmdOcmk4MWdHUHFY?=
 =?utf-8?B?VGZIa2hxaGxLY1hXWGtjSU1POFppTURuQWl1Qi9WYjVacWg3Vms5Q1A3Y0VY?=
 =?utf-8?B?bDc5UnRpKzFHSk1XMGxMNk81bmRQKzVoYjVpNkRrdytEK3MwSlFwZFF2Z0ZO?=
 =?utf-8?B?WGVCazFNcitINUZtdDJzRE92OGdNamk0N3Bkb0p3SkFhT0dzU3hRQXBnNnpP?=
 =?utf-8?B?cTlKU3cyclgvZVhWLzE3Z29vMi93eUFOS0QxdXRvTmZlcGZXSDBHdXZSbGxn?=
 =?utf-8?B?cHBUSkJKdDFjSWxVeUxCTXNyWkJ1UjVhUW10RXNUOWZzdzJ5ZUV6YWJlTXF1?=
 =?utf-8?B?OEtCQzk5OTdlRDh0S1pLcmpNK1Y2STRmUjZWcXVYOUNLRzB3TTNURUxjUDM0?=
 =?utf-8?B?UHcwR2htSHJzMlZnd2JzYWhEK3lSRTZrQjFQVXZNMExKekdOM3Zodjl6ekdZ?=
 =?utf-8?B?Z2JGNVVKM0dPS2pQd1puY1RGVk1FNEt3RXp3Ykc3RkJkbXpwTGxhcG1zOWlF?=
 =?utf-8?B?dTFJbWg3ZmZEMHErQUV2NHdXd0lLa1FRV0FWK1lRQmFYL2tucVRJaXVtNnoy?=
 =?utf-8?B?TTlIV1NCVDlFeW5HL2ovWWlRVlNadkNSQWI2Z09PUlJFcWdYd1hEWWJodUI0?=
 =?utf-8?B?RmZwNzBsNG1sVW51MzlEK0NCYkVMd1hHQno0eGJVMHdyTkZ3b1JmeGlxQitP?=
 =?utf-8?B?MVRDVndwUGV6bUJxN0Rtb0FhMWZsQVJlbVpQWk4yOWo5Z240b3dHSkZNQmhu?=
 =?utf-8?B?d1c0NElJQ0x4cTUxclJGUEhIcWR1OWhBYkxNRG5uYnhJc3VXWHhNSFFhNWEw?=
 =?utf-8?B?QndxdUVHZHY5eExGNllmcWlBWmloa3dHWi9jZk5Zbjh1WG1EdC93ZVd3Yldt?=
 =?utf-8?Q?gKJiElzsoWmFT0H0Lf?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fac989-a8cf-4684-8ede-08da1d48bb2c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 12:25:44.5519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHy9pWX5uWufjchAHRRRqmm7DA0gT/AHcWgJyQg+2MJL/eiO+6N531XGD7unHbxE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4146
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/12/2022 11:23 PM, Namjae Jeon wrote:
> 2022-04-13 10:40 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 4/12/2022 6:58 PM, Namjae Jeon wrote:
>>> Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
>>> If fat/exfat is a local share, ->f_bsize is a cluster size that is too
>>> large to be used as a sector size. Sector sizes larger than 4K cause
>>> problem occurs when mounting an iso file through windows client.
>>>
>>> The error message can be obtained using Mount-DiskImage command,
>>>    the error is:
>>> "Mount-DiskImage : The sector size of the physical disk on which the
>>> virtual disk resides is not supported."
>>>
>>> This patch reports fixed sector size as 512B logical/4K physical to
>>> windows client to avoid poking into the block device.
>>>
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/ksmbd/smb2pdu.c | 9 ++++-----
>>>    1 file changed, 4 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>> index 62cc0f95ab87..28ff7c058bc4 100644
>>> --- a/fs/ksmbd/smb2pdu.c
>>> +++ b/fs/ksmbd/smb2pdu.c
>>> @@ -4998,12 +4998,11 @@ static int smb2_get_info_filesystem(struct
>>> ksmbd_work *work,
>>>
>>>    		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
>>>
>>> -		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
>>> -		info->PhysicalBytesPerSectorForAtomicity =
>>> -				cpu_to_le32(stfs.f_bsize);
>>> -		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
>>> +		info->LogicalBytesPerSector = cpu_to_le32(512);
>>> +		info->PhysicalBytesPerSectorForAtomicity = cpu_to_le32(4096);
>>> +		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(4096);
>>>    		info->FSEffPhysicalBytesPerSectorForAtomicity =
>>> -				cpu_to_le32(stfs.f_bsize);
>>> +				cpu_to_le32(4096);
>>
> Hi Tom,
>> So, this sounds like a great approach, much better than returning 128K.
> Thanks:)
>>
>> However, it's not at all universally true that 4K is going to be atomic.
> Could you please elaborate more ? Is the atomic size not 4K for 4K
> native storage?

Where is it guaranteed that the physical storage is 4K??

>> And min(stfs.f_bsize, 4096) might be problematic too. Is there any better
>> option??
> There is no option than to poke into block layer, but Christoph
> pointed out that this will also give the wrong answer for file systems
> with multiple device support (btrfs, f2fs, xfs).

And I agree. Did you read the discussion in MS-FSCC by the way?

> A client can interpret this field as the unit for which NTFS guarantees an atomic
> operation. NTFS calculates the value of this field as follows:
>  Retrieve the physical sector size the device reports for atomicity, and store in x.
>  Validate that the value x is greater than or equal to the logical sector size. If it is not, set x to the
> logical sector size.
>  Validate that the value x is a power of two. If it is not, set x to the logical sector size.
>  Validate that the value x is less than or equal to the system page size defined in [MS-FSA] section
> 2.1.1.1. If it is not, set x to the system page size defined in [MS-FSA] section 2.1.1.1.

That's just the Windows/NTFS approach, of course.

> So we need to select fixed size as between 512B ~ 4KB. I think the v2
> patch looks a bit better...

"A bit better"? So what's the actual fix going to be?

Tom.

> Thanks!
>>
>> Tom.
>>
>>
>>>    		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
>>>    				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
>>>    		info->ByteOffsetForSectorAlignment = 0;
>>
> 
