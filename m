Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFACC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 17:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbiHBRnt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 13:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbiHBRnj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 13:43:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701A44F68D
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 10:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QylKKjuJkelyAzW0Q1j6gPEj41/B2i8k3pvFsCo7+a9+uIEMbVnsq9Mvz4hi3luQCcfh4Bj9yZNWjPDwnWLCyVE9jkNRXni1BjuezcViqFWnoQjnsb3MpE9WgM9a3tK6WrCiGhZmh509pBT/cFWu0wlzf2ZblSo73scpthkAEseBI+oGkjTiZ4Q3OZhJkbejHUo0XvjVyPIuqoDILnoSiUn9WXOaiemjqeOeiE9s/SeCI3kue57ZhcTdStPXjWzDgt64SCMpdp019SDVF6vfK+kn/DHmk7SBycBW5pevXPIfbeP6tu3F/sat+aChygmw5PtyFISOFOCPLeh+7l+G5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WiO0bmxo9xw0ho/PDAhIyVkk/o0uQrtLES5cyBiwIg8=;
 b=AdPsXyfkDSZyXbyK+1K9P4E3VJ2lvkif3hHKzOf5pOyOKNyd4kRsnWcxtkEvI1bmdZUZyUd4AmAwrvflrmIpHIqzF8LIR0RVMNh65izMf1gtb7sVm+4JbBc5+LhOjxlcqHgoAcrnHE1i0pEZ44zi/DvjNnfmmQFFMG4xqJCDvyoVGIpHvRmmZJoQIW92amh9JTngnuy+QeBPGAQJgdGWArzgeXOxkvmZRJ6VILJIr1eYWy79HdMUsNP0AvZEEVOuzEov0Kv2pW7OSt2DDNR+u9f1XJDjfiV8+oyOfCUsxI6sleFoMxzw4ojsstwdKiKw/uVDbQFiTJrkcw/DZ6acQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN0PR01MB7215.prod.exchangelabs.com (2603:10b6:408:15a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 2 Aug 2022 17:43:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 17:43:33 +0000
Message-ID: <fedc9cc2-4fc5-b7ed-081f-85a13d821fa1@talpey.com>
Date:   Tue, 2 Aug 2022 13:43:33 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <smfrench@gmail.com>
Cc:     Rowland Penny <rpenny@samba.org>, CIFS <linux-cifs@vger.kernel.org>
References: <20220801190933.27197-1-ematsumiya@suse.de>
 <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia>
 <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
 <20220802135201.4vm36drd5mp57nvv@cyberdelia>
 <CAH2r5muSREEiwehp0c0V0OFBbicJceiBxTBjasNyL36rQLqK6g@mail.gmail.com>
 <20220802155852.ae77gkacfrlmiv4t@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220802155852.ae77gkacfrlmiv4t@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0106.namprd02.prod.outlook.com
 (2603:10b6:208:51::47) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e08b4358-7fa1-48e6-08e3-08da74ae856a
X-MS-TrafficTypeDiagnostic: BN0PR01MB7215:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvmtqVoNlwPh6Hj/IKeWbPPphti5OoU5doaXZAswryAqQ2BsuEn766TbHSkJw+g4ZBVgNASpsICKBv1i4+3N2zJNQ2nJfi3xbu4wvm0fapEqFGXrvY1HA/7fodQecgzmOWkqFF2Ecy86RSkd/6PpsXTTf1qVqOUBT6zmMYPYfZsv5P9zqluunwnGa9ErN6eYFs6BnurBayopIW4yG+3HJ1+9ORY2oL3OsN5OotxxXAD1GIGrhFwCn8sjA1MRnPheKVzM8xvVba8Vio5z7SuI9ZyUFzB+Hl6ykENLfGmld8NUPyf4eeG3H2sl9Q4oIU1CaRv7R+c/dYjU9ZN7UyhfAdhc9Dy/Nhdfn0sVREc2nHVM1a4UY6xrQa3QaPXfYz8cbmQ6Q0GySib/lorHUA/V2dnVZsDOeQW5NeUXVcsXBmTvEuQys3rLX+l5PySJ9xKeBzVPsaL/PEMm8B2sGQ9zfeFd1NI2FJ1aS7VcD/DsYllFg02RrNcBlCft6luVIOEIDJ2wxKxRRVtip7YJEhFcSXXifpkPZhw+vgvAqb5OyxO0uEhHOl27RWX1N6fmnGP9FuTkW4jaB7/nM+Qa/PypyQYO7iRdtlBb+Q9plXRF8/oVjNq7Z83OF4LMAeWXwcvI4RRns/WD35VcjPggnqgOKGKML6q+yqzDAnHT7+/YQP6KbAkB5753pQa38ODGeXuIBNp97qpXLHr6PkYXiai/Dtv82n+FvhNyprHccZ0Y15ouS+Zn/qNcSiokYsydsr4OLU0hLLko1KyRte2hY4YGRH3ZIByPyCe3JkB/xWeI99caTUuvVCBlIJiQNrnztPmvs3hNEWbtaOEwjneWQNDD6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39830400003)(136003)(346002)(376002)(66476007)(38100700002)(316002)(38350700002)(66556008)(54906003)(66946007)(4326008)(8676002)(5660300002)(30864003)(41300700001)(2906002)(8936002)(6486002)(83380400001)(186003)(86362001)(478600001)(36756003)(31686004)(26005)(6512007)(31696002)(110136005)(53546011)(52116002)(2616005)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tzk3b0lTc0ZkY0FFVFgyWUNSaXFOQ2N6QXRBek9URmxMQWEvZGlQY1lUakRz?=
 =?utf-8?B?TGF6MkMybnREcE5NNDRNTDZONTdwajFJdTB4SlUwdzBNTnFrT085ZURtSitG?=
 =?utf-8?B?K1VSOVAxZXd4Nm9ZYXp3WERpaUljUkQ5S1lTVEVoTGVFU3JqWGRld2pGQS9H?=
 =?utf-8?B?MlhlMS9pNVBqYWJ1RnF2NDhzUkpkR0xJT1pBbFZtanVlalFRay9BUGNaTlpl?=
 =?utf-8?B?QVAwc1NZbmhFWUdBeFNlVU1NNnpCbEpVeWZsdWVBbWwySnk4eCs2ZTc1N05a?=
 =?utf-8?B?ODZOT0ZsTHpxNmRGcnh1NmdNb0Y0cnVaRU5ZYytQeUhGeU0vM3JWWk9RTFJC?=
 =?utf-8?B?TEsvL0lsYWxMYUVyNWdjUnNIRzZxSjN0cnUrN2xHZDIzeStSemNNa1NuL0dm?=
 =?utf-8?B?cHlzOEdRdkQxU2dBQll5MTdMU3RPOEJrNlZNSUtWb09hMGlxdlF2NGFmZU1t?=
 =?utf-8?B?MTFFV3cxWnJyZEpyT1MrTUUzcTR0SXN1b0JrdVhNclJtb2RicDBsc2JyMmtk?=
 =?utf-8?B?TmJaVzlqRTdGc2E3SDhTUFV0dFF0cm1MeHd4YVo5aUZaeFJYZ3ZrWXJJTU9B?=
 =?utf-8?B?WERWQ0hFQjhPQ1QzS0loYWpydU9TNGRnaFVxV0owNzBLN094RGt5M2cwYXU3?=
 =?utf-8?B?a3FUVTBhbWJIMGJaMjRiUkx4bk9rNTNMT0pzS21jOVNoa1lpQlo3V25RVkxT?=
 =?utf-8?B?N2xvbkFkemlHeEIzUE9Td0IwSVhVVmJYUVluMnZGNDFNQ2s5M21qbnRtZ05x?=
 =?utf-8?B?d1c5R0xycjFVSURVRUNCT0Y3TFZaNVY1MWxjRjJPRDVHc0VMYW1TdXBMM3hW?=
 =?utf-8?B?ZFJHNE5PK29PTFNITVovQXZRZ2VNdDZkQWtWOERQUXhJbVZoVHNJMy9IeWdi?=
 =?utf-8?B?RFlLSU5kT0M2QjBzQTdUb3VIUDhQd0VTNUdHYjRtVDhXMUFhOW1RWWNFK1kv?=
 =?utf-8?B?cVZhY2tjL1ZyV0l2dHhuMXVsNml6T28rY2YzWkZSNGZxc3NCOVVnN3FTV25v?=
 =?utf-8?B?dmdXaXM1dTVhVDdLR0ZZcW90NEczaHJjZmZYNjIxWUJGK2RDK1NpR0NqbnAr?=
 =?utf-8?B?am5NQXpHN3dkWnVEOGdDcGdoMWNyekJ3aldIWDFXRnR1dEkwM2RPQjBPZWp1?=
 =?utf-8?B?Sm5SL0RlMUJlY1BNY1NPMTA0N202L252bjBITkhSTHJaNko1QjRlNEQyUXha?=
 =?utf-8?B?M2tNM21qdllKMVVQMDhvNllQbFQySEhIU0M5QnQ4aFZhdWNsUGozb0NSdGE3?=
 =?utf-8?B?bUwzbVZudEZRMDdrWFhWYk1BcndFcElxaU1tV2xQTk1uYzBMRDlPQndMZVlI?=
 =?utf-8?B?c2tPSzJkR1dlMkRvSElPd0hvRGhOM2hlK3JIem9ST1lxV25MNEJxNHpYcW5a?=
 =?utf-8?B?b2QxY1I1OEtxTjAwL3VxZDJzQmc5bktySDFTQUpleXkzTGxiM2RkQmxsdWNu?=
 =?utf-8?B?T0FRT1dldHN6ajNHQ0ZDWUphSm1Scm02czZLeWRRNjNONEtHakY0VzJKNXFw?=
 =?utf-8?B?bEVKall3Y1NKRVRrS1ZuaVRWSnBBNnM3V2hTTnRNTzdpNzN3ZVo5L0F2S2lu?=
 =?utf-8?B?WHJqc0VRbGVjNzFrWnlNV3RMUXJSRFVPRHlJOXExR0VSWDdKSGROYUV4RFA5?=
 =?utf-8?B?dDFrMGZXZFNvUkZHbTk1R2dUYWVibXRDcGZFNklzNTU0bzFic0R0ZTJ3ZXhF?=
 =?utf-8?B?Vm1nVGFiSXhpR3Vkc2t2QysyNlQ5S1g5bVJqcWlkSTVnR3RlTXBLMms0VEtp?=
 =?utf-8?B?d3gzRnRFNXU0YW03dWJ6UjZQdkhqajY2SzNDUm5rK29RTW0xT1JWalllSXRi?=
 =?utf-8?B?OUljR05oTlNPaVNkbFRsbUJoNmhXcW5aTldxKzJsb2l5MVVMeE9xeHRJYTNJ?=
 =?utf-8?B?MUxrK1F6d0RtYUFGdktOODF6OFNrcnBsT09ZbnhLenZVVmpCUDBVUi9KUWxU?=
 =?utf-8?B?aDhEVHVDUkIrOHA1bFNVeVpSUi9aRGIvbDNaSFgzbmlWNnVoUytVODIxMi9p?=
 =?utf-8?B?ZW5pN3NUWmtHVFBscGxiUWhpNSt0ZVo4b200bzVsZE0vbGFIOXVmamhBS012?=
 =?utf-8?B?NVZHN3pFVWRwUzI0SDRWSTM1ekttZkFUVUtFbDRGVm1pajNXdmw3R3NXNVlK?=
 =?utf-8?Q?yJEk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e08b4358-7fa1-48e6-08e3-08da74ae856a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 17:43:33.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GSKNksrGaCLEhdMWZD8DUY5/i1uqWeDDiHB7nxoYX/RtSiIBQGPdbSLZv7dXpz7m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB7215
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

MHO, yes and yes.

On 8/2/2022 11:58 AM, Enzo Matsumiya wrote:
> On 08/02, Steve French wrote:
>> What about just "fs/smb" but "fs/smb_client" is also a possibility -
>> but I agree "fs/smbfs" could get confusing due to the very old module
>> that was removed more than 10 years ago
> 
> IMHO "fs/smb" is better than "fs/smb_client".
> 
> Let me know if it's ok to resubmit a v2 of this rename series.
> 
> Also, do we keep the module name as smbfs.ko?
> 
>> On Tue, Aug 2, 2022 at 8:52 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>>
>>> On 08/01, Tom Talpey wrote:
>>> >On 8/1/2022 4:14 PM, Enzo Matsumiya wrote:
>>> >>On 08/01, Rowland Penny wrote:
>>> >>>On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
>>> >>>wrote:
>>> >>>>Hi,
>>> >>>>
>>> >>>>As part of the ongoing effort to remove the "cifs" nomenclature from
>>> >>>>the
>>> >>>>Linux SMB client, I'm proposing the rename of the module to "smbfs".
>>> >>>
>>> >>>Hi, this has absolutely nothing to do with myself, but Linux used
>>> >>>'smbfs' before it started to use 'cifs', so you are going back to an
>>> >>>old term. This could be confusing.
>>> >>
>>> >>Hi Rowland, I'm aware of that. I had nothing to do with either
>>> >>(choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
>>> >>stayed "smbfs". And TBH this is the most coherent name, of all
>>> >
>>> >I dug around the old tarballs and it looks like fs/smbfs was pulled 
>>> from
>>> >the kernel after 2.6.36, in early 2011. This was different from 
>>> fs/cifs,
>>> >which entered the kernel much earlier, so they previously coexisted.
>>> >
>>> >I don't think the name ambiguity is very important, but I do wonder if
>>> >git might uncover some conflicts, when a previously removed directory
>>> >suddenly reappears with new content? There wasn't a lot in fs/smbfs
>>> >though.
>>>
>>> I haven't considered that.
>>> Doing a "git log --follow -- fs/smbfs" does show the older commits for
>>> before the previous migration/rename:
>>>
>>> ----
>>> commit 1e20c73a2935be2d9f19ebc63ddee1afccc42b07
>>> Author: Enzo Matsumiya <ematsumiya@suse.de>
>>> Date:   Mon Aug 1 15:05:23 2022 -0300
>>>
>>>      smbfs: rename directory "fs/cifs" -> "fs/smbfs"
>>>
>>>      Update fs/Kconfig and fs/Makefile to reflect the change.
>>>
>>>      Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>
>>> commit be9eee2e8b87e335531a3ae13abb8d26e834c438
>>> Author: Christoph Hellwig <hch@infradead.org>
>>> Date:   Sun Oct 10 05:36:29 2010 -0400
>>>
>>>      smbfs: use dget_parent
>>>
>>>      Use dget_parent instead of opencoding it.  This simplifies the 
>>> code, but
>>>      more importanly prepares for the more complicated locking for a 
>>> parent
>>>      dget in the dcache scale patch series.
>>>
>>>      Note that the d_time assignment in smb_renew_times moves out of 
>>> d_lock,
>>>      but it's a single atomic 32-bit value, and that's what other sites
>>>      setting it do already.
>>>
>>>      Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>>> ...
>>> ----
>>>
>>> I don't know if that would cause a real problem though, someone more
>>> experienced with renaming modules/directories could provide their
>>> opinion.
>>>
>>> Could we have an empty commit between old commits and the new rename to
>>> serve as a marker maybe?
>>>
>>> >Either way, I think the module name is the question here, and it 
>>> doesn't
>>> >have to be the same as the directory. I still prefer smbfs.
>>> >
>>> >Another possibility for the directory is "ksmb", which might rhyme with
>>> >the server, and keep it close alphabetically too? OTOH it might be
>>> >confusing to have two similar names.
>>>
>>> My original idea of "ideal" was to have:
>>>
>>> fs/smbfs/
>>> fs/smbfs/common
>>> fs/smbfs/client
>>> fs/smbfs/server
>>>
>>> Which aligns with e.g., drivers/nvme/ that has host/ and target/ subdirs
>>> to accomodate client and server code. This would make things way more
>>> manageable given the quantity of shared code between cifs.ko and
>>> ksmbd.ko.
>>>
>>> Another option is:
>>> fs/smbfs_client/
>>> fs/smbfs_common/ (already existing)
>>> fs/smbfs_server/
>>>
>>> But, personally, I'm not really a fan of the underscores.
>>>
>>> My 2c only though.
>>> Thoughts?
>>>
>>> >And sorry but I hate the idea of adding "-client". Should we rename
>>> >ksmbd to smb-server?? I don't think so.
>>>
>>> Agreed.
>>>
>>> >Tom.
>>>
>>> Cheers,
>>>
>>> Enzo
>>>
>>> >>available/known choices; you know the protocol (SMB), you know it 
>>> isn't
>>> >>tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
>>> >>used (as a module alias)), it's a Linux filesystem module ("FS").
>>> >>
>>> >>Also the "fs/smbfs_common" directory was renamed as recent as last 
>>> year
>>> >>(from "cifs_common") (cf. commit 23e91d8b7).
>>> >>
>>> >>>Rowland
>>> >>
>>> >>Thanks for the input, though. As an RFC patch, I'm waiting for more
>>> >>feedback and suggestions.
>>> >>
>>> >>
>>> >>Cheers,
>>> >>
>>> >>Enzo
>>> >>
>>> >>>>
>>> >>>>As it's widely known, CIFS is associated to SMB1.0, which, in turn,
>>> >>>>is
>>> >>>>associated with the security issues it presented in the past. Using
>>> >>>>"SMBFS" makes clear what's the protocol in use for outsiders, but
>>> >>>>also
>>> >>>>unties it from any particular protocol version. It also fits in the
>>> >>>>already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
>>> >>>>
>>> >>>>This short patch series only changes directory names and
>>> >>>>includes/ifdefs in
>>> >>>>headers and source code, and updates docs to reflect the rename.
>>> >>>>Other
>>> >>>>than that, no source code/functionality is modified (WIP though).
>>> >>>>
>>> >>>>Patch 1/3: effectively changes the module name to "smbfs" and create
>>> >>>>a
>>> >>>>       "cifs" module alias to maintain compatibility (a warning
>>> >>>>       should be added to indicate the complete removal/isolation
>>> >>>>of
>>> >>>>       CIFS/SMB1.0 code).
>>> >>>>Patch 2/3: rename the source-code directory to align with the new
>>> >>>>module
>>> >>>>       name
>>> >>>>Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
>>> >>>>or
>>> >>>>       "cifs module" to use the new name
>>> >>>>
>>> >>>>Enzo Matsumiya (3):
>>> >>>>  cifs: change module name to "smbfs.ko"
>>> >>>>  smbfs: rename directory "fs/cifs" -> "fs/smbfs"
>>> >>>>  smbfs: update doc references
>>> >>>>
>>> >>>> Documentation/admin-guide/index.rst           |   2 +-
>>> >>>> .../admin-guide/{cifs => smbfs}/authors.rst   |   0
>>> >>>> .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
>>> >>>> .../admin-guide/{cifs => smbfs}/index.rst     |   0
>>> >>>> .../{cifs => smbfs}/introduction.rst          |   0
>>> >>>> .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
>>> >>>> .../admin-guide/{cifs => smbfs}/usage.rst     | 168 
>>> +++++++++-------
>>> >>>>--
>>> >>>> .../{cifs => smbfs}/winucase_convert.pl       |   0
>>> >>>> Documentation/filesystems/index.rst           |   2 +-
>>> >>>> .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
>>> >>>> .../filesystems/{cifs => smbfs}/index.rst     |   0
>>> >>>> .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
>>> >>>> Documentation/networking/dns_resolver.rst     |   2 +-
>>> >>>> .../translations/zh_CN/admin-guide/index.rst  |   2 +-
>>> >>>> .../translations/zh_TW/admin-guide/index.rst  |   2 +-
>>> >>>> fs/Kconfig                                    |   6 +-
>>> >>>> fs/Makefile                                   |   2 +-
>>> >>>> fs/cifs/Makefile                              |  34 ----
>>> >>>> fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
>>> >>>> fs/smbfs/Makefile                             |  34 ++++
>>> >>>> fs/{cifs => smbfs}/asn1.c                     |   0
>>> >>>> fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
>>> >>>> fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
>>> >>>> fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
>>> >>>> fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
>>> >>>> fs/{cifs => smbfs}/cifs_ioctl.h               |   0
>>> >>>> fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
>>> >>>> fs/{cifs => smbfs}/cifs_spnego.h              |   0
>>> >>>> .../cifs_spnego_negtokeninit.asn1             |   0
>>> >>>> fs/{cifs => smbfs}/cifs_swn.c                 |   0
>>> >>>> fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
>>> >>>> fs/{cifs => smbfs}/cifs_unicode.c             |   0
>>> >>>> fs/{cifs => smbfs}/cifs_unicode.h             |   0
>>> >>>> fs/{cifs => smbfs}/cifs_uniupr.h              |   0
>>> >>>> fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
>>> >>>> fs/{cifs => smbfs}/cifsacl.h                  |   0
>>> >>>> fs/{cifs => smbfs}/cifsencrypt.c              |   0
>>> >>>> fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
>>> >>>> fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
>>> >>>> fs/{cifs => smbfs}/cifsproto.h                |  10 +-
>>> >>>> fs/{cifs => smbfs}/cifsroot.c                 |   0
>>> >>>> fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
>>> >>>> fs/{cifs => smbfs}/connect.c                  |  36 ++--
>>> >>>> fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
>>> >>>> fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
>>> >>>> fs/{cifs => smbfs}/dfs_cache.h                |   0
>>> >>>> fs/{cifs => smbfs}/dir.c                      |   2 +-
>>> >>>> fs/{cifs => smbfs}/dns_resolve.c              |   0
>>> >>>> fs/{cifs => smbfs}/dns_resolve.h              |   0
>>> >>>> fs/{cifs => smbfs}/export.c                   |   8 +-
>>> >>>> fs/{cifs => smbfs}/file.c                     |  16 +-
>>> >>>> fs/{cifs => smbfs}/fs_context.c               |  20 +--
>>> >>>> fs/{cifs => smbfs}/fs_context.h               |   0
>>> >>>> fs/{cifs => smbfs}/fscache.c                  |   0
>>> >>>> fs/{cifs => smbfs}/fscache.h                  |   6 +-
>>> >>>> fs/{cifs => smbfs}/inode.c                    |  10 +-
>>> >>>> fs/{cifs => smbfs}/ioctl.c                    |   6 +-
>>> >>>> fs/{cifs => smbfs}/link.c                     |   2 +-
>>> >>>> fs/{cifs => smbfs}/misc.c                     |  14 +-
>>> >>>> fs/{cifs => smbfs}/netlink.c                  |   0
>>> >>>> fs/{cifs => smbfs}/netlink.h                  |   0
>>> >>>> fs/{cifs => smbfs}/netmisc.c                  |   2 +-
>>> >>>> fs/{cifs => smbfs}/nterr.c                    |   0
>>> >>>> fs/{cifs => smbfs}/nterr.h                    |   0
>>> >>>> fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
>>> >>>> fs/{cifs => smbfs}/readdir.c                  |   4 +-
>>> >>>> fs/{cifs => smbfs}/rfc1002pdu.h               |   0
>>> >>>> fs/{cifs => smbfs}/sess.c                     |  10 +-
>>> >>>> fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
>>> >>>> fs/{cifs => smbfs}/smb2file.c                 |   2 +-
>>> >>>> fs/{cifs => smbfs}/smb2glob.h                 |   0
>>> >>>> fs/{cifs => smbfs}/smb2inode.c                |   2 +-
>>> >>>> fs/{cifs => smbfs}/smb2maperror.c             |   0
>>> >>>> fs/{cifs => smbfs}/smb2misc.c                 |   0
>>> >>>> fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
>>> >>>> fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
>>> >>>> fs/{cifs => smbfs}/smb2pdu.h                  |   0
>>> >>>> fs/{cifs => smbfs}/smb2proto.h                |   0
>>> >>>> fs/{cifs => smbfs}/smb2status.h               |   0
>>> >>>> fs/{cifs => smbfs}/smb2transport.c            |   2 +-
>>> >>>> fs/{cifs => smbfs}/smbdirect.c                |   0
>>> >>>> fs/{cifs => smbfs}/smbdirect.h                |   2 +-
>>> >>>> fs/{cifs => smbfs}/smbencrypt.c               |   0
>>> >>>> fs/{cifs => smbfs}/smberr.h                   |   0
>>> >>>> fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
>>> >>>> fs/{cifs => smbfs}/trace.c                    |   0
>>> >>>> fs/{cifs => smbfs}/trace.h                    |   0
>>> >>>> fs/{cifs => smbfs}/transport.c                |   4 +-
>>> >>>> fs/{cifs => smbfs}/unc.c                      |   0
>>> >>>> fs/{cifs => smbfs}/winucase.c                 |   0
>>> >>>> fs/{cifs => smbfs}/xattr.c                    |  18 +-
>>> >>>> 91 files changed, 414 insertions(+), 417 deletions(-)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
>>> >>>>(100%)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
>>> >>>> rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
>>> >>>> rename Documentation/admin-guide/{cifs => 
>>> smbfs}/winucase_convert.pl
>>> >>>>(100%)
>>> >>>> rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
>>> >>>> rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
>>> >>>> rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
>>> >>>> delete mode 100644 fs/cifs/Makefile
>>> >>>> rename fs/{cifs => smbfs}/Kconfig (72%)
>>> >>>> create mode 100644 fs/smbfs/Makefile
>>> >>>> rename fs/{cifs => smbfs}/asn1.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_debug.c (96%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_debug.h (98%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_swn.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_swn.h (95%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifsacl.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/cifsacl.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifsglob.h (99%)
>>> >>>> rename fs/{cifs => smbfs}/cifspdu.h (99%)
>>> >>>> rename fs/{cifs => smbfs}/cifsproto.h (99%)
>>> >>>> rename fs/{cifs => smbfs}/cifsroot.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/cifssmb.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/connect.c (99%)
>>> >>>> rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
>>> >>>> rename fs/{cifs => smbfs}/dfs_cache.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/dfs_cache.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/dir.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/dns_resolve.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/dns_resolve.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/export.c (91%)
>>> >>>> rename fs/{cifs => smbfs}/file.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/fs_context.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/fs_context.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/fscache.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/fscache.h (98%)
>>> >>>> rename fs/{cifs => smbfs}/inode.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/ioctl.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/link.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/misc.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/netlink.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/netlink.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/netmisc.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/nterr.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/nterr.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/ntlmssp.h (98%)
>>> >>>> rename fs/{cifs => smbfs}/readdir.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/sess.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb1ops.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb2file.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb2glob.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2inode.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb2maperror.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2misc.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2ops.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb2pdu.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smb2pdu.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2proto.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2status.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/smb2transport.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/smbdirect.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/smbdirect.h (99%)
>>> >>>> rename fs/{cifs => smbfs}/smbencrypt.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/smberr.h (100%)
>>> >>>> rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
>>> >>>> rename fs/{cifs => smbfs}/trace.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/trace.h (100%)
>>> >>>> rename fs/{cifs => smbfs}/transport.c (99%)
>>> >>>> rename fs/{cifs => smbfs}/unc.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/winucase.c (100%)
>>> >>>> rename fs/{cifs => smbfs}/xattr.c (98%)
>>> >>>>
>>> >>>
>>> >>
>>
>>
>>
>> -- 
>> Thanks,
>>
>> Steve
> 
