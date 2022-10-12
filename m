Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436C2C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Oct 2022 00:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiJLAtW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 20:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJLAtV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 20:49:21 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036C6C77E
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 17:49:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGMGb4aDOA3bBZ0964nqlgeq5i0LWYJ2+L+73VBfv88SVr6ckuthJjqn4WxxETGd0u2L1h/+18t+owpEK5XAsi3XCtPSlxYynu3NiV5UFdqb440eVqHGkV3J5M8jgvfDwfdfsVu6KYNq3Tk021rZWX47yv1GRs7dsvK9vugfiw32F/BgfF+lQEfDwjsvhscSozb9+Okj3TACgYt1DrRj65QzqZ+AvtVEKLGmWQLuAcOkbAnR79veF14REG6YV7uLffwudTt0cW37D/KyyccW4ME7jvX+OZAbU4jCfU0JAjC1NxeXLBP2cKAAjlAtHh4ZUolZz5zO6PieJYw3Wz/4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cvWC/c8u8nLKxaiKVWaY881O69OZROgEE9gI3tg0S2M=;
 b=TlS9yEJK26PgSZBqpzoMll0mYOMW85Doh+XVl/QpONSfD5upMbvioxm+KwCnyhA0c0JeRglo74XU77rN76Bb+uzX5bsLP/SnlpbnG9UEueh92E7cT9TSTkHRxHOTgm1171rE1oH2Nf19E2GueVGm8oplqx4+G9GzxyKfdO8ZyUYyuh5bd/8mKynOwpFMYSQl3ug6ruiDNp58c4jEs2u/VgMbWE6FTqkduMu8sLR78RqooOeGmq5fJj5jnaKOAcYKXuDahrAViJjvjzMzwm1cj3V7y/6SXus7GC8QAnpxz9QnRrFwIqqtsE+k/98Zx/Br7e+mYvRiDkX3lr2Na8rvfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR0101MB2862.prod.exchangelabs.com (2603:10b6:301:2f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5709.15; Wed, 12 Oct 2022 00:49:16 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Wed, 12 Oct 2022
 00:49:16 +0000
Message-ID: <bd9a1a65-8565-e5ca-8d48-f7c3430e6e7c@talpey.com>
Date:   Tue, 11 Oct 2022 20:49:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in
 emit_cached_dirents
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20221011220729.1455757-1-lsahlber@redhat.com>
 <20221011220729.1455757-2-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221011220729.1455757-2-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0050.prod.exchangelabs.com (2603:10b6:208:23f::19)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MWHPR0101MB2862:EE_
X-MS-Office365-Filtering-Correlation-Id: 139ca329-2417-4543-cb5c-08daabeb96e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYa1sYIWE+VOocDFQU0Pml4IGnwf1D4G6PXv2Wks+TACB5WoCwbavMTeOX70nutqsDCDx/ZnQ8+udF8DPANrXUw7dURC4LlrFgEMHKBxX8opZNjP3E4v4QgeB/pMLj4LXtZ+rNfwlfFAERbwp/oD8zgt7mN9BE6Kc4w2Ejr2Kfe0xTi7tlZ3FwSZ0J18wjVZiNhFdPcCDuU8AY6BN5BKvQAxThP1Q7n/JtF9IbjpbKn1mO7EUXkCTtgmJUlv3HyAN52648NUwoYoy7IUOpeu+T13glWvaGulEVBacjesb/tWgJHcIsUDF56w30sHjgVfEUNZGczIuNhH0bM2vy9Am0DnR0vdPJf4ggZcIvKu/4hs1DKH2rSEfG8mBDRsNN0l6XRR6jdyts/+5lf4+jlr8lW5sNitSyroxgPpTC4joL2pVVA4cpQzav6jWRhnh8xB4VD/t9Dvx7s031DimBYIrZ34iiNRinvz3N8wMheArVPnCC3XFG51HKcNDClIHsTYkD22CCORwSxM0RUVDOAzJDpGzhWBIqwsWXsvKqWDbuz+IiEpl2yAmjEqixXCTn4wPChIEfcdWZB+k0BO/YLGuvNKwfMbhskmHO5otqVj7rAOnZDhxW0tmpVLqbZhwrCni+0UjWCzPsc9CP0ova+IH+//Ko2HgiIVS7/s9R9AW2J8cauVoXdvkR9xdDWiP5nBUIaCD/RrM/3fTxGKSEfrtbAGANLllEgMpcnHyrzezT1oIzyZXhTvL68gC9JRrnpsGPjhMxp7tMhtOmKsB8yO0g0Xbnj2K8l1Qw80U8nTvgg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(83380400001)(2906002)(31686004)(316002)(4326008)(66476007)(66556008)(66946007)(478600001)(5660300002)(36756003)(8676002)(41300700001)(8936002)(110136005)(6506007)(53546011)(31696002)(6486002)(26005)(86362001)(2616005)(6512007)(186003)(38100700002)(52116002)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXR2Syt1bnh2Wm51NEFSc09RdDAzTFdWUWxTSUxaL09qdHRwamFVL1JCbnlj?=
 =?utf-8?B?Qktic1BZQ0ttWVI4T3RUdGVuMWRLNmhWYXRCak5qQVNhRVdIU1k4eXZacXJ5?=
 =?utf-8?B?OHhZWXV6TkR3QWhmRXEvZUowbVZxNXd0VWY2RENaNnVXMktURHlDejhjNHp6?=
 =?utf-8?B?dUlOalNyYUtZYUFRMTU5a3FYaVdTUjZyV1A5cXZGZ1BET0hjSGE2eC9wclhD?=
 =?utf-8?B?cWZMQlFqYUl5VDNBRVlzNEJLdmRhMVM5Z05FOFVJN0NYZktKVDdCbmhBT052?=
 =?utf-8?B?WU9Pd25aOWhxclBWSm5GWFRvVjdYeXVGUWpZTTBzcjdodzJaSVBwclFIVkRD?=
 =?utf-8?B?bmJrdWhFQm9VTjhRTWRKbkVGenVoZHpNdWc0KzAwSXVkemRJdlZDY2pkSXFG?=
 =?utf-8?B?blJCaGJld3l3K3p0UFBjR3l6eUlSNk5DMFNKYjFoaGR5bnRyVWh2ZFJmR0dw?=
 =?utf-8?B?SGg3UzVTaXZDZ0szcllxQTJub2Z5VzU1VVBLT21aTHFNR1F5Y01ncFlremVx?=
 =?utf-8?B?UjRsWFhOTTVOZjVLQ1NxWjRoNzNybDNxdnZtMzdwY0NndXdoVWhOR0tzRjRR?=
 =?utf-8?B?djZIOVBUeXAydDJzeEltaUhXY2M5UlNEMUMwaVZNMkZvZzMwNStKTVNOM1Nn?=
 =?utf-8?B?TndtWE9vZWhjaWpVbC9zZlNCeVJ3S013SEtJVjdQNXRwU1o5cWZubEsyc2FJ?=
 =?utf-8?B?L3d0SVFwdEJ2d0NUdVo4WGg2bjBNMkMzNWVORDhLKzhXOXJLaGNaTXQwcUtS?=
 =?utf-8?B?Q2VBSy9XaXptbmhzaDVYeERCSG85Vzc3Zk9DeWJianJIdmFEY0xiOWt2SHlp?=
 =?utf-8?B?dUw5QTd1Y1V4MENocHBOSURPOXJ0aFZEQksrNStFTk9pY1d5Z2tHWWlaWXZp?=
 =?utf-8?B?SDNQZjVnZFZOc3lDdnJSRmV0TGNudXg5Nnd5MVZySUNraG14Z3dvcWtPY0tx?=
 =?utf-8?B?MzdVNmg1RHlwUkZGWmZONUx0RXM5bUR0U0J0b0NoZi91blFsdGw4SFNOVlZJ?=
 =?utf-8?B?czRjL1p1Q3FyZ2pOYTF5anJmL09aY2xYK2NhRzBTMDM1TStvMWNyL01OUlFl?=
 =?utf-8?B?emhWODJ0eEhFNFFkTDN5Y1hTUE9Zb3pqMmVVRmpUN29RVDBWbHl2S1ZOY3Rn?=
 =?utf-8?B?QXhEcVJrSEoyTGU2VUthYm9yV2ViMm8wQ1ZXN2hJQVpRYTdyTzFjYWxZV29l?=
 =?utf-8?B?VlM4R2ErdDdnQTQyZDRCNDVvOHlSRi8wUkprMzAzdEx3dXlMamFZZ0VlTFR5?=
 =?utf-8?B?ZldJclNzV1N5ZTRTejd0clIvU28rT09nU29LVWp3VmdCRnRDNTVyNDdmZ21h?=
 =?utf-8?B?bUV0TWlySjNNTStQVlY3bllhN0RSVmNEazViNGt1eHM3R1lrWEErT2tzaSs0?=
 =?utf-8?B?NVNVNHFyRG1rMVVOQ09ZRkRyKzA0ZHZXTjE2bnhsWU5ManBOWXlyWGFnN3gw?=
 =?utf-8?B?RE9uWGJ4aHZhb1ZoejJ5ZTc4S1JIbjV3UHM2ek02TE92aFQrd0diMG9UdHFV?=
 =?utf-8?B?d2tSK3ZGN1RDY3R2ajdadk9UbTdxMGdjdG9KNWxwUkUzQk9NajRGRjdvVXdx?=
 =?utf-8?B?ZURIUWhWN3d1SXJpWHBUc1NUVjJUeXVzNTdiT1NyTUxwemtndUFaZktvOHdS?=
 =?utf-8?B?eUJGeXZOZGdPUEFaTHJPdzRERVNUS1REdTBSTUxvVlZ1Wk12NFVxeHB6c0tE?=
 =?utf-8?B?UFdHdi9EdFFxN2JKdTJMclRheUR5dVI3SG45bTNQRmYvZU9IUTdoNm50T2Ns?=
 =?utf-8?B?NWpVSEt4SUNhUjVEZ2tOYlBGNmphQXpKdDg2c1VMYWw2ejBJSldabVZTbnAr?=
 =?utf-8?B?MVM3Y2gvZ0gxbzYzSHAySjIzR08yZlJSZEk1THdHbVM3WUN1eVdNaW1JMWNs?=
 =?utf-8?B?MXVTajJXUG1RMXZreTNiQXh2MFprNkdKMko3OXM0YnlUK3FSZ0UrTk9UZ1E5?=
 =?utf-8?B?ZFFGK0g5K0w4bklZUGVCeHRLNU1ncW5VV0ZwRkxKY0hlWTk5bnQ2QllCWWVn?=
 =?utf-8?B?UDUyeWJ5THk4bDhjS1E5TWNuTG5KemllYkxQdGJzMCtHOU9YNmdxRHZJSEc3?=
 =?utf-8?B?WWZ4RkQ1SFpLWTZXdGxlQ1Zaa2xRVXNENFU3OHl5cEsxQnV3bERvb3dRdXdw?=
 =?utf-8?Q?Zzo/hTZVtm5PHy4H511lEl6Nz?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 139ca329-2417-4543-cb5c-08daabeb96e3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 00:49:16.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OlTt81WZsnx0BTEijtAsfe7iOC/EEIiw8+eUwIQpd31ku7OR4kMKLlokyiCZodQK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0101MB2862
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/11/2022 6:07 PM, Ronnie Sahlberg wrote:
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
>   fs/cifs/readdir.c | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 8e060c00c969..1bb4624e768b 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -844,17 +844,34 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
>   				struct dir_context *ctx)
>   {
>   	struct cached_dirent *dirent;
> -	int rc;
> +	bool rc;
>   
>   	list_for_each_entry(dirent, &cde->entries, entry) {
> -		if (ctx->pos >= dirent->pos)
> +		/*
> +		 * Skip all early entries prior to the current lseek()
> +		 * position.
> +		 */
> +		if (ctx->pos > dirent->pos)
>   			continue;
> +		/*
> +		 * We recorded the current ->pos value for the dirent
> +		 * when we stored it in the cache.
> +		 * However, this sequence of ->pos values may have holes
> +		 * in it, for example dot-dirs returned from the server
> +		 * are suppressed.
> +		 * Handle this bu forcing ctx->pos to be the same as the
> +		 * ->pos of the current dirent we emit from the cache.
> +		 * This means that when we emit these entries from the cache
> +		 * we now emit them with the same ->pos value as in the
> +		 * initial scan.
> +		 */

It's a little wordy, but it's better, so ok.

>   		ctx->pos = dirent->pos;
>   		rc = dir_emit(ctx, dirent->name, dirent->namelen,
>   			      dirent->fattr.cf_uniqueid,
>   			      dirent->fattr.cf_dtype);
>   		if (!rc)
>   			return rc;

Well, I still think it would be clearer as "return false". And the
name "rc" really seems odd now for a bool. But again, ok I guess.

Either way, I learned a thing or two chasing down dir_emit() and the
overall approach seems good.

> +		ctx->pos++;
>   	}
>   	return true;
>   }
> @@ -1202,10 +1219,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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

This change isn't actually changing anything. Would it be
better to leave out on principle?


>   	}
>   	kfree(tmp_buf);
>  
Overall,

Reviewed-by: Tom Talpey <tom@talpey.com>
