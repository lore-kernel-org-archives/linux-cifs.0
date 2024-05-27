Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2138.outbound.protection.outlook.com [40.107.244.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53FC1E868
	for <linux-cifs@vger.kernel.org>; Mon, 27 May 2024 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823622; cv=fail; b=a974yPiE0R2kEvFfcmepX4Gv4rqLS+0xjNKEVx7g3fmVp2ZKvAlj7gk+HJJUO2VLgflbAJwYhO1uSMoeYKvexwSGcSUha/z0VRJbStLojA6B//8JOW6y6DlV/P0tKyJRwNysJrQQFuTX1+4EHK5qoSnyLL5y6wDchAjhArwlT6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823622; c=relaxed/simple;
	bh=m/S5Kxf4Z4mMW1mEe/qr9dEe0qzOOcdb55o+A+2jSms=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=paYyt2D3nBxam1fwCgVqq9OiJbL0J02lQIQPl0KBZdZQvgVGNWdwQQ4c96TI4sY7YDENKllzJkQEGSBdcaAZ/I1V0V7JJ9yuRcWKTRshce3+ehMiIj/hbW1E3Q6NyormRg47cEwjf7Tp6vaoYT1TuO++Qnn2BG2Yqvy1sHAdDnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.244.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+18wbm3z3vm3arfbZ6uetcKC/+OQfoPAvsCxFDPOrTq3YVcuJtrhHsf+cxukdAYPgqmsUV43RurPdIPu+QFone2M0a0TaCNDvaZUPrDhOemykUOqiRZUz8uLo8nSA2HNEOX4ZSt2h7aTvNQvPSdgkfSNJmyJXVvE5aNQcDnUs1LtiCXuNJTxyeEitwmz8SPXcxplg+1P1b8EFW7Lzk57+PZDaXWYIgaQmuzkbUe81K3Sxue9lBJbOGZMaJHf7TURbisbhxTLLfjTyggWqSvE0dxILbY9FoG/fmqpu0y241tbsxf2rKf9oy27hsGVZe5aj9Dy1uArVu+KTN4Obr+iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INCmYhoNeUBJsiDpVwFelqyrVW1UR4U8Oo2xB9ehXBA=;
 b=Sss6s/Jp/YypgOJE6qq0+r4O88jMaufZqDMTUxNgjgRb6tbAW+63Q1muzbVXMrTmzoXw0AIvsRxKnqDtd3OnEw94o3Gqwmm2FJ5k4aOKJLnoUmI8BKEmij0tNeyzIZdZ3MuabUm4lT8O8wQuPXhdBKJTaXIjpZtymB3cNEp6a3brp8i9Wfop24DukPqVhbjqzTMpLUAkeLdvVs1bNkn57QgHmotQQQxn1ai49qynS3ZteLy/JL+1Ch/QACKjef57qmBKh5eZXY57zKa3mwOuXJjjNvaHxRMU7PztG+s7Vbhq+W07ifaMNu7fy9hx253noD1kWCPepfB3ylNNnTpT7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 PH0PR01MB7428.prod.exchangelabs.com (2603:10b6:510:db::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.30; Mon, 27 May 2024 15:26:56 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 15:26:56 +0000
Message-ID: <bcfeb77e-e986-4be8-87a0-65051bf98c29@talpey.com>
Date: Mon, 27 May 2024 11:26:55 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: smb: common: add missing MODULE_DESCRIPTION() macros
To: Steve French <smfrench@gmail.com>,
 Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
References: <20240526-md-fs-smb-common-v1-1-564a0036abe9@quicinc.com>
 <CAH2r5msb7G8Gh6mMXiMpS3ykC73WdTwRo9Zj662JaxU5Xq2H0A@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msb7G8Gh6mMXiMpS3ykC73WdTwRo9Zj662JaxU5Xq2H0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0218.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::13) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|PH0PR01MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f34262b-a677-4185-8f41-08dc7e6171a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmxRSml3SzU2RExxeW45K2x1WHNiVU1xZnNuMGduS0M4ZnpWUXc0NkZnNmhz?=
 =?utf-8?B?YVhUaFFid292eHJtcmRRMFBRWFBrMTVFN0NHT0g0a0cxcmxjRzJ1b0dXU3V0?=
 =?utf-8?B?dnN1Z1VncnhtdzFtb2IwYTNPdTVzeXZzbFoxOHdLb253bUJ3NjZaWVE2Z2RO?=
 =?utf-8?B?Y1VJWGE3OU9leWRTUittS2poZTN5ekVsVnFkOG1jM2xRUkVVQkFkSzBWZUU1?=
 =?utf-8?B?S3Q1MTdsdWNta2ljUlV0VHllWU0wT1AwM2FaSWlQYWRoeWY0Q0p1VUVNejVD?=
 =?utf-8?B?cHc0bCtjbjdvNGtYei9EZTJud1VacFZpYkRPVnNMOWVSb1N3dWNIQXhQTmpR?=
 =?utf-8?B?MVEwQjZwekhYOXg0TmZzMTMra2g5WW1PdGsyK2kwNlRGcDVmRm1wWlVRempH?=
 =?utf-8?B?c2c5L0loWEtTNXZCZFpSeDEyc1BISXNPUk1pQ3BEN1VzN2dvUmlXaHFneFNL?=
 =?utf-8?B?MEtEL3E1MEs4eHoybVl1RXRja1ZrcEJSeE4yR0hlamVIVVd6eEwrejk2WjBt?=
 =?utf-8?B?ZmFLdVJ3L2VPQXVxai9pK3FORllOUmVLYVFHdzVNK1F1WDU1RXRPTHNMN1ov?=
 =?utf-8?B?K1Z0YWRweUk5OE5va1A2cmdyY1lmQjg4TVBmOHkweG5RTXVnanJ5bHl4UWFH?=
 =?utf-8?B?N0VjMTVYMjZTWHNBeDB1QjFpeHdaQWdLQWY0NnZmN2RUb2lPSFNaTHR2VVhr?=
 =?utf-8?B?dWNLMHFvTW9VZmwzT0YyNHhwWHVUTHBXWkZVYkppR3lrOFJ3MmJZbnFkTVA0?=
 =?utf-8?B?azBnRmM3WE80L1ZZSUYyRHI2WUlSUVZ2aGQzSjkxa3NRWGd0b2U5OU1hNERs?=
 =?utf-8?B?dnJPZ1A1djNtdEg2NndYbUhaMjNjNzFuWituR2l3TVZhMTFaZ2NZSWZ6UW1a?=
 =?utf-8?B?QTlqYk5jMkR6SUp5VytYenBackJYN2kwN1lnVDNGSDdwMFlFM0M1eFRjSmhM?=
 =?utf-8?B?NDBORWU0L0tud2RBOEtJMkVSYTNnRzFCNjU1aGtzc0lFcWpINlVjV0V2N2ww?=
 =?utf-8?B?T25kTy9nM2pVWXN3QmYxanBqSzdYMHRFamFLNjAvWXprR2FrZUVVNjVCNE5H?=
 =?utf-8?B?UWlLamN1Q2I5bXVCRHAzZDgxYkI1UzA4VHZaMFZmemJ0bElmUW5tMDQvUkRW?=
 =?utf-8?B?MkFiRzZiYjJQNUxIaTZ5Q0VtT2l4TitPOXlGUXFVOU5WNmVTRVBreHU4aVN4?=
 =?utf-8?B?YmdzNVFpNkpLQVNGSlQ4cDZNNnZzNTFROUk0TUV1UUl6RTRQSGFuQ1VYL0da?=
 =?utf-8?B?emdBVVpZSnBUd2YvR3A4UDJ2dlBBb3poZU9tL0JockZWK3oyd3NlaDZTWUFP?=
 =?utf-8?B?eWh6RlZCSTk5eGFwcFRvb2RNa3VlTTkzUWZkM3lTTWRaU1A2dWpyb0xKaGJj?=
 =?utf-8?B?YVptQ21ZdWlram9GdmgwRy9ua2dSbVFTVmFHb2wwT3N0UXJxeUhrZWx6KzBM?=
 =?utf-8?B?K2tDZ2NUM0xwZTdRcWNjZmtFT1BURHRxaWpnL0FQYmhWeTZhWGdGa04vMFA1?=
 =?utf-8?B?TzZJZnVQVzBFZFhuWEs0aEFEUDVkUGJTSldJYkJJdVA1cXJJMVg2Wmt4emU3?=
 =?utf-8?B?YkRzcEJ6eEVUVUVvRFg2eGptUmtuNmdWNW1Od0g4SmpjRHZzMFJNUFYxNTZw?=
 =?utf-8?B?N1VFdjhJQmI3SHdJQWM1ZWxFYjBDQmcvbEZuUmx0OFNCQ3FVSGZJL2FCWVA1?=
 =?utf-8?B?RGt0YXdwVkdySFJUUVp2UUlKOTNFcVJSM01NMWZhYmNRSlliZjUzZ1ZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXRuQnJBQ3NsY1BlTTNERzRhSUNaL2dyRW9CMTRiTnFmajFzQlVzWEVnT1Zv?=
 =?utf-8?B?MGRJVVkxRzdWSDg0SmZ2b1dRMm5YSDZ2bDVSQ1phTGJtbVhKRnh3c2d1SHd5?=
 =?utf-8?B?QXRraGxrdVpTVGJhT2k2bTFyZHNmOEhHTUVreTdBNFBWOGMwU0h1MzN0VGgz?=
 =?utf-8?B?YlIzZHRNdCtnV1VYdkJnRENEN3AzY08za2RNMXFqbVFHQWtJYWNkenQ0b1VG?=
 =?utf-8?B?Tlp6VkJ5UmJvdWZyem5qZlBjcnFxWXN6U1MwRllFU0p5SzJ0YjFSNlBoODU2?=
 =?utf-8?B?dWk0bWZlbmd6MXRTdUJXdFB0VGtIQWo4cUxMQnNOUGNja0E4TzhCdnV1cENN?=
 =?utf-8?B?Uy95cm9WcVpBdXhqTGhGdHNtUlZ2ZEh1bWZGUllLbVduR2tMeVhUelZkZXVM?=
 =?utf-8?B?cVJaZ3lCNjBkcldndjdlSEV5UGZUQTFJU3AvR0ZuYjE5eWZkY0RqTlpKVDFK?=
 =?utf-8?B?V3hrSkcvc2N4b0tPSnM4N21UMnFTTzVIR1AwZGZNbzdiSHE1eVdHRkxuM0N3?=
 =?utf-8?B?aGI5UnFZa0pSYVFTYWxTRytvRGx1QzkyUlpNY0phYTZOZkxhOGg3MnBtcGxS?=
 =?utf-8?B?TEZLL1dCVDF6bmppMEc0WlJDZlRsWk5iQ1o3TFB2eXlPRi9lOEhwZ29Dc0pU?=
 =?utf-8?B?SDh5dzk3dHhxZkZidUN5alVkRkdxZmlOU2ZQcWJrQTlwTGwzc25IM2oyZ1pJ?=
 =?utf-8?B?L1ZKcUJXcmNSSUoyWDhnaTQ2ZC91VTRsV1JRc0FUcjdsdm9FN0ZwczhocU1o?=
 =?utf-8?B?dUFRbDFIbXloTUNhVm1QNHBMdy9qamFSc2R0R0ZxNGN4RFB4OEpqVjhIY3l4?=
 =?utf-8?B?eTNKOXdoSEQwd2JtN3BneFJBRnFhR2FpWEwxNDFDSXNJeW50eVB3cTNwcTZz?=
 =?utf-8?B?b3pLUkcrd3htOHlzeWR0c3ZuVUppMlBLVHBiRHZtQk5WV2E5ZmhONWhOQjhj?=
 =?utf-8?B?Vk9uaWtjYWZ1OHQ0M214TTdTWXhOVUR6WDJwcjFFd3ZkUDNSdHE2dTJKb0Fu?=
 =?utf-8?B?MUpKWFVWRWRrMVorckRpOFJiQnJHRXowWE5QcGRRNkY4a2NjenpuVytaUXBD?=
 =?utf-8?B?N2xWeVJCbDB4WEpVVVorLzN5YkJUQzJRQzFVaUVqTVBkYnNjWWlYQmRBeEFN?=
 =?utf-8?B?NjBWLytPSkxMak5TbGg4azZqTGJQQTVKZmhMUTgwUlVER1kvMlJEN05uZGJH?=
 =?utf-8?B?Z1gyWHBHNVhROWJUVkYrWjZUV0FDcFNvWC9YRDllcW4waEwvc0paRERaZWtn?=
 =?utf-8?B?RUhvWnBodWdpRHZQSU5mQmU0UUV5dEFoSkhoNHUvN00wNmZIdEp1d0FpRnB4?=
 =?utf-8?B?UTZYbWxDS0xiVEczaE15RjRDMWtORXIzb00xbTFqZmNGR3FlUUd6dHFCRGEx?=
 =?utf-8?B?RTM0Z0NjYnQ1cDRDTGlucCsweVJBZlEvRGo2NXF1SUtCVFJzMjdiTzRYSURy?=
 =?utf-8?B?VjdSTm1USXpnS3ZqSjdsc3BtZTAwTXQzc0RQTHlKbTgvc2MvbEdJKzdVRTVH?=
 =?utf-8?B?K0FySWJSai96TllVQmR1RG1xTHYyellodit4T0hsb3hackYrZUVKY1lFa1VZ?=
 =?utf-8?B?RmlvVDVpKyt3ZUkycmFZRG1MZ1dyR1krcUdXWCtpVkl1L0JjdlgxV3l4ZTZG?=
 =?utf-8?B?Wm00T3ZRK05uQWd5cFY3ZTNQRnc5NmswZk4xUUZLc2RlWlp4NCtWeFVFUHpX?=
 =?utf-8?B?VzRNT2JHblI5RURxejlPM2hjSWpsbXJRUERxb3EvYXgyYjFVaC9YMzdFZXA4?=
 =?utf-8?B?Y1BMY1FCaE03ZzBJMkpPYllwcVk5NnBWcCs1TGVnVk92TXBzTHEvYUFsbmtX?=
 =?utf-8?B?YzhSd2dCejV0Q2lhMDVBOThWSk5QeHEzVmJqZjVNbE5NbC9lakFhTXdHbVFj?=
 =?utf-8?B?WTUveTRYRDNYcHZQUWplM0VZY1hkRHgzdkdmaGh0amJQdVNUazRVQlFWbzJ4?=
 =?utf-8?B?aVRDdCt1T0RhaGV2ekw4b1FqZnRoZWJUSUwzS0VzSjFnYjk1NVlDOWFrTitD?=
 =?utf-8?B?TUYvMlFDWWxtUlZ4enpoZEIxRHV5eHQ2MGtWMDUwR05XR1BkQXhrbXVqMnV4?=
 =?utf-8?B?OUErcTdiUWZqU2o0TmRNNlJmb0ZSOEJzdFdBQTIzNzA2UTB1R0R5eExwN1VZ?=
 =?utf-8?Q?ZgYhOBL00KcyFf580NEtQVRgq?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f34262b-a677-4185-8f41-08dc7e6171a3
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:26:56.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SXxwP/FJXvGEfWMEHm5UzuzgLRdhCwyLUBIU5Us+mUISd9OMW/ShsbpXtPLlVJYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7428

On 5/26/2024 3:44 PM, Steve French wrote:
> merged into cifs-2.6.git for-next
> 
> On Sun, May 26, 2024 at 11:53 AM Jeff Johnson <quic_jjohnson@quicinc.com> wrote:
>>
>> Fix the 'make W=1' warnings:
>> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_arc4.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in fs/smb/common/cifs_md4.o
>>
>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Would it be worth adding the word "DEPRECATED" (or some such)?
These are present only for SMB1 down-compat, and we don't want
people to think they're generally useful.

Tom.

>> ---
>>   fs/smb/common/cifs_arc4.c | 1 +
>>   fs/smb/common/cifs_md4.c  | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/fs/smb/common/cifs_arc4.c b/fs/smb/common/cifs_arc4.c
>> index 043e4cb839fa..df360ca47826 100644
>> --- a/fs/smb/common/cifs_arc4.c
>> +++ b/fs/smb/common/cifs_arc4.c
>> @@ -10,6 +10,7 @@
>>   #include <linux/module.h>
>>   #include "arc4.h"
>>
>> +MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
>>   MODULE_LICENSE("GPL");
>>
>>   int cifs_arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
>> diff --git a/fs/smb/common/cifs_md4.c b/fs/smb/common/cifs_md4.c
>> index 50f78cfc6ce9..7ee7f4dad90c 100644
>> --- a/fs/smb/common/cifs_md4.c
>> +++ b/fs/smb/common/cifs_md4.c
>> @@ -24,6 +24,7 @@
>>   #include <asm/byteorder.h>
>>   #include "md4.h"
>>
>> +MODULE_DESCRIPTION("MD4 Message Digest Algorithm (RFC1320)");
>>   MODULE_LICENSE("GPL");
>>
>>   static inline u32 lshift(u32 x, unsigned int s)
>>
>> ---
>> base-commit: 416ff45264d50a983c3c0b99f0da6ee59f9acd68
>> change-id: 20240526-md-fs-smb-common-e92031f7d8cf
>>
>>
> 
> 
