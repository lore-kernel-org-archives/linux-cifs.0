Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11021113.outbound.protection.outlook.com [40.93.194.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B537DA6A
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 19:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743622584; cv=fail; b=f6io8yR+ppNDaHEg+w6WueW/m2LfdEs66IZgpFlxOog9GzJ4w5kPUx8woHhw7H6otVcbTYkrpz0nXb5/3hJDUfGDG6l215tcoqO8KcA3hr+zoMCZA+S2LExs5GJYKsAC6+f5UnxuQ9XXELGQVtgX9MT/zTPHVZEMvO+U6wMomx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743622584; c=relaxed/simple;
	bh=5wJlqwVCe1pTM7c1qzqhVJ0uZloQNlnU46PY5avoiOw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KjhrwfQOZeenIIYnH+3/wkO9DSOPs9EpSm707AmQShH1Ji8KJ8nPpNcyHwQZA9YfaQkdbXjV+6EW6dWDZ8c5Zq6BDCHPcV5Wy9Q7+K/y77rDKmUQft/cqOpi7uyf/PeNineccLMk73Dvnu5MxY5FvlXYntSrKDaygo4Gvgwcp6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.194.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AX5bGxISIxqOWoe5sVHN0ZeJHHyaD+fzmh3T/4FoYjUpH8cDnuErYVkc3TxGJI5DWvnQrVqCOAQ4kTer5cOblYIYkm7mViEVxKrQx4BkcfnQLOnm7sSCp99Ya4wvLJAWFkCDH80Ip6OaZsuJszDRjPKw5e5Q4+K+hGIacZS8xBZXf+Ph03syyVv4BEErIq5BafJPKFlxVeZhGMdJjSqNBM8OwOJ/Y1+v+oNjx0IeIyQh2/O3Oo9F9TZv5NnzYgWD8jzouI1wAF4yW/TWqyaQDz9jxdwnGZwevnLXBn25omvi4ki+rZ+AivlY9qOeeZ3IZ/uvbmETwgByi+nk34E0Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+G+DgMcM4Ls7ZAefSBtqjEAV6IjXLTtte3DkOw3LU0=;
 b=iN4WJHy0RKaxFQXrTdWha7ungM+R4TeYLeIYToKHu0dUDPaRlrHxRMTEuDQXuvIYOjoJr4Givdh/UjHx+0ATRUsodMbRgPELmGgG2emuniKfCeXtQywkEw0MOYXDamiy/OHwKqGEBUwTZC2heaOxGiT0xp+6+W6Ev7dkRNUqGEnPFo2hxWbYxGy0L+HNAE2BCtXzs+zDNh60w/F14i0lCXlvkIsLS/xELhwIMyyJgocubOYfI4FYFterYMlFIpudVn2NHh0E6Q349AvnPKDH7+1kRDwmMExIwpnQy1b1E2pWmStrJ26YWAYlnTmpghEBDWstUt76hBQgkLxJqcIJ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 DS0PR01MB7890.prod.exchangelabs.com (2603:10b6:8:140::20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.54; Wed, 2 Apr 2025 19:36:18 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%5]) with mapi id 15.20.8534.052; Wed, 2 Apr 2025
 19:36:17 +0000
Message-ID: <49b8b758-2d72-4de9-b0f1-dbf9a7124cdf@talpey.com>
Date: Wed, 2 Apr 2025 15:36:15 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: cifs RDMA restrictions
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>,
 Stefan Metzmacher <metze@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Matthew Wilcox <willy@infradead.org>, CIFS <linux-cifs@vger.kernel.org>
References: <b8dbed47-8824-4b3a-b373-061e139ee7a4@talpey.com>
 <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com>
 <563557.1743526559@warthog.procyon.org.uk>
 <659109.1743536087@warthog.procyon.org.uk>
 <7e1fc71c-2821-4294-833c-746c5fd7ee69@talpey.com>
 <803441.1743613785@warthog.procyon.org.uk>
 <CAH2r5ms2J06tJr4VEVDgmcj_1uqOnhYzbC1ybrMWDm=f8wVDoA@mail.gmail.com>
 <843601.1743622017@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <843601.1743622017@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0305.namprd03.prod.outlook.com
 (2603:10b6:408:112::10) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|DS0PR01MB7890:EE_
X-MS-Office365-Filtering-Correlation-Id: 352e216e-8bcb-4085-e50e-08dd721da363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cjhhY20rWGxmVHljRmIyY2E1RzN5S3o5cEV2V0JzNWpGa0JpdVNiSXpBR3BJ?=
 =?utf-8?B?bk5BUC9FN0kybUJ0RnVXRW41RFJjNS9XNnJmaW44RTFTa1BzaFFPdG43Zmtk?=
 =?utf-8?B?SEszVDU0NCs1NnJZNjhQLzd5aXFldy8zcHJhcmdUVmlGckxSTWNrR005UGpm?=
 =?utf-8?B?UmQyUEpGMHpyNXZmbHphZXVpZG51Zmk4eTNlUkI1bHd2VUEzcHRpOXNPZ1pv?=
 =?utf-8?B?UnJpdXJVR3NhU2ZMUDhhaHJDZ3pSTHNHK242cTJORDcvUDcwbzhDaU4xb1dK?=
 =?utf-8?B?NW1Oc2xGYk1ieU1UemtpVjVlQStrVXZtcGwzSC85V2FESFMxdTk3cjQ1YVYr?=
 =?utf-8?B?ZUxINDk4aHgxTHUzbHZoK1E3NGg3WFVKZEhOSFp3V1RTMzlwblJLQjYxL3NC?=
 =?utf-8?B?dExGNk5QeGMxNXJNajdIV25HK0ExNFJUbmljWldNSCtDSmpTaFZrRXowaVB5?=
 =?utf-8?B?YUhpVmhqekNiTHkvZy9RK2p3MnB5a0FDcjJxUktpMzF6UWlLOXI4c3VEUzdI?=
 =?utf-8?B?UnluTEJjbTRwSUhZN2NWRGF5eDRaclJDWGlQYnkzaXBmRVhjd21DWkJvbWln?=
 =?utf-8?B?eDhjbHRwOFNkc0RVNmZodW1tOEl4djR4eWc2VXZ6UCt4elJJYnVGWkRmenVw?=
 =?utf-8?B?bSs5SzJhOTFpZ2x0WFlVWVNrRWhOT0FGeGh3MjBlOVBGcC9LMFVobWRnQTBE?=
 =?utf-8?B?VGpPVUlJdnR5dWxKb0dXclV5c1RNRFdBZkU1ckhCMjlhQ3drMjBPUWZndFRV?=
 =?utf-8?B?RkxLVlg1NnlJZ0lDelAzSHBaMEovQ25XTXJBcDRCVHljeVlsNWtQVDYxY0NP?=
 =?utf-8?B?dXRveVZ4eUM2eU5wZ1N4b3BKd2lOSGgrRnk5S3hyNHNkc2o4UEtFRXNjM28w?=
 =?utf-8?B?Ty9RTWU3NzVqU1pUSFcrRHRoZUVTbDBFemtZdkdXZmpaYnZGRy9ST2tFNit1?=
 =?utf-8?B?bTZDMDZOVmZ6Q20ya2pSdVVIWlNEVUIwQTgyN2dUbE5nQzB3WlROaG55OGVk?=
 =?utf-8?B?Y2hlZGJGb2pabnlrcTREN003eExjR1R2SXN6dVZDYkJPWGpGQTNmTVpDOW1Q?=
 =?utf-8?B?T1ZvV1pZU091bmQrU2M3UklmMk1BYkxXaWNEOThjUkZOaFhvQ0ZqcUNQbC9Q?=
 =?utf-8?B?SDlXQkhWREN4RlMyTXVDVGU4THBpZm1CcHFHNDFjM0M2VEd2bGQwM2VHODhX?=
 =?utf-8?B?RnZMQUladE4xaWpuTXFCeVA4VGwvRDhabUpsTDZTOVh3WDhUcUVTbnU0bVdo?=
 =?utf-8?B?YytCNUYyZHRsSzZNb2FrYnZMVTcyL3pEWk9BalMxTEhabU1ZTG16NUE5YTNB?=
 =?utf-8?B?VWVXRldaWjlYbWltZVg4Z2tNZFEvTWRlUnNGVDlMa0lOUUh5dnh6bWR4SnhF?=
 =?utf-8?B?eWF2ZExMZHhVS24rL3M3VVY4dVJMcW44RUNnM3FmcTBJQVZsU3pWZ2Q2T1dt?=
 =?utf-8?B?REhDTThyaUp2ZHJ6Vm1LN1h5TTQ3Y2xUYzVYaFBtYkZRQUZJTEhsMkFSNzlS?=
 =?utf-8?B?YmJHVGtHVDBydXpMNUFNck5LbU1kNXBpcEdlWGdsOTEvbTFhdFk0Z0lJcmdQ?=
 =?utf-8?B?ckk2Q29RcjdGckZXRUg3a2dZRy8zbVBaRC8wc0RQU3V5djFhMzRHWG9GOUE0?=
 =?utf-8?B?NDNweTIwS2t5eXM2ME02ak1OM2g3OUlIYTBZNUpsdXZsamhwRERDUytTanNB?=
 =?utf-8?B?Y1hzcDNBcTZSY3l5K1Evd20xL0tUREFMWjE1YVZaZUU3SkJ6a013UjhmcDRk?=
 =?utf-8?B?RDRHb2hHaVhhRTJUVHlNY1MyM2VvTGpQS0VPei8zTGRkNWM5N0crZzdmZ0xl?=
 =?utf-8?B?NUtJd1Q3T3ZNQmZybnpIeWpnb2tmcS82R3B1Wk1RUWFmMGNrUXpzdzNiK0tQ?=
 =?utf-8?Q?vbiPTmJ5ADTNq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WktmNzA0SVlpYUl1bkFkKy9JbVRUWGZDVm14d2dqWXF0ck5lOGpqMXlWRVJG?=
 =?utf-8?B?STdqdFNBN3NmZ1gzcWFjYnJ3WC9yRFFiRnpQUFE4NWl2d3ZDd1NORXE2TFdn?=
 =?utf-8?B?MXBRZCs3NkZ6OW02WUVmT2V2ZzdmSW10OG5LOUFUUC9Mc2xoWXFXZFMxWHNI?=
 =?utf-8?B?WVFZaWtrSGFZaW05VTI4Y2twQkt4OUEzTDRBUExLM0p3bUs2Zlk1a002aEtJ?=
 =?utf-8?B?bG1paU1vMjliQjJCbjE2UCsvVWJxSXg2SlErcVNFL0Q2MXVFSXF5RW9GU01Q?=
 =?utf-8?B?azdQOE9uUERQcmtuSEVFUUxSWGJ5TDhscWRhTEZWWmt1MWJNbFNzRUtEUE00?=
 =?utf-8?B?MUI3VjNDcmRtZW1jdXdoNUNMcGpHL1BoYklYQVlsQTBBenBheEpZdk9pMUxp?=
 =?utf-8?B?VmE5WFArM1BWV1g1MTlTNFpxM2hTL2JUNk5oUk9LMUZWNnlkK1hEZ1hEeWF1?=
 =?utf-8?B?Ylh6YmVGeEtqdkoyUk5JMFBGaDd1NHNFSGtEVk5EQ1JTVEtMYThSZTBUMElH?=
 =?utf-8?B?Z2J2cE05Snk4NG81WkUxVmp1UTNTZ0tNMXdkSmkvUThXOVhUcXptQUcrczBo?=
 =?utf-8?B?M01naE9KbzZtSVVvV0t4UWprWG1WODI4cUoxRVdRT2lpM2p1NXZONm5QT3Ev?=
 =?utf-8?B?L3kzODVnQmlWUklEUEIxdjM1VnQvV2dZV04zY3pFamVla1Q0d2ZCbm10Ull0?=
 =?utf-8?B?ZmlxMVNrTHU1U3ZLWDAwY2M0ZFVrTlFYeEhIc3dnMmtoN1Bzbi8vL25UOEFP?=
 =?utf-8?B?MWYvdmpCU2VDWmlPL25TQlZNdWwwdU51cXJQYTJGbjJVWVhtYXlYaXdPTjFl?=
 =?utf-8?B?SEMwVlJWRGZSbEJWU1VMTnVHY2NLVER3MnRReWpsbmMwOWdJNkxWNHpHa1M1?=
 =?utf-8?B?K3ZvNnp5Yll2SVhpVm9RdXltZE5YeFEzWnBBSEhOdnFvV1JOcEhLOEFjSUpr?=
 =?utf-8?B?MU5LSU51Um1FVnk5Zno0N2RFbU1BejJ4d1lUMHRHTWVtUkN4T0lOWlJTRlVP?=
 =?utf-8?B?YWxDUUVhOCtVNHJibVUxTUFFQ05YRzJlRERDWnNrZEIwK2FwVThIOSt1WFpz?=
 =?utf-8?B?UDhPYVJnRDlSS1AzMjJVUWZWMHUrYUl0RDM2M3ZSVTR1R05uYThKcW5oNWly?=
 =?utf-8?B?cDRwQkdSSmEzeDdNN2JKU2RqczJURFlmVVRNd3V2cU5mcW04VTdZQmN5NWp5?=
 =?utf-8?B?NmFXcURBeitlN2lqUExYUTRDQmNwdmpIYWZVY2tTNHNYTnlZa3I4Z3VRNFA1?=
 =?utf-8?B?ZVY0dmsvTSszSkdLUFM1NTViMFV0ZDE2ekdaTnBSMlVGaVR5SGtPaXYydzdB?=
 =?utf-8?B?V2FZU3FzME1saEw2bnBlM21BcjhvZjB5NWU0QTlZSHRqb25DbjdUWXZqR1hv?=
 =?utf-8?B?NVNsUHNKWTNMK2RlRnFjbm14VytGcmowYi8zZFJrRUxpYTVoUEpFUWRYWE8z?=
 =?utf-8?B?OHhpQUd1VVBaT0dtU2VuakdvblgxWnVjOVc0K0hRR3o0RnI4aTA5Slk0bWF0?=
 =?utf-8?B?VzJ6cTVRbytsdTFHblJOWUJMVmJaVzE1cTdqb0drZTROVjdUcmxSajBlUWlt?=
 =?utf-8?B?NDJTcnUvMnhUYXJXaUZHTFZ0R2lyYmZFWEozZS9hUzRSSWtMV3VVbUQ5WVdP?=
 =?utf-8?B?V3NxUkRldkN2a3NsQ01tQTZuVnJ0NVdWK2NxK1htQ0w0elZmTkY2d1REZnBD?=
 =?utf-8?B?MEY3Y0IrRzFrNVY5Ti9HaVV6VkdXcU9DcWxHckdSTW1wR2t6K3pGWjhkQ2xG?=
 =?utf-8?B?UHd2c3dyalZRaVRTUDNnNHRwYzNjTklOUWs4VmpRSiswN0xyOUpFdFJyVVhU?=
 =?utf-8?B?RE1KWndqd1ZQOEVJMXpiMHBobStoUFI2UExLOVlNUTJlQlFwaXJjMWN4cEJN?=
 =?utf-8?B?SWd0NzdhZ3VIdnY2Wnl2enRzcFRYUmNCNnF3MDhwN05ZRXAwYU1YTUlHZ0F6?=
 =?utf-8?B?M20rWjN6WnVSL3dWRzZmaHZEdjlRbVU5Q0trODJaUUpEWjdHZndlakJyRFpp?=
 =?utf-8?B?SVJTa2hiUUVFY0h6akh6eW4weW9hZlVkQ21Db2Uvak45dkpnUGYweUt1bkll?=
 =?utf-8?B?eWVQT2dtNlNFK3IwWCtKZlpReUF2ZCtCUHoxSVU3KzB2eGpxTnZSZnhJVFQz?=
 =?utf-8?Q?MJlw=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 352e216e-8bcb-4085-e50e-08dd721da363
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 19:36:17.8893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xX14/efUF2S6W4K1WySuqKH6ewomQu0E0PBjCMGlW/LoHxSyXawuX/v7Ib7jLjT2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR01MB7890

On 4/2/2025 3:26 PM, David Howells wrote:
> Hi Tom,
> 
> Btw, in smb_recv_buf(), am I reading it right that it doesn't actually pass
> buf off to the RDMA layer, but rather just copies into it from a response
> popped off of the reassembly queue?
> 
> If that's the case, it should be possible to collapse smbd_recv_buf() and
> smbd_recv_page() into smbd_recv() and just replace the memcpy() with
> copy_to_iter().
I guess so. That code has been there all long and I haven't
looked into changing it. The comment at the top certainly says
it's something to consider.

The SMB Direct reassembly stuff is the non-RDMA path, where a
message payload is too large for a single ~1KB datagram, but
was not registered for direct placement. This would mainly be
fsctl's and small reads. I wouldn't get too worked up about
highly optimizing those.

Tom.
