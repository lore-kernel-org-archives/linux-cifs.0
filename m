Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023124.outbound.protection.outlook.com [40.107.201.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B681A3A95
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 21:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739827729; cv=fail; b=ekpgKGj7KqPXfb+jnJofkQsH8RbeuDiegOsEOBlvzUBACiMRUw14bCVZPhuJFWMBDR2b0G20dI9jLnwKec/HQO4KG6YXGsI+oWmj0meAdE52ythpdtzwMK7mODVSW0x0W5cs+1qrkrCLOFZgBEpJWS6T3S8LFAG5pwLbfaWEnRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739827729; c=relaxed/simple;
	bh=/EEwh9L/6fiThqFULEfAKel/FB3Eb3jDccjlr5TZQjw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Dey9eNipu2I+CBu6IBEGnLudnPE0vT0Z6WRhZnkDp6fnb+0nb0OsObS/3BaIeBQtpsmyzFxGBOCJ7nuA/j06ksnJLaa6J+bcWx3r3rmzJfw5ZBFJRtYhbgqpuqMnK294gS6jUXdlGTnctAtd0sT6ic1OtoeSktWW2aBvMk7hXoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.201.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZMZ9LLX/r/IUcE3McoVvEShLwVyUq8OM0avK6GoFBFnK9rhS3OIzVMFaXdKDXu6aadUlxEIxDJebZvqXRhwwar2hgFN/pW9MCoP8qiTPvbzx2CfQWyJ2XpbNXiHt+in5M7H0rzegiPgGBk/5+xWbpzEIpVy7yhM75J/FV8EUrRMzguL22j2jfkNhVuSjBOQAT8ILkJC+YqTJMsyWT8HMM6oIvZ8vfgHXMlrH7zCT2StcORBHEc2c8rmmDFBpZV4fpJi+NcXoPW1dfyWC9wahHsnn6vkLw6+EYXzDhDSZt+bKk7RawwX5GGZ2L+T7VXWiB2uEadFKDuIotuJ3B7k2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hcc4RK/ab3tdsQOp+txZMyIpPQgwB6zcUExGdyToAU=;
 b=ouKFMOINHF3pvspSlvnlj4PedVz5G0P9IgoLzkTZ3aGiS344FrOZZEyhTprj2pfQuKK8XLLrLPAZVYFl2SZk0F6JGIUoNtSc68PJq67cfYunu/vKxaaoKhjDwxo2vx+kETI/dcznwmguxMe0VsYz/b0zjfUOLZJgjxUMSl9t8LSm+rCABZ6zaa0eC1eRLq8WENQSLQzdI8OuOpKBYvBvpOrVYp9ShLS9UWrdnbPe4hQb2NEGXIxaocHCLAWivu9MetpeDVMUDXrlGI9YbpyxW6xCuWswEAlLk2JZ2xQWa5lsd0wzYHT+BPH/949IfpaZg47OuaNVPB5bcenv4JqKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 DM8PR01MB7015.prod.exchangelabs.com (2603:10b6:8:18::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.9; Mon, 17 Feb 2025 21:28:42 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%7]) with mapi id 15.20.8466.009; Mon, 17 Feb 2025
 21:28:41 +0000
Message-ID: <35d4423c-9714-4446-ba55-a278103584e7@talpey.com>
Date: Mon, 17 Feb 2025 16:28:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>,
 CIFS <linux-cifs@vger.kernel.org>, Ben Greear <greearb@candelatech.com>
References: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
 <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com>
 <CAH2r5mvf8iCpcp0bj29=1y=bDceEPjZiTGZEx9U2=9yYYgAKhg@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvf8iCpcp0bj29=1y=bDceEPjZiTGZEx9U2=9yYYgAKhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|DM8PR01MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb95b8a-00bf-468c-c5b6-08dd4f9a0cfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2VoK1BrRndJYkVRSUYrUmo0MWpWNmNLWmRyMjBLWS9ncmlCc2dCRkpTd3Y4?=
 =?utf-8?B?MXZsdXJwdFdSRUhuNmsxc09FU2J2VXFCNXNnQzJneVF2TVdBT2ZIQWI4c1Ji?=
 =?utf-8?B?b3VBeDY1NFBabzFMai9DeDBJbXRTV0ZqRDVOWkdYYVRLYVEreVU2dmtVajhY?=
 =?utf-8?B?cFU5YnM5a3Fxdmxqb1RSNE9EL0YzN25LR1lNMFVvSXo5a20rNkJaSmhhVHhT?=
 =?utf-8?B?UEt2bWw3aVNGMXJaVGJKQ2JwOU05SDRIWkdjb01UdkJxR0g1SXJNTCszM0FI?=
 =?utf-8?B?WFFaUkpmWDd4VzYrSXBRaE5PK1drMWxPUFNTYVpNU09TWUphRG10WGZCNVVT?=
 =?utf-8?B?M1Jod2t0NTM5VlozL2ptWHhjYUhndWFUa3hqY1ZEZDZRS1R4czJFMzR5YzEx?=
 =?utf-8?B?MU1tbUswM2tWdUswd0VzbllUcjEyandzSUtvNHFzbGp3MjZWeUtqSm9kbnJv?=
 =?utf-8?B?eHlIaS9nWGRUc0U5cHJ5WmQrdTJCWHlOdko4N2FjTUhSTlFRc2YzMGVqUHBV?=
 =?utf-8?B?QWZTR2xMZ0FpcVQ3alpwby9BcGlid2dLS2FJaGdZT0ZWVnlUcVZPNWVTWFFP?=
 =?utf-8?B?UWRrUm1yZmZFVDdSMTRvSkpjeTdQakpVNm1lUFgxRlZ1UGhsVXpKQlFqbCt6?=
 =?utf-8?B?aUJZaHdaRGpmMURCanFXZEZqWVA2T3BZamRkL2V2WFZ4d1BSSU43OUNoYzc0?=
 =?utf-8?B?WWxKZmw0VWpoeWVYL3BiMHBjUDNkUmcrWXFoMG1FUU1qbWtNNzFMVkJodG13?=
 =?utf-8?B?N2JRNXc2eVNtajRPMXZjRnBNQnMrc0ZpaDVTbnNxQVV0S1oyU2pQbkdTWGoy?=
 =?utf-8?B?VUEyU0dCZDNvWkkrRU1aTlZuQWJPbzBZZXVJSlVWckNWTnVyTmgxWU1lSDlM?=
 =?utf-8?B?elR3NEdYc0RmTU8zdGEzNlY4NitkWkJ2ZlJNSlN0RnF0NXBHci91dFhkUlJH?=
 =?utf-8?B?OXJJQ0pLaWxkNGZZWG9PL2dBTno1L1BnY3ljMjBtZ3YvdTZubUp5MWJ5dDRF?=
 =?utf-8?B?bTV0aTBzdkZSN1YwNGE2ZkdwZEpTOEI4V21Fb2o4WkZhMHZhT1dGcHVxYlpq?=
 =?utf-8?B?SWhwbFlqa1FtdUp6YWhxL29xTXI3clVvZlUzdkdCdkRPdDVvbmN5eklvRUtT?=
 =?utf-8?B?dmtLaUIydm9xR1JSKysxZ0xmUkhWcFZqWW1SKzlQOWQxT1I5aThQUnZDc3lx?=
 =?utf-8?B?Z3I5SEJxcnF6M0wxVDdWK0t2MVJJcTQ2a0xIZHRyZjhPeVhEUzh0RFpoeHN3?=
 =?utf-8?B?b3pLSk9pcFlEbytpOHZHZVl5NnJEWXZxWS90U2E0elBRQWlKR1lGa09EbkVY?=
 =?utf-8?B?REhHQjdBdlIrUFVTL054UnZ3bFdGb1J2ajhBTjk3SE5NZWlYTmdxNW9hdmNm?=
 =?utf-8?B?NTU4TWwzRUp3Uis2NFYwOUZ5RGhVMGw1YTc3WEw0a3hOQXBDeGFEZjBKQXdz?=
 =?utf-8?B?N21VNG1WWnBVUitPa3dqbnljanZ1dDRHVXovNlhzSS8rL1FoekVpS0NhTXFk?=
 =?utf-8?B?Q1pJcXg2cTdNemhRL1R4RVN1QWluMUcvZGNBbkV2QWlEQmNBc21ITHNYbXFM?=
 =?utf-8?B?NVhteWNWMXg5Qk1vdmtyQm9YdFlwM0lmUFJUSG1xcVFLclBRUE12NHA2ajV6?=
 =?utf-8?B?TWZkTW1WQmZjY2F4dEJuS1NUa0t6dzlaWDlhaUpjUjRiTjZGdmxOS0FIS2Nk?=
 =?utf-8?B?aEdpMkpTTUgxSVl6Z0Y1QkkzeWI4Y1owM1p4dzdoYlpycTZTTk1tbHFlY3Vv?=
 =?utf-8?B?R1RRUHhCU0ZCVmpJUm9aak03Tkw1QllsWUE4b3c3RkI5NWUzOVBUVlllVjkz?=
 =?utf-8?B?aitod0Q0QURERGJXV0MzUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVU4bFVTcytlYi9JdFRkKzJIamlxa2w3SmI0MVFTK1c0cGdycWVNRjZKczQz?=
 =?utf-8?B?UnFrSzZaZEl6dFBmZjRNVzVNS2wzb1lpbTBNeUxaY3FQejQvd2pDaUZHUDRS?=
 =?utf-8?B?ZU9iemJ1c2F3bENyZVdYa2dMazFCdFBuN0UrU2pUbUtmVVpJbkR5NVFpRFpS?=
 =?utf-8?B?U3Voc3lsTzdXWG5mK0xESXJZOHJoQXR6U3NGTmFHV3BCZThnYWE5UkZFNlkr?=
 =?utf-8?B?V2QzUTZOdnhhSkpWUXhEem95UEV3Z1RhbzZlMkptWlBvOTFiTjhKQ21FeFl4?=
 =?utf-8?B?VXBDem1Jd0JOZWlGK2pDeGZycFVPdkd2VkJKOHRJZlppM3NFNEpRTldSeWE5?=
 =?utf-8?B?V0hsUWNIWU9uNFRyZ3dCaysyS01zNEtocUtWaGU3eE1OeVU0SzhrNmV0anBS?=
 =?utf-8?B?SmU2ZDJjYkpZc0R4Z2NjRVFUanN4amovejFmSStaallxYjdLK0xwa2dvb3BJ?=
 =?utf-8?B?YXZzZWRhUkhzUWFKK0hqRmo3VFdwZy9zM2N2TTVmLzhrMmJpSUdQSzUyVDFj?=
 =?utf-8?B?NlpTeUFOdE5PbkJ0TUFzcGNCdC83QVhJR3RrNUZTdTZubUJnRmFWc0FFVGNE?=
 =?utf-8?B?LzZESlBlMTYxVDVNMXU1cERvN1p2d013cTdOOS8vVzQyUTNkRDMrMWNxallu?=
 =?utf-8?B?YTM2VU50VjNNMmZCUEhWNVF1YVk3RVcrcjZhcXpDeHdTSlE1OXZwVXQyd1ov?=
 =?utf-8?B?VGVDNmZ0VG5NTTBxTmhjZ1ZGeW5MS05PMnUybUk2ZE12QkpzR2x4c2NWV2tF?=
 =?utf-8?B?bVRDanoxT0NDSHpjc2I4ZmxPRlgrSEdzUlNPWVpEeGJoRDUzZkNmSUVEcUZW?=
 =?utf-8?B?UDVIb3duYVgrOVhBd0xOTlliWXRmSHNpQlNMZGRhdkRyWkd5enZSTDVrWXBI?=
 =?utf-8?B?MndhYVFBcjVBMy9NYXM0bXRHU3hyb2JWS3BORnVUWnZKcU1pNVNodXBSRlZk?=
 =?utf-8?B?aEpJN21pYjRIT1VBa3RsUTFhbm12MmhCdW9IdFBZa3JvRFdnNEhpRExNR01j?=
 =?utf-8?B?MzNjRTd1TE9YdVhmOERlM1RGRmM5YldRUU5ZOE5Xa2pPbHhpQjlQZVBwSGdm?=
 =?utf-8?B?NFRVU1h4aEZLdzErK25SelZtWjAzN2RYL21YcjhYN3dub29Rb0w1czJiQ0NM?=
 =?utf-8?B?Q3ZmWkxNelJabjhnNTcraHdPdzc3c0cvcUhMcElndGQ4WkFDMHFPbXBYc01l?=
 =?utf-8?B?aEVMUDlkTjNML3pkOUszNlFDem8yWmd3a3EvTlc2elZVSTNEa0FwSlFpbEdw?=
 =?utf-8?B?T3o5K0VyV1hmeFpqOG1ZV0tERjgvbUx3UkcxV2xLdVpIUE5Oc0FNTjVMV29i?=
 =?utf-8?B?cEx5SG5IT1IvaHBwekRvdjI1NnBaNVdMMXJkKy9TYnFOQUlub01icE9pNEV2?=
 =?utf-8?B?dG9GWXBGUWVZZm16WllURnpGNGMxWUMrc2x4VlB4VDE1YWpIRitHV0ROcFV6?=
 =?utf-8?B?cms4QmNZWTZjKzE0Z2RISkFaRlJOL0NwN0xEN1JEcS95UWo4dXZkMld5UzFS?=
 =?utf-8?B?bFV1U2lWNWdqNnpyT3I5VFdLUlZWMitYeFZWUHkwZHlmVWFqbk9Xa3FuUk5o?=
 =?utf-8?B?TFB5aDJ6UWE1cXJQK3hDV3VCdDMrOE5Hb2R5N1B3dWkwMW0vOWt2RVdYSXEx?=
 =?utf-8?B?WU9NOVpuZjQvVFgrSFp3SmhlQUV1UzRUeFdNblpER0hKckVsVm9iV0VQbVVm?=
 =?utf-8?B?R2lOUnVMYlVNcTcrZ2R6TURmVDhubmpDYkRnWFRneFppaSs3eHpWeTIwb3ZL?=
 =?utf-8?B?THM4WkpUM2tldDBRT3J4Q1hub05JSGluaC9QR0tLRjgyczRoNDdkWTJHUlcx?=
 =?utf-8?B?WEJwVnIrVUU1Rlo3dEplaFNzVUd0L09xTU9JVjVEMkdCT3M2N3UwRFQ0bGsz?=
 =?utf-8?B?emlvU1BSTmpic296UXVqNnRHYVorODJKZVFDWWxralVUeTVrc3Q0Qk5aazhj?=
 =?utf-8?B?RUxaY1NzWS8yM000TzJiblQ3NTF3bHQ5UTlXUkFTb2Y4WHNjV3J5YTFmQ295?=
 =?utf-8?B?R0FlY0hhRUMzQ1ZHa0cwYmFjKzNyam1PUHFyVGd0V3ZIb1Zhb1JsRTNxYzJF?=
 =?utf-8?B?NzBtejFwR0VoZWp6UkdqakxQcGNJb041SzFXYnVrV3ZEREFJRjQ5UHorVHNq?=
 =?utf-8?Q?xH6M=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb95b8a-00bf-468c-c5b6-08dd4f9a0cfd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 21:28:41.9053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78kIwvHC8++8kDIOcs9Bo7R4of0exnHUAKA3DATFTeLIqOaFxhRlsfwKCC7SQr4j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7015

On 2/17/2025 4:18 PM, Steve French wrote:
> On Mon, Feb 17, 2025 at 3:08 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 2/17/2025 1:27 PM, Steve French wrote:
>>> Noticed this old bug today when cleaning up emails.
>>>
>>> When the user specifies a srcaddr on mount, the DNS resolution of the
>>> host name should only look for the same type of address (ie IPv4 if
>>> srcaddr is IPv4, IPv6 if IPv6) right?
>>>
>>> Any thoughts on how this was handled in other protocols?
>>
>> What is this "srcaddr" witchcraft that thou dost utter? :)
> 
> The original patch which added it was this, and apparently is needed in some
> cases where the subnet the request comes from is restricted:
> 
> commit 3eb9a8893a76cf1cda3b41c3212eb2cfe83eae0e
> Author: Ben Greear <greearb@candelatech.com>
> Date:   Wed Sep 1 17:06:02 2010 -0700
> 
>      cifs: Allow binding to local IP address.
> 
>      When using multi-homed machines, it's nice to be able to specify
>      the local IP to use for outbound connections.  This patch gives
>      cifs the ability to bind to a particular IP address.
> 
>         Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
>         Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...
> 
>      Acked-by: Jeff Layton <jlayton@redhat.com>
>      Acked-by: Dr. David Holder <david.holder@erion.co.uk>
>      Signed-off-by: Ben Greear <greearb@candelatech.com>

I still think this is a hack, and unlikely to work reliably.

>> There isn't such an option in mount.nfs that I'm aware of.
>> And, it isn't documented in mount.cifs either.
> 
> NFS man page does show "clientaddr=" mount option,
> and it is necessary apparently in some cases (e.g.
> https://forum.proxmox.com/threads/nfs-mounts-using-wrong-source-ip-interface.70754/)

The NFSv4.0 clientaddr is totally different, that protocol requires
the client to inform the server which address to establish a
callback channel to. This horribly broken protocol architecture
was corrected in NFSv4.1.

Tom.

> 
> 
>> It seems like a hack on top of a hack to match the DNS result
>> to the type of the specified srcaddr. If the server supports
>> both IP versions and the DNS record exposes them, won't the
>> same issue occur on "normal" mounts?
>>
>> I would not see this playing nicely with multichannel, btw.
>> Or RDMA. Probably other scenarios.
>>
>> Tom.
>>
>>
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=218523
> 

