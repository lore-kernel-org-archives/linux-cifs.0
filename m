Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 479FBC32796
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 13:53:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237819AbiHXNxH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Aug 2022 09:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbiHXNwu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Aug 2022 09:52:50 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8699262
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 06:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLHQI/cLDVZELvwfkBh7jri0LyLIcUCcLGqypo42pNh8jPGXwW4koLfzOA5IupKNlKuf2GSNnJD16dRexnE3xNB4hD1dMsu+U32jNEwxnbiA0THszv53lj4TaDq9CxUJo8ROBAjCmJNu/WsPxZqZy2KwUNuIPA2zcHi28qTW2Z4k6A72c5AHVaL37pq6utn1ldiEd4pKT5Z/qsdicJIQ7DM6/KpxJGhNLTuuGl4iOkWa27jq5q5CGUKZJsStvIj9QvVQ/qZBifsMOGiXE1V9oqBeYdNs3RNIL7whfX3doZuIlFk5j6T9KcAfCXWVI/29lCUYxG74Usj3QR7dcZVqDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSuSD7Z/YSYhlL/iCYPXxZIiewv731IAsTc9cMJvrv8=;
 b=J9Skd/NjtortXMH4BauOlL66PPXlTG05oaI3LDqenTqONmBA6sIPsDOVxzaJASHWXeznc7FdjSu0tq4JDe+wHiIAwray7YCoyCEqrixMsVeWuZXXUK75JuVvj0NOD200aRtXkMf4mQKuzMVncYjnXjrPE6xk8+Ph4Idf8gY9lGiQ33AiwpJn467mZt9AM7aSTpy6LGc/lpf0fMW1FV1ode9e3BTHnRYSNybi4IvSIQ/1w28IA/fiZ5sRukStdupqEGSPsq5TiuZo/rYAeS0hul29rEjnGvTQRDLsd7HLfpvMfBj32H9r0aMkw6z2/4xqsMTMWR0NjJ9MsuBrE9Ob2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5096.prod.exchangelabs.com (2603:10b6:a03:1d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Wed, 24 Aug 2022 13:48:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Wed, 24 Aug 2022
 13:48:28 +0000
Message-ID: <2cc221b2-6292-ffe0-5f47-5dfd9dacc95a@talpey.com>
Date:   Wed, 24 Aug 2022 09:48:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH 6/6] cifs: do not cache leased directories for longer than
 30 seconds
Content-Language: en-US
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
 <20220824002756.3659568-7-lsahlber@redhat.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220824002756.3659568-7-lsahlber@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P223CA0001.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::6) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f27d9de7-a568-468f-39e1-08da85d7531f
X-MS-TrafficTypeDiagnostic: BYAPR01MB5096:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtcGmrNdCuW6duMJByXiMjO6FSTSb+r+f58sPP2JC7FWoAH2OG43SGpM2/Bw3xtfGpjhApVYaCjb5+MStVafnGA7+Hfb/twIcMY/LPbimiyZjAO4crm+XtirSafN3pdks4jVSoVuNGyrdSQdSmozG/TIpzYl40yuGL69fG9KxSO89J+5H1Nm0niRWUm9vzpyONHnx/d3iuKolLzgl0h4nzVc790JzgKRLUetdzxibpZYfDexLsDIuSJO4aqdyDR+p71QRu6tX7uIRqSIHGAvlThScwC3FG7biCgUxLhV1TpRaTpad4DE2gSbcuXz4/Nxugxq7yxFYAmoLS0Bl7nbp7jDemzxYFNCgxH9z/gyG+KApQRVlkO8R0sMgl+T2SENXcuf7G58DJ+jifZOx5GlLuHrEa0vIk8G7Ozcwnpz7s20/j7EnV8tyd6pzUyKegPivesXz73LkTlNvyRxFW2AeKVodPM3kXiySM4kG1JxS/Fz00KLMl+ntQtacK4S9qgkSjSQIZcem0/0Nrn6SQGiaXBUQg/n/jfgzuRVUTCANj/6geZTzwsN6bf4OjqLkxmQefqzAvwKfrRjmDJdY1qqWEaipOvoUYINL51IOAiFs4+3FKVzvuZ+s7E2Flw6mr+Qbd0SKoBKNVIAUN0WzQbLI7b0SpEDayfoNcGD7txYbbwV9VeUCPeJaMll5XjqikCTWsvYaGFfXQ6+2P1KY0Rvfy0wsiOY6/IT86dTLk/VWRdi462MbrOXTV27cMMjTQo9425tyZgvmdKtLq+AuDf5oikl2LFrTJ62/fWnBqrApbMeGNeSh33TbtwT5ZsrqebAdvffmtHLIHkSZLlP86HjdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(366004)(39830400003)(346002)(396003)(26005)(6512007)(52116002)(8936002)(6506007)(53546011)(5660300002)(31696002)(86362001)(2906002)(31686004)(6486002)(41300700001)(478600001)(66946007)(38350700002)(38100700002)(36756003)(186003)(2616005)(66476007)(316002)(4326008)(83380400001)(8676002)(66556008)(110136005)(148743002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlJad2NuLzUzNE5kbUdmaDFEZERzRVJRNHloWmVJQkRWMWRUc2VRKzZJZ0Jx?=
 =?utf-8?B?T0FXRE5yQk5rZkdCcmdKZ2FyVU4xMDBCa1h1YkhUaThNVWdxRVF4T0dFWWJx?=
 =?utf-8?B?dWNzN2RnRURycExya0piTEJ3VkQ4Vm5oK2FISjVjeEJuYmxBNUhYSFpaeVJk?=
 =?utf-8?B?cFA5OTBYejMyUGtvUEgvSVQxTDdXZ3Jab0RpcDFSd3lMN3l6Vlc4dzh3Skc5?=
 =?utf-8?B?MHNyQVFsb3VSREdOTkdTZktRdjRyVWlsZC9jZFRnNWhaRjJORlhDRjgxeDJ0?=
 =?utf-8?B?dXlmZW1VaFF0alNsNSt6M3VVbHhudU94M01QaWZTRTlCVEp6bXR1RXN0bzRa?=
 =?utf-8?B?aHUydlFFaUNxWVZNRS81MUp3WEJjd3MyYzJwTUs5MzF3Vno2RkRKdEdmbVZy?=
 =?utf-8?B?b21GQTczZjdmbzNHN1RzMm1pZGNhWkQvL3lWYWdIL1B6SnNiZEdOa3ZZMHhp?=
 =?utf-8?B?cmdYZTBPYkgxempQRjA0SCtJdjFGaU5qYWlyUXdQM2MyS0JKVlBNL3dVczJX?=
 =?utf-8?B?cU9UUTZQVGIyUzhpUWh3eUlFVWo5ZkNyOFp1OUNmQnNPamd5V2k3Ty9RMHpx?=
 =?utf-8?B?bFA5V2tCWFZXUmF0SnBoaEJJZ1duVkEzNmhZNmFvdTZvVzRibDJhVnBXTWR1?=
 =?utf-8?B?ck80Sk5zQzdRQTFDNTA5RGtFblhWTEVSSE9mVTJsZjI1VVVjOWR3WFZHajJj?=
 =?utf-8?B?U0Z1bmIvbWlzQ25sRWVWdTFnbGk1aTd2ZzZJZVlBdkdzZFl4TDRBSEM1UzRE?=
 =?utf-8?B?RFVIbERUdExhOEZSK1AwRnZNVDJESHYxUkJvTDduNmUzT01tektOdHZPdVdm?=
 =?utf-8?B?c1NXbWJTcHpmbVloUFpnNVNDK0w1ajdiOTNtdjRxSjNNZlljMmJkc3FsM2lI?=
 =?utf-8?B?Y0dDeUV5bGNYQjdZdnpxMm02bUNtNjZGeTJyVW9jdkJxa0NKSDI3c0cwVlZB?=
 =?utf-8?B?c1hMRExyUkYvVTZZdC9nYjVoNlAzTmorQ3RtRzBMRXdua1A1TGhGRFA4ci9P?=
 =?utf-8?B?UnBvaVNlMnFhTzcrUStaOWdOZWQydGxTdTdpQ3doeHBZVE5lRk0wUzB5d0Fw?=
 =?utf-8?B?RitaY3padk94NWRkY1IvUnpZN1ZLNzhweHZCUDNPb3NPRWZKWmFNMGduZ1VZ?=
 =?utf-8?B?eXUrMUhCcm5vUGpsMUtaVGVxbFlQUnNpM2Q2a0phVUVOakJuczNPcURxaXBv?=
 =?utf-8?B?TGsvNTVCT2JsUjFtNjdZWHM0RGhnRC9ob3hSNlR1bVI5SUo4cGtlSEN5bGp0?=
 =?utf-8?B?OUJVSjdHMVRSaU9yYi9PQW9xSlRFNjIwbzhEV3U3MjY2YkZUdUg0SFdvMExF?=
 =?utf-8?B?N2xndStlMHZQdTdhRlNwV1o3blhYRUd4cDlKdjlhR29hY2YyUVVIYlhId1BV?=
 =?utf-8?B?dDJrZkZGQlF3YlNZeitnVU1HQ2hPZlQ3eko5emY0U3ZOcFZXRUV1ZXJsR2xm?=
 =?utf-8?B?Sk9CbmJBVXlMejVmU3dyK2pRZE1MRnBMcGxOcE9KelBHQWltRUQ1alptOEMy?=
 =?utf-8?B?MVZRTW5nMTFVSkpJZS84aVRCcUJuOFl1SU9hUDd1aWUxQ2hHbVhuTzFRa3Ni?=
 =?utf-8?B?MXFLd1Vrckx0bW1yTTlUelZzYk9HK1V4TkVJUWFoSHpYcHh1ZEtWY09qdXh5?=
 =?utf-8?B?NG9IWTBjYXJVQmhPbHpGem5OVXB3WkR2RGxrdzNHY0pwWDZBWFJNNERVZ0Qv?=
 =?utf-8?B?eGlKc3lDSUVlaTZhSjVBeDNDcVlIVk5DS2xBRHVpeS9XQ2dBcFl2VkgrdEI4?=
 =?utf-8?B?aUtDYVEvcnhPY2NlZlNPSk9PTU9wTTdVSytiRnVrL2xxK0toeUxJNlpJZmtH?=
 =?utf-8?B?SkYwQ3hxRG9GWkdYR2V4ckxVc3JsUlEvU1VMNWZ2NEhTNzFOQlQ2TzhjUVph?=
 =?utf-8?B?SEFtMmRMekRqK2R5b0tzUEl1R05zT0JzRy9EREJUVE53SWI5cndhemVwQVNN?=
 =?utf-8?B?SHlyMjNxY3FyM2VjYjZrYjNFamYxb0c4dnBwS2hPQWl6QlhLMmt5WEtsUVcr?=
 =?utf-8?B?L2xQMXhxd0drelBkMjExaGkwcW9KdzJhOUo1TmUzeWdLT3k2bEtXN0FpWTNY?=
 =?utf-8?B?aks3K1Vkc1J4TmR1clpvSEwwTERqVHBTd2dTcXVZdGRWUFBiK3FFUWQ5N0NF?=
 =?utf-8?Q?G19mavKK+eZftjbKZkA8U2sMV?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27d9de7-a568-468f-39e1-08da85d7531f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 13:48:28.6770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svJSC8d3Jap5HNXJkT707wIczOOnfM3tOjNkwFGqQx79TioOrs5czf+fEcgj46fK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5096
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/23/2022 8:27 PM, Ronnie Sahlberg wrote:
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>   fs/cifs/cached_dir.c | 32 ++++++++++++++++++++++++++++++--
>   fs/cifs/cached_dir.h |  2 ++
>   2 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
> index f4d7700827b3..1c4a409bcb67 100644
> --- a/fs/cifs/cached_dir.c
> +++ b/fs/cifs/cached_dir.c
> @@ -14,6 +14,7 @@
>   
>   static struct cached_fid *init_cached_dir(const char *path);
>   static void free_cached_dir(struct cached_fid *cfid);
> +static void smb2_cached_lease_timeout(struct work_struct *work);
>   
>   /*
>    * Locking and reference count for cached directory handles:
> @@ -321,6 +322,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	cfid->tcon = tcon;
>   	cfid->time = jiffies;
>   	cfid->is_open = true;
> +	queue_delayed_work(cifsiod_wq, &cfid->lease_timeout, HZ * 30);

Wouldn't it be more efficient to implement a laundromat? There
will be MAX_CACHED_FIDS of these delayed workers, and the
timing does not need to be precise (right?).

Is it worth considering making HZ*30 into a tunable?

Tom.

> +	cfid->has_timeout = true;
>   	cfid->has_lease = true;
>   
>   oshr_free:
> @@ -447,6 +450,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>   		list_add(&cfid->entry, &entry);
>   		cfids->num_entries--;
>   		cfid->is_open = false;
> +		cfid->has_timeout = false;
>   		/* To prevent race with smb2_cached_lease_break() */
>   		kref_get(&cfid->refcount);
>   	}
> @@ -455,6 +459,7 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
>   	list_for_each_entry_safe(cfid, q, &entry, entry) {
>   		cfid->on_list = false;
>   		list_del(&cfid->entry);
> +		cancel_delayed_work_sync(&cfid->lease_timeout);
>   		cancel_work_sync(&cfid->lease_break);
>   		if (cfid->has_lease) {
>   			/*
> @@ -477,12 +482,34 @@ smb2_cached_lease_break(struct work_struct *work)
>   	struct cached_fid *cfid = container_of(work,
>   				struct cached_fid, lease_break);
>   
> +	cancel_delayed_work_sync(&cfid->lease_timeout);
>   	spin_lock(&cfid->cfids->cfid_list_lock);
> +	if (!cfid->has_lease) {
> +		spin_unlock(&cfid->cfids->cfid_list_lock);
> +		return;
> +	}
>   	cfid->has_lease = false;
>   	spin_unlock(&cfid->cfids->cfid_list_lock);
>   	kref_put(&cfid->refcount, smb2_close_cached_fid);
>   }
>   
> +static void
> +smb2_cached_lease_timeout(struct work_struct *work)
> +{
> +	struct cached_fid *cfid = container_of(work,
> +				struct cached_fid, lease_timeout.work);
> +
> +	spin_lock(&cfid->cfids->cfid_list_lock);
> +	if (!cfid->has_timeout || !cfid->on_list) {
> +		spin_unlock(&cfid->cfids->cfid_list_lock);
> +		return;
> +	}
> +	cfid->has_timeout = false;
> +	spin_unlock(&cfid->cfids->cfid_list_lock);
> +
> +	queue_work(cifsiod_wq, &cfid->lease_break);
> +}
> +
>   int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>   {
>   	struct cached_fids *cfids = tcon->cfids;
> @@ -506,9 +533,9 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
>   			cfid->on_list = false;
>   			cfids->num_entries--;
>   
> -			queue_work(cifsiod_wq,
> -				   &cfid->lease_break);
> +			cfid->has_timeout = false;
>   			spin_unlock(&cfids->cfid_list_lock);
> +			queue_work(cifsiod_wq, &cfid->lease_break);
>   			return true;
>   		}
>   	}
> @@ -530,6 +557,7 @@ static struct cached_fid *init_cached_dir(const char *path)
>   	}
>   
>   	INIT_WORK(&cfid->lease_break, smb2_cached_lease_break);
> +	INIT_DELAYED_WORK(&cfid->lease_timeout, smb2_cached_lease_timeout);
>   	INIT_LIST_HEAD(&cfid->entry);
>   	INIT_LIST_HEAD(&cfid->dirents.entries);
>   	mutex_init(&cfid->dirents.de_mutex);
> diff --git a/fs/cifs/cached_dir.h b/fs/cifs/cached_dir.h
> index e536304ca2ce..813cd30f7ca3 100644
> --- a/fs/cifs/cached_dir.h
> +++ b/fs/cifs/cached_dir.h
> @@ -35,6 +35,7 @@ struct cached_fid {
>   	struct cached_fids *cfids;
>   	const char *path;
>   	bool has_lease:1;
> +	bool has_timeout:1;
>   	bool is_open:1;
>   	bool on_list:1;
>   	bool file_all_info_is_valid:1;
> @@ -45,6 +46,7 @@ struct cached_fid {
>   	struct cifs_tcon *tcon;
>   	struct dentry *dentry;
>   	struct work_struct lease_break;
> +	struct delayed_work lease_timeout;
>   	struct smb2_file_all_info file_all_info;
>   	struct cached_dirents dirents;
>   };
