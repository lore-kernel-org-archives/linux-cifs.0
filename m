Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022113.outbound.protection.outlook.com [52.101.43.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47BD34BA3A;
	Tue,  7 Oct 2025 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759796741; cv=fail; b=GUDKPNqOZlD05Q3sIGjjatAdk82wJRro12qY2OufwmH6hbsqFTbWAN/TJO53x6p0CcIk5cKtRh7l7dvv2Pra2RbIwxgpjSQkveVlxev0xCmNG9tZBE4GI07MhxE9F+6q7ODENm0iBtAjNgEAC4VNexFN99fQoCFYJCLFdWAWp10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759796741; c=relaxed/simple;
	bh=QC9Y2M8qsaJjEDrSDjCp3RMGAT5khbmnkEPc80hpxUI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=B5fBQsu6vvbnCSfeDc7eNQvO/jEfwyBNYQhMmvqmpqhmceu/c3Cr1cm0J3s4sSZDn61Z9zf6HC9m4jOFHkHmq048+RNXyyQ+NmlTkvlJ4jQSdUJr3zEPHzQBjs2iZd3xN91mu2ECzfSj/HVcB3wprZGrZZd5BO1vmgOpAGg6WcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.43.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtpeicxwuLROacodTS0OIjg0DGwfGqMw3Amhh4YTbDwEQ/OzwsdpBQeQpceTsn7sz9VWN34W9SEbc4+/zg2HpeTKe3xlfedL9VfOd7wFMpJZ3gmFrTbYidFu/GKCzW7QvIa7K7pmNxdkqw5mbPOSXdd1x3fVyqU3iFAMKrNFXQZcW8mlqWUbjjM8QZiKXzYGRApPpix27yrVlX//bkdZXuHZQaCKhWb7idYOAvykab789oCw6PMo3okV7UufMR6guSFryVtICxcwssWJZmawpUOGwgIqelQbzoP8uNjkIHx2Kca4ygXpp32oYvWxHZJmjRpVGpz4qiYxFLjxzwHsEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r690kwhAmbp8H773i+lWqflbhoNzheWFPfSa/76icoI=;
 b=soiDy/EHOleH+R7IjWmRriaCAQz85CUqKox54aYyA4y0RJLDAsiDWKx/JQvO5nVPHoTQSh8ZE4CPazuMZ3jT0fn4ZMFPM1icKgiKUuAN609xgnGa1zFZmwlHg8VT2ImleCpW2tsswJmVrRVlvxz9Kl1ybMwNFcoOIkVSlMDMCYU69n5ppQJU8PjNDDFLweaiK7F9hlLkKxU27VLR67uRt2rNDKJy8tFo9XDRZMJKMUWlMLOs3nuEPUrpMTT7WQYyMorr+39NIzHbMi9CH79ehkjLcQlwG5CUmeDEf59QzZAYlnxhZGqLHHm4mJ1+UnAIYyWZ/mLO7dUMM2C+oxGNXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CY3PR01MB9193.prod.exchangelabs.com (2603:10b6:930:109::5) by
 CO6PR01MB7516.prod.exchangelabs.com (2603:10b6:303:147::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.20; Tue, 7 Oct 2025 00:25:36 +0000
Received: from CY3PR01MB9193.prod.exchangelabs.com
 ([fe80::5818:cc62:988f:8908]) by CY3PR01MB9193.prod.exchangelabs.com
 ([fe80::5818:cc62:988f:8908%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 00:25:36 +0000
Message-ID: <3886ed32-f67c-40ab-99d9-4445655a887a@talpey.com>
Date: Mon, 6 Oct 2025 20:25:34 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cifs: Fix copy_to_iter return value check
To: Fushuai Wang <wangfushuai@baidu.com>, sfrench@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org
References: <20251005141925.35461-1-wangfushuai@baidu.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <20251005141925.35461-1-wangfushuai@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:256::23) To CY3PR01MB9193.prod.exchangelabs.com
 (2603:10b6:930:109::5)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY3PR01MB9193:EE_|CO6PR01MB7516:EE_
X-MS-Office365-Filtering-Correlation-Id: 16bbb1db-4eec-4321-dd01-08de053808db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rm01N2phZWxvRVhObER4anBGeFh5djBaRE9GUytJNEpuZ1FaVDlpZG1hbTc4?=
 =?utf-8?B?SVBqOWc3blBoR092eWFGbitmNnJGUTVkN05wUm5zeXJFOTlISzZmZm50MEJo?=
 =?utf-8?B?bWVKayt3bkRIRTZXZzJoT1krSmZBVEs4N09jRGhxbmYxamVZN1N3RUt1cmJ0?=
 =?utf-8?B?S0ZnVDdTNVdmOHZ0R2NhQkRlM1ljeGRteCt0b24yenBwdEFYYkUxMU91RjIz?=
 =?utf-8?B?aEhUQWd0Qnpib21lWUhiT3NEVG1KdEwvTHdLNGNZVi9kTWg4Z25MWVA5UE15?=
 =?utf-8?B?ems0QjBHMHg5cGx3eFNxbUdQNnhhelN1WCs3WklXOFRLSGthaFZHUnFXVXlr?=
 =?utf-8?B?d2VDbEhEZVFsc2U3eGxWOVdaaEIzbEg3bU5rWmg2U2NMbi9TK21GZDBNbmFV?=
 =?utf-8?B?MW83dG0rY05XcHB6YzhkdVA0QWplMmxhMnJvK0F6OVcyaEpYZXAxb3F0MFFG?=
 =?utf-8?B?Qy9wU0hpUHpsUTAvMFRsTDROQnRiNXRkWHdQa2dmK3hXN2QrVCtzTTNHYmlH?=
 =?utf-8?B?bDBHaHg3QjUzQlloZXM1K2FabGQ3RTU0UGZrZ3Y3SlBidTlUbVFZc1NDR3NS?=
 =?utf-8?B?bmhOY25heHpaK3VCKzdQc1JxWUZIRmhTcmhmM09lelNZWWNDaUhMdGxjMXM1?=
 =?utf-8?B?MVp1b3hjQ2p2UGdJZkUvZVVxVWRPQ3ZOODEzdDkrNzJRak9LclpuWS9yZ3Jp?=
 =?utf-8?B?Q2V5YzFGRGtyR0Q5anJVSzlwS0NHRitkSFBZellHZzcyV00yTXlkN3ovbm5S?=
 =?utf-8?B?NGNINFVsVCtScTlFRG5acTNPMXNxdmJtWUJ1S2pJaGR6TWhsZ1RiR2xXbmI1?=
 =?utf-8?B?U2dIQmZma3k2d2R3OTFLbE1udG5yWXNiQkxldWd6WHRtblhiaDdqaEpmeGY1?=
 =?utf-8?B?UnZvNjVSVmx1YlFMOE02ODVxb2tmbVBwcFo4ekNQZXRyNzgxbzVHb2o0Tnpq?=
 =?utf-8?B?R1pHUHZaYmxZY1NjTDBmREx4bERCZEszSTJydVViRmM4My9CVVJkM2N0ejRz?=
 =?utf-8?B?WmJmdkRTcjlkNWZXOHVBcUtKNkNaZ21RZUdObzUyczAzRmV5RTJHdGJGOVo5?=
 =?utf-8?B?TU0vbG5oWFNLS3NLWUdnT1ZFdnlKbWhyTU1BRjNTRDRsMXo2WGtPSEZwZlY1?=
 =?utf-8?B?dk5vdFJ1T2MxK0tmRzZJWXdMNCswQUY5OHBkUUhIZWNMdDM3aUQxK3FtaG9i?=
 =?utf-8?B?MDZ1Zml1cWVaYVFHMmd1WkNsdzJTeW1zZlVhaktRSHFjODAzK0RtYWxQcjY0?=
 =?utf-8?B?TlF0Uk9CUGJ2RWlWRmoyMjZzT0tBSFYyRmkrdTdoMWRuSHhGUzVFM0x0TVc1?=
 =?utf-8?B?WVhRMWFSQ0VaVEY0aVg3YktTY1hiY1FWbVE5S0swVkVJamxCcnZVUFhWT2Vy?=
 =?utf-8?B?RUJqN2xVei9adXBxWTJobnhJbi8zZmYvdWc1M0hFK2p3aVVpRUFsb0Z4Y2NS?=
 =?utf-8?B?VURTSDBReFJvQ2RFSkhVc2p5UjU2MUFodGpTQnBvS1ZDUWNlWW9xaHlVYTZp?=
 =?utf-8?B?NXMzbFg0ZnNFT1ltME55QktmWS9zSWRSN1FTYU0wckx0QzVESCtlM3llU216?=
 =?utf-8?B?RFZuc0xsOG9hbkdrSUhYZzBxZ1d4TGMxemFoRHpWUGE1c3RLaGkvLytaRG54?=
 =?utf-8?B?VnNKelFSZ2R1ZG82cWJhWk9VV2ZCT1h6M1dsVkV2eTdMdW5HK3hnSDgxa2Ur?=
 =?utf-8?B?NUdPUlVGM1Y1TWp5UVMrV0VadWpsMUFmV1dITVkyOWMreGR2b0IwYmlRV3RY?=
 =?utf-8?B?Mmd1THhjUVF3elM5U0xObHl6QUE0L1NHZEZSYy9lQ2d1TjF1VHhUbHhGdGhF?=
 =?utf-8?B?enZCMkJDeURWeXJPMUs3Q1JUOXc5TXpsRE1vMXFQeW5ncDFLb1NtQWRyMWQ5?=
 =?utf-8?B?YXFBaUZXY0RLZTYzNXNNU2lRRjZRKy9GeWdYOUhtcEltSlZNMkRmL2w5S3pI?=
 =?utf-8?Q?aQapJj9lNn3CH0CIbhku/P08Qqrz3gHB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY3PR01MB9193.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejMyY3haYVkxSDJYTHNGSUlOY1BwMjJGVHBVVnBQcTRBdkEyazNPdXNndXBn?=
 =?utf-8?B?NHcvQ1FqWHlZK3dNS3Y1Q1htK3BMS2MxNkh5N3pDOWNwNFkrY2ovcVA2Z0tt?=
 =?utf-8?B?dlA4RFVycFNQU2dheXZRVVp4RFJNSlFOY2Y1NjZHTjQ3WmFXZWRBOFh5dHho?=
 =?utf-8?B?WkExRzFjZnRaQ2NDVEhvUDRvTUtkaUlGUmRqcXZoY0M3cE8ybXhBUU1ocHN5?=
 =?utf-8?B?TS9SLzIwckUrOEdtMDFQVUJvZDdnZFFnK3RvQktUNUdEaXh3SDVTRE9DT2lJ?=
 =?utf-8?B?eDR6Nnl1MjRyOWZzZlRKdmpkV2hkclZFN1p3T2Fmc2lOeU5wTHVSaUg4Q3hI?=
 =?utf-8?B?Wmc5TWZITTBtOXNQVlJnUkVpVFhIT3hBaEV6dmg5eS95Qm1DWmo1YmtyOVBs?=
 =?utf-8?B?am9PalZtTkNqNzI0eHRHY0xrV1RVc0Q1eXZwTUFrN1EwRXR1ZTdEUVM0MzVT?=
 =?utf-8?B?djl4OHJZdXRjeGJ4a1h3UWhUeDNNM2o1eHlsZUJwU1F2N3NzMVBBcTFpbW5m?=
 =?utf-8?B?M1l5MThSUGlybjhZS1h3WUxvcWgzWXYyYWNZWkg1MW5ReFBUTzRjZEV5S2dD?=
 =?utf-8?B?dW0xbENCL3FwaU9TUEdxb01tSGV1WVZ6azBpVHdQOG1KMHBBNE1SVWlGMEh5?=
 =?utf-8?B?eUZJVWlkcStLdGYvU0xMQitEeUhLTURaSFRoR3JVcHlQWmtDUTFJYUFLckw0?=
 =?utf-8?B?ZWhpc0hEQTFVTFhnajVUdjFNT3oySjVZaWZIc3NZMTltUGxRekJFQW5ZZ2F0?=
 =?utf-8?B?V1NGTlNFUFpOMTdhc2x4aW5nRkFWTDI3MG5CdTBjbURUQ3JDa2drZTNwUU55?=
 =?utf-8?B?TXZ2bUdmS1RIWTdHRGpvQmVsUDAwa3Z5ejUrNHVlZDNHNDRCRTJURS9uZTNY?=
 =?utf-8?B?SHRYWm1yTTJvRU1WVGNJOFFZTVgvckZiaEJoZjQvb0QxeWpOb0MvWCtKcXhi?=
 =?utf-8?B?cXQ3L2JhWGR3QnBBWkhNSU05Vkd3czBRR0xGUTBvM2FkdEVyaDJiTUpva29E?=
 =?utf-8?B?aVFaQjV6Uy9sek9ROVhMVENkR29wUjhGWHc3Y05xOTFsQnd0SUdtOTJ6cTh0?=
 =?utf-8?B?cmhsdWlZUUdWVksyYUdxU0JTVjF5YytrRW1IM3B4SkNKVWU4cW9OTmdRdjJH?=
 =?utf-8?B?aDlTUWJRNm9KdjBxVTNkTHltQUFLLzRnVmNhQ2tCdWZzdEJsejdxQm1pV2tB?=
 =?utf-8?B?NnVNTmFYdEpwdGVST2g4YS9pdlVtc2lGT0JCQmdGZDkxZlBNSllQcklCZjdT?=
 =?utf-8?B?OWR0Nncyc2RkTjJRcjFycFp1anNuR1YvaFJsZkRsckZObkNYeFNlalZwN2Zt?=
 =?utf-8?B?ajVubURxL014VENqdHBsNnJzY1VncVpPZTRQNDg5b1lRb1p5WmtPbHpsU0V5?=
 =?utf-8?B?YmN4bWU4QWMzSU1QMkdneXhwSDQvK0xSY25OVHI4ZjBPTWtmU2kvekxObFNk?=
 =?utf-8?B?eHlTMDRFSFE2bWt1eUFFRVNTRUhSWFZPd0FPdnNISmVnblQ3MmVlUWpRRlBT?=
 =?utf-8?B?bm9XUEN5NWVkSzFMWHBRbmNtSGkyeHphYzdwMEt4NUJyaXV5RTlwMlZXZmk0?=
 =?utf-8?B?ZFo0WXdmQUlYd25JOEhBRjVzbWZUMEwvVEVLWVFBMVptTEdaQkR1ZThPVVpk?=
 =?utf-8?B?SEFsY05yOVBnRDFoL0locTFsNjRUUUloN3UyTjJVUzc3a3JuV3NVSmhYQ293?=
 =?utf-8?B?WG0xYmszbjQ4OVBJcHJ1MnAxUGdmY0NXdnZvWDlVOWs4NWgrQThSSTN4dHJJ?=
 =?utf-8?B?Q3VmZmdJcmxabDJrblFiRzFLaWs5TldXREdFNEVwT0VjTWJMR3U5WnpGYzFQ?=
 =?utf-8?B?a0xyTTRFd05SVDlZd0hjdGhzL08yLzF1TmNoRms0ak1QZi9xWW9MNWpBL0dW?=
 =?utf-8?B?RUhhVXNsQm1VQ1ZORlQ2VGQ5aWsyS2RiME5tdjM0b096S2pGUS9TU0NFNXl2?=
 =?utf-8?B?NlErckJYUnJIV1puakNWcTRuK3ZsN1Raa1lmMXhLSjRFZnpPTTJZMkZCeHdw?=
 =?utf-8?B?TmJRaGhVSHhldkY5ZUNEZFBOUk1kQStJS0wxck9YRkFKM1pWamZsMEJqUHIw?=
 =?utf-8?B?MW9lVG40THZCNkl4V0hURmF5cVY4YUgycWE4LzArME9iNmsxZTRRb1A5TGJx?=
 =?utf-8?Q?udFM6fND3D3zNGmslweadLHGC?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bbb1db-4eec-4321-dd01-08de053808db
X-MS-Exchange-CrossTenant-AuthSource: CY3PR01MB9193.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 00:25:35.9862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vE9rzcWdn/cZ76qPoEQukOQoNA28ItwB5Gr+FqUVhLEWHH8w3Kfx0BzbplLiwznn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR01MB7516

On 10/5/2025 10:19 AM, Fushuai Wang wrote:
> The return value of copy_to_iter() function will never be negative,
> it is the number of bytes copied, or zero if nothing was copied.
> Update the check to treat !length as an error, and return -1 in
> that case.
> 
> Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
> ---
>   fs/smb/client/smb2ops.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 058050f744c0..577ac2e11e77 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4764,8 +4764,8 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
>   		/* read response payload is in buf */
>   		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
>   		length = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
> -		if (length < 0)
> -			return length;
> +		if (!length)
> +			return -1;
>   		rdata->got_bytes = data_len;

I think this has exposed several issues, and one's still there.

1) copy_to_iter() returns a size_t, which is the fundamental reason
this can never be negative. The code is assigning the size_t to
an integer ("length"), which is why static checkers never found it.
You should correct this.

2) If the "length" is positive, it's completely ignored and the
previously-computed "data_len" is substituted. This pre-existing
mistake could easily cause a too-large read data count to be
returned, incorrectly.

3) I detest using integers as booleans. Please spell out a test
against zero. But I guess I wouldn't nak for that alone.

Tom.

>   	} else {
>   		/* read response payload cannot be in both buf and pages */

