Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3250EC43334
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 02:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiGZCXO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 22:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiGZCXN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 22:23:13 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF22873B
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 19:23:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcnmaFeK58zKIgsI8bhX6jxf0x4f/5QYi9IPJCRB9eVIW6pCRoAGkzak8BCxSX6Rc2NLkyBB1iH1DccLTsniO87FmOJ49TfTyzce65IbntUIHjEcusm4BiURjK87CDZu6NWoeSUzx18Lt9On+J7wTvrk1CeSoPY7ATVaTlX8BNIdEKZsUE3XCY8huGm9+LWZasPw+4dY0PlXcTCfLNx0T/7nxTZMvncbMjRpWzQG3bqPcChRLdC6EDF/DObli+EAMZFwHRkiEEVdwrSP40t/UaQLWf6u71Vfss4aJIh5rXI3rd27x/1pv5aHYj/tHuEUxJA6httaVStA6LXIg20PuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dLLiq8990uaNSqjgR42ggKSG7gXOQ8KoCSv1XPGi07A=;
 b=UUNg2eSMgZfuYfN3uQLZ2k9blCmbgcJXgQfzxdQBGMyFC03qdYhKWvEHUNAxA04BCOs5miS1Yvzh+4WyFon1RNVArlY80aDsVOg/FxCRZbnLVcWpkJ6T0siqdFhFZywJ/INJXY2PRtVk6k5wvwx7eZIpAGwsu0I7CbkV0Ja9nkpT4d7pyKLNLTM8O6Dpil1hJ81x5K51VXnaBAxdG2yB02kE1xZzcuhvSIw0AvNbuHF5QLiRw9XWLmpC/93gk6jieYuHSrXv3KKcT0f1+GknmrjDOgNoPTPe8TqKDYVInNKLNM22yw2YWiTnBQEiTHOyFcVbhOu5mjYFYOAM3DeN6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB6027.prod.exchangelabs.com (2603:10b6:5:1da::25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.20; Tue, 26 Jul 2022 02:23:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 02:23:09 +0000
Message-ID: <bec8a446-6c74-3ef7-37f0-49cd478599a6@talpey.com>
Date:   Mon, 25 Jul 2022 22:23:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [RFC PATCH v2 00/10] cifs: rename of several structs and
 variables
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220725223707.14477-1-ematsumiya@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220725223707.14477-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0220.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f429727e-54cb-499e-f298-08da6eadc817
X-MS-TrafficTypeDiagnostic: DM6PR01MB6027:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9GCEckXTqAg7UzUf7MP+/ntjPfEo3Gv07K+5JR2g4sb413l1CWQ7LNaaIOn6z/+4lf1L20c9vARarv2OcdsujrHKahPdZuUGD9T6OMqFoAtU+3lzc2u4N0/8yKfy4vnpOScraFZBaqLOeNtHT1Menq25SRmFlbYoTBz5ftLF+jEAu4FoV3y2xErsUZ2+eDrtVL/AtguX5q6IVrBvHh8KyvAFK1QbhF7nTQ59GYmowI72hhaahDHousnNjD+TQdhbCnglAuGSywNh/5QPQLScJKNqK7JJrKJy81ly6zQHc7YkiJ0Oc+0/yOp2/JaVwvq45jdAy47VXphkNy9P2N0nlECU9pFVG2MSPQSpfE+3CFv4fcUrsDDH5lOlv98RKzCqisLvzdAwbB3fBIw1aaCU7qmekOX3GzCMLY0qQRmPQEMmr5aiY3F3qHd8k0eEVcmMzs5TMDimvcuMTV5kNhdZGlwjxRCU3uRUYFHvlsxoMBwGf8SWzQG9maeb0+S/LpzU045aBYA+ktKBDy6IixNq7kTd6g4r2qvMzKUbzV7Po5LVzwK50BEp17mt+y9T/fJu3KU3LHr4uWECLIAIjS7MP0hUb3tBbh9FDHLlPf6tHuJ1dRHjy4eZljSJ4RRYuOUgrXyiou4LeeNiVpd06Y1VAqMwEsd2CX+fd21E5lK5PhGAjGrBakRyJxdeUvFVa8uVmD+x/8JFinfxyOa6M/MdW2HcE4of6YDpVdaIKJ6r1H3WaM6x/Vw9TqSjTC24LxIyLo9roIQ+t7AQUmlodSihlxKc9mX1KtW9W2H69lb20dVLH7dLB981c6W9mmQx6iP0ZI18MCh2gtIAbb05K2l6pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(376002)(396003)(39830400003)(83380400001)(41300700001)(26005)(6506007)(52116002)(66476007)(66946007)(4326008)(6512007)(66556008)(6666004)(31696002)(36756003)(86362001)(31686004)(2616005)(8676002)(316002)(186003)(53546011)(5660300002)(8936002)(2906002)(478600001)(38100700002)(38350700002)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHZDWVNQSW8xem1zTXJ3cnRiVHZYU2doOWtneWsrY1IvS1lqTmhuaERkajVs?=
 =?utf-8?B?cWwyelgycXZRd3hsMGNPTXd2L3ZiN1oxaXRINVIweFdETllFYVUvQXBJZXZK?=
 =?utf-8?B?QUtPekUzVU4va1JqT3BQY3FUT1BUQy9CNHhnL3c4cjdiU3RVUU1Wdm1YSjhS?=
 =?utf-8?B?NVlKcE9FTTZ1VFlySGZsRzVWQkhZaEZiVXl1R3JoSmlpNVQ2UkJPSTl4S0Nh?=
 =?utf-8?B?ZTB5MXhscXNub2ZPUkxNMkduZTkrbnMvL1BINnFPZWpHbEtHSG9ENmtXMWUz?=
 =?utf-8?B?OERIVW9RZ2VzcUJPV1NqdVZyQ0dDK2k4YUxER3d5VHIwaldRZURCVlZjMi90?=
 =?utf-8?B?UVV3UXZOYTl1YkpFOExEeGZ0UmM5bW9EYUNha3JpV0NlLytnNmVnK1RVaDZv?=
 =?utf-8?B?U1FxUkJ3NEk3MVpBcWFIallkM2M5OW1iekpnTHVkanpCU0plR2Z3anA4cE52?=
 =?utf-8?B?S1NRb2xvOTVRbUhobkZ1Sk1Qb2grMnlPdU1FYW9NMnExbkxUenR6TmYyWWRV?=
 =?utf-8?B?c0g0Y1RoMXZkWElQbmQvV1V5WlVzR3RvOWdEWmtuQUN0aGFiNVk0aEV6emxW?=
 =?utf-8?B?RWZNMXZFTlRVbDd3eEpDb1IzT0M1KzJTcGJZVFRZblhMU29UbnFkZElNUnFN?=
 =?utf-8?B?L3haMHlwN0NSRmdnQ2xZMFZZdkNSYzZOYTE2U1UwWXVQcWxzY0hzZkU2dEtY?=
 =?utf-8?B?MDFpcUtwaHNWajhUcVcvUVl6OU13MXJhL0hrZDI2ZyswWGVQNXBzTWZmNW1j?=
 =?utf-8?B?QjJkVGZwL1VFcVE5ajVqS3grMDZQZmdBRjEzdXF1YjYvTGtqSVdDWE5SK2lk?=
 =?utf-8?B?UDlYWnJOOEFWNjVKN1JXelpaSkx6TitPbnBzWDJMcUxWa3pXU1ptSnNLaENK?=
 =?utf-8?B?dEdBZlFPRWVRMW5OaVQ2WGkyY0lYTlhVQytZazJQNXc2WkRJTVZuZTRkd2F5?=
 =?utf-8?B?T0JQRUN3VzdXV1NFM1diQjMweUU4VW1CckxhSGtrL2tPNkU3VVRaK3JRTDVm?=
 =?utf-8?B?K2dRRUx5OS9SZ3hJNVpXcnVVRDdhZkpNMU9JeWRBNGdualJCSitMdDlkZFFV?=
 =?utf-8?B?dGRTMjVkMTNFcEx4N3pyWDFlZ0hSQWw5ejl3Z2hnUHpKVXNJY1I2ZU5hL2k1?=
 =?utf-8?B?OTVNRFhCWXNkWGUyQTBoaWxVdkxkTWs1akd1TzJidUF0dFYwaVJxWU9xUmpU?=
 =?utf-8?B?TEJCellJRTBLOWk3eDFMbGQ2aXYwdUlSUlVJQ0JSZnRHdW1UREowcGxKZWFK?=
 =?utf-8?B?VnJod3dvV3dQQkFlOTlOSGc4YkhiL1JxaGhoV2ZWZ2ZOTnI3eHYvT25TdE45?=
 =?utf-8?B?bnRwTVhlQndDdW9pS1hOVmZzYVF6Z2JMMkNOajYyTTlJWGk3Q056ZEJVQUMv?=
 =?utf-8?B?YUFiOXpka3NVTjRONUNVbkJIRXJqTnJRM1h5ZEhSN1JYSHZSalNseXpmZS9s?=
 =?utf-8?B?Lzd0VjA5ajdWendQQnVWcXZsckl4R3YxZXpMcTdncGs1WmZMd0RhbUx3bWl1?=
 =?utf-8?B?TW56WXRFaFZ6dXRhWFl0eXEwR2gvdCtaSTdiRjU2bWZ0Tm1YWE1qaXhJVy9C?=
 =?utf-8?B?UUU3Tmo4aXZzQUdyMFlzaWl5endhSDJsajJPalFVbi9HS0JYSGZwdkNvbWtS?=
 =?utf-8?B?NXJDaHY3T0VUYTNWZDJKM2VHODZ1QXd2Vm5LMGwvL3NKN3hTRDhUU3FTMWJk?=
 =?utf-8?B?QUM4MUlzWmpxbmN0V0h4QldBWmdHNG0rM005bUgyR21DdjFnK084TnhzSWd4?=
 =?utf-8?B?dTc1bCtlZzAwZ3JPTkVKVEFiVk95VHpNcEp3bkVIQk13ckdkcDZ3RkcyMHFY?=
 =?utf-8?B?MFBnTEdMOGZsbkFvb0F1MDRmUU1KRTZkd2dGNkJTaE9mVXBORWJJbzBYZ2U4?=
 =?utf-8?B?d0w1VUV5WjZrcjlxWGRUQ3JWRnA4eXRMdG5sUXBPNkc4emszazd4R1dWTGlu?=
 =?utf-8?B?SWFpYjZ1dm52LzV4MWF1U2pxUjhSbWZLdUU1SktqMEU5aDVtM1k3VFZHMFF5?=
 =?utf-8?B?MFdtQUR0d3cwRTRpM1hRMVoydjZrbVRrOUpVWW9wWE0vaUc3SWRrcTJ5MDlt?=
 =?utf-8?B?OUZPSGI1Rlo2REEzMHQ2aDdOdmhxOWh6U2RNUWJYeksyQTZISkZvU3FHZ1Iy?=
 =?utf-8?Q?wNXE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f429727e-54cb-499e-f298-08da6eadc817
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 02:23:09.3631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VmphjmczXGjWt95ARbwnb1n64kkjq4ncnIjr3EBgFZAFfwLe+U/gN1e+Z68GgeuL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB6027
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/25/2022 6:36 PM, Enzo Matsumiya wrote:
> Hi all,
> 
> This patch set (v2) renames several cifs.ko data structures, variables, and
> functions with the goal to improve readability of the code.
> 
> In summary, what's been done:
> - change from CamelCase to snake_case
> - try to give more meaning to globals and struct members
> - rename status fields (server, ses, tcon), define constants for the
>    various statuses (4/11 can be shared between those structs, others are
>    specific to each)
> - rename of list_head variables to better represent whether they'are
>    used as a list element ("head") or a list per se. Also tried to give
>    more meaning to these, as "rlist", "tlist", "llist" looked confusing
>    and, sometimes, ambiguous.
> - remove redundant prefixes from struct members name, e.g.
>    tcon_tlink's tl_*, smb_rqst's rq_*, cifs_fattr's cf_*, etc
> 
> No functional changes has been made.
> 
> I know these touch some very old code that older devs are highly used
> to, but I see this as an improvement to reading the code for everyone.
> 
> I'll be waiting for your reviews and feedback.

Enzo, I think this effort is great. If you combine this modernization
with refactoring SMB1 into separate files to make it easier to do
away with entirely, I'll be even more supportive.

Tom.

> Cheers,
> 
> Enzo
> 
> v2:
>    - remove status typedefs (suggested by Christoph Hellwig)
>    - define status constants instead, reuse some between different
>      structs so we don't have to create a different set of statuses
>      for each cifs struct
> 
> Enzo Matsumiya (10):
>    cifs: rename xid/mid globals
>    cifs: rename global counters
>    cifs: rename "TCP_Server_Info" struct to "cifs_server_info"
>    cifs: rename cifs{File,Lock,Inode}Info structs and more
>    cifs: convert server info vars to snake_case
>    cifs: change status and security types enums to constants
>    cifs: rename cifsFYI to debug_level
>    cifs: rename list_head fields
>    cifs: rename more CamelCase to snake_case
>    cifs: rename more list_heads, remove redundant prefixes
> 
>   fs/cifs/Kconfig         |   2 +-
>   fs/cifs/asn1.c          |   4 +-
>   fs/cifs/cifs_debug.c    | 158 ++++-----
>   fs/cifs/cifs_debug.h    |  29 +-
>   fs/cifs/cifs_spnego.c   |   4 +-
>   fs/cifs/cifs_spnego.h   |   2 +-
>   fs/cifs/cifs_swn.c      |  24 +-
>   fs/cifs/cifs_swn.h      |   8 +-
>   fs/cifs/cifs_unicode.c  |   4 +-
>   fs/cifs/cifs_unicode.h  |   2 +-
>   fs/cifs/cifsacl.c       |  22 +-
>   fs/cifs/cifsencrypt.c   |  78 ++---
>   fs/cifs/cifsfs.c        | 124 +++----
>   fs/cifs/cifsglob.h      | 694 ++++++++++++++++++++--------------------
>   fs/cifs/cifsproto.h     | 172 +++++-----
>   fs/cifs/cifssmb.c       | 356 ++++++++++-----------
>   fs/cifs/connect.c       | 574 ++++++++++++++++-----------------
>   fs/cifs/dfs_cache.c     | 178 +++++------
>   fs/cifs/dfs_cache.h     |  40 +--
>   fs/cifs/dir.c           |  16 +-
>   fs/cifs/file.c          | 636 ++++++++++++++++++------------------
>   fs/cifs/fs_context.c    |   8 +-
>   fs/cifs/fs_context.h    |   2 +-
>   fs/cifs/fscache.c       |  18 +-
>   fs/cifs/fscache.h       |  10 +-
>   fs/cifs/inode.c         | 530 +++++++++++++++---------------
>   fs/cifs/ioctl.c         |  18 +-
>   fs/cifs/link.c          |  26 +-
>   fs/cifs/misc.c          | 185 ++++++-----
>   fs/cifs/netmisc.c       |   4 +-
>   fs/cifs/ntlmssp.h       |   6 +-
>   fs/cifs/readdir.c       | 344 ++++++++++----------
>   fs/cifs/sess.c          | 142 ++++----
>   fs/cifs/smb1ops.c       | 182 +++++------
>   fs/cifs/smb2file.c      |  36 +--
>   fs/cifs/smb2inode.c     | 136 ++++----
>   fs/cifs/smb2maperror.c  |   2 +-
>   fs/cifs/smb2misc.c      |  72 ++---
>   fs/cifs/smb2ops.c       | 555 ++++++++++++++++----------------
>   fs/cifs/smb2pdu.c       | 596 +++++++++++++++++-----------------
>   fs/cifs/smb2proto.h     |  68 ++--
>   fs/cifs/smb2transport.c | 112 +++----
>   fs/cifs/smbdirect.c     |  28 +-
>   fs/cifs/smbdirect.h     |  16 +-
>   fs/cifs/transport.c     | 236 +++++++-------
>   fs/cifs/xattr.c         |  12 +-
>   46 files changed, 3230 insertions(+), 3241 deletions(-)
> 
