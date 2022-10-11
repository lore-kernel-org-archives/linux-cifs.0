Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB96C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 16:38:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJKQiy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 12:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiJKQix (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 12:38:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C54212D33
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 09:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFdx1GwFAKapP3PU5udpBnSh+Aa4zEmg0mE5+GbxBZB0LqOEgrn1aJo9dsQRLgpjGGLU8GuzUfbKSYhEeA84nIlU2VAFoJlxH3BnZt2SjKLBkV6bRRVe9iyFMn946yvozBGVv9MrGFmuIKm9/Cx3AfiRqLvtwboOMD753Xissd3eJJNCjiLR+xwaQ9Sl9SUX1g2MJ12L4hccuxd3Afsz6Xvryz2hMmvxng9vBkENtlqVmsY+aJKGzxVqv7P3Unug6mHIEJtlzKoA/5WI/fANUxuEthc9BTFV2YrD2zCX/sfigXMnGSgJC6aBjLrZsvbmODVIIfTYJT6tlxV92eaL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LHEvsw/GSs+w5aofk1qap9JkBcm2d1lLFAUkuKoUKAk=;
 b=mGeebFHy6caXBff/cU0+TUjYkwWDW8NEEN4X5sJnknK5PgjY8OYgjmfFR828Lvjws/F3XawXeUjtIHUMxfgIhGbrzJwuCHLZtprQqYF0CzuI/gYcxEL/d3o+zBZIIm2XuKdXpUkZxj+UBwWlwvuP9MFSsFJY2szE3WGg4W8tEKZPm2PzfcbgRQ+QHLnpiwGGYsmmhNBrd3V8GikAIT8ItmJI0ksmh1tju4NF9fRzmcBGTNB/duvnPx/2Wlx2L0Ecfks582bQIT7Prg2JELxxd39ly85RzovNXWZ58oKpjZO1oySs7dgfXxyZLai8vmPNYHJTrqU1fArHpVqMJilzvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB2701.prod.exchangelabs.com (2603:10b6:300:fe::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.15; Tue, 11 Oct 2022 16:38:49 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Tue, 11 Oct 2022
 16:38:48 +0000
Message-ID: <f2d94342-c316-21d3-4dc8-7a969a102c2d@talpey.com>
Date:   Tue, 11 Oct 2022 12:38:47 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in
 emit_cached_dirents
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20221011064611.1428646-1-lsahlber@redhat.com>
 <20221011064611.1428646-2-lsahlber@redhat.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221011064611.1428646-2-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0338.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MWHPR01MB2701:EE_
X-MS-Office365-Filtering-Correlation-Id: 78d590b9-4c6e-4e90-3c3c-08daaba712aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJARGDmKfmnmlJToHVHAzN3HEXtvewHvEuLHAuL5Y5oDGw3d8gHa2D3lYmJ8nzfrJgUxvMBphOgrwjibEStYn4VFzQlNgGla9ehCTF1nZ6VDKt4CkUqTwQbhvYFBzxjI++8r5eNlVt3l2OQic8nFivAQfbOpG4PBPliPNydYzjsA7HuniZxa7es8pNyqurFLn2FigLcfWCb3hmhVHxKFesrPU0qzrZmBAwsMM7RkSU8RmmEC+ZRx/k2RlAJofLHP1pdclReIjrVn0R/caZZ+BfeAM9mBJ86vFgsnHJpj/4P8wWExKduy9HOL38Hx1vEp5fcEPXkWQmyIQns/yBkAW9hEi9V7RzJM0GjzNiQ7DA/AXXxeQKjCW4VQIV2LGQ5P5d8AypS0isDPZ7fGdNiq7e+vqxBXJ+5BUVPJhcYDg39El2zmbB8Kf4Yw5l5ZSYPx1wngniJQB7Z/B2C/Own2hkbuf1h/wiChTfSf3IGpUJ7y6ditXCln0zJjGxsDP2J+5qvjv2Syy01Yu4jFw+SgticmceYK5u7hzzkl47zmBPGyvjSBZ5W7hIWS8sGT8MZSfYPLxLYRG7lUyuP0A6c5EYsosPB1xxhDQ1ExPIxKD/YbKcGNGPwuBRtP7FxcJmpSTlkluzm6ZgwFKA6VlCZcOVvCKd142CIoF8cdiXPUmYKEPilMRZXf1rXXguoQGOL3mBfnBEjQLfoPN9ZbvLnNuk6pvrrUsqbPyzae0KjYz7GUa83QfS9kaJxgfHSB/WUMwt8lkcWXJM5nOIRf3KWNGfpmjsBMRmMxxYEiXBrUR5k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(396003)(39830400003)(376002)(451199015)(41300700001)(31686004)(2906002)(5660300002)(66476007)(4326008)(8676002)(8936002)(66946007)(316002)(110136005)(38350700002)(36756003)(38100700002)(66556008)(478600001)(83380400001)(6506007)(86362001)(26005)(6486002)(31696002)(2616005)(52116002)(6512007)(53546011)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG9VMk9PeDNZdkZiZVBsemFqNXR1dG9iU2daN01WeUdpeGdvQ1Rabkk3Tnh1?=
 =?utf-8?B?ZzlnZE0yQTNuVXBkSHpMNCttV3FZdDMvS2hzSW83VUV3YTJ2UTQ1RU01QWNv?=
 =?utf-8?B?d09DUE4xUEVOc2xkZzlZeWswZ090cng0RHR1RmdsdysreERsc3AvTjl3bzB6?=
 =?utf-8?B?ZDg1dzJZUTBiMGU5T2w1MEZvSDNXRmJGUE9zNkJaN1hFS1daVGxwc2FtV3VR?=
 =?utf-8?B?aDdYK0JaanRFUE5QYnB2Ym5MSzZrZURRS25RbUFqM2RJZXRCcGVPbTdaTDBP?=
 =?utf-8?B?ekswZ2lHMk9QN3hMZkQ0YnpJWjJWdUFzdjg2aWg1K3E4T0gxYklNNm9ZSWNl?=
 =?utf-8?B?N2JuSUgzVXJucDA3eDErd2VONjZ0L2lHSlR5ZnVOc0xwZ2VNaTdUb2tPU2lz?=
 =?utf-8?B?c2hXNFdvK2l1aTBHZVhLbjkwS2xvSDdFQk5TWWYxWjJFUGpnSkh0Wmhic3lI?=
 =?utf-8?B?SVVLbmpqQUZ1RTY5RXNQRHdZV3BtYjBSTmliTWo1aFRxRS85a2xBOFFJd1dy?=
 =?utf-8?B?RHVwNEJPdU1wN2hreFIrdlFrMldublN6OWNCMlMxa3JPcDRHTUUyeUkyRG1I?=
 =?utf-8?B?ZVdQL0RoY0ZRRSszMVU1SXZmRnQ3SWxHMkNkemw2WXc1eUJuL1lhaWtGcHZm?=
 =?utf-8?B?WTZoSVE1dXZpTG5iR3UvQVhyRW1Vd083Vkt5YTEwbVBFbmxEd1NTWllITm9m?=
 =?utf-8?B?d3FHTkx1Zk0raGJ1YmxNY21EVlJkT3FaNEg3MDh3WUZ5UjViN3R6dWIvQm1q?=
 =?utf-8?B?NHh2NzQwd2pRakQzMGZNb1dwcEpYWlFld3JLVGNvQ1EzQUkvNXJBVHRWNW8w?=
 =?utf-8?B?bC9ORUtlRFBvRmt6RkFRSlBzYUhiblpPZzdiaC9uS1BxWkhSUS82VzVkU1V0?=
 =?utf-8?B?eXJBSDRyaXhZR1dkZUtZUi9kczJRRlQyalA3SHBMUHJoVXZZWlJ6UjAxdDJy?=
 =?utf-8?B?djVOdFUxUXRlYTA1MmFlUW44eHd2cmRGTWxRYW9jVUszWkp6OFBhbUNhY01p?=
 =?utf-8?B?VTJObGRyRDlEQ1h3Uzl5T3FITE5uKzVDOCtlMlhmUkVzOCtaSk5hUTJwditI?=
 =?utf-8?B?MmVHSkw1dnI1bGtnMHNVU2JxQkhya0E1K3g2NmRxTzEraEYwN2JqZm1DTnVD?=
 =?utf-8?B?NDRDeksrZDRSOVVjYWc5YTUwN2pGQkwzV3hMdFd5K3dzZ2grUzNwNlhQUisz?=
 =?utf-8?B?blN2TVpmWmtydGR6Vml1YkY1eHNqZ3NXci9RTmM0MHdTYXNvb05OY0VEM0or?=
 =?utf-8?B?STFRSndzQUVvV0V6SlczMjBxM3kvamVCM29PbzFjVVVLM3FxckpMTHRiSXJU?=
 =?utf-8?B?djFGVUU1cWFVZTBsNE15aC81TFdScGxweGJtK1IwZXNGVTJwVjJhL1d3Uys3?=
 =?utf-8?B?ZTJzY2hoQm83aFE5SzU5cWp6cTdMV2s4ekd2MzFERFJpeGU4MlFwYzE2MEhp?=
 =?utf-8?B?VE41TWRJZmhTU21pektZOWpSclIvTzBQdVp3WnVMRWRsSHV0VlBoWUNTcTlQ?=
 =?utf-8?B?WnMyUWJLRUx1UUFHVk9JZ2VZaVJjZmlyaHlsdVc0Zmdnck9WMEYxYXU1dks1?=
 =?utf-8?B?ckFQajVvanVBWFNLWDRPNWxkNVlZZjNUZW85elRSaWVUZDltcU4rR0xGd1du?=
 =?utf-8?B?RDBHa2VUTG4rZlZDekI3QmN6MEhPVFFaUkkvNEprSGNBN1JjaEZrN25EWGNY?=
 =?utf-8?B?QXNaOHQ0VTF1ZnZYQTRZTUh5TGprYndpMDV0ZFdleG9aVkFNMHY4UnpHSTdK?=
 =?utf-8?B?OHBadXc2ck5sS2Z0MFVVRDROcmVLZEd2WGlDTTVKSS9DcGVXRUpMcmNTcTFh?=
 =?utf-8?B?aEFCM2U1eU81S25pekRSSkF5TnJnQTJOOWNlL2N0QWwzY0NBZ1dsZGtrZ3VI?=
 =?utf-8?B?bVhsOXYvV3lzbmNWbUo3bHdnZWhxNjJpYzNGYmdmaktQWm9CMFFlTFl0ajIr?=
 =?utf-8?B?aUxrVkxxczlRdndvMjFzR1hQU01yZzJ5Uk5CWUs2VmJkWFFDUjFvUDZtSHUy?=
 =?utf-8?B?SDVLRDErU1RQbEdHZ0lKcGdhOUptUGVvMzE3K1JQbENXN05ONHBrUzZjKy9X?=
 =?utf-8?B?a2NmdVcveDFnRCtENnpDcDZ0V3dGSWlNSmVQb29WTDFlMFFqVmxqMklNOWli?=
 =?utf-8?Q?9iU8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d590b9-4c6e-4e90-3c3c-08daaba712aa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 16:38:48.8943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xEO5QXbkORdUL2R9SpO30lzv5iPUZgKKDmtowazNJI1RFwvuixRl6blBiMD3hJdh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2701
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/11/2022 2:46 AM, Ronnie Sahlberg wrote:
> When application has done lseek() to a different offset on a directory fd
> we skipped one entry too many before we start emitting directory entries
> from the cache.
> 
> We need to also make sure that when we are starting to emit directory
> entries from the cache, the ->pos sequence might have holes and skip
> some indices.
> 
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/readdir.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 8e060c00c969..7170614434a1 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,14 +847,19 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
>   	int rc;
>   
>   	list_for_each_entry(dirent, &cde->entries, entry) {
> -		if (ctx->pos >= dirent->pos)
> +		if (ctx->pos > dirent->pos)
>   			continue;
> +		/*
> +		 * There may be holes in the ->pos sequence
> +		 * so always force ctx->pos to the current position.
> +		 */

The comment is a bit vague by referring to "->pos", because
it's the same name in both ctx and dirent.

But I have a second question, does squeezing out the holes
affect a later possible lseek on the dirhandle? I'm having
trouble tracking down where that might happen.

>   		ctx->pos = dirent->pos;
>   		rc = dir_emit(ctx, dirent->name, dirent->namelen,
>   			      dirent->fattr.cf_uniqueid,
>   			      dirent->fattr.cf_dtype);
>   		if (!rc)
>   			return rc;

It's weird that "rc" is an integer, but dir_emit() returns a bool.
It's also confusing that this isn't coded as

		if (!rc)
			return false;

Other than those questions, it looks like a clever fix.

Tom.
> +		ctx->pos++;
>   	}
>   	return true;
>   }
> @@ -1202,10 +1207,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
>   				 ctx->pos, tmp_buf);
>   			cifs_save_resume_key(current_entry, cifsFile);
>   			break;
> -		} else
> -			current_entry =
> -				nxt_dir_entry(current_entry, end_of_smb,
> -					cifsFile->srch_inf.info_level);
> +		}
> +		current_entry =
> +			nxt_dir_entry(current_entry, end_of_smb,
> +				      cifsFile->srch_inf.info_level);
>   	}
>   	kfree(tmp_buf);
>   
