Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D97C00144
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 00:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiHBAib (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 20:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiHBAib (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 20:38:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486DB33E09
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 17:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZM8wjPR68je4J/yPMfdBBrDcQncqEWB+gujtqi5h7kl/K4EyEWZ6rGyZCjWD5pW0ur6tVK0oLYYtJ1blKjDEenXu2BMhZB1VgGRswEaE0irk0uqagoaKMI10qGRDbFcJnmBIwa0E7xtkAahPGWH8UmEuChvFmHOakhSyo0zH2m/kizucKwJcP9Th8H19YMMJRpeO2VTdB1f1QhrwEUSzu1QjLOXMsse3yLGmqg7ttyhThg2fWq61diZQbNPLzsSG4cSOnyDxFpcs3X1RlgM/u2OlnyWerTzvI9vMLPGMPdeNIyQFTIKz3Gq3tVSgiz4xjs/5SQcraPWDrYLNcrthQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7zX8BeM3i3CRUsijq9rGTCJM0Lxpu9L56sZ/tw7zKI=;
 b=XLazPK+fd9wGeN6fyPk871C/GsJJ9R6YzRq6+M9eCj1SPmr9DLRIGY9hg+qnhgiWPI/fL+TUz7vLuuAJ4NVhLOSQ/dOBYeCyECE0PrQG8cCUvNSBXcbUmBlD6CsgBTdwquKRLrLF7k15+sJdSu9erHuG7ZybPKklXSaofFDHt+CuDUPU9qu8Bkl13bWQCO7QZcFqZPBSIyIAD6BeGE2IpHOqWiQQmBauG+2Fgw+wQng4OUiF/wWU64CRBMpWyansIuWhhNa0Np1CpkCE/yyJ3JrMnw3h2XhJzn1ADnYCUhaim5vsFH5UElwiTvauSXuWqSKpFaZyTSr9n4Y+gU7H9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR0101MB2956.prod.exchangelabs.com (2603:10b6:4:2c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.10; Tue, 2 Aug 2022 00:38:22 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 00:38:22 +0000
Message-ID: <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
Date:   Mon, 1 Aug 2022 20:38:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        Rowland Penny <rpenny@samba.org>
Cc:     linux-cifs@vger.kernel.org
References: <20220801190933.27197-1-ematsumiya@suse.de>
 <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220801201438.5db6emf6iddawrfl@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR15CA0010.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4553d0d7-b7ee-4d1c-d812-08da741f4d63
X-MS-TrafficTypeDiagnostic: DM5PR0101MB2956:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JkBl6cjgUsCXjuGXtlaML1+noFOel3eQ8IdGsEHyXesYvPDxtQ8jd2s8HSN/F4jwQ7q/17SVz0HMvU9StwBP7TWgxvZorHHtuitcubXIzNJwhaCh5q8vRkQxwdBrsPExCI97XJdeeIkwhUMDURXoc/f2PrEQ+PAfdtpncN82McMqkze5kRlONKXztU5no85a6/8bPDcDkzDnM7p65lJaEaNcFgElj9tJpAlQt7P0irfh5wraRbOpD+HZWU6ehW4U9ohpJH4IwxAMsi9x7KMq4eycwTTA8BTdmTxhx1LMcMsd727Xn1N9O8rEL7a6BVduVAc3fN3utiilYmv6amEa1Z0wBFeyjVUz93j97doBzrxzwi/rupZ8UWP6kzJ3Dbb8hRhyP5/Hmfzjnnn0cimgnLbeleebEoU2DV+kXLfDd/B2LETuiSxNpx3XSP1oHKxUOxBC6yGgmSnk6WuKoeh///Pz3RW5Zbu+G4ekC53dAI+cGZpVsENF4//PKCLQSn5DJFoFgbeVXs1Ho94yq7NHA4EGug1cl2g0+AxMiHtKAel7gr0ajBM/yf19xMs/6OaGKvSWDzd4WRFifpaMEgiQQas7GXNxckptDz9gpq9hw9dNz1Jc4CPeQUs8lG4PW4i5kpV4YclRpbRjBlpw/pbDOCMC4u3chOscv7/LCK7f1FIqRtlMjtF2oQyb8fl4EZWM5NfFoPEOXc5I5S2DObDZ7W4PTJ5TkXEYd0i89+oBJ3/HyiSl0Dvl/BZh5ZRAJB9lqRZX8031eWBZb8OZ9YcWBEX1g3SmssJrFp+qVYaQC+Mv/ZSnu9RWNOpIhAAfs5cl4PkhHoD7LYOukryPiss08w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39830400003)(366004)(396003)(83380400001)(30864003)(2616005)(186003)(4326008)(8936002)(36756003)(2906002)(8676002)(5660300002)(31686004)(66946007)(66556008)(66476007)(316002)(86362001)(478600001)(110136005)(6506007)(31696002)(52116002)(6512007)(53546011)(41300700001)(26005)(38350700002)(38100700002)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2g1RDVPbDFNd1I0d29UR2ZqcFNUNUhMdkF6cDg3cmNKVU9yYjFQRkg4WGJI?=
 =?utf-8?B?QUkrcHkyNE04UGFlTFVXRG01dWxoRlBFQ2w1eXFUOFlyTDRSOTYvQ1dVaWNh?=
 =?utf-8?B?VURwaC9PYXFLeXVIODdxWkF4eExjd3dRTThNNE5WTVp1V1NwQjB6MDFHM09L?=
 =?utf-8?B?aTlkcnZhRlR5UEpPMTR1NnFkRy9aeFFXaW8veTkzeXRwU0ViTVhiZHNhUHI3?=
 =?utf-8?B?WU4rM1Rkd0pOY2ZaWHEya1VUNldCWmV4dHhWeVd5cUJsb2ZrMU5ES0FkSU1N?=
 =?utf-8?B?R0lwQ2NEUmltREVTQWtyNE4rUEdQcktsdXZPWHJRS3dJKzJvVUtXZnJwYWN4?=
 =?utf-8?B?ZGJFNDZzZ3NvY0RGa1ovUUpObDdBMmVUUlF2WWNMN0RMNWpVeHoyQ1pTeGZj?=
 =?utf-8?B?TlVxanBDd3FFbFNod1FIaUtlQ0tlc2xZU0ZvMHZrc0F5czhYQ3JpQXNnZ21u?=
 =?utf-8?B?LzFzNEtaekNtZ2h5VC9VK3lsU043QVFaUThrOXN6My9hNjFQeFdqK2hrZ2lK?=
 =?utf-8?B?RTJUVUtRZVFmM0pnRmdmNFYzSXRhNGl0V1I1UmovS3Vjc09KT3RIaEM1a1RX?=
 =?utf-8?B?czFoK0RvMDl2NndlWVdvcUlVdGpBbnJydTM4QjNkWXBQWU52amU1RU5HY2l0?=
 =?utf-8?B?WS8xTk1YS3hWTXJGa2ovaXFSU2JBdnVFY0ZiQm80L3BBMUNUejdldzNxWkph?=
 =?utf-8?B?M3VOSzVwclJUMnBxb09mT0xrekxRNGpzUVpkZzJEL09iTFloVmFiZ3IxeU1p?=
 =?utf-8?B?ak1FMDdjbENpbWp2WW55cW9vNTJsZ3JrdDdkbExHRzE3UlNLY0ErdTJUUno2?=
 =?utf-8?B?VUZhZllobGl5ZFN1SGlsTWkxaFNvYU9wTzZ1UUdmN0pCSVRBRk5CbXcxSUs3?=
 =?utf-8?B?UUJ0OFJsTUZpbnpHQ0lmMGNFM2lOYU9hczRwSWtST09ybkVXYm5HWFhtS0Uw?=
 =?utf-8?B?ZVV4RWtPRXJ4Qk9jT2t0MTd1Qi9jVjJSL1RtTjVFc2lhRlZoQTIzTmNxbHpu?=
 =?utf-8?B?eWxlaUlHcnovOGZQVUw3NXVidnRhdjFHVGRNTktURlRUK0tpL0lvZi8ybFhQ?=
 =?utf-8?B?QStIZEwyZWQxc0lFRGVwQjBiTjhwaS9ZSkVpZ25QT2xQM0VxYkE0ZVZreUdx?=
 =?utf-8?B?dEEwaVZyUGVDcGtmajlRQ2QrNW10VUNndzNSYUMvTjlUNjUrMUNBZXZQN3VG?=
 =?utf-8?B?TGVUN213UDVRVm9rUk9qOFB5Zk9mcldRY1VYWmxyN0VkeC9VVVh5eExMWW1C?=
 =?utf-8?B?aFZxcjV5TWhzSGtPV3hZRkVjSHVJUVZJeVEyVGpEcExLKzFWbTdsYzNwSU13?=
 =?utf-8?B?azQ3ZXJ6V2dxRmdDZjBTb1kvQ2hFRU1EaHFqVG9lUzBPNVVUc2NTdUJVZnIv?=
 =?utf-8?B?V3d5SWZJcG0xTk5YQi85M1ltSXk3cEZOeHJSVWY3UjJFWlMxZE9aZ0c1aTRq?=
 =?utf-8?B?ekNpOVJUU0ZROHoyN3dxOXZ5MnErWmcxc1lHRXFFTE9FbEhwZTBkci9VL2tG?=
 =?utf-8?B?SENRZ0EvNXhSbWJMclA4Ym5PRG1GaW0vUXowdEJJMm03Z3huNERkMExEbW9P?=
 =?utf-8?B?S0s3aVd6UUJuT3JhcEpPbmI2UkJrZWNGdlJoMlhqbDViWGlqcG1zQzR0cHdJ?=
 =?utf-8?B?SU5idWV2QmladzJYUzQ2cWd6RzJnN0NYdVRGUjFaZmdvMkRGQVA1dEJ3SWI1?=
 =?utf-8?B?VmdGV0p3NVV2ZW1WMkpaZXlzR21RU1p1S3pqWC90bGsrWld0bEFYRVlEZ3pX?=
 =?utf-8?B?MnRCTW15VEJsTDNjN2VhMkJxTFl6S09KV0R3WDV6Zi9PZU5oR2Fva0VUcHA0?=
 =?utf-8?B?d3pKNjZERytMOFRvK29VOVZFRm5CRUlZa291bFN0ZFNDVEFJcWlvd084eTAw?=
 =?utf-8?B?Z3I3Tll1YWxZSnRvVjQvZjJzdFVVZDJYZ1QvSm1KcWlOWGdIaEtzNjB0ei9z?=
 =?utf-8?B?dm1TNWl5Vm94T1dITkhhYnVGcVNMTG5BNENIU2pEL3BCckQ3ZGpjZW1wMlc1?=
 =?utf-8?B?MDRIYjdoclZoZFhvb1JQbjlJNXBlVzhKU2xaYS9LYkpnQjgydUJxaWw5VDdy?=
 =?utf-8?B?WEdoenhoVW5Xa2ZPK0lLS2ZKeXRxeVErZ0djQzBGVDRXUk5hNndCdkI5NjJP?=
 =?utf-8?Q?xts8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4553d0d7-b7ee-4d1c-d812-08da741f4d63
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 00:38:21.9106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJur8PkhgXrxOoj5kiSCUoHplyKTXOk0ucSm2INyWTbbPaBSqtlrugGEP4Y0GDoL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0101MB2956
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/1/2022 4:14 PM, Enzo Matsumiya wrote:
> On 08/01, Rowland Penny wrote:
>> On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
>> wrote:
>>> Hi,
>>>
>>> As part of the ongoing effort to remove the "cifs" nomenclature from
>>> the
>>> Linux SMB client, I'm proposing the rename of the module to "smbfs".
>>
>> Hi, this has absolutely nothing to do with myself, but Linux used
>> 'smbfs' before it started to use 'cifs', so you are going back to an
>> old term. This could be confusing.
> 
> Hi Rowland, I'm aware of that. I had nothing to do with either
> (choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
> stayed "smbfs". And TBH this is the most coherent name, of all

I dug around the old tarballs and it looks like fs/smbfs was pulled from
the kernel after 2.6.36, in early 2011. This was different from fs/cifs,
which entered the kernel much earlier, so they previously coexisted.

I don't think the name ambiguity is very important, but I do wonder if
git might uncover some conflicts, when a previously removed directory
suddenly reappears with new content? There wasn't a lot in fs/smbfs
though.

Either way, I think the module name is the question here, and it doesn't
have to be the same as the directory. I still prefer smbfs.

Another possibility for the directory is "ksmb", which might rhyme with
the server, and keep it close alphabetically too? OTOH it might be
confusing to have two similar names.

And sorry but I hate the idea of adding "-client". Should we rename
ksmbd to smb-server?? I don't think so.

Tom.

> available/known choices; you know the protocol (SMB), you know it isn't
> tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
> used (as a module alias)), it's a Linux filesystem module ("FS").
> 
> Also the "fs/smbfs_common" directory was renamed as recent as last year
> (from "cifs_common") (cf. commit 23e91d8b7).
> 
>> Rowland
> 
> Thanks for the input, though. As an RFC patch, I'm waiting for more
> feedback and suggestions.
> 
> 
> Cheers,
> 
> Enzo
> 
>>>
>>> As it's widely known, CIFS is associated to SMB1.0, which, in turn,
>>> is
>>> associated with the security issues it presented in the past. Using
>>> "SMBFS" makes clear what's the protocol in use for outsiders, but
>>> also
>>> unties it from any particular protocol version. It also fits in the
>>> already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
>>>
>>> This short patch series only changes directory names and
>>> includes/ifdefs in
>>> headers and source code, and updates docs to reflect the rename.
>>> Other
>>> than that, no source code/functionality is modified (WIP though).
>>>
>>> Patch 1/3: effectively changes the module name to "smbfs" and create
>>> a
>>>        "cifs" module alias to maintain compatibility (a warning
>>>        should be added to indicate the complete removal/isolation
>>> of
>>>        CIFS/SMB1.0 code).
>>> Patch 2/3: rename the source-code directory to align with the new
>>> module
>>>        name
>>> Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
>>> or
>>>        "cifs module" to use the new name
>>>
>>> Enzo Matsumiya (3):
>>>   cifs: change module name to "smbfs.ko"
>>>   smbfs: rename directory "fs/cifs" -> "fs/smbfs"
>>>   smbfs: update doc references
>>>
>>>  Documentation/admin-guide/index.rst           |   2 +-
>>>  .../admin-guide/{cifs => smbfs}/authors.rst   |   0
>>>  .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
>>>  .../admin-guide/{cifs => smbfs}/index.rst     |   0
>>>  .../{cifs => smbfs}/introduction.rst          |   0
>>>  .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
>>>  .../admin-guide/{cifs => smbfs}/usage.rst     | 168 +++++++++-------
>>> -- 
>>>  .../{cifs => smbfs}/winucase_convert.pl       |   0
>>>  Documentation/filesystems/index.rst           |   2 +-
>>>  .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
>>>  .../filesystems/{cifs => smbfs}/index.rst     |   0
>>>  .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
>>>  Documentation/networking/dns_resolver.rst     |   2 +-
>>>  .../translations/zh_CN/admin-guide/index.rst  |   2 +-
>>>  .../translations/zh_TW/admin-guide/index.rst  |   2 +-
>>>  fs/Kconfig                                    |   6 +-
>>>  fs/Makefile                                   |   2 +-
>>>  fs/cifs/Makefile                              |  34 ----
>>>  fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
>>>  fs/smbfs/Makefile                             |  34 ++++
>>>  fs/{cifs => smbfs}/asn1.c                     |   0
>>>  fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
>>>  fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
>>>  fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
>>>  fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
>>>  fs/{cifs => smbfs}/cifs_ioctl.h               |   0
>>>  fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
>>>  fs/{cifs => smbfs}/cifs_spnego.h              |   0
>>>  .../cifs_spnego_negtokeninit.asn1             |   0
>>>  fs/{cifs => smbfs}/cifs_swn.c                 |   0
>>>  fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
>>>  fs/{cifs => smbfs}/cifs_unicode.c             |   0
>>>  fs/{cifs => smbfs}/cifs_unicode.h             |   0
>>>  fs/{cifs => smbfs}/cifs_uniupr.h              |   0
>>>  fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
>>>  fs/{cifs => smbfs}/cifsacl.h                  |   0
>>>  fs/{cifs => smbfs}/cifsencrypt.c              |   0
>>>  fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
>>>  fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
>>>  fs/{cifs => smbfs}/cifsproto.h                |  10 +-
>>>  fs/{cifs => smbfs}/cifsroot.c                 |   0
>>>  fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
>>>  fs/{cifs => smbfs}/connect.c                  |  36 ++--
>>>  fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
>>>  fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
>>>  fs/{cifs => smbfs}/dfs_cache.h                |   0
>>>  fs/{cifs => smbfs}/dir.c                      |   2 +-
>>>  fs/{cifs => smbfs}/dns_resolve.c              |   0
>>>  fs/{cifs => smbfs}/dns_resolve.h              |   0
>>>  fs/{cifs => smbfs}/export.c                   |   8 +-
>>>  fs/{cifs => smbfs}/file.c                     |  16 +-
>>>  fs/{cifs => smbfs}/fs_context.c               |  20 +--
>>>  fs/{cifs => smbfs}/fs_context.h               |   0
>>>  fs/{cifs => smbfs}/fscache.c                  |   0
>>>  fs/{cifs => smbfs}/fscache.h                  |   6 +-
>>>  fs/{cifs => smbfs}/inode.c                    |  10 +-
>>>  fs/{cifs => smbfs}/ioctl.c                    |   6 +-
>>>  fs/{cifs => smbfs}/link.c                     |   2 +-
>>>  fs/{cifs => smbfs}/misc.c                     |  14 +-
>>>  fs/{cifs => smbfs}/netlink.c                  |   0
>>>  fs/{cifs => smbfs}/netlink.h                  |   0
>>>  fs/{cifs => smbfs}/netmisc.c                  |   2 +-
>>>  fs/{cifs => smbfs}/nterr.c                    |   0
>>>  fs/{cifs => smbfs}/nterr.h                    |   0
>>>  fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
>>>  fs/{cifs => smbfs}/readdir.c                  |   4 +-
>>>  fs/{cifs => smbfs}/rfc1002pdu.h               |   0
>>>  fs/{cifs => smbfs}/sess.c                     |  10 +-
>>>  fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
>>>  fs/{cifs => smbfs}/smb2file.c                 |   2 +-
>>>  fs/{cifs => smbfs}/smb2glob.h                 |   0
>>>  fs/{cifs => smbfs}/smb2inode.c                |   2 +-
>>>  fs/{cifs => smbfs}/smb2maperror.c             |   0
>>>  fs/{cifs => smbfs}/smb2misc.c                 |   0
>>>  fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
>>>  fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
>>>  fs/{cifs => smbfs}/smb2pdu.h                  |   0
>>>  fs/{cifs => smbfs}/smb2proto.h                |   0
>>>  fs/{cifs => smbfs}/smb2status.h               |   0
>>>  fs/{cifs => smbfs}/smb2transport.c            |   2 +-
>>>  fs/{cifs => smbfs}/smbdirect.c                |   0
>>>  fs/{cifs => smbfs}/smbdirect.h                |   2 +-
>>>  fs/{cifs => smbfs}/smbencrypt.c               |   0
>>>  fs/{cifs => smbfs}/smberr.h                   |   0
>>>  fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
>>>  fs/{cifs => smbfs}/trace.c                    |   0
>>>  fs/{cifs => smbfs}/trace.h                    |   0
>>>  fs/{cifs => smbfs}/transport.c                |   4 +-
>>>  fs/{cifs => smbfs}/unc.c                      |   0
>>>  fs/{cifs => smbfs}/winucase.c                 |   0
>>>  fs/{cifs => smbfs}/xattr.c                    |  18 +-
>>>  91 files changed, 414 insertions(+), 417 deletions(-)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
>>> (100%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
>>>  rename Documentation/admin-guide/{cifs => smbfs}/winucase_convert.pl
>>> (100%)
>>>  rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
>>>  rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
>>>  rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
>>>  delete mode 100644 fs/cifs/Makefile
>>>  rename fs/{cifs => smbfs}/Kconfig (72%)
>>>  create mode 100644 fs/smbfs/Makefile
>>>  rename fs/{cifs => smbfs}/asn1.c (100%)
>>>  rename fs/{cifs => smbfs}/cifs_debug.c (96%)
>>>  rename fs/{cifs => smbfs}/cifs_debug.h (98%)
>>>  rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
>>>  rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
>>>  rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
>>>  rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
>>>  rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
>>>  rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
>>>  rename fs/{cifs => smbfs}/cifs_swn.c (100%)
>>>  rename fs/{cifs => smbfs}/cifs_swn.h (95%)
>>>  rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
>>>  rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
>>>  rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
>>>  rename fs/{cifs => smbfs}/cifsacl.c (99%)
>>>  rename fs/{cifs => smbfs}/cifsacl.h (100%)
>>>  rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
>>>  rename fs/{cifs => smbfs}/cifsglob.h (99%)
>>>  rename fs/{cifs => smbfs}/cifspdu.h (99%)
>>>  rename fs/{cifs => smbfs}/cifsproto.h (99%)
>>>  rename fs/{cifs => smbfs}/cifsroot.c (100%)
>>>  rename fs/{cifs => smbfs}/cifssmb.c (99%)
>>>  rename fs/{cifs => smbfs}/connect.c (99%)
>>>  rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
>>>  rename fs/{cifs => smbfs}/dfs_cache.c (99%)
>>>  rename fs/{cifs => smbfs}/dfs_cache.h (100%)
>>>  rename fs/{cifs => smbfs}/dir.c (99%)
>>>  rename fs/{cifs => smbfs}/dns_resolve.c (100%)
>>>  rename fs/{cifs => smbfs}/dns_resolve.h (100%)
>>>  rename fs/{cifs => smbfs}/export.c (91%)
>>>  rename fs/{cifs => smbfs}/file.c (99%)
>>>  rename fs/{cifs => smbfs}/fs_context.c (99%)
>>>  rename fs/{cifs => smbfs}/fs_context.h (100%)
>>>  rename fs/{cifs => smbfs}/fscache.c (100%)
>>>  rename fs/{cifs => smbfs}/fscache.h (98%)
>>>  rename fs/{cifs => smbfs}/inode.c (99%)
>>>  rename fs/{cifs => smbfs}/ioctl.c (99%)
>>>  rename fs/{cifs => smbfs}/link.c (99%)
>>>  rename fs/{cifs => smbfs}/misc.c (99%)
>>>  rename fs/{cifs => smbfs}/netlink.c (100%)
>>>  rename fs/{cifs => smbfs}/netlink.h (100%)
>>>  rename fs/{cifs => smbfs}/netmisc.c (99%)
>>>  rename fs/{cifs => smbfs}/nterr.c (100%)
>>>  rename fs/{cifs => smbfs}/nterr.h (100%)
>>>  rename fs/{cifs => smbfs}/ntlmssp.h (98%)
>>>  rename fs/{cifs => smbfs}/readdir.c (99%)
>>>  rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
>>>  rename fs/{cifs => smbfs}/sess.c (99%)
>>>  rename fs/{cifs => smbfs}/smb1ops.c (99%)
>>>  rename fs/{cifs => smbfs}/smb2file.c (99%)
>>>  rename fs/{cifs => smbfs}/smb2glob.h (100%)
>>>  rename fs/{cifs => smbfs}/smb2inode.c (99%)
>>>  rename fs/{cifs => smbfs}/smb2maperror.c (100%)
>>>  rename fs/{cifs => smbfs}/smb2misc.c (100%)
>>>  rename fs/{cifs => smbfs}/smb2ops.c (99%)
>>>  rename fs/{cifs => smbfs}/smb2pdu.c (99%)
>>>  rename fs/{cifs => smbfs}/smb2pdu.h (100%)
>>>  rename fs/{cifs => smbfs}/smb2proto.h (100%)
>>>  rename fs/{cifs => smbfs}/smb2status.h (100%)
>>>  rename fs/{cifs => smbfs}/smb2transport.c (99%)
>>>  rename fs/{cifs => smbfs}/smbdirect.c (100%)
>>>  rename fs/{cifs => smbfs}/smbdirect.h (99%)
>>>  rename fs/{cifs => smbfs}/smbencrypt.c (100%)
>>>  rename fs/{cifs => smbfs}/smberr.h (100%)
>>>  rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
>>>  rename fs/{cifs => smbfs}/trace.c (100%)
>>>  rename fs/{cifs => smbfs}/trace.h (100%)
>>>  rename fs/{cifs => smbfs}/transport.c (99%)
>>>  rename fs/{cifs => smbfs}/unc.c (100%)
>>>  rename fs/{cifs => smbfs}/winucase.c (100%)
>>>  rename fs/{cifs => smbfs}/xattr.c (98%)
>>>
>>
> 
