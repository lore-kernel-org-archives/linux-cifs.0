Received: from SJ2PR03CU002.outbound.protection.outlook.com (mail-westusazon11023123.outbound.protection.outlook.com [52.101.44.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F24920013C;
	Wed,  8 Jan 2025 16:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.44.123
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736354341; cv=fail; b=BxEUC0SBViGrTgs7eFl0vKrhm1rtK+j/jgsjn91fSK9HMdfjLNMIlcnSqCGzO2ZuFyad7ZAh3zpU2yt/k/4/iMWwbwDWCNZbgsKemVRil62dYsZiB8wnI+pVMEDYTHnEbSO9B/pIGgRyAr1gdWBewigs3RLtB4/QolIzZomild0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736354341; c=relaxed/simple;
	bh=ex0DuI5TUU6VJIZZLQDoKUdKeWy3TkFhahqFJhmKu5M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p1MJtnBDym0rOexG/sr+30cTjSglT0QriRYYiWhvGugORbQVfI7oG251ZMsi8Lc6qU1895Cm6MJRE2a7JNIUltlT4zBN60CFcNNF2wdCH25I+9lky9T2f/80oAg71UUCvmqaWM1Z3X+jJV2LIvVdccISDxoH19TVtwLf72w79DM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.44.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Unko7J4c5CYq69m91Q0NbYrhiSOVjsYCTZ6KKif3Vqb72KmX3e8hSyZpYVHxtPm6oA+ZeOSu2YgZyYJhWh4rTdZkMfM0KbmCBqLDcxMF7V0UMPz1QGyQjNnJubMlCxV4AWUGuNb/6YmiNIt/YHoRtgTeOhCTGH4mEPue9Jc4PgMqHVhojkKTebRBm+By62Z1ak09zxl6bswF9xr05oJhyeQQyvk7oRIOPpw8tD8d6tXbYJF9Xp4oyLy83V2V5i73j552Gg7aU+0hs6wiSwLMJ2xTq37Avbc9XDDrRwsyGeQ5qwSLVxZx6O/cjE18jMrDIy3FYVM95bXl0rr7NiE2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JjTnsXQaCd0YGT1dUaaaYw30sM1Cxs1Sel0BtegLyk=;
 b=NQ72CLf4/IESu7YIenVc/ZLbuVf6PAV8sC2UaMKqjijTqaT4EPwhpo4uDWM9+by9n3h/sk5wdhek1GPbiI+3P+Ixru4podk46D1U1xg6pwPu5KcN7KOVIPFx9hQhCBJjmbA7TnpMi5ZwlJnC9oyKCuAyKwNWJOxBgZZf4ll209g36VmfphqFVhQMV11Daq/MZuslREtBFUMXFwGtXg4TyliHwfcfOlviQNuTilTujiMMsYsYz2qDqz9ZVwiM4My4U3nQK0jIKrn3MZF9rfBHwF0JudfmVg80oR7ZFZ3WzkxKUZoF7vHbmUTwwibN5SXhUafjgZznVsNLMkNwU002vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 MN0PR01MB7874.prod.exchangelabs.com (2603:10b6:208:381::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.8; Wed, 8 Jan 2025 16:38:55 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8335.003; Wed, 8 Jan 2025
 16:38:55 +0000
Message-ID: <72c54534-f4dc-4b81-bb0e-239a1ce6e1d4@talpey.com>
Date: Wed, 8 Jan 2025 11:38:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer
 size
To: He X <xw897002528@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>
References: <20250106033956.27445-1-xw897002528@gmail.com>
 <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
 <CAPG2z08PyX3VZ4mxzEr_FtmiafGi=cNGpOzG7rjWxihjxeyTjQ@mail.gmail.com>
 <b183d30e-f51c-426f-978b-ef178a88bef6@talpey.com>
 <CAPG2z08fdWGMLovAo663nTant4S8oyPoWL5Vo7Rdc8JzaTRsMw@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAPG2z08fdWGMLovAo663nTant4S8oyPoWL5Vo7Rdc8JzaTRsMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:52f::31) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|MN0PR01MB7874:EE_
X-MS-Office365-Filtering-Correlation-Id: 776e20ed-83c2-48bd-8fc3-08dd3002f101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnBNZVcwSXd2RXUzVEJ0NGh2aFpVN3pvaFhZRzJhUkxNcVpYd2tCb3BrcU53?=
 =?utf-8?B?Mjhwem9KYlFoM1NpWU9qOEhydXp0ZVI1ekZHWjFJWFFKa3dyU0JXOFlhb0Vn?=
 =?utf-8?B?TlZQNnMvVFVZZXk4aEhUUDVKQnF4Tjh3K0MxWndCNjdGSGRMZEdwL1psakRX?=
 =?utf-8?B?THVjKzZoMTIxTTZBTy9mSnVQcWJWWE1jeE5CSGZWekZ5bGRQa0RjWVhnNnZi?=
 =?utf-8?B?UDBKQUlTQ3hkdHlLNGN1WVo5ZUFHaThWVkh2UXlDZ1F5UVlCeE5HQi9FT05I?=
 =?utf-8?B?ZVdsbVp4SmtXUWhnM08wcU9uMFM0RkwzYTB0T2hrM3hTZHRzVWJNbWUxSEhB?=
 =?utf-8?B?VUtzaEFCNWRwY2tIb1RpRGtIQVU4Ty9WSUxQTWVNZm1WQ2dYYjhTbHJQUnhx?=
 =?utf-8?B?WmtmV3NKdUJjSDdLV2ZLSzZGMVNZd3M0RXZYSi91SUFuVG5HUFluVGRYNUZN?=
 =?utf-8?B?d0svNjR1em9uT3BJTHh0dlAwb0pyd1g0RGJYd0J5WW9xZ24rRElQSFFFelh2?=
 =?utf-8?B?eWt4dGhyN0NXSXltUFV0OVVYLzRHclBtbTJKZlZJRHB3RXZPdHhpZUJlRldn?=
 =?utf-8?B?eHpHakVDa2xjL1RpTnFodnR6Q0E4QW56dzBSSXltZXU4YW1PMjF2VUh6VENk?=
 =?utf-8?B?dVM1MmI3MmwzcUkxZjZjeXRkYUE3dHcvNW5sUVhIaFRYNWFXeGhObkxiUkpk?=
 =?utf-8?B?aUttL0Y5Yk5QWGU5ZnZ6UVo1aGFNdnpPNnJDRXNBSlpQZDlBa3BtWXAwNGRo?=
 =?utf-8?B?YU1ES1lzaGJrMngxc2Q5REw2RExRcXQ5ZWRDNnRGamdLV1kxTVhqd2FmOHVS?=
 =?utf-8?B?cWNlakxHMFNFaDJ5aTdwOEJXVllNVS9qeXN6US9kczM0RzBZTUZyRWRKV0Jh?=
 =?utf-8?B?dTFZTFFLNklMakMzVDUxdmlzbEtxenNHQzNpekQraGRYZHZzczc0a2hMKzVi?=
 =?utf-8?B?MjVFZ3ZiSDNUc1JxQUZlbE9Nc3RpODNWOUM3R3N2TnZIRCtVWG90Q1Z4MDd6?=
 =?utf-8?B?TnNKd3ZEWXBtdllueHEzMVRyZ1NTMGhyMWs4dEM1OExBdUNvVCt4ZG1hOWdl?=
 =?utf-8?B?b3drYnRDSTRYaDBBclVDempZNmUyNWZjL2FuM0pYeXBZRkpkc1M2dXNZaEM4?=
 =?utf-8?B?QnpRZlBYODI3RDBTRC9OeUF3R3pzdWhiWEN1M1o2Yms5b1pHNTlLSGx5MFhI?=
 =?utf-8?B?MlM2RWZYUTlaT0tFRkM3eVhaUUgrRFp2dEcxbEFwVVc3YjhSL2pSVjFzME9N?=
 =?utf-8?B?bzYxV3pUT3dnMzlpQjREcHNIeHJXWUYwNk9ER0hLT1hKSXVjZzEraHhWWFRT?=
 =?utf-8?B?QjBwaVM5WlFTNXBrNytrdU9rR1VsWko5eUxHNWpXOWpJN2VoQWRScDlwbjhj?=
 =?utf-8?B?bGwrakt0RHcxRG5xeThnRFBaNDBNemY2RXRMdzNFQUpvZ0ZRR2hCblM1ZVIv?=
 =?utf-8?B?NlBVaDQrcDUxQjR3SVcwaG1nNVdaN2FMNDNXZVY3MUZ6bXVXRU5jbkJiN2l2?=
 =?utf-8?B?ZHBZS3YrV2hqYkEwRjBBMUpkWmhyQkwxTmhWOHFtRXR3eWsvanpYeEQra3Bl?=
 =?utf-8?B?WVZKNjArSFV1LzlmZUtoamlTbGR1NkREZmNyamVFdWpjYy9iUkwwZEFUQmNM?=
 =?utf-8?B?TXpBanZ5c2haS2doN3doQktxd21oZDV4SWVFalRBWWcyS3RCa2VVcEEzb1NI?=
 =?utf-8?B?N3BBMVpIdGRPVzY2RlJTaWpDMFRBck05RDNBczRiYlRmdmNJangrSVc5N3Yv?=
 =?utf-8?B?bjdnTSt4Nk1PUHN2VGJsclpURmw4cjJMQkh3bENPdGhBTkE1OGlheDNrcHc4?=
 =?utf-8?B?d3RENmRndit1ZWRucG5ZZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QU90TmFPSzRpd1N3U281emFNSmRQZ2p5ZW84MVpkMmlueXo1YTU3Z3dEbFdH?=
 =?utf-8?B?Z2ZnaXd1RFh2ZU5qNm82WUtCR0Q2Z3h1aG9VMjhPZUJ4cEJ6SStyNXkya3dD?=
 =?utf-8?B?ZVVDVXA2dXZNcG1GS01PcVZLcWl5WktEdlFlY3dvZEwxay9yYTAzRWpZVXQ2?=
 =?utf-8?B?RTdDTmorQjRVcVNJckJIeC9OaTA2VXVCMXplOVduZFRpSjBQMlFQL243OVFI?=
 =?utf-8?B?aXJ4ZVNEcnkwRDhDVUF0bDVsWVU4MzEzNU9xeVdYZVpneWJHaTVtckZjSlpn?=
 =?utf-8?B?bmdUQnNKc0tDMmFCZk90Ym5haU5KUk80VU9iZzBpbTY0UUtIbnFCNHNQYk80?=
 =?utf-8?B?ZExlTUErUkNVa090ODQ5dnZCUC9Qc1JvWDFSMGNkaVY4YTZoN1RtRDdUNm41?=
 =?utf-8?B?STdkNnQ2UmVSZ1F5L2N5YjhMRXNNSGtwWU05NVdaWXloTXZmZDc2NGtTajNn?=
 =?utf-8?B?dlZFSDR5SFBLQUNPTDlEblk1S3Z3Z3B4ZE5IaERxYnRKazcvcUthMG9SdjVD?=
 =?utf-8?B?bTRpWkc2ZTFaQWFzQmRydEVCcHBUSDVkZVZnVlA4RzZ4RHdjR3lxNy9odEU2?=
 =?utf-8?B?dE1Geml2VEZSZ1EzUUEzc1RPSnNlNTRZSWdsM2d4T1gvZHZ5dmVVd2JOWXR6?=
 =?utf-8?B?MTFqaEhGZ2xnVGNZV215WFQzT2dsYk5GeXNZRndMMVNTWGwyN0p2dis5Z1kz?=
 =?utf-8?B?ZmNpWUlCWksrSG9UaVppeVcrdEhJbHZjaDhoRm1YUzA2U3F6VHpOS0xuWFdz?=
 =?utf-8?B?a2h6Q1JQdkt0L29uQUdJYk5UYVB6Y3U2bkRQOHJVcVhYNzB6eURDMk9TNDJz?=
 =?utf-8?B?T1NDK1hBUDFoZWNzaS9YMlZDajJZU0xCNU45QkRyQVgya1UzM3p1Mi9aeFlu?=
 =?utf-8?B?Y2xpVm5rN1Q5cy9uNG5wQmZxRW5PcVNqbjhMelMxeG55VW1oZFZDMEFnYkwz?=
 =?utf-8?B?bHhxOU5wYjFWSHc4RnZsY3hzSjdsZkdYNVFUMTBBcWo3QXZianZGeHV3dDU1?=
 =?utf-8?B?OFY0N1ZRenpiNjRaS0pGZjU3ZXhhZ3hPV2tIaGNiMnNHK1JVaHRMbWwrRG1Q?=
 =?utf-8?B?REdXSnRuT3R4d3JYSUs4RVV3ODhZaCtVTEFTbHdKODJMNjc3dXk1TXJPWXBH?=
 =?utf-8?B?SFVUYU4zbFhKWlMzN0E2U1JYUU56MVliRkZ4QnhjdFgxNlFDL24rRDV3Q0t3?=
 =?utf-8?B?cHNvQStKRlFSb0JzL1hTRE0yNkVXV2tFZ080U2Q3ZnVwTVdJcExzeEY4MTNG?=
 =?utf-8?B?ZEdvN0tWSUJnRi81dmdwZHBZeXdDemtsMUU3TWdwTTUxUDhUQlNMSGVCeXBS?=
 =?utf-8?B?dGE5SWp4QmwyZzY4Q3c5aUhIdmRCQldTdVJta1VYaUFWMFlYN1lCaXBobEJw?=
 =?utf-8?B?b3Q4d0J1ZlhucllYYy9rV3NudS9lcVQ2OFlWZWZURDhoSTEvbmhZOEJzTXFN?=
 =?utf-8?B?WE1tNlRnbGluaDBKZ0s5V2I1SVVMSmwyNHVLOUdyWFVkZlVhTDRkNnhYQnZS?=
 =?utf-8?B?ajRyYTAwWkZlRUVsTWN0dUpDTi9TZ2hPcXNqcmdzNkZhSFY1YXo5OG5RL3JB?=
 =?utf-8?B?bnNhUGljVmpNdWppNC9XaUZpY0hjeStjRE5VRHJ3SXR4QWFoVjVwQVBDeHps?=
 =?utf-8?B?ZG93TVpTL0xKYXJiWjVzUzJFWHZCTUNXVkJMMFdwbHd0c1lwMk4wYnJKZTV0?=
 =?utf-8?B?M1FYajloN2xoYjRtNGNKMHpjMWJLSXVaODAveWxENGZhNEtyQ055Wnc5K2pU?=
 =?utf-8?B?MWVxc3k3anpPMStIdWhwZzhvbHpMWkFsUlBHWkRiUUg5WDF0djVhTnBOTkw0?=
 =?utf-8?B?WFNQL3M2RU4zOHNodlRxMEdnSHFBY2svYXhXdDNtU0NNbDYxQUI1eEl6QnBi?=
 =?utf-8?B?WUUrNkFHTjRpK0JTTFFPWWpHaHlKNnM5SGNwRkdDK0dQOFlkOW96Z2hodlFs?=
 =?utf-8?B?Rkl2cnM5VlhKVEpHekxuSFlGNmRYT0dKaEFhSWxoUVVMcnVzRVhSWDNxNjFK?=
 =?utf-8?B?aUw4TDBvdHBvdGdXc3RPRzJCMzM2MmoyUCtFUXF5SFd6TTltN0dWd3FxK3Qw?=
 =?utf-8?B?Y1UwSlA2NE9KS1l1TFVGNWVocHRrTUhjU2lzV1pIVlRiT0NqaGxIcCtMZjli?=
 =?utf-8?Q?BAhI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776e20ed-83c2-48bd-8fc3-08dd3002f101
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 16:38:54.9447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHWPboI1L0fOSWt+NmdQUoXqEdnnYDbXXgFImHRcHHk2s1LBAFQSOXsMAdE3yn+T
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR01MB7874

On 1/8/2025 10:03 AM, He X wrote:
>  > Ok, that's important and perhaps this needs more digging. What was
> your setup? Was it an iWARP connection, for example?
> 
> Direct connection between two mlx5_ib, ROCE network.
> 
>  > If IRD/ORD is the problem, you'll see connections break when write-heavy
> workloads are present. Is that what you mean by "did not work"?
> 
> Yes. Only disconnect when copying large files from clients(cifs) to 
> ksmbd. I do see some retrying in logs, but it is not able to recover.
> 
> I have cleared my testing logs, so I can not paste it here.

Ok. The interesting item would be the work request completion status
that preceded the connection failure, or the async error upcall event
from the rdma driver if that triggered first. Both client and server
logs are needed. And it can be a higher-level issue too, there were
some signing issues related to the fscache changes, these might be
in kernel 6.12. I tested mostly successfully at SDC in September with
them, anyway.

There may well be something else going on - RoCE can be very tricky
to set up since it depends on link layer flow control. You're not
using RoCEv2?

BTW the code does have some strange-looking defaults between client
and server IRD/ORD queue depths. The server defaults to 8 ORD, while
the client defaults to 32 IRD. This is odd, but not in itself fatal.
After all, other implementations (e.g. Windows) have their own defaults
too. The negotiation at both RDMA and SMB Direct should align them.

>  > Again "many"?
> 
> I mean the quote `In practice, many RDMA providers set the rd_atom and 
> rd_init_atom to the same value`.
> 
>> Other protocols may make different choices. Not this one.
> 
> Got. I'll do some more tests to see if I can find out the problem. 
> Thanks for your patience!

Great, looking forward to that.

Tom.

> 
> Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> 于2025年1月8日周三 
> 21:58写道：
> 
>     On 1/7/2025 10:19 PM, He X wrote:
>      > Thanks for your review!
>      >
>      > By man page, I mean rdma_xxx man pages like https://
>     linux.die.net/man/3/ <https://linux.die.net/man/3/>
>      > rdma_connect <https://linux.die.net/man/3/rdma_connect <https://
>     linux.die.net/man/3/rdma_connect>>. I do mean ORD
>      > or IRD, just bad wording.
> 
>     Ok, that's the user verb API, we're in the kernel here. Some things are
>     similar, but not all.
> 
>      > In short, RDMA on my setup did not work. While I am digging
>     around, I
> 
>     Ok, that's important and perhaps this needs more digging. What was
>     your setup? Was it an iWARP connection, for example? The iWARP protocol
>     is stricter than IB for IRD, because it does not support "retry" when
>     there are insufficient resources. This is a Good Thing, by the way,
>     it avoids silly tail latencies. But it can cause sloppy upper layer
>     code to break.
> 
>     If IRD/ORD is the problem, you'll see connections break when write-heavy
>     workloads are present. Is that what you mean by "did not work"?
> 
>      > noticed that `initiator_depth` is generally set to `min(xxx,
>      > max_qp_init_rd_atom)` in the kernel source code. I am not aware
>     of that
>      > ksmbd direct did not use IRD. And many clients set them to the
>     same value.
> 
>     Again "many"? Please be specific. Clients implement protocols, and
>     protocols have differing requirements. An SMB3 client should advertise
>     an ORD == 0, and should offer at least a small IRD > 0.
> 
>     An SMB3 server will do the converse - an IRD == 0 at all times, and an
>     ORD > 0 in response to the client's offered IRD. The resulting limits
>     are exchanged in the SMB Direct negotiation packets. The IRD==0 is what
>     you see in the very next line after your change:
> 
>       >> conn_param.responder_resources = 0;
> 
>     Other protocols may make different choices. Not this one.
> 
>     Tom.
> 
> 
>      >
>      > FYI, here is the original discussion on github https://
>     github.com/ <https://github.com/>
>      > namjaejeon/ksmbd/issues/497 <https://github.com/namjaejeon/ksmbd/
>     <https://github.com/namjaejeon/ksmbd/>
>      > issues/497>.
>      >
>      > Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>
>     <mailto:tom@talpey.com <mailto:tom@talpey.com>>> 于2025年1月8日周三
>      > 05:04写道：
>      >
>      >     On 1/5/2025 10:39 PM, He Wang wrote:
>      >      > Field `initiator_depth` is for incoming request.
>      >      >
>      >      > According to the man page, `max_qp_rd_atom` is the maximum
>     number of
>      >      > outstanding packaets, and `max_qp_init_rd_atom` is the maximum
>      >     depth of
>      >      > incoming requests.
>      >
>      >     I do not believe this is correct, what "man page" are you
>     referring to?
>      >     The commit message is definitely wrong. Neither value is
>     referring to
>      >     generic "maximum packets" nor "incoming requests".
>      >
>      >     The max_qp_rd_atom is the "ORD" or outgoing read/atomic
>     request depth.
>      >     The ksmbd server uses this to control RDMA Read requests to
>     fetch data
>      >     from the client for certain SMB3_WRITE operations. (SMB
>     Direct does not
>      >     use atomics)
>      >
>      >     The max_qp_init_rd_atom is the "IRD" or incoming read/atomic
>     request
>      >     depth. The SMB3 protocol does not allow clients to request
>     data from
>      >     servers via RDMA Read. This is absolutely by design, and the
>     server
>      >     therefore does not use this value.
>      >
>      >     In practice, many RDMA providers set the rd_atom and
>     rd_init_atom to
>      >     the same value, but this change would appear to break SMB
>     Direct write
>      >     functionality when operating over providers that do not.
>      >
>      >     So, NAK.
>      >
>      >     Namjae, you should revert your upstream commit.
>      >
>      >     Tom.
>      >
>      >      >
>      >      > Signed-off-by: He Wang <xw897002528@gmail.com
>     <mailto:xw897002528@gmail.com>
>      >     <mailto:xw897002528@gmail.com <mailto:xw897002528@gmail.com>>>
>      >      > ---
>      >      >   fs/smb/server/transport_rdma.c | 2 +-
>      >      >   1 file changed, 1 insertion(+), 1 deletion(-)
>      >      >
>      >      > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/
>      >     transport_rdma.c
>      >      > index 0ef3c9f0b..c6dbbbb32 100644
>      >      > --- a/fs/smb/server/transport_rdma.c
>      >      > +++ b/fs/smb/server/transport_rdma.c
>      >      > @@ -1640,7 +1640,7 @@ static int
>     smb_direct_accept_client(struct
>      >     smb_direct_transport *t)
>      >      >       int ret;
>      >      >
>      >      >       memset(&conn_param, 0, sizeof(conn_param));
>      >      > -     conn_param.initiator_depth = min_t(u8, t->cm_id->device-
>      >      >attrs.max_qp_rd_atom,
>      >      > +     conn_param.initiator_depth = min_t(u8, t->cm_id->device-
>      >      >attrs.max_qp_init_rd_atom,
>      >      >
>      >     SMB_DIRECT_CM_INITIATOR_DEPTH);
>      >      >       conn_param.responder_resources = 0;
>      >      >
>      >
>      >
>      >
>      > --
>      > Best regards,
>      > xhe
> 
> 
> 
> -- 
> Best regards,
> xhe

