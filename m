Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E1FC46467
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 14:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbjAJO54 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 09:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjAJO5z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 09:57:55 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F3F59338
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 06:57:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgCA3jE1wJGIoPGNRwfkyt+mClUwjajmkzhyQi+Tv384MhOXah18RX0qlvZlInVN+5uPNZv11rK1TvzSQjib+Gukjjs4MnDDCl0c4eghvPFdC6LHZ7Ht7rlIhaXOY1DlJGXwGbCOw94iaxBUSlLhEQTp3cYD2FtHHNMQ/BXqKPch+3A3hOSmldIbMlFdiRlwItuBjlqVROEKQGRatD1aA9R1IPW72XCdcmt5PTWi9xKULBGQyr1xtKLpqc8i3BncTapJ7+b4v1nYpeFQlkCk6QPgHNdEJEpf74HPZnSg/symwgcmhqndhdkx73wisdP2Su1IY98Tw3mZgRA9GdPIeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKda/ma56F7Oxibs3q1KE5JeKVpFxHjuhZXjjQ04+gA=;
 b=iAnCDLYB0Ogbpd6G2FMit5ipxnzrcnvlnNDm2PyXWifpe4T9hySJzHjrWl581QDHNBuFklocqv0LDFkOoIHBauE9dOqm/TS6A+C/Q87ZYlvuUTarml8cLl8BmmXQEadA/p0lKvVXDHjUbSiwezW4/mvARCFnNOpBHOZAr7tvUSDMSDpA7huaF8b3PA2RdIGGtURz/NXd02kEKGpUcChAztPn8ZEvfdugkr7RfAhqNjYDbk51cY3ZEaZL7Xg4UNwe4hDnj/Cq5wH4maJX+jB3DwxwoGvqh2H837KUXGcQVSwew//6p6PQcAqmtbPp3nd7YoXabYVUF7Jes6ECj+xzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA1PR01MB7277.prod.exchangelabs.com (2603:10b6:806:1f0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Tue, 10 Jan 2023 14:57:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 14:57:51 +0000
Message-ID: <f1e10da3-d2b5-98ed-637b-7773d0fb9b0f@talpey.com>
Date:   Tue, 10 Jan 2023 09:57:50 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] cifs: do not query ifaces on smb1 mounts
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
References: <20230109164146.1910-1-pc@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230109164146.1910-1-pc@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0010.prod.exchangelabs.com (2603:10b6:208:71::23)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA1PR01MB7277:EE_
X-MS-Office365-Filtering-Correlation-Id: cc3501c6-5012-47ed-4166-08daf31b0b6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gUYFrMJxSe133qgrOAowm1Q2Iz0whxgWaP/9JNcH9GiuBt0w7Tcj2hGaKRtDwtLYTycOAiKGvKIW7aw9Qg7jxpJ4wXyy07EietOlIBqI0mOPFb+hxcP4RPgxd9sSkeocvvhlah83Ylpl/KsliQ6si/J3NnPndET4ud6UkMcTn/3vq5fTLVzWaLUP91DEKofQz1NQwoVrcLp6+g98oWFVzjWYLpjfNGTASkQaio/xiwtsUnEjO+dPAhk23ISFPOck2zhhKB2MdGH9JAKNT2PO6FXHc+k4C0qr3rmk2hOvNSdn+5k5snNB/cShNmbkXih9R0JUktlmiL2ZqQYnJQO9/VtorP1hVlAe31QsA9WHjfFnfEGQdHriBYeOEhLdPHalISazr21jw/NcfMfutMxjbaDbMqZCGgsuIzZblXct3eK1s3k9AazZHl5C/3UX/0WIGMQddRGUppTrNhrEWgKBxTLRXj/olC04qQth+si0tnDJWihSwJQpYq1ZuGxjKWqxGbinAWfbSEiyJFjCxQ3NB7BkYhP2E3xYvKM3PZvubjwuKr/efYGiAWWquamsaxhvkrq3DCdNIU2noUlZB9yBbfxec+V1aImDNuj529rib/E8M1FDImVE+jKriO+p+J2d0PGJBomw3JA+WrgqedE+qmGEzQM6TnCG4wKpXfCS0S0P0uWXJUHADwyrklI1SBiVoFA9E/36hOoXJXgHwvOygSu+LfW4zjvISuGYflhwHMs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(39830400003)(376002)(451199015)(36756003)(8936002)(186003)(2906002)(41300700001)(5660300002)(52116002)(4326008)(66476007)(8676002)(66556008)(66946007)(316002)(38100700002)(26005)(2616005)(6512007)(38350700002)(31686004)(31696002)(83380400001)(86362001)(478600001)(53546011)(6506007)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y25zbEVDeDVpbjJ0YkF6UnZob1pVRWlSSzFzMnQ0eElJZTJPYzBscVlxcGNY?=
 =?utf-8?B?OWp2UU1YSXhwTjhoODNiSHRNT0o5K3pYNEUvblhxSHlsc0dNQ1JyL013dFRZ?=
 =?utf-8?B?RDJzU2toRU1tN25iOEVWT3lCZUlEZkYxSlZnZXJjbUNkWFlpbUlOSDR1dWxt?=
 =?utf-8?B?TEhuTVZoZ0dsVXIyRkNZeFdBWFY4ekhkVk1QaHRYUGFUbWlDV3ZlMFZSK3pH?=
 =?utf-8?B?TGlXaXZnUW4yNXRhNmJMcXE1VEkzbnVoay9ZeG9JL3JnLzRrYXZ0S2x6ZTdo?=
 =?utf-8?B?Wm5NK0N4ZmI3WG4vTjkvVlpSMTV1MVBiQUtBK3lUYkhnWHlwZHpmQU92Q0pN?=
 =?utf-8?B?UFRTc0pCQ0d6bTFCZ0tRUWpFZUl3bDZiZ1JoTmE2TWQ4RldZdDJlbVQ2QzR2?=
 =?utf-8?B?YUxOVTBDek1veVIzYkd4aXNnMEk4ZTBnU01xS3BMRFlIWjFvaUU1OHFOcWx5?=
 =?utf-8?B?a1pXSUZ1S29JY3NYT2NVdUxkamRQdHZOQms0MEFvVlZPYlRQV0RXQUh5WEtt?=
 =?utf-8?B?bmlTaWtBRlRQZkpHOFNjRUpUVFVkQ1F5UER2YVhEOG44ZmNycXlpUXhZZEpa?=
 =?utf-8?B?VFlNU09XbHlFV2o1RS94S3d1cTBpbjJIc2U1dGVwMDcrZTVJa0NieWVuNHZj?=
 =?utf-8?B?Y0U4eVIyT3VMM1dMb2U1Um10NisrK3Z0Mzkrb1p4YVhNdjAra1VhcGdkMVgv?=
 =?utf-8?B?N2lvNUlENzVpNVpEbmcyRTFBZThJRkY1Nm9XMkQreG5DSWNhUzBZQUpGdGRU?=
 =?utf-8?B?czgwb2lWaVJ4VzNOeVgwdzRBYVRaTHdZK3ByTmhaYm95Z0RGTHc5NlZKRHZX?=
 =?utf-8?B?M1dORmdId2k3bTlrbGpnR2VPZHlRTExQMndnTlpwbXVqcDNqVUdNQ3ZiRDdL?=
 =?utf-8?B?ZlVWbXp6Vnk4UjdJVjJpUXZOSXdkakhHaHBTb3Azcy8zeDVLTWx1Q2dtZFZw?=
 =?utf-8?B?alFBNVE4QnhTYTVzaHBTVHJ4SnAxKzl6VmpwbEd5aDRLVkdJbzNMUGY1bDRS?=
 =?utf-8?B?Z043bVlhQ2dreWdPSkxGRmEyWVVLTkxuYWNoTGI4UTJrMWJnQXE0S0lERzlH?=
 =?utf-8?B?aG12dDdvQ2wrbDEzUFU5M0ZnbnBCSzRMcnRmWjZscmRBdkZZZjgvekp2L2w3?=
 =?utf-8?B?UDZIU1dzcjI2ZXhxeXRBak1vR2VETlpTcnl1WEcrcWRwU2UxNEQwRHhha3dJ?=
 =?utf-8?B?U3FVMXMzVENCUDNsaTBDQk5OYVA4SSt2c0RRYkcyUXJmUDFiMFlDd1NleFJV?=
 =?utf-8?B?aW9iSW1iSVpQcUJ5MFRHamxaeTl1Z1NZUlNqSWxRUHNudW9NK25yZFNXcWlI?=
 =?utf-8?B?NjF3VmVzQmNVU2pIS01neTdkaGdBa1Q3amlpV2IvRnlBU29EOXc2UnA0VCsr?=
 =?utf-8?B?S01FRmY1T3lYUWlBZ1Q0RTlPTWNZcTIzSkorY2xxakpIVWZKOGsweS9waVhl?=
 =?utf-8?B?Z2hoSVRoN1AyTzEvYXVicHB5eHRxWGJPV1hxQjA1L0J1Qjl5TXVnZ3pDZ2ZB?=
 =?utf-8?B?LzFGYmpzamhVdlM5eWNDYzJWaHRhY3JDYnNiTHdyWmNSYzFkclhocFkzSld1?=
 =?utf-8?B?S2REdmJoNlB4azFoeVdYWXNjQitiN2J5SGZrK0Jkd1VBQnRHbHlxbVhFNjNr?=
 =?utf-8?B?L0ozWnRUUkdyQTFnTHpUQUgyZDM0NzRVY3pkNmxRRlpNRVByZit2eDlKME5K?=
 =?utf-8?B?U0lRNFFmQWpjR3ZpMzFkVzRnYVNFVGV5S0ZrejUyY0R6WnFQcWxUVEVhUlQ3?=
 =?utf-8?B?MDZEeHQ4WkhndllwM1hEVE5xYWpxQ0lic1FVelcrczJGckl4YjQxZDFBckNQ?=
 =?utf-8?B?ZWFld0k0dFQ4L3k2ckpySkE3aVc0dFBRVDFTRlVJSkMwWnc1eFpmSUo2ZUlD?=
 =?utf-8?B?ZS85U1ZMYzEzZFhmRmtkZmRsRmhNNm9RY1lxbG5XcjZFVXpnRnhUZ1lpK2Rq?=
 =?utf-8?B?U2VtdklzemVDSiszNHk4MEF0SU5yaFEzV0hZOTZPSnZJSEpUNEJHNitYTDkz?=
 =?utf-8?B?TGp0R0xGRENNSTcxb0RTUCsxVVJxbE5BVERqZjdqS2FCQmFlbDNzM1hLRmlS?=
 =?utf-8?B?YVBoUVJUZFBtODZ6enNSc3ZURFhicVNrYzJpOWVzRkZuRkhSamNXQUwyQXYv?=
 =?utf-8?Q?j2bFH2pt6oAqYQLCYktS9yf0u?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc3501c6-5012-47ed-4166-08daf31b0b6a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 14:57:51.0025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dW3YHKoqebooZH4QKmW2vAbyr61/oZTUmI6UKT64226uNhtVC7Wv1JGgEVKI69Vf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB7277
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/9/2023 11:41 AM, Paulo Alcantara wrote:
> Users have reported the following error on every 600 seconds
> (SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:
> 
> 	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list
> 
> It's supported only by SMB2+, so do not query network interfaces on
> SMB1 mounts.
> 
> Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>   fs/cifs/cifsglob.h |  1 +
>   fs/cifs/connect.c  | 18 ++++++++++++------
>   2 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cfdd5bf701a1..931e9d5b21f4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1240,6 +1240,7 @@ struct cifs_tcon {
>   #ifdef CONFIG_CIFS_DFS_UPCALL
>   	struct list_head ulist; /* cache update list */
>   #endif
> +	bool			iface_query_poll:1;

Why add such a special-case flag, instead of simply checking the
dialect, or (betyter) the server's multichannel capability attribute?

It seems fragile and untestable to set a flag like this, especially
in the tcon, which has nothing to do with supporting the multichannel
fsctl.

Tom.

>   	struct delayed_work	query_interfaces; /* query interfaces workqueue job */
>   };
>   
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index d371259d6808..164beb365bfe 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2366,7 +2366,10 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>   	spin_unlock(&cifs_tcp_ses_lock);
>   
>   	/* cancel polling of interfaces */
> -	cancel_delayed_work_sync(&tcon->query_interfaces);
> +	if (tcon->iface_query_poll) {
> +		tcon->iface_query_poll = false;
> +		cancel_delayed_work_sync(&tcon->query_interfaces);
> +	}
>   
>   	if (tcon->use_witness) {
>   		int rc;
> @@ -2606,11 +2609,14 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
>   	INIT_LIST_HEAD(&tcon->pending_opens);
>   	tcon->status = TID_GOOD;
>   
> -	/* schedule query interfaces poll */
> -	INIT_DELAYED_WORK(&tcon->query_interfaces,
> -			  smb2_query_server_interfaces);
> -	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> -			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +	if (!is_smb1_server(ses->server)) {
> +		/* schedule query interfaces poll */
> +		tcon->iface_query_poll = true;
> +		INIT_DELAYED_WORK(&tcon->query_interfaces,
> +				  smb2_query_server_interfaces);
> +		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> +				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
> +	}
>   
>   	spin_lock(&cifs_tcp_ses_lock);
>   	list_add(&tcon->tcon_list, &ses->tcon_list);
