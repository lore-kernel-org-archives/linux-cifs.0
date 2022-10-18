Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C54C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 14:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJROWt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 10:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbiJROWb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 10:22:31 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6067C4D92
        for <linux-cifs@vger.kernel.org>; Tue, 18 Oct 2022 07:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN20aUhcxdr2B5zRqJ5ZlwqZK36g1Io26hqE+9MlfldUV0SX/pTtPvIkV7FgHFn+04II6F6AOxN+dUxpM4/i5LimedRNGBYnYKqOHjA+QFnAgLAbTPJ6jjKTuwt1PDWpF/xmBBGQalMe7h+z/6c/8aScfrrCzMelJ1QlCEdyH1hU3wozOi3Jh47FOdQQ2AqTK4aLT9PkHvyh84H58ExPb6IPwRQooGhDSMnagqlTyydk2x8lfGMsLHHft3Bfy6bel9OdwXrnN8ePxA1SAedKXAI1vC/wdPqKcZ/QueFlQsc20M3/425i0Ah2IX6hwLalfDmWvf8qSzMig6/x2A1v8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auOferInRIz2iiUowRRvgAoWR800pvrL14lafJuHtYU=;
 b=L3ScolkYJC2ijJ49g9mFTOxSFz8/H2FX+IvBsGgVgTEdLiHy6FjS1ZxNu/JM6HJZufVYG+g8RLYoMpaBkgZMM3Ii4wcLKbVZ2iNMQfPsQ4TV6iY7Q5m1qI7bkoVaped/ldpi21SjbYFFUPgKnrhDM9oDjWI9KrX5TGloKn5p6G+2WtL2ppc0iOZMHDEPlpgI/5uPVaGAN//WG+8WzDXR1hX5d22zgRvoKFlmYAH2G5+icOpqr3x6v3vxi1WvFv0NMGKQX8C45GC9OI9sfZ/SDWvqGVs59FeBeD/mwI7lCd4LiFEh/i49poT+uQ67DjjN7j5u092jiMwneHs4cI+Nbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR01MB2359.prod.exchangelabs.com (2603:10b6:903:74::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Tue, 18 Oct 2022 14:22:18 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:22:18 +0000
Message-ID: <b1454884-cc28-9de5-8dc2-b96f92f1d8e4@talpey.com>
Date:   Tue, 18 Oct 2022 10:22:17 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] cifs: drop the lease for cached directories on rmdir or
 rename
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20221018073910.1732992-1-lsahlber@redhat.com>
 <20221018073910.1732992-2-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221018073910.1732992-2-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:208:23b::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CY4PR01MB2359:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d9f6904-b7e9-4e74-b021-08dab114296a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDrKFKRx2hfkMUKhe1LaOfjuvXyk/TrU2MIMWhf2Jr6ME+MEjWpT5RfNH0VRL869g7JpBbUKo0oiN/imILYWtFy3O8GzKHl9EmfkpNCgbyb7fSy8f9A8GBKvriV+/tQBOcboXTa5yNeJ6AkxtJ7Fn8JtUtzmdPukkfNJaTBqQh/Mhm2fyLysctOQV38IiHeWs3EpTg8DiMSaCL6jqCm2iSNPudLVlG+OQZdxTvhIxV3b+fp+SRVgqZjT1Al4Nyhm2wzEFvj+m6L+N2gp+KDC/PBU3xsu21kL8UR5CCSbgZUoCH2zwlTlNRhybqsjYmCZ1rvBy/R3XGN7TaVbO6C6vqjA9zyfRMpjuG4DmVMLuZKvGNf2frkwwuChxnKSeTA/zB4AtMA7upu8tysEqe5amV0dYLiJHxuhqgDHJdPINajE/DROP8+wFIPdBpWTAwBhJsIM6t63iBoVpMjjlLntukv/zWcGJvlmuV/OKiDQJnFXrc12uwQlTD7PJ08JCNWjhFp4mYFcsL5hrCsAmwlzZr1Z8JbLUoaFwG2Oaf47Uxkr6n/bJQPn+JgyIkgTdMoY1TZesdHeJsM4WQ/afWHBu1VITYgnHD7cX+mgdcyxsrFfpaig9suGUu07VcjG0FtpKq/bD70Te7ZphLoh0GlKS7W20gSCFhYSOWL0DUFPouzYPM5os7aJ30RN1L9OG3/yJBPEgVJbmqycl02UVRhs9xleMDSbO0lyuvJ8cl1rtXP9Kdqx5GNTQ2Nk1QK00bfqiOeU4kFvjv8YKuaEok7DOQTLUHbAULV2WU4z9iralEQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(39830400003)(346002)(451199015)(2616005)(186003)(26005)(53546011)(52116002)(6506007)(6512007)(83380400001)(2906002)(5660300002)(8936002)(110136005)(316002)(6486002)(478600001)(41300700001)(4326008)(8676002)(66476007)(66556008)(66946007)(36756003)(31696002)(86362001)(38100700002)(38350700002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czlYOE5UeWFNSmIxVzB2MWp4Y0p0aW1VblpLQ01EeHZYL09MbkxCdU40SHVz?=
 =?utf-8?B?WUVvc0R2SStnOGF5NEczdVRQckN0SVZCaWZ1alB3Y2xyeUpyVHJWanBNVzlB?=
 =?utf-8?B?M3hVVEhmbnRnR3BESjVPZzdrdVk3dFFvc25zZmlLVnJGNDZBbUI3N01DM2VQ?=
 =?utf-8?B?eHprRWJNc2tTMWowOHl5SUs3d0g3Vks1R1draHlWa3dTUGFGbVhTWnRRZkFI?=
 =?utf-8?B?RUpEajZvMXkvVytJaU1rVDg4VDY5cGlKaHh4UjlIRk15V3lqTWdaTkhOQndE?=
 =?utf-8?B?UHBvR0hWem5TbHUvVjd1dEYvdFVOWTZ5UnBseUR0TS9ITVltcmtDMFFuYkNK?=
 =?utf-8?B?NWRBZUxKUDhpRTdWSU41N2hGRitUVncyVHVGZ0NRcnRmTGJJSjFndVZrT2Iv?=
 =?utf-8?B?ampyelhVRXZKZWhPZlljREx4blE2cFM2eS9QTmtod1l4NnJsQTZYa1NyUDVn?=
 =?utf-8?B?VjhyeW41ZDZmZ2VRUHZzKzBPR2Zxc1EwUDJNbUl0OG1YSDJ5bDRNV3RKZkwv?=
 =?utf-8?B?YUI4VXlXeUd4NVptRFRYcEZhVUNrVThDdTNoUnViT0VuakVYSnJiVUw0QnR1?=
 =?utf-8?B?R1B6Q2lwTTh3SU9qQjNYYXYrWEtRUXdVL3ovUnZZZWsrSTRZRWFBbkpmMkg4?=
 =?utf-8?B?OGZkdXhSYjllUWNoNHE2K3NST0d0WnRwQXI0L21FOVRBNTZ2Q0tvSTNDbDR6?=
 =?utf-8?B?aGpOdS9WSC9CeEc1UTNOMWgzeVgwL1BJRXowcGF1ZU5IcE5VRU5od0Fjb2NE?=
 =?utf-8?B?anlyZ0pPOUVVano0RlZwendwU2RwQWp0U3BRckNZNTR6M2JucERyNmJPWUNo?=
 =?utf-8?B?ejRwaUdmOS9GTDE2VlpzZEU2UDJRRURNU0xXZ2RibnpsZzhGamx2ZGFMVWVm?=
 =?utf-8?B?TUphZnZpWmkvUncrL3dsRkNyZklOTnlEb3Jjbk9FYTE4NU9HYzEvV1dxbEQ1?=
 =?utf-8?B?SlVWbFRDYkZ6VGZGZGMzVmxsVzk3RVI5UkFmMFA3bEZMS3FPMHh0cEZnSHYx?=
 =?utf-8?B?djJoK1FvSVZzZk11M3lDOHlxa21BUzdFZjdBU1dkbzFmSmExT0toVU55QkZV?=
 =?utf-8?B?b3hZS3hST3BuMEJ2bFpwQWNlQkFNMDlvMlV5dXdZd2hvY05ac1B5eGdPbDFT?=
 =?utf-8?B?V0d0VVpKTmhGTFQ4TSt0MldhbnlMMC9VM3gybVJDbTJZYkx2azVhVTdmWlYw?=
 =?utf-8?B?eDRQcXE5UTdCUzBQcDlla2ozOTNJMjZISkxhTkVnSk1haktwanF6RkFRTTBS?=
 =?utf-8?B?M1dqbDBoeVZ3UFRneCt0d3ExZ0dqTGVnMmNSdUtlWEpyUjErSnVIVSs2ZVVH?=
 =?utf-8?B?cTRjdVQxaTNYeDFTRk9yU1dockZseFJQbzNpNjhCaHJNRUlyODg0NnZiN0tD?=
 =?utf-8?B?QmlCdmp6UmZ6dHA0NlY3Uk5JSW50ekNHT216enRubzN4ODdqdWNPR0FPb29J?=
 =?utf-8?B?M1M3NmR1TjN1Z3AvZyttNUZhd3drZGV4bDFYZHZTNjRnUklCY3B6TE0vRGNl?=
 =?utf-8?B?U2pmSTRlSlQ4NmFzZlVOcEpVTlJTNHNDQndpdEJrN0JTWkNFa3g3b3c1c3hH?=
 =?utf-8?B?b2FvcnN0Qk9VS0lENXhkcXdOMWc2VE9UeUY0OGNKSzVSS3IvellpcytOVTJ5?=
 =?utf-8?B?MXZva0UxRWxUTUF3VFlKaEl4bFFWeUJEdTBieitBVUVkc21ua2FZWjhsMnBs?=
 =?utf-8?B?Z2NYTVF5WndJYXQwSEF6VzVwQjRpdy9UVHZEdWMxNFZhYXQwY3FBT2pSTUJL?=
 =?utf-8?B?dW5RMEd1TThzYXk5aUgvV0ZFWW9kVmtQMmVkc1lTVC9nM1lPR2IxWVR2Rzhy?=
 =?utf-8?B?a0xlNzBFckpGR2tOS2FQcjEvYkR2clFBUWNZYXBLdC9xb0tSOFAwRFF2WkZ1?=
 =?utf-8?B?NmtoZXdFY3kyK0E0OTNLeWFnLytuL3k0bUNmelpRWnM0ZUhDSnJMeGhHWFE2?=
 =?utf-8?B?aXFEL3dqdEJIMzZ5OUIwS056NU15UDFXWWxIcGVwSUx5bllDakdaSGcweERN?=
 =?utf-8?B?SWFtblp2ZUFvc0d4T2VTMndZNWNZTllZSjIrVExXUjZlWEJob0FUanpwZ3Bu?=
 =?utf-8?B?TWVRZnpkcU1LNzVHVUZhbDh2ZEREdy9ZUUl0SVlRY1IyVmxFZzlQcU1MVzJm?=
 =?utf-8?Q?mmVpHgRNd0cJ/XhIJtx8QR8CB?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9f6904-b7e9-4e74-b021-08dab114296a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:22:18.0385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9hO4EdziL+Zi+43jmgtvugAlnaA+jlMnBx7LdBjM3TS0JfgCV/DYZKWGUuXEHyN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB2359
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/18/2022 3:39 AM, Ronnie Sahlberg wrote:
> When we delete or rename a directory we must also drop any cached lease we have
> on the directory.

Just curious, why drop the lease on rename? I guess this is related
to setting ReplaceIfExists, but that would apply to a lease on the
existing (replaced) directory, which would then become deleted?

I'm probably undercaffeinated, if not.

Tom.

> Fixes: a350d6e73f5e ("cifs: enable caching of directories for which a lease
> is held")
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cached_dir.c | 21 +++++++++++++++++++++
>   fs/cifs/cached_dir.h |  4 ++++
>   fs/cifs/smb2inode.c  |  2 ++
>   3 files changed, 27 insertions(+)
> 
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index ffc924296e59..6e689c4c8d1b 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -340,6 +340,27 @@ smb2_close_cached_fid(struct kref *ref)
>   	free_cached_dir(cfid);
>   }
>   
> +void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
> +			     const char *name, struct cifs_sb_info *cifs_sb)
> +{
> +	struct cached_fid *cfid = NULL;
> +	int rc;
> +
> +	rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
> +	if (rc) {
> +		cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
> +		return;
> +	}
> +	spin_lock(&cfid->cfids->cfid_list_lock);
> +	if (cfid->has_lease) {
> +		cfid->has_lease = false;
> +		kref_put(&cfid->refcount, smb2_close_cached_fid);
> +	}
> +	spin_unlock(&cfid->cfids->cfid_list_lock);
> +	close_cached_dir(cfid);
> +}
> +
> +
>   void close_cached_dir(struct cached_fid *cfid)
>   {
>   	kref_put(&cfid->refcount, smb2_close_cached_fid);
> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> index e536304ca2ce..2f4e764c9ca9 100644
> --- a/fs/cifs/cached_dir.h
> +++ b/fs/cifs/cached_dir.h
> @@ -69,6 +69,10 @@ extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
>   				     struct dentry *dentry,
>   				     struct cached_fid **cfid);
>   extern void close_cached_dir(struct cached_fid *cfid);
> +extern void drop_cached_dir_by_name(const unsigned int xid,
> +				    struct cifs_tcon *tcon,
> +				    const char *name,
> +				    struct cifs_sb_info *cifs_sb);
>   extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
>   extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
>   extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index a6640e6ea58b..68e08c85fbb8 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -655,6 +655,7 @@ int
>   smb2_rmdir(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>   	   struct cifs_sb_info *cifs_sb)
>   {
> +	drop_cached_dir_by_name(xid, tcon, name, cifs_sb);
>   	return smb2_compound_op(xid, tcon, cifs_sb, name, DELETE, FILE_OPEN,
>   				CREATE_NOT_FILE, ACL_NO_MODE,
>   				NULL, SMB2_OP_RMDIR, NULL, NULL, NULL);
> @@ -698,6 +699,7 @@ smb2_rename_path(const unsigned int xid, struct cifs_tcon *tcon,
>   {
>   	struct cifsFileInfo *cfile;
>   
> +	drop_cached_dir_by_name(xid, tcon, from_name, cifs_sb);
>   	cifs_get_writable_path(tcon, from_name, FIND_WR_WITH_DELETE, &cfile);
>   
>   	return smb2_set_path_attr(xid, tcon, from_name, to_name,
