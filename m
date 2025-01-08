Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020141.outbound.protection.outlook.com [52.101.61.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579CE1FF61A
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jan 2025 17:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736357243; cv=fail; b=dr0VGUTtcQczHuUZ4lvSvu6Q0vnhuybeBCzRCdDZnJVLkoJeuW8e7ruNw+XT0j8JLdZDKrTZzFhiE+h+4vXtKEbI81TqcNNkdtE3C4vzJ806LWpJ10kpfOoeOHClx2oMc8W2fka6+0/2xcM6SkEG1Od0TuK2AQzsFo5lkMtv2ok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736357243; c=relaxed/simple;
	bh=Jzo+LwCmrex7Y87p10RQ8BJgzNAFdWabraB50EFKz08=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mt4N26e0T+lp4sb8PHEcKcvfe+20vw3ZBrU32w/KqoVfBbpqcEn7KCkDyi4ueUnlcxtV11AROfDS76EhITGEvTRMulh0g/0ygPiRlq6Mq5v/RAk5fJk9svnEQeFF9RmvmiQGUyU9U4BYPjg3OjzhGXAvs0hmnm0K2AzN7jNnKbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.61.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKZo5A/E57ZIbxjIwxeKeA5rGu57Ghosf8OLWBGZiODYu3yEClIQC+2rsZB96ZpxipyIgqHNWt0I8nTwrAmJLGqVBriuzk7kjPvJ3zMPtj4zQBOfTJy1qyq9KDXT9K6zaxRKAU7LqimxWCtYTcBCS7VycGxzSgEIM88XAew0cFswMS/tSKKu3OIGGKqNiZpj9Mkwl22Z0IqCPI/MECL++xw5zUmrcrdxnO+0EzpKkmK36iCeAVdI0bXRmP6Zf+6/bf9vSzI7iNobC9nuaiLmJClNrsp7YwbxGVLQoHIIf5aiu8bat4m/C9V2hJYIWHxtL/tjjcX7mw4SV/POL37E5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c5IhKuLaccF4UC+TFLReukWg6mcQqL3G1MZQJNdbLT4=;
 b=CGuxR1kMneWxUIs9rafNHW5sED+V7hYDRe2/5DbLZJO4tsiyJOREsbcpMjWVSVWbI7kipzdjQLKBjEDIKd88CiXPXulLR8i/aiftBlAobM373ObflzXKgsA5OzjhInjx8P7oMzpXXdvRquUUVVClaubCQuiyFzUSutkk8ap74qGemBnmDsiLUPiNYOOufO3p83C8df9nD3j4qNOZOL+kZCXi3RrRu782qOd06k6xe5whjrIybIBd3wa9s4+zzpPReUEL4XET6om/7aVdPann1UhGQWS80rqXD1OUn4sS55FdwkhnwgmlzL0YrJ3GQhEfsAC21xRlJLq5SeqAJh09Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 IA1PR01MB9114.prod.exchangelabs.com (2603:10b6:208:595::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.10; Wed, 8 Jan 2025 17:27:18 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8335.003; Wed, 8 Jan 2025
 17:27:17 +0000
Message-ID: <55aeae3b-826b-4414-936c-26158792aecf@talpey.com>
Date: Wed, 8 Jan 2025 12:27:15 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
To: Leon Romanovsky <leon@kernel.org>,
 Kangjing Huang <huangkangjing@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <20250108093126.GF87447@unreal>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250108093126.GF87447@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:208:32d::23) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|IA1PR01MB9114:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d2f565f-a91c-4089-5c6a-08dd3009b352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RjBLUk83SHpYSmVaMzhla0RaU29IVU9rS25iQm8rTE9ZRUV1b3ZCZkJHdnE1?=
 =?utf-8?B?VUlyQU1SWVlGSy9DNTdIWGZOYmNrVjlYZzl1U3J3d3NNNlloSE1XWGVFbDdC?=
 =?utf-8?B?QjNuNEtIV2t1bGpqNjY4aFJTMjJnNTJhaVRMM0tlamI2dEtPelQ0SUFLWGF2?=
 =?utf-8?B?alM4VExXTjhueWVIY29YdVM0cTNsK2EyMGtPM2JlaGRqZW0yMXlOQ2VTeUZw?=
 =?utf-8?B?bERXWFZpcVhGY3p6K01wSUN5ak5GMGhWZnE5eC9QRHd2SUtPSGVpMkNxaVc5?=
 =?utf-8?B?Zk1mc2ZFT0hlMnMwbllHcGE2UjZpUDZLZlk2Umlid3VTcVhQMUhWMWxOeVJa?=
 =?utf-8?B?RXRrSHQwWG5HZ3p2VDJvZlYvZHZUdXNaSlhKUFpxNHNRV2szM0JRM2E0RFR6?=
 =?utf-8?B?eEpWeUtSbVVIREl0RHp6eStVejM4dXk5Skg3VWRtQmpZY1QzTlUyMlNaM2lm?=
 =?utf-8?B?TWoyN1NSYzhtbkJ2eWs3KyszN1pZU0gvK3NlZ1h6cnFXdzFrZGpUYmVXMDBx?=
 =?utf-8?B?dU1SSVB4K0h6UW5WbUFkbE0wUndkWGlGVUZScWFzUldxeEFYZlZvOU1paCsy?=
 =?utf-8?B?RzdUN1pETmJiRGMxR0tTNUpxZ3FZVDdZSXFIaXl2QW5jd2d1MllHSmlESElO?=
 =?utf-8?B?ZlVka0ZncXY5U1c3N2F0d3doSkNzeEdYVSt5aWFTY3dkc2NReHk2UkNHb2xJ?=
 =?utf-8?B?K0h6R0Uzc0F2RkpzRGZyZllocG94UWRtZ24vUTdyUnIzN1E1WXdlK2FPdDRF?=
 =?utf-8?B?aWdMSm82NWVNRmdwR3lUeis3TDFIZk5oTlNmdmViNGE4NC9lUmxuc3FjNkFP?=
 =?utf-8?B?KzNPUWx5cE5HVXFVaGdheDhyUmU0Q2xyUU9ERUZiYTMwbGM4R2toQkZvN3Ru?=
 =?utf-8?B?RlQ4N0w4VkM4YStzbStMeEJVdlVQYWU5WHZhNDZjc1RZeGJRNTBsOFYxd3pR?=
 =?utf-8?B?aVJ4NEozVjYzU2FXSWY2OGhzdUgyZGhuakFsVlJUVzJOYzR5WHRGTEszUXNO?=
 =?utf-8?B?MFZtQ25UNVJHQ005NkEyMnkyQWZCV21PK25WUWxWTENYWDlUU3JYVEl0U1Z6?=
 =?utf-8?B?OWlKQTZvbzFIc1dBaTFhT25mdEc5UG5oZHNqK0Q0clUrVDhhOUZKcTVacTVG?=
 =?utf-8?B?Um9rcDNiVDRQckVtZEU5TkFPYXFJaVIwdGNHSnd4ZDd0WnVzUFpNUURRcGda?=
 =?utf-8?B?M1RMaFgxY21PU2RVQW5PaE9oTGRKM2tOcXVob2QvWFVWWVJTS1B1eC9SWW9u?=
 =?utf-8?B?ZmFPUHlVQkY1eFlzMk81N0YrZEh2ZzYrL1hUSWZQcVJTcGthU2Rkb0xyVTNU?=
 =?utf-8?B?MkphNWRBZTJ0OGJlTG56Q2YzS3lIOVpodUZ4NEZGK0JyY2dGZytVajl4RFUz?=
 =?utf-8?B?TVhRUHB5eFI1dU1sOVN4ODRmR3JkMUl5dVhGQnlmQ3dUUXNUK241UnBMaVJp?=
 =?utf-8?B?bnlrWlllNFc0TE45NUhzZWJoaHRndDR0Y1NRazloTGppQjhlRWRyNElLWitp?=
 =?utf-8?B?a0RRMEtQRlM1Y1d5K3V6OGxLR2FSYVptbFMrSmJEeVZzdDZ1UFJiL3J4TnJL?=
 =?utf-8?B?T0dwYlpPbWtMTHBKMkNhRktBcWM1ZG05ZlorbmdYczZEamlpTGVQVlR3UGpx?=
 =?utf-8?B?bjczLzVUL0luUEppd1NXbUx0UHgxU2VmQlpHNjJsSy9xNWpzN0gxcFlmYVpN?=
 =?utf-8?B?eTNaWmw1MkZqQTB3WVEyVzBpY05Ddm5kY2dGaEpnejJidmRTWXl2Zy85SFJh?=
 =?utf-8?B?eGllTEY1Wi9XbDhBRlZFVDJwTjJ4RmorcXZMRGRsaWl1SUIwNGwrOFdzZUpS?=
 =?utf-8?B?bm9jbFRUOUx4MEI2NkZMZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eklOa2xkQkRkbXFuQ0FNdDVtYWhVN0lVTnFwY3BxUFEzNGxmU3ozRnZNRXVE?=
 =?utf-8?B?bUkxN0JDbkZNQ2Y2c3ZCRTFuRG5vWnQrRGpIQ2dPbFFiRVk1aGdweEo4ak8w?=
 =?utf-8?B?VFZ5NzRjb3l2aUdESjE3b3hBVmRVeko2VE5GZjYzSnNtSHRCRkxKNXVkSVZa?=
 =?utf-8?B?anNrMXpaUVplM2xQOUxmQXZjQXdRVUtzdk54dTJBNWpGNWRhSWE2R0hWa2hO?=
 =?utf-8?B?Z0M4c3l6YkIrNEVJelcyRkJIWlFWTHNsSUxBQTBtYi9PbUU1OHNGcDJPcEdy?=
 =?utf-8?B?K2dGTDVsdVdPZlNFYjNaZXZpUTh4VHdLUE9TaTJ1ajV4QlE4YXZZWVcyTG5s?=
 =?utf-8?B?NWlzcXFxN0FWbVM2WDZPdWg3S29yaUxMaU92bkUvb2g2Rnpuc0hyKzFBclpR?=
 =?utf-8?B?NXlEcmVZTGRkSURPQ1MrVzMrOWtKemJCWHM3dGRjQTkzTHFNbUFNVWZTUC9K?=
 =?utf-8?B?czExY0ZxWmM5Z3QwZU1jZWJORWM2UWxSY29IbjVKZ0N6YjFvKzMrMWtpVnk0?=
 =?utf-8?B?S0E4UHRnZjdKbDBobFhVUjl6MWlOWEY0ekFJUmF5aExxdG9vaUlGSzBQTTh5?=
 =?utf-8?B?cGZhY2RlcmdIS281REV3UHVyQTI1dmJMM2c2MEYwN3d0QXpyVk9wVUd4Z2hM?=
 =?utf-8?B?NUxoQTZPbHF0cmh2QlNqUy9UQ3VRV1I2YkVFK2xvNUNwOVR1b2U0aVpRRHhO?=
 =?utf-8?B?blp2VDk0Umd6NE1yMGkvT0FkUi9IM2JySTJEbFMzcFBzczlYU3RzRTVqeksy?=
 =?utf-8?B?VnBZcTlCeDAwSURaTmh5SlMyTFVNekdVOWZMNVJzaVk3WStXc2dReHpCR21U?=
 =?utf-8?B?ckFRcXZ6dmM4OFBsTDJnUVdOWHJjNmQ3eGR0WVh2YUFhNDczcDRwdlUwQ0M1?=
 =?utf-8?B?cnJRUUlYbEt1aFR3bG1tNDNkSklFelhSRHd6M0VkRWVuV1VybDduV0FhZGlF?=
 =?utf-8?B?U0N2UE9EL2tUaXlFeC9qNktVZDQrT0RsK3NTRTA1Sy90TGtmaUJ2NnpsRUpY?=
 =?utf-8?B?bmtaMEN4Wndtb0hIRVBTVjkvR0NvcVZHN2hucklyV1M0dHg2MXpvbDBOZWJn?=
 =?utf-8?B?bFR3bW5KWXNvdEZ0Slk4Z3ZCTnBOQlJjdTVTbE5JRmVSUW5BeE9FN3NyNEg2?=
 =?utf-8?B?N0tuSGZncTR0RC8xRVcyMTNiUDMvQVMzWnVEcHJ6eElQZm9lenBXTVhIUEM3?=
 =?utf-8?B?d1hFVEVNc0RQYWRjSzkyWEJJemNJZ01sOGpBbGJXeXRFT3J3cTBDL2FRbTlR?=
 =?utf-8?B?QTNhNG5XSmMxNTlkR3lWK3hseVJYNkJBdWd2Z3ZrYXJqRHNqTm9PejAwakEv?=
 =?utf-8?B?QVptakk2WjF5b1Rlci9IaTcrSldob0xmWU5QeThHQURJMVo1RFpTVVFFSlVy?=
 =?utf-8?B?a0VOeHM4b2NmYVV0M2FLUFFyZnBiek9vckR4bXFjZzg0WU5vazN0em1NaS9N?=
 =?utf-8?B?ZUxZdjg5T1VNdld6MGUrWnJkaWxtTXZmYjRGTVlyVUppcGhiOVR3M3M5d1Ns?=
 =?utf-8?B?NVlnVVhaa3BlRDg1OGltSFdySStqRFRlc3VwMkl5WXJkMFZ2Vlc2a0FzV2FV?=
 =?utf-8?B?VHRTejZ4SDlGMlY3NEJzdmFuYWRINmI4Zjk4clc1OGtJRWd3OGtCN2NKWXVX?=
 =?utf-8?B?ZDh4cUJjRUozTlR1TXMrSDNIM3FrbzJDM3lMZXYxOUdlQVZVeVNvYjEyWTI3?=
 =?utf-8?B?TEVuVmxBMFNBSzJvSzZuOUtncFN0RnA5TXlRbTErQXZobzE1dUordEQzUWgy?=
 =?utf-8?B?R2pZdDlnTEtxUWc0M3RYMm5CL1BGcWJXN3FYM09uZnVJdDQ2dXpOUHRGK2hD?=
 =?utf-8?B?c1dScStXZjJjUi9yVmd5d2lweE5hZzVNNElKVnUzM2RxL2g2UlRGZllmaERV?=
 =?utf-8?B?TGx5elU2TTZybmlJeUJoRmVtZTFIVCtyaDkxeHR5T1p3T0szbUlHMmZMUWV2?=
 =?utf-8?B?YkV2QUZTQWpPdUhrSWcwanpQZnFDOGZRNGFjY2VjSmlQcVpMeTFzdnl6KzJ3?=
 =?utf-8?B?c2RGbm5NQ2w4dzJycUpBM1FxYkhYM2UyQ1g4cVZ2VmdzYUlxNTJDbU5nM21R?=
 =?utf-8?B?V1ZqM3k4TStiNVZQUmV2MHR4b0preEVaYkRmdHlLZnR2Y3dmMWl2SW95MDFT?=
 =?utf-8?Q?NExU=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2f565f-a91c-4089-5c6a-08dd3009b352
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 17:27:17.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwMObX7a0s3KROPUb9QhXrRzqadWUCuh25dvUFvmxN5lyB7imzw02zXIlfDVi9wj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR01MB9114

On 1/8/2025 4:31 AM, Leon Romanovsky wrote:
> On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
>> On Thu, Dec 19, 2024 at 4:56 PM Leon Romanovsky <leon@kernel.org> wrote:
>>>
>>> On Sat, Dec 14, 2024 at 08:02:14AM +0000, Kangjing Huang wrote:
>>>> On Sat, Dec 14, 2024 at 1:06 AM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On Sat, Dec 14, 2024, at 04:33, Namjae Jeon wrote:
>>>>>> On Fri, Dec 13, 2024 at 8:07 PM Kangjing Huang <huangkangjing@gmail.com> wrote:
>>>>>>>
>>>>>>> Hi there,
>>>>>>>
>>>>>>> I am the original author of commit ecce70cf17d9 ("ksmbd: fix missing
>>>>>>> RDMA-capable flag for IPoIB device in ksmbd_rdma_capable_netdev()"),
>>>>>>> as mentioned in the thread.
>>>>>>>
>>>>>>> I am working on modifying the patch to take care of the layering
>>>>>>> violation. The original patch was meant to fix an issue with ksmbd,
>>>>>>> where an IPoIB netdev was not recognized as RDMA-capable. The original
>>>>>>> version of the capability evaluation tries to match each netdev to
>>>>>>> ib_device by calling get_netdev in ib verbs. However this only works
>>>>>>> in cases where the ib_device is the upper layer of netdev (e.g. RoCE),
>>>>>>> and since with IPoIB it is the other way around (netdev is the upper
>>>>>>> layer of ib_device), get_netdev won't work anymore.
>>>>>>>
>>>>>>> I tried to replicate the behavior of device matching reversely in the
>>>>>>> original version of my patch using GID, which ended up as the layering
>>>>>>> violation. However I am unaware of any exported functions from the
>>>>>>> IPoIB driver that could do the reverse lookup from netdev to the lower
>>>>>>> layer ib_device. Actually it seems that the IPoIB driver does not have
>>>>>>> any exported symbols at all.
>>>>>>>
>>>>>>> It might be that the device matching in reverse just does not make any
>>>>>>> sense and does not need to be done at all. As long as it is an IPoIB
>>>>>>> device (netdev->type == ARPHRD_INFINIBAND) it might be ok to just
>>>>>>> automatically assume it is RDMA-capable. I am not 100% sure about this
>>>>>>> though.
>>>>>> Why can't we assume RDMA-capable if it's ARPHRD_INFINIBAND type?
>>>>>> How about assuming it's RDMA-capable and allowing users to turn
>>>>>> RDMA-capable on/off via sysfs?
>>>> It does make more sense to me at this point to just broadly assume all
>>>> ARPHRD_INFINIBAND types to be RDMA-capable, we just need to make sure
>>>> this assumption indeed holds and figure out to what extent this could
>>>> involve the same layering violation.
>>>>
>>>>>
>>>>> Any attempt to treat ipoib differently from regular netdevice is wrong by definition.
>>>>>
>>>> I would agree that the design direction to treat ipoib as a pure
>>>> regular net_device is the good way to go. But the problem with ksmbd
>>>> and ipoib devices stems from the SMB protocol itself.
>>>>
>>>> In contrast to protocols that focus on certain functionalities like
>>>> nfs, SMB actually tries to manage network interfaces actively in the
>>>> protocol itself: SMB protocol's RDMA support (dubbed SMB Direct) is a
>>>> sub-feature of SMB Multichannel. Multichannel is designed to let
>>>> client and server find multiple data paths automatically (imagine a
>>>> pair of hosts with multiple adapters connected by multiple cables) to
>>>> increase bandwidth. So client can initiate a
>>>> FSCTL_QUERY_NETWORK_INTERFACE_INFO request and server is expected to
>>>> respond with NETWORK_INTERFACE_INFO containing _all_ local network
>>>> interface informations, including their capabilities such as
>>>> RDMA_CAPABLE (for details see ref [MS-SMB2] 3.3.5.15.11) Only upon
>>>> seeing the capability flag would a client attempt to initiate a RDMA
>>>> connection.
>>>>
>>>> Reference: [MS-SMB2](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB2/%5bMS-SMB2%5d.pdf)
>>>>
>>>> TLDR is that the SMB protocol requires the server to enumerate all
>>>> net_devices and indicate their RDMA capability, and
>>>> ksmbd_rdma_capable_netdev() is only used in that process. Given such
>>>> context, I wonder what should be the best way to approach this? Is
>>>> using ARPHRD_INFINIBAND good enough and acceptable in terms of
>>>> layering?
>>>
>>
>>> The thing is that ARPHRD_INFINIBAND indeed represent IPoIB and it is
>>> right check if netdev is IPoIB or not. The layering problem is that
>>> upper layers (ULPs) should use it as regular netdevice.
>>
>> This is good to know. However, since the SMB protocol explicitly calls
>> for enumeration of all network interfaces on the server host,
>> including their RDMA capabilities, I believe this is a sensible
>> exception to the layering rule. Or is there anyway else to do this
>> enumeration from the kernel space?
>>
>> Or we can give up implementing the full spec of the SMB protocol and
>> call for explicit configuration from user space on how to respond to
>> the IOCTL requests in question. Which one looks more sensible to you?
> 
> My preference is to have same IPoIB treatment for all ULPs, including SMB.
> 
> My GUESS is that SMB specification authors didn't take into account HW and
> Linux SW development around IPoIB and weren't aware of IPoIB offload which
> is implemented and enabled by default in all modern IB NICs and Linux OSes.

The SMB3 specification is completely unconcerned with IPoIB and any
other layer-2 or layer-3 implementation details. It merely discusses
an exchange of network interface capabilities such as link speed and
RDMA support. The SMB3 client uses this list to implement multichannel.

I totally agree that inspecting ARPHRD_INFINIBAND is an incorrect method
of building this list. Just because an interface supports IPoIB does not
mean it also exposes RDMA, especially in-kernel. And that ignores any
non-IB transport too of course.

Kangjing, please educate me if I'm confused here, but doesn't the
code in ksmbd_rdma_capable_netdev() look up the ib_device anyway, at
the end of the function?

> 	if (rdma_capable == false) {
> 		struct ib_device *ibdev;
> 
> 		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
> 		if (ibdev) {
> 			if (rdma_frwr_is_supported(&ibdev->attrs))
> 				rdma_capable = true;
> 			ib_device_put(ibdev);
> 		}
> 	}
> 
> 	return rdma_capable;

So, why is the code concerned at all with ARPHRD_INFINIBAND just a few
lines above? And why does it look in the smb_direct_device_list first?

Tom.

> 
> That offload allows line-rate for IPoIB, something that is not possible
> for SW IPoIB.
> 
> Thanks
> 
>>
>> Thanks
>>
>>>
>>> Thanks
>>>
>>>>
>>>>>>
>>>>>> Thanks!
>>>>>>>
>>>>>>> I am uncertain about how to proceed at this point and would like to
>>>>>>> know your thoughts and opinions on this.
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Kangjing
>>>>>>>
>>>>>>> On Fri, Nov 8, 2024 at 5:59 PM Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>>>
>>>>>>>> On Fri, Nov 08, 2024 at 08:40:40AM +0900, Namjae Jeon wrote:
>>>>>>>>> On Thu, Nov 7, 2024 at 9:00 PM Halil Pasic <pasic@linux.ibm.com> wrote:
>>>>>>>>>>
>>>>>>>>>> On Wed, 6 Nov 2024 15:59:10 +0200
>>>>>>>>>> Leon Romanovsky <leon@kernel.org> wrote:
>>>>>>>>>>
>>>>>>>>>>>> Does  fs/smb/server/transport_rdma.c qualify as inside of RDMA core code?
>>>>>>>>>>>
>>>>>>>>>>> RDMA core code is drivers/infiniband/core/*.
>>>>>>>>>>
>>>>>>>>>> Understood. So this is a violation of the no direct access to the
>>>>>>>>>> callbacks rule.
>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>> I would guess it is not, and I would not actually mind sending a patch
>>>>>>>>>>>> but I have trouble figuring out the logic behind  commit ecce70cf17d9
>>>>>>>>>>>> ("ksmbd: fix missing RDMA-capable flag for IPoIB device in
>>>>>>>>>>>> ksmbd_rdma_capable_netdev()").
>>>>>>>>>>>
>>>>>>>>>>> It is strange version of RDMA-CM. All other ULPs use RDMA-CM to avoid
>>>>>>>>>>> GID, netdev and fabric complexity.
>>>>>>>>>>
>>>>>>>>>> I'm not familiar enough with either of the subsystems. Based on your
>>>>>>>>>> answer my guess is that it ain't outright bugous but still a layering
>>>>>>>>>> violation. Copying linux-cifs@vger.kernel.org so that
>>>>>>>>>> the smb are aware.
>>>>>>>>> Could you please elaborate what the violation is ?
>>>>>>>>
>>>>>>>> There are many, but the most screaming is that ksmbd has logic to
>>>>>>>> differentiate IPoIB devices. These devices are pure netdev devices
>>>>>>>> and should be treated like that. ULPs should treat them exactly
>>>>>>>> as they treat netdev devices.
>>>>>>>>
>>>>>>>>> I would also appreciate it if you could suggest to me how to fix this.
>>>>>>>>>
>>>>>>>>> Thanks.
>>>>>>>>>>
>>>>>>>>>> Thank you very much for all the explanations!
>>>>>>>>>>
>>>>>>>>>> Regards,
>>>>>>>>>> Halil
>>>>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Kangjing "Chaser" Huang
>>>>
>>>>
>>>>
>>>> --
>>>> Kangjing "Chaser" Huang
>>
>>
>>
>> -- 
>> Kangjing "Chaser" Huang
> 
> 

