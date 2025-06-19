Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2105.outbound.protection.outlook.com [40.107.94.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44F30E84C
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.105
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750360044; cv=fail; b=pEZ2LIPX7yPhTQN8uPO9sa+k2V5RRPTypEa4rTkWDgxgqsus26oAvg+0z4rhLiZh8KX+Foc0sQen3Yei36GkfterEY6Z8LQXtB05F6m009G3+a2wndpb5GnsJ6CoGNPcqScWUQSN7BuTcDZ6SHw6pIAtdsJwH088R5URHLJGhao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750360044; c=relaxed/simple;
	bh=n9leiomZCOjcSqQYTjlupH95m+yIn6zcfgb+luLCVhk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=q/QZssj0GXqAGUEB8nLiertn4oWIdSRs2rcWigCBWPZm/PUp/MHRMsA/i+10Hv/2fjdMEES0EJGc16Q44XnUt72XUfK6cg7ByoyCg4onGEKfHBqiajM4DZUeaJycLTuPhEAEPddiQ1/G1nqRoNTPT1mJhXzPxKDKp/+83cya9gg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.94.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R9MXM8XMruo9p6CCxaxXBIwzzCFbi9UqLs4dMkM2xa29LreM/6ykZ9bwSXWtR0JrKLEWHAunYwQVLg1ORTXFn9FgDd5rdGjEw6XKflb/aYiEV/oE3u5hvcENhorBpYWZ/+vmVWUq8Dqr5PBiafB07dIq5UWkweOgw/EqX5a2OIhjGdydBGEtQmKxCDv2prVHWg/dhqdShHyqn9DBHBCJXJ67qvei8uEOzNgTkZkujgmFwq5g3C2hd+JrG7046J1Z7Y8yd08KMyjahFj9IRtoqIMr71jAib33oZCNocV1n5v6jgIIlw56qWMGz/aAQCOrUulErYwZBCJCOxszZ8EhyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iivHtSbHWNod1/WW9IIoUrtsszV8e2U3RRI37o+f9AQ=;
 b=W35DuYisDcyKjgLRwOaBf5xAl1GZTzDPp0y3S6+5hV0z9AnpFX4qm+jQwdqdGj1AodDBZuqqDBHV+UFrimPWMwZidFuCzK8KXONw+NkI2yGba5+GchEF8/sMqhE/mCzWxTxCpNOB99Q6l5h4s8PGgnnvrJzkEIevxM6DTvl28Lm4vkudL6vBi/rIt6nYl65P+mS0xDyb/uOEpj2vpUZ1L2IdLBmHBciLtGqzMJ1DVegrB4SrCjBrTiKJbxSdwlGuvsvs/4ZGelVyqMWOOgBFCObb4L2QdfBJ2IguKCvi21e2cVsYfQKoAQ4OFIGVXtpYnrB1jDpkJp8zlI9vGpAC2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) by
 CH7PR01MB8836.prod.exchangelabs.com (2603:10b6:610:249::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.25; Thu, 19 Jun 2025 19:07:19 +0000
Received: from BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106]) by BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106%5]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 19:07:18 +0000
Message-ID: <d7c68796-8c7b-44e4-adba-d2a6432e40a7@talpey.com>
Date: Thu, 19 Jun 2025 15:07:19 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] smb: client: fix max_sge overflow in
 smb_extract_folioq_to_rdma()
To: David Howells <dhowells@redhat.com>, Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
References: <530e18dfe16eaba6fb66d9d8a9a93d50e99f5c1c.1750264849.git.metze@samba.org>
 <cover.1750264849.git.metze@samba.org>
 <850217.1750333313@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <850217.1750333313@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::12) To BL3PR01MB7099.prod.exchangelabs.com
 (2603:10b6:208:33a::10)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR01MB7099:EE_|CH7PR01MB8836:EE_
X-MS-Office365-Filtering-Correlation-Id: bc67486d-a2c9-41bb-53fb-08ddaf6482dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q01pTW5SeTlSWEdNL1djcUJwUnU2Vlh2aUszeXZabGlDbVVzbFdSUkYrc0c3?=
 =?utf-8?B?K2dDSHVITjZ1U3dLczJSS2JsczRyZTVFSHdjMWp6SjE3SEVHVk1oNEYxdXJC?=
 =?utf-8?B?Q3ZFV0hwWjZCRkcwaXRKWWZtK211RFc2REZWQmFHcWV3Z0pHbmpJVkRDWFhl?=
 =?utf-8?B?TEc2NTJYVlZaS0J6Z0lNM2s1anZRMTM1a08zc2kvbjFKWVV3NU8xaktHUTBp?=
 =?utf-8?B?bWcrL2p0NWJEakttMmYzODBHYjVPa0c5a1ZDZ05rQ2xqUk5XSUZFYXg2Kzdy?=
 =?utf-8?B?TmtXdEk4QWUyUGFtSEZWUWZ1akR6R1ZRM2tWek9EZmJuK1ZHUVJuOW41M3g4?=
 =?utf-8?B?aG9La3luRURkNHlaT2sxQlNFRDRhZXpYNm9hTE5KTFUzV2I2dnFxOXNhRUov?=
 =?utf-8?B?Qmg5OC9reU14b2d0WjJZZFZ6czllaUFoN0NyNUkxclZKTlNGVjlFTms0TlJn?=
 =?utf-8?B?d2F3MHVGNVpRWS9zOWFPNllKSzlVbExEdjNXZTdvNDVSS25MN0pBQWJiUklJ?=
 =?utf-8?B?dks1OXMrNUlaTzJqOFdJZFFseEowWC9GZjFYdUxoMmVDY0dMWHhKdlJEVDFj?=
 =?utf-8?B?R2k0b3FvN09pQUplZzh2bjhaY2dsZVpnYUphcFlxU3lCTHlaU2I0N1Q1VWw5?=
 =?utf-8?B?MWw3d05CbnltNVNjdkxWRGFHdVhRZGlQMjZyeWlzaTVLNUhxRlBkcmNicnhM?=
 =?utf-8?B?NWJPKzIrVTZacjZqUDFhYUpYbHNMRUxHbUh6WXQxNTVoemxvc05XeklJTng2?=
 =?utf-8?B?YzVLaEFZVXdqeHV0Zm4rbWpxTGJNNnd0MTQxRE5zZFhCcTV4SW9RbG9TeXRv?=
 =?utf-8?B?YllQMWlmVTRsMTdRVEtqbjcyU1oxN3FNMEMvZ0xPVEVZSUFCZ2dKN2dyODY3?=
 =?utf-8?B?eVJ1MzhnQjUzTUpDaFRoM0h1NkNVeGl1UnhxMWFsUGVZdmVkWVI1ZHY0QWtE?=
 =?utf-8?B?eVhWVlZJQittK2gyVXZVREh5c0ZlUGdzS3dSOUZFMFRNZEVVTzUxdjVRYU9V?=
 =?utf-8?B?QW4xRkZVcnFsalpKdWYrQ091TWpBNVVwUDJOTWkwUlVpNmtaaTBZUjAyVDkr?=
 =?utf-8?B?SHBYNWhKMytoRzFnVlM3UXIyWHFqU3dkZk13YnMrTWhaY3huWUh3Y3UzVzlp?=
 =?utf-8?B?blU2UjBzTlBVdnJUaDFKaW1OMlVPNVcrc1lmNUk3SXcvR29lcVI1VUcycHRt?=
 =?utf-8?B?djBrZjdjd0c3Vm80alYzTXNxYnRYRFN5Q1hoSU1vOU9DQko2L2V2SnFTcGEr?=
 =?utf-8?B?OEIwaklQZmlDbFlWOEdMZVBZeHVyTGRVWW5MZEVTZVhyWCsrdlZOZ2YxaUMr?=
 =?utf-8?B?a1diVGZzdlBJVk9wamlHUU9HQ3ZaYnVwS2JqRkltUkV6ck0xZHcrVlhIUDJM?=
 =?utf-8?B?VWt5ODVJbEdXcW5WekVIVy8zbWNVZnpobFBsY1I5NlhnVWptL0ZoVW9WejEv?=
 =?utf-8?B?NjJoOVQ2SUJQMG9hWU5aQUtPRitRdlJJM0c2ZDNKMTN4ZUxQUUluMzhEU2Nz?=
 =?utf-8?B?ZmlTRXRra1pLbjA2cE1JblF4NEdtVHphc2VleEhzQ09za085UDNjWUtmcTRt?=
 =?utf-8?B?WVNYUkdEQnRNRXo5WnltQ0Jzd2FPTlJoN0R3SjRKdjh5VngwTXJSczhtYjBY?=
 =?utf-8?B?TFZIMk9BTklyM00wejkvN29CV3Y2U0NlU1lLWTBaUEhKY3ArbnQvTE9OY1Zq?=
 =?utf-8?B?cmlqaEgxcFMvaHZWRk11ZXlOQ3E4OHUvc3hSd3F5WTBYcm45TmkyNDcvbXk1?=
 =?utf-8?B?RzVUNXBQa2R4MVZYbWRHSWMzRUZwVng0dTJDTTNoZllsNmFGcmR1R1JVS3Fr?=
 =?utf-8?B?UXdTRDFmMFhCdEJRM2FIKzJycURBV09VYURobEhWbEpWTlhCZHdSZTJiNVhP?=
 =?utf-8?B?N3FPcnhqUldQU0VzdWdENmxGaHRnb0U5SUl2eEZjcEEvREtnUDJ1b29xOW9q?=
 =?utf-8?Q?B9jR85R/OZA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR01MB7099.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnZLc2R5d0Fhalh1cTY4Tlh4SG40UkFqUGNPMDlXVWxyVTBwbGI2Y3V5NmtT?=
 =?utf-8?B?b01kVnVWN0JHbTgxaGRWZHN6M2dlNmRPSm4zSE56NENUMEx5S0x6UDUvNWx1?=
 =?utf-8?B?bnBhK1B3ODNwVFN0YTJ5NWR6bmZRZkZma0VwUVFMVmE2STNjMzhuaFlNS3Rj?=
 =?utf-8?B?alhoREo3WmZLejgzdlowTUVPdkNEVE41KzdmOGFiNlkzcFJJYzN1TTZ4TUlZ?=
 =?utf-8?B?UWhVcDliMGF0VjByb1JSLzVYcHdCd3ZGMkdlTGpiVXV0UUZTM25DRGZuKy9G?=
 =?utf-8?B?dXd0ODRyWHBXNnN3eHhyZGlrbnVzd0w4OVlTV3JFU2d6UjVFSFdsZEEvb1Vy?=
 =?utf-8?B?bys3SmFhUUUvSW95TXFQQWRDeGJPeFRtelZjaDF6U0hBbGk1NW1DTG45RGJz?=
 =?utf-8?B?dVZrMlZId3ZUU0hsd2Jndjk1NmJTS1Q2SGo2WkxnUVBwSC8vbzUxNmV2dTI0?=
 =?utf-8?B?ZmNmL0t1QyszbzRLWUxRVXlLdnF6dTBwTU9uN0tMcmd1UkZXbmJDR2NOSm11?=
 =?utf-8?B?NWJpT0l4S1E2WjVwOWlWVDRjTTNFYmFsQUtYOXBJN2ZjSURNSElmTy95bUxs?=
 =?utf-8?B?ekpjNGZ0QmFNSFRLWDVFMm14ZFJsOHphVHdPUG1PeVBza1RPV2c5OTAxWkpS?=
 =?utf-8?B?NmlsYS9nZjhKNzFDMXV1RFNsOU5SaTZWQnBKSk44TExHelFTaG0ycGxTaU9a?=
 =?utf-8?B?ZEhlM1BHZjFweXJKcC8vSkM4Z0d3RDV3WlJxQytuYzlsY0UwWGg2ZSt1aHV0?=
 =?utf-8?B?UUQrTFFldDMzOWRnSVZ3VzBvRGlOU0IzTTYraU1JdGh6M2o5dkdxZWhneDZJ?=
 =?utf-8?B?WG5XN1o2THBlaytvZnBpNGQ3aGNsQVdZZVh3bFE0Q2RtQ1FyekVCY1NManR3?=
 =?utf-8?B?aWhwbTRDeTQwdGNZemlPZklFOGdsV3p3V0x4aHFaZ2pDS2trVzBYVWJRaDJL?=
 =?utf-8?B?WlV6dHR4dHVMWTViMkEzYWRVWkNsdGVLZHZWQXN0c3gxVGU1Z2cxZERucE5x?=
 =?utf-8?B?RVR2MVQ2VzZ5dGhtdUI1SUlSYXYxdkRrZ0F6SjU2M3AzRVVNd3hhSkZiQ3lx?=
 =?utf-8?B?T2NEQUhteHdCRVNwanlPbVF1cHRRWG5NRVU4aGVoUDlpR0NNK2lGejBmaXpU?=
 =?utf-8?B?bFUyTDl1UWJ4OXp3RXNVQ2hEOGVHQWlzU3B3OElOK1dkdXRNUHNVQnBzdVVN?=
 =?utf-8?B?V21mTmNFcW11d000bGhHcXVka1pNS3c2K0ZHU3V3aFRYcUx0UFhmYzBrT0dQ?=
 =?utf-8?B?YWdCc1Y3bzd1OEY5a3RwZEh5UzBia0lIZVdXYk1rWWJHbzBYMDBoYVBpU0lq?=
 =?utf-8?B?TXlHNGFnd1VGbHNPTjVmV3BRK0U2d1NPN3RERjJHTXJ4NktUYis3d3owYzRy?=
 =?utf-8?B?QmxmbFAyd1pYbS92TnNCOERVaHRqTzhscjdkR0xDNnFabzY3ajFhV290L2I1?=
 =?utf-8?B?dmRYWURGZGdMR0pPaHluRjJZOTZMcHNxSGJWcDVyRHJidEt2Uy96V0dNVXhQ?=
 =?utf-8?B?UkJ4aTB1SkpaakFDa1VoRzA0aHdYTCs3RlJrdDFFVnU4V1hzdlR3QmpISjZo?=
 =?utf-8?B?YzNvbHhCeVVlR3RvbVYzbmV5TWtMbUhDZWxnTTNjZkdLRTRDby82MlhwbytN?=
 =?utf-8?B?LzNQMUVEZHJZNGM0Z1Bkc1lvZHpWcTlJSEQ0RE5zb3F0ZlBBK25PUW1yeis5?=
 =?utf-8?B?N29KWFZUOFlpOGEvSGFQcUs1MmJBSWRvcWhPSVdETlFzL0JlczZjUmNLOWxv?=
 =?utf-8?B?Q2NBUjBEZDJCcHk5TTYxVW5YVUtISWo1bk5sN05oeUVSSk8xeGpZOUZYYnVo?=
 =?utf-8?B?OVp6cjd4MFdQNUc3UkJmbFp1ZzdnaXN1ZC9EQTdYWjAySHpyUjJScnBWYUlh?=
 =?utf-8?B?SFdMMUQ3SVhEUzFuWVcrazE1VjdpazU5TVNyU3lCa1NwejZHNE4yQytkeEk1?=
 =?utf-8?B?WEtHbW9IT2ttYlExMmlrclczUHhPZFlqTkJZUjhnWDUzcExkMmpXTmFhM21n?=
 =?utf-8?B?R2dLcHhMemloWjhDM3N3RDI4THI1UFBOK0ptY3VvTFpmLy9PeTVaVkxKaHY1?=
 =?utf-8?B?NDZ6OG9oRzZKanUvS25TcUJxQ2Rud2pVSzFDN0puYmFCdHRXZ2FmL0xZNTh1?=
 =?utf-8?Q?6cSQ=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc67486d-a2c9-41bb-53fb-08ddaf6482dd
X-MS-Exchange-CrossTenant-AuthSource: BL3PR01MB7099.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 19:07:18.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: va1YOUpeoWuNzggn4DOw/zTGeiRpxxd6ND//Q7e6zzm9IJL9Ef75vVs1RNUn436C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR01MB8836

On 6/19/2025 7:41 AM, David Howells wrote:
> Stefan Metzmacher <metze@samba.org> wrote:
> 
>>   		if (offset < fsize) {
>> -			size_t part = umin(maxsize - ret, fsize - offset);
>> +			size_t part = umin(maxsize, fsize - offset);
>>   
>>   			if (!smb_set_sge(rdma, folio_page(folio, 0), offset, part))
>>   				return -EIO;
>>   
>>   			offset += part;
>>   			ret += part;
>> +			maxsize -= part;
> 
> I don't think these two changes should make a difference.
> 
>>   		}
>>   
>>   		if (offset >= fsize) {
>> @@ -2610,7 +2611,7 @@ static ssize_t smb_extract_folioq_to_rdma(struct iov_iter *iter,
>>   				slot = 0;
>>   			}
>>   		}
>> -	} while (rdma->nr_sge < rdma->max_sge || maxsize > 0);
>> +	} while (rdma->nr_sge < rdma->max_sge && maxsize > 0);
>>   
>>   	iter->folioq = folioq;
>>   	iter->folioq_slot = slot;
> 
> But this one definitely should!
> 
> Reviewed-by: David Howells <dhowells@redhat.com>

Agreed! This code looks to have been significantly refactored from
before, it used to be a for loop with the max_sge and maxsize tests
inverted as "break" conditions. The || went lost in translation
when it became a do/while termination. Looks like it happened between
6.11 and 6.12.

Reviewed-by: Tom Talpey <tom@talpey.com>

I assume the Fixes tag is appropriate for the 6.12+ stable kernels
to pick up?

Tom.
