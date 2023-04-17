Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19EBC77B70
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Apr 2023 15:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjDQPak (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Apr 2023 11:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDQPaj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Apr 2023 11:30:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6119B758
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 08:29:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdXSKXpZpVnC7N+ubX3fDZDlFXsjOEUPFENjAhSzc0X4l75dxOY4iQxwCj4KsW+XonUCtbsMFAZ6d6RhwzCjBd3FJHqNyLUBczxqFsiMSE/CRxgJfeoVlFrUy6MW1VohRvfpyUNpELglH2EHZSPfLH9UxcvGDkfMocwQnjMfEYcJpOfXOboa3OG/Y7swGIOckc9xLblokHYn7xY8HcS6NHy80gSyfB9mqZKxAMPiVgse1QW9HrVInb2NCCAS1LqbvIdtgrWmygkumer//zKivUil97M+hameHBZC+06c+GDltjCG1GA4SIylXdiXefXZJ/5TbN/MLVtqiX+aycE88A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwE3P2tANFnRyuj8enAsN/D3XS1oIWlKObDOK7ETlbM=;
 b=KVGtdMKOlbtiSsUAQ7wHP1doxYz4YcJbDfis1IlGhLTrIBZrSa0M+klXsoK666QJuCQFLUuPQlOxligNrqeOznploNXjhmSsPTSHN2Mpm3MV1wVx6XJgYr/RNez39eQp7aiLYYKbWVZlWh3Q3eCmmJWUszJpR03DuL8bBbbXuzrkht0dLiPKPk3KbNHR4/eIAJWFBem74vjrJL84+oY/R5gbWrypTYu360gkHasWU4Q0YHaQlZ3KCpcX8RUMur3ezRVUFZ1ulkjlVV2ErDP/1tw1B+9c9upDeWFOFUsOXgD2yIp6JN25LaTIwxSk/Zs7g06LLM5WGdQkKtG8vtZ/jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6586.prod.exchangelabs.com (2603:10b6:510:95::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.19; Mon, 17 Apr 2023 15:29:07 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::342f:eeac:983e:3e2f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::342f:eeac:983e:3e2f%5]) with mapi id 15.20.6319.019; Mon, 17 Apr 2023
 15:29:07 +0000
Message-ID: <0e2cf012-e6af-37be-6b7e-5606c99349de@talpey.com>
Date:   Mon, 17 Apr 2023 11:29:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] cifs: avoid dup prefix path in
 dfs_get_automount_devname()
Content-Language: en-US
To:     Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
References: <20230416183828.18174-1-pc@manguebit.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230416183828.18174-1-pc@manguebit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:208:23e::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 69ea7938-fe8f-4bad-dc77-08db3f587bc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CQ5lpdz41EYYRTUy50TB1faLBgWjb/O5sLJ2QDT2gx7DP5z1k37bsfaCxJchetqnRweggYkuqU5fku87DKZBveKXII3Zf/V/ssxct69nyvZD2PkSokO1+REykyWulSyRb9Wc4uCgJQT+vmtWqefoR57dBmfj7o3nbT8/6fL3TReIUtq8hz9ugFB1vvZni8EvFlno/IsHSDk9U8156SuXukLLgGmmYXALNUGRQUi04z6vn8/PjeJP5We+xWcVKdm+jURHulGuQM7mkrG/b4KMiQixpXJ/6qYfj8M1bLgaEk/s5nbTCPTroO/AVt6ByeHPGqdcvk0seYqF6OrCJHOab8Bxs/Tlt7noqhT4uP0QCL6jxAP40AifbCDOSk1adjI+FfQm7rdsPX4wMSLzY5FnSGZAqkvUue9jGcLglcBop2zg9YCMCW4ONWNHwKGrJ2DTqi3jBJXuMcFwPgVI0eNJ/askGPBxstDmrGbPn7FGuAU5kb4KAC7L0XTBV7BL3MJCPrUje1t4hOLc75CESihN0Szk9arzEnM+LzGr24lEydJnM9L2xZnBJOYmy6G/06g95J3asbR7LrhnUsmBzHsIX7miS3Pth0f5xfaxxyIabvKIfqw2BRnWx7Bnm6qCE3bYdJQBA+8qip0+AGgfbWD7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(376002)(39830400003)(396003)(451199021)(5660300002)(8676002)(8936002)(41300700001)(31686004)(316002)(66556008)(66946007)(66476007)(4326008)(2906002)(31696002)(478600001)(86362001)(6486002)(38350700002)(38100700002)(52116002)(6506007)(186003)(53546011)(6512007)(83380400001)(26005)(36756003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDBtRG5GS3lGQnlNOGdHbVdMOWw1OFVNYk5xN1dlQlpscVd6QWJRd003SkJm?=
 =?utf-8?B?by9VR1M5aGt0OWNrZTdUVjJEOVMra3QyWkdQRmQrT2YvOVNPWURoMVBvV3FX?=
 =?utf-8?B?K00zYjZja3pRSG5WVUUvWnR4b1lzRVZseVduMVJKL0JhR1crdHhEa0JXa292?=
 =?utf-8?B?ZXlsUXlCanJ0MGRFaTMvd3ZFckF4alBxQkpQNyt4RTBqNWhWN1F2c0NleGtu?=
 =?utf-8?B?N2NFWTIzZGQ1eWxRS1AvcHNaZDlEb1JEaEQ5ZUtUcjBtMUhkMGQ2bzNpQ0Jh?=
 =?utf-8?B?QXZEQ1hLM0JCUjhXRkZGMjdTYm1KQzBDdzRDRUFyT2NxZUxTb3VzU2NlQ1Zv?=
 =?utf-8?B?dmJMRWVOaUJBUWFUWll4ZHQ5K2huQmFIT2VyTDVUbzhieFcwMWdKdHJWRUlU?=
 =?utf-8?B?dDBJSzE0Vjcra243ZVBkWlpUa2RhSW1FcUFsWndwSG1GWTQzU0NObDc1N3Ix?=
 =?utf-8?B?dXd1MGJacS8zSXVLcDJja0FYM2FySHA2U3Y4MHlSNXFTOEdhT2I2aVBQS21w?=
 =?utf-8?B?czN4YU1DcTVjVHo1RXN2eS84QVJ3OENLcFBCZzVxQktLODBUdFh5TjJUYVFQ?=
 =?utf-8?B?eG5qcnVnTDJpSTRUTTg3U3NKRzB1VFB4TUlJTmZXY2hZYnRBM1ZnSFJCTHZq?=
 =?utf-8?B?TElIeTZRTEl2eGZQNzdsN1BSVWtiUjIycmlzTThKQkRnNFBOZGJIMDJYWVRj?=
 =?utf-8?B?TGdlakU3MG5uL3U0MXdxZ2ZjUUZSc0x1cVBHM2NEVDZSUEJ2TGxER0VVY1du?=
 =?utf-8?B?UkczL3E1UTBaQU5mUEErNzRMbVFOVHhERFh0cEhGSUUxZi9VRTFVVERsUzlt?=
 =?utf-8?B?QXR1K3N0eU9PQ3FRdUJVakZXaU9OcURibi9GNTRXOEMzQVhkeU5aUDZRa1di?=
 =?utf-8?B?T0pURVl3ZmM1VmNOdWRPdnkrVHJXb3pOWHlCYVNXeS8vMVV3RGExckRaN2N6?=
 =?utf-8?B?NkFaYTBUVnJTWnhTcW54UHh2Q1YvVDQrK0RuM2RYMW90M0xURWVTajFoY2th?=
 =?utf-8?B?SHpsV3pDUjc0QjRTbUJneW9CVW5wbWYxaUZyOVg5OVR4NVJGSFJQU2ZNenNv?=
 =?utf-8?B?cWNrcW1ONFJKT1A0YjdXUzhmMlBjMFA5anpmVVU5U0l2VWswSW0reGxMTkZH?=
 =?utf-8?B?K3hXMjFBeEM2dEdDKzV6YXRsRjgzemUrcm5lTHJ1NFAzVmdsT3hnSVJiR3A0?=
 =?utf-8?B?MFZWOG1Jcko5d1RscUNnUHdLMExySEM0SHVBS0J1WXVDN1A1V01VVVp1YlRQ?=
 =?utf-8?B?Z3RFdTU2QWRsemRBRG43U0JScFlYajduM3ZYWlV0dWQrU0gwVnYxNGpwcDhZ?=
 =?utf-8?B?OHZJTzVTZjBGY2FqVWZGRmdnejBtYW5FQ2NsZU9EZTN2ZjdJODlCaUpIN1NB?=
 =?utf-8?B?aG9jcGZSWldZVWo5L213VlFyaE1YWHY2Z1FzOVBvWnJqWFBmOHU5Y3ZwTzNu?=
 =?utf-8?B?U0JuV1Y0RC9vVTNrVFN5ekpYY2t1Z3FiY0ZXRFFJQlBLbnZ2OFlSRXZKc2Zl?=
 =?utf-8?B?Z1dZdlUrdU0wczB3SmQ3MWJhK1FhaWtReElpeFY3WlRFYXl3SmVoSTlYZHBV?=
 =?utf-8?B?NVVUTllwV1BkM0tSbWJQMENubUZOeVJSbFVrTVRDSU9uUHAyVEx1YUFpd25a?=
 =?utf-8?B?V2hVeDE5NTdhUDJKOXMvNjhWeDJKZ2J5eDF3R0puNkhwV3IxdGttQUhpdkxy?=
 =?utf-8?B?VktmenJST1UvbU9PcWYyOUZWSndQcktnNisvTWordDh4UEdubEIwNmttMEpa?=
 =?utf-8?B?MllIK2lSZ1ZBNlMrVnlETFZ1RmJKc043YlV1azJIK1ZvOW9LMzhHS1hPd2Ju?=
 =?utf-8?B?c1ZaWmVpTXR1cUpvOFVqdjljWWhhSlM4SDgyazlQSlMwR3drb1htZlpxMFIx?=
 =?utf-8?B?eHFycUtleEx6U0NVR1JhT2lmL1RlYTg0eXNHb1lWc1pyT2VCeWdENlBJUnZj?=
 =?utf-8?B?aG5sTHh3K2NnNjRCY1plQlFEUTJKR04zR3AzYmR1a0ZQeUIxeUZQMGxheFRi?=
 =?utf-8?B?QkQ1OEtVcTFuSzU2Z2UvKzN3Sk1DeHBtOXNNZXdZTDNYcm95aE8rMDd2K1or?=
 =?utf-8?B?czhuMlgyUzk1Z2JicStFbkN6YnoyeEQ1V2R2b1BTM3A1OEhFdzR1YzN4bk00?=
 =?utf-8?Q?8RlDOBIqedXz3OSVS2NU1kyhJ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ea7938-fe8f-4bad-dc77-08db3f587bc3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 15:29:07.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a9831h719zq85XhbK4sBOq7pFyT5LHWnEyFfGvcLK3KfiOdhv8VsGuxVoditwFzY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6586
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 4/16/2023 2:38 PM, Paulo Alcantara wrote:
> @server->origin_fullpath already contains the tree name + optional
> prefix, so avoid calling __build_path_from_dentry_optional_prefix() as
> it might end up duplicating prefix path from @cifs_sb->prepath into
> final full path.
> 
> Instead, generate DFS full path by simply merging
> @server->origin_fullpath with dentry's path.
> 
> This fixes the following case
> 
> 	mount.cifs //root/dfs/dir /mnt/ -o ...
> 	ls /mnt/link
> 
> where cifs_dfs_do_automount() will call smb3_parse_devname() with
> @devname set to "//root/dfs/dir/link" instead of
> "//root/dfs/dir/dir/link".
> 
> Fixes: 7ad54b98fc1f ("cifs: use origin fullpath for automounts")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
> FYI, updated DFS tests to include the above case and avoid regressions.
> 
>   fs/cifs/cifs_dfs_ref.c |  2 --
>   fs/cifs/dfs.h          | 22 ++++++++++++++++++----
>   2 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index cb40074feb3e..0329a907bdfe 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -171,8 +171,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct path *path)
>   		mnt = ERR_CAST(full_path);
>   		goto out;
>   	}
> -
> -	convert_delimiter(full_path, '/');
>   	cifs_dbg(FYI, "%s: full_path: %s\n", __func__, full_path);
>   
>   	tmp = *cur_ctx;
> diff --git a/fs/cifs/dfs.h b/fs/cifs/dfs.h
> index 13f26e01f7b9..0b8cbf721fff 100644
> --- a/fs/cifs/dfs.h
> +++ b/fs/cifs/dfs.h
> @@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
>   			      cifs_remap(cifs_sb), path, ref, tl);
>   }
>   
> +/* Return DFS full path out of a dentry set for automount */
>   static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
>   {
>   	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
>   	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>   	struct TCP_Server_Info *server = tcon->ses->server;
> +	size_t len;
> +	char *s;
>   
>   	if (unlikely(!server->origin_fullpath))
>   		return ERR_PTR(-EREMOTE);
>   
> -	return __build_path_from_dentry_optional_prefix(dentry, page,
> -							server->origin_fullpath,
> -							strlen(server->origin_fullpath),
> -							true);
> +	s = dentry_path_raw(dentry, page, PATH_MAX);
> +	if (IS_ERR(s))
> +		return s;
> +	/* for root, we want "" */
> +	if (!s[1])
> +		s++;

The above pointer increment is really hard to understand, given the
comment. So, if the result is a single-character path, presumably "/",
advance the pointer so it becomes a null string? It's not obvious from
this code and comment.

> +	len = strlen(server->origin_fullpath);
> +	if (s < (char *)page + len)
> +		return ERR_PTR(-ENAMETOOLONG);
> +
> +	s -= len;

This looks doubly dangerous. What prevents the pointer from moving
backwards to ahead of the buffer? Especially in light of the above
root-only adjustment?

> +	memcpy(s, server->origin_fullpath, len);
> +	convert_delimiter(s, '/');
> +	return s;
>   }
>   
>   static inline void dfs_put_root_smb_sessions(struct list_head *head)

Tom.
