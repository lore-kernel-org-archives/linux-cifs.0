Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF18AC00144
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Jul 2022 19:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiG2TNA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Jul 2022 15:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238864AbiG2TM4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Jul 2022 15:12:56 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BCD87367
        for <linux-cifs@vger.kernel.org>; Fri, 29 Jul 2022 12:12:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG65GbdT1CxAUSGVGzXProgAAhCr+p9i8IPySumjjn/b/rzFoWC6RNAsaP6rQkyRUdr/bHDyuzVyCrf1mGoEh/+p5gf2xJIE4E6TyTilIl7TNd0F5VAemfs/YNZxsYDHDWYOyEJ1OM6jJjh5bxaWpoCJ/a40WgO25UESIiAhgJmK4zkiDid8VeDDVckG/S0Bzikgx/QfPTtUs4nwsUvXQzEp23BWxtK3CD+m8O2ZRGTG5z7y+etVcMSDT06Qr1IhtrtbEEWBWb994nDahn67uJ7M8Ca1f1sj9u6McOWXKntn745VXXCfZWolp/dIn4FvefbELJh1XQxaIg0yBBO3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3m6H7ypx5FkGWoNZ2oKXAhp1zSfKO2El+DEWNIPB2+E=;
 b=gjwJlvzXahwX/qsAQOrytZIxzb+PPBJ+q6rqKz96WeUEJ5rKn8lDuf27YJUL+quDY05BMRxxyLQf09v6jlDlmI29vB5Beb5t+wTVQfInUFaRc/8ZFC9RhojTEWSkr8uWi8mGEz0EcXDyDORuHtTZpZ0VzZ9UhQpVkv6N2ZeZwxYMF4dqQEElwZ1aH08yHOzoSv6a//7Zp4udQ1Qae70kQXFCG/5mP6POFuuhVBoLk5bHCOsi3V3yvUE0OuVGNpve473mc/jdjSlMirLsi7R4O7oMQGw55Y7E3lb7kvSaQTQ1svdySgkqbTETNJEuLtYrdAkVvRFOpLSzYEo/87O5Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 LV2PR01MB7862.prod.exchangelabs.com (2603:10b6:408:14e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.12; Fri, 29 Jul 2022 19:12:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5458.026; Fri, 29 Jul 2022
 19:12:43 +0000
Message-ID: <c7068960-34bc-4783-ecdd-6c6164a9bfa7@talpey.com>
Date:   Fri, 29 Jul 2022 15:12:40 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RFC PATCH v2 00/10] cifs: rename of several structs and
 variables
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220725223707.14477-1-ematsumiya@suse.de>
 <bec8a446-6c74-3ef7-37f0-49cd478599a6@talpey.com>
 <20220726024105.5jd3uf6keus5bya5@cyberdelia>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220726024105.5jd3uf6keus5bya5@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0015.namprd18.prod.outlook.com
 (2603:10b6:208:23c::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c1ac4a1-8f4b-4d1e-b320-08da71964fc9
X-MS-TrafficTypeDiagnostic: LV2PR01MB7862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ua9QgPu16LS4yebradvVQn84EA4+y1wDq6JiDlt5Mvuye4tdoLCx3UOrFVV+1VG0uAUom5hoZWjAiOvqLVAfnhYyUt0CpVwsxNwuIzOOzfUrMZMK+mhEYi4rkqcH//oDiSd+p1m2RAfpebTITrU6fDZERabnjoF9pduve++A6E9zcqC+H4rDCfH2SW6sqGri6QuEXGeBBo5LAyShJEfVD/Xj+f5X6cgHjESz0zUa0RWja74IpaDUorgM9dSRMIOkrp70/G7WRdfd7HIAxKs3lIHzFzdtc9RMRl0DZDwt4DMBtqzhahQF9c21GFLQ8rLinwyaoMdWwuQUOD7WgVsahzT0A3YFI3v++h2lHo41gKPFBMMMoX4ljYlwAXMOQKTUl3kHjS0YVHlDxhNeS5JzwvIf/EYsIxppNf0goCXYpB7bkOCF6RZwrn7Uao56FvGi/qhi7HA0um3POaYp0rJN6WccD1qVeZ5hNi3uh1RbycOAZwv2na5qL1Z0/gTKsp0ainOioHpHLhXEt+VPmdUimvjO8UTlW/Mndk18pgryqCK95czg6UfeUk2IGFQ+tdB9W2uF7MTDcFajAX0/yX3PfEWIcCCHaOJvvuvdC9vhvabLSzD0izjCd82XZwYjuZD41/j3kWDX+COBl/3yokaP2dtnCLDkRSLNSxU8c8H84FJ2fhsh2T7Q898jZjKOBUUQsMinNkiW15aQ7P9huuAqR6WpnipsDW4uFbPt43nOwystdobsLV+gFANSnan/mdOwlGPt9+ACRTUg+3SSYSsXjSNCIJjZ6bXL4hOFa7p7J8Jf1MAw9ANtvr1SkjDHVgAZ4ia9lw8JtuSyeAHcVE9jwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39830400003)(376002)(366004)(5660300002)(2906002)(316002)(6916009)(6486002)(31686004)(31696002)(36756003)(86362001)(8936002)(6512007)(38350700002)(38100700002)(83380400001)(2616005)(186003)(478600001)(66556008)(66946007)(66476007)(41300700001)(4326008)(26005)(8676002)(6506007)(53546011)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlNFUDcxZ3ZSYzFhY1Byb0RBd1E0ekxLdCtTRUNXUmNzVnZoNnAyc0didzA1?=
 =?utf-8?B?OGdzNXFXd2prNS9zZDllSXpIOWxpK3dndVlLZGxVdnlJSk4vSjZORVZUcVdS?=
 =?utf-8?B?UmN0dnl1R1ZjNHhqZGxFaFI3M1dGeElnZnJzYzNYSStsTnVSUC9uOFhyakUv?=
 =?utf-8?B?azh3RTNvYUx4RDJET00ySzU4UjB0NEFpMlozQURmUFlaejRFV3EvU1ZpcmZa?=
 =?utf-8?B?S3RjdUt6aDRBbGZPWmdCLytnOUZDT200ODE5eHRNakRpUURwS08rK2F0cGlv?=
 =?utf-8?B?OUovcE44cFJzV1N2YU9DUTRuemJ3V0Q0d0pxM2JZYytISUtjVU1HMVBpYTBn?=
 =?utf-8?B?NnhxUDY0bk5QT1JjamtWWVpXTnJRMDBtaTZKTWdLR2s1QjVpVy9vZEtJQ2pO?=
 =?utf-8?B?c2NmTWkrVHZtUmI2NWpzVmo2K1RlaFBPZnByNytwU0J5UFdRWWwwU2JKcGVn?=
 =?utf-8?B?Q1l0VU02YmVndDBnVW9oaVQyS01KbXVsOS80NHdNSjNISzBnYjFxNTZxczly?=
 =?utf-8?B?UVR2ZXRzVExXdVJBazV6WE9CdndCaE54TER4OGUyL3J3Q1BvVmp3Tytyait4?=
 =?utf-8?B?OGI3Wm1SU1VDK1RhVFJLdDdWZVd6MlhzYitjbjhpRy9ETXZFTml1dnpFYlZL?=
 =?utf-8?B?ZHhHbUJpbUFIcy9tNTBwWTFhQTYrMXlncGs1WWxtcm54ZVN0VXA4WTI4dXVN?=
 =?utf-8?B?ZmlPT0xINUl3dm9DcTNFbEdBY3k5NDYwbmZYTFVtbHRJR3hTN09xQW9CVkw2?=
 =?utf-8?B?aFJnM3RMcG01VVA1ejJQeWVvY3RISi9KY0UrYWhvRzRycWw2SHBKUHNUVXpp?=
 =?utf-8?B?RENBZG5IOVkrdzc1NVVlNXYvY1NVTHM4bTNJZ3M2UWp0OHI3YUZ6QVEyTFJu?=
 =?utf-8?B?QjlpSWhGQzIzdjlnNEhBU0k0N2p3YzgzMUxpaFVXbTdGYjNUZzVlYW1HcllB?=
 =?utf-8?B?RTdZWTBZd05meG80cm5TdzFOWm1OeHJrYzBKODlleWIzWExhQmxWNnFPY01W?=
 =?utf-8?B?MWVEa3prYW9ycGNPUytHMUhQY2VteHZKaUVPMVEyb0VyOEMyb255TmlsLytv?=
 =?utf-8?B?bXVKbXdXakg4T0tDSXlOUWptcG9qZkpyVWEvaU1STTJHMVRhZ2dtNHp5SC9j?=
 =?utf-8?B?QXBZbko0UkRSVVpSQ0xBejdXdVh1WFRTc0Nvc2dEejRPRlRUd3o3YzlIMHZ1?=
 =?utf-8?B?UXM5LzU2TkQxVXJobFFTa3FVbENwMWlhbjFTT21iL2RybnpkS1ZXTk9wNzZL?=
 =?utf-8?B?RGJ5cmdXYVpOSjFBYnVXRlRGZzVrOW9nMkN6bi9BNzZoclhLQ2tFVzN0aFFK?=
 =?utf-8?B?MTlEM0I4Q3A3NEVMQWQ0eXdTN0V1VHIxMXdRSiszNTFPaWlBSklDQWlYVWds?=
 =?utf-8?B?bFBQK3hxMDEreGpDL2x0aEdtY1JLRGVRTktSTjRwdFNOY09KRVJKSGtJR0J5?=
 =?utf-8?B?VTN0dzczYmhsUXcrM1kxM2tJaUpaMkluRWV5SkJQWWdtWElFSmlVRFNXcndX?=
 =?utf-8?B?RGltblJweDBpSzA1bnh2NytNelVxcjB2a0IwdHVsOEE3c3I0dFRCRXZnMHNw?=
 =?utf-8?B?cXZmSE1zWXRwMTRqR2t3Z2VJbUc2UzN1SWZwWkhFU1NqdU1PY3RpWWR1U0hM?=
 =?utf-8?B?V005ZldGcXhPUGY5dlpLaEZQS29ndHFIM3oySjhKbFFJaVRkRks3L2RQb0dn?=
 =?utf-8?B?MXRKVjFWLzJRNXNxRnovU2V2SGlkQW5EZDVlMlJuWFpWZFpCd3dsSXcrK0pm?=
 =?utf-8?B?dVd5RVQ5ZVR6NThmdTc5ampvUFdmTVhabVEreDN2U3I5QVM0Vjh5NXQvVHN1?=
 =?utf-8?B?Z0tWcEszRXprSlkvVjdWR1NFZ0FFZ2QwQXVINzRxUHhNdzRzVmUxekRGTDVu?=
 =?utf-8?B?cW1nc0ZjeFF2ZXRYN3NEU2dubisyRVZNZ1Bld0xNSEp1OWtFVEtIeVI0OURs?=
 =?utf-8?B?bW43Zm42VVFITGF5dWhwMi9SQmRwdGZPVUJaeitrd05uRnN5clhreVpLcFl6?=
 =?utf-8?B?MXZIdWpzbEtpUy9kOWRYV1VXSHk0OWNwV1hOUDc4Z25iLzZobm1LZGZZblJu?=
 =?utf-8?B?Q0VhNVV4cmFVTU5jYnh4dlF4UWFFQk5hclhOT044SHlab01HQWQyQlVPdWJi?=
 =?utf-8?Q?flUY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1ac4a1-8f4b-4d1e-b320-08da71964fc9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 19:12:43.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C4uXKxB95OFT8zpzxVHlhzhogk7TE+s8OuiqylLWyh75z2LOd5tW+nwb2xPcexg+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7862
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/25/2022 10:41 PM, Enzo Matsumiya wrote:
> On 07/25, Tom Talpey wrote:
>> On 7/25/2022 6:36 PM, Enzo Matsumiya wrote:
>>> Hi all,
>>>
>>> This patch set (v2) renames several cifs.ko data structures, 
>>> variables, and
>>> functions with the goal to improve readability of the code.
>>>
>>> In summary, what's been done:
>>> - change from CamelCase to snake_case
>>> - try to give more meaning to globals and struct members
>>> - rename status fields (server, ses, tcon), define constants for the
>>>   various statuses (4/11 can be shared between those structs, others are
>>>   specific to each)
>>> - rename of list_head variables to better represent whether they'are
>>>   used as a list element ("head") or a list per se. Also tried to give
>>>   more meaning to these, as "rlist", "tlist", "llist" looked confusing
>>>   and, sometimes, ambiguous.
>>> - remove redundant prefixes from struct members name, e.g.
>>>   tcon_tlink's tl_*, smb_rqst's rq_*, cifs_fattr's cf_*, etc
>>>
>>> No functional changes has been made.
>>>
>>> I know these touch some very old code that older devs are highly used
>>> to, but I see this as an improvement to reading the code for everyone.
>>>
>>> I'll be waiting for your reviews and feedback.
>>
>> Enzo, I think this effort is great. If you combine this modernization
>> with refactoring SMB1 into separate files to make it easier to do
>> away with entirely, I'll be even more supportive.
> 
> Tom, thanks for your feedback!
> As a matter of fact, I do have a branch with SMB1 code isolated [*] and the
> module renamed to "SMBFS" to modernize this module, while also keeping
> it SMB-version-agnostic.
> 
> I'm sending my changes gradually so I don't have to change a lot of
> things in case there's a lot of negative feedback.
> 
> 
> [*] - current discussions:
> - is "smbfs" the best module name? Steve suggested "smb3", but, again,
>    this ties the module to a specific SMB version

I think "smbfs" is more consistent with other kmods. And I'd be
careful about a specific version like "smb3", because that paints
it into the corner if it also supports smb2, or future dialects.

> - should SMB1 code be isolated as in source-code only or should it be a
>    different object (i.e. only built through kernel config and
>    "disable_legacy_dialects" wiped away)? Or even a separate module?

There's no single answer here, but my personal view is that it should
become a separate module. As a compile-time option, the distros are
basically forced to turn it on. We don't want that. As a module, they
can choose to leave it out. We do want that.

> In any case, I'm keeping "cifs" as a module alias for SMB1 code for now,
> and I think we'll need it that way for some time, but at least the
> internal migration will be done by then.

Yes, it's definitely needed (for now) to maintain a "cifs" module alias,
because user scripts might be using it to modload. In future if smb1
becomes a module, then drop "cifs" entirely.

Tom.

> Thanks again,
> 
> Enzo
> 
>>> v2:
>>>   - remove status typedefs (suggested by Christoph Hellwig)
>>>   - define status constants instead, reuse some between different
>>>     structs so we don't have to create a different set of statuses
>>>     for each cifs struct
>>>
>>> Enzo Matsumiya (10):
>>>   cifs: rename xid/mid globals
>>>   cifs: rename global counters
>>>   cifs: rename "TCP_Server_Info" struct to "cifs_server_info"
>>>   cifs: rename cifs{File,Lock,Inode}Info structs and more
>>>   cifs: convert server info vars to snake_case
>>>   cifs: change status and security types enums to constants
>>>   cifs: rename cifsFYI to debug_level
>>>   cifs: rename list_head fields
>>>   cifs: rename more CamelCase to snake_case
>>>   cifs: rename more list_heads, remove redundant prefixes
>>>
>>>  fs/cifs/Kconfig         |   2 +-
>>>  fs/cifs/asn1.c          |   4 +-
>>>  fs/cifs/cifs_debug.c    | 158 ++++-----
>>>  fs/cifs/cifs_debug.h    |  29 +-
>>>  fs/cifs/cifs_spnego.c   |   4 +-
>>>  fs/cifs/cifs_spnego.h   |   2 +-
>>>  fs/cifs/cifs_swn.c      |  24 +-
>>>  fs/cifs/cifs_swn.h      |   8 +-
>>>  fs/cifs/cifs_unicode.c  |   4 +-
>>>  fs/cifs/cifs_unicode.h  |   2 +-
>>>  fs/cifs/cifsacl.c       |  22 +-
>>>  fs/cifs/cifsencrypt.c   |  78 ++---
>>>  fs/cifs/cifsfs.c        | 124 +++----
>>>  fs/cifs/cifsglob.h      | 694 ++++++++++++++++++++--------------------
>>>  fs/cifs/cifsproto.h     | 172 +++++-----
>>>  fs/cifs/cifssmb.c       | 356 ++++++++++-----------
>>>  fs/cifs/connect.c       | 574 ++++++++++++++++-----------------
>>>  fs/cifs/dfs_cache.c     | 178 +++++------
>>>  fs/cifs/dfs_cache.h     |  40 +--
>>>  fs/cifs/dir.c           |  16 +-
>>>  fs/cifs/file.c          | 636 ++++++++++++++++++------------------
>>>  fs/cifs/fs_context.c    |   8 +-
>>>  fs/cifs/fs_context.h    |   2 +-
>>>  fs/cifs/fscache.c       |  18 +-
>>>  fs/cifs/fscache.h       |  10 +-
>>>  fs/cifs/inode.c         | 530 +++++++++++++++---------------
>>>  fs/cifs/ioctl.c         |  18 +-
>>>  fs/cifs/link.c          |  26 +-
>>>  fs/cifs/misc.c          | 185 ++++++-----
>>>  fs/cifs/netmisc.c       |   4 +-
>>>  fs/cifs/ntlmssp.h       |   6 +-
>>>  fs/cifs/readdir.c       | 344 ++++++++++----------
>>>  fs/cifs/sess.c          | 142 ++++----
>>>  fs/cifs/smb1ops.c       | 182 +++++------
>>>  fs/cifs/smb2file.c      |  36 +--
>>>  fs/cifs/smb2inode.c     | 136 ++++----
>>>  fs/cifs/smb2maperror.c  |   2 +-
>>>  fs/cifs/smb2misc.c      |  72 ++---
>>>  fs/cifs/smb2ops.c       | 555 ++++++++++++++++----------------
>>>  fs/cifs/smb2pdu.c       | 596 +++++++++++++++++-----------------
>>>  fs/cifs/smb2proto.h     |  68 ++--
>>>  fs/cifs/smb2transport.c | 112 +++----
>>>  fs/cifs/smbdirect.c     |  28 +-
>>>  fs/cifs/smbdirect.h     |  16 +-
>>>  fs/cifs/transport.c     | 236 +++++++-------
>>>  fs/cifs/xattr.c         |  12 +-
>>>  46 files changed, 3230 insertions(+), 3241 deletions(-)
>>>
> 
