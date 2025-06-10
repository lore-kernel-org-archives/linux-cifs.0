Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2133.outbound.protection.outlook.com [40.107.92.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF9211A1E;
	Tue, 10 Jun 2025 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749569807; cv=fail; b=fZ7iZOvzDDUziCazpE5lx0GH2J5nwV7FcjPKWjjCJeHZ2W/ubqowLVj1ZJGTbq6APbeCAvSjydWi/VZ0PF6jJiZPxt7U/jk85aInipKF60BOd6vrWDt579/ohWvebIeAStZIjXtrcfq+ouw7VNVDPx53WzlfPwGI6XOXf/H/0J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749569807; c=relaxed/simple;
	bh=U0kELZWXqs+fgByrs91IBLEheLonhUh4ghSR7G1NJa8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0FLGzCZshfEvXFZKEI1t8yTWnDl+ul2EW/Fq8klmVLZ8fRgrJ4E2oAkcMU6Sw4Pn2QlxQpXzD6lMs++fg4uxMM2ScT7tt0Ff+5+DhOwbkAlpZrmajtFhfuuD02dL0OmHd5xL/rCIVWDn/zOry5g7wRnVkTSboeJ2oEUaPA3U9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.92.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKDUAXvSI7WQxbNIV6CZPf4QRhM26w2tJFVbKPDdb1CbmmElHoGQM/MQEifISsYB72XoNxeDfgwHb9eWk4TWM7vowdYOO6dHOw1Xa5p0I7gRQdlaEqBryTnGwUTRQP1P7B9d/+79TUVjopSPCfzUnxKZ8BsiVYw/y7Fo+yH/c5BlWi6eKpZ9EB1+6QY9dp/WEv0yND/8XcX0nY1KWCkdFl3NQzxpHqW31m3RsgbvD5S+mvkIfMzTcgg8iLCZlHUAVSeWqK6dbAYCwI+XY4fUthTJctaMflLPQv1MeB1b9Jl5+TFiDfeGJFZpNi8+ck/ujxzuFG642bp2gzExjfP8dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2ktkkXzCmcDkGI19WD0yymTyWVguarMpNAzc3LNCrs=;
 b=i89DHxJe33M5NTPR673DWyxc24pkNeHXGufjJAZUOVGFxC4RQFM+JUhOD21m85yJYCTwz8aV0Xq01Q0YQHAIK2/XzCPHlzeAe4remfYDRKLyAiCVAff/yKuKAoJWBdJfghLirBzeH2zdn1I3dk/0+sjWn85R+bK7g0XLCCFvDh2l7edQAn2fw+mjfng7HxFkoTv2r4TWf2ESAM9+p06JYT49AhrRxHLV2qgFw496bMixeZrYwDFro2+LO6X9Mlisq3N6vtXuESPIRjR1sHwWYw0hQrumZ9rbpjfDuwNiCxTau0theknMZb9YSQnT7+mPE8eNSLcUNH5aNeS9Iia5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 LV8PR01MB9356.prod.exchangelabs.com (2603:10b6:408:2a0::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.29; Tue, 10 Jun 2025 15:36:39 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%6]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 15:36:32 +0000
Message-ID: <ac80cb46-5787-4fc9-a405-fd38a505c613@talpey.com>
Date: Tue, 10 Jun 2025 11:36:30 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Show reason why autodisabling serverino support
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Steve French <sfrench@samba.org>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250608164453.6699-1-pali@kernel.org>
 <3d644c3f8acb3dbcef395bd96e7e957c@manguebit.org>
 <CAH2r5muuanOgjzQ8wgd+QoyrU_ZM4tATrfYYQj=b7MapGLMh5A@mail.gmail.com>
 <20250609073650.kj6lxrykguhb7nuo@pali>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250609073650.kj6lxrykguhb7nuo@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:208:2be::34) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|LV8PR01MB9356:EE_
X-MS-Office365-Filtering-Correlation-Id: d78d1bfa-2589-486a-6c44-08dda83493ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmJtSUZnUU9CRFBWWFk4NnBZZGpJaGJBdk9Ja01KcHB5ckdST1FrQllWakxO?=
 =?utf-8?B?K2xLeVFJZHVXeVFYZlgvRGRhaVYrTnIvemtHdEs0a0dxSUJPcmdreFUxdHQy?=
 =?utf-8?B?NEZObmRWc3FTcE9xZW5xVUxIMXhXdGdCbW1Xc2UvT0lqdko1ckZsajk2enBi?=
 =?utf-8?B?dnhRUFhWVXpSUUh3cGk0K09XaVZ3UFF2K2tEYUpwN3YzN1VqS0VQZlpVZTVT?=
 =?utf-8?B?QkhqSld1OURyZWxaTW1VeldLaUV5Y2lRRVZkZ1h3d1NUV2NzellkbE1sTlZm?=
 =?utf-8?B?cVRFMzlXSzhGcjdibzU2RStDanNmZG1qU0pUOEpGT3VvNk13YUttNGVKWjdJ?=
 =?utf-8?B?blg5NnNCS3B1Q2tjMjM2TU5mRnZScGNlQ3diMTk0dmZZRG8yTVROMmRGTW8z?=
 =?utf-8?B?Qm5iZU15SXJaTms5SmZVS0FTSXhzZEM4aERGSEVhd01ZSmxYV2RtOFk5SHFY?=
 =?utf-8?B?bXhDSmFVL1E3bFdCTHcxZmJsdUxnM2tXMElQUnhicG1jbmJ0UnNYUjhrb1Vm?=
 =?utf-8?B?TVA2VWNWaUdKTTNqOUFxRVdlNHdUVngwREEzY1paOGhQTHU3czJDRFRxV3BJ?=
 =?utf-8?B?bkp6TEQ3SG1vcWRnUER5N1VtUHN3Zk5tcHhTUGk3cWtucnY2VUhIck16Rk1j?=
 =?utf-8?B?S3dlSWtXRFFYQmhCWm5FVHlsb0M4MWxTaWo1bEhKaEphc2dPN0xwd1EzQnA5?=
 =?utf-8?B?aCtiNjl4KzluSFpwY1o2cWNoUzJCYnNNWFF5VFZrLy90OHgzNjl2Ny95OCtU?=
 =?utf-8?B?OUhrTDBKc0s0dUZFKzN1dmdPL2xoU1R6Z2NtNy9mdjJzTlNFOG5hRmhNTFZp?=
 =?utf-8?B?ZVkvdktkdzFuSWJPandsdFJUdDdDL2pSUDJVVUIwM3lhTDlhQ2pUbnJlQURR?=
 =?utf-8?B?NFl0VWQ1a0pzWEE3YjBoc0lNVmFGbkxkMjhxWllFZGh0Sm4rS2lxN2NLS3F3?=
 =?utf-8?B?U1BEVytycHhYMzhXUjZ6TUVQVk9YNjhqRUV5NDJvTjFjb0FTZk51L3pXOE9o?=
 =?utf-8?B?Wm03UnJIN2szZDFxNElZTUFYd0Y3NnBuUjBLeHdiTmlRbStDUXBZaWdHd3Vh?=
 =?utf-8?B?RjFaZ2RnYTdrSHp0UENHZDZXWCtQUHQzNmVBTjJBajcrelpJMGhMeUtXRWx5?=
 =?utf-8?B?TVYxdEJRS3QwekhGRi9WL216b0g5V2VacWZFWG1KenVjYWdHRWRSSExvSUl3?=
 =?utf-8?B?Q0VCVDhSQmxIN3lPVExjME9yTVRKd1o1THhaVzRmYVJUZ3h3RytLSW16RE13?=
 =?utf-8?B?c1Y0alY5Q1RPeGNsTHVadDYrTktOS1Rvd2RBZzhTMXZFbVNBNnJOcmpPYUZz?=
 =?utf-8?B?ZDBSSUVqRnRKRGo0WXg5QlU5YUIwR2taUWJEMHlpZ1N0OU9rcmdWQ051U3p1?=
 =?utf-8?B?OCs4U0JrVkxxcGNpMUUwZ0tlZ2RoRFFiZ1A4YU5mdzE1ejNhWEpaK0pKaUhn?=
 =?utf-8?B?N1JseExDRmU4Mm4xZjlWS3Q5eDIwaWszckF2MlAwWktyQktOTlk0TGdUOHly?=
 =?utf-8?B?amFvT0daSXZOdHFTRmFoM2xDWlpYSE9ZTk9HOVk0WFY4bDl6aGtFcE1PamlI?=
 =?utf-8?B?bk84SUEwNWo4aEpwQ3dVaUxwQnVPeVdhRTErQlZaWlU0bkpVRlI3Z1hGMmdJ?=
 =?utf-8?B?bVRWczcrR1RXaFhvaDluaW9oZllQVHQvL2djc0pUeHhRTE13d3UrdFkzY0VY?=
 =?utf-8?B?V3I3MGVwbjM1VDRYVko2ckdJeFRQc0xrS3owSVVqaU5YUEEzVzhPejF3NXRX?=
 =?utf-8?B?OEpHMHRFMC9hK1dzczVCUXI4b3RCN2lNVG12VzZMVlJSeUZzeGtSOGk2UlVM?=
 =?utf-8?B?RDZoUnVRZ25uOTgrLytydmN1OS9oRFdjbVVJNzBKSHVvT0lObnJ4NW94UXIw?=
 =?utf-8?B?RUJRTzlFMTllWjd2b2VraVNXVE00RThGOEFiVDF0Q3RBRVo2TlBSbU8wY0k0?=
 =?utf-8?Q?FEFkr/EbZBc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVpiNXhVVGNGUXFHRmptdGpudnhraWxlVjhhR0k0RkVhREI2cVJPbUNLVHha?=
 =?utf-8?B?Y1YzcktyUWNOUGljUzVPdk96aWZrbEdwcEtmVzFKRW94eUp2eE1hOGZGdy9Y?=
 =?utf-8?B?Q3dJMU4rMXgwNUpVcG9OV3dQcU15S1VtUGFER2ZNUU12MnVVMzczckw4Sk5O?=
 =?utf-8?B?MGl5TURCeTBwZ1B4VFlBVFpmRk1QWmVuWWZXUUZNRTBPQUxlNGZjVVFEQ2VC?=
 =?utf-8?B?Z0xsNnRMNk5kYVhrczZGNnRvcGNUMzB2RkEwbG80eDhvalFzT2VXUW9RTzQr?=
 =?utf-8?B?VndJR0FtdWpXdnhocXBUZTEvekg1SmRqcEZpd3F4Y1luL24xSHArcjBkMmZ3?=
 =?utf-8?B?ZW9kWVhJS0xUalNMOHJqK0pmTlFrV042cXpsU2trQ0NidXh2Q0hDdnBPUVdR?=
 =?utf-8?B?V2JEbkY1OTBzbW9aOTdycjcwMHhnM2t5Q0wwWEJLVm1ibkNqTll3TzRyWVJD?=
 =?utf-8?B?NHRoVW9DdWVkM3l3elpkbEJaWGMyUnBVZk1XU1dSOGN3cEJqWHRpaktYZC9p?=
 =?utf-8?B?MUVEQTNxVG5WaEVnWHlmdVRUVjBzRFVTYkRxWjZObDFjWEtZRE0vb0ppK0po?=
 =?utf-8?B?YkRYTHBva3J1dGovd0taRjJjNUZDWjhRUnN2bWZSaFZPSzdYeHVTaFZYbzJC?=
 =?utf-8?B?YWdVODZxSFJtamRHODY4ejBKcWpCYUZid3ROOFZEcWFTd1h2c2FoMGdvZm1u?=
 =?utf-8?B?OVUxVW4xeHgrSjUyQXk1Q0lOb3JoSTA1bldYZFhpME5TNjdYVUhtNjZudDZE?=
 =?utf-8?B?bTdGV1JmTUhWRUJRakJoZVNlMHVIdkVQczI2ZUJRM0ZvSDdGZmRmVUFwejJW?=
 =?utf-8?B?REczd3lHdWozelBhekJhbFdOUE1tUGhKMG14OC9tUnkycUc0N1JaNnVQSHRp?=
 =?utf-8?B?cWc0V2VuSzdyZy8yTTlKa0t4cERhcUw4bFJ3b29tb2xmRWFqSy9GaUlaeEkv?=
 =?utf-8?B?aklSTzJDa052MHRWSCs3dElWUXArVnpMbkI5QVBwTVhXT0hnZFVjenhybUpv?=
 =?utf-8?B?TUZkN0xXSENCRlpFY09UOE9oWGg0VnJsQ3Q3OHJ4N1Z4RFZ4cDRDMHJQSS9W?=
 =?utf-8?B?aHJQM0crMm1LZkVSVUppVGh2czRtdE9ldUdwNG0wejgzczl1KzZyZzk0YkJK?=
 =?utf-8?B?bFdFL09NNy9nZFhjOFFGMTVpUENVRWszdkhhKzJFcTRtaEVuM1M3Q21PWm5G?=
 =?utf-8?B?RVp0MVRLczhEM0paYmxYNSsrakFhM3gzekYxVXQ0Y3dicGhneW9RSTJLcUpL?=
 =?utf-8?B?ZmxPK3lzZ2MveVNXdGtBUFNlNC9IdDl4NzRZdWYrWjQrRkJsamZERkxNOFQr?=
 =?utf-8?B?Y2ZVUVpVUnJHcHc4Rm1tQ3FpQUdUQTA2SU5PYmcyQXVpVnRpOWRISFRpVVpl?=
 =?utf-8?B?UlFGSWVzc0ZMckdmQTRVR3p6eHp4NTY2a3Z4dkJWV3NrUGNDL2RSZ3l1QnA5?=
 =?utf-8?B?Sm5NV1ZtVlpJYkV4ekwwQUZNVTg3TGNCL1dTL0cwOFVkOWIzdUR4cGRHcEZu?=
 =?utf-8?B?Nzdqc3R2QXpEeXdZTVlWSmJUYkdDTng4SnFER0hLZC9xcnR6SnhDc0Jhc1Bv?=
 =?utf-8?B?L0Zxdlc1WkFaVmxTVWV3RE9zQktaRHh5Q0VvR2Y2WkhWSmN3WURrSTR5VEFp?=
 =?utf-8?B?SG9NSXNzNk8vcjhzUVM2MHVpUFg1SDVoOXp4bFg5UlNpa0IvbWJqM3pZeWtv?=
 =?utf-8?B?YWRwNXZnTWZzUm9VT3hpUEduM3lsVjBCS2l2T0tKbEFIWWtMaDdYM3NyWGNa?=
 =?utf-8?B?bUxWRUhzL1VhODFyaUhTT09RcnVMbVNyK0VtWFhkQTJIZzRYUjlFTWdWVVJ0?=
 =?utf-8?B?RVNkcHVuSzBlbUxNUy9SeFkwWmhWYmd2aVFIL05icWtGdWw2WkQ2SHBnRUVM?=
 =?utf-8?B?anR2QlpxM0xiQnJ6amFGblI1ano1Ui9Rem9DekRIU3BmalFPczg1M0hTTUl2?=
 =?utf-8?B?MjRQa3JLclBFaTh1dTYxS1dEamdXbm9QeFg1V21ZaWNBaGpkL1lJaGgzU3pr?=
 =?utf-8?B?a2ZTNDI1TGZPU2M2NjhaaDZHaU5CaG13MkV5aDVreDM5cm01TjhPVWswbTgr?=
 =?utf-8?B?bWpVQzc3cmdRdUV1Ty9OWWg1aGxvbEV2VW1ua2VncEszVk1oWTNVRldCT0o0?=
 =?utf-8?Q?ZKXQ=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78d1bfa-2589-486a-6c44-08dda83493ab
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 15:36:32.7572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1CkiqCJFkcLQm38BsWzJbmAvBOYA+5UGhOdt2wDYaI7jRYimU7HzJXRC+sISmuc9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR01MB9356

The message text is pretty cryptic: "inode numbers won't match anymore".
Can this be stated in a more actionable way? The primary consumer of
the log is the sysadmin, after all.

At a minimum, stating that hardlink detection won't work, as noted in
the commit. Perhaps more helpfully, state that it's not a client issue.

Tom.

On 6/9/2025 3:36 AM, Pali Rohár wrote:
> cifs_autodisable_serverino() is already printing at the VFS level
> information that it is disabling the serverino. It is one time thing as
> once it is disabled, it is not printing it second time. So it does not
> flood logs.
> 
> In this change I have just extended this existing logging to print also reason.
> 
> On Sunday 08 June 2025 22:40:21 Steve French wrote:
>> Since this could flood logs (e.g. in some DFS cases), probably better
>> to do these via the usual dynamic trace points (and can document a
>> simple "trace-cmd -e smb3_disable_serverino" script to avoid risk of
>> flooding logs.    cifsFYI is an alternative but the world has moved to
>> the dynamic tracing (eBPF etc.)
>>
>> On Sun, Jun 8, 2025 at 3:57 PM Paulo Alcantara <pc@manguebit.org> wrote:
>>>
>>> Pali Rohár <pali@kernel.org> writes:
>>>
>>>> Before calling cifs_autodisable_serverino() function, show reason why it
>>>> has to be called.
>>>>
>>>> This change allows to debug issues why cifs.ko decide to turn off server
>>>> inode number support and hence disable support for detection of hardlinks.
>>>>
>>>> Signed-off-by: Pali Rohár <pali@kernel.org>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>   fs/smb/client/connect.c   | 2 ++
>>>>   fs/smb/client/dfs_cache.c | 2 ++
>>>>   fs/smb/client/inode.c     | 3 +++
>>>>   fs/smb/client/readdir.c   | 3 +++
>>>>   4 files changed, 10 insertions(+)
>>>
>>> NACK.
>>>
>>
>>
>> -- 
>> Thanks,
>>
>> Steve
> 
> 

