Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020072.outbound.protection.outlook.com [52.101.61.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EBD13AC1
	for <linux-cifs@vger.kernel.org>; Tue,  1 Apr 2025 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743530560; cv=fail; b=GbchbNjPWSct5Zf/svXhLgLTcqFTWBeXf6KgUxKk+wD+z6q7E78C5NU/bftO+bZK6lsW2jO10lwxfiwH6wob0S85/7EUKSmZXeFqRSYElejBbKzc9SeIROFPJ4dzO2vBgPsAL6PHEw5fzHVZg2a4jtw5jSlzpMEkl73Paqr2I0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743530560; c=relaxed/simple;
	bh=0SBkX7MXc04sRxY679DoxXUz6b2YegI4WeB90IsqtfQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NlK3NvFQ9xXOyEPysnMrQ5Ymo/LdC6C5C76PHwUVB/5xIgMsfHjCWMqHXPT73KviortKxuokI5b6ougTYM7VDPITSmnR2mwFm1YMc1oQSImRkMIkqCkBfk0hXQx/lHJEDIY6Io3ZGDNz07JGUYzdhcBqfaX7sJIh70lua/6UcuM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.61.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzgfU3WSytFcIiTyzqlP8LRVutybfGQkQHGUmpeFu3+pgwpKJUBdAInwOvkUc6LqrttsHxQ4PYJNrc+6oP5FEZFkhiUXysRDpIJRQsnomxdicc4CZF6mW9yc9TUFc4yhHh5uFuasIGoaUVa06cADIcFxNTX1ZaKhpROXjCG6BwDhKvo33bKIaWoWjLNBAdxIHazHLIRbGkfU5KUBBv0PX7Q3aTeMlmkVrMtO+aUC2k5/6HQpDHw6R9jk/0Puaxodc3b0vZNYkjh6xH4sUGLe1vM4YVpTI2X5qX8CXSVm+w3b3HH1umMQYWTuYyhdmS5k69B95IHeanbcu6N79wMmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=axIWGB7kikz6XUee5pg/BjCdRWxN2XJMSzfHD1lDa6o=;
 b=XahZvUnjsLQ8hh/5nE/FuMXrdLOD/tmDkp0GAVrZy5ZFZY6P+7W/qYy7UfRunwxcEPc9gSt5snJsHfbF7xlqs1zBx+MNvGPyrec3b0BV0Gj4w8ZZreXQuInHIdzwJ48W9B8v8rpNfKQSa6dZNCOqOjq8KPMLYe8wxMC3swg1w9DkUYUdFHt/VHBGuTWxFkG7idg8CvU3yA4kocnPp9wff+9lSpQlAxiVF6boqDJ0n8pE7bbsnrCCU5TybjKs2+qZkSaOMBSz3d7cV6/RJSNvVdGIgyoKjuVeNkkpSTYEBsnCjdC6XGLro4fgvEcxC17nuoWOL+FLR6ueFU2Xx2q0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 CH0PR01MB7036.prod.exchangelabs.com (2603:10b6:610:10a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Tue, 1 Apr 2025 18:02:31 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%5]) with mapi id 15.20.8534.052; Tue, 1 Apr 2025
 18:02:30 +0000
Message-ID: <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com>
Date: Tue, 1 Apr 2025 14:02:28 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: cifs RDMA restrictions
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Matthew Wilcox <willy@infradead.org>,
 linux-cifs@vger.kernel.org
References: <563557.1743526559@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <563557.1743526559@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:208:52d::16) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|CH0PR01MB7036:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf58983-e802-45d6-5864-08dd71475e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3plWVhZTjhXeEpEdS9KWUxLYTZIci83cDE5Tk03VHBMcnM3ZHdNWXcrTWlL?=
 =?utf-8?B?NUZHazg2bFQ5cmxFcFhHRkNCRFJXRVkzakRBK2cxK1FvazRudmRaL3lSNjZs?=
 =?utf-8?B?dktFYjZxdCtiYXcrK3ZhaS9wYiswQTlzcm85S2dBWTY0cXhHREwzTEZxMitL?=
 =?utf-8?B?Qm0va3E0MG8xUFFVYmNuRWY2K05VazBwc2U4K2JlWEh4M0x6aXNpVU1WdC8x?=
 =?utf-8?B?TXE2OFVtQzBnT2NsU2g3OVBSY1l4Sm1Hd1dieWxic3V3SndsRHR2WUVSMnUv?=
 =?utf-8?B?ZVBTNklTWHFUN3VjZ21FSWd5MTZXUEJ0MjZyeDNYR1FnRnB6Q1FXbVphY0U3?=
 =?utf-8?B?NzFXTE1YSEZPeTUrR3cvSWNVdkViWnVtNG9zZ3crVjVkMjQ4WjZ5NDJIdmFC?=
 =?utf-8?B?cE41TnlodU9jejlNYUhsditacGdQRnI1TW9QNTF1Yy9wRmIyNmdFWkk2Skhk?=
 =?utf-8?B?NE8xWU1URUgrTGx2YmwwYnZTNy82YjR2MFNtMUNqWlFUUEw1Sk9RcTNFY1NV?=
 =?utf-8?B?Z3o1YURHb1JvaUg2S2JJcGRHZW5kbWZlbVdnL3BKYUQxMkVjYWVJbDVBNysz?=
 =?utf-8?B?bzRNR2VmN2tia05LL0dmZG5qTldEWm11bjlJM01DUVNhZk9kMjdDeHpwMC9s?=
 =?utf-8?B?U0VFbU96NDlVWVNrZjlKRytaUk5OZ0k0a2dDTFM1V1BYTnhLQTdPUXNRWW9I?=
 =?utf-8?B?eFRYVDRxY0habjlnbnhjTTIwQk5mNTMzbmx1YnFGd1YyczdFSGE1ekU3RFEw?=
 =?utf-8?B?UVNMQkNoSlJQZzhXMStTM1BKMUdvZ244UkF0TGUyNGZMeDJ4VjBqZHliTVNj?=
 =?utf-8?B?Zk9wTTkzbjZGUUxjT3FLbTk5V1JNV0NyMytVcDhvbGxFZVBuc2JXSERqUlBq?=
 =?utf-8?B?ZjczRmx5ZEhyZjNOeGlQcm5wQ3E2RmE4eHJuUjBweFNuZTQ4cElRZFJZTm1J?=
 =?utf-8?B?dE82RkZiSEowSkpHb1IyTUsxUk41T3ZWUG5oRW1meFc5cml1eDQ1dW9HaW1X?=
 =?utf-8?B?ajFLQjZ2cGQ3Y0N6S2RyeitIK0sxWU5QSlVQVnBSRVNYdTlHcFZWbnExbU1U?=
 =?utf-8?B?MzduTWxXaHEyMkFnL3JpMUpUQ2s5aVU3MXpLMzkwZnJ1V2NkV2F2LzZ0b1px?=
 =?utf-8?B?S0hidGdoR1FOTVJUaExPM1VySWJRVHdhZW5hamg2Nll6WUp3WHBuOE8xRUhC?=
 =?utf-8?B?ZFpZaS9HWWMxMk1TUW5pdEhpZGY2SUY1UVpBQ2NxTGd2YWlJZ01qUW1qczZi?=
 =?utf-8?B?dVBXaEYxd0thQXNERlRvU2xuUDJPUXA0RlE3REFpTVlDZ1YvdmVURTdnVWNM?=
 =?utf-8?B?V2doL252dTc0N1lCNStYeGxOSC9MM20xbkV5WFlJVWsyU05EVG5PMGxzZTV3?=
 =?utf-8?B?aGJFYmwvK2FsZnRIWUhzbFB6WCt5TEVsNk81ZExRa3IxdDkxejBMeUNhTWZU?=
 =?utf-8?B?QkFBT1NhZlFVc2ZDV0Ricm9BcWxZeExOcG9mV0tmanhHS2hLUDFiV002OEk0?=
 =?utf-8?B?cFN5b25NZkEwTS80dkFaU2FzbjUwNG9oR0x6TmpTa3J1aUhWSkpRUU5ndklk?=
 =?utf-8?B?UnBRK0svVm9iZzh2RlBEVEtJc0hmMkl5ejEyOHcva3FoV2NhbjI2dC8ybGQz?=
 =?utf-8?B?YVRsd1NiWFZhMEE0T2NURHFOa3k0SU0wY25yT0t2MW1Tb2dOTzlhU0lBVVVH?=
 =?utf-8?B?RjJscGMxR0dxOGhtdWNabnFWNkJqQzRMSnJ6TkhIU01TTk5Xenc1WG9NbTdJ?=
 =?utf-8?B?VGF4cFVYRVBySFhZY2xhTmkyWDdxTnFuQ0RrMC9RRG5zWlJ1d1oraDJmeHBy?=
 =?utf-8?B?YWxidHYvWi8zZDIwVk9uNE9pZ0hacjR6cTZZZWJjQlJyeEdFTEZxV01kdVJR?=
 =?utf-8?Q?TaWj+5BytDSYc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlJ3a2o4Q2QrQUVRWnlwblFNTUY4VVpTelhrL3E2K3o3VW1UQUpYSFI3RTFJ?=
 =?utf-8?B?RXVZb0o3a1k5UmowSnpZbTIraFNxanNiM3FlR0dodWtHYmNGamFOS241aXVv?=
 =?utf-8?B?eGRxczhqL09XQlV1WDdvN25ybWpBZWkvTHplcmtFMnRscmlmK0YvRjJRS1pU?=
 =?utf-8?B?RkI0eHdaQ1I5MzJHa1pTV3FHYlhxdlZFTWdiNDBLd3ZsWTVKNUxlckc4SnJw?=
 =?utf-8?B?cm94ZEg4Ty9qa1dxNG8vVmNSVDBDcFU1T3ltZmppZ0lTVXgyQ2ZTajdYOW1Y?=
 =?utf-8?B?WEpKVVFTL2tYb2lMVmZHU2ZjR3B6WmV5SExQVUhXUVhaN2N4azhXaFpQTWcw?=
 =?utf-8?B?Ny94MEdGdkpEM3BXVTRWUDk4SGNrRERVNXloTGtnMHdXLzlYa3dmaWNyWEQr?=
 =?utf-8?B?cWZkRzA1RzZmL1ovRnVnY2Q0bXhWbGk1S3h1R29ZY3ZvMENVNzczK1JFQS9K?=
 =?utf-8?B?dnJwTmdhWkNPL0pCK21tMi9yUnhjcWoxYVZBZ05kamhqWkhnK1phMXZEZWVZ?=
 =?utf-8?B?ck1QL1dtWWxpSWMzMnp5azl5c3VjeEVWOUpUSWZLQ002TzF4eHJZb2UrS0VR?=
 =?utf-8?B?b3UxTUM2dDZ0UnlzUTNEVUFZOS9mM2hPVUx5dXEzdEpXeDZpK2dyd0VUOVk5?=
 =?utf-8?B?c2V4REl4ZHZGOUlEbTZtTHhETmxhSnZmblZVSHUyMTNpQklkSGU2ckJMZHI2?=
 =?utf-8?B?emNWVUMyRVg4ZlpmUnVtR0JnUURpbUdtTGhXKzB1cHFMS1ZqVWd0S21oUFQ4?=
 =?utf-8?B?bklCZjNBTUVZUjlPTTlsR0pSREZ3WHhwaWQ2bU8vYmZuL1B2Qk04MTF6SWxh?=
 =?utf-8?B?RktxVlNlb0RLS25YNjdOSVd5TFlHQnFSaDZNVElPUUJ2cWZTNkNvL1R2OXU1?=
 =?utf-8?B?elI1L0VhQ0E4WWl3U3lsZ0ZIUXZET2hTME9zZzFDVTBvMzBrYWJacnBGM0xi?=
 =?utf-8?B?N2MwRkxtYkRNNVBkV01sRUNoOThGWnRmWTludzFpaUZKOE9SdGk3WGJvODJ2?=
 =?utf-8?B?Y1VjRnpQWkhsWW5vaTQ4M29wS0FiNTNreEg1UHFTMHVzcjlsV0VsN1pNMmc4?=
 =?utf-8?B?VEo1d3VMN2dYTHFITXo2S1ZNdk5kK1pNcGNQNU1WOUhaV0NtQzBMdGV2ZGxK?=
 =?utf-8?B?a1RLOFpJbzh6cCtJQTAyQURtNloxUDV6bUZ4Zk9LUHUrcmJtbmZ6VjEzRHRZ?=
 =?utf-8?B?REx1V0ZyN1ZoQU5IR0pQL0pELzhCVjRYQjlFUUNFWEFWZXoxQzRaRkVXV2Ro?=
 =?utf-8?B?b1BjTituM1IweEw3RFFJSS9NR1dDNTR4b3lZUUpZKzM1UjZLK0RPVUZWWEgy?=
 =?utf-8?B?U0FuS2lxSlVHdG9WMlFhWTVlTUF1RGNZT2wvSi9oTk5aK053SnZ2VUx0cFBU?=
 =?utf-8?B?dEkrUWtMZ1pWeEhTTzJQUlRBeXZ0YXc2S21Ub1cyMjhYYU9xTWY2Y21UV1ZX?=
 =?utf-8?B?YXJLakMyaTdNcUZNeUhWUUdmdjhXMDNELysvQ1hrQlhwa2txNFd5TDdkT0lr?=
 =?utf-8?B?RVY5RGZibDdGY0lIZHdGbWlQcnJEaWVtRWNicVpvY2o2djhHQUhqN0V3Z2Fj?=
 =?utf-8?B?Qkg2UUp6VVVVVE54Z0U5ZHRTTk9PaVZLMUY0eHBjcnpKTUE5WmFKVDE2MVdt?=
 =?utf-8?B?SHBmL3ZmYjVEWE51TjJ4d2pLUGEwaDZlQ1ZnMFd2WThrK1luVUIrNXpsdGVj?=
 =?utf-8?B?K3o5NkNPU3dxQVhORWVFaDhpUS9SV3JNRG5rcHUrV21RWHRqL3NKSTFCclVk?=
 =?utf-8?B?eCt3U01lSjN2Q3RPUzJPSkpPS0hENU5RczlzUTZGNmIxaDl2OEdnUElDMGNU?=
 =?utf-8?B?dUdwN1FUbktPOGx5WXdxRDdsUVpJellzZnhReFlDV3JLVmNVMjhNalp3dk9w?=
 =?utf-8?B?QnNhK0Nycmc0VVFnZmVPRmxLa3FoeVpaQjVhblJ1eWE1ZTQxYXl0QU5ycVlF?=
 =?utf-8?B?SHM1QnBUZWxOLzlsY3N1bVRhKytOTGJzbjZuRW1RVzNvTExGYVd4OElSbUVy?=
 =?utf-8?B?RXZHVmtEbkQ3SVRTMm9BT3ZBbjBKQzMwZHZFV2tPeEl6akVEeXlYb2M5aE1E?=
 =?utf-8?B?Y0gyL2R2MGxXNi9TUWsyUGRBWnNkRi9XMWswS0hQYW1CS1Y3ZmNDQ0U3cGhV?=
 =?utf-8?Q?UB/k=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf58983-e802-45d6-5864-08dd71475e68
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 18:02:30.7801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wSXETCJFW2UnaaWJsGubPPKkfw74AbwEzIjK6XdD+4YknFGFNfFgYXNfffRrt49/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7036

On 4/1/2025 12:55 PM, David Howells wrote:
> Hi Tom,
> 
> I'm looking at cleaning up the "struct page" instances in smbdirect.c as much
> as possible.  Can you tell me what are the restrictions on the size of a
> segment attached to an SGE?  For instance, by:

I started typing a long answer but I ended up not sure of the question.

A single sge is just a hunk of memory that is registered with the RDMA
provider. The routine you're quoting is generating the dma_addr that
the provider (adapter) will use to access the data so it's passing what
the ib_dma stuff wants.

The sge *list* is more interesting. The first sge can have a non-zero
offset but anything that follows it can't. Such a "hole" would require
a subsequent registration, yielding handle(s) that might need multiple
RDMA operations. But it's the caller of the routine you quoted that
figured this out.

I'm going to be testing at SambaXP next week, by the way. If you have
some code, let me know.

Tom.


> 	static bool smb_set_sge(struct smb_extract_to_rdma *rdma,
> 				struct page *lowest_page, size_t off, size_t len)
> 	{
> 		struct ib_sge *sge = &rdma->sge[rdma->nr_sge];
> 		u64 addr;
> 
> 		addr = ib_dma_map_page(rdma->device, lowest_page,
> 				       off, len, rdma->direction);
> 		if (ib_dma_mapping_error(rdma->device, addr))
> 			return false;
> 
> 		sge->addr   = addr;
> 		sge->length = len;
> 		sge->lkey   = rdma->local_dma_lkey;
> 		rdma->nr_sge++;
> 		return true;
> 	}
> 
> Thanks,
> David
> 
> 

