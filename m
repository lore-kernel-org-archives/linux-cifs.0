Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020085.outbound.protection.outlook.com [52.101.56.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DA51925AB
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 17:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743613345; cv=fail; b=ii15aymkSnZNhlisjn8y6nyP7RxNJ/+4IuqWqr9s7MIGbnKo/Co0nyk1jdAAStKtlSW3ZFjNRgakZTfmXpXqPKRjsOMWVac1896p6c7mtlcxDUSCBsFqQ0gEVwjsGfznEZdwOh5yUF5r2OOudbqDm5XmR3e+B5v2XDtomJvAo2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743613345; c=relaxed/simple;
	bh=3c8qF16yKSHThtySkmm1e6kxE4tDBXadKLGREWUN/FY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ya+RRkgBUSPmg5EVt1KI6R+TeMSMwQQVj0Ty6xBqyFtE8VzA2dwC1suvYcVpQfIWQgsTGv4211dODdbtBWPuRD94+hxDy2oEntiDD0rtswhgjnYyv2zeIl3jM4ZF0k+CrWh8f3fqKv6IPNLmF5xUlW64kADd8eBIJJC73d3riR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.56.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dBWUcIAt7xuf3rDwUo+f7Q75++IpZDP+ChheX6LrD04Y0krlTyy2MVY7J5M3kKB2XtdK2pJORJ+zK8LAHEqKIqm1R6R/8BRbLSShdAzLUKIJ97bTlDgYhkv4pZBB8KGQPSn4r67xgk+VCtLIKbBsHEaU/NnEK+PQaJBPo9tk9IzNg352k9yjKDGCfV76mSJjwl9TeJJt2AHYfFxsqabMrNnFEwiTr4xTipLB2DIdNBJLGb50dO0pT2jqd5eDiu2AzHCaPXHTxcL/ZBWS0DXSjim/14ueVeXk1NQAD6L5vND+pd97blIZ7jgdzL0YcIsqwRhbpqfc8qNtEuQ8V8NE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUI/TnYY6YV3Z5ljfP1RIjhsgB3VrlxhZPKIfHF7Oxk=;
 b=S3yBcyRUUzn9vCpI0xiZtTr1nx8/m6AZq2YXAZkDWuoIuwA+r/zscEY5gz5FS5WiQEcqcaxVOeCusTUcuf/kRD2C7Fvzhc7ZcJ5MzQTS11BM3WoYj6Zy0D7pBS0Rvzx6AqUZIDLERKUDX1ZuQI/uyEnpAU1b5jZDpMlnD1SwKUaw+aheoPGegcyfhi+24c+PeDzHKYdLLlk8VlGZsybqn2s+Podaq7ovVo7VZP8x9rCdKISdYs7o2rFoAQA1b6mITEVwKMGo9FXfNPgeqyYEAPoofQuyU2cljyWkNUl2Pxjjx2ciR65CFBeO9Sh+C5fh+2EgIwNkACXqmJlR+VKFCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 DS1PR01MB8965.prod.exchangelabs.com (2603:10b6:8:21b::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8583.41; Wed, 2 Apr 2025 17:02:19 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%5]) with mapi id 15.20.8534.052; Wed, 2 Apr 2025
 17:02:18 +0000
Message-ID: <7e1fc71c-2821-4294-833c-746c5fd7ee69@talpey.com>
Date: Wed, 2 Apr 2025 13:02:20 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: cifs RDMA restrictions
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Matthew Wilcox <willy@infradead.org>,
 linux-cifs@vger.kernel.org
References: <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com>
 <563557.1743526559@warthog.procyon.org.uk>
 <659109.1743536087@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <659109.1743536087@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|DS1PR01MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: e51f4f44-7ca2-4b0a-47f2-08dd7208204d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkFBeWNqcDBpam56ZURtZDl6T2QyM210MUhDT3h6Ujl1WkVxbkQ1NEVRanhs?=
 =?utf-8?B?dVJXTjBaY2tOeFc2bDJiMlZZYVp6VjU3aFNMVFlCOFlMbktGRS8vS25wR3d1?=
 =?utf-8?B?cTRnb2JXZTJBS0pLdUdyV0NIYjc5a2diNjc2aXE3OG5CTG1ua25qN0R6U0hP?=
 =?utf-8?B?RXlKc053bEd3bG5XTFBTbzdVbWVGbE5ZRzZnZzFkNitaZXNyS3lGRm12MTU4?=
 =?utf-8?B?b2ZEdE92TkVKNFpsc2hsbXpESFkwUDcxQ1FYaWZWb3k2ZGhJOXcyWHlNNjNT?=
 =?utf-8?B?VXhQaE1mMlhQL0FMN0RodUhxRE91N2FZVEIwUE9iZDBDbjFBOGdkT3pHb0dt?=
 =?utf-8?B?N2xvUFBCclcvcFBiN3lmYW1YVkRJeTZHbVRwNVlQaTV2SkduZ255b2V1cEdj?=
 =?utf-8?B?ZGpTcVBhaWlFM05uL1RQMnNQVy92WVM5eVlGMlNVVmgzcE9IdFVOK0JMaDBq?=
 =?utf-8?B?bmtMSHdudkhaTHIvSWZkckd0eGkxcmpKV3cwQjdzT2MvWlhMNWw4bmRGSTgr?=
 =?utf-8?B?OWwyY0NONHBib0lmS3UrOHU1eTZSMlc2U3p5WVk2UTFwWWlOQ0xCaEViL2pi?=
 =?utf-8?B?bDFQbjhhamRjV1RBSkZXUGxLV2ZFSFBTQ21pTUh1TlI0bndvTUViMEVSME00?=
 =?utf-8?B?WmRHeFhyaHhmNEFUZjlFeTBCOFptK1VGcDV3b3puRDM5Q1gwVlBNdTFYUERD?=
 =?utf-8?B?eCtvOTdXL2MrRHJFMndhdWt3SEh6V0dXd3BhRXl5TUcrTkhOZC9naWVwcGU1?=
 =?utf-8?B?bG1MTEFuNzR4ZjZGVk5hMHFYM1duT3lIRlgwRVdkYUx2WDAxa01XM0lrRmlh?=
 =?utf-8?B?MjYxb096b0plOEVzbG9VSFNKbUtCT1JzZDI1S203MmQzWDV1c0ZqNVpTdkd5?=
 =?utf-8?B?YXRjTmtBUXRsRDhZcEd5V2w3QWErWlZPOURLOEY5aUhZU1FVOENEcmI5YktG?=
 =?utf-8?B?TG9QZEh6Q1dmb21BTzIwZVlzbmJZL3RnRC8rNkRvM1NZT3RtSk11RHcwY1hE?=
 =?utf-8?B?RUs2dWhoWndRUUM4Z1VrdWdNMEtKQ3BRMU14Tk9hdWZlNnBKbGc3Y1RhcTBW?=
 =?utf-8?B?c2x0a2c1cWRCTjNTSW1OUGVUUlUxQm1ac0RkT2l0UDhuZFFSNThOVjRHcEFB?=
 =?utf-8?B?K1ZYbzgxMzYrZkxpamFaaFBhUmlvNDNPKzFJSXQ4UjdFWUxkcFc5b2lnWDR2?=
 =?utf-8?B?ZjBiZG8vNzQ1eTZOYkJUS3dFTE5ZUEFNY3dQcUVXeDlXTUJyZDJWR1crSUlk?=
 =?utf-8?B?ZDRsc21Ob1gzcUpudkRUOElvamJCdTV6YVRuVWdHUmNWa0ZJOVloa2JFeEZH?=
 =?utf-8?B?K0FhOWdxem9JbUMwaTJ1WDlFYjVKYzl4Y3ZFcnUybCtXZkh0Nm1Ha25KMWU5?=
 =?utf-8?B?L1BtcmZ0eDArNllqWnpKUnJQVGhPZkJMVjBRdEJoellPdnYyM3g2bFBwWXVM?=
 =?utf-8?B?RmxnbEQrdmJ1UG1LbHZDRU5ZRktYSkZjc3o4bUJlWUVRMXRJdVd5RngzNU02?=
 =?utf-8?B?bFBHVlkwS0JKMHVaMVVRZGU2R245N1BWUVJoQWZoZWpVcTVnSGRJS1hZOE8z?=
 =?utf-8?B?VXp5L3dhendqZHlJZm9PUVpEbzB2VXRwY2JhRHZOSFlXMUZNOC9sUmtXZ3N4?=
 =?utf-8?B?a0ZEZU50dGw2ckZETGhyYVlFdFExYUVoMjJKeWRuR3FnU2JvbVJSazlJYkVw?=
 =?utf-8?B?ZnlUL0VKeDFNbjhMQWtwRStDcmRmYk00VVpJQ3JkZ0FVcUlpZUJxOHZ6Nnpv?=
 =?utf-8?B?K3lsQnA3bFI4bUN6ekpGRS9mdFBBY1JacmN6aUlRVTUyb2lkeTltYmxaMFpE?=
 =?utf-8?B?d1ZCa1BleGNXbmdTeXU3Ry9NOUoxRSt2RC91eXVKUzgyRjFpa2xKR2Vvb2xL?=
 =?utf-8?Q?s/50x2pp867Dt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXVjOEsvMkRhZG5nblpseXFnV2h6aGVweGVGY3U1WUhDOWxJMGxhZ3Y2OVVK?=
 =?utf-8?B?LzRnY1JZS215V09MUlFJQStsZENrbGNIcDQ5MGY0L3NtKysvUXRKc0JFUUVR?=
 =?utf-8?B?Um5ZcWtlK1czWkdPaGV2N3RjdVh1VHB3UnpwUzdpNTlZY3k3d0FDRzNtUmlW?=
 =?utf-8?B?ckk4SWZhQ3NRQm03bk1uU2U1U01lOFRWaEpRNWdWTGw4OGNvUGpzaWRWckJ3?=
 =?utf-8?B?VitIN05FRGt4bG1wcDNxbk5hR3d3YjZ2ODV3Q1h6MGpMLzh4TzBHTTREdEVy?=
 =?utf-8?B?NGpaZ0JFYVM3NS90bEF0czRZZ213OHBmaTgzMW11eWprNWtDczQ4dUozZ1c1?=
 =?utf-8?B?c2x6NmVWeHJ1eDk2dVlXc1UxeEZRdzQ3TFpCcy9RU1V5OERpc25NZ05UQlI0?=
 =?utf-8?B?cG9oTnhhQy9GUSt0SExUZTBEZTZhM1prQjlwTk5TWFVldWFmS2Y1c00xSnBo?=
 =?utf-8?B?Z2tNMkJwbXFmYUpyVk9YZ3pOb2lyb1F1UjdvOGk3c0xVZnpNUWNoNm1QZE9Q?=
 =?utf-8?B?dGRTSU9lK0VXbCtHNHg4YTJYc0ZOdzgxd29mUmh5T0FPUStwRTBWak9iVUtI?=
 =?utf-8?B?a0FYZllSWDFlaTMrQ3ZRRXJKOENBMW9jS0N3S3g5NE5XbC8wQm56K2xjZno1?=
 =?utf-8?B?d2JuTnZwekhpc0JJd043d0V2NHlIbVpvOUZCNmw3d2czd2NWU1VPSWJVd21S?=
 =?utf-8?B?VGJ6ekNicjNlVjhMVVdwSlkreTMyZkN3dVpGYU02U3RyY2l0amZoaWYxelQw?=
 =?utf-8?B?azgvaXNYRjAwWDF3QVlNWVptazE5Slp0bWpYQ2tlc2xRblZXWGhNNDVxUXZm?=
 =?utf-8?B?dTFhWnp6clRVVXYrK2NZc3gyZ2JPT2F0SHJPSDRHVTQ2V1FUeWZHS3FoQ2F6?=
 =?utf-8?B?eVBSbmtqb25aS0xLc29lWlNEVHJNUll4a2txZEdqWDlIdGRaZ3JQb3RURUVy?=
 =?utf-8?B?M1pTRnVlbUt6VUlYeUJJeUt6bURnaGRkUzVDYlZMRzlJekF0aWtrbTdJWlhh?=
 =?utf-8?B?a1BVYzJkUmNHb1JEM3RTc0RFeDR0YnBjRTJLc0hkWmV1OEhnRGs3NStLOFVh?=
 =?utf-8?B?SzlMR2ZvYWU4Wk9aMDRINXRMaDc0MDBsUGx4R1dodE9neGl5VUNaREgxU2ZN?=
 =?utf-8?B?VS9yRVN5UDNtZ2J3M1VSeWZXN3BuUi9yUzlzZ0FKSTM5em90Z1lCdHdSYjZ5?=
 =?utf-8?B?UXZqajFpMGxBL2dYM1ZGSmNTVGw1djJaQTJ5U0tSSUQ2QlZMbi9zWlJFUDl0?=
 =?utf-8?B?a3NOelg2TSs4T05OVnNFNldBMHZZUXFzVmxDc0t3bDlvcjROL1Q0cGRxeVAx?=
 =?utf-8?B?UmxCdmxhZ0ZCWkJDQ3h0MVhITkk4Zk1FL2x2YUNtMHZWTWJYTFUvb25yWjJC?=
 =?utf-8?B?cXNsajgxOFZ5Tk94THZ5Z2p6SG1DRFBLb09IOGVRYUQyMVd3czJoMU92VE5C?=
 =?utf-8?B?OHkwamNaTlBJRXBMaGphWVlMU2xwNUp1aEkxRExKc1c1Z2FQL012SCtYRzN5?=
 =?utf-8?B?cGY3MUQrenQyS1RQbTM3aDdyeVJDWUpFNzhHaDJ3Nm5ZYnJwcmZ2cHpLUHFU?=
 =?utf-8?B?a0dhSnFMbWE3UkEvUjFaWlVNVXZkalBoaUwxLzV2T1crWHJ3ZHdsQ1JBbFBO?=
 =?utf-8?B?ZUJSUTBQMnhPWEpGYjFWdW1Pc2plQ01OOU9BZmwzYmxtKzRrR0VRQTdXNnM1?=
 =?utf-8?B?NmFHYS9TNzFzaGNmbFVVR2tURTV1MGZja0ZiK0Y5OFE4RllsUy9paFFRTFJD?=
 =?utf-8?B?ajVWK2lXeWU1cnlVVDdtbTZYRk1BRTVwa2lXTUhkRWtBc21ncCs5VmpjbnpK?=
 =?utf-8?B?aGdtelVhb1EvRDhreHZoeGtmeFNzMnVaankzVzdGbHVRelNSSklueE5NUnBV?=
 =?utf-8?B?dWlPUUM0L0w5VnYzRk13dit0RWlNZGNtemtiL3ZlTFlXcXZTZzA1QmQzU09l?=
 =?utf-8?B?M3pNVHZlZjhSWld0ZEtTMWVWRTVGYzhBNkYzNDNBcXJpUnk4cVJUS012WkhW?=
 =?utf-8?B?ZjZMSytkckhiQmJjUFcvVG9ub0V3UE5SR1N4TEdTT1BhVTE3MlpKUzhEa1Zo?=
 =?utf-8?B?V2pBTURQU1RuU3JhV2J5TFVhVlZZNGRVTmJWZ3gySFVtcHN6aVdnUy9GcitN?=
 =?utf-8?Q?t7rg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51f4f44-7ca2-4b0a-47f2-08dd7208204d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 17:02:18.7806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VClTD8nKm6TLX+xKkH7Rw8qzE+KT+wBpBCHyr73h5tcOI3mK0e5VkVLcquN3xX8v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR01MB8965

On 4/1/2025 3:34 PM, David Howells wrote:
> Tom Talpey <tom@talpey.com> wrote:
> 
>> A single sge is just a hunk of memory that is registered with the RDMA
>> provider. The routine you're quoting is generating the dma_addr that
>> the provider (adapter) will use to access the data so it's passing what
>> the ib_dma stuff wants.
> 
> The issue is that currently, we pass individual page fragments to the RDMA
> layer, and none of them will cross a page boundary and they will be at most
> PAGE_SIZE in size.

Oh, that's suboptimal, maybe I'm thinking of the server code doing that.
It means the maximum size might be reduced, if the list exceeds the
adapter's max sge count. Not really a huge deal though, it just means
a pipeline of extra RDMA operations, which flow efficiently anyway.

> However, in order to better support large folios and large bvec descriptors, I
> could in theory set a segment much larger than PAGE_SIZE.

That would be desirable. Fewer sge's.

> But, will the device handle that?  And can the DMA API map a single buffer
> that big with the IOMMU?  And does it need aligning to a larger pow-of-2
> granule?

Yes, maybe and no.
1 - The device just expects a base and length, so size is not an issue.
2 - The IOMMU is a platform question, if it's in use and the mapping
     allows, it should work.
3 - No specific alignment required.

With the obvious caveat that this answer presumes no bugs in the adapter
code.

Tom.

> 
> David
> 
> 

