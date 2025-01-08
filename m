Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020074.outbound.protection.outlook.com [52.101.51.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4627259497;
	Wed,  8 Jan 2025 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736344729; cv=fail; b=VKmsKN6YwvDv5+i8YM3S5TbDkD1bZHpM9EgJNwGXj190JpZP14XImLMm2KhAUP3p9IMoXTTJdVMBiSQECFjT9pl9zZz9yq5j+LvjfmXAg0uKcn8+z5Ucswx+ldf38QF3amqIWj0wi2xoNl58a8gC/Fa0eVMSdcWZ2Nh5ErK5gbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736344729; c=relaxed/simple;
	bh=giq5Qk4V+yz5DIki7Q/4AeGJGxLm4iel4YmJhzP1lRU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XmVP34uBwNEkHrdUrpn/owNlSV57Hwy3QzeYggTlf/SZ9brBVGIN8KOBnlqp2cRwQwu5NQJ0+HWVOgKGyLUnwvvspliuYlhtn9JhKbB2PCat1jRfopbxNpFAjqPosGeIRtD5aoi9mAMiKDe1ajumezJ517IIkVFmuAVGmCmsJEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.51.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckxkrsL2OJHOLAe9zo16JYuV5iQZ5rqEYqu9z1nKo4iCpDiC0icZSFzvPZH06QR3/T3ocUE6jQ6pTs9StSIgq4s7n1H3r59j5KrtfjzzoVa45tF8NseJfnNksyrsVaVmA6WeBDG6dJeQwvRSKR+9Ld/WpbBUaW/65yIrwfKqJ57s368q1HOjkTq5IfgVG293IDNC9XkPSPEToDygZlk1Zn+8X+bOnG+XgO8Z1eq1/SnyzmX6DgC3IBfngAZ+WL8984RVolvR44WK3Wm7umGKke9W/h86QUF8ORy5BwpbHyHonGt5JZrsb+KIzlnY4zbAGfuDppPY6YzdwaSkp21xzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5IUAgiPMrObPXtY3oWvhRSXkQnnF0IXsxsgDZN4EgBM=;
 b=pK83hC2HSu3h1OP3XE9FX3iECN9M2op9x3vwAM0yCEkzWt4s7MiBAUMkPzA+JbOyjAboxdDFVotRNnK4iCG//7guehogHHJHHt6yqGFoYaH+fLPqBfvE8Gzi8jhjVZa7iqWA1bE4qKSU0j9dUKJpd6Ygbwab4lARDsns/CwZZky69ZjxvW/ZmItEJnJr+zAMDQcEBA4i5uYuLUrX6t2RuekMiuazAs5MFg6mHXgkGgVvFaBETCfF1SqiGT3bIGhfiXz5bWly3HQkgoE/csoq2UU2zTiJX0GUXrfKLuArZl28cRpzyZKdlY3OOQSMi9u+7yaNRA5U8oYKTSoD92r4Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 MW4PR01MB6308.prod.exchangelabs.com (2603:10b6:303:7e::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 13:58:42 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8335.003; Wed, 8 Jan 2025
 13:58:42 +0000
Message-ID: <b183d30e-f51c-426f-978b-ef178a88bef6@talpey.com>
Date: Wed, 8 Jan 2025 08:58:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer
 size
To: He X <xw897002528@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>
References: <20250106033956.27445-1-xw897002528@gmail.com>
 <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
 <CAPG2z08PyX3VZ4mxzEr_FtmiafGi=cNGpOzG7rjWxihjxeyTjQ@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAPG2z08PyX3VZ4mxzEr_FtmiafGi=cNGpOzG7rjWxihjxeyTjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0056.namprd03.prod.outlook.com
 (2603:10b6:208:32d::31) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|MW4PR01MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: f81116c8-b326-4912-406a-08dd2fec8f98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aExFL3BVRHpzZ2s2blNjemdMWEZZU0RXUGRIU2pNa25XOHBpVERCeVdJZkow?=
 =?utf-8?B?ZXpodC8zOGwzNDllN2I4bkNOSWp5aDkwWjlDY05nUTFMbkJQS3kxVDVBTitp?=
 =?utf-8?B?Z3R3alRMcGZGY3Q3UzhuRTg4QUVMeW00VkkrSW01TjRBemJybDJMS3ZuekFr?=
 =?utf-8?B?dG5LRmQ2RXoyb2NkOWl3Z25OVy9SQk43azNkM1V4dnV1WW9qcjZQcjBjV25n?=
 =?utf-8?B?WU1hdXErVFd3TzlBdVM2b01NZXZ4VnlxbFF4aHRqSmNwamRUR0FEc2VGakxU?=
 =?utf-8?B?VHQxSCs3UFpwM3FKcEFtV2crajc2bTZuRTQ1T2hYZWJlWXpka1p0REtJdmo0?=
 =?utf-8?B?SU9ZTzhDeTFvbUEzSEJQM2hLc2VBNWVjNi9PcmROTHYzNEtVWlk5bVVJYnE0?=
 =?utf-8?B?a0xTemx2M3ZpRWFRTnhIZVRuRnZXSDJhVDhpL05HTy9KMCsxZlROWXJSV0RM?=
 =?utf-8?B?TDR3QXZzWDBYTEorelA2a1YxVWp3WHcxVkhoaFhlZEdZM0dmZ1Q2d29qNVdJ?=
 =?utf-8?B?Q05YYm9BeG45eW1kR3ROWFZCRlR0d0dLRGp4eU1UTXFyT01xV0IrUGhjOWhh?=
 =?utf-8?B?Q2hhTjBBamx5SGI4QmpPN1VwMTZKeldEK1oxT09sUWhLK0NnSHBGbmtoYkZX?=
 =?utf-8?B?eXFLbTMrYm9vYWJpQVRCdXlqOUF3U01FT0Z1dC9kcTBlM29panN0aEo0QTZk?=
 =?utf-8?B?MVdrQnA3cmRzQUtGaFcyVURIZmtZdTZFM3dSMGwrNnl6OXFjVkRDVlQyaHRX?=
 =?utf-8?B?QmwydHFsYmUrcjZLMm5rVkNPS2s5dVhIa0pEUHRBTUNuWkJ2ZWJhOFlKRFB0?=
 =?utf-8?B?WU5NZ0t3Wi9sRHJqOXFYZzhqbXVheXkxdzdLYXVjTnJLWjRocFpnbk5YSkFq?=
 =?utf-8?B?K0xkekQ1RWluWkJobXZzU2pJa1NhVXIzaFFJaHltNmx5ZHRxSEorTUNBclNF?=
 =?utf-8?B?YTltUUMxZEJUYktaeEhlN0wzbU04cy83Rkk3VGZjVWZYd3oyMzAxa3kvQXJK?=
 =?utf-8?B?TFhhNnc4UVFrL1d1MkFMQWMxd0N2L2VldXJ0dEZscmpHaEVqdG54L2FjVXQw?=
 =?utf-8?B?YmxaYnU4dDZqUC9KVzBPV1FvMTNFeWxSTC9BQUE2aSt5U1ZJNXh0NVl4bWRu?=
 =?utf-8?B?Y2tYQUNlVDFodDY4SXp2L1FRUWthQUxZbXM1N0JSektQc3haOU1KMTR6UmJN?=
 =?utf-8?B?VWhwNDFUWVVKR2tLelBSMVExVXBib3dDdXM5ZE9wWXdSaWg3UGVvMTZWbXM1?=
 =?utf-8?B?MTFRci94YnlaL1gzMjlIRVdZcmNmTE9oYnRreXhrSlJaclVTc0U1R3U1R3Ju?=
 =?utf-8?B?QjVCNERRYmxEMmVXOFROS0hSeExheERIalhITlFaM1hmRkorQURla052VnRJ?=
 =?utf-8?B?eUgwQ0puTkl0bmNlc1d4TVpQdms4RmhpbmlTTzRTMGo5VGdIZmV3dFQ5Q2lQ?=
 =?utf-8?B?VGxXTmpMY0lSV2JvQkZZeEpHTVRJN0N5RVE3c1hNNlVYa3BTSXhMV0RtR2JZ?=
 =?utf-8?B?bHQyMjVNbHUyYWgvTU5TS0c1SFFZbUkvYXVUTVJvT1g1bForcGlwOGxZTGhH?=
 =?utf-8?B?ZTE2NUdKTnQwR1E0VjhPYkt2Y3B0U21uM3BCOTJTTTJ2dWsyb28rRUo2ZUk2?=
 =?utf-8?B?WmJSMDVHbzdXeWxlbFpBMFA0aDdxNWlGaXUxenREcHJxamExd2phMG5rT2RK?=
 =?utf-8?B?RkMvaWFDWE1GYkVkRCs4UElFUzV1RTduN0Nyd0lYanRwODRxSE01ekdLUGtl?=
 =?utf-8?B?RlAwcmdCeHV2RmlqZFJsUnBDQUxKZkVSVE45ZVJNamZIekkwSVk4T2kzZ0tz?=
 =?utf-8?B?Lzg5RWlZQjNEcG9tWWJCdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmJTdzlwSzAxaitsSUd2allYVjBxYVAvRkVGdTAyTldlWis0c0VtYTFDazBn?=
 =?utf-8?B?c1I2aEwxK2dBWHJRQSt1OGJYNFNZdjF4NHYxU05udjlGWERiQ0FiaVJDWURC?=
 =?utf-8?B?ZU14aUUzQnRmN3RORXordVM0VlVOWVhMeXRLN01TWVJwVC90K3VqYks4UENy?=
 =?utf-8?B?UkJwZzVSSEhVNmR2WnhJTWJiZFNjaS96bm5QZE1SQzk4QnRpSStPTk5va2Fz?=
 =?utf-8?B?dG9hM05scWIvcURsVHhyM1FLejFFZmRNU250OE41RmwvbVdDLzdLdzkwd3BQ?=
 =?utf-8?B?d1d3WHBHL21nQlVlYm5qTkRUN2Z1bDRrbEJ0c3o4TE1xaENWVTRweFZnWWNi?=
 =?utf-8?B?SjR2eThaMTRGWjNzc2dLTFJJYzlEdFRRT2UwN3lubFZRaXB1UFBBMDRyR2xp?=
 =?utf-8?B?RzBXZnY2a0F1elZuVW50c1ZiZm0zZUgwZWpZV1I2Q3lrWnFnUDhKYnlHMHpH?=
 =?utf-8?B?aTFNK3dtM1A3S1d0T0J6WkhEZFNnY3BmMFBOcHJmRTg5ZnI2RENKREs4dUdr?=
 =?utf-8?B?eEVRcnJPczJ5bCs3Q1U2cXF0NU1aSmFVWi9oNHAwMmJiUHIza0RpTVpsdzRD?=
 =?utf-8?B?V2p6WG9MMHZaZG5Ia2YxVjg1U1VKYmFGS1J0YnZVOGc3QWdycFllNzVQYXBs?=
 =?utf-8?B?bWtaakcyWkdaWEVGKy9TK2tNbmZYc3pDUWhEay8wb2NVVkFpb2s5RnhhMlhJ?=
 =?utf-8?B?c3dRa3IvcEdXck44dzBianRId05WeTlBWXFxZFB5SWlubW1yUHdlZzlPWWFj?=
 =?utf-8?B?U2xuRndtNW91Q2pDbzhKYU1QemJCUUNDYUpmMXpkY2FoUUxPcFF6OVNvYk9Q?=
 =?utf-8?B?eStNK0FVREIyVUtDV2JqbXdPRWdod1JNOEhPTC9vdUJRa2tRMHErUlBvUVEw?=
 =?utf-8?B?aXBxaVJsWW44UVIrVWJXRk1BZ1lRUmwyTC9Ybk41ZTFOd0lYbWlYN21CVHhC?=
 =?utf-8?B?OER0RjlwNjVEUFVhUDlQcXVaSFVBUXBiOFpjVGd3cno0YWQ5SE1ZbitlM0I2?=
 =?utf-8?B?blVaNjFZM0U0NGt5b1VRZW1Fa25XOVZEeG11eUFwYzUvMkdoMGJxaEhPVGlj?=
 =?utf-8?B?UW1kK3dvMmtlbHp0N0FGYTNyK3pROEJpU2VXK09aWGNGV2NJTXlhRW4rRGJp?=
 =?utf-8?B?UnpkMzBhV0YxZGxjaXc0OTRnM3VzaktaTTdYZ1VBcll0b1doQjdmWHR4MWJy?=
 =?utf-8?B?b1NCMTliTWJzVUs5UDdpSlh4R3lpRHpFMTV2cnYvSFM2U0RIRjB2cHQ4SGpH?=
 =?utf-8?B?QlcydXN0Nkx2ZVhseXBvWUxnVlBWbXJVZlhUMjlqWlJnNUNxcy9oczFBSVJx?=
 =?utf-8?B?TFlwQU96UVpyUHJqNXp4ZVNIbmJrQnQ4TytQNTNndWFubjV4VmxwQUFOb011?=
 =?utf-8?B?SDMraGxXODhLbkFEWld0WG5BZTA2bC8xa3Y3YTgxbXJMWklEWUkzNTV3ejVa?=
 =?utf-8?B?TGxWSllSVVhSeWZENERkcGxZQTNiMlVDY2ptaWcweDljZTFCNWEvdWJvMEZt?=
 =?utf-8?B?UTJFc0RERXlRczBYNnJuQXpWRE1EUW1XWUVNSEV6elpkRFB6dlF5YXdKYzBS?=
 =?utf-8?B?TDVJQWk3c1pLNjJXaVJvNzg0TjB6K3BlWVBZa3hubzFUcnNoeklISStqWGZ3?=
 =?utf-8?B?M0pvMEROZk9rNUxzVGd6bFp2aG9BaExHeTRzZjZYRnVhbGVIaVFjNHNuNTV5?=
 =?utf-8?B?d1dwNW43dWJyMmtWL2hweUFQTmFzV0FkODBDMXFaNWhFc3lrOElNdk9WR1U4?=
 =?utf-8?B?VnB2a2Y3N2xVdkNubFFYNzNabkpYdWtGenhaRVJmb2d4VVBqSWJmMUM2OWM2?=
 =?utf-8?B?YkNEMSszUnBoSHFTSUZzLzVrQklwNTVtRjUwQ0tDZGNrOXNjbGJNLzN5ZXRQ?=
 =?utf-8?B?bDZ1U25DTVR4ZnhBRFQ2NlVYclVTWERLdS9VeUF0cXpSaU9NMG01QWl5MzdK?=
 =?utf-8?B?b05hVkxOdkZsaVlpNEMwaE5PeWFNZEU1MDJXbkxFa0dYOTRxQ3VhS2dzbUV1?=
 =?utf-8?B?SXJwTnlkNGhFeUlFTjdvTVlCMTFVTWd0TE8rbzlXU3cwbDQveVVSZGpySTJh?=
 =?utf-8?B?VHVMdWdLTEs3eEVmZEpQcVpqeUp1SllKd1ljUUEzcGFiQXZtdzNJdFVialpk?=
 =?utf-8?Q?xgKc=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f81116c8-b326-4912-406a-08dd2fec8f98
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 13:58:42.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RLWLie59jqKbKt0BGAogCAhK5bfKBHY+zLRHCnsj0TedgxuDKmG8Qi5EzoYCtXyv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6308

On 1/7/2025 10:19 PM, He X wrote:
> Thanks for your review!
> 
> By man page, I mean rdma_xxx man pages like https://linux.die.net/man/3/ 
> rdma_connect <https://linux.die.net/man/3/rdma_connect>. I do mean ORD 
> or IRD, just bad wording.

Ok, that's the user verb API, we're in the kernel here. Some things are
similar, but not all.

> In short, RDMA on my setup did not work. While I am digging around, I 

Ok, that's important and perhaps this needs more digging. What was
your setup? Was it an iWARP connection, for example? The iWARP protocol
is stricter than IB for IRD, because it does not support "retry" when
there are insufficient resources. This is a Good Thing, by the way,
it avoids silly tail latencies. But it can cause sloppy upper layer
code to break.

If IRD/ORD is the problem, you'll see connections break when write-heavy
workloads are present. Is that what you mean by "did not work"?

> noticed that `initiator_depth` is generally set to `min(xxx, 
> max_qp_init_rd_atom)` in the kernel source code. I am not aware of that 
> ksmbd direct did not use IRD. And many clients set them to the same value.

Again "many"? Please be specific. Clients implement protocols, and
protocols have differing requirements. An SMB3 client should advertise
an ORD == 0, and should offer at least a small IRD > 0.

An SMB3 server will do the converse - an IRD == 0 at all times, and an
ORD > 0 in response to the client's offered IRD. The resulting limits
are exchanged in the SMB Direct negotiation packets. The IRD==0 is what
you see in the very next line after your change:

 >> conn_param.responder_resources = 0;

Other protocols may make different choices. Not this one.

Tom.


> 
> FYI, here is the original discussion on github https://github.com/ 
> namjaejeon/ksmbd/issues/497 <https://github.com/namjaejeon/ksmbd/ 
> issues/497>.
> 
> Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> 于2025年1月8日周三 
> 05:04写道：
> 
>     On 1/5/2025 10:39 PM, He Wang wrote:
>      > Field `initiator_depth` is for incoming request.
>      >
>      > According to the man page, `max_qp_rd_atom` is the maximum number of
>      > outstanding packaets, and `max_qp_init_rd_atom` is the maximum
>     depth of
>      > incoming requests.
> 
>     I do not believe this is correct, what "man page" are you referring to?
>     The commit message is definitely wrong. Neither value is referring to
>     generic "maximum packets" nor "incoming requests".
> 
>     The max_qp_rd_atom is the "ORD" or outgoing read/atomic request depth.
>     The ksmbd server uses this to control RDMA Read requests to fetch data
>     from the client for certain SMB3_WRITE operations. (SMB Direct does not
>     use atomics)
> 
>     The max_qp_init_rd_atom is the "IRD" or incoming read/atomic request
>     depth. The SMB3 protocol does not allow clients to request data from
>     servers via RDMA Read. This is absolutely by design, and the server
>     therefore does not use this value.
> 
>     In practice, many RDMA providers set the rd_atom and rd_init_atom to
>     the same value, but this change would appear to break SMB Direct write
>     functionality when operating over providers that do not.
> 
>     So, NAK.
> 
>     Namjae, you should revert your upstream commit.
> 
>     Tom.
> 
>      >
>      > Signed-off-by: He Wang <xw897002528@gmail.com
>     <mailto:xw897002528@gmail.com>>
>      > ---
>      >   fs/smb/server/transport_rdma.c | 2 +-
>      >   1 file changed, 1 insertion(+), 1 deletion(-)
>      >
>      > diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/
>     transport_rdma.c
>      > index 0ef3c9f0b..c6dbbbb32 100644
>      > --- a/fs/smb/server/transport_rdma.c
>      > +++ b/fs/smb/server/transport_rdma.c
>      > @@ -1640,7 +1640,7 @@ static int smb_direct_accept_client(struct
>     smb_direct_transport *t)
>      >       int ret;
>      >
>      >       memset(&conn_param, 0, sizeof(conn_param));
>      > -     conn_param.initiator_depth = min_t(u8, t->cm_id->device-
>      >attrs.max_qp_rd_atom,
>      > +     conn_param.initiator_depth = min_t(u8, t->cm_id->device-
>      >attrs.max_qp_init_rd_atom,
>      >                                         
>     SMB_DIRECT_CM_INITIATOR_DEPTH);
>      >       conn_param.responder_resources = 0;
>      >
> 
> 
> 
> -- 
> Best regards,
> xhe

