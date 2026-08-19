Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021082.outbound.protection.outlook.com [40.107.208.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76833ACA5C;
	Wed, 19 Aug 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787162762; cv=fail; b=fs2dslPtVqPlugEUZwNiBFBsWkwRCr7vvuhbWngV7ru2/as/3I/ciqJLwcWtnlXDadICxqrAB1p5vqsW0gfDjQ6KTyFLx7KIf1KtX2B3Q8+TYfRAN1HlKRpyUg7PKei+3vMfY+1aA4bMt5MfbqZpwIF/MBTFgjB/g0KkWe9Xf20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787162762; c=relaxed/simple;
	bh=8IHG+TUeo5huSOmWBmshH5bqSOnU54j4FTg++c5qCKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g/Zw8w+1haMPYl0zXO4HTakdJOsMOkYByClZkeE9btjMjhz5zARY7ZWwApRpG95DZdnkyaaBezwGD7B2KUtymDgQM2o8a5SmKBymaOxErEDIxqXorEMGfalcJAmS60LIpBV85MMCj0jKZpMxkL3K5wfsmvb9xemMCjd8l+m47qU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.208.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWIlDiQz3oOkHKblp35kdnGPBzP1PJbfmf6tMuqaf/GGzNjS/ZOz2BIlPeMazvqfTaTiyeyIxuiPuaE0x7NiEklbZdQxLgDjpTIQrKpPZpciZsgWYezjuao3uuIO6kNM0ESmT3HfbTuvjJ/UZ+uJWzikrGKhCkkwUYCaVycFRQowxgNABCPAGrwtQKkJzJbstTXp4/MrdtzFvxgLtEnnDExUJfaRwz/6sOHedRxdRiLL+bfxbuIwbTji2taeNm1vgR/KNc8WnjLOYF2Cv80tfQjPEjU9zMmRmsX4Q5f15BJlDPZm7MLtpbf9rI7Fphcs0fN8E8piWhdK2jZKZKbArg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IawOAD7bWKRTB/ZcSwboc0jkp17fNeULQo0zYXDr4AQ=;
 b=l2LnfMzxAebVgFjCO0ADE1E/4Mhhzv4MN6YmNESKJZRvrJ+kvVX50/HfT6EDAzRwOyHcpz4m+/dnWaAPJmVI6b+DozY+aRcCUk62zhXmJwYX49ls2MSBybG20X5j6oWsJ0pVnkEtwQG0KQE6NORSvLx8thkxECrwQrzhrv/TF9axYr58p0OOPvyzW6nflu44Cocd893hSCNkLaWVXAB35xfHBSvwscHmfM3GaFxaViHeqqCNoCnlq+DR4aEPuoEwmXAzIDUNobjfnslQVnbeJ4+BKhpKptcU+5QgZ4yDng08sWhH9lNH/ov0qvTriub5CDRH7dIIo0mT8fyTD1ypoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 BL4PR01MB999656.prod.exchangelabs.com (2603:10b6:208:618::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.8; Wed, 19 Aug 2026 18:05:57 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 18:05:57 +0000
Message-ID: <8e3e256d-0e9a-4d8d-92b8-6cc753f434d5@talpey.com>
Date: Wed, 19 Aug 2026 14:05:56 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Replace Steve French as CIFS maintainer
To: Paulo Alcantara <pc@manguebit.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>,
 Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260818140738.314254-1-pc@manguebit.org>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <20260818140738.314254-1-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0926.namprd03.prod.outlook.com
 (2603:10b6:408:107::31) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|BL4PR01MB999656:EE_
X-MS-Office365-Filtering-Correlation-Id: f44b3311-5d02-469b-5c72-08defe1c84d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	10DP/veLiD/Ztik7XuBry3f//iN6gqEKyz3oBM1YLMJD2a+rl2F0yzo9Pzg70lep9mslzaNsr7kaS3f7sTNzF4jdHdMURDWWxDPF9Koly0+FqcLPbmJ3z/fE648keFZnWj0HKTa1uPT5IF4+mRL5bEOGlGEhnTM3qKek+FDAhBsgOurSKQKRKNEWkJwYsi7H/sf+Lm9TDqDvlBEzg4+iaEskeDrko5GYRLHd/tYudRr6Sx7IVuW6XYPXT5Cdl2tZ7/+i+GlaJzBZer5mOFSJ4mgRV6/Tg5ffs3HmRwK1r5Jd1JuRh/szuECJYEzewrcQOsSNa9uomuRpH0SMk5O1vYERRtKpDlXMIdSE34KsBsdOULvDotpQPt+ZF2sByZg9MhE+gBewD2TiBF7LAeUYuZFPMhTS8MIc1ykDn/yFXApsLLcMj0CtmPED99YlvWKlK1yik1fTiheNU74FZS2lwvH9vvizDmBna0dpX0bLLYs3J4QCmSZD9I/oOKHp15RJ2m0kxUvykGXRydW25FgdVqszbyihWreGKsv3ONFtq/kXh62jSZMeKOfRRTPE9UW089XLrRZO5B8sj2Au9z9W7uoFr2erxQ+sy9kbjzuYkfI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2svS2N0VmlUdThsWnQ5Ui85TzNOWUl1dGRGS1Q4U05Oa3BwTys2U2dBZlpu?=
 =?utf-8?B?WldsUmhMK0pISGJld3FxRnYxNnJzQzNCUVJad2h6OGYxeGdxaUJJT0RJRFNT?=
 =?utf-8?B?OGRzdkU5TEFkLzNnc0hYbk5DamF5M3MyMGV6N3dNeDVNVUdpNUIyeloraGZM?=
 =?utf-8?B?OEQwendWcEp6UmkwS083eTA5ZnNKWFFUK1ZTNzViR2M4R1FLTkFQdTZSTDI5?=
 =?utf-8?B?YWYxYW9pSTVDTVQ2RFg3WmpWMDdtUWFaSlhDR2tXL240a0QrZGdlNzFGazMv?=
 =?utf-8?B?akxIZkJaVHVLSjJoczZMTDR2STNqSFZ1dEE5UEk0UE9RN2hYaUo1ZzR3bzlm?=
 =?utf-8?B?dkxBSFJTd1Y3cno5TjJsaFErUzZYWFlJOUdCOFVPOUxPRWNSMWp1WDBhWUVK?=
 =?utf-8?B?NCtuR0pLb0hYTDg2MVFaOGVudmdzOWFTMDNzQTNxQ24vQ1gyMGVqdzF3SlFn?=
 =?utf-8?B?VlFLUndPR01rbmwzZUVTbnA5RTgyRmYxWjd5V0VvWTArT3FsY2xEanNsTlht?=
 =?utf-8?B?dnpIV2I2ajB6b0ZMb0o4Zkh2dVloQ0xuVGVRZExlSHhZT0ZiRkIvM2ZMaE1J?=
 =?utf-8?B?aC9va3NKUjl5Y1VwK1c0c1h6RFNTeFhSdElEOHM5QzFPUUErSnI2cU5SUldr?=
 =?utf-8?B?cjE5bDIxU1AyT1FZSzV2WUpzbGc3QUNzd2ZjSTBjd0JPaUJEMWN6QXJmVmNQ?=
 =?utf-8?B?RFdTNUpuTmNZSDh1d1JHQXJtdlp1ODhwd29PWGpvRjc1OWg5dzVIeTV3YzJT?=
 =?utf-8?B?Vmd3UWNZUVJ0UWg4Nlk3WkMrSGE2dTgrb2xxSXdCbjNwanNHQ2lRNlFvbnF2?=
 =?utf-8?B?d0hrSXJMYnNJVnV4dWtwTHhmd1M3MStVSnBQYjZvZlZZSlZxd1ZYT3pYRldy?=
 =?utf-8?B?a2pzNERnVHMxVFZGbU5CazhoVU5OcjgzYm1ZcFkvOXJCSTRNMnlGR2RDQjIw?=
 =?utf-8?B?MHNydXFGdjFJalBlNytJM3FNYWRQM09UYTh0cWplUk8xelU3Qll5VE5oNy9Q?=
 =?utf-8?B?eFBWcmxaeXUxTFpma3I3dzFvVEFhbFdsY3Qyem95WUlHT2RYbEppQ3FUaUI4?=
 =?utf-8?B?dy9OL1A1NnlyMS9WZFhGUEo0dStpSkdLSzYwYnM4SlNGeG5uV014SmhtelFD?=
 =?utf-8?B?WnlYS1dMOE1hTUVTcWc3MUJkeDlHellkWll3WUJueEJpY2xMRE1sYkVsais5?=
 =?utf-8?B?Q1NQMk5QNUZiVUpkZFphT3J5WTZJOENqVHVyck56RE9xRjZ4UDdzTVlsUmN3?=
 =?utf-8?B?WDRJOUhpUWRFdGgxM3lvTkhlTGtvWnROWkw0RElRVklGZTArd1dPR1dNUVdF?=
 =?utf-8?B?aldyVjlaUytvNUpPZE9INnczT1dqdkduMFRudytBb0dhb2xBQW05TTR1RU1Q?=
 =?utf-8?B?TmFhRVFSRVNwRGtyWkUxdjhOdUJuWlU0NER6bDVzd3dRVDA4K084Mm1GbGJW?=
 =?utf-8?B?YTFKak9EWjRuSEpqVHBkTXpuanRXQ003OHZJSnROczRCYVNTajFKVVZGaExt?=
 =?utf-8?B?ZWVkZFpSSFJWakdndDY5NSt5YTNmVXovK2xRNlFhNzNUQTVWbzc2KzN2UWsx?=
 =?utf-8?B?bHFXTW9aMGJzVW84RFBlZE9Ta0NhL2Jpb1gwOXlPRlZMV1pMazM3TmJncjdE?=
 =?utf-8?B?MjRKdmdhUGRjMWJOMkxCZThQRFRISWk5YUcwVkp4R1E4emg0R1BHcjRENHAx?=
 =?utf-8?B?bDNPNE9GWU8zZlYwNHpCTzJuY0NITG5rbU1xT041YXBWQVM3ZnlzazJRRkZz?=
 =?utf-8?B?WjRTUVYwcmpxNmV3bEkzMVV2bEhLMzV0bHl5WndDeDVNQU9oWFFzMzl0RnRV?=
 =?utf-8?B?QXJneERSMldmYSt1SXdpaXE1T2YyY0x2VHJLeVUxamZnYXJKdzdPU3VZb0p2?=
 =?utf-8?B?Y3lRY0JveExESlA1ditJaDg2c2VPRXpRNUpwdW95cjlVbUM0ZFRFaHg1aGt1?=
 =?utf-8?B?dnMyZjlFbXhabTVuZ1pwNlFGZzVlVDNLNUdwWHRYYlRNNkVZYUNqMWx3YzEr?=
 =?utf-8?B?WVdFRlhLUWtjalVvYzNEdUc2REc5bjgyTjFKUWZRZDZnMHNaS3JYSHdjK2p4?=
 =?utf-8?B?Z0RJa0NKbGJiRnJBWlU0em45WHE5NmNpcUVSUzl4K0UyQ2laaTNZOGtuaGdw?=
 =?utf-8?B?UDdub0FZUTFoeUgycGxSUjBJeUluWXlRZGM2ZXBSTWkxU1BPTnhEUnA0eFhQ?=
 =?utf-8?B?MTZPQ3A0UGpaYnlVSWx5QWtITWY5MGhXajJYRXdQNDRqQVUySXUrdmVDbHB2?=
 =?utf-8?B?T2N5RzkycDh2aVlKUXYzNVVNV1hqejBaSGw2WmtnVkpZMXhPdGsrd2RVN3R6?=
 =?utf-8?Q?6gLltY8kpREZW4f8+5?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44b3311-5d02-469b-5c72-08defe1c84d4
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 18:05:57.5668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5MEkH9obR6tXfHgX5C9qTH2UL33+3cdkD/Wsu+Ou359w2nx6KUax/rPipYM1gWwc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR01MB999656

Thank you Paulo and Namjae for stepping up.

Acked-by: Tom Talpey <tom@talpey.com>

On 8/18/2026 10:07 AM, Paulo Alcantara wrote:
> Unfortunately, due to health reasons, Steve French can no longer
> continue as CIFS maintainer; therefore, I am taking over the role with
> Namjae Jeon as secondary maintainer.
> 
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Steve French <sfrench@samba.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: samba-technical@lists.samba.org
> Cc: linux-cifs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> ---
>   CREDITS     | 5 +++++
>   MAINTAINERS | 7 +++----
>   2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/CREDITS b/CREDITS
> index 91c51c14e993..d3f60da01dad 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1320,6 +1320,11 @@ D: Initial GPL'd Frame Relay driver
>   D: Dynamic PPP devices
>   D: Sundry modularizations (PPP, IPX, ...) and fixes
>   
> +N: Steve French
> +E: sfrench@samba.org
> +E: smfrench@gmail.com
> +D: Author and maintainer of the cifs filesystem for many years.
> +
>   N: Bob Frey
>   E: bobf@advansys.com
>   D: AdvanSys SCSI driver
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8014b9f8253e..55f27757dde5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6458,9 +6458,8 @@ F:	rust/kernel/clk.rs
>   X:	drivers/clk/clkdev.c
>   
>   COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
> -M:	Steve French <sfrench@samba.org>
> -M:	Steve French <smfrench@gmail.com>
> -R:	Paulo Alcantara <pc@manguebit.org> (DFS, global name space)
> +M:	Paulo Alcantara <pc@manguebit.org>
> +M:	Namjae Jeon <linkinjeon@kernel.org>
>   R:	Ronnie Sahlberg <ronniesahlberg@gmail.com> (directory leases, sparse files)
>   R:	Shyam Prasad N <sprasad@microsoft.com> (multichannel)
>   R:	Tom Talpey <tom@talpey.com> (RDMA, smbdirect)
> @@ -6469,7 +6468,7 @@ L:	linux-cifs@vger.kernel.org
>   L:	samba-technical@lists.samba.org (moderated for non-subscribers)
>   S:	Supported
>   W:	https://wiki.samba.org/index.php/LinuxCIFS
> -T:	git https://git.samba.org/sfrench/cifs-2.6.git for-next
> +T:	git https://git.manguebit.org/linux.git cifs-next
>   F:	Documentation/admin-guide/cifs/
>   F:	fs/smb/client/
>   F:	fs/smb/common/

