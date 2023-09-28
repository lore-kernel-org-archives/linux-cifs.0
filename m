Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE56E732E3
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Sep 2023 15:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjI1PXw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Sep 2023 11:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjI1PXu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Sep 2023 11:23:50 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F30D98
        for <linux-cifs@vger.kernel.org>; Thu, 28 Sep 2023 08:23:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbxXpWPwmRbGSpZiEFbzOJwTZ95k6HlKb6wElmbdOF4J9DvNO5NUMMy9VKBUDtYtyyOSAWAfsIcVYoE0IcOOh3Sh0Lm9sT8cm3kRpQefNLqOzeuZIVLut1USIfqpakk1MRW0WXes/jiJd3AvgGfNh0ndFpdO83RkWt1Dyrp3WH2b72MYMWgnHbietpO6MiIVrtf+pfOyVicp04BSoghkHRiyQM1SzWbp3hfnZCYtrwR+H3ZE38bXCdjrIQ9j/BGXwr05QXeqyyXdFvpYtV/O1Cg9LOEHaV9oEaRhN4Cuxw6Z+KdTTgbfNWnz1Hs2M7ZsfQ48S3cgQVysTtVqg3byhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X9WhckhbelHDWhRrDTiif6Kmm634eLQ8jXq2ctzeUEM=;
 b=WJrVy6osMtxozrHvd2DU6H8HXMV8t45VcbZAO4m9QjC6NPiJpfLGcrjh0ySUhQ4lNC/pwq9nioQXbrVb+eESJQfN3+C51DJcL3zxzHcS93+ig80Y7c7VlxmIb+H1A+rUMwnj12y4T3RrlPdMUq7GRj7ZrxP8MLH1z+nJ/yjdncFHfaRP2FqcdYQpxL+cPAjukODu9ue9Zv3Tm6N7p84P+Zaqa6rfl9mYVyiBxH3NkCJnbIqjKucDTdy2sawlEjlkytWMWofzVl218umj6nmL1eg/GNBi5NPg2WQJhblFG7pAf4AkcKmXVha5fA9V4VqcY7aDeznkGbtyLAehbg+xFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB7381.prod.exchangelabs.com (2603:10b6:510:100::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6813.35; Thu, 28 Sep 2023 15:23:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485%6]) with mapi id 15.20.6813.027; Thu, 28 Sep 2023
 15:23:43 +0000
Message-ID: <6f702d13-6473-844a-5873-9c70c909ca8b@talpey.com>
Date:   Thu, 28 Sep 2023 11:23:42 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] ksmbd: not allow to open file if delelete on close bit is
 set
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, hyc.lee@gmail.com,
        atteh.mailbox@gmail.com
References: <20230927143009.8882-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230927143009.8882-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0357.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: 06230f0f-4d0b-4167-e498-08dbc036e677
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2VD5BnfwYv/van9ohXKsyG7du55h8Z8mQMZZcF//G72DpTmsHL6x1r6NDMz/PMiqTMjVUkYgC3nhTtr45pCN+y9s1IQnQjDqrJFnZvHInojlgrLhbW0YgZLZVv5Gj5IuHSxw6TwlrNg1ooGGCrdr+XGEMwVMPEUwPsJJNnBC1YBKzBW3l1V1V+F+HOnzaXTihP5AQ3zdIef6Ur24F9AwkTJ1Ct8WQg0zKBQ8n/CeQ9Gvq+f1pxyIcb45eAF2qkXhH+d9g7yoUE+48qkzgPnG1FdHq6zfjIkKh49AGv91RmS2xFb/Es/OYjKNak9+rrgihxH2sThXgwbiS0hR/lBcPcZzJrQVs7DDrW5e4kHVT48J7csL9j3lYhhFm/cui6icQPrVJFG/ATd8qFXh6pFIFX9JbMexEyaOhtMv9YtW8y9pBaDWIGeMd741jMtn5bHlTOWbBYyMupDzxqGNKy53E8UuOpdbW00wt9MYg+tem6qb01WeG1pnBaKF5A+172vYNen8CWymDvA6OAyQIrcP8Dwp1VGj+JQklFg3+oCgVVAKZu8yimkFFIS+i8+l3Itkwp6B3RPWwzAybzJ3EMn9waSOBiE7Suj8xKbZ2oUVaoezenMeld7ORb3TaQqzT6+dST6IsqfOyikchnVSwjpV1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(39830400003)(396003)(376002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(38350700002)(38100700002)(26005)(53546011)(52116002)(6512007)(2616005)(86362001)(31686004)(478600001)(6486002)(83380400001)(6506007)(316002)(66476007)(66946007)(66556008)(41300700001)(4326008)(5660300002)(2906002)(36756003)(31696002)(8936002)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZW5nWTZJNDIxdWxaTUdnOGV5Z3pSeEUvSjFwY21oYmNWNWRndjAvOVFRWXgw?=
 =?utf-8?B?aHpZWTVBZlp4Y0c3d3lDQ1FEUExqK0IzYUl4K3o1cnU3ZGpQMmV1azlDOU9s?=
 =?utf-8?B?dFBhL0YvcXYxdkUyekhpenJRWTdMUmFYd2xSN1MvMUVOeFMvL1JGNGx2Tmp5?=
 =?utf-8?B?T3JSZGRwVTEycXlnVHZqN0pVOEx0eUtsRTZZVzhNUXkzeThsUkFRbms5V0tu?=
 =?utf-8?B?dHdDaWNpN0k1a0M2TDFIZ0dJOG9zRmhLWXZNYWM3c1ZDRnhTSVVjeURkVnE2?=
 =?utf-8?B?K1dQR09ySmJ0c2RIaFlLNUlHK0FnZFRuMkN2NklxbE92MnVHWE5Lc1BQb3NT?=
 =?utf-8?B?NmZoQlNtUzRldGJ5Y3JkeVpoalRxWUdLS2RiYlozRk1IOXZnaHNJMGFmVGdo?=
 =?utf-8?B?MElnY2NFR0VOdEpZenNlK01qVk9xV05lUUUyOHBDLytFSlhqbGdRUnRWTThs?=
 =?utf-8?B?OHU0SE9aMjBwc2VqVWY4ODVEZFZmNGIyeldwa250UWhaTHY1SXgxTExEaU9I?=
 =?utf-8?B?RVk1eU5vdUZ2L0dCNG5KMmRJWHNaQjhxeWZCRElTbnd3ZWdkd2pUWFk2Z3pq?=
 =?utf-8?B?d051dWJJMmZZbWt4RXU4dUZWNzBaZElGS2xHelV3SDd4Rk1wY3BlYW5QR2sv?=
 =?utf-8?B?WnVCR3pDYVg3Nmx6N0pkQjBObE1wQms2RTdOYVZacldrYjJRQjNqMFoyUzhG?=
 =?utf-8?B?bTRWdjZOcVRjaFBRQTM0SS9OcU44Smo2bkZtNmdKQW1uTUU2Vm13bXdCbm9U?=
 =?utf-8?B?MmY0amplWjJoVGQ5a1NYaThGelJITE82QjViOUhmUXlIZlFWdlNlSFFBT1FE?=
 =?utf-8?B?ajJxVUlEaVJxU0g1V1ozdjRVVS9aY25kTHJTa0cySllDRUtMNVNzTEFhV3Fr?=
 =?utf-8?B?Q21SaFh4bUErT2ZoTFhiUFpMOEtyakg3WGVITXRtOUp0cWl6YkU4ZEZVNkRm?=
 =?utf-8?B?aXhKQnkrRHJEMHZ4dGtiRVdYWGUvRTlYUk1FQWVwNVFVTjc3Ym1MVkRSOW5u?=
 =?utf-8?B?TWZvRnV1ZTV5SVdqMWJ5TjZCV3F2SXY0TVNhbUlXbWhMNzR3S0lzdk51Z0Uw?=
 =?utf-8?B?czVvdFRtZjN6SXBYMWMyc3kzM3BOMEtJZURlYUtRcVliMi85RlIraEFaWmpH?=
 =?utf-8?B?VmgrUTFHaGRENTY1OTZkMmRhdnZ4K01OZnk5OWEzNlIwZFhVYWNBUDA5RlVJ?=
 =?utf-8?B?UkdVZVIzbUpiUmRRQWJVL0V4YmZTNzNRTFpYditWb25UWVFiSmxIQ1dPSENm?=
 =?utf-8?B?RngwaVI3NEV1SXBzWDVJRElvcE1BZ2VWQ0tzcmtWWkdKSlAwdENlNEVSZDJs?=
 =?utf-8?B?YThVN2VBaEJpV3FWN3FTWlB6dE4wOWpKczBib0d1RlQwQjdTbzI0d2g5MlFh?=
 =?utf-8?B?dW5zOVc4MUxqL0hWb05JdkdaUDRLNmN5ZjczK1RweG1pZUMvVTd3eGpmY0Yx?=
 =?utf-8?B?MGpLTkdkTmpjK3Ixa05ZdDJKcHc4bkNOWmk5NnFVTWVKcVNoR0ZhNzcySDNG?=
 =?utf-8?B?a1NLZTBsUmwvdUQ4MXBIODJpVUNwS2dIRUcxWU5FbnFqaDBwQUE2dGtmOE52?=
 =?utf-8?B?bXIyaG5uT0ZlMVc2WVhMRy9JdHRaUURnSXFiSkdqSDQ1RmxQSGJGcEwrZi9H?=
 =?utf-8?B?bmFxZ2tibFpIdFgweXE1OU96Y2pWY004S0p4NDdwOWM3bEttZ0RTdHhlWXpr?=
 =?utf-8?B?K1ZWamJmTDFXdlRBZm9nSDBZYWtpamQ5Y2VVbWRrbW5DMzhKQTZhcWUvYzZ6?=
 =?utf-8?B?TmxmN2pIdklxY1JWako0dU1nL1ljNnJtTnkwa3MwMUNtWElBRjVtc0dOY282?=
 =?utf-8?B?SXZZamtyVU5ISFZuUjcxeGJyWDhSd09JelVnanUvMldjaklNdisxcU9qRDk5?=
 =?utf-8?B?dUxPUDN5THZUWlhhZDVRT1J4ZWJNd1lrRGg2L005VXgvTi93bzZaQ2JEWXpO?=
 =?utf-8?B?YlhDSkZWSkhPV0JaTjVsQ3RPSzBIYytoT3JlanoraFNKbHFmYU14NWxEVXFv?=
 =?utf-8?B?V3Fpa3JrR09TRERIa0R2TS9aa25LV1RWc0RSQ01RTFNZa0MvYkNrcGtVYzZl?=
 =?utf-8?B?dFVkU2V5VXlMckxEdTFneGkyQkU4UWFpWHM1NzRFSk95UElQSlpHdmVGS3RH?=
 =?utf-8?Q?1XcXbZh6HPlzKo8N8GRp2PJxD?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06230f0f-4d0b-4167-e498-08dbc036e677
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 15:23:43.1615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKkQO0gkQyAUehqIpXU/RNPtYDd7DjHpDKqAexbuYNtnUjNu+cfQczuH7fxsm1Li
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7381
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/27/2023 10:30 AM, Namjae Jeon wrote:
> Cthon test fail with the following error.
> 
> check for proper open/unlink operation
> nfsjunk files before unlink:
>    -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
> ./nfs2y8Jm9 open; unlink ret = 0
> nfsjunk files after unlink:
>    -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
> data compare ok
> nfsjunk files after close:
>    ls: cannot access './nfs2y8Jm9': No such file or directory
> special tests failed
> 
> Cthon expect to second unlink failure when file is already unlinked.
> ksmbd can not allow to open file if flags of ksmbd inode is set with
> S_DEL_ON_CLS flags.
> 
> Reported-by: Tom Talpey <tom@talpey.com>

I don't remember reporting this.

But more fundamentally, the Connectathon test is an NFS exerciser, and
specific to NFS (and Posix) semantics. Delete-on-last-close is not one
of them.

Won't failing a new open break Windows semantics if it's enforced by
default? Normally Windows checks for FILE_SHARE_DELETE before deciding
this. Maybe other checks as well...

Tom.

> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/server/vfs_cache.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index f41f8d6108ce..f2e2a7cc24a9 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -577,6 +577,11 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
>   		goto err_out;
>   	}
>   
> +	if (fp->f_ci->m_flags & S_DEL_ON_CLS) {
> +		ret = -ENOENT;
> +		goto err_out;
> +	}
> +
>   	ret = __open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
>   	if (ret) {
>   		ksmbd_inode_put(fp->f_ci);
