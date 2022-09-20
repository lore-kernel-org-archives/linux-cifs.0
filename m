Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B053CC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 21:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiITVFg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 17:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiITVFY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 17:05:24 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2043.outbound.protection.outlook.com [40.107.101.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB43686F
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 14:05:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ql28l1DGlCA65Z5Z/XnbEKuwognwrrTb4PEVDDioL7a30I1wqYvU2Xl+iR5d9dd3c5amD+pk+MJ1xH7pkrR4DZfr3DpkeDsW8upx3euMn3nPbh//2YV7qVE6Xo+zepwT9nNKF+ugAtE7wleHT6cDXkJcsZSdgrLzuOvsiQg9vMUDPC1kaG8k9UqV/xiTwytHqBwafAJcxZGR7MElJqkGtv+B6RhN1xffZ6y6w/QZx+hLFUyinT8B8+WEwqSkc4PvEozeT+ZWhcpGiAIv4qW93argx/zBblEYllOfZkP5SP0TiH/PTFIT5SlHIPc32hNNEgnP3xjkhwnhenBLN+W4Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmapTEioPbdfpeWEokhq4Cb0NLIGM7osEpMmbN6T7T0=;
 b=EAbgEFoiJKo40FzSDd5OC8a34wuvdFW/APqH2ltjKt7RdM9pTqx9TflF444CiF9avno33dgR3FAUOYW6k8vNoASwaau5pgsejKKjZ8f05jtWxDruk00aB208olyXG4NMJnvtYQQzpmHIlJ5GEke8PvyYBry1FeTrpIqGGIAwvy09DCDOXDDGwYQGjK1z3VcZuuhvoa5yaL0idGWJdTzvIIZhmuG7m1QaMdEh/yJl/mwyWHAhZ+2ANUNNChhqw2vJ4BjCQeBgLmlcaS09jRo7ozU1oZOcnP/XO53C5zeRWJSZ3EqI1kJELfPQznSC258ZaNVBysibYxjXA/pvZ1pwIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 BN6PR01MB3236.prod.exchangelabs.com (2603:10b6:404:d8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.18; Tue, 20 Sep 2022 21:05:19 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 21:05:19 +0000
Message-ID: <1799ec3e-5152-3dc9-1000-2f03396883c6@talpey.com>
Date:   Tue, 20 Sep 2022 17:05:18 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 3/3] ksmbd: fill sids in SMB_FIND_FILE_POSIX_INFO response
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220920132045.5055-1-linkinjeon@kernel.org>
 <20220920132045.5055-3-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220920132045.5055-3-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0008.prod.exchangelabs.com (2603:10b6:208:10c::21)
 To BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|BN6PR01MB3236:EE_
X-MS-Office365-Filtering-Correlation-Id: 48d74c93-2693-4d22-550e-08da9b4bd327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQrc07ne5cy8yjV3D9hpndXrwPWEnWmmvznJ5HMIMbFoqXsyutWKnjM5WMwPq3y6YHf+Ws4gkcnH66XDxdUnAi9mKQWIMhl2QNDhbSV7bSwba5C07WcwiRDJ1cuRm9AVqVtrGl16j/Vs1ENiys88yzSib5P1hMCH3BB7e9uW+oVSMRqR1kH2IyjekCt+0LgRTrKHfmUP00OLijdDfgGWFvUH861lvhs95GfVVbNcJzujhM0SFEQWPT8QoDeC9NgLAgETREyISxBYy2wWA/HyyF+Kl1DtOJGAvy/cs4fSQUokDP7b/fEatbvY9ryS5Kfx38Ay1ZDE7s6YToZmNwFFWE7vgrlnqsVO2d3a9+y0zhcD36rBwA4qOiGO6/5Bg0or9RlOieOPvnCDBTtvk+G1gQNy1O1n+k0YjVotse9bFGNLncA+c/uCpljtWnLq07lznsHNxLAUl/c2Pf7IjekJ+lWPzYSg4SjWUgVZ0lQGbk9xfVedHyAtZqrpUz3Wh+bV98IKghweM5tVzBjwjPTSqydzC2WJ4jLDstFXEO55ziOmG5fXJz9qIs3u/NevQ/qwWnUihYt1fZF27k1VIj0/xhyAaY/UEVtZ5S12ifoC/zp1HqNp5bmxIKyyMUaKvI9OfyoAh4V7enU4Lve+OFMDU0YyQMLnfKr4vQZQP5QGZDa527TkmPaUg9gsJ0BPaSxGEk0xfoXSj0ViIihcmkbGfDJ/Cq+REX9Po6p4XTI0jSi1MDe2DtIib3o2kvd9uEf5DxuFOm7DTFH6h1dnlJZTJEH4uC7fHaluhitz5Xeiidg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39830400003)(346002)(376002)(451199015)(52116002)(2906002)(6506007)(31696002)(86362001)(6512007)(8936002)(53546011)(38100700002)(26005)(36756003)(6486002)(4326008)(66476007)(8676002)(66946007)(66556008)(41300700001)(38350700002)(478600001)(31686004)(2616005)(83380400001)(316002)(186003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjg5ZHFvcFBCZTY0UUVJSWpRSWNpKyt1Yks3N1E4Ti9qZy9hOFM4Mm94OTZ0?=
 =?utf-8?B?ZUFrcmtKZ0V3VDZXcDR3RUdnb0pvYXVpRGt0cjlpWUZLWUV5bVZ1RTR6YnJQ?=
 =?utf-8?B?OGZQeGgyejNhdkJpNXN5alR6alJEU21NNFJSSFRwQmM4OEhjTWRqajFjUUZH?=
 =?utf-8?B?V3NOOS9VN1VLZzhIYTY1T01FdHpDZjVRQTRHWTE5RjNSWjlHaStEaEZrcVpq?=
 =?utf-8?B?MDBnTEV1T3V6TVhnRVlKQ1ZMTDFnZXJtMHhyY3ZwN1lFVmdkN2lsR2NJTTdX?=
 =?utf-8?B?aDBPQnpNblgwcUlyNnEyekNBazF5N1N4K055WUhsdFdEbkRMVG5qS1J6UzVv?=
 =?utf-8?B?NjhhdDJjWURoTDRYZUhtNUNnMTZBTklBUGJ4bGFUa09NZkk2KzBqa3JTWThT?=
 =?utf-8?B?Y25rLzNDNEQzVHpGdUJmVjdzYWorQlpXaDd1UHBhVUxmOTl1N044SWhGRlNN?=
 =?utf-8?B?R0h1dDZXcW15eHBaV284emM3T3podERqRUhvV0hMZ1ZqbnhIaVFWV0VjRHRv?=
 =?utf-8?B?S1MxTzhGQlV6UGtQMWxjMWRwcDh3SllJOXg3R3c5NWVtZVlYd2xQTzNYbnhx?=
 =?utf-8?B?emNGdFpEaTN5ZzlyQnhLdDIyZ1llNGRTZVFaUGpCNjQ1dFkvQWJJUGs1QTVK?=
 =?utf-8?B?bFY2WERVTlVPWkpqL2RtR1hJUUhhMjh5NjNqOERBdWRNTmdLaVk5TjdRdDZk?=
 =?utf-8?B?ZWNITHFKc0o2YWc0RUw5R0ZqdzhEOUd3MnhTWDByeEFwRmtFVmdCb2dGNFI2?=
 =?utf-8?B?Sys0aktnbTFIMVlxVDRpaVpMSXdQTzhBTzdvSitMUEpSa29lci9HSURqcFpr?=
 =?utf-8?B?cFpzVkYwdnpHVk50VVcxOFNGOVJKNCs0OXlwdktQc0l0NmFSNkt0blp3TGVz?=
 =?utf-8?B?RTc4cmc4Ym9YNjdJMFNEcCt2aExEZkVvQnQ0bmp4eUI4T3ZvdmZLeVlUOFhs?=
 =?utf-8?B?VEtMMVhYMmZuVnk3WmhwQitDWHMza2xZcU9LdHg4djFZZEZyVG1RdHhQWUxw?=
 =?utf-8?B?WDVDVGdadTJ1d3JDa1pRNVlhWXY4cFdFMEFJSEVIcUw5MkN0Y2pFOEtmOGhT?=
 =?utf-8?B?N04yZ25nZ0RzZm1hcHlBYVpkM25laEVndjZVYTA3ZGw1bmllMU5zL3RrMVVx?=
 =?utf-8?B?WmJaZGE5VVJTdUFHcUhHMWwxWVd5L09mc1I4M0JObGRSeWNXMFRUY3A1eE5S?=
 =?utf-8?B?NDZWdVNDRmFKMFc2VW1tcjE4OXZEYzQ0Z214akFLb0ZPZEltaUF5WW4wODNY?=
 =?utf-8?B?SFkvK1FsQ0NXeTlDN2gyNDErOVBkSFhYdm5VWUtNOW1UaE1ua0FvN0JaZ0R4?=
 =?utf-8?B?dEV6R2VndjE5UDdZWVRnUHVNUFdQVStMYnJGMGUwZC8xQ0owbHpuZ3NrUEV0?=
 =?utf-8?B?RXVKa1FrU3lsajZ2ZnhIa2x5aTUwd1RFZDEyTmUyV2UvSmhDWHMwRjh5WVAz?=
 =?utf-8?B?cmIzUHdOREx0WmNvUGR3U1V5RERqRXJJZkdFNUF6T2E5ZWdnVHRwSTZXUktV?=
 =?utf-8?B?aFF1REZ4OVQzODc4L2RWRk0xWWJtNlVxZFNlSVNCNDVzTllvZ1dXLzRFR0tk?=
 =?utf-8?B?SitTc1FXRFloNWQwcGpYZlM0c3AzZUdPUHVLQ1Z4Zmt3RHZoWHlaSlRzZCsr?=
 =?utf-8?B?ZGRwMWNBRzJUV29hcXkzVHRVcXpFcjM0RkdZWkZFRnhnYjA5UHVON2pYdk5m?=
 =?utf-8?B?YURENVNPTHlmcFNoT3k0dWRodkZaY2tLaE90QWpTK2RTUENhUkQ2S0lNRGh0?=
 =?utf-8?B?U0FuMVN3UFJURmp0T3BWUUo1WGxnakhrTy9TaCs4eGdTNHdjRDh6czl1UkRv?=
 =?utf-8?B?TS9hSTJ5Y1dPYVphMTJyWVZKSVVKL1owQloreFU4MmRoVlhnWEJ5azVEQml5?=
 =?utf-8?B?bHUwUzkyV2xxUTA1UklNMTl3UWxQRlhOakF4MWNYTlhibVlBQ2syV1RiY2Va?=
 =?utf-8?B?TzlCeHNNRnZtMlByanAxcWRxa2tHK3VyeFA0WWNSaGlzeGdCMHpYNG5lNXRw?=
 =?utf-8?B?RTFPMnYxZjVoLzJOWVNvRlZZVGtaU1BwQ3pVYko1Tk9POHdaRVZHWm5ITkJO?=
 =?utf-8?B?Zk5udnlLOWkvMVNmaEdhMUVYY2c1MTVHbTBIaG1GSTBkSi9xMnRpM1JJOFNv?=
 =?utf-8?Q?FpUVMwwwbnvHwlMlRY15DpCX5?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d74c93-2693-4d22-550e-08da9b4bd327
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 21:05:19.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5aRh94tz2h9lO6Z/xIJvlEJP6FidxU8Skluj2JJoa1HoU/UuQ685cPo5e0it9Et8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3236
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2022 9:20 AM, Namjae Jeon wrote:
> This patch fill missing sids in SMB_FIND_FILE_POSIX_INFO response.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 5c797cc09494..9dd6033bc4de 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -4717,6 +4717,9 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
>   {
>   	struct smb311_posix_qinfo *file_info;
>   	struct inode *inode = file_inode(fp->filp);
> +	struct user_namespace *user_ns = file_mnt_user_ns(fp->filp);
> +	vfsuid_t vfsuid = i_uid_into_vfsuid(user_ns, inode);
> +	vfsgid_t vfsgid = i_gid_into_vfsgid(user_ns, inode);
>   	u64 time;
>   
>   	file_info = (struct smb311_posix_qinfo *)rsp->Buffer;
> @@ -4734,9 +4737,15 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
>   	file_info->HardLinks = cpu_to_le32(inode->i_nlink);
>   	file_info->Mode = cpu_to_le32(inode->i_mode & 0777);
>   	file_info->DeviceId = cpu_to_le32(inode->i_rdev);
> +
> +	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
> +		  SIDUNIX_USER, (struct smb_sid *)&file_info->Sids[0]);
> +	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
> +		  SIDUNIX_GROUP, (struct smb_sid *)&file_info->Sids[16]);
> +
>   	rsp->OutputBufferLength =
> -		cpu_to_le32(sizeof(struct smb311_posix_qinfo));
> -	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo));
> +		cpu_to_le32(sizeof(struct smb311_posix_qinfo) + 32);
> +	inc_rfc1001_len(rsp_org, sizeof(struct smb311_posix_qinfo) + 32);

These 32's, and the one just below, are really sizeof(sidbuffer), right?

Why code it as a raw number?

Tom.

>   	return 0;
>   }
>   
> @@ -4858,7 +4867,7 @@ static int smb2_get_info_file(struct ksmbd_work *work,
>   			rc = -EOPNOTSUPP;
>   		} else {
>   			rc = find_file_posix_info(rsp, fp, work->response_buf);
> -			file_infoclass_size = sizeof(struct smb311_posix_qinfo);
> +			file_infoclass_size = sizeof(struct smb311_posix_qinfo) + 32;
>   		}
>   		break;
>   	default:
