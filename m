Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020087.outbound.protection.outlook.com [52.101.193.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16CA3D69
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735317852; cv=fail; b=sKfTUndQJP6qGYlRYn82cjUKNFlro5eT4lJ6M8b4L7Gs6i3lgWTZbxLfh//qqUgishumtv43gqS0gMdLL21Bi6Z9sa35DRVLdjHPHW/C9Vl2dv5OZcCiW/RRDAoYqw/dTZJzBTB+poxdiOPIhxjCfVyRNrDPE4/bB5fm/EPYzTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735317852; c=relaxed/simple;
	bh=WaIiKZR2xYWeMWgQz0iZzT9IHSWcKMjRtL1LRGNjKp8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r0wWO1e1AgP6PSa0ruoheACeIR86G+Qdg6diN0zA9TSYkrcb5Fg6oE8607pKp+goYyqBsZLoBfeaZvG41IZw4BS17qT1RQZIJLRrsQr2NMBAI/NTFsCAiujCLsngghm306k2n3Aq6cVy15wvxQmAx1QJOuBISHid6FOSyQDk05o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.193.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cL77NB+zNbTcUiNYfWIBbvkdi2p13QSSitxH00WiToAc0efvYGXTtSMCZ65B3zwPmZMhAV+CknFd8iPnY1mo2rk7fEydX2Tz2GLO3Wo2MFMDdZ4q0AmBEKPW8mS+yNxpmnpr6RDu7HUiVecvKr6rUJt1T7QV3+3MaBobov3bHef4MTsV9mMTjvevrTToiycx5cAQvLKQrHf3xBSvOVB4bbgqdrfew+9NGKjLvaEl+B7mUk7HxVj2DOaGp8WSWGiL48AX97qCvI/1dEpmmNCoeqRvqUg9jdLMVLxH7bTC/3Mnk/ItvKa/pYBTUTaUtYA4VBMUDUuLYCRSE9N8rlXv1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XxnFOTta4QD0aPgt6C83hZKsDEhM6cdfALjhLk4ij0=;
 b=OWGeJU8NXdCySqzMlvYZeuUH0G4Obma0AqHhPMENf8dFMPlhg6vdeOiPivcV+kqupF8ppJcd87CwD71JXcfb7edR0ohdpIPvZ/JZ1nz40cdxArn3/Tud1YCt6SZmUq5w5NzQoTDvKV+sO+1EK8t/wUvFx1TibsflS1qc/BpOcjMzNia4Df+1AB1IfpN8Afw11xTjxfwHmtyRDhkef7Tw3Wv0JRAsjEm43IrTRIpF+LUzj1t1DGnoTaPXqmF/zCIrxwoES8lj3VsvLJrBlbCrS2Uif6EUUwQ1/YXxKREGYG+SD8k7PErSQRljXvWn7wQiDDGYzTZhiDgE3kYNUvRYsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB5238.prod.exchangelabs.com (2603:10b6:a03:91::18) by
 CH7PR01MB8812.prod.exchangelabs.com (2603:10b6:610:24c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.14; Fri, 27 Dec 2024 16:44:02 +0000
Received: from BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0]) by BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0%6]) with mapi id 15.20.8314.001; Fri, 27 Dec 2024
 16:44:00 +0000
Message-ID: <749690fc-4647-487b-ba21-d208d72f754e@talpey.com>
Date: Fri, 27 Dec 2024 11:43:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <20241225144742.zef64foqrc6752o7@pali>
 <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
 <20241227163202.ihp3cxmhe2sehxoh@pali>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20241227163202.ihp3cxmhe2sehxoh@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:52f::18) To BYAPR01MB5238.prod.exchangelabs.com
 (2603:10b6:a03:91::18)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB5238:EE_|CH7PR01MB8812:EE_
X-MS-Office365-Filtering-Correlation-Id: 30a439f1-6810-4bdd-feaa-08dd2695aa20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RFUyR29xbzJaSzhuMWZjWjVuaHJDcVNZQW56UWxGait4Uy9iRk9sYXFrSE40?=
 =?utf-8?B?Q1RGVDh3VndCRmNDRmpHRmw2Q3B4cFo3MEFzNTFweVJrc3RDQmFGZkRkSTA3?=
 =?utf-8?B?eXNiV2d0ODU3czZ1YXBhMGN5YnNNRnVIem1JdjhoeUExRkhFT1BuVU5HM3pa?=
 =?utf-8?B?T0tKd3ZhQjA5VkQ4amtsMXRBUUVuQUNSVDhqRUJDV1R1TTlFSGpIdTFWSnVI?=
 =?utf-8?B?TzVlZVFWNVAxOFZ1blNvNXpzdDVCdFVEby92T3RFWFJ1ejhWQklWQUNCRmQ2?=
 =?utf-8?B?ck0xZjRUNmEvaFg4cW10WU9WcXI4Q0JTRlROa2NmdlB0L2h1bnorUThUNGdh?=
 =?utf-8?B?azU0OEkyeUNSSTZVQkZtMzVXVUNETmFTVFRKTlpYbjV4NHBic3RxZlV1WHZL?=
 =?utf-8?B?TCt6UUVMNWZmZ0NmZDdnOThzK0xBcmpuTDVJVDhzRnY2Y3l0MGdmZUxOVXJE?=
 =?utf-8?B?c2d2QzNsSm95NGRSaG4vUGdrcHJ5RGM5NDNCRER3VHMvdlhmWnRzWXdGekhi?=
 =?utf-8?B?Lzd5RUhDb1U5Z0xjMk1vQk1wVkFHNDZsdklzVEU3bjBTNTFQRjhEN3pWOXdW?=
 =?utf-8?B?MmxWN1JINTc2YzJ1RkpBcnNyWVpSbmcrT1N0TWhGYkdMWlJKK0RMbkhDTDl3?=
 =?utf-8?B?ZzNDczRhZCsvMG1wUWtucGYwVDdpYVZTWjUzbU5sL2NLS1V6OWZCa0d1RGNq?=
 =?utf-8?B?Um8vZ3NZR0FVWTRqL3o0ZzQ1M3FHMlVEb1hNQ0lpZnVBVG5TSWtmaFg0UW43?=
 =?utf-8?B?ZHdmOXRTL0oxcllMWFpieUg5ZXlTVzdpMnRwYnJZSE9oalQxd2V3RzBrdWhE?=
 =?utf-8?B?eko5OWVzdXU2TW1DTVV1M2I0d2QwWTNpeldnT1hjZG1vOW9CWHZITXVGaCsy?=
 =?utf-8?B?Z1J1UzFrNzBkUm1kaGhDRk9pN1dYRFZrTWxkRG9kNG5rajdNenV6cnVLV2FV?=
 =?utf-8?B?STR2UE9YbEg2TFBYSGxPNDRrQlFYVG95ZmFrN0k4bzFjeSsxZS9RR2xHRlBP?=
 =?utf-8?B?Mk9zOTRNVzI0NnE1UDJMTC93UUhpdWYxTHhaM3VYa2lNZnVXeDNHbThGRGdE?=
 =?utf-8?B?RGxjUkwrMmp4V2p5cFI0UUR3OW5kUzQyZm1ZbzUrMzRDQ0dReWpqd1FZd1ZP?=
 =?utf-8?B?dUhKV21HRlIyajVjRjZWRERVU1pob2lvaS9LemxqMG9oMmFaZjF3YlduWUx4?=
 =?utf-8?B?RlFrc2dsNGVIYUNORm5Vb2tsV1Q1L3dpbHhjNVpCeGdwM0V5U3FHbmxjclE5?=
 =?utf-8?B?VEkxdkdRRHdmcGtFWm1sajgzb3dCMVRpNS9IT1FwTW54bnFhQzdLdUJVdDlS?=
 =?utf-8?B?blBVQTlrMXgyR2c2bXlpUDQ4SGF5TzRqZ2x6dy8yK0F3U2NCNHhtcXdMQ3Fh?=
 =?utf-8?B?QU5aOHJwV1Joa3JPcG55NXRzUHRSQUdDS0Zsa3RUZkMxT2tFY0hFTTlsMkxr?=
 =?utf-8?B?U1JaeEFmK29CeS96bUFBaUd3ZmxIajVtMnNLZEpCVWRJdFlVeWpiRkRYQ21C?=
 =?utf-8?B?S2FXaWpXNmhadFdEK2hYa0NPR29sU3lucFdnYnpUNnI3dk90L0xJcUpwMUIw?=
 =?utf-8?B?dnE3cFJma1NocnlHY3dtdGd0QlVPd0xyMXEwUWM1WnFOUjNkb1gvWE0zRGdB?=
 =?utf-8?B?UlFvdXZac2RUbzd4cS9hMHZlam9QODFWTFFkanlXc0RCTkxqOERIWEVVaStR?=
 =?utf-8?B?bUdtc2NmdjJ0MEhXV1luRFhQUXFka0dmOFJ6RHBzY09jMTl4dEFQTnRsRDgw?=
 =?utf-8?B?SlRray94eHQvNzRtMFp2YWVhNjk4M3MwYmE0UzVEYjYvR1d4U3dicitENUVJ?=
 =?utf-8?B?b2xhdndOV2NidytTZ3dpZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB5238.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHAwc2hLLzZicDNSVm5tT3F4K3F4TjhSMjdBY0xmaHdOUzVZL1ZYU3JYMXdQ?=
 =?utf-8?B?TlJVWmUzNjBER3V4WnRDOEp0ci9Zc1JZcDRxNDRSa05NcnhrMVNmNlpBYTlR?=
 =?utf-8?B?KzFvbEJRUzNjYVFzS2JRMC9NOEVocUluWEZMa0dLTkV6WTlQWUFyVXE3Vzd6?=
 =?utf-8?B?Ky93UlBkZHhveE1QUll4V3RpRkoyNElrenZXV0ZESjJBR0drYjhNeVRxMmJQ?=
 =?utf-8?B?N2FWQUNwaXFvbWZrdkdWK1diNXIvd3UwWlN4dy95R2NjY3J4KzliSXJUSzlv?=
 =?utf-8?B?YmhXS24waEtvT2MycFB5andBcnlZTGpZZ01haUx6SW9JUXdMMFFzK1hhNUtK?=
 =?utf-8?B?dUVIYzZLNlR6anhUdzJTOFk3dVcyMWxGbkQ2MEFMeVlWTWxXME1FUFdadzBK?=
 =?utf-8?B?TEZzdlplMGNXYnBaL1lNWmNuWW1oMnVnamt6cy9jRGJsSFI0aFdTYmtxZEdD?=
 =?utf-8?B?TmR2NXdvTVNNaUwya2tqOXkzRkJMV0dEaVJjMHYweXdOblhZekIxcjZ3dlV4?=
 =?utf-8?B?RDhRYmhkZCtpK0dpZUNwRTkrREpCUy9KUCtXSDdNZEtTdndmNE94ckJUSUxh?=
 =?utf-8?B?ekpVcVVMU3UxZVk4OFQvRWNmZ0dTc01nWUl1ZUtQUTRydmhBZGo4ZEZ6N3Ey?=
 =?utf-8?B?OXJZL3FzZkxKc0MzcURMV1NUeUtZNm1nWERhZDlLeGZGRk5qbytMWEVxN3Vn?=
 =?utf-8?B?bXQyemdxS29EVXhjNmdlcXJlM0xzaUtFeXNDc01pL3ArZXlKelRjc0VyelhY?=
 =?utf-8?B?VGx3S01yYkxTOW5mTmpQbWViWkRLYU8zUS9QREhNRUdBM2lkdGJBcGR4OSs5?=
 =?utf-8?B?RU9zWUY2Vk4xQjNmS1M1N2o2RWowWkdqNzdJOTFNc0RLSExSU1dsbGY3WGJm?=
 =?utf-8?B?QitIdFdDZVdOQ2hXMmMvbjJGSXkvZlRBR2I3NFRybVhxdTZSWXg2QUFNZk1h?=
 =?utf-8?B?YTRVcmQ4eGY1WDlOWmNMZExXZ2daa3kyRktadEFPRDZZVW81V2lxSTlSS2d0?=
 =?utf-8?B?dnJBRWErNVpsMUFWTjg0Q290VVFta2lkTjBpaWwrM2FPWWpVQ3Q5SHdGcGZv?=
 =?utf-8?B?c1dpU2lJMFB0emxLRFozajZjNzBzV3krdjFWSmhsK3VxdmhoZm9qQm1sd1RH?=
 =?utf-8?B?WndFbkNOa3F2alNweFEvRzF4MU9OQjlseDkyNDc0L2JXWEJDMXhNeXdETHhs?=
 =?utf-8?B?MEx2ZFpqRzM5SitYL3duYXB5R3NxWWtuY3RrV1Q1V2NUZ1Vsbm81WkZORXdG?=
 =?utf-8?B?ZktLejh3cVdtSmlvUXNrd2FTeTNMYnJ5ZzR1bGU4WkRjSk9DeEdWaWlWMTVn?=
 =?utf-8?B?Mk9UREFWKzQvdWU2RG5aQzNuTU5KVkQ5RDZOVEZvT0VsWkVCc1NuVkhCLzZt?=
 =?utf-8?B?MmoyMVVoaEtGQkJ6NmFMSGJrM2N0c3VBOEVxaGJlbzMzRm16MG5EU1F3M1BG?=
 =?utf-8?B?WklJMWhmdm5FbUdSK21tRnRCNU8zRlo0cTVYMTBkZlVSSlhHeG9WcnU4UDEy?=
 =?utf-8?B?enN1ZHlpMi82VUZuZVRZY0k0alNSRUplMVdDMWF6R1ArREdWNTRSOTRUQmUz?=
 =?utf-8?B?STFSa0VlUGlRT29ST2o5QzZPYklTeVhyR25xYWdYejZjeHBFOVkvd09mUEpy?=
 =?utf-8?B?QlNEbUpyUGxWazlUNnhBK1JENzlhWXZtbnloMHUxYlhnQ1RLMS9qWFlNYU5F?=
 =?utf-8?B?V2haOGhBSTROZzlkd29YU1hBVDRrWGJWbEkvVGE5d3Z5VGtaZFJjL0J3R3dm?=
 =?utf-8?B?WUJHV1UwTTQrcmo2Z1Y1c2NZM3EwUUFvVXpUcDVPRXZBbVN3cERubEtZREJo?=
 =?utf-8?B?a3FxYzA4aGhZSVFNdURGcTFlbkZYbGFoZURId1dnSWE2TlZFNUJyd1ZZNGhw?=
 =?utf-8?B?eDBNOFdEczBuZVlJRVNLT3VwdjAwL2lnSlY4UzJkait4ZjB2RVhxV29KZmpL?=
 =?utf-8?B?MjBuWThsa1pFNEFEMHQyTGpBczhQRlpCQTU4Q2RXL2RBUGFxMWZ6ajZUeU1K?=
 =?utf-8?B?SllHYkdTR01pbGZEZkU5YVM0NXFjSHdWSENUNW5oYkhVRlZnQk00WGJMSm1I?=
 =?utf-8?B?NGp2ay81T3NyWEJPQlVnUzBnR2t1UExaeDBRWkNZQWEzUklkSDdNb0V0bVhs?=
 =?utf-8?Q?JbnU=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30a439f1-6810-4bdd-feaa-08dd2695aa20
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB5238.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 16:44:00.4263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6CEK/zQOJ9egjVkqrRpyLe32OEhAfTODJp0NQTFlkFJJQidZyfeg9FjQF6cQtla0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR01MB8812

On 12/27/2024 11:32 AM, Pali Rohár wrote:
> On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
>> On 12/25/2024 9:47 AM, Pali Rohár wrote:
>>> On Sunday 06 October 2024 12:31:27 Pali Rohár wrote:
>>>> Hello,
>>>>
>>>> Windows NT systems and SMB2 protocol support only DELETE operation which
>>>> unlinks file from the directory after the last client/process closes the
>>>> opened handle.
>>>>
>>>> So when file is opened by more client/processes and somebody wants to
>>>> unlink that file, it stay in the directory until the last client/process
>>>> stop using it.
>>>>
>>>> This DELETE operation can be issued either by CLOSE request on handle
>>>> opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
>>>> (FileDispositionInformation) and with set DeletePending flag.
>>>>
>>>>
>>>> But starting with Windows 10, version 1709, there is support also for
>>>> UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
>>>> is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
>>>> CLOSE and let file content usable for all other processes. Internally
>>>> Windows NT kernel moves this file on NTFS from its directory into some
>>>> hidden are. Which is de-facto same as what is POSIX unlink. There is
>>>> also class 65 (FileRenameInformationEx) which is allows to issue POSIX
>>>> rename (unlink the target if it exists).
>>>>
>>>> What do you think about using & implementing this functionality for the
>>>> Linux unlink operation? As the class numbers are already reserved and
>>>> documented, I think that it could make sense to use them also over SMB
>>>> on POSIX systems.
>>>>
>>>>
>>>> Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
>>>> which can be useful for unlink. It allows to unlink also file which has
>>>> read-only attribute set. So no need to do that racy (unset-readonly,
>>>> set-delete-pending, set-read-only) compound on files with more file
>>>> hardlinks.
>>>>
>>>> I think that this is something which SMB3 POSIX extensions can use and
>>>> do not have to invent new extensions for the same functionality.
>>>>
>>>>
>>>> [1] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ne-wdm-_file_information_class
>>>> [2] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-_file_disposition_information_ex
>>>> [3] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_rename_information
>>>
>>> And now I figured out that struct FILE_FS_ATTRIBUTE_INFORMATION which
>>> has member FileSystemAttributes contains new documented bit:
>>>
>>> 0x00000400 - FILE_SUPPORTS_POSIX_UNLINK_RENAME
>>> The file system supports POSIX-style delete and rename operations.
>>>
>>> See Windows NT spec:
>>> https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_fs_attribute_information
>>>
>>> Interesting is that this struct FILE_FS_ATTRIBUTE_INFORMATION is
>>> available over SMB protocol too but bit value 0x00000400 is not
>>> documented in [MS-FSCC] section 2.5.1 FileFsAttributeInformation:
>>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
>>>
>>> So it really looks like that POSIX unlink is prepared for SMB, just is
>>> not documented or implemented in Windows yet.
>>>
>>> Maybe somebody could ask Microsoft documentation team for more details?
>> We absolutely should do this, if the bit is visible remotely then it's
>> an obvious omission. If it can be set remotely, even better.
> 
> Now I check that Windows Server 2022 via both SMB3.1.1 FileFsAttributeInformation
> and via SMB1 QUERY_FS_INFO/FS_ATTRIBUTES announce the 0x00000400 bit for
> FILE_SUPPORTS_POSIX_UNLINK_RENAME.
> 
> See other email in this tread, I was able to send POSIX UNLINK as
> FILE_DISPOSITION_POSIX_SEMANTICS via SMB1, but not over SMB3.1.1
> (but it is possible that I did it in wrong way).
> 
>> Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
>> Send as much supporting evidence as you have gathered.
>>
>> Tom.
> 
> Ok. I can do it. Should I include somebody else into copy?

Sure, you may include me, tell them I sent you. :)

Tom.

